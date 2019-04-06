require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralTrainLayer"
require "Script/Main/Wujiang/GeneralRelationLayer"
require "Script/Main/Wujiang/GeneralAttrLayer"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralBaseUILogic"

module("GeneralOptLayer", package.seeall)

local m_plyGeneralOpt = nil
local m_btnBack = nil

local m_chbTrain = nil
local m_chbRelation = nil
local m_chbAttr = nil
local m_chbCur = nil
local m_TouchClick = nil

local pLayerTrain 		= nil
local pLayerRelation 	= nil
local pLayerAttr 		= nil

local m_funcCallBack 	= nil
local m_nPos = nil
local m_nType = nil

local InitGeneralOptData			= GeneralBaseUILogic.InitGeneralOptData
local GetCurGeneralGrid				= GeneralBaseUILogic.GetCurGeneralGrid
local HandleOptLayer				= GeneralBaseUILogic.HandleLayerEnabled
local HandleCheckBoxFont			= GeneralBaseUILogic.HandleCheckBoxFont
local CreateCheckBoxLabel			= GeneralBaseUILogic.CreateCheckBoxLabel

local UpdataAttrData				= GeneralAttrLayer.UpdataAttrData
local UpdateRelationData			= GeneralRelationLayer.UpdateRelationData
local UpdateTrainData				= GeneralTrainLayer.UpdateTrainData

local GetGeneralTypeByGrid			= GeneralBaseData.GetGeneralTypeByGrid
local GetGeneralPosByGrid			= GeneralBaseData.GetGeneralPosByGrid

local IsMainGeneral					= server_generalDB.IsMainGeneral

local function InitVars( )
	m_plyGeneralOpt = nil
	pLayerTrain 	= nil
	pLayerRelation 	= nil
	pLayerAttr 		= nil
	m_plBaseInfo = nil
	m_btnBack = nil
	m_chbTrain = nil
	m_chbRelation = nil
	m_chbAttr = nil
	m_chbCur = nil
	m_funcCallBack 	= nil
	m_nPos = nil
	m_nType = nil
	m_TouchClick = nil
end

function ExitOptLayer( nCallBack )
	local nGrid = GetCurGeneralGrid()
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_ZhuJiang_PeiYang)
	-- if GeneralListLayer.GetUIControl()~=nil then
		if m_funcCallBack~=nil and type(m_funcCallBack)=="function" then
			m_funcCallBack(m_nType, m_nPos)
		end
	-- end
	if IsMainGeneral(nGrid) then
		MainScene.ChangeInfoBarState(InfoBarType.Main)
	end
	MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_LEVEL_UP)
	m_plyGeneralOpt:removeFromParentAndCleanup(true)
	InitVars()
	MainScene.PopUILayer()
	if nCallBack ~= nil then
		nCallBack()
	end
end

local function _Btn_Back_Operate_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		m_btnBack:setScale(1)
		local pBarManager = MainScene.GetBarManager()
		pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_ZhuJiang_PeiYang) 

		local nGrid = GetCurGeneralGrid()
		-- if GeneralListLayer.GetUIControl()~=nil then
			if m_funcCallBack~=nil and type(m_funcCallBack)=="function" then
				m_funcCallBack(m_nType, m_nPos)
			end
		-- end
		if IsMainGeneral(nGrid) then
			MainScene.ChangeInfoBarState(InfoBarType.Main)
		end
		

		MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_LEVEL_UP)
		m_plyGeneralOpt:removeFromParentAndCleanup(true)
		InitVars()
		MainScene.PopUILayer()
	elseif  eventType == TouchEventType.began then
		m_btnBack:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		m_btnBack:setScale(1.0)
	end
end

local function ChangeBottomBg( bVisible )
	local pImgFlower = tolua.cast(m_plyGeneralOpt:getWidgetByName("Image_8"), "ImageView")
	local pImgBar = tolua.cast(m_plyGeneralOpt:getWidgetByName("Image_9"), "ImageView")

	pImgFlower:setVisible(bVisible)
	pImgBar:setVisible(not bVisible)
