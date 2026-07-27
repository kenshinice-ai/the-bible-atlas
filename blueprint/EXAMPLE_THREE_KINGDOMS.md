# 三国舆图:实例化速写

> 「史+演义」双作品对照的落地示例,配合 [ARCHITECTURE.md](ARCHITECTURE.md) §4 清单与 §5 双作品设计、[WORK_TEMPLATE.md](WORK_TEMPLATE.md) 种子规范、[PIPELINE.md](PIPELINE.md) 编排执行。本文只做决策速写,不是完整 spec。

## 1. 两个 work 定义

| 字段 | 《三国志》 | 《三国演义》 |
|---|---|---|
| id / 作品位 X | `10000000-…-0006`,X=6 | `10000000-…-0007`,X=7 |
| slug | `records-of-the-three-kingdoms` | `romance-of-the-three-kingdoms` |
| author_name | Chen Shou(陈寿,撰于西晋;裴松之注) | Luo Guanzhong(罗贯中;毛评本定型) |
| content_mode | `documented_record` | `literary_narrative` |
| category | `historical_document` | `historical_fiction` |
| map_layer | `real` | `real`(同层,可叠加对照) |
| chronology | historical 184–280 | historical 184–280 + 可选 `narrative`(百二十回回目序) |
| default_locale | en(沿用圣经版决策) | en |
| launch_rank | 2 | 1(演义为默认视角,`WORK_PROFILE.defaultActive`) |
| 主题色三元组 | 竹简灰玉 `#8FA08A` 系(史笔冷调) | 绛帐朱 `#C25E52` 系(演义热调) |

`WORK_PROFILE = { kind: "locked-pair", slugs: [志, 演义], defaultActive: 演义 }`(见 [ARCHITECTURE.md](ARCHITECTURE.md) §5.3);compare-bar 即「史/演义」视角切换器。

## 2. 时代表(13 幕,两作品平行建同 slug chapters)

色相弧方案:**汉火德残赤 → 黄巾土黄 → 乱世赭铁 → 河北玄青 → 大江碧青 → 荆益橄榄 → 鼎立紫金 → 蜀汉赤 → 魏土黄转晦 → 残局灰 → 晋白金**。即以「德运/势力色」讲一条颜色的兴亡叙事:起于汉赤终于晋金,中段随地理(河北冷色、江东青色、蜀地暖赤)摆动。十六进制为初值,**入库前必须按 `db/seeds/025` 的教训跑对比度(≥4.5:1 对 `#0F172A` 面板底与标签前景)**。

| KK | slug | 时代 | 年代 | 色相 | 建议 hex |
|---|---|---|---|---|---|
| 01 | yellow-turban-rising | 黄巾之乱 | 184–189 | 苍天已死之土黄 | `#C9A227` |
| 02 | dong-zhuo-usurpation | 董卓乱政 | 189–192 | 焚洛赭 | `#C0703F` |
| 03 | warlords-contending | 群雄割据 | 192–199 | 烽烟褐 | `#A9825A` |
| 04 | guandu-and-the-north | 官渡与河北 | 200–207 | 河朔玄青 | `#6E86A8` |
| 05 | red-cliffs | 赤壁 | 208–209 | 大江碧青 | `#4E9B8F` |
| 06 | three-spheres-forming | 三分雏形(取荆入益) | 209–218 | 荆益橄榄 | `#8FA352` |
| 07 | jing-province-and-yiling | 失荆州与夷陵 | 219–222 | 折戟绛 | `#B25858` |
| 08 | three-thrones | 三国鼎立(称帝建制) | 220–229 | 鼎立紫金 | `#9C7BC0` |
| 09 | northern-expeditions | 诸葛北伐 | 228–234 | 蜀汉赤 | `#C25E52` |
| 10 | wei-court-and-regency | 魏廷与正始之变 | 235–254 | 魏土黄转晦 | `#B39A55` |
| 11 | jiang-wei-and-the-last-campaigns | 姜维北伐与淮南三叛 | 249–262 | 残照橙灰 | `#B98A6B` |
| 12 | fall-of-shu | 灭蜀 | 263–265 | 暮山灰紫 | `#8B7F9E` |
| 13 | jin-unification | 魏晋嬗代与晋并天下 | 265–280 | 晋白金 | `#C9BC8F` |

年代允许重叠(08/09/10/11 并行推进,同圣经 gospels/acts 先例)。**两作品各建一套 chapters(同 slug、同年代、色可同色相异明度:志=降饱和,演义=全饱和)**,时代筛选与题词机制即各自成立。事件密度差异本身就是叙事信息:演义在 01–09 幕重(约七成篇幅在 234 年前),志在 10–13 幕仍有厚度。

## 3. 锚点人物(20 人,importance≥4,覆盖全部时代)

曹操 `cao-cao`、刘备 `liu-bei`、孙权 `sun-quan`、诸葛亮 `zhuge-liang`、关羽 `guan-yu`、张飞 `zhang-fei`、赵云 `zhao-yun`、吕布 `lu-bu`、董卓 `dong-zhuo`、袁绍 `yuan-shao`、汉献帝 `emperor-xian`、周瑜 `zhou-yu`、鲁肃 `lu-su`、孙策 `sun-ce`、陆逊 `lu-xun`、司马懿 `sima-yi`、刘禅 `liu-shan`、姜维 `jiang-wei`、邓艾 `deng-ai`、司马昭 `sima-zhao`。

