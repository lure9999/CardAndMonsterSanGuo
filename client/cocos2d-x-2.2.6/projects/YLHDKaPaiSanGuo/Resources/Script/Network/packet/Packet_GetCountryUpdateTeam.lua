module("Packet_GetCountryUpdateTeam", package.seeall)

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	local pTeamInfo = list[1]

	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			require "Script/Main/CountryWar/CountryWarScene"
			CountryWarScene.UpdateTeamerInfo(pTeamInfo)	
		else
			print("国战场景未开启，不执行UpdateTeam协议")			
		end
	else
		print("team stop list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_UPDATE_CORPS_DATA,Server_Excute)