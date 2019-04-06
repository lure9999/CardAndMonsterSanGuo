require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/serverDB/server_generalDB"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralBaseUILogic"
require "Script/Main/Wujiang/GeneralLvUpLayer"
require "Script/Main/Wujiang/GeneralJobLayer"
require "Script/Main/Wujiang/GeneralDanYaoLayer"
require "Script/Main/Wujiang/GeneralFateLayer"
module("GeneralTrainLayer", package.seeall)

local m_plyGeneralTrain = nil
local m_chbUpdate = nil
local m_chbDanYao = nil
local m_chbFate = nil
local m_chbCur = nil

local m_pLayerLvUp 		= nil
local m_pLayerDanYao 	= nil
local m_pLayerFate		= nil

local GetCurGeneralGrid				= GeneralBaseUILogic.GetCurGeneralGrid
local HandleTrainLayer				= GeneralBaseUILogic.HandleLayerEnabled
local HandleCheckBoxFont			= GeneralBaseUILogic.HandleCheckBoxFont
local CreateCheckBoxLabel			= GeneralBaseUILogic.CreateCheckBoxLabel
local IsMainGeneral					= server_generalDB.IsMainGeneral

local UpdateJobListView				= GeneralJobLayer.UpdateJobListView
local UpdateLvUpData				= GeneralLvUpLayer.UpdateLvUpData
local UpdateDanYaoData				= GeneralDanYaoLayer.UpdateDanYaoData
local UpdateFateData				= GeneralFateLayer.UpdateFateData

local function InitVars( )
	m_plyGeneralTrain = nil
	m_chbUpdate = nil
	m_chbDanYao = nil
	m_chbFate = nil
	m_chbCur = nil
	m_pLayerLvUp = nil
	m_pLayerDanYao 	= nil
	m_pLayerFate = nil
end

local function ChangeCheckBoxFont( curCheckBox )
	if curCheckBox:getTag()==m_chbUpdate:getTag() then

		HandleCheckBoxFont(m_chbUpdate, m_chbDanYao, m_chbFate)
	elseif curCheckBox:getTag()==m_chbDanYao:getTag() then

		HandleCheckBoxFont(m_chbDanYao, m_chbUpdate, m_chbFate)
	elseif curCheckBox:getTag()==m_chbFate:getTag() then

		HandleCheckBoxFont(m_chbFate, m_chbUpdate, m_chbDanYao)
	end
end

local function ToggleBackGround( bVisible )
	local pImgCould = tolua.cast(m_plyGeneralTrain:getWidgetByName("Image_Cloud"), "ImageView")
	pImgCould:setVisible(bVisible)

	local pImgBg = tolua.cast(m_plyGeneralTrain:getWidgetByName("Image_Bg"), "ImageView")
	pImgBg:setVisible(bVisible)

	local pImgBgUp = tolua.cast(m_plyGeneralTrain:getWidgetByName("Image_BgUp"), "ImageView")
	pImgBgUp:setVisible(bVisible)
end

