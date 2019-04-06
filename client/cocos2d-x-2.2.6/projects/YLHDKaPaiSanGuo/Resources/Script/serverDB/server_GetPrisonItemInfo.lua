module("server_GetPrisonItemInfo",package.seeall)

local m_tabGetInfo = {}
local nEyeValidNum = nil
local nHandValidNum  = nil
local nEyeValidBar = nil
function SetTableBuffer( buffer )
	m_tabGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	m_tabGetInfo["nEyeValidNum"] = pNetStream:Read()
	m_tabGetInfo["nHandValidNum"] = pNetStream:Read()
	m_tabGetInfo["nEyeValidBar"] = pNetStream:Read()
	m_tabGetInfo["nEyeaddBar"] = pNetStream:Read()
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
	package.loaded["server_GetPrisonItemInfo"] = nil
end