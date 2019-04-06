require "Script/Login/CreateRoleLogic"

module("CreateRoleScene", package.seeall)

--变量
local m_pSceneRole = nil 
local m_pLayerRole = nil 
local m_btn_random_name = nil 
local m_nNameCode  = 0 
local m_strName = nil 
local m_editbox = nil 
local man_object = nil 
local girl_object = nil 
--默认选择的头像tag
local m_head_select_index = 0
local m_img_icon = nil 

local m_sex_id   = 0 

--记录国别 推荐国家
local m_tag_country = 0


--逻辑

local GetRName     = CreateRoleLogic.GetRondamName
local GetAnimation = CreateRoleLogic.GetActionByID
local ClickPerson  = CreateRoleLogic.ClickPerson
local MoveAction   = CreateRoleLogic.MoveAction
local createRoleLogin = CreateRoleLogic.createRoleLogin
local GetImgHeadID   = CreateRoleLogic.GetImgHeadID
local ChangeBSelf    = CreateRoleLogic.ChangeBSelf
--数据
local GetPersonInfo = CreateRoleData.GetPersonInfo


TAG_SCENE = 1
TAG_LAYER_ROLE = 100 
TAG_ANIMATION = 101
TAG_TITLE_LABLE = 2 


local function RunFireAction()
	local ignore = CCParticleSystemQuad:create("Image/imgres/effectfile/xuanren_fire.plist")
	ignore:setAutoRemoveOnFinish(true)
	ignore:setScaleX(-1.2)
	ignore:setScaleY(1.1)
	ignore:setPosition(ccp(127,94))
	m_pLayerRole:addChild(ignore,100,100)
	
end
local function InitVars()
	m_pSceneRole = nil 
	m_pLayerRole = nil 
	m_btn_random_name = nil 
	m_nNameCode  = 0  
	m_strName = nil 
	m_editbox = nil 
	girl_object = nil 
	man_object = nil 
	m_head_select_index = 0 
	m_img_icon = nil 
	m_sex_id = 0 
end
local function saveNameInfo(sName,nCode,last)
	m_nNameCode = nCode
	m_strName   = sName

end

local function ChangeName()
	local function RandNameOver(strName, NameCode,nCountry)
		
		if strName ~= nil then
			saveNameInfo(strName,NameCode)
			m_editbox:setText(strName)
		end
	end
	GetRName(RandNameOver,m_sex_id)
end
--名字随机的回调
local function _Btn_Random_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		
		ChangeName()
	end
end
local function createEditBox()
	local BtnRandomPos = m_btn_random_name:getWorldPosition()
	local m_textUserName = CCEditBox:create (CCSizeMake(210,48), CCScale9Sprite:create("Image/imgres/login/bg_input.png"))
	m_textUserName:setPosition(ccp(BtnRandomPos.x+160+ CommonData.g_Origin.x, BtnRandomPos.y- CommonData.g_Origin.y))
	m_textUserName:setPlaceholderFontColor(ccc3(177, 177, 177))
	m_textUserName:setFontSize(24)
	m_textUserName:setPlaceholderFontSize(24)
	--m_textUserName:setFont(g_sFontName,24)
	m_textUserName:setFontColor(ccc3( 75, 46, 31))
	m_textUserName:setMaxLength(24)
	m_textUserName:setReturnType(kKeyboardReturnTypeDone)
	m_textUserName:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	m_textUserName:setPlaceHolder("请输入名字")
	--m_textUserName:setText("请输入名字")
	m_textUserName:setTouchPriority(-129)
	m_pLayerRole:addChild(m_textUserName, 1, 100)
	return m_textUserName
end
local function SetOrgScale(m_head_org)
	for i=1,3 do 
		local btn_head = tolua.cast(m_pLayerRole:getWidgetByName("btn_"..i),"Button")
		if  m_head_org==btn_head:getTag() then
			btn_head:getParent():setScale(0.68)
		end
	end
