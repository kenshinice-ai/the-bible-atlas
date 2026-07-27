# 银河舆图:工作量估算与流水线增补

> 基线 = 圣经实测(239 人物 / 406 事件 / 116 地点 / 275 关系,13 时代文件分 5 批)与三国估算基准([../EXAMPLE_THREE_KINGDOMS.md](../EXAMPLE_THREE_KINGDOMS.md) §7)。通用阶段照抄 [../PIPELINE.md](../PIPELINE.md) 0–8,本文只写规模数字与 Star Wars 特有增补。内容规格见 [SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md),IP 边界见 [IP_AND_NAMING.md](IP_AND_NAMING.md)。

## 1. 规模估算(P0 = 单 work `skywalker-saga`)

| 项 | 目标量 | 依据 |
|---|---|---|
| works | 1(P1 +rogue-one、the-clone-wars;P2 +mandalorian/solo/andor) | [SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md) §1 |
| chapters(时代) | 12 | §3 全表已定 slug/年代/hex(hex 已预验对比度,阶段 5 降为抽查) |
| character_groups | 13 | §5.1,骨架期一次建全 |
| characters | ≈150(锚点 24+候补 3;每时代新增 8–15) | 单 work、9 部影片主配角 + 政治/军事配角;低于圣经(圣经有大量谱系人物),密度足够 |
| locations | ≈45(画布行星 37 + 战役场所细分若干) | §4.2 全表;虚构画布不需坐标考证,是省工项 |
| events | ≈260(每部影片 18–24 + 幕间连接事件) | 04/09 两个宽年代时代刻意低密度(各 8–12 事件),等衍生 work 填厚 |
| character_relations | ≈300,全部带具体双语标签 | relation_translations 铁律([../WORK_TEMPLATE.md](../WORK_TEMPLATE.md) §3) |
| routes | 3–4 条骨干超空间航线 | §4.3;圣经/三国均未大量用 routes,本实例是画布卖点,waypoint 顺序即叙事顺序 |
| 总量系数 | ≈ 圣经的 **0.8×**(内容),代码项 ≈ 圣经 P0 重塑 + FictionalCanvas 增强 | 单 work、双语全量;英文占一半工时的规律不变 |

## 2. 批次编排(对照 [../PIPELINE.md](../PIPELINE.md) 阶段表)

| 阶段 | 代理数 | Star Wars 具体化 |
|---|---|---|
| 0 骨架期 | 1 | works 行 + **迁移 004(DROP hobbit CHECK,先于一切种子)** + launch_rank 两步法 + chronology(fictional, −33…36)+ 12 chapters + 13 groups + sources(9 部影片各 1 条 + 纪年政策 + 画布政策 2 条)+ 37 地点全量(画布坐标是全局资产,骨架期一次入库)+ 24 锚点人物 + 骨干航线 |
| 1 时代并行 | 12 时代 ÷ 每批 4 = **3 批** | 每代理领:KK、chapter slug、sequence 区间(K*1000 步长 2)、人物归属名单、**BBY/ABY→带符号年份映射表与 0 年规则**([SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md) §2.1,写进 seed-spec 头部)、time_label 双语模板(`雅汶战役前 22 年`/`22 BBY`)、IP 一页纸([IP_AND_NAMING.md](IP_AND_NAMING.md) §4) |
| 2 装载 | 主会话 | 同通用;审计 SQL 照抄 |
| 3 全局重排 | 1 | 模板 `db/seeds/023` |
| 4 关系精修 | 1 | 目标同通用:泛型标签清零(「师徒(魁刚→欧比旺)」而非「师承」) |
| 5 视觉抽查 | 0.5 | 色板已预验(§3 表内附实测值),只跑一次幂等校验脚本兜底 |
| 6 详情补写 | 按缺口 | 同通用 |
| **7 IP 审读(替代神职审计)** | 1 | 见 §3,本实例的关键差异阶段 |
| 8 烘焙部署 | 主会话 | `bake-static.ts` workSlugs、deploy 断言、托管项目名换 `galaxy-atlas` |

代码项(与内容并行,3 代理一天,同圣经 P0 重塑规模):profile/formatYear(§2.2 路 B)、ENUMS 词条、epigraphs 重写、index.html/styles、FictionalCanvas 增强 1/2/4、发布链常量。

## 3. Star Wars 特有阶段(通用流水线之外的三道门)

