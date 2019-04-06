local cjson = require "json"

module("server_CountryWarTeamOrderDB", package.seeall)

local Server_Order = {
    TeamID       =   1,
    CityID       =   2,
}

local m_TeamOrderDB = nil

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    if m_TeamOrderDB == nil then
        m_TeamOrderDB = {}
    end

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    local list = pNetStream:Read()

    m_TeamOrderDB[list[Server_Order.TeamID]] = {}
    m_TeamOrderDB[list[Server_Order.TeamID]]["CityID"] = list[Server_Order.CityID]

    --停止移动
    require "Script/Main/CountryWar/CountryWarEventManager"
    print("队伍"..list[Server_Order.TeamID].."停在了"..list[Server_Order.CityID])
    CountryWarEventManager.CountryWarStopMove(list[Server_Order.TeamID], m_TeamOrderDB[list[Server_Order.TeamID]]["CityID"])
    --调给观战的接口，观察单挑时武将的情况
    require "Script/Main/CountryWar/AtkCityScene"
    AtkCityScene.UpdateHeadWJData(list[Server_Order.TeamID], list[Server_Order.CityID])
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_TeamOrderDB == nil then
        return nil
    else
        return copyTab(m_TeamOrderDB)
    end
end

-- 删除。释放
function release()
    m_CountryWarAllMesDB = nil
    package.loaded["server_CountryWarAllMesDB"] = nil
end