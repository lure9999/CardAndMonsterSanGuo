module("server_CorpsDynamicDB",package.seeall)

local m_tableMemberDB = {}

local Server_Cmd = {
	eventID       	 = 1,
	playerName       = 2,
	eventParam1       = 3,
	eventParam2       = 4,
	eventParam3       = 5,
	time             = 6,
}

function SetTableBuffer( buffer )
	m_tableMemberDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	for key,value in pairs(list) do
		m_tableMemberDB[key] = {}
		m_tableMemberDB[key]["eventID"] = value[Server_Cmd.eventID]
		m_tableMemberDB[key]["playerName"] = value[Server_Cmd.playerName]
		m_tableMemberDB[key]["eventParam1"]  = value[Server_Cmd.eventParam1]
		m_tableMemberDB[key]["eventParam2"]  = value[Server_Cmd.eventParam2]
		m_tableMemberDB[key]["eventParam3"] = value[Server_Cmd.eventParam3]
		m_tableMemberDB[key]["time"] = value[Server_Cmd.time]
	end
	pNetStream = nil
end

function GetCopyTable()
	--[[if m_tableMemberDB == nil then
		return nil
	else
		return copyTab(m_tableMemberDB)
	end]]--
	return copyTab(m_tableMemberDB)
end

function getCorpsData( nkeyData )
	return m_tableMemberDB[nkeyData]
end

function SetTab( tTable )
	m_tableMemberDB = tTable
end

function release()
	m_tableMemberDB = nil
	package.loaded["server_CorpsDynamicDB"] = nil
end