
module("TipLayer", package.seeall)

local layerOkLayer = nil 	--带确定按扭的提示界面
local m_pPiliangLayer = nil -- 批量购买和批量使用界面
local m_pOk_CancelLayer = nil -- 带确定和取消按扭的界面
local m_pMailContentLayer = nil  --邮件正文的界面
local m_pGamerInfoLayer = nil    --玩家信息的界面
local m_pPataBoxLayer = nil    --爬塔每层奖励界面

TAG_LABLE_ROW1 = 1
TAG_LABLE_ROW2 = 2

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()	
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

function createTimeLayer(strText, lifeTime)
	lifeTime = 1
	local pBack = nil
	local pText = nil
	local pText_01 = nil
	-- 可 = 3
	local playerTimeLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(playerTimeLayer, layerTip_Tag, layerTip_Tag)
	--[[print(string.len("{}"))
	print(string.len("123"))
	print(string.len("adb"))
	print(string.len("!"))
	print(string.len(strText))]]--

	local n = 0
	local i = 0
	while true do
	     i = string.find(strText, "%w", i+1)
	     if i == nil then break end
	     n = n + 1
	end
	i = 0
	while true do
	     i = string.find(strText, "%p", i+1)
	     if i == nil then break end
	     n = n + 1
	end
	if string.len(strText) > 30+n then
		pBack = CCSprite:create("Image/imgres/common/tip_bk_02.png")
		--strText = "在在在要要工工人222212夺在苛44"

		local str_01 = nil
		local str_02 = nil
		if n ~= 0 then
			str_01 = string.sub(strText, 0, 30 - n*3 + n)
			str_02 = string.sub(strText, 30 - n*3 + n+1)
		else
			str_01 = string.sub(strText, 0, 30)
			str_02 = string.sub(strText, 30+1)
		end

		pText = CCLabelTTF:create()
		pText:setFontSize(24)
		pText:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2+20))
		pText:setString(str_01)

		pText_01 = CCLabelTTF:create()
		pText_01:setFontSize(24)
		pText_01:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2-20))
		pText_01:setString(str_02)

	else
		pBack = CCSprite:create("Image/imgres/common/tip_bk_01.png")
		pText = CCLabelTTF:create()
		pText:setFontSize(24)
		pText:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2))
		pText:setString(strText)

	end
	pBack:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2))
	playerTimeLayer:addChild(pBack)
	
	if pText ~= nil then
		playerTimeLayer:addChild(pText)
	end
	if pText_01 ~= nil then
		playerTimeLayer:addChild(pText_01)
	end

	local function DeleteSelf()
		
        playerTimeLayer:setVisible(false)
        playerTimeLayer:removeFromParentAndCleanup(true)
        playerTimeLayer = nil
	end

	local function hideBg_callback()
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(1, ccp(0, 200)))
		--actionArray1:addObject(CCScaleTo:create(1, 0.3))
		pBack:runAction(CCSpawn:create(actionArray1))
	end

	local function hideT_01_callback()
		
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(1, ccp(0, 200)))
		--actionArray1:addObject(CCScaleTo:create(1, 0.3))
		pText:runAction(CCSpawn:create(actionArray1))
	end

	local function hideT_02_callback()
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(1, ccp(0, 200)))
		--actionArray1:addObject(CCScaleTo:create(1, 0.3))
		pText_01:runAction(CCSpawn:create(actionArray1))
	end
	pBack:setScale(0.7)
	local actionArray1 = CCArray:create()
	actionArray1:addObject(CCScaleTo:create(0.1, 1.2))
	actionArray1:addObject(CCScaleTo:create(0.1, 1))
	actionArray1:addObject(CCDelayTime:create(lifeTime))
	actionArray1:addObject(CCCallFunc:create(hideBg_callback))
	actionArray1:addObject(CCFadeOut:create(1))
	actionArray1:addObject(CCDelayTime:create(2))
	actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
	pBack:stopAllActions()
	pBack:setOpacity(255)
	pBack:runAction(CCSequence:create(actionArray1))

	if pText ~= nil then
		pText:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.1, 1))
		actionArray2:addObject(CCDelayTime:create(lifeTime))
		actionArray2:addObject(CCCallFunc:create(hideT_01_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end

	if pText_01 ~= nil then
		pText_01:setScale(0.7)
		local actionArray3 = CCArray:create()
		actionArray3:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray3:addObject(CCScaleTo:create(0.1, 1))
		actionArray3:addObject(CCDelayTime:create(lifeTime))
		actionArray3:addObject(CCCallFunc:create(hideT_02_callback))
		actionArray3:addObject(CCFadeOut:create(1))
		pText_01:stopAllActions()
		pText_01:setOpacity(255)
		pText_01:runAction(CCSequence:create(actionArray3))
	end

    CommonInterface.MakeUIToCenter(playerTimeLayer)
end
-- 冒字提示
function createPopTipLayer(strText, size, color, pos)

	local pText = nil
	local pPopTipLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(pPopTipLayer, layerTip_Tag, layerTip_Tag)

	--[[pText = CCLabelTTF:create()
	pText:setPosition(pos)
	pText:setString(strText)
	pText:setColor(color)
	pText:setFontSize(size)
	pText:setFontName(CommonData.g_FONT1)]]--
	pText = LabelLayer.createStrokeLabel(size,CommonData.g_FONT1,strText,pos,COLOR_Black,color,false,ccp(0,-2),2)
	if pText ~= nil then
		pPopTipLayer:addChild(pText)
	end

	local function DeleteSelf()
        pPopTipLayer:setVisible(false)
        pPopTipLayer:removeFromParentAndCleanup(true)
        pPopTipLayer = nil
	end

	local function hide_callback()
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(1, ccp(0, 200)))
		--actionArray1:addObject(CCScaleTo:create(1, 0.3))
		actionArray1:addObject(CCDelayTime:create(1))
		actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
		pText:runAction(CCSequence:create(actionArray1))
	end

	if pText ~= nil then
		pText:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.1, 1))
		actionArray2:addObject(CCDelayTime:create(0.2))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end

    --CommonInterface.MakeUIToCenter(pPopTipLayer)
