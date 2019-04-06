module("CountryRewardBtn",package.seeall)

local m_CountryReward  = nil
local function initData(  )
	m_CountryReward  = nil
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		print("领取奖励界面")
		TipLayer.createPopTipLayer("领取奖励界面", 24, COLOR_Green, ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2))
		
	end
end

function ShowRewardBtnLayer( m_Root )
	initData()
	m_CountryReward = TouchGroup:create()
	m_CountryReward:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CountryRewardLayer_btn.json"))
	m_Root:addChild(m_CountryReward,30,30)

	local btn_reward = tolua.cast(m_CountryReward:getWidgetByName("Button_reward"),"Button")
    btn_reward:addTouchEventListener(_Click_Return_CallBack)

	m_CountryReward:retain()
	-- return m_CountryReward
end