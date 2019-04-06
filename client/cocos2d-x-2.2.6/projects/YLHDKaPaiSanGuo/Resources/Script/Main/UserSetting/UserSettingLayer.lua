
--玩家设置界面 celina


module("UserSettingLayer", package.seeall)

require "Script/Main/UserSetting/UserSettingData"
require "Script/Main/UserSetting/UserSettingLogic"
require "Script/Main/UserSetting/UserSettingChangeName"
require "Script/Main/UserSetting/UserSettingChangeHeadImage"
require "Script/Main/UserSetting/UserSettingChangeImage"
require "Script/Main/UserSetting/UserSettingSystem"
require "Script/Main/UserSetting/UserDesertCountry"
--变量
local m_settingLayer  = nil 
local m_action_role  = nil 

--数据
local GetUserModelID_layer = UserSettingData.GetUserModelID
local GetUserName_layer         = UserSettingData.GetUserName
local GetUserLv_layer    = UserSettingData.GetUserLv
local GetCurExp_layer = UserSettingData.GetCurExp
local GetNextLvExp_layer = UserSettingData.GetNextLvExp
local GetUserVIPLv_layer = UserSettingData.GetUserVIPLv
local GetCountry_layer = UserSettingData.GetCountry
local GetJTName_layer = UserSettingData.GetJTName
--逻辑
local GetRoleActionByID_layer = UserSettingLogic.GetRoleActionByID
local ToDesertJT = UserSettingLogic.ToDesertJT
local ToDesertCountry = UserSettingLogic.ToDesertCountry
local CheckBHaveJT = UserSettingLogic.CheckBHaveJT
--界面
local ShowChangeNameLayer  = UserSettingChangeName.ShowChangeNameLayer
local ShowChangeHeadImageLayer = UserSettingChangeHeadImage.ShowChangeHeadImageLayer
local ShowChangeImageLayer = UserSettingChangeImage.ShowChangeImageLayer
local ShowSystemLayer = UserSettingSystem.ShowSystemLayer


local function InitVars()
	m_settingLayer = nil 
	m_action_role =nil 
end
local function _Btn_ChangeImage_CallBack()
	--更换形象
	AddLabelImg(ShowChangeImageLayer(),102,m_settingLayer)
end
local function ShowModelImage()
	local panel_role = tolua.cast(m_settingLayer:getWidgetByName("Panel_Role"),"Layout")
	if m_action_role~=nil then
		m_action_role:removeFromParentAndCleanup(true)
		m_action_role = nil 
	end
	if GetUserModelID_layer() == 0 then
		m_action_role = GetRoleActionByID_layer(80011)
	else
		m_action_role = GetRoleActionByID_layer(GetUserModelID_layer())
		
	end
	m_action_role:setScale(2.0)
	m_action_role:setPosition(140,30)
	panel_role:addNode(m_action_role,TAG_GRID_ADD,TAG_GRID_ADD)
	--更换形象的按钮
	local _btn_change_image = tolua.cast(m_settingLayer:getWidgetByName("btn_change_img"),"Button")
	CreateBtnCallBack(_btn_change_image,"更换形象",20,_Btn_ChangeImage_CallBack,ccc3(83,28,2),ccc3(255,245,126),nil,nil)
end

local function _Btn_Change_Name_CallBack()
	--改名字
	AddLabelImg(ShowChangeNameLayer(),100,m_settingLayer)
end
local function _Btn_Change_HeadImg_CallBack()
	--换头像
	AddLabelImg(ShowChangeHeadImageLayer(),101,m_settingLayer)
end
--添加一些基本信息的通用方法
local function AddLabelBtnInfo(strAdd,bgImg,addTag,pos)
	local lable_user = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,strAdd,ccp(0,4),COLOR_Black,ccc3(228,199,167),false,ccp(0,-2),2)
	--lable_user:setAnchorPoint(ccp(0,0.5))
	lable_user:setPosition(pos)
	AddLabelImg(lable_user,addTag,bgImg)
end
--叛离军团
local function _Btn_Desert_JT()
	ToDesertJT()
end
--叛离国家
local function _Btn_Desert_Country()
	--local function DesertInfo()
		ToDesertCountry(m_settingLayer)
	--end
	--Packet_GetCountryLevelUpData.SetSuccessCallBack(DesertInfo)
	--network.NetWorkEvent(Packet_GetCountryLevelUpData.CreatePacket(GetCountry()))
