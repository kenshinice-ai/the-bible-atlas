# 圣经全量种子共享规范(011–022)

你要为《世界文学名著时空地图》项目生成一个圣经时代的 SQL 种子文件。

- 项目目录:`/Users/llmacbookpro/Library/Mobile Documents/com~apple~CloudDocs/世界文学名著时空地图`
- 种子目录:`<项目目录>/db/seeds/`
- 数据库(只读参考 + 测试):`postgresql://llmacbookpro@localhost:5432/literary_atlas`
- **模板:先完整阅读 `db/seeds/010_bible_full_01_primeval.sql`,严格模仿其结构、SQL 写法与文风。**
- 圣经 work_id:`10000000-0000-4000-8000-000000000005`

## 文件结构(与 010 一致,按节)

`BEGIN;` … 1.CHARACTERS → 2.LOCATIONS → 3.EVENTS → 4.已有事件重排(UPDATE sequence)→ 5.EVENT TRANSLATIONS → 6.EVENT-LOCATIONS → 7.EVENT-CHARACTERS → 8.EVENT-SOURCES → 9.CHARACTER RELATIONS → 10.GROUP MEMBERSHIP … `COMMIT;`

## ID 与编号约定(KK = 你的时代两位编号,如 02)

- 人物 id:`43000000-0000-4000-80KK-` + 12 位序号;地点:`33…`;事件:`63…`;关系:`73…`(与 010 相同)
- 事件 sequence 区间:`K*1000+1` 到 `K*1000+999`。把「已有事件(见下)+ 新事件」整体按叙事顺序排好,以步长 2 从 `K*1000+1` 开始编号;已有事件用 UPDATE(照抄 010 第 4 节写法),新事件在 INSERT 中直接给值。
- characters.sort_order:`K*100` 起递增;locations.sort_order:`K*100` 起递增(两表独立,不冲突)。

## 冲突免疫(与 010 的差异,必须遵守)

以下表的 INSERT 一律加 `ON CONFLICT DO NOTHING`:characters、character_translations、locations、location_translations、character_relations、character_group_members、event_characters、event_locations、event_sources。
events 和 event_translations **不加**(事件 slug 撞车说明重复造了已有事件,必须改掉)。

## 实体复用规则(重要)

**禁止重新创建已存在实体**;通过 slug JOIN 引用(照抄 010 的 JOIN 写法)。

已有人物(79 个):abraham, sarah, isaac, jacob, moses, aaron, david, solomon, jonah, mary, jesus, peter, paul, noah, lot, hagar, ishmael, rebekah, esau, rachel, leah, joseph-son-of-jacob, judah-son-of-jacob, benjamin, miriam, jethro, pharaoh-of-the-exodus, joshua, caleb, rahab, deborah, barak, gideon, samson, delilah, ruth, boaz, samuel, saul, jonathan, goliath, abigail, bathsheba, absalom, nathan, joab, rehoboam, jeroboam, elijah, elisha, ahab, jezebel, hezekiah, isaiah, jeremiah, ezekiel, daniel, nebuchadnezzar, cyrus, esther, mordecai, nehemiah, joseph-of-nazareth, john-the-baptist, mary-magdalene, martha, lazarus, judas-iscariot, pontius-pilate, herod-the-great, john-son-of-zebedee, andrew, stephen, barnabas, silas, timothy, lydia, cornelius, luke
(另:primeval 时代文件将新增 adam, eve, cain, abel, seth, enoch, methuselah, lamech-father-of-noah, shem, ham, japheth, nimrod)

已有地点(57 个):ur, harran, canaan-shechem, nile-delta, mount-sinai-traditional, jerusalem, bethlehem, nazareth, sea-of-galilee, damascus, nineveh, rome, ararat-mountains, babylon, hebron, beersheba, sodom-region, bethel, peniel-jabbok, goshen, reed-sea-crossing, kadesh-barnea, mount-nebo, jericho, shiloh, gaza, valley-of-elah, ramah, mount-gilboa, megiddo, samaria-sebaste, mount-carmel, lachish, susa, joppa, tarshish-reference, capernaum, cana, bethsaida, jordan-river-bethany, mount-of-olives, golgotha-traditional, bethany-near-jerusalem, sychar-jacobs-well, mount-tabor, emmaus-reference, caesarea-maritima, antioch-orontes, tarsus, cyprus-salamis, philippi, thessalonica, athens, corinth, ephesus, malta, patmos

