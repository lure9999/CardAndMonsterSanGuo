


module("ItemData", package.seeall)

require "Script/serverDB/server_itemDB"
require "Script/serverDB/resimg"
require "Script/serverDB/item"
require "Script/serverDB/itemrule"
require "Script/serverDB/refining"
require "Script/serverDB/danyao"

local GetEquipDataByType  = EquipListData.GetEquipDataByType
--根据类型获得当前类型的物品的表
function GetTableDataByType(nType)
	local table_by_type = {}
	if tonumber(nType)>=8 then
		--说明是道具  
		local m_table_items = server_itemDB.GetCopyTable()
		for key,value in pairs (m_table_items) do 
			if nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
				--找出所有的消耗品
				if tonumber(value["Type"]) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_DRUG then
					table.insert(table_by_type,value)
				end
			end
			if nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP then
				--找出所有的碎片
				if ( tonumber(value["Type"]) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIPFRAGMENT ) or 
				( tonumber(value["Type"]) >=E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP )then
					
					table.insert(table_by_type,value)
				end
			end
			if nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH then
				if ( tonumber(value["Type"]) >= E_BAGITEM_TYPE.E_BAGITEM_TYPE_GENERALFRAGMENT  )  and 
				   ( tonumber(value["Type"]) <= E_BAGITEM_TYPE.E_BAGITEM_TYPE_DANWAN  )then
				   table.insert(table_by_type,value)
				end
			end	
		end
	end
	if tonumber(nType)>1 and tonumber(nType)<5 then
		--说明是装备部分的
		GetEquipDataByType(nType,table_by_type)
	end
	--[[print("======根据类型获得的物品的表数据为-=====")
	printTab(table_by_type)
	print("=============end=============")
	Pause()]]--
	return table_by_type
end


--得到物品表的数量
function GetItemCounts()
	return tonumber(server_itemDB.GetCount())
end


function BagItemIsFull( )
	return GetItemCounts() >= MAX_BAG_ITME_COUNT
end

function GetEquipCounts()
	return tonumber(server_equipDB.GetCount())
end
function BagEquipIsFull()
	return GetEquipCounts()>= MAX_BAG_EQUIP_COUNT
end

function GetWJCounts()
	return tonumber(server_generalDB.GetCount())
end

function BagWJIsFull()
	return GetWJCounts()>= MAX_BAG_WJ_COUNT
end
--获得某个物品的数据表
function GetTableGoodInfoByKey(m_key)
	return server_itemDB.GetTableByKey(m_key)
end
--获得物品的类型
function GetTypeByKey(m_key)
	local l_table = getTableGoodInfoByKey(m_key)
	return tonumber(l_table["Type"])
end

--获得物品的id
function GetTempIDByGrid(nGrid)
	return tonumber(server_itemDB.GetTempIdByGird(nGrid))
end
--获得物品的规则
function GetGoodsRuleByGrid(nGrid)
	return item.getFieldByIdAndIndex(GetTempIDByGrid(nGrid),"Rule")
end
--该碎片是否可使用
function GetBCanUseByRuleID(nRuleID)
	local nCanUse = tonumber(itemrule.getFieldByIdAndIndex(nRuleID,"CANUSE"))
	if nCanUse == 1 then
		return true
	end
	return false
end
--获得炼化的消耗ID
function GetLHCoumeIDByItemID(nTempID)
	return refining.getFieldByIdAndIndex(nTempID,"LianH_ConsumeID")
end
--该碎片是否可以炼化
function GetBCanLHByRuleID(nRuleID)
	local nCanLH = tonumber(itemrule.getFieldByIdAndIndex(nRuleID,"DISCARD"))
	if nCanLH == 1 then
		return true
	end
	return false
end
function GetNameByTempId(nTempID)
	return item.getFieldByIdAndIndex(nTempID,"name")
end
function GetPriceByGird(nGird)
	local l_id = GetTempIDByGrid(nGird)
	return item.getFieldByIdAndIndex(l_id,"Price")
end
function GetDesByGird(nGird)
	local l_id = GetTempIDByGrid(nGird)
	return item.getFieldByIdAndIndex(l_id,"des")
end
function GetNumByGird(nGird)
	return tonumber(server_itemDB.GetItemNumberByGrid(nGird))
end
function GetNumByTempID(Tempid)
	return tonumber(server_itemDB.GetItemNumberByTempId(Tempid))
end

function GetItemEventType( nTempID )
	return tonumber(item.getFieldByIdAndIndex(nTempID,"event_type"))
