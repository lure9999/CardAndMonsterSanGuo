require "Script/Main/Corps/CorpsEnumType"

module("CorpsContentLayer",package.seeall)
require "Script/Main/Corps/CorpsContentLogic"
require "Script/Main/Corps/CorpsContentData"
require "Script/Main/Corps/CorpsContentDynamic"
require "Script/Main/Corps/CorpsSettingIcon"
require "Script/Main/Corps/CorpsTipLayer"
require "Script/Main/Corps/CorpsApplyListLayer"

local CreateApplyList = CorpsApplyListLayer.CreateApplyList
local CreateLabel = CorpsContentLogic.CreateLabel
local GetMemTechData = CorpsContentData.GetMemTechData
local GetCorpsInfo = CorpsData.GetCorpsInfo
local GetSetIconPath = CorpsContentData.GetSetIconPath
local GetCountry = CorpsContentData.GetCountry
local ChangedIconLayer = CorpsSettingIcon.ChangedIconLayer
local GetSetInfoByserver = CorpsContentData.GetSetInfoByserver
local GetMemberList = CorpsData.GetMemberList
local GetTotalLimitNum = CorpsContentData.GetTotalLimitNum
local GetOffTechData = CorpsContentData.GetOffTechData
local GetOfficalLimitNum = CorpsContentData.GetOfficalLimitNum
local GetOfficalControl = CorpsContentData.GetOfficalControl
local cleanListView = CorpsLogic.cleanListView
local SortTimeFromStatus = CorpsContentLogic.SortTimeFromStatus
local SortContributeFromStatus = CorpsContentLogic.SortContributeFromStatus
local SortTotalFromStatus = CorpsContentLogic.SortTotalFromStatus
local SearchId       = CorpsLogic.SearchId
local GetCorpsDynamicInfo = CorpsData.GetCorpsDynamicInfo
local SortPartByTime = CorpsContentData.SortPartByTime
local GetDayNumByMon = CorpsContentData.GetDayNumByMon

local BTN_CLOSE = "Image/imgres/button/btn_close.png"
local BTN_EMPTY = "Image/imgres/common/common_empty.png"
local BTN_WRITE = "Image/imgres/usersetting/btn_changeName.png"
local IMG_PATH_TITLE = "Image/imgres/equip/title_bg.png"
local IMG_PATH_LINE = "Image/imgres/equip/line_bg.png"
local m_ListInnerHeight = 0

--各个官职的人数
numUnGeneral = 0
numHua       = 0
numShengnv   = 0

local tabTestType = {"无条件加入","需要验证才可加入","不接受申请"}

local m_CorpsContentLayer   = nil
local m_CurrentType         = nil
local m_BoxSetting          = nil
local m_BoxDynamic          = nil
local m_BoxMember           = nil
local m_listMember          = nil
local m_dynamicList         = nil
local img_top               = nil
local panel_Member          = nil
local panel_Set             = nil
local panel_Dynamic         = nil
local img_itemIcon          = nil
local label_test            = nil
local label_needLevel       = nil
local m_scrollView          = nil
local label_explain         = nil
local label_notice          = nil
local JiesanCorpsLayer      = nil
local listMember_Info       = nil
local l_memberNum           = nil
local m_wordList = nil
local m_InputExplainTextField = nil
local m_InputNoticeTextField  = nil
local n_golbPosition        = 0
local num                   = 0
local m_NeedLevel           = 0
local mCurrentType          = 1
local heroOffID             = 0
local MemtotalLimitNum      = 0
local tabMemLevel           = {}
local tableHeroData         = {}
local function init(  )
	m_CorpsContentLayer  = nil
	m_CurrentType        = nil
	m_BoxMember          = nil
	m_BoxDynamic         = nil
	m_BoxSetting         = nil
	m_listMember         = nil
	m_dynamicList        = nil
	img_top              = nil
	panel_Dynamic        = nil
	panel_Set            = nil
	panel_Member         = nil
	img_itemIcon         = nil
	label_test           = nil
	label_needLevel      = nil
	m_scrollView         = nil
	label_explain        = nil
	label_notice         = nil
	JiesanCorpsLayer     = nil
	listMember_Info      = nil
	m_wordList 			 = nil
	l_memberNum          = nil
	m_InputNoticeTextField = nil
	m_InputExplainTextField = nil
	n_golbPosition       = 0
	num                  = 0
	m_NeedLevel          = 0
	mCurrentType         = 1
	heroOffID            = 0
	MemtotalLimitNum     = 0
	-- numUnGeneral         = 0
	-- numHua               = 0
	-- numShengnv           = 0
	tabMemLevel          = {}
	tableHeroData        = {}
end

function removeLayer(  )
	m_CorpsContentLayer:setVisible(false)
	m_CorpsContentLayer:removeFromParentAndCleanup(true)
	m_CorpsContentLayer = nil
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		--[[m_CorpsContentLayer:setVisible(false)
		m_CorpsContentLayer:removeFromParentAndCleanup(true)
		m_CorpsContentLayer = nil]]--
		removeLayer()
	end
end
--修改军团图标
local function _Click_AlterIcon_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()	
		sender:setScale(1.0)
		AddLabelImg(ChangedIconLayer(),104,m_CorpsContentLayer)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function CreateMemberInfoWidget( pListViewTemp )
	local pListViewMemberInfo = pListViewTemp:clone()
	local peer = tolua.getpeer(pListViewTemp)
	tolua.setpeer(pListViewMemberInfo,peer)
	return pListViewMemberInfo
