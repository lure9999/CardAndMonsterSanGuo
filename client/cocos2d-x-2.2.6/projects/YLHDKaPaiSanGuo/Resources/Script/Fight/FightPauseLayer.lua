
module("FightPauseLayer", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

--add by sxin 增加场景接口调用
local m_ScenceInterface = nil

local layerFightPause = nil

local function CloseSelf()
	if layerFightPause ~= nil then
		layerFightPause:setVisible(false)
		layerFightPause:setTouchEnabled(false)
		layerFightPause:removeFromParentAndCleanup(true)
		layerFightPause = nil
	end
end

local function InitVars()
	layerFightPause = nil
end

function CreateFightPauseLayer(node, pScenceInterface)
	m_ScenceInterface = pScenceInterface
	InitVars()
	layerFightPause = TouchGroup:create()
    layerFightPause:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/FightUIPauseLayer.json") )
	
	--add by celina 
	local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
	--因为整个场景向右挪了nOff_W/2 再挪回去
	layerFightPause:setPosition(ccp(-nOff_W/2, nOff_H/2))
	node:addChild(layerFightPause)
	
	
	
	local function _Button_Quit_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then

			function BattleEndOver()
				print("战斗 发给服务器 完成")
				--NetWorkLoadingLayer.loadingHideNow()

				if BaseSceneDB.IsCityWarSingleScene() == true then
					--print("此次退出需要显示国战层")
					require "Script/Main/CountryWar/CountryWarScene"
					CountryWarScene.SetIsBackFromSingle(true)
				end

				--NetWorkLoadingLayer.ClearLoading()
				BaseSceneLogic.OnResum()
				CloseSelf()
				
				m_ScenceInterface:OnTimeOver()
				m_ScenceInterface:LeaveScene()
			end
			
			BattleEndOver()

			--[[if NETWORKENABLE > 0 then
				Packet_BattleEnd.SetSuccessCallBack(BattleEndOver)
				local nSceneId = FightLevelLayer.GetFightSceneId()
				local nIndexId = FightLevelLayer.GetFightIndexId()
				print("nSceneId = " .. nSceneId)
				print("nIndexId = " .. nIndexId)
				network.NetWorkEvent(Packet_BattleEnd.CreatPacket(nSceneId, nIndexId, 0))
				NetWorkLoadingLayer.loadingShow(true)
			else
				BattleEndOver()
			end
			--]]
		end
	end
    local Button_Quit = tolua.cast(layerFightPause:getWidgetByName("Button_Quit"), "Button")
    Button_Quit:addTouchEventListener(_Button_Quit_Btn_CallBack)
	
	local function _Button_Resume_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			CloseSelf()
			BaseSceneLogic.OnResum()
		end
	end
    local Button_Resume = tolua.cast(layerFightPause:getWidgetByName("Button_Resume"), "Button")
    Button_Resume:addTouchEventListener(_Button_Resume_Btn_CallBack)
	
    local function selectedEvent(sender,eventType)
        if eventType == CheckBoxEventType.selected then
			print("sound off")
        elseif eventType == CheckBoxEventType.unselected then
			print("sound on")
        end
    end
    local CheckBox_Sound = tolua.cast(layerFightPause:getWidgetByName("CheckBox_Sound"), "CheckBox")
	CheckBox_Sound:addEventListenerCheckBox(selectedEvent) 
	
end

