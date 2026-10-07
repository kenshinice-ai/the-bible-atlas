# CLAUDE.md · the-bible-atlas

## 写作规则 · STE-lite v1

适用：操作步骤、发布和回滚、交接（HANDOFF、「等 Lee」）、警告、写给其他会话的说明。

1. 一步一个动作。动词在前。条件放在句首：「如果……，就……」。
2. 句长：中文不超过 40 字，英文不超过 20 词。代码、路径、命令不计。
3. 每一步写成功判据：期望的输出、状态码或版本号。`healthy`、退出码 0 不算证据，除非写明它证明了什么。
4. 警告用 `> ⚠️`。第一句写做什么或不做什么，第二句写不照做的后果，然后写原因。一个警告只讲一个危险。
5. 用主动语态。待办写明负责人。
6. 一词一义：只用本仓库术语表里的词。一个新词有两个意思时，先拆成两个词，再写进表里。
7. 会变的值带日期：「2026-10-03 实测」。没核实的写「未核实」，并写原因。没做的不写成已做。
8. 步骤、原因、事故经过分开放。事故经过不打断步骤。

不适用：
- 说明和原因段：不限句长，但第一句给结论。
- 历史日志（*-LOG.md、按日期记的流水）：保留原样。
- 产品文案和品牌文案（任何语言）、App Store 文案、面向访客的 AI prompt。
- 交接文件里「等 Lee」条目的格式：沿用全局约定，这里不改。
- TTS 旁白和配音稿：不拆句（qwen-tts 实测：拆句 10 次全败）。
- 经文、古籍、文化内容。

旧文档不批量改写。你改哪一节，就按规则整理哪一节。

## 本仓库的范围

- 适用：`docs/DEPLOYMENT.md`、`docs/HANDOFF.md`、`docs/HANDOFF_DECISIONS_*.md`、`blueprint/PIPELINE.md`。
- 不适用：经文、文学文本、界面文案、`.claude/agents/` 的评审语体。

## 术语表

| 用这个 | 意思（只有这一个） | 不要用 |
|---|---|---|
| the-bible-atlas | 本仓库（`kenshinice-ai/the-bible-atlas`），含圣经和其他 profile | Literary Atlas、世界文学名著时空地图（旧名）。`literary_atlas`、`@literary-atlas/*` 只作数据库名和包名 |
| profile | 一套独立构建、独立发布的前端和静态站配置，如 `bible`、`three-kingdoms`、`galaxy`、`european-art-history` | 档 |
| 作品（work） | `works` 表的一行，如 `the-bible`。一个 profile 可含多部作品 | 作品（指美术品时） |
| 艺术品（artwork） | 欧洲美术史 profile 里的一件美术作品 | 作品 |
| 时代（era） | 圣经 profile 的 13 个叙事分期，库里存为 `chapters` 表的行 | 章节、chapter（指圣经时代时） |
| 和合本（1919，繁体） | 名言卡和经文引用所用的 1919 年繁体版，逐字核验 | 单写「和合本」 |
| 和合本·新标点 | 时代题词所用的新标点简体版 | 单写「和合本」 |
| World English Bible（WEB） | 英文经文的唯一用本 | KJV（已排除：英国 Crown copyright） |
| 本地栈 | macOS Homebrew PostgreSQL 加 `Start-Bible-Atlas.command` 的本地运行方式 | 方案 A |
| Docker 旧栈 | `docker compose` 起的本地全栈 | 方案 B |
| VPS 全栈方案 | `deploy/deploy.sh` 加 `deploy/docker-compose.prod.yml` 的服务器部署方案 | 方案 A |
| 静态站 | `deploy/deploy-static.sh` 烘焙双语 JSON 后静态构建，发布到 Cloudflare Pages | 方案 C |
