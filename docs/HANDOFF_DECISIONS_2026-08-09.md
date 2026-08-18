# Handoff 决策补充 · 2026-08-09

本文件记录 Bible visual pilot 的执行决策与证据边界。它不代表 production 已更新，也不代表全站媒体策展已经完成。

## 1. 本轮冻结范围

- 只做 3 条视觉媒体：1 位人物、1 个事件、1 个地点。
- 试点媒体均来自 Wikimedia Commons，且只选择本地可再发布的 Public Domain 资产。
- 本地目录固定为 apps/web/public/media/bible/；每条媒体必须由 seed 引用，不能依赖未审计的远程 img。
- 人物、事件、地点共用 VisualMedia 展示契约，保留外链-only 的安全降级。

## 2. 语义与权利决策

- character_depiction = 人物形象示意，不是历史肖像，也不是 canonical likeness。
- event_scene = 事件场景示意，不是现场照片或 eyewitness documentation。
- place_view = 指定地点的 documentary view；现代照片不等于古代场景或考古复原。
- depiction_status 只描述图像与实体的展示关系，不提高事件真实性、历史年代或地点识别的置信度。
- Public Domain、CC0、CC BY、CC BY-SA 是当前 bundled 白名单；许可证、作者、来源、署名、双语 alt、provenance 或 checksum 任一未核验时，必须 external-link-only。

## 3. P0/P1/P2 实施决策

- P0 文案与状态：中文 origin region 使用本地化标签；Bible reference/source labels 使用书卷映射；时间轴同时显示 dated、undated 和 total；窄屏时间轴保持可滚动且不制造页面级横溢出。
- P1 数据/API：media_assets 增加 media_role 与 depiction_status；atlas API 公开这两个字段；Web Zod contract 与抽屉展示同步。
- P2 视觉：先验证人物、事件、地点三种语义，不扩散到批量下载；先建立可重复 verifier，再决定下一批。

## 4. 证据边界与交接

- 本地候选、隔离数据库、静态构建和公开 production 是四个不同证据层级；本轮只推进到本地候选/验证。
- 公开站点 https://bible-atlas-6h7.pages.dev/ 没有重新部署，线上旧 bundle 不应被写成包含本轮图片或 UI 的版本。
- 当前分支仍为 main。Git 检查点 codex/bible-visual-pilot-20260809 因 iCloud 工作区 .git/refs 无法创建目录而失败；没有绕过权限、没有提交、没有推送。
- 一次验证已完成，结果和证据层级写入 docs/BIBLE_VISUAL_PILOT_2026-08-09.md；下一步仍须先建立可写 Git 检查点，再单独评估提交、独立静态构建和线上发布。
- 当前剩余技术观察项：静态构建主 JS minified chunk 约 666 KB，虽不阻断本轮试点，但应在下一轮做 code-splitting/媒体懒加载测量。
