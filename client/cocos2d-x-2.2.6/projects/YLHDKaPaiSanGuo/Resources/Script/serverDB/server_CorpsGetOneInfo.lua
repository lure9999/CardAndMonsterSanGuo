module("server_CorpsGetOneInfo",package.seeall)

local m_tableCorpsInfoDB = {}

local Server_Cmd = {
	id      	= 1,
	name    	= 2,
	level   	= 3,
	people  = 4,
	needLevel  = 5,	
	flag     = 6,
	country = 7,	
	brief      = 8,
	limitType = 9,
	cur_num = 10,
	is_tag  = 11,

}

function SetTableBuffer( buffer )
	m_tableCorpsInfoDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
    m_tableCorpsInfoDB["id"] = list[Server_Cmd.id]
    m_tableCorpsInfoDB["name"] = list[Server_Cmd.name]
    m_tableCorpsInfoDB["level"] = list[Server_Cmd.level]
    m_tableCorpsInfoDB["people"] = list[Server_Cmd.people]
    m_tableCorpsInfoDB["needLevel"] = list[Server_Cmd.needLevel]
    m_tableCorpsInfoDB["flag"] = list[Server_Cmd.flag]
    m_tableCorpsInfoDB["country"] = list[Server_Cmd.country]
    m_tableCorpsInfoDB["brief"] = list[Server_Cmd.brief]
    m_tableCorpsInfoDB["limitType"] = list[Server_Cmd.limitType]
    m_tableCorpsInfoDB["cur_num"] = list[Server_Cmd.cur_num]
    m_tableCorpsInfoDB["is_tag"] = 2
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
	package.loaded["server_CorpsInfoDB"] = nil
end