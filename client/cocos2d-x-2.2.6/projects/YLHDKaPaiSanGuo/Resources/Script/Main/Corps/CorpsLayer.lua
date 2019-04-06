--FileName:Corpslayer
--Author:xuechao
--Purpose:军团创建,查找,加入界面
--require "Script/Common/Common"
require "Script/Common/LabelLayer"
require "Script/serverDB/server_mainDB"
module("CorpsLayer", package.seeall)
require "Script/Main/Corps/CorpsChangeIconLayer"
--测试UI
require "Script/Main/Corps/CorpsData"
require "Script/Main/Corps/CorpsInfoSetLayer"
require "Script/Main/Corps/CorpsApplyListLayer"
require "Script/Main/Corps/CorpsLogic"
--require "Script/Main/Corps/CorpsScene"


local m_CorpsPanel        	= nil
local m_BoxCorpsCreate    	= nil
local m_BoxCorpsAdd       	= nil
local m_BoxCorpsFind      	= nil
local m_InputCreateField 		= nil
local nCurrentType       		= nil
local m_InputNameTextField 	= nil
local m_InputIDTextField 		= nil
local m_ItemIcon         		= nil
local listCorpsInfoWidget	 	= nil
local ListViewAddInfo    		= nil
local CorpsIconItem       	= nil
local Panel_Create 			= nil
local Panel_Find 				= nil
local m_BtnSearch             = nil
local m_CorpsSearchID         = nil
local listViewFindResult      = nil
local LableCorpsLevel         = nil
local m_LabelLevel            = nil
local m_countryID             = 2
local m_CorpsIconID           = 2
m_CampFlagID            = 1
local Panel_Add               = nil
local m_ImageItem 			= nil
local iconid           	    = nil
local randomNum               = 2
local image_CountryBg         = nil
local m_labelTmoney           = nil
-- local m_labelmoney            = nil
local line                    = nil
local isClickCamp = false
local isClickIcon = false
local isClickAppCannel = false
local isRand = false
local m_ApplyText = nil
local btn_apply = nil
local btn_cancel = nil
local isapplycancenl = false
local ApplyCorpsInfoWidget = nil
local tableApplyData = {}
local tableApplyStatus = {}
local scheduleNum = 0
local schedulerEntry = nil
local nPageNum = 1
local istrue = false
local isrefresh = false
local isFirst = false

--本地测试

local createIDLayer  = TipLayer.createTimeLayer
local ShowChangedIconInfoLayer = CorpsChangeIconLayer.ShowChangedIconInfoLayer
local MakeHeadIcon	 = UIInterface.MakeHeadIcon
local ShowInfoSettingLayer = CorpsInfoSetLayer.ShowInfoSettingLayer
local getText       = LabelLayer.getText
local GetCorpsListData = CorpsData.GetCorpsListData
local GetCorpsOnlyID = CorpsData.GetCorpsOnlyID
local GetCorpsCountryID = CorpsData.GetCorpsCountryID
local GetCorpsName = CorpsData.GetCorpsName
local GetIconDataID = CorpsData.GetIconDataID
local CreateApplyList = CorpsApplyListLayer.CreateApplyList
local SortCorpsFromStatus = CorpsLogic.SortCorpsFromStatus
local SortCorpsFromLevel = CorpsLogic.SortCorpsFromLevel
local SortCorpsList = CorpsLogic.SortCorpsList
local GetIconByLegio = CorpsData.GetIconByLegio
--local GetIconDataID = CorpsData.GetIconDataID
local GetIconTableByFile = CorpsData.GetIconTableByFile
local getDataById = CorpsData.getDataById
local GetimsgDataTable = CorpsData.GetimsgDataTable
local GetSearchId = CorpsLogic.GetSearchId
local cleanListView = CorpsLogic.cleanListView
local CheckName = CorpsLogic.CheckName
local GetApplySet = CorpsLogic.GetApplySet
local SaveCorpsInfo = CorpsLogic.SaveCorpsInfo
local SaveCountryID = CorpsLogic.SaveCountryID
local GetAllCorpsData = CorpsData.GetAllCorpsData
local RequestRefreshView = CorpsLogic.RequestRefreshView
local CheckCountryPower = CorpsLogic.CheckCountryPower

local function initVars()
	m_CorpsPanel        	= nil
	m_BoxCorpsCreate    	= nil
	m_BoxCorpsAdd       	= nil
	m_BoxCorpsFind      	= nil
	m_InputCreateField 		= nil
	nCurrentType       		= nil
	m_InputNameTextField 	= nil
	m_InputIDTextField 		= nil
	m_ItemIcon         		= nil
	listCorpsInfoWidget 	= nil
	ListViewAddInfo    		= nil
	CorpsIconItem       	= nil
	Panel_Create 	   		= nil
	Panel_Find 				= nil
	m_BtnSearch           	= nil
	m_CorpsSearchID       	= nil
	listViewFindResult      = nil
	LableCorpsLevel         = nil
	m_LabelLevel            = nil
	m_countryID             = 2
	m_CorpsIconID           = 2
	randomNum               = 2
	m_CampFlagID            = 1
	m_ImageItem             = nil
	isClickCamp 			= false
	isClickIcon             = false
	iconid                  = nil
	Panel_Add               = nil
	scheduleNum 			= 0
	isClickAppCannel        = false
	isRand                  = false
	image_CountryBg         = nil
	m_labelTmoney           = nil
	-- m_labelmoney            = nil
	line                    = nil
	m_ApplyText             = nil
	btn_apply               = nil
	btn_cancel              = nil
	ApplyCorpsInfoWidget    = nil
	nPageNum                = 1
	isFirst                 = false
	isapplycancenl 			= false
	m_recomCountryID        = 1

