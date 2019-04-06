
--新的加载界面 celina

module("LoadingNewLayer", package.seeall)

require "Script/Login/LoadingLogic"

--变量
local nLoadingType = nil 
local m_loadingLayer = nil 
local table_res = nil --要加载的资源
local m_callBack = nil --回调函数
--local m_pProdressBar = nil
local sVersion = nil
local m_PauseNum = nil --加载资源的过程需要回调
local m_CountCallBack = nil ---加载过程需要回调的次数 暂时写为加载完传入的资源以后第一次回调,加载完以后回调第二次
local m_nAllResCount = nil
local m_nCurResCount = nil
local m_nCurProPos = 0
local m_nDesProPos = 0
local m_bAnimationEnd = false
local m_typeLoading = nil
local Label_Progress = nil --版本信息
local nowSubInfo = nil --记录减掉一个版本后的
local animation_door = nil 
local bLoadTwice =nil
local pLoadLua = nil
--local changeCallBack = nil --如果是切换场景，等关门再回调切换场景

local pAnimationStart = nil 

--逻辑
local GetBackGroundImage_layer  = LoadingLogic.GetBackGroundImage
local GetUpdateVer = LoadingLogic.GetUpdateVer
local ToGetUpUrl = LoadingLogic.ToGetUpUrl
local CreateLoadingAnimation_UI = LoadingLogic.CreateLoadingAnimation
local GetLoadingAciton_UI = LoadingLogic.GetLoadingAciton
local CheckBEnd_UI = LoadingLogic.CheckBEnd
--local GetUpdateUrl = LoadingLogic.GetUpdateUrl
local TabLabelShow_UI = LoadingLogic.TabLabelShow
local GetActionDelay_UI = LoadingLogic.GetActionDelay

local ToLogicDownLoadOK = LoadingLogic.ToLogicDownLoadOK
local RandomLoaingType_UI = LoadingLogic.RandomLoaingType

local TYPELOADING = {
	TYPELOADING_BAR = 1,
	TYPELOADING_NO_BAR = 2,
	TYPELOADING_DOOR = 3,
	TYPELOADING_START = 4, --开始界面的
}
 --loading 的类型
LOADING_TYPE = {
	LOADING_TYPE_DOWN_LOAD = 1,
	LOADING_TYPE_2 = 2,
	LOADING_TYPE_3 = 3,
	LOADING_TYPE_NONE = 4,
	LOADING_TYPE_LOAD = 5,--加载界面
	LOADING_TYPE_GUOZHAN = 6, --国战的新手引导加载
}
local function InitVars()
	nLoadingType = nil 
	m_loadingLayer = nil 
	m_callBack = nil 
	table_res = nil 
	--m_pProdressBar = nil
	sVersion = nil
	m_PauseNum = nil
	m_CountCallBack = nil
	m_nAllResCount = nil
	m_nCurResCount = nil
	m_nCurProPos = 0
	m_nDesProPos = 0
	m_bAnimationEnd = false
	Label_Progress = nil
	nowSubInfo = nil
	animation_door = nil 
	bLoadTwice = nil
	--changeCallBack = nil
	pLoadLua = nil
	pAnimationStart = nil 
end
function UpdateVersion(ver)
	nowSubInfo = ver
end
function GetUpdateVersion()
	return nowSubInfo
