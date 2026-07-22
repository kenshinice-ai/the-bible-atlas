import { useEffect, useMemo, useRef, useState } from "react";
import { getAtlas,getWorks } from "./api";
import { AtlasMap } from "./components/AtlasMap";
import { EntityDrawer } from "./components/EntityDrawer";
import { RelationshipGraph } from "./components/RelationshipGraph";
import { WorkControlCenter } from "./components/WorkControlCenter";
import { WorldTimeline } from "./components/WorldTimeline";
import { parseAtlasState,serializeAtlasState,validateWorkSelection,type ExploreState,type MapContentLayer,type SelectedEntity,type SelectionMode,type SelectionSource,type Tab,type TimelineMode } from "./state";
import { type Atlas,type Locale,type WorksResponse } from "./types";

function activateCard(event:React.KeyboardEvent<HTMLElement>,action:()=>void){if(event.key==="Enter"||event.key===" "){event.preventDefault();action()}}

const copy={
  "zh-CN":{title:"世界文学名著时空地图",loading:"载入中",characters:"人物",events:"事件",locations:"地点",routes:"路线",relationships:"关系",sources:"来源与数据说明",copy:"复制深链接",copied:"已复制",error:"加载失败",single:"单部探索",multi:"多部对照",active:"主作品",limit:"最多同时选择 5 部作品",layer:"现实作品与虚构作品不能叠加在同一地图层",unknown:"深链接中包含未知作品",multiHint:"地图叠加已选作品；人物、事件、关系和叙事顺序跟随主作品。",fit:"返回全部作品范围",places:"地点",landmarks:"地标",uncertain:"此坐标为推定或近似位置",empty:"当前筛选没有事件",clear:"清除筛选",narrative:"叙事顺序",history:"历史时间"},
  en:{title:"World Literature Atlas",loading:"Loading",characters:"People",events:"Events",locations:"Places",routes:"Routes",relationships:"Relations",sources:"Sources and data notes",copy:"Copy deep link",copied:"Copied",error:"Load failed",single:"Single exploration",multi:"Compare works",active:"Primary work",limit:"Select up to 5 works",layer:"Real and fictional works cannot share one map layer",unknown:"The deep link contains an unknown work",multiHint:"The map overlays selected works; people, events, relations, and narrative order follow the primary work.",fit:"Fit all selected works",places:"Places",landmarks:"Landmarks",uncertain:"This coordinate is inferred or approximate",empty:"No events match the current filter",clear:"Clear filter",narrative:"Narrative order",history:"Historical time"},
} as const;

function tabForEntity(entity:SelectedEntity):Tab{
  return entity.type==="character"?"characters":entity.type==="event"?"events":entity.type==="location"?"locations":entity.type==="route"?"routes":entity.type==="relationship"?"relationships":"events";
}

