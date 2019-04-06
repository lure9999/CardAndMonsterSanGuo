
--create by celina ---

----登陆界面-------
module("LoginLayer", package.seeall)
require "Script/Login/LoginLogic"
require "Script/Login/ServerChooseLayer"
require "Script/Login/AccountLoginLayer"
require "Script/Login/LoginCommon"
require "Script/Common/Common"


LOGIN_SATE = {
	LOGIN_SATE_FIRST = 0,--之前没有登陆过
	LOGIN_SATE_LOGIN = 1,--之前登陆过

}
--变量
local m_layer_login = nil 
local m_login_state = 0  --登陆的状态
local m_label_serverName = nil 
local m_label_userAccount = nil --账号
local m_panel_list_item  = nil 
local m_listview_account = nil 
local m_org_tag_select = nil 

--逻辑部分
--local checkHaveAccount = 
local checkHaveServer = LoginLogic.checkServer
local getServerList   = LoginLogic.getServerList
local getServerName   = LoginLogic.getServerName

local getTableTag     = LoginLogic.getTableByTag

local getAccount = LoginLogic.GetUserName
local getAccountPW = LoginLogic.GetPassWord
local saveServer   = LoginLogic.saveServerName
local AccountCount = LoginLogic.CheckAccountCount
local CheckBUpdate = LoginLogic.CheckBUpdate



--layer

local getServerLayer = ServerChooseLayer.createServerChooseLayer
local deleteServerLayer = ServerChooseLayer.deleteMySelf
local getAccountLayer = AccountLoginLayer.createLayerAccount
local deleteAccountLayer = AccountLoginLayer.deleteMySelf
--提示框
local showTips = TipLayer.createTimeLayer

--颜色值
COLOR_SERVERNAME = ccc3(75,43,31)
COLOR_GRAY_LABLE = ccc3(133,133,133)

--账号列表里的选中图路径
IMG_ACCOUNT_PATH = "Image/imgres/login/bg_choosed.png"

local function clear()
	m_layer_login = nil 
	m_login_state = 0  --登陆的状态
    m_label_serverName = nil 
	m_label_userAccount = nil 
	m_panel_list_item = nil 
	m_org_tag_select = nil 
end

function deleteLayer()
	if m_layer_login~=nil then
		m_layer_login:removeFromParentAndCleanup(true)
		clear()
	end
end

local function checkServerColor(str_name)
	if checkHaveServer() ~= "" then
		m_label_serverName:setColor(COLOR_GRAY_LABLE)
	else
		m_label_serverName:setColor(COLOR_SERVERNAME)
	end
	
end



local function hideSelf()
	m_layer_login:setVisible(false)
end

local function showLoginServer()
	--显示服务器的名称
	local m_server_name = getServerName()
	if m_server_name == nil then
		showTips("没有服务器列表",2)
		return 
	end
	m_label_serverName:setText(m_server_name)
	checkServerColor()
end
local function InitVars()
	m_layer_login = nil 
	m_login_state = 0  --登陆的状态
    m_label_serverName = nil 
	m_label_userAccount = nil 
	m_panel_list_item = nil 
	m_org_tag_select = nil 
end
--选择服务器界面的回调
local function _Label_Server_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		local layer_server = getServerLayer()
		if layer_server~=nil then
			if m_layer_login:getChildByTag(layerServerChoose_Tag)~=nil then
				deleteServerLayer()
			end
			m_layer_login:addChild(layer_server,layerServerChoose_Tag,layerServerChoose_Tag)
		end
		
	end
end
local function _Label_Account_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--点击输入账号
		m_listview_account:setVisible(false)
		local layer_account = getAccountLayer()
		if layer_account~=nil then
			if m_layer_login:getChildByTag(layerNLogin_Tag)~=nil then
				deleteAccountLayer()
			end
			m_layer_login:addChild(layer_account,layerNLogin_Tag,layerNLogin_Tag)
		end
		
	end
