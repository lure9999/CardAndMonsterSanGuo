

require "Script/serverDB/server_equipDB"
require "Script/Common/CommonData"
require "Script/serverDB/server_matrixDB"
require "Script/Main/Equip/EquipListData"

module("EquipOperateData", package.seeall)

--基础数据
local GetTypeByGrid = EquipListData.GetTypeByGrid
local GetTempID     = EquipListData.GetTempID
local GetCurLvByGird = EquipListData.GetCurLvByGird
local GetBaseIDByGridStr = EquipListData.GetBaseIDByGridStr

--得到列表当中所有的和此格子相同类型的物品
function GetTableListByGird(nGrid)
	--得到表
	local copy_table_ep = server_equipDB.GetCopyTable()
	local table_grid = {} --存储此类型所有格子
	local m_temp_id = GetTempID(nGrid)
	local m_type_ep = GetTypeByGrid(nGrid)
	
	local m_bEquiped = server_matrixDB.IsShangZhenEquip(nGrid)
	--遍历表
	for key,value in pairs (copy_table_ep) do
		local l_bEquiped = server_matrixDB.IsShangZhenEquip(value["Grid"])
		if l_bEquiped == m_bEquiped then
			local l_grid = value["Grid"]
			local l_type = GetTypeByGrid(l_grid)
			if tonumber(l_type) == tonumber(m_type_ep) then
				table.insert(table_grid,value["Grid"])
			end
		end
	end
	--[[print("nGrid:============"..nGrid)
	print("=====此件物品所有类型的表============")
	printTab(table_grid)
	print("count:"..(#table_grid))]]--
	return table_grid
end

function GetQHLimitLvByGrid(nGrid)
	local limit_strength = equipt.getFieldByIdAndIndex(GetTempID(nGrid),"QiangHLv")
	local l_lv_player = tonumber(CommonData.g_MainDataTable.level)
	local l_limit_lv = l_lv_player*(tonumber(limit_strength)/100)
	--取整
	l_limit_lv = l_limit_lv - l_limit_lv%1
	--if l_limit_lv == 0 then l_limit_lv = 1 end
	
	return l_limit_lv
end
--传入当前的格子，返回基础值
function GetValueBase(nGrid,strBase,nLv)
	local str_d = string.format("Inc_Att_%d",nLv)
	local base_value = nil
	if tonumber(nLv)==0 then
		--print(id..":id")
		base_value = attribute.getFieldByIdAndIndex(GetBaseIDByGridStr(nGrid,strBase),"value")
	else
		base_value = attributincremental.getFieldByIdAndIndex(GetBaseIDByGridStr(nGrid,strBase),str_d)
	end
	return tonumber(base_value)
	
end

