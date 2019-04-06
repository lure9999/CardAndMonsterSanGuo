module("server_PrisonDB",package.seeall)

m_tabPrisonDB = {}
local Server_Cmd = {
	id		= 1,
	num 	= 2,
	name 	= 3,
}
function SetTableBuffer( buffer )
	m_tabPrisonDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	m_tabPrisonDB.id = list[1]
	m_tabPrisonDB.name = list[2]
	m_tabPrisonDB.flag = list[3]

	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabPrisonDB)
end

function getCorpsData( keyData )
	return m_tabPrisonDB[keyData]
end

function release()
	m_tabPrisonDB = nil
	package.loaded["server_PrisonDB"] = nil
end