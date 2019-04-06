require "Script/Common/Common"
require "Script/serverDB/server_generalDB"
require "Script/Main/Wujiang/GeneralBaseData"


module("GeneralListLogic", package.seeall)

local GetCopyTable			= server_generalDB.GetCopyTable
local GetTempId				= server_generalDB.GetTempId
local IsMainGeneral			= server_generalDB.IsMainGeneral
local GetGridByTempId		= server_generalDB.GetGridByTempId
local GetTableByTempId		= server_generalDB.GetTableByTempId
local GetTempIdByGrid		= server_generalDB.GetTempIdByGrid

local GetNumByTempID		= ItemData.GetNumByTempID
local GetItemEventParaA		= ItemData.GetItemEventParaA
local GetGeneralPos 		= GeneralBaseData.GetGeneralPos
local GetGeneralType 		= GeneralBaseData.GetGeneralType
local GetGeneralName		= GeneralBaseData.GetGeneralName
local GetGeneralNameByGeneralID	=	GeneralBaseData.GetGeneralNameByGeneralID

local function GetItemIdByParaBAndItemType( nParaB, nItemType )
	for k, v in pairs(item.getTable()) do
		if nParaB==tonumber(v[tonumber(item.getIndexByField("event_para_B"))])
			and nItemType==tonumber(v[tonumber(item.getIndexByField("item_type"))]) then
			return tonumber(string.sub(k, 4))
		end
	end
	return -1
end

-- 排序优先级 主将>是否上阵>等级>星级>丹药等级>品质
local function SortGeneralList( g1, g2 )
	if g1["Info02"]["MainStay"] == g2["Info02"]["MainStay"] then
		if g1["Info02"]["GoOut"] == g2["Info02"]["GoOut"] then
			if g1["Info02"]["Lv"] == g2["Info02"]["Lv"] then
				if g1["Info02"]["Star"] == g2["Info02"]["Star"] then
					if g1["Info02"]["danyaoLv"] == g2["Info02"]["danyaoLv"] then
						if g1["Info02"]["Colour"] > g2["Info02"]["Colour"] then
							return true
						else
							return g1["Info02"]["Colour"] > g2["Info02"]["Colour"]
						end
					else
						return g1["Info02"]["danyaoLv"] > g2["Info02"]["danyaoLv"]
					end
				else
					return g1["Info02"]["Star"] > g2["Info02"]["Star"]
				end
			else
				return g1["Info02"]["Lv"] > g2["Info02"]["Lv"]
			end
		else
			return g1["Info02"]["GoOut"] > g2["Info02"]["GoOut"]
		end
	else
		return g1["Info02"]["MainStay"] > g2["Info02"]["MainStay"]
	end
end

local function SortFunc( g1, g2 )
	if g1.State==g2.State  then
		if g1.State==1 and g2.State==1 then
			return SortGeneralList(g1, g2)
		else
			return g1["Info02"]["HaveNum"] > g2["Info02"]["HaveNum"]
		end
	else
		return g1.State > g2.State
	end
end

local function GetHavedGeneralData( nGeneralId )
	local tabTemp = {}
	tabTemp["State"] = 1
	tabTemp["GeneralId"] = nGeneralId
	tabTemp["Grid"] = GetGridByTempId(nGeneralId)
	tabTemp["Info02"] = GetTableByTempId(nGeneralId)["Info02"]
	return tabTemp
end

local function GetNotHaveGeneralData( nGeneralId )
	local nItemId = GetItemIdByParaBAndItemType(nGeneralId, 3)
	if nItemId<0 then
		return
	end
	local tabTemp = {}
	local nHaveNum = GetNumByTempID(nItemId)
	local nNeedNum = GetItemEventParaA(nItemId)
	local tabTemp = {}
	local tabData = {}
	tabTemp["GeneralId"] = nGeneralId	-- 更新UI信息用
	tabTemp["ItemId"] = nItemId			-- 召唤武将用
	tabData["HaveNum"] = nHaveNum
	tabData["NeedNum"] = nNeedNum

	if nHaveNum>=nNeedNum then
		tabTemp["State"]  = 2
	else
		tabTemp["State"]  = 0
	end
	tabTemp["Info02"] = tabData
	return tabTemp
end

