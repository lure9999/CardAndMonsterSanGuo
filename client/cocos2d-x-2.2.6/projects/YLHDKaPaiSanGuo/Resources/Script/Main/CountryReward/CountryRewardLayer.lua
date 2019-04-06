module("CountryRewardLayer",package.seeall)
require "Script/Main/CountryReward/CountryRewardLogic"
require "Script/Main/CountryReward/CountryRewardData"

local CheckBagIsFull 		= CountryRewardLogic.CheckBagIsFull
local GetRewardInfoByID 	= CountryRewardData.GetRewardInfoByID
local GetRewardDataByServer = CountryRewardData.GetRewardDataByServer
local GetMoneyName          = CountryRewardData.GetMoneyName
local GetDataByID           = CountryRewardData.GetDataByID
local cleanListView         = CountryRewardLogic.cleanListView

local m_RewardLayer 	= nil
local plistView 		= nil
local pRewardWidget     = nil

local function initData(  )
	m_RewardLayer 	= nil
	plistView     	= nil
	pRewardWidget   = nil
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		m_RewardLayer:setVisible(false)
		m_RewardLayer:removeFromParentAndCleanup(true)
		m_RewardLayer = nil
	end
end

local function GetItemWidget( pRewardItemTemp )
	local pRewardItem = pRewardItemTemp:clone()
	local peer = tolua.getpeer(pRewardItemTemp)
	tolua.setpeer(pRewardItem,peer)
	return pRewardItem
end

local function DeleteRewardItem( id )
	local pGroupID          = Get()
	local pRewardItemTemp 	= GUIReader:shareReader():widgetFromJsonFile("Image/ItemReward.json")
	local nItemArray 		= pRewardItemTemp:getItems()
	local nMaxCount 		= nItemArray:count()
	for i=1,nMaxCount do
		local nItem = nItemArray:objectAtIndex(i-1)
		-- local nItemGroupID = Get(nItem:getTag())
		if tonumber(pGroupID) == tonumber(nItemGroupID) then
			pRewardItemTemp:removeItem(i-1)
		end
	end
end

local function loadItemInfo( value,key )
	local pRewardItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/CountryRewardItem.json")
	pRewardWidget = GetItemWidget(pRewardItemTemp)
	local img_bgicon = tolua.cast(pRewardWidget:getChildByName("Image_bg"),"ImageView")
	local image_icon = tolua.cast(img_bgicon:getChildByName("Image_item"),"ImageView")
	local label_typeNum = tolua.cast(img_bgicon:getChildByName("Label_typeNum"),"Label")
	local label_name = tolua.cast(img_bgicon:getChildByName("Label_name"),"Label")
	local btn_reward = tolua.cast(img_bgicon:getChildByName("Button_get"),"Button")
	btn_reward:setTag(value.id)
	--奖励物品的名字
	-- local tab_type,name = GetRewardInfoByID(value.id)
	local Btn_Text = LabelLayer.createStrokeLabel(25, CommonData.g_FONT1, "领取", ccp(0, 0), ccc3(33,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	
	label_name:setText(value.name)

	-- label_Num:setText(value.num)
	--奖励物品图标
	local reward_type = nil
	local iconID = nil
	local n_ID = value.id + 1
	--value.id 为0时说明为物品,走物品表
	local iconID,reward_type,is_coin = GetDataByID(n_ID)
	local pControl = nil
	if tonumber(is_coin) == 0 then
		pControl = UIInterface.MakeHeadIcon(image_icon,ICONTYPE.ITEM_ICON,iconID,nil,nil,nil,6,nil)
	else
		pControl = UIInterface.MakeHeadIcon(image_icon,ICONTYPE.COIN_ICON,iconID,nil,nil,nil,7,nil)
	end
	
	local l_tynum = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, reward_type, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	label_typeNum:addChild(l_tynum)

	local pLbItemNum = Label:create()
	pLbItemNum:setPosition(ccp(-50,-42))
	pLbItemNum:setFontSize(24)
	pLbItemNum:setName("LabelNum")
	pLbItemNum:setText(value.num)
	pLbItemNum:setAnchorPoint(ccp(0, 0.5))
	pControl:addChild(pLbItemNum)

	--领取奖励回调
	local function _Click_GetReward_CallBack( sender,eventType )
		local pSender = tolua.cast(sender,"Button")
		local pTag = pSender:getTag()
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			--[[if CheckBagIsFull() == false then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(503,nil)
				pTips = nil
				return
			end]]--
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1479,nil)
				pTips = nil
				local tabs_reward = {}

				tabs_reward = GetRewardDataByServer()

				if next(tabs_reward) ~= nil then
					for key,value in pairs(tabs_reward) do
						if tonumber(value["num"]) > 0 then
							loadItemInfo(value,key)
						end
					end
					print("奖励领取协议")
				else
					cleanListView(plistView)
				end
				plistView:removeItem(key-1)
			end
			Packet_RewardGet.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_RewardGet.CreatPacket(value.id))
			NetWorkLoadingLayer.loadingShow(true)
		end
	end 
	btn_reward:addChild(Btn_Text)
	btn_reward:addTouchEventListener(_Click_GetReward_CallBack)

	plistView:setItemsMargin(10)
	plistView:pushBackCustomItem(pRewardWidget)
