--FileName:CorpsDynamicLayer
--Author:xuechao
--Purpose:军团动态
require "Script/Common/RichLabel"
module("CorpsDynamicLayer",package.seeall)

local m_CorpsDynamicLayer = nil
local listCorpsDynamic    = nil
local m_scrollView_Dynamic  = nil
local pItemWidget     = nil
local m_ListInnerHeight = 0
local IMG_PATH_TITLE = "Image/imgres/equip/title_bg.png"
local IMG_PATH_LINE = "Image/imgres/equip/line_bg.png"

local CreateCommonInfoWidget = CorpsLogic.CreateCommonInfoWidget
local GetCorpsDynamicInfo = CorpsData.GetCorpsDynamicInfo

local function initData(  )
	m_CorpsDynamicLayer = nil
	listCorpsDynamic    = nil
	m_scrollView_Dynamic  = nil
end

local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		m_CorpsDynamicLayer:setVisible(false)
		m_CorpsDynamicLayer:removeFromParentAndCleanup(true)
		m_CorpsDynamicLayer = nil
	end
end

local function CreateItemWidget( pItemTemp )
    local pItem = pItemTemp:clone()
    local peer = tolua.getpeer(pItemTemp)
    tolua.setpeer(pItem, peer)
    return pItem
end

local function addTitleWord(  )
	local img_time = ImageView:create()
	img_time:loadTexture(IMG_PATH_TITLE)
	img_time:setScale9Enabled(true)
	img_time:setSize(CCSize(300,40))
	img_time:setPosition(ccp(350,775))
	AddLabelImg(img_time,101,m_scrollView_Dynamic)

	local nTimeDB = os.date("*t")
	local labelTimeText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, nTimeDB.month.."月"..nTimeDB.day.."日", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	AddLabelImg(labelTimeText,101,img_time)
	
end

local function loadItemInfo( value)
	local pItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsDynamicItem.json")
	pItemWidget = CreateItemWidget(pItemTemp)
	if next(value) ~= nil then
			local nTimeDB = os.date("*t",value.time)
			if tonumber(nTimeDB.min) < 10 then
				nTimeDB.min = "0"..nTimeDB.min
			end
			local nTimeStr = nTimeDB.hour..":"..nTimeDB.min
			color = "|color|51,22,5||size|20|"
			-- loadItemInfo(key,value)nMessText
			local nMessText = "加入军团"
			if tonumber(value["eventID"]) == 1 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."加入军团"
			elseif tonumber(value["eventID"]) == 2 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."  ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."退出军团"
			elseif tonumber(value["eventID"]) == 3 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."  ".."      ".."|color|53,25,13||size|20|".."军团升级"
			elseif tonumber(value["eventID"]) == 4 then
				if tonumber(value["eventParam1"]) == 1 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被任命为副将"
				elseif tonumber(value["eventParam1"]) == 2 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被任命为护法"
				elseif tonumber(value["eventParam1"]) == 3 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被任命为圣女"
				elseif tonumber(value["eventParam1"]) == 4 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被撤为帮众"
				end
				
			elseif tonumber(value["eventID"]) == 5 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被罢免军团职位"
			elseif tonumber(value["eventID"]) == 6 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."捐献了军团贡献".." ".."|color|53,25,13||size|20|"..value["eventParam1"]
			else
				nMessText = ""
			end

			local messContentItem = RichLabel.Create(nMessText,400,nil,nil,1)
			messContentItem:setPosition(ccp(0,-10))
			pItemWidget:addChild(messContentItem)

			m_ListInnerHeight = m_ListInnerHeight + (messContentItem:getContentSize().height + 5)
    		-- listCorpsDynamic:setInnerContainerSize(CCSizeMake(listCorpsDynamic:getInnerContainerSize().width,m_ListInnerHeight))
			listCorpsDynamic:jumpToBottom()
			-- listCorpsDynamic:setItemsMargin(10)
			listCorpsDynamic:pushBackCustomItem(pItemWidget)
	end
end

