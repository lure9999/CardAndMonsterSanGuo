require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Main/Corps/CorpsShop/CorpsShopData"
require "Script/Main/Corps/CorpsShop/CorpsShopLogic"
require "Script/Main/Corps/CorpsShop/CorpsShopTipLayer"

module("CorpsShopLayer", package.seeall)

local SINGLROWITEMCOUNT = 2
local COUNTPERPAGE = 8

local m_nShopId = nil
local m_nLeftRefreshCount = nil

local m_pCorpsShop = nil
local m_lvShopItem = nil
local m_btnReturn = nil
local m_btnRefresh = nil
local m_plbShopName = nil
local m_pimgTalk = nil
local m_tab_NeedUpdate  = nil --celina add 记录要更新的img

local CreateStrokeLabel 			= LabelLayer.createStrokeLabel
local SetStrokeLabelText			= LabelLayer.setText
local createTimeLayer				= TipLayer.createTimeLayer
local createPiLiangLayer			= TipLayer.createPiLiangLayer
local createOk_Cancel_TipLayer		= TipLayer.createOk_Cancel_TipLayer
local CreateTipLayerManager				= TipCommonLayer.CreateTipLayerManager
local GetShopName					= CorpsShopData.GetShopName
local GetShopRefreshTime			= CorpsShopLogic.GetShopRefreshTime
local GetItemName					= CorpsShopData.GetItemName
local GetItemReserves				= CorpsShopData.GetItemReserves
local GetTableByGrid				= server_shopDB.GetTableByGrid
local GetRefreshCount				= server_shopDB.GetRefreshCount
local GetSurplusItemNum				= CorpsShopLogic.GetSurplusItemNum
local GetShopRefreshTimes			= CorpsShopData.GetShopRefreshTimes
local GetRefreshShopConsumeId		= CorpsShopData.GetRefreshShopConsumeId
local GetItemPathByTempID 			= ItemData.GetItemPathByTempID
local GetTradeTipInfo				= CorpsShopLogic.GetTradeTipInfo
local GetTradeData					= CorpsShopLogic.GetTradeData

local MakeHeadIcon					= UIInterface.MakeHeadIcon
local RunListAction 				= UIInterface.RunListAction

local BagIsFull						= ItemData.BagItemIsFull

local GetShopTipTextById			= CorpsShopData.GetShopTipTextById
local GetExpendIconPath = CorpsShopData.GetExpendIconPath

local function InitVars(  )
	m_nShopId = nil
	m_pCorpsShop = nil
	m_lvShopItem = nil
	m_btnReturn = nil
	m_btnRefresh = nil
	m_plbShopName = nil
	m_tab_NeedUpdate = nil
end

local function _Button_Return_ShopLayer_CallBack( sender, eventType )
	m_pCorpsShop:removeFromParentAndCleanup(true)
	InitVars()
end

local function CreateShopItemWidget( pShopItemTemp )
    local pShopItem = pShopItemTemp:clone()
    local peer = tolua.getpeer(pShopItemTemp)
    tolua.setpeer(pShopItem, peer)
    return pShopItem
end

local function RunTalkAction( nId )
	m_pimgTalk:setVisible(true)
	local pLabel = tolua.cast(m_pimgTalk:getChildByName("Label_Talk"), "Label")
	pLabel:setText(GetShopTipTextById(nId))
	local nWidth = pLabel:getSize().width
	if nWidth>308 then
		m_pimgTalk:setSize(CCSize(nWidth+60, m_pimgTalk:getSize().height))
	else
		m_pimgTalk:setSize(CCSize(308, m_pimgTalk:getSize().height))
	end
	pLabel:setPosition(ccp(m_pimgTalk:getSize().width/2+10, pLabel:getPositionY()))

	local function HideTalkImg(  )
		m_pimgTalk:setVisible(false)
	end
	local pActArray = CCArray:create()
	pActArray:addObject(CCDelayTime:create(1))
	pActArray:addObject(CCCallFunc:create(HideTalkImg))
	m_pimgTalk:stopAllActions()
	m_pimgTalk:runAction(CCSequence:create(pActArray))
