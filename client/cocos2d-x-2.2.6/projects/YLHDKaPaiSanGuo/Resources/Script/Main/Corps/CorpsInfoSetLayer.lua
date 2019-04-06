--FileName:CorpsInfoSetLayer
--Author:xuechao
--Purpose:军团设置界面

--require "Script/Main/Corps/CorpsChangeIconLayer"
module("CorpsInfoSetLayer",package.seeall)
require "Script/Main/UserSetting/UserSettingChangeName"
require "Script/Main/Corps/CorpsData"
require "Script/Main/Corps/CorpsCampAlterLayer"
require "Script/Main/Corps/CorpsSettingIcon"
require "Script/Main/Corps/CorpsChangedName"

local BTN_CLOSE = "Image/imgres/button/btn_close.png"
local BTN_EMPTY = "Image/imgres/common/common_empty.png"

local ShowChangeNameLayer  = UserSettingChangeName.ShowChangeNameLayer
local GetIconDataID = CorpsData.GetIconDataID
--local ShowChangedIconInfoLayer = CorpsChangeIconLayer.ShowChangedIconInfoLayer
local GetCorpsListData = CorpsData.GetCorpsListData
local ShowCampLayer = CorpsCampAlterLayer.ShowCampLayer
local ChangedIconLayer = CorpsSettingIcon.ChangedIconLayer
local ShowCorpsChangeNameLayer = CorpsChangedName.ShowCorpsChangeNameLayer
local GetCorpsInfo 			= CorpsData.GetCorpsInfo

m_CorpsInfoSettingLayer 	= nil
m_NeedLevel 				= 30
local labelNeedLevel 		= 0
local labelTestTypr 		= nil
local m_CorpsIconID 		= 1
local image_icon 			= nil
local m_CorpsCampID 		= 1
local labelName 			= nil
local tableData 			= {}
local flagid 				= nil
local corpsname 			= nil
local corpsid 				= nil
local corpslevel 			= nil
local corpspeople 			= nil
local corpsneedlevel 		= nil
local corpsbrief 			= nil
ScrollView_Setting 			= nil
m_InputNoticeTextField 		= nil
m_InputExplainTextField 	= nil
Panel_ScrollView 			= nil
TextField_explain 			= nil
TextField_notice 			= nil
local tableValue 			= {}
local valueData             = {}
local m_nameText 			= nil
local n_golbPosition 		= 0
local image_type 			= nil
local image_level 			= nil
local btn_Alter             = nil
local btn_Type_Add          = nil
local btn_Type_Cut          = nil
local btn_alter_Notice      = nil
local btn_alter_Declare     = nil
local btn_icon              = nil
local btn_Need_Add          = nil
local btn_Need_Cut          = nil
local corpsCoutry           = nil
local changName             = nil
local image_Nothing         = nil
local image_test            = nil
local image_UnTest          = nil
local label_explainContent  = nil
local label_noticeContent   = nil
local weekDay               = nil
--local corpsname = nil

local TestTypeTable = {"任何人都可以加入","需要验证才可以加入","不允许任何人加入"}
num = 1
tableDataType = {}

local function initVar()
	m_InputNoticeTextField      = nil
	m_InputExplainTextField     = nil
	m_CorpsInfoSettingLayer 	= nil
	m_NeedLevel 				= 30
	labelNeedLevel 				= 0
	labelTestTypr 				= nil
	num 						= 1
	m_CorpsIconID 				= 1
	image_icon 					= nil
	m_CorpsCampID 				= 1
	labelName 					= nil
	flagid 						= nil
    corpsname 					= nil
    corpsid 					= nil
    corpslevel 					= nil
    corpspeople 				= nil
    corpsneedlevel 				= nil
    corpsbrief 					= nil
    ScrollView_Setting 			= nil
	Panel_ScrollView 			= nil
	TextField_explain 			= nil
	TextField_notice 			= nil
	m_nameText  				= nil
	n_golbPosition 				= 0
	image_type 					= nil
	image_level 				= nil
	btn_Alter             		= nil
	btn_Type_Add          		= nil
	btn_Type_Cut          		= nil
	btn_alter_Notice      		= nil
	btn_alter_Declare     		= nil
	btn_icon              		= nil
	btn_Need_Add          		= nil
	btn_Need_Cut          		= nil
	corpsCoutry                 = nil
	changName                   = nil
	image_Nothing				= nil
	image_test                  = nil
	image_UnTest                = nil
	label_explainContent        = nil
	label_noticeContent         = nil
	weekDay                     = nil
	tableValue                  = {}
	valueData                   = {}
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		m_CorpsInfoSettingLayer:setVisible(false)
		m_CorpsInfoSettingLayer:removeFromParentAndCleanup(true)
		m_CorpsInfoSettingLayer = nil
	end

