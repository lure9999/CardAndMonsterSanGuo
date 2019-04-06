-- for CCLuaEngine traceback


require "Script/Common/Common"
require "Script/Audio/AudioUtil"


module("GrogShopLayer", package.seeall)



local layerGrogShop = nil
local scene_now_gs  = nil


--时间
local time_lj_gs  = nil
local time_sj_gs  = nil



local hour_lj = nil
local minute_lj = nil
local second_lj = nil

local hour_sj = nil
local minute_sj = nil
local second_sj = nil

local label_lj_time = nil
local label_sj_time = nil

local run_logic_lj = nil
local run_logic_sj = nil

local scheduler = nil

local btn_lj_grogshop = nil
local btn_sj_grogshop = nil

local label_free_lj = nil
local label_free_sj = nil

local function initData()
	scene_now_gs = CCDirector:sharedDirector():getRunningScene()
	hour_lj = 0 
	minute_lj = 0
	second_lj = 1
	
	hour_sj = 0 
	minute_sj = 0
	second_sj = 30
	
	second_lj = second_lj..""  
    minute_lj = minute_lj..""  
    hour_lj = hour_lj..""  
	
	second_sj = second_sj..""  
    minute_sj = minute_sj..""  
    hour_sj = hour_sj.."" 
      
    if string.len(second_lj) == 1 then  
        second_lj = "0"..second_lj  
    end  
      
    if string.len(minute_lj) == 1 then  
        minute_lj = "0"..minute_lj  
    end  
      
    if string.len(hour_lj) == 1 then  
        hour_lj = "0"..hour_lj  
    end
	
	if string.len(second_sj) == 1 then  
        second_sj = "0"..second_sj  
    end  
      
    if string.len(minute_sj) == 1 then  
        minute_sj = "0"..minute_sj  
    end  
      
    if string.len(hour_sj) == 1 then  
        hour_sj = "0"..hour_sj  
    end
	
	time_lj_gs = hour_lj..":"..minute_lj..":"..second_lj
	time_sj_gs = hour_sj..":"..minute_sj..":"..second_sj
	
	scheduler = CCDirector:sharedDirector():getScheduler()
	label_free_lj = tolua.cast(layerGrogShop:getWidgetByName("label_free_lj_gs"),"Label")
	label_free_sj = tolua.cast(layerGrogShop:getWidgetByName("label_free_sj_gs"),"Label")
	
end


local function loadChoose(i_type)
	local layer_choose = scene_now_gs:getChildByTag(layerChooseCard_Tag)
	if layer_choose == nil then
		require "Script/Main/Grogshop/ChooseCardLayer"
		local layer_n_choose = ChooseCardLayer.createChooseCardLayer(i_type)
		scene_now_gs:addChild(layer_n_choose,layerChooseCard_Tag,layerChooseCard_Tag)
	end
end
local function updateLJTime()
    second_lj = second_lj -1 
	if second_lj == -1 then
		if (minute_lj ~= -1) or (hour_lj ~= -1) then
			 minute_lj = minute_lj -1 ;
			 second_lj = 59
			 if minute_lj == -1 then
				if hour_lj~=-1 then
					hour_lj = hour_lj -1 
					minute_lj = 59
					if hour_lj == -1 then
						if run_logic_lj ~= nil then
							scheduler:unscheduleScriptEntry(run_logic_lj) 
							run_logic_lj = nil
							label_lj_time:setVisible(false)
							label_free_lj:setText("免费抽取一次")
							label_free_lj:setPosition(ccp(12,0))
							btn_lj_grogshop:setTouchEnabled(true)
						end
						second_lj = 0 
						minute_lj = 0
						hour_lj   = 0
					end
				end
			 end
		end
	end
	second_lj = second_lj..""  
    minute_lj = minute_lj..""  
    hour_lj = hour_lj..""  
      
    if string.len(second_lj) == 1 then  
        second_lj = "0"..second_lj  
    end  
      
    if string.len(minute_lj) == 1 then  
        minute_lj = "0"..minute_lj  
    end  
      
    if string.len(hour_lj) == 1 then  
        hour_lj = "0"..hour_lj  
    end  
    if run_logic_lj ~= nil then
		label_lj_time:setString(hour_lj..":"..minute_lj..":"..second_lj)
	end
    
	 
