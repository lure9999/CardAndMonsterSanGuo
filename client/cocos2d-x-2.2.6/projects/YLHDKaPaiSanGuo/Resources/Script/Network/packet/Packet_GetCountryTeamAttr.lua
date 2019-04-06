module("Packet_GetCountryTeamAttr", package.seeall)

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
	local nAttr  = pNetStream:Read()
	local nValue = pNetStream:Read()

	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			--更新属性UI
			require "Script/Main/CountryWar/CountryUILayer"
			CountryUILayer.UpdateTeamAttr(tonumber(nIndex), tonumber(nAttr), tonumber(nValue))
			--更新佣兵数据
			require "Script/serverDB/server_CountryWarTeamMesDB"
			server_CountryWarTeamMesDB.UpdateAttr(tonumber(nIndex), tonumber(nAttr), tonumber(nValue))
		else
			print("国战场景未开启，不执行UpdateTeamAttr协议")			
		end
	else
		print("team stop list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_CORPS_PARAM_UPDATE,Server_Excute)