
require "Script/serverDB/server_equipDB"
require "Script/Common/CommonData"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/equipt"

module("GetListEquip", package.seeall)




function getTableListByGird(nGrid)
	--得到表
	local copy_table_ep = server_equipDB.GetCopyTable()
	local table_grid = {} --存储此类型所有格子
	local m_temp_id = server_equipDB.GetTempIdByGrid(nGrid)
	local m_type_ep = equipt.getFieldByIdAndIndex(m_temp_id,"Type")
	
	local m_bEquiped = server_matrixDB.IsShangZhenEquip(nGrid)
	--遍历表
	for key,value in pairs (copy_table_ep) do
		local l_bEquiped = server_matrixDB.IsShangZhenEquip(value["Grid"])
		if l_bEquiped == m_bEquiped then
			local l_id = value["TempID"]
			local l_type = equipt.getFieldByIdAndIndex(l_id,"Type")
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