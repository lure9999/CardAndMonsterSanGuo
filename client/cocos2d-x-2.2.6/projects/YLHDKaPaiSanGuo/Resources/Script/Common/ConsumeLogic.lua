require "Script/Common/Common"
module("ConsumeLogic", package.seeall)

MAX_CONSUMETYPE_COUNT=5

ConsumeParaAType =
{
	ItemID 	= 1,		-- 道具ID
	ItemNum = 2,	-- 道具数量
}

IncType =
{
	IncNo 	= 0,
	IncNum 	= 1,
	IncId 	= 2,
}

-- 通过消耗ID获取增量类型
local function GetConsumeIncType( nConsumeId )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "IncrementalLimit"))
end

-- 获取消耗类型
local function GetConsumeType( nConsumeId, nConsumeIdx )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "Consume_Type_"..tostring(nConsumeIdx)))
end

-- 获取消耗类型获取增量ID
local function GetConsumeIncIdByType( nConsumeId, nConsumeIdx )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "Consume_Type_"..tostring(nConsumeIdx)))
end
-- 通过参数A获得消耗增量Id
local function GetConsumeIncIdByParaA( nConsumeId, nConsumeIdx )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "Type_"..tostring(nConsumeIdx).."_para_A"))
end

-- 通过参数B获得消耗增量Id
local function GetConsumeIncIdByParaB( nConsumeId, nConsumeIdx )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "Type_"..tostring(nConsumeIdx).."_para_B"))
end

-- 通过参数A获得消耗物品ID
local function GetConsumeItemIdByParaA( nConsumeId, nConsumeIdx )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "Type_"..tostring(nConsumeIdx).."_para_A"))
end

-- 通过参数A获得所需消耗物品数量
local function GetConsumeNeedItemNumByParaA( nConsumeId, nConsumeIdx )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "Type_"..tostring(nConsumeIdx).."_para_A"))
end

-- 通过参数B获得所需消耗物品数量
local function GetConsumeNeedItemNumByParaB( nConsumeId, nConsumeIdx )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeId, "Type_"..tostring(nConsumeIdx).."_para_B"))
end

-- 获得消耗增量物品数量
-- para1: 增量Id; para2:增量索引; para3:增量步长, 现在默认为1
local function GetConsumeIncData( nConsumeIncId, nIncIdx, nIncStep )
	local index = 0
	index = nIncIdx+nIncStep
	if tonumber(nIncIdx+nIncStep)>100 then
		index = 100
	end
 	return tonumber(consumeincremental.getFieldByIdAndIndex(nConsumeIncId, "Inc_Con_"..index))
end

-- 通过类型获得物品数量
local function GetConsumeItemNumByType( nConsumeType, nGrid )
	local nItemNum = 0
	if nConsumeType==ConsumeType.Sliver then
		nItemNum = server_mainDB.getMainData("silver")--CommonData.g_MainDataTable.silver
	elseif nConsumeType==ConsumeType.Gold then
		nItemNum = server_mainDB.getMainData("gold")--CommonData.g_MainDataTable.gold
	elseif nConsumeType==ConsumeType.Tili then
		nItemNum = server_mainDB.getMainData("tili")--CommonData.g_MainDataTable.tili
	elseif nConsumeType==ConsumeType.Naili then
		nItemNum = server_mainDB.getMainData("naili")--CommonData.g_MainDataTable.naili
	elseif nConsumeType==ConsumeType.MainGenExp then
		nItemNum = server_mainDB.getMainData("exp")--CommonData.g_MainDataTable.exp
	elseif nConsumeType==ConsumeType.GeneralExp then

	elseif nConsumeType==ConsumeType.BaoWuExp then
		if nGrid==-1 then
			return
		end
		nItemNum = server_equipDB.GetExpByGrid(nGrid)
	elseif nConsumeType==ConsumeType.JunGongCoin then
		
	elseif nConsumeType==ConsumeType.FamilyCoin then
		nItemNum = server_mainDB.getMainData("Family_Prestige")--CommonData.g_MainDataTable.Family_Prestige
	elseif nConsumeType==ConsumeType.FriendCoin then

	elseif nConsumeType==ConsumeType.JunGongPre then

	elseif nConsumeType==ConsumeType.FamilyPre then
		nItemNum = server_mainDB.getMainData("Family_Prestige")--CommonData.g_MainDataTable.Family_Prestige
	elseif nConsumeType==ConsumeType.FriendPre then
	elseif nConsumeType==ConsumeType.XingHun then
		nItemNum = server_mainDB.getMainData("XingHun")--CommonData.g_MainDataTable.XingHun
	end
	return nItemNum
