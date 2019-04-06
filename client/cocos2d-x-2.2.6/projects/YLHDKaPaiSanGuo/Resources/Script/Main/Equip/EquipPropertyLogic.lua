
module("EquipPropertyLogic", package.seeall)



--数据

local GetCurLvByGird  = EquipListData.GetCurLvByGird
local GetLockLvByGrid = EquipListData.GetLockLvByGrid
local GetXLState      = EquipListData.GetXLState
--nLayerType 区分是装备界面进来的还是阵容界面进来的
function GetShowBtn(nLayerType)
	if nLayerType == E_LAYER_TYPE.E_LAYER_TYPE_EQUIP  or nLayerType == E_LAYER_TYPE.E_LAYER_TYPE_ITEM  then
		return false
	end
	return true
end

function IsLockLv(nGrid)
	if GetCurLvByGird(nGrid)>= GetLockLvByGrid(nGrid,"QiangHLv_1") then
		return true
	end
	return false
end
function GetBRefine(nGrid)
	if tonumber(GetXLState(nGrid)) <1 then
		return false
	end
	return true
end

function CheckXLJL(nType)
	local tabXL = nil
	if nType == 1 then
		tabXL = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_21)
	else
		tabXL = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_22)
	end
	if tabXL~=nil then
		if tonumber(tabXL.vipLimit) == 0 then
			return false
		end
	end
	return true
end