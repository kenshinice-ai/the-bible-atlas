# 欧洲古典音乐史 Atlas · Gate 2 Foundation 策展清单

日期：2026-08-04  
状态：冻结；机器可读清单位于 `scripts/european_music_foundation_data.ts`

## 1. 冻结计数

| 实体 | 数量 |
|---|---:|
| canonical 人物 | 48 |
| compositions | 72 |
| styles / schools / forms | 20 |
| instruments | 24 |
| institutions / ensembles | 16 |
| locations | 24 |
| person relations | 80 |
| composition events | 72 |
| additional person/institution events | 24 |
| events 合计 | 96 |
| score/audio fragments | 28 |

清单通过静态审计：

- 人物、作品、风格、乐器、机构、地点、关系和片段数量与 Blueprint 配额一致；
- 72 部作品的作曲家 slug 全部存在；
- 人物、作品和机构引用的地点全部存在；
- 80 条关系两端人物全部存在；
- 28 个乐谱片段引用的 composition 全部存在；
- 各实体 slug 无重复、无空格、符合 `^[a-z0-9-]+$`。

## 2. 人物范围

人物按主时期归入七章，覆盖：

- 中世纪：希尔德加德、巴黎圣母院复调、Ars nova 与量谱理论；
- 文艺复兴：若斯坎、帕莱斯特里纳、拉索、塔利斯、伯德、加布里埃利；
- 巴洛克：蒙特威尔第、珀塞尔、科雷利、维瓦尔第、巴赫、亨德尔、泰勒曼、拉莫；
- 古典主义：格鲁克、海顿、莫扎特、克莱门蒂、博凯里尼、贝多芬；
- 浪漫主义：舒伯特、柏辽兹、肖邦、舒曼、李斯特、瓦格纳、勃拉姆斯、威尔第、柴可夫斯基；
- 现代主义与战争：德彪西、拉威尔、马勒、勋伯格、斯特拉文斯基、巴托克、普罗科菲耶夫、奥尔夫；
- 战后与当代：布里顿、梅西安、布列兹、利盖蒂、瓦雷兹。

进入 production 的纪律：

- 每位作曲家至少一部 composition；
- 非作曲者若后续加入，必须至少有作品、机构、事件或关系上下文；
- 不把机构或乐团伪造成 canonical 人物；
- 一个历史人物只保留一个 `characters` 节点。

## 3. 曲目范围

72 部曲目覆盖：

- 圣咏、奥尔加农、经文歌与循环弥撒；
- 文艺复兴复调和威尼斯多重合唱；
- 早期歌剧、数字低音、大协奏曲、独奏协奏曲、受难曲、清唱剧；
- 古典交响曲、弦乐四重奏、奏鸣曲和歌剧改革；
- 浪漫主义艺术歌曲、标题交响曲、钢琴体裁、音乐戏剧、芭蕾和安魂曲；
- 印象主义、表现主义、新古典主义、打击乐与音色/音簇写作；
- 战后室内乐、声乐套曲与管弦乐织体。

每部曲目生成一个主要创作/首演事件，共 72 个。另从 24 位锚点人物生成出生、任职、理论出版或机构活动事件，使 Foundation 达到 96 个事件。

## 4. 风格与体裁

冻结 20 个：

1. Gregorian chant
2. Organum
3. Ars antiqua
4. Ars nova
5. Renaissance polyphony
6. Venetian polychoral style
7. Seconda pratica
8. Basso continuo
9. Concerto grosso
10. Baroque opera
11. Galant style
12. Sonata form
13. Classical symphony
14. Romanticism
15. Program music
16. Musical nationalism
17. Musical impressionism
18. Expressionism
19. Neoclassicism
20. Serialism

主 chapter 负责展示归属，style 起止年代允许跨 chapter。

## 5. 乐器

冻结 24 类：

- 人声；
- 鲁特琴、维奥尔琴；
- 小提琴、中提琴、大提琴、低音提琴；
- 羽管键琴、古钢琴、钢琴、管风琴；
- 竖笛、横笛、双簧管、单簧管、巴松管；
- 自然号、圆号、小号、长号；
- 定音鼓、一般打击乐；
- 竖琴、萨克斯管。

用户层使用八大家族；研究层保存 Hornbostel–Sachs code、历史范围和 MIMO preferred term。Foundation 不提供仿真音色试听。

## 6. 地点与机构

24 个地点为真实欧洲城市，坐标使用城市中心点并标记 `city_centroid`。机构覆盖：

- 教堂与宫廷；
- 歌剧院；
- 音乐学院；
- 音乐节；
- 广播/音乐机构；
- 现代音乐研究机构。

机构必须指向清单中的真实地点，不能自行复制城市坐标。

## 7. 人物关系

80 条关系覆盖：

- mentorship；
- influence；
- collaboration；
- institutional_peer；
- aesthetic_opposition；
- reception_advocacy；
- family。

每条关系生成：

- 方向；
- 强度；
- 中英文具体 label；
- 中英文摘要；
- 来源；
- 至少一个 relation context。

关系并非“同一时期自动相连”。机器清单逐条指定人物对和关系类型；跨时期影响必须由来源和摘要解释。

## 8. 28 个乐谱与声音片段

片段覆盖中世纪、文艺复兴、巴洛克、古典、浪漫和现代主义。Foundation 暂不为 1945 年后的版权期作品制作可播放片段。

每段：

- 4 小节（允许以后在 2–8 小节范围内调整）；
- 8–30 秒；
- MEI canonical；
- SVG 乐谱；
- timing JSON；
- 22050 Hz / 16-bit / mono PCM WAV；
- 独立 manifest 和 checksum；
- 中英文分析说明；
- 固定学习播放免责声明。

片段默认是项目自行编码的分析性研究摘录；不复制现代商业版本的排版、指法、校勘或编辑记号。

## 9. 来源与权利

Foundation source catalog 包括：

- IMSLP；
- Bach Digital；
- Mozart Digital；
- Beethoven-Haus Bonn；
- British Library Music Collections；
- Library of Congress Music Collections；
- Europeana Music；
- MEI Guidelines；
- Verovio；
- 项目自产分析性乐谱片段记录。

权利门禁：

- 底层作品、版本、MEI 转录、SVG、timing 和 WAV 分层记录；
- 没有明确权利状态的片段不得返回播放路径；
- 不使用商业录音；
- 不使用来源不明 SoundFont 或采样包；
- 战后作品在 Foundation 中可以有元数据与事件，但默认没有片段。

## 10. Gate 2 结论

Gate 2 已冻结，可以进入 Gate 3：

1. 创建 `013_european_classical_music.sql`；
2. 创建 `014_music_score_assets.sql`；
3. 生成 `057` skeleton/Foundation seed；
4. 对 fresh/repeat migration 与 seed 做完整验证；
5. migration 与 seed 验证通过前不接前端。
