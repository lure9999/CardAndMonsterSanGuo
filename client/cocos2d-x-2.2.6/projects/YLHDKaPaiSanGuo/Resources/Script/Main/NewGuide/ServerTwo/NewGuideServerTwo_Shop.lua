
--celina 新手引导的服务器第二步的酒馆
module("NewGuideServerTwo_Shop", package.seeall)



local  AddGuideIcon = NewGuideLayer.AddGuideIcon
local GetGuideIcon = NewGuideLayer.GetGuideIcon

local m_CallBack = nil 
local pAnimationIcon = nil


local function _Click_WJ_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		pAnimationIcon:setVisible(false)
		pAnimationIcon:setTouchEnabled(false)
		LuckyDrawLayer.GetLuckyDrawByNewGuilde(3)
	end
end
--关闭获得奖品的界面
local function _Click_OK_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		pAnimationIcon:setVisible(false)
		pAnimationIcon:setTouchEnabled(false)
		LuckyDrawLayer.GetLuckyDrawByNewGuilde(4)
		
		if m_CallBack~=nil then
			m_CallBack()
		end
	end
end

local function Close_CallBack()
	pAnimationIcon:setVisible(true)
	pAnimationIcon:setTouchEnabled(true)
	pAnimationIcon:setPosition(ccp(720,10))
	pAnimationIcon:addTouchEventListener(_Click_OK_CallBack)
end
--抽出武将的回调
local function WJ_CallBack()
	pAnimationIcon:setVisible(true)
	pAnimationIcon:setTouchEnabled(true)
	pAnimationIcon:setPosition(ccp(520,60))
	pAnimationIcon:addTouchEventListener(_Click_WJ_CallBack)
end
local function _Click_Free_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--去调用接口
		LuckyDrawLayer.GetLuckyDrawByNewGuilde(0,WJ_CallBack,Close_CallBack)
		pAnimationIcon:setVisible(false)
		pAnimationIcon:setTouchEnabled(false)
	end	
end
--点击了主界面的酒馆
local function _Click_Lucky_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerSmithy_Tag)
		if temp == nil then 
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			require "Script/Main/LuckyDraw/LuckyDrawLayer"
			local pLayerLuckyDraw = LuckyDrawLayer.CreateLuckyDrawLayer()
			scenetemp:addChild(pLayerLuckyDraw,layerSmithy_Tag,layerSmithy_Tag)
			MainScene.PushUILayer(pLayerLuckyDraw)
			pAnimationIcon:setPosition(ccp(300,200))
			pAnimationIcon:addTouchEventListener(_Click_Free_CallBack)
		else
			print("已经打开了酒馆界面")
		end		
	end

end
function DealGuideGropShop(fCallBack)
	m_CallBack = fCallBack
	AddGuideIcon(ccp(260,260))
	pAnimationIcon = GetGuideIcon()
	pAnimationIcon:setTouchEnabled(true)
	pAnimationIcon:addTouchEventListener(_Click_Lucky_CallBack)
end