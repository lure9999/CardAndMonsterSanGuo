--强化返还获得物品界面 celina


module("StrengthenReturnLayer", package.seeall)


--数据

local GetColorByTempID = ItemData.GetColorByTempID

local m_layer_return =nil 
local tabReturnData = nil 
local m_Price = nil 
local m_sell_type = 0

local function InitVars()
	m_layer_return = nil 
	tabReturnData = nil 
	m_Price = nil 
	m_sell_type = 0
end
local function _Btn_Confirm_CallBack()
	m_layer_return:removeFromParentAndCleanup(true)
	m_layer_return = nil 
	
end
local function AddEffect()
	local img_title = tolua.cast(m_layer_return:getWidgetByName("img_title"),"ImageView")
	local layout_bg = tolua.cast(m_layer_return:getWidgetByName("Panel_Return"),"Layout")


	CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
			"StrengthenEquip_effect_01", 
			"huodejianli01_02_01", 
			img_title, 
			ccp(0, -5),
			nil,
			0)
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
			"StrengthenEquip_effect_01", 
			"huodejianli02_02", 
			layout_bg, 
			ccp(img_title:getPositionX(), img_title:getPositionY()-20),
			nil,
			0)
end
local function InitUI()
	local tabCoin = tabReturnData[1]
	local tabItem = tabReturnData[2]
	local nCoinCount = #tabCoin
	local nItemCount = #tabItem
	local img_BG = tolua.cast(m_layer_return:getWidgetByName("img_mid_bg"),"ImageView")
	local nTotalCount =  nCoinCount+nItemCount
	local posX = 0 
	if nTotalCount == 1 then
		posX= 0
	end
	if nTotalCount == 2 then
		posX= -70
	end
	if nTotalCount == 3 then
		posX= 0-140
	end
	if nTotalCount == 4 then
		posX= -210
	end
	
	for i=1,nTotalCount do 
		local img_icon_bg = ImageView:create()
		img_icon_bg:loadTexture("Image/imgres/common/bottom.png")
		img_icon_bg:setPosition(ccp(posX+(i-1)*140,10))
		img_icon_bg:setScale(0.68)
		
		local img_icon = nil 
		local label_num = Label:create()
		label_num:setColor(ccc3(49,31,21))
		label_num:setFontSize(20)
		
		if i<= nCoinCount then
			label_num:setText(tabCoin[i][2])
			img_icon = UIInterface.MakeHeadIcon(img_icon_bg, ICONTYPE.COIN_ICON, tabCoin[i][1], nil)
		else
			label_num:setText(tabItem[i-nCoinCount][2])
			img_icon = UIInterface.MakeHeadIcon(img_icon_bg, ICONTYPE.ITEM_ICON, tabItem[i-nCoinCount][1], nil)
		end
		label_num:setPosition(ccp(posX+(i-1)*140,-40))
		AddLabelImg(label_num,2000+i,img_BG)
		AddLabelImg(img_icon_bg,1000+i,img_BG)
	end
	
	--售价
	local label_price = tolua.cast(m_layer_return:getWidgetByName("Label_sell_num"),"Label")
	label_price:setText(m_Price)
	local btn_ok = tolua.cast(m_layer_return:getWidgetByName("btn_confirm"),"Button")
	CreateBtnCallBack( btn_ok,"确认",36,_Btn_Confirm_CallBack,COLOR_Black,COLOR_White,nil,nil,nil )
	
	--标题
	local img_title = tolua.cast(m_layer_return:getWidgetByName("img_title"),"ImageView")
	local img_word_title = ImageView:create()
	if m_sell_type == 6 or  m_sell_type == 7 then
		img_word_title:loadTexture("Image/imgres/equip/return_xl.png")
	end
	if m_sell_type == 8 then
		--宝物
		img_word_title:loadTexture("Image/imgres/equip/return_jl.png")
	end
	if m_sell_type == 9 then
		--灵宝
		img_word_title:loadTexture("Image/imgres/equip/return_qh.png")
	end
	AddLabelImg(img_word_title,1,img_title)
	
	AddEffect()
end

function CreateStrengthenReturn(tabData,nPrice,nType)
	InitVars()
	if m_layer_return ==nil then
		m_layer_return = TouchGroup:create()
		m_layer_return:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/StrengthenReturnUI.json"))
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_layer_return, layerGetReturnTag, layerGetReturnTag)
	
	end
	tabReturnData = tabData
	m_Price = nPrice 
	m_sell_type = tonumber(nType)
	InitUI()
end