end

local function UpdateShopItemControl( pControl, tabItem )

	local pImgSoldOut = tolua.cast(pControl:getChildByName("Image_Soldout"), "ImageView")
	local pImgItemIcon = tolua.cast(pControl:getChildByName("Image_Item"), "ImageView")

	local pImgColor = tolua.cast(pImgItemIcon:getChildByTag(50), "ImageView")
	local pSpriteColor = tolua.cast(pImgColor:getVirtualRenderer(), "CCSprite")

	local pImgNameBg = tolua.cast(pControl:getChildByName("Image_ItemName"), "ImageView")
	local pSpriteName = tolua.cast(pImgNameBg:getVirtualRenderer(), "CCSprite")

	local pImgIcon = tolua.cast(pImgItemIcon:getChildByTag(1000), "ImageView")
	local pSpriteIcon = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")

	local pImgFlower = tolua.cast(pControl:getChildByName("Image_30"), "ImageView")
	local pSpriteFlower = tolua.cast(pImgFlower:getVirtualRenderer(), "CCSprite")

	local pImgFlowerLeft = tolua.cast(pControl:getChildByName("Image_31"), "ImageView")
	local pSpriteFlowerLeft = tolua.cast(pImgFlowerLeft:getVirtualRenderer(), "CCSprite")

	local pImgFlowerRight = tolua.cast(pControl:getChildByName("Image_32"), "ImageView")
	local pSpriteFlowerRight = tolua.cast(pImgFlowerRight:getVirtualRenderer(), "CCSprite")

	local pImgMoneyBg = tolua.cast(pControl:getChildByName("Image_10"), "ImageView")
	local pSpriteMoneyBg = tolua.cast(pImgMoneyBg:getVirtualRenderer(), "CCSprite")

	local pImgMoneyIcon = tolua.cast(pControl:getChildByName("Image_MoneyIcon"), "ImageView")
	local pSpriteMoneyIcon = tolua.cast(pImgMoneyBg:getVirtualRenderer(), "CCSprite")

	local pSpriteControl = tolua.cast(pControl:getVirtualRenderer(), "CCScale9Sprite")

	local nCurReserves = tabItem["nReserves"]

	if nCurReserves==0 then
		Scale9SpriteSetGray(pSpriteControl,1)
		SpriteSetGray(pSpriteName,1)
		SpriteSetGray(pSpriteIcon,1)
		SpriteSetGray(pSpriteColor,1)
		SpriteSetGray(pSpriteFlower,1)
		SpriteSetGray(pSpriteFlowerLeft,1)
		SpriteSetGray(pSpriteFlowerRight,1)
		SpriteSetGray(pSpriteMoneyBg,1)
		SpriteSetGray(pSpriteMoneyIcon,1)
		pImgSoldOut:setVisible(true)
  	else
  		Scale9SpriteSetGray(pSpriteControl,0)
  		SpriteSetGray(pSpriteName,0)
  		SpriteSetGray(pSpriteIcon,0)
  		SpriteSetGray(pSpriteColor,0)
		SpriteSetGray(pSpriteFlower,0)
		SpriteSetGray(pSpriteFlowerLeft,0)
		SpriteSetGray(pSpriteFlowerRight,0)
		SpriteSetGray(pSpriteMoneyBg,0)
		SpriteSetGray(pSpriteMoneyIcon,0)
  		pImgSoldOut:setVisible(false)
	end

	local pLbItemPrice = tolua.cast(pControl:getChildByName("Label_CostNum"), "Label")
	pLbItemPrice:setText(tostring(tabItem["Price"]))

	local nMaxReserves = GetItemReserves(tabItem["ItemID"])

	local pItemControl = pControl:getChildByName("Image_Item")
	local pLbItemNum = tolua.cast(pItemControl:getChildByName("LabelNum"), "Label")
	-- pLbItemNum:setText(tostring(nCurReserves).."/"..tostring(nMaxReserves))
	pLbItemNum:setText(tostring(nCurReserves))
	--添加商品的消耗icon显示 ，（之前没有做）
	local pImgMoneyIcon = tolua.cast(pControl:getChildByName("Image_MoneyIcon"), "ImageView")
	pImgMoneyIcon:loadTexture(GetExpendIconPath(tabItem["ItemID"]))
