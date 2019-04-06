module("Packet_GetReceiveCountryWarMissionState", package.seeall)


--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local nstate = pNetStream:Read()
	local ntype  = pNetStream:Read()
	if status == 1 then	
		require "Script/serverDB/server_MissionCountryWarStateDB"
		server_MissionCountryWarStateDB.SetTableBuffer(PacketData)
		require "Script/Main/MissionNormal/MissionNormalLayer"
		if ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS then
			if MissionNormalLayer.GetControlUI() ~= nil then
				print("发布国家任务")
				MissionNormalLayer.BeginCWarMisiion()
			end
		elseif ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI or ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU or ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU then
			if MissionNormalLayer.GetControlUI() ~= nil then
				print("发布国家升级任务")
				MissionNormalLayer.BeginCWarLevelUpMission()
			end		
		elseif ntype ==	E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_TRIAL then
			if MissionNormalLayer.GetControlUI() ~= nil then
				print("发布国家试炼任务")
				MissionNormalLayer.BeginCWarShiLianMission()
			end

		end
	else
		TipLayer.createTimeLayer("通知国战任务状态失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_NOTIFY_TASK_RELEASE,Server_Excute)