end

local function HandldMainBtnLayer( pLayer )
	require "Script/Main/MainBtnLayer"
	local pMainBtnLayer=pLayer:getChildByTag(layerMainBtn_Tag)
	if pMainBtnLayer~=nil then
		pMainBtnLayer:removeFromParentAndCleanup(true)
	end
    pMainBtnLayer = MainBtnLayer.createMainBtnLayer()
    pLayer:addChild(pMainBtnLayer, layerMainBtn_Tag, layerMainBtn_Tag)
end

local function ChangeOptType( curChb )
	local nGrid = GetCurGeneralGrid()
	if IsMainGeneral(nGrid) then
		MainScene.ChangeInfoBarState(InfoBarType.Main)
	end
	if curChb:getTag()==m_chbTrain:getTag() then
		if pLayerTrain==nil then
			pLayerTrain = GeneralTrainLayer.CreateGeneralTrainLayer(nGrid)
			m_plyGeneralOpt:addChild(pLayerTrain, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
		else
			UpdateTrainData()
		end
		HandleOptLayer(pLayerTrain, pLayerRelation, pLayerAttr)
		ChangeBottomBg(false)
	elseif curChb:getTag()==m_chbRelation:getTag() then
		if pLayerRelation==nil then
			pLayerRelation = GeneralRelationLayer.CreateGeneralRelationLayer(nGrid)
			m_plyGeneralOpt:addChild(pLayerRelation, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
		else
			UpdateRelationData(nGrid)
		end
		HandleOptLayer(pLayerRelation, pLayerTrain, pLayerAttr)
		ChangeBottomBg(true)
	elseif curChb:getTag()== m_chbAttr:getTag() then
		HandleOptLayer(plyAttr, pLayerTrain, pLayerRelation)
		if pLayerAttr==nil then
			pLayerAttr = GeneralAttrLayer.CreateGeneralAttrLayer(nGrid)
			m_plyGeneralOpt:addChild(pLayerAttr, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
		else
			UpdataAttrData(nGrid)
		end
		HandleOptLayer(pLayerAttr, pLayerTrain, pLayerRelation)
		ChangeBottomBg(true)
	end
	if pLayerTrain~=nil then
		GeneralTrainLayer.UpdateTrainLayerState()
	end
   	HandldMainBtnLayer(m_plyGeneralOpt)
end

local function ChangeCheckBoxFont( curCheckBox )
	if curCheckBox:getTag()==m_chbTrain:getTag() then

		HandleCheckBoxFont(m_chbTrain, m_chbRelation, m_chbAttr)
	elseif curCheckBox:getTag()==m_chbRelation:getTag() then

		HandleCheckBoxFont(m_chbRelation, m_chbTrain, m_chbAttr)
	elseif curCheckBox:getTag()==m_chbAttr:getTag() then

		HandleCheckBoxFont(m_chbAttr, m_chbTrain, m_chbRelation)
	end
end

-- CheckBox回调
local function _CheckBox_GeneralOpt__CallBack(sender, eventType)
	-- 获取当前点击的CheckBox
	local curCheckBox = tolua.cast(sender,"CheckBox")
	if eventType == CheckBoxEventType.selected then
		if m_chbCur~=curCheckBox then
			m_chbCur:setSelectedState(false)
			m_chbCur = curCheckBox
			ChangeCheckBoxFont(m_chbCur)
			ChangeOptType(m_chbCur)
		end
	else
		if curCheckBox:getSelectedState() == false then
			curCheckBox:setSelectedState(true)
			if m_chbCur==nil then
				m_chbCur = curCheckBox
				ChangeCheckBoxFont(m_chbCur)
				ChangeOptType(m_chbCur)
			end
		end
	end
end

local function InitOptCheckBoxInfo(nGrid)
	CreateCheckBoxLabel(m_chbTrain, "培养", 12, 0)
	CreateCheckBoxLabel(m_chbRelation, "缘分", 12, 0)
	CreateCheckBoxLabel(m_chbAttr, "属性", 12, 0)
	if GetGeneralTypeByGrid(nGrid)==GeneralType.HuFa then
		_CheckBox_GeneralOpt__CallBack(m_chbAttr, CheckBoxEventType.unselected)
		m_chbAttr:setPosition(ccp(m_chbTrain:getPositionX(), m_chbTrain:getPositionY()))
		m_chbTrain:setVisible(false)
		m_chbTrain:setTouchEnabled(false)
		m_chbRelation:setVisible(false)
		m_chbRelation:setTouchEnabled(false)
	else
		_CheckBox_GeneralOpt__CallBack(m_chbTrain, CheckBoxEventType.unselected)
	end
end

local function InitWidgets()
	m_btnBack = tolua.cast(m_plyGeneralOpt:getWidgetByName("btn_back"),"Button")
	if m_btnBack==nil then
		print("m_btnBack is nil")
		return false
	else
		m_btnBack:addTouchEventListener(_Btn_Back_Operate_CallBack)
	end

	m_chbTrain = tolua.cast(m_plyGeneralOpt:getWidgetByName("box_py"), "CheckBox")
	if m_chbTrain==nil then
		print("m_chbTrain is nil")
		return false
	else
		m_chbTrain:addEventListenerCheckBox(_CheckBox_GeneralOpt__CallBack)
	end

	m_chbRelation = tolua.cast(m_plyGeneralOpt:getWidgetByName("box_yf"), "CheckBox")
	if m_chbRelation==nil then
		print("m_chbRelation is nil")
		return false
	else
		m_chbRelation:addEventListenerCheckBox(_CheckBox_GeneralOpt__CallBack)
	end

	m_chbAttr = tolua.cast(m_plyGeneralOpt:getWidgetByName("box_attr"), "CheckBox")
	if m_chbAttr==nil then
		print("m_chbAttr is nil")
		return false
	else
		m_chbAttr:addEventListenerCheckBox(_CheckBox_GeneralOpt__CallBack)
	end

	return true
end

function InsertMask()
	local function _Click_TouchMask_CallFunc( sender, eventType )
		if eventType==TouchEventType.ended then
		print("触摸屏蔽了")
		end
	end

	m_TouchClick = TouchGroup:create()
	local pLayer = Layout:create()
	pLayer:setName("AniLayer")
	pLayer:setSize(CCSize(1140, 640))
	pLayer:setContentSize(CCSizeMake(1140, 640))
	pLayer:setTouchEnabled(true)
	pLayer:setZOrder(9999)
	pLayer:setTag(1666)
	m_TouchClick:addWidget( pLayer )
	m_TouchClick:setTouchPriority(-129)
	pLayer:addTouchEventListener(_Click_TouchMask_CallFunc)

	m_plyGeneralOpt:addChild(m_TouchClick)
end

function MaskDrop()
	if m_TouchClick ~=nil then
		m_TouchClick:removeFromParentAndCleanup(true)
		m_TouchClick = nil
	end
end

function CreateGeneralOptLayer( nGrid, nType, nPos, funcCallBack ,nClickType)
	InitVars()
	m_plyGeneralOpt = TouchGroup:create()
	m_plyGeneralOpt:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangOperateLayer.json" ) )
	if InitWidgets()==false then
		return
	end
	m_funcCallBack = funcCallBack
	m_nType = nType
	m_nPos = nPos
	InitGeneralOptData(nGrid, nPos,nClickType)
	InitOptCheckBoxInfo(nGrid)

	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		pBarManager:Create(m_plyGeneralOpt,CoinInfoBarManager.EnumLayerType.EnumLayerType_ZhuJiang_PeiYang) --EnumLayerType_Biwu
	end

	return m_plyGeneralOpt
end

function GetUIControl(  )
	return m_plyGeneralOpt
end
