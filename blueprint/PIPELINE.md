# 内容生产流水线:代理编排剧本

> 按《圣经舆图》实战(13 时代扩充,2026-07,`docs/HANDOFF.md` 记录全程)总结的可复制阶段清单。种子写法规则见 [WORK_TEMPLATE.md](WORK_TEMPLATE.md);实例化整体步骤见 [ARCHITECTURE.md](ARCHITECTURE.md) §4。
> 核心经验:**并行生成、串行装载、全局收尾**;所有跨代理契约(UUID 前缀、slug 归属名单、sequence 分区)在派单前一次性定死。

## 阶段总览

| # | 阶段 | 代理数 | 产出 | 圣经对应物 |
|---|---|---|---|---|
| 0 | 骨架期 | 1 | works/chapters/groups/sources/锚点实体种子 | `002–008` |
| 1 | 时代并行生成 | 每时代 1 个,**每批 ≤4 并行** | `0NN_<work>_full_KK_<era>.sql` | `010–022` |
| 2 | 装载 | 主会话串行 | `seed_history` 登记 | `db-cli.ts seed` |
| 3 | 全局重排 | 1 | sequence 重排种子 | `023` |
| 4 | 关系精修 | 1–2 | 泛型标签→具体双语标签+摘要 | `024`(补救)+ `026`(精修) |
| 5 | 视觉重调 | 1 | 时代/群体色板对比度修正 | `025` |
| 6 | 详情补写 | 按缺口 | detail/motivation/significance 补齐 | (并入各时代文件) |
| 7 | 领域审计 | 1(专家人格) | 审计报告 + 修正种子 | `docs/CLERGY_AUDIT.md` + `027` |
| 8 | 烘焙部署 | 主会话 | 静态站点上线 | `deploy/deploy-static.sh --publish cf` |

## 阶段 0:骨架期(单代理或主会话)

建 works 行、launch_rank、work_chronologies、全部 chapters、全部 character_groups、全部 sources、首批锚点人物/地点/核心事件/核心关系。**群体和 sources 必须在此期建全**——后续时代代理只允许「往组里加成员、按 title JOIN source」,这是防撞名制度的一半。

## 阶段 1:时代并行生成(本流水线的主体)

### 派单前:固化共享规范 + 导出输入清单

写一份新作品版 seed-spec(以 `db/seeds/bible-seed-spec.md` 为蓝本、按 [WORK_TEMPLATE.md](WORK_TEMPLATE.md) 泛化),内嵌**从库里现导的**清单(过时清单 = slug 撞名之源):

```sql
-- 已有人物/地点(代理只能 JOIN、不得再建)
SELECT slug FROM characters WHERE work_id='<WORK_UUID>' ORDER BY slug;
SELECT slug FROM locations  WHERE work_id='<WORK_UUID>' ORDER BY slug;
-- 已有分组(只能加成员)与 sources(按 title JOIN)
SELECT slug FROM character_groups WHERE work_id='<WORK_UUID>' ORDER BY sort_order;
SELECT title FROM sources WHERE work_id='<WORK_UUID>' ORDER BY title;
-- 各时代既有事件(代理必须重排进自己的 sequence 区间,禁止重复创建)
SELECT ch.slug AS era, e.slug FROM events e JOIN chapters ch ON ch.id=e.chapter_id
WHERE e.work_id='<WORK_UUID>' ORDER BY ch.sequence, e.sequence;
```

### 每个时代代理的任务提示必须包含

1. 模板文件指路:「先完整阅读 `db/seeds/010_bible_full_01_primeval.sql`(或新作品首个已验收时代文件),严格模仿结构与 SQL 写法」;
2. 本时代 KK、chapter slug、era 年代区间、sequence 区间;
3. **人物/地点归属名单**(本时代负责创建哪些新实体——跨时代人物只由归属时代建,这是防撞名制度的另一半);
4. 可引用范围:骨架期实体 + 自建 + 编号更小时代所建;
5. 自测命令模板(回滚测试 + 孤儿检查,含 relation_translations 检查——见 [WORK_TEMPLATE.md](WORK_TEMPLATE.md) §5);**SCRATCH 路径用当前会话的可写临时目录**(圣经 spec 里留了旧会话路径的坑,HANDOFF 已记);
6. 交付标准:只报数量/测试结果/预期缺失,不贴全文。

### 批次与规模(圣经实测)

- 13 时代分 5 批装载完成,最大一批 4 代理并行;每时代产出约 15–25 个新事件 + 若干人物/地点/关系(「小步走」策略:先保最著名事件,密度以后再补)。
- 一个时代文件的典型体量:新增 12–21 人物、0–5 地点、13–21 事件、20–40 关系。

### 已知坑(每个都真实发生过)

