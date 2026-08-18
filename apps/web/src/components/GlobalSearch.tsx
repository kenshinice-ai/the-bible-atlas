import { useEffect, useId, useRef, useState } from "react";
import { STATIC_DATA, search } from "../api";
import { t, type UIKey } from "../i18n";
import { PROFILE } from "../profile";
import { SINGLE_WORK, type SelectedEntity } from "../state";
import type { Atlas, Locale, SearchResponse } from "../types";

const KIND_KEY: Record<SearchResponse["items"][number]["kind"], UIKey> = {
  work: "kindWork", character: "kindCharacter", event: "kindEvent", location: "kindLocation", artist: "kindArtist", artwork: "kindArtwork", movement: "kindMovement", institution: "kindInstitution",
  composition: "kindComposition", music_style: "kindMusicStyle", instrument: "kindInstrument", music_institution: "kindMusicInstitution", score_fragment: "kindScoreFragment",
  creature: "kindCreature", passage: "kindPassage", textual_place: "kindTextualPlace",
};

interface Props {
  locale: Locale;
  activeWork: string;
  atlases: Atlas[];
  onSelectEntity: (entity: SelectedEntity) => void;
  onSelectWork: (slug: string) => void;
}

/**
 * The static build has no /api/search, but it holds the whole atlas in memory —
 * a substring scan over a few hundred rows mirrors the server's ILIKE exactly.
 */
function searchAtlases(atlases: Atlas[], query: string): SearchResponse["items"] {
  const needle = query.toLocaleLowerCase();
  const hit = (...haystack: (string | null | undefined)[]) => haystack.some((value) => value?.toLocaleLowerCase().includes(needle));
  const items: SearchResponse["items"] = [];
  for (const atlas of atlases) {
    const workSlug = atlas.work.slug;
    for (const person of atlas.characters) if (hit(person.name, person.summary, ...person.aliases)) items.push({ kind: "character", slug: person.slug, label: person.name, context: person.summary, workSlug });
    for (const event of atlas.events) if (hit(event.title, event.summary, event.detail)) items.push({ kind: "event", slug: event.slug, label: event.title, context: event.summary, workSlug });
    for (const place of atlas.locations) if (hit(place.name, place.summary, ...place.aliases)) items.push({ kind: "location", slug: place.slug, label: place.name, context: place.summary, workSlug });
    // In the art-history profile artists are canonical people, so their
    // character row is the single searchable identity. Keep specialist artist
    // results for any future profile that does not opt into that mapping.
    if (!PROFILE.canonicalArtistPeople) for (const artist of atlas.artists) if (hit(artist.name, artist.fullName, artist.summary, artist.modernStatus, ...artist.aliases, ...artist.periodTitles, ...artist.formalTitles)) items.push({ kind: "artist", slug: artist.slug, label: artist.fullName || artist.name, context: artist.summary, workSlug });
    for (const artwork of atlas.artworks) if (hit(artwork.title, artwork.summary, artwork.medium)) items.push({ kind: "artwork", slug: artwork.slug, label: artwork.title, context: artwork.summary, workSlug });
    for (const movement of atlas.movements) if (hit(movement.name, movement.summary)) items.push({ kind: "movement", slug: movement.slug, label: movement.name, context: movement.summary, workSlug });
    for (const institution of atlas.institutions) if (hit(institution.name, institution.summary)) items.push({ kind: "institution", slug: institution.slug, label: institution.name, context: institution.summary, workSlug });
    for (const composition of atlas.compositions) if (hit(composition.title, composition.summary, composition.description, composition.genre, composition.form)) items.push({ kind: "composition", slug: composition.slug, label: composition.title, context: composition.summary, workSlug });
    for (const style of atlas.musicStyles) if (hit(style.name, style.summary, style.styleKind)) items.push({ kind: "music_style", slug: style.slug, label: style.name, context: style.summary, workSlug });
    for (const instrument of atlas.instruments) if (hit(instrument.name, instrument.summary, instrument.family, instrument.hornbostelSachsCode, ...instrument.aliases)) items.push({ kind: "instrument", slug: instrument.slug, label: instrument.name, context: instrument.summary, workSlug });
    for (const institution of atlas.musicInstitutions) if (hit(institution.name, institution.summary, institution.institutionType)) items.push({ kind: "music_institution", slug: institution.slug, label: institution.name, context: institution.summary, workSlug });
    for (const fragment of atlas.scoreFragments) if (hit(fragment.title, fragment.summary, fragment.analysisNote)) items.push({ kind: "score_fragment", slug: fragment.slug, label: fragment.title, context: fragment.summary, workSlug });
    if (atlas.shanhaijing) {
      for (const creature of atlas.shanhaijing.creatures) if (hit(creature.name, creature.summary, creature.detail, ...creature.aliases)) items.push({ kind: "creature", slug: creature.slug, label: creature.name, context: creature.summary, workSlug });
      for (const passage of atlas.shanhaijing.passages) if (hit(passage.title, passage.summary, passage.textZh, passage.referenceKey)) items.push({ kind: "passage", slug: passage.slug, label: passage.title, context: passage.summary, workSlug });
      for (const place of atlas.shanhaijing.places) if (hit(place.name, place.summary, ...place.aliases)) items.push({ kind: "textual_place", slug: place.slug, label: place.name, context: place.summary, workSlug });
    }
  }
  return items.slice(0, 200);
}

