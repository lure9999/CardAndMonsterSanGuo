-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"
local m_CountryWarTeamMesDB = {}


module("server_CountryWarTeamMesDB", package.seeall)

local Server_TeamData = {
    TeamIndex       =   1,
    TeamLevel       =   2,
    TeamFace        =   3,
    TeamRes         =   4,
    TeamName        =   5,
    TeamBloodMax    =   6,
    TeamBloodCur    =   7,
    TeamID          =   8,
    TeamState       =   9,
    TeamCity        =   10,
    TeamTarCity     =   11,
    TeamBloodWCity  =   12, -- -1 = 未开始血战
    TeamCellTime    =   13, -- -1 = 没有坐牢
    TeamMistyIndex  =   14,
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_CountryWarTeamMesDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    local list = pNetStream:Read()

    for i=1,table.getn(list) do
        local nIndex = list[i][Server_TeamData.TeamIndex]
        m_CountryWarTeamMesDB[nIndex] = {}
        m_CountryWarTeamMesDB[nIndex]["TeamLevel"] = list[i][Server_TeamData.TeamLevel]
        m_CountryWarTeamMesDB[nIndex]["TeamFace"] = list[i][Server_TeamData.TeamFace]
        m_CountryWarTeamMesDB[nIndex]["TeamRes"] = list[i][Server_TeamData.TeamRes]
        m_CountryWarTeamMesDB[nIndex]["TeamName"] = list[i][Server_TeamData.TeamName]
        m_CountryWarTeamMesDB[nIndex]["TeamBloodMax"] = list[i][Server_TeamData.TeamBloodMax]
        m_CountryWarTeamMesDB[nIndex]["TeamBloodCur"] = list[i][Server_TeamData.TeamBloodCur]
        m_CountryWarTeamMesDB[nIndex]["TeamID"] = list[i][Server_TeamData.TeamID]
        m_CountryWarTeamMesDB[nIndex]["TeamState"] = list[i][Server_TeamData.TeamState]
        m_CountryWarTeamMesDB[nIndex]["TeamCity"] = list[i][Server_TeamData.TeamCity]
        m_CountryWarTeamMesDB[nIndex]["TeamTarCity"] = list[i][Server_TeamData.TeamTarCity]
        m_CountryWarTeamMesDB[nIndex]["TeamBloodWCity"] = list[i][Server_TeamData.TeamBloodWCity]
        m_CountryWarTeamMesDB[nIndex]["CellTime"] = list[i][Server_TeamData.TeamCellTime]
        m_CountryWarTeamMesDB[nIndex]["TeamMistyIndex"] = list[i][Server_TeamData.TeamMistyIndex]
    end
    
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_CountryWarTeamMesDB == nil then
        return nil
    else
        return copyTab(m_CountryWarTeamMesDB)
    end
end

function AddTeamMess( nTab )
    if m_CountryWarTeamMesDB ~= nil and nTab ~= nil then
        for key,value in pairs(nTab) do
            local nIndex = nTab["TeamIndex"]
            m_CountryWarTeamMesDB[nIndex] = {}
            m_CountryWarTeamMesDB[nIndex]["TeamLevel"]      = nTab["Level"]
            m_CountryWarTeamMesDB[nIndex]["TeamFace"]       = nTab["FaceID"]
            m_CountryWarTeamMesDB[nIndex]["TeamRes"]        = nTab["nTempID"]
            m_CountryWarTeamMesDB[nIndex]["TeamName"]       = nTab["Name"]
            m_CountryWarTeamMesDB[nIndex]["TeamBloodMax"]   = nTab["BloodMax"]
            m_CountryWarTeamMesDB[nIndex]["TeamBloodCur"]   = nTab["BloodCur"]
            m_CountryWarTeamMesDB[nIndex]["TeamID"]         = nTab["TeamID"]
            m_CountryWarTeamMesDB[nIndex]["TeamState"]      = nTab["TeamState"]
            m_CountryWarTeamMesDB[nIndex]["TeamCity"]       = nTab["City"]
            m_CountryWarTeamMesDB[nIndex]["TeamTarCity"]    = nTab["TarCity"]
            m_CountryWarTeamMesDB[nIndex]["TeamBloodWCity"] = nTab["BloodTarCity"]  
            m_CountryWarTeamMesDB[nIndex]["CellTime"]       = nTab["CellTime"]
            m_CountryWarTeamMesDB[nIndex]["TeamMistyIndex"] = nTab["TeamMistyIndex"]    
        end
    else
        print("Insert Team Data Failed")
    end
    print("Insert")
end

function DelTeamMess( nIndex )
    --print("Del")
    --print(m_CountryWarTeamMesDB[nIndex], nIndex)
    --Pause()
    if m_CountryWarTeamMesDB[nIndex] ~= nil and nIndex ~= nil then
        print("nIndex = "..nIndex)
        --printTab(m_CountryWarTeamMesDB)
        --Pause()
        m_CountryWarTeamMesDB[nIndex] = nil
        --printTab(m_CountryWarTeamMesDB)
        --Pause()
    else
        print("Del Team Data Failed")
    end
end

function UpdateTeamMess( nTab, nIndex )
    if m_CountryWarTeamMesDB[nIndex] ~= nil and nTab ~= nil then
        for key,value in pairs(nTab) do
            m_CountryWarTeamMesDB[nIndex]["TeamLevel"]      = nTab["Level"]
            m_CountryWarTeamMesDB[nIndex]["TeamFace"]       = nTab["FaceID"]
            m_CountryWarTeamMesDB[nIndex]["TeamRes"]        = nTab["nTempID"]
            m_CountryWarTeamMesDB[nIndex]["TeamName"]       = nTab["Name"]
            m_CountryWarTeamMesDB[nIndex]["TeamBloodMax"]   = nTab["BloodMax"]
            m_CountryWarTeamMesDB[nIndex]["TeamBloodCur"]   = nTab["BloodCur"]
            m_CountryWarTeamMesDB[nIndex]["TeamState"]      = nTab["TeamState"]
            m_CountryWarTeamMesDB[nIndex]["TeamCity"]       = nTab["City"]
            m_CountryWarTeamMesDB[nIndex]["TeamTarCity"]    = nTab["TarCity"]
            m_CountryWarTeamMesDB[nIndex]["TeamBloodWCity"] = nTab["BloodTarCity"]
            m_CountryWarTeamMesDB[nIndex]["CellTime"]       = nTab["CellTime"]
            m_CountryWarTeamMesDB[nIndex]["TeamMistyIndex"] = nTab["TeamMistyIndex"]
        end
    else
        print("Update Team Data Failed")          
    end
end

function UpdateAttr( nIndex, nAttrID, nValue )
    if m_CountryWarTeamMesDB[nIndex] ~= nil then 
        if nAttrID == TEAM_ATTR.Blood then
            m_CountryWarTeamMesDB[nIndex]["TeamBloodCur"] = nValue
        end
    end
end

function UpdateTeamState( nIndex, nState )
    if m_CountryWarTeamMesDB[nIndex] ~= nil then 
        m_CountryWarTeamMesDB[nIndex]["TeamState"] = nState
    end
end


-- 删除。释放
function release()
    m_CountryWarTeamMesDB = nil
    package.loaded["server_CountryWarTeamMesDB"] = nil
end

