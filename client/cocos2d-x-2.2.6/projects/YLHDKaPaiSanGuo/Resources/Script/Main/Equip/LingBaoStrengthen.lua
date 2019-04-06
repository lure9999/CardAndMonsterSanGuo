require "Script/Main/Equip/StrengthenLimitUI"

module("LingBaoStrengthen", package.seeall)

local m_layer_lingbao = nil 
local m_lingbao_grid = nil 

--数据
local GetCurLvByGird     = EquipListData.GetCurLvByGird
local GetBaseIDByGridStr = EquipListData.GetBaseIDByGridStr
local GetBaseNameByGrid  = EquipListData.GetBaseNameByGrid
local GetBaseValueByGrid = EquipListData.GetBaseValueByGrid
--逻辑
local GetBLimitLayerByGrid = EquipStrengthenLogic.GetBLimitLayerByGrid
local AddNewLayer  = TreasureStrengthenLogic.AddNewLayer
local ToLingBaoStrengthen = EquipStrengthenLogic.ToLingBaoStrengthen




function GetLingBaoStrengthenUI()
	return m_layer_lingbao
end
local function ShowLBLimitUI(nGrid)
	m_layer_lingbao:removeAllChildrenWithCleanup(true)
	AddNewLayer(m_layer_lingbao,StrengthenLimitUI.createStrengthenLimitUI(nGrid))
end
local function ShowLBNormalUI(nGrid)
	StrengthenNarmalLayer.AddStrengthenNarmalLayer(m_layer_lingbao,nGrid)
end
local function InitUI(nGrid)
	if GetBLimitLayerByGrid(nGrid) == false then
		ShowLBNormalUI(nGrid)
	else
		ShowLBLimitUI(nGrid)
	end	
end
local function UpdateLingBao(nGrid)
	InitUI(nGrid)
	--EquipCommon.Update(ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO,GetCurLvByGird(nGrid),nGrid)
	EquipCommon.Update(ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO,nGrid)
end
local function _Btn_Qh_LB_CallBack()
	--更新界面 
	local function updateNow()
		EquipOperateLayer.updateEquipInfo(m_lingbao_grid)
		UpdateLingBao(m_lingbao_grid)
	end
	ToLingBaoStrengthen(m_lingbao_grid,GetCurLvByGird(m_lingbao_grid),updateNow)
end

local function InitVars()
	m_layer_lingbao  = nil
	m_lingbao_grid = nil 
end

--传入灵宝的服务器相对应的顺序ID
function CreateLingBaoStrengthen(nGrid)
	InitVars()
	m_lingbao_grid = nGrid
	m_layer_lingbao = TouchGroup:create()
	m_layer_lingbao:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/LingBao_Strength.json" ) )
	InitUI(nGrid)
	local btn_qh_lingbao = tolua.cast(m_layer_lingbao:getWidgetByName("btn_qh"),"Button")
	CreateBtnCallBack(btn_qh_lingbao,"强化",36,_Btn_Qh_LB_CallBack)
	return m_layer_lingbao
end