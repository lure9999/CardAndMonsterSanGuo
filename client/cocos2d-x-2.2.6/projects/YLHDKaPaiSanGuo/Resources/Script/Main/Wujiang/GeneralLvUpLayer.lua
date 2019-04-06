require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralLvUpData"
require "Script/Main/Wujiang/GeneralBaseUILogic"

module("GeneralLvUpLayer", package.seeall)

local m_plyGeneralLvUp = nil
local m_lbDanYao = nil
local m_imgHead = nil
local m_lbExpPool = nil
local m_pgBar = nil
local m_btnLeft = nil
local m_btnRight = nil
local m_nCurLv = nil
local m_nAinIdx = 1
local m_tabAniKey = {}
local m_plArmature = nil


local SetCurGeneralIdx 			= GeneralBaseUILogic.SetCurGeneralIdx
local GetCurGeneralGrid			= GeneralBaseUILogic.GetCurGeneralGrid
local UpdateBtnsState			= GeneralBaseUILogic.UpdateBtnsState
local PlayGeneralAnimation		= GeneralBaseUILogic.PlayGeneralAnimation
local UpdateHeadIcon			= GeneralBaseUILogic.UpdateHeadIcon

local GetGeneralName			= GeneralBaseData.GetGeneralName
local GetGeneralLv				= GeneralBaseData.GetGeneralLv
local GetMainGeneralLv			= GeneralBaseData.GetMainGeneralLv
local GetGeneralStar			= GeneralBaseData.GetGeneralStar
local GetGeneralCountryIcon		= GeneralBaseData.GetGeneralCountryIcon
local GetGeneralTypeIcon		= GeneralBaseData.GetGeneralTypeIcon
local GetDanYaoLvText			= GeneralBaseData.GetDanYaoLvText
local GetGeneralTurnLife		= GeneralBaseData.GetGeneralTurnLife
local GetAniKeyDef				= GeneralBaseData.GetAniKeyDef

local GetNeedExp				= GeneralLvUpData.GetNeedExp
local GetGeneralExpPool 		= GeneralLvUpData.GetGeneralExpPool
local GetGeneralMaxExpPool		= GeneralLvUpData.GetGeneralMaxExpPool
local GetAddAttrValue			= GeneralLvUpData.GetAddAttrValue
local CheckNeed					= GeneralLvUpData.CheckNeed

local function InitVars( )
	m_plyGeneralLvUp = nil
	m_lbDanYao = nil
	m_imgHead = nil
	m_lbExpPool = nil
	m_pgBar = nil
	m_btnLeft = nil
	m_btnRight = nil
	m_nCurLv = nil
	m_nAinIdx = 1
	m_plArmature = nil
end

