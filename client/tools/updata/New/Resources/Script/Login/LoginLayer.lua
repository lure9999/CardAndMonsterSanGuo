-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    Log("----------------------------------------")
    Log("LUA ERROR: " .. tostring(msg) .. "\n")
    Log(debug.traceback())
    Log("----------------------------------------")
end

module("LoginLayer", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

local layerLogin = nil

function ShowEnterPanel(username, password)
    local Panel_Enter = tolua.cast(layerLogin:getWidgetByName("Panel_Enter"), "PageView")
	Panel_Enter:setVisible(true)
	Panel_Enter:setTouchEnabled(true)
    local Button_UserName = tolua.cast(layerLogin:getWidgetByName("Button_UserName"), "Button")
	Button_UserName:setTitleText(username)
end

function SetLoadingInfo(text, nCurCount, nAllCount)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local loginTemp = runningScene:getChildByTag(layerLogin_Tag)
	if loginTemp ~= nil then
		local Panel_Loading = tolua.cast(loginTemp:getWidgetByName("Panel_Loading"), "PageView")
		Panel_Loading:setVisible(true)
		Panel_Loading:setTouchEnabled(true)
		local fPer = nCurCount/nAllCount
		
		local ProgressBar_Loading = tolua.cast(loginTemp:getWidgetByName("ProgressBar_Loading"), "LoadingBar")
		fPer = fPer*100
		ProgressBar_Loading:setPercent(fPer)
		
		local Label_Text = tolua.cast(loginTemp:getWidgetByName("Label_Text"), "Label")
		Label_Text:setText("正在加载资源。。。" ..  math.ceil(fPer) .. "%)")
		local Image_Sword = tolua.cast(loginTemp:getWidgetByName("Image_Sword"), "ImageView")
		local xPt = -240+(480/100)*fPer
		Image_Sword:setPosition(ccp(xPt, Image_Sword:getPositionY()))
		
		if fPer == 100 then
			-- 显示主界面
			require "Script/Main/MainScene.lua"
			MainScene.createMainUI()
		end
	end
end

function createLoginUI()

	sceneGame = CCScene:create()
	print("ssss")
	layerLogin = TouchGroup:create()									-- 背景层
    layerLogin:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/LoginLayer.json") )
	
	sceneGame:addChild(layerLogin, 0, layerLogin_Tag)
	
    local Panel_Enter = tolua.cast(layerLogin:getWidgetByName("Panel_Enter"), "PageView")
	Panel_Enter:setVisible(true)
	
    local Panel_Login_in = tolua.cast(layerLogin:getWidgetByName("Panel_Login_in"), "PageView")
	Panel_Login_in:setVisible(false)
	Panel_Login_in:setTouchEnabled(false)
	
    local Panel_Loading = tolua.cast(layerLogin:getWidgetByName("Panel_Loading"), "PageView")
	Panel_Loading:setVisible(false)
	Panel_Loading:setTouchEnabled(false)
	
	local function _Button_UserName_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			Log("登陆界面")
			require "Script/Login/InputUserLayer.lua"
			InputUserLayer.createInputUserUI(layerLogin)
			
			Panel_Enter:setVisible(false)
			Panel_Enter:setTouchEnabled(false)
		end
	end
    local Button_UserName = tolua.cast(layerLogin:getWidgetByName("Button_UserName"), "Button")
    Button_UserName:addTouchEventListener(_Button_UserName_Btn_CallBack)
	
	local function _Button_ServerName_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			Log("服务器列表")
		end
	end
    local Button_ServerName = tolua.cast(layerLogin:getWidgetByName("Button_ServerName"), "Button")
    Button_ServerName:addTouchEventListener(_Button_ServerName_Btn_CallBack)
	Button_ServerName:setTitleText("暂无")
	
	local function _Button_Enter_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			Log("进入游戏")
			-- 钱坤去登陆
			-------------------------------------------------------
			-- 显示加载界面
			Panel_Enter:setVisible(false)
			Panel_Enter:setTouchEnabled(false)
			Panel_Loading:setVisible(true)
			Panel_Loading:setTouchEnabled(true)
			
			require "Script/Login/LoadingLayer"
			LoadingLayer.createLoadingLayerUI()
		end
	end
    local Button_Enter = tolua.cast(layerLogin:getWidgetByName("Button_Enter"), "Button")
    Button_Enter:addTouchEventListener(_Button_Enter_Btn_CallBack)
	
    CCDirector:sharedDirector():replaceScene(sceneGame)
	
	------------------------------------------------music-----------------------------------------------------------------------
    AudioUtil.playBgm("audio/main.mp3")
	------------------------------------------------other------------------------------------------------------------------------
	
end

--xpcall(main, __G__TRACKBACK__)
