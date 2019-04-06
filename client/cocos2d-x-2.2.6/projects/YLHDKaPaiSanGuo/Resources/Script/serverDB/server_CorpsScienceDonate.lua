module("server_CorpsScienceDonate",package.seeall)

local m_tableScienceDonate = {}
local nResult = nil

function SetTableBuffer( buffer )
	m_tableScienceDonate = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()  
	nResult = pNetStream:Read()
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tableScienceDonate)
end

function getCorpsData( keyData )
	return m_tableScienceDonate[keyData]
end

function GetResultData(  )
	return nResult
end

function release()
	m_tableScienceDonate = nil
	package.loaded["server_CorpsScienceDonate"] = nil
end