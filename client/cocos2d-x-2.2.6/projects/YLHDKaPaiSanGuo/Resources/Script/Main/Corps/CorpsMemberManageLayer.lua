--FileName:CorpsMemberManageLayer
--Author:sixuechao
--Purpose:军团成员信息
--require "Script/Common/Common"
require "Script/Main/Corps/CorpsEnumType"
require "Script/Common/LabelLayer"
require "Script/Common/UIInterface"
require "Script/serverDB/server_mainDB"

module("CorpsMemberManageLayer",package.seeall)
require "Script/Main/Corps/CorpsApplyListLayer"
require "Script/Main/Corps/CorpsTipLayer"
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceData"
require "Script/Main/Corps/CorpsMemberSortLogic"
local CreateApplyList = CorpsApplyListLayer.CreateApplyList
local cleanListView = CorpsLogic.cleanListView
local GetMemberList = CorpsData.GetMemberList
local GetHeadImgPath = CorpsData.GetHeadImgPath
local SearchId       = CorpsLogic.SearchId
local GetScienceUpDate  	= CorpsScienceData.GetScienceUpdate
local SortTimeFromStatus = CorpsMemberSortLogic.SortTimeFromStatus
local SortTotalFromStatus = CorpsMemberSortLogic.SortTotalFromStatus
local SortContributeFromStatus = CorpsMemberSortLogic.SortContributeFromStatus


local m_CorpsMemberManagerLayer     = nil
local m_BoxLastTime                 = nil
local m_BoxWeekContribute           = nil
local m_BoxTotalContribute          = nil
local mCurrentType                  = nil
local listMemberInfoWidget          = nil
local ListView_MemberInfo           = nil
local ListView_Seven                = nil
local ListView_Total                = nil
local JiesanCorpsLayer              = nil
local listMember_Info               = nil
local Hero_InfoLayer                = nil
local HeroInfoLayer                 = nil
local HeroSetInfoLayer 			    = nil
local LeaveHeroName                 = nil
local label_position                = nil
local lable_offical                 = nil
local tableHeroData = {}
local tablePersonData = {}
local tablePersonNumData = {}
local tableNumLevel = {}
local tablePositionType = {"将军","副将","护法","圣女","帮众"}
local num = 1
local CorpsPosition = nil
local Heroposition = nil
local btn_ApplyList = nil
local btn_InvMember = nil
local btn_leave = nil
local peopleNum = 1
local l_corpsmemText = nil
local nGlobalID = nil
local PersonUserid = nil
local PositionNum  = nil
local heroPerposition = nil
local heroUserid = nil
local labelpowerdataText = nil
numGeneral = 0
numUnGeneral = 0
numHua = 0
numShengnv = 0


local function initData()
	m_CorpsMemberManagerLayer = nil
	m_BoxTotalContribute      = nil
	m_BoxWeekContribute       = nil
	m_BoxLastTime             = nil
	listMemberInfoWidget      = nil
	ListView_MemberInfo       = nil
	ListView_Seven            = nil
	ListView_Total            = nil
	mCurrentType              = nil
	JiesanCorpsLayer          = nil
	listMember_Info           = nil
	Hero_InfoLayer            = nil  
	HeroInfoLayer             = nil
	HeroSetInfoLayer 		  = nil
	LeaveHeroName             = nil
	label_position            = nil
	lable_offical             = nil
	CorpsPosition             = nil
	Heroposition              = nil
	btn_ApplyList 			  = nil
	Button_InvMember 		  = nil
	btn_leave 				  = nil
	l_corpsmemText            = nil
	nGlobalID				  = nil
	PersonUserid              = nil
	PositionNum               = nil
	heroPerposition           = nil
	heroUserid                = nil
	labelpowerdataText 		  = nil
	tableHeroData = {}
	tablePersonNumData = {}
	tableNumLevel  = {}
	numGeneral = 0
	numUnGeneral = 0
	numHua = 0
	numShengnv = 0
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then  
		AudioUtil.PlayBtnClick()
		m_CorpsMemberManagerLayer:setVisible(false)
		m_CorpsMemberManagerLayer:removeFromParentAndCleanup(true)
		m_CorpsMemberManagerLayer = nil
	end