local function UpdateBaseData( nGrid )
	local strName = GetGeneralName(nGrid)
	local plbName1 = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Label_Name1"), "Label")
	if plbName1~=nil then
		plbName1:setText(strName)
	end

	m_nCurLv = GetGeneralLv(nGrid)
	if m_nCurLv>MAX_PLAYER_LEVEL then
		m_nCurLv = MAX_PLAYER_LEVEL
	end
	local plbLv = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Label_Lv"), "Label")
	if plbLv~=nil then
		plbLv:setText("Lv."..tostring(m_nCurLv))
	end

	-- local plbLv1 = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Label_Lv1"), "Label")
	-- if plbLv1~=nil then
	-- 	plbLv1:setText(tostring(m_nCurLv))
	-- end

	local nStars = GetGeneralStar(nGrid)
	for i=1, 6 do
		local imgStar = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Image_star_n_"..tostring(i)),"ImageView")
		if i<=nStars then
			imgStar:setVisible(true)
		else
			imgStar:setVisible(false)
		end
	end

	local strIcon = GetGeneralCountryIcon(nGrid)
	local pImgCountry = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Image_Country"), "ImageView")
	if pImgCountry~=nil then
		pImgCountry:loadTexture(strIcon)
	end

	local strAttr = GetGeneralTypeIcon(nGrid)
	local pImgType = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Image_Type"),"ImageView")
	if pImgType~=nil then
		pImgType:loadTexture(strAttr)
	end

	local strLv = GetDanYaoLvText(nGrid)
	if m_lbDanYao~= nil then
		LabelLayer.setText(m_lbDanYao, strLv)
	end

	local nNeedExp = GetNeedExp(m_nCurLv)

	local lbNeedExp = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Label_NeedExp"), "Label")
	local img_needExp = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Image_21"),"ImageView")
	img_needExp:setVisible(true)
	if tonumber(m_nCurLv) >= MAX_PLAYER_LEVEL then
		img_needExp:setVisible(false)
	end
	if lbNeedExp~=nil then
		lbNeedExp:setText(":"..tostring(nNeedExp))
	end

	local nExpPool=GetGeneralExpPool()
	local nMaxExpPool = GetGeneralMaxExpPool(GetMainGeneralLv())
	LabelLayer.setText(m_lbExpPool, tostring(nExpPool).."/"..tostring(nMaxExpPool))

	local pgBar = tolua.cast(m_plyGeneralLvUp:getWidgetByName("ProgressBar_80"), "LoadingBar")
	if nExpPool>=nMaxExpPool then
		pgBar:setPercent(100)
	else
		local nCurExpPercent = tonumber(nExpPool/nMaxExpPool)
		pgBar:setPercent(nCurExpPercent*100)
	end
end

local function UpdateAttrText( nUpLv )
	local nTurn = GetGeneralTurnLife(GetCurGeneralGrid())
	local nAddHp, nAddAttack, nAddWuFang, nAddFaFang = GetAddAttrValue(nUpLv, nTurn)

	local panelLvUp = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Panel_LvUp"), "Layout")
	--TipLayer.createPopTipLayer("生命 +"..tostring(nAddHp), 24, ccc3(0,255,79), ccp(panelLvUp:getPositionX() + panelLvUp:getSize().width/2-50, panelLvUp:getPositionY() + panelLvUp:getSize().height-100))
	--TipLayer.createPopTipLayer("攻击 +"..tostring(nAddAttack), 24, ccc3(0,255,79), ccp(panelLvUp:getPositionX() + panelLvUp:getSize().width/2-50, panelLvUp:getPositionY() + panelLvUp:getSize().height -130))
	--TipLayer.createPopTipLayer("物防 +"..tostring(nAddWuFang), 24, ccc3(0,255,79), ccp(panelLvUp:getPositionX() + panelLvUp:getSize().width/2-50, panelLvUp:getPositionY() + panelLvUp:getSize().height -160))
	--TipLayer.createPopTipLayer("法防 +"..tostring(nAddFaFang), 24, ccc3(0,255,79), ccp(panelLvUp:getPositionX() + panelLvUp:getSize().width/2-50, panelLvUp:getPositionY() + panelLvUp:getSize().height -190))
end

local function _BtnLianHua_CallBack( sender, eventType )
	TipLayer.createTimeLayer("暂未开启", 2)
	return
end

function UpdateLvUpData( nGrid )
	m_tabAniKey = GetAniKeyDef(nGrid)
	UpdateHeadIcon(nGrid, m_plyGeneralLvUp)
	UpdateBaseData(nGrid)
	UpdateBtnsState(m_btnLeft, m_btnRight)
	PlayGeneralAnimation(nGrid, m_plArmature, Ani_Def_Key.Ani_stand, 3/4, 0, 1.8)
end

local function UpdateLvUpLayer(  )
	UpdateLvUpData(GetCurGeneralGrid())
end

