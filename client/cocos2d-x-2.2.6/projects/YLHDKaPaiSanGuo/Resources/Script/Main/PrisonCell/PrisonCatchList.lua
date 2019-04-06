module("PrisonCatchList",package.seeall)
require "Script/Main/Corps/CorpsContentData"
require "Script/Main/PrisonCell/PrisonCellList"
local GetCatchListDB = PrisonCellData.GetCatchListDB
local SortPartByTime = CorpsContentData.SortPartByTime
local m_ListInnerHeight = 0
local m_PrisonListLayer = nil
local m_CatchList       = nil
local pItemWidget   = nil

local IMG_PATH_TITLE = "Image/imgres/equip/title_bg.png"
local IMG_PATH_LINE = "Image/imgres/equip/line_bg.png"

local function init(  )
	m_PrisonListLayer = nil
	m_CatchList       = nil
end

local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		m_PrisonListLayer:setVisible(false)
		m_PrisonListLayer:removeFromParentAndCleanup(true)
		m_PrisonListLayer = nil
	end
end

local function CreateItemWidget( pItemTemp )
    local pItem = pItemTemp:clone()
    local peer = tolua.getpeer(pItemTemp)
    tolua.setpeer(pItem, peer)
    return pItem
end

local function ShowCatchInfo()
	local tableCatchData = GetCatchListDB()
	local tabNum = #tableCatchData

	local sortTab = SortPartByTime(tableCatchData)

	for key,value in pairs(sortTab) do
		local m_PrisonItemManger = PrisonCellList.CreateManger()
		m_PrisonItemManger:ShowPrisonItem(value)
		m_CatchList:pushBackCustomItem(m_PrisonItemManger:GetItem())
	end
end

local function initWidget(  )
	local img_name = tolua.cast(m_PrisonListLayer:getWidgetByName("Image_4"),"ImageView")
	local labelTitleText = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "抓捕记录", ccp(0, 0), ccc3(83,28,2), ccc3(255,194,30), true, ccp(0, -2), 2)
	img_name:addChild(labelTitleText)

	m_CatchList = tolua.cast(m_PrisonListLayer:getWidgetByName("ListView_item"),"ListView")
	m_CatchList:setClippingType(1)

	ShowCatchInfo()
end

function loadPrisonListLayer(  )
	init()
	if m_PrisonListLayer == nil then
		m_PrisonListLayer = TouchGroup:create()									-- 背景层
		m_PrisonListLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/PrisonCatchList.json"))
	end


	local btn_return = tolua.cast(m_PrisonListLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_return_CallBack)

	initWidget()
	return m_PrisonListLayer
end