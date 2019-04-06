require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Main/Mall/ShopData"
require "Script/Main/Mall/ShopLogic"
require "Script/Common/RichLabel"
module("ShopLayer", package.seeall)
require "Script/Main/Corps/CorpsScene"

-- local MARK_DISCOUNT = "Image/imgres/common/mark_discount.png"
-- local MARK_HOT = "Image/imgres/common/mark_hot.png"
-- local MARK_RECD = "Image/imgres/common/mark_recd.png"
-- local MARK_RERA = "Image/imgres/common/mark_rera.png"

local MARK_DISCOUNT = "Image/imgres/VIPCharge/mark1.png"
local MARK_HOT = "Image/imgres/VIPCharge/mark2.png"
local MARK_RECD = "Image/imgres/VIPCharge/mark3.png"
local MARK_RERA = "Image/imgres/VIPCharge/mark4.png"

local SINGLROWITEMCOUNT = 2
local COUNTPERPAGE = 8
local m_selected = 0
local m_selectedID = 0

local m_nShopId = nil
local m_nShopType = nil
local m_nLeftRefreshCount = nil

local m_plyShop = nil
local m_lvShopItem = nil
local m_btnReturn = nil
local m_btnRefresh = nil
local m_plbShopName = nil
local m_pimgTalk = nil
local u_timeShopHand = nil
local pLbRefreshTime = nil
local m_tab_NeedUpdate  = nil --celina add 记录要更新的img
local tabShopItem = {}
local pShopItemWidget = nil
local n_ShopItem = nil
local pItemControl = nil
local n_GridItem = nil

local CreateStrokeLabel 			= LabelLayer.createStrokeLabel
local SetStrokeLabelText			= LabelLayer.setText
local createTimeLayer				= TipLayer.createTimeLayer
local createPiLiangLayer			= TipLayer.createPiLiangLayer
local createOk_Cancel_TipLayer		= TipLayer.createOk_Cancel_TipLayer
local CreateTipLayerManager				= TipCommonLayer.CreateTipLayerManager
local GetShopName					= ShopData.GetShopName
local GetShopRefreshTime			= ShopLogic.GetShopRefreshTime
local GetItemName					= ShopData.GetItemName
local GetItemReserves				= ShopData.GetItemReserves
local GetTableByGrid				= server_shopDB.GetTableByGrid
local GetRefreshCount				= server_shopDB.GetRefreshCount
local GetSurplusItemNum				= ShopLogic.GetSurplusItemNum
local GetShopRefreshTimes			= ShopData.GetShopRefreshTimes
local GetRefreshShopConsumeId		= ShopData.GetRefreshShopConsumeId
local GetItemPathByTempID 			= ItemData.GetItemPathByTempID
local GetTradeTipInfo				= ShopLogic.GetTradeTipInfo
local GetTradeData					= ShopLogic.GetTradeData
local GetGridNum                    = ShopData.GetGridNum
local CheckItemByGrid               = ShopLogic.CheckItemByGrid
local CheckItemByItemID             = ShopLogic.CheckItemByItemID
local GetAnimationAction            = ShopLogic.GetAnimationAction
-- local MakeHeadIcon					= UIInterface.MakeHeadIcon
local RunListAction 				= UIInterface.RunListAction
local GetItemCurPrice               = ShopLogic.GetItemCurPrice

local BagIsFull						= ItemData.BagItemIsFull
local GetItemData                   = ShopData.GetItemData     
local GetShopTipTextById			= ShopData.GetShopTipTextById
local GetShopTxtById                = ShopData.GetShopTxtById
local GetTolkIDByShopID             = ShopLogic.GetTolkIDByShopID
local GetTolkSoldOutByShopID        = ShopLogic.GetTolkSoldOutByShopID
local GetExpendIconPath 			= ShopData.GetExpendIconPath
local GetShopHeadPath 				= ShopData.GetShopHeadPath

local nKeys = {
	nKey = "|",
}

