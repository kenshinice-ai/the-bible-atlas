# Handoff 决策补充 · 2026-08-02

这是欧洲美术史 R9/R10 内容扩充阶段的执行记录；R8 作品媒体与 R7 人物统一决策仍保留在下方。以本文件、`docs/HANDOFF.md` 和最终 Git 提交为准。

## R9/R10 内容与媒体阶段（2026-08-02，最终门禁与部署进行中）

### 内容冻结

- 只增加艺术史叙事中的重要人物，不按数量补次要人物；总量冻结为 82 位 canonical 人物/艺术家与 200 件作品。
- 8 个创作时期按纪律配额归一；新增第 9 个 event-first 章节“战后传播、修复与遗产治理”，不为填满栏目而增加仍在版权期的战后艺术家。
- 新增 18 条 1945–2024 的博物馆、修复、返还、数字化与遗产治理事件；chronology 结构延伸到 2026。
- 200 件作品均补齐中英文原创 summary 与 description；description 用于适量背景说明，不复制馆藏长文。

### 数据与媒体门禁

- 隔离数据库 `literary_atlas_eah_full_20260802`：82 artists / 82 characters / 200 artworks / 218 events / 9 chapters / 23 movements / 36 relations。
- 纪律检查全部为 0：zero-work artist、artist/character 未映射、双语作品缺失、作品事件孤儿、事件来源孤儿、事件地点孤儿。
- 200/200 作品具有一条 media link：160 bundled verified、40 external-only pending；160 个本地文件与数据库 SHA-256 完全一致。
- Commons 导入器除 Public Domain、CC0、CC BY、CC BY-SA 白名单外，新增匿名作品空值保护、API/图片网络重试、断点续跑、作者身份匹配和失败关闭。
- 人工复核发现的 21 个近似候选（临摹、局部习作、复制品、邮票图或其他作品）全部进入 `FORCE_EXTERNAL_SLUGS`，不复制、不渲染为目标原作；媒体目录已清除 28 个最终 Seed 未引用的临时文件。

### 当前状态

- 已生成：`055_european_art_disciplined_expansion.sql` 与 `056_european_art_expansion_media.sql`。
- 已通过：扩充 Seed 隔离装载、内容计数/闭环门禁、生成器无漂移、fresh database 001–056 完整 bootstrap、repeat bootstrap、`typecheck`、API 5 + Web 32 tests、production build、`verify:postgis`、`verify:artwork-media`、start-command 与 Docker config。
- 静态双语 JSON 已验证 82/82/200/218/9/23/36/200，160 bundled + 40 external，description 缺失 0，chronology end 2026；构建哈希为 `8242cc5b…e90e` / `527466da…0d96` / `448ddb73…c17`。
- 本地 in-app browser 对 `127.0.0.1` 被环境安全策略拒绝，未将本地 UI 误记为已验收；尚待 Git 提交/推送、Cloudflare Pages 发布，并在公开 production URL 完成桌面/390px 浏览器与线上数据验收。

## R8 作品媒体与发布（2026-08-02）

### 决策

- 每件作品保留一条 `media_links(entity_kind='artwork')`；作品详情抽屉按 `media_kind` 决定渲染本地图片或外部来源页。
- Wikimedia Commons 只有在元数据明确为 Public Domain、CC0、CC BY 或 CC BY-SA 时才进入生产图片白名单；本地文件固定为 960px 缩略图并记录作者、署名、来源页、许可页、原始 URL、抓取时间和 SHA-256。
- Google Arts & Culture 只作为研究线索或外部提供方参考，不从其可见页面推断再发布许可；没有单独可复用许可时只能 `external_link + pending`。
- `portuguese-braque` 与 `violin-and-candlestick` 没有通过 Commons 开放许可门禁，保留官方 Braque 页面外链，不复制或渲染图片。

### 实现与门禁

- Migration：`db/migrations/011_artwork_media_rights.sql`
- Seed：`db/seeds/054_european_artwork_media.sql`
- 导入器：`scripts/import_commons_artwork_media.ts`
- 验证器：`scripts/verify_artwork_media.ts`（`npm run verify:artwork-media`）
- 96/96 作品各有一条媒体记录：94 条 `image + bundled + verified`，2 条 `external_link + pending`；94 个本地图片文件与数据库 checksum 全部一致，目录无残留或缺失文件。
- 每条媒体均有中英文 published source translation、`artwork_sources` provenance、HTTPS 来源/原始 URL、作者、署名和中英文 alt text。
- API atlas（隔离 PostgreSQL 18 + PostGIS）返回 48 艺术家、96 作品、96 事件、96 媒体；中英文 alt text 随 locale 切换。

### 浏览器与发布

