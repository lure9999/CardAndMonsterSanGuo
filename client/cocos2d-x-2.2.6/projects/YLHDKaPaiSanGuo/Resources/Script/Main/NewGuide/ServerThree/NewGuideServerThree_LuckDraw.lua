
--celina 新手引导的服务器第三步的酒馆
module("NewGuideServerThree_LuckDraw", package.seeall)



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
	pAnimationIcon:setPosition(ccp(500,50))
	pAnimationIcon:addTouchEventListener(_Click_WJ_CallBack)
end
local function _Click_Free_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--去调用接口
		LuckyDrawLayer.GetLuckyDrawByNewGuilde(1,WJ_CallBack,Close_CallBack)
		pAnimationIcon:setVisible(false)
		pAnimationIcon:setTouchEnabled(false)
	end	
end

function DealGuideLuckDraw(fCallBack)
	m_CallBack = fCallBack
	
	pAnimationIcon = GetGuideIcon()
	if pAnimationIcon== nil then
		AddGuideIcon(ccp(800,230))
		pAnimationIcon = GetGuideIcon()
	else
		pAnimationIcon:setVisible(true)
		pAnimationIcon:setPosition(ccp(750,180))
	end
	pAnimationIcon:setTouchEnabled(true)
	pAnimationIcon:addTouchEventListener(_Click_Free_CallBack)
end