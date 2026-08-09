import { label, t } from "../i18n";
import type { SelectedEntity } from "../state";
import type { Atlas, Locale } from "../types";

interface Props {
  atlas: Atlas;
  locale: Locale;
  onSelect: (entity: SelectedEntity) => void;
}

/**
 * A compact learning layer above the virtualized excerpt list.  It keeps the
 * score tab task-oriented: start with a bounded study unit, then jump to the
 * exact composition or fragment instead of scanning 56 independent rows.
 */
export function MusicStudyPanel({ atlas, locale, onSelect }: Props) {
  return <section className="music-study-panel" aria-labelledby="music-study-title">
    <header>
      <p className="eyebrow">{t("musicStudy", locale)}</p>
      <h2 id="music-study-title">{t("learningPath", locale)}</h2>
      <p>{locale === "zh-CN" ? "每个单元都把年代、作品、乐谱与来源放在同一个可核验的学习动作里。" : "Each unit joins chronology, works, notation, and sources in one bounded, verifiable learning action."}</p>
    </header>
    <div className="learning-grid">
      {atlas.musicLearningUnits.map((unit) => {
        const composition = atlas.compositions.find((item) => item.slug === unit.compositionSlugs[0]);
        const fragment = atlas.scoreFragments.find((item) => item.slug === unit.scoreFragmentSlugs[0]);
        return <article className="learning-card" key={unit.slug}>
          <div className="identity-tags"><span>{label(unit.unitKind, locale)}</span><span>{label(unit.difficulty, locale)}</span><span>{unit.targetMinutes}′</span></div>
          <h3>{unit.title}</h3>
          <p>{unit.summary}</p>
          <small>{unit.objective}</small>
          <div className="drawer-actions">
            {composition && <button type="button" onClick={() => onSelect({ type: "composition", workSlug: atlas.work.slug, id: composition.slug })}>{t("studyOpenComposition", locale)}</button>}
            {fragment && <button type="button" onClick={() => onSelect({ type: "score_fragment", workSlug: atlas.work.slug, id: fragment.slug })}>{t("studyOpenFragment", locale)}</button>}
          </div>
        </article>;
      })}
    </div>
    <details className="music-catalog">
      <summary>{t("catalog", locale)} · {atlas.instruments.length} {t("instruments", locale)} · {atlas.musicInstitutions.length} {t("musicInstitutions", locale)}</summary>
      <div className="catalog-columns">
        <section><h3>{t("instruments", locale)}</h3><div className="catalog-links">{atlas.instruments.map((instrument) => <button type="button" key={instrument.slug} onClick={() => onSelect({ type: "instrument", workSlug: atlas.work.slug, id: instrument.slug })}>{instrument.name}</button>)}</div></section>
        <section><h3>{t("musicInstitutions", locale)}</h3><div className="catalog-links">{atlas.musicInstitutions.map((institution) => <button type="button" key={institution.slug} onClick={() => onSelect({ type: "music_institution", workSlug: atlas.work.slug, id: institution.slug })}>{institution.name}</button>)}</div></section>
      </div>
    </details>
  </section>;
}