local function InitVars(  )
	m_nShopId = nil
	m_plyShop = nil
	m_lvShopItem = nil
	m_btnReturn = nil
	m_btnRefresh = nil
	m_plbShopName = nil
	m_tab_NeedUpdate = nil
	u_timeShopHand  = nil
	pLbRefreshTime = nil
	pShopItemWidget = nil
	n_ShopItem = nil
	n_GridItem = nil
	m_nShopType = nil
	pItemControl = nil
	tabShopItem = {}
	-- m_selected = 0
end

local function _Button_Return_ShopLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if u_timeShopHand ~= nil then
			m_plyShop:getScheduler():unscheduleScriptEntry(u_timeShopHand)
			u_timeShopHand = nil
		end
		if tonumber(m_nShopId) == 1 or tonumber(m_nShopId) == 4 then
			local pBarManager = MainScene.GetBarManager()
			pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Shop) 
		elseif tonumber(m_nShopId) == 2  then
			local pBarManager = MainScene.GetBarManager()
			pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_ShopBiWu)
		end
		m_plyShop:removeFromParentAndCleanup(true)
		m_plyShop = nil
		-- InitVars()
		local m_pCorpsScene = CorpsScene.GetPScene()
		
		if m_pCorpsScene == nil then
			MainScene.PopUILayer()
		end

	end
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
	
	local pathItem = ShopData.GetItemPath(tabItem["ItemID"])
	local pImgItemIcon = tolua.cast(pControl:getChildByName("Image_Item"), "ImageView")
	
	if pathItem == nil then 
		pItemControl = UIInterface.MakeHeadIcon(pImgItemIcon, ICONTYPE.ITEM_ICON, 201, tabItem["Grid"])
	else
		pItemControl = UIInterface.MakeHeadIcon(pImgItemIcon, ICONTYPE.ITEM_ICON, tabItem["ItemID"], nil)
	
	end
	pItemControl:setTouchEnabled(false)

	local pLbItemNum = Label:create()
	pLbItemNum:setPosition(ccp(-50,-42))
	pLbItemNum:setFontSize(18)
	pLbItemNum:setName("LabelNum")
	pLbItemNum:setAnchorPoint(ccp(0, 0.5))
	pItemControl:addChild(pLbItemNum)

	local pImgSoldOut = tolua.cast(pControl:getChildByName("Image_Soldout"), "ImageView")
	-- local pImgItemIcon = tolua.cast(pControl:getChildByName("Image_Item"), "ImageView")
	local pSpritepImgItemIcon = tolua.cast(pImgItemIcon:getVirtualRenderer(), "CCSprite")

	local pImgColor = tolua.cast(pImgItemIcon:getChildByTag(50), "ImageView")
	local pSpriteColor = tolua.cast(pImgColor:getVirtualRenderer(), "CCSprite")

	local pImgNameBg = tolua.cast(pControl:getChildByName("Image_ItemName"), "ImageView")
	local pSpriteName = tolua.cast(pImgNameBg:getVirtualRenderer(), "CCSprite")

	local pImgIcon = tolua.cast(pImgItemIcon:getChildByTag(1000), "ImageView")
	local pSpriteIcon = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")

	--魂
	local pImgHun = tolua.cast(pItemControl:getChildByTag(1001), "ImageView")
	-- print(pImgHun)
	local pSpriteHun = nil
	if pImgHun ~= nil then
		pSpriteHun = tolua.cast(pImgHun:getVirtualRenderer(), "CCSprite")
	end
	--碎片
	local pImgSuiPian = tolua.cast(pItemControl:getChildByTag(1000), "ImageView")

	local pSpriteSui = nil
	if pImgSuiPian ~= nil then
		pSpriteSui = tolua.cast(pImgSuiPian:getVirtualRenderer(), "CCSprite")
	end
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

	local img_mark = tolua.cast(pControl:getChildByName("Image_mark"),"ImageView")
	local pSpriteMarkIcon = tolua.cast(img_mark:getVirtualRenderer(), "CCSprite")

	local pLabel_name = tolua.cast(pControl:getChildByName("Label_ItemName"),"Label")
	-- pLabel_name:setVisible(false)

	
	--根据商店ID及物品格子取出对应物品的信息
	local tabConditoin = GetItemData(m_nShopId,tabItem["Grid"])
	--获得物品储量
	local TotalReserves = tabConditoin[1][9]
	--还剩余数量
	local nCurReserves = tonumber(TotalReserves) - tonumber(tabItem["nReserves"])
	if nCurReserves==0 then
		Scale9SpriteSetGray(pSpriteControl,1)
		SpriteSetGray(pSpritepImgItemIcon,1)
		SpriteSetGray(pSpriteName,1)
		SpriteSetGray(pSpriteIcon,1)
		SpriteSetGray(pSpriteColor,1)
		SpriteSetGray(pSpriteFlower,1)
		SpriteSetGray(pSpriteFlowerLeft,1)
		SpriteSetGray(pSpriteFlowerRight,1)
		SpriteSetGray(pSpriteMoneyBg,1)
		SpriteSetGray(pSpriteMoneyIcon,1)
		SpriteSetGray(pSpriteMarkIcon,1)
		if pImgSuiPian ~= nil then
  			SpriteSetGray(pSpriteSui,1)
  		end
		if pImgHun ~= nil then
  			SpriteSetGray(pSpriteHun,1)
  		end
  		
  		pImgSoldOut:setVisible(true)
  	else
  		-- SpriteSetGrayToZero()
  		Scale9SpriteSetGray(pSpriteControl,0)
		
		SpriteSetGray(pSpritepImgItemIcon,0)
  		SpriteSetGray(pSpriteName,0)
  		SpriteSetGray(pSpriteIcon,0)
  		SpriteSetGray(pSpriteColor,0)
		SpriteSetGray(pSpriteFlower,0)
		SpriteSetGray(pSpriteFlowerLeft,0)
		SpriteSetGray(pSpriteFlowerRight,0)
		SpriteSetGray(pSpriteMoneyBg,0)
		SpriteSetGray(pSpriteMoneyIcon,0)
		SpriteSetGray(pSpriteMarkIcon,0)

		if pImgSuiPian ~= nil then
  			SpriteSetGray(pSpriteSui,0)
  		end
		if pImgHun ~= nil then
  			SpriteSetGray(pSpriteHun,0)
  		end
  		
  		pImgSoldOut:setVisible(false)
	end

	
	--当前价格
	local buy_Price = GetItemCurPrice(m_nShopId,tabItem["Grid"],tabItem["nReserves"])
	local pLbItemPrice = tolua.cast(pControl:getChildByName("Label_CostNum"), "Label")
	pLbItemPrice:setText(tostring(buy_Price))

	local strItemName = GetItemName(tabItem["ItemID"])
    pLabel_name:setText(strItemName)

	-- local pItemControl11 = pControl:getChildByName("Image_Item")
	-- local pLbItemNum = tolua.cast(pImgItemIcon:getChildByName("LabelNum"), "Label")
	pLbItemNum:setText(tostring(nCurReserves))

	pImgMoneyIcon:loadTexture(GetExpendIconPath(tabConditoin[1][5]))

	local Herolevel = server_mainDB.getMainData("level")
	local powerLevel = server_mainDB.getMainData("power")
	local m_tabShop = {}
	m_tabShop = CheckItemByItemID(tabItem["Grid"],m_nShopId)
	
	local label_mark = tolua.cast(img_mark:getChildByName("Label_mark"),"Label")
	local label_dis = tolua.cast(pControl:getChildByName("Label_count"),"Label")
	
	--if tonumber(tabItem["ShopID"]) ~= 6 then
		--img_mark:setVisible(false)
	--else
		-- if next(m_tabShop) ~= nil then
			if tonumber(m_tabShop["TagImg"]) == 1 then
				img_mark:loadTexture(MARK_HOT)
			elseif tonumber(m_tabShop["TagImg"]) == 2 then
				img_mark:loadTexture(MARK_DISCOUNT)
			elseif tonumber(m_tabShop["TagImg"]) == 3 then
				img_mark:loadTexture(MARK_RECD)
			elseif tonumber(m_tabShop["TagImg"]) == 4 then
				img_mark:loadTexture(MARK_RERA)
			elseif tonumber(m_tabShop["TagImg"]) == 0 then
				img_mark:setVisible(false)
			end
			if tonumber(m_tabShop["Discount"]/1000) ~= 1 then
				local line = AddLine(ccp(-10,0),ccp(30,0), ccc3(0xff,0x00,0x00),1,255)
				pLbItemPrice:addNode(line)
				local cur_Price = math.floor(tostring(buy_Price)*m_tabShop["Discount"]/1000)
				if tonumber(cur_Price) < 1 then
					cur_Price = 1
				end
				label_dis:setText(cur_Price)
			end
			--富文本显示
			
			-- printTab(tabConditoin)
			-- Pause()
			local pTextWidth = 150
			local cur_vip = server_mainDB.getMainData("vip")
			local cur_level = server_mainDB.getMainData("level")
			if tonumber(tabItem["is_buy"]) == 0 then
			if tonumber(tabConditoin[1][10]) > 0 then
				local nMessText = tabConditoin[1][11]
				local pShade = ImageView:create()
				pShade:loadTexture("Image/imgres/countrywar/cityNameBg.png")
				pShade:setScale9Enabled(true)
				pShade:setSize(CCSize(220,55))
				pShade:setPosition(ccp(pControl:getContentSize().width/2-40,pControl:getContentSize().height/2-30))
				pControl:addChild(pShade)
				local color = "|color|254,231,73||size|24|"
				local messContentItem = RichLabel.Create(color..nMessText,pTextWidth,nil,nil,1)
				messContentItem:setPosition(ccp(-60,25))
				pShade:addChild(messContentItem)

				Scale9SpriteSetGray(pSpriteControl,1)
				SpriteSetGray(pSpritepImgItemIcon,1)
				SpriteSetGray(pSpriteName,1)
				SpriteSetGray(pSpriteIcon,1)
				SpriteSetGray(pSpriteColor,1)
				SpriteSetGray(pSpriteFlower,1)
				SpriteSetGray(pSpriteFlowerLeft,1)
				SpriteSetGray(pSpriteFlowerRight,1)
				SpriteSetGray(pSpriteMoneyBg,1)
				SpriteSetGray(pSpriteMoneyIcon,1)
				SpriteSetGray(pSpriteMarkIcon,1)
				if pImgHun ~= nil then
		  			SpriteSetGray(pSpriteHun,1)
		  		end
			end
			end
		-- end
	--end
