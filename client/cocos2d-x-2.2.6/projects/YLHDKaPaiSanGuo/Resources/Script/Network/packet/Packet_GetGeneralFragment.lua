module("Packet_GetGeneralFragment", package.seeall)
--local cjson	= require "json"
function CreatPacket( )
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_GS_NET_MSG_ID.C_MS_GETGENERALFRAGMENT)
	pNetStream:Write(0)
	pNetStream:Write(0)

	return pNetStream:GetPacket()
end

local Return_Cmd = {
	status			= nil,
	list 			= nil,
}

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.list = pNetStream:Read()
	pNetStream = nil
		   
	-- print("Packet_GetGeneralFragment")

	if Return_Cmd.status == 1 then
	else
	end
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,C_MS_NET_MSG_ID.C_MS_GETGENERALFRAGMENT,Server_Excute)