end
--对变量赋值
local function initData()
	local l_img_server_bg = tolua.cast(m_layer_login:getWidgetByName("img_bg_server"),"ImageView")
	m_label_serverName = Label:create()
	m_label_serverName:setTouchEnabled(true)
	m_label_serverName:setFontSize(LoginCommon.LABLE_ACCOUNT_SIZE)
	m_label_serverName:setPosition(ccp(0,0))
	m_label_serverName:setText("")
	m_label_serverName:addTouchEventListener(_Label_Server_CallBack)
	--m_label_serverName:setTouchPriority(-129)
	if l_img_server_bg:getChildByTag(LoginCommon.TAG_LABEL_BUTTON)~=nil then
		l_img_server_bg:getChildByTag(LoginCommon.TAG_LABEL_BUTTON):setVisible(false)
		l_img_server_bg:getChildByTag(LoginCommon.TAG_LABEL_BUTTON):removeFromParentAndCleanup(true)
	end
	l_img_server_bg:addChild(m_label_serverName,LoginCommon.TAG_LABEL_BUTTON,LoginCommon.TAG_LABEL_BUTTON)
	
	---账号
	local l_img_account_bg = tolua.cast(m_layer_login:getWidgetByName("img_bg_input"),"ImageView")
	m_label_userAccount = Label:create()
	m_label_userAccount:setTouchEnabled(true)
	m_label_userAccount:setFontSize(LoginCommon.LABLE_ACCOUNT_SIZE)
	m_label_userAccount:setPosition(ccp(0,0))
	m_label_userAccount:setText("点击输入账号")
	m_label_userAccount:addTouchEventListener(_Label_Account_CallBack)
	if l_img_account_bg:getChildByTag(LoginCommon.TAG_LABEL_BUTTON)~=nil then
		l_img_account_bg:getChildByTag(LoginCommon.TAG_LABEL_BUTTON):setVisible(false)
		l_img_account_bg:getChildByTag(LoginCommon.TAG_LABEL_BUTTON):removeFromParentAndCleanup(true)
	end
	l_img_account_bg:addChild(m_label_userAccount,LoginCommon.TAG_LABEL_BUTTON,LoginCommon.TAG_LABEL_BUTTON)
end
local function getSList()
	local function GetListOver()
		saveServer(getServerName())
		showLoginServer()
		
	end
	getServerList(GetListOver)
end

local function toGetServerList()
	--if NETWORKENABLE > 0 then
	    local array_action = CCArray:create()
		array_action:addObject(CCDelayTime:create(0.1))
		array_action:addObject(CCCallFunc:create(getSList))
		local actions = CCSequence:create(array_action)
		m_layer_login:runAction(actions)
	--end
end
function updateSelectServerName()
	saveServer(getServerName())
	m_label_serverName:setText(getServerName())
	checkServerColor(getServerName())
end
local function getCloneItemAccount()
	local new_item_account = m_panel_list_item:clone()
	local peer = tolua.getpeer(m_panel_list_item)
	tolua.setpeer(new_item_account,peer)
	
	return new_item_account 

end
--非选中或者选中的处理
local function setListView(bShow)
	m_listview_account:setVisible(bShow)
	if m_listview_account:getItems():count()~=0 then
		for i=0,m_listview_account:getItems():count()-1 do 
			local item_ii = m_listview_account:getItem(i)
			item_ii:setTouchEnabled(bShow)
		end
	end
	m_label_serverName:setTouchEnabled(not(bShow))
	m_listview_account:setTouchEnabled(bShow)
end
--改变当前选中的
local function setListItemNameChange()
	if m_org_tag_select~=nil then
		local org_Account = m_label_userAccount:getStringValue()
		local table_info = getTableTag(m_org_tag_select-LoginCommon.TAG_LAYER_ADD+1)	
		m_label_userAccount:setText(table_info.a_name)
		local item_chenge = m_listview_account:getItem(m_org_tag_select-LoginCommon.TAG_LAYER_ADD)
		local label_name = tolua.cast(item_chenge:getChildByName("Lable_name"),"Label")
		label_name:setText(org_Account)
	end
end
--显示选中或者非选中
local function setImgBgItem(nTag,nOpacity)
	if m_org_tag_select~=nil then
		local item_list = m_listview_account:getItem(nTag-LoginCommon.TAG_LAYER_ADD)
		local img_s_bg = tolua.cast(item_list:getChildByName("img_item_bg"),"ImageView")
		img_s_bg:setOpacity(nOpacity)
	end
	if nOpacity == 255 then
		--表示选中了
		setListView(false)
		setListItemNameChange()
	else
		setListView(true)
	end
	
end


local function _Btn_PullDown_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		m_listview_account:setVisible(not(m_listview_account:isVisible()))
		setImgBgItem(m_org_tag_select,0)
		
	end
