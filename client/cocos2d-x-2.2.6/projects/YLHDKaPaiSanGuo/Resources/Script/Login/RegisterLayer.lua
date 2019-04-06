
require "Script/Login/RegisterAgreementLayer"

module("RegisterLayer", package.seeall)


----变量
local m_layerRegister      = nil 
local m_editbox_account_r    = nil 
local m_editbox_password_r  = nil 
local m_editbox_a_password_r = nil 


TAG_TITLE_LABLE_R = 2
TAG_EDITBOX_ACCOUNT = 50
TAG_EDITBOX_PASSWORD = 51
TAG_EDITBOX_A_PASSWORD = 52

local addLable = LoginCommon.addLableToButton
local layerRegisterAgreement = RegisterAgreementLayer.createLayerAgreement
local EnterGameLogin = LoginCommon.handleToMainLayer
local SaveUser  = LoginLogic.SaveUserInfo

local CheckLogin = LoginLogic.CheckRegisterLogin

local function InitVars()
	m_layerRegister = nil 
	m_editbox_account_r = nil 
	m_editbox_password_r = nil 
	m_editbox_a_password_r = nil 
end
local function deleteRegister()
	m_layerRegister:removeFromParentAndCleanup(true)
	m_layerRegister = nil 
end
local function _Btn_Close_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		sender:setScale(0.9)
		AccountLoginLayer.Editbox_b_show(true)
		deleteRegister()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end
local function _Btn_EnterGame_CallBack()
	local bError = CheckLogin(m_editbox_account_r:getText(),m_editbox_password_r:getText(),m_editbox_a_password_r:getText())
	if bError==false then
		setBtnEnabled(true)
		return 
	else
		SaveUser(m_editbox_account_r:getText(),m_editbox_password_r:getText())
		local function RegisterCallBack()
			setBtnEnabled(false)
			deleteRegister()
			AccountLoginLayer.DeleteMySelf()
			LoginLayer.deleteLayer()
		end
		EnterGameLogin(RegisterCallBack,true)
	end
	
	
end
local function initData()

end
function setBtnEnabled(bEnabled)
	m_editbox_account_r:setTouchEnabled(bEnabled)
	m_editbox_password_r:setTouchEnabled(bEnabled)
	m_editbox_a_password_r:setTouchEnabled(bEnabled)
	
end
local function createEditBox(str_info,pos,tag,nFalg)
	local l_edit_box = CCEditBox:create(CCSizeMake(298,44),CCScale9Sprite:create("Image/imgres/login/bg_input.png"))
	l_edit_box:setPosition(pos)
	l_edit_box:setFontColor(ccc3(75,46,31))
	l_edit_box:setFontSize(30)
	l_edit_box:setFontName(CommonData.g_FONT3)
	l_edit_box:setMaxLength(20)
	l_edit_box:setPlaceholderFontColor(ccc3(75,46,31))
	l_edit_box:setPlaceholderFontSize(30)
	l_edit_box:setReturnType(kKeyboardReturnTypeDone)
	l_edit_box:setInputFlag(nFalg)
	l_edit_box:setTouchPriority(-129)
	l_edit_box:setPlaceHolder(str_info)
	if m_layerRegister:getChildByTag(tag)~=nil then
		m_layerRegister:getChildByTag(tag):setVisible(false)
		m_layerRegister:getChildByTag(tag):removeFromParentAndCleanup(true)
	end
	m_layerRegister:addChild(l_edit_box,tag,tag)
	return l_edit_box
end
local function  _Lable_Info_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		setBtnEnabled(false)
		local layer_r = layerRegisterAgreement()
		if m_layerRegister:getChildByTag(LoginCommon.TAG_LAYER_ADD)~=nil then
			m_layerRegister:getChildByTag(LoginCommon.TAG_LAYER_ADD):setVisible(false)
			m_layerRegister:getChildByTag(LoginCommon.TAG_LAYER_ADD):removeFromParentAndCleanup(true)
		end
		m_layerRegister:addChild(layer_r,LoginCommon.TAG_LAYER_ADD,LoginCommon.TAG_LAYER_ADD)
	end
end
local function initUI()
	--进入游戏按钮
	local btn_enter_game_r = tolua.cast(m_layerRegister:getWidgetByName("btn_enter_r"),"Button")
	CreateBtnCallBack(btn_enter_game_r,"进入游戏",36,_Btn_EnterGame_CallBack)
	--标题
	local label_title = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"用户名注册",ccp(0,4),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	local img_bg_title = tolua.cast(m_layerRegister:getWidgetByName("img_title_bg_r"),"ImageView")
	if img_bg_title:getChildByTag(TAG_TITLE_LABLE_R)~=nil then
		img_bg_title:getChildByTag(TAG_TITLE_LABLE_R):setVisible(false)
		img_bg_title:getChildByTag(TAG_TITLE_LABLE_R):removeFromParentAndCleanup(true)
	end
	img_bg_title:addChild(label_title,TAG_TITLE_LABLE_R,TAG_TITLE_LABLE_R)
	
	--底图
	local img_bg_r = tolua.cast(m_layerRegister:getWidgetByName("img_bg_register"),"ImageView")
	--输入框
	local size_x = m_layerRegister:getContentSize().width/2
	local size_y = m_layerRegister:getContentSize().height/2
	m_editbox_account_r = createEditBox("手动输入账号",ccp(size_x+20,size_y+66*2),TAG_EDITBOX_ACCOUNT,kEditBoxInputFlagInitialCapsWord)
	m_editbox_password_r = createEditBox("密码",ccp(size_x+20,size_y+69),TAG_EDITBOX_PASSWORD,kEditBoxInputFlagPassword)
	m_editbox_a_password_r = createEditBox("重新输入密码",ccp(size_x+20,size_y+8),TAG_EDITBOX_A_PASSWORD,kEditBoxInputFlagPassword)
	
	--协议
	local lable_info = tolua.cast(m_layerRegister:getWidgetByName("label_xy"),"Label")
	lable_info:setTouchEnabled(true)
	lable_info:addTouchEventListener(_Lable_Info_CallBack)
end
function createLayerRegister()
	InitVars()
	m_layerRegister = TouchGroup:create()
	m_layerRegister:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/RegisterLoginLayer.json" ) )
	initData()
	initUI()
	--返回按钮
	local btn_close_r = tolua.cast(m_layerRegister:getWidgetByName("btn_close_r"),"Button")
	
	btn_close_r:addTouchEventListener(_Btn_Close_CallBack)
	return m_layerRegister
end