
--本文件主要完成物品的使用检测逻辑
module("ItemUseLogic", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

require "Script/serverDB/server_itemDB"

--使用物品的背包来源
local Souce_Type = {
	
	Souce_Type_bag = 0,
	Souce_Type_General = 1,
	
}

--使用返回值
local Return_ID = {
	
	Return_ID_Success = 1,
	Return_ID_Fail = 0,
	Return_ID_Error_Null = -1,
	Return_ID_Error_Money = -2,
	Return_ID_Error_Key = -3,
	Return_ID_Error_General = -4,
	Return_ID_Error_NeedNum = -5,
	Return_ID_Error_MAXLEVEL = -6,
}

local E_ITEM_EVENT_TYPE =
{
	E_ITEM_EVENT_TYPE_NONE			 = 0,		-- 无效果0
	E_ITEM_EVENT_TYPE_DRUG			 = 1,		-- 药物 消耗品1 DRUG_TYPE_DEFINE 【1=主将经验】【2=武将经验】【3=宝物经验】【4=体力】【5=耐力】【6=银币】【7=金币】
	E_ITEM_EVENT_TYPE_BOX				= 2,		-- 宝箱2
	E_ITEM_EVENT_TYPE_EQUIPFRAGMENT		= 3,		-- 碎片3
	E_ITEM_EVENT_TYPE_GENERALFRAGMENT	= 4,		-- 将魂4
	E_ITEM_EVENT_TYPE_DANWAN			= 5,		--丹丸5
	E_ITEM_EVENT_TYPE_GENERAL			= 6,		-- 武将6
	E_ITEM_EVENT_TYPE_EQUIP				= 7,		-- 装备7
	E_ITEM_EVENT_TYPE_TREASURE			= 8,		-- 宝物8
}

-- 消耗品增加类型
local E_DRUG_TYPE = 
{
	E_DRUG_TYPE_MAINEXP			= 1,		--// 主将经验	
	E_DRUG_TYPE_GENERALEXP		= 2,			--// 武将经验
	E_DRUG_TYPE_TREASUREEXP		= 3,			--// 宝物经验
	E_DRUG_TYPE_LITI			= 4,			--// 体力
	E_DRUG_TYPE_NAILI			= 5,			--// 耐力
	E_DRUG_TYPE_SILVER			= 6,			--// 银币
	E_DRUG_TYPE_GOLD			= 7,			--// 金币
	E_DRUG_TYPE_END				= 8,
}

--获得物品数据
local GetBagItemData =  server_itemDB.GetTableByGrid

local GetpItemNumber =  server_itemDB.Get_ItemNumber
local GetpItemTempID =  server_itemDB.Get_ItemTempID
local GetpItemEventType =  server_itemDB.Get_ItemEventType


require "Script/serverDB/item"

--封装一些方法给逻辑用

--检测背包里有没有物品和数量
local function CheckBagItemCount(nItemTempID,nNumber)
	local nCount = server_itemDB.GetItemNumberByTempId(nItemTempID)
	if nCount >= nNumber then 		
		return true
	end 
	
	return false
end

--获得item.lua表的数据
local function Getitemtable_EVENT_PARA_A( itemID )
	
	return item.getFieldByIdAndIndex(itemID,"event_para_A")
	
end

local function Getitemtable_EVENT_PARA_B( itemID )
	
	return item.getFieldByIdAndIndex(itemID,"event_para_B")
	
end

local function Getitemtable_EVENT_PARA_C( itemID )
	
	return item.getFieldByIdAndIndex(itemID,"event_para_C")
	
end


--开箱子
local function OprItemBox(pItem,nNumber)
	
	--检查钥匙
	--获取钥匙id
	local nKeyID = Getitemtable_EVENT_PARA_B(GetpItemTempID(pItem))
	
	--如果要钥匙
	if nKeyID > 0 then 
		
		if CheckBagItemCount(nKeyID,nNumber) == false then 
			
			return Return_ID.Return_ID_Error_Key
			
		end 
		
	end	
	
	return Return_ID.Return_ID_Success
	
end
--使用药品 彦青把逻辑写完维护
local function OprItemDrug(pItem,nNumber)

	local ItemTempID = GetpItemTempID(pItem)
	local iType = Getitemtable_EVENT_PARA_A(ItemTempID)
	local iVel = Getitemtable_EVENT_PARA_B(ItemTempID)
	
	if iType == E_DRUG_TYPE.E_DRUG_TYPE_MAINEXP then
	
		if CommonData.g_MainDataTable.level >= 100 then 
			return Return_ID.Return_ID_Error_MAXLEVEL
		end
		
	elseif iType == E_DRUG_TYPE.E_DRUG_TYPE_GENERALEXP then
		
		return Return_ID.Return_ID_Success
	
	elseif iType == E_DRUG_TYPE.E_DRUG_TYPE_TREASUREEXP then
		return Return_ID.Return_ID_Success
	elseif iType == E_DRUG_TYPE.E_DRUG_TYPE_LITI then
		return Return_ID.Return_ID_Success
	elseif iType == E_DRUG_TYPE.E_DRUG_TYPE_NAILI then
	
		return Return_ID.Return_ID_Success
			
	elseif iType == E_DRUG_TYPE.E_DRUG_TYPE_SILVER then
	
		return Return_ID.Return_ID_Success
	
	elseif iType == E_DRUG_TYPE.E_DRUG_TYPE_GOLD then
	
		return Return_ID.Return_ID_Success
	
	else
		return Return_ID.Return_ID_Error_Null
	end
	
	return Return_ID.Return_ID_Success
end
--使用装备碎片
local function OprItemEquipFragment(pItem,nNumber)
	
	local ItemTempID = GetpItemTempID(pItem)
	local nNeedNum = Getitemtable_EVENT_PARA_A(ItemTempID)
	local iNeedSilver = Getitemtable_EVENT_PARA_C(ItemTempID)

	if GetpItemNumber(pItem) < nNeedNum then 
		
		return Return_ID.Return_ID_Error_NeedNum
		
	end 
	
	--g_MainDataTable 独立出一个数据表来！！！！！！！
	if CommonData.g_MainDataTable.silver < iNeedSilver then 
		
		return Return_ID.Return_ID_Error_Money
		
	end 
	
	return Return_ID.Return_ID_Success
	
end
--使用武将碎片
local function OprItemGeneralFragment(pItem,nNumber)

	local ItemTempID = GetpItemTempID(pItem)
	local nNeedNum = Getitemtable_EVENT_PARA_A(ItemTempID)
	local iNeedSilver = Getitemtable_EVENT_PARA_C(ItemTempID)
	
	if GetpItemNumber(pItem) < nNeedNum then 
		
		return Return_ID.Return_ID_Error_NeedNum
		
	end 
	
	--g_MainDataTable 独立出一个数据表来！！！！！！！
	if CommonData.g_MainDataTable.silver < iNeedSilver then 
		
		return Return_ID.Return_ID_Error_Money
		
	end 
	
	return Return_ID.Return_ID_Success
	
end

local function UseItem( pItem, nNumber)
	
	local nEventType = GetpItemEventType(pItem)		
	
	if nEventType == E_ITEM_EVENT_TYPE.E_ITEM_EVENT_TYPE_BOX then 
		return OprItemBox(pItem,nNumber)	
	elseif nEventType == E_ITEM_EVENT_TYPE.E_ITEM_EVENT_TYPE_DRUG then 
		return OprItemDrug(pItem,nNumber)
	elseif nEventType == E_ITEM_EVENT_TYPE.E_ITEM_EVENT_TYPE_EQUIPFRAGMENT then 
		return OprItemEquipFragment(pItem,nNumber)
	elseif nEventType == E_ITEM_EVENT_TYPE.E_ITEM_EVENT_TYPE_GENERALFRAGMENT then 
		return OprItemGeneralFragment(pItem,nNumber)
	else
		return Return_ID.Return_ID_Error_Null
	end
	
	
end


local function Check_Use_Item(nGrid,nNumber, SouceType)
	
	if SouceType == Souce_Type.Souce_Type_bag then 
		
		local pItem = GetBagItemData(nGrid)		
		return UseItem(pItem,nNumber)
		
	elseif SouceType == Souce_Type.Souce_Type_General then 
		return Return_ID.Return_ID_Fail
	else
		return Return_ID.Return_ID_Error_Null
	end
	
end


-- 根据物品ID检查是否能够使用
--使用背包里的道具 参数 nGrid 背包的格子 nNumber 数量
function Check_Use_BagItem(nGrid,nNumber)
	
	return Check_Use_Item(nGrid,nNumber,Souce_Type.Souce_Type_bag)
	
end
