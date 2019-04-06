module("Packet_GetCountryExpeditionMove", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status 		= pNetStream:Read()
	local nGrid  		= pNetStream:Read()
	local nTarCityID    = pNetStream:Read()
	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			CountryWarScene.MoveExpeSuchAs( tonumber(nGrid), tonumber(nTarCityID) )
		else
			print("国战场景未开启，不执行远征军移动")
		end
	else
		print("server blood war error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_EXPEDITION_MOVE,Server_Excute)