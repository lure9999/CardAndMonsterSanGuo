-- for CCLuaEngine traceback

require "Script/serverDB/server_mainDB"
module("HeroTalkLayer", package.seeall)
--require("Script/severDB/server_mainDB")
local m_playerHeroTalk = nil
local m_ptalkOverCallBackFun = nil

local m_pleftPanel = nil
local m_prightPanel = nil


local m_pImage_Hero_left = nil
local m_pImage_Hero_right = nil
local m_p_Label_Name_left = nil
local m_p_Label_Text_left = nil

local m_p_Label_Name_right = nil
local m_p_Label_Text_right = nil

local m_p_Image_Back = nil
local m_p_Image_Back_0 = nil

local INTERVAL_TIME = 0.1

local m_guide_CallBack = nil 


local m_bActionOut = false

local function InitVars()
	m_playerHeroTalk = nil
end

function setCallBackFun(funCallBack)
	m_ptalkOverCallBackFun = funCallBack
end

function SetGuideBackFun(funCallBack)
	m_guide_CallBack = funCallBack
end

function TalkLogic(talkId)
	
	require "Script/serverDB/herotalk"
	local tempTable = herotalk.getDataById(talkId)
	local hero_name = tempTable[1]
	local hero_img_left = tempTable[2]
	local hero_img_right = tempTable[3]
	local talk_text = tempTable[4]
	local next_id = tempTable[5]
	local pre_id = talkId
	if m_ptalkOverCallBackFun ~= nil then m_ptalkOverCallBackFun(talkId, next_id) end
	local tick_event = nil
	local bEnable = true
	m_bActionOut = false
    if tonumber(server_mainDB.getMainData("gender")) == 2 then
    	if hero_img_left == "zhujue" then   
    		hero_img_left = "banshenxiang_nvzhu"
    		hero_name = server_mainDB.getMainData("name")
    	end
	else		
	    if hero_img_left == "zhujue" then
	    	hero_img_left = "banshenxiang_nanzhu"
	    	hero_name = server_mainDB.getMainData("name")
	    end			
	end
	local function TalkSide(nSide)
		
		if tonumber(nSide) == 1 then
			-- left	
			m_pleftPanel:setVisible(true)
			Panel_right:setVisible(false)
			m_pImage_Hero_left:loadTexture("Image/imgres/hero/body_img/" .. hero_img_left .. ".png")
			m_pImage_Hero_left:setScale(1)
			m_pImage_Hero_left:setColor(COLOR_White)
			local tempTableRight = herotalk.getDataById(next_id)
			m_pImage_Hero_right:loadTexture("Image/imgres/hero/body_img/" .. hero_img_right .. ".png")
			m_pImage_Hero_right:setScaleX(-0.7)
			m_pImage_Hero_right:setScaleY(0.7)
			--m_pImage_Hero_right:setColor(ccc3(0xbf,0xaa,0xaa))
			--m_p_Label_Text_left:setText(talk_text)
			m_p_Label_Name_left:setText(hero_name)
			if m_p_Label_Text_left ~= nil then
				m_p_Label_Text_left:removeFromParentAndCleanup(true)
				m_p_Label_Text_left = nil
			end
			m_p_Label_Text_left = LabelLayer.CreateRichTextLabel(talk_text,1500)
			m_p_Label_Text_left:setPosition(ccp(-350, 0))
			m_p_Image_Back:addChild(m_p_Label_Text_left)

		else
			-- right
			if tonumber(server_mainDB.getMainData("gender")) == 2 then
		    	if hero_img_right == "zhujue" then   
		    		hero_img_right = "banshenxiang_nvzhu"
		    		hero_name = server_mainDB.getMainData("name")
		    	end
			else		
			    if hero_img_right == "zhujue" then
			    	hero_img_right = "banshenxiang_nanzhu"
			    	hero_name = server_mainDB.getMainData("name")
			    end			
			end
			m_pleftPanel:setVisible(false)
			Panel_right:setVisible(true)
			m_pImage_Hero_left:loadTexture("Image/imgres/hero/body_img/" .. hero_img_left .. ".png")--测试
			m_pImage_Hero_left:setScale(0.7)
			--m_pImage_Hero_left:setColor(ccc3(0xbf,0xaa,0xaa))
			local tempTableRight = herotalk.getDataById(next_id)
			m_pImage_Hero_right:loadTexture("Image/imgres/hero/body_img/" .. hero_img_right .. ".png")
			m_pImage_Hero_right:setScaleX(-1)
			m_pImage_Hero_right:setScaleY(1)
			m_pImage_Hero_right:setColor(COLOR_White)
			--m_p_Label_Text_right:setText(talk_text)
			m_p_Label_Name_right:setText(hero_name)
			if m_p_Label_Text_right ~= nil then
				m_p_Label_Text_right:removeFromParentAndCleanup(true)
				m_p_Label_Text_right = nil
			end
			m_p_Label_Text_right = LabelLayer.CreateRichTextLabel(talk_text,1000)
			m_p_Label_Text_right:setPosition(ccp(-150, 0)) --250
			m_p_Image_Back_0:addChild(m_p_Label_Text_right)
		end
	end
	
	local function _Image_Back_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
		--Pause()
			if bEnable == false then return end
			if tonumber(next_id) == 0 then
    			local pPanelAll = tolua.cast(m_playerHeroTalk:getWidgetByName("Panel_all"), "Layout")
			    pPanelAll:setVisible(false)

		        local function doLogic()
					if m_ptalkOverCallBackFun ~= nil then m_ptalkOverCallBackFun(next_id, pre_id) end
					-- 没有对话了
					m_ptalkOverCallBackFun = nil
			        m_playerHeroTalk:removeFromParentAndCleanup(true)
			        m_playerHeroTalk = nil
					if m_guide_CallBack~=nil then
						m_guide_CallBack()
					end
				end
				
				if m_bActionOut == false then
					m_bActionOut = true
					local array_action = CCArray:create()
					array_action:addObject(CCDelayTime:create(0.5))
					array_action:addObject(CCCallFunc:create(doLogic))
					local actions = CCSequence:create(array_action)
					m_playerHeroTalk:runAction(actions)
					ActionManager:shareManager():playActionByName("HeroTalkLayer.json","Animation1")
				end
				return
			end
			tempTable = herotalk.getDataById(next_id)
			hero_name = tempTable[1]
			hero_img_left = tempTable[2]
			hero_img_right = tempTable[3]
			talk_text = tempTable[4]
			if m_ptalkOverCallBackFun ~= nil then m_ptalkOverCallBackFun(next_id, tempTable[5]) end
			pre_id = next_id
			next_id = tempTable[5]
			if tonumber(server_mainDB.getMainData("gender")) == 2 then
    			if hero_img_left == "zhujue" then    		
    				hero_img_left = "banshenxiang_nvzhu"
    				hero_name = server_mainDB.getMainData("name")
    			end
			else		
	    		if hero_img_left == "zhujue" then
	    			hero_img_left = "banshenxiang_nanzhu"
	    			hero_name = server_mainDB.getMainData("name")
	    		end			
			end
			TalkSide(tempTable[6])
		
			local function tick()
				bEnable = true
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(tick_event)
				tick_event = nil
			end
			if tick_event == nil then
				tick_event = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, INTERVAL_TIME, false)
			end
			bEnable = false
		end
	end
    m_p_Image_Back = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_Back"), "ImageView")
    m_p_Image_Back:setTouchEnabled(true)
    m_p_Image_Back:addTouchEventListener(_Image_Back_CallBack)
	
	m_p_Label_Name_left = Label:create()
	m_p_Label_Name_left:setFontSize(28)
	m_p_Label_Name_left:setColor(COLOR_Black)
	m_p_Label_Name_left:setPosition(ccp(0, 4))
	m_p_Label_Name_left:setText(hero_name)
    local Image_Name = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_Name"), "ImageView")
	Image_Name:addChild(m_p_Label_Name_left)
	
	-- m_p_Label_Text_left = Label:create()
	-- m_p_Label_Text_left:setText(talk_text)
	-- m_p_Label_Text_left:setFontSize(24)
	-- m_p_Label_Text_left:setColor(COLOR_White)
	-- m_p_Label_Text_left:setAnchorPoint(ccp(0,0.5))
	-- m_p_Label_Text_left:setPosition(ccp(-400, 0))
	-- m_p_Image_Back:addChild(m_p_Label_Text_left)
	-- print("talk_text = " .. talk_text)
	m_p_Label_Text_left = LabelLayer.CreateRichTextLabel(talk_text,1500)
	m_p_Label_Text_left:setPosition(ccp(-350, 0))
	m_p_Image_Back:addChild(m_p_Label_Text_left)
    m_pImage_Hero_left = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_Hero_left"), "ImageView")
	m_pImage_Hero_left:loadTexture("Image/imgres/hero/body_img/" .. hero_img_left .. ".png")
	
	
    m_p_Image_Back_0 = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_Back_0"), "ImageView")
    m_p_Image_Back_0:addTouchEventListener(_Image_Back_CallBack)
    local Panel_right1 = tolua.cast(m_playerHeroTalk:getWidgetByName("Panel_right"), "Layout")
    Panel_right1:addTouchEventListener(_Image_Back_CallBack)
    local Panel_left1 = tolua.cast(m_playerHeroTalk:getWidgetByName("Panel_left"), "Layout")
    Panel_left1:addTouchEventListener(_Image_Back_CallBack)
	
	m_p_Label_Name_right = Label:create()
	m_p_Label_Name_right:setFontSize(28)
	m_p_Label_Name_right:setColor(COLOR_Black)
	m_p_Label_Name_right:setText(hero_name)
	m_p_Label_Name_right:setPosition(ccp(0, 4))
    local Image_Name_0 = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_Name_0"), "ImageView")
	Image_Name_0:addChild(m_p_Label_Name_right)
	
	-- m_p_Label_Text_right = Label:create()
	-- m_p_Label_Text_right:setText(talk_text)
	-- m_p_Label_Text_right:setFontSize(24)
	-- m_p_Label_Text_right:setColor(COLOR_White)
	-- m_p_Label_Text_right:setAnchorPoint(ccp(0,0.5))
	-- m_p_Label_Text_right:setPosition(ccp(-300, 0))
	-- m_p_Image_Back_0:addChild(m_p_Label_Text_right)
	
	m_p_Label_Text_right = LabelLayer.CreateRichTextLabel(talk_text,1000)
	m_p_Label_Text_right:setPosition(ccp(-150, 0)) --250
	m_p_Image_Back_0:addChild(m_p_Label_Text_right)

    m_pImage_Hero_right = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_Hero_right"), "ImageView")
	m_pImage_Hero_right:loadTexture("Image/imgres/hero/body_img/" .. hero_img_right .. ".png")
	
    m_pleftPanel = tolua.cast(m_playerHeroTalk:getWidgetByName("Panel_left"), "Layout")
    Panel_right = tolua.cast(m_playerHeroTalk:getWidgetByName("Panel_right"), "Layout")
	
	TalkSide(tempTable[6])
	
