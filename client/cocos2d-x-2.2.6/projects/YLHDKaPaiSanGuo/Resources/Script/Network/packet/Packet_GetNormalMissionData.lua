module("Packet_GetNormalMissionData", package.seeall)


local m_funSuccessCallBack = nil

function CreatePacket(nType)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GET_DALIY_TASK_INFO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)

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
	local nType  = pNetStream:Read()
	--print(PacketData)
	--print(m_funSuccessCallBack)
	--Pause()
	if status == 1 then	
		if m_funSuccessCallBack ~= nil then
			if tonumber(nType) == 0 then
				 --主线解析
				require "Script/serverDB/server_NormalMissionMainLineDB"
				server_NormalMissionMainLineDB.SetTableBuffer(PacketData)
			elseif tonumber(nType) == 1 then
				--日常解析
				require "Script/serverDB/server_NormalMissionDB"
				server_NormalMissionDB.SetTableBuffer(PacketData)
			else

			end	
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end	
	else
		TipLayer.createTimeLayer("任务数据错误", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GET_DALIY_TASK_INFO,Server_Excute)