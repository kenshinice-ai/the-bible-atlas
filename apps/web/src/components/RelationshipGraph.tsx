import { useMemo, useState } from "react";
import { relationVisibleAtSequence, type SelectedEntity } from "../state";
import type { Atlas, Locale } from "../types";

interface Props{atlas:Atlas;locale:Locale;until:number;selected:SelectedEntity|null;onSelect:(entity:SelectedEntity)=>void;onSequence:(sequence:number)=>void}
const genderShape={male:"M4 4h12v12H4z",female:"M10 2a6 6 0 1 0 0 12 6 6 0 0 0 0-12zm0 12v5m-3-2h6",unknown:"M3 10a7 7 0 1 0 14 0 7 7 0 0 0-14 0z",na:"M3 3h14v14H3z"} as const;
function activate(event:React.KeyboardEvent<SVGGElement>,action:()=>void){if(event.key==="Enter"||event.key===" "){event.preventDefault();action()}}

/** Small-data accessible relationship graph; lifecycle filtering follows narrative events. */
export function RelationshipGraph({atlas,locale,until,selected,onSelect,onSequence}:Props){
  const[directOnly,setDirectOnly]=useState(false);
  const selectedCharacter=selected?.type==="character"?selected.id:null;
  const relations=atlas.relations.filter((relation)=>relationVisibleAtSequence(relation,atlas.events,until)).filter((relation)=>!directOnly||!selectedCharacter||relation.fromSlug===selectedCharacter||relation.toSlug===selectedCharacter);
  const slugs=useMemo(()=>{const linked=new Set(relations.flatMap((relation)=>[relation.fromSlug,relation.toSlug]));return atlas.characters.filter((person)=>!directOnly||!selectedCharacter||person.slug===selectedCharacter||linked.has(person.slug))},[atlas.characters,directOnly,relations,selectedCharacter]);
  const positions=new Map(slugs.map((person,index)=>{const angle=(Math.PI*2*index)/Math.max(slugs.length,1)-Math.PI/2;return[person.slug,{x:50+38*Math.cos(angle),y:50+38*Math.sin(angle)}]}));
  return <section className="relationship-graph"><div className="graph-tools"><button onClick={()=>setDirectOnly(!directOnly)}>{directOnly?(locale==="zh-CN"?"显示全图":"Show all"):(locale==="zh-CN"?"只看直接关系":"Direct only")}</button><label>{locale==="zh-CN"?"关系时间":"Relationship time"}<input type="range" min="1" max={Math.max(atlas.events.length,1)} value={Math.min(until,atlas.events.length)} onChange={(event)=>onSequence(Number(event.target.value))}/></label></div>
    <svg viewBox="0 0 100 100" role="img" aria-label={locale==="zh-CN"?`${slugs.length} 人、${relations.length} 条关系`:`${slugs.length} people and ${relations.length} relationships`}>
      {relations.map((relation)=>{const from=positions.get(relation.fromSlug);const to=positions.get(relation.toSlug);if(!from||!to)return null;const choose=()=>onSelect({type:"relationship",workSlug:atlas.work.slug,id:relation.id});return <g key={relation.id} className={`graph-edge ${relation.sentiment}`} onClick={choose} onKeyDown={(event)=>activate(event,choose)} role="button" tabIndex={0}><line x1={from.x} y1={from.y} x2={to.x} y2={to.y} strokeWidth={.35+relation.strength*.12} strokeDasharray={relation.sentiment==="negative"?"2 1":undefined}/><text x={(from.x+to.x)/2} y={(from.y+to.y)/2}>{relation.label}</text><title>{relation.label}: {relation.summary}</title></g>})}
      {slugs.map((person)=>{const point=positions.get(person.slug)!;const active=selectedCharacter===person.slug;const choose=()=>onSelect({type:"character",workSlug:atlas.work.slug,id:person.slug});return <g key={person.slug} transform={`translate(${point.x} ${point.y})`} className={`graph-node ${active?"selected":""}`} onClick={choose} onKeyDown={(event)=>activate(event,choose)} role="button" tabIndex={0}><circle r={5+person.importance*.45} style={{fill:atlas.work.themeColor}}/><path d={genderShape[person.gender]} transform="translate(-3 -3) scale(.3)"/><text y="9" textAnchor="middle">{person.name}</text><title>{person.name} · {person.roleType}</title></g>})}
    </svg></section>;
}