新地点:确有必要才建,给出真实经纬度 `ST_GeogFromText('POINT(经度 纬度)')`、合理的 location_type / coordinate_accuracy / preferred_zoom / modern_country_code / is_inferred / still_exists,layer 一律 'real',canvas_x/canvas_y 为 NULL,双语翻译齐全。

**跨时代人物归属**:每个人物只由「归属时代」创建(见你的任务提示中的负责名单)。你可以在 event_characters / relations 中引用:①已有 79 人;②你自己新建的人物;③编号比你小的时代负责创建的人物(装载顺序在你之前)。**绝不引用编号比你大的时代的人物**(JOIN 会静默丢行)。

已有分组(只能往里加成员,不建新组):abrahamic-household, house-of-jacob, exodus-leadership, conquest-generation, judges-circle, house-of-saul, house-of-david, northern-court, prophetic-circle, exile-court, persian-court, nazareth-household, galilean-disciples, roman-authorities, bethany-household, pauline-circle, primeval-figures, judahite-court, opposing-powers

已有 sources(event_sources 按 title JOIN,照抄 010 第 8 节):Genesis, Exodus, Numbers, Deuteronomy, Joshua, Judges, Ruth, Samuel, Kings, Chronicles, Ezra, Nehemiah, Esther, Isaiah, Jeremiah, Ezekiel, Daniel, Hosea, Amos, Jonah, Gospel according to Matthew / Mark / Luke / John, Acts of the Apostles, Letter to the Romans, Letters to the Corinthians, Revelation。若一个时代的事件来自多本书,按事件分别 JOIN 对应 source(可分多条 INSERT…SELECT,按 slug 列表分组)。

## 时间标注规范(本次扩充的重点)

- 除 primeval 外,所有事件 `time_type='range'`,`calendar_system='unknown'`(个别有儒略历精度的新约事件可用 'julian'),`historical_start_year/end_year` 给**宽年代区间**(BCE 为负数,无 0 年)。
- 每个事件的区间必须落在时代区间内(见任务提示),并随叙事顺序大体单调推进;单个事件区间宽度:族长时代 100–200 年,王国时代 30–80 年,新约 2–10 年。
- reality/confidence 惯例(与库内 006 一致):
  - 一般叙事:`reported_historical` + `low`(王国以后核心事件可 `medium`)
  - 神迹/异象/显现:`legendary_or_mythic` + `low`
  - 学术争议大的(如过红海、以斯帖、但以理宫廷故事):`contested` + `low`
  - 有域外史料印证的(撒玛利亚陷落、西拿基立围城、耶路撒冷陷落、古列敕令等):`verified_historical` + `high`
- event_translations.time_label 必填:中文 `约公元前 2100–1900 年` / 英文 `c. 2100–1900 BCE`;公元后 `约公元 48–52 年` / `c. 48–52 CE`。

## 枚举值(只能用这些)

- event_type: birth,death,meeting,journey,battle,trial,imprisonment,escape,marriage,betrayal,discovery,political,social,religious,migration,other
- event_reality: verified_historical,reported_historical,fictional_narrative,fictional_with_historical_context,legendary_or_mythic,symbolic_or_dream,contested
- time_type: exact,approximate,range,relative,fictional_calendar,unknown;confidence: high,medium,low
- gender: male,female,unknown,na;age_stage: child,youth,adult,elder,unknown
- role_type: protagonist,antagonist,supporting,narrator,historical,collective,supernatural
- reality_type(人物): historical,fictional,fictionalised_historical,unknown(默认 unknown;有域外印证的君王用 historical)
- icon_variant(自由文本,沿用现有):person,prophet,patriarch,matriarch,soldier,king,queen,ruler,disciple,missionary,judge,priest,lawgiver,teacher
- relation_type(沿用现有):family,spouse,sibling,ally,adversary,mentor,romantic,other;direction: bidirectional,source_to_target,target_to_source;sentiment: positive,negative,mixed,neutral;status: active,ended,changed,unknown;strength 1–5;importance 1–5
- location_type: country,region,city,district,street,building,landmark,prison,station,port,battlefield,residence,school,religious_site,fictional_place,route_node;coordinate_accuracy: exact,approximate,city_centroid,inferred,fictional
- locale: zh-CN, en;translations.status 一律 'published'

## 内容要求

