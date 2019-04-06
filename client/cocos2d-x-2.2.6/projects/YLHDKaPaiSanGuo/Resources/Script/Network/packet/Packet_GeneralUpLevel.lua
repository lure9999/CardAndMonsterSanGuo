module("Packet_GeneralUpLevel", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket(nGrid, nTimes)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_UPLVGENERAL)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	pNetStream:Write(nTimes)

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
	local list = pNetStream:Read()
	pNetStream = nil
	
	-- print("Packet_GeneralUpLevel")
	-- print(PacketData)
	if status == 1 then

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_UPLVGENERAL_RETURN,Server_Excute)