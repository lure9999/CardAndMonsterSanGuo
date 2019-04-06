module("Packet_BattleBeginByAttr", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket(nSceneID, nIndexID, nAttrID)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CLIMBING_GAIN)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(tonumber(nSceneID))
	pNetStream:Write(tonumber(nIndexID))
	pNetStream:Write(tonumber(nAttrID))

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
	local errorID = pNetStream:Read()

	if status == 1 then

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(errorID)
			m_funSuccessCallBack = nil
		end		
		
	else
		print("battle Begin Attr false")
	end
	
	--[[if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(pNetStream)
			m_funSuccessCallBack = nil
		end
	else
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
		print("battle Begin false")
	end]]
	pNetStream = nil

end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CLIMBING_GAIN,Server_Excute)