end
local function updateSJTime()
	second_sj = second_sj -1 
	if second_sj == -1 then
		if (minute_sj ~= -1) or (hour_sj ~= -1) then
			 minute_sj = minute_sj -1 ;
			 second_sj = 59
			 if minute_sj == -1 then
				if hour_sj~=-1 then
					hour_sj = hour_sj -1 
					minute_sj = 59
					if hour_sj == -1 then
						if run_logic_sj ~= nil then
							scheduler:unscheduleScriptEntry(run_logic_sj) 
							run_logic_sj = nil
							label_sj_time:setVisible(false)
							label_free_sj:setText("免费抽取一次")
							label_free_sj:setPosition(ccp(12,0))
							btn_sj_grogshop:setTouchEnabled(true)
						end
						second_sj = 0 
						minute_sj = 0
						hour_sj   = 0
					end
				end
			 end
		end
	end
	second_sj = second_sj..""  
    minute_sj = minute_sj..""  
    hour_sj = hour_sj..""  
      
    if string.len(second_sj) == 1 then  
        second_sj = "0"..second_sj  
    end  
      
    if string.len(minute_sj) == 1 then  
        minute_sj = "0"..minute_sj  
    end  
      
    if string.len(hour_sj) == 1 then  
        hour_sj = "0"..hour_sj  
    end  
    if run_logic_sj ~= nil then
		label_sj_time:setString(hour_sj..":"..minute_sj..":"..second_sj)
	end
end
function updateData( type_gs )
	if type_gs == 0 then
		second_lj = 10 
		label_free_lj:setText("后免费")
		label_free_lj:setPosition(ccp(90,0))
		label_lj_time:setVisible(true)
		run_logic_lj = scheduler:scheduleScriptFunc(updateLJTime,1,false)
		btn_lj_grogshop:setTouchEnabled(false)
	else
		second_sj = 20 
		label_free_sj:setText("后免费")
		label_free_sj:setPosition(ccp(90,0))
		label_sj_time:setVisible(true)
		run_logic_sj = scheduler:scheduleScriptFunc(updateSJTime,1,false)
		btn_sj_grogshop:setTouchEnabled(false)
	end
	
end
local function initUI()
	--良将的抽取
	local function _Btn_lj_GrogShop_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			loadChoose(0)
		end
	end
    btn_lj_grogshop = tolua.cast(layerGrogShop:getWidgetByName("btn_lj_gs"),"Button")
	btn_lj_grogshop:addTouchEventListener(_Btn_lj_GrogShop_CallBack)
	btn_lj_grogshop:setTouchEnabled(false)
	--神将的抽取
	local function _Btn_sj_GrogShop_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			loadChoose(1)
		end
	end
	btn_sj_grogshop = tolua.cast(layerGrogShop:getWidgetByName("btn_sj_gs"),"Button")
	btn_sj_grogshop:addTouchEventListener(_Btn_sj_GrogShop_CallBack)
	btn_sj_grogshop:setTouchEnabled(false)
	
	--倒计时
	
	label_lj_time = CCLabelAtlas:create(time_lj_gs,"Image/common/number_04.png",22,29,string.byte("0"))
	label_lj_time:setPosition(ccp(130,186))
	layerGrogShop:addChild(label_lj_time,12,12) 
	run_logic_lj = scheduler:scheduleScriptFunc(updateLJTime,1,false)
	
	label_sj_time = CCLabelAtlas:create(time_sj_gs,"Image/common/number_04.png",22,29,string.byte("0"))
	label_sj_time:setPosition(ccp(580,186))
	layerGrogShop:addChild(label_sj_time,12,12) 
	run_logic_sj = scheduler:scheduleScriptFunc(updateSJTime,1,false)
	--layerGrogShop:scheduleUpdateWithPriorityLua(updateTime, 0)
end

function createGrogShopLayer()
	layerGrogShop = TouchGroup:create()
	layerGrogShop:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/GrogshopLayer.json"))
	
	initData()
	
	initUI()
	--将主界面按钮重新加载一次
    require "Script/Main/MainBtnLayer"
    local temp_grogshop = MainBtnLayer.createMainBtnLayer()
    layerGrogShop:addChild(temp_grogshop, layerMainBtn_Tag, layerMainBtn_Tag)
	local function _Btn_Back_GrogShop_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			if run_logic_lj ~= nil then
				scheduler:unscheduleScriptEntry(run_logic_lj)
			end
			if run_logic_sj ~= nil then
				scheduler:unscheduleScriptEntry(run_logic_sj)
			end
			
			layerGrogShop:setVisible(false)
            layerGrogShop:removeFromParentAndCleanup(true)
            layerGrogShop = nil
        	MainScene.PopUILayer()
		end
	end
	local btn_back_grogshop = tolua.cast(layerGrogShop:getWidgetByName("btn_back_gs"),"Button")
	btn_back_grogshop:addTouchEventListener(_Btn_Back_GrogShop_CallBack)

	return layerGrogShop


end