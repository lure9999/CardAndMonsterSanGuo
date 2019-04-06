
module("EquipXilianAfterLayer", package.seeall)
require "Script/Main/Equip/EquipXilianCommonLayer"

--逻辑
local GetAfterXLInfo = EquipXilianLogic.GetAfterXLInfo
local ShowXLMidInfo   = EquipXilianCommonLayer.ShowXLMidInfo
local ShowXLBtn      = EquipXilianCommonLayer.ShowXLBtn


function ToLayerXLAfter(nGrid,mLayer,listLable,fContinueXL,fReplace,fCancel)
	--洗炼值
	--中间部分
	local panel_mid = tolua.cast(mLayer:getWidgetByName("Panel_before_xl"),"Layout")
	panel_mid:setVisible(true)
	ShowXLMidInfo(GetAfterXLInfo(nGrid,listLable),panel_mid,EquipXilianCommonLayer.XL_TYPE.XL_TYPE_AFTER)
	ShowXLBtn(EquipXilianCommonLayer.XL_TYPE.XL_TYPE_AFTER,mLayer,nGrid,fContinueXL,fReplace,fCancel)
end