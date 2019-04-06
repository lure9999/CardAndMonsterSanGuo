-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_MissionCountryWarStateDB", package.seeall)

local m_MissionCountryWarStateDB = {}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    --m_MissionCountryWarStateDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local nstate = pNetStream:Read()
    local ntype = pNetStream:Read()

    local function GetLevelUpMissionBegin(  )
        --判断当前国家升级任务是否发布
        if ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI or 
            ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU or 
            ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU then

            return true
        end

        return false
    end

    local function GetShiLianMissionBegin(  )
        --判断当前国家试炼任务是否发布
        if ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_TRIAL then

            return true
        end

        return false
    end

    if ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS then
        --三国任务发布数据
        m_MissionCountryWarStateDB["SanGuoTask"] = {}
        m_MissionCountryWarStateDB["SanGuoTask"]["State"]     = nstate
        m_MissionCountryWarStateDB["SanGuoTask"]["Type"]      = ntype
        m_MissionCountryWarStateDB["SanGuoTask"]["Time"]      = pNetStream:Read()
        m_MissionCountryWarStateDB["SanGuoTask"]["Hour1"]     = pNetStream:Read()
        m_MissionCountryWarStateDB["SanGuoTask"]["min1"]      = pNetStream:Read()
        m_MissionCountryWarStateDB["SanGuoTask"]["Hour2"]     = pNetStream:Read()
        m_MissionCountryWarStateDB["SanGuoTask"]["min2"]      = pNetStream:Read()
    end

    if GetLevelUpMissionBegin() == true then
        --升级任务发布数据
        m_MissionCountryWarStateDB["LevelUpTask"] = {}
        m_MissionCountryWarStateDB["LevelUpTask"]["State"]     = nstate
        m_MissionCountryWarStateDB["LevelUpTask"]["Type"]      = ntype
    end

    if GetShiLianMissionBegin() == true then
        --试炼任务发布数据
        m_MissionCountryWarStateDB["ShiLianTask"] = {}
        m_MissionCountryWarStateDB["ShiLianTask"]["State"]     = nstate
        m_MissionCountryWarStateDB["ShiLianTask"]["Type"]      = ntype  
        m_MissionCountryWarStateDB["ShiLianTask"]["Time"]      = ntype       
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_MissionCountryWarStateDB == nil then
        return nil
    else
        return copyTab(m_MissionCountryWarStateDB)
    end
end

-- 删除。释放
function release()
    m_MissionCountryWarStateDB = nil
    package.loaded["server_MissionCountryWarStateDB"] = nil
end