end
--修改军团验证类型
--验证类型  减少
local function _Click_TypeCut_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		-- print("1...........",num)
		local num_tag = 0
		if num <= 0 then
			num_tag = 0
			num = 1
		else
			num = num - 1
			num_tag = num
		end
		
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingShow(false)
			local tabset = {}
			tabset = GetSetInfoByserver()
			local typeID = tonumber(tabset["contetnt"])
			label_test:setText(tabTestType[typeID+1])
			num = typeID
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1415,nil)
			pTips = nil
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(3,num_tag))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--验证类型   增加
local function _Click_TypeAdd_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local num_tag = 0
		if num >= 2 then
			num = 2
			num_tag = 2
		else
			num = num + 1
			num_tag = num
		end
		
		
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingShow(false)
			if num >= 2 then
				num = 3
			else
				num = num + 1
			end
			local tabset = {}
			tabset = GetSetInfoByserver()
			local typeID = tonumber(tabset["contetnt"])
			label_test:setText(tabTestType[typeID+1])
			num = typeID
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1415,nil)
			pTips = nil
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(3,num_tag))
		NetWorkLoadingLayer.loadingShow(true)
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
			local tabset = {}
			tabset = GetSetInfoByserver()
			label_needLevel:setText(tabset["contetnt"])
			m_NeedLevel = tonumber(tabset["contetnt"])
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
			local tabset = {}
			tabset = GetSetInfoByserver()
			label_needLevel:setText(tabset["contetnt"])
			m_NeedLevel = tonumber(tabset["contetnt"])
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1415,nil)
			pTips = nil
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(4,m_NeedLevel))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--复选框的状态
local function initStatus()
	m_BoxSetting:setSelectedState(false)
	m_BoxMember:setSelectedState(false)
	m_BoxDynamic:setSelectedState(false)
	m_BoxSetting:setZOrder(0)
	m_BoxMember:setZOrder(0)
	m_BoxDynamic:setZOrder(0)
	m_BoxSetting:setTouchEnabled(true)
	m_BoxMember:setTouchEnabled(true)
	m_BoxDynamic:setTouchEnabled(true)
end

--军团动态相关UI
local function CorpsDynamicFunction(  )
	local function GetDynamicSuccess(  )
		cleanListView(m_dynamicList)
		local tableDynamicData = GetCorpsDynamicInfo()
		local sortTab = SortPartByTime(tableDynamicData)
		local tabNum = #tableDynamicData
		
		for key,value1 in pairs(sortTab) do
			local m_DyItemManger = CorpsContentDynamic.CreateManger()
			m_DyItemManger:ShowDynamicItem(value1)
			m_dynamicList:pushBackCustomItem(m_DyItemManger:GetItem())
		end
	end
	Packet_CorpsDynamic.SetSuccessCallBack(GetDynamicSuccess)
	network.NetWorkEvent(Packet_CorpsDynamic.CreatePacket())
	
end

local function _Click_HeroInfo_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local p_tag = sender:getTag()
		local tablePersonData = {}
		for key,value in pairs(tableHeroData) do
			if SearchId(p_tag,value) == true then
				tablePersonData["userID"] = value.userID
				tablePersonData["faceID"] = value.faceID
				tablePersonData["name"] = value.name
				tablePersonData["power"] = value.power
				tablePersonData["lastTime"] = value.lastTime
				tablePersonData["seven"] = value.seven
				tablePersonData["level"] = value.level
				tablePersonData["position"] = value.position
				AddLabelImg(CorpsTipLayer.CreatePositionLayer(tablePersonData,heroOffID),layerCorpsPosition,m_CorpsContentLayer)
			
			end
		end
	end
end

