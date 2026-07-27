-- 030_location_prose.sql
-- 为圣经作品（work_id = 10000000-0000-4000-8000-000000000005）中 44 个缺少 detail 的地点
-- 补写双语 detail，并为叙事重镇酌情补写 literary_significance / historical_background。
-- 现有 summary 不动，仅通过 COALESCE(NULLIF(...)) 方式在字段为空时写入。

BEGIN;

-- 批次 1：创世记 / 出埃及记 / 民数记 旷野行程
UPDATE location_translations t
SET detail = v.detail,
    literary_significance = COALESCE(NULLIF(v.lit, ''), t.literary_significance),
    historical_background = COALESCE(NULLIF(v.hist, ''), t.historical_background)
FROM locations l, (VALUES
  ('eden-reference','zh-CN','创世记二至三章记载人类始祖居住的乐园，经文称有比逊、基训、希底结（底格里斯）、伯拉（幼发拉底）四河由此分流，传统多将其定位于两河流域南部，但学界对确址仍有不同意见。',
    '伊甸园是圣经叙事中人类受造、犯罪、被逐的起点，为其后整部救赎历史奠定背景。',
    '经文对四河的描述融合了古代近东的地理知识与神学象征，历代学者提出多种定位方案，始终未有定论。'),
  ('eden-reference','en','Genesis 2–3 places the garden of the first humans where four rivers—including the Tigris and Euphrates—converge, leading tradition to locate it in southern Mesopotamia, though scholars remain divided on any precise site.',
    'Eden is the narrative starting point for humanity’s creation, sin, and exile, setting the backdrop for the whole of biblical redemption history.',
    'The description of four rivers blends ancient Near Eastern geography with theological symbolism, and generations of scholars have proposed competing locations without consensus.'),

  ('land-of-nod-reference','zh-CN','该隐杀弟后被耶和华放逐，创世记四16记载他离开耶和华面前，去住在伊甸东边的挪得之地，“挪得”意为“流荡”，经文未给出具体地理坐标，其位置纯属推定。','',''),
  ('land-of-nod-reference','en','After killing his brother, Cain was banished and, per Genesis 4:16, settled “east of Eden, in the land of Nod”—a name meaning “wandering.” Scripture gives no further geographic marker, so any location is purely conjectural.','',''),

  ('mizpah-of-gilead','zh-CN','创世记三十一章记载雅各与拉班在此堆石为证、彼此立约分手，雅各称之为“迦累得”，拉班称之为“米斯巴”，意为“瞭望台”；确切地点在约旦河东的基列山地，今址已难考定。','',''),
  ('mizpah-of-gilead','en','In Genesis 31, Jacob and Laban piled stones as a witness to their covenant of parting here—Jacob calling it Galeed, Laban calling it Mizpah (“watchtower”). Located somewhere in the Gilead highlands east of the Jordan, its exact site is now unrecoverable.','',''),

  ('elim-reference','zh-CN','出埃及记十五27记载以色列人出埃及后在此扎营，营地有十二股水泉、七十棵棕树，是旷野中难得的绿洲；传统多将其定于西奈半岛西侧的加兰德勒旱谷一带，确址仍有争议。','',''),
  ('elim-reference','en','Exodus 15:27 records the Israelites camping here, finding twelve springs and seventy palm trees—a welcome oasis in the wilderness. Tradition often places it in the Wadi Gharandal area on the western Sinai Peninsula, though the identification remains debated.','',''),

  ('rephidim-reference','zh-CN','出埃及记十七章记载以色列人在此因无水怨言，摩西击打磐石得水；亚玛力人也在此与以色列争战，摩西举手代祷、约书亚率军得胜。传统上定于西奈山西北的费兰旱谷一带，确址存疑。','',''),
  ('rephidim-reference','en','Exodus 17 recounts water miraculously flowing from a struck rock here amid the people’s complaints, and Israel’s battle with Amalek, won as Moses held up his hands. Tradition places it in the Wadi Feiran area northwest of Mount Sinai, though the site remains uncertain.','',''),

  ('kibroth-hattaavah-reference','zh-CN','民数记十一章记载以色列人贪食肉类，耶和华降下鹌鹑却又因贪欲降瘟疫，死者就葬在此地，故名“基博罗哈他瓦”，意为“贪欲之人的坟墓”；确切位置无法考定，仅能依行程大致推定于西奈北部旷野。','',''),
  ('kibroth-hattaavah-reference','en','Numbers 11 recounts Israel’s craving for meat, met by a plague of quails followed by a plague of judgment; those who died of greed were buried here, giving the site its name, “graves of craving.” Its exact location is unrecoverable, roughly placed in the northern Sinai wilderness based on the itinerary.','',''),

  ('hazeroth-reference','zh-CN','民数记十二章记载米利暗与亚伦在此因摩西的古实妻子而毁谤他，米利暗因此长大麻风，后经摩西代求而痊愈；地点位于西奈旷野行程之中，确址已难考证。','',''),
  ('hazeroth-reference','en','Numbers 12 records Miriam and Aaron here criticizing Moses over his Cushite wife, resulting in Miriam’s temporary leprosy, healed after Moses’ intercession. Situated along the Sinai wilderness route, its precise site can no longer be established.','',''),

  ('arad','zh-CN','民数记二十一1记载亚拉得王听闻以色列人从亚他林路来，就攻击他们并掳去几个人，以色列人向耶和华许愿求胜，后来毁灭了他们的城邑；遗址一般认作今以色列南部的特尔亚拉得。','',''),
  ('arad','en','Numbers 21:1 records the Canaanite king of Arad attacking Israel and taking captives, after which Israel vowed to the LORD and went on to destroy the Canaanite towns. The site is generally identified with Tel Arad in Israel’s Negev.','','')
) AS v(slug, locale, detail, lit, hist)
WHERE t.location_id = l.id AND t.locale = v.locale::locale_code AND l.slug = v.slug
  AND l.work_id = '10000000-0000-4000-8000-000000000005';

