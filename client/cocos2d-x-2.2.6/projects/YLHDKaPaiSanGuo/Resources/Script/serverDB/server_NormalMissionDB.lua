-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_NormalMissionDB", package.seeall)

local m_NormalMissionDB = {}


local MissionInfo = {
    TaskID             = 1,     --任务ID
    TaskState          = 2,     --任务状态   0==完成未领取，1=不可领取，2=完成已领取
    RewardID           = 3,
    Count              = 4,     --完成数
    TakeTime           = 5,     --接取任务时间
}

local MissionBoxInfo = {
    BoxState           = 1,
    BoxRewardID        = 2,
}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_NormalMissionDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local nType  = pNetStream:Read()
    m_NormalMissionDB["Score"] = pNetStream:Read()
    local list_BoxState = pNetStream:Read()
    local list_Mission  = pNetStream:Read()
    m_NormalMissionDB["Box"] = {}
    for key,value in pairs(list_BoxState) do 
        m_NormalMissionDB["Box"][key] = {}
        m_NormalMissionDB["Box"][key]["BoxState"] = value[MissionBoxInfo.BoxState]
        m_NormalMissionDB["Box"][key]["BoxRewardID"] = value[MissionBoxInfo.BoxRewardID]
    end

    m_NormalMissionDB["Mission"] = {}
    for key,value in pairs(list_Mission) do
        m_NormalMissionDB["Mission"][key] = {}
        m_NormalMissionDB["Mission"][key]["TaskID"] = value[MissionInfo.TaskID]
        m_NormalMissionDB["Mission"][key]["TaskState"] = value[MissionInfo.TaskState]
        m_NormalMissionDB["Mission"][key]["RewardID"]  = value[MissionInfo.RewardID]
        m_NormalMissionDB["Mission"][key]["Count"] = value[MissionInfo.Count]
        m_NormalMissionDB["Mission"][key]["TakeTime"] = value[MissionInfo.TakeTime]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_NormalMissionDB ~= nil then
        return copyTab(m_NormalMissionDB)
    else
        print("m_NormalMissionDB error")
    end
end

function GetScore(  )
    if m_NormalMissionDB ~= nil then
        return  m_NormalMissionDB["Score"] 
    end

    return nil
end

function GetBoxState( nIndex )
    if m_NormalMissionDB ~= nil then
        return  m_NormalMissionDB["Box"][nIndex]["BoxState"] 
    end

    return nil
end

function GetBoxRewardID( nIndex )
    if m_NormalMissionDB ~= nil then
        return  m_NormalMissionDB["Box"][nIndex]["BoxRewardID"] 
    end

    return nil
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_NormalMissionDB = tTable
end

-- 删除。释放
function release()
    m_NormalMissionDB = nil
    package.loaded["server_NormalMissionDB"] = nil
end