end

local function initStatus()
	m_BoxLastTime:setSelectedState(false)
	m_BoxWeekContribute:setSelectedState(false)
	m_BoxTotalContribute:setSelectedState(false)
	m_BoxLastTime:setZOrder(0)
	m_BoxWeekContribute:setZOrder(0)
	m_BoxTotalContribute:setZOrder(0)
	m_BoxLastTime:setTouchEnabled(true)
	m_BoxWeekContribute:setTouchEnabled(true)
	m_BoxTotalContribute:setTouchEnabled(true)
end

local function CreateMemberInfoWidget( pListViewTemp )
	local pListViewMemberInfo = pListViewTemp:clone()
	local peer = tolua.getpeer(pListViewTemp)
	tolua.setpeer(pListViewMemberInfo,peer)
	return pListViewMemberInfo
end

--查看成员信息回调
local function _Click_HeroInfo_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		local HeroIconItemTag = tolua.cast(sender,"ImageView")
		local pTag = HeroIconItemTag:getTag()
		for key,value in pairs(tableHeroData) do
			if SearchId(pTag,value) == true then
				tablePersonData["userID"] = value.userID
				tablePersonData["faceID"] = value.faceID
				tablePersonData["name"] = value.name
				tablePersonData["power"] = value.power
				tablePersonData["lastTime"] = value.lastTime
				tablePersonData["seven"] = value.seven
				tablePersonData["level"] = value.level
				tablePersonData["position"] = value.position
				AddLabelImg(CorpsTipLayer.CreatePositionLayer(tablePersonData,heroposition),layerCorpsPosition,m_CorpsMemberManagerLayer)
			end
		end
	end
end

local function GetCorpsPosition( )
	local function GetSuccessCallback(  )
		NetWorkLoadingLayer.loadingShow(false)
		local tableTemp = GetMemberList()
		if #tableTemp ~= 0 then
			for key,value in pairs(tableTemp) do
				CorpsPosition = value.position
			end
		else
			
		end
		
	end	
	Packet_CorpsGetMemList.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetMemList.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)
end

--取消解散军团的回调
local function _Click_JieSanCorpsCancel_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		JiesanCorpsLayer:setVisible(false)
		JiesanCorpsLayer:removeFromParentAndCleanup(true)
		JiesanCorpsLayer = nil
	end
end

function JieSanCallBack(  )
	if CommonData.g_CountryWarLayer ~= nil then
		CommonData.g_CountryWarLayer:removeFromParentAndCleanup(false)
	end
	local m_pCorpsScene = CorpsScene.GetPScene()
	if m_pCorpsScene ~= nil then
		local coinLayer = m_pCorpsScene:getChildByTag(layerCoinBar_Tag)
		if coinLayer ~= nil then
			coinLayer:removeFromParentAndCleanup(true)
			coinLayer = nil
		end
	end
	local m_pMainRoot = MainScene.GetControlUI()				
	CorpsScene.InitVars()
	CorpsScene.CleanCorpsTopLayer()
	initData()
	CCDirector:sharedDirector():popScene()
	MainScene.SetCurParent(true)
	ChatShowLayer.ShowChatlayer(m_pMainRoot)
	-- CoinInfoBar.AddCoinBar(m_pMainRoot)
	
end