end

-- 冒字提示扩展 add by js
function createPopTipLayerAugment(strText, size, color, pos, moveTime, UpSize, bStorke, bAnchor)

	local pUpSize = 200

	local pMoveTime = 1

	if moveTime ~= nil then
		pMoveTime = moveTime
	end	

	if UpSize ~= nil then
		pUpSize = UpSize
	end

	local pText = nil
	local pPopTipLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(pPopTipLayer, layerTip_Tag, layerTip_Tag)

	if bStorke == true then
		pText = LabelLayer.createStrokeLabel(size,CommonData.g_FONT1,strText,pos,COLOR_Black,color,false,ccp(0,-2),2)
	else
		pText = CCLabelTTF:create()
		pText:setPosition(pos)
		pText:setColor(color)
		pText:setFontSize(size)
		pText:setFontName(CommonData.g_FONT1)
		pText:setString(strText)
	end

	if bAnchor == true then
		pText:setAnchorPoint(ccp(0.5,0.5))
	end
	
	if pText ~= nil then
		pPopTipLayer:addChild(pText)
	end

	local function DeleteSelf()
        pPopTipLayer:setVisible(false)
        pPopTipLayer:removeFromParentAndCleanup(true)
        pPopTipLayer = nil
	end

	local function hide_callback()
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(pMoveTime, ccp(0, pUpSize)))
		actionArray1:addObject(CCDelayTime:create(1))
		actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
		pText:runAction(CCSequence:create(actionArray1))
	end

	if pText ~= nil then
		pText:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.1, 1))
		actionArray2:addObject(CCDelayTime:create(0.2))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end

    --CommonInterface.MakeUIToCenter(pPopTipLayer)
end

function createPopTipLayerValue(strText, size, color, pos, moveTime, UpSize, bStorke, bAnchor,nValue)

	local pUpSize = 200

	local pMoveTime = 1

	if moveTime ~= nil then
		pMoveTime = moveTime
	end	
	if UpSize ~= nil then
		pUpSize = UpSize
	end
	if nValue ~= nil then
		if tonumber(nValue) < 0 then
			color = ccc3(255,0,0)
		else
			color = COLOR_Green
		end
	end
	local visible_Size = CCDirector:sharedDirector():getVisibleSize()
	local pText = nil
	local pPopTipLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(pPopTipLayer, layerTip_Tag, layerTip_Tag)

	if bStorke == true then
		pText = LabelLayer.createStrokeLabel(size,CommonData.g_FONT1,strText,pos,COLOR_Black,color,false,ccp(0,-2),2)
	else
		pText = CCLabelTTF:create()
		pText:setPosition(pos)
		pText:setColor(color)
		pText:setFontSize(size)
		pText:setFontName(CommonData.g_FONT1)
		pText:setString(strText)
	end

	if bAnchor == true then
		pText:setAnchorPoint(ccp(0.5,0.5))
	end
	
	if pText ~= nil then
		pPopTipLayer:addChild(pText)
	end

	local function DeleteSelf()
        pPopTipLayer:setVisible(false)
        pPopTipLayer:removeFromParentAndCleanup(true)
        pPopTipLayer = nil
	end

	local function hide_callback()
		local actionArray1 = CCArray:create()
		-- actionArray1:addObject(CCMoveBy:create(pMoveTime, ccp(0, pUpSize)))
		local action1 = CCMoveBy:create(pMoveTime, ccp(0, pUpSize))
		local action2 = CCFadeOut:create(0.1)
		local action3 = CCSpawn:createWithTwoActions(action1,action2)
		actionArray1:addObject(action3)
		-- actionArray1:addObject(CCDelayTime:create(0.5))

		actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
		pText:runAction(CCSequence:create(actionArray1))
	end

	if pText ~= nil then
		pText:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.1, 1))
		actionArray2:addObject(CCDelayTime:create(0.5))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end

    --CommonInterface.MakeUIToCenter(pPopTipLayer)
end

--[[
function callback( )
	print("callback")
end
TipLayer.createOkTipLayer("33333333333333333", callback)
--]]

function createOkTipLayer(strText, callbackFun)
	if layerOkLayer == nil then
		layerOkLayer = TouchGroup:create()									-- 背景层
	    layerOkLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/OkTipLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(layerOkLayer, layerTip_Tag, layerTip_Tag)
	end
    local Label_Text = tolua.cast(layerOkLayer:getWidgetByName("Label_Text"), "Label")
	if Label_Text~=nil then
		Label_Text:setText(strText)
	end
    local Image_1 = tolua.cast(layerOkLayer:getWidgetByName("Image_1"), "ImageView")
    Image_1:setScale(0)
	Image_1:runAction(CCScaleTo:create(0.5, 1))
	local function _Ok_Btn_CallBack()
		layerOkLayer:setVisible(false)
		layerOkLayer:removeFromParentAndCleanup(true)
		layerOkLayer = nil
		if callbackFun ~= nil then
			callbackFun()
			callbackFun =nil
		end
	end
    local Button_Ok = tolua.cast(layerOkLayer:getWidgetByName("Button_Ok"), "Button")
   -- Button_Ok:addTouchEventListener(_Ok_Btn_CallBack)
   CreateBtnCallBack(Button_Ok, "确定", 36, _Ok_Btn_CallBack)
	local function _Close_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
	        layerOkLayer:setVisible(false)
	        layerOkLayer:removeFromParentAndCleanup(true)
	        layerOkLayer = nil
		end
	end
    local Button_Close = tolua.cast(layerOkLayer:getWidgetByName("Button_Close"), "Button")
    Button_Close:addTouchEventListener(_Close_Btn_CallBack)
    --CommonInterface.MakeUIToCenter(layerOkLayer)