end

local function Cleanlayer(  )
	m_CorpsPanel:setVisible(false)
	m_CorpsPanel:removeFromParentAndCleanup(true)
	m_CorpsPanel = nil
	
end

local function _Click_Return_CorpsLayer_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
	 	sender:setScale(1.0)
	 	--nPageNum = 1
		Cleanlayer()
		-- MainScene.PopUILayer()
	elseif eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function initStatus()
	m_BoxCorpsFind:setSelectedState(false)
	m_BoxCorpsAdd:setSelectedState(false)
	m_BoxCorpsCreate:setSelectedState(false)
	m_BoxCorpsFind:setZOrder(0)
	m_BoxCorpsAdd:setZOrder(0)
	m_BoxCorpsCreate:setZOrder(0)
	m_BoxCorpsFind:setTouchEnabled(true)
	m_BoxCorpsAdd:setTouchEnabled(true)
	m_BoxCorpsCreate:setTouchEnabled(true)


	if m_InputNameTextField ~= nil and m_InputIDTextField ~= nil then
		m_InputNameTextField:setVisible(false)
		m_InputNameTextField:setTouchEnabled(false)
		m_InputIDTextField:setVisible(false)
		m_InputIDTextField:setTouchEnabled(false)
	end
end

local function ResetClipType()
	local Image_Bg = tolua.cast(m_CorpsPanel:getWidgetByName("Image_Bg"),"ImageView")

	local Panel_Add = tolua.cast(m_CorpsPanel:getWidgetByName("Panel_Add"),"Layout")
	local pCorpsAddList = tolua.cast(Panel_Add:getChildByName("ListView_Add"),"ListView")
	if pCorpsAddList ~= nil then  pCorpsAddList:setClippingType(1) end
end

--军团图标返回回调
local function _Click_IconReturn_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()		
		m_ItemIcon:removeFromParentAndCleanup(true)
		m_ItemIcon = nil
	end
end

local function CreateIconItemWidget( pListViewIconTemp )
	local pListViewIcon = pListViewIconTemp:clone()
	local peer = tolua.getpeer(pListViewIconTemp)
	tolua.setpeer(pListViewIcon,peer)
	return pListViewIcon
end

function EnterCorpsScene(  )
	local function GetSuccessCallback(  )
		if CorpsScene.GetPScene() == nil then
			Cleanlayer()
			MainScene.SetCurParent(false)
			CorpsScene.CreateCorpsScene()
			NetWorkLoadingLayer.ClearLoading()
		else
			print("已经是军团场景了")
		end
	end
	Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
end

--军团图标点击响应该函数
local function _Click_SelectIcon_CallBack( sender,eventType )
    local pTag = tolua.cast(sender,"ImageView")
	if eventType == TouchEventType.ended then	
		AudioUtil.PlayBtnClick()	
		m_ItemIcon:removeFromParentAndCleanup(true)
		m_ItemIcon = nil
	end
end 

--军团图标响应函数
local function InitIconItemControl( pControl )
	pControl:addTouchEventListener(_Click_SelectIcon_CallBack)
end