end

--自动重置数据
function TimeUpdateShop(nGird,key)
	local strRefreshTime = GetShopRefreshTime(m_nShopId)
	local pLbRefreshTime = tolua.cast(m_pCorpsShop:getWidgetByName("Label_RefreshTime"), "Label")
	pLbRefreshTime:setText(strRefreshTime)
	local tab = GetTableByGrid(nGird, m_nShopId)
	local nList = key -1 
	if nList<0 then
		nList = 0
	end
	local pControl = tolua.cast(m_lvShopItem:getItem(nList/2):getChildByName("Image_ShopItem_"..key%2), "ImageView")
	UpdateShopItemControl(pControl,tab)
	
end
local function _Image_Buy_MallLayer_CallBack( sender, eventType)
	if eventType == TouchEventType.ended then
		local pManagerTip = CreateTipLayerManager()
		local tabItem = GetTableByGrid(sender:getTag(), m_nShopId)
		
		local nBuyReserves = tabItem["nReserves"]
		if nBuyReserves==0 then
			RunTalkAction(13)
        	return
		end

		if BagIsFull()==true then
			--CreateTipsLayer(503, TIPS_TYPE.TIPS_TYPE_NONE, nil, nil, nil)
			pManagerTip:ShowCommonTips(503,nil)
			pManagerTip = nil
			return
		end

		local function SelectNumberCall(nNum)
			table.insert(m_tab_NeedUpdate,tolua.cast(sender, "ImageView"))
			local tabTradeData = GetTradeData(m_nShopId, tabItem["ItemID"], nNum, tabItem["Price"])
			if tabTradeData.Enough==false then
				TipLayer.createTimeLayer(GetTradeTipInfo(tabTradeData.CoinType), 2)
				return
			end
			local function BuyOver()
				NetWorkLoadingLayer.loadingHideNow()
				local tabCurItem = GetTableByGrid(sender:getTag(), m_nShopId)
				createTimeLayer("恭喜您获得" .. tostring(nNum) .. "个" .. GetItemName(tabItem["ItemID"]), 2)
				UpdateShopItemControl(tolua.cast(sender, "ImageView"), tabCurItem)
			end
			Packet_BuyItem.SetSuccessCallBack(BuyOver)
			network.NetWorkEvent(Packet_BuyItem.CreatPacket(m_nShopId, sender:getTag(), nNum, 100))
			NetWorkLoadingLayer.loadingShow(true)
		end
		local nHave = server_itemDB.GetItemNumberByTempId(tabItem["ItemID"])
        TipLayer.createPiLiangLayer(0,tabItem["ItemID"], nHave, nBuyReserves, m_nShopId, tabItem["ItemID"], tabItem["Price"], SelectNumberCall,GetExpendIconPath(tabItem["ItemID"]))
	end
end

local function InitShopItemControl( pControl, tabItem )
	pControl:setTag(tabItem["Grid"])
	pControl:addTouchEventListener(_Image_Buy_MallLayer_CallBack)
	local strItemName = GetItemName(tabItem["ItemID"])
    local pLbItemName = CCLabelTTF:create(strItemName,CommonData.g_FONT1,22)
    pLbItemName:setPosition(ccp(-3,80))
    pControl:addNode(pLbItemName,1,99)


	local pImgItemIcon = tolua.cast(pControl:getChildByName("Image_Item"), "ImageView")
	local pItemControl = MakeHeadIcon(pImgItemIcon, ICONTYPE.ITEM_ICON, tabItem["ItemID"], tabItem["Grid"])
	pItemControl:setTouchEnabled(false)

	local pLbItemNum = Label:create()
	pLbItemNum:setPosition(ccp(50,-42))
	pLbItemNum:setFontSize(18)
	pLbItemNum:setName("LabelNum")
	pLbItemNum:setAnchorPoint(ccp(1.0, 0.5))
	pImgItemIcon:addChild(pLbItemNum)
	
	
	

	UpdateShopItemControl(pControl, tabItem)
