--获得点击城市攻守方信息 celina

local cjson = require "json"

module("server_getCityFightCountryInfo", package.seeall)

local m_tableFightCountryDB = {}
local Server_Cmd = {
	nStatus= 1,
}

local Info01_Cmd = {nCityState = 1, nCityNum = 2}
-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableFightCountryDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local nStatus = pNetStream:Read()
	local list  = pNetStream:Read()
	for key, value in pairs(list) do
		m_tableFightCountryDB[key] = {}
		for k,v in pairs(value) do 
			m_tableFightCountryDB[key][k] = {}
			m_tableFightCountryDB[key][k]["nCityState"] = v[Info01_Cmd.nCityState]
			m_tableFightCountryDB[key][k]["nCityNum"] = v[Info01_Cmd.nCityNum]
		end
       
    end
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    return copyTab(m_tableFightCountryDB)
end



-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableFightCountryDB = tTable
end

-- 删除。释放
function release()
    m_tableFightCountryDB = nil
    package.loaded["server_getCityFightCountryInfo"] = nil
end