- 静态构建 `apps/web/dist` 已烘焙双语 JSON 和 94 个图片文件；作品抽屉显示图片、署名、许可链接和来源页；外链作品显示不复制图片提示；英文切换保留当前作品；390px 视口 `body.scrollWidth === innerWidth`，作品图片加载成功，控制台 error/warn 为 0。
- 完整门禁通过：`npm run typecheck`、`npm test`（API 5 + Web 32）、`npm run build`、`npm run test:start-command`、`docker compose config --quiet`、`npm run verify:postgis`、`npm run verify:artwork-media`。
- Cloudflare Pages production `main` 已发布：[`https://european-art-history-atlas.pages.dev`](https://european-art-history-atlas.pages.dev)，deployment `a23e6912-c11e-4b29-8269-f5328fc89c53`，预览地址 `https://a23e6912.european-art-history-atlas.pages.dev`，Source `3ca34e5`。
- 线上探针通过：首页与 deployment URL HTTP 200；`atlas.european-art-history.zh-CN.json` 返回 48 艺术家、96 作品、96 事件、96 媒体，其中 94 条 `bundled + verified`、2 条 external；`media/artworks/mona-lisa.jpg` 返回 HTTP 200、`image/jpeg`。
- 静态构建 SHA-256：`index.html` `0c8a0950f135b86be6a00fe30fe84cfec85954718cdc1015b55bfa38efcda325`；`index-CBruIyTh.js` `0b712f6c0b6150f95504a259127e5fbe9512627f3315de7fde7b7b745fa60b52`；`index-C4eyKGdp.css` `a10fff2f82a506b7f7e817722f55b6ba433a0de06713db1f2f05d547f7b7f95f`。
- R8 实现提交：`3ca34e533dbd6b1848cf12849e865d8a27b39afb`。源码包 `release/European-Art-History-Atlas-R8-20260802-source.zip` 已在生产 deployment 记录写入后重新生成并通过压缩完整性检查，SHA-256 `09a8a2c6f825dceb4975950a79893ab5eb08eb43824612caf0c81190a6d085c5`；三个既有 profile 的 seed、静态产物和生产站点不重烘焙。

## 决策

- 艺术家与人物不是两个互不相干的图节点。命名为人的艺术家统一映射到 `characters`，`artists` 保留为艺术史专业扩展表。
- `artists.character_id` 是唯一 canonical 映射；部分工坊、集体或匿名大师未来仍可保留在 `artists` 而不伪造个人身份。
- 人物关系、事件参与、地点关联、来源关联和搜索以 `characters` 链为公共逻辑；作品、流派、艺术目录信息继续从 `artists` 链读取。
- `artist_translations.full_name` 是完整历史姓名，`aliases` 保留简短目录名；`formal_titles` 只保存有来源支撑的爵位、骑士勋章或荣誉称号。没有可靠称号时使用空数组，禁止用现代地位/时期称谓冒充爵位。
- 艺术史站点人物页签不再展示重复的艺术家页签；旧 `artist:` 深链接兼容归一为同一 `character:` 人物。

## 实现

- Migration：`db/migrations/010_artist_person_unification.sql`
- Seed：`db/seeds/053_european_art_people_unification.sql`
- API：人物返回 `artistSlug`；艺术家返回 `characterSlug`、`fullName`、`aliases`、`formalTitles`；艺术史搜索排除重复的 artist 结果。
- Web：艺术史人物列表使用 canonical character；人物抽屉显示完整姓名、现代地位、时期称谓、正式爵位/荣誉称号和作品；作品入口与旧链接自动归一。

## 数据门禁

在隔离 PostgreSQL 18 + PostGIS 数据库 `literary_atlas_artist_person_audit_20260802` 上：

- 48/48 位艺术家具备 `character_id`，无空映射；48/48 人物有 zh-CN 与 en published 翻译。
- 48/48 艺术家双语 `full_name` 非空；5 位艺术家（10 条双语翻译）有明确 `formal_titles`，其余为空数组。
- 96 件作品对应 96 个生命周期事件；镜像后人物链有 96 条事件参与、43 条地点关联、48 条来源关联。
- 18 条人物关系、36 条双语关系翻译均有具体 label/summary；重复 bootstrap 不新增行。
- 既有圣经、三国、银河原力 seed 文件未修改，既有站点不重烘焙。

## 验证与发布

- 已通过 `npm run typecheck`。
- `npm test` 已通过：API 5 tests、Web 31 tests；`npm run typecheck`、`npm run build`、`npm run verify:postgis` 均通过。
- API 已验证 atlas/detail/search：艺术史 atlas 返回 48 人物、48 艺术家、96 作品、96 事件、18 关系；搜索“提香”只返回一个 canonical character；所有新增人物/关系 UUID 均符合 RFC-4122 版本/变体约束。
- 最终静态包已完成桌面与 390px 浏览器验收：中英文切换保留人物/关系状态，旧 `artist:` 深链接归一为 `character:`，人物抽屉显示完整姓名/爵位，关系图显示 48 节点/18 连线，群体层在无群组 profile 中禁用，控制台无 error/warn，横向溢出为 0。
- Cloudflare Pages production 已发布：`https://european-art-history-atlas.pages.dev`，deployment `d3b92eb0`；预览地址 `https://d3b92eb0.european-art-history-atlas.pages.dev`；线上双语静态 JSON 返回 48 人物 / 48 艺术家 / 96 作品 / 96 事件 / 18 关系。
- 源码包：`release/European-Art-History-Atlas-R7-20260802-source.zip`；SHA-256 `12daad4d94ea6d5229d8223c2cce3c71fd47abef9d43b7d5460b958f6288765b`；实现提交 `5229286`，最终 handoff 提交 `d0417ea`。

## 保护边界

- 不修改圣经、三国、银河原力内容和既有 seed；不为它们补时间或关系数据。
- 不将艺术家完整姓名或爵位写进艺术史事件的历史时代语言；现代称谓保存在独立字段。
- 艺术文本只保存原创摘要与结构化事件，不收录受版权保护的大段原文。
