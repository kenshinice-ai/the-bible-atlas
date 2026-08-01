# Handoff 决策补充 · 2026-08-02

这是欧洲美术史 R7 人物统一阶段的执行记录；以本文件、`docs/HANDOFF.md` 和最终 Git 提交为准。

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
- `npm test` 的 API listen 测试在受限沙箱中需要外部本地 socket 权限；提权后再执行完整测试并记录结果。
- API 已验证 atlas/detail/search：艺术史 atlas 返回 48 人物、48 艺术家、96 作品、96 事件、18 关系；搜索“提香”只返回一个 canonical character。
- 下一步：提权执行完整测试/生产构建，使用独立 API 烘焙 `european-art-history`，完成浏览器中英切换、人物→关系→作品、旧深链接与 390px 验收，再发布 Cloudflare Pages 并补写 URL/deployment/hash。

## 保护边界

- 不修改圣经、三国、银河原力内容和既有 seed；不为它们补时间或关系数据。
- 不将艺术家完整姓名或爵位写进艺术史事件的历史时代语言；现代称谓保存在独立字段。
- 艺术文本只保存原创摘要与结构化事件，不收录受版权保护的大段原文。
