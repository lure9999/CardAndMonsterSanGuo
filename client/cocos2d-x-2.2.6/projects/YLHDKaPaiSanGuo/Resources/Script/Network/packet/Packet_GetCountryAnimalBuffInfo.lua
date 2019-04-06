module("Packet_GetCountryAnimalBuffInfo", package.seeall)

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local Server_Cmd = {
    TeamIndex                = 1, 
    TeamBuff                 = 2,
}

local Server_Buff = {
    AnimalIndex                = 1, 
    AnimalBuffNum              = 2,
}

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()

    --print(PacketData)
    --Pause()     

	if status == 1 then
		local list = pNetStream:Read()

		local pTeamCount = table.getn(list)

		require "Script/serverDB/server_CountryAnimalBuffDB"
		server_CountryAnimalBuffDB.SetTableBuffer(PacketData)
		if CommonData.g_IsUnlockCountryWar == true then

			if pTeamCount == 1 then
				--表示在线的单次更新
				print("单次更新灵兽buff")

				local pTeamDB = list[1]

				local pTeamIdx = pTeamDB[Server_Cmd.TeamIndex]

		        local pBuffDB = pTeamDB[Server_Cmd.TeamBuff]
		        local pBuffCount = table.getn(pBuffDB)

		        require "Script/Main/CountryWar/CountryWarRaderLayer"
		        for j=1, pBuffCount do
		            local pAnimalIdx = pBuffDB[j][Server_Buff.AnimalIndex]
		            local pAnimalNum = pBuffDB[j][Server_Buff.AnimalBuffNum]

		            CountryWarRaderLayer.UpdateTeamAnimalBuff(pTeamIdx, pAnimalIdx, pAnimalNum)
		        end	

		    end	
				
		else
			print("国战场景未开启，不执行刷新神兽BUFF协议,记录数据")		
		end
			
	else
		print("animal buff list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_CORPS_MYTHICAL_CREATURES_INFO,Server_Excute)