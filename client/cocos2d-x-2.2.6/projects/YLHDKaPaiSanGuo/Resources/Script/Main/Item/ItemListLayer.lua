

module("ItemListLayer", package.seeall)

--[[
require "Script/Main/Item/ItemData"

]]--
require "Script/Main/Item/ItemLotSelectLogic"
require "Script/Main/Item/ItemLogic" 
require "Script/Main/Item/ItemNoGoods" 
require "Script/Main/Item/ItemGoods"
require "Script/Main/Item/ItemSelectInfo"
require "Script/Main/Item/ItemBtn" 
--变量
local m_layerItemList =nil 
local m_org_object_box = nil 
local m_org_type_box = nil  --记录大的项目是道具还是装备背包
local m_cur_select_grid = nil
local m_b_lot_select = false
local m_goods_state  = nil --背包物品的状态，0表示单选，1表示多选

local label_lot_sliver = nil --背包多选的价格
local m_price_total = 0 


local PATH_MENU_BTN_L = "Image/imgres/item/item_select_l.png"
local PATH_MENU_BTN_N = "Image/imgres/item/item_select_n.png"

local COLOR_MENU_L = ccc3(51,25,13)
local COLOR_MENU_N = ccc3(255,245,126)

--记录小的项目分为装备，宝物，灵宝，碎片，消耗品，以及将魂，因为之前用的是box的类型，修改地方较多，所以暂时沿用
local m_menu_type = nil 
local m_menu_object = nil 

--暂时给add 红点用
local m_item_box = nil 
local m_PointManger = nil
local m_item_sp = nil
local tab_menu_item = {
	"消耗品",
	"碎片",
	"将魂",
}
local tab_menu_equip = {
	"装备",
	"宝物",
	"灵宝",
}
--逻辑部分
local DealLotSelectLogic = ItemLotSelectLogic.DealLotSelectLogic
local DealDelOKImg = ItemLotSelectLogic.DealDelOKImg
local DealSellLotEquip = ItemLotSelectLogic.DealSellLotEquip

local CheckBHaveGoods = ItemLogic.CheckBHaveGoods
local CheckBHaveItem  = ItemLogic.CheckBHaveItem
local GetStrNumBag    = ItemLogic.GetStrNumBag

local GetGridByID = ItemLogic.GetGridByID
local GetBoxByMenuType  = ItemLogic.GetBoxByMenuType
local GetTabLot   = ItemGoods.GetTabLot


--界面
local CreateNoGoods    = ItemNoGoods.CreateNoGoods
local CreateItemGoods  = ItemGoods.CreateItemGoods
local CreateSelectInfo = ItemSelectInfo.CreateSelectInfo
local CreateItemBtn    = ItemBtn.CreateItemBtn



local function SetNoGoods(bShow)
	if bShow == false then
		if m_layerItemList:getChildByTag(2000)~=nil then
			m_layerItemList:getChildByTag(2000):setVisible(false)
			m_layerItemList:getChildByTag(2000):removeFromParentAndCleanup(true)
		end
		if m_layerItemList:getChildByTag(2001)~=nil then
			m_layerItemList:getChildByTag(2001):setVisible(false)
			m_layerItemList:getChildByTag(2001):removeFromParentAndCleanup(true)
		end
	end
end
local function ShowNumBag()
	--修改为改变标题
	local img_title_bg = tolua.cast(m_layerItemList:getWidgetByName("img_num_ng"),"ImageView")
	local str_title = ""
	if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM then
		str_title = "道具背包"
	else
		str_title = "装备背包"
	end
	
	if img_title_bg:getChildByTag(1 ) == nil then
		local label_title = LabelLayer.createStrokeLabel(28,CommonData.g_FONT1,str_title,ccp(0,5),COLOR_Black,ccc3(255,194,30),true,ccp(0,-2),2)
		AddLabelImg(label_title,1,img_title_bg)
	else
		local pLabelLayout = img_title_bg:getChildByTag(1 )
		if pLabelLayout~=nil then
			LabelLayer.setText(pLabelLayout,str_title)
		end
	end
	--添加背包的个数
	local lable_bag_num = tolua.cast(m_layerItemList:getWidgetByName("Label__num_item"),"Label")
	lable_bag_num:setText(GetStrNumBag(m_org_type_box))
