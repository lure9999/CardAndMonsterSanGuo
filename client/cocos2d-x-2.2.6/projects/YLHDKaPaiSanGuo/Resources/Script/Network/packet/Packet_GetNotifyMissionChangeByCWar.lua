module("Packet_GetNotifyMissionChangeByCWar", package.seeall)

local Mission_Type = {
	Mission_MainLine    	= 0,
	Mission_Daily			= 1,
	Mission_Corps			= 2,
	Mission_CountryWar		= 3,
	Mission_Special 		= 4,
}

--解析包逻辑
function Server_Excute( PacketData )
	print(PacketData)
	print("刷新国战组任务 or 国家升级任务")
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)

	local status  = pNetStream:Read()
	local ntype  = pNetStream:Read()

	if status == 1 then	

		if tonumber(ntype) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS then
			require "Script/serverDB/server_NormalMissionCWarDBByArray"
			server_NormalMissionCWarDBByArray.SetTableBuffer(PacketData)
		elseif tonumber(ntype) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI or
			   tonumber(ntype) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU or
			   tonumber(ntype) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU 
		then
			require "Script/serverDB/server_NormalMissionCWarLevelUpDBByArray"
			server_NormalMissionCWarLevelUpDBByArray.SetTableBuffer(PacketData)
		elseif tonumber(ntype) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_TRIAL then 
			require "Script/serverDB/server_NormalMissionCWarShiLianDB"
			server_NormalMissionCWarShiLianDBByArray.SetTableBuffer(PacketData)
		end

		require "Script/Main/MissionNormal/MissionNormalLayer"
		MissionNormalLayer.MissionUpdateByArray( ntype )
	else
		TipLayer.createTimeLayer("通知 CWar Array 任务状态失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SEND_WAR_COUNTRY_TASK_DATA,Server_Excute)