end

function ChangeCorpsCamp( nCountry )
	corpsCoutry = nCountry
	if corpsCoutry ~= valueData.country then
		-- image_camp:loadTexture("Image/imgres/common/country/country_" .. corpsCoutry .. ".png")
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1440,nil)
		pTips = nil
	end
	return corpsCoutry
end

function ChangedCorpsIconItem(pTag)
	m_CorpsIconID = pTag
	local itemid = resimg.getFieldByIdAndIndex(m_CorpsIconID,"icon_path")
	image_icon:loadTexture(itemid)
	return m_CorpsIconID
end

function ChangedCorpsName( str )
	changName = str
	LabelLayer.setText(m_nameText,str)
end

function ChangeCorpsCampItem( pTag )
	m_CorpsCampID = pTag
	return m_CorpsCampID
end

--验证类型  减少
local function _Click_TypeCut_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		num = num - 1
		if num <= 1 then
			num = 1
		end
		--labelTestTypr:setText(TestTypeTable[num])
		if labelTestTypr:getChildByTag(1000) ~= nil then
			LabelLayer.setText(labelTestTypr:getChildByTag(1000),TestTypeTable[num])
		else
			local text = LabelLayer.createStrokeLabel(22,"微软雅黑",TestTypeTable[num],ccp(0,0),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,-2),2)
			labelTestTypr:addChild(text,0,1000)
		end

		--[[local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingShow(false)
			
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(3,num))
		NetWorkLoadingLayer.loadingShow(true)]]--
	end
end

local function SetCorpsMoney( nNumber )
	local image_Corpsmoney = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Image_11"),"ImageView")
	if image_Corpsmoney:getChildByTag(1000) ~= nil then
		LabelLayer.setText(image_Corpsmoney:getChildByTag(1000),nNumber)
	else
		local text = LabelLayer.createStrokeLabel(24,"微软雅黑",nNumber,ccp(0,0),ccc3(83,28,2), ccc3(161,85,20),true,ccp(0,-2),2)
		image_Corpsmoney:addChild(text,0,1000)
	end
end

--验证类型   增加
local function _Click_TypeAdd_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		num = num + 1
		if num >= 3 then
			num = 3
		end
		
		--labelTestTypr:setText(TestTypeTable[num])
		if labelTestTypr:getChildByTag(1000) ~= nil then
			LabelLayer.setText(labelTestTypr:getChildByTag(1000),TestTypeTable[num])
		else
			local text = LabelLayer.createStrokeLabel(22,"微软雅黑",TestTypeTable[num],ccp(0,0),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,-2),2)
			labelTestTypr:addChild(text,0,1000)
		end
		--labelTestTypr:setText(tableDataType[num])
		--[[local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingShow(false)
			
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(3,num))
		NetWorkLoadingLayer.loadingShow(true)]]--
	end
end