end
function ToDownLoad()
	--m_pProdressBar:setVisible(true)
	local _img_tips = tolua.cast(m_loadingLayer:getWidgetByName("img_Tips"),"ImageView")
	_img_tips:setVisible(true)
	local _img_word_bg = tolua.cast(m_loadingLayer:getWidgetByName("img_nobar_word"),"ImageView")
	_img_word_bg:setVisible(false)
	local function _Btn_StartUpdate(sender, eventType)
		if eventType ==2 then
			StartUpdate(true)
			_img_tips:setVisible(false)
			_img_word_bg:setVisible(false)
		end
	end
	--提示版本下载的信息
	--[[local pTipLayer = TipCommonLayer.CreateTipLayerManager()
	pTipLayer:ShowCommonTips(1477,SatartDownLoad,tonumber(GetUpdateVer(sVersion)),0.3)
	pTipLayer = nil]]--
	
	local Label_Info = tolua.cast(m_loadingLayer:getWidgetByName("Label_11"),"Label")
	--print(sVersion)
	local nowVer = CCUserDefault:sharedUserDefault():getStringForKey("g_Version")
	local nVer,nSize = GetUpdateVer(nowVer)
	local nSizeM = tonumber(nSize)/1024
	Label_Info:setText(string.format("%.1f（%.2fM）请速速更新！",tonumber(nVer),nSizeM))
	local btn = tolua.cast(m_loadingLayer:getWidgetByName("btn_ok"),"Button")
	local label  = createStrokeLabelNew(36, CommonData.g_FONT1, "确定",ccp(0,4), ccc3(0,0,0), ccc3(255,255,255), true, 2)
	btn:addChild(label)
	btn:addTouchEventListener(_Btn_StartUpdate)
end
function DownLoadEnterGame(fCallBack)
	sVersion = nowSubInfo
	--print("DownLoadEnterGame")
	--print(sVersion)
	--Pause()
	ToLogicDownLoadOK(sVersion,Label_Progress,fCallBack)
end

local function AddLoadingAnimation(_img_barBg)
	local function EffectEnd(pAnimation)
		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 1 then
				m_bAnimationEnd = true 
				CheckBEnd_UI(m_bAnimationEnd,m_loadingLayer,m_callBack)
			end
		end
		pAnimation:setMovementEventCallFunc(onMovementEvent)
		
		
	end
	CreateLoadingAnimation_UI("Image/imgres/effectfile/loading/loading.ExportJson", 
		"loading", 
		"Animation1", 
		_img_barBg, 
		ccp(-_img_barBg:getContentSize().width/2, 0),
		EffectEnd)
end
local function LoadingBarType(bTwice)
	local _img_barBg = tolua.cast(m_loadingLayer:getWidgetByName("Image_Bar_Bg"),"ImageView")
	if bTwice == false then
		if table_res~=nil then
			for key,value in pairs(table_res) do 
				m_nAllResCount = m_nAllResCount +1
			end
			m_nCurResCount = m_nCurResCount + 1
			myAddImageAsync(table_res[m_nCurResCount])
		end
	else
		m_PauseNum = 0
	
	end
	local function LoadingAction()
		if m_nCurProPos < m_nDesProPos then
			m_nCurProPos = m_nCurProPos + 1
		end
		--设置熊猫的位置
		if _img_barBg:getChildByTag(1)~=nil then
			local xPt = (700/100)*m_nCurProPos +100
			_img_barBg:getChildByTag(1):setPosition(ccp(xPt, 0))
		end
		
		if m_PauseNum~=nil and   m_PauseNum~=0 then
			--说明加载资源后要回调
			if bTwice == false then
				if m_nCurResCount>= m_PauseNum then
					CheckBEnd_UI(m_bAnimationEnd,m_loadingLayer,m_callBack)
				end
			end
		else
			if m_nCurProPos >= 100 then
				CheckBEnd_UI(m_bAnimationEnd,m_loadingLayer,m_callBack)
				
			end
		end
		
	end
	m_loadingLayer:runAction(GetLoadingAciton_UI(LoadingAction))
end
local function AddNoBarAnimation(_img_noBarBg) 
	pAnimationStart = LoadingLogic.GetAnimationByName("Image/imgres/effectfile/loading/loading.ExportJson",
		"loading", 
		"Animation3",
		_img_noBarBg,
		ccp(23,-11), 
		nil,
		1)
end