end

function createOk_Cancel_TipLayer(strText, callbackFun)
	if m_pOk_CancelLayer == nil then
		m_pOk_CancelLayer = TouchGroup:create()									-- 背景层
	    m_pOk_CancelLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/TipLayerOk_CancelLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_pOk_CancelLayer, layerTip_Tag, layerTip_Tag)
	end

    local Label_Text = tolua.cast(m_pOk_CancelLayer:getWidgetByName("Label_Text"), "Label")
    Label_Text:setText(strText)

    local Image_1 = tolua.cast(m_pOk_CancelLayer:getWidgetByName("Image_1"), "ImageView")
    Image_1:setScale(0)
	local actionArray1 = CCArray:create()
	actionArray1:addObject(CCScaleTo:create(0.2, 1.2))
	actionArray1:addObject(CCScaleTo:create(0.1, 1))
	Image_1:runAction(CCSequence:create(actionArray1)) 

	local function _Ok_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
	        m_pOk_CancelLayer:setVisible(false)
	        m_pOk_CancelLayer:removeFromParentAndCleanup(true)
	        m_pOk_CancelLayer = nil
	        if callbackFun ~= nil then
	        	callbackFun()
	        end
		end
	end
    local Button_Ok = tolua.cast(m_pOk_CancelLayer:getWidgetByName("Button_Ok"), "Button")
    Button_Ok:addTouchEventListener(_Ok_Btn_CallBack)

	local function _Cancel_Btn_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
	        m_pOk_CancelLayer:setVisible(false)
	        m_pOk_CancelLayer:removeFromParentAndCleanup(true)
	        m_pOk_CancelLayer = nil
		end
	end
    local Button_Cancel = tolua.cast(m_pOk_CancelLayer:getWidgetByName("Button_Cancel"), "Button")
    Button_Cancel:addTouchEventListener(_Cancel_Btn_CallBack)

    --CommonInterface.MakeUIToCenter(m_pOk_CancelLayer)
end

local function GetCurNum( pLabelNum, nMax, nAddNum )
	local nCurNumber = tonumber(pLabelNum:getStringValue())
	if nCurNumber>0 and nCurNumber <= tonumber(nMax) then
		nCurNumber = nCurNumber + nAddNum
		if nCurNumber>nMax then
			nCurNumber = nMax
		end

		if nCurNumber<1 then
			nCurNumber = 1
		end
	end
	return nCurNumber
end

local function SetLabelNumAndPrice( nType, pImgCoinIcon, pLabelNum, nCurNumber, pLabelPrice, nNowPrice, nShopID, nItemID )
	
	if nType==0 then
	    local tabTradeData = ShopLogic.GetTradeData(nShopID, nItemID, nCurNumber, nNowPrice)
	    -- printTab(tabTradeData)
	    -- Pause()
	    --[[if tabTradeData.Enough==false then
	    	createTimeLayer(ShopLogic.GetTradeTipInfo(tabTradeData.CoinType), 2)
		end]]--
	    pLabelPrice:setText(tabTradeData.TotalPrice)
	    --nCurNumber = tabTradeData.Count
		pImgCoinIcon:loadTexture(tabTradeData.CoinIcon)
	end
	pLabelNum:setText(tostring(nCurNumber))
end
function GetGuideTipsOK()
	return layerOkLayer
end
function DeleteGuideTipsOK()
	if layerOkLayer~=nil then
		layerOkLayer:setVisible(false)
		layerOkLayer:removeFromParentAndCleanup(true)
		layerOkLayer = nil
	end
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
    local img_botm = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_12"),"ImageView")
    local img_btomUp = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_11"),"ImageView")
    img_botm:setScaleX(1.2)
    img_btomUp:setScaleX(1.2)
	
	local Label_Item_name = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_Item_name"), "Label")

    --[[local Label_Item_name = Label:create()
    Label_Item_name:setFontSize(20)
    Label_Item_name:setFontName(CommonData.g_FONT3)
    Label_Item_name:setPosition(ccp(0,0))
    Label_NameBg:addChild(Label_Item_name,1)]]--

    local Label_num_01 = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_num_01"), "Label")
    local Label_num_02 = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_num_02"), "Label")
    local Label_02 = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_02"), "Label")
   	local Image_Coin = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_Coin"), "ImageView")
    local Label_desc = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_desc"), "Label")
	local Label_number = tolua.cast(m_pPiliangLayer:getWidgetByName("Label_number"), "Label")
	Label_num_02:setColor(ccc3(255,255,255))
   --[[ local Label_desc = Label:create()
    Label_desc:setFontSize(18)
    Label_desc:setColor(ccc3(49,31,21))
    Label_desc:setFontName(CommonData.g_FONT3)
    Label_desc:setPosition(ccp(35,11))
    ItemBg:addChild(Label_desc,1)]]--

    --[[local Label_number = Label:create()
    Label_number:setFontSize(26)
    Label_number:setFontName(CommonData.g_FONT3)
    Label_number:setPosition(ccp(0,0))
    Label_NumBg:addChild(Label_number,1)
   	Label_number:setText("1")]]--
	Label_number:setText("1")
    Label_title:setVisible(false)
    local label_btnOk_text = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
    local Image_Icon = tolua.cast(m_pPiliangLayer:getWidgetByName("Image_Icon"), "ImageView")
    UIInterface.MakeHeadIcon(Image_Icon, ICONTYPE.ITEM_ICON, nTempId, nil)

	if nType == 0 then
		local tabConditoin = ShopData.GetItemData(nShopID,nItemID)
    	Label_title:setText("批量购买")
		Label_02:setText("总价:")
		Label_desc:setVisible(true)
		local desc_item = item.getFieldByIdAndIndex(nTempId,"des")
		Label_desc:setText(desc_item)
		LabelLayer.setText(label_btnOk_text, "购买")
		Image_Coin:setVisible(true)
		if imgPath~=nil then
			if tonumber(tabConditoin[1][5]) > 100 then
				Image_Coin:loadTexture(imgPath)
				Image_Coin:setScale(0.3)
			else
				Image_Coin:loadTexture(imgPath)
			end
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
		--修改为 不显示可使用和可出售
		img_botm:setVisible(false)
		Label_02:setVisible(false)
		Label_num_02:setVisible(false)
		
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
			callbackFun(tonumber(Label_number:getStringValue()),tonumber(nNowPrice))
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

