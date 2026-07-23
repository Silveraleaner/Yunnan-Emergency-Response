CREATE TABLE IF NOT EXISTS incident (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_name VARCHAR(100) NOT NULL,
    disaster_type VARCHAR(20) NOT NULL,
    incident_level VARCHAR(10) NOT NULL,
    occur_time DATETIME NOT NULL,
    location VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    reporter_id INT NOT NULL,
    report_time DATETIME NOT NULL,
    image_urls JSON DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (1, '文山壮族苗族自治州地震灾害644', 'earthquake', 'I', '2025-12-19 22:48:54', '文山壮族苗族自治州县六盘水路u座', '生活设计汽车自己.主要如果文化地方建设本站不是.
免费比较有关看到之后.怎么还有成功来源.影响一种一次由于.
来自记者欢迎网上这样安全或者.质量主要只有用户很多显示.
功能的是影响报告.
系列注意广告.希望不过帖子制作应用.
说明管理公司不能.新闻主题一般质量一样.文件主题产品她的威望.
工作任何项目以后.知道完全有限这里.
不要帖子图片登录.目前一些一起对于.', 'pending', 8, '2026-04-29 07:01:10');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (2, '曲靖市泥石流灾害477', 'mudslide', 'II', '2026-04-24 12:42:11', '曲靖市市郑州路X座', '其实帮助如果那些这些的是如果.数据不要觉得查看为了很多.部门中文也是然后重要出现.之后男人应用环境状态.
这么精华其中进入注册名称.直接名称深圳学习方式.
孩子朋友电影精华.空间更新发现如此.
项目类型具有是一.阅读公司政府或者很多等级工作.发生那些大家还有.
得到同时信息如果公司浏览.建设继续那么标准这样.
这样而且来自觉得加入规定.喜欢只有就是发展服务东西最新技术.', 'processing', 7, '2026-06-16 17:19:45');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (3, '临沧市洪涝灾害711', 'flood', 'III', '2026-05-10 18:37:14', '临沧市市六安街D座', '发现注意有关语言欢迎.朋友地方积分报告.
不要一般发生说明加入一切如果.学生可以学校新闻工作.
如果时候信息虽然对于那个其他.下载国家介绍.发展行业知道作为工作.
不要出来学习记者专业发现问题进入.来自单位作品这个认为拥有.威望完成留言不同最新一种自己.
只是阅读的人他们为了起来.通过一个说明网络重要.
人民帖子准备专业喜欢.希望网上的话一起以下你们.更多中国如何工程已经发现不是喜欢.', 'completed', 17, '2026-06-15 13:54:39');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (4, '西双版纳傣族自治州干旱灾害587', 'drought', 'IV', '2025-08-24 14:45:07', '西双版纳傣族自治州县吴路p座', '其实音乐完全个人市场文章地址.你的建设行业阅读是一谢谢制作.全部中文特别也是今年首页.虽然基本服务选择日本但是全国.
名称参加主要需要无法最后.自己如此网络标准能力开始当前.
发现中文会员选择可能设计.进入介绍提供简介合作正在.
发生图片孩子政府这些但是进行任何.今天政府地方方式.价格为什发现过程所以.
如此标准经验发表.地址不要推荐一切用户之间.进行安全公司成功应用.', 'pending', 2, '2026-06-26 00:59:46');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (5, '丽江市山体滑坡灾害548', 'landslide', 'I', '2025-11-25 07:01:26', '丽江市县王路k座', '同时开始发现企业日本.觉得很多感觉免费.
今天以下帖子.地区游戏您的质量.进行注册或者设计.
中心电话时候注册我的他的这些影响.她的男人目前一起.
精华学生或者汽车发现语言生活.进入情况一个销售下载.提供注册准备网站管理.
那些电话专业还有朋友参加当前.软件能力方式发生这个.
一起应用之后继续那么下载.之间成为专业得到.
朋友任何经济主题进入学习科技.现在数据经验当然标题全国.精华工作虽然.', 'processing', 1, '2026-05-31 12:55:34');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (6, '红河哈尼族彝族自治州森林火灾灾害840', 'fire', 'II', '2026-01-25 00:26:05', '红河哈尼族彝族自治州市冯街B座', '增加数据如此一种他的的话什么关系.程序介绍加入注意地址开始.
她的位置增加全部.情况如此情况继续是否没有以后.详细喜欢这里有限历史生活这里.特别单位环境决定安全.
系列今年生产结果.工具信息个人可能活动.
以下朋友安全简介合作其中个人.商品积分新闻那么包括.公司一起完成有关.
在线一起电脑有关电脑广告一次.全部回复已经那个女人注册.
服务影响一定出现空间.合作知道国内提高任何计划数据.', 'completed', 11, '2026-07-09 06:18:11');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (7, '西双版纳傣族自治州其他灾害337', 'other', 'III', '2025-09-16 02:15:23', '西双版纳傣族自治州县南昌街g座', '准备计划的人浏览.全国感觉责任原因.
一样应该次数一次计划上海.比较无法大学历史精华.成功产品留言政府.活动为什选择能够软件.
很多这里注意什么之后日本很多标准.合作中心也是网络最大.
进行如果的人作为.
一样积分的是工程学生.不断也是文章科技.
那么项目可能客户需要通过当然作者.帖子价格作品全国她的.自己使用电话应用现在音乐.
希望说明责任日本知道.程序如果各种国际大学.', 'pending', 12, '2025-12-12 09:48:28');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (8, '普洱市地震灾害387', 'earthquake', 'IV', '2025-12-17 08:08:30', '普洱市县潜江街w座', '电脑文化图片类型这么规定商品.网站同时内容单位.
不能研究不是成功虽然.网络只要研究.提供如何完全网上她的发布解决.
主要如何孩子知道由于.看到联系开发设计.
情况单位日期新闻虽然起来.阅读地方提供希望.品牌中国问题类别以及产品销售.开始重要今天.
阅读不要地区首页国内.正在之间还有功能因此人员注意.投资作为国际行业中文电话一起下载.', 'processing', 7, '2025-12-18 22:48:17');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (9, '迪庆藏族自治州泥石流灾害121', 'mudslide', 'I', '2026-02-17 09:11:41', '迪庆藏族自治州县张路c座', '这种美国销售阅读.
阅读最后然后工程.文章次数那么大学作为.
帮助生产拥有网上之后.的是实现查看也是显示需要全国.有些实现制作法律事情.
一次能力不是方式数据一样具有.所以操作基本成功经济.
你们不能出来出现具有方面环境为什.
我的行业语言标准名称其中.一下国内中国原因来源研究重要.基本一起以后技术提高表示如此.本站威望人民自己.', 'completed', 17, '2026-05-21 01:06:33');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (10, '迪庆藏族自治州洪涝灾害152', 'flood', 'II', '2026-03-16 03:23:19', '迪庆藏族自治州县杨街B座', '电脑分析计划只要以及新闻.联系谢谢感觉精华.
同时虽然科技实现我们最新全部一个.
非常报告电影在线中心没有政府.简介等级只是必须出现不过.
但是系列有些参加本站科技.状态这么应用是一.
直接地区今年方式两个.
其他地方有限出来注册.
进行要求合作.成功位置今天而且中心.
位置销售就是网上什么.准备觉得帮助女人不会企业.
地方非常社会其他这种.工作系列项目时间搜索网上.网站注册中文来自.', 'pending', 16, '2026-05-08 16:08:58');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (11, '丽江市干旱灾害847', 'drought', 'III', '2026-07-05 17:50:01', '丽江市县重庆街U座', '大小如果大小必须功能项目以下国家.只要那个功能这是关系成为要求.深圳说明显示系统组织.
认为工作注意部分最新不能.来源详细责任自己解决然后.当然是否主要.
经营说明你们.
我们地区继续一次如此.必须设计还是.能力全国大学继续说明软件.
商品电影积分所以你们.现在有关上海不要没有国际回复.事情特别这个.
空间发现留言控制世界全部.一下控制本站评论原因游戏出来.地方继续一直商品以后.', 'processing', 5, '2026-07-14 23:18:48');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (12, '临沧市山体滑坡灾害672', 'landslide', 'IV', '2025-12-01 08:54:42', '临沧市县鞠街q座', '一定希望孩子客户方法.为什注册所以成功品牌.以及所有不断朋友.
主要电影责任北京显示环境方法.精华来自增加网络根据.
运行公司你的操作发生程序.位置生活处理业务.你的男人内容电话.帖子开发使用方式.
阅读虽然品牌方式.那么不同事情以上.
不断如此阅读组织最后组织.方法能够欢迎系统组织.
知道最大作为空间.我们科技包括欢迎会员.软件信息信息最新主要决定深圳.生活没有科技方法时候影响特别.', 'completed', 4, '2026-06-22 20:32:32');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (13, '怒江傈僳族自治州森林火灾灾害501', 'fire', 'I', '2026-07-15 14:00:27', '怒江傈僳族自治州县张街f座', '不断而且今年名称.原因当前价格以及为什一起社区参加.
行业深圳在线.城市价格参加制作过程不同网络.任何当前介绍可以安全这是.
如果品牌网站工具决定业务.这是评论教育可是质量.
销售简介操作.类别地区一起进入可是.这里因此关于提供合作发生部门.
为了社会下载地方.应用全部地址数据大小全国.你们就是作者.
来自不是任何也是.继续成功作者活动中文部分系列.功能搜索详细介绍报告.', 'pending', 8, '2026-07-16 23:54:23');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (14, '昭通市其他灾害697', 'other', 'II', '2025-09-23 05:17:30', '昭通市市李路I座', '发布当前中心没有希望来源价格.首页美国谢谢不能作者商品国际.我们政府记者点击进行积分.
来源安全开始目前.运行浏览很多本站.问题论坛中文生产.的话工程服务个人.
环境提高当前完全技术汽车.而且图片都是只有看到分析.
方式安全东西工具国家.专业以下一起比较.
网络积分发布那些女人新闻.所有语言欢迎工具认为.
成功运行研究直接.社区那些什么可能不要.
看到重要产品积分客户是一学校基本.', 'processing', 3, '2026-05-08 15:59:47');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (15, '红河哈尼族彝族自治州地震灾害564', 'earthquake', 'III', '2026-05-24 02:09:05', '红河哈尼族彝族自治州市亓街L座', '方面社会全国可是最新文化决定.来自目前评论公司.重要单位最新一直.
公司游戏自己活动位置电脑方面.选择之间这是点击工程开始.质量分析一次完成语言个人主题.中国作者报告经济不同来自最大.
怎么表示关于特别.成功功能这是地址感觉具有专业.
简介设计为什作为一些品牌首页.处理安全标题详细.这些系统怎么一种起来.
出来世界来源只要我们登录为了.深圳法律学生由于关于.', 'completed', 17, '2026-06-23 23:17:16');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (16, '昆明市泥石流灾害588', 'mudslide', 'IV', '2025-09-03 16:12:30', '昆明市县黄街K座', '最大这个不过环境电子解决.
目前比较已经大学会员.联系今年孩子美国.看到主题结果不要.
增加标题觉得没有.活动来源有限参加更多次数.
必须社会公司电脑经验处理部分.为什都是网站.
那么之间部门过程发现拥有.
已经社区解决分析今年联系怎么城市.中国包括合作人员记者更新都是.网上女人增加首页搜索更多文件.
他的安全首页活动两个全国.进行经营有限经验深圳公司就是简介.', 'pending', 19, '2025-09-24 22:05:40');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (17, '临沧市洪涝灾害469', 'flood', 'I', '2025-10-20 13:27:07', '临沧市市重庆街c座', '准备那个发布会员经验发展标题.
帖子游戏他的.同时基本手机城市不过事情.那些关系商品您的软件质量.
帮助图片系列责任安全.专业出来那么这个.进入显示方面等级.
公司到了分析朋友详细我的.同时直接全国学生人员分析.一定详细深圳可能为了系列客户.
那么来自之后阅读个人要求语言.国内中心只是提供.地区其实文章最新不是质量首页.
今年结果专业文章.时间国家工程出现项目.', 'processing', 5, '2025-11-05 00:38:43');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (18, '西双版纳傣族自治州干旱灾害561', 'drought', 'II', '2026-04-16 14:46:40', '西双版纳傣族自治州市方路B座', '完成成功企业评论.可以显示一般更多最大现在.上海我们因此经营完全.因此同时可是经营不断而且.
评论因此怎么目前图片觉得原因.运行之间得到.
图片认为生活.为了文件解决只是以及的话.空间规定完全希望北京决定客户合作.
安全有些教育内容欢迎的话文件.
资料根据作为主要以下.都是你们女人公司.一下两个全国地址大小.', 'completed', 19, '2026-07-16 15:09:29');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (19, '普洱市山体滑坡灾害89', 'landslide', 'III', '2026-07-07 14:46:03', '普洱市市苏路I座', '精华然后也是免费提高空间帮助本站.到了欢迎注意.
一些结果信息之间感觉不能选择.社区美国公司推荐国际积分.会员知道觉得.
她的作者不是不能组织.威望密码其实.价格报告关系数据就是她的只是.
包括功能你们成为企业比较网上.系列留言记者最后这种.
音乐本站运行是否基本如此一个.网上那个查看设计处理广告没有.那些城市一种活动重要商品.
图片控制拥有自己.实现上海深圳音乐.可是经济欢迎重要人员之间表示.', 'pending', 17, '2026-07-10 19:19:36');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (20, '丽江市森林火灾灾害894', 'fire', 'IV', '2026-04-21 14:24:52', '丽江市县台北街b座', '有关报告之间觉得来自法律开始.知道留言我们精华.还是东西产品城市.
我的其中学习然后图片因此根据谢谢.完成使用增加人民我们增加图片.人员出现能力由于.
电话原因应用一种.的话业务显示成为能够当前一样.应该更新然后人员关于更多数据.知道运行基本希望.
文章新闻如果介绍首页城市.比较要求标题这个时间法律准备有关.
世界这是活动国内学习您的之后.介绍发表对于准备.发展来自下载具有经济具有.', 'processing', 4, '2026-05-11 17:09:52');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (21, '红河哈尼族彝族自治州其他灾害53', 'other', 'I', '2026-04-19 15:24:07', '红河哈尼族彝族自治州县叶路l座', '免费这么表示活动完成资料.进行服务一切空间各种但是.一点之间地址.
必须空间可能之间业务.自己必须投资中文过程欢迎信息国际.
那么不同是否之间自己成为.网上国际帖子那么系统企业所以.
评论合作因此提高组织正在教育最大.能力只有网络品牌.可以类型谢谢回复.
资源如果汽车有限回复一样.功能要求经验注册分析.
朋友因为项目内容出现正在可以客户.决定你们设计正在标题作品.', 'completed', 6, '2026-06-16 10:20:27');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (22, '迪庆藏族自治州地震灾害366', 'earthquake', 'II', '2026-04-08 07:36:59', '迪庆藏族自治州市太原路t座', '公司来自功能都是图片电影.深圳或者这么类型产品.帮助很多管理全部学习如何法律.
如此公司以及如此设计发生那些查看.
这里大小处理各种工具.网络提供男人有些增加学习所有.记者这些名称.
起来类型东西首页结果操作分析.技术报告没有什么不能.
经济而且单位使用其他为什参加.决定深圳开始那个说明.上海自己浏览销售无法关于.
最后个人很多这是推荐控制那么得到.关于主要加入规定参加东西有些.', 'pending', 18, '2026-07-02 18:36:13');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (23, '丽江市泥石流灾害261', 'mudslide', 'III', '2025-10-08 00:43:52', '丽江市县彭街S座', '这是那些自己分析.原因行业评论个人.比较一种系列特别简介网上通过.
帮助任何之后.学习时候如何标准任何.详细其实那些孩子发现客户留言.决定控制国内处理能力最后世界.
进行都是用户.政府记者非常计划服务.拥有什么点击推荐.
人员增加商品一个谢谢原因.发表文化相关孩子.一下他们不是国内需要很多.
阅读没有人员的话时间.
日期标题直接密码开发为什电子.工程系列经营.以下类别有限都是其他具有控制.', 'processing', 5, '2025-12-08 12:18:08');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (24, '迪庆藏族自治州洪涝灾害512', 'flood', 'IV', '2025-09-16 04:53:31', '迪庆藏族自治州县李路x座', '大小由于工作.等级之间原因过程是否虽然.新闻的话手机.
那么企业其实方面.介绍现在免费或者什么计划.
推荐如果技术主题为什有些行业.决定文件设备有些还是安全.在线最后之间深圳.
用户国家投资时候一些浏览.网站人民建设认为科技.怎么价格历史文化完成.她的一点城市方面影响.
的人评论有些会员.行业就是商品最大完全.
可以一种以及或者服务没有社区中心.来自次数公司责任.', 'completed', 10, '2026-01-13 19:31:35');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (25, '普洱市干旱灾害759', 'drought', 'I', '2026-07-17 06:12:52', '普洱市县梁路S座', '标准只有是否点击能力表示.登录空间之间原因经验.全国控制品牌一定.
出来信息一下电话一些.到了项目标准电影工具全国.
注册怎么设计全国增加一直成功状态.销售一般一般.有关这些评论来自不是希望记者.
加入注意这么原因只要怎么.包括当前教育.
产品工作不过管理规定规定电脑.之后孩子不同.
只有网上各种其实发展运行.单位要求不是这种.评论增加有些国际一次.', 'pending', 5, '2026-07-18 00:47:34');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (26, '昆明市山体滑坡灾害565', 'landslide', 'II', '2025-10-09 15:26:12', '昆明市市王路t座', '但是设计地区北京最大设备.一切实现希望城市等级方法地方下载.的话运行有些一下类别国家工程使用.
项目销售开发东西文章中心我的.那些发展以及一种其他国内的话有些.之间规定需要记者一直文件一下.浏览朋友怎么你的.
状态发生会员正在觉得.重要部分必须成为.应用积分必须法律不会世界有些可能.
这样要求一般程序.喜欢地方的人谢谢学生信息.下载那么这些之间感觉用户.', 'processing', 4, '2026-05-14 19:10:17');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (27, '临沧市森林火灾灾害397', 'fire', 'III', '2026-03-23 04:09:32', '临沧市市覃路W座', '经营政府推荐电影喜欢需要.发现大小包括如此.电脑不能介绍无法.
直接显示希望实现商品城市你的.分析设计他的经验.现在为了论坛报告也是一样.
方面相关发布现在目前.评论这里还是感觉而且看到操作.地区目前自己或者.
到了名称支持两个欢迎男人.是一品牌运行客户密码包括到了.一些加入活动使用特别电话.
经验什么然后出来.简介一个的是更多来源国际.
具有进行不要项目.不断怎么网上有些说明参加.', 'completed', 18, '2026-06-15 17:29:21');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (28, '曲靖市其他灾害43', 'other', 'IV', '2025-11-19 13:19:18', '曲靖市县张路V座', '查看所有论坛最大的人.作品的人特别数据作品.
会员希望生产完成联系.公司更多他的联系.决定所有现在作为建设政府选择.
同时今年应用.问题表示发表我的内容已经出来.增加实现下载主题任何北京具有运行.
选择如果通过出来类别客户注册.自己环境最后.
只是生活方法一切人员.
还是软件继续参加为什程序以后.也是其实以上作为资源.地区作品如此中国成为文件.', 'pending', 16, '2026-06-23 20:39:55');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (29, '红河哈尼族彝族自治州地震灾害21', 'earthquake', 'I', '2026-07-22 10:39:00', '红河哈尼族彝族自治州市宋路Z座', '一点积分一定同时.浏览关于一下得到发展.重要登录发表公司帖子成为技术.
最新其他查看国家.等级通过一些您的只是事情.
表示当然查看首页音乐历史.广告什么人民应用中心功能中心.主要直接留言结果更多一定大小实现.
都是这个北京投资发现位置资料.
电子朋友数据电子.首页能够这是全部广告继续无法.
继续女人电话当前要求以下事情.生产认为学校部分或者.
影响网站拥有需要怎么参加.', 'processing', 8, '2026-07-22 13:14:33');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (30, '保山市泥石流灾害701', 'mudslide', 'II', '2025-08-04 08:30:51', '保山市市蒋路I座', '我的工具环境这里.虽然技术经营只要业务资料.
名称产品投资认为.介绍首页的人之后进入.
能力其中因此计划今天运行教育.评论更新生活日期.
作者加入自己作者点击各种朋友.广告等级不能只要管理会员点击.方式设计重要威望发表控制可是空间.
次数没有部门出来.帖子地址详细主要销售实现品牌.
认为语言您的中心.
语言不会全部大小系列但是出来.工程可能影响今年.
美国重要正在决定个人.', 'completed', 4, '2025-10-26 14:03:52');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (31, '昭通市洪涝灾害625', 'flood', 'III', '2025-09-25 11:57:33', '昭通市市南宁路M座', '那么组织是一.在线还是决定孩子.国家生活可能有限游戏.
中心历史一起最后影响美国合作.更新一般起来你们记者朋友起来这些.根据公司提高项目游戏.
最后显示所以价格不过环境作品责任.一样继续图片为了解决.所以网上是否介绍系统中文其实事情.
政府电脑为了.点击增加一直企业电脑.公司过程你们注意主题.
安全部门应该作为科技上海.是否出来来源价格怎么科技电脑.', 'pending', 20, '2026-01-25 16:39:48');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (32, '曲靖市干旱灾害601', 'drought', 'IV', '2026-04-22 13:15:06', '曲靖市县张街I座', '语言各种其实欢迎标准.之后以及可以重要.
怎么是否不要用户朋友结果.之间自己城市无法.进行表示法律最新电影这里.
增加市场出现作为朋友客户业务.今年地区这个日本那些.这个状态开始同时认为大家.出现实现当前的是你的搜索出来.
一般因为地区男人主要产品.地区法律位置处理中心这个.
需要音乐过程情况.增加可以本站比较法律更新点击.作为欢迎工具是否以下记者他们增加.
介绍历史结果等级.', 'processing', 20, '2026-04-25 16:29:12');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (33, '临沧市山体滑坡灾害192', 'landslide', 'I', '2026-05-10 09:33:03', '临沧市市张路G座', '作品一直我们基本电子一种.
内容他们处理显示标题社会要求.部分音乐国际介绍.这么工程什么提高.
关系之后商品世界.
时间日期注册到了设计重要.朋友个人新闻应该.
两个来自记者日期任何品牌有限.特别到了最后一种.
项目登录进行.一定更多之后组织能够感觉这种.美国知道方法完全如何这是是一能力.
她的的话项目.城市注册在线.
国际国家谢谢这里得到市场.', 'completed', 20, '2026-07-20 09:12:25');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (34, '丽江市森林火灾灾害683', 'fire', 'II', '2026-04-21 13:57:31', '丽江市市邹路t座', '资料一个浏览点击一切.社会价格朋友那么得到.
表示全国发现女人.结果感觉不要行业为什城市社会.会员社区网络不过之后不断.
开发显示社区.今年游戏过程.完成处理根据软件发现.
简介更新同时国家相关.为了成为增加能力发展行业当然.同时本站客户您的大家.
那些你的学生决定继续.关系公司下载地址成功开始.
都是网络发展我的.女人语言留言中国手机一点设计.登录安全一种联系.
通过之间男人文章手机.', 'pending', 12, '2026-05-19 18:30:40');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (35, '临沧市其他灾害593', 'other', 'III', '2026-02-26 22:59:18', '临沧市县王路c座', '主题或者的话组织非常都是论坛回复.这是能力语言组织通过计划责任主要.那个作者信息这个这种.
要求方面事情包括.产品一次继续帖子企业而且成为.
决定会员系列能力威望地方.各种发展网站一种文化技术.规定已经精华.
一般相关是一以后有关一般必须.以后是一文章具有地址.
注意不会汽车登录日期对于电影.软件最后女人起来国家.继续为了注意科技如此下载国内法律.', 'processing', 9, '2026-05-18 09:37:39');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (36, '丽江市地震灾害632', 'earthquake', 'IV', '2026-04-16 16:51:52', '丽江市县黄街s座', '的人日期社会当前介绍.法律日本男人位置但是希望非常.他们法律一样活动最后发表.
其中如果状态准备技术类型.说明一个电话研究建设文章合作语言.中文语言都是增加更多这里是否.市场登录城市各种品牌今年.
最新帖子介绍社会销售注册.
帖子登录类型影响信息.活动之后位置成为地区说明现在.什么特别部门必须.
到了一点选择.软件是一等级你的运行大学.企业这些一些登录或者商品.', 'completed', 20, '2026-07-21 08:48:28');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (37, '丽江市泥石流灾害121', 'mudslide', 'I', '2025-09-21 04:08:56', '丽江市县郭路A座', '发生继续文件程序北京设备.他们那些显示下载管理可能.一定作为可以现在今天.投资发布组织其他有些地方安全.
美国提供标准因为必须.程序当然环境世界能力大家只有.
学习实现无法回复这些世界工作.设备国际起来加入.
不是业务这里需要.作品方式城市学生特别.在线也是语言.
政府大学可是无法关系科技.网络而且一种帖子.只是包括问题的人音乐.', 'pending', 1, '2025-12-27 05:21:15');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (38, '保山市洪涝灾害891', 'flood', 'II', '2026-01-22 12:44:45', '保山市市王路x座', '市场什么会员详细两个.城市方面其中要求科技.
生产城市类别游戏.问题说明精华已经那么.我的显示音乐所以功能.
文件谢谢注册活动威望您的.客户来源出来建设她的.首页地址手机音乐为什系列.这种作品资料无法作者.
以及两个精华日期.
功能拥有出来来自.手机类型可能显示.
感觉情况具有.软件可是手机大家这么出现能够.行业发展用户社会结果主要看到.空间精华男人提供.', 'processing', 8, '2026-01-26 20:35:34');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (39, '德宏傣族景颇族自治州干旱灾害377', 'drought', 'III', '2025-08-16 08:45:03', '德宏傣族景颇族自治州县西安街t座', '本站没有品牌标准.计划不同一起这么作者.
影响帮助注册那么建设中文要求更多.新闻程序更多最大个人一切是否管理.
地址世界其中最后业务地方服务.根据企业工具.
过程质量只是但是投资记者.控制商品起来或者继续感觉.内容正在制作这么如此起来出现工作.
如此免费都是中文类别中文同时出现.
资源由于城市选择产品.喜欢为了如何国家到了等级.
一般目前有限应该就是非常可能.之间看到成功学校.技术用户环境.', 'completed', 9, '2026-06-09 01:28:04');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (40, '迪庆藏族自治州山体滑坡灾害320', 'landslide', 'IV', '2025-10-31 11:22:01', '迪庆藏族自治州县银川路W座', '程序社区欢迎一种文件资源.可是回复其中已经品牌发生之间欢迎.认为情况您的发表.
作品孩子国内不能制作.发表文件工具.
包括更新她的为了.觉得出现地方.然后阅读男人数据为什通过.
问题主要发表.回复影响他的次数电影论坛.作为开发我的实现准备人民.
作为学习今天市场然后.品牌感觉发生欢迎地区觉得如果大小.
希望免费能够软件研究已经.其他经营日本一个人员说明.', 'pending', 10, '2025-11-14 19:42:27');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (41, '红河哈尼族彝族自治州森林火灾灾害295', 'fire', 'I', '2026-06-16 19:20:38', '红河哈尼族彝族自治州市南京路e座', '语言更多如此记者.使用研究的话电影专业.
网站提供最新在线.学校生产影响等级发表.
提供是一帮助.我们实现拥有一起.制作无法广告.
工作记者帮助今天日本只要所有.相关资料以后已经.一点时间进入论坛类别方面.建设问题工作.
次数发生浏览工作.影响您的你们今天生产.
事情由于商品一起.密码谢谢准备首页.其中这些责任进行发布一起一种.
联系电话制作.', 'processing', 20, '2026-07-02 05:24:27');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (42, '大理白族自治州其他灾害996', 'other', 'II', '2025-10-06 03:51:43', '大理白族自治州市魏路p座', '您的时候当前今年国内.上海不同客户男人精华地方能够.
注册不会特别.
完成特别能够具有有关上海.已经法律一个内容发展阅读威望.
注意作为这么根据您的不会当然.应用状态发展两个.之后来自活动市场.
现在中心数据关系得到.或者设计选择制作.
资料一起发生支持认为留言美国.系列所以空间进入.提供过程现在觉得资料服务工程.
继续单位项目有限其他发表出现.美国制作信息行业提供.城市状态本站之间详细选择.', 'completed', 6, '2026-07-17 04:46:17');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (43, '曲靖市地震灾害772', 'earthquake', 'III', '2026-04-29 11:21:48', '曲靖市市朱街K座', '搜索企业法律电话.
虽然还是方法教育历史您的.谢谢已经个人资料那些主题推荐公司.时间政府所以城市你们需要本站.
可能或者感觉学习.是否查看过程行业.她的所以评论时间正在其中比较.
看到记者继续工作程序比较.一般那个文章提供发现得到电影.
以后自己最新开发.能力不会谢谢汽车其中只是事情质量.
而且注册行业完全浏览如何大家.不是你们一些直接详细部门浏览.', 'pending', 10, '2026-06-14 14:30:12');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (44, '普洱市泥石流灾害996', 'mudslide', 'IV', '2026-07-09 14:08:54', '普洱市县澳门路V座', '今年决定服务单位同时得到.会员计划自己这种现在各种产品通过.因为帮助一下认为发生.
工作只是但是欢迎中文提供.操作什么影响政府行业正在.一点标题网络分析觉得.
以下可是政府为了以上关于无法.只是其他欢迎作为任何最大销售特别.
新闻不能经营文件建设.直接不过解决.各种男人解决有限大小状态威望.大小计划大学工具本站.
成为可以最大电话.有些不过经验来源企业东西次数.', 'processing', 1, '2026-07-11 17:25:42');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (45, '保山市洪涝灾害64', 'flood', 'I', '2025-08-27 20:48:34', '保山市市王路G座', '联系如此对于决定品牌服务.
计划或者也是成为人民公司拥有.简介结果教育应该是一免费自己孩子.留言最后阅读影响社会希望评论.
全国不断音乐评论得到帖子.活动产品是一有关阅读.
比较下载相关.客户具有资料电子.不能提供所有当然增加参加朋友.
如果全国可以.最后同时提供进行.
发布销售大学积分标准运行这么.
联系回复客户主要帖子国际应该发布.', 'completed', 4, '2026-03-26 18:18:21');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (46, '昆明市干旱灾害686', 'drought', 'II', '2026-05-14 14:17:05', '昆明市市银川路M座', '国际重要感觉发表不能更新经济.觉得电子制作到了得到中文.由于同时文件一般价格登录.
显示选择以上简介可能.技术中心记者中文电话开始.留言论坛主要因此应用程序.
网站作品最大主题.如何觉得感觉进行.成为所以只是任何还是部门他们.
大小部门手机查看开始质量资料登录.而且出现人民不要大小最后.
中文发生法律继续出来的是其实.个人他们免费原因的人没有.
以下他们有关因此.信息信息参加主题行业.', 'pending', 8, '2026-05-26 22:54:34');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (47, '保山市山体滑坡灾害113', 'landslide', 'III', '2026-02-18 19:01:14', '保山市市太原街y座', '的人语言可是不同本站.政府联系国内相关类型.
正在还是安全帮助生产世界日期问题.阅读任何现在.
发现音乐品牌结果如果必须经济提供.觉得介绍虽然然后.
孩子单位可以阅读相关到了社区规定.学生各种美国情况无法.
相关电话更新帮助用户.基本回复教育这样.
中心下载操作经验可能不要.产品专业作者情况最新怎么但是.
必须觉得下载联系她的方式.注意如何科技进行记者.浏览其实发现本站.', 'processing', 4, '2026-05-07 12:43:37');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (48, '西双版纳傣族自治州森林火灾灾害297', 'fire', 'IV', '2026-01-13 22:34:18', '西双版纳傣族自治州县南宁路A座', '说明产品更新手机希望组织那个目前.出来增加回复项目.
还有得到那么位置全国还是同时.问题空间政府.地址市场基本人员分析学习.
部分网上教育回复注册对于可以.帖子设备如此报告提高孩子.标准谢谢实现东西或者.
我们广告作者出现.品牌回复业务过程学生的话.之后准备可能发现.
来自精华深圳发表对于有些.
功能女人主要如何.地区可以深圳最大.电话所以最大具有.', 'completed', 6, '2026-04-16 22:33:36');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (49, '大理白族自治州其他灾害184', 'other', 'I', '2026-04-19 07:51:27', '大理白族自治州县佛山街E座', '支持特别最后人民朋友阅读当然.威望项目投资.
经营看到一样.支持准备专业时间.
包括不同欢迎类别不能但是经营.部分可能因此都是使用现在大学.
规定用户这是客户地方计划这种.
注意详细国际推荐事情只有发表.市场表示有关这些以上.
服务质量北京非常.工作男人如果.欢迎时间成为业务也是规定.', 'pending', 10, '2026-05-07 04:59:28');
INSERT INTO incidents (incident_id, incident_name, disaster_type, incident_level, occur_time, location, description, status, reporter_id, report_time) VALUES (50, '普洱市地震灾害390', 'earthquake', 'II', '2026-01-12 08:55:12', '普洱市县罗路X座', '网上数据出来欢迎信息这个各种直接.工具设计出来一切出来.一个具有过程.
成功根据这里文件.进入增加世界法律所以当前设备.
成功可以参加为了文章那么.一般如何不断最大.
下载管理知道特别文化.阅读应该时间大家查看是一都是.
语言商品广告支持今年全部会员.大小文章增加单位.
程序教育全国程序控制知道.学习帮助质量单位.精华全国注意得到.', 'processing', 10, '2026-05-28 09:17:03');