--确定解散军团的回调
local function _Click_JieSanCorpsCertain_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local function GetSuccessCallback(  )
			-- NetWorkLoadingLayer.loadingHideNow()
			JieSanCallBack()
			NetWorkLoadingLayer.ClearLoading()			
		end
		Packet_CorpsDelete.SetSuccessCallback(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsDelete.CreatePacket())
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--解散军团json
local function BreakCorps( )
	if JiesanCorpsLayer == nil then
		JiesanCorpsLayer = TouchGroup:create()
	    JiesanCorpsLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsLeaveOr.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(JiesanCorpsLayer, layerCorpsJieSan_Tag, layerCorpsJieSan_Tag)
	end
	local imageBg = tolua.cast(JiesanCorpsLayer:getWidgetByName("Image_Bg"),"ImageView")
	local label_content = tolua.cast(imageBg:getChildByName("Label_content"),"Label")
	local label_warnning = tolua.cast(imageBg:getChildByName("Label_warn"),"Label")
	local btn_cancel = tolua.cast(imageBg:getChildByName("Button_Canel"),"Button")
	local btn_certain = tolua.cast(imageBg:getChildByName("Button_certain"),"Button")

	--添加文字,颜色
	local strContent = "军团成立至今,包含着所有成员的心血与努力！".."\n".."          确定是否真的要解散军团?"
	local strWarnning = "注：该操作不可逆！请慎重操作"
	local label_dfh = Label:create()
	label_dfh:setFontSize(24)
	label_dfh:setFontName(CommonData.g_FONT3)
	label_dfh:setColor(ccc3(51,25,13))
	label_dfh:setText(strContent)
	local labelContentText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, strContent, ccp(0, 0), ccc3(83,28,2), ccc3(51,25,13), true, ccp(0, -2), 2)	
	local labelWarnningText = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, strWarnning, ccp(0, 0), ccc3(83,28,2), ccc3(194,14,0), true, ccp(0, -2), 2)	
	local labelCancelText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "取消", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, -2), 2)
	local labelCertainText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, -2), 2)

	label_content:addChild(label_dfh)
	-- label_warnning:addChild(labelWarnningText)
	label_warnning:setText("注：该操作不可逆！请慎重操作")
	-- label_content:setText(labelContentText)
	btn_cancel:addChild(labelCancelText)
	btn_certain:addChild(labelCertainText)
	btn_cancel:addTouchEventListener(_Click_JieSanCorpsCancel_CallBack)
	btn_certain:addTouchEventListener(_Click_JieSanCorpsCertain_CallBack)

end

--查看申请列表的回调
local function _Click_ApplyList_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		--查看所有的申请
		AudioUtil.PlayBtnClick()
		AddLabelImg(CreateApplyList(2),102,m_CorpsMemberManagerLayer)
		--Packet_CorpsGetList.SetSuccessCallBack(GetSuccessCall)
		--network.NetWorkEvent(Packet_CorpsGetList.CreatePacket(1,chooseNum))
		--NetWorkLoadingLayer.loadingShow(true)
	end
end

--解散军团按钮的回调
local function _Click_InvMember_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		BreakCorps()
	end
end

local function LeaveCalBack(  )
	local m_pCorpsScene = CorpsScene.GetPScene()
	local m_pMainRoot = MainScene.GetControlUI()
	if m_pCorpsScene ~= nil then
		--[[local coinLayer = m_pCorpsScene:getChildByTag(layerCoinBar_Tag)
		if coinLayer ~= nil then
			coinLayer:removeFromParentAndCleanup(true)
			coinLayer = nil
		end
		CoinInfoBar.AddCoinBar(m_pMainRoot)]]--
		CorpsScene.CleanCorpsTopLayer()
	end
					
	CorpsScene.InitVars()
	initData()
	CCDirector:sharedDirector():popScene()
	ChatShowLayer.ShowChatlayer(m_pMainRoot)
	
	
	NetWorkLoadingLayer.ClearLoading()
end

--离开军团的回调
local function _Click_LeaveCorps_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		MainScene.SetCurParent(true)
		CorpsLogic.LeaveCorps(LeaveCalBack)
	end
end

