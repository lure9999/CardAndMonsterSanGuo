require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/DungeonBaseUILogic"
require "Script/Main/Dungeon/DungeonLogic"

module("ActivitySelectLayer", package.seeall)

local GetPointId					= DungeonBaseData.GetPointId
local GetPointRuleId				= DungeonBaseData.GetPointRuleId
local GetNeedLv						= DungeonBaseData.GetNeedLv
local IsEnoughLv					= DungeonLogic.IsEnoughLv
local CheckPremiseId 				= DungeonLogic.CheckPremiseId

local GetSceneId					= DungeonBaseData.GetSceneId
local GetSceneType					= DungeonBaseData.GetSceneType
local GetSceneRuleId				= DungeonBaseData.GetSceneRuleId
local GetTimes 						= DungeonBaseData.GetTimes
local GetPremiseId					= DungeonBaseData.GetPremiseID
local IsEnoughTimes					= DungeonLogic.IsEnoughTimes
local GetPointLeftTimes				= server_fubenDB.GetPointLeftTimes

local GetActivityIdxBySceneId		= server_fubenDB.GetActivityIdxBySceneId
local GetPointId 					= DungeonBaseData.GetPointId
local GetPointRuleId				= DungeonBaseData.GetPointRuleId
local GetNeedTiLi					= DungeonBaseData.GetNeedTiLi
local IsEnoughTiLi					= DungeonLogic.IsEnoughTiLi

local GetActivityMapName			= DungeonBaseData.GetActivityMapName
local GetSceneIndex					= DungeonBaseData.GetSceneIndex
local GetActivityTimes				= DungeonBaseData.GetActivityTimes

local _Point_Click_CallBack_		= DungeonBaseUILogic._Point_Click_CallBack_

local m_pLayerActivitySelect = nil
local m_funUpdateCallBack = nil
local m_pImageLvs = {}
local m_nSceneIdx = nil

local function InitVars(  )
	m_pLayerActivitySelect = nil
	m_pImageLvs = {}
	m_nSceneIdx=nil
	m_funUpdateCallBack = nil
end

ErrorCode =
{
	Success				= 0,
	NotEnoughLv 		= 1,
	NotEnoughTiLi 		= 2,
	NotEnoughTimes 		= 3,
	NotEnoughFamilyLv 	= 4,
	WrongWeekDay		= 5,
	PremiseError		= 6,
	CoolDown			= 7
}

local  function _Btn_Close_ActivitySelect_CallBack( sender, eventType )
	if eventType==TouchEventType.began then
		AudioUtil.PlayBtnClick()
	end
	m_pLayerActivitySelect:removeFromParentAndCleanup(true)
	InitVars()
end

local function _Image_LevelSelect_CallBack( sender, eventType )
	local Image_Bg = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Image_3"), "ImageView")
	if Image_Bg:getNodeByTag(1990) ~= nil then
		Image_Bg:getNodeByTag(1990):removeFromParentAndCleanup(true)
	end
	_Point_Click_CallBack_(sender, eventType, nil, m_nSceneIdx)
end

local function UpdateActivityData( nIdx )
	local nPointId = GetPointId(m_nSceneIdx, nIdx)
	local nRuleId = GetPointRuleId(nPointId)
	local nNeedLv = GetNeedLv(nRuleId)
	local pImageIcon = tolua.cast(m_pImageLvs[nIdx]:getChildByName("Image_Icon"), "ImageView")
	local pLabelLv = tolua.cast(m_pImageLvs[nIdx]:getChildByName("Label_NeedLv"), "Label")
	local pLabel = tolua.cast(m_pImageLvs[nIdx]:getChildByName("Label_22"), "Label")
	local pLabel_23 = tolua.cast(m_pImageLvs[nIdx]:getChildByName("Label_23"), "Label")
	local nSceneId = GetSceneId(m_nSceneIdx)	
	local nErrorCode = DungeonLogic.IsCanFight(nSceneId, m_nSceneIdx, nIdx, DungeonsType.Activity)

	--等级满足并且前置通关
	local function GetIsOpen(  )
		local bOpen = false

		if IsEnoughLv(nNeedLv) == true and CheckPremiseId(GetPremiseId(nRuleId)) == true then
			bOpen = true
		end

		return bOpen
	end

	if GetIsOpen() == true then
		pLabelLv:setVisible(false)
		pLabel:setVisible(false)
		pLabel_23:setVisible(false)
		m_pImageLvs[nIdx]:setTouchEnabled(true)
		pImageIcon:loadTexture("Image/imgres/activity/unlock_level_"..nIdx..".png")
	else
		pLabelLv:setVisible(true)
		pLabel:setVisible(true)
		pLabel_23:setVisible(true)
		m_pImageLvs[nIdx]:setTouchEnabled(false)
		pLabelLv:setText(tostring(nNeedLv))
		pImageIcon:loadTexture("Image/imgres/activity/locked_level_"..nIdx..".png")
	end
end