end

function createHeroTalkUI(talkId)
	InitVars()
	m_playerHeroTalk = TouchGroup:create()									-- 背景层
    m_playerHeroTalk:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/HeroTalkLayer.json") )
	
    local pPanelAll = tolua.cast(m_playerHeroTalk:getWidgetByName("Panel_all"), "Layout")
    pPanelAll:setVisible(false)

	local function doLogic()
		-- body
    	pPanelAll:setVisible(true)
		TalkLogic(talkId)
	end
	local array_action = CCArray:create()
	array_action:addObject(CCDelayTime:create(0.5))
	array_action:addObject(CCCallFunc:create(doLogic))
	local actions = CCSequence:create(array_action)
	m_playerHeroTalk:runAction(actions)

	ActionManager:shareManager():playActionByName("HeroTalkLayer.json","Animation0")

    local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height

    m_playerHeroTalk:setPosition(ccp(nOff_W/2, nOff_H/2))

    local tableFixControl = {
    {
    	["off_x"] = 0,
    	["off_y"] = 0,
    	-- ["control"] = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_left_hand"), "ImageView"),
    },
    {
    	["off_x"] = 0,
    	["off_y"] = 0,
    	["control"] = tolua.cast(m_playerHeroTalk:getWidgetByName("Panel_right"), "Layout"),
    },
    {
    	["off_x"] = 0,
    	["off_y"] = 0,
    	["control"] = tolua.cast(m_playerHeroTalk:getWidgetByName("Image_Hero_right"), "ImageView"),
    },
}
	for key,value in pairs(tableFixControl) do
		if value["control"] ~= nil then
			local nWidth = value["control"]:getPositionX() - nOff_W + value["off_x"]
			local nHeight = value["control"]:getPositionY() - nOff_H + value["off_y"]
    		value["control"]:setPosition(ccp(nWidth, nHeight))
		end
	end

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	m_playerHeroTalk:setTouchPriority(ENUM_TOUCH_LEVEL.ENUM_TOUCH_LEVEL_HEROTALK)
	runningScene:addChild(m_playerHeroTalk, 2000, layerHeroTalk_Tag)
end