### 3.1 画布坐标校对门(阶段 0 之后、阶段 1 之前)

真实地理作品靠经纬度自证,虚构画布必须**视检**:

1. 骨架期落库后本地起 web,人工截图 FictionalCanvas,核对:同心环带归属正确(Core 点不落外环)、著名相对方位不反直觉(塔图因在东南、恩多在西、未知区域贴西缘)、标签无严重压字;
2. SQL 自检(补进骨架种子自测):环带半径一致性——`sqrt((canvas_x-50)^2+(canvas_y-38)^2)` 与 §4.1 环带表比对,越带点逐个说明(死星、卡米诺属「有意越带」白名单);
3. 后续时代代理**禁止新建行星**(37 点是封闭清单,新地点只允许行星表面场所,坐标继承母行星 ±1 内偏移)——写进归属名单,防画布散点漂移。

### 3.2 纪年标签覆盖审计(阶段 2 装载后追加的 SQL 门)

formatYear 耦合决定 time_label 是显示正确性的生命线([SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md) §2.2),零容忍:

```sql
-- 全部必须 0 行
SELECT e.slug FROM events e JOIN event_translations t ON t.event_id=e.id
WHERE e.work_id='10000000-0000-4000-8000-000000000008'
  AND (t.time_label='' OR t.time_label LIKE '%公元%' OR t.time_label LIKE '%BCE%' OR t.time_label LIKE '%CE');
-- BBY/ABY 与带符号年份方向一致性
SELECT e.slug FROM events e JOIN event_translations t ON t.event_id=e.id AND t.locale='en'
WHERE e.work_id='10000000-0000-4000-8000-000000000008'
  AND ((e.historical_start_year<0 AND t.time_label NOT LIKE '%BBY%') OR (e.historical_start_year>0 AND t.time_label NOT LIKE '%ABY%'));
-- 人物生卒年方向抽查(EntityDrawer 直呼 formatYear,靠 profile.yearLabels 修——回归时点开锚点人物抽屉逐一目验)
```

### 3.3 IP 审读(阶段 7,替代圣经的 CLERGY_AUDIT)

审读代理人格 = 「娱乐法务视角 × 粉丝百科编辑」双人格(模板参照 `.claude/agents/liturgical-design-director.md` 换领域重写)。检单:

1. **原创性机检**:全库 summary/detail 与已知台词/官方文案跑 ≥8 连续词重合检查(抽样 + 关键事件全查);命中即改写;
2. **引用清点**:题词短引用 ≤3 条、每条 ≤15 词、出处齐全(`epigraphs.ts` 头部登记与正文一致);库内 event 文本中不得出现引号包裹的台词;
3. **命名合规**:产品名/域名/托管项目名不含商标词;免责声明双语两处落点在位(index.html + 页脚);
4. **素材合规**:构建产物 grep 无外链官方图片、无剧照资产;SVG 装饰为原创;
5. **译名一致性**(对应圣经的「该撒利亚拼法」审计):中文译名以大陆通行译名为准建译名表(欧比旺/绝地/原力…),全库统一;
6. 产出:`docs/IP_AUDIT.md` + 修正种子一个;**落库后必须重新烘焙**(圣经 027 教训:静态数据要等审计修正后再烘)。

## 4. 里程碑建议

| 里程碑 | 内容 | 出口条件 |
|---|---|---|
| M0 蓝图定稿 | 本目录三文件 + 用户确认命名方案 | 命名与免责声明文案拍板([IP_AND_NAMING.md](IP_AND_NAMING.md) §1 是先决:名字影响 slug/托管项目名/域名) |
| M1 骨架上屏 | 阶段 0 + 代码项 + 画布视检门 | 12 时代空壳 + 37 星点 + 24 锚点在三视图可浏览,BBY/ABY 显示正确 |
| M2 内容全量 | 阶段 1–6(3 批并行) | 审计 SQL 全绿,§3.2 纪年门通过 |
| M3 上线 | 阶段 7–8 | IP 审读关闭,重烘焙后 `--publish cf` |
| P1 | rogue-one + the-clone-wars 两个衍生 work;WORK_PROFILE 转 locked-set;FictionalCanvas 缩放/平移与航线光带 | compare 模式下正传/外传同画布叠加可用 |

全程纪律不变:每阶段完成即更新 `docs/HANDOFF.md` 并随变更提交;修正一律新开种子编号;不动已装载文件。