end

function GetItemEventParaA( nTempID )
	return tonumber(item.getFieldByIdAndIndex(nTempID,"event_para_A"))
end

function GetItemEventParaB( nTempID )
	return tonumber(item.getFieldByIdAndIndex(nTempID,"event_para_B"))
end

function GetItemEventParaC( nTempID )
	return tonumber(item.getFieldByIdAndIndex(nTempID,"event_para_C"))
end

function GetNumJHunByGird(nGird)
	return GetItemEventParaA(GetTempIDByGrid(nGird))
end

function GetItemCanUse(nGrid)
	local Rule = item.getFieldByIdAndIndex(GetTempIDByGrid(nGrid), "Rule")
	return itemrule.getFieldByIdAndIndex(Rule, "CANUSE")
end

function GetBHaveWJ(nGird)
	local bHave = false
	local id_wj_zk = item.getFieldByIdAndIndex(GetTempIDByGrid(nGird),"event_para_B")
	--用整卡的ID找参数A获得武将的ID
	local id_wj = item.getFieldByIdAndIndex(id_wj_zk,"event_para_A")
	local need_Max = item.getFieldByIdAndIndex(GetTempIDByGrid(nGird),"event_para_A")
	if (tonumber(need_Max) == 0 ) or (server_generalDB.GetIsHaveWJ(id_wj)==true ) then
		bHave = true 
	else
		bHave = false
	end
	return bHave
end

function CheckTempID(nGrid)
	
	local table_cur = getItemCopyData()
	local count = 0
	for key,value in pairs (table_cur) do 
		if tonumber(value["Grid"]) == tonumber(nGrid) then
			count = count +1
		end
	end
	if count == 0 then
		return false
	else
		return true
	end
	
end

function GetItemDescByTempID(nTempID)
	return item.getFieldByIdAndIndex(nTempID,"des")
end

function GetItemTypeByTempID(nTempID)
	--print(item.getFieldByIdAndIndex(nTempID,"item_type"))
	return tonumber(item.getFieldByIdAndIndex(nTempID,"item_type"))
end
function GetItemPathByTempID(nTempID)
	--[[print(nTempID)
	Pause()]]--
	local res_id = item.getFieldByIdAndIndex(nTempID,"res_id")
	local tabRes = resimg.getTable()
	local bHave = false 
	for key,value in pairs(tabRes) do 
		if key  == "id_"..res_id then
			bHave = true 
		end
		
	end
	if bHave == false then 
		return resimg.getFieldByIdAndIndex(201, "icon_path")
	end
	return resimg.getFieldByIdAndIndex(res_id, "icon_path")
end
function GetColorByTempID(nTempID)
	local nPinzhi = item.getFieldByIdAndIndex(nTempID,"pinzhi")
	if tonumber(nPinzhi) == 0 then nPinzhi = 1 end
	return nPinzhi
end
function GetItemColorPathByTempID(nTempID)
	if tonumber(GetItemTypeByTempID(nTempID)) == 1 then
		return string.format("Image/imgres/common/color/wj_pz%d.png",GetColorByTempID(nTempID))
	end
	if tonumber(GetItemTypeByTempID(nTempID)) == 2 then
		return string.format("Image/imgres/common/color/item_pz%d.png",GetColorByTempID(nTempID))
	end
	if tonumber(GetItemTypeByTempID(nTempID)) == 3 then -- 将魂
		return string.format("Image/imgres/common/color/item_pz%d.png",GetColorByTempID(nTempID))
	end	
	
	return  string.format("Image/imgres/common/color/wj_pz%d.png",GetColorByTempID(nTempID))
end
function GetStonePathByTempId(nTempID)
	return string.format("Image/imgres/common/color/stone_%d.png",GetColorByTempID(nTempID))
end	
function GetHunPathByTempID(nTempID)
	return string.format("Image/imgres/common/color/hun_%d.png",GetColorByTempID(nTempID))
end

function GetPlayerLv()
	return tonumber(server_mainDB.getMainData("level"))
end

function GetItemGridByID(itemID)
	return server_itemDB.GetGird(itemID)
end

function GetTabItemIDByDYLv(nLv)
	local tab = {}
	for i=1,9 do 
		local str = string.format("Dan%dItemID",i)
		local itemID = danyao.getFieldByIdAndIndex(nLv,str)
		table.insert(tab,itemID)
	end
	return tab
end

function GetDYNameByLv(nLv)
	return danyao.getFieldByIdAndIndex(nLv,"JDanName")
end