--没有进度条的加载
local function LoadingNoBarType(bTwice)
	if bTwice == false then
		if table_res~=nil then
			for key,value in pairs(table_res) do 
				m_nAllResCount = m_nAllResCount +1
			end
			m_nCurResCount = m_nCurResCount + 1
			myAddImageAsync(table_res[m_nCurResCount])
		end
		--[[local tabLabel = {}
		for i=1,3 do 
			local label= Label:create()
			label:setFontName(CommonData.g_FONT3)
			label:setFontSize(20)
			label:setText(".")
			label:setVisible(false)
			label:setPosition(ccp(1044+6*(i-1),44))
			if m_loadingLayer:getChildByTag(100+i)~=nil then
				m_loadingLayer:getChildByTag(100+i):setVisible(false)
				m_loadingLayer:getChildByTag(100+i):removeFromParentAndCleanup(true)
			end
			m_loadingLayer:addChild(label,100+i,100+i)
			table.insert(tabLabel,label)
		end]]--
		--[[local countNow = 0
		local labelWord = tolua.cast(m_loadingLayer:getWidgetByName("Label_word"),"Label")
		local function DotAction()
			if m_loadingLayer ~=nil then
				countNow = countNow +1 
				if countNow>3 then
					countNow = 1 
				end
				TabLabelShow_UI(tabLabel,countNow)
			end
		end
		if m_loadingLayer~=nil then
			labelWord:runAction(GetActionDelay_UI(DotAction))
		end]]--
	else
		m_PauseNum = 0
	end
	
	
	
	local function NoBarLoading()
		if m_nCurProPos < m_nDesProPos then
			m_nCurProPos = m_nCurProPos + 1
		end
		if m_PauseNum~=nil and   m_PauseNum~=0 then
			--说明加载资源后要回调
			if bTwice == false then
				if m_nCurResCount>= m_PauseNum then
					if m_callBack~=nil then
						m_callBack()
					end
				end
			end
		else
			if m_nCurProPos >= 100 then
				if m_callBack~=nil then
					m_callBack()
				end
				m_loadingLayer:stopAllActions()
			end
		end
	end
	m_loadingLayer:runAction(GetLoadingAciton_UI(NoBarLoading))
end 

local function LoadTableResStart(bTwice)
	if m_typeLoading == TYPELOADING.TYPELOADING_BAR then
		LoadingBarType(bTwice)
	else
		if nLoadingType ~= LOADING_TYPE.LOADING_TYPE_DOWN_LOAD then
			LoadingNoBarType(bTwice)
		end
	end
end
local function AddDoorAnimation(changeSceneCall)
	local function AddHuHua(pAnimation)
		
		local function HuhuaEnd()	
			LoadTableResStart(bLoadTwice)
		end
		LoadingLogic.GetAnimationByName("Image/imgres/effectfile/huohua_loading/huohua_loading.ExportJson",
			"huohua_loading", 
			"Animation1",
			m_loadingLayer,
			ccp(570,320), 
			HuhuaEnd,
			4001)
		animation_door = pAnimation
		if changeSceneCall~=nil then
			changeSceneCall()			
		end
	end
	
	LoadingLogic.GetAnimationByName("Image/imgres/effectfile/loading/loading.ExportJson",
		"loading", 
		"Animation4",
		m_loadingLayer,
		ccp(570,320),
		AddHuHua,
		4000)
		
end
function SetLoadingInfo(text, nCurCount, nAllCount)
	nAllCount = m_nAllResCount
	if m_loadingLayer ~= nil then
		local fPer = nCurCount/m_nAllResCount
		fPer = fPer*100
		m_nDesProPos = fPer
		if fPer == 100 then
		else
			local function AysAddCount()
				m_nCurResCount = m_nCurResCount + 1
				myAddImageAsync(table_res[m_nCurResCount])
			end
			local actionCur = CCArray:create()
			local ff = nCurCount/m_nAllResCount
			actionCur:addObject(CCCallFuncN:create(AysAddCount))
			m_loadingLayer:runAction(CCSequence:create(actionCur))
		end
	end
