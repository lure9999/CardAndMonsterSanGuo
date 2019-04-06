module("server_RewardGetDB",package.seeall)

m_tabRewardInfo = {}
local Server_Cmd = {
	id		= 1,
	num 	= 2,
	name 	= 3,
}
function SetTableBuffer( buffer )
	m_tabRewardInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	if list ~= nil then
		table.insert(server_RewardGetDB,list)
	end
	for key,value in pairs(list) do
		m_tabRewardInfo[key]["id"] = value[Server_Cmd.userID]
	end
	m_tabRewardInfo.id = list[1]
	m_tabRewardInfo.name = list[2]
	m_tabRewardInfo.flag = list[3]

	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabRewardInfo)
end

function getCorpsData( keyData )
	return m_tabRewardInfo[keyData]
end

function release()
	m_tabRewardInfo = nil
	package.loaded["server_RewardGetDB"] = nil
end