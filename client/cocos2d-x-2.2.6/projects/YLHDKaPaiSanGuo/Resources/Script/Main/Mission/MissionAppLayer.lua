require "Script/Common/Common"
require "Script/Main/Mission/MissionData"
require "Script/Main/Mission/MissionLogic"


module("MissionAppLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 

local m_MissionAppLayer = nil

local function InitVars()
	m_MissionAppLayer = nil
end


local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

local function _Click_Return_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		m_MissionAppLayer:removeFromParentAndCleanup(true)
		InitVars()
	elseif  eventType == TouchEventType.began then
	elseif eventType == TouchEventType.canceled then
	end
end

--create entrance
function CreateMissionAppLayer()
	InitVars()
	m_MissionAppLayer = TouchGroup:create()
	m_MissionAppLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MissionAppointmentLayer.json"))

    --按钮事件设置
    local Image_Return = tolua.cast(m_MissionAppLayer:getWidgetByName("Image_Click"),"ImageView")
	if Image_Return == nil then
		print("Image_Return is nil")
		return false
	else
		Image_Return:addTouchEventListener(_Click_Return_CallBack)
	end
    
	return  m_MissionAppLayer
end