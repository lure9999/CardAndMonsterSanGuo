module("CorpsSpiritLogic",package.seeall)
-- require "Script/Mian/Corps/CorpsSpiritData"
require "Script/Main/Item/GetGoodsLayer"
local GetMonsterLevel = CorpsSpiritData.GetMonsterLevel
local GetMonsterInfo  = CorpsSpiritData.GetMonsterInfo
local GetSpiritLevelInfo = CorpsSpiritData.GetSpiritLevelInfo
--对得到的灵兽信息进行排序
function SortMonsterFromLevel( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.TechLv) > tonumber(b.TechLv)
		else
			return tonumber(a.TechLv) < tonumber(b.TechLv)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end
--根据科技等级得到对应的灵兽的信息
function CheckMonsterInfo( tab,nLevel )
	if tonumber(nLevel) == 0 then
		nLevel = nLevel + 1
	end
	for key,value in pairs(tab) do
		if tonumber(nLevel) == tonumber(value["TechLv"]) then
			return value
		end
	end
end

function GetSpiritInfoByLevel( num )
	local tabMon = GetMonsterInfo(num)
	local tabMonster = SortMonsterFromLevel(tabMon,false)
	local tabLevel = GetMonsterLevel()
	local tabInfo = CheckMonsterInfo(tabMonster,tabLevel["m_nLevel"])
	return tabInfo
end

function CkeckTechLevel(  )
	local tabTechnology = {}
	local tabLevel = GetMonsterLevel()
	local tab = GetSpiritLevelInfo()
	local nLevel = tabLevel["m_nLevel"]
	--[[if tonumber(nLevel) == 0 then
		nLevel = nLevel + 1
	end]]--
	for key,value in pairs(tab) do
		if tonumber(nLevel) == tonumber(value[2]) then
			tabTechnology["TechnologyID"] = value[1]
			tabTechnology["TechLv"] = value[2]
			tabTechnology["ResimgID"] = value[3]
			tabTechnology["TechName"] = value[4]
			tabTechnology["TechDes"] = value[5]
			tabTechnology["UpConditionID"] = value[6]
			tabTechnology["UpConsumeID"] = value[7]
			tabTechnology["ConsumeNum"] = value[8]
			tabTechnology["ResearchTime"] = value[9]
			tabTechnology["TechEffID1"] = value[10]
			tabTechnology["TechEffID2"] = value[11]
			tabTechnology["TechEffID3"] = value[12]
			tabTechnology["TechEffID4"] = value[13]
			return tabTechnology
		end
	end
end

function SortQueryInfo(  )
	local tabQuery = CorpsSpiritData.GetQueryInfo()
	local tabSort = {}
	local tabQ = {}
	local tabB = {}
	local tabZ = {}
	local tabX = {}
	for key,value in pairs(tabQuery) do
		if tonumber(value["nType"]) == 1 then
			table.insert(tabQ,value)
		elseif tonumber(value["nType"]) == 2 then
			table.insert(tabB,value)
		elseif tonumber(value["nType"]) == 3 then
			table.insert(tabZ,value)
		elseif tonumber(value["nType"]) == 4 then
			table.insert(tabX,value)
		end
	end
	table.insert(tabSort,tabQ)
	table.insert(tabSort,tabB)
	table.insert(tabSort,tabZ)
	table.insert(tabSort,tabX)
	return tabSort
end

function ShowRewardLayer( nTab1, nTab2, nCallBack )
	GetGoodsLayer.createGetGoods(nTab1, nTab2, nCallBack)
end

function GetNormalSpiritAnimation( nType )
	local Animation11 = nil
	local Animation12 = nil
	Animation11 = "Image/imgres/effectfile/juntuan_lingshou_texiao/juntuan_lingshou_texiao.ExportJson"
	if tonumber(nType) == 1 then
		Animation12 = "Animation7"
	elseif tonumber(nType) == 2 then
		Animation12 = "Animation8"
	elseif tonumber(nType) == 3 then
		Animation12 = "Animation9"
	elseif tonumber(nType) == 4 then
		Animation12 = "Animation10"
	elseif tonumber(nType) == 5 then
		Animation12 = "Animation5"
	end
	return Animation11,Animation12
end

function GetClickSpiritAnimation( nType )
	local Animation11 = nil
	local Animation12 = nil
	Animation11 = "Image/imgres/effectfile/juntuan_lingshou_texiao/juntuan_lingshou_texiao.ExportJson"
	if tonumber(nType) == 1 then
		Animation12 = "Animation1"
	elseif tonumber(nType) == 2 then
		Animation12 = "Animation2"
	elseif tonumber(nType) == 3 then
		Animation12 = "Animation3"
	elseif tonumber(nType) == 4 then
		Animation12 = "Animation4"
	elseif tonumber(nType) == 5 then
		Animation12 = "Animation6"
	end
	return Animation11,Animation12
end