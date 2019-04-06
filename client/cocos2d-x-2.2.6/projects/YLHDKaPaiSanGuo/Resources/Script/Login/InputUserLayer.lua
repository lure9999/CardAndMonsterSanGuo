-- for CCLuaEngine traceback

module("InputUserLayer", package.seeall)

local m_strText_username = nil
local m_strText_password = nil
--CCTextFieldTTF
local function CreateEditBox(loginLayer)

    local Image_user = tolua.cast(loginLayer:getWidgetByName("Image_user"), "ImageView")
    local Image_password = tolua.cast(loginLayer:getWidgetByName("Image_password"), "ImageView")

	local user_pt = Image_user:getWorldPosition()
	local password_pt = Image_password:getWorldPosition()
	
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	m_strText_username = CCEditBox:create (CCSizeMake(300,53), CCScale9Sprite:create("Image/imgres/common/text_bk.png"))
	m_strText_username:setPosition(ccp(user_pt.x - CommonData.g_Origin.x, user_pt.y - CommonData.g_Origin.y))
	m_strText_username:setPlaceholderFontColor(ccc3(177, 177, 177))
	-- m_strText_username:setPlaceholderFontSize(17)
	--m_strText_username:setFont(g_sFontName,24)
	m_strText_username:setFontColor(ccc3( 0x78, 0x25, 0x00))
	m_strText_username:setMaxLength(24)
	m_strText_username:setReturnType(kKeyboardReturnTypeDone)
	m_strText_username:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	--m_strText_username:setText("请输入账号")
	m_strText_username:setPlaceHolder("plase input your count")
	m_strText_username:setTouchPriority(-129)
	runningScene:addChild(m_strText_username, 1, 100)
	
	m_strText_password = CCEditBox:create (CCSizeMake(300,53), CCScale9Sprite:create("Image/imgres/common/text_bk.png"))
	m_strText_password:setPosition(ccp(password_pt.x - CommonData.g_Origin.x, password_pt.y - CommonData.g_Origin.y))
	m_strText_password:setPlaceholderFontColor(ccc3(177, 177, 177))
	m_strText_password:setFontColor(ccc3( 0x78, 0x25, 0x00))
	m_strText_password:setMaxLength(24)
	m_strText_password:setReturnType(kKeyboardReturnTypeDone)
	m_strText_password:setInputFlag (kEditBoxInputFlagPassword)
	--m_strText_password:setText("请输入密码")
	m_strText_password:setTouchPriority(-129)
	m_strText_password:setPlaceHolder("plase input your count")
	runningScene:addChild(m_strText_password, 1, 101)
end

local function RegBtnHandle(loginLayer)

	local function _Button_login_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			--print("登陆")
			local username = m_strText_username:getText()
			local password = m_strText_password:getText()
			if username == "" then
				print("用户名不能为空")
			end
			if password == "" then
				print("密码不能为空")
			end
			-- 去登陆
			---------------------------------------------
		end
	end
	
	local function _Button_reg_user_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			print("新用户注册")
		end
	end
	
	local function _Button_close_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			--print("关闭")
			local Panel_Login_in = tolua.cast(loginLayer:getWidgetByName("Panel_Login_in"), "PageView")
			Panel_Login_in:setVisible(false)
			Panel_Login_in:setTouchEnabled(false)
			local username = m_strText_username:getText()
			local password = m_strText_password:getText()
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
			print("Panel_Login_in = nil")
		end
		
	else
		print("loginLayer == nil")
	end

	
	
	return layerInputUser
	
end