end
local function _Btn_Head_CallBack(sender,eventType)
	local now_btn = tolua.cast(sender,"Button")
	local now_tag = now_btn:getTag()
	if eventType == TouchEventType.ended then
		if tonumber(now_tag) ~= tonumber(m_head_select_index) then
			now_btn:getParent():setScale(0.8)
			SetOrgScale(m_head_select_index)
			m_head_select_index = now_tag
			m_img_icon:setPosition(ccp(now_btn:getParent():getPositionX(),now_btn:getParent():getPositionY()))
		end
	elseif eventType == TouchEventType.canceled then
		now_btn:getParent():setScale(0.68)
	end
end

local function UpdateHeadImg(strSexPath)
	--头像
	for i=1,3 do 
		local m_btn_head = tolua.cast(m_pLayerRole:getWidgetByName("btn_"..i),"Button")
		--[[print(GetImgHeadID(strSexPath..i..".png"))
		Pause()]]--
		m_btn_head:setTag(GetImgHeadID(strSexPath..i..".png"))
		--m_btn_head:setTag(TAG_GRID_ADD+i)
		m_btn_head:getParent():setTag(TAG_GRID_ADD+i)
		m_btn_head:addTouchEventListener(_Btn_Head_CallBack)
		
		m_btn_head:loadTextures(strSexPath..i..".png",strSexPath..i..".png","")
		local img_icon = tolua.cast(m_pLayerRole:getWidgetByName("img_"..i),"ImageView")
		if i==1 then
			m_head_select_index = m_btn_head:getTag()
			
			if m_img_icon == nil  then
				m_img_icon = ImageView:create()
					
				m_img_icon:loadTexture("Image/imgres/item/selected_icon.png")
				m_img_icon:setScale(0.8)
				m_img_icon:setPosition(ccp(img_icon:getPositionX(),img_icon:getPositionY()))
				
				local img_name_head = tolua.cast(m_pLayerRole:getWidgetByName("img_bg_head"),"ImageView")
				if img_name_head:getChildByTag(TAG_TITLE_LABLE)~=nil then
					img_name_head:getChildByTag(TAG_TITLE_LABLE):setVisible(false)
					img_name_head:getChildByTag(TAG_TITLE_LABLE):removeFromParentAndCleanup(true)
				end
				img_name_head:addChild(m_img_icon,TAG_TITLE_LABLE,TAG_TITLE_LABLE)
			else
				m_img_icon:setPosition(ccp(img_icon:getPositionX(),img_icon:getPositionY()))
			end
			m_btn_head:getParent():setScale(0.8)
		else
			local nScale = m_btn_head:getParent():getScale()
			if tonumber(string.format("%.1f",nScale)) == 0.8 then
				m_btn_head:getParent():setScale(0.68)
			end	
		end
	end
end
local function ShowPersonInfo()
	local tabInfo = GetPersonInfo(m_sex_id)
	for i=1,#tabInfo do 
		local label_info = tolua.cast(m_pLayerRole:getWidgetByName("Label_"..i),"Label")
		label_info:setText(tabInfo[i])
	end
end
--点击人物的回调
local function _Clik_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		if (ClickPerson(sender:getTouchEndPos(),man_object) == true) or (ClickPerson(sender:getTouchEndPos(),girl_object) == true) then
			local function changeHeadImg(str_path,nTag)
				UpdateHeadImg(str_path)
				m_sex_id = nTag
				ChangeName()
				ShowPersonInfo()
			end
			MoveAction(man_object,girl_object,changeHeadImg)
		end
	end

end
--返回的回调
local function _Btn_Back_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--print("_Btn_Back_CallBack")
		sender:setScale(0.9)
		m_pLayerRole:removeFromParentAndCleanup(true)
		m_pLayerRole = nil
		--network.DisconnetMS()
		network.luaDestroyNetWork()
		StartScene.SetPopScene(true)
		NetWorkLoadingLayer.ClearLoading()
		
		
		if CommonData.IsAnySDK() == false then
			
			CCDirector:sharedDirector():popScene()
			LoginLayer.UpdateAccount()	
			
		else
			CCDirector:sharedDirector():popScene()
			--LoginLogic.DealSDKLogin(AnySDKgetUserId(),AnySDKgetChannelId())
		end
		
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end

