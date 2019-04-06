module("Packet_GetCountryTeamOrder", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()

	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			--print("Packet_GetCountryTeamOrder 可以移动")
			require "Script/serverDB/server_CountryWarTeamOrderDB"
			server_CountryWarTeamOrderDB.SetTableBuffer(PacketData)
		else
			print("国战场景未开启，不执行TeamOrder协议")
		end
	else
		print("team stop list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_COPRS_STOP,Server_Excute)