end
local tab = {
	
	"Script/Login/DownLoadLayer",
	"Script/Login/LoadingNewLayer",
	"Script/Common/Common",
	"Script/Login/LoginLayer",
	"Script/Fight/simulationStl",
	"Script/Network/network",	
	"Script/Main/UserSetting/UserSettingLayer",	
	"Script/serverDB/countrycity",	
	"Script/serverDB/general",
	"Script/serverDB/globedefine",
	"Script/serverDB/server_mainDB",
	"Script/Main/CountryWar/CountryWarDef",
	"Script/Main/Wujiang/GeneralBaseData",
	"Script/serverDB/server_CountryWarAllMesDB",
	"Script/serverDB/server_CountryWarTeamOrderDB",
	"Script/serverDB/server_CountryWarTeamMesDB",
	"Script/serverDB/server_CountryWarPalyerInfoDB",
	"Script/serverDB/server_countryLevelUpDB",
	"Script/serverDB/server_CountryWarTeamLifeDB",
	"Script/serverDB/server_CountryWarExpeditionMesDB",
	"Script/serverDB/server_CountryAnimalBuffDB",
	"Script/serverDB/server_CountryPattern",
	"Script/serverDB/server_CountryWarMistyMesDB",
	"Script/serverDB/country",
	"Script/serverDB/resani",
	"Script/serverDB/expendition",
	"Script/Main/Item/ItemData",	
	"Script/Main/CountryWar/CountryWarData",
	"Script/Main/CountryWar/CountryWarLogic",
	"Script/Main/CountryWar/ClickCityLayer",
	"Script/Main/CountryWar/PathFinding",	
	"Script/Main/CountryWar/CountryWarRaderLayer",	
	"Script/Main/CountryWar/CountryUILayer",
	"Script/Main/CountryWar/CountryWarCityManager",
	"Script/Main/CountryWar/ClickCityLogic",
	"Script/Main/CountryWar/CityNode",
	"Script/Main/CountryWar/PlayerNode",
	"Script/Main/CountryWar/AtkChooseCity",
	"Script/Main/CountryWar/AtkCityData",
	"Script/Main/CountryWar/CountryChildLayer",
	"Script/Main/CountryWar/MistyManager",
	"Script/Main/CountryWar/CountryWarManager",
	"Script/Login/LoadingNewLayer",
	"Script/Main/CountryWar/CountryWarScene",
	"Script/Main/Pata/PataLayer",
	"Script/Main/RankList/RankListLayer",
	"Script/Main/Chat/ChatLayer",
	"Script/Main/Corps/CorpsLayer",
	"Script/Main/Corps/CorpsLogic",
	"Script/Main/Chat/ChatShowLayer",
	"Script/Main/NoticeBoard/NoticeTipLayer",
	"Script/Main/NoticeBoard/NoticeScrollLayer",
	"Script/Main/NoticeBoard/NoticeSTiplayer",
	"Script/Main/NoticeBoard/NoticeScrollData",
	"Script/Main/Corps/CorpsScene",
	"Script/Main/CountryWar/CountryUILayer",
	"Script/Main/SignIn/SignInLayer",
	"Script/Main/UserSetting/UserSettingData",
	"Script/serverDB/server_CorpsGetInfoDB",
	"Script/serverDB/server_ShopOpenDB",
	"Script/serverDB/vipfunction",
	"Script/Main/CountryReward/CountryRewardBtn",
	"Script/Main/ChargeVIP/ChargeVIPLayer",
	--"Script/Common/CoinInfoBar",
	"Script/Main/CoinBar/CoinInfoBarManager",
	"Script/Main/NewGuide/NewGuideManager",
	"Script/Main/HeroUpgrade/HeroUpGradeLayer",
	"Script/Network/packet/Packet_GetBaseData",
	"Script/Network/packet/Packet_GetItemList",
	"Script/Network/packet/Packet_GetEquipList",
	"Script/Network/packet/Packet_GetGeneralList",
	"Script/Network/packet/Packet_GetShopList",
	"Script/Network/packet/Packet_BuyItem",
	"Script/Network/packet/Packet_UseItem_Box",
	"Script/Network/packet/Packet_UpdataEquipList",
	"Script/Network/packet/Packet_UpdataGeneralList",
	"Script/Network/packet/Packet_UpdataItemList",	
	"Script/Audio/AudioUtil",
	"Script/Login/CreateRoleScene",
	"Script/test/TestEngineLayer",
	"Script/Network/packet/PacketNewRequire",
}