end

--自动重置数据
function TimeUpdateShop(nGird,key)
	local strRefreshTime = GetShopRefreshTime(m_nShopId)
	local pLbRefreshTime = tolua.cast(m_plyShop:getWidgetByName("Label_RefreshTime"), "Label")
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
		AudioUtil.PlayBtnClick()
		local pManagerTip = CreateTipLayerManager()	
		local tag = sender:getTag()
		n_GridItem = sender
		local tabItem = GetTableByGrid(sender:getTag(), m_nShopId)
		if sender:getNodeByTag(1990) ~= nil then
			sender:getNodeByTag(1990):removeFromParentAndCleanup(true)
		end
		if tabItem == nil then			
			return 
		end

		local tabConditoin = GetItemData(m_nShopId,tabItem["Grid"])
		local cur_vip = server_mainDB.getMainData("vip")
		local cur_level = server_mainDB.getMainData("level")
		-- printTab(tabItem)
		if tonumber(tabItem["is_buy"]) == 0 then			
			return 
		end
		local nBuyReserves = tonumber(tabConditoin[1][9]) - tonumber(tabItem["nReserves"])
		if nBuyReserves==0 then
			--售空时的喊话
			local tabSlodOut = GetTolkSoldOutByShopID(m_nShopId)
			local n_soldOut = #tabSlodOut
			local n_index = math.random(1,n_soldOut)

			local n_TxtID = tabSlodOut[n_index]
			RunTalkAction(n_TxtID)
        	return
		end

		if BagIsFull()==true then
			pManagerTip:ShowCommonTips(503,nil)
			pManagerTip = nil
			return
		end

		local function SelectNumberCall(nNum,nToprice)
			table.insert(m_tab_NeedUpdate,tolua.cast(sender, "ImageView"))
			local function BuyOver()
				NetWorkLoadingLayer.loadingHideNow()
				local n_pCorpsScene = CorpsScene.GetPScene()
				if n_pCorpsScene ~= nil then
					CorpsScene.GetConteobile(1)
				end
				local tabCurItem = GetTableByGrid(tag, m_nShopId) --tag  sender:getTag()
				createTimeLayer("恭喜您获得" .. tostring(nNum) .. "个" .. GetItemName(tabItem["ItemID"]), 2)
				UpdateShopItemControl(tolua.cast(sender, "ImageView"), tabCurItem)
			end
			Packet_BuyItem.SetSuccessCallBack(BuyOver)
			network.NetWorkEvent(Packet_BuyItem.CreatPacket(m_nShopType, m_nShopId,sender:getTag(), nNum))
			NetWorkLoadingLayer.loadingShow(true)
		end
		local buy_Price = GetItemCurPrice(m_nShopId,tabItem["Grid"],tabItem["nReserves"])

		local dis_count = tabConditoin[1][13]/1000
		local cur_Price = math.floor(tostring(buy_Price)*dis_count)
		if tonumber(cur_Price) < 1 then
			cur_Price = 1
		end
		local nHave = server_itemDB.GetItemNumberByTempId(tabItem["ItemID"])
		
        TipLayer.createPiLiangLayer(0,tabItem["ItemID"], nHave, nBuyReserves, m_nShopId, tabItem["Grid"], cur_Price, SelectNumberCall,GetExpendIconPath(tabConditoin[1][5]))
	end