-- --显示军团列表信息
local function listCorpsInfoIcon(ItemTab )

	local mCorpsId = ItemTab.id
	local m_contentInfo    = ItemTab.brief
	local CorpsNeedLevel = ItemTab.needLevel
	local CorpslimitType = ItemTab.limitType
	local ListCorps_Info  = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsInfoLayer.json")
	listCorpsInfoWidget   = CreateIconItemWidget(ListCorps_Info)
	CorpsIconItem   = tolua.cast(listCorpsInfoWidget:getChildByName("Image_Item"),"ImageView")	
	if isRand == true then
    	local itemid = resimg.getFieldByIdAndIndex(ItemTab.flag,"icon_path")
		CorpsIconItem:loadTexture(itemid)
	elseif isRand == false then
		local itemid = resimg.getFieldByIdAndIndex(ItemTab.flag,"icon_path")
		CorpsIconItem:loadTexture(itemid)
    end	
    
	local CorpsIconKuang   = tolua.cast(listCorpsInfoWidget:getChildByName("Image_Kuang"),"ImageView")
	local corpskuangBg = tolua.cast(listCorpsInfoWidget:getChildByName("Image_64"),"ImageView")
	corpskuangBg:setZOrder(-1)


	local CorpsBelongIcon = tolua.cast(listCorpsInfoWidget:getChildByName("Image_Belong"),"ImageView")
    
	local LabelCorpsName  = tolua.cast(listCorpsInfoWidget:getChildByName("Label_CorpsName"),"Label")
	local LabelCorpsNum 	 = tolua.cast(listCorpsInfoWidget:getChildByName("Label_CorpsMember"),"Label")
	LableCorpsLevel = tolua.cast(listCorpsInfoWidget:getChildByName("Label_Level"),"Label")
	local LabelCorps_Info = tolua.cast(listCorpsInfoWidget:getChildByName("Label_Info"),"Label")
	LabelCorps_Info:setText(m_contentInfo)
	LableCorpsLevel:setText(ItemTab.needLevel)
	local LabelNeedLevel = tolua.cast(listCorpsInfoWidget:getChildByName("Label_NeedLevel"),"Label")	
	LabelNeedLevel:setText("需要主将等级:")

	if ItemTab["cur_num"] == nil then
		ItemTab["cur_num"] = 1
	end
    
    local m_LabelCorpsNum = nil
	local m_LabelCorpsName  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, ItemTab.name, ccp(0, 0), COLOR_Black, ccc3(253,194,30), true, ccp(0, -3), 3)
	if ItemTab.people > 33 then
		m_LabelCorpsNum   = LabelLayer.createStrokeLabel(18, "微软雅黑",ItemTab["cur_num"].."/"..ItemTab.people, ccp(1, 0), COLOR_Black, ccc3(99,216,53), true, ccp(0, -2), 2)
	else
		m_LabelCorpsNum   = LabelLayer.createStrokeLabel(18, "微软雅黑", ItemTab["cur_num"].."/"..ItemTab.people, ccp(1, 0), COLOR_Black, ccc3(255,87,35), true, ccp(0, -2), 2)
	
	end
	
	local m_CorpsLevel = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, "lv." .. ItemTab.level, ccp(-10, -25), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	-- CorpsIconItem:addChild(m_CorpsLevel)
	CorpsIconKuang:addChild(m_CorpsLevel)
	
	local valueCountry = ItemTab.country
	if valueCountry > 3 then
		valueCountry = math.random(1,3)
		CorpsBelongIcon:loadTexture("Image/imgres/common/country/country_" .. valueCountry .. ".png")	
	else
		CorpsBelongIcon:loadTexture("Image/imgres/common/country/country_" .. valueCountry .. ".png")
	end
	LabelCorpsName:addChild(m_LabelCorpsName)
	LabelCorpsNum:addChild(m_LabelCorpsNum)

	m_ApplyText      = LabelLayer.createStrokeLabel(24, CommonData.g_FONT3, "", ccp(0, 2), ccc3(33,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)

	local tabItemStatus = {}
	tabItemStatus = GetAllCorpsData()
	if #tabItemStatus ~= nil then
				
		if GetSearchId(mCorpsId,tabItemStatus) == true then
			isapplycancenl = true
			LabelLayer.setText(m_ApplyText,"取消申请")
		else
			isapplycancenl = false
			LabelLayer.setText(m_ApplyText,"申请加入")
		end
	else
		LabelLayer.setText(m_ApplyText,"申请加入")
	end

	local function _Click_apply_CallBack( sender,eventType )

		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			-- local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
			local HeroLevel = tonumber(server_mainDB.getMainData("level"))
			local btn = tolua.cast(sender,"Button")
			local pTag = btn:getTag()
			local pCorpsTagID = tonumber(pTag)
			local m_BtnText = btn:getChildByTag(TAG_LABEL_BUTTON)
			local l_text = LabelLayer.getText(m_BtnText)
			if l_text == nil then
				l_text = "申请加入"
			end
			--[[if CorpslimitType == 2 then

				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1408,nil)
				pTips = nil
			else]]--
					if l_text == "申请加入"  then
						if HeroLevel >= CorpsNeedLevel then
						local function GetSuccessCallback(  )
							NetWorkLoadingLayer.loadingHideNow()
							LabelLayer.setText(m_BtnText,"取消申请")
							isapplycancenl = true
							if CorpslimitType == 1 then
								
								local pTips = TipCommonLayer.CreateTipLayerManager()
								pTips:ShowCommonTips(1407,nil)
								pTips = nil
								
							elseif CorpslimitType == 0 then

								local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
								if isCorps > 0 then
									local function GetSuccessCallback(  )
										NetWorkLoadingLayer.loadingHideNow()
										if CorpsScene.GetPScene() == nil then
											Cleanlayer()
											MainScene.SetCurParent(false)
											CorpsScene.CreateCorpsScene()
											-- NetWorkLoadingLayer.ClearLoading()
										else
											print("已经是军团场景了")
										end
									end
									Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
									network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
									NetWorkLoadingLayer.loadingShow(true)
								end
							end
							
						end
						Packet_CorpsApply.SetSuccessCallBack(GetSuccessCallback)
						network.NetWorkEvent(Packet_CorpsApply.CreatePacket(pCorpsTagID))
						NetWorkLoadingLayer.loadingShow(true)
						else
							local pTips = TipCommonLayer.CreateTipLayerManager()
							pTips:ShowCommonTips(1404,nil)
							pTips = nil
						end
					else
						local function GetSuccessCallback(  )
							NetWorkLoadingLayer.loadingHideNow()
							LabelLayer.setText(m_BtnText,"申请加入")
							isapplycancenl = false
						end				
						Packet_CorpsApplyCanncel.SetSuccessCallBack(GetSuccessCallback)
						network.NetWorkEvent(Packet_CorpsApplyCanncel.CreateStream(pCorpsTagID))
						NetWorkLoadingLayer.loadingShow(true)
							
					end
				
			--end
		end
	end


	local btn_apply = tolua.cast(listCorpsInfoWidget:getChildByName("Button_48"),"Button")
	btn_apply:setTouchEnabled(true)
	btn_apply:addChild(m_ApplyText,TAG_LABEL_BUTTON,TAG_LABEL_BUTTON)
	btn_apply:setTag(ItemTab.id)
	
	
	btn_apply:addTouchEventListener(_Click_apply_CallBack)

	--ListViewAddInfo:setItemsMargin(5)--设置item间的间距,为5像素

	if	nCurrentType == E_Corps_Type.E_Corps_Add then
		ListViewAddInfo:pushBackCustomItem(listCorpsInfoWidget)
		ListViewAddInfo:jumpToTop()
	elseif nCurrentType == E_Corps_Type.E_Corps_Find then
		listViewFindResult:pushBackCustomItem(listCorpsInfoWidget)
		listViewFindResult:jumpToTop()
	end