end
local function _Btn_Enter_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		sender:setScale(0.9)
		local table_create_info = {str_name= "",str_sex="",str_nameCode = ""}
		table_create_info.str_name = m_editbox:getText()
		
		table_create_info.str_sex  = m_sex_id
		if ChangeBSelf(m_editbox:getText(),m_strName) == true then
			--如果是自己的起的名字
			table_create_info.str_nameCode = 0
		else
			table_create_info.str_nameCode = m_nNameCode
		end
		
		table_create_info.str_resID   = m_head_select_index
		table_create_info.nCountry  = m_tag_country
		createRoleLogin(table_create_info)
		CCUserDefault:sharedUserDefault():setIntegerForKey("time_now",0)
		table_create_info=nil 
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end
local function _Img_Country_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		
		local tag = sender:getTag()-TAG_GRID_ADD
		if tag~= m_tag_country then
			sender:setScale(0.3)
			
			local img_Org = tolua.cast(m_pLayerRole:getWidgetByName("img_c"..m_tag_country),"ImageView")
			img_Org:setScale(0.25)
			local _img_Org_sprite = tolua.cast(img_Org:getVirtualRenderer(), "CCSprite")
			SpriteSetGray(_img_Org_sprite,1)
			local _img_select = tolua.cast(m_pLayerRole:getWidgetByName("img_c"..tag),"ImageView")
			--_img_select:setScale(0.25)
			local _img_select_sprite = tolua.cast(_img_select:getVirtualRenderer(), "CCSprite")
			SpriteSetGray(_img_select_sprite,0)
			m_tag_country = tag
		end
	elseif eventType == TouchEventType.canceled then
		sender:setScale(0.25)
	end
end
local function InitCountry()
	local img_country_bg = tolua.cast(m_pLayerRole:getWidgetByName("img_bg_country"),"ImageView")
	for i=1,3 do 
		local img_country = tolua.cast(m_pLayerRole:getWidgetByName("img_c"..i),"ImageView")
		
		img_country:setTag(TAG_GRID_ADD+i)
		--CreateBtnCallBack( btn_country,nil,nil,_Btn_Country_CallBack,nil,nil,i)
		img_country:setTouchEnabled(true)
		img_country:addTouchEventListener(_Img_Country_CallBack)
		if i~= m_tag_country then
			local _img_country_sprite = tolua.cast(img_country:getVirtualRenderer(), "CCSprite")
			SpriteSetGray(_img_country_sprite,1)
		else
			img_country:setScale(0.3)
			local img_jian = ImageView:create()
			img_jian:loadTexture("Image/imgres/equip/icon/daojv/item002.png")
			img_jian:setPosition(ccp(-img_country:getContentSize().width/4,-img_country:getContentSize().height/4-25))
			--img_jian:setScale(0.3)
			AddLabelImg(img_jian,5000,img_country)
		end
	end
	local img_zy_bg = tolua.cast(m_pLayerRole:getWidgetByName("img_name_country"),"ImageView")
	local label_zy = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"选择阵营",ccp(0,4),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	AddLabelImg(label_zy,TAG_TITLE_LABLE,img_zy_bg)
