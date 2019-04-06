

--新手引导的服务器步骤第六大步骤之打开背包 celina
module("NewGuideServerSix_MainSceneBtn", package.seeall)

local GetGuideIcon = NewGuideLayer.GetGuideIcon
local AddGuideIcon = NewGuideLayer.AddGuideIcon


local pAnimationGuide = nil 
local m_Btn_CallBack = nil 
local m_pos_btn = nil 

local function _OpenItem_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		if m_Btn_CallBack~=nil then
			m_Btn_CallBack()
			m_Btn_CallBack = nil 
		end
	end
end
local function _OpenBtn_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		MainBtnLayer.SetRootBtnState(false)
		if m_pos_btn~=nil then
			--pAnimationGuide:setPosition(ccp(1020,220))
			pAnimationGuide:setPosition(m_pos_btn)
		end
		
		pAnimationGuide:addTouchEventListener(_OpenItem_CallBack)
	end
end


function OpenItemBtn(fCallBack,pos1)
	m_Btn_CallBack = fCallBack
	m_pos_btn = pos1
	MainBtnLayer.SetRootBtnState(true)
	pAnimationGuide = GetGuideIcon()
	if pAnimationGuide ==nil then
		AddGuideIcon(ccp(1070,50))
		--AddGuideIcon(pos)
		pAnimationGuide = GetGuideIcon()
	end
	if pAnimationGuide~=nil then
		pAnimationGuide:setTouchEnabled(true)
		pAnimationGuide:addTouchEventListener(_OpenBtn_CallBack)
	end
end




