-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    Log("----------------------------------------")
    Log("LUA ERROR: " .. tostring(msg) .. "\n")
    Log(debug.traceback())
    Log("----------------------------------------")
end

module("InputUserLayer", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

local text_username = nil
local text_password = nil

local function CreateEditBox(loginLayer)

    local Image_user = tolua.cast(loginLayer:getWidgetByName("Image_user"), "ImageView")
    local Image_password = tolua.cast(loginLayer:getWidgetByName("Image_password"), "ImageView")

	local user_pt = Image_user:getWorldPosition()
	local password_pt = Image_password:getWorldPosition()
	
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	text_username = CCEditBox:create (CCSizeMake(300,53), CCScale9Sprite:create("Image/common/text_bk.png"))
	text_username:setPosition(ccp(user_pt.x, user_pt.y))
	text_username:setPlaceHolder("请输入账号")
	text_username:setPlaceholderFontColor(ccc3(177, 177, 177))
	-- text_username:setPlaceholderFontSize(17)
	--text_username:setFont(g_sFontName,24)
	text_username:setFontColor(ccc3( 0x78, 0x25, 0x00))
	text_username:setMaxLength(24)
	text_username:setReturnType(kKeyboardReturnTypeDone)
	text_username:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	text_username:setText("请输入账号")
	text_username:setTouchPriority(-129)
	runningScene:addChild(text_username, 1, 100)
	
	text_password = CCEditBox:create (CCSizeMake(300,53), CCScale9Sprite:create("Image/common/text_bk.png"))
	text_password:setPosition(ccp(password_pt.x, password_pt.y))
	text_password:setPlaceHolder("请输入密码")
	text_password:setPlaceholderFontColor(ccc3(177, 177, 177))
	text_password:setFontColor(ccc3( 0x78, 0x25, 0x00))
	text_password:setMaxLength(24)
	text_password:setReturnType(kKeyboardReturnTypeDone)
	text_password:setInputFlag (kEditBoxInputFlagPassword)
	text_password:setText("请输入密码")
	text_password:setTouchPriority(-129)
	runningScene:addChild(text_password, 1, 101)
end

local function RegBtnHandle(loginLayer)

	local function _Button_login_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			Log("登陆")
			local username = text_username:getText()
			local password = text_password:getText()
			if username == "" then
				Log("用户名不能为空")
			end
			if password == "" then
				Log("密码不能为空")
			end
			-- 去登陆
			---------------------------------------------
		end
	end
	
	local function _Button_reg_user_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			Log("新用户注册")
		end
	end
	
	local function _Button_close_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			Log("关闭")
			local Panel_Login_in = tolua.cast(loginLayer:getWidgetByName("Panel_Login_in"), "PageView")
			Panel_Login_in:setVisible(false)
			Panel_Login_in:setTouchEnabled(false)
			local username = text_username:getText()
			local password = text_password:getText()
			LoginLayer.ShowEnterPanel(username, password)
			
			local runningScene = CCDirector:sharedDirector():getRunningScene()
			runningScene:removeChildByTag(100, true)
			runningScene:removeChildByTag(101, true)
		end
	end
    local Button_login = tolua.cast(loginLayer:getWidgetByName("Button_login"), "Button")
    Button_login:addTouchEventListener(_Button_close_Btn_CallBack)
    local Button_reg_user = tolua.cast(loginLayer:getWidgetByName("Button_reg_user"), "Button")
    Button_reg_user:addTouchEventListener(_Button_close_Btn_CallBack)
    local Button_close = tolua.cast(loginLayer:getWidgetByName("Button_close"), "Button")
    Button_close:addTouchEventListener(_Button_close_Btn_CallBack)
	
end

function createInputUserUI(loginLayer)

	if loginLayer ~= nil then
		
		local Panel_Login_in = tolua.cast(loginLayer:getWidgetByName("Panel_Login_in"), "PageView")
		if Panel_Login_in ~= nil then
			Panel_Login_in:setVisible(true)
			Panel_Login_in:setTouchEnabled(true)
			CreateEditBox(loginLayer)
			RegBtnHandle(loginLayer)
		else
			Log("Panel_Login_in = nil")
		end
		
	else
		Log("loginLayer == nil")
	end

	
	
	return layerInputUser
	
end

--xpcall(main, __G__TRACKBACK__)
