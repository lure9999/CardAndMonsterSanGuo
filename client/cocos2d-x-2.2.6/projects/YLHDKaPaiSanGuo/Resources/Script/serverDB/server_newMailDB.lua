-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_newMailDB", package.seeall)

local m_tableNewMailDB = {}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableMailInfoDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()

    m_tableNewMailDB["ID"] = pNetStream:Read()
    m_tableNewMailDB["Type"] = pNetStream:Read()
    m_tableNewMailDB["Time"] = pNetStream:Read()
    m_tableNewMailDB["Title"] = pNetStream:Read()
    m_tableNewMailDB["SenderName"] = pNetStream:Read()
    m_tableNewMailDB["Content"] = pNetStream:Read()
    --m_tableNewMailDB["hasReward"] = pNetStream:Read()

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_tableNewMailDB == nil then
        return nil
    else
        return copyTab(m_tableNewMailDB)
    end
end

-- 删除。释放
function release()
    m_tableNewMailDB = nil
    package.loaded["server_newMailDB"] = nil
end