end

local function InitShopItemControl( pControl, tabItem )
	
	pControl:setTag(tabItem["Grid"])
	pControl:addTouchEventListener(_Image_Buy_MallLayer_CallBack)
	
	UpdateShopItemControl(pControl, tabItem)
end

local function UpadateShopListItem( tabShopItem,  nBeginIdx, nEndIdx  )
	local pShopItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemShopListLayer.json")
	for i=nBeginIdx, nEndIdx do
		if i%SINGLROWITEMCOUNT==0 then
			pShopItemWidget = CreateShopItemWidget(pShopItemTemp)
			local pathItem = ShopData.GetItemPath(tabShopItem[i-1]["ItemID"])
			local pControl_1 = tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_1"), "ImageView")
			InitShopItemControl(pControl_1, tabShopItem[i-1])
			local pItemID_1 = tabShopItem[i-1]["ItemID"]
			if pItemID_1 == m_selectedID then
				n_ShopItem = pControl_1
			end

			local pControl_2 = tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_2"), "ImageView")
			InitShopItemControl(pControl_2, tabShopItem[i])

			local pItemID_2 = tabShopItem[i]["ItemID"]
			if pItemID_2 == m_selectedID then
				n_ShopItem = pControl_2
			end

			m_lvShopItem:pushBackCustomItem(pShopItemWidget)
			-- m_lvShopItem:scrollToPercentHorizontal(100,0.1,false)
		elseif (i%SINGLROWITEMCOUNT~=0) and (i==(#tabShopItem)) then
			local pathItem = ShopData.GetItemPath(tabShopItem[i-1]["ItemID"])
			local  pShopItemWidget = CreateShopItemWidget(pShopItemTemp)
			local pControl_1 =  tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_1"), "ImageView")
			InitShopItemControl(pControl_1, tabShopItem[i])
			local pItemID_1 = tabShopItem[i]["ItemID"]
			if pItemID_1 == m_selectedID then
				n_ShopItem = pControl_1
			end

			local pControl_2 =tolua.cast(pShopItemWidget:getChildByName("Image_ShopItem_2"), "ImageView")
			if pControl_2~=nil then
				pControl_2:setVisible(false)
				pControl_2:setEnabled(false)
			end
			m_lvShopItem:pushBackCustomItem(pShopItemWidget)
			
		end
		local tab_item = tabShopItem[i]
		local n_GridNum = 0
		if tonumber(tab_item["ItemID"]) == tonumber(m_selectedID) then
			m_selected = GetGridNum(nBeginIdx, nEndIdx)
			n_GridNum = tab_item["Grid"]
		end
		if i == (#tabShopItem) then
			if tonumber(n_GridNum) > 6 then
				m_lvShopItem:scrollToPercentHorizontal(39*m_selected,0.1,false)
			end
		end
	end
	
end

local function SetDelayTime(nSecend)
	if nSecend < 0 then return end
				
	local nDelayTime = nSecend
	local strH = math.floor(nSecend/3600)
	local strM = math.floor(nSecend/60) - strH*60
	local strS = math.floor(nSecend%60)
	if tonumber(strH) < 10 then strH = "0" .. strH end
	if tonumber(strM) < 10 then strM = "0" .. strM end
	if tonumber(strS) < 10 then strS = "0" .. strS end
		
	local function tick(dt)
		if nDelayTime == 0 then
			if u_timeShopHand ~= nil then
				m_plyShop:getScheduler():unscheduleScriptEntry(u_timeShopHand)
				u_timeShopHand = nil
			end
			m_plyShop:removeFromParentAndCleanup(true)
			InitVars()
			local m_pCorpsScene = CorpsScene.GetPScene()
		
			if m_pCorpsScene == nil then
				MainScene.PopUILayer()
			end
			return 
		end
		nDelayTime = nDelayTime -1
		SetDelayTime(nDelayTime)
	end
	if u_timeShopHand == nil then
		u_timeShopHand = m_plyShop:getScheduler():scheduleScriptFunc(tick, 1, false)
	else
		pLbRefreshTime:setText(strH..":"..strM .. ":" .. strS)
	end
end
	
--更新商店，自动刷新
local function UpadateShopItem( nShopId )
	local strShopName = GetShopName(nShopId)
	SetStrokeLabelText(m_plbShopName, strShopName)


	local strRefreshTime = GetShopRefreshTime(nShopId)
	pLbRefreshTime = tolua.cast(m_plyShop:getWidgetByName("Label_RefreshTime"), "Label")
	local label_word = tolua.cast(m_plyShop:getWidgetByName("Label_10"), "Label")

	local pShopItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemShopListLayer.json")
	tabShopItem = server_shopDB.GetCopyTable(nShopId)
	if tonumber(m_nShopType) == 4 then
		label_word:setText("距该商店关闭还有:")
		local closeTime = tabShopItem.nTime
		local strHs = math.floor(closeTime/3600)
		local strMs = math.floor(closeTime/60) - strHs*60
		local strSs = math.floor(closeTime%60)
		local strTemp = ""
		if tonumber(strHs) < 10 then strHs = "0" .. strHs end
		if tonumber(strMs) < 10 then strMs = "0" .. strMs end
		if tonumber(strSs) < 10 then strSs = "0" .. strSs end
		pLbRefreshTime:setText(strHs..":"..strMs .. ":" .. strSs)
		SetDelayTime(closeTime)

	else
		pLbRefreshTime:setText(strRefreshTime)
	end
	RunListAction(m_lvShopItem, tabShopItem, COUNTPERPAGE, UpadateShopListItem)
end

local function _Button_Refresh_ShopLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		function IsRefresh( bRefresh )
			if bRefresh==false then
				local function refreshShopOver()
					NetWorkLoadingLayer.loadingHideNow()
					if u_timeShopHand ~= nil then
						m_plyShop:getScheduler():unscheduleScriptEntry(u_timeShopHand)
						u_timeShopHand = nil
					end
					local n_pCorpsScene = CorpsScene.GetPScene()
					if n_pCorpsScene ~= nil then
						CorpsScene.GetConteobile(1)
					end
					UpadateShopItem(m_nShopId)
					
				end
				NetWorkLoadingLayer.loadingShow(true)
				Packet_RefreshShop.SetSuccessCallBack(refreshShopOver)
				network.NetWorkEvent(Packet_RefreshShop.CreatPacket(m_nShopType))
			end
		end
		-- 商店表里配的可刷新次数 - 服务器返回的已经刷新数RefreshNumber
		
		if m_nLeftRefreshCount<1 then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1223,nil)
			pTips = nil
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
		local consumName =ShopData.GetConsumTypeName(tabConsumeData["ConsumeType"])
		local pManagerTip = CreateTipLayerManager()
		pManagerTip:ShowCommonTips(403,IsRefresh,tabConsumeData.ItemNeedNum,consumName,m_nLeftRefreshCount)
	end
end

local function _ImageHead_MallLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		AudioUtil.PlayBtnClick()
		--获取喊话ID
		local tabTalk = GetTolkIDByShopID(m_nShopId)
		local ranNum = #tabTalk
		local  nId = math.random(1, ranNum)
		RunTalkAction(tabTalk[nId])
		local Animation31 = nil
		local Animation32 = nil
		local Animation31,Animation32 = GetAnimationAction(m_nShopType)
		local function EffectOver(  )
			local Animation21 = nil
			local Animation22 = nil
			CommonInterface.GetAnimationByName(Animation31, 
					Animation32, 
					"Animation1", 
					sender, 
					ccp(10, -15),
					nil,
					10)
		end
		
		CommonInterface.GetAnimationByName(Animation31, 
				Animation32, 
				"Animation2", 
				sender, 
				ccp(10, -15),
				EffectOver,
				10)
	elseif eventType == TouchEventType.began then
		-- sender:setScale(1.2)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitWidgets(  )
	--物品列表
	m_lvShopItem = tolua.cast(m_plyShop:getWidgetByName("ListView_Items"), "ListView")
	if m_lvShopItem == nil then
		print("m_lvShopItem is nil")
		return false
	else
		m_lvShopItem:setClippingType(1)
	end

	--返回按钮
	m_btnReturn = tolua.cast(m_plyShop:getWidgetByName("Button_Return"), "Button")
	m_btnReturn:addTouchEventListener(_Button_Return_ShopLayer_CallBack)
	if m_btnReturn == nil then
		print("m_btnReturn is nil")
		return false
	else
		-- CreateBtnCallBack(m_btnReturn, nil, nil, _Button_Return_ShopLayer_CallBack)
	end

	m_btnRefresh = tolua.cast(m_plyShop:getWidgetByName("Button_Refresh"), "Button")
	if m_btnRefresh == nil then
		print("m_btnRefresh is nil")
		return false
	else
		m_btnRefresh:addTouchEventListener(_Button_Refresh_ShopLayer_CallBack)
	end

	local pImgShopNameBg = tolua.cast(m_plyShop:getWidgetByName("Image_ShopName"), "ImageView")
	if pImgShopNameBg==nil then
		print("pImgShopNameBg is nil")
		return false
	else
		m_plbShopName = CreateStrokeLabel(36, CommonData.g_FONT1, "商店名称", ccp(0, -5), ccc3(108, 22, 20), ccc3(255, 235, 154), true, ccp(0, -2), 2)
		pImgShopNameBg:addChild(m_plbShopName)
	end

	local pImgRefresh = tolua.cast(m_plyShop:getWidgetByName("Image_Refresh"), "ImageView")
	if pImgRefresh==nil then
		print("pImgRefresh is nil")
		return false
	else
		if tonumber(m_nLeftRefreshCount) > 0 then
			local plbRefresh = CreateStrokeLabel(20, CommonData.g_FONT1, "刷新", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
			pImgRefresh:addChild(plbRefresh)
		else
			pImgRefresh:setVisible(false)
		end
	end

	m_pimgTalk = tolua.cast(m_plyShop:getWidgetByName("Image_Talk"), "ImageView")
	if m_pimgTalk == nil then
		print("m_pimgTalk is nil")
		return false
	else
		-- m_pimgTalk:setVisible(false)
		RunTalkAction(9)
	end


	local pImageHead = tolua.cast(m_plyShop:getWidgetByName("Image_8"), "ImageView")
	if pImageHead==nil then
		print("pImageHead is nil")
		return false
	else
		pImageHead:setTouchEnabled(true)
		pImageHead:addTouchEventListener(_ImageHead_MallLayer_CallBack)
	end
	local pathHead = GetShopHeadPath(m_nShopType)
	-- pImageHead:loadTexture(pathHead)
	local Animation11,Animation12 = GetAnimationAction(m_nShopType)
		CommonInterface.GetAnimationByName(Animation11, 
			Animation12, 
			"Animation1", 
			pImageHead, 
			ccp(10, -15),
			nil,
			10)
	return true
end

function CreateShopLayer(nShopId)
	
	InitVars()

	m_plyShop = TouchGroup:create()									-- 背景层
    m_plyShop:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/ShopLayer.json") )
    local s_ShopID = server_shopDB.GetCopyTableShopID()
    m_nShopId = s_ShopID
    local s_shopType = server_shopDB.GetShopType()
    m_nShopType = s_shopType
    m_nLeftRefreshCount = GetRefreshCount(m_nShopId)

    if InitWidgets()==false then
    	return
    end
	m_tab_NeedUpdate = {}
   	--将主界面按钮重新加载一次
   	if nShopId == 1  or nShopId == 4 then
	    local pMainBtns = MainBtnLayer.createMainBtnLayer()
	    m_plyShop:addChild(pMainBtns, layerMainBtn_Tag, layerMainBtn_Tag)
	    local pBarManager = MainScene.GetBarManager()
		if pBarManager~=nil then
			pBarManager:Create(m_plyShop,CoinInfoBarManager.EnumLayerType.EnumLayerType_Shop)
		end
	elseif nShopId == 2 then
		local pBarManager = MainScene.GetBarManager()
		if pBarManager~=nil then
			pBarManager:Create(m_plyShop,CoinInfoBarManager.EnumLayerType.EnumLayerType_ShopBiWu) --EnumLayerType_Biwu
		end
	end
    
    UpadateShopItem(m_nShopId)


	return m_plyShop
end

function SetLeftRefreshCount( nCount )
	m_nLeftRefreshCount = nCount
end

local function AddGuide( n_ShopItemwidget )
	--指引点击效果
	if n_ShopItemwidget == nil then
		m_selectedID = 0
		return
	end
	if n_ShopItemwidget:getNodeByTag(1990) ~= nil then
		n_ShopItemwidget:getNodeByTag(1990):removeFromParentAndCleanup(true)
	end

	local GuideAnimation = CommonData.g_GuildeManager:GetGuildeAni()
	GuideAnimation:setPosition(ccp(0, 0))

	n_ShopItemwidget:addNode(GuideAnimation, 1990, 1990)

end

function ShowShopLayers( nShopId ,typeID  )
	local nShopTypeID = tonumber(nShopId)
	m_selectedID = typeID
	local function OpenShop()
		NetWorkLoadingLayer.loadingHideNow()
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerShopTag)
		if temp == nil then
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			local pLayerShop = CreateShopLayer(nShopTypeID)
			scenetemp:addChild(pLayerShop,layerShopTag,layerShopTag)
			MainScene.PushUILayer(pLayerShop)
			
			AddGuide(n_ShopItem)
		else
			print("已经是商店界面了")
		end
	end
	Packet_GetShopList.SetSuccessCallBack(OpenShop)
	network.NetWorkEvent(Packet_GetShopList.CreatPacket(nShopTypeID))
	NetWorkLoadingLayer.loadingShow(true)

	
end
