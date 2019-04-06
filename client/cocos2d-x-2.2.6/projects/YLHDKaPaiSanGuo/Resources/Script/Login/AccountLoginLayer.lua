require "Script/Login/LoginCommon"
require "Script/Login/RegisterLayer"

module("AccountLoginLayer", package.seeall)

---celina 0203 账户登陆界面
--变量
local m_layerAccountLogin   = nil 
local m_editbox_account     = nil 
local m_editbox_password    = nil 
--逻辑部分
local saveUser         = LoginLogic.SaveUserInfo
local CheckLogin = LoginLogic.CheckRegisterLogin
local toRegisterLayer  = RegisterLayer.createLayerRegister

--描边
local LableLine  = LabelLayer.createStrokeLabel

function DeleteMySelf()
	m_layerAccountLogin:removeFromParentAndCleanup(true)
	m_layerAccountLogin = nil 
end

local function InitVars()
	m_layerAccountLogin = nil 
end
function Editbox_b_show (bShow)
	if m_editbox_account~=nil and m_editbox_password~=nil then
		m_editbox_account:setTouchEnabled(bShow)
		m_editbox_password:setTouchEnabled(bShow)
	end
	
end
local function showLayerAccount()
	--登陆界面的背景图片
	local l_img_bg = tolua.cast(m_layerAccountLogin:getWidgetByName("img_ac_bg"),"ImageView")
	--登陆名字
	local l_img_title_bg = tolua.cast(m_layerAccountLogin:getWidgetByName("img_n_bg"),"ImageView")
	local l_label_title = LableLine(24,CommonData.g_FONT1,"登录",ccp(0,4),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	if l_img_title_bg:getChildByTag(3)~=nil then
		l_img_title_bg:getChildByTag(3):setVisible(false)
		l_img_title_bg:getChildByTag(3):removeFromParentAndCleanup(true)
	end
	l_img_title_bg:addChild(l_label_title,3,3)
	local bg_x = l_img_bg:getPositionX()
	local bg_y = l_img_bg:getPositionY()
	--账号
	m_editbox_account = CCEditBox:create(CCSizeMake(298,44),CCScale9Sprite:create("Image/imgres/login/bg_input.png"))
	m_editbox_account:setPosition(ccp(bg_x+35,bg_y+48))
	
	m_editbox_account:setFontName(CommonData.g_FONT3)
	m_editbox_account:setMaxLength(20)
	m_editbox_account:setPlaceholderFontColor(ccc3(75,46,31))
	--m_editbox_account:setPlaceholderFontColor(ccc3(255,255,255))
	m_editbox_account:setPlaceholderFontSize(30)
	m_editbox_account:setFontColor(ccc3(75,46,31))
	--m_editbox_account:setFontColor(ccc3(255,255,255))
	m_editbox_account:setFontSize(30)
	m_editbox_account:setPlaceHolder("账号")
	
	m_editbox_account:setReturnType(kKeyboardReturnTypeDone)
	m_editbox_account:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_editbox_account:setTouchPriority(-129)
	if m_layerAccountLogin:getChildByTag(200)~=nil then
		m_layerAccountLogin:getChildByTag(200):setVisible(false)
		m_layerAccountLogin:getChildByTag(200):removeFromParentAndCleanup(true)
	end
	m_layerAccountLogin:addChild(m_editbox_account,0,200)
	
	
	--密码
	m_editbox_password = CCEditBox:create(CCSizeMake(298,44),CCScale9Sprite:create("Image/imgres/login/bg_input.png"))
	m_editbox_password:setPosition(ccp(bg_x+35,bg_y-12))
	m_editbox_password:setFontColor(ccc3(75,46,31))
	m_editbox_password:setFontSize(30)
	m_editbox_password:setFontName(CommonData.g_FONT3)
	m_editbox_password:setMaxLength(24)
	m_editbox_password:setPlaceholderFontColor(ccc3(75,46,31))
	m_editbox_password:setPlaceholderFontSize(30)
	m_editbox_password:setReturnType(kKeyboardReturnTypeDone)
	m_editbox_password:setInputFlag(kEditBoxInputFlagPassword)
	m_editbox_password:setTouchPriority(-129)
	m_editbox_password:setPlaceHolder("密码")
	if m_layerAccountLogin:getChildByTag(201)~=nil then
		m_layerAccountLogin:getChildByTag(201):setVisible(false)
		m_layerAccountLogin:getChildByTag(201):removeFromParentAndCleanup(true)
	end
	m_layerAccountLogin:addChild(m_editbox_password,0,201)
	
	
end
local function linkServer()
	--print(m_editbox_password:getText())
	--Pause()
	local bError = CheckLogin(m_editbox_account:getText(),m_editbox_password:getText())
	if bError == false then
		return 
	else
		local function accountCallBack()
			local btn_enterGame = tolua.cast(m_layerAccountLogin:getWidgetByName("btn_enterGame"),"Button")
			btn_enterGame:setTouchEnabled(false)
			DeleteMySelf()
			--将父类也删除
			LoginLayer.deleteLayer()
		end
		saveUser(m_editbox_account:getText(),m_editbox_password:getText())
		LoginCommon.handleToMainLayer(accountCallBack,true)
	
	end
	
end
function SetEnterGame(bTouch )
	if m_layerAccountLogin~=nil then
		local btn_enterGame = tolua.cast(m_layerAccountLogin:getWidgetByName("btn_enterGame"),"Button")
		btn_enterGame:setTouchEnabled(bTouch)
	end
end
local function _Btn_EnterGame_CallBack()
	--进入游戏
	--联网登陆
	--保存用户名和密码
	
	linkServer()
end
local function _Btn_Register_CallBack( )
	Editbox_b_show(false)
	local layerRegister = toRegisterLayer()
	if m_layerAccountLogin:getChildByTag(LoginCommon.TAG_LAYER_ADD)~=nil then
		m_layerAccountLogin:getChildByTag(LoginCommon.TAG_LAYER_ADD):setVisible(false)
		m_layerAccountLogin:getChildByTag(LoginCommon.TAG_LAYER_ADD):removeFromParentAndCleanup(true)
	end
	m_layerAccountLogin:addChild(layerRegister,LoginCommon.TAG_LAYER_ADD,LoginCommon.TAG_LAYER_ADD)
end
local function _Btn_Close_CallBack()
	DeleteMySelf()
end
function createLayerAccount()
	InitVars()
	m_layerAccountLogin = TouchGroup:create()
	m_layerAccountLogin:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/AccountLoginLayer.json" ) )
	showLayerAccount()
	local btn_enterGame = tolua.cast(m_layerAccountLogin:getWidgetByName("btn_enterGame"),"Button")
	CreateBtnCallBack(btn_enterGame,"进入游戏",36,_Btn_EnterGame_CallBack)
	
	--一秒注册
	local btn_register = tolua.cast(m_layerAccountLogin:getWidgetByName("btn_register"),"Button")
	CreateBtnCallBack(btn_register,"一秒注册",36,_Btn_Register_CallBack)
	
	local btn_close = tolua.cast(m_layerAccountLogin:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack(btn_close,nil,0,_Btn_Close_CallBack)
	return m_layerAccountLogin
end