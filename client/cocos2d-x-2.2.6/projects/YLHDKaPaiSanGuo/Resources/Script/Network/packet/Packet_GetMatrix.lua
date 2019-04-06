module("Packet_GetMatrix", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GETMATRIX)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	print("Packet_GetMatrix")
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	pNetStream = nil
	
	-- print("Packet_GetMatrix")

	if status == 1 then
		
		require "Script/serverDB/server_matrixDB"
		server_matrixDB.SetTableBuffer(PacketData)

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(MS_C_NET_MSG_ID.MS_C_GETMATRIX_RETURN)
			m_funSuccessCallBack = nil
		end
	else
		
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GETMATRIX_RETURN,Server_Excute)