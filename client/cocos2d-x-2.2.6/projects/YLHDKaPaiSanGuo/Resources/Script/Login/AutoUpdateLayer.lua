

module("AutoUpdateLayer", package.seeall)

local m_lyAutoUpdate = nil
local m_strAllVer = nil
local m_updateVer = nil
-- 确定按钮回调
local function _Button_Confrim_AutoUpdate_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		Pause()
		local Panel_Confrim = tolua.cast(m_lyAutoUpdate:getWidgetByName("Panel_ConfrimUpdate"), "Layout")
		 local Image_Progress = tolua.cast(m_lyAutoUpdate:getWidgetByName("Image_Progress"), "ImageView")
		 if Image_Progress~=nil then
		 	Image_Progress:setVisible(true)
		 end
		Panel_Confrim:setVisible(false)
		StartUpdate(true)
	end
end

-- 取消按钮回调
local function _Button_Cancel_AutoUpdate_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		CCDirector:sharedDirector():endToLua()
	end
end

function createAutoUpdateLayer( strAllVer )
	--print("createAutoUpdateLayer")
	--Pause()
	local sceneGame = CCDirector:sharedDirector():getRunningScene()
	m_lyAutoUpdate = TouchGroup:create()									-- 背景层
    m_lyAutoUpdate:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/AutoUpdateLayer.json") )
    sceneGame:addChild(m_lyAutoUpdate, layerAuotoUpdate_Tag, layerAuotoUpdate_Tag)
	m_lyAutoUpdate:setZOrder(0)
	local Button_Confrim = tolua.cast(m_lyAutoUpdate:getWidgetByName("Button_Confrim"), "Button")
	Button_Confrim:addTouchEventListener(_Button_Confrim_AutoUpdate_CallBack)

	local Button_Cancel = tolua.cast(m_lyAutoUpdate:getWidgetByName("Button_Cancel"), "Button")
  	Button_Cancel:addTouchEventListener(_Button_Cancel_AutoUpdate_CallBack)
	--[[Button_Confrim:loadTextures("Image/imgres/button/btn_blue.png","Image/imgres/button/btn_blue.png",nil)
	Button_Confrim:addTouchEventListener(_Button_Confrim_AutoUpdate_CallBack)
	Button_Confrim:setPosition(ccp(570,320))
	m_lyAutoUpdate:addChild(Button_Confrim)]]--
  	-- 所有需要更新的版本号
  	m_strAllVer = strAllVer
  	if m_strAllVer~="" then
  		-- 获取第一个需要更新的URL
		local url=GetUpdateUrl()
		-- 根据第一个URL来检测是否有更新包
		print("=======")
  		CheckUpdate(url)
  	end
	return m_lyAutoUpdate
end

function  getUpdateVer()
	print("getUpdateVer")
	local ver = ""
	if m_strAllVer~="" then
		local idx = string.find(m_strAllVer,"|")
		if idx~=nil then
			ver = string.sub(m_strAllVer,0,idx-1)
			m_strAllVer = string.sub(m_strAllVer,idx+1)
		end
	end
	m_updateVer = ver

	return ver
end

function getCruUpdateVer(  )
	return m_updateVer
end
function GetUpdateUrl( )
	local ver = getUpdateVer()
	local url = ""
	if ver~="" then
		url = string.format(CommonData.g_szFtpUrl .. "/pub/%s/ver.ini",tostring(ver))
	end
	return url
end