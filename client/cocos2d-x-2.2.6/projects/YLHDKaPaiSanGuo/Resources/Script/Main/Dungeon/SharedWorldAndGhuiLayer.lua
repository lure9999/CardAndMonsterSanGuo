

--分享到世界、公会界面 celina



module("SharedWorldAndGhuiLayer", package.seeall)


--变量
local m_sharedWorldLayer = nil

local function InitVars()
	m_sharedWorldLayer = nil 
end
local function _Btn_Cancel_SharedWorld_CallBack()
	m_sharedWorldLayer:removeFromParentAndCleanup(true)
	m_sharedWorldLayer = nil 
end
local function _Btn_OK_SharedWorld_CallBack()
	--确定分享然后弹出成功界面
	m_sharedWorldLayer:removeFromParentAndCleanup(true)
	m_sharedWorldLayer = nil 
end
local function ShowUI()
	
	--确定按钮
	local btn_ok_world = tolua.cast(m_sharedWorldLayer:getWidgetByName("btn_s"),"Button")
	CreateBtnCallBack(btn_ok_world,"确定",36,_Btn_OK_SharedWorld_CallBack,nil,nil,nil,nil)
	--取消按钮
	local btn_cancel_world = tolua.cast(m_sharedWorldLayer:getWidgetByName("btn_c"),"Button")
	CreateBtnCallBack(btn_cancel_world,"取消",36,_Btn_Cancel_SharedWorld_CallBack,nil,nil,nil,nil)
end

function ShowSharedWorldAndGHuiLayer()
	InitVars()
	
	m_sharedWorldLayer =  TouchGroup:create()
	m_sharedWorldLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CompeteLayer_SharedWorld.json" ) )
	
	ShowUI()
	
	
	return m_sharedWorldLayer
end