end

local function CircleCorpsList()	
	local corpsDatatid = nil
	local nYetCountryID = server_mainDB.getMainData("nCountry")
	local function GetSuccessCallback( )
		NetWorkLoadingLayer.loadingShow(false)
		local tableDataList = {}
		tableDataList = GetCorpsListData()
		--nPageNum = CorpsData.GetnPageNum()
		nTotalNum = CorpsData.GetnTotalNum()
		
		if nPageNum >= nTotalNum then
			nPageNum = nTotalNum
		end
		local Tempguild = {}
		local tabletemps = {}
		for key,value in pairs(tableDataList) do
			 listCorpsInfoIcon(value)
			
		end
		istrue = false
		isrefresh = false
	end

	Packet_CorpsFind.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsFind.CreatePacket(nPageNum))
	NetWorkLoadingLayer.loadingShow(true)
	
end

local function GetFindCorpsInfo(  )
	local tableDataList = GetCorpsListData()
	--nPageNum = CorpsData.GetnPageNum()
	nTotalNum = CorpsData.GetnTotalNum()
		
	if nPageNum >= nTotalNum then
		nPageNum = nTotalNum
	end
	local Tempguild = {}
	local tabletemps = {}
	for key,value in pairs(tableDataList) do
		listCorpsInfoIcon(value)
	end
	istrue = false
	isrefresh = false
end

local function GetApplyCorpsInfo()
	cleanListView(ListViewAddInfo)
	local function GetSuccessCall( )
		NetWorkLoadingLayer.loadingHideNow()
		local tableDataAp = {}
		tableDataAp = GetAllCorpsData()
		if #tableDataAp ~= 0 then
			for key,value in pairs(tableDataAp) do
				table.insert(tableApplyStatus,value)
				listCorpsInfoIcon(value)
			end
			CircleCorpsList()
		else
			CircleCorpsList()
		end
		istrue = false
		isrefresh = false
	end
	
	Packet_CorpsGetList.SetSuccessCallBack(GetSuccessCall)
	network.NetWorkEvent(Packet_CorpsGetList.CreatePacket(1,1))
	NetWorkLoadingLayer.loadingShow(true)
end

local function ShowCorpsByID()
	local searchCorpsID = nil
	local chooseNum = 1
	local strContent = m_InputIDTextField:getText()
	local strEditID = tonumber(strContent)
	if strEditID ~= nil then
		local function GetSuccessCallback( )
			NetWorkLoadingLayer.loadingHideNow()
			local tableData = CorpsData.GetCorpsOneInfo()
			m_BtnSearch:setVisible(false)
			m_BtnSearch:setTouchEnabled(false)
			m_CorpsSearchID:setVisible(false)
			m_InputIDTextField:setVisible(false)
			listViewFindResult:setVisible(true)
			listCorpsInfoIcon(tableData)
		end
		Packet_CorpsFindOne.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsFindOne.CreatePacket(1,strEditID))
		NetWorkLoadingLayer.loadingShow(true)
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1412,nil)
		pTips = nil
	end
	
end

--搜索军团ID的回调
local function _Click_Search_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then	
		AudioUtil.PlayBtnClick()		
		ShowCorpsByID()
	end	
end