--通过官职来确定权限
local function ShowButton( nPosition )
	--PersonUserid
	if nPosition == 0 then
		btn_ApplyList:setVisible(true)
		btn_InvMember:setVisible(true)
		btn_leave:setVisible(false)
		btn_ApplyList:setTouchEnabled(true)
		btn_InvMember:setTouchEnabled(true)
		btn_leave:setTouchEnabled(false)
		btn_ApplyList:addTouchEventListener(_Click_ApplyList_CallBack)
		btn_InvMember:addTouchEventListener(_Click_InvMember_CallBack)
	elseif nPosition == 1 or nPosition == 2 or nPosition == 3 then
		btn_ApplyList:setVisible(true)
		btn_InvMember:setVisible(false)
		btn_leave:setVisible(true) 
		btn_ApplyList:setTouchEnabled(true)
		btn_InvMember:setTouchEnabled(false)
		btn_leave:setTouchEnabled(true)
		btn_ApplyList:addTouchEventListener(_Click_ApplyList_CallBack)
		btn_leave:addTouchEventListener(_Click_LeaveCorps_CallBack)
	else
		btn_leave:setVisible(true)
		btn_leave:setTouchEnabled(true)
		btn_leave:addTouchEventListener(_Click_LeaveCorps_CallBack)
	end
end

