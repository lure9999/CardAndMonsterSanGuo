--获得夺宝的结果 celina

module("Packet_OpenDobkBox", package.seeall)
--local cjson	= require "json"



local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	old			= 4,
	new			= 5,
}

local m_funSuccessCallBack = nil

--type 类型，0神武抢夺，1宝马抢夺
function CreatPacket()
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_SNATCH_OPEN_BOX )
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
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
	if status == 1 then
		require "Script/serverDB/server_dobkOpenBox"
		server_dobkOpenBox.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SNATCH_OPEN_BOX,Server_Excute)