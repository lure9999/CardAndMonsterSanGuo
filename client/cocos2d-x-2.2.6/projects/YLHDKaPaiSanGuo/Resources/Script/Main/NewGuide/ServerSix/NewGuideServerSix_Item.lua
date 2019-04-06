
--新手引导的服务器步骤第六大步骤之背包 celina
module("NewGuideServerSix_Item", package.seeall)

local GetGuideIcon = NewGuideLayer.GetGuideIcon
local AddGuideIcon = NewGuideLayer.AddGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide

local m_Item_CallBack = nil 
local m_guideAnimation = nil 

local function _Close_Item_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		ItemListLayer.NewGuideClose()
		DeleteGuide()
		if m_Item_CallBack~=nil then
			m_Item_CallBack()
		end
	end
end
local function _Click_UseOK_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		TipLayer.DeleteGuideTipsOK()
		m_guideAnimation:setPosition(ccp(105,550))
		m_guideAnimation:addTouchEventListener(_Close_Item_CallBack)
	end
end
--使用物品OK
local function UseItemOK()
	if m_guideAnimation~=nil then
		m_guideAnimation:setPosition(ccp(495,175))
		m_guideAnimation:addTouchEventListener(_Click_UseOK_CallBack)
	end
end
local function _Click_Use_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--使用物品
		ItemBtn.NewGuideUseItem(208,UseItemOK)
	end
end
local function _Select_DuKang()
	--移到使用
	if m_guideAnimation~=nil then
		m_guideAnimation:setPosition(ccp(350,20))
		m_guideAnimation:addTouchEventListener(_Click_Use_CallBack)
	end
end
local function _Click_DuKang_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--选取杜康酒
		ItemListLayer.SelectItemByID(208,_Select_DuKang)
	end
end

function OpenItemLayer(fCallBack)
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerItemList_Tag)
	m_Item_CallBack = fCallBack
	require "Script/Main/Item/ItemListLayer"
	if tempCur == nil  then
		local function OpenItem()
			NetWorkLoadingLayer.loadingHideNow()
			--ClearUI()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			MainScene.DeleteUILayer(ItemListLayer.GetUIControl())
			local item_item = ItemListLayer.CreateItemListLayer()
			scenetemp:addChild(item_item,layerItemList_Tag,layerItemList_Tag)
			MainScene.PushUILayer(item_item)
			m_guideAnimation = GetGuideIcon()
			if m_guideAnimation~=nil then
				m_guideAnimation:setPosition(ccp(500,260))
				m_guideAnimation:addTouchEventListener(_Click_DuKang_CallBack)
			end
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_GetItemList.SetSuccessCallBack(OpenItem)
		network.NetWorkEvent(Packet_GetItemList.CreatPacket())
	end

end