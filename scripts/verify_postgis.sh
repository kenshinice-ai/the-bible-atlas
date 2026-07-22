#!/usr/bin/env bash
set -euo pipefail

ATLAS_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ATLAS_TEMP=$(mktemp -d /private/tmp/literary-atlas-postgis.XXXXXX)
ATLAS_DB_PORT=$((55000 + RANDOM % 5000))
ATLAS_API_PORT=$((45000 + RANDOM % 5000))
ATLAS_API_PID=""

cleanup() {
  ATLAS_STATUS=$?
  if [[ "$ATLAS_STATUS" -ne 0 && -f "$ATLAS_TEMP/api.log" ]]; then
    echo "API log from failed verification:" >&2
    sed -n '1,120p' "$ATLAS_TEMP/api.log" >&2
  fi
  if [[ -n "$ATLAS_API_PID" ]]; then kill "$ATLAS_API_PID" >/dev/null 2>&1 || true; fi
  pg_ctl -D "$ATLAS_TEMP/data" -m fast stop >/dev/null 2>&1 || true
  rm -rf "$ATLAS_TEMP"
  return "$ATLAS_STATUS"
}
trap cleanup EXIT

for command in initdb pg_ctl psql createdb curl node npm; do
  command -v "$command" >/dev/null || { echo "Missing required command: $command" >&2; exit 1; }
done
test -f "$(pg_config --sharedir)/extension/postgis.control" || { echo "PostGIS extension is not installed for $(pg_config --version)" >&2; exit 1; }

initdb -D "$ATLAS_TEMP/data" -A trust --no-locale >/dev/null
pg_ctl -D "$ATLAS_TEMP/data" -o "-F -p $ATLAS_DB_PORT -c listen_addresses=127.0.0.1" -w start >/dev/null

# Reproduce the v3.0 -> v3.1 upgrade path with a pre-existing fictional row.
# This catches migration ordering bugs that a fresh install cannot expose.
createdb -h 127.0.0.1 -p "$ATLAS_DB_PORT" atlas_upgrade
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d atlas_upgrade -f "$ATLAS_ROOT/db/migrations/001_initial.sql" >/dev/null
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d atlas_upgrade <<'SQL' >/dev/null
INSERT INTO works(id,slug,author_name,publication_year,content_mode,map_layer,default_locale,launch_rank,mode_reason)
VALUES ('90000000-0000-4000-8000-000000000001','the-hobbit','J. R. R. Tolkien',1937,'literary_narrative','fictional','en',1,'upgrade fixture');
INSERT INTO locations(id,work_id,slug,layer,canvas_x,canvas_y)
VALUES ('90000000-0000-4000-8000-000000000002','90000000-0000-4000-8000-000000000001','bag-end','fictional',50,50);
SQL
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d atlas_upgrade -f "$ATLAS_ROOT/db/migrations/002_v3_1_complex_atlas.sql" >/dev/null
test "$(psql -At -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d atlas_upgrade -c "SELECT coordinate_accuracy FROM locations WHERE slug='bag-end'")" = "fictional"

psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d postgres -f "$ATLAS_ROOT/db/migrations/001_initial.sql" >/dev/null
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d postgres -f "$ATLAS_ROOT/db/migrations/002_v3_1_complex_atlas.sql" >/dev/null
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d postgres -f "$ATLAS_ROOT/db/seeds/001_four_works.sql" >/dev/null
psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d postgres -f "$ATLAS_ROOT/db/seeds/002_bible_v3_1.sql" >/dev/null

psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d postgres <<'SQL' >/dev/null
DO $$
BEGIN
  IF (SELECT count(*) FROM works) <> 5 THEN RAISE EXCEPTION 'expected five works'; END IF;
  IF EXISTS (SELECT 1 FROM works w LEFT JOIN work_translations z ON z.work_id=w.id AND z.locale='zh-CN' AND z.status='published' LEFT JOIN work_translations e ON e.work_id=w.id AND e.locale='en' AND e.status='published' WHERE z.work_id IS NULL OR e.work_id IS NULL) THEN RAISE EXCEPTION 'missing published work translation'; END IF;
  IF EXISTS (SELECT 1 FROM locations l JOIN works w ON w.id=l.work_id WHERE w.slug='the-hobbit' AND (l.geom IS NOT NULL OR l.canvas_x IS NULL OR l.canvas_y IS NULL)) THEN RAISE EXCEPTION 'Hobbit location violates fictional canvas'; END IF;
  IF EXISTS (SELECT 1 FROM locations l JOIN works w ON w.id=l.work_id WHERE w.slug<>'the-hobbit' AND (l.geom IS NULL OR l.canvas_x IS NOT NULL OR l.canvas_y IS NOT NULL)) THEN RAISE EXCEPTION 'real work location violates PostGIS layer'; END IF;
  IF EXISTS (SELECT 1 FROM events e JOIN works w ON w.id=e.work_id LEFT JOIN event_locations el ON el.event_id=e.id LEFT JOIN event_sources es ON es.event_id=e.id WHERE w.slug='a-tale-of-two-cities' GROUP BY e.id HAVING count(DISTINCT el.location_id)=0 OR count(DISTINCT es.source_id)=0) THEN RAISE EXCEPTION 'Tale event is missing location or source'; END IF;
  IF EXISTS (SELECT 1 FROM characters c JOIN works w ON w.id=c.work_id LEFT JOIN event_characters ec ON ec.character_id=c.id WHERE w.slug='a-tale-of-two-cities' GROUP BY c.id HAVING count(ec.event_id)=0) THEN RAISE EXCEPTION 'Tale character is not connected to an event'; END IF;
  IF (SELECT count(*) FROM characters c JOIN works w ON w.id=c.work_id WHERE w.slug='the-bible') < 10 THEN RAISE EXCEPTION 'Bible needs at least ten people'; END IF;
  IF (SELECT count(*) FROM events e JOIN works w ON w.id=e.work_id WHERE w.slug='the-bible') < 12 THEN RAISE EXCEPTION 'Bible needs at least twelve events'; END IF;
  IF (SELECT count(*) FROM character_relations r JOIN works w ON w.id=r.work_id WHERE w.slug='the-bible') < 15 THEN RAISE EXCEPTION 'Bible needs at least fifteen relationships'; END IF;
  IF EXISTS (SELECT 1 FROM events e JOIN works w ON w.id=e.work_id LEFT JOIN event_locations el ON el.event_id=e.id LEFT JOIN event_characters ec ON ec.event_id=e.id LEFT JOIN event_sources es ON es.event_id=e.id WHERE w.slug='the-bible' GROUP BY e.id HAVING count(DISTINCT el.location_id)=0 OR count(DISTINCT ec.character_id)=0 OR count(DISTINCT es.source_id)=0) THEN RAISE EXCEPTION 'Bible event closure failed'; END IF;
  IF EXISTS (SELECT 1 FROM events e JOIN works w ON w.id=e.work_id WHERE w.slug='the-bible' AND (e.time_type IN ('approximate','range') AND e.start_date IS NOT NULL)) THEN RAISE EXCEPTION 'uncertain Bible time was stored as exact SQL date'; END IF;
  IF EXISTS (SELECT 1 FROM locations l JOIN works w ON w.id=l.work_id WHERE w.slug='the-bible' AND (l.layer<>'real' OR l.geom IS NULL OR l.coordinate_accuracy='fictional')) THEN RAISE EXCEPTION 'Bible geography layer failed'; END IF;
END $$;
SQL

if psql -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d postgres -c "INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y) VALUES ('99999999-0000-0000-0000-000000000001','10000000-0000-4000-8000-000000000004','invalid-real-point','fictional',ST_GeogFromText('POINT(0 0)'),50,50);" >/dev/null 2>&1; then
  echo "Expected the fictional-coordinate constraint to reject a real point" >&2
  exit 1
fi

npm run build -w @literary-atlas/api >/dev/null
DATABASE_URL="postgresql://127.0.0.1:$ATLAS_DB_PORT/postgres" API_PORT="$ATLAS_API_PORT" npm run start -w @literary-atlas/api >"$ATLAS_TEMP/api.log" 2>&1 &
ATLAS_API_PID=$!
for _ in {1..40}; do
  if curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/health" >"$ATLAS_TEMP/health.json" 2>/dev/null; then break; fi
  sleep 0.25
