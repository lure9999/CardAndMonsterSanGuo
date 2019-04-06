-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_NormalMissionCorpsDB", package.seeall)

local m_NormalMissionCorpsDB = {}


local MissionInfo = {
    Index              = 1,         --军团任务索引
    TaskID             = 2,         --军团任务ID
    TaskState          = 3,         --军团任务状态
    RewardID           = 4,         --军团任务奖励ID
    Count              = 5,         --军团任务计数
    TakeTime           = 6,         --军团任务接取时间
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_NormalMissionCorpsDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()

    m_NormalMissionCorpsDB["SurPlusFinishTimes"]         = pNetStream:Read()       --任务剩余完成次数
    m_NormalMissionCorpsDB["FreeRefreshTimes"]           = pNetStream:Read()       --任务剩余免费刷新次数

    local list_Corps  = pNetStream:Read()

    m_NormalMissionCorpsDB["CorpsMission"] = {}
    if list_Corps ~= nil then
        for key,value in pairs(list_Corps) do 
            m_NormalMissionCorpsDB["CorpsMission"][key] = {}
            m_NormalMissionCorpsDB["CorpsMission"][key]["Index"]         = value[MissionInfo.Index]
            m_NormalMissionCorpsDB["CorpsMission"][key]["TaskID"]         = value[MissionInfo.TaskID]
            m_NormalMissionCorpsDB["CorpsMission"][key]["TaskState"]      = value[MissionInfo.TaskState]
            m_NormalMissionCorpsDB["CorpsMission"][key]["RewardID"]       = value[MissionInfo.RewardID]
            m_NormalMissionCorpsDB["CorpsMission"][key]["Count"]          = value[MissionInfo.Count]
            m_NormalMissionCorpsDB["CorpsMission"][key]["TakeTime"]       = value[MissionInfo.TakeTime]
        end
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_NormalMissionCorpsDB ~= nil then
        return copyTab(m_NormalMissionCorpsDB)
    else
        print("m_NormalMissionCorpsDB error")
    end
end

function GetSurPlusFinishTimes( )
    if m_NormalMissionCorpsDB ~= nil then
        return tonumber(m_NormalMissionCorpsDB["SurPlusFinishTimes"])
    else
        print("m_NormalMissionCorpsDB error")
    end
end

function GetFreeRefreshTimes( )
    if m_NormalMissionCorpsDB ~= nil then
        return tonumber(m_NormalMissionCorpsDB["FreeRefreshTimes"])
    else
        print("m_NormalMissionCorpsDB error")
    end
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_NormalMissionCorpsDB = tTable
end

-- 删除。释放
function release()
    m_NormalMissionCorpsDB = nil
    package.loaded["server_NormalMissionCorpsDB"] = nil
end