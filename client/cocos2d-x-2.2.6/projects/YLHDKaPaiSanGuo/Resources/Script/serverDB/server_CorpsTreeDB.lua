module("server_CorpsTreeDB",package.seeall)

local m_tableCorpsGetInfo = {}
local nMoneyType = nil
local nMoneyNum = nil
local nRewardID = nil
local nVIPNum   = 0
function SetTableBuffer( buffer )
	m_tableCorpsGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	m_tableCorpsGetInfo.nMoneyType = pNetStream:Read()
	m_tableCorpsGetInfo.nMoneyNum = pNetStream:Read()
	m_tableCorpsGetInfo.nVIPNum   = pNetStream:Read()
	m_tableCorpsGetInfo.nRewardID = pNetStream:Read()

	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tableCorpsGetInfo)
end

function getCorpsData( keyData )
	return m_tableCorpsGetInfo[keyData]
end

function release()
	m_tableCorpsGetInfo = nil
	package.loaded["server_CorpsTreeDB"] = nil
end