local function CreateMailItemWidget( pMailItemTemp )
    local pMailItem = pMailItemTemp:clone()
    local peer = tolua.getpeer(pMailItemTemp)
    tolua.setpeer(pMailItem, peer)
    return pMailItem
end

--add ZJS 150422 mail Content
function createMailContentLayer( mailContent , mailTag ,mailRewardContent, receiveCallfunc)
	if m_pMailContentLayer == nil then
		m_pMailContentLayer = TouchGroup:create()									-- 背景层
	    m_pMailContentLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MailContentLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_pMailContentLayer, layerTip_Tag, layerTip_Tag)
	end
	local function _Reward_Return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			--判断邮件类型
			receiveCallfunc(mailContent,false)
			m_pMailContentLayer:setVisible(false)
			m_pMailContentLayer:removeFromParentAndCleanup(true)
			m_pMailContentLayer = nil
		end
	end
	local m_pMailContentBg = tolua.cast(m_pMailContentLayer:getWidgetByName("MailContent_Bg"),"ImageView")
	local m_pMailContentMaskBg = tolua.cast(m_pMailContentLayer:getWidgetByName("MailContent_MaskBg"),"ImageView")
	local m_pMailContentList = tolua.cast(m_pMailContentLayer:getWidgetByName("MailContent_TextList"),"ListView")
	if m_pMailContentList ~= nil then m_pMailContentList:setClippingType(1) end
	m_pMailContentMaskBg:setTouchEnabled(true)
	m_pMailContentMaskBg:addTouchEventListener(_Reward_Return_CallBack)
	m_pMailContentBg:setPosition(ccp(578,305))
	m_pMailContentBg:setAnchorPoint(ccp(0.5,0.5))
	--m_pMailContentBg:setOpacity(0)

	local function _Child_Visiable()
		m_pMailContentBg:setScale(0)
	end

	local actionArray1 = CCArray:create()
	actionArray1:addObject(CCCallFunc:create(_Child_Visiable))
	actionArray1:addObject(CCScaleTo:create(0.2, 1.2))
	actionArray1:addObject(CCScaleTo:create(0.1, 1))
	m_pMailContentBg:runAction(CCSequence:create(actionArray1))

	local btnText,isReward
	if mailContent["hasReward"] == 1 then 
		btnText = "领取"
		isReward = true
	else
		btnText = "关闭"
		isReward = false
	end

	local function _Close_Btn_CallBack()
		local function sendReceiveRequest(  )
			NetWorkLoadingLayer.loadingHideNow()
			if isReward == true then
				if receiveCallfunc ~= nil then
					receiveCallfunc(mailContent,true)
				end	
			end
		end
		if isReward == true then
		--关闭邮件后，有附件的邮件直接删除，无附件的邮件状态变为已读，并且刷新邮件页面
			NetWorkLoadingLayer.loadingShow(true)
			Packet_GetMailReward.SetSuccessCallBack(sendReceiveRequest)
			network.NetWorkEvent(Packet_GetMailReward.CreatPacket(mailContent["ID"]))
		else
			m_pMailContentLayer:setVisible(false)	
			receiveCallfunc(mailContent,true)	
		end
			m_pMailContentLayer:removeFromParentAndCleanup(true)
			m_pMailContentLayer = nil		
	end
    local Button_Close = tolua.cast(m_pMailContentBg:getChildByName("MailContent_Btn"), "Button")
    CreateBtnCallBack(Button_Close, nil, nil, _Close_Btn_CallBack)

	local pMailContentTitle = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, mailContent["Title"], ccp(0, 195), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	local pMailContentBtnText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, btnText, ccp(3, 4), COLOR_Black, COLOR_White, true, ccp(0, -2), 3)
	m_pMailContentBg:addChild(pMailContentTitle,2,1000)
	Button_Close:addChild(pMailContentBtnText,2,1000)

	--取得邮件内容list和背景
	local m_pMailContentTextBg = tolua.cast(m_pMailContentBg:getChildByName("MailContent_TextBg"),"ImageView")

	--创建富文本
	require "Script/Common/RichLabel"
	local mailContent_Text = RichLabel.Create(mailContent["Content"],380)
	local size = mailContent_Text:getContentSize()
	mailContent_Text:setSize(CCSizeMake(size.width,size.height))
	m_pMailContentList:pushBackCustomItem(mailContent_Text)

	--发件人
	local pMailSender = Label:create()
	pMailSender:setFontSize(18)
	pMailSender:setContentSize(CCSizeMake(380,pMailSender:getContentSize().width))
	pMailSender:setAnchorPoint(ccp(0,0))
	pMailSender:setColor(ccc3(255,233,172))
	pMailSender:setText(mailContent["SenderName"])

	local nSenderBg = Layout:create()
	nSenderBg:setBackGroundColor(ccc3(50,50,50))
	nSenderBg:setSize(CCSizeMake(380,pMailSender:getContentSize().height))

	if isReward == true then 
		pMailSender:setPosition(ccp(mailContent_Text:getContentSize().width - pMailSender:getContentSize().width,0))
		nSenderBg:addChild(pMailSender)
		m_pMailContentList:pushBackCustomItem(nSenderBg)
	else
		pMailSender:setPosition(ccp(m_pMailContentTextBg:getSize().width * 0.5 - pMailSender:getContentSize().width - 40,-m_pMailContentTextBg:getSize().height * 0.5 + 20))
		m_pMailContentTextBg:addChild(pMailSender,200)		
	end
	
	--如果邮件有奖励的话
	if isReward == true then 
		local pMailContentRewardWidgetTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MailRewardLayer.json")
		local pMailContentRewardWidget = CreateMailItemWidget(pMailContentRewardWidgetTemp)
		m_pMailContentList:pushBackCustomItem(pMailContentRewardWidget)
		--货币奖励
		local coinImg_1 = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_1"), "ImageView")
		local coinImg_2 = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_2"), "ImageView")
		local coinImg_3 = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_3"), "ImageView")
		local coinImg_4 = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_4"), "ImageView")
		local coinImg_5 = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_5"), "ImageView")
		coinImg_1:setVisible(false)
		coinImg_2:setVisible(false)
		coinImg_3:setVisible(false)
		coinImg_4:setVisible(false)
		coinImg_5:setVisible(false)

		local function loadCoinImgAndShow( imgPath , index, num)
			local coinImg = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_"..index), "ImageView")
			local pcoinText = CreateLabel(num,20,COLOR_White,CommonData.g_FONT3,ccp(coinImg:getPositionX() + 80, coinImg:getPositionY()))
			coinImg:loadTexture(imgPath)
			coinImg:setVisible(true)
			pMailContentRewardWidget:addChild(pcoinText)
		end
		require "Script/Main/Mail/MailData"
		local rewardCoin = mailRewardContent["coin"]
		local rewardItem = mailRewardContent["item"]
		local isSplite = true
		for key,value in pairs(rewardCoin) do
			if value[1] > 0 then
				local nCoinResID = coin.getFieldByIdAndIndex(value[1], "ResID")
				local imgPath = MailData.GetItemHeadIcon(nCoinResID)
				loadCoinImgAndShow(imgPath,key,value[2])
				isSplite = false
			end
		end
		if isSplite == true then 
			local Reward_Title = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_Title"), "Label")
			local Reward_Line = tolua.cast(pMailContentRewardWidget:getChildByName("Reward_Line"), "ImageView")
			Reward_Title:setPositionY(25)
			Reward_Line:setPositionY(10)
			pMailContentRewardWidget:setSize(CCSizeMake(420, 50))
		end
		--道具奖励
		local pMailRewardItemWidgetTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MailRewardItemLayer.json")
		local pMailRewardItemLayoutTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MailRewardItemLayout.json")

		--确认需要几个layout来存储奖励item
		local itemNum = table.getn(rewardItem)
		local layoutNum = 0
		if itemNum >= 4 then 
			if itemNum % 4 == 0 then
				--奖励数目能被4整除
				layoutNum = itemNum / 4
			else
				layoutNum = math.floor((itemNum / 4)) + 1
			end
		else
			layoutNum = 1
		end

		local layoutArray = CCArray:create()
		for i=1,layoutNum do
			local itemLayout = CreateMailItemWidget(pMailRewardItemLayoutTemp)
			layoutArray:addObject(itemLayout)
		end

		local function InsertRewardItem( path, key, Id, num ,parent)	
			local pMailRewardItemWidget = CreateMailItemWidget(pMailRewardItemWidgetTemp)
			local pMailRewardItemPanel = tolua.cast(pMailRewardItemWidget:getChildByName("MailRewardItemBg"), "ImageView")	
			local pMailRewardItemFrame = tolua.cast(pMailRewardItemWidget:getChildByName("MailRewardItemFrame"), "ImageView")
			local pMailRewardItem = tolua.cast(pMailRewardItemPanel:getChildByName("Image_RewardItem"), "ImageView") 
			pMailRewardItem:loadTexture(path)
			pMailRewardItemWidget:setPosition(ccp(15 + 95 * (key - 1) ,20))
			local pMailRewardItemNumLabel = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "X"..num, ccp(5, 12), COLOR_Black, COLOR_White, false, ccp(0, 0), 2)
			pMailRewardItemFrame:addChild(pMailRewardItemNumLabel,1)
			pMailRewardItemFrame:loadTexture("Image/imgres/common/color/wj_pz" .. MailData.GetItemPinZhi(Id) .. ".png")	
			parent:addChild(pMailRewardItemWidget)
		end

		local getItemNum = 0 			--奖励取值计数
		local getArrNum	= 0
		--add celina 2016.0203
		if #rewardItem ==0  then
			return 
		end
		for key,value in pairs(rewardItem) do	
			--每取4个item做一个奖励的layout
			if getItemNum < 4 then
				getItemNum = getItemNum + 1
			else
				getItemNum = 1
				getArrNum = getArrNum + 1
			end
			--[[
			print("getItemNum = "..getItemNum)
			print("key = "..key)
			print("getArrNum = "..getArrNum)
			--]]
			local itemLayout = layoutArray:objectAtIndex(getArrNum)
			local nItemResID = item.getFieldByIdAndIndex(value[1], "res_id")
			local imgPath = MailData.GetItemHeadIcon(nItemResID)
			InsertRewardItem(imgPath,getItemNum,value[1],value[2],itemLayout)
		end

		for i=1,layoutNum do
			local itemLayout = layoutArray:objectAtIndex(i-1)
			m_pMailContentList:pushBackCustomItem(itemLayout)
		end
	end
