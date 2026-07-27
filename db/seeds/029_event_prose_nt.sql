-- 029_event_prose_nt.sql
-- New Testament event detail/significance enrichment (gospels, acts, pauline-mission)
-- zh-CN + en detail/significance for events currently missing prose content.
-- Some placeholder summaries (<10 zh chars) are also rewritten to be more informative.

BEGIN;

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('annunciation-at-nazareth','zh-CN','天使加百列奉差到拿撒勒，向童女马利亚显现，告知她将由圣灵感孕生下耶稣，是至高者的儿子；马利亚顺服应允。','开启福音书的诞生叙事，确立耶稣弥赛亚身份的起点。'),
  ('annunciation-at-nazareth','en','The angel Gabriel appears to the virgin Mary at Nazareth, announcing that she will conceive by the Holy Spirit and bear a son called Son of the Most High; Mary submits in obedience.','Opens the Gospel birth narrative and establishes the origin of Jesus’s messianic identity.'),
  ('flight-to-egypt','zh-CN','希律王下令杀害伯利恒城内两岁以下的男孩，约瑟遵天使指示，连夜带着马利亚与耶稣逃往埃及，直等希律死后才返回。','使耶稣幼年应验先知所说神子从埃及被召出的预言。'),
  ('flight-to-egypt','en','Herod orders the killing of infant boys in Bethlehem, and Joseph, warned by an angel, flees by night with Mary and the child Jesus to Egypt, remaining there until Herod’s death.','Fulfills the prophecy that God’s son would be called out of Egypt.'),
  ('return-to-nazareth','zh-CN','希律死后，约瑟遵天使指示带家人从埃及返回以色列地，因惧怕希律之子亚基老掌权犹太，遂避居加利利的拿撒勒城，耶稣在此长大。','说明耶稣拿撒勒人称号的地理与家族背景。'),
  ('return-to-nazareth','en','After Herod’s death, Joseph brings his family back from Egypt but, fearing Herod’s son Archelaus who now rules Judea, settles instead in Nazareth of Galilee, where Jesus grows up.','Explains the geographic origin behind Jesus being called a Nazarene.'),
  ('baptism-at-the-jordan','zh-CN','耶稣从加利利来到约旦河，请施洗约翰为祂施洗；祂从水里上来时，天开了，圣灵仿佛鸽子降在祂身上，有声音从天上说这是神的爱子。','标志耶稣公开传道生涯的正式开始。'),
  ('baptism-at-the-jordan','en','Jesus comes from Galilee to the Jordan and is baptized by John; as he comes up from the water, the heavens open, the Spirit descends like a dove, and a voice declares him God’s beloved Son.','Marks the formal start of Jesus’s public ministry.'),
  ('calling-of-the-first-disciples','zh-CN','耶稣在加利利海边行走，看见西门彼得与安得烈、雅各与约翰在打鱼或补网，呼召他们撇下渔网跟从祂，应许使他们得人如得鱼。','建立门徒群体，是耶稣事工团队形成的起点。'),
  ('calling-of-the-first-disciples','en','Walking by the Sea of Galilee, Jesus sees Simon Peter and Andrew, then James and John, fishing or mending nets, and calls them to follow him, promising to make them fishers of men.','Founds the disciple band that becomes the core of Jesus’s ministry.'),
  ('first-sign-at-cana','zh-CN','耶稣与母亲、门徒在加利利的迦拿赴婚宴，酒用尽后马利亚请求耶稣帮助；耶稣命人将水倒入石缸，水就变成上好的酒。','约翰福音记载的第一个神迹，显明耶稣的荣耀。'),
  ('first-sign-at-cana','en','At a wedding in Cana of Galilee, Jesus, his mother, and his disciples are guests; when the wine runs out, Mary asks Jesus to help, and he turns water in stone jars into fine wine.','The first of the signs recorded in John, revealing Jesus’s glory.'),
  ('conversation-at-jacobs-well','zh-CN','耶稣途经撒玛利亚，在雅各井旁与一名撒玛利亚妇人交谈，向她启示自己是弥赛亚，并谈论活水与用心灵诚实敬拜神；妇人回城传扬，许多撒玛利亚人信了。','打破犹太人与撒玛利亚人的隔阂，预示福音向外邦扩展。'),
  ('conversation-at-jacobs-well','en','Passing through Samaria, Jesus meets a Samaritan woman at Jacob’s well, reveals himself as the Messiah, and speaks of living water and worship in spirit and truth; she returns to town, and many Samaritans believe.','Crosses the Jewish-Samaritan divide and foreshadows the gospel’s reach beyond Israel.'),
  ('transfiguration-on-tabor','zh-CN','耶稣带彼得、雅各、约翰上山祷告，面貌改变，衣服洁白放光，摩西与以利亚显现同祂说话，有云彩遮盖他们，天上有声音说这是我的爱子。','印证耶稣的神性身份，连接律法、先知与耶稣的使命。'),
  ('transfiguration-on-tabor','en','Jesus takes Peter, James, and John up a mountain to pray; his face and clothes shine with light, Moses and Elijah appear speaking with him, a cloud overshadows them, and a voice declares him God’s beloved Son.','Confirms Jesus’s divine identity and links him to the Law and the Prophets.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('raising-of-lazarus','zh-CN','耶稣的朋友拉撒路在伯大尼病死，安葬四天后耶稣来到坟前，吩咐挪开石头，大声呼叫拉撒路的名字，拉撒路便裹着布走出坟墓复活。','约翰福音记载的最大神迹，直接引发犹太公会决意除掉耶稣。'),
  ('raising-of-lazarus','en','Jesus’s friend Lazarus dies at Bethany and is buried four days when Jesus arrives; he has the stone removed, calls Lazarus by name, and Lazarus walks out of the tomb still wrapped in graveclothes.','The greatest sign in John’s Gospel, which precipitates the Sanhedrin’s decision to kill Jesus.'),
  ('entry-into-jerusalem','zh-CN','耶稣骑着驴驹从伯法其进入耶路撒冷，群众铺衣服和棕树枝在路上，高喊和散那，迎接祂如君王一般，应验先知关于谦和君王的预言。','揭开耶稣受难周的序幕，公开显明祂的弥赛亚身份。'),
  ('entry-into-jerusalem','en','Riding a donkey’s colt from Bethphage into Jerusalem, Jesus is greeted by crowds spreading cloaks and palm branches and shouting Hosanna, fulfilling the prophecy of a humble king.','Opens Jesus’s final week and publicly displays his messianic claim.'),
  ('last-supper','zh-CN','耶稣与十二门徒在耶路撒冷一间楼房守逾越节筵席，祂为门徒洗脚，设立擘饼喝杯的圣礼，预言犹大将出卖祂、彼得将三次不认祂。','建立教会守圣餐的传统，也是耶稣受难前的最后教导。'),
  ('last-supper','en','Jesus shares a Passover meal with the twelve disciples in an upper room in Jerusalem, washes their feet, institutes the bread and cup, and predicts Judas’s betrayal and Peter’s denial.','Establishes the church’s tradition of the Lord’s Supper on the eve of the crucifixion.'),
  ('arrest-on-the-mount-of-olives','zh-CN','耶稣在客西马尼园祷告后，犹大带着祭司长差来的兵丁以亲吻为暗号前来，兵丁便拿住耶稣；门徒四散逃跑，彼得曾拔刀抵抗被耶稣制止。','受难叙事正式展开，标志耶稣从自由传道转入被捕受审。'),
  ('arrest-on-the-mount-of-olives','en','After praying in Gethsemane on the Mount of Olives, Jesus is identified by Judas’s kiss and seized by an armed crowd sent by the chief priests; the disciples scatter, and Peter’s sword-stroke is rebuked.','Formally launches the passion narrative as Jesus moves from ministry to arrest.'),
  ('trial-before-pilate','zh-CN','犹太公会将耶稣解送罗马巡抚彼拉多，控告祂自称犹太人的王；彼拉多查不出罪状，几次想释放祂，但在群众压力下终将耶稣交出钉十字架。','显明犹太宗教领袖与罗马政权共同促成耶稣被处死。'),
  ('trial-before-pilate','en','The Sanhedrin hands Jesus over to the Roman governor Pilate, accusing him of claiming kingship; Pilate finds no fault and seeks to release him, but yields to the crowd’s pressure and hands Jesus over for crucifixion.','Shows Jewish religious leaders and Roman authority jointly bringing about Jesus’s execution.'),
  ('empty-tomb','zh-CN','安息日过后的第一日清晨，几位妇女来到耶稣的坟墓，发现石头已经滚开，坟墓空了，天使宣告耶稣已经复活；各卷福音书对细节的记述略有不同。','复活叙事的关键证据，是基督教信仰的核心事件。'),
  ('empty-tomb','en','Early on the first day of the week, women come to Jesus’s tomb and find the stone rolled away and the body gone; an angel announces that he has risen, though the Gospels vary in detail.','The key evidence opening the resurrection narrative, central to Christian faith.'),
  ('road-to-emmaus','zh-CN','复活当日，两个门徒往以马忤斯村去，复活的耶稣与他们同行却未被认出；直到晚饭擘饼时他们的眼睛才开了，认出是耶稣，祂便忽然不见了。','以认出与相认的主题印证耶稣复活的真实性。'),
  ('road-to-emmaus','en','On the day of the resurrection, two disciples walk to the village of Emmaus, joined unrecognized by the risen Jesus; only when he breaks bread at supper do their eyes open, and he vanishes.','Confirms the reality of the resurrection through a theme of recognition.'),
  ('pentecost-in-jerusalem','zh-CN','五旬节那天，门徒聚集在耶路撒冷一处，圣灵降临，有响声如大风、舌头如火焰落在各人身上，门徒开始说方言，彼得向群众讲道，当日约三千人受洗归主。','教会公开诞生的标志性事件，圣灵浇灌应验旧约预言。'),
  ('pentecost-in-jerusalem','en','On the day of Pentecost the disciples are gathered in Jerusalem when the Holy Spirit comes with the sound of rushing wind and tongues of fire; they speak in other tongues, Peter preaches, and about three thousand are baptized.','The founding event of the church’s public life, fulfilling the prophecy of the Spirit poured out.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('stephen-is-killed','zh-CN','司提反在犹太公会前见证耶稣是基督，指控听众抗拒圣灵；众人恼怒，将他拉到城外用石头打死，扫罗（后来的保罗）在场看守衣裳，表示赞同。','教会第一位殉道者，其死引发对信徒的逼迫与向外扩散。'),
  ('stephen-is-killed','en','Stephen testifies before the Sanhedrin that Jesus is the Christ and accuses his hearers of resisting the Spirit; enraged, they drag him outside the city and stone him to death, while Saul, later Paul, looks on approvingly, guarding the coats.','The church’s first martyr, whose death triggers persecution and the scattering of believers.'),
  ('peters-vision-at-joppa','zh-CN','彼得在约帕城一处房顶祷告时进入异象，看见一块布从天而降，里面有各样洁净与不洁净的走兽，有声音三次吩咐他宰了吃；彼得起初拒绝，后来明白神已洁净外邦人。','打破洁净礼仪的界限，为福音传给外邦人预备心理基础。'),
  ('peters-vision-at-joppa','en','Praying on a rooftop at Joppa, Peter falls into a trance and sees a sheet let down from heaven filled with clean and unclean animals; a voice tells him three times to kill and eat, and he comes to understand that God has cleansed the Gentiles.','Breaks down the ritual purity boundary, preparing the way for the gospel to reach Gentiles.'),
  ('peter-and-cornelius-at-caesarea','zh-CN','彼得应百夫长哥尼流之邀，来到该撒利亚向他及其全家传讲耶稣的福音；彼得讲道之时，圣灵降在在场的外邦听众身上，彼得便吩咐给他们施洗。','教会历史上外邦人首次正式蒙圣灵印证并受洗加入。'),
  ('peter-and-cornelius-at-caesarea','en','Peter goes to Caesarea at the invitation of the centurion Cornelius and preaches the gospel to him and his household; while he is speaking, the Holy Spirit falls on the Gentile listeners, and Peter has them baptized.','The first formal reception of Gentiles into the church, confirmed by the Spirit.'),
  ('barnabas-brings-paul-to-antioch','zh-CN','安提阿教会因外邦信徒归主而兴旺，巴拿巴从耶路撒冷前往查看后，又去大数把扫罗找来，二人在安提阿同工一年教导众人；门徒在安提阿开始被称为基督徒。','安提阿成为差派保罗宣教的基地，为日后外邦宣教奠定基础。'),
  ('barnabas-brings-paul-to-antioch','en','As the Antioch church grows through Gentile converts, Barnabas is sent from Jerusalem to see it, then fetches Saul from Tarsus; the two teach together in Antioch for a year, where disciples are first called Christians.','Establishes Antioch as the base from which Paul’s missionary work is later launched.'),
  ('first-journey-begins-at-cyprus','zh-CN','安提阿教会禁食祷告后，按手差遣巴拿巴与扫罗出去宣教；二人先到西流基，乘船前往塞浦路斯，从撒拉米到帕弗，在各会堂传讲神的道。','保罗宣教旅程的正式起点，教会差传制度的开端。'),
  ('first-journey-begins-at-cyprus','en','After fasting and prayer, the Antioch church lays hands on Barnabas and Saul and sends them out; they sail from Seleucia to Cyprus, preaching in the synagogues from Salamis to Paphos.','The formal start of Paul’s missionary journeys and the church’s practice of commissioned mission.'),
  ('jerusalem-council','zh-CN','因外邦信徒是否需受割礼遵守摩西律法引发争议，教会代表在耶路撒冷聚集商议；彼得、巴拿巴、保罗与雅各先后发言，最终决议外邦信徒不必受割礼，只需遵守几项基本诫命。','确立外邦人因信称义、不须遵守全部律法的教会立场。'),
  ('jerusalem-council','en','Disputes over whether Gentile converts must be circumcised and keep the law of Moses bring church leaders together in Jerusalem; after Peter, Barnabas, Paul, and James speak, the council rules that Gentiles need only observe a few basic requirements.','Settles the church’s position that Gentiles are justified by faith apart from the full Mosaic law.'),
  ('crossing-into-macedonia','zh-CN','保罗在特罗亚夜间得异象，见一个马其顿人求他说请你过来帮助我们；保罗与同伴便立刻搭船前往尼亚波利，再到腓立比，将福音带入欧洲。','福音传播从亚洲跨入欧洲的地理转折点。'),
  ('crossing-into-macedonia','en','At Troas, Paul has a night vision of a Macedonian man pleading, Come over and help us; he and his companions promptly sail to Neapolis and on to Philippi, bringing the gospel into Europe.','The geographic turning point where the gospel crosses from Asia into Europe.'),
  ('lydia-hosts-at-philippi','zh-CN','保罗一行在腓立比城外河边遇见一群妇女祷告，其中卖紫色布疋的吕底亚听道后信主受洗，并坚请保罗等人住在她家里。','欧洲第一位记名归信者，其家成为腓立比教会的雏形。'),
  ('lydia-hosts-at-philippi','en','Outside Philippi by the river, Paul’s party meets women at prayer; among them Lydia, a seller of purple cloth, believes and is baptized, and urges Paul’s group to stay in her house.','The first named convert in Europe, whose household becomes the nucleus of the Philippian church.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

UPDATE event_translations t SET detail = v.detail, significance = v.sig
FROM events e, (VALUES
  ('paul-and-silas-detained-at-philippi','zh-CN','保罗在腓立比赶出一名占卜使女身上的邪灵，触怒其主人，保罗与西拉被拉到官长面前遭鞭打下入监牢；半夜地震牢门自开，狱卒全家因此信主。','显明福音大能超越冤屈与监禁，也涉及罗马公民权的申诉。'),
  ('paul-and-silas-detained-at-philippi','en','After Paul casts a spirit of divination out of a slave girl at Philippi, her owners have Paul and Silas beaten and imprisoned; at midnight an earthquake opens the prison doors, and the jailer’s household believes.','Shows the gospel’s power despite unjust imprisonment and raises the issue of Roman citizenship.'),
  ('debate-at-athens','zh-CN','保罗在雅典看见满城偶像，心里着急，便在会堂与市场辩论，又被请到亚略巴古向哲学家演说，引用他们未识之神的坛，传讲创造宇宙的真神与耶稣复活。','福音首次正面与希腊哲学传统对话的经典场景。'),
  ('debate-at-athens','en','Distressed by the idols filling Athens, Paul debates in the synagogue and marketplace, then is invited to speak at the Areopagus, where he cites their altar to an unknown god to proclaim the Creator and Jesus’s resurrection.','The classic scene of the gospel’s direct encounter with Greek philosophy.'),
  ('long-stay-at-corinth','zh-CN','保罗在哥林多住了一年半，与百基拉、亚居拉同工制造帐棚为生，在会堂辩论，后专向外邦人传道；亚该亚方伯迦流不理会犹太人对保罗的控告。','哥林多教会的建立背景，也是保罗书信写作的重要场景。'),
  ('long-stay-at-corinth','en','Paul stays eighteen months in Corinth, working as a tentmaker with Priscilla and Aquila, reasoning in the synagogue and then turning to the Gentiles; the proconsul Gallio dismisses Jewish charges against him.','The founding background of the Corinthian church and an important setting for Paul’s letters.'),
  ('years-at-ephesus','zh-CN','保罗在以弗所停留约三年，天天在推喇奴学房辩论，行了许多神迹，使许多行邪术的人焚烧书卷归主；后来因银匠底米丢煽动，为亚底米女神的缘故引发骚乱。','行程中停留最久之地，反映福音对当地宗教经济的冲击。'),
  ('years-at-ephesus','en','Paul remains at Ephesus about three years, teaching daily in the hall of Tyrannus and working many miracles; sorcerers burn their books, and later a riot breaks out, stirred up by the silversmith Demetrius over the goddess Diana.','The longest stay in the itinerary, showing the gospel’s impact on local religion and trade.'),
  ('arrest-in-jerusalem','zh-CN','保罗回到耶路撒冷，在圣殿里被亚细亚来的犹太人认出并煽动群众，指控他污秽圣殿；众人正要打死他时，罗马千夫长率兵赶来将他救出并拘押。','保罗宣教生涯转入被囚受审最后阶段的起点。'),
  ('arrest-in-jerusalem','en','Back in Jerusalem, Paul is recognized in the temple by Jews from Asia who stir up the crowd, accusing him of defiling the temple; as they try to kill him, a Roman captain intervenes with soldiers and takes him into custody.','Opens the final phase of Paul’s ministry, moving from mission to imprisonment and trial.'),
  ('hearing-at-caesarea','zh-CN','保罗被押送到该撒利亚，先后在巡抚腓力斯与非斯都面前受审，又向亚基帕王陈明自己的经历与信仰；因不服犹太人的控告，保罗上告该撒，要求解往罗马受审。','保罗行使罗马公民权，把案件带往帝国中枢罗马。'),
  ('hearing-at-caesarea','en','Brought to Caesarea, Paul is heard before the governors Felix and Festus and gives his testimony before King Agrippa; rejecting the charges against him, he appeals to Caesar, requiring transfer to Rome for trial.','Paul exercises his Roman citizenship, moving the case toward the imperial capital.'),
  ('shipwreck-at-malta','zh-CN','保罗作为囚犯乘船前往罗马途中遭遇风暴，船在米利大岛附近触礁破裂，全船二百七十六人却因保罗蒙神应许而全部安全上岸；岛上居民待他们甚是友善。','航程中断而未毁灭，印证保罗必到罗马作见证的应许。'),
  ('shipwreck-at-malta','en','Sailing as a prisoner toward Rome, Paul’s ship is caught in a storm and wrecked off the island of Malta; all two hundred seventy-six aboard reach shore safely as promised, and the islanders show them unusual kindness.','The voyage’s interruption without loss of life confirms the promise that Paul would testify at Rome.'),
  ('patmos-vision','zh-CN','使徒约翰因传神的道被放逐到拔摩海岛，在主日被圣灵感动，见复活的基督向他显现，吩咐他将所见异象写下来，分送给亚细亚的七个教会。','启示录写作的自述场景，将末世异象文本与流亡处境相连。'),
  ('patmos-vision','en','Exiled to the island of Patmos for the word of God, the apostle John is in the Spirit on the Lord’s day when the risen Christ appears to him and commands him to write down his visions for the seven churches of Asia.','The stated setting for writing Revelation, linking the apocalyptic visions to John’s exile.')
) AS v(slug, locale, detail, sig)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

-- Summary rewrites for events whose placeholder zh-CN summary was under 10 characters
UPDATE event_translations t SET summary = v.summary
FROM events e, (VALUES
  ('annunciation-at-nazareth','zh-CN','天使加百列在拿撒勒告知童女马利亚，她将因圣灵感孕生下耶稣。'),
  ('annunciation-at-nazareth','en','The angel Gabriel tells the virgin Mary at Nazareth that she will conceive by the Holy Spirit and bear Jesus.'),
  ('flight-to-egypt','zh-CN','希律下令杀婴，约瑟带马利亚与耶稣连夜逃往埃及避祸。'),
  ('flight-to-egypt','en','Warned of Herod’s massacre of infants, Joseph flees by night to Egypt with Mary and Jesus.'),
  ('return-to-nazareth','zh-CN','约瑟因惧怕亚基老，带家人从埃及回到加利利的拿撒勒定居。'),
  ('return-to-nazareth','en','Fearing Archelaus, Joseph settles his family in Nazareth of Galilee instead of Judea.'),
  ('baptism-at-the-jordan','zh-CN','施洗约翰在约旦河为耶稣施洗，圣灵如鸽子降下，天上有声音宣告。'),
  ('baptism-at-the-jordan','en','John baptizes Jesus in the Jordan; the Spirit descends like a dove and a voice from heaven declares him God’s Son.'),
  ('calling-of-the-first-disciples','zh-CN','耶稣在加利利海边呼召彼得、安得烈、雅各、约翰撇网跟从。'),
  ('calling-of-the-first-disciples','en','By the Sea of Galilee, Jesus calls Peter, Andrew, James, and John to leave their nets and follow him.'),
  ('entry-into-jerusalem','zh-CN','耶稣骑驴驹进耶路撒冷，群众铺衣呼喊和散那，迎祂如君王。'),
  ('entry-into-jerusalem','en','Jesus rides a donkey’s colt into Jerusalem as crowds spread cloaks and wave palms, hailing him as king.'),
  ('arrest-on-the-mount-of-olives','zh-CN','犹大在客西马尼园以亲吻为号，带兵丁拿住耶稣，门徒四散逃跑。'),
  ('arrest-on-the-mount-of-olives','en','In Gethsemane, Judas betrays Jesus with a kiss and soldiers seize him as the disciples flee.'),
  ('first-journey-begins-at-cyprus','zh-CN','安提阿教会差派巴拿巴与保罗出发，乘船前往塞浦路斯宣教。'),
  ('first-journey-begins-at-cyprus','en','The Antioch church commissions Barnabas and Saul, who sail to Cyprus to begin the mission.'),
  ('crossing-into-macedonia','zh-CN','保罗在特罗亚见异象，随即渡海前往马其顿，福音传入欧洲。'),
  ('crossing-into-macedonia','en','A night vision at Troas leads Paul to cross into Macedonia, bringing the gospel to Europe.'),
  ('arrest-in-jerusalem','zh-CN','保罗在圣殿被认出遭群众攻击，罗马千夫长赶来将他拘押保护。'),
  ('arrest-in-jerusalem','en','Recognized in the temple, Paul is attacked by a mob and taken into Roman custody for his own protection.')
) AS v(slug, locale, summary)
WHERE t.event_id = e.id AND t.locale = v.locale::locale_code AND e.slug = v.slug
  AND e.work_id = '10000000-0000-4000-8000-000000000005';

COMMIT;
