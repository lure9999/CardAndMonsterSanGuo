-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_countryLevelUpDB", package.seeall)

local m_CountryLevelUpDB = {}


local CountryInfo = {
    Country                  = 1, 
    Level                    = 2,
    Power                    = 3,
    Exp                      = 4,
    NormalId                 = 5,
    NormalArmyName           = 6,
    NormalArmyLv             = 7,
    EliteId                  = 8,
    EltedArmyName            = 9,
    EltedArmyLv              = 10,
}

local Enemy_Info = {
    Country            = 1,
    Level              = 2,
    Exp                = 3,
}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_CountryLevelUpDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list_CountryInfo = pNetStream:Read()
    local list_EnemyCountry_1 = pNetStream:Read()
    local list_EnemyCountry_2 = pNetStream:Read()

    m_CountryLevelUpDB["Country"] = list_CountryInfo[CountryInfo.Country]
    m_CountryLevelUpDB["Level"] = list_CountryInfo[CountryInfo.Level]
    m_CountryLevelUpDB["Power"] = list_CountryInfo[CountryInfo.Power]
    m_CountryLevelUpDB["Exp"] = list_CountryInfo[CountryInfo.Exp]
    m_CountryLevelUpDB["NormalId"] = list_CountryInfo[CountryInfo.NormalId]
    m_CountryLevelUpDB["NormalArmyName"] = list_CountryInfo[CountryInfo.NormalArmyName]
    m_CountryLevelUpDB["NormalArmyLv"] = list_CountryInfo[CountryInfo.NormalArmyLv]
    m_CountryLevelUpDB["EliteId"] = list_CountryInfo[CountryInfo.EliteId]
    m_CountryLevelUpDB["ElitedArmyName"] = list_CountryInfo[CountryInfo.EltedArmyName]
    m_CountryLevelUpDB["ElitedArmyLv"] = list_CountryInfo[CountryInfo.EltedArmyLv]
    m_CountryLevelUpDB["Enemy_Country_1"] = list_EnemyCountry_1[Enemy_Info.Country]
    m_CountryLevelUpDB["Enemy_Level_1"] = list_EnemyCountry_1[Enemy_Info.Level]
    m_CountryLevelUpDB["Enemy_Exp_1"] = list_EnemyCountry_1[Enemy_Info.Exp]
    m_CountryLevelUpDB["Enemy_Country_2"] = list_EnemyCountry_2[Enemy_Info.Country]
    m_CountryLevelUpDB["Enemy_Level_2"] = list_EnemyCountry_2[Enemy_Info.Level]
    m_CountryLevelUpDB["Enemy_Exp_2"] = list_EnemyCountry_2[Enemy_Info.Exp]

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_CountryLevelUpDB ~= nil then
        return copyTab(m_CountryLevelUpDB)
    else
        print("m_CountryLevelUpDB error")
    end
end

function GetCoutry(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["Country"] 
    end

    return nil
end

function GetPower(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["Power"] 
    end

    return nil
end

function GetLevel(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["Level"] 
    end

    return nil
end

function GetExp(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["Exp"] 
    end

    return nil
end

function GetNormalArmyName(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["NormalArmyName"] 
    end

    return nil    
end

function GetNormalArmyLv(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["NormalArmyLv"] 
    end

    return nil    
end

function GetEliteArmyName(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["ElitedArmyName"] 
    end

    return nil    
end

function GetEliteArmyLv(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["ElitedArmyLv"] 
    end

    return nil    
end

function GetEnemyCountry( nIndex )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["Enemy_Country_"..nIndex] 
    end

    return nil
end

function GetEnemyLevel( nIndex )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["Enemy_Level_"..nIndex] 
    end

    return nil
end

function GetEnemyExp( nIndex )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["Enemy_Exp_"..nIndex] 
    end

    return nil
end

function GetNormalDefenseID(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["NormalId"] 
    end

    return nil
end

function GetEliteDefenseID(  )
    if m_CountryLevelUpDB ~= nil then
        return  m_CountryLevelUpDB["EliteId"] 
    end

    return nil
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_CountryLevelUpDB = tTable
end

-- 删除。释放
function release()
    m_CountryLevelUpDB = nil
    package.loaded["server_countryLevelUpDB"] = nil
end