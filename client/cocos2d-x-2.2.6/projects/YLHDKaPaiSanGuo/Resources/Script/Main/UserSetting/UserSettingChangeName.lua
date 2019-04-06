--玩家修改名字界面 celina


module("UserSettingChangeName", package.seeall)

--变量

local m_layer_changeName = nil 
local m_editbox_changeName = nil

--逻辑
local CheckNameOK = UserSettingLogic.CheckNameOK
local ToChangeName = UserSettingLogic.ToChangeName
--数据
local GetChangeNameTimes = UserSettingData.GetChangeNameTimes
local GetExpendData = UserSettingData.GetExpendData
local GetCountryTag = UserSettingData.GetCountryTag
local GetChangeNameExpend = UserSettingData.GetChangeNameExpend

local function InitVars()
	m_layer_changeName = nil
	m_editbox_changeName = nil
end
local function DeleteEditBox()
	local img_changeName_Bg = tolua.cast(m_layer_changeName:getWidgetByName("img_changeName"),"ImageView")
	if img_changeName_Bg:getNodeByTag(200)~=nil then
		img_changeName_Bg:removeNodeByTag(200)
	end
end
local function _Btn_Cancel_Name_CallBack()
	m_layer_changeName:removeFromParentAndCleanup(true)
	DeleteEditBox()
	InitVars()
end
local function _Btn_OK_Name_CallBack()
	--确定，保存名字和关闭
	local function ChangeOK()
		DeleteEditBox()
		m_layer_changeName:removeFromParentAndCleanup(true)
		InitVars()
		--通知名字更新
		UserSettingLayer.UpdateImage()
	end
	ToChangeName(m_editbox_changeName:getText(),ChangeOK)
	
	
end

local function ShowUI()
	local m_panel = tolua.cast(m_layer_changeName:getWidgetByName("Panel_xh"),"Layout")
	local lable_free  = nil
	if tonumber(GetChangeNameTimes()) >0 then
		lable_free = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"消耗",ccp(0,4),ccc3(43,31,31),ccc3(255,194,30),true,ccp(0,-2),2)
		lable_free:setPosition(ccp(100,40))
		
		local img_bg_num = ImageView:create()
		img_bg_num:loadTexture("Image/imgres/equip/bg_name_equiped.png")
		img_bg_num:setPosition(ccp(200,40))
		AddLabelImg(img_bg_num,2,m_panel)
		--消耗图标
		local tableExpend = GetChangeNameExpend()
		for i=1,table.getn(tableExpend) do 
			local img_icon = ImageView:create()
			img_icon:loadTexture(tableExpend[1].IconPath)
			img_icon:setPosition(ccp(-40+(i-1)*100,0))
			img_icon:setScale(0.55)
			AddLabelImg(img_icon,i,img_bg_num)
			--数字
			local label_num = nil 
			if tableExpend[1].Enough == true then
				label_num = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,tableExpend[1].ItemNeedNum,ccp(0,4),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
			else
				label_num = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,tableExpend[1].ItemNeedNum,ccp(0,4),ccc3(23,5,5),ccc3(255,87,35),true,ccp(0,-2),2)
			end
			label_num:setPosition(ccp(15+(i-1)*100,0))
			AddLabelImg(label_num,10+i,img_bg_num)
		end
	else
		--免费修改一次
		lable_free = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"免费修改一次",ccp(0,4),ccc3(43,31,31),ccc3(255,194,30),true,ccp(0,-2),2)
		lable_free:setPosition(ccp(200,40))
		
	end
	AddLabelImg(lable_free,1,m_panel)
	local img_changeName_Bg = tolua.cast(m_layer_changeName:getWidgetByName("img_changeName"),"ImageView")
	--输入文本
	if m_editbox_changeName == nil then
		m_editbox_changeName = CCEditBox:create(CCSizeMake(298,44),CCScale9Sprite:create("Image/imgres/login/bg_input.png"))
		m_editbox_changeName:setPosition(ccp(0,0))
		m_editbox_changeName:setMaxLength(6)
		m_editbox_changeName:setFontName(CommonData.g_FONT3)
		m_editbox_changeName:setPlaceholderFontColor(ccc3(75,46,31))
		m_editbox_changeName:setPlaceholderFontSize(30)
		m_editbox_changeName:setFontColor(ccc3(75,46,31))
		m_editbox_changeName:setFontSize(30)
		m_editbox_changeName:setPlaceHolder("")
		
		m_editbox_changeName:setReturnType(kKeyboardReturnTypeDone)
		m_editbox_changeName:setInputFlag(kEditBoxInputFlagInitialCapsWord)
		m_editbox_changeName:setTouchPriority(-129)
		img_changeName_Bg:addNode(m_editbox_changeName,200,200)
	end
	--按钮，确定和取消
	local m_btn_cancel = tolua.cast(m_layer_changeName:getWidgetByName("btn_cancel"),"Button")
	CreateBtnCallBack(m_btn_cancel,"取消",36,_Btn_Cancel_Name_CallBack,COLOR_Black,COLOR_White,nil,nil)
	local m_btn_ok = tolua.cast(m_layer_changeName:getWidgetByName("btn_ok"),"Button")
	CreateBtnCallBack(m_btn_ok,"确定",36,_Btn_OK_Name_CallBack,COLOR_Black,COLOR_White,nil,nil)
end

function ShowChangeNameLayer()
	InitVars()
	m_layer_changeName =  TouchGroup:create()
	m_layer_changeName:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/UserChangeName.json" ) )
	ShowUI()
	return m_layer_changeName
end