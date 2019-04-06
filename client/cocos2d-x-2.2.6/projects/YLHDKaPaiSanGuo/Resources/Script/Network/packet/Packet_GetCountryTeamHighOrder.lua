module("Packet_GetCountryTeamHighOrder", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local Server_Cmd = {
	TeamIndex 	 = 1,
	TarBloodCity = 2, 		-- 血战/坚守的目标城市
}

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local list   = pNetStream:Read()
	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			require "Script/Main/CountryWar/CountryWarEventManager"
			CountryWarEventManager.CountryWarCityBloodWar(list[Server_Cmd.TeamIndex], list[Server_Cmd.TarBloodCity])
		else
			print("国战场景未开启，不执行TeamHighOrder")
		end
	else
		print("server blood war error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_CORPS_BLOOD_RETURN,Server_Excute)