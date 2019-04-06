-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_NormalMissionMainLineDB", package.seeall)

local m_NormalMissionMainLineDB = {}


local MissionInfo = {
    TaskID             = 1,     --任务ID
    TaskState          = 2,     --任务状态   0==完成未领取，1=不可领取，2=完成已领取， 3=未开启
    RewardID           = 3,
    Count              = 4,     --完成数
    TakeTime           = 5,     --接取任务时间
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_NormalMissionMainLineDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local ntype = pNetStream:Read()
    local list_Mission = pNetStream:Read()

    for key,value in pairs(list_Mission) do
        m_NormalMissionMainLineDB[key] = {}
        m_NormalMissionMainLineDB[key]["TaskID"] = value[MissionInfo.TaskID]
        m_NormalMissionMainLineDB[key]["TaskState"] = value[MissionInfo.TaskState]
        m_NormalMissionMainLineDB[key]["RewardID"] = value[MissionInfo.RewardID]
        m_NormalMissionMainLineDB[key]["Count"] = value[MissionInfo.Count]
        m_NormalMissionMainLineDB[key]["TakeTime"] = value[MissionInfo.TakeTime]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_NormalMissionMainLineDB ~= nil then
        return copyTab(m_NormalMissionMainLineDB)
    else
        print("m_NormalMissionMainLineDB error")
    end
end


-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_NormalMissionMainLineDB = tTable
end

-- 删除。释放
function release()
    m_NormalMissionMainLineDB = nil
    package.loaded["server_NormalMissionMainLineDB"] = nil
end