end
--右边的信息
local function ShowRightUI()
	local img_name_bg = tolua.cast(m_settingLayer:getWidgetByName("img_name_bg"),"ImageView")
	local lable_name = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,GetUserName_layer(),ccp(-6,4),COLOR_Black,ccc3(255,194,30),true,ccp(0,-2),2)
	AddLabelImg(lable_name,10,img_name_bg)
	--更换名称的按钮
	local _btn_change_name = tolua.cast(m_settingLayer:getWidgetByName("btn_change_name"),"Button")
	CreateBtnCallBack(_btn_change_name,nil,nil,_Btn_Change_Name_CallBack,nil,nil,nil,nil)
	
	--更换头像
	local _btn_change_headImg = tolua.cast(m_settingLayer:getWidgetByName("btn_change_head"),"Button")
	CreateBtnCallBack(_btn_change_headImg,"更换头像",20,_Btn_Change_HeadImg_CallBack,ccc3(83,28,2),ccc3(255,245,126),nil,nil)
	
	--头像
	local img_head_user = tolua.cast(m_settingLayer:getWidgetByName("img_touxiang"),"ImageView")
	local pControl = UIInterface.MakeHeadIcon(img_head_user, ICONTYPE.PLAYER_ICON, nil, nil)
	
	--主将等级
	local img_bg_lable = tolua.cast(m_settingLayer:getWidgetByName("img_user_bg"),"ImageView")
	local label_lv = tolua.cast(m_settingLayer:getWidgetByName("Label_11"),"Label")
	label_lv:setText(GetUserLv_layer())
	--武将等级上限(就是主将等级)
	local label_lv_limit = tolua.cast(m_settingLayer:getWidgetByName("Label_12"),"Label")
	label_lv_limit:setText(GetUserLv_layer())
	--Vip等级
	local label_vip = tolua.cast(m_settingLayer:getWidgetByName("Label_16"),"Label")
	if tonumber(GetUserVIPLv_layer())>0 then
		label_vip:setVisible(false)
		local labelVIP = LabelBMFont:create()
		labelVIP:setFntFile("Image/imgres/common/num/number_warresult.fnt")
		labelVIP:setText(GetUserVIPLv_layer())
		labelVIP:setAnchorPoint(ccp(0,0))
		labelVIP:setPosition(ccp(115, 11))
		img_bg_lable:addChild(labelVIP)
		
	else
		label_vip:setVisible(true)
	end
	--主将经验
	local label_exp = tolua.cast(m_settingLayer:getWidgetByName("Label_13"),"Label")
	
	if tonumber(GetUserLv_layer()) == 100 then
		--label_exp:setText(GetCurExp_layer())
		label_exp:setText("满级")
	else
		--修改为当前的等级20160408
		label_exp:setText(GetCurExp_layer().."/"..GetNextLvExp_layer(GetUserLv_layer()))
	end
	local pressBar = tolua.cast(m_settingLayer:getWidgetByName("ProgressBar_22"),"LoadingBar")
	local percent = tonumber(GetCurExp_layer())/tonumber(GetNextLvExp_layer(GetUserLv_layer()))
	pressBar:setPercent(percent*100)
	--所属军团
	local label_jt = tolua.cast(m_settingLayer:getWidgetByName("Label_14"),"Label")
	label_jt:setText(GetJTName_layer())
	--所属国家
	local label_country = tolua.cast(m_settingLayer:getWidgetByName("Label_15"),"Label")
	label_country:setText(GetCountry_layer())
	
	local btn_desert_jt = tolua.cast(m_settingLayer:getWidgetByName("btn_1"),"Button")
	
	CreateBtnCallBack( btn_desert_jt,"离开军团",25,_Btn_Desert_JT,ccc3(53,28,2),COLOR_White,nil,2,"微软雅黑" ,ccp(0,0))
	local btn_desert_country = tolua.cast(m_settingLayer:getWidgetByName("btn_2"),"Button")
	--CreateBtnCallBack( btn_desert_country,"叛离国家",25,_Btn_Desert_Country,ccc3(53,28,2),COLOR_White,nil,2,"微软雅黑",ccp(0,0) )
	btn_desert_country:setVisible(false)
	btn_desert_country:setTouchEnabled(false)
	if CheckBHaveJT() == false then
		btn_desert_jt:setVisible(false)
		btn_desert_jt:setTouchEnabled(false)
	end
end
local function _Btn_SystemSetting_CallBack()
	--系统设置
	AddLabelImg(ShowSystemLayer(),103,m_settingLayer)
end
local function ShowUI()
	ShowModelImage()
	ShowRightUI()
	--系统设置
	local _btn_system_setting = tolua.cast(m_settingLayer:getWidgetByName("btn_setting"),"Button")
	CreateBtnCallBack(_btn_system_setting,"系统设置",36,_Btn_SystemSetting_CallBack,COLOR_Black,COLOR_White,nil,nil)
end
function UpdateImage()
	ShowUI()
end

function UpdateCountry()
	--所属国家
	local label_country = tolua.cast(m_settingLayer:getWidgetByName("Label_15"),"Label")
	label_country:setText(GetCountry_layer())
end

local function _Btn_Setting_Back_CallBack()
	m_settingLayer:removeFromParentAndCleanup(true)
end
function CreateUserSettingLayer()
	InitVars()
	m_settingLayer =  TouchGroup:create()
	m_settingLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/UserSettingLayer.json" ) )
	
	ShowUI()
	--返回按钮
	local _btn_setting_back  = tolua.cast(m_settingLayer:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack(_btn_setting_back,nil,nil,_Btn_Setting_Back_CallBack,nil,nil,nil,nil)
	return m_settingLayer
end