module("Packet_GetCountryChangeTeamState", package.seeall)

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local Server_Cmd = {
	TeamID 		= 1,
	TeamState   = 2,
}

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local list = pNetStream:Read()

	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			print("Packet_GetCountryChangeTeamState")
			local nTeamID = list[Server_Cmd.TeamID]
			local nTeamState = list[Server_Cmd.TeamState]
			require "Script/Main/CountryWar/CountryWarEventManager"
			CountryWarEventManager.PlayerChangeState(nTeamID, nTeamState)
		else
			print("国战场景未开启，不执行ChangeTeamState协议")
		end
	else
		print("team state change list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_CORPS_STATE_RETURN,Server_Excute)