done
curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/health" >"$ATLAS_TEMP/health.json"
echo "API smoke: locales"
curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/api/locales" >"$ATLAS_TEMP/locales.json"
echo "API smoke: works"
curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/api/works?locale=zh-CN" >"$ATLAS_TEMP/works.json"
echo "API smoke: Tale atlas"
ATLAS_HTTP_STATUS=$(curl -sS -o "$ATLAS_TEMP/atlas.json" -w '%{http_code}' "http://127.0.0.1:$ATLAS_API_PORT/api/works/a-tale-of-two-cities/atlas?locale=zh-CN")
if [[ "$ATLAS_HTTP_STATUS" != "200" ]]; then
  echo "Atlas endpoint returned HTTP $ATLAS_HTTP_STATUS" >&2
  sed -n '1,80p' "$ATLAS_TEMP/atlas.json" >&2
  exit 1
fi
echo "API smoke: Bible atlas"
curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/api/works/the-bible/atlas?locale=zh-CN" >"$ATLAS_TEMP/bible.json"
echo "API smoke: Chinese search"
curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/api/search?locale=zh-CN&q=%E5%B7%B4%E9%BB%8E" >"$ATLAS_TEMP/search-zh.json"
echo "API smoke: English search"
curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/api/search?locale=en&q=Paris" >"$ATLAS_TEMP/search-en.json"

node - "$ATLAS_TEMP" <<'NODE'
const fs=require('node:fs');
const dir=process.argv[2];
const read=(name)=>JSON.parse(fs.readFileSync(`${dir}/${name}.json`,'utf8'));
const assert=(condition,message)=>{if(!condition)throw new Error(message)};
const health=read('health');
const locales=read('locales');
const works=read('works');
const atlas=read('atlas');
const bible=read('bible');
assert(health.status==='ok'&&health.version==='3.1.0','health contract failed');
assert(JSON.stringify(locales.locales)===JSON.stringify(['zh-CN','en']),'locale contract failed');
assert(works.items.length===5&&works.items.every((item)=>item.translationStatus==='published'&&item.resolvedLocale==='zh-CN'&&item.fallbackUsed===false),'work locale metadata failed');
assert(atlas.characters.length===8&&atlas.events.length===6&&atlas.locations.length===6&&atlas.routes.length===1,'Tale atlas counts failed');
assert(atlas.characters.every((item)=>item.eventSlugs.length>0&&item.translationStatus==='published'),'character closure or locale metadata failed');
assert(atlas.events.every((item)=>item.locationSlugs.length>0&&item.sourceTitles.length>0&&item.translationStatus==='published'),'event location/source closure failed');
assert(atlas.events.find((item)=>item.slug==='bastille-falls')?.startDate==='1789-07-14','historical date must remain an exact calendar date');
assert(atlas.locations.every((item)=>item.layer==='real'&&Number.isFinite(item.lat)&&Number.isFinite(item.lng)),'PostGIS coordinates failed');
assert(atlas.relations.length>=3&&atlas.relations.every((item)=>item.translationStatus==='published'),'relation contract failed');
assert(bible.characters.length===13&&bible.events.length===14&&bible.locations.length===12&&bible.routes.length===3&&bible.relations.length===15,'Bible atlas counts failed');
assert(bible.events.every((item)=>item.locationSlugs.length>0&&item.sourceTitles.length>0),'Bible event closure failed');
assert(read('search-zh').items.some((item)=>item.label.includes('巴黎')),'Chinese search failed');
assert(read('search-en').items.some((item)=>item.label.includes('Paris')),'English search failed');
NODE

test "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$ATLAS_API_PORT/api/works?locale=fr")" = "400"
test "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$ATLAS_API_PORT/api/works/unknown/atlas?locale=en")" = "404"

psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$ATLAS_DB_PORT" -d postgres -c "UPDATE location_translations SET status='draft' WHERE locale='zh-CN' AND location_id=(SELECT id FROM locations WHERE slug='paris' AND work_id='10000000-0000-4000-8000-000000000001');" >/dev/null
curl -fsS "http://127.0.0.1:$ATLAS_API_PORT/api/works/a-tale-of-two-cities/atlas?locale=zh-CN" >"$ATLAS_TEMP/fallback.json"
node - "$ATLAS_TEMP/fallback.json" <<'NODE'
const fs=require('node:fs');
const atlas=JSON.parse(fs.readFileSync(process.argv[2],'utf8'));
const paris=atlas.locations.find((item)=>item.slug==='paris');
if(!paris||paris.resolvedLocale!=='en'||paris.fallbackUsed!==true||paris.translationStatus!=='published')throw new Error('explicit entity fallback contract failed');
NODE

echo "PostGIS v3.0 upgrade, v3.1 migration, five-work seed, Bible closure, fallback, bilingual search and API smoke: PASS"