end

--测试
local function loadRedPoint(  )
	require "Script/serverDB/server_itemDB"
	require "Script/serverDB/item"
	if m_item_box == nil and m_item_sp == nil then
		return
	end
	local is_Red = ItemLogic.CheckRedPoint()
	if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM then
		if is_Red == true then
			m_PointManger:ShowRedPoint(100,m_item_box,60,25)
			m_PointManger:ShowRedPoint(101,m_item_sp,50,10)
		else
			if m_item_box:getChildByTag(100) ~= nil then 
				m_item_box:getChildByTag(100):removeFromParentAndCleanup(true) 
			end
			m_PointManger:DeleteRedPoint(101)
		end
	else
		m_PointManger:DeleteRedPoint(101)
	end

end

local function ShowGoods()
	SetNoGoods(false)
	loadRedPoint()
	local function SetCurSelectGrid(nGrid)
		m_cur_select_grid = nGrid
		
		--按钮部分
		--现在点击的是售出还是炼化
		local function BtnClickCallBack(nGrid)
			DealDelOKImg(GetTabLot(),true)
			m_price_total = 0
			if CheckBHaveItem(nGrid,m_menu_type) == false then
				--说明没有这个物品了
				m_cur_select_grid = nil		
			end
			--界面部分
			ShowNumBag()
			
			if CheckBHaveGoods(m_menu_type) == true then
				--没有物品的界面
				CreateNoGoods(m_layerItemList)
			else
				ShowGoods()
			end
		end
		CreateSelectInfo(m_layerItemList,m_cur_select_grid,m_menu_type,BtnClickCallBack)
		CreateItemBtn(m_layerItemList,m_cur_select_grid,m_menu_type,BtnClickCallBack)
	end

	CreateItemGoods(m_layerItemList,m_menu_type,m_cur_select_grid,SetCurSelectGrid)
	
end


--添加指引的代码 
local function AddItemGuide(bLeft)
	--左按钮
	local m_btn_left = tolua.cast(m_layerItemList:getWidgetByName("btn_sell"),"Button")
	local m_btn_right = tolua.cast(m_layerItemList:getWidgetByName("btn_use"),"Button")

	local Layout_Bg = tolua.cast(m_layerItemList:getWidgetByName("Panel_btn"),"Layout")
	
	local m_scrollview = tolua.cast(m_layerItemList:getWidgetByName("scrollview_bi"),"ScrollView")
	if m_cur_select_grid ~=nil then
		--选中的物品
		local _img_Item = m_scrollview:getChildByTag(TAG_GRID_ADD+tonumber(m_cur_select_grid))
	end


	--指引点击效果
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/zhiyin01.ExportJson")
	local GuideAnimation = CCArmature:create("zhiyin01")
	GuideAnimation:getAnimation():play("Animation1")

	if bLeft == true then
		--按钮上添加
		if Layout_Bg:getNodeByTag(1990) ~= nil then
			Layout_Bg:getNodeByTag(1990):removeFromParentAndCleanup(true)
		end

		GuideAnimation:setPosition(ccp(m_btn_right:getPositionX(), m_btn_right:getPositionY()))
		Layout_Bg:addNode(GuideAnimation, 1990, 1990)

	else
		--道具上添加
	end
end
local function HideBtnAndPrice(bVisible)
	local layout_btn = tolua.cast(m_layerItemList:getWidgetByName("Panel_btn"),"Layout")
	layout_btn:setVisible(bVisible)
	--价格
	local img_price = tolua.cast(m_layerItemList:getWidgetByName("img_price_bg"),"ImageView")
	img_price:setVisible(bVisible)
	--总价
	local label_price = tolua.cast(m_layerItemList:getWidgetByName("label_price"),"Label")
	label_price:setVisible(bVisible)
