-- require "Script/Common/Common"
require "Script/Main/Wujiang/GeneralRelationData"
require "Script/Main/Wujiang/GeneralBaseData"

module("GeneralRelationLogic", package.seeall)


local GetGeneralNameByTempId	= GeneralBaseData.GetGeneralNameByTempId
local GetGeneralHeadIcon		= GeneralBaseData.GetGeneralHeadIcon
local GetGeneralColorIcon		= GeneralBaseData.GetGeneralColorIcon

local GetRelatinoType			= GeneralRelationData.GetRelatinoType
local GetRelationItemTab		= GeneralRelationData.GetRelationItemTab
local GetMaxSoildValue 			= GeneralRelationData.GetRelationMaxSolidVale
local GetRelationId 			= GeneralRelationData.GetRelationId
local GetRelationName			= GeneralRelationData.GetRelationName
local GetRelationAttrDes		= GeneralRelationData.GetRelationAttrDes
local GetItemNameByTempId		= GeneralRelationData.GetItemNameByTempId
local GetEquipIconByTempId		= GeneralRelationData.GetEquipIcon
local GetEquipColorIcon 		= GeneralRelationData.GetEquipColorIcon

local GetRelationSolidTab		= server_generalDB.GetRelationSolidTab
local GetRelationSolidValue		= server_generalDB.GetRelationSolidValue
local GetGeneralIdByGrid		= server_generalDB.GetTempIdByGrid
local GetGridByTempId			= server_generalDB.GetGridByTempId
local IsHaveGeneral				= server_generalDB.GetIsHaveWJ

local IsShangZhen				= server_matrixDB.IsShangZhen
local GetEquipListByGeneralGrid = server_matrixDB.GetEquipListByGeneralGrid

local GetEquipIdByGrid 			= server_equipDB.GetTempIdByGrid

-- 判断固化状态
local function CheckSolidState( nSolidValue, nMaxSolidVlaue )
	if nSolidValue>=nMaxSolidVlaue then
		return true
	else
		return false
	end
end

-- 通过装备模板ID获取装备状态
local function IsEquipedByEquipId( nEquipId, nSelfGrid )
	-- 判断武将已经穿戴的装备
	local tabEquip = GetEquipListByGeneralGrid(nSelfGrid)
	for k,v in pairs(tabEquip) do
		if tonumber(v)>0 then
			local nTempId = tonumber(GetEquipIdByGrid(v))
			-- 已穿戴的装备模板ID和装备列表中的装备ID相等，则状态已装备
			if nTempId==nEquipId then
				return true
			end
		end
	end
	return false
end

-- 连接相关武将名字
local function ConnectGeneralName( tabItemData )
	local strName = ""
	for i=1, #tabItemData do
		if i==#tabItemData then
			strName = strName..tabItemData[i].Name
		else
			strName = tabItemData[i].Name.."，"..strName
		end
	end
	return strName
end

-- 拼接缘分描述
local function GetRelationDesc( nRelationId, tabItemData )
	local strDesc = "与"
	local strName = ConnectGeneralName(tabItemData)
	local strRelationDes = GetRelationAttrDes(nRelationId)
	strDesc = strDesc..strName.."同时上场，"..strRelationDes
	return strDesc
end

-- 获得某一件装备或武将的上阵状态
local function GetShangZhenStateByType( nType, nNeedId, nSelfGrid )
	-- print("Type = "..nType.." NeedId = "..nNeedId.." SelfGird = "..nSelfGrid)
	if nType==GeneralRelationData.RelationType.General then
		local nGrid = GetGridByTempId(nNeedId)
		-- 检测武将列表中是否有缘分相关武将
		if IsHaveGeneral(nNeedId)==false then
			return false
		else
			if IsShangZhen(nGrid)==false then --如果有，则检测是否上阵
				return false
			else
				return true
			end
		end
	elseif nType==GeneralRelationData.RelationType.Equip then
		if IsEquipedByEquipId(nNeedId, nSelfGrid)==false then --判断当前操作的武将是否已穿戴相关装备
			return false
		else
			return true
		end
	end
end

