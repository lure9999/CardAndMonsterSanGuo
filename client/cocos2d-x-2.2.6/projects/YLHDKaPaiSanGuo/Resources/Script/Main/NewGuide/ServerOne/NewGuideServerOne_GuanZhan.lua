--新手引导第一大部 之观战 celina
module("NewGuideServerOne_GuanZhan", package.seeall)

local GetCityNameByCityID = AtkCityData.GetCityNameByCityID

local GetCountryPathByTag = AtkCityData.GetCountryPathByTag
local GetBloodPercend = AtkCityData.GetBloodPercend

local GetTimeAction = AtkCitySceneLogic.GetTimeAction
local GetTimeOneAction = AtkCitySceneLogic.GetTimeOneAction
--[[local GetDamageMy = AtkCitySceneLogic.GetDamageMy
local GetDamageOther = AtkCitySceneLogic.GetDamageOther]]--
local GetCountryNameByIndex = AtkCitySceneLogic.GetCountryNameByIndex

local AddGuideIcon = NewGuideLayer.AddGuideIcon
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide

local SetFight = NewGuideLayer.SetFight
local SetNextCallBack = NewGuideLayer.SetNextCallBack

local m_pSceneUI = nil 
local tableBtn= {"撤退","突进","单挑","分身"}
local m_fCallBack = nil 

local m_pMyObject = nil 
local m_pOtherObject = nil 

local nMyCount = 0
local nOtherCount = 0
local tabNowFightWJData = {}

local MyPos = ccp(418+CommonData.g_Origin.x,198+CommonData.g_Origin.y)
local OtherPos = ccp(722+CommonData.g_Origin.x,198+CommonData.g_Origin.y)
local TAG_BLOOD = 6000

local pManagerGuanZhan = nil 

local function InitVars()
	--m_pSceneUI = nil 
	--m_fCallBack = nil 

	m_pMyObject = nil 
	m_pOtherObject = nil 

	nMyCount = 0
	nOtherCount = 0
end
local function GetScorllView()
	local scrollView = tolua.cast(m_pSceneUI:getWidgetByName("ScrollView_city"),"ScrollView")
	return scrollView
end
local function SetBlood(nType,nHurt)
	local bar_blood = tolua.cast(tabBlood[nType],"LoadingBar")
	local now_percent = bar_blood:getPercent()
	local nCurPercent = now_percent-GetBloodPercend(nHurt,tabNowFightWJData[nType].nTotalHP)
	if nCurPercent<0 then
		nCurPercent = 0
	end
	bar_blood:setPercent(nCurPercent)
end
local function GetDamage(nHP)
	local statyTime = 60
	if statyTime<3 then
		statyTime = 3
	end
	local nTimes = math.floor(statyTime/3)
	return math.floor(nHP/nTimes)
end

local function ChangeMyAction()
	--掉血tabNowFightWJData[1].nHPConsume/nSceneds,
	if nSceneds>30 then
		m_pMyObject:AddBloodEffect(GetDamage(tabNowFightWJData[1].nHPConsume),GetScorllView())
		SetBlood(1,GetDamage(tabNowFightWJData[1].nHPConsume))
	end
	nMyCount = nMyCount +1
	if nMyCount == 1 then
		m_pMyObject:playSkill(m_pOtherObject:GetAnimate())
	end
	if nMyCount == 2 then
		m_pMyObject:playManualSkill(m_pOtherObject:GetAnimate())
	end
	if nMyCount == 3 then
		m_pMyObject:playAttack(m_pOtherObject:GetAnimate())
	end
	if nMyCount==3 then
		nMyCount = 0
	end
end
local function ChangeOtherAction()
	if nSceneds>30 then
		m_pOtherObject:AddBloodEffect(GetDamage(tabNowFightWJData[2].nHPConsume),GetScorllView())
		SetBlood(2,GetDamage(tabNowFightWJData[2].nHPConsume))
	end
	nOtherCount = nOtherCount +1
	if nOtherCount == 1 then
		m_pOtherObject:playSkill(m_pMyObject:GetAnimate())
	end
	if nOtherCount == 2 then
		m_pOtherObject:playManualSkill(m_pMyObject:GetAnimate())
	end
	if nOtherCount == 3 then
		m_pOtherObject:playAttack(m_pMyObject:GetAnimate())
	end
	if nOtherCount==3 then
		nOtherCount = 0
	end
