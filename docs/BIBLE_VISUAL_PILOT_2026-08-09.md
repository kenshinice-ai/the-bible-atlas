# Bible visual pilot · 2026-08-09

## 结论

本轮完成一个最小可验证视觉闭环：人物、事件、地点各 1 条视觉媒体。三张图片均为本地 bundled Public Domain 资产；角色、语义状态、来源、署名、双语 alt text、许可 URL、retrieved_at 和 SHA-256 均进入数据契约。试点只完成到本地候选，未部署线上。

## 范围与边界

- P0：修复审计中发现的中文 origin/reference/count 标签泄漏；为窄屏时间轴提供明确的横向滚动容器；人物、事件、地点抽屉统一显示视觉媒体上下文。
- P1：把媒体从 artwork-only 扩为带语义角色的通用视觉媒体，并保留 fail-closed 权利路径。
- P2：只选择 3 个高辨识度样本验证内容—数据—UI—权利链路，不以试点数量推断全站策展完成。
- 不做：不把古典绘画当历史肖像，不把叙事版画当现场证据，不把现代地点照片当古代复原，不从生产站点抓取图片，不部署。

## 试点资产

| 实体 | 本地文件 | Commons 文件页 | 角色 / 状态 | 权利 |
|---|---|---|---|---|
| Abraham | /media/bible/abraham-three-angels.jpg | [012.Abraham and the Three Angels](https://commons.wikimedia.org/wiki/File:012.Abraham_and_the_Three_Angels.jpg) | character_depiction / illustrative | Gustave Doré · Public Domain |
| Flood narrative ends at Ararat | /media/bible/great-flood.jpg | [007.The Great Flood](https://commons.wikimedia.org/wiki/File:007.The_Great_Flood.jpg) | event_scene / illustrative | Gustave Doré · Public Domain |
| Jerusalem | /media/bible/jerusalem-western-wall.jpg | [Jerusalem Western Wall BW 1](https://commons.wikimedia.org/wiki/File:Jerusalem_Western_Wall_BW_1.JPG) | place_view / documentary | Berthold Werner · Public Domain |

The seed records both the Commons source page and the Wikimedia upload URL.
The three local checksums are enforced by
scripts/verify_bible_visual_media.ts; the verifier also rejects missing files,
stale files, incomplete bilingual provenance, non-HTTPS source URLs and
non-whitelisted licences.

## 实现面

- Schema: db/migrations/019_media_visual_context.sql
- Seed: db/seeds/063_bible_visual_media_pilot.sql
- API: apps/api/src/app.ts
- Web contract/i18n: apps/web/src/types.ts, apps/web/src/i18n.ts
- Drawer: apps/web/src/components/EntityDrawer.tsx
- Timeline/graph localization: apps/web/src/components/TimelineRibbon.tsx, apps/web/src/hierarchy.ts, apps/web/src/components/RelationGraph.tsx
- Responsive behavior: apps/web/src/styles.css
- Verification command: npm run verify:bible-visual-media

## 验证记录

本轮一次完整验证已完成，使用临时数据库 literary_atlas_bible_visual_pilot_20260809（PostgreSQL 18.4 / PostGIS 3.6）、临时 API 44032 和静态预览 55173：

- fresh bootstrap：migration 001–019、seed 001–063 全部装载；repeat bootstrap 全部报告 already applied。
- npm run verify:bible-visual-media：3/3 bundled Public Domain 图片、语义角色/状态、provenance、双语来源和 SHA-256 通过。
- npm run typecheck：API/Web 通过；npm test：API 5 + Web 33 全部通过；npm run build：通过。
- npm run verify:postgis：v3.0→v3.1 upgrade、全量既有 profile、API smoke、双语搜索与 fallback 通过；git diff --check 通过。
- 浏览器抽检：英文 Abraham 人物抽屉、Ararat 事件抽屉、Jerusalem 地点抽屉，以及中文 Jerusalem 地点抽屉均显示本地图片、语义免责声明、署名、来源/许可链接；console error/warn 为 0。
- 390px 抽检：viewport 390×844，body/document scrollWidth 均为 390；时间轴容器 clientWidth 336、scrollWidth 760，页面无横向溢出；人物/事件/地点媒体仍可见。

证据边界：以上都是本地候选/临时数据库/静态预览证据。公开站点未重新部署，不能据此宣称 production 已包含本轮变更。构建仍提示主 JS minified chunk 约 666 KB 超过 500 KB 建议阈值，列为下一轮性能收口项。

## Handoff

- 公开站点：[The Bible Atlas](https://bible-atlas-6h7.pages.dev/) 未改变，仍是本轮之前的线上版本。
- 本地候选与 production 分开记录；本轮不部署。
- 当前分支仍为 main。创建 codex/bible-visual-pilot-20260809 检查点因 iCloud .git/refs 权限错误失败，未强行修改 Git refs。
- 下一批视觉媒体必须复用本契约，逐批人工核对来源与语义，不把“公开可见”当作“可再发布”。
