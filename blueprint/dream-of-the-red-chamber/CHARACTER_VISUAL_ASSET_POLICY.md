# 《红楼梦 Atlas》人物视觉资产与虚构形象规范

- 状态：`draft`
- 日期：`2026-08-15`
- 已批准方向：所有纳入项目的人物均制作原创虚构形象
- 资产性质：`artistic_interpretation / illustrative`

## 1. 目标

《红楼梦 Atlas》中的人物不能长期停留在抽象圆点。每位正式人物应拥有一套统一而有辨识度的原创虚构形象，使头像、人物详情、关系显微镜和全身人物卡形成完整视觉体验。

视觉目标是：

- 美好、优雅、细腻；
- 容貌有辨识度，不使用同一张“标准美人脸”；
- 发式、首饰、妆容、服饰和身份彼此一致；
- 体现人物年龄、处境、气质与社会位置；
- 以原著和审慎的时代视觉研究为灵感；
- 不复制任何影视演员、现成剧照、游戏角色或特定在世艺术家的风格。

“美好”不等于把所有人年轻化、贵族化或同质化。长辈应有庄重之美，刘姥姥等人物应有质朴、温暖和生命力，丫鬟的服饰等级不能与主家小姐混同。

## 2. 每位人物的标准资产

每位正式人物至少生成：

| 资产 | 比例 | 用途 |
|---|---:|---|
| `portrait-master` | 4:5 | 人物详情、关系显微镜、分享卡 |
| `fullbody-master` | 2:3 | 全身人物卡、群体对照、服饰展示 |
| `avatar` | 1:1 | 关系图节点、搜索、人物轨道 |
| `thumbnail` | 3:4 | 移动端列表与预加载 |

`avatar` 和 `thumbnail` 优先从已批准 master 裁切，不重新生成陌生面孔。这样同一人物在各处保持身份一致。

第一期约 35 人预计产生：

- 70 张 master 图；
- 35 张头像；
- 35 张缩略图；
- 合计约 140 个发布文件，不含被淘汰的草稿和备选。

## 3. 统一美术方向

### 3.1 风格

- 原创、半写实、细腻绘画式人物概念设计；
- 中国古典审美与编辑型博物馆画册质感；
- 柔和真实的皮肤、丝绸、刺绣、玉石、金银和发丝材质；
- 不做廉价网游立绘、塑料 3D、现代影楼古装或电视剧截图感；
- 不使用可识别的真人演员脸；
- 不模仿特定影视版本的服装、妆造或构图。

### 3.2 历史与虚构声明

《红楼梦》的服饰时代与版本视觉传统复杂。项目图像采用“古典中国贵族家庭的原创视觉想象”，参考清代审美语境及相关服饰研究，但不声称是唯一正确的历史复原。

所有人物图必须标记：

```text
depiction_status: illustrative
interpretation_class: artistic_interpretation
historical_accuracy_claim: none
```

### 3.3 背景

主资产采用统一的低干扰背景：

- 暖墨黑、绛色、淡绢色或极弱园林虚景；
- 人物轮廓清楚；
- 不出现文字、印章、logo、水印；
- 不让复杂室内陈设遮盖服装与首饰；
- 头像裁切后仍能辨认发式和肩部轮廓。

## 4. 容貌规范

### 4.1 共同要求

- 中国人面部特征自然、细腻且彼此不同；
- 保留真实皮肤纹理，不使用蜡像式磨皮；
- 眼神、嘴角、眉形和姿态承担人物性格；
- 不用夸张“网红脸”、欧化骨相、过高鼻梁或现代审美模板；
- 不将所有年轻女性做成同一年龄、同一脸型；
- 不以暴露、媚俗或性化姿态表现年轻人物。

### 4.2 年龄与身份

- 少年人物保持少年感，不成人化；
- 长辈保留年龄纹理、威仪与温度；
- 丫鬟与小姐在材质、首饰数量和服装层级上明确区分；
- 男性角色也需有精细发冠、玉饰、腰带和衣料层次；
- 身份低不等于画面粗糙，每个人都应被认真、体面地描绘。

## 5. 妆容、发式与首饰

### 妆容

- 以薄、透、自然为主；
- 面部气色与人物处境一致；
- 黛玉偏清淡、冷润、克制；
- 宝钗偏温润、端整、平衡；
- 王熙凤可以更鲜明华贵，但不能现代浓妆化；
- 长辈妆容端庄，不刻意消除年龄。

### 发式

- 每个人建立稳定发式轮廓；
- 正面头像也要能看见关键簪钗和发髻结构；
- 同一人物的 portrait 与 fullbody 保持一致；
- 不使用现代刘海、烫发、旗袍影楼头套。

### 首饰

必须根据人物身份建立首饰等级：

1. 皇室/高位礼仪；
2. 贾府长辈与管家权力人物；
3. 主家小姐与公子；
4. 富裕亲族；
5. 丫鬟与侍女；
6. 外部平民人物。

重点材质：

- 玉；
- 金银；
- 珍珠；
- 点翠或类似传统工艺的审慎艺术化表达；
- 珊瑚、宝石和丝质发带。

首饰不是越多越好；必须服务人物身份与气质。

