
require "Script/Common/CommonCmd"
require "Script/Common/CommonData"
require "Script/Common/CommonInterface"
require "Script/Common/ObserverManager"
require "Script/Main/Loading/NetWorkLoadingLayer"
require "Script/Common/TipLayer"
require "Script/Common/TipCommonLayer"
require "Script/Common/UnitTime"
require "Script/Common/UIInterface"
require "Script/Common/LabelLayer"
require "Script/Common/GuideRegisterManager"

--[[require "Script/Login/LoginLogic"

require "Script/serverDB/activity_copy"
require "Script/serverDB/attribute"
require "Script/serverDB/attributincremental"
require "Script/serverDB/coin"
require "Script/serverDB/consume"
require "Script/serverDB/consumeincremental"
require "Script/serverDB/equipt"
require "Script/serverDB/event_limit"
require "Script/serverDB/expand"
require "Script/serverDB/fuben"
require "Script/serverDB/general"
require "Script/serverDB/globedefine"
require "Script/serverDB/goods"
require "Script/serverDB/guidedata"
require "Script/serverDB/item"
require "Script/serverDB/itemdrop"
require "Script/serverDB/itemdropgroup"
require "Script/serverDB/itemrule"
require "Script/serverDB/monst"
require "Script/serverDB/nor_copy"
require "Script/serverDB/nor_copydata"
require "Script/serverDB/point"
require "Script/serverDB/pointreward"
require "Script/serverDB/qianghua"
require "Script/serverDB/resimg"
require "Script/serverDB/scence"
require "Script/serverDB/scenerule"
require "Script/serverDB/server_equipDB"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/server_itemDB"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/server_shopDB"
require "Script/serverDB/server_fubenDB"
require "Script/serverDB/shop"
require "Script/serverDB/shopitem"
require "Script/serverDB/skill"
require "Script/serverDB/suit"
require "Script/serverDB/talent"
require "Script/serverDB/xilian"
require "Script/serverDB/xilianattribute"
require "Script/serverDB/errortip"
require "Script/serverDB/yuanfen"
require "Script/serverDB/txt"
require "Script/serverDB/pub"
require "Script/serverDB/Legioicon"
require "Script/DB/AnimationData"
require "Script/Fight/UiFightManage"
require "Script/Common/UIEffectManager"]]--

TouchEventType = 
{
    began = 0,
    moved = 1,
    ended = 2,
    canceled = 3,
}

PageViewEventType = {
   turning = 0,  
}

PVTouchDir = {
	turnLeft = 	0,
	turnRight = 1,
}

--add celina test
TextFieldEventType = 
{
    attach_with_me = 0 ,
	detach_with_me = 1 ,
	insert_text = 2 ,
	delete_backward = 3,
}

