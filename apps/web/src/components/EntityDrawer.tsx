import { useEffect, useRef, useState } from "react";
import { getEntityDetail } from "../api";
import { colorForCharacter } from "../hierarchy";
import { formatEventTime, formatYear, label, t } from "../i18n";
import type { SelectedEntity, SelectionSource, Tab } from "../state";
import type { Atlas, AtlasCharacter, AtlasMedia, Locale } from "../types";

interface Props {
  atlas: Atlas;
  entity: SelectedEntity;
  locale: Locale;
  onClose: () => void;
  onSelect: (entity: SelectedEntity, source: SelectionSource) => void;
  onTab: (tab: Tab) => void;
  onChapter: (chapter: string | null) => void;
}

/**
 * The atlas index deliberately ships without long prose so it stays small at any
 * entity count; the drawer is where that prose is fetched, one entity at a time.
 */
function useEntityDetail(workSlug: string, kind: string, id: string, locale: Locale): Record<string, string> {
  const [fields, setFields] = useState<Record<string, string>>({});
  useEffect(() => {
    const controller = new AbortController();
    setFields({});
    getEntityDetail(workSlug, kind, id, locale, controller.signal)
      .then((detail) => setFields(detail.fields))
      .catch(() => { /* the index already carries everything needed to render */ });
    return () => controller.abort();
  }, [id, kind, locale, workSlug]);
  return fields;
}

function PersonAvatar({ person, color }: { person: AtlasCharacter; color: string }) {
  return <span className={`person-avatar ${person.gender} ${person.ageStage}`} style={{ background: color }} aria-hidden="true">
    <svg viewBox="0 0 48 48">
      <circle cx="24" cy={person.ageStage === "child" ? 17 : 15} r={person.ageStage === "child" ? 8 : 10} />
      <path d={person.gender === "female" ? "M8 43c2-13 8-19 16-19s14 6 16 19z" : "M9 43c1-12 6-18 15-18s14 6 15 18z"} />
    </svg>
  </span>;
}

function Sources({ names, locale }: { names: string[]; locale: Locale }) {
  if (names.length === 0) return null;
  return <section><h3>{t("sources", locale)}</h3>{names.map((name) => <p key={name} className="source-name">{name}</p>)}</section>;
}

function ArtworkMediaCard({ media, locale }: { media: AtlasMedia; locale: Locale }) {
  const [failed, setFailed] = useState(false);
  const sourceUrl = media.sourcePageUrl ?? media.originalUrl ?? (media.assetUrl.startsWith("http") ? media.assetUrl : null);
  if (media.mediaKind === "external_link") {
    return <div className="artwork-media artwork-media-external">
      <p>{t("externalImageNote", locale)}</p>
      {sourceUrl && <a className="link" href={sourceUrl} target="_blank" rel="noreferrer">{t("viewSource", locale)} ↗</a>}
      <small>{media.assetSource} · {media.assetLicence}</small>
    </div>;
  }
  if (failed) {
    return <div className="artwork-media artwork-media-unavailable">
      <p>{t("imageUnavailable", locale)}</p>
      {sourceUrl && <a className="link" href={sourceUrl} target="_blank" rel="noreferrer">{t("viewSource", locale)} ↗</a>}
    </div>;
  }
  return <figure className="artwork-media">
    <img src={media.assetUrl} alt={media.altText} loading="lazy" decoding="async" onError={() => setFailed(true)} />
    <figcaption><span><strong>{t("imageAttribution", locale)}:</strong> {media.attributionText}</span>{sourceUrl && <a href={sourceUrl} target="_blank" rel="noreferrer">{t("viewSource", locale)} ↗</a>}{media.licenseUrl && <a href={media.licenseUrl} target="_blank" rel="noreferrer">{media.assetLicence}</a>}</figcaption>
  </figure>;
}

function ArtworkMedia({ media, locale }: { media: AtlasMedia[]; locale: Locale }) {
  if (media.length === 0) return null;
  return <section><h3>{t("artworkImage", locale)}</h3><div className="artwork-media-stack">{media.map((item) => <ArtworkMediaCard key={item.id} media={item} locale={locale} />)}</div></section>;
}