end
local function InitTitle()
	--标题
	local img_title = tolua.cast(m_pSceneUI:getWidgetByName("img_title"),"ImageView")
	local lable_title = LabelLayer.createStrokeLabel(60,CommonData.g_FONT1,"世界攻城战",ccp(0,28),ccc3(126,14,12),ccc3(255,235,151),true,ccp(0,-2),2)
	AddLabelImg(lable_title,1,img_title)
	--地点
	local lable_pos = tolua.cast(m_pSceneUI:getWidgetByName("label_name_city"),"Label")
	local nCountry = tonumber(server_mainDB.getMainData("nCountry"))
	if nCountry == 1 then
		lable_pos:setText("地点："..GetCityNameByCityID(58))
	elseif nCountry == 2 then
		lable_pos:setText("地点："..GetCityNameByCityID(105))
	else
		lable_pos:setText("地点："..GetCityNameByCityID(191))
	end
	
	--攻守方的国家和名字
	for i=1 ,3 do 
		local img_bg_red = tolua.cast(m_pSceneUI:getWidgetByName("img_bg_red_"..i),"ImageView")
		local img_city_my = tolua.cast(m_pSceneUI:getWidgetByName("img_city_red_"..i),"ImageView")
		local label_my = tolua.cast(m_pSceneUI:getWidgetByName("label_num_red_"..i),"Label")
		if i>1 then
			label_my:setVisible(false)
			img_city_my:setVisible(false)
			img_bg_red:setVisible(false)
		else
			label_my:setText("1")
			img_city_my:loadTexture(GetCountryPathByTag(nCountry))
		end
	end
	local img_country_defence = tolua.cast(m_pSceneUI:getWidgetByName("img_city_blue"),"ImageView")
	local numOther = tolua.cast(m_pSceneUI:getWidgetByName("label_num_blue"),"Label")
	numOther:setText("1")
	img_country_defence:loadTexture(GetCountryPathByTag(5))
end
local function _Btn_CallBack()
	
end
local function InitBtn()
	for i=1,4 do 
		local btn_i = tolua.cast(m_pSceneUI:getWidgetByName("btn_"..i),"Button")
		btn_i:setTag(TAG_GRID_ADD+i)
		CreateBtnCallBack( btn_i,tableBtn[i],30,_Btn_CallBack,COLOR_Black,COLOR_White,i,nil )
		btn_i:getChildByTag(1):setPosition(ccp(0,-30))
	end
end



local function _Guide_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--print("战斗")
		require "Script/Fight/BaseScene"
		--关闭观战界面
		local pAnimation = GetGuideIcon()
		if pAnimation~=nil then
			DeleteGuide()
		end
		InitVars()
		m_pSceneUI:removeFromParentAndCleanup(true)
		CountryWarScene.SetIsBackFromSingle( true )
		pManagerGuanZhan:Fun_ExitCountryWarScene()
		if m_fCallBack~=nil then
			SetFight(true)
			SetNextCallBack(m_fCallBack)
		end
		
		BaseScene.createBaseScene()
		BaseScene.InitCGFightData(2)
		BaseScene.EnterBaseScene()
	end
end
local function CreateWJIconWideget( pAtkTemp )
    local pCloneAtk = pAtkTemp:clone()
    local peer = tolua.getpeer(pAtkTemp)
    tolua.setpeer(pCloneAtk, peer)
    return pCloneAtk
