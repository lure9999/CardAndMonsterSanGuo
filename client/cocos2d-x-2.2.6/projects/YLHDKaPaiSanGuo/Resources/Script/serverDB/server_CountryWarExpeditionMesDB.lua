-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

local m_CountryWarExpeditionMesDB = nil

module("server_CountryWarExpeditionMesDB", package.seeall)

--require "Script/Main/CountryWar/CountryWarScene"

local Server_ExpeditionData = {
    Grid       =   1,           --服务器生成远征军动态ID
    Index      =   2,           --远征军静态表ID索引
    CityID     =   3,           --远征军所在城市ID
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    if m_CountryWarExpeditionMesDB == nil then
        m_CountryWarExpeditionMesDB = {}
        --print("事件数据不在存在，执行初始化")
    else
        --print("事件数据存在，不执行初始化")
    end

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    local list = pNetStream:Read()

    if table.getn(m_CountryWarExpeditionMesDB) == 0 then
        if table.getn(list) > 0 then
            for i=1,table.getn(list) do
                m_CountryWarExpeditionMesDB[i] = {}
                m_CountryWarExpeditionMesDB[i]["Grid"] = list[i][Server_ExpeditionData.Grid]
                m_CountryWarExpeditionMesDB[i]["Index"] = list[i][Server_ExpeditionData.Index]
                m_CountryWarExpeditionMesDB[i]["CityID"] = list[i][Server_ExpeditionData.CityID]
                if CommonData.g_IsUnlockCountryWar == true then
                    CountryWarScene.InertExpeSuchAs(m_CountryWarExpeditionMesDB[i])
                end
            end
        else
            --print("Error expe mes DB 44")
            --printTab(list)
            --Pause()
        end
    else
        --添加数据
        local nMaxNumNew = table.getn(list)
        local nMaxNumOld = table.getn(m_CountryWarExpeditionMesDB)
        local index = 1 
        --local newData = {}
        if nMaxNumNew > 0 then
            for i=nMaxNumOld + 1,nMaxNumOld + nMaxNumNew do
                m_CountryWarExpeditionMesDB[i] = {}
                m_CountryWarExpeditionMesDB[i]["Grid"] = list[index][Server_ExpeditionData.Grid]
                m_CountryWarExpeditionMesDB[i]["Index"] = list[index][Server_ExpeditionData.Index]
                m_CountryWarExpeditionMesDB[i]["CityID"] = list[index][Server_ExpeditionData.CityID]
                index = index + 1
               -- newData[i] = m_CountryWarExpeditionMesDB[i]
               CountryWarScene.InertExpeSuchAs(m_CountryWarExpeditionMesDB[i])
            end
        else
            print("Error expe mes DB 65")
            --printTab(list)
            --Pause()
        end
        --[[if table.getn(newData) > 0 then
            CountryWarScene.InertExpeSuchAs(newData)
        end]]
        --print("添加数据，添加后 ---------------------------- ")
        --printTab(m_CountryWarExpeditionMesDB)
    end
    
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_CountryWarExpeditionMesDB == nil then
        return nil
    else
        return copyTab(m_CountryWarExpeditionMesDB)
    end
end

function UpdateDataByGrid( nGrid, nCityID )
    if m_CountryWarExpeditionMesDB == nil then
        return nil
    else
        for i=1,table.getn(m_CountryWarExpeditionMesDB) do
            if m_CountryWarExpeditionMesDB[i]["Grid"] == nGrid then
                m_CountryWarExpeditionMesDB[i]["CityID"] = nCityID
                --print("更新事件数据源动态ID为"..nGrid.."的城市ID为"..nCityID)
                break
            end
        end
    end
end

function DeltabByGrid( nGrid )
    --print("准备del = "..nGrid)
    if m_CountryWarExpeditionMesDB == nil then
        return nil
    else
        local nDelIndex = nil
        for i=1,table.getn(m_CountryWarExpeditionMesDB) do
            if m_CountryWarExpeditionMesDB[i]["Grid"] == nGrid then
                nDelIndex = i
                --print("删除事件数据源"..i)
                --printTab(m_CountryWarExpeditionMesDB)
                break
            end
        end
        if nDelIndex ~= nil then
            CountryWarScene.DelExpeSuchAs(nDelIndex, nGrid)
            table.remove(m_CountryWarExpeditionMesDB, nDelIndex)
            print("删除成功")
            --printTab(m_CountryWarExpeditionMesDB)
        else
            print("删除事件数据源索引为空")
        end
    end
end

function GetExpeDitionCount( )
    if m_CountryWarExpeditionMesDB ~= nil then
        return tonumber(table.getn(m_CountryWarExpeditionMesDB))
    else    
        return 0
    end
end

function GetExpeDitionIndex( nIndex )
    if m_CountryWarExpeditionMesDB ~= nil then
        return tonumber(m_CountryWarExpeditionMesDB[nIndex]["Index"])
    else    
        return nil
    end
end

function GetExpeDitionGrid( nIndex )
    if m_CountryWarExpeditionMesDB ~= nil then
        return tonumber(m_CountryWarExpeditionMesDB[nIndex]["Grid"])
    else    
        return nil
    end
end

function GetExpeDitionCityID( nIndex )
    if m_CountryWarExpeditionMesDB ~= nil then
        if m_CountryWarExpeditionMesDB[nIndex] ~= nil then
            return tonumber(m_CountryWarExpeditionMesDB[nIndex]["CityID"])
        else
            return nil
        end
    else    
        return nil
    end
end

-- 删除。释放
function release()
    m_CountryWarExpeditionMesDB = nil
    package.loaded["server_CountryWarExpeditionMesDB"] = nil
end

