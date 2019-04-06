-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_NormalMissionCWarDB", package.seeall)

local m_NormalMissionCWarDB = {}


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

local MissionBoxInfo = {
    BoxState           = 1,
    BoxRewardID        = 2,
}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_NormalMissionCWarDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()

    m_NormalMissionCWarDB["Type"]        = pNetStream:Read()
    m_NormalMissionCWarDB["SurPlusTime"] = pNetStream:Read()
    m_NormalMissionCWarDB["RewardID"]    = pNetStream:Read()
    m_NormalMissionCWarDB["RewardState"] = pNetStream:Read()

    local list_Country  = pNetStream:Read()
    local list_Personal = pNetStream:Read()

    m_NormalMissionCWarDB["CWarMission"] = {}
    for key,value in pairs(list_Country) do 
        m_NormalMissionCWarDB["CWarMission"][key] = {}
        m_NormalMissionCWarDB["CWarMission"][key]["Index"]         = value[MissionInfo.Index]
        m_NormalMissionCWarDB["CWarMission"][key]["TaskID"]         = value[MissionInfo.TaskID]
        m_NormalMissionCWarDB["CWarMission"][key]["TaskState"]      = value[MissionInfo.TaskState]
        m_NormalMissionCWarDB["CWarMission"][key]["RewardID"]       = value[MissionInfo.RewardID]
        m_NormalMissionCWarDB["CWarMission"][key]["Count"]          = value[MissionInfo.Count]
        m_NormalMissionCWarDB["CWarMission"][key]["TakeTime"]       = value[MissionInfo.TakeTime]
        m_NormalMissionCWarDB["CWarMission"][key]["AttackType"]     = value[MissionInfo.AttackType]
        m_NormalMissionCWarDB["CWarMission"][key]["AttackID"]       = value[MissionInfo.AttackID]
        m_NormalMissionCWarDB["CWarMission"][key]["DefenseType"]    = value[MissionInfo.DefenseType]
        m_NormalMissionCWarDB["CWarMission"][key]["DefenseID"]      = value[MissionInfo.DefenseID]
    end

    m_NormalMissionCWarDB["PersonalMission"] = {}
    for key,value in pairs(list_Personal) do 
        m_NormalMissionCWarDB["PersonalMission"][key] = {}
        m_NormalMissionCWarDB["PersonalMission"][key]["Index"]      = value[MissionInfo.Index]
        m_NormalMissionCWarDB["PersonalMission"][key]["TaskID"]     = value[MissionInfo.TaskID]
        m_NormalMissionCWarDB["PersonalMission"][key]["TaskState"]  = value[MissionInfo.TaskState]
        m_NormalMissionCWarDB["PersonalMission"][key]["RewardID"]   = value[MissionInfo.RewardID]
        m_NormalMissionCWarDB["PersonalMission"][key]["Count"]      = value[MissionInfo.Count]
        m_NormalMissionCWarDB["PersonalMission"][key]["TakeTime"]   = value[MissionInfo.TakeTime]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_NormalMissionCWarDB ~= nil then
        return copyTab(m_NormalMissionCWarDB)
    else
        print("m_NormalMissionCWarDB error")
    end
end

function GetSurPlusTime( )
    if m_NormalMissionCWarDB ~= nil then
        return tonumber(m_NormalMissionCWarDB["SurPlusTime"])
    else
        print("m_NormalMissionCWarDB error")
    end
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_NormalMissionCWarDB = tTable
end

-- 删除。释放
function release()
    m_NormalMissionCWarDB = nil
    package.loaded["server_NormalMissionCWarDB"] = nil
end