end
local function AddWJIcon(tabWJId)
	local pAtkInfo = GUIReader:shareReader():widgetFromJsonFile("Image/AteCityInfo.json")
	tabBlood = {}
	for i=1,2 do 
		local pClone = CreateWJIconWideget(pAtkInfo)
		local img_bg = tolua.cast(pClone:getChildByName("img_city_info"),"ImageView")
		local label_name = tolua.cast(img_bg:getChildByName("label_name"),"Label")
		label_name:setText(tabWJId[i].strName)
		local label_lv = tolua.cast(img_bg:getChildByName("label_lv"),"Label")
		--[[if i==1 then
			label_lv:setText("【"..GetCountryNameByType(tabCityInfoData.sCounty).."】Lv:"..tabWJId[i].nLv)
		else
			label_lv:setText("【"..GetCountryNameByType(tabCityInfoData.sEnemyCounty).."】Lv:"..tabWJId[i].nLv)
		end]]--
		label_lv:setText("【"..GetCountryNameByIndex(tabWJId[i].nCountry).."】Lv:"..tabWJId[i].nLv)
		if i==1 then
			pClone:setPosition(ccp(m_pMyObject:GetAnimate():getPositionX()-60,m_pMyObject:GetAnimate():getPositionY()+170))
		else
			pClone:setPosition(ccp(m_pOtherObject:GetAnimate():getPositionX()-60,m_pOtherObject:GetAnimate():getPositionY()+170))
		end
		local img_barBG = tolua.cast(pClone:getChildByName("img_bar_bg"),"ImageView")
		local bar_blood = tolua.cast(img_barBG:getChildByName("bar_blood"),"LoadingBar")
		local nCurHP = tabWJId[i].nCurHP
		if tonumber(nCurHP) == 0 then
			nCurHP = tabWJId[i].nHPConsume
		end
		table.insert(tabBlood,bar_blood)
		bar_blood:setPercent(GetBloodPercend(nCurHP,tabWJId[i].nTotalHP))
		AddLabelImg(pClone,TAG_BLOOD+i,GetScorllView())
	end 
	
end

local function RunMyFirstAction()

	--print("RunMyFirstAction")
	m_pMyObject:GetAnimate():stopAllActions()
	if tabNowFightWJData== nil then
		return 
	end
	--[[print("RunMyFirstAction")
	print(GetDamageMy(tabNowFightWJData[1].nHPConsume))
	print("end RunMyFirstAction")]]--
	m_pMyObject:AddBloodEffect(GetDamage(tabNowFightWJData[1].nHPConsume),GetScorllView())
	SetBlood(1,GetDamage(tabNowFightWJData[1].nHPConsume))
	m_pMyObject:playAttack(m_pOtherObject:GetAnimate())
	m_pMyObject:GetAnimate():runAction(GetTimeAction(3,ChangeMyAction))
end
local function RunOtherFirstAction()
	--print("RunOtherFirstAction")
	--Pause()
	m_pOtherObject:GetAnimate():stopAllActions()
	if tabNowFightWJData== nil then
		--Pause()
		return 
	end
	m_pOtherObject:AddBloodEffect(GetDamage(tabNowFightWJData[2].nHPConsume),GetScorllView())
	SetBlood(2,GetDamage(tabNowFightWJData[2].nHPConsume))
	m_pOtherObject:playAttack(m_pOtherObject:GetAnimate())
	m_pOtherObject:GetAnimate():runAction(GetTimeAction(3,ChangeOtherAction))
