import { useEffect, useMemo, useState } from "react";
import { getAtlas,getWorks } from "./api";
import { AtlasMap } from "./components/AtlasMap";
import { parseAtlasState, validateWorkSelection, type SelectionMode, type Tab } from "./state";
import { type Atlas,type Locale,type WorksResponse } from "./types";

const MAX_WORKS=3;
const copy={
  "zh-CN":{title:"世界文学名著时空地图",loading:"载入中",characters:"人物",events:"事件",locations:"地点",routes:"路线",sources:"来源",copy:"复制深链接",copied:"已复制",error:"加载失败",all:"叙事进度",single:"单选",multi:"对照多选",choose:"选择世界名著",active:"当前浏览",limit:"最多选择 3 部作品",layer:"现实作品与虚构作品不能叠加在同一地图层",unknown:"深链接中包含未知作品",multiHint:"地图叠加已选作品；人物、事件和时间轴跟随当前作品。"},
  en:{title:"World Literature Atlas",loading:"Loading",characters:"Characters",events:"Events",locations:"Places",routes:"Routes",sources:"Sources",copy:"Copy deep link",copied:"Copied",error:"Load failed",all:"Narrative progress",single:"Single",multi:"Compare",choose:"Choose classics",active:"Active work",limit:"Select up to 3 works",layer:"Real and fictional works cannot share one map layer",unknown:"The deep link contains an unknown work",multiHint:"The map overlays selected works; people, events and timeline follow the active work."}
} as const;