end

function GetDataByServer(  )
	--获取奖励物品的信息
	if m_RewardLayer == nil then
		return
	end
	cleanListView(plistView)
	-- plistView = tolua.cast(m_RewardLayer:getWidgetByName("ListView_item"),"ListView")
	local tab_reward = {}
	tab_reward = GetRewardDataByServer()
	if next(tab_reward) ~= nil then
		for key,value in pairs(tab_reward) do
			if tonumber(value["num"]) > 0 then
				loadItemInfo(value,key)
			end
		end
	else
		cleanListView(plistView)
	end
end

local function initWidgets(  )
	local img_bg = tolua.cast(m_RewardLayer:getWidgetByName("Image_bg"),"ImageView")
	plistView = tolua.cast(m_RewardLayer:getWidgetByName("ListView_item"),"ListView")
	local btn_all = tolua.cast(m_RewardLayer:getWidgetByName("Button_have"),"Button")
	local img_name = tolua.cast(m_RewardLayer:getWidgetByName("Image_name"),"ImageView")

	if plistView ~= nil then
		plistView:setClippingType(1)
	end

	local Btn_text = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "全部领取", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -3), 3)
	btn_all:addChild(Btn_text)

	local function _Click_GetAllReward_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local tab_reward = {}
			tab_reward = GetRewardDataByServer()
			if next(tab_reward) ~= nil then
				--[[if CheckBagIsFull() == false then
					TipLayer.createTimeLayer("您的背包已满", 2)
					return
				end]]--
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					--领取过后刷新列表
					GetDataByServer()	
					cleanListView(plistView)
				end
				Packet_RewardGet.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_RewardGet.CreatPacket(-1))
				NetWorkLoadingLayer.loadingShow(true)
			else
				TipLayer.createTimeLayer("无奖励可领取", 2)
			end
		end
	end
	btn_all:addTouchEventListener(_Click_GetAllReward_CallBack)
	--获取奖励的信息
	GetDataByServer()
end

function createRewardLayer( n_Root )
	initData()
	m_RewardLayer = TouchGroup:create()									-- 背景层
    m_RewardLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryRewardLayer.json") )
    n_Root:addChild(m_RewardLayer,1999,1999)
    initWidgets()

    -- local btn_return = tolua.cast(m_RewardLayer:getWidgetByName("Button_return"),"Button")
    -- btn_return:addTouchEventListener(_Click_Return_CallBack)

    local panel_return = tolua.cast(m_RewardLayer:getWidgetByName("Panel_reward"),"Layout")
	panel_return:addTouchEventListener(_Click_Return_CallBack)

    return m_RewardLayer
end