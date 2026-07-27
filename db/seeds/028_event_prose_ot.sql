-- 028_event_prose_ot.sql
-- Bilingual detail/significance prose for Old Testament events that previously
-- lacked it, plus rewrites of telegraphic (<10-character) summaries.
-- Scope: primeval, patriarchs, exodus-and-sinai, wilderness-and-conquest,
-- judges, united-monarchy, divided-kingdoms, prophetic-narrative,
-- judah-and-exile, return-and-restoration. New Testament eras are handled
-- by a separate seed file and are not touched here.
--
-- Self-check (must be zero errors before loading for real):
--   sed 's/^COMMIT;$/ROLLBACK;/' db/seeds/028_event_prose_ot.sql \
--     | psql -d literary_atlas -v ON_ERROR_STOP=1 -f - 2>&1 | tail -5

-- =====================================================================
-- Batch 1: primeval, patriarchs, exodus-and-sinai, wilderness-and-conquest
-- =====================================================================
BEGIN;

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('birth-of-cain','zh-CN','亚当与夏娃出伊甸园后，夏娃怀孕生下长子该隐，说这是靠耶和华的帮助得了一个男子。该隐后来成为耕地的农夫。','人类繁衍的开端，引出该隐与亚伯的冲突。'),
  ('birth-of-cain','en','After leaving Eden, Eve conceives and bears her firstborn son, Cain, declaring she has gotten a man with the Lord’s help. Cain grows up to till the ground.','Marks the start of human procreation and sets up the conflict with Abel.'),
  ('flood-narrative-ends-at-ararat','zh-CN','洪水消退后，挪亚方舟停在亚拉腊山上；挪亚放出乌鸦与鸽子探测地面干燥的程度，最终全家和百兽出方舟。','洪水审判结束，人类与万物在新地上重新开始。'),
  ('flood-narrative-ends-at-ararat','en','As the floodwaters recede, Noah’s ark comes to rest on the mountains of Ararat; Noah sends out a raven and then doves to test whether the ground has dried, and finally he, his family, and the animals leave the ark.','Closes the flood judgment and opens a fresh start for humanity and creation.'),
  ('covenant-after-the-flood','zh-CN','挪亚出方舟献祭后，神与挪亚及其后裔立约，应许不再用洪水毁灭全地，并以彩虹作为立约的记号。','神与全人类立约，奠定普世秩序的基础。'),
  ('covenant-after-the-flood','en','After Noah offers sacrifice upon leaving the ark, God establishes a covenant with him and his descendants, promising never again to destroy the earth by flood, and sets the rainbow as its sign.','God’s covenant with all humanity, founding a universal order.'),
  ('dispersal-at-babel','zh-CN','示拿平原的人们联合建城筑塔，要传扬自己的名；耶和华变乱他们的口音，使众人不能明白彼此的话，于是众人分散在全地上。','解释语言与民族分散的起源，衔接列国谱系。'),
  ('dispersal-at-babel','en','The people of Shinar unite to build a city and a tower to make a name for themselves; the Lord confuses their language so they cannot understand one another, scattering them over the face of the earth.','Explains the origin of languages and nations, linking to the table of nations.'),
  ('abram-at-shechem','zh-CN','亚伯兰听从耶和华的呼召，离开哈兰进入迦南地，来到示剑的摩利橡树那里；耶和华向他显现，应许将这地赐给他的后裔，亚伯兰便在那里筑坛。','应许之地的旅程正式展开，标志族长叙事的起点。'),
  ('abram-at-shechem','en','Obeying the Lord’s call, Abram leaves Haran and enters Canaan, arriving at the oak of Moreh at Shechem, where the Lord appears and promises the land to his offspring; Abram builds an altar there.','The journey into the promised land formally begins, opening the patriarchal narrative.'),
  ('lot-settles-near-sodom','zh-CN','亚伯兰与侄儿罗得因牲畜众多、牧人相争，二人商定分开居住；罗得选择约旦河平原一带肥沃之地，渐渐迁移帐棚，直到所多玛城附近。','亲属分家的抉择，为所多玛的审判埋下伏笔。'),
  ('lot-settles-near-sodom','en','As their herds grow too large to share the land, Abram and his nephew Lot agree to separate; Lot chooses the well-watered Jordan plain and gradually moves his tents as far as Sodom.','A family’s parting choice that foreshadows Sodom’s coming judgment.'),
  ('destruction-of-the-sodom-cities','zh-CN','两位天使奉命毁灭所多玛与蛾摩拉，罗得一家在天亮前被催促逃离；耶和华降下硫磺与火，倾覆平原诸城，罗得的妻子因回头张望变成盐柱。','罪恶之城的审判，成为后世警戒的典型例证。'),
  ('destruction-of-the-sodom-cities','en','Two angels are sent to destroy Sodom and Gomorrah; Lot’s family is urged to flee before dawn as the Lord rains sulfur and fire on the cities of the plain, and Lot’s wife looks back and becomes a pillar of salt.','The judgment of the wicked cities, later invoked as a warning example.'),
  ('hagar-and-ishmael-in-the-wilderness','zh-CN','以撒断奶设宴后，撒拉见夏甲之子以实玛利戏笑，要求亚伯拉罕将母子二人赶出；夏甲带着孩子在别是巴的旷野迷路，神开她的眼看见水井，救了他们性命。','家族继承之争外溢，神仍眷顾被逐的母子。'),
  ('hagar-and-ishmael-in-the-wilderness','en','After Isaac’s weaning feast, Sarah sees Ishmael mocking and demands Abraham send Hagar and her son away; wandering lost in the wilderness of Beersheba, Hagar is shown a well by God, who saves their lives.','Fallout from the inheritance dispute, yet God still cares for the exiled mother and son.'),
  ('binding-of-isaac','zh-CN','神试验亚伯拉罕，命他将独子以撒献为燔祭；亚伯拉罕在摩利亚地准备行刑之际，耶和华的使者及时阻止，指示他用公羊代替，并再次应许赐福他的后裔。','族长叙事中信心考验的顶点，预表代赎的主题。'),
  ('binding-of-isaac','en','God tests Abraham by commanding him to offer his only son Isaac as a burnt offering on Mount Moriah; as he raises the knife, the angel of the Lord stops him, providing a ram as a substitute and renewing the blessing.','The supreme test of faith in the patriarchal story, foreshadowing substitutionary sacrifice.'),
  ('sarah-buried-at-hebron','zh-CN','撒拉在希伯仑去世，享寿一百二十七岁；亚伯拉罕向赫人以弗仑购买麦比拉洞作为坟地，正式在迦南地取得第一块产业。','族长家族在应许之地首次拥有合法产业。'),
  ('sarah-buried-at-hebron','en','Sarah dies at Hebron at the age of one hundred twenty-seven; Abraham purchases the cave of Machpelah from Ephron the Hittite as a burial site, gaining the family’s first legal holding in Canaan.','The patriarchal family’s first legally owned property in the promised land.'),
  ('rebekah-brought-from-harran','zh-CN','亚伯拉罕差遣老仆人回哈兰本族之地，为以撒寻找妻子；仆人在井旁认出利百加合乎神的心意，利百加同意随他返回迦南，成为以撒的妻子。','借由长途择偶延续应许的血统。'),
  ('rebekah-brought-from-harran','en','Abraham sends his servant back to Harran to find a wife for Isaac from his own kin; at a well the servant recognizes Rebekah as God’s chosen answer, and she agrees to return with him to become Isaac’s wife.','A journey to secure a bride ensures the promised line continues.'),
  ('jacob-takes-the-blessing','zh-CN','年迈失明的以撒欲为长子以扫祝福，利百加与雅各设计让雅各假扮以扫，披上羊皮骗得父亲的祝福；以扫发现后痛哭，雅各因此逃往哈兰躲避兄长的怒气。','欺瞒手段夺得长子名分，加剧兄弟间的仇隙。'),
  ('jacob-takes-the-blessing','en','The aged, blind Isaac intends to bless his firstborn Esau, but Rebekah and Jacob conspire so that Jacob, disguised in goatskins, deceives his father into blessing him instead; Esau weeps bitterly, and Jacob flees to Harran to escape his brother’s rage.','A deception secures the birthright blessing and deepens the brothers’ feud.'),
  ('jacobs-dream-at-bethel','zh-CN','雅各在逃往哈兰途中夜宿伯特利，枕石而眠，梦见一梯子直通天，神的使者上去下来；耶和华在梦中重申赐地与后裔的应许，雅各醒来后立石为柱，称那地为伯特利。','逃亡途中的异象确认神的应许不因人的过犯而废弃。'),
  ('jacobs-dream-at-bethel','en','Fleeing to Harran, Jacob stops for the night at Bethel and dreams of a stairway reaching to heaven with angels ascending and descending; the Lord renews the promise of land and offspring, and Jacob wakes to set up a stone pillar, naming the place Bethel.','A vision during his flight confirms God’s promise still stands.'),
  ('jacob-marries-leah-and-rachel','zh-CN','雅各在哈兰投靠舅父拉班，为迎娶拉结服事七年；婚礼之夜拉班却以长女利亚顶替，雅各又服事七年才娶得拉结，二女及其使女后来共为雅各生下十二个儿子的先祖。','以劳役换取婚约，埋下家族内部竞争的种子。'),
  ('jacob-marries-leah-and-rachel','en','Jacob takes refuge with his uncle Laban in Harran and serves seven years to marry Rachel, but on the wedding night Laban substitutes the elder daughter Leah instead; Jacob serves another seven years for Rachel, and the two sisters and their maids become the mothers of his twelve sons.','A labor-for-marriage bargain that sows rivalry within the family.'),
  ('jacob-and-esau-reconcile','zh-CN','雅各在雅博渡口与神摔跤后改名以色列，次日鼓起勇气面对多年未见的以扫；以扫却奔来拥抱、亲吻雅各，兄弟二人相拥而泣，冰释前嫌。','长年的兄弟仇怨在渡口之后得以化解。'),
  ('jacob-and-esau-reconcile','en','After wrestling with God at the ford of Jabbok and being renamed Israel, Jacob musters courage to meet Esau, whom he has not seen for years; Esau runs to embrace and kiss him, and the brothers weep together, their old quarrel resolved.','The brothers’ long-standing feud is resolved after the encounter at the ford.'),
  ('rachel-buried-near-bethlehem','zh-CN','雅各全家从伯特利继续南行，途中拉结在快到以法他（即伯利恒）时难产而死，临终前为幼子起名便俄尼，雅各改称便雅悯，并在她墓上立了一根柱子。','迁徙途中的丧亲之痛，也标记出便雅悯支派的起源。'),
  ('rachel-buried-near-bethlehem','en','As Jacob’s household journeys on from Bethel, Rachel dies in childbirth just short of Ephrath (Bethlehem); with her last breath she names the boy Ben-oni, but Jacob calls him Benjamin, and sets up a pillar over her grave.','A death on the road that also marks the origin of the tribe of Benjamin.'),
  ('joseph-sold-into-egypt','zh-CN','约瑟因父亲偏爱及他所做的梦而遭众兄嫉恨，兄长们将他丢入枯井后又卖给经过的以实玛利商队，商队再将他转卖到埃及；兄弟们把约瑟的彩衣染血带回骗父亲说他被野兽吞吃。','兄弟的嫉妒把约瑟送往埃及，开启家族命运的转折。'),
  ('joseph-sold-into-egypt','en','Resented by his brothers for his father’s favoritism and his dreams, Joseph is thrown into a pit and sold to a passing caravan of Ishmaelites, who carry him to Egypt; the brothers dip his robe in blood and tell Jacob a wild animal has devoured him.','Sibling jealousy sends Joseph to Egypt, turning the family’s fortunes.'),
  ('joseph-rises-in-egypt','zh-CN','约瑟在埃及先作护卫长波提乏的家宰，后因主母诬告下监；他在狱中为法老的酒政与膳长解梦，又准确解出法老七年丰收七年饥荒的梦，法老遂立他为埃及的宰相，管理全地粮政。','从囚徒晋升为宰相，展现神在患难中的护理。'),
  ('joseph-rises-in-egypt','en','In Egypt Joseph becomes overseer of Potiphar’s house, then is imprisoned on a false charge; after interpreting dreams for Pharaoh’s cupbearer and baker, and then Pharaoh’s own dream of seven years of plenty and famine, Pharaoh sets him over all Egypt to manage its grain.','A rise from prisoner to prime minister showing God’s providence in adversity.'),
  ('brothers-reunite-in-egypt','zh-CN','饥荒中约瑟的兄长们下埃及籴粮，向宰相下拜却认不出他是约瑟；约瑟几番试探后再也忍不住，向兄弟们表明身份，众人相拥而泣，家族的裂痕得以弥合。','失散多年的兄弟相认，化解昔日的仇怨。'),
  ('brothers-reunite-in-egypt','en','During the famine Joseph’s brothers come down to Egypt to buy grain and bow before the vizier without recognizing him; after testing them, Joseph can no longer restrain himself and reveals his identity, and the brothers embrace and weep, healing the old rift.','Long-separated brothers recognize one another, mending past wrongs.'),
  ('household-settles-in-goshen','zh-CN','约瑟差人接父亲雅各全家下埃及躲避饥荒；法老因约瑟的缘故厚待他们，将歌珊地赐给雅各一家牧放牲畜，以色列人从此在埃及安居繁衍。','族长叙事在此过渡到以色列人寄居埃及的时代。'),
  ('household-settles-in-goshen','en','Joseph sends for his father Jacob and the whole household to escape the famine in Egypt; for Joseph’s sake Pharaoh grants them the land of Goshen to graze their flocks, and Israel settles and multiplies there.','The patriarchal narrative gives way to Israel’s sojourn in Egypt.'),
  ('birth-of-moses-in-goshen','zh-CN','埃及新王恐惧以色列人繁盛，下令将希伯来男婴溺死河中；利未家一妇人生下摩西后将他藏了三个月，其后放入蒲草箱置于河边，法老女儿拾得并收他为养子。','压迫政策下的存留，为日后的拯救者预备道路。'),
  ('birth-of-moses-in-goshen','en','Fearing Israel’s growing numbers, a new Pharaoh orders Hebrew baby boys drowned in the Nile; a Levite woman hides her son for three months, then sets him afloat in a basket among the reeds, where Pharaoh’s daughter finds and adopts him as Moses.','A survival under oppression that prepares the future deliverer.'),
  ('moses-flees-to-midian','zh-CN','摩西成年后见一埃及人殴打希伯来人，愤而将那埃及人打死并埋在沙中；事情败露后他惧怕法老追究，逃往米甸地，在井旁帮助祭司流珥的女儿们，后娶其女西坡拉为妻。','杀人出逃使摩西离开宫廷，转入旷野牧羊的生涯。'),
  ('moses-flees-to-midian','en','Seeing an Egyptian beating a Hebrew, the grown Moses strikes the Egyptian dead and buries him in the sand; when this becomes known he flees Pharaoh’s wrath to Midian, where he helps the priest Jethro’s daughters at a well and later marries Zipporah.','A killing forces Moses out of the palace into a shepherd’s life in Midian.'),
  ('call-at-the-burning-bush','zh-CN','摩西在何烈山牧羊时，见荆棘着火却不烧毁，神从其中呼唤他的名字，自称是亚伯拉罕、以撒、雅各的神；神差他回埃及带领以色列人出来，并赐他行神迹的能力以坚固信心。','旷野中的委任，正式开启拯救以色列的使命。'),
  ('call-at-the-burning-bush','en','While shepherding at Horeb, Moses sees a bush ablaze yet unconsumed; God calls to him from within it, identifying himself as the God of Abraham, Isaac, and Jacob, and commissions him to lead Israel out of Egypt, giving him signs to strengthen his faith.','A wilderness commissioning formally launches the mission to deliver Israel.'),
  ('confrontation-with-pharaoh','zh-CN','摩西与亚伦多次求见法老，要求释放以色列人，却屡遭拒绝并加重劳役；耶和华藉着一连串灾害——由血灾到长子之死——击打埃及，法老才终于让步允许以色列人离开。','一系列对抗与神迹迫使法老松手，促成出埃及的实现。'),
  ('confrontation-with-pharaoh','en','Moses and Aaron repeatedly confront Pharaoh demanding Israel’s release, only to face refusal and harsher labor; the Lord strikes Egypt with a series of plagues, from blood to the death of the firstborn, until Pharaoh finally relents and lets Israel go.','A cycle of confrontation and plagues forces Pharaoh to release Israel.'),
  ('crossing-of-the-sea','zh-CN','以色列人出埃及后被法老的军队追至海边，耶和华使摩西伸杖分开海水，以色列人从干地中过去；埃及追兵随后进入海中，海水复合，全军尽没。','出埃及叙事的核心神迹，确立耶和华拯救者的形象。'),
  ('crossing-of-the-sea','en','Trapped at the sea by Pharaoh’s pursuing army, Israel watches as Moses stretches out his staff and the Lord parts the waters, letting the people cross on dry ground; when the Egyptian army follows, the waters return and drown them.','The central miracle of the exodus, establishing the Lord as deliverer.'),
  ('song-at-the-sea','zh-CN','以色列人过红海得救后，摩西与百姓一同歌唱，赞美耶和华战胜马和骑兵的大能；米利暗又率妇女击鼓跳舞，以诗歌形式回应刚才的拯救。','以诗歌确认并纪念刚发生的拯救大能。'),
  ('song-at-the-sea','en','After crossing the sea to safety, Moses and the Israelites sing together in praise of the Lord’s triumph over horse and rider; Miriam leads the women with tambourines and dancing in response to the deliverance.','A hymn that commemorates and confirms the deliverance just witnessed.'),
  ('jethro-advises-a-court-system','zh-CN','摩西的岳父叶忒罗来到旷野探望，见摩西独自审断百姓的事从早忙到晚；他建议摩西设立千夫长、百夫长等分层官长处理小事，只将大事呈给摩西，摩西采纳了这建议。','建立分层治理制度，为日后的司法与行政奠定模式。'),
  ('jethro-advises-a-court-system','en','Moses’ father-in-law Jethro visits the camp and sees Moses judging the people alone from morning to evening; he advises appointing officials over thousands, hundreds, fifties, and tens to handle minor cases, leaving only major matters to Moses, and Moses adopts the plan.','Establishes a tiered system of governance, a model for later administration.'),
  ('golden-calf-episode','zh-CN','摩西在西奈山上迟迟未归，百姓催逼亚伦造神像；亚伦收集金环铸成金牛犊，百姓向它献祭跳舞。摩西下山见状怒摔法版，命利未人击杀带头作恶者，并为百姓的罪向神代求。','立约刚成便遭破坏，暴露百姓的悖逆与摩西的中保角色。'),
  ('golden-calf-episode','en','When Moses delays on Mount Sinai, the people pressure Aaron into making them a god; Aaron casts a golden calf from their earrings, and the people sacrifice and dance before it. Moses comes down, smashes the tablets in anger, has the Levites strike down the ringleaders, and intercedes for the people.','The covenant is broken almost as soon as it is made, exposing both the people’s rebellion and Moses’ role as mediator.'),
  ('scouts-sent-from-kadesh','zh-CN','以色列人到达加低斯附近后，摩西按耶和华吩咐从十二支派各派一人前往窥探迦南地；探子们四十天后回来，带回葡萄等土产，却对当地居民的强大意见分歧。','侦察行动的结果引发信心与恐惧的正面冲突。'),
  ('scouts-sent-from-kadesh','en','Near Kadesh, Moses sends one leader from each of the twelve tribes to scout out Canaan as the Lord commands; after forty days the scouts return with grapes and other produce but disagree sharply over whether Israel can overcome the land’s strong inhabitants.','The reconnaissance triggers a direct clash between faith and fear.'),
  ('long-stay-at-kadesh','zh-CN','因十个探子的负面报告，百姓惧怕不肯上去征战，耶和华判他们在旷野飘流四十年，直到那一代人都死尽；加低斯及其周边成为以色列人长期停留、间或迁移的据点。','因不信而受罚的漫长岁月，构成一代人的终结与新生代的兴起。'),
  ('long-stay-at-kadesh','en','Because of the scouts’ discouraging report, the people refuse to advance and the Lord sentences them to forty years of wandering until that generation dies out; Kadesh and its surroundings become the base for this long, largely stationary period.','A long punishment for unbelief that marks the end of one generation and the rise of the next.'),
  ('death-of-aaron','zh-CN','以色列人从加低斯起行到何珥山，摩西奉耶和华之命带亚伦与其子以利亚撒上山，将祭司的圣衣从亚伦身上脱下给以利亚撒穿上；亚伦随即在山顶去世，全会众为他哀哭三十天。','首任大祭司离世，祭司职分平稳交接给下一代。'),
  ('death-of-aaron','en','Traveling from Kadesh to Mount Hor, Moses, at the Lord’s command, takes Aaron and his son Eleazar up the mountain and transfers the priestly garments from Aaron to Eleazar; Aaron dies there, and the whole community mourns him for thirty days.','The first high priest dies as the priesthood passes smoothly to the next generation.'),
  ('moses-views-canaan-from-nebo','zh-CN','摩西在临终前登上尼波山的毗斯迦山顶，耶和华使他遥望全应许之地，却告诉他不得进入；摩西在摩押地去世，安葬之处无人知道，以色列人为他哀哭三十日。','领受律法之人止步于应许地之外，象征一个时代的完结。'),
  ('moses-views-canaan-from-nebo','en','Before his death Moses climbs Pisgah on Mount Nebo, where the Lord shows him the whole promised land but tells him he may not enter it; Moses dies in Moab, is buried in an unknown place, and Israel mourns him thirty days.','The lawgiver halts just short of the promised land, closing out an era.'),
  ('scouts-sheltered-by-rahab','zh-CN','约书亚从什亭差遣两名探子暗中侦察耶利哥城；妓女喇合将他们藏在屋顶的麻秸中，瞒过王的搜捕，并要求探子日后攻城时保全她全家性命，探子应允并系上红绳为记。','本地居民的协助为攻城行动提供关键情报与内应。'),
  ('scouts-sheltered-by-rahab','en','Joshua sends two spies from Shittim to scout Jericho in secret; the prostitute Rahab hides them under stalks of flax on her roof, evading the king’s search, and secures a promise that her family will be spared when the city falls, marked by a scarlet cord.','A local resident’s help provides crucial intelligence and an inside contact for the coming siege.'),
  ('crossing-the-jordan','zh-CN','以色列人在约书亚率领下抵达约旦河边，抬约柜的祭司脚一沾水，河水便在上游断流，全会众从干地上过河；约书亚又命人从河中取十二块石头立在吉甲作为纪念。','渡河标志旷野漂流结束，正式进入应许之地。'),
  ('crossing-the-jordan','en','Led by Joshua, Israel reaches the Jordan; as the priests carrying the ark step into the water, the river stops flowing upstream, and the whole nation crosses on dry ground. Joshua then has twelve stones set up at Gilgal as a memorial.','The crossing ends the wilderness wandering and formally begins entry into the promised land.'),
  ('fall-of-jericho','zh-CN','以色列人绕耶利哥城而行，祭司吹角，第七日绕城七次后众人呐喊，城墙随即塌陷，以色列人攻入城中，将城中的人与牲畜尽行毁灭，只留喇合一家；此役有关的考古证据至今仍存争议。','征战叙事的开端之战，也是学界争论最多的考古个案之一。'),
  ('fall-of-jericho','en','Israel marches around Jericho for seven days as priests blow trumpets; on the seventh day, after seven circuits, the people shout and the walls collapse, allowing Israel to take the city, destroying all but Rahab’s household. The archaeological evidence for the event remains disputed.','The opening battle of the conquest, and one of the most contested cases in biblical archaeology.'),
  ('shrine-set-up-at-shiloh','zh-CN','迦南地大致平定后，以色列全会众聚集在示罗，将会幕支搭在那里，作为分配余下土地与敬拜耶和华的中心；示罗因此在士师时期长期担任宗教中心的角色。','会幕落脚示罗，确立士师时期的中央敬拜地点。'),
  ('shrine-set-up-at-shiloh','en','With Canaan largely subdued, the whole community of Israel gathers at Shiloh and sets up the tent of meeting there as the center for allotting the remaining land and worshiping the Lord, a role Shiloh retains throughout the period of the judges.','The tabernacle’s placement at Shiloh establishes the central place of worship for the judges era.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

UPDATE event_translations t SET summary = v.summary
FROM events e, (VALUES
  ('birth-of-cain','zh-CN','夏娃在伊甸园外生下长子该隐，成为亚当家族的第一代子嗣。'),
  ('birth-of-cain','en','Eve bears Cain, Adam and Eve’s firstborn son, born outside Eden.'),
  ('jacobs-dream-at-bethel','zh-CN','雅各逃亡途中夜宿伯特利，梦见天梯并领受神的应许。'),
  ('jacobs-dream-at-bethel','en','Fleeing to Harran, Jacob dreams at Bethel of a stairway to heaven.'),
  ('rachel-buried-near-bethlehem','zh-CN','雅各一家南行途中，拉结在近伯利恒处难产而死。'),
  ('rachel-buried-near-bethlehem','en','Rachel dies in childbirth near Bethlehem as Jacob’s household journeys south.'),
  ('moses-flees-to-midian','zh-CN','摩西因失手打死埃及人而逃往米甸，在当地牧羊安家。'),
  ('moses-flees-to-midian','en','After killing an Egyptian, Moses flees to Midian and becomes a shepherd.'),
  ('call-at-the-burning-bush','zh-CN','摩西在何烈山的荆棘火焰中蒙神呼召，受命带领以色列出埃及。'),
  ('call-at-the-burning-bush','en','At Horeb’s burning bush, God calls Moses to lead Israel out of Egypt.'),
  ('jethro-advises-a-court-system','zh-CN','叶忒罗建议摩西设立分层官长，减轻独自审案的重担。'),
  ('jethro-advises-a-court-system','en','Jethro advises Moses to appoint officials to share the burden of judging.'),
  ('long-stay-at-kadesh','zh-CN','因探子的负面报告，以色列人在加低斯一带滞留近四十年。'),
  ('long-stay-at-kadesh','en','Israel lingers near Kadesh for nearly forty years after the scouts’ report.'),
  ('death-of-aaron','zh-CN','亚伦在何珥山去世，祭司圣衣转交其子以利亚撒。'),
  ('death-of-aaron','en','Aaron dies on Mount Hor as the priesthood passes to his son Eleazar.'),
  ('moses-views-canaan-from-nebo','zh-CN','摩西在尼波山远眺应许之地后去世，未能亲自进入。'),
  ('moses-views-canaan-from-nebo','en','Moses views the promised land from Nebo, then dies without entering it.'),
  ('crossing-the-jordan','zh-CN','约书亚率以色列人踏干地渡过约旦河，正式进入迦南。'),
  ('crossing-the-jordan','en','Joshua leads Israel across the Jordan on dry ground into Canaan.'),
  ('shrine-set-up-at-shiloh','zh-CN','以色列全会众在示罗支搭会幕，作为中央敬拜之地。'),
  ('shrine-set-up-at-shiloh','en','Israel sets up the tabernacle at Shiloh as its central place of worship.')
) AS v(slug, locale, summary)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

COMMIT;

-- =====================================================================
-- Batch 2: judges, united-monarchy
-- =====================================================================
BEGIN;

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('deborah-and-barak-muster-at-tabor','zh-CN','女先知底波拉传耶和华的话，命巴拉率一万人上他泊山迎战迦南将军西西拉的军队；巴拉要求底波拉同去，底波拉应允但预言荣耀将归于一名妇人之手。','先知与将领联合行动，开启对迦南势力的反击。'),
  ('deborah-and-barak-muster-at-tabor','en','The prophetess Deborah relays the Lord’s command for Barak to muster ten thousand men on Mount Tabor against the Canaanite general Sisera’s forces; Barak insists Deborah go with him, and she agrees, though she foretells the glory will go to a woman instead.','A joint action by prophet and commander launches the counterattack against Canaanite power.'),
  ('battle-near-megiddo','zh-CN','以色列军队在他泊山下冲下迎战西西拉的铁车部队，耶和华使敌军在基顺河边溃乱；西西拉弃车徒步逃走，最终被雅亿用帐棚橛子钉死。这场战役以散文与底波拉之歌两种版本流传。','士师时期最重要的胜仗之一，兼具战事与诗歌两种记述。'),
  ('battle-near-megiddo','en','Israel’s forces charge down from Tabor against Sisera’s iron chariots, and the Lord throws the enemy into confusion near the Kishon River; Sisera flees on foot and is finally killed by Jael with a tent peg. The battle survives in both a prose account and the Song of Deborah.','One of the judges era’s decisive victories, preserved in both narrative and poetic form.'),
  ('gideon-reduces-his-force','zh-CN','耶和华以基甸的三万二千人太多为由，先叫惧怕的人回去，又用饮水的方式甄选，最后只留三百人；这支小队夜间以火把、瓶子与号角突袭米甸营地，使敌军自相残杀溃逃。','以少胜多的安排，凸显得胜在于耶和华而非人数。'),
  ('gideon-reduces-his-force','en','Judging Gideon’s army of thirty-two thousand too large, the Lord has the fearful sent home and then selects men by how they drink from a stream, leaving only three hundred; this small band routs the Midianite camp at night with torches, jars, and trumpets, throwing the enemy into panicked self-slaughter.','A deliberate reduction in numbers shows victory rests with the Lord, not troop strength.'),
  ('samson-among-the-philistine-cities','zh-CN','参孙在亭拿娶非利士女子为妻，婚宴上因谜语之赌与非利士人结怨，他先后在亚实基伦击杀三十人、又用狐狸尾巴焚烧非利士人的田地，个人恩怨逐渐升级为两族间的冲突。','私人纠纷不断扩大，演变为以色列与非利士的对抗。'),
  ('samson-among-the-philistine-cities','en','Samson marries a Philistine woman at Timnah, and a wager over a riddle at the wedding feast sparks conflict; he kills thirty men at Ashkelon and later burns Philistine grain fields using foxes with torches tied to their tails, escalating a personal grudge into a wider clash between the two peoples.','A private quarrel keeps escalating into open conflict between Israel and the Philistines.'),
  ('samson-and-delilah','zh-CN','参孙爱上梭烈谷的女子大利拉，非利士首领买通她探问参孙力量的秘密；大利拉三次试探失败后仍不放弃，参孙终于说出力气在于从未剪过的头发，大利拉趁他熟睡剪去他的头发，参孙力量尽失被擒。','背叛导致大能士师力量丧失，落入敌手受辱。'),
  ('samson-and-delilah','en','Samson falls in love with Delilah of the Sorek valley, and the Philistine lords bribe her to discover the secret of his strength; after three failed attempts she persists until he reveals it lies in his uncut hair, and while he sleeps she has it shaved off, leaving him powerless and captured.','Betrayal strips the mighty judge of his strength and delivers him into enemy hands.'),
  ('samson-at-gaza','zh-CN','非利士人挖去参孙的双眼，将他锁在迦萨磨坊做苦工；一次庆典中众人带他出来戏弄取乐，参孙趁机祷告求神再赐力量，双手推倒庙宇两根柱子，与在场的非利士人同归于尽。','以自我牺牲收束参孙的士师生涯，完成最后的复仇。'),
  ('samson-at-gaza','en','Blinded by the Philistines, Samson is put to grinding labor in the Gaza prison; brought out to be mocked at a festival, he prays for one last surge of strength and pushes down the temple’s two central pillars, dying together with the Philistines gathered there.','Self-sacrifice closes out Samson’s career as judge in one final act of vengeance.'),
  ('naomi-and-ruth-reach-bethlehem','zh-CN','拿俄米因饥荒携夫及二子迁居摩押，丈夫与儿子相继去世后，她决定返回伯利恒；儿媳路得坚持随她同去，并说“你的国就是我的国，你的神就是我的神”，二人一同回到伯利恒。','外邦女子的忠诚，开启一段跨族群的归回叙事。'),
  ('naomi-and-ruth-reach-bethlehem','en','Famine drives Naomi to Moab with her husband and two sons, but after all three men die she decides to return to Bethlehem; her daughter-in-law Ruth insists on going with her, declaring “your people shall be my people, and your God my God,” and the two women arrive together in Bethlehem.','A foreign woman’s loyalty opens a story of return across ethnic lines.'),
  ('ruth-and-boaz-at-the-threshing-floor','zh-CN','拿俄米指点路得趁波阿斯在禾场扬完大麦、心中畅快之时，夜里悄悄躺卧在他脚边；波阿斯醒来发现路得，称赞她的贤德，应允若有更近的亲属不愿尽赎回本分，自己必娶她为妻。','借赎业习俗推进婚约，为大卫家系铺路。'),
  ('ruth-and-boaz-at-the-threshing-floor','en','Naomi instructs Ruth to lie down at Boaz’s feet on the threshing floor after he finishes winnowing barley in good spirits; Boaz wakes to find her there, praises her loyalty, and promises to marry her himself if a nearer kinsman-redeemer declines.','The redeemer custom advances the marriage that leads toward David’s lineage.'),
  ('samuel-serves-at-shiloh','zh-CN','幼年的撒母耳由母亲哈拿献给耶和华，在示罗跟随祭司以利事奉；一夜耶和华三次呼唤撒母耳的名字，以利终于明白是神在呼召，撒母耳由此开始担任先知，成年后带领以色列人。','士师时代向王国时代过渡的关键人物由此登场。'),
  ('samuel-serves-at-shiloh','en','Given by his mother Hannah to serve the Lord, young Samuel ministers at Shiloh under the priest Eli; one night the Lord calls Samuel’s name three times, and Eli realizes it is God calling him, marking the start of Samuel’s role as prophet and eventual leader of Israel.','Introduces the pivotal figure who bridges the age of judges and the age of kings.'),
  ('samuel-anoints-saul','zh-CN','百姓要求立王治理，撒母耳奉耶和华指示膏立便雅悯人扫罗为以色列首位君王；撒母耳将膏油倒在扫罗头上并亲吻他，随后众人抽签确认，扫罗正式受膏为王。','士师制度终结，以色列君主制正式建立。'),
  ('samuel-anoints-saul','en','Responding to the people’s demand for a king, Samuel, guided by the Lord, anoints Saul of Benjamin as Israel’s first king, pouring oil on his head and kissing him; the choice is then confirmed by lot before the assembly.','Ends the era of judges and formally establishes Israel’s monarchy.'),
  ('saul-rejected-at-ramah','zh-CN','耶和华命扫罗灭尽亚玛力人及其一切所有，扫罗却留下亚甲王和上好的牛羊；撒母耳在拉玛见扫罗辩解为要献祭，遂宣告耶和华已因他的悖逆弃绝他作王，扫罗撕裂撒母耳衣角为记。','王权首次因悖逆神命而被废，先知与君王正式决裂。'),
  ('saul-rejected-at-ramah','en','The Lord commands Saul to destroy the Amalekites and all they have, but Saul spares King Agag and the best of the livestock; at Ramah, Samuel rejects Saul’s excuse of wanting to sacrifice and declares that the Lord has rejected him as king, tearing his robe as a sign.','The first royal rejection for disobedience marks a formal break between prophet and king.'),
  ('samuel-anoints-david-at-bethlehem','zh-CN','耶和华差撒母耳到伯利恒耶西家中另立新王，撒母耳依次察看耶西的儿子们，都不是耶和华所拣选的，直到最小的牧童大卫从田间被召回；撒母耳当着众兄长的面膏立大卫，耶和华的灵便大大感动他。','王权转移悄然展开，为日后大卫登基埋下伏笔。'),
  ('samuel-anoints-david-at-bethlehem','en','The Lord sends Samuel to Jesse’s house in Bethlehem to anoint a new king; each of Jesse’s older sons is passed over until the youngest, the shepherd boy David, is brought in from the field, and Samuel anoints him before his brothers as the Spirit of the Lord comes powerfully upon him.','The transfer of kingship quietly begins, setting up David’s eventual rise.'),
  ('david-and-goliath-in-the-valley-of-elah','zh-CN','非利士与以色列两军在以拉谷对峙，非利士巨人歌利亚天天出来骂阵挑战，无人敢应战；牧童大卫自告奋勇，不披甲胄只用甩石机弦，一石击中歌利亚额头将他打死，非利士军随即溃逃。','个人的信心与勇气扭转两军对峙的局面。'),
  ('david-and-goliath-in-the-valley-of-elah','en','With Israel and the Philistines facing off across the valley of Elah, the giant Goliath taunts Israel’s army daily and no one dares answer; the young David volunteers, and with a single stone from his sling strikes Goliath dead, sending the Philistine army fleeing.','One young man’s courage and faith turn the tide of a standoff between armies.'),
  ('jonathan-and-david-make-a-covenant','zh-CN','大卫杀死歌利亚后，扫罗的儿子约拿单从心里爱大卫如同爱自己的性命，二人立约结为盟友；约拿单将身上的外袍、战衣、刀、弓和腰带都给了大卫，作为盟约的表记。','王子与未来君王的情谊，将贯穿日后的宫廷冲突。'),
  ('jonathan-and-david-make-a-covenant','en','After David kills Goliath, Jonathan, Saul’s son, loves David as his own soul and makes a covenant with him; Jonathan gives David his robe, armor, sword, bow, and belt as tokens of the bond between them.','A bond between a prince and the future king that will run through the coming court conflict.'),
  ('david-a-fugitive-in-the-south','zh-CN','扫罗因嫉妒屡次要杀大卫，大卫被迫离开宫廷，辗转于挪伯、迦特、亚杜兰洞、西弗旷野与隐基底等地躲藏；期间他曾两次有机会杀死扫罗却都手下留情，只在暗中割下扫罗的衣襟为证。','长期逃亡历练大卫的忍耐，也显明他不害王命的原则。'),
  ('david-a-fugitive-in-the-south','en','Hunted by a jealous Saul, David is forced from the court and moves between Nob, Gath, the cave of Adullam, the wilderness of Ziph, and En Gedi; twice given the chance to kill Saul, he spares him each time, once only cutting off a corner of his robe as proof.','The long years as a fugitive test David’s patience and demonstrate his refusal to harm the Lord’s anointed.'),
  ('abigail-intercedes','zh-CN','大卫的部下曾保护财主拿八的羊群，大卫派人求些食物却遭拿八羞辱拒绝，大卫盛怒之下要率人报复；拿八之妻亚比该闻讯急忙备下礼物迎见大卫，好言劝阻，使大卫免于流无辜人的血。','一位妇人的斡旋阻止了一场不必要的杀戮。'),
  ('abigail-intercedes','en','David’s men had protected the flocks of the wealthy Nabal, but when David sends to ask for provisions, Nabal insults and refuses him, prompting David to ride out for revenge; Nabal’s wife Abigail rushes to meet David with gifts and wise words, persuading him not to shed innocent blood.','One woman’s mediation averts a needless act of vengeance.'),
  ('saul-and-jonathan-die-on-gilboa','zh-CN','非利士人在基利波山与以色列交战，扫罗的三个儿子（包括约拿单）阵亡；扫罗身受重伤，为免落入敌手受辱，伏在自己刀上自尽，非利士人次日发现尸首，将其钉在伯珊城墙上示众。','扫罗王朝随其战死而终结，为大卫登基扫清道路。'),
  ('saul-and-jonathan-die-on-gilboa','en','The Philistines defeat Israel on Mount Gilboa, killing three of Saul’s sons including Jonathan; badly wounded and unwilling to be captured and mocked, Saul falls on his own sword, and the Philistines later fasten his body to the wall of Beth-shan.','Saul’s dynasty ends with his death in battle, clearing the way for David’s kingship.'),
  ('bathsheba-and-nathans-rebuke','zh-CN','大卫在王宫顶上看见拔示巴沐浴，便召她同房致其怀孕，又设计使她丈夫乌利亚战死沙场以掩盖罪行；先知拿单借穷人夺羊的比喻当面指责大卫，大卫承认自己犯了罪。','权力滥用引发的道德危机，先知的责备迫使君王悔改。'),
  ('bathsheba-and-nathans-rebuke','en','David sees Bathsheba bathing from his rooftop, summons her, and gets her pregnant, then arranges for her husband Uriah to die in battle to cover his sin; the prophet Nathan confronts David with a parable about a poor man’s ewe lamb, and David confesses his guilt.','An abuse of royal power triggers a moral crisis, and a prophet’s rebuke forces the king’s confession.'),
  ('absaloms-revolt','zh-CN','大卫之子押沙龙多年暗中收买民心，终于在希伯仑自立为王，率众叛变；大卫仓皇带随从逃离耶路撒冷，避难约旦河对岸，一场父子间的政权危机就此爆发。','家族内部的仇怨升级为动摇王位的公开叛乱。'),
  ('absaloms-revolt','en','David’s son Absalom, having quietly won the people’s favor for years, proclaims himself king at Hebron and leads a rebellion; David flees Jerusalem in haste with his loyal followers, taking refuge across the Jordan as a crisis between father and son erupts into open revolt.','A festering family grievance escalates into an open rebellion that threatens the throne.'),
  ('death-of-absalom','zh-CN','大卫的军队在以法莲树林与押沙龙的叛军交战，押沙龙骑骡逃跑时头发被橡树枝缠住，悬挂半空；约押不顾大卫吩咐不可伤害他儿子的命令，将押沙龙刺死，随后全军班师。','叛乱平息，却以父亲丧子的悲痛作为代价。'),
  ('death-of-absalom','en','David’s forces meet Absalom’s rebel army in the forest of Ephraim; fleeing on a mule, Absalom’s hair catches in the branches of a great oak, leaving him suspended, and Joab kills him despite David’s explicit order to spare his son.','The revolt ends, but at the cost of a father’s grief over his son’s death.'),
  ('solomon-succeeds-david','zh-CN','大卫年老体衰之际，儿子亚多尼雅擅自设宴自立为王，拿单与拔示巴急忙提醒大卫立所罗门的旧誓；大卫下令立即膏立所罗门为王，公开确认继承地位，平息了这场宫廷继承的危机。','继承之争尘埃落定，所罗门顺利登上王位。'),
  ('solomon-succeeds-david','en','As the aging David weakens, his son Adonijah proclaims himself king at a feast without authorization; Nathan and Bathsheba urge David to honor his earlier promise to Solomon, and David has Solomon anointed king at once, publicly settling the succession crisis.','The succession struggle is resolved as Solomon ascends the throne.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

UPDATE event_translations t SET summary = v.summary
FROM events e, (VALUES
  ('samson-and-delilah','zh-CN','大利拉借爱情套出参孙力量的秘密，致其被非利士人擒获。'),
  ('samson-and-delilah','en','Delilah betrays Samson’s secret, leading to his capture by the Philistines.'),
  ('samson-at-gaza','zh-CN','参孙在迦萨推倒庙宇支柱，与非利士人同归于尽。'),
  ('samson-at-gaza','en','Samson pulls down the temple pillars at Gaza, dying with the Philistines.'),
  ('samuel-anoints-saul','zh-CN','撒母耳奉神指示膏立扫罗，成为以色列首位君王。'),
  ('samuel-anoints-saul','en','Samuel anoints Saul as Israel’s first king at the Lord’s direction.'),
  ('samuel-anoints-david-at-bethlehem','zh-CN','撒母耳在伯利恒膏立牧童大卫，暗中开启王权的转移。'),
  ('samuel-anoints-david-at-bethlehem','en','Samuel anoints the shepherd David at Bethlehem, quietly transferring the kingship.'),
  ('jonathan-and-david-make-a-covenant','zh-CN','约拿单与大卫立盟约，赠以战袍兵器表明情谊。'),
  ('jonathan-and-david-make-a-covenant','en','Jonathan and David make a covenant of loyalty, sealed with Jonathan’s gifts.'),
  ('david-a-fugitive-in-the-south','zh-CN','大卫为躲避扫罗追杀，在南地各处流亡多年。'),
  ('david-a-fugitive-in-the-south','en','Fleeing Saul’s pursuit, David spends years as a fugitive in the southern wilderness.'),
  ('saul-and-jonathan-die-on-gilboa','zh-CN','扫罗与约拿单在基利波山之战中阵亡，扫罗王朝终结。'),
  ('saul-and-jonathan-die-on-gilboa','en','Saul and Jonathan die in battle on Mount Gilboa, ending Saul’s dynasty.'),
  ('solomon-succeeds-david','zh-CN','大卫在临终前下令膏立所罗门为王，平息继承危机。'),
  ('solomon-succeeds-david','en','David orders Solomon anointed king, settling the succession crisis before his death.')
) AS v(slug, locale, summary)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

COMMIT;

-- =====================================================================
-- Batch 3: divided-kingdoms, prophetic-narrative, judah-and-exile
-- =====================================================================
BEGIN;

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('rehoboam-refuses-relief','zh-CN','所罗门死后，北方支派在示剑求罗波安减轻其父加在他们身上的重轭；罗波安不听老臣的劝告，反听年轻人的意见，扬言要用蝎子鞭责打百姓，比他父亲更加重他们的负担。','王室的强硬态度直接触发了国家的分裂。'),
  ('rehoboam-refuses-relief','en','After Solomon’s death, the northern tribes ask Rehoboam at Shechem to lighten the heavy yoke his father had placed on them; rejecting the elders’ counsel for the young men’s advice, Rehoboam threatens to scourge the people with scorpions rather than ease their burden.','The crown’s harsh stance directly triggers the kingdom’s split.'),
  ('kingdom-divides','zh-CN','罗波安的强硬回应激怒北方十支派，他们喊出“我们与大卫有什么份儿呢”，拥立耶罗波安为王，另立以色列国；罗波安只保留犹大与便雅悯，南北自此分裂为两个王国。','统一王国正式分裂为南北两国的历史转折点。'),
  ('kingdom-divides','en','Rehoboam’s harsh answer enrages the ten northern tribes, who cry, “What portion do we have in David?” and make Jeroboam their king, forming a separate kingdom of Israel; Rehoboam is left with only Judah and Benjamin, splitting the united monarchy in two.','The historic turning point when the united monarchy splits into two kingdoms.'),
  ('jeroboam-establishes-northern-shrines','zh-CN','耶罗波安恐怕百姓上耶路撒冷献祭会重归大卫家，便在但和伯特利各造一只金牛犊，对百姓说这就是领他们出埃及的神；他又设立不属利未支派的祭司与自定的节期，另立敬拜体系。','政治分裂延伸为宗教制度的分裂，招致长期的批判。'),
  ('jeroboam-establishes-northern-shrines','en','Fearing that worship in Jerusalem would draw the people back to the house of David, Jeroboam sets up golden calves at Dan and Bethel, declaring these the gods who brought Israel out of Egypt; he also appoints non-Levite priests and an alternate festival calendar.','Political division extends into religious institutions, drawing lasting condemnation.'),
  ('ahab-and-jezebel-marry','zh-CN','北国王亚哈娶西顿王的女儿耶洗别为后，为巩固与腓尼基的邦交；耶洗别带来对巴力的敬拜，亚哈在撒玛利亚为巴力立庙筑坛，使以色列的敬拜危机较前任诸王更为严重。','外交联姻引进异教敬拜，加深北国的宗教冲突。'),
  ('ahab-and-jezebel-marry','en','King Ahab of Israel marries Jezebel, daughter of the king of Sidon, to strengthen ties with Phoenicia; Jezebel brings the worship of Baal with her, and Ahab builds a temple and altar to Baal in Samaria, deepening Israel’s religious crisis beyond that of earlier kings.','A diplomatic marriage imports foreign worship, sharpening the northern kingdom’s religious conflict.'),
  ('contest-on-mount-carmel','zh-CN','先知以利亚在迦密山召集亚哈王与巴力先知四百五十人当众对决，各自筑坛献祭却不点火，求各自的神降火为凭；巴力先知呼求终日无应，以利亚一祷告便有火从天降下烧尽祭物，百姓遂将巴力的先知全数杀灭。','先知叙事中最公开的对决，确认耶和华独一的地位。'),
  ('contest-on-mount-carmel','en','On Mount Carmel, Elijah confronts King Ahab and four hundred fifty prophets of Baal in a public contest: each side builds an altar and calls on its god to send fire, without lighting it themselves. Baal’s prophets cry out all day with no response, but fire falls the moment Elijah prays, and the people put Baal’s prophets to death.','The most public confrontation among the prophets, affirming the Lord’s sole claim to worship.'),
  ('elijah-withdraws-to-horeb','zh-CN','迦密山之战后耶洗别扬言要杀以利亚，以利亚惧怕逃往南地旷野，一度求死，后被天使两次喂养，靠那力量走了四十昼夜到何烈山；耶和华不在风、地震、火中，却在微小的声音中向他说话。','公开胜利后的退隐与低潮，先知在静默中重新领受使命。'),
  ('elijah-withdraws-to-horeb','en','After Jezebel threatens his life following the Carmel contest, Elijah flees to the southern wilderness in fear, at one point wishing to die, until an angel feeds him twice and he travels forty days on that strength to Horeb; there the Lord speaks to him not in wind, earthquake, or fire, but in a still, small voice.','A retreat and low point after public victory, where the prophet receives his mission anew in silence.'),
  ('elijah-passes-the-mantle','zh-CN','耶和华在何烈山指示以利亚膏立以利沙接续先知职分；以利亚将外衣搭在正在耕地的以利沙身上，以利沙随即撇下牛群跟从他学习，多年后以利亚被旋风接去时又将外衣留给以利沙。','先知职分的正式交接，确保这一传统得以延续。'),
  ('elijah-passes-the-mantle','en','At Horeb the Lord directs Elijah to anoint Elisha as his prophetic successor; Elijah throws his cloak over Elisha as he is plowing, and Elisha leaves his oxen to follow him, years later inheriting that same cloak when Elijah is taken up in a whirlwind.','The formal handover of the prophetic office ensures the tradition continues.'),
  ('naboths-vineyard','zh-CN','耶斯列人拿伯拒绝将祖传葡萄园卖给亚哈王，耶洗别便假借亚哈之名，指使人诬告拿伯亵渎神和王，将他用石头打死，随后夺取了葡萄园；以利亚奉命前去谴责亚哈一家将因此遭灾祸。','王权借司法之名侵占产业，引发先知的正面控告。'),
  ('naboths-vineyard','en','When Naboth of Jezreel refuses to sell his ancestral vineyard to Ahab, Jezebel arranges false charges of blasphemy against him, has him stoned to death, and seizes the vineyard for the king; Elijah is sent to condemn Ahab’s house for the coming judgment this brings.','Royal power seizes property through a rigged trial, provoking a direct prophetic indictment.'),
  ('death-of-jezebel','zh-CN','耶户奉命铲除亚哈家，率军直闯耶斯列；耶洗别梳妆打扮后倚窗嘲讽耶户，耶户命内侍将她从窗口推下，她的血溅在墙上和马身上，尸体被野狗吃尽，只剩头骨手脚，应验了以利亚先前的预言。','北国宫廷叙事的关键转折，先知预言就此应验。'),
  ('death-of-jezebel','en','Commissioned to wipe out Ahab’s house, Jehu marches on Jezreel; Jezebel dresses and taunts him from a window, but at his command her attendants throw her down, her blood spattering the wall and horses, and dogs devour her body except for her skull, feet, and hands, fulfilling Elijah’s earlier prophecy.','A key turning point in the northern court’s story, fulfilling an earlier prophetic word.'),
  ('fall-of-samaria','zh-CN','北国何细亚年间背叛亚述，亚述王撒缦以色围攻撒玛利亚三年，最终攻陷此城，将大批以色列人掳往亚述各地安置，另迁别族人来定居；亚述的铭文记载与圣经记述可互相印证。','北国以色列就此终结，成为分裂王国叙事的重要句点。'),
  ('fall-of-samaria','en','When King Hoshea rebels against Assyria, the Assyrian king besieges Samaria for three years before capturing it, deporting large numbers of Israelites to various parts of Assyria and resettling other peoples in their place; Assyrian inscriptions corroborate the biblical account.','The end of the northern kingdom of Israel, a major closing point in the divided-kingdom narrative.'),
  ('jonah-sails-from-joppa','zh-CN','耶和华命约拿前往尼尼微宣告审判的信息，约拿却起身逃往相反方向，下到约帕，找到一只船要往他施去，交了船价上了船，想躲开耶和华的面。','先知抗命出逃，开启一场与神旨意的正面周旋。'),
  ('jonah-sails-from-joppa','en','Commanded by the Lord to go and preach judgment against Nineveh, Jonah instead sets off in the opposite direction, going down to Joppa, where he finds a ship bound for Tarshish, pays the fare, and boards it to flee from the Lord’s presence.','A prophet’s flight from his commission opens a direct standoff with God’s will.'),
  ('jonah-heads-for-tarshish','zh-CN','约拿所乘的船在海上遇到大风暴，水手惊惶各自呼求神明，约拿却在舱底沉睡；水手抽签得知灾祸因约拿而起，约拿承认自己在躲避耶和华，请他们将自己抛入海中，风浪随即平息。','逃避的行程以海上风暴与被抛入海作结，凸显逃无可逃。'),
  ('jonah-heads-for-tarshish','en','The ship Jonah boards is caught in a violent storm, and while the terrified sailors cry out to their gods, Jonah sleeps below deck; casting lots, the sailors learn Jonah is the cause, and after he admits he is fleeing the Lord and asks to be thrown overboard, the sea grows calm the moment they do so.','The flight ends in a storm at sea and being cast overboard, showing there is no real escape.'),
  ('jonah-outside-nineveh','zh-CN','尼尼微人因约拿的宣告而悔改，耶和华收回原定的灾祸，约拿却因此发怒，出城搭棚坐在东边等着看城的结局；耶和华用一棵蓖麻树的枯荣教导约拿要顾惜这十二万多不能分辨左右手的人。','先知与神的心意仍有分歧，全书以未解的问题收尾。'),
  ('jonah-outside-nineveh','en','When Nineveh repents at Jonah’s preaching and the Lord relents from the disaster he had planned, Jonah becomes angry and sits outside the city under a shelter to watch what will happen; the Lord uses a withering plant to teach Jonah that he should care about the city’s many people who cannot tell right from left.','The prophet’s outlook still diverges from God’s, and the book ends with the question unresolved.'),
  ('isaiah-called-in-the-temple','zh-CN','乌西雅王去世那年，以赛亚在圣殿中看见耶和华坐在高高的宝座上，撒拉弗彼此呼喊“圣哉、圣哉、圣哉”；以赛亚自觉污秽不配，撒拉弗以火炭洁净他的口，耶和华问谁肯为我们去，以赛亚回应说请差遣我。','圣殿中的异象委任以赛亚，正式开启他的先知生涯。'),
  ('isaiah-called-in-the-temple','en','In the year King Uzziah dies, Isaiah sees the Lord seated on a high throne in the temple, with seraphim calling to one another, “Holy, holy, holy”; feeling unclean, Isaiah has his mouth purified with a burning coal, and when the Lord asks whom to send, Isaiah answers, “Here am I, send me.”','A temple vision commissions Isaiah, formally launching his prophetic career.'),
  ('isaiah-counsels-hezekiah','zh-CN','亚述大军压境，希西家差人求问先知以赛亚；以赛亚传耶和华的话，叫希西家不要惧怕亚述王的辱骂，应许亚述王必听见风声就归回本地，且必倒在自己的刀下。','国际危机中先知的建议成为王室决策的重要依据。'),
  ('isaiah-counsels-hezekiah','en','With the Assyrian army bearing down, Hezekiah sends to consult the prophet Isaiah; Isaiah relays the Lord’s word that Hezekiah need not fear the Assyrian king’s taunts, promising that he will hear a rumor and return home, only to fall by the sword in his own land.','A prophet’s counsel becomes decisive royal policy amid an international crisis.'),
  ('assyrian-siege-of-lachish','zh-CN','亚述王西拿基立攻打犹大的坚固城，拉吉是其中最重要的一座；亚述军队筑坡攻城，最终攻陷拉吉，此役的过程被刻在尼尼微宫殿的浮雕上，成为圣经之外的重要图像见证。','城池陷落的浮雕留存，提供了圣经记载之外的实物印证。'),
  ('assyrian-siege-of-lachish','en','Assyrian king Sennacherib attacks the fortified cities of Judah, and Lachish, among the most important, falls after Assyrian forces build a siege ramp against it; the campaign is depicted in relief carvings from Sennacherib’s palace at Nineveh, an important extrabiblical witness.','Surviving relief carvings of the siege provide physical corroboration outside the biblical text.'),
  ('sennacherib-besieges-jerusalem','zh-CN','亚述王西拿基立攻取拉吉后移兵围困耶路撒冷，其将领在城下辱骂耶和华与希西家；希西家在圣殿祷告后，耶和华的使者一夜间击杀亚述营中大批士兵，西拿基立随即撤兵回国。圣经与亚述铭文对结果的记述并不一致。','一场围城战有截然不同的胜负记述，考验历史与信仰的对读。'),
  ('sennacherib-besieges-jerusalem','en','After taking Lachish, Sennacherib moves against Jerusalem, and his officer taunts the Lord and Hezekiah in Hebrew beneath the walls; after Hezekiah prays in the temple, the angel of the Lord strikes down 185,000 in the Assyrian camp overnight, and Sennacherib withdraws. The biblical account and Assyrian records differ on the outcome.','A siege whose outcome is told differently by two sources, testing how history and faith are read together.'),
  ('hezekiahs-water-tunnel','zh-CN','希西家预备迎战亚述围城，命人开凿隧道将基训泉的水引入城内的西罗亚池，以确保城内水源不被切断；隧道两端工人相向凿进，中途凿通会合，隧道内留有记述工程完工的希西家铭文。','围城前的工程准备，留下可考的实物证据。'),
  ('hezekiahs-water-tunnel','en','Preparing for the Assyrian siege, Hezekiah has a tunnel cut to bring water from the Gihon spring into the Pool of Siloam inside the city walls, securing the water supply; workers dug from both ends toward the middle, and an inscription found in the tunnel commemorates its completion.','Siege preparations that leave behind verifiable physical evidence.'),
  ('jeremiah-called','zh-CN','约西亚王在位第十三年，耶和华的话临到耶利米，说在他未出母腹之先已分别他为列国的先知；耶利米以自己年幼、不会说话推辞，耶和华伸手按他的口，将话放在他口中，并赐他杏树枝与滚水的两个异象。','危机前夕蒙召的先知，将见证犹大最后的岁月。'),
  ('jeremiah-called','en','In the thirteenth year of King Josiah, the word of the Lord comes to Jeremiah, telling him he was set apart as a prophet to the nations before he was born; when Jeremiah protests that he is only a youth, the Lord touches his mouth and gives him two visions, an almond branch and a boiling pot.','A prophet called on the eve of crisis, destined to witness Judah’s final years.'),
  ('first-deportation-to-babylon','zh-CN','巴比伦王尼布甲尼撒首次攻打耶路撒冷，掳走犹大王约雅斤及王室、贵族、工匠等大批人口，并带走圣殿部分器皿；但以理等几名少年贵族子弟也在此次被掳的人中，被带往巴比伦受训供职。','犹大流散的开端，圣殿器皿与人口首次被掳往异邦。'),
  ('first-deportation-to-babylon','en','Babylon’s King Nebuchadnezzar first attacks Jerusalem, deporting King Jehoiachin along with the royal family, nobles, and craftsmen, and taking some of the temple vessels; among the exiles are young nobles including Daniel, who are trained for service in the Babylonian court.','The start of Judah’s dispersion, as both temple vessels and people are first carried into exile.'),
  ('daniel-in-the-babylonian-court','zh-CN','但以理与三个同伴被选入巴比伦宫廷受训，却不肯用王的膳食玷污自己，只求以素菜与水试验十天；结果他们的面貌比用王膳的少年人更加俊美强壮，神又赐他们各样学问聪明，尼布甲尼撒考察后见他们胜过全国的术士十倍。','异邦宫廷中坚守信仰的少年，为流散群体树立榜样。'),
  ('daniel-in-the-babylonian-court','en','Daniel and three companions are chosen for training in the Babylonian court but refuse to defile themselves with the king’s food, asking instead for ten days on vegetables and water; they end up healthier and more capable than the others, and Nebuchadnezzar finds them ten times better than all his magicians.','Young exiles who keep their faith in a foreign court, becoming a model for the dispersed community.'),
  ('ezekiels-vision-by-the-canal','zh-CN','被掳到巴比伦第五年，祭司以西结在迦巴鲁河边看见天开了，得见神的异象：狂风、火焰、四活物与轮中套轮的景象，以及宝座上仿佛人形的神的荣耀；他随即俯伏在地，听见有声音对他说话。','流散群体中产生的重要异象文本，由此开启以西结的先知信息。'),
  ('ezekiels-vision-by-the-canal','en','In the fifth year of exile, the priest Ezekiel, by the Kebar canal in Babylon, sees the heavens open in a vision of a windstorm, fire, four living creatures, and wheels within wheels, with the glory of the Lord in human likeness above a throne; he falls facedown and hears a voice speak to him.','A landmark vision produced within the exile community, opening Ezekiel’s prophetic message.'),
  ('jerusalem-falls','zh-CN','巴比伦王尼布甲尼撒第二次围困耶路撒冷，围城近两年后城墙被攻破，西底家王连夜出逃，被巴比伦军队追上并擒获于耶利哥平原；他的众子在他眼前被杀，随后他的双眼被剜去，被铜链锁着带往巴比伦。','犹大王国至此彻底终结，以色列独立政权告一段落。'),
  ('jerusalem-falls','en','Nebuchadnezzar besieges Jerusalem a second time, breaching the walls after nearly two years; King Zedekiah flees by night but is caught on the plains of Jericho, forced to watch his sons killed, then blinded and taken in bronze chains to Babylon.','The kingdom of Judah comes to a complete end, closing out Israel’s independent monarchy.'),
  ('temple-destroyed','zh-CN','耶路撒冷陷落一个月后，巴比伦护卫长尼布撒拉旦奉命前来，放火焚烧圣殿、王宫与城中大宅，又拆毁耶路撒冷四围的城墙；圣殿中的铜柱、铜海及各样器皿都被打碎或掳走带回巴比伦。','宗教中心随国破而毁，敬拜体系被迫中断。'),
  ('temple-destroyed','en','About a month after Jerusalem falls, the Babylonian captain of the guard, Nebuzaradan, sets fire to the temple, the palace, and the great houses of the city, and tears down the surrounding walls; the temple’s bronze pillars, the bronze sea, and other vessels are broken up or carried off to Babylon.','The center of worship is destroyed along with the kingdom, breaking off the sacrificial system.'),
  ('jeremiah-taken-to-egypt','zh-CN','耶路撒冷陷落后，余留的犹大人惧怕巴比伦报复基大利被刺一事，不听耶利米劝阻执意逃往埃及，还强行带走耶利米与巴录同去；耶利米在埃及仍继续传讲审判的信息，此后再无关于他的明确记载。','先知生涯的最后阶段，讯息延续到埃及流亡群体之中。'),
  ('jeremiah-taken-to-egypt','en','After Jerusalem’s fall, the remaining Judeans, fearing Babylonian reprisal for Gedaliah’s assassination, ignore Jeremiah’s warning and flee to Egypt, forcibly taking Jeremiah and Baruch with them; Jeremiah continues to deliver messages of judgment in Egypt, where the biblical record of him ends.','The final stage of the prophet’s career, his message carried on among exiles in Egypt.'),
  ('belshazzars-feast','zh-CN','巴比伦王伯沙撒设大筵席，命人取出圣殿的金银器皿供众人饮酒，并赞美金银木石所造的神；忽有人的指头在墙上写字，但以理受召解读，指出巴比伦国度已被称在天平里显出亏欠，当夜伯沙撒便被杀，国度归于玛代人大利乌。','政权更替前夜的宫廷场面，异象文字应验于当夜。'),
  ('belshazzars-feast','en','King Belshazzar of Babylon holds a great feast, using the temple’s gold and silver vessels for wine while praising gods of silver, gold, and stone; a hand appears and writes on the wall, and Daniel is called to interpret it, declaring Babylon has been weighed and found wanting. That very night Belshazzar is killed and the kingdom passes to Darius the Mede.','A royal banquet on the eve of regime change, its handwritten verdict fulfilled that same night.'),
  ('daniel-in-the-lions-den','zh-CN','大利乌王手下的官员嫉妒但以理受重用，设计颁布三十日内只准向王祷告的禁令，诱使他触犯；但以理仍照常一日三次朝耶路撒冷祷告，因而被扔入狮子坑，神差使者封住狮子的口使他毫发无损，控告他的人反被扔入坑中丧命。','忠于信仰与效忠制度间的冲突，以神的保守作结。'),
  ('daniel-in-the-lions-den','en','Jealous of Daniel’s standing under King Darius, officials engineer a thirty-day ban on prayer to anyone but the king to trap him; Daniel continues praying toward Jerusalem three times a day as before and is thrown into the lions’ den, but God sends an angel to shut the lions’ mouths, and Daniel emerges unharmed while his accusers are thrown in and killed.','A clash between religious loyalty and imperial law resolved through divine protection.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

UPDATE event_translations t SET summary = v.summary
FROM events e, (VALUES
  ('rehoboam-refuses-relief','zh-CN','罗波安在示剑拒绝减轻赋役，激化了南北分裂的危机。'),
  ('rehoboam-refuses-relief','en','Rehoboam refuses to ease Israel’s burdens at Shechem, precipitating the kingdom’s split.'),
  ('kingdom-divides','zh-CN','北方十支派拥立耶罗波安，南北王国自此正式分裂。'),
  ('kingdom-divides','en','The ten northern tribes crown Jeroboam king, formally splitting Israel and Judah.'),
  ('death-of-jezebel','zh-CN','耶户命人将耶洗别推下窗户处死，应验以利亚的预言。'),
  ('death-of-jezebel','en','Jehu has Jezebel thrown from a window to her death, fulfilling Elijah’s prophecy.'),
  ('elijah-passes-the-mantle','zh-CN','以利亚将外衣披在以利沙身上，正式传承先知的职分。'),
  ('elijah-passes-the-mantle','en','Elijah passes his prophetic mantle to Elisha, securing the succession.'),
  ('jonah-sails-from-joppa','zh-CN','约拿抗拒神的差遣，从约帕搭船逃往他施方向。'),
  ('jonah-sails-from-joppa','en','Jonah defies his commission and boards a ship at Joppa bound for Tarshish.'),
  ('isaiah-called-in-the-temple','zh-CN','以赛亚在圣殿异象中蒙召，回应神说愿意奉差遣。'),
  ('isaiah-called-in-the-temple','en','In a temple vision Isaiah is called and answers, “Here am I, send me.”'),
  ('hezekiahs-water-tunnel','zh-CN','希西家凿通水道，将基训泉水引入城内以备围城。'),
  ('hezekiahs-water-tunnel','en','Hezekiah cuts a tunnel bringing Gihon spring water into the city before the siege.'),
  ('jeremiah-called','zh-CN','耶利米在约西亚年间蒙召作列国的先知。'),
  ('jeremiah-called','en','Jeremiah is called as a young man to prophesy to the nations under Josiah.'),
  ('first-deportation-to-babylon','zh-CN','尼布甲尼撒首次掳走约雅斤王及大批犹大人前往巴比伦。'),
  ('first-deportation-to-babylon','en','Nebuchadnezzar deports King Jehoiachin and many Judeans to Babylon.'),
  ('jerusalem-falls','zh-CN','巴比伦攻破耶路撒冷，西底家王被擒，犹大国灭亡。'),
  ('jerusalem-falls','en','Babylon breaches Jerusalem’s walls, capturing Zedekiah and ending Judah’s kingdom.'),
  ('temple-destroyed','zh-CN','巴比伦军队焚毁圣殿与王宫，拆毁耶路撒冷城墙。'),
  ('temple-destroyed','en','Babylonian forces burn the temple and palace and tear down Jerusalem’s walls.'),
  ('jeremiah-taken-to-egypt','zh-CN','犹大余民不顾耶利米劝阻，挟他一同逃往埃及避难。'),
  ('jeremiah-taken-to-egypt','en','Judah’s remnant flees to Egypt against Jeremiah’s warning, taking him along.')
) AS v(slug, locale, summary)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

COMMIT;

-- =====================================================================
-- Batch 4: return-and-restoration
-- =====================================================================
BEGIN;

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('cyrus-permits-return','zh-CN','波斯王居鲁士灭巴比伦后，第一年颁布谕旨，说耶和华已委派他建造耶路撒冷的圣殿，准许被掳的犹大人回归本地重建；居鲁士又将尼布甲尼撒当年掳去的圣殿器皿交还，让归回的人带回。','帝国政策的转变，为被掳群体开启归回重建之路。'),
  ('cyrus-permits-return','en','After conquering Babylon, Persia’s King Cyrus issues a decree in his first year stating that the Lord has charged him to rebuild the temple in Jerusalem, permitting the exiled Judeans to return home; he also restores the temple vessels Nebuchadnezzar had carried off.','A shift in imperial policy opens the way for the exiles to return and rebuild.'),
  ('first-returnees-reach-jerusalem','zh-CN','犹大和便雅悯的族长、祭司、利未人等在所罗巴伯与耶书亚带领下，靠着居鲁士的谕旨离开巴比伦，携带归还的圣殿器皿返回耶路撒冷及犹大各城，人数依家族登记造册，共约四万余人。','流亡群体大规模归回本地，重建工作的起点。'),
  ('first-returnees-reach-jerusalem','en','Led by Zerubbabel and Jeshua, heads of families from Judah and Benjamin, along with priests and Levites, leave Babylon under Cyrus’s decree and return to Jerusalem and the towns of Judah, carrying back the temple vessels; the returnees are recorded by family, numbering around forty thousand.','The large-scale return of the exile community, marking the start of reconstruction.'),
  ('second-temple-rebuilt','zh-CN','归回的犹大人先重建祭坛恢复献祭，后在所罗巴伯与耶书亚带领下开工建殿，因周边民族阻挠及大流士登基前的政局而一度停工；先知哈该、撒迦利亚督促百姓，工程恢复，圣殿终于在大流士王第六年完工，众人欢庆行奉献礼。','宗教中心得以重建，标志重建阶段的重要里程碑。'),
  ('second-temple-rebuilt','en','Returning Judeans first rebuild the altar to resume sacrifices, then begin the temple itself under Zerubbabel and Jeshua, though work stalls due to local opposition and unrest before Darius’s reign; urged on by the prophets Haggai and Zechariah, the work resumes and the temple is completed in Darius’s sixth year, dedicated amid great celebration.','The rebuilding of the center of worship marks a major milestone in the restoration.'),
  ('esther-becomes-queen-at-susa','zh-CN','波斯王亚哈随鲁废黜王后瓦实提后，命人在书珊城选拔美貌女子入宫；犹大孤女以斯帖由堂兄末底改抚养，被选入宫中并隐瞒自己的犹大身份，最终在众女子中蒙王喜悦，被立为王后。','一名犹大孤女登上波斯宫廷王后之位的起点。'),
  ('esther-becomes-queen-at-susa','en','After Queen Vashti is deposed, King Ahasuerus of Persia has beautiful young women brought to the citadel of Susa; the Jewish orphan Esther, raised by her cousin Mordecai, is taken in without revealing her Jewish identity and wins the king’s favor above all the others, becoming queen.','The start of a Jewish orphan’s rise to become queen of the Persian court.'),
  ('mordecai-refuses-to-bow','zh-CN','亚哈随鲁王擢升哈曼为宰相，命众臣仆向他跪拜，末底改因身为犹大人而拒绝下拜；哈曼恼怒之余得知末底改的身份后，便设计说服王颁旨要在全国一日之内剪除所有犹大人。','个人的拒绝行礼演变为针对全体犹大人的灭绝阴谋。'),
  ('mordecai-refuses-to-bow','en','King Ahasuerus elevates Haman to prime minister and orders all officials to bow to him, but Mordecai refuses because he is a Jew; enraged upon learning Mordecai’s identity, Haman persuades the king to issue a decree to annihilate all Jews throughout the empire in a single day.','One man’s refusal to bow escalates into a plot to destroy an entire people.'),
  ('esther-intervenes-at-court','zh-CN','以斯帖冒死未经宣召进入内院见王，蒙王伸出金杖接纳，随后两次设宴款待王与哈曼；在第二次宴席上，以斯帖向王指控哈曼企图灭绝她本族的阴谋，王大怒，下令将哈曼挂在他为末底改所预备的木架上。','以宫廷程序和智谋扭转局势，而非依靠武力对抗。'),
  ('esther-intervenes-at-court','en','Risking her life, Esther approaches the king unsummoned and is received when he extends his scepter; she hosts two banquets for the king and Haman, and at the second reveals Haman’s plot to destroy her people. Enraged, the king has Haman hanged on the gallows Haman had built for Mordecai.','Court procedure and wit, not force, reverse the fate of Esther’s people.'),
  ('nehemiah-rebuilds-the-wall','zh-CN','尼希米在波斯宫中作王的酒政，闻知耶路撒冷城墙荒废、城门被焚，便求王准他回去重修；他动员百姓分段修筑城墙，面对参巴拉、多比雅等人的讥笑、威胁与暗算，仍一手拿兵器一手作工，历经五十二日将城墙修完。','在政治阻力下完成的公共工程，恢复城邑的防御与尊严。'),
  ('nehemiah-rebuilds-the-wall','en','Serving as cupbearer at the Persian court, Nehemiah learns that Jerusalem’s walls lie broken and its gates burned, and asks the king’s permission to return and rebuild; he organizes the people by sections, and despite mockery, threats, and plots from Sanballat, Tobiah, and others, the workers labor with a weapon in one hand and complete the wall in fifty-two days.','A public works project finished despite political opposition, restoring the city’s defense and dignity.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

UPDATE event_translations t SET summary = v.summary
FROM events e, (VALUES
  ('first-returnees-reach-jerusalem','zh-CN','所罗巴伯率首批归回者携圣殿器皿回到耶路撒冷。'),
  ('first-returnees-reach-jerusalem','en','Zerubbabel leads the first returnees back to Jerusalem with the temple vessels.'),
  ('second-temple-rebuilt','zh-CN','圣殿历经波折在大流士六年完工，众人举行奉献礼。'),
  ('second-temple-rebuilt','en','Despite setbacks, the second temple is completed under Darius and joyfully dedicated.'),
  ('esther-becomes-queen-at-susa','zh-CN','犹大孤女以斯帖隐瞒身世，蒙王拣选立为波斯王后。'),
  ('esther-becomes-queen-at-susa','en','The Jewish orphan Esther, hiding her identity, is chosen queen of Persia.'),
  ('mordecai-refuses-to-bow','zh-CN','末底改拒向哈曼下拜，哈曼因而图谋灭绝犹大全族。'),
  ('mordecai-refuses-to-bow','en','Mordecai’s refusal to bow to Haman triggers a plot to destroy all Jews.')
) AS v(slug, locale, summary)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

COMMIT;