--add celina 炼化类型
ENUM_REFINING_TYPE = {
	ENUM_REFINING_TYPE_ITEM = 0,
	ENUM_REFINING_TYPE_EQUIP = 1,
	ENUM_REFINING_TYPE_WJ    = 2
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

ICONTYPE = {
	GENERAL_ICON 	= 0,
	ITEM_ICON		= 1,
	EQUIP_ICON 		= 2,
	COIN_ICON       = 3,
	PLAYER_ICON     = 4,
	DISPLAY_ICON	= 5,
	GENERAL_COLOR_ICON = 6,--只有头像和品质框
	HEAD_ICON = 7,--所有的头像框（无品质）
	ITEM_COLOR_ICON = 8,--只有品质的物品框
	SCIENCEUP_ICON  = 9,
}

--add by sxin sharder效果定义
SharderKey =
{
	E_SharderKey_Normal		=0,--//正常
	E_SharderKey_Banish 	=1,--//消除
	E_SharderKey_Blur		=2,--//模糊
	E_SharderKey_Frozen		=3,--//冻
	E_SharderKey_GrayScaling=4,--//灰色半透
	E_SharderKey_Ice		=5,--//冰
	E_SharderKey_Invisible	=6,--//看不见
	E_SharderKey_Poison		=7,--//毒药
	E_SharderKey_SpriteGray	=8,--//灰度
	E_SharderKey_Stone		=9,--//石化
	E_SharderKey_RounIcon	=10,--//圆形
	E_SharderKey_RounIcon_Gray	=11,--//灰度圆形
	E_SharderKey_Color_R		=12,--//发怒
}

-- 副本类型
DungeonsType = {
	Normal 		= 1,
	Elite 		= 2,
	Activity 	= 3,
	PK 			= 4,
	ClimbingTower = 5,
}

-- 关卡类型
PointType= {
	Small 	= 1,
	Big 	= 2,
}

-- 武将类型
GeneralType = 
{
	Main 	= 10, -- 主将
	General = 4, -- 武将
	HuFa 	= 5, -- 护法
}

-- 武将位置
GeneralPos = 
{
	All		= 0, -- 全部
	Front 	= 1, -- 前排
	Middle	= 2, -- 中排
	Behind	= 3, -- 后排
}

TipType =
{
	Item 	= 1,
	Monster = 2
}

MonsterType =
{
	Solider 	= 1,
	Genereal 	= 2,
}
TipPosType =
{
	LeftTop 	= 1,
	RightTop	= 2,
	RightBottom = 3,
	LeftBottom 	= 4,
}
-- 消耗类型
ConsumeType = 
{
	Item		= 0, --道具
	Sliver		= 1, --银币
	Gold		= 2, --金币
	Tili		= 3, --鸡腿
	Naili		= 4, --令旗
	MainGenExp	= 5, --主将经验
	GenExp 		= 6, --武将经验
	HuFaExp		= 7, --护法经验
	BaoWuExp	= 8, --宝物经验
	JunGongCoin	= 9, --军工币
	FamilyCoin	=10, --家族币
	FriendCoin	=11, --好友币
	JunGongPre	=12, --军功声望
	FamilyPre	=13, --家族声望
	FriendPre	=14, --好友声望
	General 	=15, --武将
	Equip 		=16, --装备
	XingHun		=17, --星魂
}

--VIP开启功能索引
enumVIPFunction = {
	eVipFunction_0 = 0,
	eVipFunction_1 = 1, --开启推图扫荡10次
	eVipFunction_2 = 2, --开启自动爬塔功能
	eVipFunction_3 = 3, --开启高级捐献功能
	eVipFunction_4 = 4, --开启高级食堂功能
	eVipFunction_5 = 5, --解锁佣兵第二个格子
	eVipFunction_6 = 6, --解锁佣兵第三个格子
	eVipFunction_7 = 7, --开启装备自动强化功能
	eVipFunction_8 = 8, --开启中级洗练功能
	eVipFunction_9 = 9, --开启高级洗练功能
	eVipFunction_10 = 10,--开启夺宝10次功能
	eVipFunction_11 = 11, --推图关卡次数购买
	eVipFunction_12 = 12, --精英战役挑战次数购买
	eVipFunction_13 = 13, --活动战役挑战次数购买
	eVipFunction_14 = 14, --爬塔重置次数购买
	eVipFunction_15 = 15, --比武次数购买
	eVipFunction_16 = 16, --军团捐献次数购买
	eVipFunction_17 = 17, --食堂领取次数购买
	eVipFunction_18 = 18, --军团神树领取经验倍数
	eVipFunction_19 = 19, --清除比武CD
	eVipFunction_20 = 20, --购买军团任务次数
	eVipFunction_21 = 21, --装备【装备洗练】
	eVipFunction_22 = 22, --装备【宝物精炼】
	eVipFunction_23 = 23, --武将【武将丹药】
	eVipFunction_24 = 24, --武将【武将天命】
	eVipFunction_25 = 25, --军团【创建/加入】
	eVipFunction_26 = 26, --国战【进入国战】
	eVipFunction_27 = 27, --玩法【比武】
	eVipFunction_28 = 28, --玩法【夺宝】
	eVipFunction_29 = 29, --玩法【爬塔】
}

-- 消耗类型
ConsumeTypeName =
{
	"道具",
	"银币",
	"元宝",
	"鸡腿",
	"令旗",
	"主将经验",
	"武将经验",
	"护法经验",
	"宝物经验",
	"军工币",
	"家族币",
	"好友币",
	"军功声望",
	"家族声望",
	"好友声望",
	"武将",
	"装备",
	"星魂",
}

General_Ani_Def_Key =
{
	"Ani_run",
	"Ani_cheers",
	"Ani_attack",
	"Ani_skill",
	"Ani_manual_skill",
}

RoleJobType = 
{
	Warrior = 1, --战士
	Mage 	= 2, --法师
	Archer 	= 3, --弓手
}

GeneralOptType = 
{
	Update 		= 1,
	DanYao 		= 2,
	Fate 		= 3,
	Relation	= 4,
	Attribute 	= 5,
}

CoinType =
				{
					Sliver 	= 1,
					Gold	= 2,
					PVP		= 3,
					Family	= 4,
					BiWuMoney = 9,
					CorpsPri = 10,
					HunJue  = 217,
				}

InfoBarType =
			{
				Main 	= 0,
				XingHun	= 1
			}

PubType =
		{
			Sliver 	= 0,
			Gold 	= 1,
		}
function printTab(tab)
	
	if tab == nil then print("nil") return end
	local strTmp = ""
	local function PrintT(tab)
		for i,v in pairs(tab) do
			if type(v) == "table" then				
				strTmp = strTmp .."\n" ..i .."{"
				PrintT(v)
				strTmp = strTmp .."}\n"							
			else
				if type(v) == "boolean" then
					if v == true then
						strTmp = strTmp ..i ..":" .."true" .."   "
					else
						strTmp = strTmp ..i ..":" .."false" .."   "
					end
				elseif type(v) == "userdata" then
					strTmp = strTmp ..i ..":" .."userdata" .."   "
				elseif type(v) == "function" then
					strTmp = strTmp ..i ..":" .."function" .."   "
				else
					strTmp = strTmp ..i ..":" ..v .."   "
				end
			end
		end	
	end
	PrintT(tab)
	 print(strTmp)	
	strTmp = ""	
	
end

function copyTab(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = copyTab(v)
        end
    end
    return tab
end

local function WriteFileT(tab)
	local strTmp = ""
	for i,v in pairs(tab) do
		if type(v) == "table" then				
			strTmp = strTmp .."\n" ..'"'..i..'"' .."{"
			strTmp = strTmp .. WriteFileT(v)
			strTmp = strTmp .."}\n"							
		elseif type(v) == "boolean" then			
			strTmp = strTmp ..'"'..i..'"' ..":" ..tostring(v) ..","			
		elseif type(v) == "userdata" then
			strTmp = strTmp ..'"'..i..'"' ..":" .."userdata" ..","
		elseif type(v) == "function" then
			strTmp = strTmp ..'"'..i..'"' ..":" .."function" ..","
		else
			strTmp = strTmp ..'"'..i..'"' ..":" ..v ..","				
		end
	end	
	
	return strTmp
end
	
function Fileprint(fileName,tableData)
 	
	os.execute('mkdir Log')
	
	local f = io.open( "Log/"..fileName, "w+" )			
	f:write( WriteFileT(tableData) )
	f:close() 
	
end

function FileStrprint(fileName,str_data)
	os.execute('mkdir Log')
	local f = io.open( "Log/"..fileName, "w+" )			
	f:write( str_data )
	f:close() 
end

function table2json(t)  

	
	local function serialize(tbl)  
		local tmp = {}  
		for k, v in pairs(tbl) do  
			local k_type = type(k)  
			local v_type = type(v)  
			local key = (k_type == "string" and "\"" .. k .. "\":")  
				or (k_type == "number" and "")  
			local value = (v_type == "table" and serialize(v))  
				or (v_type == "boolean" and tostring(v))  
				or (v_type == "string" and "\"" .. v .. "\"")  
				or (v_type == "number" and v)  
			tmp[#tmp + 1] = key and value and tostring(key) .. tostring(value) or nil  
		end   
		if table.maxn(tbl) == 0 then  
			return "{" .. table.concat(tmp, ",") .. "}"  
		else 			
			return "[" .. table.concat(tmp, ",") .. "]"  
		end  
	end   
	
	assert(type(t) == "table")  
	return serialize(t)  
end  

function FileLog_json(fileName,tableData)
 	os.execute('mkdir Log')
	local f = io.open( "Log/"..fileName, "w+" )		
	f:write( table2json(tableData) )
	f:close() 
	
end



CHANGE_FOMATION_TIME = 0.5						-- 换阵过程中移动动作的时间
TAG_LABEL_BUTTON = 1               --按钮的上的文字tag

layerStart_Tag = 1
layerLogin_Tag = 2
layerMainBack = 3
layerMainRoot_Tag = 4
layerHeroTalk_Tag = 5
layerWujiangList_Tag = 6
layerWujiangInfo_Tag = 7
layerItemList_Tag = 8
layerEquipList_Tag = 9
lyaerActivityList_Tag = 10
layerMatrix_Tag = 11
layerItemInfo_Tag = 12
layerEquipProperty_Tag = 13
layerMall_Tag = 14
layerEquipStrengthen_Tag = 15
layerMatrixWuJiangList_Tag = 16
layerMatrixEquipList_Tag = 17
layerFightLevel_Tag = 18
layerGrogshop_Tag  = 19
layerChooseCard_Tag = 20
layerGetCard_Tag    = 21
lyaerFriend_Tag		= 22

layerFightData_Tag = 23
layerServerChoose_Tag  = 24
layerNLogin_Tag        = 25
layerRegisterLogin_Tag  = 26
layerCreateRole_Tag = 28
layerFirstLogin_Tag = 27
layerWujiangOperate_Tag = 29
layerWujiangUpdate_Tag  = 30
layerArenaMgr_Tag = 31
layerCompeteResultWin = 32
layerCompeteResultFail = 33
layerTreasureListTag = 34
layerDobk_Tag = 35
layerEquipMatrix = 36 --阵容选择装备
layerEquipOperateTag = 37 
layerMail_Tag = 38
layerMailContent_Tag = 39
layerSmithy_Tag	= 40
layerCompetition_Tag = 41
layerActivitySelTag = 42

layerPataTag = 44
layerRankListTag = 46
layerCorpsTag = 47
layerCorpsItemIcon = 48
layerCorpsMessHallTag = 49
layerCorpsPresentTag = 50
layerCorpsTeachTag = 51
layerMissionTag = 52
layerCorpsMercenaryTag = 53
layerCorpsSpiritTag = 54
layerCorpsShangHuiTag = 55
layerCorpsDynamicTag = 56
layerCorpsMemberTag = 57
layerCorpsPosition = 58
layerCorpsJieSan_Tag = 59
layerCorpsBless_Tag = 60
layerCopMerBless_Tag = 61
layerCopSpiritGod_Tag = 62
layerCopSpitBless_Tag = 63
layerLevel_Tag = 64
layerAlterPosition_Tag = 65
layerMerInfo_Tag = 66
layerCopTree_tag = 67
layerCorpsShop_Tag = 68
layerCountryWarLevelUp_tag = 69
layerMissionNormal_tag = 70
layerGetGoodsTag = 510                        -- 公共奖励界面需要高于其他界面
layerCorpsMercenaryTag = 72
layerMercenaryRefresh_tag = 73
layerSignInLayer_Tag = 74
layerSignInData_tag = 75
layerCountryWarTag = 99 			            --国战层需要经常更换父节点，Z轴要高一些
layerSpeedUp_tag = 76
layerVIPCharge_tag = 77
layerPrison_Tag = 78
layerPropUse_Tag = 79
layerUserSettingTag  = 501
layerChatFaceTag = 502
layerCorpsSettingTag = 80
layerPrisonTag = 81
layerPrisonCatchTag = 82
layerSpiritTag = 83
layerSpiritBlessTag = 84
layerSpiritGoldTag = 120

layerGetReturnTag = 700 --获得强化等返还所得

layerShopTag = 504
layerMainCur_Tag = 400
layerMainBtn_Tag = 500							-- 这个按扭要常住的。所以要高些。

layerAtkWar_Tag = 601
layerAtkWarAvatar_Tag = 602
layerTopTag = 603
layerHeroUpgrade_tag = 1200                      -- 主将升级触发界面要高于其他界面
layerTip_Tag = 9999								-- 这个要高于所有界面
layerLoading_Tag = 1000							-- 这个要高于所有界面

layerFightUI_Tag = 100

layerAuotoUpdate_Tag = 998
layerCoinBar_Tag = 997

layerTipsMessage_Tag = 3000
layerGuideTotal_Tag = 2001
layerGuide_Tag  = 2000           --引导管理界面


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
--品质的颜色
COLOR_PINZHI_WHITE =  ccc3(255,255,255)
COLOR_PINZHI_GREEN = ccc3(29,255,50)
COLOR_PINZHI_BLUE = ccc3(29,67,255)
COLOR_PINZHI_PURPLE = ccc3(255,155,228)
COLOR_PINZHI_ORANGE = ccc3(255,231,70)
--套装的颜色
COLOR_SUIT_NAME = ccc3(255,156,28)

layerCurRunning = nil							-- 当前在中间显示的层
CHANGE_FOMATION_TIME = 0.2						-- 换阵过程中移动动作的时间

SCROLL_Dis = 2000

LOCALTEST					= 0
NETWORKENABLE				= 1
-- network
SERVERPORT = 12175
--SERVERHOST = "127.0.0.1"
SERVERHOST = "192.168.0.110"

visibleSize = CCDirector:sharedDirector():getVisibleSize()
origin = CCDirector:sharedDirector():getVisibleOrigin()

--add by sxin 增加统一场景析构方法

function Scence_OnExit()	
    
end

function Scence_OnBegin()	
	CCDirector:sharedDirector():purgeCachedData()	
end

local m_EventObj = nil

--add by sxin 增加后台切换响应--家溯做处理
function Lua_EnterBackground()	
    print("Lua_EnterBackground")
    print(CommonData.g_IsUnlockCountryWar)
    if CommonData.g_IsUnlockCountryWar == true then
		require "Script/Main/CountryWar/CountryWarEventManager"
		CountryWarEventManager.CountryWarEnterBackground()
	end
end

function Lua_EnterForeground(fDeltaTime)	
	if CommonData.g_IsUnlockCountryWar == true then
   		print("Lua_EnterForeground fDeltaTime = " .. tonumber(fDeltaTime))
		require "Script/Main/CountryWar/CountryWarEventManager"
   		CountryWarEventManager.CountryWarEnterForeground(tonumber(fDeltaTime))
   		--network.NetWorkEvent(Packet_CountryWarLoadFinish.CreatPacket()) 	--重新链接国战
   	end
	if CommonData.g_IsPaTaIng == true then
		require "Script/Main/Pata/PataLayer"
		PataLayer.GetDeltaTIme(fDeltaTime)
	end
end
------------------------add celina---------------------------------------------------
ENUM_STRING_WORD = {
	ENUM_STRING_EQUIPED  = "已装备",
	ENUM_STRING_EQUIP    = "装备",
    ENUM_STRING_TREASURE = "宝物",
	ENUM_STRING_LINGBAO  = "灵宝",
	ENUM_STRING_QH       = "强化",
	ENUM_STRING_XL       = "洗炼",
	ENUM_STRING_JL       = "精炼",
	ENUM_STRING_XH       = "消耗品",
	ENUM_STRING_SP       = "碎片",
	ENUM_STRING_JH       = "将魂"
}
ENUM_STRING = {
	"已装备",
	"装备",
    "宝物",
	"灵宝",
	"强化",
	"洗炼",
	"精炼",
	"消耗品",
	"碎片",
	"将魂",
	"道具",
	"装备"
}
ENUM_TYPE_BOX  = {
	ENUM_TYPE_BOX_EQUIPED  = 1,
	ENUM_TYPE_BOX_EQUIP    = 2,
    ENUM_TYPE_BOX_TREASURE = 3,
	ENUM_TYPE_BOX_LINGBAO  = 4,
	ENUM_TYPE_BOX_QH       = 5,
	ENUM_TYPE_BOX_XL       = 6,
	ENUM_TYPE_BOX_JL       = 7,
	ENUM_TYPE_BOX_XH       = 8,
	ENUM_TYPE_BOX_SP       = 9,
	ENUM_TYPE_BOX_JH       = 10,
}
ENUM_STRING_ITEM = {
	ENUM_STRING_ITEM_ITEM  = "道具",
	ENUM_STRING_ITEM_EQUIP = "装备",
}
ENUM_TYPE_BOX_ITEM = {
	ENUM_BOX_ITEM  = 11,
	ENUM_BOX_EQUIP = 12,
}

City_Area = {
	NoEff_Top			= 1,
	NoEff_Bottom		= 2,
	NoEff_Left			= 3,
	NoEff_Right			= 4,
	NoEff_Left_Bottom   = 5,
	NoEff_Left_Top 		= 6,
	NoEff_Right_Bottom  = 7,
	NoEff_Right_Top		= 8,
	Eff_Normal			= 9,
}

local function addObject(pObject,paddObject)
	if pObject:getChildByTag(TAG_LABEL_BUTTON)~=nil then
		pObject:getChildByTag(TAG_LABEL_BUTTON):setVisible(false)
		pObject:getChildByTag(TAG_LABEL_BUTTON):removeFromParentAndCleanup(true)
	end
	
	pObject:addChild(paddObject,TAG_LABEL_BUTTON,TAG_LABEL_BUTTON)
end
--传入lable的名字，要加的button对象
local function addLableOnObject(str_name,button,f_size,colorOne,colorTwo,nSize,strFontName,pPos)
	if nSize == nil then
		nSize = 2
	end
	local fontName = nil
	if strFontName~=nil then
		fontName = strFontName
	else
		fontName = CommonData.g_FONT1
	end
	if str_name ~=nil then
		local label_game = nil
		if pPos==nil then
			pPos = ccp(0,4)
		end
		if colorOne~=nil then
			label_game = LabelLayer.createStrokeLabel(f_size,fontName,str_name,pPos,colorOne,colorTwo,true,ccp(0,-nSize),nSize)
		else
			label_game = LabelLayer.createStrokeLabel(f_size,fontName,str_name,pPos,COLOR_Black,COLOR_White,true,ccp(0,-nSize),nSize)
		end
		addObject(button,label_game)
		
	end
end

--btn_object ：button对象
--str_Name ：button上的名字
--fCallBack：回调函数
--nSize 描边像素 默认为2像素
function CreateBtnCallBack( btn_object,str_Name,fSize,fCallBack,colorOne,colorTwo,nGrid,nSize,strFontName,pos )
	local function _Btn_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			sender:setScale(1.0)
			if fCallBack~=nil then
				--print(fCallBack)
				--Pause()
				fCallBack(nGrid)
			end
		elseif  eventType == TouchEventType.began then
		
			sender:setScale(0.9)
		elseif  eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	
	end
	if str_Name ~=nil then
		addLableOnObject(str_Name,btn_object,fSize,colorOne,colorTwo,nSize,strFontName,pos)
	end
	btn_object:addTouchEventListener(_Btn_CallBack)
end
---checkbox 相关
function GetBoxTypeByName(str_name)
	if str_name == ENUM_STRING_WORD.ENUM_STRING_EQUIPED then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIPED
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_EQUIP then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_TREASURE then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_LINGBAO then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_QH  then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_QH
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_XL  then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_XL
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_JL  then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_JL
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_XH  then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_SP  then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP
	elseif str_name == ENUM_STRING_WORD.ENUM_STRING_JH  then
		return ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH
	end
end

function GetBoxItemType(str_name)
	if str_name == "装备1" then
		return ENUM_TYPE_BOX_ITEM.ENUM_BOX_EQUIP
	end
	return ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM
end	
function GetNameByBoxType(nboxType)
	return ENUM_STRING[nboxType]
end
local function AddLableOnBox(pBox,strName)
	--print(strName)
	--Pause()
	local pos = ccp(0,0)
	
	if string.len(strName)>6 then
		pos = ccp(15,2)
	else
		pos = ccp(10,2)
	end
	local lable_add = nil 
	local width_box = pBox:getContentSize().width
	local height_box = pBox:getContentSize().height
	if pBox:getSelectedState() == true then
		lable_add = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,strName,pos,ccc3(41,22,10),COLOR_White,true,ccp(0,-2),2)
	elseif pBox:getSelectedState() == false then
		lable_add = Label:create()
		lable_add:setFontName(CommonData.g_FONT1)
		lable_add:setFontSize(25)
		lable_add:setColor(ccc3(199,136,86))
		lable_add:setPosition(CCPoint(10,2))
		lable_add:setText(strName)
	end
	addObject(pBox,lable_add)
end
local function getLable(box_o)
	local object = box_o:getChildByTag(TAG_LABEL_BUTTON)
	if object~=nil then
		
		return LabelLayer.getText(object)
	end
	return ""
end
function UpdateObject(old_box,new_box,str_name)
	--更新文字
	
	AddLableOnBox(old_box,getLable(old_box))
	AddLableOnBox(new_box,str_name)
	
end

local p_BoxObject = nil 


--创建box,传入box的对象，上面的文字，回调函数
function CreateCheckBoxCallBack( box_Object,str_Name,fCallBack,tableSelf )
	local function _Box_CallBack(sender,eventType)
		if eventType == CheckBoxEventType.selected then 
			--[[if sender:getTag()~= p_BoxObject:getTag() then
				p_BoxObject:setSelectedState(false)
				UpdateObject(p_BoxObject,sender,str_Name)
				p_BoxObject = sender
				
			end]]--
			sender:setSelectedState(true)
			if fCallBack~=nil then
				
				if str_Name == "装备1" or str_Name == "道具" then
					fCallBack(GetBoxItemType(sender:getName()),sender,tableSelf)
				else	
					fCallBack(GetBoxTypeByName(sender:getName()),sender,tableSelf)
				end
				
			end
		elseif eventType == CheckBoxEventType.unselected then
			
			if sender:getSelectedState()== false then
				sender:setSelectedState(true)
			end
		end
	end
	--print(str_Name)
	
	
	if str_Name == "装备1" then
		AddLableOnBox(box_Object,"装备")
	else
		AddLableOnBox(box_Object,str_Name)
	end
	box_Object:setName(str_Name)
	box_Object:addEventListenerCheckBox(_Box_CallBack)
end

------list item的回调----
--bAction 有无动作
--基础加值
TAG_GRID_ADD  = 100 
function CreateItemCallBack(pItem,bAction,callBack,tableSelf)
	local function  _Item_CallBack(sender,eventType)
		if eventType==TouchEventType.ended then
			if bAction == true then
				sender:setScale(1.0)
			end
			if callBack~=nil then
				
				callBack(sender:getTag()-TAG_GRID_ADD,sender,tableSelf)
			end
		elseif  eventType == TouchEventType.began then
			if bAction == true then
				sender:setScale(0.9)
			end
		elseif  eventType == TouchEventType.canceled then
			if bAction == true then
				sender:setScale(1.0)
			end
		end
	end
	pItem:addTouchEventListener(_Item_CallBack)
end
function AddLabelImg(strokeLable,tag,pObject)
	if pObject==nil then
		print("要添加的父类对象为nil")
		return 
	end
	if pObject:getChildByTag(tag)~=nil then
		pObject:getChildByTag(tag):setVisible(false)
		pObject:getChildByTag(tag):removeFromParentAndCleanup(true)
	end
	pObject:addChild(strokeLable,tag,tag)
end
--方法获得功防的icon 的path
EQUIP_TYPE_ENUM = 
{
	ARRTRIBUTE_TYPE_HP		      = 0,	--生命
	ARRTRIBUTE_TYPE_ATTACK	      = 1,	-- 攻击
	ARRTRIBUTE_TYPE_PHYDEF	      = 2,	-- 物防
	ARRTRIBUTE_TYPE_MAGICDEF	  = 3,	-- 法防
	ARRTRIBUTE_TYPE_DODGE	      = 4,	-- 躲闪 修改为闪避
	ARRTRIBUTE_TYPE_HIT			  = 5,	-- 暴击 
	ARRTRIBUTE_TYPE_SHIPO		  = 6,	-- 识破
	ARRTRIBUTE_TYPE_ENGINE		  = 7,	-- 初始能量 修改为能量初值
	ARRTRIBUTE_TYPE_HPRECOVER	  = 8,	-- 生命恢复 
	ARRTRIBUTE_TYPE_ENGINERECOVER = 9,	-- 能量恢复
	ARRTRIBUTE_TYPE_WULI		  = 10,	-- 武力
	ARRTRIBUTE_TYPE_WISDOM		  = 11,	-- 智力
	ARRTRIBUTE_TYPE_STRENGTH	  = 12,	-- 统御
	ARRTRIBUTE_TYPE_ANGER		  = 13,	-- 自动技能初始值
	ARRTRIBUTE_TYPE_ADD_GONGJI    = 14,	--  绝对攻击 修改为穿透
	ARRTRIBUTE_TYPE_ADD_FANGYU	  = 15,	--  绝对减伤 修改为免伤
}
function GetIconPath(l_type)
	local str_path = nil
	if tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_HP then
		str_path = "Image/imgres/common/hp.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_ATTACK then
		str_path = "Image/imgres/common/att.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_PHYDEF then
		str_path = "Image/imgres/common/wf.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_MAGICDEF then
		str_path = "Image/imgres/common/ff.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_DODGE then
		str_path = "Image/imgres/common/shan.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_HIT then
		str_path = "Image/imgres/common/bao.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_SHIPO then
		str_path = "Image/imgres/common/po.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_ADD_GONGJI then
		str_path = "Image/imgres/common/att.png"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_ADD_FANGYU then
		str_path = "Image/imgres/common/att.png"
	end
	return str_path
end
function GetIconName(l_type)
	local str_name = nil
	if tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_HP then
		str_name = "生命"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_ATTACK then
		str_name = "攻击"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_PHYDEF then
		str_name = "物防"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_MAGICDEF then
		str_name = "法防"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_DODGE then
		str_name = "闪避"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_HIT then
		str_name = "暴击"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_SHIPO then
		str_name = "识破"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_ADD_GONGJI then
		str_name = "穿透"
	elseif tonumber(l_type) == EQUIP_TYPE_ENUM.ARRTRIBUTE_TYPE_ADD_FANGYU then
		str_name = "免伤"
	end
	return str_name
end
--celina 添加VIP图标和VIP信息
function AddVIPImage(pParent,nVipLv,pos)
	local img_vip_flag = ImageView:create()
	img_vip_flag:loadTexture("Image/imgres/dungeon/vip_bg.png")
	img_vip_flag:setPosition(pos)
	AddLabelImg(img_vip_flag,100,pParent)
	
	local lable_vip = Label:create()
	lable_vip:setFontName(CommonData.g_FONT3)
	lable_vip:setFontSize(18)
	lable_vip:setPosition(ccp(-5,11))
	lable_vip:setRotation(-45)
	lable_vip:setText("VIP"..nVipLv)
	AddLabelImg(lable_vip,1,img_vip_flag)
end

--1【1=消耗品】2【2=碎片】3【3=将魂】控制道具的分属标签页3【4=武将】3【5=护法】2【6=装备】2【7=套装】2【8=宝物】
E_BAGITEM_TYPE =
{
	E_BAGITEM_TYPE_NONE			   = 0,		-- 无效果0
	E_BAGITEM_TYPE_DRUG			   = 1,		-- 消耗品  --药物 消耗品1 DRUG_TYPE_DEFINE 【1=主将经验】【2=武将经验】【3=宝物经验】【4=体力】【5=耐力】【6=银币】【7=金币】
	E_BAGITEM_TYPE_EQUIPFRAGMENT   = 2,		-- 碎片2 
	E_BAGITEM_TYPE_GENERALFRAGMENT = 3,		-- 将魂3
	E_BAGITEM_TYPE_GENERAL         =4,		-- 武将4 属于将魂
	E_BAGITEM_TYPE_DANWAN		 = 5,		-- 护法5 属于将魂
	E_BAGITEM_TYPE_EQUIP		 = 6,		-- 装备6 属于碎片
	E_BAGITEM_TYPE_SUIT   		 = 7,		-- 套装7 属于碎片
	E_BAGITEM_TYPE_TREASURE		 = 8,		-- 宝物 属于碎片
	E_BAGITEM_TYPE_LINGBAO       = 9,       --灵宝
}
E_ITEM_TYPE ={
	E_ITEM_TYPE_XIAOHAO = 1,
	E_ITEM_TYPE_SUIPIAN = 2 ,
	E_ITEM_TYPE_JIANGHUN = 3
}
E_LAYER_TYPE = {
	E_LAYER_TYPE_EQUIP = 0,
	E_LAYER_TYPE_ZHENRONG = 1,
	E_LAYER_TYPE_ITEM   = 2,
}
--装备的操作界面
E_LAYER_OPERATER = {
	E_LAYER_OPERATER_EQUIP    = 1,
	E_LAYER_OPERATER_TREASURE = 2 ,
	E_LAYER_OPERATER_LINGBAO  = 3
}
--装备的操作
E_OPERATER = {
	E_OPERATER_STRENGTHEN = 1,
	E_OPERATER_XILIAN     = 2,--代表洗炼或者精炼
}
--装备列表几种情况
--现在是什么界面类型
ENUM_EQUIP_LAYER_OPRATER_TYPE = {
	ENUM_EQUIP_LAYER_OPRATER_TYPE_LIST = 1,--装备列表界面
	ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED = 2,--宝物强化选择界面
	ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP     = 3,--阵容选择界面
}
--铁匠铺页面
E_SMITHY_TYPE = {
	E_SMITHY_EQUIPREBORN	= 1,		--装备重生	
	E_SMITHY_WUJIANGINHERIT = 2,		--武将继承
	E_SMITHY_EQUIPREFINING  = 3,		--装备炼化
	E_SMITHY_SOULREFINING   = 4,		--将魂炼化
}

--------tips type
--铁匠铺页面
E_CHAT_TYPE = {
	E_CHAT_WORLD	 = 1,		--世界聊天	
	E_CHAT_GUILD	 = 2,		--幫派聊天
	E_CHAT_TEAM 	 = 3,		--队伍聊天
	E_CHAT_PRIVATE   = 4,		--私聊
}

E_Corps_Type = {
	E_Corps_Add      = 1,
	E_Corps_Find     = 2,
	E_Corps_Create   = 3,
	E_ICON_1        = 4,
	E_ICON_2        = 5,
	E_ICON_3        = 6,
	E_ICON_4        = 7,
	E_ICON_5        = 8,
}

RANKING_LIST_TYPE = {
	RANKING_LIST_ATHLETICS				= 0,		-- 比武
	RANKING_LIST_FACTION				= 1,		-- 军团繁荣度
	RANKING_LIST_FIGHT					= 2,		-- 战斗力
	RANKING_LIST_LEVEL					= 3,		-- 等级
	RANKING_LIST_CORPS_POWER			= 4,		-- 军团总战力
	RANKING_LIST_COPY					= 5,		-- 副本
	RANKING_LIST_TOWER					= 6,		-- 爬塔
}

MISSION_TYPE = {
	MISSION_COUNTRY 					= 1,
	MISSION_ARMY	 					= 2,
	MISSION_SHILIAN 					= 3,
	MISSION_LEVELUP 					= 4,
	MISSION_RANDOM	 					= 5,
	MISSION_HOPE	 					= 6,
}

--军团国家任务类型
E_WORLD_MISSION_TASK_TYPE = {
	E_WORLD_TASK_THREE_KINGDOMS 		= 0,			-- 三国任务
	E_WORLD_TASK_TRIAL  				= 1,			-- 试练任务
	E_WORLD_TASK_TRIAL_SHU 				= 2,			-- 备用
	E_WORLD_TASK_TRIAL_WU 				= 3,			-- 备用
	E_WORLD_TASK_LV_UP_WEI 				= 4,			-- 魏国升级任务
	E_WORLD_TASK_LV_UP_SHU 				= 5,			-- 蜀国升级任务
	E_WORLD_TASK_LV_UP_WU 				= 6,			-- 吴国升级任务
	E_WORLD_TASK_PLAYER_WEI 			= 7,			-- 魏国个人任务
	E_WORLD_TASK_PLAYER_SHU 			= 8,			-- 蜀国个人任务
	E_WORLD_TASK_PLAYER_WU 				= 9,			-- 吴国个人任务
	E_WORLD_TASK_CORPS_WEI 				= 10,			-- 魏国军团
	E_WORLD_TASK_CORPS_SHU 				= 11,			-- 蜀国军团
	E_WORLD_TASK_CORPS_WU 				= 12,			-- 吴国军团
}

TIPS_TYPE = {
	TIPS_TYPE_NONE     = 0,
	TIPS_TYPE_GERNERAL = 1,
	TIPS_TYPE_EQUIP    = 2,
	TIPS_TYPE_ITEM     = 3,
	TIPS_TYPE_PLAYER   = 4,
	TIPS_TYPE_MAIL     = 5,
	TIPS_TYPE_CHAT     = 6,
	TIPS_TYPE_PATA     = 7,
}

--夺宝的类型 
DOBK_TYPE = {
	DOBK_TYPE_SW = 0,--神武抢夺
	DOBK_TYPE_BW = 1,--宝物抢夺
}
--夺城战场景----celina---------------------------------------------------
CITY_WAR_WIDTH = 1710
CITY_WAR_HEIGHT = 640
-------end-------------------------------------------------
-------通知更新系统----celina---------------------------------------------------
OBSERVER_REGISTER_TYPE = {
	OBSERVER_REGISTER_MAIN = 1,
	OBSERVER_REGISTER_EQUIP_OPERATER = 2,
	OBSERVER_REGISTER_LEVEL_UP = 3,
	OBSERVER_REGISTER_MATRIX = 4,
	OBSERVER_REGISTER_COMPETIONLAYER = 5,
	OBSERVER_REGISTER_ATKSCENE = 6,--攻城战界面的更新
	OBSERVER_REGISTER_DUNGEON = 7,
	OBSERVER_REGISTER_ATKSCENE_ARMYINFO = 8,--攻城战界面的战队信息更新
	OBSERVER_REGISTER_MERCENARY = 9,--佣兵到期通知
	OBSERVER_REGISTER_COINBAR   = 10,--货币条
}
-----end-------------------------------------------------
----celina-----
--攻城战的时间差值
CITYWAR_TIME = 2
--攻方和守方的类型
TEAM_TYPE = {
	TEAM_TYPE_ATK = 1,
	TEAM_TYPE_DEFENCE =2,
}



GUIDE_MANAGER_TYPE = {
	GUIDE_MANAGER_TYPE_ITEM = 1 ,
	GUIDE_MANAGER_TYPE_COIN = 2,
}

ENUM_ATTR_TIME = {
	ENUM_ATTR_TIME_TILI = 1 ,--还有多长时间更新体力
	ENUM_ATTR_TIME_NAILI = 1 ,--还有多长时间更新耐力
}

--触摸优先级
ENUM_TOUCH_LEVEL = {
	ENUM_TOUCH_LEVEL_LOADING = -1,
	ENUM_TOUCH_LEVEL_GUIDE = -2,
	ENUM_TOUCH_LEVEL_HEROTALK = -3,
}
----end---------
-----------------------------------end-------------------------------------------------

MAX_BAG_ITME_COUNT = 240
MAX_BAG_EQUIP_COUNT = 240
MAX_BAG_WJ_COUNT = 144

MAX_PLAYER_LEVEL = 100

COMPETITION_TIME = 180
--add by sxin PLATFORM