- 全部双语(zh-CN + en)。人物:name/summary/detail/motivation;事件:title/summary/detail/significance/time_label;地点:name/summary + historical_region_name(其余文本列可空字符串)。
- 文风与 010 一致:中文简洁的叙事描述;英文对应;英文散文里的所有格撇号用弯引号 `’`(避免 SQL 转义);若用直引号必须写成 `''`。
- 内容基于圣经文本本身(创世记式的中性叙述口吻,"经文记载/叙事描述",不做信仰断言)。
- 每个新事件必须有:双语翻译、≥1 个 event_location(role 'primary',position 0)、≥1 个 event_character(第一个 role 'primary'/is_primary,其余 'participant',照抄 010 写法)、≥1 个 event_source。

## 自测(写完必须做,直到零错误)

```bash
SCRATCH=/private/tmp/claude-501/-Users-llmacbookpro-Library-Mobile-Documents-com-apple-CloudDocs-----------/d5c70932-63f8-4b88-b768-d78874952d17/scratchpad
cd "<项目目录>/db/seeds"
sed 's/^COMMIT;$/ROLLBACK;/' 0NN_你的文件.sql > "$SCRATCH/test_NN.sql"
psql "postgresql://llmacbookpro@localhost:5432/literary_atlas" -v ON_ERROR_STOP=1 -f "$SCRATCH/test_NN.sql"
```

进一步把 `ROLLBACK;` 前插入孤儿检查(把 KK 换成你的编号),四条查询都必须返回 0 行,否则说明 JOIN 静默丢行(slug 拼错):

```sql
SELECT e.slug FROM events e WHERE e.id::text LIKE '63000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_translations t WHERE t.event_id=e.id AND t.locale='en');
SELECT e.slug FROM events e WHERE e.id::text LIKE '63000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_locations x WHERE x.event_id=e.id);
SELECT e.slug FROM events e WHERE e.id::text LIKE '63000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_characters x WHERE x.event_id=e.id);
SELECT e.slug FROM events e WHERE e.id::text LIKE '63000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_sources x WHERE x.event_id=e.id);
SELECT c.slug FROM characters c WHERE c.id::text LIKE '43000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM character_translations t WHERE t.character_id=c.id AND t.locale='zh-CN');
```

注意:测试时你引用的「编号更小时代」的新人物尚未入库,相关 event_characters 行会被静默丢弃——这类 slug 属于预期缺失,忽略即可(在孤儿检查里,如果某事件只有这类人物,给它再加一个已有人物作 participant 以保证非空)。

## 各时代既有事件(必须在第 4 节重排进你的 sequence 区间,禁止重复创建)

