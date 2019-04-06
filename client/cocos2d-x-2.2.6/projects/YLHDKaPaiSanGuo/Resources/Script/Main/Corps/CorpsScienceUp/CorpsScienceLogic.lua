require "Script/Main/Corps/CorpsScienceUp/CorpsScienceData"
require "Script/serverDB/technolog"
module("CorpsScienceLogic",package.seeall)

local GetZhuZiNum = CorpsScienceData.GetZhuZiNum
local GetZhuZiTotalNum = CorpsScienceData.GetZhuZiTotalNum

function CheckIsTeach( nTempId )
	local nCurNum = GetZhuZiNum(nTempId)
	local nTotalNum = GetZhuZiTotalNum(nTempId)

	if tonumber(nCurNum) >= tonumber(nTotalNum) then
		return false
	end
	return true
end

function GetNeedNum( nTempId )
	local nCurNum = GetZhuZiNum(nTempId)
	local nTotalNum = GetZhuZiTotalNum(nTempId)
	local nNeedNum = nTotalNum - nCurNum
	return nNeedNum
end

--得到第几个
function GetItemNum( nItemID,tabData )
	for key,value in pairs(tabData) do 
		print(value.itemID)
		if tonumber(value.itemID) == tonumber(nItemID) then
			return key
		end
	end
	return 0
end

function CheckScienceID( nlv, tableData )
	if tonumber(tableData[2]) == nlv then
		return true
	end
	return false
end

local function GetScienceNameByLevel( tab_science ,nLevel)
	local name = nil
	for key,value in pairs(tab_science) do
		if tonumber(value[2]) == nLevel then
			name = value[4]
			return name
		end
	end
end

function ReturnScienceName( nScienceID ,nLevel)
	local label_name = nil
	local tab_science = {}
	tab_science = technolog.getArrDataByField("TechnologyID",nScienceID)
	label_name = GetScienceNameByLevel(tab_science,nLevel)
	return label_name
end