function Shell({ children, onClose, locale }: { children: React.ReactNode; onClose: () => void; locale: Locale }) {
  const drawerRef = useRef<HTMLElement | null>(null);
  useEffect(() => {
    const previous = document.activeElement instanceof HTMLElement ? document.activeElement : null;
    const drawer = drawerRef.current;
    const close = drawer?.querySelector<HTMLButtonElement>(".close");
    close?.focus();
    const trap = (event: KeyboardEvent) => {
      if (event.key !== "Tab" || !drawer) return;
      const focusable = [...drawer.querySelectorAll<HTMLElement>("button,a,input,select,textarea,[tabindex]:not([tabindex='-1'])")].filter((element) => !element.hasAttribute("disabled"));
      if (focusable.length === 0) return;
      const first = focusable[0]!;
      const last = focusable.at(-1)!;
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
    };
    document.addEventListener("keydown", trap);
    return () => {
      document.removeEventListener("keydown", trap);
      if (previous?.isConnected) previous.focus();
    };
  }, []);
  return <aside ref={drawerRef} className="entity-drawer" role="dialog" aria-modal="true" aria-label={locale === "zh-CN" ? "条目详情" : "Entity detail"}>
    <button type="button" className="close" aria-label={t("close", locale)} onClick={onClose}>×</button>
    {children}
  </aside>;
}

