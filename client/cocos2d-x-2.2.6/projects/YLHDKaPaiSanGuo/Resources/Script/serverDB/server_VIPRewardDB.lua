module("server_VIPRewardDB",package.seeall)

local m_VIPRewardDB = {}

local Server_Cmd = {
	id      	= 1,
	name    	= 2,
	level   	= 3,
	people  = 4,
	needLevel  = 5,	
	flag     = 6,
	country = 7,	
	brief      = 8,
	limitType  = 9,

}

function SetTableBuffer( buffer )
	m_VIPRewardDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	nPageNum = pNetStream:Read()
	nTotalPage = pNetStream:Read()
	local list = pNetStream:Read()
    for key,value in pairs(list) do
    	m_VIPRewardDB[key] = {}
    	m_VIPRewardDB[key]["id"] = value[Server_Cmd.id]
    	m_VIPRewardDB[key]["name"] = value[Server_Cmd.name]
    	m_VIPRewardDB[key]["level"] = value[Server_Cmd.level]
    	m_VIPRewardDB[key]["people"] = value[Server_Cmd.people]
    	m_VIPRewardDB[key]["needLevel"] = value[Server_Cmd.needLevel]
    	m_VIPRewardDB[key]["flag"] = value[Server_Cmd.flag]
    	m_VIPRewardDB[key]["country"] = value[Server_Cmd.country]
    	m_VIPRewardDB[key]["brief"] = value[Server_Cmd.brief]
    	m_VIPRewardDB[key]["limitType"] = value[Server_Cmd.limitType]
    end
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_VIPRewardDB)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_VIPRewardDB = tTable
end

function release()
	m_VIPRewardDB = nil
	package.loaded["server_VIPRewardDB"] = nil
end