--通过传过来的类型确定
--成员列表，显示成员的信息
local function loadMmemberInfo(value)
	nGlobalID = CommonData.g_nGlobalID	
	listMember_Info  =  GUIReader:shareReader():widgetFromJsonFile("Image/Corps_MemberInfo.json")
	listMemberInfoWidget = CreateMemberInfoWidget(listMember_Info)

	local herolevel = server_mainDB.getMainData("level")
	local heroname = server_mainDB.getMainData("name")

	Heroposition = value.position
	local heroname1 = value.name
	PersonUserid = value.userID
	local Faceid = value.faceID
	local heroPower = value.power
	local LastTime = value.lastTime
	local Week = value.seven
	local hero_level = value.level

	local MemberIconItem = tolua.cast(listMemberInfoWidget:getChildByName("Image_Icon"),"ImageView")
	local m_k = tolua.cast(MemberIconItem:getChildByName("Image_49"),"ImageView")
	m_k:setVisible(false)
	local HeroIconItem = tolua.cast(MemberIconItem:getChildByName("Image_iconID"),"ImageView")
	if Faceid == 0 then
		UIInterface.MakeHeadIcon(HeroIconItem,ICONTYPE.DISPLAY_ICON,nil,nil,nil,nil,7)

		HeroIconItem:setScale(0.68)
	else
		-- HeroIconItem:loadTexture(GetHeadImgPath(Faceid))
		-- UIInterface.MakeHeadIcon(HeroIconItem,ICONTYPE.PLAYER_ICON,value["faceID"],nil,nil,nil,6,nil)
		local pControl = UIInterface.MakeHeadIcon(HeroIconItem, ICONTYPE.HEAD_ICON, nil, nil,nil,value["faceID"],nil)
	end

	--UIInterface.MakeHeadIcon(HeroIconItem,ICONTYPE.DISPLAY_ICON,nil,nil,nil,nil,nil)
	--HeroIconItem:setScale(0.68)
	local image_click = tolua.cast(listMemberInfoWidget:getChildByName("Image_click"),"ImageView")
	image_click:setTouchEnabled(true)
	image_click:setTag(value.userID)
	image_click:addTouchEventListener(_Click_HeroInfo_CallBack)
	local image_level = tolua.cast(listMemberInfoWidget:getChildByName("Image_level"),"ImageView")
	local label_level = tolua.cast(image_level:getChildByName("Label_Level"),"Label")

	local label_power = tolua.cast(listMemberInfoWidget:getChildByName("Label_Power"),"Label")
	local label_guanzhi = tolua.cast(listMemberInfoWidget:getChildByName("Label_guanzhi"),"Label")
	local label_name = tolua.cast(listMemberInfoWidget:getChildByName("Label_Name"),"Label")
	local label_offocial = tolua.cast(listMemberInfoWidget:getChildByName("Label_official"),"Label")
	local label_switch = tolua.cast(listMemberInfoWidget:getChildByName("Label_switch"),"Label")
	local label_data = tolua.cast(listMemberInfoWidget:getChildByName("Label_data"),"Label")
	local image_bt = tolua.cast(listMemberInfoWidget:getChildByName("Image_bt"),"ImageView")
	image_bt:setVisible(false)


	local mTimeStr = nil
	local nTimeStr = nil
	local nTimeDB = os.date("*t", value.lastTime)
	local ntime = os.date("*t")
	local delta_T = ntime.day - nTimeDB.day
	if tonumber(nTimeDB.min) < 10 then
		nTimeDB.min = "0"..nTimeDB.min
	end
	local nWeekStr = tonumber(nTimeDB.wday)
	if ntime.day == nTimeDB.day then
		mTimeStr = "今日"
		nTimeStr = mTimeStr..nTimeDB.hour..":"..nTimeDB.min
	elseif ntime.day ~= nTimeDB.day then
		if delta_T > 30 then
			nTimeStr = "一个月前"
		else
			if delta_T < 0 then
				mTimeStr = "今日"
				if tonumber(ntime.min) < 10 then
					ntime.min = "0"..ntime.min
				end
				nTimeStr = mTimeStr..ntime.hour..":"..ntime.min
			else
				nTimeStr = delta_T.. "天前"
			end
		end
	end	

    local labelLevelText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, hero_level, ccp(0, 0), ccc3(83,28,2), COLOR_White, true, ccp(0, -2), 2)
    local labelNameText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, heroname1, ccp(0, 0), ccc3(80,46,26), ccc3(255,235,200), true, ccp(0, -2), 2)
    
   
	-- label_offocial:setText("大将军")
	label_power:setText("官职：")
	label_level:setText(hero_level)

    local labelpowerdataTexts = Label:create()
    labelpowerdataTexts:setFontSize(24)
    labelpowerdataTexts:setColor(ccc3(255,235,200))
    labelpowerdataTexts:setPosition(ccp(-20,0))
    if Heroposition == 0 then
    	labelpowerdataTexts:setText("将军")
    	--labelpowerdataTexts = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "将军", ccp(-20, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)
    elseif Heroposition == 1 then
    	labelpowerdataTexts:setText("副将")
    	--labelpowerdataTexts = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "副将", ccp(-20, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)
    elseif Heroposition == 2 then
    	labelpowerdataTexts:setText("护法")
    	--labelpowerdataTexts = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "先锋", ccp(-20, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)
    elseif Heroposition == 3 then
    	labelpowerdataTexts:setText("圣女")
    	--labelpowerdataTexts = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "圣女", ccp(-20, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)
    elseif Heroposition == 4 then
    	labelpowerdataTexts:setText("帮众")
    	--labelpowerdataTexts = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "帮众", ccp(-20, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)
    end

    label_guanzhi:addChild(labelpowerdataTexts)
    label_name:addChild(labelNameText)

    if mCurrentType == C_MemberStatus.C_MemberLastTime then
    	label_switch:setText("最后上线时间:")
    	label_data:setText(nTimeStr)
    	ListView_MemberInfo:pushBackCustomItem(listMemberInfoWidget)
    	ListView_MemberInfo:jumpToTop()	
    elseif mCurrentType == C_MemberStatus.C_MemberWeekContribute then
    	label_switch:setText("最近七日贡献:")
    	label_data:setText(Week)
    	ListView_Seven:pushBackCustomItem(listMemberInfoWidget)
    	ListView_Seven:jumpToTop()	
    elseif mCurrentType == C_MemberStatus.C_MemberTotalContribute then
    	label_switch:setText("总贡献:")
    	label_data:setText(value["totalContibute"])
    	ListView_Total:pushBackCustomItem(listMemberInfoWidget)
    	ListView_Total:jumpToTop()
    end
    if nGlobalID == PersonUserid then
    	heroposition = value.position
    	ShowButton(heroposition)
    end
    
end

function GetPeopleNum( num )
	peopleNum = peopleNum + num
	return peopleNum
end

