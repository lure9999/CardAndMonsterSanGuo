local cjson = require "json"

module("server_CountryWarTeamLifeDB", package.seeall)

local Server_Order = {
    TeamID       =   1,
    CityID       =   2,
}

local m_TeamLifeDB = nil

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    if m_TeamLifeDB == nil then
        m_TeamLifeDB = {}
    end

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    m_TeamLifeDB[1] = pNetStream:Read()
    m_TeamLifeDB[2] = pNetStream:Read()
    m_TeamLifeDB[3] = pNetStream:Read()

    printTab(m_TeamLifeDB)
    --Pause()

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_TeamLifeDB == nil then
        return nil
    else
        return copyTab(m_TeamLifeDB)
    end
end

-- 删除。释放
function release()
    m_TeamLifeDB = nil
    package.loaded["server_CountryWarTeamLifeDB"] = nil
end