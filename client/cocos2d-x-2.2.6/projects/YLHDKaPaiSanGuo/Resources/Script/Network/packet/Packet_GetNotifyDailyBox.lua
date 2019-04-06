module("Packet_GetNotifyDailyBox", package.seeall)

local Mission_Type = {
	Mission_MainLine    	= 0,
	Mission_Daily			= 1,
	Mission_Corps			= 2,
	Mission_CountryWar		= 3,
	Mission_Special 		= 4,
}

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)

	local status  	 = pNetStream:Read()
	local nBoxIndex  = pNetStream:Read()
	local nBoxState  = pNetStream:Read()
	local nBoxScore  = pNetStream:Read()

	if status == 1 then	
		require "Script/Main/MissionNormal/MissionNormalLayer"
		MissionNormalLayer.UpdateDailyBox( tonumber(nBoxIndex + 1), tonumber(nBoxState), tonumber(nBoxScore) )
	else
		TipLayer.createTimeLayer("服务器错误Update DailyBox", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_DALIY_TREASURE_STATE_CHANGE,Server_Excute)