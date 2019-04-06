module("Packet_GetReceiveMissionCorpsData", package.seeall)

local m_funSuccessCallBack = nil

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then	
		require "Script/serverDB/server_NormalMissionCorpsDB"
		server_NormalMissionCorpsDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		else
     		require "Script/Main/MissionNormal/MissionNormalLayer"
     		if MissionNormalLayer.GetControlUI() ~= nil then
    			MissionNormalLayer.BeginCorpsMisiion()
     		end
		end	
	else
		TipLayer.createTimeLayer("获取军团任务数据失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SEND_CORPS_TASK_DATA,Server_Excute)