local function loadMmemberInfo( valueItem )
	listMember_Info = TouchGroup:create()
	listMember_Info  =  GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSetMemberInfo.json")
	local listMemberInfoWidget = CreateMemberInfoWidget(listMember_Info)

	local panelTouch = tolua.cast(listMemberInfoWidget:getChildByName("Image_click"),"ImageView")
	panelTouch:setTouchEnabled(true)
	panelTouch:setTag(valueItem["userID"])
	panelTouch:addTouchEventListener(_Click_HeroInfo_CallBack)

	local img_HeadBtom = tolua.cast(listMemberInfoWidget:getChildByName("Image_Icon"),"ImageView")
	local img_HeadIcon = tolua.cast(img_HeadBtom:getChildByName("Image_iconID"),"ImageView")
	local img_level = tolua.cast(listMemberInfoWidget:getChildByName("Image_level"),"ImageView")
	local label_level = tolua.cast(img_level:getChildByName("Label_Level"),"Label")
	local hero_name = tolua.cast(listMemberInfoWidget:getChildByName("Label_Name"),"Label")
	local label_guanzhi = tolua.cast(listMemberInfoWidget:getChildByName("Label_guanzhi"),"Label")
	local label_time = tolua.cast(listMemberInfoWidget:getChildByName("Label_data"),"Label")
	local label_switch = tolua.cast(listMemberInfoWidget:getChildByName("Label_switch"),"Label")
	
	if tonumber(valueItem["faceID"]) == 0 then
		UIInterface.MakeHeadIcon(img_HeadIcon,ICONTYPE.DISPLAY_ICON,nil,nil,nil,nil,7)
	else
		UIInterface.MakeHeadIcon(img_HeadIcon, ICONTYPE.HEAD_ICON, nil, nil,nil,valueItem["faceID"],nil)
	end

	label_level:setText(valueItem["level"])
	local l_nameText = LabelLayer.createStrokeLabel(25, CommonData.g_FONT1, valueItem["name"], ccp(0, 0), ccc3(80,46,26), ccc3(253,235,200), true, ccp(0, -2), 2)
	hero_name:addChild(l_nameText)	

	local p_officalText = ""
	if tonumber(valueItem["position"]) == 0 then
		p_officalText = "将军"
		label_guanzhi:setColor(ccc3(100,4,101))
	elseif tonumber(valueItem["position"]) == 1 then
		p_officalText = "副将"
		label_guanzhi:setColor(ccc3(8,141,23))
		numUnGeneral = numUnGeneral + 1
	elseif tonumber(valueItem["position"]) == 2 then
		p_officalText = "护法"
		label_guanzhi:setColor(ccc3(17,59,152))
		numHua = numHua + 1
	elseif tonumber(valueItem["position"]) == 3 then
		p_officalText = "圣女"
		label_guanzhi:setColor(ccc3(17,59,152))
		numShengnv = numShengnv + 1
	elseif tonumber(valueItem["position"]) == 4 then
		p_officalText = "帮众"
		label_guanzhi:setColor(ccc3(49,31,21))
	end
	label_guanzhi:setText(p_officalText)

	local mTimeStr = nil
	local nTimeStr = nil
	local nTimeDB = os.date("*t", valueItem.lastTime)
	local ntime = os.date("*t")

	local delta_T = ntime.day - nTimeDB.day
	if tonumber(nTimeDB.min) < 10 then
		nTimeDB.min = "0"..nTimeDB.min
	end
	local nWeekStr = tonumber(nTimeDB.wday)

	

	--先判断月份 月份相差两个月
	if (tonumber(ntime["month"]) - tonumber(nTimeDB["month"])) > 1 then
		nTimeStr = "一个月前"
	else
		-- 月份相差一个月，登录不在本月
		if (tonumber(ntime["month"]) - tonumber(nTimeDB["month"])) == 1 then
			-- 获得上次登录月份的天数
			local m_lastNum = GetDayNumByMon(nTimeDB["month"],nTimeDB["year"])
			-- 得到相差的天数
			local d_dayNum = (m_lastNum - tonumber(nTimeDB["day"])) + tonumber(ntime["day"])
			if d_dayNum > 30 then
				nTimeStr = "一个月前"
			else
				nTimeStr = d_dayNum.. "天前"
			end

		else
			--在同一个月份内
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
		end
	end

	if mCurrentType == C_MemberStatus.C_MemberLastTime then
		label_time:setText(nTimeStr)
		label_switch:setText("最后上线时间：")
	elseif mCurrentType == C_MemberStatus.C_MemberWeekContribute then
		label_time:setText(valueItem["seven"])
		label_switch:setText("最近七天贡献：")
	elseif mCurrentType == C_MemberStatus.C_MemberTotalContribute then
		label_time:setText(valueItem["totalContibute"])
		label_switch:setText("总贡献：")
	end

	m_listMember:pushBackCustomItem(listMemberInfoWidget)
    m_listMember:jumpToTop()
    m_listMember:setItemsMargin(5)
    local nGlobalID = CommonData.g_nGlobalID	
    if tonumber(nGlobalID) == tonumber(valueItem["userID"]) then
    	heroOffID = tonumber(valueItem["position"])
    end
    	

end

function loadDataFromServer(  )
	cleanListView(m_listMember)
	tableHeroData = {}
	local numPerson = 0
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
				numPerson = numPerson + 1
				table.insert(tableHeroData,value)
				l_memberNum:setText(numPerson.."/"..MemtotalLimitNum)
			end
		else
			
		end
		
	end	
	Packet_CorpsGetMemList.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetMemList.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)
end

--查看申请列表的回调
local function _Click_ApplyList_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		--查看所有的申请
		AudioUtil.PlayBtnClick()
		AddLabelImg(CreateApplyList(2),102,m_CorpsContentLayer)
	end
end

