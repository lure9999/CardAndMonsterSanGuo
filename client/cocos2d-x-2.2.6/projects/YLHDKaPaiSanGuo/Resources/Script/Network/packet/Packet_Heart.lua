module("Packet_Heart", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_HEART)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write("0")
	pNetStream:Write(0)
	return pNetStream:GetPacket()

end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	time 			= nil,
}

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.time = pNetStream:Read()
	-- print("Packet_Heart")
	-- print(PacketData)
		   	
	if Return_Cmd.status == 1 then

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(Return_Cmd.time)
			m_funSuccessCallBack = nil
		end
	else
		
	end
	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_HEART_RETURN,Server_Excute)