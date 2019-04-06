--获得可突进撤退的列表 celina

local cjson = require "json"

module("server_getWarTCDB", package.seeall)

local m_tableWarTCDB = {}
local Server_Cmd = {
	nStatus= 1,
}

local Info01_Cmd = {nCityState = 1, nCityNum = 2}
-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableWarTCDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local nStatus = pNetStream:Read()
	local list = pNetStream:Read()
	for key, value in pairs(list) do
		m_tableWarTCDB[key] = {}
		m_tableWarTCDB[key]["Type"] = value[1]
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    return copyTab(m_tableWarTCDB)
end



-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableWarTCDB = tTable
end

-- 删除。释放
function release()
    m_tableWarTCDB = nil
    package.loaded["server_getWarTCDB"] = nil
end