- `reality_type`:以上诸人在志 work 为 `historical`;在演义 work 为 `fictionalised_historical`。
- 演义独有人物照常入演义 work:貂蝉 `diaochan`(`fictional`)——正史仅「布与卓侍婢私通」一句,无其人;此类落差正是对照模式的展品。
- `icon_variant` 需新增值并在 `apps/web/src/i18n.ts` ENUMS 补双语对(见 [ARCHITECTURE.md](ARCHITECTURE.md) §3.2),建议:`strategist`(军师/谋士)、`general`(将军)、`warlord`(群雄)、`regent`(权臣);`king/queen/ruler/soldier` 沿用。

## 4. 群体划分(建议 14 组)

| slug | 名称 | group_type |
|---|---|---|
| han-court | 汉室朝廷 | institution |
| yellow-turbans | 黄巾军 | institution |
| liangzhou-faction | 董卓凉州集团 | institution |
| hebei-faction | 袁绍河北集团 | institution |
| house-of-cao | 曹氏霸府(曹魏) | dynasty |
| house-of-liu | 昭烈帝室(蜀汉) | dynasty |
| house-of-sun | 孙氏江东(孙吴) | dynasty |
| shu-generals | 蜀汉武臣 | circle |
| shu-chancellery | 丞相府与北伐幕僚 | circle |
| wu-commandery | 江东都督府 | circle |
| wei-strategists | 魏廷谋主 | circle |
| jing-province-circle | 荆州集团 | circle |
| house-of-sima | 司马氏 | dynasty |
| men-of-letters | 建安名士与士族 | circle |

## 5. 同事件双 reality 对照样例(内容层约定,同 slug)

| slug | 志 | 演义 |
|---|---|---|
| battle-of-red-cliffs | `verified_historical`+`high`,简记「权遣周瑜,大破曹军于赤壁」 | `fictional_with_historical_context`,铺陈群英会/连环计/借东风 |
| straw-boat-arrows(草船借箭) | (志 work 不建此事件;史源为 213 年濡须孙权乘船受箭) | `fictional_narrative`,detail 注明移花接木自濡须之战 |
| empty-fort-ruse(空城计) | 不建(裴注引郭冲三事,陈寿未取) | `fictional_narrative` 或 `contested` |
| peach-garden-oath(桃园结义) | 不建(志仅「恩若兄弟」) | `fictional_narrative` |
| guan-yu-slays-hua-xiong(温酒斩华雄) | 志:华雄死于孙坚军(可建 `sun-jian-defeats-hua-xiong`) | `fictional_narrative`,与志侧事件同年并列即成对照 |

## 6. 题词来源(全部公有领域)

- **欢迎题词**(对应圣经 `WELCOME_EPIGRAPH`):《临江仙·滚滚长江东逝水》节选(杨慎词,毛评本卷首)——「滚滚长江东逝水,浪花淘尽英雄。(节选)」。
- **加载轮换**:「话说天下大势,分久必合,合久必分。」(《演义》第一回开篇);另配志序/裴注短句两条。
- **页脚**:「是非成败转头空。青山依旧在,几度夕阳红。(节选)」。
- **各时代题词**(`ERA_EPIGRAPHS`,按 chapter slug 一一对应):混用两源并标注——志侧用陈寿「评曰」(如评曹操「非常之人,超世之杰」、评诸葛亮「识治之良才,管、萧之亚匹」),演义侧用回目联语与卷中诗。en 侧处理:公有领域英译可用 C. H. Brewitt-Taylor 译本(1925,已入公有领域)或自译并标 "tr. the editors"(圣经版用 KJV 的对应策略)。
- **版权纪律**:陈寿原文、裴松之注、毛评本《演义》均为公有领域;**今人点校本的校勘记、注释、白话译文有版权,一律不用**;引文自行标点。`UI.epigraphSourceSuffix`(`i18n.ts:208`)相应改为 `(毛评本)`/`(Brewitt-Taylor)` 之类;`scriptureNote` 改写为底本声明。

## 7. 预估工作量(以圣经实测为基线)

圣经终态:239 人物 / 406 事件 / 116 地点 / 275 关系,13 个时代文件分 5 批(每批 ≤4 代理并行)+ 重排/精修/色调/审计 4 个收尾种子。

| 项 | 志 | 演义 | 备注 |
|---|---|---|---|
| 人物 | ≈180 | ≈220(含虚构) | 同名人物两 work 各建一行(不同 UUID/X 位),文案两套口吻 |
| 事件 | ≈250 | ≈330 | 演义按回目聚合,志按纪传拆纪年 |
| 地点 | ≈90 | ≈95 | 坐标同源可复用研究成果,行仍按 work 分建 |
| 关系 | ≈300 | ≈380 | 全部带具体双语标签(铁律) |

- 生成建议:**每时代 1 个代理同时产出该时代的志+演义两个文件**(同一研究上下文保证同 slug 对照对齐)→ 13 代理 ÷ 每批 4 ≈ 4 批;加骨架期 1、收尾(重排/精修/史学审计/色调)4–5 个任务。
- 总量约为圣经项目的 **1.7–2 倍**(双作品、双口吻、英文全量);其中英文内容生产约占一半工时,不可低估。
- 品牌层改造(i18n/epigraphs/index.html/styles + `WORK_PROFILE` 泛化 + 发布链常量)为一次性代码工作,参照圣经 P0 重塑的规模:3 代理并行一天内完成 + 浏览器验证。