--军团成员相关UI
local function CorpsMemberFunction(  )
	local tableLevel = {}
	tabMemLevel  = {}
	tableLevel = CorpsData.GetScienceLevel()
	tabMemLevel =  tableLevel[2]
	local tabTechData = {}
	tabTechData = GetMemTechData(tabMemLevel["m_nLevel"])

	local btn_applyList = tolua.cast(m_CorpsContentLayer:getWidgetByName("Button_apply"),"Button")
	if btn_applyList:getChildByTag(101) ~= nil then
		LabelLayer.setText(btn_applyList:getChildByTag(101),"申请列表")
	else
		local l_Btnapply    = LabelLayer.createStrokeLabel(25, CommonData.g_FONT1, "申请列表", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
		btn_applyList:addChild(l_Btnapply,1,101)  
	end
	btn_applyList:addTouchEventListener(_Click_ApplyList_CallBack)
end
--修改图标
function ChangedCorpsIconItem(pTag)
	-- m_CorpsIconID = pTag
	local itemid = resimg.getFieldByIdAndIndex(pTag,"icon_path")
	img_itemIcon:loadTexture(itemid)
	return m_CorpsIconID
end

--初始化输入框
local function initEditbox()
   	local nTopNum = 0
   	local edit = nil
   	local editNotice = nil
   	local img_setEx = tolua.cast(m_scrollView:getChildByName("Image_setEx"),"ImageView")
   	local img_setNt = tolua.cast(m_scrollView:getChildByName("Image_setNt"),"ImageView")
   	
   	local function editBoxTextEventHandle( strEventName,pSender )
   		edit = tolua.cast(pSender,"CCEditBox")
   		--通过tag值来判断是公告还是军团声明
   		local n_tag = edit:getTag()

   		if strEventName == "began" then
   		elseif strEventName == "ended" then
   			local labelWord = edit:getText()
   			local lenStr = string.len(labelWord)
   			if tonumber(n_tag) == 200 then
   			
	   			if lenStr <= 90 and lenStr >= 3 then
		   			local function GetSuccessCallback(  )
						NetWorkLoadingLayer.loadingShow(false)
						local tabText = GetSetInfoByserver()
						label_explain:setText(tabText["contetnt"])
						
		   				local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1415,nil)
						pTips = nil
					end	
					Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
					network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(6,labelWord))
					NetWorkLoadingLayer.loadingShow(true)
					m_InputExplainTextField:setText("")
				else
					-- m_InputExplainTextField:setText("")
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1419,nil)
					pTips = nil
				end
			elseif tonumber(n_tag) == 201 then
				if lenStr <= 90 and lenStr >= 3 then
		   			local function GetSuccessCallback(  )
						NetWorkLoadingLayer.loadingShow(false)
						local tabText = GetSetInfoByserver()
						label_notice:setText(tabText["contetnt"])
		   				local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1415,nil)
						pTips = nil
					end	
					Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
					network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(7,labelWord))
					NetWorkLoadingLayer.loadingShow(true)
					m_InputNoticeTextField:setText("")
				else
					-- m_InputNoticeTextField:setText("")
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1419,nil)
					pTips = nil
				end
   			end
   		elseif strEventName == "return" then
   		elseif strEventName == "changed" then
   			--[[local everyWords = edit:getText()
   			if tonumber(n_tag) == 200 then
   				label_explain:setText(everyWords)
   			elseif tonumber(n_tag) == 201 then
   				label_notice:setText(everyWords)
   			end]]--
   		end
   	end
  	
	--创建军团声明输入框
	m_InputExplainTextField = CCEditBox:create(CCSizeMake(60,60),CCScale9Sprite:create(BTN_WRITE))--420
	-- m_InputExplainTextField:setPosition(ccp(468,338))
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
	if img_setEx:getNodeByTag(200)~=nil then
		img_setEx:getNodeByTag(200):setVisible(false)
		img_setEx:getNodeByTag(200):removeFromParentAndCleanup(true)
	end	
	img_setEx:addNode(m_InputExplainTextField,0,200)

	--创建公告输入框
	m_InputNoticeTextField = CCEditBox:create(CCSizeMake(60,60),CCScale9Sprite:create(BTN_WRITE))--370
	-- m_InputNoticeTextField:setPosition(ccp(467,136))
	m_InputNoticeTextField:setMaxLength(30)
	m_InputNoticeTextField:setPlaceholderFontColor(ccc3(255,255,255))
	m_InputNoticeTextField:setPlaceholderFontSize(24)
	m_InputNoticeTextField:setFontColor(ccc3(255,255,255))
	m_InputNoticeTextField:setFontSize(24)
	m_InputNoticeTextField:setReturnType(kKeyboardReturnTypeDone)
	m_InputNoticeTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputNoticeTextField:setInputMode(kEditBoxInputModeSingleLine)

	m_InputNoticeTextField:registerScriptEditBoxHandler(editBoxTextEventHandle)
	m_InputNoticeTextField:setTouchPriority(0)
	m_InputNoticeTextField:setFontName(CommonData.g_FONT3)
	if img_setNt:getNodeByTag(201)~=nil then
		img_setNt:getNodeByTag(201):setVisible(false)
		img_setNt:getNodeByTag(201):removeFromParentAndCleanup(true)
	end	
	img_setNt:addNode(m_InputNoticeTextField,0,201)

	if tonumber(n_golbPosition) == 4 then
		m_InputNoticeTextField:setVisible(false)
		m_InputNoticeTextField:setTouchEnabled(false)
		m_InputExplainTextField:setVisible(false)
		m_InputExplainTextField:setTouchEnabled(false)
	else
		m_InputNoticeTextField:setVisible(true)
		m_InputNoticeTextField:setTouchEnabled(true)
		m_InputExplainTextField:setVisible(true)
		m_InputExplainTextField:setTouchEnabled(true)
	end

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
	NetWorkLoadingLayer.ClearLoading()
	local m_pMainRoot = MainScene.GetControlUI()				
	CorpsScene.InitVars()
	CorpsScene.CleanCorpsTopLayer()
	init()
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
			NetWorkLoadingLayer.loadingHideNow(false)
			JieSanCallBack()
						
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
local function LeaveCalBack(  )
	local m_pCorpsScene = CorpsScene.GetPScene()
	local m_pMainRoot = MainScene.GetControlUI()
	if m_pCorpsScene ~= nil then
		CorpsScene.CleanCorpsTopLayer()
	end
	NetWorkLoadingLayer.ClearLoading()				
	-- CorpsScene.InitVars()
	init()
	CCDirector:sharedDirector():popScene()
	ChatShowLayer.ShowChatlayer(m_pMainRoot)
	
end
local function _Click_LeaveCorps_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local pTag = sender:getTag()
		if pTag == 0 then
			BreakCorps()
		else
			MainScene.SetCurParent(true)
			CorpsLogic.LeaveCorps(LeaveCalBack)
		end
	end
end

