-- for CCLuaEngine traceback

require "Script/Common/Common"
require "Script/Audio/AudioUtil"


module("ChooseCardLayer", package.seeall)

local layerChooseCard = nil

local scene_now_choosecard = nil

local type_jiang_card = nil
local time_card       = nil
local function initData()
	scene_now_choosecard = CCDirector:sharedDirector():getRunningScene()

end
local function loadGetCard()
	require "Script/Main/Grogshop/GrogShopLayer"
	GrogShopLayer.updateData(type_jiang_card)
	layerChooseCard:setVisible(false)
	layerChooseCard:removeFromParentAndCleanup(true)
	layerChooseCard = nil
	local layer_gshop = scene_now_choosecard:getChildByTag(layerGrogshop_Tag)
	if layer_gshop:isVisible() == true then
		layer_gshop:setVisible(false)
	end
	
	local layer_get = scene_now_choosecard:getChildByTag(layerGetCard_Tag)
	if layer_get == nil then
		require "Script/Main/Grogshop/GetCardLayer"
		local layer_g_card = GetCardLayer.createGetCardLayer(type_jiang_card,time_card)
		scene_now_choosecard:addChild(layer_g_card,layerGetCard_Tag,layerGetCard_Tag)
	end
end
local function initUI()
	--抽一次
	local function _Btn_ChooseOne_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			time_card = 0
			loadGetCard()
			
		end
	end
	local btn_chooseone = tolua.cast(layerChooseCard:getWidgetByName("btn_one_bc"),"Button")
	btn_chooseone:addTouchEventListener(_Btn_ChooseOne_CallBack)
	--抽十次
	local function _Btn_ChooseTen_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			time_card = 1
			loadGetCard()
		end
	end
	local btn_chooseten = tolua.cast(layerChooseCard:getWidgetByName("btn_ten_bc"),"Button")
	btn_chooseten:addTouchEventListener(_Btn_ChooseTen_CallBack)
end
-- 0表示良将 1表示神将
function createChooseCardLayer(jiang_type)
	layerChooseCard = TouchGroup:create()
	layerChooseCard:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/BuyCardLayer.json"))
	type_jiang_card = jiang_type
	initData()
	initUI()
	local function _Btn_Back_ChooseCard_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			layerChooseCard:setVisible(false)
            layerChooseCard:removeFromParentAndCleanup(true)
            layerChooseCard = nil
		end
	end
	local btn_back_choosecard = tolua.cast(layerChooseCard:getWidgetByName("btn_back_buycard"),"Button")
	btn_back_choosecard:addTouchEventListener(_Btn_Back_ChooseCard_CallBack)

	return layerChooseCard


end