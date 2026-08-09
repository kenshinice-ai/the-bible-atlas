# 欧洲古典音乐史 Atlas Phase 2 交接记录

日期：2026-08-09
Profile：`european-classical-music-history`
阶段：Foundation → Phase 2 扩容与学习路径

## 目标与规模

本轮按照扩展审计执行一次可回滚增量：提高时代密度，加入学习单元与首层乐谱入口，同时保持静态部署和权利边界。目标从 Foundation 的 416 个语义展示对象扩到 728 个，约 1.75 倍；新实体至少补齐中英文 published 翻译。

| 资源 | Foundation | Phase 2 目标 | 增量 |
|---|---:|---:|---:|
| 人物 | 48 | 72 | +24 |
| 曲目 | 72 | 120 | +48 |
| 风格 | 20 | 32 | +12 |
| 乐器 | 24 | 36 | +12 |
| 机构 | 16 | 24 | +8 |
| 地点 | 24 | 36 | +12 |
| 事件 | 96 | 180 | +84 |
| 人物关系 | 80 | 160 | +80 |
| 路线 | 8 | 12 | +4 |
| 乐谱片段/自产音频 | 28 | 56 | +28 |
| 学习单元 | 0 | 12 | +12 |

## 已实施内容

- `db/migrations/017_european_music_learning_units.sql`：学习单元、双语文本、曲目/片段连接和 cross-work audit view。
- `db/migrations/018_european_music_phase2_language_correction.sql`：扩展作品文本语言的可重复修正。
- `db/seeds/060_european_classical_music_phase2.sql`：Phase 2 结构化内容。
- `db/seeds/061_european_classical_music_phase2_score_fragments.sql` 与 `062_..._verovio_refresh.sql`：新增乐谱、SVG、timing、manifest 和自产中性合成音。
- `scripts/european_music_phase2_data.ts`、`scripts/generate_european_music_phase2.mjs`：可重复生成与计数断言。
- `apps/web/src/components/MusicStudyPanel.tsx`：12 个学习单元与音乐目录。
- 前端五入口、焦点管理、搜索键盘操作和响应式工作区同步更新。

## 本地证据

- 目标 profile 计数：72 人物 / 120 曲目 / 32 风格 / 36 乐器 / 24 机构 / 36 地点 / 180 事件 / 160 关系 / 12 路线 / 56 片段 / 12 学习单元。
- cross-work link audit：0 行。
- PostgreSQL `literary_atlas` 当前大小：39,024,319 bytes（约 37.2 MiB）。
- 媒体：56/56 bundle 完整，音频约 27.7 MiB；所有片段均为学习用自产合成音，不代表历史演奏或真实乐器音色。
- 390px 本地浏览器：页面 `scrollWidth === clientWidth === 390`；桌面工作区计算列为 `61.8fr / 38.2fr`；抽屉焦点陷阱、焦点恢复和搜索键盘选择通过；console 无 error/warn。

## 发布门禁

- Git：代码 release commit `d2fb145` 与最终交接 commit `a0a1ca3` 已推送到远程 `main`；工作树仅保留未跟踪的无关 `.codex/`。
- Cloudflare Pages production：[european-classical-music-history-atlas.pages.dev](https://european-classical-music-history-atlas.pages.dev)。本次 deployment `845d780b-fd9a-49ea-9f71-b983c101070e`，预览地址为 [845d780b.european-classical-music-history-atlas.pages.dev](https://845d780b.european-classical-music-history-atlas.pages.dev)，Cloudflare source 为 `d2fb145`。
- production 首页 HTTP 200；中文 JSON 679,003 bytes、英文 JSON 687,565 bytes，双语均为 72 人物 / 120 曲目 / 32 风格 / 36 乐器 / 24 机构 / 36 地点 / 180 事件 / 160 关系 / 12 路线 / 56 片段 / 12 学习单元，work slug 均为 `european-classical-music-history`。
- production 音乐媒体完整可达性：280 个唯一 MEI / SVG / timing / manifest / WAV URL 全部 HTTP 200；代表性 WAV `Content-Type: audio/wav`。
- production 浏览器：桌面 `1280px` 下工作区计算列为 `746.539px / 461.461px`，即 61.8% / 38.2%；390px 下 `scrollWidth === clientWidth === 390`；12 个学习单元、乐谱抽屉焦点陷阱/恢复、键盘搜索均通过；console 无 error/warn。
- 静态构建目录约 78M；关键 SHA-256：`index.html` `0af7094d2ba3b19fa09857c9bdd0432c95f3ac42302be4ca931b070a8772a804`，JS `d797786ab29ab15c3394e62ec227c9b0d069aafe04ebfab42fd6f11f9a568bbf`，CSS `df5b7eec681ae1fc263f95fa3a1b071ebc16f988dfb2a1be44b01f3576cc1d94`。
- 回滚点：上一版 production deployment `1e29ca49-1689-48f9-9282-344b4a9fe648` 仍保留，可在 Cloudflare Pages 控制台恢复。
