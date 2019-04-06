require "Script/serverDB/globedefine"
require "Script/serverDB/task"
require "Script/serverDB/resimg"
require "Script/serverDB/orderrew"
require "Script/serverDB/pointreward"
require "Script/serverDB/dailytask"
require "Script/serverDB/maintask"
require "Script/serverDB/coin"
require "Script/serverDB/server_NormalMissionDB"
require "Script/serverDB/server_NormalMissionMainLineDB"
require "Script/serverDB/server_MissionPromptDB"
require "Script/serverDB/server_MissionCountryWarStateDB"
require "Script/serverDB/server_NormalMissionCWarDB"
require "Script/serverDB/server_NormalMissionCWarDBByArray"
require "Script/serverDB/server_NormalMissionCWarLevelUpDBByArray"
require "Script/serverDB/server_NormalMissionCWarShiLianDBByArray"
require "Script/serverDB/server_NormalMissionCorpsDB"
require "Script/serverDB/server_NormalMissionCWarLevelUpDB"
require "Script/serverDB/server_NormalMissionCWarShiLianDB"

require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"

module("MissionNormalData", package.seeall)

local GetIndexByCTag					=	CountryWarLogic.GetIndexByCTag
local GetCityNameByIndex				=	CountryWarData.GetCityNameByIndex
local GetExpendData						=	ConsumeLogic.GetExpendData

function GetBoxScore( nStage,  nScoreIndex )
	return tonumber(globedefine.getFieldByIdAndIndex("daliyboxjifen"..nStage,"Para_"..nScoreIndex))
end

function GetBoxMaxScore( nStage )
	return tonumber(globedefine.getFieldByIdAndIndex("daliyboxjifen"..nStage,"Para_4"))
end

function GetMissionName( nMissionID )
	return task.getFieldByIdAndIndex(nMissionID, "Name")
end

function GetMissionText( nMissionID )
	return task.getFieldByIdAndIndex(nMissionID, "Text")
end

function GetMissionIcon( nMissionID )
	return tonumber(task.getFieldByIdAndIndex(nMissionID, "TaskIcon"))
end

function GetMissionRewardIcon( nMissionID )
	return tonumber(task.getFieldByIdAndIndex(nMissionID, "RewIcon"))
end

function GetMisiionOrderRewID( nMissionID )
	return tonumber(task.getFieldByIdAndIndex(nMissionID, "RewPara"))
end

function GetMissionPath( nResID )
	return resimg.getFieldByIdAndIndex(nResID, "icon_path")
end

function GetCondNum( nMissionID )
	return tonumber(task.getFieldByIdAndIndex(nMissionID, "Condnumber"))
end

function GetCurSocre()
	return tonumber(server_NormalMissionDB.GetScore())
end

function GetBoxState( nIndex )
	return tonumber(server_NormalMissionDB.GetBoxState(nIndex))
end

function GetBoxRewardID( nIndex )
	return tonumber(server_NormalMissionDB.GetBoxRewardID(nIndex))
end

function GetMissionTab( )
	return server_NormalMissionDB.GetCopyTable()
end

function GetRewCondID( nConRewID )
	return tonumber(orderrew.getFieldByIdAndIndex(nConRewID, "RewCondID"))
end

function GetRewType( nConRewID )
	return tonumber(orderrew.getFieldByIdAndIndex(nConRewID, "RewType"))
end

function GetRewPara( nConRewID )
	return tonumber(orderrew.getFieldByIdAndIndex(nConRewID, "RewPara"))
end

function GetRewDataByID( nID )
	local tab = orderrew.getTable()
	local tabRewCondID = {}
	local index = 1
	for key,value in pairs(tab) do
		if tonumber(value[1]) == nID then
			table.insert(tabRewCondID, value[2])
		end
	end
	
	return tabRewCondID
end

function GetMissionRewardRes( nTaskID )
	return tonumber(task.getFieldByIdAndIndex(nTaskID, "RewIcon"))
end

function GetMissionRewardData( nRewardID, nIndex )
	return tonumber(pointreward.getFieldByIdAndIndex(nRewardID, "CionID_"..nIndex))
end

function GetMissionRewardItemData( nRewardID, nIndex )
	return tonumber(pointreward.getFieldByIdAndIndex(nRewardID, "ItemID_"..nIndex))
end

function GetMissionRewardItemDataNum( nRewardID, nIndex )
	return tonumber(pointreward.getFieldByIdAndIndex(nRewardID, "ItemNum_"..nIndex))
end

function GetMissionRewardDataNum( nRewardID, nIndex )
	return tonumber(pointreward.getFieldByIdAndIndex(nRewardID, "Number_"..nIndex))
end

function GetRewardPath( nResId )
	return resimg.getFieldByIdAndIndex(nResId, "icon_path")
end

function GetCoinResID( nCoinID )
	return coin.getFieldByIdAndIndex(nCoinID, "ResID")
end

function GetItemResID( nItemID )
	return item.getFieldByIdAndIndex(nItemID, "res_id")
end

function GetGotoUIID( nMissionID )
	return tonumber(dailytask.getFieldByIdAndIndex(nMissionID, "Go"))
	--[[for key,value in pairs(dailytask.getTable()) do
		if tonumber(value[3]) == tonumber(nMissionID) then
			local nIdxIdx = string.find(key, "_",1)
			local endIdx  = string.len(key)
			local nIdx    = string.sub(key,nIdxIdx + 1,endIdx) 
			return tonumber(dailytask.getFieldByIdAndIndex(nIdx, "Go"))
		end
	end

	return nil]]
end

function GetCoinName( nCoinID )
	return tostring(coin.getFieldByIdAndIndex(nCoinID, "Name"))
end

