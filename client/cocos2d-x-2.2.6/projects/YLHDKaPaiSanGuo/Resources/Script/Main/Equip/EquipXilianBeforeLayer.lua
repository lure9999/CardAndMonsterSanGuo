

module("EquipXilianBeforeLayer", package.seeall)

require "Script/Main/Equip/EquipXilianCommonLayer"
--逻辑
local GetDataByXLInfo = EquipXilianLogic.GetDataByXLInfo
local ShowXLMidInfo   = EquipXilianCommonLayer.ShowXLMidInfo
local ShowXLBtn      = EquipXilianCommonLayer.ShowXLBtn

function ToLayerXLBefore(nGrid,mXLLayer,fXLCallBack)
	--中间部分
	local panelMid = tolua.cast(mXLLayer:getWidgetByName("Panel_before_xl"),"Layout")
	panelMid:setVisible(true)
	ShowXLMidInfo(GetDataByXLInfo(nGrid),panelMid,EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE)
	ShowXLBtn(EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE,mXLLayer,nGrid,fXLCallBack)
end