end

local function _Img_Item_CallBack(sender,eventType)
	local tag = sender:getTag()
	
	if eventType == TouchEventType.ended then
		if tag ~= m_org_tag_select then
			if m_org_tag_select~= nil then
				setImgBgItem(m_org_tag_select,0)
			end
			m_org_tag_select = tag
		end
		setImgBgItem(tag,255)
		
	end
end

local function showLisAccount()
	local table_list = AccountCount()
	m_listview_account = tolua.cast(m_layer_login:getWidgetByName("ListView_Account"),"ListView")
	local btn_pull_down = tolua.cast(m_layer_login:getWidgetByName("btn_pull_down"),"Button")
	btn_pull_down:addTouchEventListener(_Btn_PullDown_CallBack)
	
	m_listview_account:setTouchEnabled(false)
	if #table_list == 0 then
		btn_pull_down:setVisible(false)
		btn_pull_down:setTouchEnabled(false)
		m_listview_account:setVisible(false)
	else
		btn_pull_down:setVisible(true)
		btn_pull_down:setTouchEnabled(true)
		m_listview_account:setVisible(false)
		
		for i=0,#table_list-1 do 
			if getAccount()~= table_list[i+1].a_name then
				local item_clone_i = getCloneItemAccount()
				local label_name = tolua.cast(item_clone_i:getChildByName("Lable_name"),"Label")
				local img_bg_item = tolua.cast(item_clone_i:getChildByName("img_item_bg"),"ImageView")
				label_name:setText(table_list[i+1].a_name)
				img_bg_item:setOpacity(0)
				item_clone_i:setTag(LoginCommon.TAG_LAYER_ADD+i)
				if i~= (#table_list-1) then
					item_clone_i:addTouchEventListener(_Img_Item_CallBack)
				else
					item_clone_i:addTouchEventListener(_Label_Account_CallBack)
				end
				m_listview_account:pushBackCustomItem(item_clone_i)
			end
		end
	end
end

local function initUI()
	if getAccount()~="" then
		m_label_userAccount:setText(getAccount())
	end
	local m_btn_account = tolua.cast(m_layer_login:getWidgetByName("btn_account"),"Button")
	local lable_btn_account = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,"账号",ccp(0,4),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,-2),2)
	if m_btn_account:getChildByTag(LoginCommon.TAG_LABEL_BUTTON)~=nil then
		m_btn_account:getChildByTag(LoginCommon.TAG_LABEL_BUTTON):setVisible(false)
		m_btn_account:getChildByTag(LoginCommon.TAG_LABEL_BUTTON):removeFromParentAndCleanup(true)
	end
	m_btn_account:addChild(lable_btn_account,LoginCommon.TAG_LABEL_BUTTON,LoginCommon.TAG_LABEL_BUTTON)
	m_btn_account:addTouchEventListener(_Label_Account_CallBack)
	
	m_panel_list_item = GUIReader:shareReader():widgetFromJsonFile( "Image/Account_item.json" )
	--有没有账号的处理
	showLisAccount()
	--CreateCheckBoxCallBack(nil,"进入游戏",_Box_CallBack)
end

function SetEnterTouch()
	if m_layer_login == nil then
		return 
	end
	local btn_enterGame = tolua.cast(m_layer_login:getWidgetByName("btn_enter_g"),"Button")
	btn_enterGame:setTouchEnabled(true)
end
local function _Enter_CallBack()
	--进入游戏
	local function callBack()
		local btn_enterGame = tolua.cast(m_layer_login:getWidgetByName("btn_enter_g"),"Button")
		btn_enterGame:setTouchEnabled(false)
		deleteLayer()
	end
	LoginCommon.handleToMainLayer(callBack,true)
end

function UpdateAccount()
	if m_label_userAccount~=nil then
		m_label_userAccount:setText(getAccount())
	end
end
function createLoginLayer()
	InitVars()
	m_layer_login = TouchGroup:create()
	m_layer_login:addWidget(GUIReader:shareReader():widgetFromJsonFile( "Image/LoginUILayer.json" ))
	initData()
	toGetServerList()
	initUI()
	--按钮
	local btn_enterGame = tolua.cast(m_layer_login:getWidgetByName("btn_enter_g"),"Button")
	CreateBtnCallBack(btn_enterGame,"进入游戏",36,_Enter_CallBack)
	return m_layer_login
end