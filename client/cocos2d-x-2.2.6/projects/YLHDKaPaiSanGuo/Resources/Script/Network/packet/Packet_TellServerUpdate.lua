
--告诉服务器可以更新 celina


module("Packet_TellServerUpdate", package.seeall)


function CreatPacket()
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_REQUEST_DATA)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	return pNetStream:GetPacket()
end