export default function App(){
  const initial=useMemo(()=>parseAtlasState(location.search),[]);
  const[locale,setLocale]=useState<Locale>(initial.locale);
  const[mode,setMode]=useState<SelectionMode>(initial.mode);
  const[selectedWorks,setSelectedWorks]=useState<string[]>(initial.works);
  const[activeWork,setActiveWork]=useState(initial.active);
  const[tab,setTab]=useState<Tab>(initial.tab);
  const[selected,setSelected]=useState<string|null>(initial.selected);
  const[until,setUntil]=useState(initial.until);
  const[works,setWorks]=useState<WorksResponse["items"]>([]);
  const[atlases,setAtlases]=useState<Atlas[]>([]);
  const[error,setError]=useState<string|null>(null);
  const[selectionError,setSelectionError]=useState<string|null>(null);
  const[copied,setCopied]=useState(false);
  const t=copy[locale];

  useEffect(()=>{void getWorks(locale).then((response)=>setWorks(response.items)).catch((cause:unknown)=>setError(cause instanceof Error?cause.message:String(cause)))},[locale]);
  useEffect(()=>{let current=true;if(works.length===0)return()=>{current=false};const issue=validateWorkSelection(works,mode,selectedWorks);if(issue){const message=issue==="mixed_layers"?t.layer:issue==="unknown_work"?t.unknown:t.limit;setAtlases([]);setSelectionError(message);setError(message);return()=>{current=false}}setSelectionError(null);setError(null);void Promise.all(selectedWorks.map((slug)=>getAtlas(slug,locale))).then((items)=>{if(current)setAtlases(items)}).catch((cause:unknown)=>{if(current)setError(cause instanceof Error?cause.message:String(cause))});return()=>{current=false}},[selectedWorks,locale,mode,works,t]);
  useEffect(()=>{const q=new URLSearchParams({locale,mode,works:selectedWorks.join(","),active:activeWork,tab});if(selected)q.set("selected",selected);if(until!==999)q.set("until",String(until));history.replaceState(null,"",`?${q}`)},[locale,mode,selectedWorks,activeWork,tab,selected,until]);

  const activeAtlas=atlases.find((atlas)=>atlas.work.slug===activeWork)??atlases[0]??null;
  const visibleEvents=activeAtlas?.events.filter((event)=>event.sequence<=until)??[];
  const max=activeAtlas?.events.length??1;
  const selectedLocation=useMemo(()=>{if(!selected)return null;const split=selected.indexOf(":");if(split<0)return null;const workSlug=selected.slice(0,split);const locationSlug=selected.slice(split+1);const atlas=atlases.find((item)=>item.work.slug===workSlug);const location=atlas?.locations.find((item)=>item.slug===locationSlug);return atlas&&location?{atlas,location}:null},[selected,atlases]);

  function changeMode(next:SelectionMode){setMode(next);setSelectionError(null);if(next==="single"){setSelectedWorks([activeWork]);setSelected(null)}}
  function chooseWork(slug:string){
    setSelectionError(null);
    if(mode==="single"){setSelectedWorks([slug]);setActiveWork(slug);setSelected(null);setUntil(999);return}
    if(selectedWorks.includes(slug)){
      if(selectedWorks.length===1){setSelectionError(t.limit);return}
      const remaining=selectedWorks.filter((item)=>item!==slug);setSelectedWorks(remaining);if(activeWork===slug)setActiveWork(remaining[0]!);setSelected(null);return;
    }
    if(selectedWorks.length>=MAX_WORKS){setSelectionError(t.limit);return}
    const currentLayer=works.find((item)=>item.slug===selectedWorks[0])?.mapLayer;
    const candidateLayer=works.find((item)=>item.slug===slug)?.mapLayer;
    if(currentLayer&&candidateLayer&&currentLayer!==candidateLayer){setSelectionError(t.layer);return}
    setSelectedWorks([...selectedWorks,slug]);setActiveWork(slug);setSelected(null);setUntil(999);
  }

  return <main>
    <header><div><p className="eyebrow">Blueprint v3.0</p><h1>{t.title}</h1></div><div className="controls">
      <details className="picker"><summary>{t.choose} · {selectedWorks.length}</summary><div className="picker-panel"><div className="mode"><button className={mode==="single"?"active":""} onClick={()=>changeMode("single")}>{t.single}</button><button className={mode==="multi"?"active":""} onClick={()=>changeMode("multi")}>{t.multi} ≤ {MAX_WORKS}</button></div>{works.map((work)=><label key={work.slug}><input type={mode==="single"?"radio":"checkbox"} name="work" checked={selectedWorks.includes(work.slug)} onChange={()=>chooseWork(work.slug)}/><span><strong>{work.title}</strong><small>{work.mapLayer==="real"?"REAL":"FICTIONAL"} · {work.authorName}</small></span></label>)}{selectionError&&<p className="selection-error">{selectionError}</p>}</div></details>
      <div className="locale" aria-label="language"><button className={locale==="zh-CN"?"active":""} onClick={()=>setLocale("zh-CN")}>中文</button><button className={locale==="en"?"active":""} onClick={()=>setLocale("en")}>EN</button></div>
    </div></header>
    {error?<section className="error"><strong>{t.error}</strong><p>{error}</p></section>:!activeAtlas?<p>{t.loading}…</p>:<>
      {mode==="multi"&&<section className="compare-bar"><span>{t.active}:</span>{atlases.map((atlas,index)=><button key={atlas.work.slug} className={atlas.work.slug===activeAtlas.work.slug?"active":""} onClick={()=>{setActiveWork(atlas.work.slug);setUntil(999)}}><i style={{background:["#b99cff","#f1ad66","#65c6bd"][index]}}/>{atlas.work.title}</button>)}<p>{t.multiHint}</p></section>}
      <section className="hero"><div><span className={`badge ${activeAtlas.work.contentMode}`}>{activeAtlas.work.contentMode.replaceAll("_"," ")}</span><h2>{activeAtlas.work.title}</h2><p>{activeAtlas.work.summary}</p></div><button onClick={()=>void navigator.clipboard.writeText(location.href).then(()=>{setCopied(true);setTimeout(()=>setCopied(false),1500)})}>{copied?t.copied:t.copy}</button></section>
      <section className="workspace"><div className="map-shell"><AtlasMap atlases={atlases} selected={selected} onSelect={setSelected}/>{selectedLocation&&<aside className="selection"><button aria-label="close" onClick={()=>setSelected(null)}>×</button><small>{selectedLocation.atlas.work.title}</small><h3>{selectedLocation.location.name}</h3><p>{selectedLocation.location.summary}</p></aside>}</div>
      <aside className="browser"><nav>{(["characters","events","locations","routes"] as Tab[]).map((key)=><button key={key} className={tab===key?"active":""} onClick={()=>setTab(key)}>{t[key]}</button>)}</nav><div className="cards">
        {tab==="characters"&&activeAtlas.characters.map((item)=>{const relations=activeAtlas.relations.filter((relation)=>relation.fromSlug===item.slug||relation.toSlug===item.slug);return <article key={item.slug} onClick={()=>{const event=activeAtlas.events.find((candidate)=>item.eventSlugs.includes(candidate.slug));if(event){setTab("events");setUntil(event.sequence);const place=event.locationSlugs[0];if(place)setSelected(`${activeAtlas.work.slug}:${place}`)}}}><h3>{item.name}</h3><p>{item.summary}</p>{relations.map((relation)=><small key={`${relation.fromSlug}:${relation.toSlug}:${relation.relationType}`} className="relation">{relation.label}</small>)}</article>})}
        {tab==="events"&&visibleEvents.map((item)=><article key={item.slug} onClick={()=>{const place=item.locationSlugs[0];if(place)setSelected(`${activeAtlas.work.slug}:${place}`)}}><span className="sequence">{item.sequence}</span><h3>{item.title}</h3><p>{item.summary}</p><small>{item.startDate??item.reality.replaceAll("_"," ")} · {item.sourceTitles.length} source{item.sourceTitles.length===1?"":"s"}</small></article>)}
        {tab==="locations"&&activeAtlas.locations.map((item)=>{const key=`${activeAtlas.work.slug}:${item.slug}`;return <article key={item.slug} className={selected===key?"selected":""} onClick={()=>setSelected(key)}><h3>{item.name}</h3><p>{item.summary}</p></article>})}
        {tab==="routes"&&activeAtlas.routes.map((item)=><article key={item.slug} onClick={()=>{const place=item.waypoints[0]?.locationSlug;if(place)setSelected(`${activeAtlas.work.slug}:${place}`)}}><h3>{item.name}</h3><p>{item.summary}</p><small>{item.certainty.replaceAll("_"," ")}</small></article>)}
      </div></aside></section>
      <section className="timeline"><label>{t.all}: {until===999?max:Math.min(until,max)}/{max}<input type="range" min="1" max={max} value={until===999?max:Math.min(until,max)} onChange={(event)=>setUntil(Number(event.target.value))}/></label><div>{activeAtlas.events.map((event)=><button key={event.slug} className={event.sequence<=until?"on":""} title={event.title} onClick={()=>{setUntil(event.sequence);setTab("events")}}>{event.sequence}</button>)}</div></section>
      {activeAtlas.sources.length>0&&<footer><h2>{t.sources}</h2>{activeAtlas.sources.map((source)=><p key={source.title}>{source.url?<a href={source.url} target="_blank" rel="noreferrer">{source.title}</a>:source.title} · {source.evidenceGrade}</p>)}</footer>}
    </>}
  </main>;
}
