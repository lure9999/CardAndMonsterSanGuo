module("Packet_BattleBegin", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket(nSceneID, nIndexID)
	-- print("Packet_BattleBegin SceneId = "..nSceneID.."\t IndexId = "..nIndexID)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BATTLEBEGIN)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(tonumber(nSceneID))
	pNetStream:Write(tonumber(nIndexID))

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
	
	-- print("Packet_BattleBegin")
	
	if status == 1 then
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
	end
	pNetStream = nil

end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BATTLEBEGIN_RETURN,Server_Excute)