--设置右边的参数内容
local function CorpsSetRight(  )
	local tableLevel = {}
	tabMemLevel  = {}
	local tabOfficalLevel = {}
	tableLevel = CorpsData.GetScienceLevel()
	tabMemLevel =  tableLevel[2]--当前科技
	tabOfficalLevel = tableLevel[3]
	local tabTechData = {}
	tabTechData = GetMemTechData(tabMemLevel["m_nLevel"])--当前科技对应的信息

	local tabMem = GetMemberList()
	local totalLimitNum = GetTotalLimitNum(tabMemLevel["m_nLevel"]) -- 当前科技的总人数
	local t_hufa,t_shengnv = GetOfficalLimitNum(tabOfficalLevel["m_nLevel"])
	local n_offNum1 = 0
	local n_offNum2 = 0
	local n_offNum3 = 0
	local n_offNum4 = 0
	local n_offNum5 = 0
	for key,value in pairs(tabMem) do
		if tonumber(value["position"]) == 0 then
			n_offNum1 = n_offNum1 + 1
		elseif tonumber(value["position"]) == 1 then
			n_offNum2 = n_offNum2 + 1
		elseif tonumber(value["position"]) == 2 then
			n_offNum3 = n_offNum3 + 1
		elseif tonumber(value["position"]) == 3 then
			n_offNum4 = n_offNum4 + 1
		elseif tonumber(value["position"]) == 4 then
			n_offNum5 = n_offNum5 + 1
		end
	end
	local img_off1 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_offical"),"ImageView")
	local label_off1 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_officalNum"),"Label")
	local img_off2 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_offical_0"),"ImageView")
	local label_off2 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_officalNum1"),"Label")
	local img_off3 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_offical_1"),"ImageView")
	local label_off3 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_officalNum2"),"Label")
	local img_off4 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_offical_2"),"ImageView")
	local label_off4 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_officalNum3"),"Label")
	-- local img_off5 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_offical_3"),"ImageView")
	-- local label_off5 = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_officalNum4"),"Label")

	label_off1:setText(n_offNum1.."/"..1)
	label_off2:setText(n_offNum2.."/"..1)
	label_off3:setText(n_offNum4.."/"..t_shengnv)
	label_off4:setText(n_offNum3.."/"..t_hufa)
	-- label_off5:setText(n_offNum5.."/"..totalLimitNum)

	local m_showInfo = nil
	local function ShowOffical( nTag )
		if m_showInfo == nil then
			m_showInfo = TouchGroup:create()
		    m_showInfo:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSetMemTips.json") )
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			scenetemp:addChild(m_showInfo, layerCorpsPosition, layerCorpsPosition)
		end
		local img_tips = tolua.cast(m_showInfo:getWidgetByName("Image_bg"),"ImageView")
		local tabOffText = GetOfficalControl(nTag)
		local t_num = #tabOffText
		local lineMaxNum = math.ceil(t_num/3)
		local lineMinNum = math.floor(t_num/3)
		local residum = t_num - lineMinNum*3
		for i=1,#tabOffText do
			if (lineMaxNum - i) == 0 then
				for j=1,residum do
					local IconIndex = ((i - 1)*3) + j
					local label_OfficalText = Label:create()
					label_OfficalText:setFontSize(18)
					label_OfficalText:setColor(ccc3(233,189,119))
					label_OfficalText:setText(tabOffText[IconIndex])
					label_OfficalText:setPosition(ccp(-240+j*120,60-(i-1)*30))
					img_tips:addChild(label_OfficalText)
				end
			else
				for j=1,3 do
					local IconIndex = ((i - 1)*3) + j
					local label_OfficalText = Label:create()
					label_OfficalText:setFontSize(18)
					label_OfficalText:setColor(ccc3(233,189,119))
					label_OfficalText:setText(tabOffText[IconIndex])
					label_OfficalText:setPosition(ccp(-240+j*120,60-(i-1)*30))
					img_tips:addChild(label_OfficalText)
				end
			end
		end
	end

	local function _Click_Offical_CallBack( sender,eventType )
		local pTag = sender:getTag()
		if eventType == TouchEventType.ended then
	  		sender:setScale(1.0)
	  		m_showInfo:setVisible(false)
	  		m_showInfo:removeFromParentAndCleanup(true)
	  		m_showInfo = nil
	    elseif  eventType == TouchEventType.began then
	    	AudioUtil.PlayBtnClick()
	     	sender:setScale(0.9)
	     	ShowOffical(pTag)
	    elseif eventType == TouchEventType.canceled then
	    	sender:setScale(1.0)
	    	m_showInfo:setVisible(false)
	  		m_showInfo:removeFromParentAndCleanup(true)
	  		m_showInfo = nil
	    elseif eventType == TouchEventType.moved then
	    	
	    end
	end
	img_off1:setTouchEnabled(true)
	img_off2:setTouchEnabled(true)
	img_off3:setTouchEnabled(true)
	img_off4:setTouchEnabled(true)
	-- img_off5:setTouchEnabled(true)
	img_off1:setTag(1)
	img_off2:setTag(2)
	img_off3:setTag(3)
	img_off4:setTag(4)
	-- img_off5:setTag(5)

	img_off1:addTouchEventListener(_Click_Offical_CallBack)
	img_off2:addTouchEventListener(_Click_Offical_CallBack)
	img_off3:addTouchEventListener(_Click_Offical_CallBack)
	img_off4:addTouchEventListener(_Click_Offical_CallBack)
	-- img_off5:addTouchEventListener(_Click_Offical_CallBack)
end

