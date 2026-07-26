import { useEffect, useId, useRef, useState } from "react";
import { search } from "../api";
import { t, type UIKey } from "../i18n";
import { BIBLE_ONLY, type SelectedEntity } from "../state";
import type { Locale, SearchResponse } from "../types";

const KIND_KEY: Record<SearchResponse["items"][number]["kind"], UIKey> = {
  work: "kindWork", character: "kindCharacter", event: "kindEvent", location: "kindLocation",
};

interface Props {
  locale: Locale;
  activeWork: string;
  onSelectEntity: (entity: SelectedEntity) => void;
  onSelectWork: (slug: string) => void;
}

/**
 * Cross-work search over the bilingual index.
 *
 * `/api/search` shipped in v3.1 but nothing ever called it, so the only way to
 * reach an entity was to scroll a list. With 136 events and 79 people that is no
 * longer viable, and it stops being viable at all beyond a few hundred.
 */
export function GlobalSearch({ locale, activeWork, onSelectEntity, onSelectWork }: Props) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<SearchResponse["items"]>([]);
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);
  const boxRef = useRef<HTMLDivElement | null>(null);
  const listId = useId();

  useEffect(() => {
    const trimmed = query.trim();
    if (trimmed.length < 2) { setResults([]); setPending(false); return; }
    const controller = new AbortController();
    setPending(true);
    const timer = window.setTimeout(() => {
      search(trimmed, locale, controller.signal)
        // Bible-only: whole-work results have nothing to switch to, so hide them.
        .then((response) => { setResults(BIBLE_ONLY ? response.items.filter((item) => item.kind !== "work") : response.items); setOpen(true); })
        .catch(() => setResults([]))
        .finally(() => setPending(false));
    }, 220);
    return () => { window.clearTimeout(timer); controller.abort(); };
  }, [locale, query]);

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

  return <div className="global-search" ref={boxRef}>
    <input
      type="search"
      value={query}
      role="combobox"
      aria-expanded={open}
      aria-controls={listId}
      aria-label={t("searchEverything", locale)}
      placeholder={t("searchEverything", locale)}
      onChange={(event) => setQuery(event.target.value)}
      onFocus={() => { if (results.length > 0) setOpen(true); }}
    />
    {pending && <span className="search-spinner" aria-hidden="true" />}
    {open && <ul className="search-results" id={listId} role="listbox">
      {results.length === 0
        ? <li className="empty">{t("noResults", locale)}</li>
        : results.map((item) => <li key={`${item.kind}:${item.workSlug}:${item.slug}`}>
          <button type="button" role="option" aria-selected={false} onClick={() => choose(item)}>
            <span className={`kind-chip ${item.kind}`}>{t(KIND_KEY[item.kind], locale)}</span>
            <strong>{item.label}</strong>
            {item.context && <small>{item.context}</small>}
          </button>
        </li>)}
    </ul>}
  </div>;
}
