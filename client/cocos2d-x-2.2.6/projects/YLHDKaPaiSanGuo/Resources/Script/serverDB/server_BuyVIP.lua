module("server_BuyVIP",package.seeall)

local m_tableInfo = {}
local nVIPType = 0

function SetTableBuffer( buffer )
	m_tableInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	nVIPType     = pNetStream:Read()

end

function GetVIPType(  )
	return nVIPType
end


function GetCopyTable(  )
    return copyTab(m_tableInfo)
end

function release()
	m_tableInfo = nil
	package.loaded["server_BuyVIP"] = nil
end