end

function GetConsumeItemType( nItemId )
	return tonumber(item.getFieldByIdAndIndex(nItemId,"item_type"))
end

function GetConsumeItemQuality( nItemId )
	return tonumber(item.getFieldByIdAndIndex(nItemId,"pinzhi"))
end

function GetConsumeItemColorIcon( nItemId )
	local nQuality = GetConsumeItemQuality(nItemId)
	local nItemType = GetConsumeItemType(nItemId)
	local strColorPath = nil
	if nItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIPFRAGMENT or nItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_GENERALFRAGMENT then
		strColorPath = string.format("Image/imgres/common/color/item_pz%d.png",nQuality)
	else
		strColorPath = string.format("Image/imgres/common/color/wj_pz%d.png",nQuality)
	end
	return strColorPath
end

-- 获得物品图标
local function GetItemIconByResId( nResId )
	if nResId>-1 then
		return resimg.getFieldByIdAndIndex(nResId, "icon_path")
	else
		return nil
	end
end

-- 通过类型获得物品图标
local function GetConsumeItemIconByType( nConsumeType )
	local nResId = tonumber(coin.getFieldByIdAndIndex(nConsumeType, "ResID"))
	return GetItemIconByResId( nResId )
end

-- 通过物品ID获得物品图标
local function GetConsumeItemIconByItemId( nItemId )
	local nResId = tonumber(item.getFieldByIdAndIndex(nItemId, "res_id"))
	return GetItemIconByResId( nResId )
end

local function GetReturnConsumeId( nConsumeIncId, nIncIdx, nIncStep )
	local index = 0
	index = nIncIdx+nIncStep
	if tonumber(nIncIdx+nIncStep)>100 then
		index = 100
	end
	return tonumber(consumeincremental.getFieldByIdAndIndex(nConsumeIncId, "Inc_Con_"..index))
end

-- 通过消耗ID获取消耗信息表
local function GetConsumeTabById(nMaxCount, nConsumeId)
	local tabConsume = {}
	for i=1, nMaxCount do
		local tabTemp = {}
		local nConsumeType = GetConsumeType(nConsumeId, i)
		if nConsumeType >-1 then
			tabTemp.ConsumeID = nConsumeId
			tabTemp.IncType = GetConsumeIncType(nConsumeId)
			tabTemp.nIdx = i
			tabTemp.ConsumeType = nConsumeType
			table.insert(tabConsume, tabTemp)
		end
	end
	return tabConsume
end

-- 判断消耗表ParaA的参数类型
function GetConsumeParaAType( nConsumeType )
	if nConsumeType==ConsumeType.Item
		or nConsumeType==ConsumeType.General
		or nConsumeType==ConsumeType.Equip then
		return ConsumeParaAType.ItemID
	else
		return ConsumeParaAType.ItemNum
	end
end

-- 获取消耗物品名称
function GetItemName( nItemId )
	return item.getFieldByIdAndIndex(nItemId, "name")
end

-- 获取消耗类型名称
function GetConsumeTypeName( nConsumeType )
	return ConsumeTypeName[nConsumeType+1]
end

-- 获得消耗ID中所有的消耗信息
-- para1:最大消耗个数, 现在最大为5;
-- para2:消耗ID;
-- para3:增量索引,不是增量可以不传, 默认为0;
-- para4:增量步长,不是增量可以不传, 默认为1;
--返回值格式{ConsumeID, IncType,  nIdx,     ConsumeType}
------------消耗ID      增量类型  消耗索引  消耗类型
function GetConsumeTab(  nMaxCount, nConsumeId, nIncIdx, nIncStep )
	local tabConsume = {}
	local nIncType = GetConsumeIncType(nConsumeId)

	nIncIdx 	= nIncIdx or 0
	nIncStep	= nIncStep or 1
	if nIncType==IncType.IncId then
		local tabConsumeId = {}

		for i=1, MAX_CONSUMETYPE_COUNT do
			local nConsumeIncId = GetConsumeIncIdByType(nConsumeId, i)
			if nConsumeIncId>-1 then
				table.insert(tabConsumeId, nConsumeIncId)
			end
		end

		for i=1,table.getn(tabConsumeId) do
			local nReturnConsumeId = GetConsumeIncData(tabConsumeId[i], nIncIdx, nIncStep)
			tabConsume = GetConsumeTabById(nMaxCount, nReturnConsumeId)
		end
	else
		tabConsume = GetConsumeTabById(nMaxCount, nConsumeId)
	end
	--printTab(tabConsume)
	return tabConsume
