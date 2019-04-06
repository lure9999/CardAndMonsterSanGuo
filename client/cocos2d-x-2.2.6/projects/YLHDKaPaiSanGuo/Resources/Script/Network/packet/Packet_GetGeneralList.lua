module("Packet_GetGeneralList", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GETGENERALLIST)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	
	print("发送Packet_GetGeneralList")
	return pNetStream:GetPacket()

end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	list 			= nil,
}

--解析包逻辑
function Server_Excute( PacketData )
	-- BeginTime()
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.list = pNetStream:Read()
	-- EndTime()
	
	-- print(PacketData)
		   	
	if Return_Cmd.status == 1 then

		require "Script/serverDB/server_generalDB"
		server_generalDB.SetTableBuffer(PacketData)

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(MS_C_NET_MSG_ID.MS_C_GETGENERALLIST_RETURN)
			m_funSuccessCallBack = nil
		end
	else
		
	end
	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GETGENERALLIST_RETURN,Server_Excute)