end
local function HideCutDownLayerLeft(bVisible)
	local img_bg_all = tolua.cast(m_layerItemList:getWidgetByName("img_bg_l"),"ImageView")
	local img_cutDown = img_bg_all:getChildByTag(9)
	if img_cutDown~=nil then
		img_cutDown:setVisible(bVisible)
		img_cutDown:setTouchEnabled(bVisible)
		if img_cutDown:getChildByTag(3)~=nil then
			local btn_sell_lot = tolua.cast(img_cutDown:getChildByTag(3),"Button")
			btn_sell_lot:setTouchEnabled(bVisible)	
		end
	end
end
--更新多个售卖
local function UpdateLotSelect()
	DealDelOKImg(GetTabLot(),true)
	m_price_total = 0
	
	if CheckBHaveItem(m_cur_select_grid,m_menu_type) == false then
		--说明没有这个物品了
		m_cur_select_grid = nil		
	end
	--界面部分
	ShowNumBag()
	if CheckBHaveGoods(m_menu_type) == true then
		--没有物品的界面
		HideCutDownLayerLeft(false)
		CreateNoGoods(m_layerItemList)
		
	else
		ShowGoods()
		HideBtnAndPrice(false)
		
	end
	
	if CheckBHaveGoods(m_menu_type) == true then
		DealLotSelectLogic(true,GetTabLot(),false)
		ItemGoods.ClearGoods()
	else
		DealLotSelectLogic(true,GetTabLot())
	end
end
local function _Btn_Sell_Lot_CallBack()
	DealSellLotEquip(GetTabLot(),UpdateLotSelect)
end
local function AddCutDownLayerLeft()
	local img_bg_all = tolua.cast(m_layerItemList:getWidgetByName("img_bg_l"),"ImageView")
	local img_cutDown = ImageView:create()
	img_cutDown:setScale9Enabled(true)
	img_cutDown:loadTexture("Image/imgres/item/cutDown.png")
    img_cutDown:setSize(CCSize(322, 429))
    img_cutDown:setPosition(CCPoint(-200, 3))
	img_cutDown:setTouchEnabled(true)
    --img_bg_all:addChild(img_cutDown)
	AddLabelImg(img_cutDown,9,img_bg_all)
	--添加button
	local btn_sell_lot = Button:create()
	
	btn_sell_lot:setTouchEnabled(true)
    btn_sell_lot:setScale9Enabled(true)
    btn_sell_lot:loadTextures("Image/imgres/button/btn_yellow.png","Image/imgres/button/btn_yellow.png","")
    btn_sell_lot:setPosition(CCPoint(-7, -198))
    btn_sell_lot:setSize(CCSize(127, 45))
	CreateBtnCallBack(btn_sell_lot,"出售",20,_Btn_Sell_Lot_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil,CommonData.g_FONT3)
    img_cutDown:addChild(btn_sell_lot,3,3)
	
	local label_total_price = Label:create()
	label_total_price:setFontName(CommonData.g_FONT3)
	label_total_price:setFontSize(20)
	label_total_price:setColor(ccc3(49,31,21))
	label_total_price:setText("总价:")
	label_total_price:setPosition(ccp(-78,-146))
	img_cutDown:addChild(label_total_price,2,2)
	
	local img_nameBG = ImageView:create()
	img_nameBG:loadTexture("Image/imgres/equip/bg_name_equiped.png")
	img_nameBG:setPosition(ccp(53,-149))
	img_nameBG:setSize(CCSize(160, 25))
	img_cutDown:addChild(img_nameBG,1,1)
	
	local img_sliver_icon = ImageView:create()
	img_sliver_icon:loadTexture("Image/imgres/common/silver.png")
	img_sliver_icon:setScale(0.55)
	img_sliver_icon:setPosition(ccp(-73,0))
	AddLabelImg(img_sliver_icon,1,img_nameBG)
	
	label_lot_sliver = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,0,ccp(0,0),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
	AddLabelImg(label_lot_sliver,2,img_nameBG)
end
function GetSelectSellPrice()
	return m_price_total
end
function UpdateLablePrice(nPrice)
	m_price_total = m_price_total +nPrice
	LabelLayer.setText(label_lot_sliver,m_price_total)
