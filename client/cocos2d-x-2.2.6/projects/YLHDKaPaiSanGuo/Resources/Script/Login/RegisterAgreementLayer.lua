

module("RegisterAgreementLayer", package.seeall)

--变量
local m_layerAgreement = nil 

local label_button = LoginCommon.addLableToButton

local function InitVars()
	m_layerAgreement = nil 
end
local function deleteAgreement()
	m_layerAgreement:removeFromParentAndCleanup(true)
	m_layerAgreement = nil 
end
local function _Btn_Know_CallBack(sender,eventType)
	deleteAgreement()
	RegisterLayer.setBtnEnabled(true)
end

local function initUI()
	local img_wen = tolua.cast(m_layerAgreement:getWidgetByName("img_wen_info"),"ImageView")
	local lable_title_word = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"三国萌将志游戏协议",ccp(0,24),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	
	if img_wen:getChildByTag(LoginCommon.TAG_LABEL_BUTTON)~=nil then
		img_wen:getChildByTag(LoginCommon.TAG_LABEL_BUTTON):removeFromParentAndCleanup(true)
	end
	img_wen:addChild(lable_title_word,LoginCommon.TAG_LABEL_BUTTON,LoginCommon.TAG_LABEL_BUTTON)
end

function createLayerAgreement()
	InitVars()
	m_layerAgreement = TouchGroup:create()
	m_layerAgreement:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/RegisterAgreement.json" ) )
	initUI()
	local btn_konw = tolua.cast(m_layerAgreement:getWidgetByName("btn_enter"),"Button")
	CreateBtnCallBack(btn_konw,"朕知道了",36,_Btn_Know_CallBack)
	return m_layerAgreement
end
