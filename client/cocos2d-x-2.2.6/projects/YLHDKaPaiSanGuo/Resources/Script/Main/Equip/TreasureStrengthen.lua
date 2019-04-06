
require "Script/Main/Equip/TreasureStrengthenLogic"
require "Script/Main/Equip/EquipStrengthenLogic"
require "Script/Main/Equip/StrengthenLimitUI"
require "Script/Main/Equip/StrengthenNarmalLayer"

module("TreasureStrengthen", package.seeall)

local m_lyTreasureStrengthen = nil
local m_grid_treasure = nil 


--逻辑
local AddNewLayer  = TreasureStrengthenLogic.AddNewLayer
local GetBLimitLayerByGrid = EquipStrengthenLogic.GetBLimitLayerByGrid
local GetAutoAddTreasureTable = TreasureStrengthenLogic.GetAutoAddTreasureTable
local ToStrengthenBW  = TreasureStrengthenLogic.ToStrengthenBW




--宝物强化的UI
local function ShowTreasureUI(nGrid)
	
	if GetBLimitLayerByGrid(nGrid) == true then
		--达到极限值
		m_lyTreasureStrengthen:removeAllChildrenWithCleanup(true)
		AddNewLayer(m_lyTreasureStrengthen,StrengthenLimitUI.createStrengthenLimitUI(nGrid))
	else
		--达不到极限值
		StrengthenNarmalLayer.AddStrengthenNarmalLayer(m_lyTreasureStrengthen,nGrid)
	end
end
local function InitUI(nGrid)
	ShowTreasureUI(nGrid)
end

--强化按钮
local function _Btn_Strengthen_BW_CallBack( )
    --print("_Btn_Strengthen_BW_CallBack")
	ToStrengthenBW(m_grid_treasure)
end

--自动添加按钮
local function _Btn_AutoAdd_BW_CallBack( )
	--自动添加print("_Btn_AutoAdd_BW_CallBack")
	StrengthenNarmalLayer.UpdateSelectBW(GetAutoAddTreasureTable(m_grid_treasure),m_lyTreasureStrengthen,m_grid_treasure)
end

local function InitVars()
	m_lyTreasureStrengthen = nil
	m_grid_treasure = nil 
end

function GetTreasureUI()
	return m_lyTreasureStrengthen
end
function createTreasureStrengthen( nTreasureGrid )
	InitVars()
	m_grid_treasure = nTreasureGrid
	m_lyTreasureStrengthen = TouchGroup:create()
	m_lyTreasureStrengthen:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/Treasure_Strength.json" ) )
	--print(nTreasureID)
	InitUI(nTreasureGrid)
	
	local btn_qh_bw = tolua.cast(m_lyTreasureStrengthen:getWidgetByName("btn_qh"),"Button")
	CreateBtnCallBack(btn_qh_bw,"强化",36,_Btn_Strengthen_BW_CallBack)
	
	local btn_add_bw = tolua.cast(m_lyTreasureStrengthen:getWidgetByName("btn_autoAdd"),"Button")
	CreateBtnCallBack(btn_add_bw,"自动添加",36,_Btn_AutoAdd_BW_CallBack)
	
	
	return m_lyTreasureStrengthen
end