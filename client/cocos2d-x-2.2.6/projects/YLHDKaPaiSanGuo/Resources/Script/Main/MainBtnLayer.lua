-- for CCLuaEngine traceback
module("MainBtnLayer", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"
--require "Script/Network/network"
require "Script/Main/Dungeon/DungeonManagerLayer"
require "Script/Main/Dungeon/CompetitionLayer"
require "Script/Main/Dobk/DobkLayer"
require "Script/serverDB/server_MissionPromptDB"

local m_playerMainBtn = nil
local m_PointManger   = nil
local m_bRootHide = true
local m_bBackTouch = true

local function InitVars()
	m_playerMainBtn = nil
	m_PointManger   = nil
	m_bRootHide = true
	m_bBackTouch = true
end

function ClearUI()
	MainScene.ShowLeftInfo(false)
	-- 清理正在显示的一级界面
	-- 这里取一下常驻按扭，如果能取到的话。清理掉，新界面会再添加一个。
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
    local frameArray = scenetemp:getChildren()
	for i = 0, frameArray:count()-1 do
		local child = tolua.cast(frameArray:objectAtIndex(i), "CCNode")
		if tonumber(child:getTag()) ~= -1 and
			tonumber(child:getTag()) ~= layerMainRoot_Tag and
			tonumber(child:getTag()) ~= layerMainBack and
			tonumber(child:getTag()) ~= layerLoading_Tag then
    		print("delete node tag is " .. child:getTag())
    		child:removeFromParentAndCleanup(true)
    		child = nil
    		ClearUI()
    		return
		end
	end
end

function setBackTouch( bFlag )
	local Image_18 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_18"), "ImageView")
	Image_18:setTouchEnabled(bFlag)
	Image_18:setVisible(bFlag)
	m_bBackTouch = bFlag
end

function SetRootBtnState(bFlag)
	m_bRootHide = bFlag
	if m_bRootHide == true then

		local Image_3 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_3"), "ImageView")
		local Button_Change = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Change"), "Button")
		Image_3:setPosition(ccp(1076, 30))
		Image_3:setScale(0)
		local Image_18 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_18"), "ImageView")
		Image_18:setVisible(false)
		Image_18:setTouchEnabled(false)
	end
	if m_bRootHide == false then

		local Image_3 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_3"), "ImageView")
		local Button_Change = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Change"), "Button")
		Image_3:setPosition(ccp(1076, 30))
		Image_3:setScale(1)
		local Image_18 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_18"), "ImageView")
		Image_18:setVisible(m_bBackTouch)
		Image_18:setTouchEnabled(m_bBackTouch)
	end
end

function GetRootBtnState()
	return m_bRootHide
end

function SetRedPoint(  )
	if m_playerMainBtn ~= nil then
		local Button_Day = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Day"), "Button")
		local nRedPoint  = tolua.cast(Button_Day:getChildByName("Image_Point"), "ImageView")
		local nState = server_MissionPromptDB.GetRedPointState()
		if nState == false then
			nRedPoint:setVisible(false)
		else
			nRedPoint:setVisible(true)
		end
	end
end

function SetBagPoint(  )
	require "Script/serverDB/server_itemDB"
	require "Script/serverDB/item"
	if m_playerMainBtn == nil then
		return
	end
	local Button_Item = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Item"), "Button")
	local tab = server_itemDB.GetCopyTable()
	for key,value in pairs(tab) do
		-- if tonumber(nTypeNum) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP then
			if ( tonumber(value["Type"]) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIPFRAGMENT ) or 
			( tonumber(value["Type"]) >=E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP )then
				local NeedNum = item.getFieldByIdAndIndex(value["ItemID"],"event_para_A") -- 需要的数量
				if (tonumber(value["Info03"]["Count"])/tonumber(NeedNum)) >= 1 then
					m_PointManger:ShowRedPoint(760,Button_Item,30,25)
					return
				end
			else
				if Button_Item:getChildByTag(760) ~= nil then 
					Button_Item:getChildByTag(760):removeFromParentAndCleanup(true) 
				end
				-- m_PointManger:DeleteRedPoint(760)
			end
		-- end
	end
end

function createMainBtnLayer()
	
	InitVars()
	
	m_playerMainBtn = TouchGroup:create()									-- 背景层
    m_playerMainBtn:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MainBtnLayer.json") )
	
	m_playerMainBtn:setTouchEnabled(false)
	m_PointManger = AddPoint.CreateAddPoint()
	local function _Button_Change_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			if sender ~= nil then sender:setScale(1) end
			
			if m_bRootHide == false then
				ActionManager:shareManager():playActionByName("MainBtnLayer.json","Animation0")
    			local Image_18 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_18"), "ImageView")
    			--Image_18:runAction(CCFadeTo:create(1, 0))
    			Image_18:setVisible(false)
    			Image_18:setTouchEnabled(false)
				m_bRootHide = true
			else
				ActionManager:shareManager():playActionByName("MainBtnLayer.json","Animation1")
    			local Image_18 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_18"), "ImageView")
    			--Image_18:runAction(CCFadeTo:create(1, 120))
    			Image_18:setVisible(m_bBackTouch)
    			Image_18:setTouchEnabled(m_bBackTouch)
				m_bRootHide = false
			end
		else if eventType == TouchEventType.began then
			if sender ~= nil then sender:setScale(0.9) end
        	end
        end
	end
    local Button_Change = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Change"), "Button")
    Button_Change:addTouchEventListener(_Button_Change_Btn_CallBack)

	-- 阵容
	local function _Button_Fomation_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			if sender ~= nil then sender:setScale(1) end
		    local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			require "Script/Main/Matrix/MatrixLayer"
			local tempCur = scenetemp:getChildByTag(layerMatrix_Tag)
			if tempCur ~= nil then
			    _Button_Change_Btn_CallBack(nil, TouchEventType.ended)
			else

				local function OpenMatrix()
					NetWorkLoadingLayer.loadingHideNow()
					--ClearUI()
					MainScene.ShowLeftInfo(false)
					MainScene.ClearRootBtn()
					MainScene.DeleteUILayer(MatrixLayer.GetUIControl())
					local matrix = MatrixLayer.createMatrixUI()
					scenetemp:addChild(matrix,layerMatrix_Tag,layerMatrix_Tag)
					MainScene.PushUILayer(matrix)
				end

				if NETWORKENABLE > 0 then
					NetWorkLoadingLayer.loadingShow(true)

					Packet_GetMatrix.SetSuccessCallBack(OpenMatrix)
					network.NetWorkEvent(Packet_GetMatrix.CreatPacket())
				else
					OpenMatrix()
				end
			end
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
    local Button_Fomation = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Fomation"), "Button")
    Button_Fomation:addTouchEventListener(_Button_Fomation_Btn_CallBack)
    -----------------------------------------------------------------

	local function _Button_Task_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
    --local Button_Task = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Task"), "Button")
   -- Button_Task:addTouchEventListener(_Button_Task_Btn_CallBack)
	
	local function _Button_Copy_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			prin("Copy")
			sender:setScale(1.0)
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
    --local Button_Copy = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Copy"), "Button")
    --Button_Copy:addTouchEventListener(_Button_Copy_Btn_CallBack)
	
	
	--add celina 0716 添加武将按钮的操作-----------------------------------------------------
    local function _Button_Wujiang_Btn_CallBack(sender,eventType)
		--Pausetraceback()
	    if eventType == TouchEventType.ended then
	    	if sender ~= nil then sender:setScale(1) end
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			local tempCur = scenetemp:getChildByTag(layerWujiangList_Tag)
			-- require "Script/Main/Wujiang/WujiangListLayer"
			require "Script/Main/Wujiang/GeneralListLayer"
			if tempCur ~= nil and tempCur == GeneralListLayer:GetUIControl() then
			    print("已经是武将界面了")
			    _Button_Change_Btn_CallBack(nil, TouchEventType.ended)
			else
				local function OpenWujiang()
					NetWorkLoadingLayer.loadingHideNow()
					--ClearUI()
					MainScene.ShowLeftInfo(false)
					MainScene.ClearRootBtn()
					
					MainScene.DeleteUILayer(GeneralListLayer.GetUIControl())
					local wujiang = GeneralListLayer.CreateGeneralListLayer()
					scenetemp:addChild(wujiang,layerWujiangList_Tag,layerWujiangList_Tag)
					MainScene.PushUILayer(wujiang)
				end

				if NETWORKENABLE > 0 then
					NetWorkLoadingLayer.loadingShow(true)
					Packet_GetGeneralList.SetSuccessCallBack(OpenWujiang)
					network.NetWorkEvent(Packet_GetGeneralList.CreatPacket())
				else
					OpenWujiang()
				end
			end
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
    end

	local Button_Wujiang = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Wujiang"), "Button")
    Button_Wujiang:addTouchEventListener(_Button_Wujiang_Btn_CallBack)
	--添加道具的界面 0721
	local function _Button_Item_Btn_CallBack(sender,eventType)
	    if eventType == TouchEventType.ended then
	    	if sender ~= nil then sender:setScale(1) end
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			local tempCur = scenetemp:getChildByTag(layerItemList_Tag)
			require "Script/Main/Item/ItemListLayer"
			if tempCur ~= nil  then
			    print("已经是道具界面了")
			    _Button_Change_Btn_CallBack(nil, TouchEventType.ended)
			else
				local function OpenItem()
					NetWorkLoadingLayer.loadingHideNow()
					--ClearUI()
					MainScene.ShowLeftInfo(false)
					MainScene.ClearRootBtn()
					MainScene.DeleteUILayer(ItemListLayer.GetUIControl())
					local item_item = ItemListLayer.CreateItemListLayer()
					scenetemp:addChild(item_item,layerItemList_Tag,layerItemList_Tag)

					MainScene.PushUILayer(item_item)
				end
				if NETWORKENABLE > 0 then
					NetWorkLoadingLayer.loadingShow(true)

					Packet_GetItemList.SetSuccessCallBack(OpenItem)
					network.NetWorkEvent(Packet_GetItemList.CreatPacket())

				else
					OpenItem()
				end
			end
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
    end
	local Button_Item = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Item"), "Button")
	Button_Item:setPositionY(Button_Item:getPositionY() + 5)
    Button_Item:addTouchEventListener(_Button_Item_Btn_CallBack)

	--end add celina---------------------------------------------------------------------------------
    local function _Button_Activity_Btn_CallBack(sender,eventType)
	    --斩将入口
	    if eventType == TouchEventType.ended then
			---斩将入口---
	    	if sender ~= nil then sender:setScale(1) end
						
			------------------测试新战斗------
			require "Script/Fight/BaseScene"
			BaseScene.createBaseScene()
			BaseScene.InitTestPKData(1000,1)				
			BaseScene.EnterBaseScene()
				
			
		elseif  eventType == TouchEventType.began then
				sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
				sender:setScale(1.0)
		end
	end

	--local Button_Activity = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Activity"), "Button")
    --Button_Activity:addTouchEventListener(_Button_Activity_Btn_CallBack)

    local function _Back_CallBack(sender,eventType)
	    if eventType == TouchEventType.ended then
	    	if sender ~= nil then sender:setScale(1) end
	    	_Button_Change_Btn_CallBack(sender, eventType)
	   	elseif  eventType == TouchEventType.began then
			--sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			--sender:setScale(1.0)
	    end
	end

	local function _Button_Day_Btn_CallBack(sender,eventType)
    	if eventType == TouchEventType.ended then
			--任务界面
			--[[sender:setScale(1.0)
			MainScene.DeleteAllObjects()
			network.LuaNetWorkConect(true)]]--
			sender:setScale(1.0)
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			local tempCur = scenetemp:getChildByTag(layerMissionNormal_tag)
			require "Script/Main/MissionNormal/MissionNormalLayer"
			if tempCur ~= nil  then
			    print("已经是任务界面了")
			    _Button_Change_Btn_CallBack(nil, TouchEventType.ended)
			else
				local function openMissionLayer()
					NetWorkLoadingLayer.loadingHideNow()
					MainScene.ShowLeftInfo(false)
					MainScene.ClearRootBtn()
					MainScene.DeleteUILayer(MissionNormalLayer.GetUIControl())
					local mission = MissionNormalLayer.CreateMissionNormalLayer(1)
					scenetemp:addChild(mission,layerMissionNormal_tag,layerMissionNormal_tag)

					MainScene.PushUILayer(mission)
				end

				--openMissionLayer()
				if NETWORKENABLE > 0 then
					NetWorkLoadingLayer.loadingShow(true)

					Packet_GetNormalMissionData.SetSuccessCallBack(openMissionLayer)
					network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(1)) --0=主线任务。1=日常任务

				else
					openMissionLayer()
				end
			end
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end

	local Button_Day = tolua.cast(m_playerMainBtn:getWidgetByName("Button_Day"), "Button")
	local nRedPoint  = tolua.cast(Button_Day:getChildByName("Image_Point"), "ImageView")
	local nState 	 = server_MissionPromptDB.GetRedPointState()
	nRedPoint:setVisible(false)	
	if nState == true then
		nRedPoint:setVisible(true)
	end
	Button_Day:addTouchEventListener(_Button_Day_Btn_CallBack)
	
    local Image_Item_1 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_Item_1"), "ImageView")
    local Image_Item_2 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_Item_2"), "ImageView")
    local Image_Item_3 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_Item_3"), "ImageView")
    local Image_Item_4 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_Item_4"), "ImageView")
    local pText_1 = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, "阵容", ccp(0, -32.33), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
	pText_1:setZOrder(10)
   Image_Item_1:addChild(pText_1,2)
    local pText_2 = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, "武将", ccp(0, -32.33), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
    pText_2:setZOrder(10)
	Image_Item_2:addChild(pText_2,2)
    local pText_3 = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, "背包", ccp(0, -32.33), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
	 pText_3:setZOrder(10)
   Image_Item_3:addChild(pText_3,2)
    local pText_4 = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, "日志", ccp(0, -32.33), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
	pText_4:setZOrder(10)
   Image_Item_4:addChild(pText_4,2)

    local Image_18 = tolua.cast(m_playerMainBtn:getWidgetByName("Image_18"), "ImageView")
	Image_18:setVisible(false)
    Image_18:setTouchEnabled(false)
	Image_18:addTouchEventListener(_Back_CallBack)

    local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height

    m_playerMainBtn:setPosition(ccp(-nOff_W/2, nOff_H/2))
    SetBagPoint()
	return m_playerMainBtn
end
