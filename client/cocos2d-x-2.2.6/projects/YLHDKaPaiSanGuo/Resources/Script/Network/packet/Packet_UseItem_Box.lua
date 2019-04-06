module("Packet_UseItem_Box", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
	BoxID 			= 4,
	KeyID 			= 5,
	number 			= 6,
}

function CreatPacket(nGrid, number)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_USEITEM_BOX)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	pNetStream:Write(number)

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
	
	-- print("Packet_UseItem_Box")
	-- print(PacketData)

	if status == 1 then

		local list = pNetStream:Read()
    	--local nTempId = list[1][1]
    	--local nNumber = list[1][2]

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(nTempId, nNumber)
			m_funSuccessCallBack = nil
		end

	else
		
	end
	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_USEITEM_BOX_RETURN,Server_Excute)