module("Packet_GetRankData", package.seeall)


local m_funSuccessCallBack = nil

function CreatPacket(nRankType)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_RANKING_LIST)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nRankType)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	NType 			= nil,
	NRanking		= nil,
	TableUser      = nil
}

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.NType = pNetStream:Read()
	Return_Cmd.NRanking = pNetStream:Read()
	pNetStream = nil
	
	if Return_Cmd.status == 1 then	
		if m_funSuccessCallBack ~= nil then
			require "Script/serverDB/server_rankDB"
			server_rankDB.SetTableBuffer(PacketData)
			
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end	
	else
		print("Packet_GetRankData")
		TipLayer.createTimeLayer("服务器数据错误", 2)	
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_RANKING_LIST,Server_Excute)