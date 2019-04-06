module("Packet_GetNotifyMissionChange", package.seeall)

--解析包逻辑
function Server_Excute( PacketData )
	print(PacketData)
	print("刷新任务")
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status  = pNetStream:Read()
	local nType   = pNetStream:Read()		--任务更新类型 0 = 改变单个任务，1 = 刷新列表, 2 = 删除任务
	local nTaskType = pNetStream:Read()		-- 任务类型 0 = 主线  1 = 日常 2 = 军团  3 = 国家 4 = 国家升级 5 = 国家试炼 
	--任务参数(最新的任务数据)
	local nTaskID 		= pNetStream:Read()
	local nTaskState 	= pNetStream:Read()
	local nRewardID     = pNetStream:Read()
	local nCount   		= pNetStream:Read()
	local nTakeTime  	= pNetStream:Read()	
	local nIndex	  	= pNetStream:Read()		

	if status == 1 then	
		require "Script/Main/MissionNormal/MissionNormalLayer"
		if tonumber(nType) == 0 then
			MissionNormalLayer.MissionUpdateBySingle(tonumber(nTaskType), tonumber(nTaskID), tonumber(nTaskState), tonumber(nRewardID), tonumber(nCount), tonumber(nTakeTime), nIndex)
		elseif tonumber(nType) == 1 then
			MissionNormalLayer.MissionUpdateByList( tonumber(nTaskType) )
		elseif tonumber(nType) == 2 then
			MissionNormalLayer.DeleteMission( tonumber(nTaskID) )
		end
	else
		TipLayer.createTimeLayer("通知任务状态失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_NOTIFY_TASK_UPDATE,Server_Excute)