/**
 * Cross-work search over the bilingual index.
 *
 * `/api/search` shipped in v3.1 but nothing ever called it, so the only way to
 * reach an entity was to scroll a list. With 136 events and 79 people that is no
 * longer viable, and it stops being viable at all beyond a few hundred.
 */
export function GlobalSearch({ locale, activeWork, atlases, onSelectEntity, onSelectWork }: Props) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<SearchResponse["items"]>([]);
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);
  const [activeIndex, setActiveIndex] = useState(-1);
  const boxRef = useRef<HTMLDivElement | null>(null);
  const listId = useId();

  useEffect(() => {
    const trimmed = query.trim();
    if (trimmed.length < 1) { setResults([]); setActiveIndex(-1); setPending(false); return; }
    if (STATIC_DATA) {
      const timer = window.setTimeout(() => { setResults(searchAtlases(atlases, trimmed)); setActiveIndex(-1); setOpen(true); setPending(false); }, 160);
      setPending(true);
      return () => window.clearTimeout(timer);
    }
    const controller = new AbortController();
    setPending(true);
    const timer = window.setTimeout(() => {
      search(trimmed, locale, controller.signal)
        // Single-work build: whole-work results have nothing to switch to.
        .then((response) => { setResults(SINGLE_WORK ? response.items.filter((item) => item.kind !== "work") : response.items); setActiveIndex(-1); setOpen(true); })
        .catch(() => setResults([]))
        .finally(() => setPending(false));
    }, 220);
    return () => { window.clearTimeout(timer); controller.abort(); };
  }, [atlases, locale, query]);

  useEffect(() => {
    if (!open) return;
    const dismiss = (event: PointerEvent) => { if (event.target instanceof Node && !boxRef.current?.contains(event.target)) setOpen(false); };
    const escape = (event: KeyboardEvent) => { if (event.key === "Escape") setOpen(false); };
    document.addEventListener("pointerdown", dismiss);
    document.addEventListener("keydown", escape);
    return () => { document.removeEventListener("pointerdown", dismiss); document.removeEventListener("keydown", escape); };
  }, [open]);

  function choose(item: SearchResponse["items"][number]) {
    setOpen(false);
    if (item.workSlug !== activeWork) onSelectWork(item.workSlug);
    if (item.kind === "work") return;
    onSelectEntity({ type: item.kind, workSlug: item.workSlug, id: item.slug });
  }

  function handleKeyDown(event: React.KeyboardEvent<HTMLInputElement>) {
    if (event.key === "ArrowDown") {
      event.preventDefault();
      setOpen(true);
      setActiveIndex((current) => results.length === 0 ? -1 : Math.min(current + 1, results.length - 1));
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      setActiveIndex((current) => results.length === 0 ? -1 : Math.max(current - 1, 0));
    } else if (event.key === "Enter" && open && activeIndex >= 0) {
      event.preventDefault();
      choose(results[activeIndex]!);
    } else if (event.key === "Escape") {
      setOpen(false);
      setActiveIndex(-1);
    }
  }

  return <div className="global-search" ref={boxRef}>
    <input
      type="search"
      value={query}
      role="combobox"
      aria-expanded={open}
      aria-controls={listId}
      aria-autocomplete="list"
      aria-busy={pending}
      aria-activedescendant={activeIndex >= 0 ? `${listId}-option-${activeIndex}` : undefined}
      aria-label={t("searchEverything", locale)}
      placeholder={t("searchEverything", locale)}
      onChange={(event) => setQuery(event.target.value)}
      onKeyDown={handleKeyDown}
      onFocus={() => { if (results.length > 0) setOpen(true); }}
    />
    {pending && <span className="search-spinner" role="status" aria-label={locale === "zh-CN" ? "正在搜索" : "Searching"} />}
    {open && <ul className="search-results" id={listId} role="listbox">
      {results.length === 0
        ? <li className="empty" role="status">{t("noResults", locale)}</li>
        : results.map((item, index) => <li key={`${item.kind}:${item.workSlug}:${item.slug}`}>
          <button id={`${listId}-option-${index}`} type="button" role="option" tabIndex={-1} aria-selected={activeIndex === index} onMouseEnter={() => setActiveIndex(index)} onClick={() => choose(item)}>
            <span className={`kind-chip ${item.kind}`}>{t(KIND_KEY[item.kind], locale)}</span>
            <strong>{item.label}</strong>
            {item.context && <small>{item.context}</small>}
          </button>
        </li>)}
    </ul>}
  </div>;
}