local function ShowCorpsDynamicInfo()
	local function GetSuccessCall()
		NetWorkLoadingLayer.loadingHideNow()
		local tableDynamicData = GetCorpsDynamicInfo()
		local tabNum = #tableDynamicData

		if next(tableDynamicData) ~= nil then

			local img_time = ImageView:create()
			img_time:loadTexture(IMG_PATH_TITLE)
			img_time:setPosition(ccp(200,-20))
			local cur_TimeDB = os.date("*t")
				
			local labelTimeText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, cur_TimeDB["month"].."月"..cur_TimeDB["day"].."日", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
			AddLabelImg(labelTimeText,101,img_time)

			local layout = Layout:create()
			layout:setTouchEnabled(false)
			layout:addChild(img_time)
			listCorpsDynamic:addChild(layout)
		end
		
		for key,value in pairs(tableDynamicData) do
			loadItemInfo(value)
			--[[if next(value) ~= nil then
			local nTimeDB = os.date("*t",value.time)
			if tonumber(nTimeDB.min) < 10 then
				nTimeDB.min = "0"..nTimeDB.min
			end
			local nTimeStr = nTimeDB.hour..":"..nTimeDB.min
			color = "|color|51,22,5||size|20|"
			-- loadItemInfo(key,value)nMessText
			local nMessText = "加入军团"
			if tonumber(value["eventID"]) == 1 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."加入军团"
			elseif tonumber(value["eventID"]) == 2 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."退出军团"
			elseif tonumber(value["eventID"]) == 3 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."      ".."|color|53,25,13||size|20|".."军团升级"
			elseif tonumber(value["eventID"]) == 4 then
				if tonumber(value["eventParam1"]) == 1 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被任命为副将"
				elseif tonumber(value["eventParam1"]) == 2 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被任命为护法"
				elseif tonumber(value["eventParam1"]) == 3 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被任命为圣女"
				elseif tonumber(value["eventParam1"]) == 4 then
					nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被撤为帮众"
				end
				
			elseif tonumber(value["eventID"]) == 5 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."      ".."|color|53,25,13||size|20|".."被罢免军团职位"
			elseif tonumber(value["eventID"]) == 6 then
				nMessText = "|color|253,235,200||size|20|"..nTimeStr.."    ".."|color|255,234,19||size|20|"..value["playerName"].."捐献了".."      ".."|color|53,25,13||size|20|"..value["eventParam1"]
			else
				nMessText = ""
			end

			local messContentItem = RichLabel.Create(nMessText,400,nil,nil,1.5)
			-- messContentItem:setPosition(ccp(-100,-100))

			local layout1 = Layout:create()
			layout1:setTouchEnabled(false)
			layout1:addChild(messContentItem)
			listCorpsDynamic:addChild(layout1)
			-- listCorpsDynamic:addChild(messContentItem)

			m_ListInnerHeight = m_ListInnerHeight + (messContentItem:getContentSize().height + 5)
    		listCorpsDynamic:setInnerContainerSize(CCSizeMake(listCorpsDynamic:getInnerContainerSize().width,m_ListInnerHeight))
			listCorpsDynamic:jumpToBottom()
			listCorpsDynamic:setItemsMargin(50)
			end]]--
		end
		
	end
	Packet_CorpsDynamic.SetSuccessCallBack(GetSuccessCall)
	network.NetWorkEvent(Packet_CorpsDynamic.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)
end

local function initWidget(  )
	local label_title = tolua.cast(m_CorpsDynamicLayer:getWidgetByName("Label_title"),"Label")
	local labelTitleText = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "军团动态", ccp(0, 0), ccc3(83,28,2), ccc3(255,194,30), true, ccp(0, -2), 2)
	label_title:addChild(labelTitleText)

	--m_scrollView_Dynamic = tolua.cast(m_CorpsDynamicLayer:getWidgetByName("ScrollView_Dynamic"),"ScrollView")
	--m_scrollView_Dynamic:setClippingType(1)

	listCorpsDynamic = tolua.cast(m_CorpsDynamicLayer:getWidgetByName("ListView_Dynamic"),"ListView")
	listCorpsDynamic:setClippingType(1)
	addTitleWord()

	ShowCorpsDynamicInfo()
	
end

function showDynamicLayer()
	initData()

	m_CorpsDynamicLayer = TouchGroup:create()									-- 背景层
	m_CorpsDynamicLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsDynamic.json"))

	local btn_return = tolua.cast(m_CorpsDynamicLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_return_CallBack)

	initWidget()

	return m_CorpsDynamicLayer
end