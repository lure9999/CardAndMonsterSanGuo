module("server_CorpsSettingDB",package.seeall)

local m_tableCorpsInfoDB = {}

local Server_Cmd = {
	id      	= 1,
	name    	= 2,

}

function SetTableBuffer( buffer )
	m_tableCorpsInfoDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local alterID = pNetStream:Read()
	local contetnt = pNetStream:Read()
	m_tableCorpsInfoDB["alterID"] = alterID
	m_tableCorpsInfoDB["contetnt"] = contetnt
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tableCorpsInfoDB)	
end

function GetCorpsID( key )
	return m_tableCorpsInfoDB[key]["id"]
end

function GetCountryID( key )
	return m_tableCorpsInfoDB[key]["flag"]
end

function GetCorpsName( key )
	return m_tableCorpsInfoDB[key]["name"]
end
--设置表数据，为本地使用
function SetTable( tTable )
	m_tableCorpsInfoDB = tTable
end

function release()
	m_tableCorpsInfoDB = nil
	package.loaded["server_CorpsSettingDB"] = nil
end