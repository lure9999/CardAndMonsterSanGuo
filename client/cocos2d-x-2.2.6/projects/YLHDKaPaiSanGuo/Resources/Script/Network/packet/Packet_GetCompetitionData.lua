module("Packet_GetCompetitionData", package.seeall)


--比武界面 celina

local m_funSuccessCallBack = nil

function CreatPacket()
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_TOURNAMENT_LIST)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	RankHistory     = nil,
	RankCurrent     = nil,
	list            = nil 
}

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	
	if Return_Cmd.status == 1 then	
		--表示有比武数据
		require "Script/serverDB/server_biwuDB"
		server_biwuDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack~=nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		local errorID = pNetStream:Read()
		if errorID~=nil then
			if tonumber(errorID) == 1010 then
				TipLayer.createTimeLayer("等级不足,功能尚未开启",2)
			else
				TipLayer.createTimeLayer("服务器数据错误", 2)	
			end
		end
		
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_TOURNAMENT_LIST,Server_Excute)