
module("RegisterLogin", package.seeall)


--[[RegisterType = {
	noName = 1 ,
	noPassWord = 2 ,
	noRePassWord = 3,
	register  = 4,
}]]--

--local sceneRegister = nil 
local m_playerRegister = nil

local m_register_userName = nil
local m_register_userPassWord = nil
local m_register_userPassWord_re = nil

local function initData()
    
end

local function clearData()
    --sceneRegister = nil
	m_register_userName = nil
	m_register_userPassWord = nil
	m_register_userPassWord_re = nil
	m_playerRegister:removeFromParentAndCleanup(true)
	m_playerRegister = nil
	
    
	
end

local function exitRegisterLoginLayer()
    clearData()
    --CCDirector:sharedDirector():popScene()
end

--判断是否都为nil
--[[local function registerLoginCon()
    if m_register_userName == nil then
	    return RegisterType.noName
	end
	if m_register_userPassWord == nil then 
	    return RegisterType.noPassWord
	end
	if m_register_userPassWord_re == nil then
	    return RegisterType.noRePassWord
	end
	
	if m_register_userName ~=nil then
	    if m_register_userPassWord ~=nil then
		    if m_register_userPassWord_re ~=nil then
			    return RegisterType.register
			end
		end
	end
end]]--
function createRegisterLogin()
    --得到界面
	m_playerRegister = TouchGroup:create()
	m_playerRegister:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/RegisterLoginLayer.json" ) )
	
	
	--输入账号
	--修改输入的方式 带光标
	--得到背景
	local img_register_inputBG = tolua.cast(m_playerRegister:getWidgetByName("img_registerBG"),"ImageView")
	local size_input_x = img_register_inputBG:getContentSize().width
	local size_input_y = img_register_inputBG:getContentSize().height
	
	m_register_userName = CCEditBox:create(CCSizeMake(264,46),CCScale9Sprite:create("Image/login/register_label_bg.png"))
	m_register_userName:setPosition(ccp(size_input_x-70,size_input_y+132))
	m_register_userName:setFontName(CommonData.g_FONT3)
	m_register_userName:setFontSize(30)
	m_register_userName:setPlaceholderFontColor(ccc3(177,177,177))
	m_register_userName:setPlaceholderFontSize(24)
	m_register_userName:setFontColor(ccc3(0x78, 0x25, 0x00))
	m_register_userName:setMaxLength(30)
	m_register_userName:setReturnType(kKeyboardReturnTypeDone)
	m_register_userName:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	m_register_userName:setPlaceHolder("邮箱/手机号/用户名")
	--m_register_userName:setText("邮箱/手机号/用户名")
	m_register_userName:setTouchPriority(-129)
	m_playerRegister:addChild(m_register_userName, 1, 100)
	
	
	m_register_userPassWord = CCEditBox:create(CCSizeMake(264,46),CCScale9Sprite:create("Image/login/register_label_bg.png"))
	m_register_userPassWord:setPosition(ccp(size_input_x-70,size_input_y+55))
	m_register_userPassWord:setFontName(CommonData.g_FONT3)
	m_register_userPassWord:setPlaceholderFontColor(ccc3(177,177,177))
	m_register_userPassWord:setPlaceholderFontSize(30)
	m_register_userPassWord:setFontColor(ccc3(0x78, 0x25, 0x00))
	--m_register_userPassWord:setText("请输入密码")
	m_register_userPassWord:setFontSize(30)
	m_register_userPassWord:setMaxLength(24)
	m_register_userPassWord:setReturnType(kKeyboardReturnTypeDone)
	m_register_userPassWord:setInputFlag (kEditBoxInputFlagPassword)
	m_register_userPassWord:setTouchPriority(-129)
	m_register_userPassWord:setPlaceHolder("请输入密码")
	m_playerRegister:addChild(m_register_userPassWord, 1, 101)
	
	m_register_userPassWord_re = CCEditBox:create(CCSizeMake(264,46),CCScale9Sprite:create("Image/login/register_label_bg.png"))
	m_register_userPassWord_re:setPosition(ccp(size_input_x-70,size_input_y-20))
	m_register_userPassWord_re:setFontName(CommonData.g_FONT3)
	m_register_userPassWord_re:setPlaceholderFontColor(ccc3(177,177,177))
	m_register_userPassWord_re:setPlaceholderFontSize(30)
	m_register_userPassWord_re:setFontColor(ccc3(0x78, 0x25, 0x00))
	--m_register_userPassWord_re:setText("请确认密码")
	m_register_userPassWord_re:setFontSize(30)
	m_register_userPassWord_re:setMaxLength(24)
	m_register_userPassWord_re:setReturnType(kKeyboardReturnTypeDone)
	m_register_userPassWord_re:setInputFlag (kEditBoxInputFlagPassword)
	m_register_userPassWord_re:setTouchPriority(-129)
	m_register_userPassWord_re:setPlaceHolder("请确认密码")
	m_playerRegister:addChild(m_register_userPassWord_re, 1, 102)
	
	
	--注册并登陆按钮
	local function _Button_RegisterLogin_CallBack(sender,eventType)
	    if eventType == TouchEventType.ended then
			--m_playerRegister:removeFromParentAndCleanup(true)
			--m_playerRegister = nil
		    --require "Script/Login/CreateRoleLayer"
			--CreateRoleLayer.createNewRoleLayer()
			AudioUtil.PlayBtnClick()
		end
	end
	local Button_RegisterLogin = tolua.cast(m_playerRegister:getWidgetByName("btn_registerLogin"),"TextField")
	Button_RegisterLogin:addTouchEventListener(_Button_RegisterLogin_CallBack)
	
	--关闭返回
	local function _Button_Register_Close_CallBack(sender,eventType)
	    if eventType == TouchEventType.ended then
		    exitRegisterLoginLayer()
			require "Script/Login/NLoginLayer"
			local scene_now = CCDirector:sharedDirector():getRunningScene()
			local layer_now = NLoginLayer.createNLoginUI()
			if layer_now~=nil then
				scene_now:addChild(layer_now,layerNLogin_Tag,layerNLogin_Tag)
			end
		end
	end
	
	local Button_Register_Close = tolua.cast(m_playerRegister:getWidgetByName("btn_register_close"),"Button")
	Button_Register_Close:addTouchEventListener(_Button_Register_Close_CallBack)
	--CCDirector:sharedDirector():pushScene(sceneRegister)
	
	return m_playerRegister
end