-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    Log("----------------------------------------")
    Log("LUA ERROR: " .. tostring(msg) .. "\n")
    Log(debug.traceback())
    Log("----------------------------------------")
end

module("MainScene", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

local layerMainRoot = nil
function closeLayerByTag(tag_id)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local tempLayer = runningScene:getChildByTag(tag_id)
	if tempLayer ~= nil then
		runningScene:removeChildByTag(tag_id, true)
	else
		Log("none this layer tag is" .. tag_id)
	end
end

function createMainUI()

	sceneGame = CCScene:create()
	layerMainRoot = TouchGroup:create()									-- 背景层
    layerMainRoot:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MainRootLayer.json") )
	
	local function _Button_Fight_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			Log("进入战斗")
			PushFightScene()
		end
	end
    local Button_Fight = tolua.cast(layerMainRoot:getWidgetByName("Button_Fight"), "Button")
    Button_Fight:addTouchEventListener(_Button_Fight_Btn_CallBack)
	
	local function _Button_Chat_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			require "Script/Main/Chat/HeroTalk.lua"
			sceneGame:addChild(HeroTalk.createHeroTalkUI(1), 0, layerHeroTalk_Tag)
		end
	end
    local Button_Chat = tolua.cast(layerMainRoot:getWidgetByName("Button_Chat"), "Button")
    Button_Chat:addTouchEventListener(_Button_Chat_Btn_CallBack)
	
	sceneGame:addChild(layerMainRoot, 0, layerMainRoot_Tag)
	
    CCDirector:sharedDirector():replaceScene(sceneGame)
	
	------------------------------------------------music-----------------------------------------------------------------------
    --AudioUtil.playBgm("audio/main.mp3")
	------------------------------------------------other------------------------------------------------------------------------
	
end

--xpcall(main, __G__TRACKBACK__)
