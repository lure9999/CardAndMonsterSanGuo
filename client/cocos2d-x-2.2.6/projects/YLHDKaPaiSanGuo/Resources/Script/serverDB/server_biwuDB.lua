-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_biwuDB", package.seeall)

local m_tableBiWuDB = {}
local nRankHistory = nil
local nRankCurrent = nil
local nTimes = nil
local endTime = 0
local Server_Cmd = {
    pID            = 1, 
	pName          = 2 ,
    pLevel            = 3, 
	pModelID     = 4,
	pRank = 5,
	pFight = 6,
	Info01 = 7,
}

local Info01_Cmd = {wID1 = 1, wID2 = 2, wID3 = 3,wID4 = 4,wID5 = 5,wID6 = 6}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableBiWuDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
	nRankHistory  = pNetStream:Read()
	nRankCurrent = pNetStream:Read()
	nTimes = pNetStream:Read()
	endTime = pNetStream:Read()
    local list = pNetStream:Read()
    for key, value in pairs(list) do
        m_tableBiWuDB[key] = {}
        m_tableBiWuDB[key]["pID"] = value[Server_Cmd.pID]
		m_tableBiWuDB[key]["pName"] = value[Server_Cmd.pName]
		m_tableBiWuDB[key]["pLevel"] = value[Server_Cmd.pLevel]
		m_tableBiWuDB[key]["pModelID"] = value[Server_Cmd.pModelID]
		m_tableBiWuDB[key]["pRank"] = value[Server_Cmd.pRank]
		m_tableBiWuDB[key]["pFight"] = value[Server_Cmd.pFight]
		m_tableBiWuDB[key]["Info01"] = {}
		m_tableBiWuDB[key]["Info01"]["wID1"] = value[Server_Cmd.Info01][Info01_Cmd.wID1]
        m_tableBiWuDB[key]["Info01"]["wID2"] = value[Server_Cmd.Info01][Info01_Cmd.wID2]
        m_tableBiWuDB[key]["Info01"]["wID3"] = value[Server_Cmd.Info01][Info01_Cmd.wID3]
		m_tableBiWuDB[key]["Info01"]["wID4"] = value[Server_Cmd.Info01][Info01_Cmd.wID4]
		m_tableBiWuDB[key]["Info01"]["wID5"] = value[Server_Cmd.Info01][Info01_Cmd.wID5]
		m_tableBiWuDB[key]["Info01"]["wID6"] = value[Server_Cmd.Info01][Info01_Cmd.wID6]
    end

    pNetStream = nil
	--[[printTab(m_tableBiWuDB)
	Pause()]]--
end

--得到历史排名
function GetHistoryRank()
	return nRankHistory
end
--得到当前排名
function GetCurrentRank()
	return nRankCurrent
end
-- 得到当前的次数
function GetVSTimes()
	return nTimes
end
function GetEndTime()
	return endTime
end
-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableBiWuDB)
end

--根据显示的顺序来得到某个玩家的数据,nIndex,1,2,3
function GetPlayerInfoByIndex(nIndex)
	return m_tableBiWuDB[nIndex]
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableBiWuDB = tTable
end

-- 删除。释放
function release()
    m_tableBiWuDB = nil
    package.loaded["server_biwuDB"] = nil
end