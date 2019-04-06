module("Packet_UseEquip", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	EquipID		= 4,
	TmpID		= 5,
	Position	= 6,
	GeneralUUID	= 7,
}

function CreatPacket( )
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_GS_NET_MSG_ID.C_MS_USEEQUIP)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(22)
	pNetStream:Write(33)
	pNetStream:Write(33)

	return pNetStream:GetPacket()
end

local Return_Cmd = {
	status			= nil,
}

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	--print(PacketData)
	--Pause()
	Return_Cmd.status = pNetStream:Read()
	pNetStream = nil
	
	if Return_Cmd.status == 1 then
		
	else
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,C_MS_NET_MSG_ID.C_MS_USEEQUIP,Server_Excute)