end

function createPataBoxLayer()
	if m_pPataBoxLayer ~= nil then
		m_pPataBoxLayer = nil
	end
	m_pPataBoxLayer = TouchGroup:create()									-- 背景层
    m_pPataBoxLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/PataBoxLayer.json") )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(m_pPataBoxLayer, layerTip_Tag, layerTip_Tag)
	
	local function _Reward_Return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			m_pPataBoxLayer:setVisible(false)
			m_pPataBoxLayer:removeFromParentAndCleanup(true)
			m_pPataBoxLayer = nil
			sender:setScale(1.0)
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end

	local Image_Bg        = tolua.cast(m_pPataBoxLayer:getWidgetByName("Image_Bg"), "ImageView")
	local ListViewBox	  =	tolua.cast(m_pPataBoxLayer:getWidgetByName("ListView_Box"), "ListView")
	local Btn_Return      = tolua.cast(m_pPataBoxLayer:getWidgetByName("Button_Close"), "Button")
	Btn_Return:addTouchEventListener(_Reward_Return_CallBack)
	local Label_TitleText =  LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "通天塔奖励", ccp(5, 220), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 3)
	Image_Bg:addChild(Label_TitleText,10)

	--添加每一层奖励
	if ListViewBox ~= nil then ListViewBox:setClippingType(1) end
	local MAIL_ADD_NUM = 4
	local MAIL_ADD_NUM_INSERT = 4
	local count_now_add = 0
	local count_now_begin = 1
	require "Script/Main/Pata/PataLogic"
	require "Script/Common/ItemTipLayer"
	local function _Image_RewardItem_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			ItemTipLayer.DeleteItemTipLayer()
		elseif eventType==TouchEventType.began then
			ItemTipLayer.CreateItemTipLayer(m_pPataBoxLayer, sender, TipType.Item, sender:getTag(), TipPosType.RightTop)
		elseif eventType==TouchEventType.canceled then
			ItemTipLayer.DeleteItemTipLayer()
		end
	end
	local function UpDataItem( pCurItem,nIndex )
		local layer = nIndex * 5
		local Label_TitleText =  LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "第"..layer.."层奖励", ccp(210, 125), COLOR_Black, COLOR_White, true, ccp(0, 0), 2)
		pCurItem:addChild(Label_TitleText)
		local tabReward = PataLogic.GetCurItemData(nIndex)
		for i=1,table.getn(tabReward) do
			local Image_Reward = tolua.cast(pCurItem:getChildByName("Image_Reward_"..i), "ImageView")
			local Image_Item   = tolua.cast(Image_Reward:getChildByName("Image_Reward"), "ImageView")
			local Image_Color = tolua.cast(Image_Reward:getChildByName("Image_Color"), "ImageView")
			local rewardData = PataLogic.GetRewardItemData(tabReward[i])
			Image_Item:loadTexture(rewardData.IconPath)
			Image_Color:loadTexture(rewardData.ItemColor)
			Image_Reward:setTag(tabReward[i])
			Image_Reward:setTouchEnabled(true)
			Image_Reward:addTouchEventListener(_Image_RewardItem_CallBack)
		end
	end
	local function GetActionArray(callback)
		local array_action = CCArray:create()
		array_action:addObject(CCDelayTime:create(0.5))
		array_action:addObject(CCCallFunc:create(callback))
		local action_list = CCSequence:create(array_action)
		array_action:removeAllObjects()
		array_action = nil 
		return action_list
	end	
	local function AddItemInList( nBeginIndex,nEndIndex )
		local pBoxItemWidgetTemp = GUIReader:shareReader():widgetFromJsonFile("Image/PataRewardItemLayer.json")
		for i=nBeginIndex,nEndIndex do
			local pItem = CreateMailItemWidget(pBoxItemWidgetTemp)
			UpDataItem(pItem,i)
			ListViewBox:pushBackCustomItem(pItem)
		end
	end
	local function RunAddItemAction( pAction ,AddItemCallBack )
		pAction:stopAllActions()
		count_now_add = 0
		AddItemCallBack(count_now_begin,MAIL_ADD_NUM)
		count_now_add = MAIL_ADD_NUM
		local function listCheckCallBack()
			pAction:stopAllActions()
			if 20 > count_now_add then
				if (count_now_add + MAIL_ADD_NUM_INSERT) > 20 then
					AddItemCallBack(count_now_add + 1,count_now_add + (20 - count_now_add))
				else
					AddItemCallBack(count_now_add + 1,(MAIL_ADD_NUM_INSERT + count_now_add))
					count_now_add = count_now_add + MAIL_ADD_NUM_INSERT
					pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
				end
			end
		end
		pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
	end
	RunAddItemAction(ListViewBox , AddItemInList)
