

module("ItemNoGoods", package.seeall)



function CreateNoGoods(mLayer)
	local m_scrollview_goods = tolua.cast(mLayer:getWidgetByName("scrollview_bi"),"ScrollView")
	m_scrollview_goods:removeAllChildrenWithCleanup(true)
	local m_panel_xh = tolua.cast(mLayer:getWidgetByName("Panel_xh"),"Layout")
	m_panel_xh:setVisible(false)
	local m_panel_btn = tolua.cast(mLayer:getWidgetByName("Panel_btn"),"Layout")
	m_panel_btn:setVisible(false)
	local btn_sell = tolua.cast(mLayer:getWidgetByName("btn_sell"),"Button")
	local btn_use = tolua.cast(mLayer:getWidgetByName("btn_use"),"Button")
	btn_sell:setTouchEnabled(false)
	btn_use:setTouchEnabled(false)
	--人物
	local img_mm = ImageView:create()
	img_mm:loadTexture("Image/imgres/item/mm.png")
	img_mm:setPosition(ccp(250,230))
	if mLayer:getChildByTag(2000)~=nil then
		mLayer:getChildByTag(2000):setVisible(false)
		mLayer:getChildByTag(2000):removeFromParentAndCleanup(true)
	end
	mLayer:addChild(img_mm,0,2000)
	
	--对话框
	local img_talk_bg = ImageView:create()
	img_talk_bg:loadTexture("Image/imgres/item/bg_talk.png")
	img_talk_bg:setPosition(ccp(600,330))
	img_talk_bg:setScale9Enabled(true)
	img_talk_bg:setCapInsets(CCRectMake(100,20,1,1))
	img_talk_bg:setSize(CCSize(441,61))
	if mLayer:getChildByTag(2001)~=nil then
		mLayer:getChildByTag(2001):setVisible(false)
		mLayer:getChildByTag(2001):removeFromParentAndCleanup(true)
	end
	mLayer:addChild(img_talk_bg,0,2001)
	--文字
	local label_talk = Label:create()
	--label_talk:setFontName(CommonData.g_FONT1)
	label_talk:setFontSize(26)
	label_talk:setColor(ccc3(49,31,21))
	label_talk:setText("主公大淫，--！这里啥玩意儿没有")
	label_talk:setPosition(ccp(10,2))
	if img_talk_bg:getChildByTag(1)~=nil then
		img_talk_bg:getChildByTag(1):setVisible(false)
		img_talk_bg:getChildByTag(1):removeFromParentAndCleanup(true)
	end
	
	img_talk_bg:addChild(label_talk,0,1)
end