end
local function DealLotSelect()
	--处理多选还是取消多选
	if m_b_lot_select == true then
		--多选
		m_goods_state = 1 
		AddCutDownLayerLeft()
		--下面的btn和出售价格隐藏
		HideBtnAndPrice(false)
		if CheckBHaveGoods(m_menu_type) == true then
			DealLotSelectLogic(true,GetTabLot(),false)
		else
			DealLotSelectLogic(true,GetTabLot())
		end
	end
	if m_b_lot_select == false then
		--取消多选
		m_goods_state = 0
		HideCutDownLayerLeft(false)
		HideBtnAndPrice(true)
		
		if CheckBHaveGoods(m_menu_type) == true then
			
			DealLotSelectLogic(false,GetTabLot(),false)
		else
			DealLotSelectLogic(false,GetTabLot())
		end
	end
end
local function _Img_Lot_Selecet_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--换图
		if CheckBHaveGoods(m_menu_type) == false then
			m_b_lot_select = not m_b_lot_select
			local img_select = tolua.cast(sender,"ImageView")
			if m_b_lot_select == true then
				img_select:loadTexture("Image/imgres/item/img_select_l.png")
				--说明选中了
				m_goods_state = 1 
			else
				img_select:loadTexture("Image/imgres/item/img_select_n.png")
				--说明取消选中
				m_goods_state = 0
				m_price_total = 0
			end
			--ShowLotSell(m_b_lot_select)
			DealLotSelect()
		end
	end
end
local function InitUI()
	--界面部分
	ShowNumBag()
	if CheckBHaveGoods(m_menu_type) == true then
		--没有物品的界面
		CreateNoGoods(m_layerItemList)
	else
		ShowGoods()
	end
	--多选的按钮
	local img_bg_select = tolua.cast(m_layerItemList:getWidgetByName("Image_39"),"ImageView")
	local img_select = tolua.cast(m_layerItemList:getWidgetByName("Image_40"),"ImageView")
	--img_bg_select:setTouchEnabled(true)
	--img_select:setTouchEnabled(true)
	img_select:addTouchEventListener(_Img_Lot_Selecet_CallBack)
	
end
function GetUIControl()
	return m_layerItemList
end
--返回按钮
local function _Btn_Back_ItemlistLayer_CallBack()
	CCUserDefault:sharedUserDefault():setIntegerForKey("temp_id",0)
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Item)
	m_layerItemList:setVisible(false)
	m_layerItemList:removeFromParentAndCleanup(true)
	m_layerItemList = nil
	MainScene.PopUILayer()
end
local function DealLotUI()
	m_b_lot_select = false
	if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_EQUIP then
		ShowLotSell(true)
	else
		ShowLotSell(false)
	end
	
	HideCutDownLayerLeft(m_b_lot_select)
	if CheckBHaveGoods(m_menu_type) == false then
		HideBtnAndPrice(not m_b_lot_select)
	end
end

local function _Img_Btn_Menu_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		local tag_now = sender:getTag()-TAG_GRID_ADD
		local img_now = tolua.cast(sender,"ImageView")
		local label_now = tolua.cast(sender:getChildByTag(1),"Label")
		if tag_now~=m_menu_type then
			--更新界面
			label_now:setColor(COLOR_MENU_L)
			local orgLable = tolua.cast(m_menu_object:getChildByTag(1),"Label")
			orgLable:setColor(COLOR_MENU_N)
			m_menu_object:loadTexture(PATH_MENU_BTN_N)
			m_menu_object = img_now
			m_menu_type = tag_now
			img_now:loadTexture(PATH_MENU_BTN_L)
			m_cur_select_grid = nil
			m_goods_state = 0
			m_price_total = 0
			--将选中的状态的对勾都删除
			DealDelOKImg(GetTabLot(),true)
			DealLotUI()
			InitUI()
		end
	end
