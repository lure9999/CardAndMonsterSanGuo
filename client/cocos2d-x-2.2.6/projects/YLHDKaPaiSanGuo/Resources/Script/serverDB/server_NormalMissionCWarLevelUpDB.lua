-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_NormalMissionCWarLevelUpDB", package.seeall)

local m_NormalMissionCWarLevelUpDB = {}


local MissionInfo = {
    Index              = 1,
    TaskID             = 2,     --任务ID
    TaskState          = 3,     --任务状态   0==完成未领取，1=不可领取，2=完成已领取
    RewardID           = 4,
    Count              = 5,     --完成数
    TakeTime           = 6,     --接取任务时间
}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)

    m_NormalMissionCWarLevelUpDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()

    m_NormalMissionCWarLevelUpDB["Type"]        = pNetStream:Read()

    local list_Country  = pNetStream:Read()
    local list_Personal = pNetStream:Read()

    m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"] = {}
    for key,value in pairs(list_Country) do 
        m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"][key] = {}
        m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"][key]["Index"]         = value[MissionInfo.Index]
        m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"][key]["TaskID"]         = value[MissionInfo.TaskID]
        m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"][key]["TaskState"]      = value[MissionInfo.TaskState]
        m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"][key]["RewardID"]       = value[MissionInfo.RewardID]
        m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"][key]["Count"]          = value[MissionInfo.Count]
        m_NormalMissionCWarLevelUpDB["CWarMissionLevelUp"][key]["TakeTime"]       = value[MissionInfo.TakeTime]
    end

    m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"] = {}
    for key,value in pairs(list_Personal) do 
        m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"][key] = {}
        m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"][key]["Index"]      = value[MissionInfo.Index]
        m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"][key]["TaskID"]     = value[MissionInfo.TaskID]
        m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"][key]["TaskState"]  = value[MissionInfo.TaskState]
        m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"][key]["RewardID"]   = value[MissionInfo.RewardID]
        m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"][key]["Count"]      = value[MissionInfo.Count]
        m_NormalMissionCWarLevelUpDB["PersonalMissionLevelUp"][key]["TakeTime"]   = value[MissionInfo.TakeTime]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_NormalMissionCWarLevelUpDB ~= nil then
        return copyTab(m_NormalMissionCWarLevelUpDB)
    else
        print("m_NormalMissionCWarLevelUpDB error")
    end
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_NormalMissionCWarLevelUpDB = tTable
end

-- 删除。释放
function release()
    m_NormalMissionCWarLevelUpDB = nil
    package.loaded["server_NormalMissionCWarLevelUpDB"] = nil
end