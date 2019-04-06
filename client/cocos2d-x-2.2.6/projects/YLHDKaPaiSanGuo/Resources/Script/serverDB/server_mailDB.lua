-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_mailDB", package.seeall)

local m_tableMailDB = {}

local Server_Mail = {
    ID                  = 1,        --邮件标识
    Type                = 2,        --邮件类型
    Status              = 3,        --邮件状态(已读，未读)
    ResIMG              = 4,        --图标ID
    hasReward           = 5,        --是否有奖励
    Time                = 6,        --邮件日期
    Title               = 7,        --邮件标题
    SenderName          = 8,        --邮件发送者
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableMailDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    local list = pNetStream:Read()
    for key, value in pairs(list) do
        m_tableMailDB[key] = {}
        m_tableMailDB[key]["ID"] = value[Server_Mail.ID]
        m_tableMailDB[key]["Type"] = value[Server_Mail.Type]
        m_tableMailDB[key]["Status"] = value[Server_Mail.Status]
        m_tableMailDB[key]["ResIMG"] = value[Server_Mail.ResIMG]
        m_tableMailDB[key]["hasReward"] = value[Server_Mail.hasReward]
        m_tableMailDB[key]["Time"] = value[Server_Mail.Time]
        m_tableMailDB[key]["Title"] = value[Server_Mail.Title]
        m_tableMailDB[key]["SenderName"] = value[Server_Mail.SenderName]
        if m_tableMailDB[key]["hasReward"] == 1 then
            m_tableMailDB[key]["Status"] = 1
        end
    end
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_tableMailDB == nil then
        return nil
    else
        return copyTab(m_tableMailDB)
    end
end

function JudgeUnReadMail()
    local table = GetCopyTable()
    if table == nil then 
        return false 
    else
        for key,value in pairs(table) do
            if value["Status"] == 1 then
                return true
            end
        end
    end
    return false
end

-- 删除。释放
function release()
    m_tableMailDB = nil
    package.loaded["server_mailDB"] = nil
end