-- 批次 2：民数记结尾 / 约书亚记前半
UPDATE location_translations t
SET detail = v.detail,
    literary_significance = COALESCE(NULLIF(v.lit, ''), t.literary_significance),
    historical_background = COALESCE(NULLIF(v.hist, ''), t.historical_background)
FROM locations l, (VALUES
  ('heshbon','zh-CN','民数记二十一章记载希实本原为亚摩利王西宏的都城，以色列人在此击败西宏、夺得其地；后归流便支派，先知书中屡次提及此城，作为审判亚扪、摩押的象征。','',''),
  ('heshbon','en','Numbers 21 identifies Heshbon as the capital of the Amorite king Sihon, defeated by Israel here, after which the city was allotted to Reuben. Prophetic books repeatedly cite Heshbon in oracles of judgment against Ammon and Moab.','',''),

  ('edrei-bashan','zh-CN','民数记二十一33及申命记三章记载巴珊王噩率军在以得来迎战以色列，战败被灭，其地归玛拿西半支派；遗址一般认为在今叙利亚德拉市一带，巴珊以境内的巨人传说和铁床闻名。','',''),
  ('edrei-bashan','en','Numbers 21:33 and Deuteronomy 3 record King Og of Bashan meeting Israel in battle at Edrei and being defeated, his territory given to half the tribe of Manasseh. The site is generally located near modern Daraa, Syria, in a region famed for its legendary giant king and iron bed.','',''),

  ('plains-of-moab','zh-CN','位于约旦河东、与耶利哥隔河相望的平原，是以色列人出埃及后最后的扎营之地；摩西在此重申律法、祝福十二支派并去世，巴兰也在此为以色列祝福而非咒诅。',
    '摩押平原是摩西五经叙事的终点，申命记全书即以此地为背景展开告别讲论。',
    '该平原是约旦河东谷地的一部分，土地肥沃，自古为跨约旦河的战略要冲。'),
  ('plains-of-moab','en','Located east of the Jordan opposite Jericho, this plain was Israel’s final encampment before entering Canaan. Here Moses reiterated the law, blessed the twelve tribes, and died, and here Balaam was compelled to bless rather than curse Israel.',
    'The plains of Moab mark the endpoint of the Pentateuch’s narrative, forming the setting for the farewell discourses of Deuteronomy.',
    'Part of the fertile Jordan rift valley east of the river, the plain was long a strategic crossing point into Canaan.'),

  ('punon-reference','zh-CN','民数记三十三42-43记载以色列人绕行以东途中在此扎营；传统认为此地邻近古代铜矿区，与民数记二十一章铜蛇事件的地理背景相关，但确切位置仍待考证。','',''),
  ('punon-reference','en','Numbers 33:42–43 lists this as a wilderness campsite during Israel’s detour around Edom. Tradition links it to an ancient copper-mining region, associating it with the bronze-serpent episode of Numbers 21, though its exact location remains uncertain.','',''),

  ('gilgal-reference','zh-CN','约书亚记四章记载以色列人过约旦河后在此安营，立十二块石头为记，并在此行割礼、守逾越节；此后吉甲长期作为士师与撒母耳时代的聚会与献祭之地。传统定位于耶利哥附近，确切遗址仍有争议。',
    '吉甲横跨约书亚记、士师记与撒母耳记，是以色列进迦南后信仰与政治生活的反复起点。',
    '该地毗邻约旦河渡口，地势平坦，便于大规模会众扎营与集会，故长期具有礼仪与军事枢纽的地位。'),
  ('gilgal-reference','en','Joshua 4 records Israel’s first camp after crossing the Jordan, where twelve memorial stones were set up and the people were circumcised and kept Passover. Gilgal remained a gathering and sacrificial site through the judges and Samuel’s era; traditionally placed near Jericho, its precise site is still debated.',
    'Gilgal recurs across Joshua, Judges, and Samuel, marking the repeated starting point of Israel’s religious and political life after entering Canaan.',
    'Adjacent to a Jordan crossing point and level ground suited to mass encampment, the site long served as a ceremonial and military hub.'),

  ('ai-reference','zh-CN','约书亚记七至八章记载以色列人因亚干私取当灭之物，首次攻艾城失利，后除净罪恶方才得胜、焚毁其城；地点位于伯特利以东，通常与今艾特拉遗址相联系，但学界对确址仍有不同意见。',
    '艾城之战的先败后胜，是约书亚记中“罪污必先除净方能得胜”这一神学主题的关键例证。',
    '该遗址的考古年代与约书亚记叙事的年代对应问题，是圣经考古学界长期争论的焦点之一。'),
  ('ai-reference','en','Joshua 7–8 recounts Israel’s first defeat at Ai due to Achan’s sin, followed by victory and the city’s destruction once the sin was purged. Located east of Bethel, it is often identified with et-Tell, though scholars remain divided on the identification.',
    'The defeat and later victory at Ai is a key illustration of Joshua’s theological theme that hidden sin must be purged before victory can follow.',
    'The mismatch between the site’s archaeological dating and the narrative’s presumed timeframe remains a long-running point of debate in biblical archaeology.'),

  ('mount-ebal','zh-CN','申命记二十七章与约书亚记八30-35记载，约书亚在示剑北侧的以巴路山筑坛献祭，并按摩西吩咐将律法的祝福与咒诅分列基利心山与以巴路山两侧宣读，重申与耶和华的约。',
    '以巴路山的筑坛立约，标志着以色列进迦南后对西奈之约的公开重申与延续。',
    '考古学者在山上发现的祭坛遗迹，常被部分学者与约书亚记的记载相联系，但解释仍有争议。'),
  ('mount-ebal','en','Deuteronomy 27 and Joshua 8:30–35 record Joshua building an altar on Mount Ebal, north of Shechem, and reading the law’s blessings and curses from Ebal and neighboring Mount Gerizim, renewing Israel’s covenant with the LORD.',
    'The altar and covenant ceremony on Mount Ebal mark Israel’s public renewal of the Sinai covenant upon entering Canaan.',
    'Altar remains found on the mountain are often linked by some scholars to the Joshua account, though the interpretation remains contested.'),

  ('gibeon','zh-CN','约书亚记九章记载基遍人以诡计与以色列立约求和，免于被灭；十章记载约书亚为救援基遍而与五王联军作战，日头因此停留不落。所罗门早年也曾在基遍的高处向耶和华献祭并求智慧。',
    '基遍的故事展现了立约的严肃性——即便因诡诈缔结，以色列仍恪守盟约不悔。',
    '基遍曾长期设有敬拜场所，直到耶路撒冷圣殿建成前，仍是以色列重要的献祭高处。'),
  ('gibeon','en','Joshua 9 records the Gibeonites tricking Israel into a covenant of peace, sparing them from destruction; Joshua 10 tells of Joshua marching to defend Gibeon, during which the sun stood still. Solomon later sacrificed and prayed for wisdom at the high place of Gibeon.',
    'The Gibeonite episode demonstrates the gravity of covenant-keeping—Israel honored the treaty even though it had been secured by deception.',
    'Gibeon long served as a worship site, remaining an important high place for sacrifice until the Jerusalem temple was built.')
) AS v(slug, locale, detail, lit, hist)
WHERE t.location_id = l.id AND t.locale = v.locale::locale_code AND l.slug = v.slug
  AND l.work_id = '10000000-0000-4000-8000-000000000005';