--军团设置相关UI
local function CorpsSetFunction(  )
	local tableSetValue = {}
	tableSetValue = GetCorpsInfo()
	num = 0
	m_NeedLevel = tableSetValue[1][5]
	local strBtn = ""
	if tonumber(n_golbPosition) == 0 then
		
		strBtn = "解散军团"
	else
		strBtn = "离开军团"
	end
	local btn_leave = tolua.cast(m_CorpsContentLayer:getWidgetByName("Button_jiesan"),"Button")
	if btn_leave:getChildByTag(101) ~= nil then
		LabelLayer.setText(btn_leave:getChildByTag(101),strBtn)
	else
		local l_Btnleave    = LabelLayer.createStrokeLabel(25, CommonData.g_FONT1, strBtn, ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
		btn_leave:addChild(l_Btnleave,1,101)  
	end  
	btn_leave:setTag(n_golbPosition)
	btn_leave:addTouchEventListener(_Click_LeaveCorps_CallBack)
	
	local label_name = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_name"),"Label")
	local label_ID = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_ID"),"Label")
	local img_itemBtom = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_ItemIcon"),"ImageView")
	img_itemIcon = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_Item"),"ImageView")
	local img_country = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_countryIcon"),"ImageView")
	local btn_left = tolua.cast(m_CorpsContentLayer:getWidgetByName("Button_left"),"Button")
	local img_left = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_157"),"ImageView")
	local btn_right = tolua.cast(m_CorpsContentLayer:getWidgetByName("Button_right"),"Button")
	local img_right = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_158"),"ImageView")
	local btn_sub = tolua.cast(m_CorpsContentLayer:getWidgetByName("Button_sub"),"Button")
	local btn_add = tolua.cast(m_CorpsContentLayer:getWidgetByName("Button_add"),"Button")
	local img_sub = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_159"),"ImageView")
	local img_add = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_160"),"ImageView")
	label_test = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_typeNum"),"Label")
	label_needLevel = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_levelNum"),"Label")
	label_explain = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_explainText"),"Label")
	label_notice = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_NoticeText"),"Label")

	local corpsName = LabelLayer.createStrokeLabel(25, CommonData.g_FONT1, tableSetValue[1][2], ccp(15, 0), ccc3(51,25,13), ccc3(255,221,74), true, ccp(0, -3), 3)
	label_name:addChild(corpsName)
	label_ID:setText(tableSetValue[1][1]) --设置ID
	--军团图标
	local pathIcon = GetSetIconPath(tableSetValue[1][6])
	local countryIcon = GetCountry(tableSetValue[1][7])
	img_itemIcon:loadTexture(pathIcon)
	img_country:loadTexture(countryIcon)
	

	--验证类型
	num = tonumber(tableSetValue[1][9])
	local n_numType = tonumber(tableSetValue[1][9]) + 1
	local testTypeText = tabTestType[n_numType]
	label_test:setText(testTypeText)
	

	--需求等级
	label_needLevel:setText(tableSetValue[1][5])
	

	label_explain:setText(tableSetValue[1][8])

	label_notice:setText(tableSetValue[1][12])

	--根据权限显示
	local pSpriteLeft = tolua.cast(btn_left:getVirtualRenderer(), "CCSprite")
	local pSpriteRight = tolua.cast(btn_right:getVirtualRenderer(), "CCSprite")
	local pSpriteSub = tolua.cast(btn_sub:getVirtualRenderer(), "CCSprite")
	local pSpriteAdd = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
	local pSpriteimgLeft = tolua.cast(img_left:getVirtualRenderer(), "CCSprite")
	local pSpriteimgRight = tolua.cast(img_right:getVirtualRenderer(), "CCSprite")
	local pSpriteimgSub = tolua.cast(img_sub:getVirtualRenderer(), "CCSprite")
	local pSpriteimgAdd = tolua.cast(img_add:getVirtualRenderer(), "CCSprite")

	if tonumber(n_golbPosition) == 4 then
		SpriteSetGray(pSpriteLeft,1)
		SpriteSetGray(pSpriteRight,1)
		SpriteSetGray(pSpriteSub,1)
		SpriteSetGray(pSpriteAdd,1)
		SpriteSetGray(pSpriteimgLeft,1)
		SpriteSetGray(pSpriteimgRight,1)
		SpriteSetGray(pSpriteimgSub,1)
		SpriteSetGray(pSpriteimgAdd,1)
		btn_left:setTouchEnabled(false)
		btn_right:setTouchEnabled(false)
		btn_sub:setTouchEnabled(false)
		btn_add:setTouchEnabled(false)

	else
		SpriteSetGray(pSpriteLeft,0)
		SpriteSetGray(pSpriteRight,0)
		SpriteSetGray(pSpriteSub,0)
		SpriteSetGray(pSpriteAdd,0)
		SpriteSetGray(pSpriteimgLeft,0)
		SpriteSetGray(pSpriteimgRight,0)
		SpriteSetGray(pSpriteimgSub,0)
		SpriteSetGray(pSpriteimgAdd,0)
		btn_left:setTouchEnabled(true)
		btn_right:setTouchEnabled(true)
		btn_sub:setTouchEnabled(true)
		btn_add:setTouchEnabled(true)
		img_itemBtom:setTouchEnabled(true)
		img_itemBtom:addTouchEventListener(_Click_AlterIcon_CallBack)
		btn_left:addTouchEventListener(_Click_TypeCut_CallBack)
		btn_right:addTouchEventListener(_Click_TypeAdd_CallBack)
		btn_add:addTouchEventListener(_Click_NeedAdd_CallBack)
		btn_sub:addTouchEventListener(_Click_NeedCut_CallBack)
	end

	local function GetSuccessCallback(  )
		CorpsSetRight()
	end
	Packet_CorpsGetMemList.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetMemList.CreatePacket())
end
local function loadWidgetUI(  )
	img_top = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_top"),"ImageView")
	panel_Member = tolua.cast(m_CorpsContentLayer:getWidgetByName("Panel_member"),"Layout")
	panel_Dynamic = tolua.cast(m_CorpsContentLayer:getWidgetByName("Panel_dynamic"),"Layout")
	panel_Set = tolua.cast(m_CorpsContentLayer:getWidgetByName("Panel_set"),"Layout")

	--军团成员列表UI
	m_listMember = tolua.cast(m_CorpsContentLayer:getWidgetByName("ListView_item"),"ListView")
	if m_listMember ~= nil then m_listMember:setClippingType(1) end
	--军团动态
	m_dynamicList = tolua.cast(m_CorpsContentLayer:getWidgetByName("ListView_dynamic"),"ListView")
	if m_dynamicList ~= nil then m_dynamicList:setClippingType(1) end
end



