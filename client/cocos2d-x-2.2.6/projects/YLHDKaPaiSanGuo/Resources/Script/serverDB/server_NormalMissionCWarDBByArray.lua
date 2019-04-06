-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_NormalMissionCWarDBByArray", package.seeall)

local m_CWarArrayDB = {}


local MissionInfo = {
    Index              = 1,
    TaskID             = 2,     --任务ID
    TaskState          = 3,     --任务状态   0==完成未领取，1=不可领取，2=完成已领取
    RewardID           = 4,
    Count              = 5,     --完成数
    TakeTime           = 6,     --接取任务时间
    AttackType         = 7,     --攻打国家类型
    AttackID           = 8,     --攻打国家ID
    DefenseType        = 9,     --防守国家类型
    DefenseID          = 10,     --防守国家ID
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_CWarArrayDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    
    local ntype  = pNetStream:Read()

    local nSurplusTime  = pNetStream:Read()

    local list_Country  = pNetStream:Read()

    m_CWarArrayDB["SurPlusTime"] = nSurplusTime

    m_CWarArrayDB["CWarArray"] = {}

    for key,value in pairs(list_Country) do 
        m_CWarArrayDB["CWarArray"][key] = {}
        m_CWarArrayDB["CWarArray"][key]["Index"]          = value[MissionInfo.Index]
        m_CWarArrayDB["CWarArray"][key]["TaskID"]         = value[MissionInfo.TaskID]
        m_CWarArrayDB["CWarArray"][key]["TaskState"]      = value[MissionInfo.TaskState]
        m_CWarArrayDB["CWarArray"][key]["RewardID"]       = value[MissionInfo.RewardID]
        m_CWarArrayDB["CWarArray"][key]["Count"]          = value[MissionInfo.Count]
        m_CWarArrayDB["CWarArray"][key]["TakeTime"]       = value[MissionInfo.TakeTime]
        m_CWarArrayDB["CWarArray"][key]["AttackType"]     = value[MissionInfo.AttackType]
        m_CWarArrayDB["CWarArray"][key]["AttackID"]       = value[MissionInfo.AttackID]
        m_CWarArrayDB["CWarArray"][key]["DefenseType"]    = value[MissionInfo.DefenseType]
        m_CWarArrayDB["CWarArray"][key]["DefenseID"]      = value[MissionInfo.DefenseID]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_CWarArrayDB ~= nil then
        return copyTab(m_CWarArrayDB)
    else
        print("m_CWarArrayDB error")
    end
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_CWarArrayDB = tTable
end

-- 删除。释放
function release()
    m_CWarArrayDB = nil
    package.loaded["server_NormalMissionCWarDBByArray"] = nil
end