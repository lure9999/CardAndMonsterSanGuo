-- for CCLuaEngine traceback

require "Script/Common/Common"
require "Script/Audio/AudioUtil"


module("GetCardLayer", package.seeall)

local layerGetCard = nil

local scene_now_getcard = nil

local type_jiang_getcard = nil
--得到卡的个数
local count_jiang_getcard = nil

local zizhi_jiang_getcard = nil
local btn_card_getcard    = nil
local label_zizhi_num     = nil

local img_info_bg         = nil

local function initData()
	scene_now_getcard = CCDirector:sharedDirector():getRunningScene()
	zizhi_jiang_getcard = 13
	btn_card_getcard = tolua.cast(layerGetCard:getWidgetByName("btn_card_getcard"),"Button")
	label_zizhi_num  = LabelAtlas:create()
	img_info_bg = tolua.cast(layerGetCard:getWidgetByName("img_card_info_gc"),"ImageView")
end

--[[local function ActionCallBack()
	label_zizhi_num:setVisible(true)
end]]--

--卡片的信息
local function _Btn_Card_GetCard_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--print("卡片信息")
	end
end 
--加载一次的信息
local function loadOneCard()
	btn_card_getcard:addTouchEventListener(_Btn_Card_GetCard_CallBack)
	btn_card_getcard:setScale(0)
	
	local array_action = CCArray:create()
	--array_action:addObject(CCFadeOut:create(5))
	array_action:addObject(CCScaleTo:create(0.6, 1))
	array_action:addObject(CCRotateBy:create(0.6, 360*3))
	local spawn_action = CCSpawn:create(array_action)
	btn_card_getcard:runAction(spawn_action)
	--资质
	
	label_zizhi_num:setProperty(string.format("%d",zizhi_jiang_getcard),"Image/common/number_05.png",20,30,"0")
	label_zizhi_num:setPosition(ccp(20,-22))
	img_info_bg:addChild(label_zizhi_num,14,14)
	--[[local call_action = CCCallFunc:create(ActionCallBack)
	local delay_action = CCDelayTime:create(0.6)
	local seq_action = CCSequence:createWithTwoActions(delay_action,call_action)
	label_zizhi_num:runAction(seq_action)]]--
end
local function loadTenCard()
	btn_card_getcard:setScale(0)
	btn_card_getcard:setPosition(ccp(-340,120))
	label_zizhi_num:setProperty(string.format("%d",zizhi_jiang_getcard),"Image/common/number_05.png",20,30,"0")
	label_zizhi_num:setPosition(ccp(20,-22))
	img_info_bg:addChild(label_zizhi_num,14,14)
	local img_bg_getcard = tolua.cast(layerGetCard:getWidgetByName("img_bg_getcard"),"ImageView")
	
	local array_acction_btn = CCArray:create()
	array_acction_btn:addObject(CCScaleTo:create(0.6,0.4))
	array_acction_btn:addObject(CCRotateBy:create(0.6,360*3))
	local spawn_action_ten = CCSpawn:create(array_acction_btn)
	btn_card_getcard:runAction(spawn_action_ten)
	
	for i = 1,9 do
		local btn_card_i = Button:create()
		if i<5 then
			btn_card_i:setPosition(ccp(-340+i*170,120))
		else
			btn_card_i:setPosition(ccp(-340+(i-5)*170,120-244))
		end
		btn_card_i:setScale(0)
		btn_card_i:loadTextures("Image/grogshop/card_bg.png","Image/grogshop/card_bg.png","")
		btn_card_i:setTouchEnabled(true)
		btn_card_i:addTouchEventListener(_Btn_Card_GetCard_CallBack)
		btn_card_i:setTag(100+i)
		img_bg_getcard:addChild(btn_card_i)
		
		local img_jiang_gc = ImageView:create()
		img_jiang_gc:loadTexture("Image/grogshop/card_lvbu.png")
		img_jiang_gc:setPosition(ccp(0,0))
		btn_card_i:addChild(img_jiang_gc)
		
		local img_info_bg_gc = ImageView:create()
		img_info_bg_gc:setPosition(ccp(34,-164))
		img_info_bg_gc:loadTexture("Image/grogshop/bg_name_card.png")
		btn_card_i:addChild(img_info_bg_gc)
		
		local label_name_gc = Label:create()
		label_name_gc:setFontSize(36)
		label_name_gc:setColor(ccc3(255,227,114))
		label_name_gc:setPosition(ccp(-16,25))
		label_name_gc:setText("吕小布布")
		img_info_bg_gc:addChild(label_name_gc)
		
		local img_zizhi_gc = ImageView:create()
		img_zizhi_gc:loadTexture("Image/grogshop/word_zizhi.png")
		img_zizhi_gc:setPosition(ccp(-51,-22))
		img_info_bg_gc:addChild(img_zizhi_gc)
		
		local label_zizhi_count = LabelAtlas:create()
		label_zizhi_count:setProperty(string.format("%d",zizhi_jiang_getcard),"Image/common/number_05.png",20,30,"0")
		label_zizhi_count:setPosition(ccp(20,-22))
		img_info_bg_gc:addChild(label_zizhi_count)
		
	end
	for i=1 ,9 do 
		local arr = CCArray:create()
		arr:addObject(CCScaleTo:create(0.6,0.4))
		arr:addObject(CCRotateBy:create(0.6,360*3))
		local spawn_action_ll = CCSpawn:create(arr)
		local btn_card_local = img_bg_getcard:getChildByTag(100+i)
		btn_card_local:runAction(spawn_action_ll)
	end
end
local function initUI()
	
	if count_jiang_getcard == 0 then
		loadOneCard()
	else
		loadTenCard()
	end
	
end
-- 0表示良将 1表示神将 time_jiang 0表示一次 1表示10次
function createGetCardLayer(jiang_type_g,time_jiang)
	layerGetCard = TouchGroup:create()
	layerGetCard:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/GetCardLayer.json"))
	type_jiang_getcard = jiang_type_g
	count_jiang_getcard = time_jiang
	initData()
	initUI()
	local function _Btn_Back_GetCard_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			layerGetCard:setVisible(false)
            layerGetCard:removeFromParentAndCleanup(true)
            layerGetCard = nil
			local layer_shop = scene_now_getcard:getChildByTag(layerGrogshop_Tag)
			if layer_shop ~= nil then
				if layer_shop:isVisible() == false then
					layer_shop:setVisible(true)
				end
			end
		end
	end
	local btn_back_getcard = tolua.cast(layerGetCard:getWidgetByName("btn_back_getcard"),"Button")
	btn_back_getcard:addTouchEventListener(_Btn_Back_GetCard_CallBack)

	return layerGetCard


end