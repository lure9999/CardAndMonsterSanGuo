module("Packet_CountryWarLoadFinish", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

--nType 1= 点击国战时的发送 2 = 确定国战可以进入加载完资源发送
function CreatPacket(nType)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_LOAD_FINISH)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack( tonumber(errorCode) )
		end
	end
	pNetStream = nil
end
PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_LOGIN_BS_UP,Server_Excute)