export default function App(){
  const[explore,setExplore]=useState<ExploreState>(()=>parseAtlasState(location.search));
  const[works,setWorks]=useState<WorksResponse["items"]>([]);const[atlases,setAtlases]=useState<Atlas[]>([]);const[error,setError]=useState<string|null>(null);const[selectionError,setSelectionError]=useState<string|null>(null);const[copied,setCopied]=useState(false);
  const atlasCache=useRef(new Map<string,Atlas>());const t=copy[explore.locale];

  function commit(next:ExploreState,push=false){if(push)history.pushState(null,"",serializeAtlasState(next));setExplore(next)}
  useEffect(()=>{const restore=()=>setExplore(parseAtlasState(location.search));window.addEventListener("popstate",restore);return()=>window.removeEventListener("popstate",restore)},[]);
  useEffect(()=>{
    if(!explore.selectedEntity)return;
    const dismissOutside=(event:PointerEvent)=>{const drawer=document.querySelector(".entity-drawer");if(event.target instanceof Element&&event.target.closest("button,a,input,select,summary,label,[role='button'],.browser,.map-shell,.world-timeline"))return;if(event.target instanceof Node&&drawer&&!drawer.contains(event.target))setExplore((current)=>({...current,selectedEntity:null}))};
    const dismissWithKeyboard=(event:KeyboardEvent)=>{if(event.key==="Escape")setExplore((current)=>({...current,selectedEntity:null}))};
    document.addEventListener("pointerdown",dismissOutside);document.addEventListener("keydown",dismissWithKeyboard);
    return()=>{document.removeEventListener("pointerdown",dismissOutside);document.removeEventListener("keydown",dismissWithKeyboard)};
  },[explore.selectedEntity]);
  useEffect(()=>{history.replaceState(null,"",serializeAtlasState(explore))},[explore]);
  useEffect(()=>{let current=true;setError(null);void getWorks(explore.locale).then((response)=>{if(current)setWorks(response.items)}).catch((cause:unknown)=>{if(current)setError(cause instanceof Error?cause.message:String(cause))});return()=>{current=false}},[explore.locale]);
  useEffect(()=>{
    let current=true;if(works.length===0)return()=>{current=false};const issue=validateWorkSelection(works,explore.mode,explore.works);
    if(issue){const message=issue==="mixed_layers"?t.layer:issue==="unknown_work"?t.unknown:t.limit;setAtlases([]);setSelectionError(message);setError(message);return()=>{current=false}}
    setSelectionError(null);setError(null);
    const load=async(slug:string)=>{const key=`${explore.locale}:${slug}`;const cached=atlasCache.current.get(key);if(cached)return cached;const atlas=await getAtlas(slug,explore.locale);atlasCache.current.set(key,atlas);return atlas};
    void Promise.all(explore.works.map(load)).then((items)=>{if(current)setAtlases(items)}).catch((cause:unknown)=>{if(current)setError(cause instanceof Error?cause.message:String(cause))});return()=>{current=false};
  },[explore.locale,explore.mode,explore.works,works,t]);

  const activeAtlas=atlases.find((atlas)=>atlas.work.slug===explore.active)??atlases[0]??null;
  const visibleEvents=useMemo(()=>{if(!activeAtlas)return[];let items=activeAtlas.events;if(explore.timelineMode==="narrative")items=items.filter((event)=>event.sequence<=explore.until);else items=items.filter((event)=>event.historicalStartYear===null||(event.historicalStartYear>=explore.rangeStart&&event.historicalStartYear<=explore.rangeEnd));const selected=explore.selectedEntity;if(selected?.workSlug===activeAtlas.work.slug&&selected.type==="character")items=items.filter((event)=>event.characterSlugs.includes(selected.id));if(selected?.workSlug===activeAtlas.work.slug&&selected.type==="location")items=items.filter((event)=>event.locationSlugs.includes(selected.id));return items},[activeAtlas,explore.rangeEnd,explore.rangeStart,explore.selectedEntity,explore.timelineMode,explore.until]);
  const selectedAtlas=explore.selectedEntity?atlases.find((atlas)=>atlas.work.slug===explore.selectedEntity?.workSlug):null;

  function changeMode(mode:SelectionMode){const next={...explore,mode,works:mode==="single"?[explore.active]:explore.works,selectedEntity:null,selectionSource:"list" as const};setSelectionError(null);commit(next,true)}
  function chooseWork(slug:string){
    setSelectionError(null);if(explore.mode==="single"){commit({...explore,works:[slug],active:slug,selectedEntity:null,until:999},true);return}
    if(explore.works.includes(slug)){if(explore.works.length===1){setSelectionError(t.limit);return}const remaining=explore.works.filter((item)=>item!==slug);commit({...explore,works:remaining,active:explore.active===slug?remaining[0]!:explore.active,selectedEntity:explore.selectedEntity?.workSlug===slug?null:explore.selectedEntity},true);return}
    if(explore.works.length>=5){setSelectionError(t.limit);return}const currentLayer=works.find((item)=>item.slug===explore.works[0])?.mapLayer;const candidateLayer=works.find((item)=>item.slug===slug)?.mapLayer;if(currentLayer&&candidateLayer&&currentLayer!==candidateLayer){setSelectionError(t.layer);return}
    commit({...explore,works:[...explore.works,slug],active:slug,selectedEntity:null,until:999},true);
  }
  function selectEntity(entity:SelectedEntity,source:SelectionSource){const event=atlases.find((atlas)=>atlas.work.slug===entity.workSlug)?.events.find((item)=>item.slug===entity.id);commit({...explore,active:entity.workSlug,selectedEntity:entity,selectionSource:source,tab:tabForEntity(entity),until:event?.sequence??explore.until},true)}
  function setTab(tab:Tab){commit({...explore,tab},true)}
  function toggleLayer(layer:MapContentLayer){const mapLayers=explore.mapLayers.includes(layer)?explore.mapLayers.filter((item)=>item!==layer):[...explore.mapLayers,layer];commit({...explore,mapLayers})}
  function setTimelineMode(timelineMode:TimelineMode){commit({...explore,timelineMode},true)}

  return <main className={explore.selectedEntity?"has-drawer":undefined}>
    <header className="topbar"><div><p className="eyebrow">Blueprint v3.1 · Bible complexity sample</p><h1>{t.title}</h1></div><div className="controls"><WorkControlCenter works={works} selected={explore.works} active={explore.active} mode={explore.mode} locale={explore.locale} error={selectionError} onMode={changeMode} onToggle={chooseWork} onActive={(active)=>commit({...explore,active,selectedEntity:null,until:999},true)}/><div className="locale" aria-label="language"><button className={explore.locale==="zh-CN"?"active":""} onClick={()=>commit({...explore,locale:"zh-CN"},true)}>中文</button><button className={explore.locale==="en"?"active":""} onClick={()=>commit({...explore,locale:"en"},true)}>EN</button></div></div></header>
    {error?<section className="error"><strong>{t.error}</strong><p>{error}</p></section>:!activeAtlas?<p>{t.loading}…</p>:<>
      <section className="compare-bar"><span>{t.active}:</span>{atlases.map((atlas)=><button key={atlas.work.slug} style={{borderColor:atlas.work.themeColor}} className={atlas.work.slug===activeAtlas.work.slug?"active":""} onClick={()=>commit({...explore,active:atlas.work.slug,selectedEntity:null,until:999},true)}><i style={{background:atlas.work.themeColor}}/>{atlas.work.title}</button>)}<p>{t.multiHint}</p></section>
      <section className="hero" style={{borderColor:activeAtlas.work.themeColor}}><div><span className={`badge ${activeAtlas.work.category}`}>{activeAtlas.work.category.replaceAll("_"," ")}</span><h2>{activeAtlas.work.title}</h2><p>{activeAtlas.work.summary}</p><small>{activeAtlas.work.originRegion} · {activeAtlas.characters.length} {t.characters} · {activeAtlas.events.length} {t.events} · {activeAtlas.locations.length} {t.locations}</small></div><button onClick={()=>void navigator.clipboard.writeText(location.href).then(()=>{setCopied(true);setTimeout(()=>setCopied(false),1500)})}>{copied?t.copied:t.copy}</button></section>
      <section className="workspace"><div className="map-shell"><AtlasMap atlases={atlases} selectedEntity={explore.selectedEntity} selectionSource={explore.selectionSource} mapLayers={explore.mapLayers} onSelect={selectEntity} onToggleLayer={toggleLayer} labels={{fit:t.fit,places:t.places,routes:t.routes,landmarks:t.landmarks,uncertain:t.uncertain}}/></div>
      <aside className="browser"><nav>{(["characters","events","locations","routes","relationships"] as Tab[]).map((key)=><button key={key} className={explore.tab===key?"active":""} onClick={()=>setTab(key)}>{t[key]}</button>)}</nav><div className="cards">
        {explore.tab==="characters"&&activeAtlas.characters.map((person)=><article key={person.slug} role="button" tabIndex={0} className={explore.selectedEntity?.type==="character"&&explore.selectedEntity.id===person.slug?"selected":""} onClick={()=>selectEntity({type:"character",workSlug:activeAtlas.work.slug,id:person.slug},"list")} onKeyDown={(event)=>activateCard(event,()=>selectEntity({type:"character",workSlug:activeAtlas.work.slug,id:person.slug},"list"))}><span className={`mini-person ${person.gender}`} style={{borderColor:activeAtlas.work.themeColor}} aria-hidden="true"/><h3>{person.name}</h3><p>{person.summary}</p><small>{person.roleType.replaceAll("_"," ")} · {person.ageStage} · {person.eventSlugs.length} {t.events}</small></article>)}
        {explore.tab==="events"&&(visibleEvents.length===0?<p className="empty">{t.empty}</p>:visibleEvents.map((event)=><article key={event.slug} role="button" tabIndex={0} className={explore.selectedEntity?.type==="event"&&explore.selectedEntity.id===event.slug?"selected":""} onClick={()=>selectEntity({type:"event",workSlug:activeAtlas.work.slug,id:event.slug},"list")} onKeyDown={(keyEvent)=>activateCard(keyEvent,()=>selectEntity({type:"event",workSlug:activeAtlas.work.slug,id:event.slug},"list"))}><span className={`sequence ${event.timeType}`}>{event.sequence}</span><h3>{event.title}</h3><p>{event.summary}</p><small>{event.timeLabel||event.timeType.replaceAll("_"," ")} · {event.confidence} · {event.sourceTitles.length} source{event.sourceTitles.length===1?"":"s"}</small></article>))}
        {explore.tab==="locations"&&activeAtlas.locations.map((place)=><article key={place.slug} role="button" tabIndex={0} className={explore.selectedEntity?.type==="location"&&explore.selectedEntity.id===place.slug?"selected":""} onClick={()=>selectEntity({type:"location",workSlug:activeAtlas.work.slug,id:place.slug},"list")} onKeyDown={(event)=>activateCard(event,()=>selectEntity({type:"location",workSlug:activeAtlas.work.slug,id:place.slug},"list"))}><span className={`place-type type-${place.locationType}`}/><h3>{place.name}</h3><p>{place.summary}</p><small>{place.locationType.replaceAll("_"," ")} · {place.coordinateAccuracy} · {place.eventSlugs.length} {t.events}</small></article>)}
        {explore.tab==="routes"&&activeAtlas.routes.map((route)=><article key={route.slug} role="button" tabIndex={0} className={explore.selectedEntity?.type==="route"&&explore.selectedEntity.id===route.slug?"selected":""} onClick={()=>selectEntity({type:"route",workSlug:activeAtlas.work.slug,id:route.slug},"list")} onKeyDown={(event)=>activateCard(event,()=>selectEntity({type:"route",workSlug:activeAtlas.work.slug,id:route.slug},"list"))}><h3>{route.name}</h3><p>{route.summary}</p><small>{route.certainty.replaceAll("_"," ")} · {route.waypoints.length} nodes</small></article>)}
        {explore.tab==="relationships"&&<RelationshipGraph atlas={activeAtlas} locale={explore.locale} until={Math.min(explore.until,activeAtlas.events.length)} selected={explore.selectedEntity} onSelect={(entity)=>selectEntity(entity,"relationship")} onSequence={(until)=>commit({...explore,until,timelineMode:"narrative"})}/>}
      </div>{explore.selectedEntity&&(explore.selectedEntity.type==="character"||explore.selectedEntity.type==="location")&&<button className="clear-filter" onClick={()=>commit({...explore,selectedEntity:null})}>{t.clear}</button>}</aside></section>
      <WorldTimeline atlases={atlases} activeAtlas={activeAtlas} locale={explore.locale} mode={explore.timelineMode} rangeStart={explore.rangeStart} rangeEnd={explore.rangeEnd} until={explore.until} onMode={setTimelineMode} onRange={(rangeStart,rangeEnd)=>commit({...explore,rangeStart,rangeEnd,timelineMode:"history"})} onNarrative={(until)=>commit({...explore,until,timelineMode:"narrative"})} onSelect={(entity)=>selectEntity(entity,"timeline")}/>
      {activeAtlas.sources.length>0&&<footer><h2>{t.sources}</h2><p>{explore.locale==="zh-CN"?"模糊年代与推定地点会明确标记；摘要为原创结构化描述。":"Uncertain dates and inferred places are explicitly marked; summaries are original structured descriptions."}</p>{activeAtlas.sources.map((source)=><details key={source.id}><summary>{source.url?<a href={source.url} target="_blank" rel="noreferrer">{source.title}</a>:source.title} · {source.sourceType} · {source.evidenceGrade}</summary><p>{source.citation}</p></details>)}</footer>}
      {selectedAtlas&&explore.selectedEntity&&<EntityDrawer atlas={selectedAtlas} entity={explore.selectedEntity} locale={explore.locale} onClose={()=>commit({...explore,selectedEntity:null})} onSelect={selectEntity} onTab={setTab}/>}
    </>}
  </main>;
}