## 6. 服饰规范

每位人物建立：

- 主色；
- 辅色；
- 衣料；
- 纹样；
- 领口与袖型；
- 腰间配件；
- 鞋履；
- 季节；
- 身份等级；
- 是否有代表性手持物。

共同规则：

- 展示完整层次和自然垂坠；
- 刺绣与纹样精细但不喧宾夺主；
- 避免现代旗袍、婚纱式汉服、戏服夸张肩线；
- 避免所有人物都穿大红大金；
- 全身图必须显示鞋履与完整下摆；
- 手部与衣袖不能畸形或互相穿透。

## 7. 8 人原型首批

Gate 1 先制作以下 8 人：

| 人物 | 关系验证价值 | 视觉关键词 |
|---|---|---|
| 贾宝玉 | 原型中心节点 | 温润少年、通灵宝玉、红与玉色、精致但不女相化 |
| 林黛玉 | affection / trust | 清瘦灵秀、冷润淡雅、黛色与浅青、含蓄而敏锐 |
| 薛宝钗 | affection / duty | 温润端整、象牙与柔金、稳重、克制华美 |
| 王熙凤 | power / conflict | 明艳华贵、绛红与金、凤形首饰、锐利自信 |
| 贾母 | authority / care | 高贵慈严、深梅与金棕、长辈威仪、丰厚层次 |
| 王夫人 | authority / morality | 端肃克制、靛青与沉香色、佛珠或简洁贵重饰物 |
| 袭人 | care / dependency | 温柔稳妥、藕荷与米色、整洁含蓄、可靠 |
| 晴雯 | affection / conflict | 明丽灵动、青绿与绯色点缀、锐气、轻盈精致 |

这 8 人可组成 12–18 条关系，足以测试人物焦点图、权力/照护/冲突 lens、关系详情与章回变化。

## 8. 生成批次

### Wave 0：风格圣经

- 先生成贾宝玉、林黛玉各 2–3 个方向；
- 冻结脸部写实程度、光线、背景、材质与服饰精度；
- 形成 approved style reference；
- 未冻结前不批量生成。

### Wave 1：8 人原型

- 8 张 portrait master；
- 8 张 fullbody master；
- 派生 8 张 avatar 和 8 张 thumbnail；
- 通过交互原型检查头像在 32/48/72/120px 的辨识度。

### Wave 2：其余核心人物

- 完成约 12 位核心人物；
- 重点保持同一世界观与身份差异。

### Wave 3：上下文人物

- 完成约 15 位上下文人物；
- 不能因非核心身份降低图像质量。

## 9. 生成与资产记录

每个 master 图记录：

```text
character_slug
asset_role
prompt_version
style_reference_version
generation_tool
generation_date
source_inputs
rights_status
depiction_status
interpretation_class
review_status
checksum
alt_text_zh
alt_text_en
```

项目内路径候选：

```text
apps/web/public/media/red-chamber/characters/<slug>/
  portrait-v1.webp
  fullbody-v1.webp
  avatar-v1.webp
  thumbnail-v1.webp
  manifest.json
```

不得用覆盖旧文件的方式返工；新版本使用 `v2`、`v3`，批准后再更新 manifest 指针。

## 10. 单人物生成提示模板

```text
Use case: historical-scene
Asset type: character portrait / full-body character artwork for Red Chamber Atlas
Primary request: an original fictional interpretation of <人物>
Subject: <年龄、身份、气质、表情、姿态>
Style/medium: refined semi-realistic painterly portrait, Chinese classical editorial art
Composition/framing: <4:5 portrait or 2:3 full body>, complete hair and clothing silhouette
Lighting/mood: soft diffused light, elegant, calm, highly detailed
Color palette: <主色、辅色、背景>
Materials/textures: silk, embroidery, jade, gold or silver appropriate to social status
Details: historically inspired hairstyle, jewelry, makeup and layered clothing
Constraints: original face, age-appropriate dignity, consistent with the approved style bible
Avoid: actor likeness, television adaptation resemblance, modern qipao, modern makeup,
       generic influencer face, sexualized pose, text, logo, watermark, malformed hands,
       excessive jewelry inconsistent with status
```

## 11. 人工审核清单

每张图必须检查：

- 人物辨识度；
- 年龄；
- 面部是否自然；
- 双眼、牙齿、耳朵和手部；
- 发髻与簪钗结构；
- 首饰是否符合身份；
- 妆容是否过现代；
- 衣领、袖口、腰带、下摆和鞋履；
- 材质与刺绣；
- portrait/fullbody 是否同一张脸；
- 是否意外接近演员或现有改编；
- 是否含文字、水印或伪签名；
- 小尺寸头像是否仍清楚；
- 中英文 alt 是否准确；
- manifest 与 checksum 是否完整。

## 12. 发布纪律

- 未通过审核的图只进入 draft 工作区；
- `rights_status != verified` 不进入 public path；
- 人物详情明确显示“原创虚构形象 / artistic interpretation”；
- 不把图像描述为原作者认可、历史照片或唯一正确复原；
- 任何人物都可以暂时显示优雅的无图占位，不用低质量图凑齐覆盖率。

