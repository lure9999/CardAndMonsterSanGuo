module("Packet_CountryWarUnlockCell", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

function CreatPacket( nTeamIndex )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_RELEASE_PRISON)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nTeamIndex)

	return pNetStream:GetPacket()
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local index  = pNetStream:Read()
	local res    = pNetStream:Read()

	if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(index, res)
			m_funSuccessCallBack = nil
		end
	else
		print("error to unlock cell")
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_RELEASE_PRISON_RESULT,Server_Excute)