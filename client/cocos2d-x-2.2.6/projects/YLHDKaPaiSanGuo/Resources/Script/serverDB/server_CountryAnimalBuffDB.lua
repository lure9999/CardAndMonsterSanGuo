-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_CountryAnimalBuffDB", package.seeall)

local m_CountryAnimalBuffDB = {}

local Server_Cmd = {
    TeamIndex                = 1, 
    TeamBuff                 = 2,
}

local Server_Buff = {
    AnimalIndex                = 1, 
    AnimalBuffNum              = 2,
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    --m_CountryAnimalBuffDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()

    local pTeamCount = table.getn(list)

    for i=1, pTeamCount do
        local pTeamDB = list[i]

        local pTeamIdx = pTeamDB[Server_Cmd.TeamIndex]
        --如果表中没有这个队伍的灵兽buff数据则创建一个
        if m_CountryAnimalBuffDB[pTeamIdx] == nil then

            m_CountryAnimalBuffDB[pTeamIdx] = {}

        end

        --判断当前有几个灵兽的buff进行更新
        local pBuffDB = pTeamDB[Server_Cmd.TeamBuff]
        local pBuffCount = table.getn(pBuffDB)

        --对几个buff先进行初始化
        for k=1,5 do
            m_CountryAnimalBuffDB[pTeamIdx][k] = 0
        end

        for j=1, pBuffCount do
            local pAnimalIdx = pBuffDB[j][Server_Buff.AnimalIndex]
            local pAnimalNum = pBuffDB[j][Server_Buff.AnimalBuffNum]

            m_CountryAnimalBuffDB[pTeamIdx][pAnimalIdx] = pAnimalNum
        end

    end

    --printTab(m_CountryAnimalBuffDB)
    --Pause()

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_CountryAnimalBuffDB ~= nil then
        return copyTab(m_CountryAnimalBuffDB)
    else
        print("m_CountryAnimalBuffDB error")
    end
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_CountryAnimalBuffDB = tTable
end

-- 删除。释放
function release()
    m_CountryAnimalBuffDB = nil
    package.loaded["server_CountryAnimalBuffDB"] = nil
end