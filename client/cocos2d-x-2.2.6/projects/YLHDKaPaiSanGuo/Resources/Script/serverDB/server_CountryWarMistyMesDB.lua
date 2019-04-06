-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"
local m_CountryWarMistyMesDB = {}


module("server_CountryWarMistyMesDB", package.seeall)

local Server_MistyData = {
    MistyIndex          =   1,          --迷雾城市Index
    MonsterNums         =   2,          --迷雾城市守军总数量
    MonsterBlood        =   3,          --迷雾城市守军总血量
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_CountryWarMistyMesDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    local list = pNetStream:Read()

    for i=1,42 do           --写死42个迷雾城市
        m_CountryWarMistyMesDB[i] = {}
        m_CountryWarMistyMesDB[i]["MistyIndex"] = list[i][Server_MistyData.MistyIndex]
        m_CountryWarMistyMesDB[i]["MonsterNums"] = list[i][Server_MistyData.MonsterNums]
        m_CountryWarMistyMesDB[i]["MonsterBlood"] = list[i][Server_MistyData.MonsterBlood]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_CountryWarMistyMesDB == nil then
        return nil
    else
        return copyTab(m_CountryWarMistyMesDB)
    end
end

function UpdateCityMistyState( nIndex, bState )
    if m_CountryWarMistyMesDB == nil then
        return nil
    else
        if bState == false then
            m_CountryWarMistyMesDB[nIndex]["MistyIndex"] = -1
        end
    end
end

-- 删除。释放
function release()
    m_CountryWarMistyMesDB = nil
    package.loaded["server_CountryWarMistyMesDB"] = nil
end

