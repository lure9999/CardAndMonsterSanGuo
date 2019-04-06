module("Packet_GetCountryDelTeam", package.seeall)

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local nIndex = pNetStream:Read()

	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			require "Script/Main/CountryWar/CountryWarScene"
			CountryWarScene.DelTeamerInfo(tonumber(nIndex))	
		else
			print("国战场景未开启，不执行DelTeamerInfo协议")			
		end
	else
		print("team stop list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_CREATE_MERCENARY_DATA,Server_Excute)