end

local function UpadateShopListItem( tabShopItem,  nBeginIdx, nEndIdx  )
	local pShopItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemShopListLayer.json")
	for i=nBeginIdx, nEndIdx do
		if i%SINGLROWITEMCOUNT==0 then
			local  pShopItemWidget = CreateShopItemWidget(pShopItemTemp)
			local pControl_1 = tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_1"), "ImageView")
			InitShopItemControl(pControl_1, tabShopItem[i-1])

			local pControl_2 = tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_2"), "ImageView")
			InitShopItemControl(pControl_2, tabShopItem[i])

			m_lvShopItem:pushBackCustomItem(pShopItemWidget)
		elseif (i%SINGLROWITEMCOUNT~=0) and (i==(#tabShopItem)) then
			local  pShopItemWidget = CreateShopItemWidget(pShopItemTemp)
			local pControl_1 =  tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_1"), "ImageView")
			InitShopItemControl(pControl_1, tabShopItem[i])

			local pControl_2 =tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_2"), "ImageView")
			if pControl_2~=nil then
				pControl_2:setVisible(false)
				pControl_2:setEnabled(false)
			end
			m_lvShopItem:pushBackCustomItem(pShopItemWidget)
		end
	end
end
--更新商店，自动刷新
local function UpadateShopItem( nShopId )
	local strShopName = GetShopName(nShopId)
	SetStrokeLabelText(m_plbShopName, strShopName)

	local strRefreshTime = GetShopRefreshTime(nShopId)
	local pLbRefreshTime = tolua.cast(m_pCorpsShop:getWidgetByName("Label_RefreshTime"), "Label")
	pLbRefreshTime:setText(strRefreshTime)

	local pShopItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemShopListLayer.json")
	local tabShopItem = server_shopDB.GetCopyTable(nShopId)

	RunListAction(m_lvShopItem, tabShopItem, COUNTPERPAGE, UpadateShopListItem)
end



local function _Button_Refresh_ShopLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		function IsRefresh( bRefresh )
			if bRefresh==false then
				local function refreshShopOver()
					NetWorkLoadingLayer.loadingHideNow()
					UpadateShopItem(m_nShopId)
				end
				NetWorkLoadingLayer.loadingShow(true)
				Packet_RefreshShop.SetSuccessCallBack(refreshShopOver)
				network.NetWorkEvent(Packet_RefreshShop.CreatPacket(m_nShopId))
			end
		end
		-- 商店表里配的可刷新次数 - 服务器返回的已经刷新数RefreshNumber
		if m_nLeftRefreshCount<1 then
			TipLayer.createTimeLayer("今日刷新次数已用完！")
			return
		end
		local nAllCount = GetShopRefreshTimes(m_nShopId)
		local nConsumeId = GetRefreshShopConsumeId(m_nShopId)
		-- local nRefreshCount = GetRefreshCount(m_nShopId)
		local tabConsume = ConsumeLogic.GetConsumeTab(5, nConsumeId)
		local tempTable = server_shopDB.GetCopyTable(m_nShopId)
		local tabConsumeData = {}
		for i=1, table.getn(tabConsume) do
			tabConsumeData = ConsumeLogic.GetConsumeItemData( tabConsume[i].ConsumeID,  tabConsume[i].nIdx, tabConsume[i].ConsumeType, tabConsume[i].IncType, nAllCount - m_nLeftRefreshCount, 1, nil )
		end
		if tabConsumeData.Enough==false then
			return
		end
		local pManagerTip = CreateTipLayerManager()
		pManagerTip:ShowCommonTips(403,IsRefresh,tabConsumeData.ItemNeedNum,m_nLeftRefreshCount)
		--CreateTipsLayer(403, TIPS_TYPE.TIPS_TYPE_NONE, m_nLeftRefreshCount, IsRefresh,tabConsumeData.ItemNeedNum)
		-- printTab(tempTable)
		-- createOk_Cancel_TipLayer("显示下一批货物您将消耗{" .. tempTable["nNumber"] .. "}金币是否继续？（今日还可刷新{" .. nAllCount-tempTable["RefreshNumber"] .. "}次）", TipOver)
	end
end

local function _ImageHead_MallLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		math.randomseed(os.time())
		local  nId = math.random(9, 14)
		RunTalkAction(nId)
	elseif eventType == TouchEventType.began then
		-- sender:setScale(1.2)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitWidgets(  )
	--物品列表
	m_lvShopItem = tolua.cast(m_pCorpsShop:getWidgetByName("ListView_Items"), "ListView")
	if m_lvShopItem == nil then
		print("m_lvShopItem is nil")
		return false
	else
		m_lvShopItem:setClippingType(1)
	end

	--返回按钮
	m_btnReturn = tolua.cast(m_pCorpsShop:getWidgetByName("Button_Return"), "Button")
	if m_btnReturn == nil then
		print("m_btnReturn is nil")
		return false
	else
		CreateBtnCallBack(m_btnReturn, nil, nil, _Button_Return_ShopLayer_CallBack)
	end

	m_btnRefresh = tolua.cast(m_pCorpsShop:getWidgetByName("Button_Refresh"), "Button")
	if m_btnRefresh == nil then
		print("m_btnRefresh is nil")
		return false
	else
		m_btnRefresh:addTouchEventListener(_Button_Refresh_ShopLayer_CallBack)
	end

	local pImgShopNameBg = tolua.cast(m_pCorpsShop:getWidgetByName("Image_ShopName"), "ImageView")
	if pImgShopNameBg==nil then
		print("pImgShopNameBg is nil")
		return false
	else
		m_plbShopName = CreateStrokeLabel(36, CommonData.g_FONT1, "商店名称", ccp(0, -5), ccc3(108, 22, 20), ccc3(255, 235, 154), true, ccp(0, -2), 2)
		pImgShopNameBg:addChild(m_plbShopName)
	end

	local pImgRefresh = tolua.cast(m_pCorpsShop:getWidgetByName("Image_Refresh"), "ImageView")
	if pImgRefresh==nil then
		print("pImgRefresh is nil")
		return false
	else
		local plbRefresh = CreateStrokeLabel(20, CommonData.g_FONT1, "刷新", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pImgRefresh:addChild(plbRefresh)
	end

	m_pimgTalk = tolua.cast(m_pCorpsShop:getWidgetByName("Image_Talk"), "ImageView")
	if m_pimgTalk == nil then
		print("m_pimgTalk is nil")
		return false
	else
		-- m_pimgTalk:setVisible(false)
		RunTalkAction(9)
	end

	local pImageHead = tolua.cast(m_pCorpsShop:getWidgetByName("Image_8"), "ImageView")
	if pImageHead==nil then
		print("pImageHead is nil")
		return false
	else
		pImageHead:setTouchEnabled(true)
		pImageHead:addTouchEventListener(_ImageHead_MallLayer_CallBack)
	end
	return true
end

function CreateShopLayer( nShopId )
	InitVars()
	m_pCorpsShop = TouchGroup:create()									-- 背景层
    m_pCorpsShop:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/ShopLayer.json") )
    if InitWidgets()==false then
    	return
    end
	m_tab_NeedUpdate = {}

    m_nShopId = nShopId
    m_nLeftRefreshCount = GetRefreshCount(nShopId)
    UpadateShopItem(nShopId)
	return m_pCorpsShop
end

function SetLeftRefreshCount( nCount )
	m_nLeftRefreshCount = nCount
end