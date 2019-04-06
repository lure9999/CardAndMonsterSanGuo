-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_NormalMissionCWarShiLianDB", package.seeall)

local m_NormalMissionCWarShiLianDB = {}


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

    m_NormalMissionCWarShiLianDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()

    m_NormalMissionCWarShiLianDB["Type"]        = pNetStream:Read()
    m_NormalMissionCWarShiLianDB["SurPlusTime"] = pNetStream:Read()

    local list_Country  = pNetStream:Read()
    local list_Personal = pNetStream:Read()

    m_NormalMissionCWarShiLianDB["CWarMissionShiLian"] = {}
    for key,value in pairs(list_Country) do 
        m_NormalMissionCWarShiLianDB["CWarMissionShiLian"][key] = {}
        m_NormalMissionCWarShiLianDB["CWarMissionShiLian"][key]["Index"]         = value[MissionInfo.Index]
        m_NormalMissionCWarShiLianDB["CWarMissionShiLian"][key]["TaskID"]         = value[MissionInfo.TaskID]
        m_NormalMissionCWarShiLianDB["CWarMissionShiLian"][key]["TaskState"]      = value[MissionInfo.TaskState]
        m_NormalMissionCWarShiLianDB["CWarMissionShiLian"][key]["RewardID"]       = value[MissionInfo.RewardID]
        m_NormalMissionCWarShiLianDB["CWarMissionShiLian"][key]["Count"]          = value[MissionInfo.Count]
        m_NormalMissionCWarShiLianDB["CWarMissionShiLian"][key]["TakeTime"]       = value[MissionInfo.TakeTime]
    end

    m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"] = {}
    for key,value in pairs(list_Personal) do 
        m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"][key] = {}
        m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"][key]["Index"]      = value[MissionInfo.Index]
        m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"][key]["TaskID"]     = value[MissionInfo.TaskID]
        m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"][key]["TaskState"]  = value[MissionInfo.TaskState]
        m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"][key]["RewardID"]   = value[MissionInfo.RewardID]
        m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"][key]["Count"]      = value[MissionInfo.Count]
        m_NormalMissionCWarShiLianDB["PersonalMissionShiLian"][key]["TakeTime"]   = value[MissionInfo.TakeTime]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_NormalMissionCWarShiLianDB ~= nil then
        return copyTab(m_NormalMissionCWarShiLianDB)
    else
        print("m_NormalMissionCWarShiLianDB error")
    end
end

function GetSurPlusTime( )
    if m_NormalMissionCWarShiLianDB ~= nil then
        return tonumber(m_NormalMissionCWarShiLianDB["SurPlusTime"])
    else
        print("m_NormalMissionCWarDB error")
    end
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_NormalMissionCWarShiLianDB = tTable
end

-- 删除。释放
function release()
    m_NormalMissionCWarShiLianDB = nil
    package.loaded["server_NormalMissionCWarLevelUpDB"] = nil
end