--需求等级  减少
local function _Click_NeedCut_CallBack( sender , eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if m_NeedLevel < 0 then
			m_NeedLevel = 0
		elseif m_NeedLevel >= 10 then
			m_NeedLevel = m_NeedLevel - 10
		end
		
		
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingShow(false)
			if labelNeedLevel:getChildByTag(1000) ~= nil then
				LabelLayer.setText(labelNeedLevel:getChildByTag(1000),m_NeedLevel)
			else
				local text = LabelLayer.createStrokeLabel(22,"微软雅黑",m_NeedLevel,ccp(0,0),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,-2),2)
				labelNeedLevel:addChild(text,0,1000)
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1415,nil)
			pTips = nil
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(4,m_NeedLevel))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--需求等级   增加
local function _Click_NeedAdd_CallBack( sender ,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if m_NeedLevel >= 100 then
			m_NeedLevel = 100
		elseif m_NeedLevel <= 90 then
			m_NeedLevel = m_NeedLevel + 10
		end
		
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingShow(false)
			if labelNeedLevel:getChildByTag(1000) ~= nil then
				LabelLayer.setText(labelNeedLevel:getChildByTag(1000),m_NeedLevel)
			else
				local text = LabelLayer.createStrokeLabel(22,"微软雅黑",m_NeedLevel,ccp(0,0),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,-2),2)
				labelNeedLevel:addChild(text,0,1000)
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1415,nil)
			pTips = nil
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(4,m_NeedLevel))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--修改军团名字
local function _Click_Name_CallBack( sender ,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		AddLabelImg(ShowCorpsChangeNameLayer(valueData),102,m_CorpsInfoSettingLayer)
	end
end

--修改军团图标
local function _Click_IconChose_CallBack( sender ,eventType )
	if eventType == TouchEventType.ended then	
		AudioUtil.PlayBtnClick()	
		local iconid = 2
		AddLabelImg(ChangedIconLayer(),104,m_CorpsInfoSettingLayer)
	end
end

--修改军团阵营
local function _Click_CampChose_CallBack( sender , eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if tonumber(weekDay) == 1 then
			local function GetSuccessCallBack(  )
				NetWorkLoadingLayer.loadingHideNow()
				AddLabelImg(ShowCampLayer(valueData),102,m_CorpsInfoSettingLayer)
			end
			Packet_CorpsRecomCountry.SetSuccessCallBack(GetSuccessCallBack)
			network.NetWorkEvent(Packet_CorpsRecomCountry.CreatePacket())
			NetWorkLoadingLayer.loadingShow(true)
			
		else
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1434,nil)
			pTips = nil
		end	
	end
end
local function wordWarp( str ,length)		

    local beginPos = 1
	local resultStr = ""
	local len = string.len(str)
	local tableStr = {}
	while beginPos <= len do	
		local char = string.sub(str,beginPos,beginPos+length - 1)
		table.insert(tableStr,char)
		local strlen = beginPos + length
		if strlen > len then
			break
		else
			beginPos = beginPos + length
		end
	end

	for i = 1,#tableStr do
		resultStr = resultStr..tableStr[i].."\n"
		--Pause()
	end
	return resultStr
end

local function TextFieldEvent( sender, eventType )
	local textField = tolua.cast(sender,"CCTextField")
   	
	if eventType == TEXTFIELD_EVENT_ATTACH_WITH_IME then
		--开始编辑事件  Panel_ScrollView
   		--local mobeBy = CCMoveBy:create(0.1,ccp(0,textField:getContentSize().height * 2.5))
   		print("开始编辑事件")
		
   	elseif eventType == TEXTFIELD_EVENT_DETACH_WITH_IME then
   		--结束编辑事件
		print("结束编辑事件")

		--[[local function GetSuccessCallback(  )
			
			
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(2,editName))]]--
   			
   	elseif eventType == TEXTFIELD_EVENT_INSERT_TEXT then
   		--插入文字事件
   		print("插入文字事件")
   	elseif eventType == TEXTFIELD_EVENT_DELETE_BACKWARD then
   		--删除文字事件
		print("删除文字事件")
   	end
	
end

local function ChangeImage( value )
	local CorpsSetIconID = tonumber(CorpsLogic.GetCorpsIconID())
	local itemid = resimg.getFieldByIdAndIndex(CorpsSetIconID,"icon_path")
	image_icon:loadTexture(itemid)
end

local function QuanxianByPosition( nPosition )
	print(nPosition)
	if tonumber(nPosition) == 1 then
	elseif tonumber(nPosition) == 2 or tonumber(nPosition) == 3 then
		image_Nothing:setTouchEnabled(false)
		image_test:setTouchEnabled(false)
		image_UnTest:setTouchEnabled(false)
		btn_Need_Cut:setTouchEnabled(false)
		btn_Need_Add:setTouchEnabled(false)
	elseif tonumber(nPosition) == 4 then
		m_InputExplainTextField:setVisible(false)
		m_InputExplainTextField:setTouchEnabled(false)
		m_InputNoticeTextField:setVisible(false)
		m_InputNoticeTextField:setTouchEnabled(false)
		image_Nothing:setTouchEnabled(false)
		image_test:setTouchEnabled(false)
		image_UnTest:setTouchEnabled(false)
		btn_alter_Declare:setVisible(false)
		btn_alter_Declare:setTouchEnabled(false)
		btn_alter_Notice:setVisible(false)
		btn_alter_Notice:setTouchEnabled(false)
		btn_icon:setVisible(false)
		btn_icon:setTouchEnabled(false)
		btn_Need_Cut:setVisible(false)
		btn_Need_Cut:setTouchEnabled(false)
		btn_Need_Add:setVisible(false)
		btn_Need_Add:setTouchEnabled(false)
		image_Nothing:setTouchEnabled(false)
		image_test:setTouchEnabled(false)
		image_level:setPosition(ccp(image_level:getPositionX() - 50,image_level:getPositionY()))
		--image_type:setPosition(ccp(image_type:getPositionX() - 50,image_type:getPositionY()))

	end
