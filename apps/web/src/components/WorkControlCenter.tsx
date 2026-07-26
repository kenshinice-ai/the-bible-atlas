import { useEffect, useMemo, useRef, useState } from "react";
import { label, t } from "../i18n";
import { MAX_SELECTED_WORKS, type SelectionMode } from "../state";
import type { Locale, WorkSummary } from "../types";

interface Props {
  works: WorkSummary[];
  selected: string[];
  active: string;
  mode: SelectionMode;
  locale: Locale;
  error: string | null;
  onMode: (mode: SelectionMode) => void;
  onToggle: (slug: string) => void;
  onActive: (slug: string) => void;
}

/** Searchable, keyboard-native work picker with explicit primary-work control. */
export function WorkControlCenter({ works, selected, active, mode, locale, error, onMode, onToggle, onActive }: Props) {
  const [query, setQuery] = useState("");
  const [category, setCategory] = useState("all");
  const [open, setOpen] = useState(false);
  const pickerRef = useRef<HTMLDetailsElement>(null);

  useEffect(() => {
    if (!open) return;
    const dismissOutside = (event: PointerEvent) => { if (event.target instanceof Node && !pickerRef.current?.contains(event.target)) setOpen(false); };
    const dismissWithKeyboard = (event: KeyboardEvent) => { if (event.key === "Escape") setOpen(false); };
    document.addEventListener("pointerdown", dismissOutside);
    document.addEventListener("keydown", dismissWithKeyboard);
    return () => { document.removeEventListener("pointerdown", dismissOutside); document.removeEventListener("keydown", dismissWithKeyboard); };
  }, [open]);

  const filtered = useMemo(() => works.filter((work) => {
    const haystack = [work.title, work.alternateTitle, work.authorName, work.originRegion, work.publicationYear, work.category, work.mapLayer].join(" ").toLocaleLowerCase();
    return (!query || haystack.includes(query.toLocaleLowerCase())) && (category === "all" || work.category === category);
  }), [category, query, works]);

  return <details ref={pickerRef} className="picker" open={open} onToggle={(event) => setOpen(event.currentTarget.open)}>
    <summary>{t("workPicker", locale)} · {selected.length}/{mode === "multi" ? MAX_SELECTED_WORKS : 1}</summary>
    <div className="picker-panel">
      <div className="mode">
        <button type="button" className={mode === "single" ? "active" : ""} aria-pressed={mode === "single"} onClick={() => onMode("single")}>{t("single", locale)}</button>
        <button type="button" className={mode === "multi" ? "active" : ""} aria-pressed={mode === "multi"} onClick={() => onMode("multi")}>{t("multi", locale)} ≤ {MAX_SELECTED_WORKS}</button>
      </div>
      <div className="selected-chips">
        {selected.map((slug) => {
          const work = works.find((item) => item.slug === slug);
          if (!work) return null;
          return <span key={slug} className={slug === active ? "active" : ""} style={{ borderColor: work.themeColor }}>
            <button type="button" onClick={() => onActive(slug)} aria-label={`${t("primary", locale)}: ${work.title}`}>{work.title}</button>
            <button type="button" onClick={() => onToggle(slug)} aria-label={`${t("clear", locale)}: ${work.title}`}>×</button>
          </span>;
        })}
      </div>
      <div className="picker-filters">
        <input value={query} onChange={(event) => setQuery(event.target.value)} placeholder={t("searchWorks", locale)} aria-label={t("searchWorks", locale)} />
        <select value={category} onChange={(event) => setCategory(event.target.value)} aria-label={t("allCategories", locale)}>
          <option value="all">{t("allCategories", locale)}</option>
          {[...new Set(works.map((work) => work.category))].map((value) => <option key={value} value={value}>{label(value, locale)}</option>)}
        </select>
      </div>
      <div className="work-list">
        {filtered.map((work) => {
          const checked = selected.includes(work.slug);
          const disabled = mode === "multi" && !checked && selected.length >= MAX_SELECTED_WORKS;
          return <label key={work.slug} className={disabled ? "disabled" : ""}>
            <input type={mode === "single" ? "radio" : "checkbox"} name="work" checked={checked} disabled={disabled} onChange={() => onToggle(work.slug)} />
            <i style={{ background: work.themeColor }} />
            <span>
              <strong>{work.title}</strong>
              <small>{work.alternateTitle} · {work.authorName}</small>
              <small>{label(work.category, locale)} · {work.originRegion} · {work.characterCount} / {work.eventCount} / {work.locationCount} {t("characters", locale)} / {t("events", locale)} / {t("locations", locale)}</small>
            </span>
            {checked && <button type="button" className={active === work.slug ? "primary active" : "primary"} onClick={(event) => { event.preventDefault(); onActive(work.slug); }}>{t("primary", locale)}</button>}
          </label>;
        })}
      </div>
      {mode === "multi" && selected.length >= MAX_SELECTED_WORKS && <p className="selection-error">{t("limitReached", locale)}</p>}
      {error && <p className="selection-error" role="status">{error}</p>}
    </div>
  </details>;
}