-- 批次 3：约书亚记后半 / 士师记 / 撒母耳记上
UPDATE location_translations t
SET detail = v.detail,
    literary_significance = COALESCE(NULLIF(v.lit, ''), t.literary_significance),
    historical_background = COALESCE(NULLIF(v.hist, ''), t.historical_background)
FROM locations l, (VALUES
  ('makkedah-reference','zh-CN','约书亚记十16-27记载南方联军五王战败后藏身玛基大的洞穴，约书亚命人以石头封洞口，战后将五王擒出处死并悬挂示众；确切遗址位置至今未有定论。','',''),
  ('makkedah-reference','en','Joshua 10:16–27 records five defeated Canaanite kings hiding in a cave at Makkedah, sealed with stones until Joshua had them brought out, executed, and displayed. The site’s precise location remains undetermined.','',''),

  ('waters-of-merom-reference','zh-CN','约书亚记十一章记载北方迦南诸王联合夏琐王耶宾，在米伦水一带集结抵抗以色列，约书亚率军突袭大败联军；传统认为此地位于上加利利，确切位置仍存争议。','',''),
  ('waters-of-merom-reference','en','Joshua 11 records the northern Canaanite kings, led by Jabin of Hazor, massing near the waters of Merom to resist Israel, only to be routed in Joshua’s surprise attack. Traditionally placed in Upper Galilee, the exact site remains disputed.','',''),

  ('hazor','zh-CN','约书亚记十一章称夏琐为“诸国之首”，是北方迦南联军的核心，约书亚击败联军后攻取并焚毁此城；士师记与列王纪记载它其后重建，又先后毁于所罗门的建设与亚述的入侵，是加利利地区最重要的古代王城遗址。',
    '夏琐从约书亚的焚毁到所罗门的重建再到亚述的覆灭，浓缩了以色列历史盛衰的一条主线。',
    '考古发掘显示夏琐是青铜时代近东最大的城市之一，其庞大规模印证了经文对它显赫地位的描述。'),
  ('hazor','en','Joshua 11 calls Hazor “the head of all these kingdoms,” leader of the northern Canaanite coalition defeated and burned by Joshua. Rebuilt afterward, it appears again in Judges and Kings, later fortified by Solomon and eventually destroyed by Assyria—making it the most significant royal city site in ancient Galilee.',
    'Hazor’s arc—burned by Joshua, rebuilt, fortified by Solomon, and finally destroyed by Assyria—condenses a whole thread of Israel’s rise and fall into one city.',
    'Excavations show Hazor was among the largest cities in the Bronze Age Near East, its scale confirming the text’s description of its prominence.'),

  ('timnath-serah-reference','zh-CN','约书亚记十九50、二十四30记载，以法莲山地的这座城是约书亚个人求得的产业，他年老后在此安葬；传统认为其位置在示罗以北，确切遗址仍有争议。','',''),
  ('timnath-serah-reference','en','Joshua 19:50 and 24:30 record this Ephraimite hill-country town as Joshua’s personal inheritance, where he was buried in old age. Traditionally located north of Shiloh, its precise identification remains debated.','',''),

  ('valley-of-achor-reference','zh-CN','约书亚记七24-26记载亚干因私取当灭之物，与家眷牲畜一同在此被石头打死焚烧，此谷因此得名“亚割”，意为“连累”；先知何西阿书二15、以赛亚书六十五10却反将此谷预言为将来盼望之门。',
    '亚割谷由审判之地转化为先知笔下盼望的象征，是圣经中“咒诅可转为祝福”这一主题的鲜明例证。',
    '此谷推定位于耶利哥附近通往迦南山地的通道上，是艾城战役之后清除罪污的现场。'),
  ('valley-of-achor-reference','en','Joshua 7:24–26 records Achan and his household stoned and burned here for his theft of devoted things, giving the valley its name, “Achor” (“trouble”). Yet the prophets Hosea (2:15) and Isaiah (65:10) later reimagine this valley of judgment as a future “door of hope.”',
    'The Valley of Achor turns from a place of judgment into a prophetic symbol of hope, a striking biblical example of curse transformed into blessing.',
    'Traditionally placed near Jericho along a route into the Canaanite hill country, the valley was the site where sin was purged after the defeat at Ai.'),

  ('ophrah-reference','zh-CN','士师记六至八章记载基甸的家乡在亚比以谢族的俄弗拉，他在此拆毁巴力祭坛、蒙耶和华呼召拯救以色列，后来又在此为百姓制造以弗得，反成绊脚石；确切位置不详，一般推定在玛拿西山地。','',''),
  ('ophrah-reference','en','Judges 6–8 identifies Ophrah, of the clan of Abiezer, as Gideon’s hometown, where he tore down an altar to Baal and was called to deliver Israel, though he later made an ephod there that became a snare. Its exact location is unknown, generally placed in the hill country of Manasseh.','',''),

  ('zorah','zh-CN','士师记十三章记载参孙出生于但支派的琐拉，其父玛挪亚曾在此见耶和华使者显现；琐拉位于梭烈谷北侧，与邻近的以实陶、玛哈尼但同为参孙生平活动的核心地带。','',''),
  ('zorah','en','Judges 13 records Samson’s birth at Zorah, a Danite town where the angel of the LORD appeared to his father Manoah. Situated on the north side of the Sorek Valley, Zorah and nearby Eshtaol and Mahaneh-dan form the core setting of Samson’s story.','',''),

  ('mizpah-of-benjamin','zh-CN','撒母耳记上七章记载撒母耳在便雅悯的米斯巴召聚以色列人禁食悔改，耶和华使非利士人溃败，撒母耳立“以便以谢”石为记；士师记二十章亦记载支派内战前的会众曾聚集于此。一般认作纳斯贝丘遗址。',
    '米斯巴是撒母耳士师生涯的象征性起点，标志着以色列从士师混乱转向合一悔改的转折。',
    '该地地势高耸、便于瞭望，自古是便雅悯地区重要的会众聚集与防御据点。'),
  ('mizpah-of-benjamin','en','1 Samuel 7 records Samuel gathering Israel at Mizpah in Benjamin for fasting and repentance, after which the LORD routed the Philistines and Samuel set up the stone “Ebenezer.” Judges 20 also records a tribal assembly here before civil war. Generally identified with Tell en-Nasbeh.',
    'Mizpah marks a symbolic turning point in Samuel’s career, where Israel moved from the disorder of the judges toward unified repentance.',
    'Positioned on high ground well suited to watching approaches, the site was long an important assembly and defensive point for the tribe of Benjamin.'),

  ('endor','zh-CN','撒母耳记上二十八章记载，扫罗在基利波战役前夜，因耶和华不再应允而微服私访隐多珥的交鬼妇人，召撒母耳灵魂显现，得知自己与儿子们将战死；隐多珥位于摩利冈北麓的村落。',
    '隐多珥之夜是扫罗悲剧命运的顶点，象征他与耶和华关系彻底破裂后的绝望挣扎。',
    '此事发生于以色列律法明令禁止交鬼行邪术的背景下，凸显扫罗末路时的孤注一掷。'),
  ('endor','en','1 Samuel 28 records Saul, on the eve of the battle of Gilboa and abandoned by divine answers, secretly visiting a medium at Endor to summon Samuel’s spirit, only to learn he and his sons would die in battle. Endor lay at the foot of the hill of Moreh.',
    'The night at Endor is the climax of Saul’s tragic arc, a desperate act after his relationship with the LORD had utterly broken down.',
    'The episode occurs against the backdrop of Israel’s law explicitly forbidding consultation of mediums, underscoring Saul’s final, desperate gamble.')
) AS v(slug, locale, detail, lit, hist)
WHERE t.location_id = l.id AND t.locale = v.locale::locale_code AND l.slug = v.slug
  AND l.work_id = '10000000-0000-4000-8000-000000000005';