/** Full-detail drawer for the shared selected entity. */
export function EntityDrawer({ atlas, entity, locale, onClose, onSelect, onTab, onChapter }: Props) {
  const detail = useEntityDetail(atlas.work.slug, entity.type === "relationship" ? "relationship" : entity.type, entity.id, locale);
  const chapterOf = (slug: string | null) => atlas.chapters.find((item) => item.slug === slug);

  if (entity.type === "character") {
    const person = atlas.characters.find((item) => item.slug === entity.id);
    if (!person) return null;
    const relations = atlas.relations.filter((item) => item.fromSlug === person.slug || item.toSlug === person.slug);
    const artist = person.artistSlug ? atlas.artists.find((item) => item.slug === person.artistSlug) : undefined;
    const groups = atlas.groups.filter((group) => person.groupSlugs.includes(group.slug));
    const era = chapterOf(person.chapterSlug);
    const birthPlace = atlas.locations.find((place) => place.slug === person.birthPlaceSlug);
    const deathPlace = atlas.locations.find((place) => place.slug === person.deathPlaceSlug);
    return <Shell onClose={onClose} locale={locale}>
      <header>
        <PersonAvatar person={person} color={colorForCharacter(atlas, person)} />
        <div>
          <small>{atlas.work.title}{era ? ` · ${era.title}` : ""}</small>
          <h2>{person.name}</h2>
          {person.aliases.length > 0 && <p className="aliases">{t("aliases", locale)}: {person.aliases.join(" · ")}</p>}
        </div>
      </header>
      <div className="identity-tags">
        <span>{label(person.iconVariant, locale)}</span>
        <span>{label(person.gender, locale)}</span>
        <span>{label(person.ageStage, locale)}</span>
        <span>{label(person.roleType, locale)}</span>
        <span>{label(person.realityType, locale)}</span>
        {artist && <span>{artist.modernStatus}</span>}
      </div>
      {artist && artist.formalTitles.length > 0 && <p className="aliases"><strong>{t("formalTitles", locale)}:</strong> {artist.formalTitles.join(" · ")}</p>}
      <p>{person.summary}</p>
      {(detail.detail || person.detail) && <p>{detail.detail || person.detail}</p>}
      {(detail.motivation || person.motivation) && <section><h3>{t("motivation", locale)}</h3><p>{detail.motivation || person.motivation}</p></section>}
      <dl>
        <dt>{t("lifeRange", locale)}</dt>
        <dd>{person.birthYear !== null ? formatYear(person.birthYear, locale) : "—"} — {person.deathYear !== null ? formatYear(person.deathYear, locale) : "—"}</dd>
        {birthPlace && <><dt>{t("birthPlace", locale)}</dt><dd><button className="link" onClick={() => onSelect({ type: "location", workSlug: atlas.work.slug, id: birthPlace.slug }, "list")}>{birthPlace.name}</button></dd></>}
        {deathPlace && <><dt>{t("deathPlace", locale)}</dt><dd><button className="link" onClick={() => onSelect({ type: "location", workSlug: atlas.work.slug, id: deathPlace.slug }, "list")}>{deathPlace.name}</button></dd></>}
        {era && <><dt>{t("era", locale)}</dt><dd><button className="link" onClick={() => onChapter(era.slug)}>{era.title}</button></dd></>}
        {groups.length > 0 && <><dt>{t("groups", locale)}</dt><dd>{groups.map((group) => group.name).join(" · ")}</dd></>}
        <dt>{t("relatedEvents", locale)}</dt><dd>{person.eventSlugs.length}</dd>
        <dt>{t("relatedPlaces", locale)}</dt><dd>{person.locationSlugs.length}</dd>
      </dl>
      <div className="drawer-actions">
        <button onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: person.slug }, "list")}>{t("locateOnMap", locale)}</button>
        <button onClick={() => onTab("relations")}>{t("openGraph", locale)}</button>
        <button onClick={() => onTab("events")}>{t("relatedEvents", locale)}</button>
        {artist && <button onClick={() => onTab("artworks")}>{t("artworks", locale)}</button>}
      </div>
      {person.eventSlugs.length > 0 && <section>
        <h3>{t("relatedEvents", locale)} · {person.eventSlugs.length}</h3>
        <div className="drawer-links">
          {person.eventSlugs.map((slug) => {
            const event = atlas.events.find((item) => item.slug === slug);
            return event ? <button key={slug} onClick={() => onSelect({ type: "event", workSlug: atlas.work.slug, id: slug }, "list")}>#{event.sequence} {event.title}</button> : null;
          })}
        </div>
      </section>}
      {relations.length > 0 && <section>
        <h3>{t("keyRelations", locale)}</h3>
        {relations.map((relation) => {
          const other = atlas.characters.find((item) => item.slug === (relation.fromSlug === person.slug ? relation.toSlug : relation.fromSlug));
          return <button className={`relation-row ${relation.sentiment}`} key={relation.id} onClick={() => onSelect({ type: "relationship", workSlug: atlas.work.slug, id: relation.id }, "list")}>
            <span>{relation.label}{other ? ` · ${other.name}` : ""}</span>
            <small>{relation.summary}</small>
          </button>;
        })}
      </section>}
      {artist && artist.artworkSlugs.length > 0 && <section>
        <h3>{t("artworks", locale)} · {artist.artworkSlugs.length}</h3>
        <div className="drawer-links">
          {artist.artworkSlugs.map((slug) => {
            const artwork = atlas.artworks.find((item) => item.slug === slug);
            return artwork ? <button key={slug} onClick={() => onSelect({ type: "artwork", workSlug: atlas.work.slug, id: slug }, "list")}>{artwork.title}</button> : null;
          })}
        </div>
      </section>}
      <Sources names={person.sourceTitles} locale={locale} />
    </Shell>;
  }

  if (entity.type === "event") {
    const event = atlas.events.find((item) => item.slug === entity.id);
    if (!event) return null;
    const era = chapterOf(event.chapterSlug);
    const parent = atlas.events.find((item) => item.slug === event.parentEventSlug);
    const children = atlas.events.filter((item) => item.parentEventSlug === event.slug);
    // Narrative neighbours, so a reader can walk the story without leaving the drawer.
    const ordered = [...atlas.events].sort((a, b) => a.sequence - b.sequence);
    const position = ordered.findIndex((item) => item.slug === event.slug);
    const previous = position > 0 ? ordered[position - 1] : undefined;
    const following = position >= 0 && position < ordered.length - 1 ? ordered[position + 1] : undefined;
    const routes = atlas.routes.filter((route) => event.routeSlugs.includes(route.slug));
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title}{era ? ` · ${era.title}` : ""} · {label(event.eventType, locale)}</small>
      <h2>{event.title}</h2>
      <div className="identity-tags">
        <span>{formatEventTime(event, locale)}</span>
        <span>{label(event.reality, locale)}</span>
        <span className={`confidence ${event.confidence}`}>{label(event.confidence, locale)}</span>
        <span>#{event.sequence}</span>
      </div>
      <p>{event.summary}</p>
      {(detail.detail || event.detail) && <p>{detail.detail || event.detail}</p>}
      {(detail.significance || event.significance) && <section><h3>{t("significance", locale)}</h3><p>{detail.significance || event.significance}</p></section>}
      <div className="drawer-nav">
        <button type="button" disabled={!previous} title={previous?.title} onClick={() => previous && onSelect({ type: "event", workSlug: atlas.work.slug, id: previous.slug }, "list")}>← {previous ? previous.title : t("prevEvent", locale)}</button>
        <button type="button" disabled={!following} title={following?.title} onClick={() => following && onSelect({ type: "event", workSlug: atlas.work.slug, id: following.slug }, "list")}>{following ? following.title : t("nextEvent", locale)} →</button>
      </div>
      {parent && <dl><dt>{t("parentEvent", locale)}</dt><dd><button className="link" onClick={() => onSelect({ type: "event", workSlug: atlas.work.slug, id: parent.slug }, "list")}>{parent.title}</button></dd></dl>}
      {children.length > 0 && <section>
        <h3>{t("childEvents", locale)} · {children.length}</h3>
        <div className="drawer-links">
          {children.map((child) => <button key={child.slug} onClick={() => onSelect({ type: "event", workSlug: atlas.work.slug, id: child.slug }, "list")}>#{child.sequence} {child.title}</button>)}
        </div>
      </section>}
      <div className="drawer-links">
        <h3>{t("people", locale)}</h3>
        {event.characterSlugs.map((slug) => {
          const person = atlas.characters.find((item) => item.slug === slug);
          return person ? <button key={slug} onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: slug }, "list")}>{person.name}</button> : null;
        })}
        <h3>{t("relatedPlaces", locale)}</h3>
        {event.locationSlugs.map((slug) => {
          const place = atlas.locations.find((item) => item.slug === slug);
          return place ? <button key={slug} onClick={() => onSelect({ type: "location", workSlug: atlas.work.slug, id: slug }, "list")}>{place.name}</button> : null;
        })}
        {routes.length > 0 && <>
          <h3>{t("relatedRoutes", locale)}</h3>
          {routes.map((route) => <button key={route.slug} onClick={() => onSelect({ type: "route", workSlug: atlas.work.slug, id: route.slug }, "list")}>{route.name}</button>)}
        </>}
      </div>
      <Sources names={event.sourceTitles} locale={locale} />
    </Shell>;
  }

  if (entity.type === "artist") {
    const artist = atlas.artists.find((item) => item.slug === entity.id);
    if (!artist) return null;
    const era = chapterOf(artist.chapterSlug);
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title}{era ? ` · ${era.title}` : ""}</small><h2>{artist.fullName || artist.name}</h2>
      {artist.aliases.length > 0 && <p className="aliases">{t("aliases", locale)}: {artist.aliases.join(" · ")}</p>}
      <div className="identity-tags"><span>{label(artist.artistKind, locale)}</span><span>{artist.modernStatus}</span>{artist.periodTitles.map((title) => <span key={title}>{title}</span>)}</div>
      {artist.formalTitles.length > 0 && <p className="aliases"><strong>{t("formalTitles", locale)}:</strong> {artist.formalTitles.join(" · ")}</p>}
      <p>{artist.summary}</p>
      <dl><dt>{t("lifeRange", locale)}</dt><dd>{artist.birthYear !== null ? formatYear(artist.birthYear, locale) : "—"} — {artist.deathYear !== null ? formatYear(artist.deathYear, locale) : "—"}</dd><dt>{t("artworks", locale)}</dt><dd>{artist.artworkSlugs.length}</dd><dt>{t("relatedPlaces", locale)}</dt><dd>{artist.locationSlugs.length}</dd></dl>
      {artist.artworkSlugs.length > 0 && <section><h3>{t("artworks", locale)}</h3><div className="drawer-links">{artist.artworkSlugs.map((slug) => { const artwork = atlas.artworks.find((item) => item.slug === slug); return artwork ? <button key={slug} onClick={() => onSelect({ type: "artwork", workSlug: atlas.work.slug, id: slug }, "list")}>{artwork.title}</button> : null; })}</div></section>}
      <div className="drawer-actions"><button onClick={() => onTab("artworks")}>{t("artworks", locale)}</button><button onClick={() => onTab("movements")}>{t("movements", locale)}</button></div>
      <Sources names={artist.sourceTitles} locale={locale} />
    </Shell>;
  }

  if (entity.type === "artwork") {
    const artwork = atlas.artworks.find((item) => item.slug === entity.id);
    if (!artwork) return null;
    const era = chapterOf(artwork.chapterSlug);
    const artworkMedia = atlas.media.filter((item) => item.entityKind === "artwork" && item.entityId === artwork.id).sort((left, right) => left.id.localeCompare(right.id));
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title}{era ? ` · ${era.title}` : ""}</small><h2>{artwork.title}</h2>
      <div className="identity-tags"><span>{label(artwork.status, locale)}</span><span>{artwork.medium}</span><span>{artwork.creationStartYear ?? "?"}{artwork.creationEndYear && artwork.creationEndYear !== artwork.creationStartYear ? `–${artwork.creationEndYear}` : ""}</span></div>
      <ArtworkMedia media={artworkMedia} locale={locale} />
      <p>{artwork.summary}</p>
      {artwork.description && <section className="artwork-description"><h3>{t("artworkDescription", locale)}</h3><p>{artwork.description}</p></section>}
      <dl><dt>{t("creationPlace", locale)}</dt><dd>{atlas.locations.find((place) => place.slug === artwork.creationLocationSlug)?.name ?? "—"}</dd><dt>{t("currentLocation", locale)}</dt><dd>{atlas.locations.find((place) => place.slug === artwork.currentLocationSlug)?.name ?? "—"}</dd><dt>{t("medium", locale)}</dt><dd>{artwork.medium}</dd></dl>
      {artwork.artistSlugs.length > 0 && <section><h3>{t("artists", locale)}</h3><div className="drawer-links">{artwork.artistSlugs.map((slug) => { const artist = atlas.artists.find((item) => item.slug === slug); return artist ? <button key={slug} onClick={() => onSelect({ type: "artist", workSlug: atlas.work.slug, id: slug }, "list")}>{artist.fullName || artist.name}</button> : null; })}</div></section>}
      <Sources names={artwork.sourceTitles} locale={locale} />
    </Shell>;
  }

  if (entity.type === "movement") {
    const movement = atlas.movements.find((item) => item.slug === entity.id);
    if (!movement) return null;
    return <Shell onClose={onClose} locale={locale}><small>{atlas.work.title}</small><h2>{movement.name}</h2><p>{movement.summary}</p><dl><dt>{t("lifeRange", locale)}</dt><dd>{movement.startYear ?? "—"} — {movement.endYear ?? "—"}</dd><dt>{t("artists", locale)}</dt><dd>{movement.artistSlugs.length}</dd><dt>{t("artworks", locale)}</dt><dd>{movement.artworkSlugs.length}</dd></dl><Sources names={movement.sourceTitles} locale={locale} /></Shell>;
  }

  if (entity.type === "institution") {
    const institution = atlas.institutions.find((item) => item.slug === entity.id);
    if (!institution) return null;
    const place = atlas.locations.find((item) => item.slug === institution.locationSlug);
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title}</small><h2>{institution.name}</h2>
      <div className="identity-tags"><span>{label(institution.institutionType, locale)}</span></div>
      <p>{institution.summary}</p>
      <dl><dt>{t("creationPlace", locale)}</dt><dd>{place?.name ?? "—"}</dd><dt>{t("lifeRange", locale)}</dt><dd>{institution.foundedYear !== null ? formatYear(institution.foundedYear, locale) : "—"} — {institution.closedYear !== null ? formatYear(institution.closedYear, locale) : (locale === "zh-CN" ? "至今" : "present")}</dd><dt>{t("artists", locale)}</dt><dd>{institution.artistSlugs.length}</dd></dl>
      <div className="drawer-actions"><button onClick={() => onTab(atlas.work.category === "art_history" ? "characters" : "artists")}>{t(atlas.work.category === "art_history" ? "characters" : "artists", locale)}</button></div>
      <Sources names={institution.sourceTitles} locale={locale} />
    </Shell>;
  }

  if (entity.type === "composition") {
    const composition = atlas.compositions.find((item) => item.slug === entity.id);
    if (!composition) return null;
    const era = chapterOf(composition.chapterSlug);
    const composer = atlas.characters.find((item) => item.slug === composition.primaryComposerSlug);
    const fragments = atlas.scoreFragments.filter((item) => composition.scoreFragmentSlugs.includes(item.slug));
    const studyUnits = atlas.musicLearningUnits.filter((unit) => unit.compositionSlugs.includes(composition.slug));
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title}{era ? ` · ${era.title}` : ""}</small>
      <h2>{composition.title}</h2>
      <div className="identity-tags">
        <span>{label(composition.workStatus, locale)}</span><span>{composition.genre}</span><span>{composition.form}</span>
        <span>{composition.compositionStartYear ?? "?"}{composition.compositionEndYear && composition.compositionEndYear !== composition.compositionStartYear ? `–${composition.compositionEndYear}` : ""}</span>
      </div>
      <p>{composition.summary}</p>
      {composition.description && <section><h3>{locale === "zh-CN" ? "曲目简介" : "About this work"}</h3><p>{composition.description}</p></section>}
      <dl>
        {composer && <><dt>{locale === "zh-CN" ? "作曲家" : "Composer"}</dt><dd><button className="link" onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: composer.slug }, "list")}>{composer.name}</button></dd></>}
        <dt>{locale === "zh-CN" ? "调性" : "Key"}</dt><dd>{composition.keySignature || "—"}</dd>
        <dt>{locale === "zh-CN" ? "预计时长" : "Approx. duration"}</dt><dd>{composition.approxDurationSeconds ? `${Math.round(composition.approxDurationSeconds / 60)}′` : "—"}</dd>
        {composition.textLanguage && <><dt>{locale === "zh-CN" ? "文本语言" : "Text language"}</dt><dd>{composition.textLanguage}</dd></>}
        <dt>{locale === "zh-CN" ? "乐谱片段" : "Score excerpts"}</dt><dd>{fragments.length}</dd>
      </dl>
      {composition.contributors.length > 0 && <section><h3>{locale === "zh-CN" ? "创作参与者" : "Contributors"}</h3><div className="drawer-links">{composition.contributors.map((contributor) => { const person = atlas.characters.find((item) => item.slug === contributor.slug); return person ? <button key={`${contributor.slug}:${contributor.role}`} type="button" onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: person.slug }, "list")}>{person.name} · {label(contributor.role, locale)}</button> : null; })}</div></section>}
      {composition.instrumentSlugs.length > 0 && <section>
        <h3>{locale === "zh-CN" ? "编制与乐器" : "Instrumentation"}</h3>
        <div className="drawer-links">{composition.instrumentSlugs.map((slug) => {
          const instrument = atlas.instruments.find((item) => item.slug === slug);
          return instrument ? <button key={slug} onClick={() => onSelect({ type: "instrument", workSlug: atlas.work.slug, id: slug }, "list")}>{instrument.name}</button> : null;
        })}</div>
      </section>}
      {fragments.map((fragment) => <section className="score-fragment" key={fragment.slug}>
        <h3>{fragment.title}</h3>
        <p>{fragment.analysisNote}</p>
        <img src={fragment.svgAssetPath} alt={`${fragment.title} · ${locale === "zh-CN" ? "四小节分析乐谱" : "four-measure analytical score"}`} loading="lazy" />
        {fragment.audioAssetPath && <audio controls preload="none" src={fragment.audioAssetPath} aria-label={fragment.title} />}
        <small>{fragment.playbackDisclaimer}</small>
        {fragment.annotations.length > 0 && <ul>{fragment.annotations.map((annotation) => <li key={annotation.id}><strong>{annotation.label}:</strong> {annotation.explanation}</li>)}</ul>}
      </section>)}
      {studyUnits.length > 0 && <section className="learning-links"><h3>{t("learningPath", locale)}</h3><div className="drawer-links">{studyUnits.map((unit) => <div className="learning-link" key={unit.slug}><strong>{unit.title}</strong><small>{label(unit.difficulty, locale)} · {unit.targetMinutes}′</small>{unit.scoreFragmentSlugs[0] && <button type="button" onClick={() => onSelect({ type: "score_fragment", workSlug: atlas.work.slug, id: unit.scoreFragmentSlugs[0]! }, "list")}>{t("studyOpenFragment", locale)}</button>}</div>)}</div></section>}
      <Sources names={composition.sourceTitles} locale={locale} />
    </Shell>;
  }

  if (entity.type === "instrument") {
    const instrument = atlas.instruments.find((item) => item.slug === entity.id);
    if (!instrument) return null;
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title} · {label(instrument.family, locale)}</small><h2>{instrument.name}</h2>
      <div className="identity-tags"><span>{label(instrument.family, locale)}</span>{instrument.hornbostelSachsCode && <span>H–S {instrument.hornbostelSachsCode}</span>}{instrument.mimoTerm && <span>{instrument.mimoTerm}</span>}</div>
      <p>{instrument.summary}</p>
      <dl>
        <dt>{locale === "zh-CN" ? "历史范围" : "Historical range"}</dt><dd>{instrument.startYear ?? "—"} — {instrument.endYear ?? "—"}</dd>
        <dt>{locale === "zh-CN" ? "相关曲目" : "Related works"}</dt><dd>{instrument.compositionSlugs.length}</dd>
      </dl>
      <div className="drawer-links">{instrument.compositionSlugs.slice(0, 16).map((slug) => {
        const composition = atlas.compositions.find((item) => item.slug === slug);
        return composition ? <button key={slug} onClick={() => onSelect({ type: "composition", workSlug: atlas.work.slug, id: slug }, "list")}>{composition.title}</button> : null;
      })}</div>
      <Sources names={instrument.sourceTitles} locale={locale} />
    </Shell>;
  }

  if (entity.type === "music_style") {
    const style = atlas.musicStyles.find((item) => item.slug === entity.id);
    if (!style) return null;
    return <Shell onClose={onClose} locale={locale}><small>{atlas.work.title} · {label(style.styleKind, locale)}</small><h2>{style.name}</h2><p>{style.summary}</p><dl><dt>{t("lifeRange", locale)}</dt><dd>{style.startYear ?? "—"} — {style.endYear ?? "—"}</dd><dt>{locale === "zh-CN" ? "相关曲目" : "Related works"}</dt><dd>{style.compositionSlugs.length}</dd></dl><Sources names={style.sourceTitles} locale={locale} /></Shell>;
  }

  if (entity.type === "music_institution") {
    const institution = atlas.musicInstitutions.find((item) => item.slug === entity.id);
    if (!institution) return null;
    const place = atlas.locations.find((item) => item.slug === institution.locationSlug);
    return <Shell onClose={onClose} locale={locale}><small>{atlas.work.title} · {label(institution.institutionType, locale)}</small><h2>{institution.name}</h2><p>{institution.summary}</p><dl><dt>{t("creationPlace", locale)}</dt><dd>{place?.name ?? "—"}</dd><dt>{t("lifeRange", locale)}</dt><dd>{institution.foundedYear ?? "—"} — {institution.closedYear ?? (locale === "zh-CN" ? "至今" : "present")}</dd></dl><Sources names={institution.sourceTitles} locale={locale} /></Shell>;
  }

  if (entity.type === "score_fragment") {
    const fragment = atlas.scoreFragments.find((item) => item.slug === entity.id);
    if (!fragment) return null;
    const composition = atlas.compositions.find((item) => item.slug === fragment.compositionSlug);
    return <Shell onClose={onClose} locale={locale}><small>{atlas.work.title} · {label(fragment.notationKind, locale)}</small><h2>{fragment.title}</h2><p>{fragment.analysisNote}</p>{composition && <button type="button" className="link" onClick={() => onSelect({ type: "composition", workSlug: atlas.work.slug, id: composition.slug }, "list")}>{locale === "zh-CN" ? `回到曲目：${composition.title}` : `Back to ${composition.title}`}</button>}<section className="score-fragment"><img src={fragment.svgAssetPath} alt={fragment.title} />{fragment.audioAssetPath && <audio controls preload="none" src={fragment.audioAssetPath} />}<small>{fragment.playbackDisclaimer}</small></section><Sources names={fragment.sourceTitles} locale={locale} /></Shell>;
  }

  if (entity.type === "location") {
    const place = atlas.locations.find((item) => item.slug === entity.id);
    if (!place) return null;
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title}{place.historicalRegionName ? ` · ${place.historicalRegionName}` : ""}</small>
      <h2>{place.name}</h2>
      {place.aliases.length > 0 && <p className="aliases">{t("aliases", locale)}: {place.aliases.join(" · ")}</p>}
      <div className="identity-tags">
        <span>{label(place.locationType, locale)}</span>
        <span className={place.isInferred ? "confidence low" : "confidence high"}>{label(place.coordinateAccuracy, locale)}</span>
        {place.modernCountryCode && <span>{place.modernCountryCode}</span>}
      </div>
      <p>{place.summary}</p>
      {(detail.detail || place.detail) && <p>{detail.detail || place.detail}</p>}
      {(detail.literarySignificance || place.literarySignificance) && <section><h3>{t("literarySignificance", locale)}</h3><p>{detail.literarySignificance || place.literarySignificance}</p></section>}
      {(detail.historicalBackground || place.historicalBackground) && <section><h3>{t("historicalBackground", locale)}</h3><p>{detail.historicalBackground || place.historicalBackground}</p></section>}
      {(detail.modernStatus || place.modernStatus) && <section><h3>{t("modernStatus", locale)}</h3><p>{detail.modernStatus || place.modernStatus}</p></section>}
      <dl>
        <dt>{t("coordinates", locale)}</dt><dd>{place.lat?.toFixed(4) ?? "—"}, {place.lng?.toFixed(4) ?? "—"}</dd>
        <dt>{t("coordinateQuality", locale)}</dt><dd>{label(place.coordinateAccuracy, locale)}{place.isInferred ? ` · ${t("uncertainCoordinate", locale)}` : ""}</dd>
        {place.stillExists !== null && <><dt>{t("stillExists", locale)}</dt><dd>{place.stillExists ? t("yes", locale) : t("no", locale)}</dd></>}
        {place.historicalRegionName && <><dt>{t("historicalRegion", locale)}</dt><dd>{place.historicalRegionName}</dd></>}
        <dt>{t("relatedEvents", locale)}</dt><dd>{place.eventSlugs.length}</dd>
      </dl>
      {place.eventSlugs.length > 0 && <section>
        <h3>{t("relatedEvents", locale)} · {place.eventSlugs.length}</h3>
        <div className="drawer-links">
          {place.eventSlugs.map((slug) => {
            const event = atlas.events.find((item) => item.slug === slug);
            return event ? <button key={slug} onClick={() => onSelect({ type: "event", workSlug: atlas.work.slug, id: slug }, "list")}>#{event.sequence} {event.title}</button> : null;
          })}
        </div>
      </section>}
      <div className="drawer-actions">
        <button onClick={() => onTab("events")}>{t("relatedEvents", locale)}</button>
        {place.routeSlugs.length > 0 && <button onClick={() => onTab("routes")}>{t("relatedRoutes", locale)}</button>}
      </div>
    </Shell>;
  }

  if (entity.type === "route") {
    const route = atlas.routes.find((item) => item.slug === entity.id);
    if (!route) return null;
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title} · {label(route.certainty, locale)}</small>
      <h2>{route.name}</h2>
      <p>{route.summary}</p>
      <h3>{t("waypoints", locale)}</h3>
      <ol className="waypoints">
        {route.waypoints.map((waypoint) => {
          const place = atlas.locations.find((item) => item.slug === waypoint.locationSlug);
          const event = atlas.events.find((item) => item.slug === waypoint.eventSlug);
          return <li key={waypoint.position}>
            <button onClick={() => onSelect({ type: "location", workSlug: atlas.work.slug, id: waypoint.locationSlug }, "list")}>{place?.name ?? waypoint.locationSlug}</button>
            {event && <small><button className="link" onClick={() => onSelect({ type: "event", workSlug: atlas.work.slug, id: event.slug }, "list")}>{event.title}</button></small>}
          </li>;
        })}
      </ol>
    </Shell>;
  }

  if (entity.type === "relationship") {
    const relation = atlas.relations.find((item) => item.id === entity.id);
    if (!relation) return null;
    const from = atlas.characters.find((item) => item.slug === relation.fromSlug);
    const to = atlas.characters.find((item) => item.slug === relation.toSlug);
    const startEvent = atlas.events.find((item) => item.slug === relation.startEventSlug);
    const endEvent = atlas.events.find((item) => item.slug === relation.endEventSlug);
    return <Shell onClose={onClose} locale={locale}>
      <small>{atlas.work.title} · {label(relation.relationType, locale)}</small>
      <h2>{relation.label}</h2>
      <p>{relation.summary || detail.summary}</p>
      <div className="relation-pair">
        {[from, to].map((person) => person ? <button key={person.slug} onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: person.slug }, "graph")}>
          <PersonAvatar person={person} color={colorForCharacter(atlas, person)} />{person.name}
        </button> : null)}
      </div>
      <dl>
        <dt>{t("direction", locale)}</dt><dd>{label(relation.direction, locale)}</dd>
        <dt>{t("sentiment", locale)}</dt><dd><span className={`sentiment-chip ${relation.sentiment}`}>{label(relation.sentiment, locale)}</span></dd>
        <dt>{t("strength", locale)}</dt><dd>{relation.strength}/5</dd>
        <dt>{t("status", locale)}</dt><dd>{label(relation.status, locale)}</dd>
        {(startEvent || endEvent) && <>
          <dt>{t("relationLifecycle", locale)}</dt>
          <dd>
            {startEvent && <button className="link" onClick={() => onSelect({ type: "event", workSlug: atlas.work.slug, id: startEvent.slug }, "list")}>{t("from", locale)} {startEvent.title}</button>}
            {endEvent && <button className="link" onClick={() => onSelect({ type: "event", workSlug: atlas.work.slug, id: endEvent.slug }, "list")}>{t("to", locale)} {endEvent.title}</button>}
          </dd>
        </>}
      </dl>
      <Sources names={relation.sourceTitles} locale={locale} />
    </Shell>;
  }

  return null;
}
