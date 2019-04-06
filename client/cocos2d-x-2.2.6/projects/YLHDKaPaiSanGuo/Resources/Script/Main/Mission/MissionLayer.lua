require "Script/Common/Common"
require "Script/Main/Mission/MissionData"
require "Script/Main/Mission/MissionLogic"
require "Script/Main/Mission/MissionContentLayer"
require "Script/Main/Mission/MissionAppLayer"

module("MissionLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 

local m_MissionLayer = nil
local m_baseLayer 	 = nil

local function InitVars()
	m_MissionLayer = nil
	m_baseLayer    = nil
end

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setText(text)
	label:setPosition(pos)
	return label
end

local function _Button_Return_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
		m_MissionLayer:removeFromParentAndCleanup(true)
		InitVars()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Mission_CallFunc( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
        if sender:getTag() ~= MISSION_TYPE.MISSION_HOPE then
	        if sender:getTag() == MISSION_TYPE.MISSION_ARMY then
	        	local appLayer = MissionAppLayer.CreateMissionAppLayer()
		        if appLayer ~= nil then
	        		m_baseLayer:addChild(appLayer, 1001)
	        	end
	        else
	        	m_MissionLayer:setVisible(false)
		        local contentLayer = MissionContentLayer.CreateMissionLayer(sender:getTag(), m_MissionLayer)
	        	if contentLayer ~= nil then
	        		m_baseLayer:addChild(contentLayer, 1000)
	        	end
	       	end
	    end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitItem( nIndex, nBase, nBaseInfo )
	local pTitle_Storke = nil
	local pInfoLabel 	= nil
	if nIndex == MISSION_TYPE.MISSION_COUNTRY then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "国 家 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
		pInfoLabel    = CreateLabel("21:00 发布国家任务", 18, ccc3(51,25,13), CommonData.g_FONT3, ccp(0,0))
	elseif nIndex == MISSION_TYPE.MISSION_ARMY then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "军 团 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
		pInfoLabel    = CreateLabel("由军团长发布任务", 18, ccc3(51,25,13), CommonData.g_FONT3, ccp(0,0))
	elseif nIndex == MISSION_TYPE.MISSION_SHILIAN then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "试 炼 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)		
		pInfoLabel    = CreateLabel("由国王发布任务", 18, ccc3(51,25,13), CommonData.g_FONT3, ccp(0,0))
	elseif nIndex == MISSION_TYPE.MISSION_LEVELUP then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "升 级 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
		pInfoLabel    = CreateLabel("由国王发布任务", 18, ccc3(51,25,13), CommonData.g_FONT3, ccp(0,0))
	elseif nIndex == MISSION_TYPE.MISSION_RANDOM then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "随 机 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
		pInfoLabel    = CreateLabel("随机出发,全凭运气", 18, ccc3(51,25,13), CommonData.g_FONT3, ccp(0,0))
	elseif nIndex == MISSION_TYPE.MISSION_HOPE then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "敬 请 期 待", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
		nBaseInfo:setVisible(false)
	end
	if pTitle_Storke ~= nil then
		nBase:addChild(pTitle_Storke,1)
	end
	if pInfoLabel ~= nil then
		nBaseInfo:addChild(pInfoLabel,1)
	end
end

local function InitMissionUI( )
	for i=1,6 do
	    local Image_MissionItem = tolua.cast(m_MissionLayer:getWidgetByName("Image_CountryMission_"..i),"ImageView")
	    local Image_LightBg 	= tolua.cast(Image_MissionItem:getChildByName("Image_bg"),"ImageView")
		if Image_MissionItem == nil then
			print("Image_MissionItem is nil")
			return false
		else
			Image_MissionItem:setTag(i)
			Image_MissionItem:setTouchEnabled(true)
			Image_MissionItem:addTouchEventListener(_Click_Mission_CallFunc)
			InitItem(i, Image_MissionItem, Image_LightBg)
		end
	end
end
--create entrance
function CreateMissionLayer(nBase)
	InitVars()
	m_MissionLayer = TouchGroup:create()
	m_MissionLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MissionMainLayer.json"))

	InitMissionUI()

    --按钮事件设置
    local Button_Return = tolua.cast(m_MissionLayer:getWidgetByName("Button_Return"),"Button")
	if Button_Return == nil then
		print("Button_Return is nil")
		return false
	else
		Button_Return:addTouchEventListener(_Button_Return_CallBack)
	end

	m_baseLayer = nBase
    
	return  m_MissionLayer
end