--FileName:CorpsCoceralLayer
--Author:xuechao
--Purpose:商会界面
module("CorpsCoceralLayer",package.seeall)
require "Script/Main/Corps/CorpsFunctionTipLayer"

local m_CorpsCoceralLayer = nil
local m_ListViewItem = nil
local m_CorpsItemIcon = nil

local CreateStrokeLabel 			= LabelLayer.createStrokeLabel


local function initData(  )
	m_CorpsCoceralLayer = nil
	m_ListViewItem      = nil
	m_CorpsItemIcon     = nil

end

local function AddInfoWidget( pListViewTemp )
	local pListViewMemberInfo = pListViewTemp:clone()
	local peer = tolua.getpeer(pListViewTemp)
	tolua.setpeer(pListViewMemberInfo,peer)
	return pListViewMemberInfo
end

local function _Click_ShanghuiReturn_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		m_CorpsCoceralLayer:setVisible(false)
		m_CorpsCoceralLayer:removeFromParentAndCleanup(true)
		m_CorpsCoceralLayer = nil
	end
end

local function Click_Refresh_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
	end
end

local function _Click_AddGoods_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
	end
end
--左按钮
local function _Click_Left_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
	end
end
--右边按钮
local function _Click_Right_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
	end
end

local function _Click_Item_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		CorpsFunctionTipLayer.CreateBuyThingLayer()
	end
end

local function InitShopControl( pControl )
	local label_name = tolua.cast(pControl:getChildByName("Label_name"),"Label")
	local label_num = tolua.cast(pControl:getChildByName("Label_num"),"Label")
	local label_money = tolua.cast(pControl:getChildByName("Label_money"),"Label")
	local img_icon = tolua.cast(pControl:getChildByName("Image_25"),"ImageView")
end

local function initItemControl( pControl )
	pControl:addTouchEventListener(_Click_Item_CallBack)
	InitShopControl(pControl)
end

local function InitWidgetControl(  )
	if m_CorpsItemIcon == nil then
	    m_CorpsItemIcon = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsShanghui_Item.json")
	end
	m_CorpsWidgetItem = AddInfoWidget(m_CorpsItemIcon)
	local image_shopItem1 = tolua.cast(m_CorpsWidgetItem:getChildByName("Image_ShopItem1"),"ImageView")
	local image_shopItem2 = tolua.cast(m_CorpsWidgetItem:getChildByName("Image_ShopItem1_0"),"ImageView")
	image_shopItem2:setTouchEnabled(true)
	image_shopItem1:setTouchEnabled(true)

	initItemControl(image_shopItem1)
	initItemControl(image_shopItem2)

	m_ListViewItem:pushBackCustomItem(m_CorpsWidgetItem)
    m_ListViewItem:jumpToLeft()
end

local function initWidget(  )

	--按钮
	local btn_return = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_ShanghuiReturn_CallBack)

	local btn_refresh = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Button_refresh"),"Button")
	btn_refresh:addTouchEventListener(Click_Refresh_CallBack)

	local pLabel_name = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Label_CorpsShanghui"),"Label")
	local labelNameText = CreateStrokeLabel(36, CommonData.g_FONT1, "军团商会", ccp(0, 0), ccc3(108, 22, 20), ccc3(255, 235, 154), true, ccp(0, -2), 2)
	pLabel_name:addChild(labelNameText)

	local pImgrefresh = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Image_refresh"),"ImageView")
	local pLrefreshText =  CreateStrokeLabel(20, CommonData.g_FONT1, "刷新", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	pImgrefresh:addChild(pLrefreshText)

	local btn_add = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Button_shangjia"),"Button")
	local btnAddText = CreateStrokeLabel(36, CommonData.g_FONT1, "上架物品", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	btn_add:addChild(btnAddText)
	btn_add:addTouchEventListener(_Click_AddGoods_CallBack)

	-------------------------------------------------左右按钮-------------------------------------------------------------------------------------
	local btn_left = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Button_left"),"Button")
	local btn_right = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Button_right"),"Button")

	btn_left:addTouchEventListener(_Click_Left_CallBack)
	btn_right:addTouchEventListener(_Click_Right_CallBack)

	local label_words = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("Label_word"),"Label")
	label_words:setText("碎片")



	m_ListViewItem = tolua.cast(m_CorpsCoceralLayer:getWidgetByName("ListView_item"),"ListView")
	m_ListViewItem:setClippingType(1)

	InitWidgetControl()

end

function ShowCorpsCoceralLayer(  )
	initData()
	m_CorpsCoceralLayer = TouchGroup:create()
	m_CorpsCoceralLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsShanghuiLayer.json"))

	initWidget()

	return m_CorpsCoceralLayer
end