function loadDataFromServer(  )
	cleanListView(ListView_MemberInfo)
	cleanListView(ListView_Seven)
	cleanListView(ListView_Total)
	numGeneral = 0
	numUnGeneral = 0
	numHua = 0
	numShengnv = 0
	tableHeroData = {}
	local function GetSuccessCallback()
		NetWorkLoadingLayer.loadingShow(false)
		local tableTemp = GetMemberList()
		local tabTime = {}
		if mCurrentType == C_MemberStatus.C_MemberLastTime then
			tabTime = SortTimeFromStatus(tableTemp,true)
		elseif mCurrentType == C_MemberStatus.C_MemberWeekContribute then
			tabTime = SortContributeFromStatus(tableTemp,true)
		elseif mCurrentType == C_MemberStatus.C_MemberTotalContribute then
			tabTime = SortTotalFromStatus(tableTemp,true)
		end
		if #tableTemp ~= 0 then
			for key,value in pairs(tabTime) do
				loadMmemberInfo(value)
				local Heroposition = value.position	
				if value.position == 0 then
					numGeneral = numGeneral + 1
				elseif value.position == 1 then
					numUnGeneral = numUnGeneral + 1
				elseif value.position == 2 then
					numHua = numHua + 1
				elseif value.position == 3 then
					numShengnv = numShengnv + 1
				end
				table.insert(tableHeroData,value)
			end
		else
			
		end
		
		LabelLayer.setText(l_corpsmemText,#tableTemp)
	end	
	Packet_CorpsGetMemList.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetMemList.CreatePacket())
	-- NetWorkLoadingLayer.ClearLoading()
	NetWorkLoadingLayer.loadingShow(true)
end

