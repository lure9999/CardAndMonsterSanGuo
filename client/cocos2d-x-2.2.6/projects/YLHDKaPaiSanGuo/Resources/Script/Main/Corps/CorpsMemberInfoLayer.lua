module("CorpsMemberInfoLayer",package.seeall)

m_pMemberInfoLayer = nil

local function initVar(  )
	m_pMemberInfoLayer = nil
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		m_pMemberInfoLayer:removeFromParentAndCleanup(false)
	end
end

function ShowMemberLayer( nCurrentType )
	initVar()

	m_pMemberInfoLayer = TouchGroup:create()
	m_pMemberInfoLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/Corps_MemberList.json"))

	local btn_return = tolua.cast(m_pMemberInfoLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_Return_CallBack)

	--initData()

	return m_pMemberInfoLayer
end