-- 批次 4：撒母耳记下 / 列王纪
UPDATE location_translations t
SET detail = v.detail,
    literary_significance = COALESCE(NULLIF(v.lit, ''), t.literary_significance),
    historical_background = COALESCE(NULLIF(v.hist, ''), t.historical_background)
FROM locations l, (VALUES
  ('gibeah-of-saul','zh-CN','撒母耳记上十26记载基比亚是扫罗的家乡与作王后的驻地，他在此建立以色列最早的王家营地；士师记十九至二十章记载的便雅悯支派内战惨剧也发生于此。一般认作富勒丘遗址。',
    '基比亚串联起士师记的道德崩坏叙事与扫罗王朝的兴起，是以色列由乱到治转折期的缩影。',
    '考古发掘显示此地曾有铁器时代早期的堡垒建筑，与扫罗时代的简朴王权相符。'),
  ('gibeah-of-saul','en','1 Samuel 10:26 identifies Gibeah as Saul’s hometown and royal base, site of Israel’s earliest royal encampment. It was also the setting of the atrocity and civil war recorded in Judges 19–20. Generally identified with Tell el-Ful.',
    'Gibeah links the moral collapse narrated in Judges with the rise of Saul’s kingship, a microcosm of Israel’s turn from chaos toward order.',
    'Excavations reveal an early Iron Age fortress here, consistent with the modest scale of Saul’s early monarchy.'),

  ('ziklag-reference','zh-CN','撒母耳记上二十七6记载非利士王亚吉将洗革拉赐给大卫，作为他避难扫罗期间的根据地；三十章又记载亚玛力人袭掠此城、大卫追击夺回妻儿财物。确切位置有争议，南地数处遗址均曾被提出。','',''),
  ('ziklag-reference','en','1 Samuel 27:6 records the Philistine king Achish granting Ziklag to David as his base while fleeing Saul; 1 Samuel 30 tells of Amalekites raiding the town before David pursued and recovered his family and possessions. Its exact location is disputed, with several Negev sites proposed.','',''),

  ('mahanaim-reference','zh-CN','创世记三十二1-2记载雅各返乡途中在此遇见神的使者，称之为“玛哈念”，意为“二营”；撒母耳记下二至四章记载伊施波设在此建都，大卫躲避押沙龙叛乱时也曾驻跸于此。位于约旦河东基列地，确切位置仍待考证。',
    '玛哈念从雅各的属灵相遇之地，演变为以色列王权更迭与内乱中的政治避难所，横跨数个世代的叙事。',
    '该地地处约旦河东交通要冲，战略地位使其屡次成为动荡时期的政治重心。'),
  ('mahanaim-reference','en','Genesis 32:1–2 records Jacob encountering angels here on his return journey, naming it Mahanaim (“two camps”). 2 Samuel 2–4 records it as Ish-bosheth’s capital, and David also took refuge here during Absalom’s rebellion. Located in Gilead east of the Jordan, its precise site remains uncertain.',
    'Mahanaim runs from Jacob’s spiritual encounter to a political refuge during Israel’s royal upheavals, spanning generations of narrative.',
    'Positioned at a crossroads east of the Jordan, its strategic value made it a recurring political center in times of unrest.'),

  ('rabbah-of-ammon','zh-CN','撒母耳记下十一至十二章记载约押围攻亚扪都城拉巴期间，大卫命人将乌利亚置于阵前借刀杀人、夺取拔示巴，城破后大卫方才亲赴受降；拉巴即今约旦首都安曼，古名沿用至今仍可辨认。',
    '拉巴之围是大卫王朝命运的转折点，他在此犯下的罪成为其后家族悲剧的根源。',
    '拉巴长期为亚扪人的政治中心，后经希腊化时期更名为费拉德尔菲亚，即今安曼的前身。'),
  ('rabbah-of-ammon','en','2 Samuel 11–12 records David arranging Uriah’s death at the front during Joab’s siege of Rabbah, the Ammonite capital, after taking Bathsheba, only to travel there himself once the city fell. Rabbah survives today as Amman, Jordan’s capital, its ancient name still traceable.',
    'The siege of Rabbah is a turning point for David’s dynasty—the sin committed here becomes the root of the family tragedies that follow.',
    'Rabbah was long the Ammonite political center, later renamed Philadelphia in the Hellenistic period, the forerunner of modern Amman.'),

  ('tyre','zh-CN','撒母耳记下五11及列王纪上五章记载，腓尼基王希兰与大卫、所罗门交好，由推罗供应香柏木与工匠，助建王宫与圣殿；这座海岛港城后来也是以西结书、以赛亚书等先知谴责骄傲与商贸罪恶的重要对象。',
    '推罗从所罗门盛世的友好盟邦，转变为先知书中骄傲必倾覆的典型象征，展现圣经对繁华的道德审视。',
    '推罗是古代地中海东岸最重要的海上贸易城邦之一，以精湛的航海与建筑技艺闻名于近东。'),
  ('tyre','en','2 Samuel 5:11 and 1 Kings 5 record the Phoenician king Hiram’s alliance with David and Solomon, supplying cedar and craftsmen for the palace and temple. This island port city later became a prime target of prophetic oracles—in Ezekiel and Isaiah—condemning pride and commercial excess.',
    'Tyre moves from a friendly ally in Solomon’s golden age to a byword in the prophets for pride destined to fall, showing Scripture’s moral scrutiny of prosperity.',
    'Tyre was one of the foremost maritime trading city-states on the eastern Mediterranean coast, renowned across the Near East for seafaring and architectural skill.'),

  ('wadi-cherith-reference','zh-CN','列王纪上十七2-7记载，以利亚在旱灾之初奉命藏身约旦河东的基立溪旁，乌鸦为他叼来饼和肉，直到溪水枯竭方才离开；传统或将此地与雅比溪相联系，确切位置无法考定。','',''),
  ('wadi-cherith-reference','en','1 Kings 17:2–7 records Elijah hiding by the Wadi Cherith, east of the Jordan, at the onset of the drought, fed by ravens until the stream dried up. Tradition sometimes links it with the Jabbok region, though its precise location cannot be established.','',''),

  ('zarephath','zh-CN','列王纪上十七8-24记载，以利亚奉命前往西顿所属的撒勒法，寄居于一寡妇家中，面粉与油不减，后来寡妇之子病死又蒙以利亚祷告复活；耶稣在路加福音四26也曾提及此事。今为黎巴嫩的萨拉凡德。',
    '撒勒法的神迹表明耶和华的怜悯超越以色列疆界，施及外邦寡妇，预示福音将临及万民。',
    '撒勒法自古隶属腓尼基西顿的辖境，是地中海沿岸的一处渔业与贸易小镇。'),
  ('zarephath','en','1 Kings 17:8–24 records Elijah sent to Zarephath, in Sidonian territory, where he lodged with a widow whose flour and oil never ran out, and whose son he later raised from death through prayer. Jesus cites this episode in Luke 4:26. Today it is Sarafand, Lebanon.',
    'The miracle at Zarephath shows the LORD’s mercy extending beyond Israel’s borders to a foreign widow, foreshadowing the gospel’s reach to all peoples.',
    'Zarephath had long belonged to Sidonian Phoenician territory, a small fishing and trading town on the Mediterranean coast.'),

  ('ramoth-gilead','zh-CN','列王纪上二十二章记载亚哈王联合犹大王约沙法夺回基列的拉末时中箭身亡，应验先知米该雅的预言；列王纪下九章记载先知门徒又在此膏立耶户为王，引发耶户革命。此地是以色列与亚兰反复争夺的边境重镇，一般认作鲁梅特丘遗址。',
    '基列的拉末两度成为北国王朝更替的引爆点，分别终结亚哈家与开启耶户王朝。',
    '该城扼守约旦河东通往大马士革的要道，长期是以色列与亚兰争夺的战略边界。'),
  ('ramoth-gilead','en','1 Kings 22 records King Ahab dying from an arrow wound while trying to retake Ramoth-gilead alongside Judah’s Jehoshaphat, fulfilling the prophet Micaiah’s warning. 2 Kings 9 records Jehu being anointed king here, sparking his revolution. This border stronghold, repeatedly contested by Israel and Aram, is generally identified with Tell Ramith.',
    'Ramoth-gilead twice serves as the flashpoint for a change of dynasty in the northern kingdom, ending the house of Ahab and launching that of Jehu.',
    'The city guarded the road east of the Jordan toward Damascus, long a contested strategic frontier between Israel and Aram.'),

  ('shunem','zh-CN','列王纪下四8-37记载，书念的一位富足妇人为以利沙预备楼房接待，以利沙为她求得儿子，孩子暴毙后又蒙以利沙祷告复活；书念位于耶斯列平原边缘，今为苏莱姆村，撒母耳记上二十八4也记载非利士人曾在此扎营。',
    '书念妇人的故事是以利沙神迹叙事中最细腻动人的一段，展现先知与平民之间的信任与恩典。',
    '书念地处耶斯列谷交通要道，自古是往来军队扎营与农商往来的必经之地。'),
  ('shunem','en','2 Kings 4:8–37 records a wealthy woman of Shunem preparing a room for Elisha, who obtained a son for her and later raised the boy from death through prayer. Shunem lies at the edge of the Jezreel Valley, today the village of Sulem; 1 Samuel 28:4 also records Philistines camping here before Saul’s final battle.',
    'The story of the Shunammite woman is among the most tender episodes in the Elisha narratives, showing the trust and grace between prophet and ordinary household.',
    'Shunem lay along a key route through the Jezreel Valley, long a natural stopping point for armies on the march and for agricultural trade.'),

  ('gath-hepher','zh-CN','列王纪下十四25记载先知约拿是迦特希弗人，他曾预言耶罗波安二世收复以色列边界；这座加利利地区的城镇是约拿书主人公在旧约叙事中唯一留下明确籍贯的先知故乡。','',''),
  ('gath-hepher','en','2 Kings 14:25 identifies the prophet Jonah as being from Gath-hepher, who prophesied Jeroboam II’s restoration of Israel’s borders. This Galilean town is the recorded hometown of the reluctant prophet whose story is told in the book of Jonah.','',''),

  ('tekoa','zh-CN','阿摩司书一1记载先知阿摩司出身犹大旷野边缘的牧人城镇提哥亚，原以牧羊、修理桑树为业，后蒙耶和华呼召往北国宣讲审判信息；撒母耳记下十四2也记载大卫曾从此地召来智慧妇人劝谏押沙龙之事。','',''),
  ('tekoa','en','Amos 1:1 identifies the prophet Amos as a shepherd from Tekoa, on the edge of the Judean wilderness, who tended sycamore figs before being called to preach judgment to the northern kingdom. 2 Samuel 14:2 also records David summoning a wise woman from Tekoa to intercede regarding Absalom.','','')
) AS v(slug, locale, detail, lit, hist)
WHERE t.location_id = l.id AND t.locale = v.locale::locale_code AND l.slug = v.slug
  AND l.work_id = '10000000-0000-4000-8000-000000000005';

