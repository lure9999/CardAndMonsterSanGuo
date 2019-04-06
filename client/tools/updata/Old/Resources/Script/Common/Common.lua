TouchEventType = 
{
    began = 0,
    moved = 1,
    ended = 2,
    canceled = 3,
}

HeroType={
	good=0,
	famous=1,
	god=2,
}

CheckBoxEventType = 
{
    selected = 0,
    unselected = 1,
}

CHANGE_FOMATION_TIME = 0.5						-- 换阵过程中移动动作的时间


layerStart_Tag = 1
layerLogin_Tag = 2
layerMainRoot_Tag = 3
layerHeroTalk_Tag = 4


FONT1 = "STHeitiSC-Medium"
FONT2 = "Image/Main/font/迷你简胖娃"
FONT3 = "Image/Main/font/simhei.ttf"


COLOR_White = ccc3(0xff,0xff,0xff)
COLOR_Black = ccc3(0x00,0x00,0x00)
COLOR_Green = ccc3(0x00,0xe6,0x24)
COLOR_Green_Deep = ccc3(0x17,0x61,0x1f)
COLOR_Blue = ccc3(0x00,0xae,0xff)
COLOR_Purple = ccc3(0xff,0x19,0xc6)
COLOR_Gold = ccc3(0xfc,0xf9,0x00)
COLOR_Brown = ccc3(0x5a,0x38,0x03)
COLOR_Gray = ccc3(0x6e,0x6e,0x6e)
COLOR_Red = ccc3(0xff,0x00,0x00)

layerCurRunning = nil							-- 当前在中间显示的层
CHANGE_FOMATION_TIME = 0.2						-- 换阵过程中移动动作的时间

SCROLL_Dis = 2000

-- bag
STORECOUNT							= 12 -- 十二种装备。以后更改表需要更改此数目。

-- network
NETCMD_GETSERVERLIST		= "c=user&m=login&"
NETCMD_LOGIN 						= "c=user&m=login&"   												-- 用户登录 
NETCMD_REGISIT					= "c=user&m=register&"												-- 用户注册 
NETCMD_GUEST						= "c=user&m=guest&"													-- 注册试玩 
NETCMD_GUESTREGISIT			= "c=user&m=guestlogin&"											-- 试玩登录 
NETCMD_BINDING					= "c=register&m=binding&"											-- 试玩登录 
NETCMD_GETTOKEN				= "c=login&m=user&"													-- 获取唯一标示
NETCMD_GETHEROLIST			= "c=general&m=index&"												-- 获取武将列表 
NETCMD_GETMINE					= "c=member&m=index&"											-- 获取用户信息 
NETCMD_GETSELLHEROLIST		= "c=general&m=get_sell_general_list&"						-- 获取出售武将列表
NETCMD_SELLHEROLIST			= "c=general&m=sell_general&"									-- 出售武将
NETCMD_HEROUPGRADE			= "c=general&m=add_exp&"											-- 武将升级
NETCMD_CHANGEMATRIX			= "c=matrix&m=swap&"												-- 布阵
NETCMD_RESETMATRIX			=	"c=general&m=reset_matrix&"									-- 全部下阵除武将
NETCMD_ADDHEROLIST			=	"c=general&m=add_general&"									-- 增加武将
NETCMD_ADDGOLD				=	"c=member&m=add_gold&"									-- 增加武将
NETCMD_ADDEXP					=	"c=member&m=add_exp&"										-- 增加经验
NETCMD_GETEQLIST				= "c=equipment&m=get_equipment_list&"						--获取装备列表
NETCMD_FRAGMENT				= "c=equipment&m=get_fragment_list&"						-- 获取装备碎片列表
NETCMD_QUESTHEROEQ			= "c=equipment&m=get_general_equipment&"				-- 获取武将装备信息
NETCMD_GETEQGRADEPRICE 	= "c=equipment&m=get_intensify_price&"						-- 获取装备强化价格信息
NETCMD_GRADEEQ					= "c=equipment&m=intensify&"									-- 强化装备
NETCMD_GRADEEQAUTO			= "c=equipment&m=auto_intensify&"							-- 装备强化——自动
NETCMD_USEEQ						= "c=equipment&m=equip&"										-- 使用装备
NETCMD_UNUSEEQ					= "c=equipment&m=unequip&"									-- 卸下装备
NETCMD_AUTOUSEEQ				= "c=equipment&m=one_key_equip&"							-- 一键装备装备
NETCMD_SELLEQLIST				= "c=equipment&m=equipment_sell_list&"						-- 装备出售列表
NETCMD_SELLEQ						= "c=equipment&m=equipment_sell&"						-- 出售装备
NETCMD_COMBINEQ					= "c=equipment&m=compound&"								-- 合成装备
NETCMD_ADDEQ						= "c=equipment&m=add&t=1&"									-- 添加装备
NETCMD_ADDFRAG					= "c=equipment&m=add&t=2&"									-- 添加碎片
NETCMD_STORE						= "c=store&m=get_store_list&"									-- 商城
NETCMD_BAG							= "c=package&m=get_item_list&"									-- 背包
NETCMD_BUYSTORE					= "c=store&m=buy&"												-- 购买物品
NETCMD_USEITEM						=	"c=package&m=use_item&"									-- 使用物品
NETCMD_BUYHERO					= "c=store&m=buy&t=1&f=0&"											-- 购买武将
NETCMD_BATTLE_USER				= "c=battle&m=battle_user&touid=14&"						-- 战斗
NETCMD_HEROLVUP				= "c=general&m=lvup&"														-- 武将升级
NETCMD_HEROLVUP				= "c=member&m=reset&"														-- 初始化
NETCMD_URL 							= "http://10.248.31.157/server_uc/index.php?"     -- http连接的地址
NETCMD_URLTEST						= "http://10.248.31.157/server_game/index.php?"		-- 测试地址 
-- 失败代码表示
ERROR_LOGIN_ZERO					= "失败"
ERROR_LOGIN_NOUSER			= "用户不存在"
ERROR_LOGIN_PWD					= "密码错误"
ERROR_LOGIN_LOGIN				= "用户名或者密码为空"
ERROR_LOGIN_BLACK				= "账号被封"
ERROR_ENTER_LOGIN				= "用户名或者密码为空"
ERROR_ENTER_GET					= "获取用户登录标示信息失败"
ERROR_ENTER_ENTER				= "登录验证失败"
ERROR_ENTER_INIT					= "初始化用户信息失败"
ERROR_GETMINE						= "获取角色信息失败"
ERROR_MATRIX_LOCATE			= "位置参数错误"
ERROR_MATRIX_DATA				= "位置数据错误"
ERROR_HEROUPGRADE_INFO		= "获取武将信息失败"
ERROR_HEROUPGRADE_NO		= "主将无法升级"
ERROR_HEROUPGRADE_MORE	= "等级无法超过主将等级"
ERROR_HEROUPGRADE_TURN	= "武将需转生后才可升级"
ERROR_HEROUPGRADE_LOST	= "已上阵武将无法被吃"
ERROR_HEROUPGRADE_NOEAT	= "有武将不能被吃"
ERROR_HEROUPGRADE_ZERO	= "增加经验为0"
ERROR_HEROUPGRADE_DELETE= "扣除被吃武将失败"
ERROR_HEROUPGRADE_ADD		= "添加经验失败"


visibleSize = CCDirector:sharedDirector():getVisibleSize()
origin = CCDirector:sharedDirector():getVisibleOrigin()
