-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"
local index = 1
local m_CountryWarAllMesDB = {}
local m_StateArr = nil
local m_CountryArr = nil

function GetBinData( Cmd_1, Cmd_2 )
  --[[  print(index, Cmd_1, Cmd_2)

    m_CountryWarAllMesDB[index] = {}
    if tonumber(Cmd_2) == 2 then
        m_CountryWarAllMesDB["Country"][index] = Cmd_1
    elseif tonumber(Cmd_2) == 1 then
        m_CountryWarAllMesDB["State"][index] = Cmd_1
    end
    index = index + 1]]
end

--[[function GetBinData(nArr)
    --local Arr = nArr
end]]

module("server_CountryWarAllMesDB", package.seeall)

local Server_City = {
    State       =   0,
    Country     =   1,
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_CountryWarAllMesDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    local list   = pNetStream:Read()
    local list_State_1 = list[1]            --8个UInt代表城市一级互斥状态（和平 = 0， 战争 = 1）
    local list_State_2 = list[2]            --254个Int代表城市二级叠加状态（第一位 = 城市连线（0 = unlock 1 = lock）， 第二位 = 中心城锁定(1 = 中心城 )， 第三位 = 城市单挑混乱）
    local list_Country = list[3]            --254个Int代表城市国家归属(1 = 魏，2 = 蜀，3 = 吴, 4 = 北狄, 5 = 西戎, 6 = 东夷, 7 = 黄巾军, 8 = 群雄)

    m_CountryWarAllMesDB["State"] = {}
    m_CountryWarAllMesDB["State2"] = {}
    m_CountryWarAllMesDB["Country"] = {}

    m_StateArr = CCArray:create()
    m_CountryArr = CCArray:create()
    --城市一级状态数据解析
    for i=1,table.getn(list_State_1) do
        local UIntData = list_State_1[i]
        UIntTrans(tonumber(UIntData), 1, 1, m_StateArr)
    end

    --城市二级状态数据解析
    local nCityTag2 = 1
    for i=1,table.getn(list_State_2) do
        local IntData = list_State_2[i]
        local nArr = CCArray:create()
        IntTrans(tonumber(IntData), 1, 1, nArr)

        nCityTag2 = i
        if nCityTag2 >= 168 then
            nCityTag2 = i + 2
        end

        m_CountryWarAllMesDB["State2"][nCityTag2] = {}
        for j=0,3 do
            local nState2S = tolua.cast(nArr:objectAtIndex(j),"CCInteger")
            local nStateNum2S = nState2S:getValue()
            if j == 0 then
                m_CountryWarAllMesDB["State2"][nCityTag2]["LockState"] =  nStateNum2S
            elseif j == 1 then
                m_CountryWarAllMesDB["State2"][nCityTag2]["CenterCity"] =  nStateNum2S
            elseif j == 2 then
                m_CountryWarAllMesDB["State2"][nCityTag2]["Confusion"] =  nStateNum2S
            elseif j == 3 then
                m_CountryWarAllMesDB["State2"][nCityTag2]["ManZuEvent"] =  nStateNum2S
            end
        end
    end 

    local nCityTag = 1
    for i=0, m_StateArr:count() - 3 do
        nCityTag = i + 1
        if nCityTag >= 168 then
            nCityTag = i + 3
        end

        local nStateS = tolua.cast(m_StateArr:objectAtIndex(i),"CCInteger")
        local nStateNumS = nStateS:getValue() 
        m_CountryWarAllMesDB["State"][nCityTag] = nStateNumS + 1    

        --城池归属数据解析
        m_CountryWarAllMesDB["Country"][nCityTag] = list_Country[i+1]
    end
   
    --[[local index = 1
    m_CountryWarAllMesDB["Country"] = {}
    m_CountryWarAllMesDB["State"] = {}
    m_StateArr = CCArray:create()
    m_CountryArr = CCArray:create()

    for i=1,table.getn(list) do 
        if i <= 8 then
            --前8个UInt每一位表示一个城市状态 和平 == 1  战争 == 2
            local UIntData = list[i]
            UIntTrans(tonumber(UIntData), 1, 1, m_StateArr)
        else
            --后16个UInt每2位表示城市归属
            local UIntData = list[i]
            UIntTrans(tonumber(UIntData), 2, 3, m_CountryArr)
        end
    end
    local nCityTag = 1
    for i=0,m_CountryArr:count()-3 do
        nCityTag = i + 1
        if nCityTag >= 168 then
            nCityTag = i + 3
        end
        local nStateC = tolua.cast(m_CountryArr:objectAtIndex(i),"CCInteger")
        local nStateNumC = nStateC:getValue()
        m_CountryWarAllMesDB["Country"][nCityTag] = nStateNumC

        local nStateS = tolua.cast(m_StateArr:objectAtIndex(i),"CCInteger")
        local nStateNumS = nStateS:getValue()    
        m_CountryWarAllMesDB["State"][nCityTag] = nStateNumS + 1
    end]]

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_CountryWarAllMesDB == nil then
        return nil
    else
        return copyTab(m_CountryWarAllMesDB)
    end
end

function GetCityCountry( CityID )
    if m_CountryWarAllMesDB["Country"] ~= nil then
        return m_CountryWarAllMesDB["Country"][CityID]
    else
        print("error in CountryDB")
    end
end

function SetCityCountry( CityID, nCountry )
    if m_CountryWarAllMesDB["Country"] ~= nil then
        m_CountryWarAllMesDB["Country"][CityID] = nCountry
        print("修改城池"..CityID.."所属国家为 = "..nCountry)
    else
        print("error in CountryDB")
    end
end

function GetCityState( CityID )
    if m_CountryWarAllMesDB["State"] ~= nil then
        return m_CountryWarAllMesDB["State"][CityID]
    else
        print("error in StateDB")
    end
end
--二级状态数据获取
--锁定状态
function GetCityLockByState2( CityID )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        return m_CountryWarAllMesDB["State2"][CityID]["LockState"]
    else
        print("error in StateDB")
    end
end
--中心城状态
function GetCityCenterByState2( CityID )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        return m_CountryWarAllMesDB["State2"][CityID]["CenterCity"]
    else
        print("error in StateDB")
    end
end
--混乱单挑状态
function GetCityConfusByState2( CityID )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        return m_CountryWarAllMesDB["State2"][CityID]["Confusion"]
    else
        print("error in StateDB")
    end
end
--蛮族入侵状态
function GetCityManZuByState2( CityID )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        return m_CountryWarAllMesDB["State2"][CityID]["ManZuEvent"]
    else
        print("error in StateDB")
    end
end

function SetCityLockByState2( CityID, nState )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        m_CountryWarAllMesDB["State2"][CityID]["LockState"] = nState
        print("修改城池"..CityID.."当前状态LockState为 = "..nState)
    else
        print("error in StateDB")
    end
end

function SetCityCenterByState2( CityID, nState )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        m_CountryWarAllMesDB["State2"][CityID]["CenterCity"] = nState
        print("修改城池"..CityID.."当前状态Center为 = "..nState)
    else
        print("error in StateDB")
    end
end

function SetCityConfusByState2( CityID, nState )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        m_CountryWarAllMesDB["State2"][CityID]["Confusion"] = nState
        print("修改城池"..CityID.."当前状态Confusion为 = "..nState)
    else
        print("error in StateDB")
    end
end
--重设蛮族入侵状态
function SetCityManZuByState2( CityID, nState )
    if m_CountryWarAllMesDB["State2"] ~= nil then
        m_CountryWarAllMesDB["State2"][CityID]["ManZuEvent"] = nState
        print("修改城池"..CityID.."当前状态ManZuEvent为 = "..nState)
    else
        print("error in StateDB")
    end
end
--------------------------

function SetCityState( CityID, nState )
    if m_CountryWarAllMesDB["State"] ~= nil then
        m_CountryWarAllMesDB["State"][CityID] = nState
        print("修改城池"..CityID.."当前状态为 = "..nState)
    else
        print("error in StateDB")
    end
end

-- 删除。释放
function release()
    m_CountryWarAllMesDB = nil
    package.loaded["server_CountryWarAllMesDB"] = nil
end