function SetNodeTimer(pNode,fTime, pcallFunc, iTagID)

	local pDelay = CCDelayTime:create(fTime)	
	local pSequence  = CCSequence:createWithTwoActions(pDelay, pcallFunc)
	pSequence:setTag(iTagID)
	pNode:runAction(pSequence)
end

local function send(x)
	coroutine.yield(x)
end
local function ReLoad()
	local i=0
	local length = table.getn(tab)
	--print(length)
	
	while i<length do 
		i=i+1
		print("i:"..tab[i])
		local s = require (tab[i])	
		send(i)		
	end
end
local function receive()
	local status,value = coroutine.resume(pLoadLua)
	return value
end
local function Consumer(start,endNum)
	
	for i=start,endNum do 
		local j = receive()
		if j==endNum then
			--进入游戏
			DeleteUpdateNewLayer()
			require "Script/Login/StartScene"
			--StartScene.ToStartLogin()
			StartScene.createStart_SceneUI()
		end
	end
end

local function Consumer_New(start,endNum)
	
	local mLayout  = tolua.cast(m_loadingLayer:getWidgetByName("Panel_Loading"),"Layout")
	local pcallFunc = nil		
	local function pCallBack(pNode)	
		
		local i = receive()
		if i==endNum then
		
			--加载路点数据
			CountryWarData.Loadcityroad_editData()
			--进入游戏
			DeleteUpdateNewLayer()
			require "Script/Login/StartScene"
			--StartScene.ToStartLogin()
			StartScene.createStart_SceneUI()
		else
			pcallFunc = CCCallFuncN:create(pCallBack)		
			SetNodeTimer(mLayout,0.1,pcallFunc,0)
		end
	
	end
	
	pcallFunc = CCCallFuncN:create(pCallBack)	
	SetNodeTimer(mLayout,0.1,pcallFunc,0)
end