--替换军团图标的回调
local function _Click_ReplaceItem_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local iconiid = 1	
		AddLabelImg(ShowChangedIconInfoLayer(iconiid),102,m_CorpsPanel)		
	end
end

--随机替换图标的回调
local function _Click_RandomReplaceItem_CallBack( sender,eventType )	
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		randomNum = math.random(1,35)
		local itemIndex = legioicon.getFieldByIdAndIndex(randomNum,"iconid")
		m_CorpsIconID = itemIndex
		local itemid = resimg.getFieldByIdAndIndex(itemIndex,"icon_path")
		m_ImageItem:loadTexture(itemid)
		isRand = false
	end
end

--创建军团的回调函数
local function _Click_CreateCorps_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local function EnterCorpsCallBack(  )
			if CorpsScene.GetPScene() == nil then
				Cleanlayer()
				MainScene.SetCurParent(false)
				CorpsScene.CreateCorpsScene()
				NetWorkLoadingLayer.ClearLoading()
			else
				print("已经是军团场景了")
			end
		end
		local strEdit = m_InputNameTextField:getText()
		CorpsLogic.CreateCorpsCallBack(strEdit,m_CorpsIconID,m_countryID,EnterCorpsCallBack)
	end
end

--改变军团图标
function ChangedIconItem(pTag)
	m_CorpsIconID = pTag
	local itemid = resimg.getFieldByIdAndIndex(m_CorpsIconID,"icon_path")
	m_ImageItem:loadTexture(itemid)
	isRand = true
	return m_CorpsIconID
end

function ChangeCorpsIcon(  )
	local id = CorpsLogic.ChangeIcon()
end

local function _Click_ListView_CallBack( sender,eventType )
	if eventType == LISTVIEW_ONSELECTEDITEM_START then

	elseif eventType == LISTVIEW_ONSELECTEDITEM_END then
		AudioUtil.PlayBtnClick()
		if isrefresh == true then
			if nPageNum == 1 then
				GetApplyCorpsInfo()
			else
			 	CircleCorpsList()
		 	end
			
			isrefresh = false
			istrue = false
			scheduleNum = 0
		end
	end
end

local function requestCallBAck( sender,eventType )
	if eventType == SCROLLVIEW_EVENT_SCROLL_TO_TOP then
		if istrue == false then
			scheduleNum = scheduleNum + 1
			if scheduleNum == 10 then
				scheduleNum = 0
				
				if nPageNum <= 1 then
					nPageNum = 1
				else
					nPageNum = nPageNum - 1
					--istrue = true
					--isrefresh = true
				end
			end
		
		end
	elseif eventType == SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM then
		AudioUtil.PlayBtnClick()
		if istrue == false then
			scheduleNum = scheduleNum + 1
			if scheduleNum == 10 then
				scheduleNum = 0				
				
				if nPageNum >= nTotalNum then
					nPageNum = nTotalNum
				else
					nPageNum = nPageNum + 1 
					istrue = true
					isrefresh = true
				end
				
			end
		
		end
	end

end

