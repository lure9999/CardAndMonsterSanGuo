module("server_CorpsDB",package.seeall)

local m_tableCorpsDB = {}

local Server_Corps = {
	status  = 1,
}

function SetTableBuffer( buffer)
	m_tableCorpsDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()

	pNetStream = nil
end

function GetCopyTable()
	
	return copyTab(m_tableCorpsDB)
end

function SetTable( tTable )
	m_tableCorpsDB = tTable
end

--刪除,释放
function release(  )
	m_tableCorpsDB = nil
	package.loaded["server_CorpsDB"] = nil
end