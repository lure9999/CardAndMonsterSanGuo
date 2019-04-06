module("server_UsePrisonItem",package.seeall)

local m_tabGetInfo = {}
local nType = nil
local nNum = nil
function SetTableBuffer( buffer )
	m_tabGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	m_tabGetInfo["nType"] = pNetStream:Read()
	m_tabGetInfo["nNum"]  = pNetStream:Read()
	m_tabGetInfo["ba_percent"]  = pNetStream:Read()
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabGetInfo)
end

function getCorpsData( keyData )
	return m_tabGetInfo[keyData]
end

function release()
	m_tabGetInfo = nil
	package.loaded["server_UsePrisonItem"] = nil
end