module("Packet_GetReceiveMissionPromptData", package.seeall)

local Server_Cmd = {
	E_TASK_KIND_MAIN		=	0, --主线任务
	E_TASK_KIND_DALIY		=	1, --日常任务
	E_TASK_KIND_CORPS		=	2, --军团任务
	E_TASK_KIND_WAR			=	3, --国战任务
}
				
				

--解析包逻辑
function Server_Excute( PacketData )
	--Pause()

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()

	if status == 1 then	
		require "Script/serverDB/server_MissionPromptDB"
		server_MissionPromptDB.SetTableBuffer(PacketData)
		require "Script/Main/MissionNormal/MissionNormalLayer"
		if MissionNormalLayer.GetControlUI() ~= nil then
			MissionNormalLayer.RefreshRedPoint()
		end

		require "Script/Main/MissionNormal/MissionNormalLayer"
		require "Script/Main/CountryWar/CountryUILayer"
		require "Script/Main/MainBtnLayer"
		if MissionNormalLayer.GetControlUI() == nil then
			--非任务界面的刷新
			local pUILayer = CountryUILayer.GetControlUI()

			if pUILayer ~= nil then
				CountryUILayer.SetRedPointState()
				--[[if pUILayer:isVisible() == false then
					MainBtnLayer.SetRedPoint()
				end]]
			else
				--MainBtnLayer.SetRedPoint()
			end
		end
	else
		TipLayer.createTimeLayer("通知红点状态失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_NOTIFY_TASK_RED_POINT,Server_Excute)