--创建军团时的界面
local function initCorpsPanelStatus(nCurrentType)	
	--创建军团时的UI
	local Image_Bg = tolua.cast(m_CorpsPanel:getWidgetByName("Image_Bg"),"ImageView")
	Panel_Add = tolua.cast(m_CorpsPanel:getWidgetByName("Panel_Add"),"Layout")
	Panel_Create = tolua.cast(m_CorpsPanel:getWidgetByName("Panel_Create"),"Layout")
	Panel_Find = tolua.cast(m_CorpsPanel:getWidgetByName("Panel_Find"),"Layout")

    local m_BtnItem = tolua.cast(Panel_Create:getChildByName("Button_Alter"),"Button")--选择图标
    local m_BtnRand = tolua.cast(Panel_Create:getChildByName("Button_Random"),"Button")
    local image_kuangBG = tolua.cast(Panel_Create:getChildByName("Image_67"),"ImageView")
    image_kuangBG:setZOrder(-1)

    --图标
    m_ImageItem = tolua.cast(Panel_Create:getChildByName("Image_Item"),"ImageView")

    local m_BtnAddGuild = tolua.cast(Panel_Create:getChildByName("Button_AddGuid"),"Button")
    m_BtnSearch = tolua.cast(Panel_Find:getChildByName("Button_Find"),"Button")
    m_CorpsSearchID = tolua.cast(Panel_Find:getChildByName("Label_CorpsID"),"Label")
    listViewFindResult = tolua.cast(Panel_Find:getChildByName("ListView_FindResult"),"ListView")

    local m_CorpsName = tolua.cast(Panel_Create:getChildByName("Label_CorpsName"),"Label")
    local m_CorpsIcon = tolua.cast(Panel_Create:getChildByName("Label_CorpsIcon"),"Label")
    local m_CorpsCreateCost = tolua.cast(Panel_Create:getChildByName("Label_Cost"),"Label")
    m_CorpsName:setText("军团名称：")
    m_CorpsIcon:setText("军团图标：")
    m_CorpsSearchID:setText("军团ID:")
    -- m_CorpsCreateCost:setText("创建花费：")
    --取自全局定义表里面的消耗类型，数量
    local corpsMoney = CorpsData.GetCorpsCamp()
    local tabExpendData = ConsumeLogic.GetExpendData(corpsMoney[1])
	local imgPath = tabExpendData.TabData[1]["IconPath"]
	
    m_labelTmoney = tolua.cast(Panel_Create:getChildByName("Label_Money"),"Label")
    local corpsMoneyType = tolua.cast(Panel_Create:getChildByName("Image_Money"),"ImageView")
    corpsMoneyType:loadTexture(imgPath)

    local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(corpsMoneyType,tabExpendData.TabData[1]["ConsumeType"],GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN)
	pGuideManager = nil

    local m_TmoneyText        = LabelLayer.createStrokeLabel(24, "微软雅黑", tabExpendData.TabData[1]["ItemNeedNum"], ccp(1, 0), ccc3(83,28,2), ccc3(99,216,53), true, ccp(0, -2), 2)
    
    m_labelTmoney:addChild(m_TmoneyText)
    line = AddLine(ccp(-35,0),ccp(35,0), ccc3(255,0,0),1,255)
    	
    local CorpsTitleName = tolua.cast(Image_Bg:getChildByName("Label_Name"),"Label")
    local m_CorpsTitleNameText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "军团", ccp(1, 0), ccc3(126,14,12), ccc3(255,235,151), true, ccp(0, -2), 2)
    CorpsTitleName:addChild(m_CorpsTitleNameText)

	---显示军旗
	local country_id = server_mainDB.getMainData("nCountry")
	local image_flag = tolua.cast(Panel_Create:getChildByName("Image_53"),"ImageView")
	CorpsLogic.GetAnimationByCountryID(image_flag)

    local strTab = CorpsData.GetCorpsListData()
   
    ListViewAddInfo = tolua.cast(Panel_Add:getChildByName("ListView_Add"),"ListView")
    if ListViewAddInfo ~= nil then ListViewAddInfo:setClippingType(1) end

    if isRand == true then
    	local itemid = resimg.getFieldByIdAndIndex(m_CorpsIconID,"icon_path")
		m_ImageItem:loadTexture(itemid)
	elseif isRand == false then
		local itemid = resimg.getFieldByIdAndIndex(m_CorpsIconID,"icon_path")
		m_ImageItem:loadTexture(itemid)
    end	
	
    local m_CreateText        = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "创建军团", ccp(1, 0), COLOR_Black, ccc3(255,255,255), true, ccp(0, -2), 2)
    local m_SearchText        = LabelLayer.createStrokeLabel(20, CommonData.g_FONT3, "查找", ccp(1, 3), ccc3(33,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)   
    local m_CorpsIDText       = LabelLayer.createStrokeLabel(40, CommonData.g_FONT1, "军团ID:", ccp(1, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)

	Panel_Add:setVisible(false)
	Panel_Add:setTouchEnabled(false)
	Panel_Add:setZOrder(2)
	Panel_Create:setVisible(false)
	Panel_Create:setTouchEnabled(false)
	Panel_Create:setZOrder(2)
	Panel_Find:setVisible(false)
	Panel_Find:setTouchEnabled(false)
	Panel_Find:setZOrder(2)
	m_BtnItem:setVisible(false)
	m_BtnItem:setTouchEnabled(false)
	m_BtnItem:setZOrder(2)
	m_BtnAddGuild:setVisible(false)
	m_BtnAddGuild:setTouchEnabled(false)
	m_BtnAddGuild:setZOrder(2)
	m_BtnSearch:setVisible(false)
	m_BtnSearch:setTouchEnabled(false)
	m_BtnSearch:setZOrder(2)
	m_ImageItem:setVisible(false)
	m_ImageItem:setTouchEnabled(false)
	m_ImageItem:setZOrder(2)
	

	listViewFindResult:setVisible(false)       
	

    m_BtnAddGuild:addChild(m_CreateText) 
    m_BtnSearch:addChild(m_SearchText)  

    if nCurrentType == E_Corps_Type.E_Corps_Add then
    	nPageNum = 1
    	tableApplyStatus = {}
    	Panel_Add:setVisible(true)
    	Panel_Add:setTouchEnabled(true)
    	Panel_Add:setZOrder(5)   
    	ListViewAddInfo:setTouchEnabled(true)
    	ListViewAddInfo:addEventListenerScrollView(requestCallBAck)
    	ListViewAddInfo:addEventListenerListView(_Click_ListView_CallBack)
    	line:removeFromParentAndCleanup(false)
    	GetApplyCorpsInfo()
    elseif nCurrentType == E_Corps_Type.E_Corps_Find then
    	Panel_Find:setVisible(true)
    	Panel_Find:setTouchEnabled(true)
    	Panel_Find:setZOrder(5)
    	m_CorpsSearchID:setVisible(true)
    	m_BtnSearch:setVisible(true)
    	m_BtnSearch:setTouchEnabled(true)
    	m_BtnSearch:setZOrder(5)
    	line:removeFromParentAndCleanup(false)
        m_BtnSearch:addTouchEventListener(_Click_Search_CallBack)
    	cleanListView(ListViewAddInfo)
    elseif nCurrentType == E_Corps_Type.E_Corps_Create then
    	Panel_Create:setVisible(true)
    	Panel_Create:setTouchEnabled(true)
    	Panel_Create:setZOrder(5)
    	m_BtnItem:setVisible(true)
		m_BtnItem:setTouchEnabled(true)
		m_BtnItem:setZOrder(5)
		m_BtnAddGuild:setVisible(true)
		m_BtnAddGuild:setTouchEnabled(true)
		m_BtnAddGuild:setZOrder(5)		
		m_ImageItem:setVisible(true)
		m_ImageItem:setTouchEnabled(true)
		m_ImageItem:setZOrder(5)
        m_BtnAddGuild:addTouchEventListener(_Click_CreateCorps_CallBack)
        m_ImageItem:addTouchEventListener(_Click_ReplaceItem_CallBack)
        m_BtnRand:addTouchEventListener(_Click_RandomReplaceItem_CallBack)
        line:removeFromParentAndCleanup(false)
        -- m_labelmoney:addNode(line,1000,1000)
    	cleanListView(ListViewAddInfo)
    end
    cleanListView(listViewFindResult)
    ResetClipType()

end

--CheckBox的状态
local function CheckBoxStatus( nCurrentIndex )
	initStatus()
	if nCurrentIndex == E_Corps_Type.E_Corps_Add then
		--显示添加军团界面
		AudioUtil.PlayBtnClick()
		m_BoxCorpsAdd:setSelectedState(true)
		m_BoxCorpsAdd:setZOrder(2)
		m_InputNameTextField:setVisible(false)
		m_InputNameTextField:setTouchEnabled(false)
		m_InputIDTextField:setVisible(false)
		m_InputIDTextField:setTouchEnabled(false)		
		
	elseif nCurrentIndex == E_Corps_Type.E_Corps_Find then
		--显示搜索军团界面
		AudioUtil.PlayBtnClick()
		m_BoxCorpsFind:setSelectedState(true)
		m_BoxCorpsFind:setZOrder(2)
 		m_InputNameTextField:setVisible(false)
		m_InputNameTextField:setTouchEnabled(false)
		m_InputIDTextField:setVisible(true)
		m_InputIDTextField:setTouchEnabled(true)
		m_InputIDTextField:setText("")						
	elseif nCurrentIndex == E_Corps_Type.E_Corps_Create then
		--显示创建军团界面
		AudioUtil.PlayBtnClick()
		m_BoxCorpsCreate:setSelectedState(true)
		m_BoxCorpsCreate:setZOrder(2)
		m_InputNameTextField:setVisible(true)
		m_InputNameTextField:setTouchEnabled(true)
		m_InputNameTextField:setText("")
		m_InputIDTextField:setVisible(false)
		m_InputIDTextField:setTouchEnabled(false)
		isClickCamp = false
	end
    nCurrentType = nCurrentIndex
    initCorpsPanelStatus(nCurrentIndex)
end

function upDataCorpsImage()
	initCorpsPanelStatus(E_Corps_Type.E_Corps_Create)
end

local function _Click_CheckBox_CallBack( sender,eventType )
	AudioUtil.PlayBtnClick()
	local CorpsType_Sender = tolua.cast(sender,"CheckBox")
	CheckBoxStatus(CorpsType_Sender:getTag()) 
end

local function initCorpsWidgets( nCurrentType )
	--checkBox的创建
	m_BoxCorpsAdd = tolua.cast(m_CorpsPanel:getWidgetByName("CheckBox_Add"),"CheckBox")
	m_BoxCorpsFind = tolua.cast(m_CorpsPanel:getWidgetByName("CheckBox_Find"),"CheckBox")
	m_BoxCorpsCreate = tolua.cast(m_CorpsPanel:getWidgetByName("CheckBox_Create"),"CheckBox")

	m_BoxCorpsAdd:setTag(E_Corps_Type.E_Corps_Add)
	m_BoxCorpsFind:setTag(E_Corps_Type.E_Corps_Find)
	m_BoxCorpsCreate:setTag(E_Corps_Type.E_Corps_Create)

	local pAddText = Label:create()
	pAddText:setFontSize(30)
	pAddText:setColor(ccc3(127,55,35))
	pAddText:setFontName(CommonData.g_FONT1)
	pAddText:setText("加入军团")

	local pFindText = Label:create()
	pFindText:setFontSize(30)
	pFindText:setColor(ccc3(127,55,35))
	pFindText:setFontName(CommonData.g_FONT1)
	pFindText:setText("查找军团")

	local pCreateText = Label:create()
	pCreateText:setFontSize(30)
	pCreateText:setColor(ccc3(127,55,35))
	pCreateText:setFontName(CommonData.g_FONT1)
	pCreateText:setText("创建军团")


    m_BoxCorpsAdd:addChild(pAddText)
    m_BoxCorpsFind:addChild(pFindText)
    m_BoxCorpsCreate:addChild(pCreateText)

    m_BoxCorpsAdd:addEventListenerCheckBox(_Click_CheckBox_CallBack)
    m_BoxCorpsFind:addEventListenerCheckBox(_Click_CheckBox_CallBack)
    m_BoxCorpsCreate:addEventListenerCheckBox(_Click_CheckBox_CallBack)

    --initCorpsPanelStatus(nCurrentType)

end

--初始化输入框
local function initEditbox()
   	local nTopNum = 0
   	local edit = nil
   	local function editBoxTextEventHandle( strEventName,pSender )
   		edit = tolua.cast(pSender,"CCEditBox")
   		if strEventName == "began" then
   			
   		elseif strEventName == "ended" then
   			
   			if edit == m_InputNameTextField then
   				nTopNum = 30
   			elseif edit == m_InputIDTextField then
   				nTopNum = 30
   			end
   		elseif strEventName == "canceled" then
   			
   		elseif strEventName == "changed" then
   			
   		end
   	end
  	-- m_pChatFaceLayer:removeFromParentAndCleanup(false)	
  
	--创建军团名字输入框
	m_InputNameTextField = CCEditBox:create(CCSizeMake(250,45),CCScale9Sprite:create("Image/imgres/corps/Input.png"))--420
	m_InputNameTextField:setPosition(ccp(760,370))
	m_InputNameTextField:setMaxLength(30)
	m_InputNameTextField:setPlaceHolder("输入创建军团名称")
	m_InputNameTextField:setPlaceholderFontColor(ccc3(233,180,114))
	m_InputNameTextField:setPlaceholderFontSize(24)
	m_InputNameTextField:setFontColor(ccc3(233,180,114))
	m_InputNameTextField:setFontSize(24)
	m_InputNameTextField:setReturnType(kKeyboardReturnTypeDone)
	m_InputNameTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputNameTextField:setInputMode(kEditBoxInputModeSingleLine)
	m_InputNameTextField:registerScriptEditBoxHandler(editBoxTextEventHandle)
	m_InputNameTextField:setTouchPriority(0)	
	m_InputNameTextField:setFontName(CommonData.g_FONT3)
	if m_CorpsPanel:getChildByTag(200)~=nil then
		m_CorpsPanel:getChildByTag(200):setVisible(false)
		m_CorpsPanel:getChildByTag(200):removeFromParentAndCleanup(true)
	end	
	m_CorpsPanel:addChild(m_InputNameTextField,0,200)

	--搜索军团ID输入框
	m_InputIDTextField = CCEditBox:create(CCSizeMake(300,45),CCScale9Sprite:create("Image/imgres/corps/Input.png"))--370
	m_InputIDTextField:setPosition(ccp(580,300))
	m_InputIDTextField:setMaxLength(30)
	m_InputIDTextField:setPlaceHolder("输入搜索军团ID")
	m_InputIDTextField:setPlaceholderFontColor(ccc3(233,180,114))
	m_InputIDTextField:setPlaceholderFontSize(24)
	m_InputIDTextField:setFontColor(ccc3(233,180,114))
	m_InputIDTextField:setFontSize(24)
	m_InputIDTextField:setReturnType(kKeyboardReturnTypeDone)
	m_InputIDTextField:setInputFlag(kEditBoxInputFlagInitialCapsWord)
	m_InputIDTextField:setInputMode(kEditBoxInputModeSingleLine)

	m_InputIDTextField:registerScriptEditBoxHandler(editBoxTextEventHandle)
	m_InputIDTextField:setTouchPriority(0)
	m_InputIDTextField:setFontName(CommonData.g_FONT3)
	if m_CorpsPanel:getChildByTag(201)~=nil then
		m_CorpsPanel:getChildByTag(201):setVisible(false)
		m_CorpsPanel:getChildByTag(201):removeFromParentAndCleanup(true)
	end	
	m_CorpsPanel:addChild(m_InputIDTextField,0,201)

end

function GetCorpsLayer(  )
	return m_CorpsPanel
end

function CreateCorpsLayer(nIndex)
	initVars()

	m_CorpsPanel = TouchGroup:create()
	m_CorpsPanel:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CreateCorpsLayer.json"))
	
	--根据传进来的nIndex来决定当前打开哪个类型的页面
    local pBoxCurrent_Type = nIndex
    nCurrentType = pBoxCurrent_Type
    --初始化页面
	initCorpsWidgets(pBoxCurrent_Type)
	--初始化军团输入框
	initEditbox()

    --检测当前军团类型	
    CheckBoxStatus(pBoxCurrent_Type)

	local m_pButton = tolua.cast(m_CorpsPanel:getWidgetByName("Button_Return"),"Button")
	m_pButton:addTouchEventListener(_Click_Return_CorpsLayer_CallBack)
	
	-- CircleCorpsList()
	return m_CorpsPanel
end