--整体UI显示内容
local function initCorpsStatus( nCurrentType )
	--top顶层的UI
	mCurrentType = 1
	local l_memberWord = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_num"),"Label")
	l_memberNum = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_menNum"),"Label")
	local img_switch = tolua.cast(m_CorpsContentLayer:getWidgetByName("Image_switch"),"ImageView")
	local label_first = tolua.cast(m_CorpsContentLayer:getWidgetByName("Label_first"),"Label")

	local tableLevel = {}
	tabMemLevel  = {}
	tableLevel = CorpsData.GetScienceLevel()
	tabMemLevel =  tableLevel[2]--当前科技

	MemtotalLimitNum = GetTotalLimitNum(tabMemLevel["m_nLevel"]) -- 当前科技的总人数

	local function ShowWordBg(  )
		if m_wordList == nil then
			m_wordList = TouchGroup:create()
			m_wordList:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSetMemItem.json") )
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			scenetemp:addChild(m_wordList, layerMerInfo_Tag, layerMerInfo_Tag)
		end

		local panel_word = tolua.cast(m_wordList:getWidgetByName("Panel_21"),"Layout")
		local imgWordBg = tolua.cast(m_wordList:getWidgetByName("Image_itembg"),"ImageView")
		local btn_time = tolua.cast(imgWordBg:getChildByName("Button_time"),"Button")
		local btn_week = tolua.cast(imgWordBg:getChildByName("Button_week"),"Button")
		local btn_total = tolua.cast(imgWordBg:getChildByName("Button_total"),"Button")

		btn_time:setTag(1)
		btn_week:setTag(2)
		btn_total:setTag(3)
		panel_word:setTag(4)
		local function _Click_Change_CallBack( sender,eventType )
			if eventType == TouchEventType.ended then
				AudioUtil.PlayBtnClick()	
				sender:setScale(1.0)
				local p_tag = sender:getTag()
				mCurrentType = p_tag
				numUnGeneral = 0
				numHua = 0
				numShengnv = 0
				if p_tag == 1 then
					label_first:setText("最后上线时间")
					loadDataFromServer()
				elseif p_tag == 2 then
					label_first:setText("军团七日贡献")
					loadDataFromServer()
				elseif p_tag == 3 then
					label_first:setText("军团总贡献")
					loadDataFromServer()
				end
				img_switch:setVisible(true)
				img_switch:setTouchEnabled(true)
				m_wordList:setVisible(false)
				m_wordList:removeFromParentAndCleanup(true)
				m_wordList = nil
			elseif  eventType == TouchEventType.began then
				sender:setScale(0.9)
			elseif eventType == TouchEventType.canceled then
				sender:setScale(1.0)
			end
		end
		btn_time:addTouchEventListener(_Click_Change_CallBack)
		btn_week:addTouchEventListener(_Click_Change_CallBack)
		btn_total:addTouchEventListener(_Click_Change_CallBack)
		-- panel_word:setTouchEnabled(true)
		-- panel_word:addTouchEventListener(_Click_Change_CallBack)
	end
	local function _ClickShowWord_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			img_switch:setVisible(false)
			img_switch:setTouchEnabled(false)
			ShowWordBg()
		end
		
	end
	img_switch:setTouchEnabled(true)
	img_switch:addTouchEventListener(_ClickShowWord_CallBack)

	m_scrollView = tolua.cast(m_CorpsContentLayer:getWidgetByName("ScrollView_Set"),"ScrollView")
	if m_scrollView ~= nil then
		m_scrollView:setClippingType(1)
	end

	if nCurrentType == C_CORPSCONTENTSTATUS.C_ContentSet then
		panel_Set:setVisible(true)
		panel_Set:setTouchEnabled(true)
		panel_Set:setZOrder(1)
		panel_Member:setVisible(false)
		panel_Member:setTouchEnabled(false)
		panel_Member:setZOrder(0)
		panel_Dynamic:setVisible(false)
		panel_Dynamic:setTouchEnabled(false)
		panel_Dynamic:setZOrder(0)
		img_switch:setVisible(false)
		img_switch:setTouchEnabled(false)
		l_memberNum:setVisible(false)
		l_memberWord:setText("军团设置")
		
		local function GetSuccessSetCallback(  )
			CorpsSetFunction()
		end
		Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessSetCallback)
		network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
	elseif nCurrentType == C_CORPSCONTENTSTATUS.C_ContentMember then
		panel_Member:setVisible(true)
		panel_Member:setTouchEnabled(true)
		panel_Member:setZOrder(1)
		panel_Set:setVisible(false)
		panel_Set:setTouchEnabled(false)
		panel_Set:setZOrder(0)
		panel_Dynamic:setVisible(false)
		panel_Dynamic:setTouchEnabled(false)
		panel_Dynamic:setZOrder(0)
		img_switch:setVisible(true)
		img_switch:setTouchEnabled(true)
		l_memberWord:setText("军团成员")
		l_memberNum:setVisible(true)
		CorpsMemberFunction()
		loadDataFromServer()

		numUnGeneral = 0
		numHua = 0
		numShengnv = 0
		
	elseif nCurrentType == C_CORPSCONTENTSTATUS.C_ContentDynamic then
		panel_Dynamic:setVisible(true)
		panel_Dynamic:setTouchEnabled(true)
		panel_Dynamic:setZOrder(1)

		panel_Member:setVisible(false)
		panel_Member:setTouchEnabled(false)
		panel_Member:setZOrder(0)
		panel_Set:setVisible(false)
		panel_Set:setTouchEnabled(false)
		panel_Set:setZOrder(0)

		l_memberWord:setText("军团动态")
		img_switch:setVisible(false)
		img_switch:setTouchEnabled(false)
		l_memberNum:setVisible(false)
		CorpsDynamicFunction()
		
	end
end