end

function createPataLevelInfoLayer( nCurLayer ,nMonsterData )
	if m_pPataLevelInfoLayer == nil then
		m_pPataLevelInfoLayer = TouchGroup:create()									-- 背景层
	    m_pPataLevelInfoLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/PataLevelInfoLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_pPataLevelInfoLayer, layerTip_Tag, layerTip_Tag)
	end
	local function _Reward_Return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			m_pPataLevelInfoLayer:setVisible(false)
			m_pPataLevelInfoLayer:removeFromParentAndCleanup(true)
			m_pPataLevelInfoLayer = nil
			sender:setScale(1.0)
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
	local Image_Bg        = tolua.cast(m_pPataLevelInfoLayer:getWidgetByName("Image_Bg"), "ImageView")
	local Btn_Return      = tolua.cast(m_pPataLevelInfoLayer:getWidgetByName("Button_Close"), "Button")
	Btn_Return:addTouchEventListener(_Reward_Return_CallBack)
	local Label_TitleText =  LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "第"..nCurLayer.."层", ccp(5, 86), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 3)
	Image_Bg:addChild(Label_TitleText,10)
	--获取本层怪物信息
	local function _Image_Monster_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			ItemTipLayer.DeleteItemTipLayer()
		elseif eventType==TouchEventType.began then
			ItemTipLayer.CreateItemTipLayer(m_pPataLevelInfoLayer, sender, TipType.Monster, sender:getTag(), TipPosType.RightTop)
		elseif eventType==TouchEventType.canceled then
			ItemTipLayer.DeleteItemTipLayer()
		end
	end
	local function HeadSet( nItem , nTag)
		nItem:setTag(nTag)
		nItem:setTouchEnabled(true)
		nItem:addTouchEventListener(_Image_Monster_CallBack)
	end
	for i=1,5 do
		local nMonster = nMonsterData[i]
		if nMonster.MonsterType == MonsterType.Genereal then
			local Image_mBg       = tolua.cast(m_pPataLevelInfoLayer:getWidgetByName("Image_mBg_"..i), "ImageView")
			local Image_Color     = tolua.cast(Image_mBg:getChildByName("Image_Color"), "ImageView")
			local Image_Monster   = tolua.cast(Image_mBg:getChildByName("Image_Monster"), "ImageView")
			local pLabelJob       = tolua.cast(Image_mBg:getChildByName("Label_Job"), "Label")
			local pNameBg 		  = tolua.cast(Image_mBg:getChildByName("Image_nameBg"), "ImageView")
			pNameBg:loadTexture("Image/imgres/dungeon/monster_name_bg.png")
			Image_mBg:removeChild(pLabelJob, true)
			local pLbJob = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, nMonster.Military, ccp(0, 0), ccc3(49, 16, 7), ccc3(254, 225, 78), true, ccp(0, -2), 2)
			pLbJob:setScale(1.0)
			pNameBg:addChild(pLbJob)
			Image_Color:loadTexture(nMonster.ColorIcon)
			Image_Monster:loadTexture(nMonster.HeadIcon)
			HeadSet(Image_Monster,nMonster.MonsterId)
			require "Script/Main/Dungeon/DungeonBaseData"
			local nMonsterLevel = DungeonBaseData.GetMonsterLevel(nMonster.MonsterId)
			--local Label_Info =  LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "敌方LV:"..nMonsterLevel, ccp(-190, 30), COLOR_Black, ccc3(51,25,13), true, ccp(0, 0), 0)
			local Label_Info =  CreateLabel("敌方LV:"..nMonsterLevel,30, ccc3(51,25,13), CommonData.g_FONT1,ccp(-190, 30))
			Image_Bg:addChild(Label_Info,10)
		else
			local Image_mBg       = tolua.cast(m_pPataLevelInfoLayer:getWidgetByName("Image_mBg_"..i), "ImageView")
			local Image_Color     = tolua.cast(Image_mBg:getChildByName("Image_Color"), "ImageView")
			local Image_Monster   = tolua.cast(Image_mBg:getChildByName("Image_Monster"), "ImageView")
			local pLabelJob       = tolua.cast(Image_mBg:getChildByName("Label_Job"), "Label")
			pLabelJob:setText(nMonster.Military)
			Image_Color:loadTexture(nMonster.ColorIcon)
			Image_Monster:loadTexture(nMonster.HeadIcon)
			HeadSet(Image_Monster,nMonster.MonsterId)
		end
	end
