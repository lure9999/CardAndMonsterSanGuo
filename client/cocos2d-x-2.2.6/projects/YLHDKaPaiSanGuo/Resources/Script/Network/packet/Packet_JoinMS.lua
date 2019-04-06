module("Packet_JoinMS", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	IP 				= 2,
	Token 			= 3,
	DynamicGSID 	= 4,
	DynamicMSID 	= 5,
	GlobalID 		= 6,
}

function CreatPacket( )
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_GS)
	pNetStream:Write(C_GS_NET_MSG_ID.C_GS_JOINMS)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(CommonData.g_nDynamicGSID)
	pNetStream:Write(CommonData.g_ServerListTable[CommonData.g_nCurServerIndex].MapServerDynamicID)
	pNetStream:Write(CommonData.g_ServerListTable[CommonData.g_nCurServerIndex].ServerIP)
	
	--[[print("JoinMS")
	print(CommonData.g_ServerListTable[CommonData.g_nCurServerIndex].ServerIP)
	print(CommonData.g_szToken)
	print(CommonData.g_nDynamicGSID)
	print(CommonData.g_ServerListTable[CommonData.g_nCurServerIndex].MapServerDynamicID)
	print(CommonData.g_nGlobalID)
	Pause()]]--

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
}

--解析包逻辑
function Server_Excute( PacketData )
	
	-- print("luaDestroyNetWork - 3")
	network.luaDestroyNetWork()
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	pNetStream = nil
	if Return_Cmd.status == 1 then
		--print("JoinMS登陆成功")
		
		CommonData.g_nDynamicMSID = CommonData.g_ServerListTable[CommonData.g_nCurServerIndex].MapServerDynamicID
		--print(CommonData.g_nDynamicMSID)
		--Pause()
		if m_funSuccessCallBack ~= nil then
			
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
		
	else
	
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_GS_C,GS_C_NET_MSG_ID.GS_C_JOINMS_RETURN,Server_Excute)