end

-- 获得消耗ID中特定消耗物品信息
-- para1:消耗Id;
-- para2:消耗类型索引;
-- para3:消耗类型;
-- para4:递增类型;
-- para5:增量索引,不是增量可以不传, 默认为0;
-- para6:增量步长,不是增量可以不传, 默认为1;
--返回值格式{Enough, ConsumeType, ItemId, ItemNum,  ItemNeedNum,  IconPath}
------------是否足够  消耗类型    物品ID  物品数量  所需物品数量  物品图标
function GetConsumeItemData( nConsumeId,  nConsumeIdx, nConsumeType, nIncType, nIncIdx, nIncStep, nGrid )
	local tabConsumeItemData = {}
	local bEnough = false
	local nItemId = nil
	local nItemNeedNum = nil
	local nItemNum = 0
	local strIconPath = nil
	local nConsumeIncId = nil
	nIncIdx 	= nIncIdx or 0
	nIncStep	= nIncStep or 1
	nGrid		= nGrid or -1
	--print("nIncType=="..nIncType)
	--print(IncType.IncNo)
	--Pause()
	if nIncType == IncType.IncNo then -- 不递增
		if GetConsumeParaAType(nConsumeType)==ConsumeParaAType.ItemID then
			nItemId = GetConsumeItemIdByParaA(nConsumeId, nConsumeIdx)
			strIconPath = GetConsumeItemIconByItemId(nItemId)
			local nItemType = tonumber(ItemData.GetItemTypeByTempID(nItemId))
			if nItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP or
				nItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT or
				nItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE or
				nItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then

				nItemNum = server_equipDB.GetEquipNumByTempId(nItemId)
				
				--修改，如果背包入口进去的，确实需要减掉自己，如果是已装备入口进去的，则不需要，因为本身就不在背包里(暂时放到调用者哪里)
				local nSelfId = server_equipDB.GetTempIdByGrid(nGrid)
				if tonumber(nSelfId)==nItemId then
					if nItemNum>0 then
						nItemNum = nItemNum-1
					end
				end
			else
				nItemNum = server_itemDB.GetItemNumberByTempId(nItemId)
			end
			nItemNeedNum =  GetConsumeNeedItemNumByParaB(nConsumeId, nConsumeIdx)
			--print("nItemNum="..nItemNum)
			--print("nItemNeedNum="..nItemNeedNum)
		else
			strIconPath = GetConsumeItemIconByType(nConsumeType)
			nItemNum = GetConsumeItemNumByType(nConsumeType, nGrid)
			nItemNeedNum =  GetConsumeNeedItemNumByParaA(nConsumeId, nConsumeIdx)
		end
	elseif nIncType == IncType.IncNum then -- 数量递增
		if nIncIdx<0 or nIncStep<1 then
			print("增量索引或者增量步长错误")
			return
		end

		if GetConsumeParaAType(nConsumeType)==ConsumeParaAType.ItemID then
			nConsumeIncId = GetConsumeIncIdByParaB(nConsumeId, nConsumeIdx)
			nItemId = GetConsumeItemIdByParaA(nConsumeId, nConsumeIdx)
			strIconPath = GetConsumeItemIconByItemId(nItemId)
			nItemNum = server_itemDB.GetItemNumberByTempId(nItemId)
		else
			strIconPath = GetConsumeItemIconByType(nConsumeType)
			nItemNum = GetConsumeItemNumByType(nConsumeType, nGrid)
			nConsumeIncId = GetConsumeIncIdByParaA(nConsumeId, nConsumeIdx)
			--print("nCosnIncId="..nConsumeIncId)
		end
		--[[if nIncIdx == 100 then
			print(nConsumeIncId)
			print(nIncIdx)
			print(nIncStep)
			Pause()
		end]]--
		nItemNeedNum =  GetConsumeIncData(nConsumeIncId, nIncIdx, nIncStep)
	end
	if nItemNum<nItemNeedNum then
		bEnough = false
	else
		bEnough = true
	end

	-- 如果消耗类型是不是道具累,即nConsumeType ~= 0时, tabConsumeItemData.ItemId=nil
	tabConsumeItemData.Enough 		= bEnough
	tabConsumeItemData.ConsumeType	= nConsumeType
	tabConsumeItemData.ItemNum 		= nItemNum
	tabConsumeItemData.ItemNeedNum 	= nItemNeedNum
	tabConsumeItemData.IconPath 	= strIconPath
	if GetConsumeParaAType(nConsumeType)==ConsumeParaAType.ItemID then
		tabConsumeItemData.ParaAType 	= ConsumeParaAType.ItemID
		tabConsumeItemData.ItemId 		= nItemId
		tabConsumeItemData.ItemType 	= GetConsumeItemType(nItemId)
		tabConsumeItemData.ColorIcon	= GetConsumeItemColorIcon(nItemId)
	else
		tabConsumeItemData.ParaAType 	= ConsumeParaAType.ItemNum
	end
	return tabConsumeItemData