end
local function SetOrgMenuState()
	for i=1,3 do 
		local img_btn = tolua.cast(m_layerItemList:getWidgetByName("img_btn_"..i),"ImageView")
		local label_btn = tolua.cast(m_layerItemList:getWidgetByName("Label_"..i),"Label")
		label_btn:setTag(1)
		if i==1 then
			m_menu_object = img_btn
			label_btn:setColor(COLOR_MENU_L)
			img_btn:loadTexture(PATH_MENU_BTN_L)
		else
			label_btn:setColor(COLOR_MENU_N)
			img_btn:loadTexture(PATH_MENU_BTN_N)
		end
		img_btn:setTouchEnabled(true)
		img_btn:addTouchEventListener(_Img_Btn_Menu_CallBack)
		if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM then
			--大目录
			if i==1 then
				img_btn:setTag(TAG_GRID_ADD+ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH)
			end
			if i==2 then
				img_btn:setTag(TAG_GRID_ADD+ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP)
				m_item_sp = img_btn
			end
			if i==3 then
				img_btn:setTag(TAG_GRID_ADD+ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH)
			end
			label_btn:setText(tab_menu_item[i])
		end
		if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_EQUIP then
			--大目录
			label_btn:setText(tab_menu_equip[i])
			if i==1 then
				img_btn:setTag(TAG_GRID_ADD+ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP)
			end
			if i==2 then
				img_btn:setTag(TAG_GRID_ADD+ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE)
			end
			if i==3 then
				img_btn:setTag(TAG_GRID_ADD+ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO)
			end
		end
	end
	
end
local function _Btn_ClickType_ItemList_CallBack(nType,sender)
	m_org_type_box = nType
	if m_org_object_box:getTag() ~= sender:getTag() then
		m_org_object_box:setSelectedState(false)
		
		if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM then
			UpdateObject(m_org_object_box,sender,"道具")
			m_menu_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH
		else
			m_menu_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP
			UpdateObject(m_org_object_box,sender,"装备")
		end
		SetOrgMenuState()
		m_org_object_box = sender
		
		m_cur_select_grid = nil
		m_goods_state = 0
		m_price_total = 0
		--将选中的状态的对勾都删除
		DealDelOKImg(GetTabLot(),true)
		--[[m_b_lot_select = false
		if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_EQUIP then
			
			--if CheckBHaveGoods(m_org_type_box) == false then
				
				ShowLotSell(true)
			--end
		else
			ShowLotSell(false)
		end
		
		--ShowLotSell(m_b_lot_select)
		
		HideCutDownLayerLeft(m_b_lot_select)
		if CheckBHaveGoods(m_menu_type) == false then
			HideBtnAndPrice(not m_b_lot_select)
		end]]--
		DealLotUI()
		InitUI()
	end

	local Layout_Bg = tolua.cast(m_layerItemList:getWidgetByName("Panel_btn"),"Layout")
	if Layout_Bg:getNodeByTag(1990) ~= nil then
		Layout_Bg:getNodeByTag(1990):removeFromParentAndCleanup(true)
	end
end
local function InitVars()
	m_layerItemList = nil 
	m_org_object_box = nil 
	m_org_type_box = nil 
	m_cur_select_grid = nil
	m_b_lot_select = false 
	m_goods_state = 0
	label_lot_sliver =nil 
	m_price_total = 0
	m_menu_type = nil 
	m_menu_object = nil 
	m_item_box = nil 
	m_PointManger = nil
end

function GetGoodsState()
	return m_goods_state
end
local function AddMainBtn()
	--主界面的按钮
    local temp_equipList = MainBtnLayer.createMainBtnLayer()
    m_layerItemList:addChild(temp_equipList, layerMainBtn_Tag, layerMainBtn_Tag)
end
local function SetOrgBoxState(nType)
	if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM then
		local m_box_item = tolua.cast(m_layerItemList:getWidgetByName("box_item_bi"),"CheckBox")
		m_org_object_box = m_box_item
		m_box_item:setSelectedState(true)
	elseif m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_EQUIP then
		local m_box_equip = tolua.cast(m_layerItemList:getWidgetByName("box_equip_bi"),"CheckBox")
		m_org_object_box = m_box_equip
		m_box_equip:setSelectedState(true)
	end
end