--从服务器中解析加载成员数据
local function loadHeroInfoData()
	cleanListView(ListView_MemberInfo)
	cleanListView(ListView_Seven)
	cleanListView(ListView_Total)
	tableHeroData = {}
	local tableTemp = GetMemberList()
	local tabTime = {}
	
	if mCurrentType == C_MemberStatus.C_MemberLastTime then
		tabTime = SortTimeFromStatus(tableTemp,true)
	elseif mCurrentType == C_MemberStatus.C_MemberWeekContribute then
		tabTime = SortContributeFromStatus(tableTemp,true)
	elseif mCurrentType == C_MemberStatus.C_MemberTotalContribute then
		tabTime = SortTotalFromStatus(tableTemp,true)
	end
	
	for key,value in pairs(tabTime) do
		loadMmemberInfo(value)
		if value.position == 0 then
			numGeneral = numGeneral + 1
		elseif value.position == 1 then
			numUnGeneral = numUnGeneral + 1
		elseif value.position == 2 then
			numHua = numHua + 1
		elseif value.position == 3 then
			numShengnv = numShengnv + 1
		end
		local Heroposition = value.position	
		table.insert(tableHeroData,value)
	end
	LabelLayer.setText(l_corpsmemText,#tableTemp)
end

--显示界面中的UI控件
local function initCorpsMemberStatus( nCurrentType )
	--panel
	for i=11,14 do
		local ArrayMemData = CorpsScienceData.GetArrayData(i)
		table.insert(tablePersonNumData,ArrayMemData)
	end
	local tablepersonLevel = tablePersonNumData[tableNumLevel.m_nLevel]
	local numPerson = CorpsData.GetCorpsMemberNum(tablepersonLevel[10])
	
	local Image_Bg = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("Image_Btom"),"ImageView")
	local Panel_Last = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("Panel_ListViewLasttime"),"Layout")
	local Panel_Week = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("Panel_ListViewSeven"),"Layout")
	local Panel_Total = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("Panel_TotalContribte"),"Layout")

	--button
	btn_ApplyList = tolua.cast(Image_Bg:getChildByName("Button_ApplyList"),"Button")
	btn_InvMember = tolua.cast(Image_Bg:getChildByName("Button_InvMember"),"Button")
	btn_leave = tolua.cast(Image_Bg:getChildByName("Button_leave"),"Button")

	local label_Member  = tolua.cast(Image_Bg:getChildByName("Label_Member"),"Label")
	local label_title = tolua.cast(Image_Bg:getChildByName("Label_CorpsMember"),"Label")
	local label_totalMem = tolua.cast(Image_Bg:getChildByName("Label_6"),"Label")

	--listView
	ListView_MemberInfo = tolua.cast(Panel_Last:getChildByName("ListView_MemInfo"),"ListView")
	if ListView_MemberInfo ~= nil then ListView_MemberInfo:setClippingType(1) end
	ListView_Seven = tolua.cast(Panel_Week:getChildByName("ListView_Seven"),"ListView")
	if ListView_Seven ~= nil then ListView_Seven:setClippingType(1) end
	ListView_Total = tolua.cast(Panel_Total:getChildByName("ListView_Total"),"ListView")
	if ListView_Total ~= nil then ListView_Total:setClippingType(1) end

	--添加文字,颜色
	local l_applistText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "申请列表", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	local l_disText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "解散军团", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	local l_leaveText = LabelLayer.createStrokeLabel(18, CommonData.g_FONT3, "离开军团", ccp(0, 0), ccc3(83,28,2), COLOR_White, true, ccp(0, -2), 2)
	l_corpsmemText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, peopleNum, ccp(10, 0), COLOR_Black, ccc3(99,216,53), true, ccp(0, -2), 2)
	--local l_numText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "军团成员:", ccp(0, 0), ccc3(83,28,2), ccc3(63,28,11), true, ccp(0, -2), 2)
	local l_totalnumText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "/"..numPerson, ccp(-10, 0), COLOR_Black, ccc3(99,216,53), true, ccp(0, -2), 2)

	

	btn_ApplyList:addChild(l_applistText)
	btn_InvMember:addChild(l_disText)
	btn_leave:addChild(l_leaveText)
	btn_ApplyList:setVisible(false)
	btn_ApplyList:setTouchEnabled(false)
	btn_InvMember:setVisible(false)
	btn_InvMember:setTouchEnabled(false)
	btn_leave:setVisible(false)
	btn_leave:setTouchEnabled(false)
	label_Member:addChild(l_corpsmemText)
	label_title:setText("军团成员:")
	label_totalMem:addChild(l_totalnumText)

	Panel_Last:setVisible(false)
	Panel_Last:setTouchEnabled(false)
	Panel_Last:setZOrder(2)
	Panel_Week:setVisible(false)
	Panel_Week:setTouchEnabled(false)
	Panel_Week:setZOrder(2)
	Panel_Total:setVisible(false)
	Panel_Total:setTouchEnabled(false)
	Panel_Total:setZOrder(2)
	
	if nCurrentType == C_MemberStatus.C_MemberLastTime then
		Panel_Last:setVisible(true)
		Panel_Last:setTouchEnabled(true)
		Panel_Last:setZOrder(5)
		cleanListView(ListView_MemberInfo)

		--loadDataFromServer()
		loadHeroInfoData()
		cleanListView(ListView_Seven)
		cleanListView(ListView_Total)
	elseif nCurrentType == C_MemberStatus.C_MemberWeekContribute then
		Panel_Week:setVisible(true)
		Panel_Week:setTouchEnabled(true)
		Panel_Week:setZOrder(5)
		cleanListView(ListView_Seven)
		--loadDataFromServer()
		loadHeroInfoData()
		cleanListView(ListView_Total)
		cleanListView(ListView_MemberInfo)
	elseif nCurrentType == C_MemberStatus.C_MemberTotalContribute then
		Panel_Total:setVisible(true)
		Panel_Total:setTouchEnabled(true)
		Panel_Total:setZOrder(5)
		cleanListView(ListView_Total)
		--loadDataFromServer()
		loadHeroInfoData()
		cleanListView(ListView_Seven)
		cleanListView(ListView_MemberInfo)
	end

end