function GetPromptState( nIndex )
	if server_MissionPromptDB.GetTypeState( nIndex ) == 0 then
		return false
	else
		return true 
	end

	return false
end
--通过任务ID获取任务实例ID
function GetTaskExampleID( nTaskID )
	return tonumber(dailytask.getFieldByIdAndIndex(nTaskID, "TaskID"))
end

--通过任务ID获取任务积分
function GetTaskIntergal( nTaskID )
	return tonumber(dailytask.getFieldByIdAndIndex(nTaskID, "Point"))
end

function GetDailyMissionCmd( nTaskID, nIndex )
	return  tonumber(dailytask.getFieldByIdAndIndex(nTaskID, "CondID"..nIndex))
end

-----主线任务数据

function GetMainMissionCmd( nTaskID, nIndex )
	return  tonumber(maintask.getFieldByIdAndIndex(nTaskID, "CondID"..nIndex))
end

function GetMainLineTab( )
	return server_NormalMissionMainLineDB.GetCopyTable()
end

function GetTaskExampleID_MainLine( nTaskID )
	return tonumber(maintask.getFieldByIdAndIndex(nTaskID, "TaskID"))
end

function GetTaskGroupID_MainLine( nTaskID )
	return tonumber(maintask.getFieldByIdAndIndex(nTaskID, "GroupID"))
end

function GetGotoUIID_MainLine( nMissionID )
	return tonumber(maintask.getFieldByIdAndIndex(nMissionID, "Go"))
end

function GetMainLineUnlockText( nMissionID )
	return tostring(maintask.getFieldByIdAndIndex(nMissionID, "Text"))
end

-----------------------------------------国战任务数据------------------------------------------------
function GetMissionCountryWarState( )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["SanGuoTask"]["State"])     --0未发布， 1发布
end

function GetMissionCountryWarType( )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["SanGuoTask"]["Type"])   
end

function GetMissionCountryWarState_LevelUp( )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["LevelUpTask"]["State"])     --0未发布， 1发布
end

function GetMissionCountryWarType_LevelUp( )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["LevelUpTask"]["Type"])   
end

------------------------------国家试炼任务--------------------------------------------------
function GetMissionShiLianWarState( )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["ShiLianTask"]["State"])     --0未发布， 1发布	
end

function GetMissionCountryWarType_ShiLian( )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["ShiLianTask"]["Type"])   
end

--一上线时候接受的剩余时间
function GetMissionCountryWarTime( )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["SanGuoTask"]["Time"])   
end
--进入国战任务界面接受的剩余时间
function GetMissionCountryWarSurPlusTime( )
	return server_NormalMissionCWarDB.GetSurPlusTime()
end

function GetMissionShiLianTime(  )
	local nTab = server_MissionCountryWarStateDB.GetCopyTable()
	return tonumber(nTab["ShiLianTask"]["Time"])  
end

--发布试炼任务接受的剩余时间
function GetMissionShiLianSurPlusTime(  )
	return server_NormalMissionCWarShiLianDB.GetSurPlusTime()
end

function GetMissionCWarDB( )
	return server_NormalMissionCWarDB.GetCopyTable()
end

function GetMissionDB_LevelUp( )
	return server_NormalMissionCWarLevelUpDB.GetCopyTable()
end

function GetMissionDB_ShiLian( )
	return server_NormalMissionCWarShiLianDB.GetCopyTable()
end

function GetCityName( nCityID )
	local nIndex = GetIndexByCTag(nCityID)
	return tostring(GetCityNameByIndex(nIndex))
end

function GetCWarMissionEffectiveTime( nTaskID )
	return tostring(task.getFieldByIdAndIndex(nTaskID, "Time"))
end

function GetCWarMissionReleaseTime( )
	local nTab  = server_MissionCountryWarStateDB.GetCopyTable()
	local nStr1 = nTab["SanGuoTask"]["Hour1"]..":"..nTab["SanGuoTask"]["min1"]
	local nStr2 = nTab["SanGuoTask"]["Hour2"]..":"..nTab["SanGuoTask"]["min2"]

	return nStr1,nStr2
end
--国家任务组数据
function GetCWarArrayDB(  )
	return server_NormalMissionCWarDBByArray.GetCopyTable()
end

--国家升级任务组数据
function GetCWarArrayDB_LevelUp(  )
	return server_NormalMissionCWarLevelUpDBByArray.GetCopyTable()
end

--国家试炼任务组数据
function GetCWarArrayDB_ShiLian(  )
	return server_NormalMissionCWarShiLianDBByArray.GetCopyTable()
end


-----------------------------------------军团任务数据------------------------------------------------
function GetCorpsMission_SurPlusFinishTimes( )
	return server_NormalMissionCorpsDB.GetSurPlusFinishTimes()
end

function GetCorpsMission_FreeRefreshTimes( )
	return server_NormalMissionCorpsDB.GetFreeRefreshTimes()
end

function GetCorpsMission_TopFinishTimes( )
	return globedefine.getFieldByIdAndIndex("LegioTask", "Para_4")
end

function GetCorpsMission_RefreshConfuse( )
	local pConfuseID = tonumber(globedefine.getFieldByIdAndIndex("LegioTask", "Para_2"))
	return GetExpendData(pConfuseID)
end

function GetCorpsMission_MissionDB(	)
	return server_NormalMissionCorpsDB.GetCopyTable()
end

function GetItemNameByItemID( nItemID )
	return tostring(item.getFieldByIdAndIndex(nItemID, "name"))
end

function GetCoinNameByConsumeType( nConsumeType )
	return tostring(coin.getFieldByIdAndIndex(nConsumeType, "Name"))
end

function GetMissionCond_2Info( nMissionID )
	return tonumber(task.getFieldByIdAndIndex(nMissionID, "CondID2"))
end
