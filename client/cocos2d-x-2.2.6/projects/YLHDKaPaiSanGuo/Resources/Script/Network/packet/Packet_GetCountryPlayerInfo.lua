module("Packet_GetCountryPlayerInfo", package.seeall)

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
		--修改数据源
		require "Script/serverDB/server_CountryWarPalyerInfoDB"
		server_CountryWarPalyerInfoDB.SetTableBuffer(PacketData)
		--注册国战初始化回调
	    require "Script/Main/CountryWar/CountryWarScene"

	    if CommonData.g_IsUnlockCountryWar == false then
	    	--国战层尚未存在，初始化国战
		    Packet_GetCountryWarAllMes.SetSuccessCallBack(CountryWarScene.Init)

		    Packet_GetCountryWarTeamMes.SetSuccessCallBack(CountryWarScene.InitTeamInfo) 

			Packet_GetCountryWarMistyMes.SetSuccessCallBack(CountryWarScene.InitMisty)

		else
			--国战层已经解锁，则做同步更新
			Packet_GetCountryWarAllMes.SetSuccessCallBack(CountryWarScene.CountryWarSyncUpdateByAllMess)

			Packet_GetCountryWarTeamMes.SetSuccessCallBack(CountryWarScene.CountryWarSyncUpdateByTeamMess)

			Packet_GetCountryWarMistyMes.SetSuccessCallBack(CountryWarScene.CountryWarSyncUpdateByMistyMess)
			
		end

	else
		print("country war player info error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_PLAYER_DATA_RETURN,Server_Excute)