module("Packet_GetReceiveMissionNormalData", package.seeall)


local m_funSuccessCallBack = nil

function CreatePacket(nType, nMissionID)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GET_DALIY_TASK_REWARD_INFO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
	pNetStream:Write(nMissionID)

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
	local result = pNetStream:Read()

	if status == 1 then	
		if m_funSuccessCallBack ~= nil  then
			m_funSuccessCallBack( tonumber(result) )
			m_funSuccessCallBack = nil
		end	
	else
		TipLayer.createTimeLayer("领取任务奖励失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GET_DALIY_TASK_REWARD_INFO,Server_Excute)