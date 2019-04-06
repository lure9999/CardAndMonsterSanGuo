module("Packet_GetCountryTeamLife", package.seeall)

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

--解析包逻辑
function Server_Excute( PacketData )
	--print(PacketData)
	--Pause()

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local Index_1 = pNetStream:Read() 			-- -1=无佣兵 0=未过期 1=已过期
	local Index_2 = pNetStream:Read()
	local Index_3 = pNetStream:Read()

	if status == 1 then
		require "Script/serverDB/server_CountryWarTeamLifeDB"
		if CommonData.g_IsUnlockCountryWar == true then
			server_CountryWarTeamLifeDB.SetTableBuffer(PacketData)
			require "Script/Main/CountryWar/CountryWarEventManager"
			require "Script/Main/CountryWar/CountryUILayer"

			if tonumber(Index_1) == 1 then
				CountryWarEventManager.PlayerChangeLife(1, false)
				CountryUILayer.UpdateTeamLifeUI(1,false)
			elseif tonumber(Index_1) == 0 then
				CountryWarEventManager.PlayerChangeLife(1, true)
				CountryUILayer.UpdateTeamLifeUI(1,true)
			end

			if tonumber(Index_2) == 1 then
				CountryWarEventManager.PlayerChangeLife(2, false)
				CountryUILayer.UpdateTeamLifeUI(2,false)
			elseif tonumber(Index_2) == 0 then
				CountryWarEventManager.PlayerChangeLife(2, true)
				CountryUILayer.UpdateTeamLifeUI(2,true)
			end

			if tonumber(Index_3) == 1 then
				CountryWarEventManager.PlayerChangeLife(3, false)
				CountryUILayer.UpdateTeamLifeUI(3,false)
			elseif tonumber(Index_3) == 0 then
				CountryWarEventManager.PlayerChangeLife(3, true)
				CountryUILayer.UpdateTeamLifeUI(3,true)
			end		
		else
			print("国战场景未开启，不执行刷新佣兵生命周期协议,记录数据")
			server_CountryWarTeamLifeDB.SetTableBuffer(PacketData)			
		end
	else
		print("team life list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_MERCENARY_STATE,Server_Excute)