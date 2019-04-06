module("server_CorpsMessHallDB",package.seeall)

local m_tableMessDB = {}

function SetTableBuffer( buffer )
	m_tableMessDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()

	pNetStream = nil
end

function GetCopyTable(  )
	return copyTab(m_tableMessDB)
end

function release(  )
	m_tableMessDB = nil
	package.loaded["server_CorpsMessHallDB"] = nil
end