end 

function createGamerInfoLayer( GamerDB ,receiveCallfunc)
	if m_pGamerInfoLayer == nil then
		m_pGamerInfoLayer = TouchGroup:create()									-- 背景层
	    m_pGamerInfoLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/ChatGamerInfoLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_pGamerInfoLayer, layerTip_Tag, layerTip_Tag)
	end
	local nGamerInfoBg = tolua.cast(m_pGamerInfoLayer:getWidgetByName("Image_GamerInfoBg"), "ImageView")
	--add Head
	local nHeadBg = tolua.cast(m_pGamerInfoLayer:getWidgetByName("Image_HeadBg"), "ImageView")
	local nHead = UIInterface.MakeHeadIcon(nHeadBg,ICONTYPE.HEAD_ICON,nil,nil,nil,GamerDB.face) --HEAD_ICON DISPLAY_ICON
	nHeadBg:setScale(0.7)
	--add Level
	-- local nLevel = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, "Lv."..GamerDB.level, ccp(nHeadBg:getPositionX()-10, nHeadBg:getPositionY()-30), COLOR_Black, COLOR_White, true, ccp(0, 0), 2)
	-- nGamerInfoBg:addChild(nLevel,1001)
	local nLevel = Label:create()
	nLevel:setPosition(ccp(-200,42))
	nLevel:setFontSize(18)
	nLevel:setName("LabelNum")
	nLevel:setAnchorPoint(ccp(0, 0.5))
	nLevel:setText("Lv."..GamerDB.level)
	nGamerInfoBg:addChild(nLevel)
	--add Vip
	local img_VIP = tolua.cast(m_pGamerInfoLayer:getWidgetByName("Image_Vip"), "ImageView")

	local labelVIP = LabelBMFont:create()
	labelVIP:setFntFile("Image/imgres/common/num/vipNum.fnt")
	labelVIP:setPosition(ccp(45,1))
	labelVIP:setAnchorPoint(ccp(0.5,0.5))
	labelVIP:setText(GamerDB.vipLevel)
	img_VIP:addChild(labelVIP,0,1000)
	--addName
	local strName = GamerDB.name
	local nameText = ""
    if nGamerInfoBg:getChildByTag(1000) ~= nil then
		LabelLayer.setText(nGamerInfoBg:getChildByTag(1000), strName)
    else
		nameText = LabelLayer.createStrokeLabel(20, "微软雅黑", strName, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
		nameText:setPosition(ccp(0,93))
		nGamerInfoBg:addChild(nameText,  2, 1000)
	end
	--add Fightiabilty
	
	local nFightText = Label:create()
	nFightText:setFontSize(18)
	nFightText:setFontName(CommonData.g_FONT3)
	nFightText:setColor(ccc3(51,25,13))
	nFightText:setPosition(ccp(nameText:getPositionX() - 30, nameText:getPositionY() - 50))
	nFightText:setText("战斗力 :")
	nGamerInfoBg:addChild(nFightText)
	
	local nFightpowerText = Label:create()
	nFightpowerText:setFontSize(18)
	nFightpowerText:setFontName(CommonData.g_FONT3)
	nFightpowerText:setColor(ccc3(147,54,33))
	nFightpowerText:setPosition(ccp(nFightText:getPositionX() + 80, nFightText:getPositionY()))
	nFightpowerText:setText(GamerDB.power)
	nGamerInfoBg:addChild(nFightpowerText)

	-- add CorpsName
	if GamerDB["bang_pai"] ~="" then
		local nCorpsText = Label:create()
		nCorpsText:setFontSize(24)
		nCorpsText:setFontName(CommonData.g_FONT3)
		nCorpsText:setColor(ccc3(147,54,33))
		nCorpsText:setPosition(ccp(nameText:getPositionX()-10, nameText:getPositionY() - 120))
		nCorpsText:setText("军团:".."  "..GamerDB["bang_pai"])
		nGamerInfoBg:addChild(nCorpsText)
	end
	--add ReturnBack
	local function _Reward_Return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			sender:setScale(1.0)
			m_pGamerInfoLayer:setVisible(false)
			m_pGamerInfoLayer:removeFromParentAndCleanup(true)
			m_pGamerInfoLayer = nil
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
	local nReturnBackBtn = tolua.cast(m_pGamerInfoLayer:getWidgetByName("Button_Close"), "Button")
	nReturnBackBtn:addTouchEventListener(_Reward_Return_CallBack)
	local nReturnBackPanel = tolua.cast(m_pGamerInfoLayer:getWidgetByName("Panel_Return"), "Layout")
	nReturnBackPanel:addTouchEventListener(_Reward_Return_CallBack)

	--add PrivateButton addFriendsBtn
	local function _ClickInfo_GamerInfo_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then
			sender:setScale(1.0)
			if sender:getTag() == 1001 then
				--去私聊
				receiveCallfunc(true)
			-- elseif sender:getTag() == 1002 then
				--加为好友
				-- receiveCallfunc(false)
			else
				Log("Error Tag")
			end
			m_pGamerInfoLayer:setVisible(false)
			m_pGamerInfoLayer:removeFromParentAndCleanup(true)
			m_pGamerInfoLayer = nil
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
	local nPrivate = tolua.cast(m_pGamerInfoLayer:getWidgetByName("Image_PrivateChat"), "ImageView")
	-- local nAddFriends = tolua.cast(m_pGamerInfoLayer:getWidgetByName("Image_AddFriend"), "ImageView")
	local pPrivateBtnText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "私聊", ccp(3, 4), COLOR_Black, COLOR_White, true, ccp(0, -2), 3)
	-- local pAddFriendsBtnText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "加为好友", ccp(3, 4), COLOR_Black, COLOR_White, true, ccp(0, -2), 3)
	nPrivate:addChild(pPrivateBtnText)
	nPrivate:setTag(1001)
	-- nAddFriends:addChild(pAddFriendsBtnText)
	-- nAddFriends:setVisible(false)
	-- nAddFriends:setTouchEnabled(false)
	-- nAddFriends:setTag(1002)
	nPrivate:addTouchEventListener(_ClickInfo_GamerInfo_CallBack)
	-- nAddFriends:addTouchEventListener(_ClickInfo_GamerInfo_CallBack)