local function InitUI(strVersion,changeSceneCall)
	
	sVersion = strVersion
	--local mPanel  = tolua.cast(m_loadingLayer:getWidgetByName("Panel_Loading"),"Layout")
	--mPanel:setBackGroundImage(GetBackGroundImage_layer(nLoadingType))
	local img_bg =  tolua.cast(m_loadingLayer:getWidgetByName("Image_12"),"ImageView")
	
	--如果是一开始的loading界面的话，类型为加logo标识的
	if tonumber(nLoadingType)==LOADING_TYPE.LOADING_TYPE_LOAD or tonumber(nLoadingType)==LOADING_TYPE.LOADING_TYPE_GUOZHAN then
		m_typeLoading = TYPELOADING.TYPELOADING_START
		img_bg:loadTexture("Image/imgres/loading/loading_bg03.png")
	else
		img_bg:loadTexture(GetBackGroundImage_layer(nLoadingType))
		m_typeLoading = RandomLoaingType_UI()
		if tonumber(m_typeLoading) == TYPELOADING.TYPELOADING_DOOR  then
			if tonumber(nLoadingType) == LOADING_TYPE.LOADING_TYPE_DOWN_LOAD  then
				m_typeLoading = tonumber(m_typeLoading)-1
			end
		end
	end
	
	local _img_barBg = tolua.cast(m_loadingLayer:getWidgetByName("Image_Bar_Bg"),"ImageView")
	
	local _img_noBarBg = tolua.cast(m_loadingLayer:getWidgetByName("Image_no_Bar_Bg"),"ImageView")
	local _img_word_bg = tolua.cast(m_loadingLayer:getWidgetByName("img_nobar_word"),"ImageView")
	local _img_tips = tolua.cast(m_loadingLayer:getWidgetByName("img_Tips"),"ImageView")
	_img_tips:setVisible(false)
	
	if nLoadingType == LOADING_TYPE.LOADING_TYPE_DOWN_LOAD then
		local sceneGame = CCDirector:sharedDirector():getRunningScene()
		sceneGame:addChild(m_loadingLayer, 998, 998)
		_img_barBg:setVisible(false)
		_img_noBarBg:setVisible(false)
		_img_word_bg:setVisible(false)
		if ToGetUpUrl(strVersion)== false then
			--直接进入游戏
			DeleteUpdateNewLayer()
			--[[require "Script/Login/StartScene"
			StartScene.createStart_SceneUI()]]--
			LoadingNewLayer.ShowLoading(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_LOAD,g_strVersion,false)
		end
	elseif nLoadingType == LOADING_TYPE.LOADING_TYPE_LOAD or tonumber(nLoadingType)==LOADING_TYPE.LOADING_TYPE_LOAD then
		local sceneGame = CCDirector:sharedDirector():getRunningScene()
		sceneGame:addChild(m_loadingLayer, 998, 998)	
		
	end
	if tonumber(m_typeLoading) == TYPELOADING.TYPELOADING_BAR then
		_img_barBg:setVisible(true)
		_img_noBarBg:setVisible(false)
		_img_word_bg:setVisible(false)
		AddLoadingAnimation(_img_barBg)
		img_bg:setVisible(true)
	elseif tonumber(m_typeLoading) == TYPELOADING.TYPELOADING_DOOR then
		_img_barBg:setVisible(false)
		_img_noBarBg:setVisible(false)
		_img_word_bg:setVisible(false)
		img_bg:setVisible(false)
		AddDoorAnimation(changeSceneCall)
	elseif  tonumber(m_typeLoading) == TYPELOADING.TYPELOADING_START then
		--没有动画
		--[[_img_noBarBg:setVisible(false)
		_img_word_bg:setVisible(false)
		_img_barBg:setVisible(false)]]--
		_img_noBarBg:setVisible(true)
		_img_word_bg:setVisible(false)
		_img_barBg:setVisible(false)
		AddNoBarAnimation(_img_noBarBg)
		
		--添加标识
		local img_logo = ImageView:create()
		img_logo:loadTexture("Image/imgres/login/logo.png")
		img_logo:setPosition(ccp(0,240))
		img_logo:setScale(0.8)
		if img_bg:getChildByTag(100)==nil then
			img_bg:addChild(img_logo,100,100)
		end
		
	else
		_img_noBarBg:setVisible(true)
		_img_word_bg:setVisible(false)
		_img_barBg:setVisible(false)
		AddNoBarAnimation(_img_noBarBg)
	end
	if nLoadingType == LOADING_TYPE.LOADING_TYPE_LOAD then
		local m_nHanderTime =nil 
		local function LoadUpdata(dt)		
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
			pLoadLua = coroutine.create(ReLoad)
			--Consumer(1,table.getn(tab))
			 CCUserDefault:sharedUserDefault():setBoolForKey("isMainScene",false)
			Consumer_New(1,table.getn(tab))
		end
		m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(LoadUpdata, 0.1, false)
	end
	if nLoadingType == LOADING_TYPE.LOADING_TYPE_GUOZHAN then
		local m_nHanderTime =nil 
		local function LoadUpdata(dt)		
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
			if m_callBack~=nil then
				m_callBack()
				m_callBack =nil 
			end
		end
		m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(LoadUpdata, 0.5, false)
	end
end
function UpdateProgress(nCurSize,nAllSize)
	-- 计算进度条
	--m_pProdressBar:setVisible(true)
	local per = nCurSize/nAllSize
	per = per*100
	--m_pProdressBar:setPercent(per)
	if Label_Progress==nil then
		Label_Progress = Label:create()
		Label_Progress:setFontSize(20)
		Label_Progress:setPosition(ccp(570,118))
		--AddLabelImg(Label_Progress,900,m_loadingLayer)
		if m_loadingLayer:getChildByTag(900)==nil then
			m_loadingLayer:addChild(Label_Progress,900,900)
		end
	end
	if per>=0 then
		print("正在更新版本")
		print(GetUpdateVer(sVersion))
		print(per)
		local m_strShowText =  string.format("正在更新%s版本:%s%s",GetUpdateVer(sVersion),tostring(per),"%")
		if Label_Progress~=nil then
			Label_Progress:setText(m_strShowText)
		end
		-- Label_Progress:setText(tostring(per).."%")
	end
	
	
	--[[local _img_barBg = tolua.cast(m_loadingLayer:getWidgetByName("Image_Bar_Bg"),"ImageView")
	local _img_noBarBg = tolua.cast(m_loadingLayer:getWidgetByName("Image_no_Bar_Bg"),"ImageView")
	local _img_word_bg = tolua.cast(m_loadingLayer:getWidgetByName("img_nobar_word"),"ImageView")
	_img_noBarBg:setVisible(true)
	_img_word_bg:setVisible(false)
	_img_barBg:setVisible(false)
	LoadingNoBarType(false)
	AddNoBarAnimation(_img_noBarBg)]]--
