module("Packet_SaveModel", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	old			= 4,
	new			= 5,
}

local m_funSuccessCallBack = nil

function CreatPacket( nModelID,nHeadID)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CHANGE_MODELS_3D)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nModelID)
	pNetStream:Write(nHeadID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--½âÎö°üÂß¼­
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local modelID = pNetStream:Read()
	if status == 1 then
		--µÃµ½¾ßÌå¼ÇÂ¼µÄÐÅÏ¢
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		print("±£´æÐÎÏóÊ§°Ü")
		
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CHANGE_MODELS_3D,Server_Excute)