end

local function JudgeType( nTypeID )
	if nTypeID == 0 then
		image_Nothing:setScale(1)
		image_test:setScale(0.9)
		image_UnTest:setScale(0.9)
		image_Nothing:setColor(ccc3(255,255,255))
		image_test:setColor(ccc3(150,150,150))
		image_UnTest:setColor(ccc3(150,150,150))
	elseif nTypeID == 1 then
		image_Nothing:setScale(0.9)
		image_test:setScale(1)
		image_UnTest:setScale(0.9)
		image_Nothing:setColor(ccc3(150,150,150))
		image_test:setColor(ccc3(255,255,255))
		image_UnTest:setColor(ccc3(150,150,150))
	elseif nTypeID == 2 then
		image_Nothing:setScale(0.9)
		image_test:setScale(0.9)
		image_UnTest:setScale(1)
		image_Nothing:setColor(ccc3(150,150,150))
		image_test:setColor(ccc3(150,150,150))
		image_UnTest:setColor(ccc3(255,255,255))
	end
	
end

local function _Click_ChooseType_CallBack( sender,eventType )
	local pTag = tonumber(sender:getTag())
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		-- JudgeType(pTag)		
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingShow(false)
			JudgeType(pTag)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1415,nil)
			pTips = nil
		end
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(3,pTag))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function initData(value)
	--变量
	n_golbPosition = CorpsScene.n_GolbPosition
	flagid = value.flag
	corpsname = value.name
	local corpsid = value.id
	local corpslevel = value.level
	local corpspeople = value.people
	local corpsneedlevel = value.needlevel
	local corpsbrief = value.brief
	corpsCoutry = value.country
	m_CorpsIconID = value.flag
	local Image_Btom = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Image_bottom"),"ImageView")
	
	if ScrollView_Setting ~= nil then ScrollView_Setting:setClippingType(1) end
	
	--image_type = tolua.cast(ScrollView_Setting:getChildByName("Image_63"),"ImageView")
	image_level = tolua.cast(ScrollView_Setting:getChildByName("Image_73"),"ImageView")
	btn_Alter = tolua.cast(ScrollView_Setting:getChildByName("Button_Alter"),"Button")
	btn_Alter:setVisible(false)
	btn_Alter:setTouchEnabled(false)
	btn_Need_Cut = tolua.cast(ScrollView_Setting:getChildByName("Button_LevelCut"),"Button")
	btn_Need_Add = tolua.cast(ScrollView_Setting:getChildByName("Button_LevelAdd"),"Button")
	btn_alter_Declare = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Button_Declare"),"Button")
	btn_alter_Notice = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Button_Notice"),"Button")
	btn_icon = tolua.cast(ScrollView_Setting:getChildByName("Button_icon"),"Button")
	image_icon = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Image_CorpsIcon"),"ImageView")

	--修改军团图标
	local itemid = resimg.getFieldByIdAndIndex(m_CorpsIconID,"icon_path")
	image_icon:loadTexture(itemid)

	--验证类型
	local m_NothimgText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "无条件", ccp(1, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)
	local m_TestText  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "需验证", ccp(1, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)
	local m_UnTestText  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "不接受", ccp(1, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)
	
	image_Nothing = tolua.cast(ScrollView_Setting:getChildByName("Image_Nothing"),"ImageView")
	image_test    = tolua.cast(ScrollView_Setting:getChildByName("Image_test"),"ImageView")
	image_UnTest  = tolua.cast(ScrollView_Setting:getChildByName("Image_UnTest"),"ImageView")
	image_Nothing:setTag(0)
	image_test:setTag(1)
	image_UnTest:setTag(2)
	JudgeType(value.limitType)
	image_Nothing:setTouchEnabled(true)
	image_test:setTouchEnabled(true)
	image_UnTest:setTouchEnabled(true)
	image_Nothing:addChild(m_NothimgText)
	image_test:addChild(m_TestText)
	image_UnTest:addChild(m_UnTestText)
	image_Nothing:addTouchEventListener(_Click_ChooseType_CallBack)
	image_test:addTouchEventListener(_Click_ChooseType_CallBack)
	image_UnTest:addTouchEventListener(_Click_ChooseType_CallBack)

	--label
	local labelID = tolua.cast(ScrollView_Setting:getChildByName("Label_CorpsId"),"Label")
	labelName = tolua.cast(ScrollView_Setting:getChildByName("Label_CorpsName"),"Label")
	--labelTestTypr = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Label_TestType"),"Label")
	labelNeedLevel = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Label_NeedLevel"),"Label")
	local label_id = tolua.cast(ScrollView_Setting:getChildByName("Label_id"),"Label")
	local label_icon = tolua.cast(ScrollView_Setting:getChildByName("Label_icon"),"Label")
	local label_name = tolua.cast(ScrollView_Setting:getChildByName("Label_name"),"Label")
	local label_type = tolua.cast(ScrollView_Setting:getChildByName("Label_type"),"Label")
	local label_needlevel = tolua.cast(ScrollView_Setting:getChildByName("Label_needlevel"),"Label")
	-- local label_camp = tolua.cast(ScrollView_Setting:getChildByName("Label_camp"),"Label")
	local label_explain = tolua.cast(ScrollView_Setting:getChildByName("Label_explain"),"Label")
	local label_notice = tolua.cast(ScrollView_Setting:getChildByName("Label_notice"),"Label")
	label_explainContent = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Label_explainText"),"Label")
	label_noticeContent = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Label_noticetext"),"Label")

	m_NeedLevel = value.needLevel
	if labelNeedLevel:getChildByTag(1000) ~= nil then
		LabelLayer.setText(labelNeedLevel:getChildByTag(1000),value.needLevel)
	else
		local text = LabelLayer.createStrokeLabel(22,"微软雅黑",value.needLevel,ccp(0,0),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,-2),2)
		labelNeedLevel:addChild(text,0,1000)
	end

	local m_AlterNameText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "修改", ccp(1, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	local m_CampIconText  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "修改", ccp(1, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	local m_CorpsIconText  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "修改", ccp(1, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	m_nameText  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1,corpsname, ccp(1, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, -2), 2)
	local m_CorpsidText  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, corpsid, ccp(1, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	
	label_id:setText("军团ID：")
	label_name:setText("军团名称：")
	label_icon:setText("军团图标：")
	label_type:setText("验证类型：")
	label_needlevel:setText("需求等级：")
	-- label_camp:setText("选择阵营：")
	label_explain:setText("军团说明：")
	label_notice:setText("军团公告：")
	label_noticeContent:setText(value.m_notice)
	label_explainContent:setText(value.brief)

	QuanxianByPosition(n_golbPosition)

	btn_icon:addChild(m_CorpsIconText)
	labelID:addChild(m_CorpsidText)
	labelName:addChild(m_nameText)

	btn_Need_Cut:addTouchEventListener(_Click_NeedCut_CallBack)
	btn_Need_Add:addTouchEventListener(_Click_NeedAdd_CallBack)
	btn_icon:addTouchEventListener(_Click_IconChose_CallBack)
	
end

--初始化输入框
local function initEditbox()
   	local nTopNum = 0
   	local edit = nil
   	local editNotice = nil
   	local function editBoxTextEventHandle( strEventName,pSender )
   		edit = tolua.cast(pSender,"CCEditBox")
   		if strEventName == "began" then

   		elseif strEventName == "ended" then
   			local labelWord = edit:getText()
   			-- local labelContent = label_explainContent:getStringValue()
   			local lenStr = string.len(labelWord)
   			if lenStr <= 90 and lenStr >= 3 then
	   			local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingShow(false)
					label_explainContent:setText(labelWord)
	   				m_InputExplainTextField:setText("")
	   				local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1415,nil)
					pTips = nil
				end	
				Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(6,labelWord))
				NetWorkLoadingLayer.loadingShow(true)
				m_InputExplainTextField:setText("")
			else
				m_InputExplainTextField:setText("")
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1419,nil)
				pTips = nil
			end
   		elseif strEventName == "canceled" then

   		elseif strEventName == "changed" then

   		end
   	end

   	local function editBoxNTextEventsHandle( strEventName,pSender )
   		editNotice = tolua.cast(pSender,"CCEditBox")
   		if strEventName == "began" then

   		elseif strEventName == "ended" then
   			local labelWord = editNotice:getText()
   			-- local labelContent = label_explainContent:getStringValue()
   			local lenStr = string.len(labelWord)
   			if lenStr <= 90 and lenStr >= 3 then
	   			local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingShow(false)
					label_noticeContent:setText(labelWord)
	   				m_InputNoticeTextField:setText("")
	   				local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1415,nil)
					pTips = nil
				end	
				Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(7,labelWord))
				NetWorkLoadingLayer.loadingShow(true)
				m_InputNoticeTextField:setText("")
			else
				m_InputNoticeTextField:setText("")
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1419,nil)
				pTips = nil
			end
   		elseif strEventName == "canceled" then

   		elseif strEventName == "changed" then
   			
   		end
   	end
  
	--创建军团声明输入框
	m_InputExplainTextField = CCEditBox:create(CCSizeMake(50,50),CCScale9Sprite:create(BTN_EMPTY))--420
	m_InputExplainTextField:setPosition(ccp(490,250))
	m_InputExplainTextField:setMaxLength(30)
	m_InputExplainTextField:setPlaceholderFontColor(ccc3(255,255,255))
	m_InputExplainTextField:setPlaceholderFontSize(0)
	m_InputExplainTextField:setFontColor(ccc3(255,255,255))
	m_InputExplainTextField:setFontSize(0)
	m_InputExplainTextField:setReturnType(kKeyboardReturnTypeDone)
	m_InputExplainTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputExplainTextField:setInputMode(kEditBoxInputModeSingleLine)
	m_InputExplainTextField:registerScriptEditBoxHandler(editBoxTextEventHandle)
	m_InputExplainTextField:setTouchPriority(0)	
	 m_InputExplainTextField:setFontName(CommonData.g_FONT3)
	if ScrollView_Setting:getChildByTag(200)~=nil then
		ScrollView_Setting:getChildByTag(200):setVisible(false)
		ScrollView_Setting:getChildByTag(200):removeFromParentAndCleanup(true)
	end	
	ScrollView_Setting:addNode(m_InputExplainTextField,0,200)

	--创建公告输入框
	m_InputNoticeTextField = CCEditBox:create(CCSizeMake(50,50),CCScale9Sprite:create(BTN_EMPTY))--370
	m_InputNoticeTextField:setPosition(ccp(490,70))
	m_InputNoticeTextField:setMaxLength(30)
	m_InputNoticeTextField:setPlaceholderFontColor(ccc3(255,255,255))
	m_InputNoticeTextField:setPlaceholderFontSize(24)
	m_InputNoticeTextField:setFontColor(ccc3(255,255,255))
	m_InputNoticeTextField:setFontSize(24)
	m_InputNoticeTextField:setReturnType(kKeyboardReturnTypeDone)
	m_InputNoticeTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputNoticeTextField:setInputMode(kEditBoxInputModeSingleLine)

	m_InputNoticeTextField:registerScriptEditBoxHandler(editBoxNTextEventsHandle)
	m_InputNoticeTextField:setTouchPriority(0)
	m_InputNoticeTextField:setFontName(CommonData.g_FONT3)
	if ScrollView_Setting:getChildByTag(201)~=nil then
		ScrollView_Setting:getChildByTag(201):setVisible(false)
		ScrollView_Setting:getChildByTag(201):removeFromParentAndCleanup(true)
	end	
	ScrollView_Setting:addNode(m_InputNoticeTextField,0,201)

