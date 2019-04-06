require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Dungeon/ActivitySelectLayer"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/DungeonLogic"
module("ActivityLayer", package.seeall)

local GetMapName					= DungeonBaseData.GetMapName
local GetSceneId					= DungeonBaseData.GetSceneId
local GetSceneType					= DungeonBaseData.GetSceneType
local GetSceneRuleId				= DungeonBaseData.GetSceneRuleId
local GetTimes 						= DungeonBaseData.GetTimes
local IsEnoughTimes					= DungeonLogic.IsEnoughTimes
local GetPointLeftTimes				= server_fubenDB.GetPointLeftTimes
local GetActivityIdxBySceneId		= server_fubenDB.GetActivityIdxBySceneId
local GetPointId 					= DungeonBaseData.GetPointId
local GetPointRuleId				= DungeonBaseData.GetPointRuleId
local GetNeedTiLi					= DungeonBaseData.GetNeedTiLi
local GetActivityMapName			= DungeonBaseData.GetActivityMapName
local GetSceneIndex					= DungeonBaseData.GetSceneIndex
local GetActivityTimes				= DungeonBaseData.GetActivityTimes
local IsEnoughTiLi					= DungeonLogic.IsEnoughTiLi
local IsRightWeekDay				= DungeonLogic.IsRightWeekDay
local CheckIsOpen					= DungeonLogic.CheckIsOpen
local GetOpenRuleStr				= DungeonLogic.GetOpenRuleStr

local m_pLayerActivity = nil
local m_tabImageAct = {}

local function InitVars()
	m_pLayerActivity = nil
	m_tabImageAct = {}
end

local ActType =
			{
				Sliver		= 16,
				Exp			= 17,
				Equip		= 18,
				Treasure	= 19
			}

local tabActivityIdx ={ActType.Exp, ActType.Sliver, ActType.Equip, ActType.Treasure}

local function UpdateLeftTimes( pImageAct, nActType, nIndex )
	if pImageAct==nil then
		print("strName".." is nil")
		return
	else
		local nSceneIdx = GetSceneIndex(nIndex+1)
		local nSceneId = GetSceneId(nSceneIdx)
		local nSceneType = GetSceneType(nSceneIdx)
		local nSceneRuleId = GetSceneRuleId(nSceneIdx)
		--local nTimes = GetTimes(nSceneRuleId)
		local nTimes = GetActivityTimes()
		local nLeftTimes =nTimes - GetPointLeftTimes(nSceneType, nSceneId, nil)
		local pLabelTimes = tolua.cast(pImageAct:getChildByName("Label_Times"), "Label")
		pLabelTimes:setText(tostring(nLeftTimes).."/"..tostring(nTimes))
		if IsEnoughTimes(nTimes, nSceneId, nil)==true then
			pLabelTimes:setColor(ccc3(99,216,53))
		else
			pLabelTimes:setColor(ccc3(255,87,35))
		end
	end
end

function UpdateLeftTimesFull(  )
	-- 将剩余次数置满
	local function Update( pImageAct )
		local pLabelTimes = tolua.cast(pImageAct:getChildByName("Label_Times"), "Label")
		if pLabelTimes ~= nil then
			local nLeftTimes = GetActivityTimes()
			pLabelTimes:setText(tostring(nLeftTimes).."/"..GetActivityTimes())
			pLabelTimes:setColor(ccc3(99,216,53))
		end
	end

	for k, v in pairs(tabActivityIdx) do
		Update(m_tabImageAct[k])
	end

end

local function UpdateCostTili( pImageAct, nActType, nIndex )
	if pImageAct==nil then
		print("strName".." is nil")
		return
	else
		local nSceneIdx = GetSceneIndex(nIndex+1)
		local nSceneId = GetSceneId(nSceneIdx)
		local nPointIdx = GetActivityIdxBySceneId(nSceneId)
		local pLabelTiLi = tolua.cast(pImageAct:getChildByName("Label_CostTiLi"), "Label")
		local nCostTiLi = 0
		
		if nPointIdx==0 then
			nCostTiLi = 0			
		else
			local nPointId = GetPointId(nSceneIdx, nPointIdx)
			local nPointRuleId = GetPointRuleId(nPointId)		
			nCostTiLi = GetNeedTiLi(nPointRuleId)	
			--print(nSceneIdx, nPointIdx, nPointId, nPointRuleId, GetNeedTiLi(nPointRuleId))
			--Pause()			
		end
		pLabelTiLi:setText(tostring(nCostTiLi))
		if IsEnoughTiLi(nCostTiLi)==true then
			pLabelTiLi:setColor(ccc3(99,216,53))
		else
			pLabelTiLi:setColor(ccc3(255,87,35))
		end
	end
end