- 02 patriarchs(19):abraham-leaves-ur, abram-at-shechem, lot-settles-near-sodom, hagar-and-ishmael-in-the-wilderness, birth-of-isaac, destruction-of-the-sodom-cities, binding-of-isaac, sarah-buried-at-hebron, rebekah-brought-from-harran, jacob-takes-the-blessing, jacobs-dream-at-bethel, jacob-marries-leah-and-rachel, jacob-named-israel, jacob-and-esau-reconcile, joseph-sold-into-egypt, joseph-rises-in-egypt, brothers-reunite-in-egypt, household-settles-in-goshen, rachel-buried-near-bethlehem
- 03 exodus-and-sinai(10):birth-of-moses-in-goshen, moses-flees-to-midian, call-at-the-burning-bush, confrontation-with-pharaoh, exodus-from-egypt, crossing-of-the-sea, song-at-the-sea, sinai-covenant, golden-calf-episode, jethro-advises-a-court-system
- 04 wilderness-and-conquest(8):scouts-sent-from-kadesh, long-stay-at-kadesh, death-of-aaron, moses-views-canaan-from-nebo, scouts-sheltered-by-rahab, crossing-the-jordan, fall-of-jericho, shrine-set-up-at-shiloh
- 05 judges(9):deborah-and-barak-muster-at-tabor, battle-near-megiddo, gideon-reduces-his-force, samson-among-the-philistine-cities, samson-and-delilah, samson-at-gaza, naomi-and-ruth-reach-bethlehem, ruth-and-boaz-at-the-threshing-floor, samuel-serves-at-shiloh
- 06 united-monarchy(15):samuel-anoints-saul, saul-rejected-at-ramah, samuel-anoints-david-at-bethlehem, david-and-goliath-in-the-valley-of-elah, jonathan-and-david-make-a-covenant, david-a-fugitive-in-the-south, abigail-intercedes, saul-and-jonathan-die-on-gilboa, david-becomes-king, jerusalem-royal-capital, bathsheba-and-nathans-rebuke, absaloms-revolt, death-of-absalom, solomon-succeeds-david, first-temple-built
- 07 divided-kingdoms(10):rehoboam-refuses-relief, kingdom-divides, jeroboam-establishes-northern-shrines, ahab-and-jezebel-marry, contest-on-mount-carmel, elijah-withdraws-to-horeb, elijah-passes-the-mantle, naboths-vineyard, death-of-jezebel, fall-of-samaria
- 08 prophetic-narrative(5):jonah-sails-from-joppa, jonah-heads-for-tarshish, jonah-to-nineveh, jonah-outside-nineveh, isaiah-called-in-the-temple
- 09 judah-and-exile(13):isaiah-counsels-hezekiah, assyrian-siege-of-lachish, sennacherib-besieges-jerusalem, hezekiahs-water-tunnel, jeremiah-called, first-deportation-to-babylon, daniel-in-the-babylonian-court, ezekiels-vision-by-the-canal, jerusalem-falls, temple-destroyed, jeremiah-taken-to-egypt, belshazzars-feast, daniel-in-the-lions-den
- 10 return-and-restoration(7):cyrus-permits-return, first-returnees-reach-jerusalem, second-temple-rebuilt, esther-becomes-queen-at-susa, mordecai-refuses-to-bow, esther-intervenes-at-court, nehemiah-rebuilds-the-wall
- 11 gospels(18):annunciation-at-nazareth, birth-of-jesus, flight-to-egypt, return-to-nazareth, baptism-at-the-jordan, first-sign-at-cana, calling-of-the-first-disciples, galilean-ministry, conversation-at-jacobs-well, transfiguration-on-tabor, raising-of-lazarus, entry-into-jerusalem, last-supper, arrest-on-the-mount-of-olives, trial-before-pilate, crucifixion-in-jerusalem, empty-tomb, road-to-emmaus
- 12 acts(6):pentecost-in-jerusalem, stephen-is-killed, peters-vision-at-joppa, peter-and-cornelius-at-caesarea, paul-conversion-damascus, barnabas-brings-paul-to-antioch
- 13 pauline-mission(13):first-journey-begins-at-cyprus, jerusalem-council, crossing-into-macedonia, lydia-hosts-at-philippi, paul-and-silas-detained-at-philippi, debate-at-athens, long-stay-at-corinth, years-at-ephesus, arrest-in-jerusalem, hearing-at-caesarea, shipwreck-at-malta, paul-arrives-rome, patmos-vision
  (注意:patmos-vision 年代 81–96,重排时放在区间末尾即可)

## 章节 JOIN

事件 INSERT 里 `JOIN chapters ch ON ch.slug='<你的时代slug>' AND ch.work_id='10000000-0000-4000-8000-000000000005'`(照抄 010)。

## 完成标准

1. 文件写入 `db/seeds/`,命名 `0NN_bible_full_KK_<slug>.sql`
2. 自测零错误、孤儿检查零行(除注明的预期缺失)
3. 最终答复只需报告:新增人物数/地点数/事件数/关系数、测试结果、预期缺失的跨时代引用列表

### 关系(character_relations)必须同时写 relation_translations

API 只返回带已发布 label 翻译的关系(`relation_translations.status='published'`),漏写翻译的关系在界面上不可见。每条关系都要配 zh-CN 与 en 两行:

```sql
INSERT INTO relation_translations(relation_id, locale, label, summary, status)
SELECT r.id, v.locale::locale_code, v.label, v.summary, 'published'
FROM character_relations r JOIN (VALUES
  ('from-slug','to-slug','family','zh-CN','父子','一句摘要'),
  ('from-slug','to-slug','family','en','Father and son','One-line summary')
) AS v(fslug,tslug,rtype,locale,label,summary)
  ON r.relation_type=v.rtype
 JOIN characters fc ON fc.id=r.from_character_id AND fc.slug=v.fslug
 JOIN characters tc ON tc.id=r.to_character_id AND tc.slug=v.tslug
WHERE r.work_id='10000000-0000-4000-8000-000000000005';
```

(历史缺口已由 `024_relation_translation_backfill.sql` 按 relation_type 回填基线标签;新种子不要依赖回填,直接写具体标签。)