end
local function InitData()
	m_sex_id = 1
	--层
	m_pLayerRole = TouchGroup:create()									-- 背景层
    m_pLayerRole:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CreateRoleLayer.json") )
	m_pSceneRole:addChild(m_pLayerRole,TAG_LAYER_ROLE,TAG_LAYER_ROLE)
	
	local panel_role = tolua.cast(m_pLayerRole:getWidgetByName("Panel_CreateRole"),"Layout")
	panel_role:addTouchEventListener(_Clik_CallBack)
	--输入名字框
	m_btn_random_name = tolua.cast(m_pLayerRole:getWidgetByName("btn_choose_name"),"Button")
	m_editbox = createEditBox()
	--随机名字的按钮
	
	m_btn_random_name:addTouchEventListener(_Btn_Random_CallBack)
	
	
	if m_editbox~=nil then
		--开始先显示一个随机名字
		local function RandNameOver(strName, NameCode,nCountry)
			m_tag_country = tonumber(nCountry)
			CCUserDefault:sharedUserDefault():setIntegerForKey("country",m_tag_country)
			--国家选择
			InitCountry()
			if strName ~= nil then
				saveNameInfo(strName,NameCode)
				m_editbox:setText(strName)
			end
		end
		GetRName(RandNameOver,m_sex_id)
	end
	--人物的介绍
	ShowPersonInfo()
	--进入游戏
	local btn_back = tolua.cast(m_pLayerRole:getWidgetByName("btn_enter"),"Button")
	btn_back:addTouchEventListener(_Btn_Enter_CallBack)
	--返回按钮
	local btn_back = tolua.cast(m_pLayerRole:getWidgetByName("btn_back_role"),"Button")
	btn_back:addTouchEventListener(_Btn_Back_CallBack)
end
local function addManAndGirl()
	--设置位置
	man_object:setPosition(ccp(317+60,354-220))
	girl_object:setPosition(ccp(694+30-65,256-110))
	
	girl_object:setColor(ccc3(140,140,140))
	
	man_object:setScaleX(CreateRoleLogic.SCALE_BIG_RATIO_X)
	man_object:setScaleY(CreateRoleLogic.SCALE_BIG_RATIO_Y)
	
	--man_object:setScale(4.0)
	girl_object:setScaleX(CreateRoleLogic.SCALE_SMALL_RATIO_X)
	girl_object:setScaleY(CreateRoleLogic.SCALE_SMALL_RATIO_Y)
	
	m_pLayerRole:addChild(man_object, 1, 1)
	m_pLayerRole:addChild(girl_object, 0, 0)
end

local function InitUI()
	--火的动画
	RunFireAction()
	--添加人物
	man_object = GetAnimation(CreateRoleLogic.ID_MAN)
	girl_object = GetAnimation(CreateRoleLogic.ID_GIRL)
	
	addManAndGirl()
	
	UpdateHeadImg(CreateRoleLogic.STR_HEAD_MAN_PATH)
	
	--头像部分的标题
	local img_namebg = tolua.cast(m_pLayerRole:getWidgetByName("img_name_bg"),"ImageView")
	local label_title = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"选择头像",ccp(0,4),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	if img_namebg:getChildByTag(TAG_TITLE_LABLE)~=nil then
		img_namebg:getChildByTag(TAG_TITLE_LABLE):setVisible(false)
		img_namebg:getChildByTag(TAG_TITLE_LABLE):removeFromParentAndCleanup(true)
	end
	img_namebg:addChild(label_title,TAG_TITLE_LABLE,TAG_TITLE_LABLE)
	
	
end
function createRoleUI()
	InitVars()
	m_pSceneRole = CCScene:create()
	
	InitData()
	InitUI()
	
	local scene_node  = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_xuanjuese.json")--CCScene:create()	
	m_pSceneRole:addChild(scene_node, TAG_SCENE,TAG_SCENE )
	local m_nHanderTime = nil
	local function NetUpdata(dt)
		UpNetWork()
	end	

	local function SceneEvent(tag)
		if tag == "enter" then	
			Scence_OnBegin()
			m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, CommonData.g_nNetUpdataTime, false)			
		end

		if tag == "enterTransitionFinish" then	
			--Scence_OnBegin()
			--print("createMainUI")
			--Pause()
			
		end	

		if tag == "exit" then	
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
		end	

		if tag == "exitTransitionStart" then		
		end	

		if tag == "cleanup" then			
		end	
	end
	m_pSceneRole:registerScriptHandler(SceneEvent)
	CCDirector:sharedDirector():pushScene(m_pSceneRole)
end