end


function upSetCorpsIcon()
	--initData(tableValue)
	ChangeImage(valueData)
end

function ShowInfoSettingLayer()
	initVar()
	
	tableValue = GetCorpsInfo()
	for key,value in pairs(tableValue) do
		valueData["id"] 			= value[1]
		valueData["name"] 			= value[2]
		valueData["flag"] 			= value[6]
		valueData["level"] 			= value[3]
		valueData["people"] 		= value[4]
		valueData["needLevel"] 		= value[5]
		valueData["country"] 		= value[7]
		valueData["brief"] 			= value[8]
		valueData["limitType"] 		= value[9]
		valueData["m_uContribute"] 	= value[10] -- 军团总贡献
		valueData["m_uCorpsMoney"] 	= value[11]
		valueData["m_notice"]       = value[12]
	end
	m_CorpsInfoSettingLayer = TouchGroup:create()
	m_CorpsInfoSettingLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSettinglayer.json"))
	Panel_ScrollView = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Panel_ScrollView"),"Layout")
	ScrollView_Setting = tolua.cast(Panel_ScrollView:getChildByName("ScrollView_SettingInfo"),"ScrollView")

	local btn_return = tolua.cast(m_CorpsInfoSettingLayer:getWidgetByName("Button_Return"),"Button")
	btn_return:addTouchEventListener(_Click_Return_CallBack)

	initEditbox()
	initData(valueData)
	

	weekDay = UnitTime.GetCurWday()

	return m_CorpsInfoSettingLayer
end