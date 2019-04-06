module("server_AniBHMRobot",package.seeall)

local m_tabRobot = {}
local Server_Cmd1 = {
	faceID       	= 1,
	level        	= 2,
	starLevel       = 3,
}

function SetTableBuffer( buffer )
	m_tabRobot = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 	= pNetStream:Read()	
	local list = pNetStream:Read()
	for key,value in pairs(list) do
		m_tabRobot[key] = {}
		m_tabRobot[key]["faceID"] = value[Server_Cmd1.faceID]
		m_tabRobot[key]["level"] = value[Server_Cmd1.level]
		m_tabRobot[key]["starLevel"]  = value[Server_Cmd1.starLevel]
	end
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabRobot)	
end

function GetCurPerByServer(  )
	return cur_per
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabRobot = tTable
end

function release()
	m_tabRobot = nil
	package.loaded["server_AniBHMRobot"] = nil
end