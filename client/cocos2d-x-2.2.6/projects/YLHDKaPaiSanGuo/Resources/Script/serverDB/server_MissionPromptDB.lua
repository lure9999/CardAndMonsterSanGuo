-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_MissionPromptDB", package.seeall)

local m_MissionPromptDB = {0,0,0,0,0,0,0}

local REDPOINT = {
    REDPOINT_MAIN           =   1, --主线任务红点
    REDPOINT_DAILY          =   2, --日常任务红点
    REDPOINT_CORPS          =   3, --军团任务红点
    REDPOINT_CWAR           =   4, --国战任务红点
    REDPOINT_LEVELUP        =   5, --国家升级任务红点
    REDPOINT_SHILIAN        =   6, --国家试炼任务红点
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local nIndex = pNetStream:Read()
    local nState = pNetStream:Read()
    --nstate :0 = 不显示 1 = 显示
    m_MissionPromptDB[nIndex+1] = nState

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_MissionPromptDB == nil then
        return nil
    else
        return copyTab(m_MissionPromptDB)
    end
end

function GetRedPointState( )
    -- 是否有红点
    for i=1,table.getn(m_MissionPromptDB) do
        if tonumber(m_MissionPromptDB[i]) == 1 then
            return true
        end
    end

    return false
end

function GetRedPointStateByCWar(  )
    -- 国战场景里的日志按钮是否有红点
    if m_MissionPromptDB ~= nil then
        if tonumber(m_MissionPromptDB[REDPOINT.REDPOINT_CORPS]) == 1 or 
           tonumber(m_MissionPromptDB[REDPOINT.REDPOINT_LEVELUP]) == 1 or
           tonumber(m_MissionPromptDB[REDPOINT.REDPOINT_SHILIAN]) == 1 or
           tonumber(m_MissionPromptDB[REDPOINT.REDPOINT_CWAR]) == 1 then
           
            return true
       
        end

        return false
    end
end

function GetTypeState( nIndex )
    return tonumber(m_MissionPromptDB[nIndex])
end

-- 删除。释放
function release()
    m_MissionPromptDB = nil
    package.loaded["server_MissionPromptDB"] = nil
end