function GetGeneralList( nType, nPos ,nGridTab )
	local tabGeneral = {}
	if nGridTab == nil then
		for k, v in pairs(general.getTable()) do
			local nGeneralId = tonumber(string.sub(k, 4))
			if nType == GeneralType.HuFa then
				if GetGeneralType(nGeneralId)==GeneralType.HuFa then
					if server_generalDB.GetIsHaveWJ(nGeneralId)==true then
						local tabTemp = GetHavedGeneralData(nGeneralId)
						table.insert(tabGeneral, tabTemp)
					else
						local tabTemp = GetNotHaveGeneralData(nGeneralId)
						table.insert(tabGeneral, tabTemp)
					end
				end
			else
				if GetGeneralType(nGeneralId)~=GeneralType.HuFa then
					if server_generalDB.GetIsHaveWJ(nGeneralId)==true then
						if nPos == GeneralPos.All then
							local tabTemp = GetHavedGeneralData(nGeneralId)
							table.insert(tabGeneral, tabTemp)
						else
							if nPos == GetGeneralPos(nGeneralId) then
								local tabTemp = GetHavedGeneralData(nGeneralId)
								table.insert(tabGeneral, tabTemp)

							end
						end
					else
						if GetGeneralType(nGeneralId)~=GeneralType.Main then
							if nPos == GeneralPos.All then
								local tabTemp = GetNotHaveGeneralData(nGeneralId)
								table.insert(tabGeneral, tabTemp)
							else
								if nPos == GetGeneralPos(nGeneralId) then
									local tabTemp = GetNotHaveGeneralData(nGeneralId)
									table.insert(tabGeneral, tabTemp)
								end
							end
						end
					end
				end
			end
		end
	else
		for k, v in pairs(general.getTable()) do
			local nGeneralId = tonumber(string.sub(k, 4))
			local nTabGeneralName = GetGeneralNameByGeneralID(nGeneralId)
			if nType == GeneralType.HuFa then						--当前点击的武将类型
				--当前点击为护法时
				for i=1,table.getn(nGridTab) do
					local nTmpID = GetTempIdByGrid(nGridTab[i])
					if GetGeneralType(nTmpID) == GeneralType.HuFa then
						if nTmpID == nGeneralId then
							if server_generalDB.GetIsHaveWJ(nGeneralId)==true then
								local tabTemp = GetHavedGeneralData(nGeneralId)
								table.insert(tabGeneral, tabTemp)
							else
								local tabTemp = GetNotHaveGeneralData(nGeneralId)
								table.insert(tabGeneral, tabTemp)
							end
						end	
					end
				end
			else 
				if GetGeneralType(nGeneralId)~=GeneralType.HuFa then
					if server_generalDB.GetIsHaveWJ(nGeneralId)==true then
						--判断是否已经拥有这个武将
						if nPos == GeneralPos.All then
							local tabTemp = GetHavedGeneralData(nGeneralId)
							table.insert(tabGeneral, tabTemp)
						else
							if nPos == GetGeneralPos(nGeneralId) and nType == GeneralType.Main then
								local tabTemp = GetHavedGeneralData(nGeneralId)
								table.insert(tabGeneral, tabTemp)
							end
							for i=1,table.getn(nGridTab) do
								local nGeneralName = GetGeneralName(nGridTab[i])
								if nTabGeneralName == nGeneralName then
									local tabTemp = GetHavedGeneralData(nGeneralId)
									table.insert(tabGeneral, tabTemp)
								end	
							end
						end
					else
						--当前没有这个武将.
						if GetGeneralType(nGeneralId)~=GeneralType.Main then
							if nPos == GeneralPos.All then
								local tabTemp = GetNotHaveGeneralData(nGeneralId)
								table.insert(tabGeneral, tabTemp)
							else
								for i=1,table.getn(nGridTab) do
									local nGeneralName = GetGeneralName(nGridTab[i])
									if nTabGeneralName == nGeneralName then
										local tabTemp = GetNotHaveGeneralData(nGeneralId)
										table.insert(tabGeneral, tabTemp)
									end	
								end
							end
						end
					end
				end
			end
		end	
	end

	table.sort(tabGeneral, SortFunc)
	-- 必须排序过后进行次操作
	-- state==-1 代表分割，插入文本框，两个状态为-1的，插入文本提示，如果有一个状态为-的，插入文本提示，第二个控件不显示
	-- for k,v in pairs(tabGeneral) do
	-- 	if tabGeneral[k]["State"]==0 then
	-- 		local tabTemp = {}
	-- 		tabTemp["State"] = -1
	-- 		table.insert(tabGeneral, k,  tabTemp)
	-- 		--k是奇数时，需要再插入一个-1
	-- 		if k%2~=0 then
	-- 			table.insert(tabGeneral, k,  tabTemp)
	-- 		end
	-- 		break
	-- 	end
	-- end
	return tabGeneral
end

function MakeGeneraListByRule( nType, nPos )
	local tabGeneral = GetGeneralList(nType, nPos)
	for k,v in pairs(tabGeneral) do
		if tabGeneral[k]["State"]==0 then
			local tabTemp = {}
			tabTemp["State"] = -1
			table.insert(tabGeneral, k,  tabTemp)
			--k是奇数时，需要再插入一个-1
			if k%2~=0 then
				table.insert(tabGeneral, k,  tabTemp)
			end
			break
		end
	end
	return tabGeneral
end

function GetGeneralGridListByTypeAndPos( nType, nPos , nGridTab )
	local tabTemp = GetGeneralList(nType, nPos ,nGridTab)
	local tabGeneral = {}
	for k, v in pairs(tabTemp) do
		if v["State"]==1 then
			table.insert(tabGeneral, v)
		end
	end
	return tabGeneral
end
