module("server_ScienceLevelDB",package.seeall)

local m_tableScienceLevelDB = {}

local Server_Cmd = {
	m_nType      	= 1,
	m_nLevel    	= 2,
	m_bValid    	= 3,
	m_time          = 4,
	m_CurAmount     = 5,
	

}

function SetTableBuffer( buffer )
	m_tableScienceLevelDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
    if list ~= nil then
    	for key,value in pairs(list) do
	    	m_tableScienceLevelDB[key] = {}
	    	m_tableScienceLevelDB[key]["m_nType"] = value[Server_Cmd.m_nType]
	    	m_tableScienceLevelDB[key]["m_nLevel"] = value[Server_Cmd.m_nLevel]
	    	m_tableScienceLevelDB[key]["m_bValid"] = value[Server_Cmd.m_bValid]
	    	m_tableScienceLevelDB[key]["m_time"] = value[Server_Cmd.m_time]
	    	m_tableScienceLevelDB[key]["m_CurAmount"] = value[Server_Cmd.m_CurAmount]
	    end
    end
	pNetStream = nil

end

function GetCopyTable()
	return copyTab(m_tableScienceLevelDB)
end

function GetCurAmoutByID( ID )
	local tab = {}
	tab = GetCopyTable()
	if next(tab) == nil then
		return
	else
		for key,value in pairs(tab) do
			if tonumber(ID) == tonumber(value.m_nType) then
				return value.m_CurAmount
			end
		end
	end
end

function RefreshTime( ntime )
	m_tableScienceLevelDB[nType]["m_nType"] = nType
end

function GetCurTimeByID( ID )
	local tab = GetCopyTable()
	if next(tab) == nil then
		return
	else
		for key,value in pairs(tab) do
			if tonumber(ID) == tonumber(value.m_nType) then
				return value.m_time
			end
		end
	end
end

function RefreshTableDataByServer( nType,nLevel )
	if next(m_tableScienceLevelDB) == nil then
		return
	end
	m_tableScienceLevelDB[nType]["m_nType"] = nType
	m_tableScienceLevelDB[nType]["m_nLevel"] = nLevel
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tableScienceLevelDB = tTable
end

function release()
	m_tableScienceLevelDB = nil
	package.loaded["server_ScienceLevelDB"] = nil
end