local  function ChangeTrainType( curCheckBox )
	local nGrid = GetCurGeneralGrid()
	if curCheckBox:getTag()==m_chbUpdate:getTag() then
		if m_pLayerLvUp == nil then
			if IsMainGeneral(GetCurGeneralGrid())==false then
				m_pLayerLvUp =  GeneralLvUpLayer.CreateGeneralLvUpLayer(nGrid)
				MainScene.ChangeInfoBarState(InfoBarType.Main)
				ToggleBackGround(true)
			else
				m_pLayerLvUp =  GeneralJobLayer.CreateGeneralJobLayer(nGrid)
				ToggleBackGround(false)
				MainScene.ChangeInfoBarState(InfoBarType.XingHun)
			end
			m_plyGeneralTrain:addChild(m_pLayerLvUp, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
		else
			if IsMainGeneral(nGrid)==false then
				UpdateLvUpData(nGrid)
				MainScene.ChangeInfoBarState(InfoBarType.Main)
				ToggleBackGround(true)
			else
				UpdateJobListView()
				ToggleBackGround(false)
				MainScene.ChangeInfoBarState(InfoBarType.XingHun)
			end
		end
		HandleTrainLayer(m_pLayerLvUp, m_pLayerDanYao, m_pLayerFate)
	elseif curCheckBox:getTag()==m_chbDanYao:getTag() then
		local tabDanYao = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_23)
		if tabDanYao~=nil then
			if tonumber(tabDanYao.vipLimit) == 0 then
				if m_chbCur~=curCheckBox then
					m_chbCur:setSelectedState(true)
					m_chbCur = curCheckBox
					ChangeCheckBoxFont(m_chbCur)
					ChangeTrainType(m_chbCur)
				end
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1643,nil,"武将丹药",tonumber(tabDanYao.level))
				pTips = nil
				return 
			else
				if m_pLayerDanYao == nil then
					m_pLayerDanYao = GeneralDanYaoLayer.CreateGeneralDanYaoLayer(nGrid)
					m_plyGeneralTrain:addChild(m_pLayerDanYao, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
				else
					UpdateDanYaoData(nGrid)
				end
				HandleTrainLayer(m_pLayerDanYao, m_pLayerLvUp, m_pLayerFate)
				MainScene.ChangeInfoBarState(InfoBarType.Main)
				ToggleBackGround(true)
			end
		else
			if m_pLayerDanYao == nil then
				m_pLayerDanYao = GeneralDanYaoLayer.CreateGeneralDanYaoLayer(nGrid)
				m_plyGeneralTrain:addChild(m_pLayerDanYao, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
			else
				UpdateDanYaoData(nGrid)
			end
			HandleTrainLayer(m_pLayerDanYao, m_pLayerLvUp, m_pLayerFate)
			MainScene.ChangeInfoBarState(InfoBarType.Main)
			ToggleBackGround(true)
		end
	elseif curCheckBox:getTag()==m_chbFate:getTag() then
		local tabFate = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_24)
		if tabFate~=nil then
			if tonumber(tabFate.vipLimit) == 0 then
				if m_chbCur~=curCheckBox then
					m_chbCur:setSelectedState(true)
					m_chbCur = curCheckBox
					ChangeCheckBoxFont(m_chbCur)
					ChangeTrainType(m_chbCur)
				end
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1643,nil,"武将天命",tonumber(tabFate.level))
				pTips = nil
				return 
			else
				if m_pLayerFate == nil then
					m_pLayerFate = GeneralFateLayer.CreateGeneralFateLayer(nGrid)
					m_plyGeneralTrain:addChild(m_pLayerFate, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
				else
					UpdateFateData(nGrid)
				end
				HandleTrainLayer(m_pLayerFate, m_pLayerLvUp, m_pLayerDanYao)
				MainScene.ChangeInfoBarState(InfoBarType.Main)
				ToggleBackGround(true)
			end
		else
			if m_pLayerFate == nil then
				m_pLayerFate = GeneralFateLayer.CreateGeneralFateLayer(nGrid)
				m_plyGeneralTrain:addChild(m_pLayerFate, layerWujiangUpdate_Tag, layerWujiangUpdate_Tag)
			else
				UpdateFateData(nGrid)
			end
			HandleTrainLayer(m_pLayerFate, m_pLayerLvUp, m_pLayerDanYao)
			MainScene.ChangeInfoBarState(InfoBarType.Main)
			ToggleBackGround(true)
		end
	end
end

local function _CheckBox_GeneralTrain__CallBack(sender, eventType)
	-- 获取当前点击的CheckBox
	local curCheckBox = tolua.cast(sender,"CheckBox")
	if eventType == CheckBoxEventType.selected then
		if m_chbCur~=curCheckBox then
			m_chbCur:setSelectedState(false)
			m_chbCur = curCheckBox
			ChangeCheckBoxFont(m_chbCur)
			ChangeTrainType(m_chbCur)
		end
	else
		if curCheckBox:getSelectedState() == false then
			curCheckBox:setSelectedState(true)
			if m_chbCur==nil then
				m_chbCur = curCheckBox
				ChangeCheckBoxFont(m_chbCur)
				ChangeTrainType(m_chbCur)
			end
		end
	end
end

function UpdateTrainData(  )
	ChangeTrainType(m_chbCur)
end

local function InitOptCheckBoxInfo(nGrid)
	if IsMainGeneral(nGrid)==true then
		CreateCheckBoxLabel(m_chbUpdate, "职    业", 0, 11)
	else
		CreateCheckBoxLabel(m_chbUpdate, "升    级", 0, 11)
	end
	CreateCheckBoxLabel(m_chbDanYao, "丹    药", 0, 11)
	CreateCheckBoxLabel(m_chbFate, "天    命", 0, 11)
	_CheckBox_GeneralTrain__CallBack(m_chbUpdate, CheckBoxEventType.unselected)
end

function UpdateTrainLayerState(  )
	if m_plyGeneralTrain~=nil and m_plyGeneralTrain:isVisible()==false then
		if m_pLayerFate~=nil then
			m_pLayerFate:setVisible(false)
			m_pLayerFate:setTouchEnabled(false)
		end

		if m_pLayerLvUp~=nil then
			m_pLayerLvUp:setVisible(false)
			m_pLayerLvUp:setTouchEnabled(false)
		end

		if m_pLayerDanYao~=nil then
			m_pLayerDanYao:setVisible(false)
			m_pLayerDanYao:setTouchEnabled(false)
		end
	else
		_CheckBox_GeneralTrain__CallBack(m_chbCur, CheckBoxEventType.unselected)
	end
end

local function InitWidgets(  )

	m_chbUpdate = tolua.cast(m_plyGeneralTrain:getWidgetByName("box_update"), "CheckBox")
	if m_chbUpdate==nil then
		print("m_chbUpdate is nil")
		return false
	else
		m_chbUpdate:addEventListenerCheckBox(_CheckBox_GeneralTrain__CallBack)
	end

	m_chbDanYao = tolua.cast(m_plyGeneralTrain:getWidgetByName("box_danyao"), "CheckBox")
	if m_chbDanYao==nil then
		print("m_chbDanYao is nil")
		return false
	else
		m_chbDanYao:addEventListenerCheckBox(_CheckBox_GeneralTrain__CallBack)
	end

	m_chbFate = tolua.cast(m_plyGeneralTrain:getWidgetByName("box_tm"), "CheckBox")
	if m_chbFate==nil then
		print("m_chbFate is nil")
		return false
	else
		m_chbFate:addEventListenerCheckBox(_CheckBox_GeneralTrain__CallBack)
	end

	return true
end

function CreateGeneralTrainLayer( nGrid )
	InitVars()
	m_plyGeneralTrain = TouchGroup:create()
	m_plyGeneralTrain:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangTrainLayer.json" ) )
	if InitWidgets()==false then
		return
	end

	InitOptCheckBoxInfo(nGrid)
	return m_plyGeneralTrain
end