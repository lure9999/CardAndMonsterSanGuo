module("PrisonCellLogic",package.seeall)
require "Script/Main/Item/ItemData"
require "Script/Main/Item/GetGoodsLayer"

local BagItemIsFull  = ItemData.BagItemIsFull
local BagEquipIsFull = ItemData.BagEquipIsFull
local BagWJIsFull = ItemData.BagWJIsFull
local GetBoxData  = PrisonCellData.GetBoxData
local GetRewardPrisonByID = PrisonCellData.GetRewardPrisonByID

--对数据进行排序
function SortPrisonData( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.RewardCondition) > tonumber(b.RewardCondition)
		else
			return tonumber(a.RewardCondition) < tonumber(b.RewardCondition)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end

local function CheckBBagIsFull()
	if ( BagEquipIsFull() == true ) or ( BagItemIsFull() == true ) then
		return false
	end
	return true
end
--开箱子需要增加武将的判断
function CheckBOpenBox()
	if CheckBBagIsFull() == false or BagWJIsFull() == true then
		return false
	end
	return true
end

function CheckPrisonStatus( nIndex )
	
end

function cleanListView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:removeAllItems()
	end 
end

--得到奖励的物品
function ToGetGoods(  )
	local tabNew = {}
	local tab = GetBoxData()
	GetGoodsLayer.createGetGoods(tab,nil)
end

function GetRewardLayer( nIndex )
	local function _ClickTouch(  )
		
	end
	local tabCoin,tabItem = GetRewardPrisonByID(nIndex)
	if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
		GetGoodsLayer.createGetGoods(tabItem,nil,_ClickTouch)
	elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
		GetGoodsLayer.createGetGoods(nil,tabCoin,_ClickTouch)
	elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
		GetGoodsLayer.createGetGoods(tabItem,tabCoin,_ClickTouch)
	end
end

--使用道具界面
local function loadUseProp(  )
	if m_PropLayer == nil then
		m_PropLayer = TouchGroup:create()
	    m_PropLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/SignInData.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_PropLayer, layerPropUse_Tag, layerPropUse_Tag)
	end
	local itemNum = 1
	local img_item = tolua.cast(m_PropLayer:getWidgetByName("Image_Item"),"ImageView")
	local label_itemname = tolua.cast(m_PropLayer:getWidgetByName("Label_ItemName"),"Label")
	local label_itemnum = tolua.cast(m_PropLayer:getWidgetByName("Label_ItemNum"),"Label")
	local label_itemexpress = tolua.cast(m_PropLayer:getWidgetByName("Label_express"),"Label")
	local label_itemword = tolua.cast(m_PropLayer:getWidgetByName("Label_word"),"Label")
	local label_useNum = tolua.cast(m_PropLayer:getWidgetByName("Label_useNum"),"Label")

	local btn_addTen = tolua.cast(m_PropLayer:getWidgetByName("Button_AddTen"),"Button")
	local btn_Add = tolua.cast(m_PropLayer:getWidgetByName("Button_Add"),"Button")
	local btn_cut = tolua.cast(m_PropLayer:getWidgetByName("Button_cut"),"Button")
	local btn_cutTen = tolua.cast(m_PropLayer:getWidgetByName("Button_cutTen"),"Button")
	local btn_use = tolua.cast(m_PropLayer:getWidgetByName("Button_use"),"Button")
	local btn_back = tolua.cast(m_PropLayer:getWidgetByName("Button_back"),"Button")
	pSpriteScience_add = tolua.cast(btn_Add:getVirtualRenderer(), "CCSprite")
	pSpriteScience_addTen = tolua.cast(btn_addTen:getVirtualRenderer(), "CCSprite")
	pSpriteScience_cut = tolua.cast(btn_cut:getVirtualRenderer(), "CCSprite")
	pSpriteScience_cutTen = tolua.cast(btn_cutTen:getVirtualRenderer(), "CCSprite")

	local function _Click_prop_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			m_PropLayer:setVisible(false)
			m_PropLayer:removeFromParentAndCleanup(true)
			m_PropLayer = nil
		end
	end
	btn_back:addTouchEventListener(_Click_prop_CallBack)

	local function _Click_add_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			itemNum = itemNum + 1
			if itemNum > 100 then
				SpriteSetGray(pSpriteScience_add,1)
				SpriteSetGray(pSpriteScience_addTen,1)
				btn_Add:setTouchEnabled(false)
				btn_addTen:setTouchEnabled(false)
			else
				SpriteSetGray(pSpriteScience_cut,0)
				SpriteSetGray(pSpriteScience_cutTen,0)
				btn_cut:setTouchEnabled(true)
				btn_cutTen:setTouchEnabled(true)
			end
			
		end
	end
	local function _Click_addTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			itemNum = itemNum + 10
			if itemNum > 100 then
				SpriteSetGray(pSpriteScience_add,1)
				SpriteSetGray(pSpriteScience_addTen,1)
				btn_Add:setTouchEnabled(false)
				btn_addTen:setTouchEnabled(false)
			else
				SpriteSetGray(pSpriteScience_cut,0)
				SpriteSetGray(pSpriteScience_cutTen,0)
				btn_cut:setTouchEnabled(true)
				btn_cutTen:setTouchEnabled(true)
			end
			
		end
	end
	local function _Click_cut_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			itemNum = itemNum - 1
			if itemNum < 0 then
				SpriteSetGray(pSpriteScience_cut,1)
				SpriteSetGray(pSpriteScience_cutTen,1)
				btn_cut:setTouchEnabled(false)
				btn_cutTen:setTouchEnabled(false)
			else
				SpriteSetGray(pSpriteScience_add,0)
				SpriteSetGray(pSpriteScience_addTen,0)
				btn_Add:setTouchEnabled(true)
				btn_addTen:setTouchEnabled(true)
			end
			
		end
	end
	local function _Click_cutTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			itemNum = itemNum - 10
			if itemNum < 0 then
				SpriteSetGray(pSpriteScience_cut,1)
				SpriteSetGray(pSpriteScience_cutTen,1)
				btn_cut:setTouchEnabled(false)
				btn_cutTen:setTouchEnabled(false)
			else
				SpriteSetGray(pSpriteScience_add,0)
				SpriteSetGray(pSpriteScience_addTen,0)
				btn_Add:setTouchEnabled(true)
				btn_addTen:setTouchEnabled(true)
			end
			
		end
	end

	if itemNum > 100 then -- 测试用
		SpriteSetGray(pSpriteScience_add,1)
		SpriteSetGray(pSpriteScience_addTen,1)
		SpriteSetGray(pSpriteScience_cut,1)
		SpriteSetGray(pSpriteScience_cutTen,1)
		btn_Add:setTouchEnabled(false)
		btn_addTen:setTouchEnabled(false)
		btn_cut:setTouchEnabled(false)
		btn_cutTen:setTouchEnabled(false)
	end
	if itemNum < 0 then
		SpriteSetGray(pSpriteScience_cut,1)
		SpriteSetGray(pSpriteScience_cutTen,1)
		btn_cut:setTouchEnabled(false)
		btn_cutTen:setTouchEnabled(false)
	end

	btn_addTen:addTouchEventListener(_Click_addTen_CallBack)
	btn_Add:addTouchEventListener(_Click_add_CallBack)
	btn_cut:addTouchEventListener(_Click_cut_CallBack)
	btn_cutTen:addTouchEventListener(_Click_cutTen_CallBack)
end