-- 获得缘分状态
local function GetRelationState( nType, nSelfGrid, bSolidfy, tabItemData )
	-- 如果已固化
	if bSolidfy==true then
		return GeneralRelationData.RelationState.Solidified
	end

	-- 当前武将未上阵
	if IsShangZhen(nSelfGrid)==false then
		return GeneralRelationData.RelationState.NotActivted
	end

	-- 缘分相关武将只要有一个未上阵, 或者相关装备未穿戴
	for i=1, #tabItemData do
		if tabItemData[i].ShangZhen==false then
			return GeneralRelationData.RelationState.NotActivted
		end
	end

	return GeneralRelationData.RelationState.Solidifying
end

-- 获得每一条缘分相关装备或武将的数据
local function GetEachRelationData( nType, tabItemData, nSelfGrid )
	local tabGeneralData = {}
	for i=1, #tabItemData do
		local tabTemp = {}
		tabTemp.ItemId			= tabItemData[i].ItemId
		if nType==GeneralRelationData.RelationType.General then
			tabTemp.Name 		= GetGeneralNameByTempId(tabItemData[i].ItemId)
			tabTemp.ItemIcon	= GetGeneralHeadIcon(tabItemData[i].ItemId)
			tabTemp.ColorIcon	= GetGeneralColorIcon(tabItemData[i].ItemId)
		elseif nType==GeneralRelationData.RelationType.Equip then
			tabTemp.Name 		= GetItemNameByTempId(tabItemData[i].ItemId)
			tabTemp.ItemIcon 	= GetEquipIconByTempId(tabItemData[i].ItemId)
			tabTemp.ColorIcon	= GetEquipColorIcon(tabItemData[i].ItemId)
		end
		tabTemp.PieceId   	= tabItemData[i].PieceId
		tabTemp.ShangZhen 	= GetShangZhenStateByType(nType, tabItemData[i].ItemId, nSelfGrid)
		table.insert(tabGeneralData, tabTemp)
	end
	-- printTab(tabGeneralData)
	return tabGeneralData
end

-- 获得每一条缘分相关装备或武将的数据
local function GetRelationDataById( nType, nSelfGrid, nRelationId )
	local tabItemData = GetRelationItemTab(nRelationId)
	return GetEachRelationData(nType, tabItemData, nSelfGrid)
end

-- 拼接缘分状态文字
function GetStateText( nSate, nSolidValue, nMaxSolidVlaue )
	if nSate == GeneralRelationData.RelationState.NotActivted then
		return "未激活"
	elseif nSate == GeneralRelationData.RelationState.Solidifying then
		return "已激活 固化进度："..tostring(nSolidValue).."/"..tostring(nMaxSolidVlaue)
	elseif nSate == GeneralRelationData.RelationState.Solidified then
		return "已固化"
	end
end

-- 获得操作武将的缘分数据
function GetRelationData( nSelfGrid  )
	local tabRelationData = {}
	local tabSolidValue = GetRelationSolidTab(nSelfGrid)
	local nGeneralId = GetGeneralIdByGrid(nSelfGrid)
	for i=1, GeneralRelationData.MAX_RELATION_COUNT do
		local nRelationId = GetRelationId(nGeneralId, i)
		if nRelationId>-1 then
			local tabTemp = {}
			local nType = GetRelatinoType(nRelationId)
			local tabItemData		= GetRelationDataById(nType, nSelfGrid, nRelationId)
			local nSolidValue 		= GetRelationSolidValue(tabSolidValue, i)
			local nMaxSolidVlaue 	= GetMaxSoildValue(nRelationId)
			local bSolidfy			= CheckSolidState(nSolidValue, nMaxSolidVlaue)

			tabTemp.Idx 			= i
			tabTemp.RelationId 		= nRelationId
			tabTemp.RelationName 	= GetRelationName(nRelationId)
			tabTemp.SolidValue 		= nSolidValue
			tabTemp.MaxSolidValue 	= nMaxSolidVlaue
			tabTemp.Solidfy			= bSolidfy
			tabTemp.EachData 		= tabItemData
			tabTemp.State 			= GetRelationState(nType, nSelfGrid, bSolidfy, tabItemData)
			tabTemp.Desc 			= GetRelationDesc( nRelationId, tabItemData)
			table.insert(tabRelationData, tabTemp)
		end
	end
	return tabRelationData
end

-- 获得排序后的缘分状态表
function SortRelationStateTab( tabState )
	local function comps(a,b)
		return a > b
	end
	table.sort( tabState, comps )
	return tabState
end