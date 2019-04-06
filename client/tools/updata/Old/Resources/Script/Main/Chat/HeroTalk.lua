-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    Log("----------------------------------------")
    Log("LUA ERROR: " .. tostring(msg) .. "\n")
    Log(debug.traceback())
    Log("----------------------------------------")
end

module("HeroTalk", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

local layerHeroTalk = nil

function createHeroTalkUI(talkId)

	layerHeroTalk = TouchGroup:create()									-- 背景层
    layerHeroTalk:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/HeroTalkLayer.json") )
	
	local _Label_Name = nil
	local _Label_Text = nil
	local Image_Hero = nil
	require "DB/HeroTalk"
	local tempTable = HeroTalk.getDataById(talkId)
	local hero_name = tempTable[1]
	local hero_img = tempTable[2]
	local talk_text = tempTable[3]
	local next_id = tempTable[4]
	local function _Image_Back_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
		Log("Click")
		if next_id == "0" then
			-- 没有对话了
			MainScene.closeLayerByTag(layerHeroTalk_Tag)
			return
		end
		tempTable = HeroTalk.getDataById(next_id)
		hero_name = tempTable[1]
		hero_img = tempTable[2]
		talk_text = tempTable[3]
		next_id = tempTable[4]
		
		_Label_Name:setText(hero_name)
		_Label_Text:setText(talk_text)
		Image_Hero:loadTexture("Image/chat/" .. hero_img .. ".png")
		
		end
	end
    local Image_Back = tolua.cast(layerHeroTalk:getWidgetByName("Image_Back"), "ImageView")
    Image_Back:addTouchEventListener(_Image_Back_CallBack)
	
	_Label_Name = Label:create()
	_Label_Name:setText(hero_name)
	_Label_Name:setFontSize(28)
	_Label_Name:setColor(COLOR_Gold)
	_Label_Name:setPosition(ccp(0, 4))
	--_Label_Name:setFontName(fontName)
    local Image_Name = tolua.cast(layerHeroTalk:getWidgetByName("Image_Name"), "ImageView")
	Image_Name:addChild(_Label_Name)
	
	_Label_Text = Label:create()
	_Label_Text:setText(talk_text)
	_Label_Text:setFontSize(24)
	_Label_Text:setColor(COLOR_White)
	_Label_Text:setAnchorPoint(ccp(0,0.5))
	_Label_Text:setPosition(ccp(-400, 0))
	Image_Back:addChild(_Label_Text)
	
    Image_Hero = tolua.cast(layerHeroTalk:getWidgetByName("Image_Hero"), "ImageView")
	Image_Hero:loadTexture("Image/chat/" .. hero_img .. ".png")
	
	
	return layerHeroTalk
	
end

--xpcall(main, __G__TRACKBACK__)
