--比武界面的数据 celina


module("CompetitionData", package.seeall)

require "Script/serverDB/server_mainDB"
require "Script/serverDB/resimg"
require "Script/serverDB/general"
require "Script/serverDB/arena"
require "Script/serverDB/globedefine"
require "Script/serverDB/scence"
require "Script/serverDB/scenerule"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/server_biwuDB"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/server_pvpRecordDB"
require "Script/Common/ConsumeLogic"
require "Script/serverDB/point"
--require "Script/serverDB/job"
--require "Script/DB/AnimationData"

--[[--得到头像
function GetHeadImgPath()
	--得到ID
	local headID = server_mainDB.getMainData("nHeadID")
	return resimg.getFieldByIdAndIndex(headID,"icon_path")
end
function GetHeadColorPath()
	local gID = server_mainDB.getMainData("JobGeneralID")
	local colorNum = tonumber(general.getFieldByIdAndIndex(gID,"Colour"))
	local strColorPath = string.format("Image/imgres/common/color/wj_pz%d.png",colorNum)
	return strColorPath
end]]--

function GetPlayerName()
	return server_mainDB.getMainData("name")
end
function GetRoleID()
	--print(server_mainDB.getMainData("JobGeneralID"))
	return  server_mainDB.getMainData("nModeID")
end
function GetArenaTable()
	return arena.getTable()
end
function GetRankNameByID(nTempID)
	return arena.getFieldByIdAndIndex(nTempID,"Title")
end
function GetKeyArenaByStr(strArena)
	return arena.getIndexByField(strArena)
end
--得到名次
function GetRank()
	return server_biwuDB.GetCurrentRank()--server_mainDB.getMainData("nRank")
end
function GetHistoryRank()
	return server_biwuDB.GetHistoryRank()--server_mainDB.getMainData("nHistoryRank")
end
--得到等级
function GetLevel()
	return server_mainDB.getMainData("level")
end
--得到战斗力
function GetPower()
	return server_mainDB.getMainData("power")
end
local function GetSceneID()
	return globedefine.getFieldByIdAndIndex("BiWu","Para_1")
end
local function GetRuleID()
	return scence.getFieldByIdAndIndex(GetSceneID(),"RuleID")
end
function GetBWConsumeID()
	return scenerule.getFieldByIdAndIndex(GetRuleID(),"ConsumeID")
end

function GetCosumeData()
	
	return ConsumeLogic.GetExpendData(GetBWConsumeID())
end
--得到挑战次数
function GetVSTimes()
	--[[if tonumber(scenerule.getFieldByIdAndIndex(GetRuleID(),"Times")) ==-1 then
		return "无限"
	end
	return tonumber(scenerule.getFieldByIdAndIndex(GetRuleID(),"Times"))]]--
	
	--[[if server_biwuDB.GetVSTimes()== nil then
		return 0
	end]]--
	local nTimes = server_mainDB.getMainData("BWTimes")
	return 10-tonumber(nTimes)
end

function GetTotalTimes()
	local nTotalTimes = globedefine.getFieldByIdAndIndex("BiWu","Para_5")
	return nTotalTimes
end
--得到挑战的时间
function GetVSTime()
	local nTime = tonumber(globedefine.getFieldByIdAndIndex("BiWu","Para_6"))
	return nTime--tonumber(scenerule.getFieldByIdAndIndex(GetRuleID(),"CD"))
end


function GetGridGerneral(nTempID)
	return server_generalDB.GetGridByTempId(nTempID)
end

function GetGerneralResPath(nGrid)
	local resID = general.getFieldByIdAndIndex(GetGerneralTempID(nGrid),"ResID")
	return AnimationData.getFieldByIdAndIndex(resID,"ImagefileName_Head")
end
local function GetTabPlayerData()
	local tabData = {}
	for i=1,3 do 
		local tab = server_biwuDB.GetPlayerInfoByIndex(i)
		table.insert(tabData,tab)
	end
	
	local function sortByRanking(a,b)
		return a.pRank<b.pRank
	end
	table.sort(tabData,sortByRanking)
	return tabData
end
function GetPlayerDataByIndex(nIndex)
	local tabNow = GetTabPlayerData()
	return tabNow[nIndex]
end
local function GetMatrixTab()
	return server_matrixDB.GetCopyTable()
end
function GetRankByPID(nID)
	local tabData = GetTabPlayerData()
	for key,value in pairs(tabData) do 
		if tonumber(value.pID) == tonumber(nID) then
			return value.pRank
		end
	end
	return 0
end

function GetSelfData()
	local tableSelfData = {}
	tableSelfData.pName = GetPlayerName()
	tableSelfData.pLevel = GetLevel()
	tableSelfData.pRank = GetRank()
	tableSelfData.pFight = GetPower()
	local tableMatrix = {}
	for key,value in pairs(GetMatrixTab()) do 
		if tonumber(value["Info01"]["generalgrid"]) >0 then
			local tempID = GetGerneralTempID(value["Info01"]["generalgrid"])
			local tableTempID = {}
			tableTempID[1] = tempID
			table.insert(tableMatrix,tableTempID)
		end
	end
	tableSelfData.Info01 = tableMatrix
	return tableSelfData
end
function GetGerneralTempID(nGrid)
	return server_generalDB.GetTempIdByGrid(nGrid)
end
function GetRewardID(nRankID)
	return arena.getFieldByIdAndIndex(nRankID,"DayRewardID")
end

--获得比武的记录数据
function GetRecordData()
	
	return server_pvpRecordDB.GetCopyTable()
end
function GetIDByKey(nKey)
	local nLegth = string.find(nKey,"_")
	
	local nStr = string.sub(nKey,nLegth+1,string.len(nKey))
	return nStr
end
function GetEndTimeVS()
	return server_biwuDB.GetEndTime()
end