-- 批次 5：约拿书 / 福音书 / 使徒行传
UPDATE location_translations t
SET detail = v.detail,
    literary_significance = COALESCE(NULLIF(v.lit, ''), t.literary_significance),
    historical_background = COALESCE(NULLIF(v.hist, ''), t.historical_background)
FROM locations l, (VALUES
  ('mediterranean-open-sea-reference','zh-CN','约拿书一4-15记载约拿为躲避耶和华的呼召，搭船逃往他施，途中海上忽起狂风大浪，水手们抽签得知缘由后将约拿抛入海中，风浪随即平息；此地代表约拿逃亡路线上遭遇风暴的东地中海海域，为示意性位置。','',''),
  ('mediterranean-open-sea-reference','en','Jonah 1:4–15 records a violent storm striking the ship as Jonah fled toward Tarshish to escape his calling; after casting lots to find the cause, the sailors threw Jonah overboard and the sea grew calm. This marker represents the eastern Mediterranean waters where the storm struck, a symbolic rather than precise location.','',''),

  ('mount-of-temptation-traditional','zh-CN','马太福音四1-11、路加福音四1-13记载耶稣受洗后被圣灵引到旷野，禁食四十昼夜后受魔鬼三次试探；传统上将此山地定位于耶利哥以西的犹大旷野，拜占庭时期以来即建有修道院纪念此事，但经文本身并未指明具体山名。','',''),
  ('mount-of-temptation-traditional','en','Matthew 4:1–11 and Luke 4:1–13 record Jesus, after his baptism, being led by the Spirit into the wilderness where he fasted forty days and nights before facing three temptations from the devil. Tradition locates this in the Judean wilderness west of Jericho, marked by a monastery since Byzantine times, though the Gospels themselves name no specific mountain.','',''),

  ('mount-of-beatitudes','zh-CN','马太福音五至七章记载耶稣在加利利湖畔的山坡上教导门徒与众人，以“八福”开篇阐述天国子民的品格，是耶稣最著名的登山宝训之地；此山名并非经文明指，乃后世传统依地理与地形推定，一般认为在迦百农附近的湖畔高地。',
    '登山宝训是耶稣教导的纲领性讲论，八福山因此成为基督教传统中最富象征意义的教导场景之一。',
    '拜占庭时期以来，此地陆续建有纪念教堂，现代所建的八福堂延续了这一朝圣传统。'),
  ('mount-of-beatitudes','en','Matthew 5–7 records Jesus teaching from a hillside above the Sea of Galilee, opening with the Beatitudes to describe the character of citizens of the kingdom—his best-known discourse, the Sermon on the Mount. The name is a later traditional designation rather than one given in the text, generally placed on high ground near the lake close to Capernaum.',
    'The Sermon on the Mount is the programmatic summary of Jesus’ teaching, making the Mount of Beatitudes one of the most symbolically charged teaching sites in Christian tradition.',
    'Memorial churches have stood here since Byzantine times, and the modern Church of the Beatitudes continues this pilgrimage tradition.'),

  ('machaerus','zh-CN','马太福音十四1-12、马可福音六17-29记载施洗约翰因指责希律安提帕娶兄弟之妻而下监，后因希罗底之女起舞讨希律欢心，约翰在狱中被斩首；犹太史家约瑟夫斯记载此事发生于死海东岸希律家族所建的马凯鲁斯山顶要塞。',
    '施洗约翰在马凯鲁斯之死，预示了耶稣自己将面临的苦难与逼迫的先声。',
    '马凯鲁斯要塞由大希律扩建，兼具军事防御与王室行宫功能，是希律家族在约旦河东最重要的据点之一。'),
  ('machaerus','en','Matthew 14:1–12 and Mark 6:17–29 record John the Baptist imprisoned for condemning Herod Antipas’ marriage to his brother’s wife, then beheaded in prison after Herodias’ daughter danced for Herod. The Jewish historian Josephus records this occurring at Machaerus, a hilltop fortress built by the Herodian dynasty on the eastern shore of the Dead Sea.',
    'John the Baptist’s death at Machaerus foreshadows the suffering and persecution Jesus himself would soon face.',
    'The fortress at Machaerus was expanded by Herod the Great, serving as both a military stronghold and a royal residence, one of the Herodian dynasty’s most important outposts east of the Jordan.'),

  ('caesarea-philippi','zh-CN','马太福音十六13-20、马可福音八27-30记载耶稣带门徒来到黑门山麓的该撒利亚腓立比境内，问门徒“你们说我是谁”，彼得回答“你是基督，是永生神的儿子”，耶稣随即预言教会的建立与自己的受难；这是一座希腊化色彩浓厚的城市，原为异教崇拜潘神之地。',
    '彼得在该撒利亚腓立比的认信，是福音书叙事的关键转折点，标志耶稣受难预告的开始。',
    '该城因希律家族兴建献给凯撒而得名，同时保留着敬拜潘神的古老异教传统，彰显耶稣宣教所处的多元宗教环境。'),
  ('caesarea-philippi','en','Matthew 16:13–20 and Mark 8:27–30 record Jesus, near Caesarea Philippi at the foot of Mount Hermon, asking his disciples “Who do you say I am?”—prompting Peter’s confession, “You are the Christ, the Son of the living God,” after which Jesus foretold the church’s founding and his own suffering. This Hellenistic city had long been a center of pagan worship of the god Pan.',
    'Peter’s confession at Caesarea Philippi is a key turning point in the Gospel narrative, marking the beginning of Jesus’ predictions of his own suffering.',
    'The city was named for its dedication to Caesar under the Herodian dynasty while retaining its ancient pagan association with the god Pan, reflecting the religiously pluralistic setting of Jesus’ ministry.'),

  ('lystra','zh-CN','使徒行传十四8-20记载保罗在路司得医好一生来瘸腿的人，当地人误以为保罗、巴拿巴是宙斯与希耳米神显现，欲向他们献祭，后又受挑唆用石头打保罗，以为他死了将他拖出城外；路司得也是提摩太的家乡（徒十六1）。',
    '路司得的狂喜献祭与随后的石刑，并列展现了保罗宣教历程中赞誉与逼迫的剧烈反差。',
    '路司得地处吕高尼内陆，当地民间信仰与希腊神话传说交融，是保罗初次深入小亚细亚腹地宣教的据点之一。'),
  ('lystra','en','Acts 14:8–20 records Paul healing a man lame from birth at Lystra, after which the crowd mistook Paul and Barnabas for the gods Zeus and Hermes and sought to sacrifice to them—only to later stone Paul and drag him out of the city for dead. Lystra was also Timothy’s hometown (Acts 16:1).',
    'The ecstatic sacrifice offered at Lystra and the stoning that follows it sit side by side, showing the violent swing between acclaim and persecution in Paul’s mission.',
    'Located inland in Lycaonia, Lystra blended local folk belief with Greek mythology, and was one of Paul’s early bases for reaching deep into the Anatolian interior.'),

  ('troas','zh-CN','使徒行传十六8-10记载保罗在特罗亚夜间见异象，一个马其顿人求他“过来帮助我们”，由此促成福音跨越爱琴海传入欧洲；二十7-12又记载保罗在此讲道直到半夜，少年犹推古坐在窗台打盹坠楼而死，保罗祷告使他复活。',
    '特罗亚的异象是使徒行传中宣教版图从亚洲跨入欧洲的关键转折点。',
    '特罗亚是爱琴海东岸的重要港口城市，邻近古代特洛伊遗址，为地中海东西航运的枢纽。'),
  ('troas','en','Acts 16:8–10 records Paul receiving a night vision at Troas of a Macedonian man pleading, “Come over and help us,” launching the gospel’s crossing into Europe. Acts 20:7–12 also records Paul preaching there until midnight, when young Eutychus, dozing in a window, fell to his death and was raised through Paul’s prayer.',
    'The vision at Troas is the key turning point in Acts where the mission’s map expands from Asia into Europe.',
    'Troas was a major port city on the eastern Aegean coast, near the site of ancient Troy, a hub for shipping between east and west in the Mediterranean.'),

  ('miletus','zh-CN','使徒行传二十17-38记载保罗第三次宣教旅程返回耶路撒冷途中，在米利都停留，请以弗所教会的长老前来，向他们语重心长地告别，叮嘱他们谨守群羊、防备残暴的豺狼，众人为此痛哭相拥；米利都位于以弗所以南的爱琴海岸，是古希腊著名的港口城邦。',
    '保罗在米利都对以弗所长老的告别演说，是使徒行传中最情真意切的临别嘱托，总结了他的宣教心志。',
    '米利都自古是爱奥尼亚地区的重要海港与文化中心，至保罗时代因港湾淤积已逐渐衰落。'),
  ('miletus','en','Acts 20:17–38 records Paul, en route to Jerusalem on his third missionary journey, stopping at Miletus to summon the Ephesian elders for a poignant farewell, urging them to guard the flock against savage wolves, prompting weeping embraces. Miletus lies on the Aegean coast south of Ephesus, a renowned port city of ancient Greece.',
    'Paul’s farewell speech to the Ephesian elders at Miletus is the most emotionally candid parting address in Acts, summarizing his missionary conviction.',
    'Miletus had long been a major port and cultural center of Ionia, though by Paul’s time its harbor was already silting up and its prominence fading.')
) AS v(slug, locale, detail, lit, hist)
WHERE t.location_id = l.id AND t.locale = v.locale::locale_code AND l.slug = v.slug
  AND l.work_id = '10000000-0000-4000-8000-000000000005';

COMMIT;