-- local function UpLevelOver()
-- 	NetWorkLoadingLayer.loadingHideNow()
-- 	UpdateLvUpData(GetCurGeneralGrid())
-- 	UpdateAttrText()
	-- local pro_01 = nil

	-- local function PlayOver()
	-- 	UpdateBaseData(m_nCurGrid)
	-- 	-- pro_01:setPercentage(0)
	-- end
	-- local pgBar = tolua.cast(m_plyGeneralLvUp:getWidgetByName("ProgressBar_80"), "LoadingBar")
	-- pro_01 = pgBar:getNodeByTag(200)
	-- if pro_01 == nil then
	-- 	pro_01 = CCProgressTimer:create(CCSprite:create("Image/wujiang/green_bar_update.png"))
	-- 	pro_01:setType(1)
	-- 	pro_01:setPercentage(0)
	-- 	pgBar:addNode(pro_01, 0, 200)
	-- end

	-- local to1 = CCProgressTo:create(0.3, 100)
	-- pro_01:setBarChangeRate(CCPointMake(1, 0))
	-- pro_01:setMidpoint(CCPointMake(0, 0))
	-- local actionArray1 = CCArray:create()
	-- actionArray1:addObject(to1)
	-- actionArray1:addObject(CCDelayTime:create(0.2))
	-- actionArray1:addObject(CCCallFuncN:create(PlayOver))
	-- pro_01:runAction(CCSequence:create(actionArray1))

-- end

local function GetSpecialAnimate(  )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local nPosX = scenetemp:getContentSize().width
	local nPosY = scenetemp:getContentSize().height
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/shengji_texiao/shengji_texiao.ExportJson", 
		"shengji_texiao", 
		"Animation2", 
		scenetemp, 
		ccp(nPosX/2, nPosY/2),
		nil,
		layerHeroUpgrade_tag)
end

local function _BtnLvUp5_CallBack( )
	if CheckNeed(m_nCurLv, 5)==false then
		return
	end
	local function UpLevelOver()
		NetWorkLoadingLayer.loadingHideNow()
		UpdateLvUpData(GetCurGeneralGrid())
		UpdateAttrText(5)
		GetSpecialAnimate()
		PlayGeneralAnimation(GetCurGeneralGrid(), m_plArmature, Ani_Def_Key.Ani_cheers, 3/4, 0, 1.8)
	end
	Packet_GeneralUpLevel.SetSuccessCallBack(UpLevelOver)
	network.NetWorkEvent(Packet_GeneralUpLevel.CreatPacket(GetCurGeneralGrid(), 5))
	NetWorkLoadingLayer.loadingShow(true)
end

function _BtnLvUp_CallBack( nCallBack )
	if CheckNeed(m_nCurLv, 1)==false then
		return
	end
	local function UpLevelOver()
		NetWorkLoadingLayer.loadingHideNow()
		UpdateLvUpData(GetCurGeneralGrid())
		UpdateAttrText(1)
		GetSpecialAnimate()
		PlayGeneralAnimation(GetCurGeneralGrid(), m_plArmature, Ani_Def_Key.Ani_cheers, 3/4, 0, 1.8)
		if nCallBack ~= nil then
			nCallBack()
		end
	end

	Packet_GeneralUpLevel.SetSuccessCallBack(UpLevelOver)
	if NewGuideManager.GetBGuide() == true then
		NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_7)
	else
		network.NetWorkEvent(Packet_GeneralUpLevel.CreatPacket(GetCurGeneralGrid(), 1))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function _Btn_Left_LvUp_CallBack( )
	SetCurGeneralIdx(-1)
	UpdateLvUpData(GetCurGeneralGrid())
	UpdateBtnsState(m_btnLeft, m_btnRight)
	PlayGeneralAnimation(GetCurGeneralGrid(), m_plArmature, Ani_Def_Key.Ani_stand, 3/4, 0, 1.8)
end

