--获得攻城战界面的信息解析 celina

local cjson = require "json"

module("server_getCountryWarInfo", package.seeall)

local m_tableWarCityDB = {}
local m_tableWarBufferDB = {} --存储缓存数据
local statyTime = 0
local nCityID = 0
local nWin  = 0
local nTotalTime = 0
local Server_Cmd = {
	nStatus= 1,
	Info01 = 2,
}
--local timeDataNew = nil

local Info01_Cmd = {nImageID = 1, nCountry = 2, strName = 3,strCH = 4,nLv = 5,nTotalHP = 6,nCurHP = 7,
					nHPConsume=8,nNum=9}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableWarCityDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local nStatus = pNetStream:Read()
	local nType = pNetStream:Read()
	nCityID = pNetStream:Read()
    local list = pNetStream:Read()
	nWin = pNetStream:Read()
	statyTime = pNetStream:Read()
	nTotalTime = pNetStream:Read()
    for key, value in pairs(list) do
        m_tableWarCityDB[key] = {}
		m_tableWarCityDB[key]["nImageID"] = value[Info01_Cmd.nImageID]
        m_tableWarCityDB[key]["nCountry"] = value[Info01_Cmd.nCountry]
        m_tableWarCityDB[key]["strName"] = value[Info01_Cmd.strName]
		m_tableWarCityDB[key]["strCH"] = value[Info01_Cmd.strCH]
		m_tableWarCityDB[key]["nLv"] = value[Info01_Cmd.nLv]
		m_tableWarCityDB[key]["nTotalHP"] = value[Info01_Cmd.nTotalHP]
		m_tableWarCityDB[key]["nCurHP"] = value[Info01_Cmd.nCurHP]
		m_tableWarCityDB[key]["nHPConsume"] = value[Info01_Cmd.nHPConsume]
		m_tableWarCityDB[key]["nNum"] = value[Info01_Cmd.nNum]
    end
	local getBufferDB = {}
	getBufferDB.nWin = nWin
	getBufferDB.statyTime = statyTime
	getBufferDB.fightDB = m_tableWarCityDB
	table.insert(m_tableWarBufferDB,getBufferDB)
	
	--记录一个时间
	--timeDataNew = UnitTime.GetCurTime()
	--[[print("00")
	printTab(m_tableWarBufferDB)]]--
	--Pause()
	--AtkCityScene.UpdateListInfo() 
	
    pNetStream = nil
end

--[[function GetNewDataTime()
	return timeDataNew
end]]--
--获得城市的ID
function GetCityID()
	return nCityID
end
--获得时间
function GetStatyTime()
	return m_tableWarBufferDB[1].statyTime

end
function GetTotalTime()
	return nTotalTime
end
function GetCityWarResult()
	return m_tableWarBufferDB[1].nWin
end
-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableWarCityDB)
end

function GetBufferTableDB()
	if m_tableWarBufferDB[1] == nil then
		return nil
	end
	return m_tableWarBufferDB[1].fightDB
end
function DeleteBufferTableDB()
	table.remove(m_tableWarBufferDB,1)
end
function GetAllBufferTableDB()
	return m_tableWarBufferDB
end
function DeleteBufferData()
	for key,value in pairs(m_tableWarBufferDB) do 
		value = nil 
	end
	m_tableWarBufferDB = {}
end
-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableWarCityDB = tTable
end

-- 删除。释放
function release()
    m_tableWarCityDB = nil
    package.loaded["server_getCountryWarInfo"] = nil
end