end

---add celina 150206
local function createTipLayer()
	local playerTimeLayer = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(playerTimeLayer, layerTip_Tag, layerTip_Tag)
	return playerTimeLayer
end
local function addLable(str_lable,img_lable_bg,pos,tag)
	local lable_str = Label:create()
	lable_str:setFontSize(24)
	lable_str:setColor(ccc3(233,180,114))
	lable_str:setText(str_lable)
	if img_lable_bg:getChildByTag(tag)~=nil then
		img_lable_bg:getChildByTag(tag):removeFromParentAndCleanup(true)
	end
	lable_str:setPosition(pos)
	img_lable_bg:addChild(lable_str,tag,tag)
end
local function TipAction(nLayer,nTime)
	if nLayer ~= nil then
		local function acctionEnd()
			nLayer:removeFromParentAndCleanup(true)
		end
		nLayer:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.1, 1))
		actionArray2:addObject(CCDelayTime:create(nTime))
		actionArray2:addObject(CCCallFunc:create(acctionEnd))
		actionArray2:addObject(CCFadeOut:create(1))
		nLayer:stopAllActions()
		nLayer:runAction(CCSequence:create(actionArray2))
	end
end

function showErrorTip(str_error,lifeTime)
	local str_length = string.len(str_error)
	
	local img_bg = ImageView:create()
	img_bg:setScale9Enabled(true)
    img_bg:loadTexture("Image/imgres/common/tip_bk_01.png")
	
	local col = str_length/(18*3)
	local n = 0
	local i = 0
	while true do
	     i = string.find(str_error, "%w", i+1)
	     if i == nil then break end
	     n = n + 1
	end
	i = 0
	while true do
	     i = string.find(str_error, "%p", i+1)
	     if i == nil then break end
	     n = n + 1
	end
	if col~=0  then 
		img_bg:setSize(CCSize(18*25+100, 49*2))
		local str_new_1 = string.sub(str_error,0,18*3+n)
		local str_new_2 = string.sub(str_error,str_length-18*3-n-1)
		addLable(str_new_1,img_bg,ccp(0,img_bg:getContentSize().height/2),TAG_LABLE_ROW1)
		addLable(str_new_2,img_bg,ccp(0,img_bg:getContentSize().height/2-50),TAG_LABLE_ROW2)
	end
	
	
	
	local layer_error = createTipLayer()
	img_bg:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2))
	layer_error:addChild(img_bg)
	TipAction(layer_error,lifeTime)
end