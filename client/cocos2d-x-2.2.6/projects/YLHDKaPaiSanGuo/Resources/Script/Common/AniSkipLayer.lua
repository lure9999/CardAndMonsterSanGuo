
module("AniSkipLayer", package.seeall)

local m_AniSKil = nil
local m_pSkipCallBackFun = nil

local function InitVars()
	m_AniSKil = nil
end

local function _Click_Button_Skip_CallFunc(sender, eventType)
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		if m_pSkipCallBackFun ~= nil then 
			m_pSkipCallBackFun() 
		else
			print("no callBack")
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function Create(funCallBack)
	InitVars()
	m_AniSKil = TouchGroup:create()									-- 背景层
    m_AniSKil:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/AnimaitionSkipLayer.json") )

    m_pSkipCallBackFun = funCallBack

    local nImgTop = tolua.cast(m_AniSKil:getWidgetByName("Image_Top"), "ImageView")
    local nImgBottom = tolua.cast(m_AniSKil:getWidgetByName("Image_Bottom"), "ImageView")
    local nSkipBtn = tolua.cast(m_AniSKil:getWidgetByName("Button_Skip"), "Button")
    nSkipBtn:addTouchEventListener(_Click_Button_Skip_CallFunc)

    --入场动画
	nImgTop:runAction(CCMoveBy:create(0.2, ccp(0,-nImgTop:getContentSize().height)))
	nImgBottom:runAction(CCMoveBy:create(0.2, ccp(0,nImgBottom:getContentSize().height)))

    local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height

    m_AniSKil:setPosition(ccp(nOff_W/2, nOff_H/2))

    local tableFixControl = {
    {
    	["off_x"] = 0,
    	["off_y"] = 0,
    	["control"] = tolua.cast(m_AniSKil:getWidgetByName("Button_Skip"), "Button"),
    },
}
	for key,value in pairs(tableFixControl) do
		if value["control"] ~= nil then
			local nWidth = value["control"]:getPositionX() - nOff_W + value["off_x"]
			local nHeight = value["control"]:getPositionY() - nOff_H + value["off_y"]
    		value["control"]:setPosition(ccp(nWidth, nHeight))
		end
	end

	return m_AniSKil
end