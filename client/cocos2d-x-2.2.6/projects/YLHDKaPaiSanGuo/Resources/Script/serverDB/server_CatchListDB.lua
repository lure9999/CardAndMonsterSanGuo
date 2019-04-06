module("server_CatchListDB",package.seeall)

local m_tableInfo = {}

function SetTableBuffer( buffer )
	m_tableInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list   = pNetStream:Read()
	for key,value in pairs(list) do
		m_tableInfo[key] = {}
		m_tableInfo[key]["time"] = value[1]
		m_tableInfo[key]["name"] = value[2]
	end

end

function getMainData(keyData)
	return m_tableInfo[keyData]
end

function GetCopyTable(  )
    return copyTab(m_tableInfo)
end

function release()
	m_tableInfo = nil
	package.loaded["server_CatchListDB"] = nil
end