-- for CCLuaEngine traceback

module("NetWorkLoadingLayer", package.seeall)

require "Script/Audio/AudioUtil"

local layerLoadingLayer = nil
local bFirst = true
local layerLoading_Tag = 1000
--local pAction    = nil

--[[local timer_Event = nil
local elapsed_time = 0.5

local overtime_Time = 60
local overtime_Event = nil]]--

--[[local function closeUpdata()
	layerLoadingLayer:setVisible(false)
    layerLoadingLayer:setTouchEnabled(false)
    if timer_Event ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timer_Event)
        timer_Event = nil
    end
    if overtime_Event ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(overtime_Event)
        overtime_Event = nil
    end
end]]--

--[[local function overtime_CallBack()
    print("超时了")
    loadingHideNow()
end]]--
local function PlayAction()
	if layerLoadingLayer== nil then
		return 
	end
	local img_action = tolua.cast(layerLoadingLayer:getWidgetByName("Image_4"),"ImageView")
	print("img_action")
	
	img_action:runAction( CCRepeatForever:create( CCRotateBy:create(2 , 360) ))
end
local function StopAction()
	if layerLoadingLayer== nil then
		return 
	end
	local img_action = tolua.cast(layerLoadingLayer:getWidgetByName("Image_4"),"ImageView")
	img_action:stopAllActions()
end
local function createLoadingUI()
	
	layerLoadingLayer = TouchGroup:create()									-- 背景层
    layerLoadingLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/NetworkLoading.json") )
	
	
	
	--pAction =  ActionManager:shareManager():playActionByName("NetworkLoading.json","Animation0")
	
    local scenetemp =  CCDirector:sharedDirector():getRunningScene()
    scenetemp:addChild(layerLoadingLayer,layerLoading_Tag,layerLoading_Tag)
	
	PlayAction()
	bFirst = false
end
local function AddLoadingUI()
	local scenetempNew =  CCDirector:sharedDirector():getRunningScene()
    scenetempNew:addChild(layerLoadingLayer,layerLoading_Tag,layerLoading_Tag)
	PlayAction()
	layerLoadingLayer:release()
end
function loadingShow(bShow)
    if layerLoadingLayer == nil and bFirst == true then
       createLoadingUI()
    end
	if  layerLoadingLayer:getParent()== nil and bFirst == false  then
		
		AddLoadingUI()
	end
    if bShow == true then
		PlayAction()
        layerLoadingLayer:setVisible(bShow)
        layerLoadingLayer:setTouchEnabled(bShow)
        layerLoadingLayer:setPosition(ccp(0, 0))
       --[[ if overtime_Event ~= nil then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(overtime_Event)
            overtime_Event = nil
        end
        overtime_Event = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(overtime_CallBack, overtime_Time, false)]]--
    else
        -- 延时关闭
       --[[ if timer_Event ~= nil then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timer_Event)
            timer_Event = nil
        end
        timer_Event = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(closeUpdata, elapsed_time, false)]]--
		 if layerLoadingLayer ~= nil then
			StopAction()
			layerLoadingLayer:setVisible(false)
			layerLoadingLayer:setTouchEnabled(false)
			layerLoadingLayer:setPosition(ccp(10000, 10000))
		end
    end
end

function loadingHideNow()
	
	--[[if timer_Event ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timer_Event)
        timer_Event = nil
    end

    if overtime_Event ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(overtime_Event)
        overtime_Event = nil
    end]]--
    if layerLoadingLayer ~= nil then
		StopAction()
        layerLoadingLayer:setVisible(false)
        layerLoadingLayer:setTouchEnabled(false)
        layerLoadingLayer:setPosition(ccp(10000, 10000))
    end
end

function ClearLoading()
	StopAction()
	--bClear = true
	if timer_Event ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timer_Event)
        timer_Event = nil
    end
    if overtime_Event ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(overtime_Event)
        overtime_Event = nil
    end
   if layerLoadingLayer ~= nil then
		layerLoadingLayer:retain()
        layerLoadingLayer:removeFromParentAndCleanup(false)
    end
	--loadingHideNow()
end