--iType 小的menu类型
local function InitData(iType,iItemID)
	m_goods_state = 0
	--初始化box按钮
	local m_box_item = tolua.cast(m_layerItemList:getWidgetByName("box_item_bi"),"CheckBox")
	m_item_box = m_box_item
	local m_box_equip = tolua.cast(m_layerItemList:getWidgetByName("box_equip_bi"),"CheckBox")
	if iType==nil then
		--默认的是道具下的消耗品
		m_org_type_box = ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM
		m_menu_type  = ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH
		
	else
		m_menu_type  = iType
		m_org_type_box = GetBoxByMenuType(m_menu_type)
	end
	
	if m_org_type_box == ENUM_TYPE_BOX_ITEM.ENUM_BOX_EQUIP then
		ShowLotSell(true)
	else
		ShowLotSell(false)
	end
	SetOrgBoxState()
	SetOrgMenuState()
	CreateCheckBoxCallBack(m_box_item,ENUM_STRING_ITEM.ENUM_STRING_ITEM_ITEM,_Btn_ClickType_ItemList_CallBack)
	--为了区分原有的装备页签
	CreateCheckBoxCallBack(m_box_equip,"装备1",_Btn_ClickType_ItemList_CallBack)
	
	
end
function NewGuideClose()
	CCUserDefault:sharedUserDefault():setIntegerForKey("temp_id",0)
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Item)
	m_layerItemList:setVisible(false)
	m_layerItemList:removeFromParentAndCleanup(true)
	m_layerItemList = nil
	MainScene.PopUILayer()
end
--批量出售的按钮显示
function ShowLotSell(bOpen)
	local img_bg = tolua.cast(m_layerItemList:getWidgetByName("Image_39"),"ImageView")
	local img_select = tolua.cast(m_layerItemList:getWidgetByName("Image_40"),"ImageView")
	img_bg:setVisible(bOpen)
	img_select:setVisible(bOpen)
	
	img_bg:setTouchEnabled(bOpen)
	img_select:setTouchEnabled(bOpen)
	if m_b_lot_select == true then
		img_select:loadTexture("Image/imgres/item/img_select_l.png")
		--说明选中了
	else
		img_select:loadTexture("Image/imgres/item/img_select_n.png")
		--说明取消选中
		
	end
end
--为新手引导制作
function SelectItemByID(nItemID,fCallBack)
	m_cur_select_grid = ItemData.GetItemGridByID(nItemID)
	local function SetCurSelectGrid(nGrid)
		m_cur_select_grid = nGrid
		
		--按钮部分
		--现在点击的是售出还是炼化
		local function BtnClickCallBack(nGrid)
			if CheckBHaveItem(nGrid,m_menu_type) == false then
				--说明没有这个物品了
				m_cur_select_grid = nil		
			end
			--界面部分
			ShowNumBag()
			if CheckBHaveGoods(m_menu_type) == true then
				--没有物品的界面
				CreateNoGoods(m_layerItemList)
			else
				ShowGoods()
			end
		end
		CreateSelectInfo(m_layerItemList,m_cur_select_grid,m_menu_type,BtnClickCallBack)
		CreateItemBtn(m_layerItemList,m_cur_select_grid,m_menu_type,BtnClickCallBack)
		if fCallBack~=nil then
			fCallBack()
		end
	end

	CreateItemGoods(m_layerItemList,m_menu_type,m_cur_select_grid,SetCurSelectGrid)
end
--nType区分的是小的目录
function CreateItemListLayer ( bLeft,nType, nItemID)
	InitVars()
	m_layerItemList = TouchGroup:create()
	m_layerItemList:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/ItemListLayer.json"))
	AddMainBtn()
	m_PointManger = AddPoint.CreateAddPoint()
	InitData(nType, nItemID)
	if bLeft == false then
		--说明要找一组丹药，nItemID 表示等级
		m_cur_select_grid = GetGridByID(nItemID)
	else
		m_cur_select_grid = nItemID
	end
	
	InitUI()
	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		pBarManager:Create(m_layerItemList,CoinInfoBarManager.EnumLayerType.EnumLayerType_Item)
	end
	if nType~=nil and nItemID ~= nil then
		if CheckBHaveItem(m_cur_select_grid,m_menu_type) == true then
			AddItemGuide(bLeft)
		end
	end

	
	local btn_back = tolua.cast(m_layerItemList:getWidgetByName("btn_back_bi"),"Button")
	CreateBtnCallBack(btn_back,nil ,0,_Btn_Back_ItemlistLayer_CallBack)
	return m_layerItemList
end