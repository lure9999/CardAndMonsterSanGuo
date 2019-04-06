module("server_CorpsGetListDB",package.seeall)
require "Script/Main/Corps/CorpsEnumType"

local m_tableCorpsInfoDB = {}

local Server_Cmd = {
	id      	= 1,
	name    	= 2,
	level   	= 3,
	people  	= 4,
	needLevel  	= 5,	
	flag     	= 6,
	country 	= 7,	
	brief      	= 8,
	limitType   = 9,
	cur_num     = 10,
	is_tag     = 11,

}

function SetTableBuffer( buffer )
	m_tableCorpsInfoDB = {}

	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
    if list ~= nil then
    	for key,value in pairs(list) do
	    	m_tableCorpsInfoDB[key] = {}
	    	m_tableCorpsInfoDB[key]["id"] = value[Server_Cmd.id]
	    	m_tableCorpsInfoDB[key]["name"] = value[Server_Cmd.name]
	    	m_tableCorpsInfoDB[key]["level"] = value[Server_Cmd.level]
	    	m_tableCorpsInfoDB[key]["people"] = value[Server_Cmd.people]
	    	m_tableCorpsInfoDB[key]["needLevel"] = value[Server_Cmd.needLevel]
	    	m_tableCorpsInfoDB[key]["flag"] = value[Server_Cmd.flag]
	    	m_tableCorpsInfoDB[key]["country"] = value[Server_Cmd.country]
	    	m_tableCorpsInfoDB[key]["brief"] = value[Server_Cmd.brief]
	    	m_tableCorpsInfoDB[key]["limitType"] = value[Server_Cmd.limitType]
	    	m_tableCorpsInfoDB[key]["cur_num"] = value[Server_Cmd.cur_num]
	    	m_tableCorpsInfoDB[key]["is_tag"] = 0
	    end
    end
	pNetStream = nil

end

function GetCopyTable()
	--[[if m_tableCorpsInfoDB == nil then
		return nil
	else
		return copyTab(m_tableCorpsInfoDB)
	end]]--
	return copyTab(m_tableCorpsInfoDB)
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tableCorpsInfoDB = tTable
end

function release()
	m_tableCorpsInfoDB = nil
	package.loaded["server_CorpsGetListDB"] = nil
end


