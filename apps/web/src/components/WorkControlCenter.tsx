import { useEffect, useMemo, useRef, useState } from "react";
import { MAX_SELECTED_WORKS, type SelectionMode } from "../state";
import type { Locale, WorkSummary } from "../types";

interface Props{works:WorkSummary[];selected:string[];active:string;mode:SelectionMode;locale:Locale;error:string|null;onMode:(mode:SelectionMode)=>void;onToggle:(slug:string)=>void;onActive:(slug:string)=>void}

/** Searchable, keyboard-native work picker with explicit primary-work control. */
export function WorkControlCenter({works,selected,active,mode,locale,error,onMode,onToggle,onActive}:Props){
  const[query,setQuery]=useState("");const[category,setCategory]=useState("all");const[open,setOpen]=useState(false);const pickerRef=useRef<HTMLDetailsElement>(null);
  useEffect(()=>{
    if(!open)return;
    const dismissOutside=(event:PointerEvent)=>{if(event.target instanceof Node&&!pickerRef.current?.contains(event.target))setOpen(false)};
    const dismissWithKeyboard=(event:KeyboardEvent)=>{if(event.key==="Escape")setOpen(false)};
    document.addEventListener("pointerdown",dismissOutside);document.addEventListener("keydown",dismissWithKeyboard);
    return()=>{document.removeEventListener("pointerdown",dismissOutside);document.removeEventListener("keydown",dismissWithKeyboard)};
  },[open]);
  const filtered=useMemo(()=>works.filter((work)=>{const haystack=[work.title,work.alternateTitle,work.authorName,work.originRegion,work.publicationYear,work.category,work.mapLayer].join(" ").toLocaleLowerCase();return(!query||haystack.includes(query.toLocaleLowerCase()))&&(category==="all"||work.category===category)}),[category,query,works]);
  const labels=locale==="zh-CN"?{choose:"作品控制中心",search:"搜索名称、作者、地区、年代或类型",all:"全部类型",single:"单部探索",multi:"多部对照",primary:"主作品",limit:"已达 5 部上限；请先移除一部。",counts:"人物 / 事件 / 地点"}:{choose:"Work control centre",search:"Search title, author, region, era, or type",all:"All categories",single:"Single exploration",multi:"Compare works",primary:"Primary",limit:"Five-work limit reached; remove one first.",counts:"people / events / places"};
  return <details ref={pickerRef} className="picker" open={open} onToggle={(event)=>setOpen(event.currentTarget.open)}><summary>{labels.choose} · {selected.length}/{mode==="multi"?MAX_SELECTED_WORKS:1}</summary><div className="picker-panel">
    <div className="mode"><button className={mode==="single"?"active":""} onClick={()=>onMode("single")}>{labels.single}</button><button className={mode==="multi"?"active":""} onClick={()=>onMode("multi")}>{labels.multi} ≤ {MAX_SELECTED_WORKS}</button></div>
    <div className="selected-chips">{selected.map((slug)=>{const work=works.find((item)=>item.slug===slug);return work?<span key={slug} className={slug===active?"active":""} style={{borderColor:work.themeColor}}><button onClick={()=>onActive(slug)} aria-label={`${labels.primary}: ${work.title}`}>{work.title}</button><button onClick={()=>onToggle(slug)} aria-label={`Remove ${work.title}`}>×</button></span>:null})}</div>
    <div className="picker-filters"><input value={query} onChange={(event)=>setQuery(event.target.value)} placeholder={labels.search} aria-label={labels.search}/><select value={category} onChange={(event)=>setCategory(event.target.value)}><option value="all">{labels.all}</option>{[...new Set(works.map((work)=>work.category))].map((value)=><option key={value} value={value}>{value.replaceAll("_"," ")}</option>)}</select></div>
    <div className="work-list">{filtered.map((work)=>{const checked=selected.includes(work.slug);const disabled=mode==="multi"&&!checked&&selected.length>=MAX_SELECTED_WORKS;return <label key={work.slug} className={disabled?"disabled":""}><input type={mode==="single"?"radio":"checkbox"} name="work" checked={checked} disabled={disabled} onChange={()=>onToggle(work.slug)}/><i style={{background:work.themeColor}}/><span><strong>{work.title}</strong><small>{work.alternateTitle} · {work.authorName}</small><small>{work.category.replaceAll("_"," ")} · {work.originRegion} · {work.characterCount}/{work.eventCount}/{work.locationCount} {labels.counts}</small></span>{checked&&<button type="button" className={active===work.slug?"primary active":"primary"} onClick={(event)=>{event.preventDefault();onActive(work.slug)}}>{labels.primary}</button>}</label>})}</div>
    {mode==="multi"&&selected.length>=MAX_SELECTED_WORKS&&<p className="selection-error">{labels.limit}</p>}{error&&<p className="selection-error">{error}</p>}
  </div></details>;
}
