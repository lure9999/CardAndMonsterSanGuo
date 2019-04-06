module("Packet_GetCountryPattern", package.seeall)

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
		require "Script/serverDB/server_CountryPattern"
		server_CountryPattern.SetTableBuffer(PacketData)
		--if CommonData.g_IsUnlockCountryWar == true then
		require "Script/Main/CountryWar/CountryWarRaderLayer"
		CountryWarRaderLayer.UpdateSanGuoPattern()
		--else
			--print("国战场景未开启，不执行刷新世界格局协议,记录数据")		
		--end
			
	else
		print("animal buff list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_WAR_COUNTRY_STATE,Server_Excute)