function UpdateLayerInfo( )
	for i=1, 8 do
		UpdateActivityData(i)
	end

	-- 更新次数
	local pLabelTimes = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Label_Times"), "Label")
	local nSceneId = nil
	if pLabelTimes~=nil then
		nSceneId = GetSceneId(m_nSceneIdx)		
		local nSceneType = GetSceneType(m_nSceneIdx)
		local nSceneRuleId = GetSceneRuleId(m_nSceneIdx)
		local nTimes = GetActivityTimes()
		local nLeftTimes =nTimes - GetPointLeftTimes(nSceneType, nSceneId, nil)
		pLabelTimes:setText(tostring(nLeftTimes).."/"..tostring(nTimes))
		if IsEnoughTimes(nTimes, nSceneId, nil)==true then
			pLabelTimes:setColor(ccc3(99,216,53))
		else
			pLabelTimes:setColor(ccc3(255,87,35))
		end
	end	
	-- 更新体力
	local nPointIdx = GetActivityIdxBySceneId(nSceneId)
	local pLabelTiLi = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Label_CostTili"), "Label")
	local nCostTiLi = 0	
		
	if nPointIdx==0 then
		nCostTiLi = 0
	else
		local nPointId = GetPointId(m_nSceneIdx, nPointIdx)
		local nPointRuleId = GetPointRuleId(nPointId)
		--print(m_nSceneIdx, nPointIdx, nPointId, nPointRuleId, GetNeedTiLi(nPointRuleId))
		--Pause()
		nCostTiLi = GetNeedTiLi(nPointRuleId)		
	end
	
	pLabelTiLi:setText(tostring(nCostTiLi))
	if IsEnoughTiLi(nCostTiLi)==true then
		pLabelTiLi:setColor(ccc3(99,216,53))
	else
		pLabelTiLi:setColor(ccc3(255,87,35))
	end

	if m_funUpdateCallBack~=nil then
		m_funUpdateCallBack()
	end
end

function UpdateLeftTimesFull(  )
	-- 将剩余次数置满
	local pLabelTimes = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Label_Times"), "Label")
	if pLabelTimes ~= nil then
		local nLeftTimes = GetActivityTimes()
		pLabelTimes:setText(tostring(nLeftTimes).."/"..GetActivityTimes())
		pLabelTimes:setColor(ccc3(99,216,53))
	end
end

local function InitWidgtes()
	m_pLayerActivitySelect = TouchGroup:create()
	m_pLayerActivitySelect:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/ActivitySelectLayer.json"))
	if m_pLayerActivitySelect==nil then
		print("m_pLayerActivitySelect is nil")
		return false
	end

	local pBtnClose = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Button_Close"), "Button")
	if pBtnClose==nil then
		print("pBtnClose is nil")
		return false
	else
		CreateBtnCallBack(pBtnClose, nil, nil, _Btn_Close_ActivitySelect_CallBack)
	end

	local Image_17 = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Image_17"), "ImageView")
	local pTitleLabel = LabelLayer.createStrokeLabel(26, CommonData.g_FONT3, "选择难度", ccp(0, 0), COLOR_Black, ccc3(239,193,55), true, ccp(0, 0), 3)
	Image_17:addChild(pTitleLabel)

	for i=1, 8 do
		m_pImageLvs[i] = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Image_Level_"..tostring(i)), "ImageView")
		if m_pImageLvs[i]==nil then
			print("m_pImageLvs_"..i.." is nil")
			return false
		else
			local pLabelLv = tolua.cast(m_pImageLvs[i]:getChildByName("Label_NeedLv"), "Label")
			local pLabel = tolua.cast(m_pImageLvs[i]:getChildByName("Label_22"), "Label")
			local pLabel_23 = tolua.cast(m_pImageLvs[i]:getChildByName("Label_23"), "Label")
			pLabelLv:setFontName(CommonData.g_FONT1)
			pLabel:setFontName(CommonData.g_FONT1)
			pLabel_23:setFontName(CommonData.g_FONT1)
			m_pImageLvs[i]:setTag(i)
			m_pImageLvs[i]:addTouchEventListener(_Image_LevelSelect_CallBack)
		end
	end
end

function GoToManagerCallFuncByActivitySelect( nPointIdx )

	--[[local Image_Bg = tolua.cast(m_pLayerActivitySelect:getWidgetByName("Image_3"), "ImageView")

	--指引点击效果
	if Image_Bg:getNodeByTag(1990) ~= nil then
		Image_Bg:getNodeByTag(1990):removeFromParentAndCleanup(true)
	end

    local GuideAnimation = CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/zhiyin01.ExportJson")
	GuideAnimation = CCArmature:create("zhiyin01")
	GuideAnimation:getAnimation():play("Animation1")

	--获取战役关卡坐标

	local _PIndex = tonumber(nPointIdx)

	GuideAnimation:setPosition(ccp(m_pImageLvs[_PIndex]:getPositionX(), m_pImageLvs[_PIndex]:getPositionY()))

	Image_Bg:addNode(GuideAnimation, 1990, 1990)]]

end

function CreateActivitySelectLayer( nSceneIdx, funUpdateCallBack )
	Log("nSceneIdx = "..nSceneIdx)
	if InitWidgtes()==false then
		print("InitWidgtes failed...")
		return
	end
	m_funUpdateCallBack = funUpdateCallBack
	m_nSceneIdx = nSceneIdx
	UpdateLayerInfo()
	return m_pLayerActivitySelect
end