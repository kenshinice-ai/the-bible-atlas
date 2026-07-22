import { useMemo } from "react";
import { formatHistoricalYear, historicalSortValue, type SelectedEntity, type TimelineMode } from "../state";
import type { Atlas, AtlasEvent, Locale } from "../types";

interface Props{
  atlases:Atlas[];activeAtlas:Atlas;locale:Locale;mode:TimelineMode;rangeStart:number;rangeEnd:number;until:number;
  onMode:(mode:TimelineMode)=>void;onRange:(start:number,end:number)=>void;onNarrative:(sequence:number)=>void;onSelect:(entity:SelectedEntity)=>void;
}
interface TimelineEvent{event:AtlasEvent;atlas:Atlas}

function bucketSize(span:number):number{if(span>1000)return 100;if(span>200)return 20;if(span>50)return 5;return 1}
function eventYear(event:AtlasEvent):number|null{return event.historicalStartYear}
function bucketStart(year:number,size:number):number{return year>0?Math.floor((year-1)/size)*size+1:Math.floor(year/size)*size}
function activate(event:React.KeyboardEvent<SVGGElement>,action:()=>void){if(event.key==="Enter"||event.key===" "){event.preventDefault();action()}}

/** Accessible SVG timeline with explicit BCE/CE, uncertainty, density, zoom, and pan. */
export function WorldTimeline({atlases,activeAtlas,locale,mode,rangeStart,rangeEnd,until,onMode,onRange,onNarrative,onSelect}:Props){
  const historical=useMemo(()=>atlases.flatMap((atlas)=>atlas.events.map((event)=>({atlas,event}))).filter((item)=>eventYear(item.event)!==null).sort((a,b)=>historicalSortValue(eventYear(a.event))-historicalSortValue(eventYear(b.event))),[atlases]);
  const narrative=activeAtlas.events.map((event)=>({atlas:activeAtlas,event}));
  const items=mode==="history"?historical.filter(({event})=>{const year=eventYear(event);return year!==null&&year>=rangeStart&&year<=rangeEnd}):narrative;
  const min=mode==="history"?rangeStart:1;const max=mode==="history"?rangeEnd:Math.max(activeAtlas.events.length,1);const span=Math.max(max-min,1);
  const x=(value:number)=>40+((value-min)/span)*920;
  const buckets=useMemo(()=>{if(mode!=="history")return[];const size=bucketSize(rangeEnd-rangeStart);const map=new Map<number,TimelineEvent[]>();for(const item of historical){const year=eventYear(item.event);if(year===null||year<rangeStart||year>rangeEnd)continue;const start=bucketStart(year,size);map.set(start,[...(map.get(start)??[]),item])}return[...map].sort((a,b)=>a[0]-b[0]).map(([start,events])=>({start,end:start+size-1,events}))},[historical,mode,rangeEnd,rangeStart]);
  const maxDensity=Math.max(1,...buckets.map((bucket)=>bucket.events.length));
  function zoom(factor:number){const centre=(rangeStart+rangeEnd)/2;const half=Math.max(5,((rangeEnd-rangeStart)/2)*factor);const nextStart=Math.round(centre-half);const nextEnd=Math.round(centre+half);onRange(nextStart===0?-1:nextStart,nextEnd===0?1:nextEnd)}
  function pan(direction:-1|1){const shift=Math.max(1,Math.round((rangeEnd-rangeStart)*.25))*direction;let start=rangeStart+shift;let end=rangeEnd+shift;if(start<=0&&end>=0){start-=1;end-=1}onRange(start,end)}
  return <section className="world-timeline" aria-label={locale==="zh-CN"?"世界历史时间轴":"World history timeline"}>
    <header><div><p className="eyebrow">{locale==="zh-CN"?"BCE 至现代":"BCE to modern"}</p><h2>{locale==="zh-CN"?"世界时间轴":"World timeline"}</h2></div><div className="timeline-modes"><button className={mode==="history"?"active":""} onClick={()=>onMode("history")}>{locale==="zh-CN"?"历史时间":"History"}</button><button className={mode==="narrative"?"active":""} onClick={()=>onMode("narrative")}>{locale==="zh-CN"?"叙事顺序":"Narrative"}</button></div></header>
    {mode==="history"&&<div className="timeline-tools"><button aria-label="pan earlier" onClick={()=>pan(-1)}>←</button><button aria-label="zoom in" onClick={()=>zoom(.5)}>＋</button><button aria-label="zoom out" onClick={()=>zoom(2)}>−</button><button aria-label="pan later" onClick={()=>pan(1)}>→</button><button onClick={()=>onRange(-3000,2026)}>{locale==="zh-CN"?"完整范围":"Full range"}</button><output>{formatHistoricalYear(rangeStart,locale)} — {formatHistoricalYear(rangeEnd,locale)}</output></div>}
    <div className="timeline-scroll" tabIndex={0}><svg viewBox="0 0 1000 210" role="img" aria-label={locale==="zh-CN"?`当前显示 ${items.length} 个事件`:`${items.length} events shown`}>
      <line x1="40" y1="142" x2="960" y2="142" className="axis"/>
      {mode==="history"&&buckets.map((bucket)=>{const left=x(bucket.start);const right=x(Math.min(bucket.end,rangeEnd));const height=54*(bucket.events.length/maxDensity);const choose=()=>{onRange(bucket.start,bucket.end);const first=bucket.events[0];if(first)onSelect({type:"event",workSlug:first.atlas.work.slug,id:first.event.slug})};return <g key={bucket.start} className="density" onClick={choose} onKeyDown={(event)=>activate(event,choose)} role="button" tabIndex={0}><rect x={left} y={132-height} width={Math.max(3,right-left-1)} height={height} style={{fill:bucket.events[0]?.atlas.work.themeColor}}/><title>{bucket.events.length} events · {formatHistoricalYear(bucket.start,locale)}</title></g>})}
      {items.map(({event,atlas},index)=>{const value=mode==="history"?(eventYear(event)??min):event.sequence;const cx=x(value);const uncertain=event.timeType!=="exact";const choose=()=>{if(mode==="narrative")onNarrative(event.sequence);onSelect({type:"event",workSlug:atlas.work.slug,id:event.slug})};return <g key={`${atlas.work.slug}:${event.slug}`} transform={`translate(${cx} ${150+(index%3)*16})`} className={`timeline-node ${uncertain?"uncertain":"exact"} ${mode==="narrative"&&event.sequence>until?"muted":""}`} onClick={choose} onKeyDown={(keyEvent)=>activate(keyEvent,choose)} role="button" tabIndex={0}><circle r="6" style={{fill:uncertain?"transparent":atlas.work.themeColor,stroke:atlas.work.themeColor}}/><text y="18" textAnchor="middle">{index%2===0?event.title.slice(0,16):""}</text><title>{atlas.work.title} · {event.title} · {event.timeLabel||event.timeType}</title></g>})}
      <text x="40" y="30" className="timeline-summary">{mode==="history"?`${formatHistoricalYear(rangeStart,locale)} — ${formatHistoricalYear(rangeEnd,locale)}`:`${activeAtlas.work.title} · ${items.length}`}</text>
    </svg></div>
  </section>;
}