--检测checkBox的状态
local function CheckBoxStatus( mCurrentIndex )
	--initData()
	initStatus()
	tableHeroData = {}
	if mCurrentIndex == C_MemberStatus.C_MemberLastTime then
		m_BoxLastTime:setSelectedState(true)
		m_BoxLastTime:setZOrder(2)
		
	elseif mCurrentIndex == C_MemberStatus.C_MemberWeekContribute then
		m_BoxWeekContribute:setSelectedState(true)
		m_BoxWeekContribute:setZOrder(2)
		
	elseif mCurrentIndex == C_MemberStatus.C_MemberTotalContribute then
		m_BoxTotalContribute:setSelectedState(true)
		m_BoxTotalContribute:setZOrder(2)
		
	end
	mCurrentType = mCurrentIndex
	initCorpsMemberStatus(mCurrentType)
end

local function _Click_CheckBox_CallBack( sender,eventType )
	local MemberListType = tolua.cast(sender,"CheckBox")
	AudioUtil.PlayBtnClick()
	CheckBoxStatus(MemberListType:getTag())
end

local function initMemberWidget( nCurrentIndex )
	m_BoxLastTime = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("CheckBox_Time"),"CheckBox")
	m_BoxWeekContribute = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("CheckBox_WeekContribute"),"CheckBox")
	m_BoxTotalContribute = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("CheckBox_TotallContribute"),"CheckBox")

	m_BoxLastTime:setTag(C_MemberStatus.C_MemberLastTime)
	m_BoxWeekContribute:setTag(C_MemberStatus.C_MemberWeekContribute)
	m_BoxTotalContribute:setTag(C_MemberStatus.C_MemberTotalContribute)

	local pLastTimeText = Label:create()
	pLastTimeText:setFontSize(30)
	pLastTimeText:setColor(ccc3(63,28,11))
	pLastTimeText:setFontName(CommonData.g_FONT1)
	pLastTimeText:setText("最后上线时间")

	local pWeekContributeText = Label:create()
	pWeekContributeText:setFontSize(30)
	pWeekContributeText:setColor(ccc3(63,28,11))
	pWeekContributeText:setFontName(CommonData.g_FONT1)
	pWeekContributeText:setText("军团周贡献")

	local pTotalContributeText = Label:create()
	pTotalContributeText:setFontSize(30)
	pTotalContributeText:setColor(ccc3(63,28,11))
	pTotalContributeText:setFontName(CommonData.g_FONT1)
	pTotalContributeText:setText("军团总贡献")


	m_BoxLastTime:addChild(pLastTimeText)
	m_BoxWeekContribute:addChild(pWeekContributeText)
	m_BoxTotalContribute:addChild(pTotalContributeText)

	m_BoxLastTime:addEventListenerCheckBox(_Click_CheckBox_CallBack)
	m_BoxWeekContribute:addEventListenerCheckBox(_Click_CheckBox_CallBack)
	m_BoxTotalContribute:addEventListenerCheckBox(_Click_CheckBox_CallBack)

	
	--initCorpsMemberStatus(nCurrentIndex)
end

--创建函数
function CreateMemberLayer( nIndex ,tabLevel)
	initData()
	
	m_CorpsMemberManagerLayer = TouchGroup:create()
	m_CorpsMemberManagerLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/Corps_MemberList.json"))

	--[[local ScienceID = 2
	local function JudgePerson()
		NetWorkLoadingLayer.loadingHideNow()
		local tablePerson = CorpsScienceData.GetScienceUpdate()
	end	
	Packet_CorpsScienceUpDate.SetSuccessCallBack(JudgePerson)
	network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(ScienceID))
	NetWorkLoadingLayer.loadingShow(true)]]--
	local tab = CorpsData.GetScienceLevel()
	tableNumLevel = tab[2]

	local pBoxCurrentType = nIndex
	mCurrentType = pBoxCurrentType

	initMemberWidget(pBoxCurrentType)

	CheckBoxStatus(pBoxCurrentType)

	local btn_Return = tolua.cast(m_CorpsMemberManagerLayer:getWidgetByName("Button_return"),"Button")
	btn_Return:addTouchEventListener(_Click_Return_CallBack)

	return m_CorpsMemberManagerLayer

end