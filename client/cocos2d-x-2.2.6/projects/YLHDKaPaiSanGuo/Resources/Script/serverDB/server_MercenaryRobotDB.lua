--解析佣兵机器人的
module("server_MercenaryRobotDB",package.seeall)

local m_MercenaryRobotInfoDB = {}
local RefreshNum = nil

local Server_Cmd = {
	name    	= 1,
	level   	= 2,
	id      	= 3,
	iconID  	= 4,
	power  		= 5,	
	times     	= 6,
	nColorID 	= 7,
	onlyID      = 8,

}

function SetTableBuffer( buffer )
	m_MercenaryRobotInfoDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	RefreshNum = pNetStream:Read()
	local list = pNetStream:Read()
    if list ~= nil then
    	for key,value in pairs(list) do
	    	m_MercenaryRobotInfoDB[key] = {}    	
	    	m_MercenaryRobotInfoDB[key]["name"] = value[Server_Cmd.name]
	    	m_MercenaryRobotInfoDB[key]["level"] = value[Server_Cmd.level]
	    	m_MercenaryRobotInfoDB[key]["id"] = value[Server_Cmd.id]
	    	m_MercenaryRobotInfoDB[key]["iconID"] = value[Server_Cmd.iconID]
	    	m_MercenaryRobotInfoDB[key]["power"] = value[Server_Cmd.power]
	    	m_MercenaryRobotInfoDB[key]["times"] = value[Server_Cmd.times]
	    	m_MercenaryRobotInfoDB[key]["nColorID"] = value[Server_Cmd.nColorID]
	    	m_MercenaryRobotInfoDB[key]["onlyID"] = value[Server_Cmd.onlyID]
	    end
    end
	pNetStream = nil
end

function GetCopyTable()
	return copyTab(m_MercenaryRobotInfoDB)
end

function GetRefreshNum(  )
	return RefreshNum	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_MercenaryRobotInfoDB = tTable
end

function release()
	m_MercenaryRobotInfoDB = nil
	package.loaded["server_MercenaryRobotDB"] = nil
end