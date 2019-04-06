

module("EquipXilianInfo", package.seeall)

local m_layer_xilian_info = nil 

local function InitVars()
	m_layer_xilian_info = nil 
end

local function _Btn_Close_CallBack( )
	m_layer_xilian_info:removeFromParentAndCleanup(true)
end
local function _Btn_Strength_CallBack( nGrid )	

	m_layer_xilian_info:removeFromParentAndCleanup(true)
	EquipOperateLayer.UpdateBtn(nGrid)
	
end

function CreateEquipXilianInfo( nGrid )
	m_layer_xilian_info = TouchGroup:create()
	m_layer_xilian_info:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/Up_Xilian_Info.json" ) )
	
	local _btn_close = tolua.cast(m_layer_xilian_info:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack(_btn_close,nil,nil,_Btn_Close_CallBack)
	
	--标题
	local bg_title = tolua.cast(m_layer_xilian_info:getWidgetByName("img_name_bg_up"),"ImageView")
	local title = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,"提升炼化属性上限规则",ccp(25,7),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(title,1,bg_title)
	
	--删掉之前的继续洗炼的提示
	local img_c = tolua.cast(m_layer_xilian_info:getWidgetByName("img_continue"),"ImageView")
	img_c:removeFromParentAndCleanup(true)
	--前往强化的按钮
	local m_btn_up = tolua.cast(m_layer_xilian_info:getWidgetByName("btn_go_qh"),"Button")
	CreateBtnCallBack( m_btn_up,"前往强化",36,_Btn_Strength_CallBack,COLOR_Black,COLOR_White,nGrid )
	
	return m_layer_xilian_info
end