end
--设置回调放给调用者，为了方便中间有多次回调需求
function SetFCallBack(fCallBack,nNumCallBack)
	m_callBack = fCallBack
	m_CountCallBack = nNumCallBack
end
--设置加载文件table放给调用者，为了方便中间间断或者有两次加载等需要回调
function SetLoadResTable(tempTable,nPauseNum)
	m_nAllResCount = 0
	m_nCurResCount = 0
	m_nCurProPos = 0
	m_nDesProPos = 0
	m_callBack = nil
	m_PauseNum = nPauseNum
	ReSetAsync()
	table_res = tempTable
end
--类型 typeNone 是随机三张其中一张 strVersion下载单独使用
local function CreateLoadingLayer( nType,strVersion ,changeSceneCall)
	m_loadingLayer = TouchGroup:create()									-- 背景层
    m_loadingLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/LoadingLayer.json") )
	nLoadingType = nType
	--m_loadingLayer:setTouchPriority(-2)--ENUM_TOUCH_LEVEL.ENUM_TOUCH_LEVEL_LOADING
	
	local mLayout  = tolua.cast(m_loadingLayer:getWidgetByName("Panel_Loading"),"Layout")
	if tonumber(nLoadingType)~=LOADING_TYPE.LOADING_TYPE_DOWN_LOAD then
		local pLayout = Layout:create()
		pLayout:setName("loadingNewLayer")
		pLayout:setSize(CCSize(1140,640))
		pLayout:setTouchEnabled(true)	
		pLayout:setZOrder(10000)
		m_loadingLayer:setTouchPriority(-2)
		m_loadingLayer:addWidget(pLayout)
	end
	InitUI(strVersion,changeSceneCall)
	return m_loadingLayer 
end
function GetLoadingLayerUI(nType,sVersion,fChangeSceneCall)
	if m_loadingLayer == nil then
		CreateLoadingLayer(nType,sVersion ,fChangeSceneCall)
	end

	return m_loadingLayer
end
function ShowLoading(bShow,nType,sVersion,bTwice)

	bLoadTwice = bTwice
	if m_loadingLayer == nil then
		CreateLoadingLayer(nType,sVersion ,changeSceneCall)
	end
	if m_loadingLayer~=nil and bShow == true then
		if m_typeLoading ~= TYPELOADING.TYPELOADING_DOOR then
			LoadTableResStart(bTwice)	
		else
			if bTwice == true then
				LoadTableResStart(bTwice)
			end	
		end
	else
		if m_typeLoading == TYPELOADING.TYPELOADING_DOOR then
			if animation_door~=nil then
				
				local function onMovementEvent(armatureBack,movementType,movementID)
					if movementType == 1 then
						m_loadingLayer:setVisible(false)
						m_loadingLayer:removeFromParentAndCleanup(true)
						InitVars()
					elseif movementType == 2 then
						
					end
				end
				animation_door:play("Animation6")
				animation_door:setMovementEventCallFunc(onMovementEvent)
				AudioUtil.playEffect("audio/loading/open_door_scene.mp3")
			end
		else
			if m_loadingLayer~=nil then
				m_loadingLayer:removeFromParentAndCleanup(true)
				InitVars()
			end
		end
		
	end
	
end
function GetBgType()
	return m_typeLoading
end

function DeleteUpdateNewLayer()
	if m_loadingLayer~=nil then
		m_loadingLayer:removeFromParentAndCleanup(true)
		m_loadingLayer = nil
	end
end
