import { useMemo, useState } from "react";
import { RelationGraph } from "./RelationGraph";
import type { SelectedEntity, ZoomLevel } from "../state";
import type { Atlas, Locale } from "../types";

type Lens = "all" | "affection" | "care" | "power" | "conflict";
const LENS_TYPES: Record<Lens, readonly string[]> = {
  all: [], affection: ["romantic", "rivalry"], care: ["care", "family"], power: ["authority", "alliance"], conflict: ["conflict", "rivalry"],
};

interface Props {
  atlas: Atlas;
  locale: Locale;
  chapter: string | null;
  selected: SelectedEntity | null;
  zoomLevel: ZoomLevel;
  onChapter: (chapter: string | null) => void;
  onZoomLevel: (level: ZoomLevel) => void;
  onSelect: (entity: SelectedEntity) => void;
}

export function RedChamberPrototype({ atlas, locale, chapter, selected, zoomLevel, onChapter, onZoomLevel, onSelect }: Props) {
  const [lens, setLens] = useState<Lens>("all");
  const focusSlug = selected?.type === "character" ? selected.id : "jia-baoyu";
  const relations = useMemo(() => {
    const chapterEvents = chapter ? new Set(atlas.events.filter((event) => event.chapterSlug === chapter).map((event) => event.slug)) : null;
    return atlas.relations.filter((relation) => {
      if (lens !== "all" && !LENS_TYPES[lens].includes(relation.relationType)) return false;
      if (!chapterEvents) return true;
      return (relation.startEventSlug && chapterEvents.has(relation.startEventSlug)) ||
        (relation.endEventSlug && chapterEvents.has(relation.endEventSlug)) ||
        relation.startEventSlug === null;
    });
  }, [atlas, chapter, lens]);
  const neighbours = new Set([focusSlug]);
  for (const relation of relations) {
    if (relation.fromSlug === focusSlug) neighbours.add(relation.toSlug);
    if (relation.toSlug === focusSlug) neighbours.add(relation.fromSlug);
  }
  const characters = atlas.characters.filter((person) => neighbours.has(person.slug));
  const focused = atlas.characters.find((person) => person.slug === focusSlug) ?? atlas.characters[0]!;
  const focusedRelations = relations.filter((relation) => relation.fromSlug === focusSlug || relation.toSlug === focusSlug);
  const lang = locale === "zh-CN" ? 0 : 1;
  const lenses: readonly [Lens, readonly [string, string]][] = [
    ["all", ["全部关系", "All relations"]], ["affection", ["情与亲近", "Affection"]], ["care", ["照护与依赖", "Care"]], ["power", ["权力与礼法", "Power"]], ["conflict", ["冲突与竞争", "Conflict"]],
  ];
  return <section className="red-chamber-prototype">
    <aside className="red-person-rail" aria-label={locale === "zh-CN" ? "原型人物" : "Prototype people"}>
      <p className="red-kicker">{locale === "zh-CN" ? "第一期 · 八人原型" : "Phase one · eight-person prototype"}</p>
      {atlas.characters.map((person) => <button
        type="button" key={person.slug} className={person.slug === focusSlug ? "active" : ""}
        onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: person.slug })}
      >
        <span className="red-avatar" aria-hidden="true">{person.name.slice(0, 1)}</span>
        <span><strong>{person.name}</strong><small>{person.summary}</small></span>
      </button>)}
    </aside>

    <div className="red-network-stage">
      <header className="red-stage-header">
        <div><p className="red-kicker">{locale === "zh-CN" ? "人物焦点图" : "Character focus graph"}</p><h2>{focused.name}</h2><p>{focused.summary}</p></div>
        <div className="red-portrait-placeholder" aria-label={locale === "zh-CN" ? `${focused.name}原创虚构肖像待生成` : `Original fictional portrait for ${focused.name} pending`}>
          <span>{focused.name.slice(0, 1)}</span><small>{locale === "zh-CN" ? "虚构肖像待生成" : "portrait pending"}</small>
        </div>
      </header>
      <div className="red-lenses" role="group" aria-label={locale === "zh-CN" ? "关系镜片" : "Relationship lens"}>
        {lenses.map(([key, label]) => <button type="button" key={key} className={lens === key ? "active" : ""} aria-pressed={lens === key} onClick={() => setLens(key)}>{label[lang]}</button>)}
      </div>
      <RelationGraph atlas={atlas} locale={locale} characters={characters} relations={focusedRelations} zoomLevel={zoomLevel}
        selected={{ type: "character", workSlug: atlas.work.slug, id: focusSlug }} onZoomLevel={onZoomLevel} onSelect={onSelect} onChapter={onChapter} />
    </div>

    <aside className="red-reading-panel">
      <p className="red-kicker">{locale === "zh-CN" ? "关系显微镜" : "Relationship lens"}</p>
      <h2>{focused.name}</h2>
      <p>{locale === "zh-CN" ? `当前显示 ${focusedRelations.length} 条直接关系。选择人物或关系可打开详细抽屉。` : `${focusedRelations.length} direct relationships are visible. Select a person or relation for detail.`}</p>
      <div className="red-relation-list">
        {focusedRelations.map((relation) => {
          const otherSlug = relation.fromSlug === focusSlug ? relation.toSlug : relation.fromSlug;
          const other = atlas.characters.find((person) => person.slug === otherSlug);
          return <button type="button" key={relation.id} onClick={() => onSelect({ type: "relationship", workSlug: atlas.work.slug, id: relation.id })}>
            <strong>{other?.name}</strong><span>{relation.label}</span><small>{relation.summary}</small>
          </button>;
        })}
      </div>
    </aside>

    <nav className="red-chapter-rail" aria-label={locale === "zh-CN" ? "章回阶段" : "Chapter stages"}>
      <button type="button" className={chapter === null ? "active" : ""} onClick={() => onChapter(null)}>{locale === "zh-CN" ? "全部阶段" : "All stages"}</button>
      {atlas.chapters.map((item) => <button type="button" key={item.slug} className={chapter === item.slug ? "active" : ""} onClick={() => onChapter(chapter === item.slug ? null : item.slug)}>
        <i style={{ background: item.accentColor }} /><strong>{item.title}</strong><small>{item.referenceLabel}</small>
      </button>)}
    </nav>
  </section>;
}