end

-- 设置所有消耗物品是否足够信息
function SetConsumeItemsData( tabConItemsData, tabItemData )
	local tabTemp = {}
	if GetConsumeParaAType(tabItemData.ConsumeType) == ConsumeParaAType.ItemID then
		tabTemp.Enough = tabItemData.Enough
		tabTemp.Name = GetItemName(tabItemData.ItemId)
	else
		tabTemp.Enough = tabItemData.Enough
		tabTemp.Name = GetConsumeTypeName(tabItemData.ConsumeType)
	end
	table.insert(tabConItemsData, tabTemp)
end

function CheckBConsumeByID(nConsumeID)
	if tonumber(nConsumeID)<1 then
		return true
	end
	if consume.getDataById(nConsumeID) == nil  then
		--TipLayer.createTimeLayer("消耗ID不存在",2)
		return false
	end
	local consumeTab = GetConsumeTab(5,nConsumeID)
	
	local tabBCan = {}
	for i=1,table.getn(consumeTab) do 

		local tableExpendData = GetConsumeItemData(consumeTab[i].ConsumeID,consumeTab[i].nIdx,consumeTab[i].ConsumeType,consumeTab[i].IncType)
		tabBCan[i] = tableExpendData.Enough
	end
	
	for key,value in pairs(tabBCan) do 
		if value== false then
			return false
		end
	end
	return true
end
----------------------------------celina--------------------------------------------------

local function GetExpendAllData(nConsumeID)
	local consumeTab = GetConsumeTab(5,nConsumeID)
	local tabCur = {}
	for i=1,table.getn(consumeTab) do 
		local tableExpendData = GetConsumeItemData(consumeTab[i].ConsumeID,consumeTab[i].nIdx,consumeTab[i].ConsumeType,consumeTab[i].IncType)
		table.insert(tabCur,tableExpendData)
	end
	return tabCur
end

local function CheckIndex(size,index)
	if index>size then
		TipLayer.createTimeLayer("给出的索引大于总个数",2)
		return false
	end
	return true
end
local function GetExpendType(self,nIndex)
	if CheckIndex(self:GetSize(),nIndex)== false then
		
		return 
	end
	return self.TabData[nIndex].ConsumeType

end
local function GetSize(self)
	return table.getn(self.TabData)
end
local function GetExpendItemID(self,nIndex)
	if CheckIndex(self:GetSize(),nIndex)== false then
		
		return 
	end
	return self.TabData[nIndex].ItemId
end
local function GetExpendNum(self,nIndex)
	if CheckIndex(self:GetSize(),nIndex)== false then
		
		return 
	end
	return self.TabData[nIndex].ItemNeedNum
end
--新的入口 只需要传入消耗的ID
function GetExpendData(nExpendID)
	local tabExpend = {
		TabData = GetExpendAllData(nExpendID),
		GetSize = GetSize,
		GetExpendTypeByIndex = GetExpendType,
		GetItemIDByIndex = GetExpendItemID,
		GetNumByIndex = GetExpendNum,
	}
	return tabExpend
end
