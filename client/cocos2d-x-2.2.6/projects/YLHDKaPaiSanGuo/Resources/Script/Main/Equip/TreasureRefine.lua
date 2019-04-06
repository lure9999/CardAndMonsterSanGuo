


module("TreasureRefine", package.seeall)


--变量
local m_lyTreasureRefine = nil 
local m_gird_refine  = nil 

--逻辑
local GetBRefineLimit = EquipStrengthenLogic.GetBRefineLimit
local ToRefineTreasure = RefineLogic.ToRefineTreasure
local AddNewLayer  = TreasureStrengthenLogic.AddNewLayer
--数据
local GetCurLvByGird = EquipListData.GetCurLvByGird

function GetRefineUI()
	return m_lyTreasureRefine
end
--[[local function InitData(nGrid)
	
end]]--


local function InitUI(nGrid)
	if GetBRefineLimit(nGrid) == true then
		--达到极限值
		m_lyTreasureRefine:removeAllChildrenWithCleanup(true)
		AddNewLayer(m_lyTreasureRefine,StrengthenLimitUI.createStrengthenLimitUI(nGrid))
	else
		--达不到极限值
		StrengthenNarmalLayer.AddStrengthenNarmalLayer(m_lyTreasureRefine,nGrid,1)
	end
end


--精炼按钮
local function _Btn_JingLian_CallBack()
	local function RefineCallBack(nGrid)
		--[[print("_Btn_JingLian_CallBack")
		print(nGrid)
		Pause()]]--
		
		InitUI(nGrid)
		EquipOperateLayer.updateEquipInfo(nGrid)
		--EquipCommon.Update(ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE,GetCurLvByGird(nGrid),nGrid)
		EquipCommon.Update(ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE,nGrid)
		local function effect_02()
		end
		local Image_20 = EquipOperateLayer.getImgIcon():getChildByTag(50)
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
		"StrengthenEquip_effect_01", 
		"qianghua02", 
		Image_20, 
		ccp(0, 0),
		effect_02,
		10)
	end
   ToRefineTreasure(m_gird_refine,RefineCallBack)
end

local function InitVars()
	m_lyTreasureRefine = nil
	m_gird_refine = nil
end

function CreateTreasureRefine( nTreasureGrid )
	InitVars()
	m_gird_refine = nTreasureGrid
	m_lyTreasureRefine = TouchGroup:create()
	m_lyTreasureRefine:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/Treasure_Refine.json" ) )
	
	--InitData(nTreasureGrid)
	InitUI(nTreasureGrid)
	local btn_jl = tolua.cast(m_lyTreasureRefine:getWidgetByName("btn_qh"),"Button")
	CreateBtnCallBack(btn_jl,"精炼",36,_Btn_JingLian_CallBack)

	return m_lyTreasureRefine
end