local function UpdateActivityInfo( )
	for k, v in pairs(tabActivityIdx) do
		UpdateLeftTimes(m_tabImageAct[k], v, k)
		UpdateCostTili(m_tabImageAct[k], v, k)
	end
end

local function _Image_Activity_CallBack_( sender, eventType  )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		local pRunningScene = CCDirector:sharedDirector():getRunningScene()
		local pLayerEnterPoint = pRunningScene:getChildByTag(layerActivitySelTag)
		if pLayerEnterPoint == nil then
			local pLayerEnterPoint = ActivitySelectLayer.CreateActivitySelectLayer(sender:getTag(), UpdateActivityInfo)
			pRunningScene:addChild(pLayerEnterPoint, layerActivitySelTag, layerActivitySelTag)
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
		AudioUtil.PlayBtnClick()
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitActivityControlData( pImageAct, nActType, nIndex )
	if pImageAct==nil then
		return
	else
		local nSceneIdx = GetSceneIndex(nIndex+1)
		local nSceneId = GetSceneId(nSceneIdx)
		local nSceneType = GetSceneType(nSceneIdx)
		local nSceneRuleId = GetSceneRuleId(nSceneIdx)
		pImageAct:setTag(nSceneIdx)
		pImageAct:setTouchEnabled(true)
		pImageAct:addTouchEventListener(_Image_Activity_CallBack_)

		local pLabelName = tolua.cast(pImageAct:getChildByName("Label_Name"), "Label")
		pLabelName:setText(tostring(GetActivityMapName(nIndex + 1)))
		--开启条件说明
		local pImgRule = tolua.cast(pImageAct:getChildByName("Image_OpenRule"), "ImageView")
		local pLabelRule = tolua.cast(pImgRule:getChildByName("Label_Info_1"), "Label")
		local pImgIcon = tolua.cast(pImageAct:getChildByName("Image_5"), "ImageView")
		local pImgIconBg = tolua.cast(pImageAct:getChildByName("Image_14"), "ImageView")
		local pImageActSp = tolua.cast(pImageAct:getVirtualRenderer(), "CCSprite")
		local pImgIconSp = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")
		local pImgIconBgSp = tolua.cast(pImgIconBg:getVirtualRenderer(), "CCSprite")
		--今天如果不开放则置灰
		if CheckIsOpen(nSceneRuleId) == true then 
			SpriteSetGray(pImageActSp, 1)
			SpriteSetGray(pImgIconSp, 1)
			SpriteSetGray(pImgIconBgSp, 1)
			pImgRule:setVisible(true)
			pImageAct:setTouchEnabled(false)
		else
			SpriteSetGray(pImageActSp, 0)
			SpriteSetGray(pImgIconSp, 0)
			SpriteSetGray(pImgIconBgSp, 0)
			pImgRule:setVisible(false)
			pImageAct:setTouchEnabled(true)
		end
		pLabelRule:setText(GetOpenRuleStr(nSceneRuleId))
	end
end

local function InitWidgtes()
	m_pLayerActivity = GUIReader:shareReader():widgetFromJsonFile("Image/ActivityLayer.json")
	if m_pLayerActivity==nil then
		print("m_pLayerActivity is nil")
		return false
	end

	for i=1, 4 do
		m_tabImageAct[i] = tolua.cast(m_pLayerActivity:getChildByName("Image_Act_"..tostring(i)), "ImageView")
		if m_tabImageAct[i]==nil then
			print("m_tabImageAct_"..i.." is nil")
			return false
		end
	end
	return true
end

function GoToManagerCallFuncByActivity( nSceneIdx, nPointIdx )
	--[[if nSceneIdx == 0 then
		--任意战役
		nSceneIdx = 16
	end
	if nPointIdx == 0 then
		--任意关卡
		nPointIdx = 1
	end
	local pRunningScene = CCDirector:sharedDirector():getRunningScene()
	local pLayerEnterPoint = pRunningScene:getChildByTag(layerActivitySelTag)

	if pLayerEnterPoint == nil then
		local pLayerEnterPoint = ActivitySelectLayer.CreateActivitySelectLayer(nSceneIdx, UpdateActivityInfo)
		pRunningScene:addChild(pLayerEnterPoint, layerActivitySelTag, layerActivitySelTag)
		ActivitySelectLayer.GoToManagerCallFuncByActivitySelect( nPointIdx )
	end]]
end

function CreateActivityLayer(  )
	InitVars()

	if InitWidgtes()==false then
		return
	end

	for k, v in pairs(tabActivityIdx) do
		InitActivityControlData(m_tabImageAct[k], v, k)
	end

	UpdateActivityInfo()

	-- local nSceneIdx, nPointIdx = GetLastSceneIdxAndPointIdx(3)
	return m_pLayerActivity
end