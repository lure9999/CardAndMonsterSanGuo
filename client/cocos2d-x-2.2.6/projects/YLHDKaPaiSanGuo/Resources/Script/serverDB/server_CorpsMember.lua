module("server_CorpsMember",package.seeall)

local m_tableMemberDB = {}

local Server_Cmd = {
	userID       = 1,
	faceID       = 2,
	level        = 3,
	power        = 4,
	position     = 5,
	lastTime     = 6,
	seven        = 7,
	totalContibute = 8,
	name         = 9,
}

function SetTableBuffer( buffer )
	m_tableMemberDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	for key,value in pairs(list) do
		m_tableMemberDB[key] = {}
		m_tableMemberDB[key]["userID"] = value[Server_Cmd.userID]
		m_tableMemberDB[key]["faceID"] = value[Server_Cmd.faceID]
		m_tableMemberDB[key]["level"]  = value[Server_Cmd.level]
		m_tableMemberDB[key]["power"]  = value[Server_Cmd.power]
		m_tableMemberDB[key]["position"] = value[Server_Cmd.position]
		m_tableMemberDB[key]["lastTime"] = value[Server_Cmd.lastTime]
		m_tableMemberDB[key]["seven"]  = value[Server_Cmd.seven]
		m_tableMemberDB[key]["totalContibute"]  = value[Server_Cmd.seven]
		m_tableMemberDB[key]["name"]   = value[Server_Cmd.name]
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
	package.loaded["server_CorpsMember"] = nil
end