local function _Btn_Right_LvUp_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		SetCurGeneralIdx(1)
		UpdateLvUpData(GetCurGeneralGrid())
		UpdateBtnsState(m_btnLeft, m_btnRight)
		PlayGeneralAnimation(GetCurGeneralGrid(), m_plArmature, Ani_Def_Key.Ani_stand, 3/4, 0, 1.8)
	elseif eventType == TouchEventType.began then
		sender:setTouchEnabled(false)
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Panel_Armatrue_CallBack_( sender, eventType )
	if eventType == TouchEventType.ended then
		m_nAinIdx = m_nAinIdx+1
		if m_nAinIdx>=#m_tabAniKey then
			m_nAinIdx=1
		end
		PlayGeneralAnimation(GetCurGeneralGrid(), m_plArmature, m_tabAniKey[m_nAinIdx],  3/4, 0, 1.8)
	end
end

local  function InitWidgets( )
	local pBtnLianHua = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Button_LianHua"), "Button")
	if pBtnLianHua==nil then
		print("pBtnLianHua is nil")
		return false
	else
		CreateBtnCallBack(pBtnLianHua, "炼化将魂", 36, _BtnLianHua_CallBack)
		pBtnLianHua:setEnabled(false)
	end

	m_plArmature = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Panel_Armature"), "Layout")
	if m_plArmature==nil  then
		print(" m_plArmature is nil")
		return false
	else
		m_plArmature:setTouchEnabled(true)
		m_plArmature:addTouchEventListener(_Panel_Armatrue_CallBack_)
	end

	local pBtnLv5 = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Button_Lv5"), "Button")
	if pBtnLv5==nil then
		print("pBtnLv5 is nil")
		return false
	else
		CreateBtnCallBack(pBtnLv5, "连升5级", 36, _BtnLvUp5_CallBack)
	end

	local pBtnLvUp = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Button_Lv"), "Button")
	if pBtnLvUp==nil then
		print("pBtnLvUp is nil")
		return false
	else
		CreateBtnCallBack(pBtnLvUp, "升级", 36, _BtnLvUp_CallBack)
	end

	local plbName = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Label_Name"), "Label")
	if plbName==nil then
		print("plbName is nil")
		return false
	else
		plbName:setFontName(CommonData.g_FONT1)
	end
	local pDanYaoBg = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Image_DanYao"), "ImageView")
	if pDanYaoBg==nil then
		print("pDanYaoBg is nil")
		return false
	else
		m_lbDanYao = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "凝神成丹", ccp(0, 0), ccc3(57,25,15), ccc3(250,255,118), true, ccp(0, -2), 2)
		pDanYaoBg:addChild(m_lbDanYao)
	end

	local  m_pgBar = tolua.cast(m_plyGeneralLvUp:getWidgetByName("ProgressBar_80"), "LoadingBar")
	if m_pgBar==nil then
		print("m_pgBar is nil")
		return false
	else
		m_lbExpPool = LabelLayer.createStrokeLabel(20, "Thonburi", "10/1000", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		m_pgBar:addChild(m_lbExpPool)
		m_pgBar:setPercent(0)
	end

	m_btnRight = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Button_Right"), "Button")
	if m_btnRight==nil then
		print("m_btnRight is nil")
		return false
	else
		--CreateBtnCallBack(m_btnRight, nil, nil, _Btn_Right_LvUp_CallBack)
		m_btnRight:addTouchEventListener( _Btn_Right_LvUp_CallBack )
	end

	m_btnLeft = tolua.cast(m_plyGeneralLvUp:getWidgetByName("Button_Left"), "Button")
	if m_btnLeft==nil then
		print("m_btnLeft is nil")
		return false
	else
		CreateBtnCallBack(m_btnLeft, nil, nil, _Btn_Left_LvUp_CallBack)
	end

	return true
end

function CreateGeneralLvUpLayer( nGrid )
	InitVars( )
	m_plyGeneralLvUp = TouchGroup:create()
	m_plyGeneralLvUp:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangLvUpLayer.json" ) )
	if InitWidgets()==false then
		return
	end
	MainScene.GetObserver():RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_LEVEL_UP,UpdateLvUpLayer)
	UpdateLvUpData(nGrid)
	return m_plyGeneralLvUp
end