| 坑 | 后果 | 预防 |
|---|---|---|
| 关系漏写 relation_translations | 170/272 条关系在 UI 消失,事后 `024` 回填 + `026` 精修两轮返工 | 孤儿检查加关系翻译项;spec 中给出可照抄的 SQL 块 |
| slug 跨代理撞名 | events 无 ON CONFLICT 会直接报错(好);characters 有 ON CONFLICT 会**静默吞掉**后建的版本(坏) | 归属名单 + 现导清单;装载后跑重复 slug 审计 |
| JOIN 静默丢行 | 事件缺参与者/地点/来源,界面残缺无报错 | 四条孤儿检查必须 0 行 |
| 引用编号更大时代的实体 | JOIN 丢行(装载顺序在后) | 提示中写死引用范围;测试时的「预期缺失」逐条列明并复核方向 |
| sequence 越区/非单调 | 叙事顺序错乱、until 过滤失真 | 区间制 + 阶段 3 全局重排兜底 |
| 特殊年代事件(如 patmos-vision 81–96) | 超出时代 era 区间 | 在 spec 里逐个点名处理方式(放区间末尾) |

## 阶段 2:装载(主会话,严格按编号串行)

```bash
cd apps/api && DATABASE_URL="postgresql://…" npx tsx src/db-cli.ts seed   # 幂等,seed_history 登记
```

装载后立即跑全库审计(任何一条非零即返工):

```sql
-- 每时代事件数、sequence 区间、单调性
SELECT ch.slug, ch.sequence, count(*), min(e.sequence), max(e.sequence)
FROM events e JOIN chapters ch ON ch.id=e.chapter_id WHERE e.work_id='<WORK_UUID>'
GROUP BY 1,2 ORDER BY 2;
-- 重复 sequence / 越区
SELECT sequence, count(*) FROM events WHERE work_id='<WORK_UUID>' GROUP BY 1 HAVING count(*)>1;
-- 全库孤儿(五类,同 WORK_TEMPLATE §5,把 LIKE 前缀放宽到整个作品位)
```

## 阶段 3:全局重排(1 代理)

模板 `db/seeds/023_bible_global_sequence_rebands.sql`:按(时代 sequence,时代内现序)`ROW_NUMBER` 把全作品事件重排进 `K*1000` 分区。幂等设计(保持时代内相对顺序),以后每补一批内容重跑一次即可。

## 阶段 4:关系精修(1–2 代理)

即使阶段 1 已强制具体标签,批量生产仍会残留泛型/机翻味标签。模板 `026_relation_labels_refine.sql`:导出全部关系(from_slug, to_slug, relation_type, 现 label),按批(每批约 40 条 ×2 语言)UPDATE 成具体角色对 + 一句领域口吻摘要。完成标准:两种语言泛型标签(亲属/同盟/相关…)清零:

```sql
SELECT count(*) FROM relation_translations WHERE label IN ('亲属','配偶','兄弟姐妹','同盟','对立','师承','相关','Family','Spouse','Ally','Adversary','Mentorship');
```

## 阶段 5:视觉重调(1 代理)

导出全部 chapters/groups 的 accent_color,对 `--panel #0F172A` 与标签前景色跑对比度计算(目标 ≥4.5:1),产出一个幂等 UPDATE 种子(模板 `025_bible_era_accent_retune.sql`)。**新作品建议把这一步前置到骨架期**,一次设计到位。

## 阶段 6:详情补写(按缺口派单)

审计空 detail/motivation/significance 的实体,按时代分包补写(与阶段 1 同一套自测)。圣经采用「小步走」——首轮只保 summary 齐全,detail 允许后补;缺口查询:

```sql
SELECT c.slug FROM characters c JOIN character_translations t ON t.character_id=c.id
WHERE c.work_id='<WORK_UUID>' AND t.locale='zh-CN' AND (t.detail='' OR t.motivation='');
```

## 阶段 7:领域审计(1 专家人格代理)

圣经版:神职人员标准审计(`docs/CLERGY_AUDIT.md` + `027_clergy_audit_fixes.sql`)——题词逐字对照公有领域底本、称谓/译名一致性(如「该撒利亚」拼法 8 处)、中立性口吻。**三国版对应物:史学审计**——引文逐字对照中华书局点校本之外的公有领域底本(陈寿原文/毛评本)、人名地名译名表(Wade-Giles vs pinyin 统一)、志/演义 reality 标注抽查、避免把演义情节标成 `verified_historical`。产出:审计报告 + 一个修正种子,**落库后必须重新烘焙**(圣经教训:027 落库后重烘焙,静态数据才是审计后数据)。

审计期可复用现成代理人格模板:`.claude/agents/liturgical-design-director.md`(领域专家 × 设计总监双人格),换领域重写即可。

## 阶段 8:烘焙部署(主会话)

```bash
npm run start:local                     # 本地 API+DB(烘焙数据源)
bash deploy/deploy-static.sh            # 烘焙→静态构建→产物断言(注意脚本内 slug 断言已换新作品)
npx vite preview --outDir apps/web/dist # 本地预览抽查:三视图计数与库一致、双语、深链接归正、每时代题词
bash deploy/deploy-static.sh --publish cf
```

上线检查(圣经版实测项):HTTPS、默认语言正确、实体计数与库一致、零 `/api` 请求、搜索可用、抽屉 prose 完整。

## 全程纪律

- **每阶段完成即更新 `docs/HANDOFF.md` 并随变更提交**(仓库既有制度,见用户级 memory);
- 不改已装载的种子文件——修正一律新开编号种子;
- 数据库只读参考用 `psql -d literary_atlas`,写入只走种子 + db-cli。
