-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_pvpRecordDB", package.seeall)

local m_tableRecordDB = {}


local Server_Cmd = {
	nStatus= 1, 
	nCount          = 2 ,
	Info01 = 3,
}

local Info01_Cmd = {nID = 1, nTime = 2, nResult = 3,nRanking = 4,nLevel = 5,sName = 6}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableRecordDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
	
    local nStatus = pNetStream:Read()
	Server_Cmd.nCount = pNetStream:Read()
    local list = pNetStream:Read()
	
	
    for key, value in pairs(list) do
        m_tableRecordDB[key] = {}
		m_tableRecordDB[key]["nID"] = tostring(value[Info01_Cmd.nID])
        m_tableRecordDB[key]["nTime"] = value[Info01_Cmd.nTime]
        m_tableRecordDB[key]["nResult"] = value[Info01_Cmd.nResult]
		m_tableRecordDB[key]["nRanking"] = value[Info01_Cmd.nRanking]
		m_tableRecordDB[key]["nLevel"] = value[Info01_Cmd.nLevel]
		m_tableRecordDB[key]["sName"] = value[Info01_Cmd.sName]
    end

    pNetStream = nil
	--[[printTab(m_tableRecordDB)
	Pause()]]--
end



-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableRecordDB)
end

--根据显示的顺序来得到某个玩家的数据,nIndex,1,2,3
function GetPlayerInfoByIndex(nIndex)
	return m_tableRecordDB[nIndex]
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableRecordDB = tTable
end

-- 删除。释放
function release()
    m_tableRecordDB = nil
    package.loaded["server_pvpRecordDB"] = nil
end