--复选框上文字的改变
local function CheckSelectStatus(  )
	if m_BoxSetting:getChildByTag(100) ~= nil then
		m_BoxSetting:getChildByTag(100):removeFromParentAndCleanup(true)
		local pCorpsSetText = CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		m_BoxSetting:addChild(pCorpsSetText,100,100)
	end
	if m_BoxMember:getChildByTag(100) ~= nil then
		m_BoxMember:getChildByTag(100):removeFromParentAndCleanup(true)
		local pCorpsMemberText = CreateLabel( "成员", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		m_BoxMember:addChild(pCorpsMemberText,100,100)
	end
	if m_BoxDynamic:getChildByTag(100) ~= nil then
		m_BoxDynamic:getChildByTag(100):removeFromParentAndCleanup(true)
		local pCorpsDynamicText = CreateLabel( "动态", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		m_BoxDynamic:addChild(pCorpsDynamicText,100,100)
	end
end

--检测checkBox的状态
local function CheckBoxStatus( mCurrentIndex )
	--initData()
	initStatus()
	tableHeroData = {}
	if mCurrentIndex == C_CORPSCONTENTSTATUS.C_ContentSet then
		m_BoxSetting:setSelectedState(true)
		m_BoxSetting:setZOrder(2)
	elseif mCurrentIndex == C_CORPSCONTENTSTATUS.C_ContentMember then
		m_BoxMember:setSelectedState(true)
		m_BoxMember:setZOrder(2)
		
	elseif mCurrentIndex == C_CORPSCONTENTSTATUS.C_ContentDynamic then
		m_BoxDynamic:setSelectedState(true)
		m_BoxDynamic:setZOrder(2)
		
	end
	m_CurrentType = mCurrentIndex
	initCorpsStatus(m_CurrentType)
end
--点击复选框的响应回调
local function _Click_CheckBox_CallBack( sender,eventType )
	local CorpsListType = tolua.cast(sender,"CheckBox")
	AudioUtil.PlayBtnClick()
	local boxTag = CorpsListType:getTag()
	CheckBoxStatus(CorpsListType:getTag())
	CheckSelectStatus()
	if boxTag == C_CORPSCONTENTSTATUS.C_ContentSet then
		if m_BoxSetting:getChildByTag(100) ~= nil then
	        m_BoxSetting:getChildByTag(100):removeFromParentAndCleanup(true)
	        local pCorpsSetText    = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "军团", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
	    	m_BoxSetting:addChild(pCorpsSetText,100,100)
	    end
	elseif boxTag == C_CORPSCONTENTSTATUS.C_ContentMember then
		if m_BoxMember:getChildByTag(100) ~= nil then
	        m_BoxMember:getChildByTag(100):removeFromParentAndCleanup(true)
	        local pCorpsMemberText    = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "成员", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
	    	m_BoxMember:addChild(pCorpsMemberText,100,100)
	    end
	elseif boxTag == C_CORPSCONTENTSTATUS.C_ContentDynamic then
		if m_BoxDynamic:getChildByTag(100) ~= nil then
	        m_BoxDynamic:getChildByTag(100):removeFromParentAndCleanup(true)
	        local pCorpsDynamicText    = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "动态", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
	    	m_BoxDynamic:addChild(pCorpsDynamicText,100,100)
	    end
	end
	
end
--加载复选框
local function initWidgetBox( nCurrentIndex )
	m_BoxSetting = tolua.cast(m_CorpsContentLayer:getWidgetByName("CheckBox_Set"),"CheckBox")
	m_BoxMember  = tolua.cast(m_CorpsContentLayer:getWidgetByName("CheckBox_member"),"CheckBox")
	m_BoxDynamic = tolua.cast(m_CorpsContentLayer:getWidgetByName("CheckBox_dynamic"),"CheckBox")

	m_BoxSetting:setTag(C_CORPSCONTENTSTATUS.C_ContentSet)
	m_BoxMember:setTag(C_CORPSCONTENTSTATUS.C_ContentMember)
	m_BoxDynamic:setTag(C_CORPSCONTENTSTATUS.C_ContentDynamic)

	local pCorpsSetText,pCorpsMemberText,pCorpsDynamicText = nil

	if nCurrentIndex == C_CORPSCONTENTSTATUS.C_ContentSet then
		pCorpsSetText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "军团", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, -2), 2)
		pCorpsMemberText = CreateLabel( "成员", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		pCorpsDynamicText = CreateLabel( "动态", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
	elseif nCurrentIndex == C_CORPSCONTENTSTATUS.C_ContentMember then
		pCorpsMemberText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "成员", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, -2), 2)
		pCorpsSetText = CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		pCorpsDynamicText = CreateLabel( "动态", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
	elseif nCurrentIndex == C_CORPSCONTENTSTATUS.C_ContentDynamic then
		pCorpsDynamicText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "动态", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, -2), 2)
		pCorpsMemberText = CreateLabel( "成员", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		pCorpsSetText = CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
	end
	

	m_BoxSetting:addChild(pCorpsSetText,100,100)
	m_BoxMember:addChild(pCorpsMemberText,100,100)
	m_BoxDynamic:addChild(pCorpsDynamicText,100,100)

	m_BoxSetting:addEventListenerCheckBox(_Click_CheckBox_CallBack)
	m_BoxMember:addEventListenerCheckBox(_Click_CheckBox_CallBack)
	m_BoxDynamic:addEventListenerCheckBox(_Click_CheckBox_CallBack)
end
--创建层
function CreateContentLayer( nIndex ,tabLevel )
	init()
	m_CorpsContentLayer = TouchGroup:create()
	m_CorpsContentLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSetMemberLayer.json"))
	tabMemLevel = tabLevel


	n_golbPosition = CorpsScene.n_GolbPosition -- 获得自己的官职
	m_CurrentType = nIndex
	loadWidgetUI()
	initWidgetBox(m_CurrentType)
	CheckBoxStatus(m_CurrentType)
	initEditbox()
	local btn_return = tolua.cast(m_CorpsContentLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_Return_CallBack)

	return m_CorpsContentLayer
end