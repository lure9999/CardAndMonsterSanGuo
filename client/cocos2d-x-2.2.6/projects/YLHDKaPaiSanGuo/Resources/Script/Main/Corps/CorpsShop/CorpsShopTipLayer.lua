module("CorpsShopTipLayer", package.seeall)

local m_pPiliangLayer     = nil

local function SetLabelNumAndPrice( nType, pImgCoinIcon, pLabelNum, nCurNumber, pLabelPrice, nNowPrice, nShopID, nItemID )
	if nType==0 then
	    local tabTradeData = ShopLogic.GetTradeData(nShopID, nItemID, nCurNumber, nNowPrice)
	 --    if tabTradeData.Enough==false then
	 --    	createTimeLayer(ShopLogic.GetTradeTipInfo(tabTradeData.CoinType), 2)
		-- end
	    pLabelPrice:setText(tabTradeData.TotalPrice)
	    --nCurNumber = tabTradeData.Count
		pImgCoinIcon:loadTexture(tabTradeData.CoinIcon)
	end
	pLabelNum:setText(tostring(nCurNumber))
end

-- nType == 0 为批量购买 == 1 为批量使用
function createPiLiangLayer(nType, nTempId, nHave, nUse, nShopID, nItemID, nNowPrice ,callbackFun,imgPath)

	if m_pPiliangLayer == nil then
		m_pPiliangLayer = TouchGroup:create()									-- 背景层
	    m_pPiliangLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/PiLiangLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_pPiliangLayer, layerTip_Tag, layerTip_Tag)
	end

    local Label_title = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_title"), "Label")
    local Label_NameBg = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_10"), "ImageView")
    local Label_NumBg = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_6"), "ImageView")
    local ItemBg = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_1"), "ImageView")

    local Label_Item_name = Label:create()
    Label_Item_name:setFontSize(20)
    Label_Item_name:setFontName(CommonData.g_FONT3)
    Label_Item_name:setPosition(ccp(0,0))
    Label_NameBg:addChild(Label_Item_name,1)

    local Label_num_01 = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_num_01"), "Label")
    local Label_num_02 = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_num_02"), "Label")
    local Label_02 = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_02"), "Label")
   	local Image_Coin = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_Coin"), "ImageView")
    --local Label_desc = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_desc"), "Label")

    local Label_desc = Label:create()
    Label_desc:setFontSize(18)
    Label_desc:setColor(ccc3(49,31,21))
    Label_desc:setFontName(CommonData.g_FONT3)
    Label_desc:setPosition(ccp(35,11))
    ItemBg:addChild(Label_desc,1)

    local Label_number = Label:create()
    Label_number:setFontSize(26)
    Label_number:setFontName(CommonData.g_FONT3)
    Label_number:setPosition(ccp(0,0))
    Label_NumBg:addChild(Label_number,1)
   	Label_number:setText("1")

    Label_title:setVisible(false)
    local label_btnOk_text = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
    local Image_Icon = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_Icon"), "ImageView")

    UIInterface.MakeHeadIcon(Image_Icon, ICONTYPE.ITEM_ICON, nTempId, nil)

	if nType == 0 then

    	Label_title:setText("批量购买")
		Label_02:setText("总价:")
		Label_desc:setVisible(true)
		local desc_item = item.getFieldByIdAndIndex(nTempId,"des")
		Label_desc:setText(desc_item)
		LabelLayer.setText(label_btnOk_text, "购买")
		Image_Coin:setVisible(true)
		if imgPath~=nil then
			Image_Coin:loadTexture(imgPath)
		end
    else
    	Label_number:setText("1")
    	Label_title:setText("批量使用")
		Label_desc:setVisible(false)
		Image_Coin:setVisible(false)
		Label_num_02:setPosition(ccp(35, 51))
		if nType==1 then
			LabelLayer.setText(label_btnOk_text, "确定")
			Label_02:setText("可使用:")
		elseif nType==2 then
			LabelLayer.setText(label_btnOk_text, "出售")
			Label_02:setText("可出售:")
		end
	end

	local name_item = item.getFieldByIdAndIndex(nTempId,"name")
	Label_Item_name:setText(name_item)
	Label_num_01:setText(nHave)
	if nType~=0 then
		Label_num_02:setText(nUse)
	else
		Label_num_02:setText(nNowPrice)
	end

    local Image_1 = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_1"), "ImageView")
    Image_1:setScale(0)
	local actionArray1 = CCArray:create()
	actionArray1:addObject(CCScaleTo:create(0.2, 1.2))
	actionArray1:addObject(CCScaleTo:create(0.1, 1))
	Image_1:runAction(CCSequence:create(actionArray1))

	local function _Ok_Btn_CallBack()
		if callbackFun ~= nil then
			callbackFun(tonumber(Label_number:getStringValue()))
		end
		m_pPiliangLayer:setVisible(false)
		m_pPiliangLayer:removeFromParentAndCleanup(true)
		m_pPiliangLayer = nil
	end
    local Button_Ok = tolua.cast(m_pPiliangLayer:getWidgetByName("Button_OK"), "Button")
    Button_Ok:addChild(label_btnOk_text)
    CreateBtnCallBack(Button_Ok, nil, nil, _Ok_Btn_CallBack)

	local function _Add_Btn_CallBack()
  		local nCurNumber = GetCurNum(Label_number, nUse, 1)
  		Label_number:setText(tostring(nCurNumber))
	    SetLabelNumAndPrice(nType, Image_Coin, Label_number, nCurNumber, Label_num_02, nNowPrice, nShopID, nItemID)
	end

	local Button_add = tolua.cast(m_pPiliangLayer:getWidgetByName("Button_add"), "Button")
    CreateBtnCallBack(Button_add, nil, nil, _Add_Btn_CallBack)

	local function _Sub_Btn_CallBack()
		local nCurNumber = GetCurNum(Label_number, nUse, -1)
		Label_number:setText(tostring(nCurNumber))
		SetLabelNumAndPrice(nType, Image_Coin, Label_number, nCurNumber, Label_num_02, nNowPrice, nShopID, nItemID)
	end

	local Button_sub = tolua.cast(m_pPiliangLayer:getWidgetByName("Button_sub"), "Button")
    CreateBtnCallBack(Button_sub, nil, nil, _Sub_Btn_CallBack)

	local function _Sub_Ten_Btn_CallBack()
		local nCurNumber = GetCurNum(Label_number, nUse, -10)
		Label_number:setText(tostring(nCurNumber))
	    SetLabelNumAndPrice(nType, Image_Coin, Label_number, nCurNumber, Label_num_02, nNowPrice, nShopID, nItemID)
	end

	local Button_sub_ten = tolua.cast(m_pPiliangLayer:getWidgetByName("Button_sub_ten"), "Button")
    CreateBtnCallBack(Button_sub_ten, nil, nil, _Sub_Ten_Btn_CallBack)

	local function _Add_Ten_Btn_CallBack()
		local nCurNumber = GetCurNum(Label_number, nUse, 10)
		Label_number:setText(tostring(nCurNumber))
		SetLabelNumAndPrice(nType, Image_Coin, Label_number, nCurNumber, Label_num_02, nNowPrice, nShopID, nItemID)
	end

    local Button_add_ten = tolua.cast(m_pPiliangLayer:getWidgetByName("Button_add_ten"), "Button")
    CreateBtnCallBack(Button_add_ten, nil, nil, _Add_Ten_Btn_CallBack)

	local function _Close_Btn_CallBack()
		m_pPiliangLayer:setVisible(false)
		m_pPiliangLayer:removeFromParentAndCleanup(true)
		m_pPiliangLayer = nil
	end
    local Button_Close = tolua.cast(m_pPiliangLayer:getWidgetByName("Button_close"), "Button")
    CreateBtnCallBack(Button_Close, nil, nil, _Close_Btn_CallBack)
    --CommonInterface.MakeUIToCenter(m_pPiliangLayer)
end