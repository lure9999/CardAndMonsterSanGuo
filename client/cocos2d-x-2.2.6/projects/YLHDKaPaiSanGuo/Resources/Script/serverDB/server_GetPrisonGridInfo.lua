module("server_GetPrisonGridInfo",package.seeall)

local m_tabGetInfo = {}
local totalNum = 0
local Server_cmd = {
	nIndex  = 1,
	is_open = 2,
	cur_num = 3,
	is_get  = 4,
}
function SetTableBuffer( buffer )
	m_tabGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	totalNum     = pNetStream:Read()
	local list = pNetStream:Read()
	for key,value in pairs(list) do
		m_tabGetInfo[key] = {}
		m_tabGetInfo[key]["nIndex"]  = value[Server_cmd.nIndex]
		m_tabGetInfo[key]["is_open"] = value[Server_cmd.is_open]
		m_tabGetInfo[key]["cur_num"] = value[Server_cmd.cur_num]
		m_tabGetInfo[key]["is_get"] = value[Server_cmd.is_get]
	end
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabGetInfo)
end

function GetTotalNum(  )
	return totalNum
end

function getCorpsData( keyData )
	return m_tabGetInfo[keyData]
end

function release()
	m_tabGetInfo = nil
	package.loaded["server_GetPrisonGridInfo"] = nil
end