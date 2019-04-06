module("Packet_UpdateAttr",package.seeall)

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status  = pNetStream:Read()	
	local shopType = pNetStream:Read()
	local is_open = pNetStream:Read()

	if status == 1 then	
		require "Script/serverDB/server_dValueDB"
		server_dValueDB.SetTableBuffer(PacketData)
	else
		NetWorkLoadingLayer.loadingHideNow()
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_UPDATE_ATTR,Server_Excute)