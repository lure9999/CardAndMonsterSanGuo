module("server_MercenaryInfoDB",package.seeall)

local m_MercenaryInfoDB = {}

local Server_Cmd = {	
	name    	= 1,
	level   	= 2,
	id      	= 3,
	iconID  	= 4,
	power	  	= 5,	
	times     	= 6,
	nColorID 	= 7,
	onlyID      = 8,
}

function SetTableBuffer( buffer )
	m_MercenaryInfoDB = {}

	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
    if list ~= nil then
    	for key,value in pairs(list) do
	    	m_MercenaryInfoDB[key] = {}	    	
	    	m_MercenaryInfoDB[key]["name"] = value[Server_Cmd.name]
	    	m_MercenaryInfoDB[key]["level"] = value[Server_Cmd.level]
	    	m_MercenaryInfoDB[key]["id"] = value[Server_Cmd.id]
	    	m_MercenaryInfoDB[key]["iconID"] = value[Server_Cmd.iconID]
	    	m_MercenaryInfoDB[key]["power"] = value[Server_Cmd.power]
	    	m_MercenaryInfoDB[key]["times"] = value[Server_Cmd.times]
	    	m_MercenaryInfoDB[key]["nColorID"] = value[Server_Cmd.nColorID]
	    	m_MercenaryInfoDB[key]["onlyID"] = value[Server_Cmd.onlyID]
	    end
    end
	pNetStream = nil

end

function GetCopyTable()
	return copyTab(m_MercenaryInfoDB)
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_MercenaryInfoDB = tTable
end

function GetMercenaryTime( index )
	return m_MercenaryInfoDB[index].times
end

function GetMercenaryID( index )
	return m_MercenaryInfoDB[index].id
end

function GetLevel(index)
	return m_MercenaryInfoDB[index].level
end

function release()
	m_MercenaryInfoDB = nil
	package.loaded["server_MercenaryInfoDB"] = nil
end