local cjson = require "json"

module("server_CountryWarPalyerInfoDB", package.seeall)

local Server_Order = {
    TeamID       =   1,
    CityID       =   2,
}

local Server_Cmd = {
    Country      =  1,
    BloodTime    =  2,
}

local m_PlayerInfoDB = nil

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)

    if m_PlayerInfoDB == nil then
        m_PlayerInfoDB = {}
    end

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    local list   = pNetStream:Read()
    m_PlayerInfoDB["Country"] = list[Server_Cmd.Country]
    m_PlayerInfoDB["BloodTime"] = list[Server_Cmd.BloodTime]

    CommonData.g_BloodOrDefenseTime = tonumber(list[Server_Cmd.BloodTime])

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_PlayerInfoDB == nil then
        return nil
    else
        return copyTab(m_PlayerInfoDB)
    end
end

-- 删除。释放
function release()
    m_PlayerInfoDB = nil
    package.loaded["server_CountryWarPalyerInfoDB"] = nil
end