end
local function ShowWJAction()
	local nCountryNow = tonumber(server_mainDB.getMainData("nCountry"))
	local strNameZhu = server_mainDB.getMainData("name")
	local imgID = server_mainDB.getMainData("nModeID")
	
	tabNowFightWJData[1]= {}
	tabNowFightWJData[1].nCountry = nCountryNow
	tabNowFightWJData[1].strName = strNameZhu
	tabNowFightWJData[1].nCurHP = 900
	tabNowFightWJData[1].nImageID = imgID
	tabNowFightWJData[1].nTotalHP = 900
	tabNowFightWJData[1].strCH = ""
	tabNowFightWJData[1].nNum = 1
	tabNowFightWJData[1].nLv= 2
	tabNowFightWJData[1].nHPConsume= 900
	
	tabNowFightWJData[2]= {}
	tabNowFightWJData[2].nCountry = 5
	tabNowFightWJData[2].strName = "司马懿"
	tabNowFightWJData[2].nCurHP = 900
	tabNowFightWJData[2].nImageID = 6042
	tabNowFightWJData[2].nTotalHP = 900
	tabNowFightWJData[2].strCH = ""
	tabNowFightWJData[2].nNum = 1
	tabNowFightWJData[2].nLv= 100
	tabNowFightWJData[2].nHPConsume= 900
	
	if m_pMyObject==nil then
		m_pMyObject = UIEffectManager.CreateUIEffectObj()
		m_pMyObject:Create(tonumber(tabNowFightWJData[1].nImageID),false,GetScorllView())
		m_pMyObject:GetAnimate():setPosition(MyPos)
		m_pMyObject:GetAnimate():setZOrder(3001)
	end
	if m_pOtherObject == nil then
		m_pOtherObject = UIEffectManager.CreateUIEffectObj()
		m_pOtherObject:Create(tonumber(tabNowFightWJData[2].nImageID),true,GetScorllView())
		m_pOtherObject:GetAnimate():setPosition(OtherPos)
		m_pOtherObject:GetAnimate():setZOrder(3000)
	end
	m_pMyObject:GetAnimate():runAction(GetTimeOneAction(2,RunMyFirstAction))
	m_pOtherObject:GetAnimate():runAction(GetTimeOneAction(2,RunOtherFirstAction))
	AddWJIcon( tabNowFightWJData )
end
local function FlushWarTime()
	local label_time = tolua.cast(m_pSceneUI:getWidgetByName("label_time"),"Label")
	if nSceneds == 31 then
		label_time:stopAllActions()
		--出现对话
		local function FinishTalk()
		
		end
		HeroTalkLayer.createHeroTalkUI(3039)
		HeroTalkLayer.SetGuideBackFun(FinishTalk)
	end
	nSceneds = nSceneds-1
	label_time:setText("00:"..nSceneds)
end
function ShowTime()
	nSceneds = 60
	local label_time = tolua.cast(m_pSceneUI:getWidgetByName("label_time"),"Label")
	label_time:setText("00:"..nSceneds)
	label_time:runAction(GetTimeAction(1,FlushWarTime))
end
local function InitUI()
	local Img_Name_Bg= tolua.cast(m_pSceneUI:getWidgetByName("img_name_bg"),"ImageView")
	Img_Name_Bg:setPosition(ccp(Img_Name_Bg:getPositionX()-CommonData.g_Origin.x,Img_Name_Bg:getPositionY()))
	--城池的名字
	InitTitle()
	InitBtn()
	local btn_fight = tolua.cast(m_pSceneUI:getWidgetByName("btn_fight"),"Button")
	NewGuideLayer.AddGuideIcon(ccp(btn_fight:getPositionX(),btn_fight:getPositionY()))
	local pLayoutGuide = NewGuideLayer.GetGuideIcon()
	pLayoutGuide:setTouchEnabled(true)
	pLayoutGuide:addTouchEventListener(_Guide_CallBack)
	ShowWJAction()
	ShowTime()
end

--直显示一个简单的界面
function CreateGuideGuanZhan(fCallBack,pManager)
	m_fCallBack = fCallBack
	pManagerGuanZhan = pManager
	m_pSceneUI = TouchGroup:create()
	m_pSceneUI:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/AtkCityWarScene.json" ) )
	--得到ScrollView
	local scrollView = tolua.cast(m_pSceneUI:getWidgetByName("ScrollView_city"),"ScrollView")
	
	--挂接场景
	local scene_node  = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_guozhan01.json")--CCScene:create()	
	if scrollView:getNodeByTag(1000)~= nil then
		scrollView:removeNodeByTag(1000)
	end
	scene_node:setPosition(ccp(-285,0))
	scrollView:addNode(scene_node,1000,1000)
	
	scrollView:ignoreAnchorPointForPosition(true)
    scrollView:setPosition(ccp(0,0))
	scrollView:setBounceEnabled(true)
	InitUI()
	local pScene = CCDirector:sharedDirector():getRunningScene()
	
	pScene:addChild(m_pSceneUI,layerAtkWar_Tag,layerAtkWar_Tag)
end



