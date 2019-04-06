
--获得单挑的的结果
module("Packet_GetSingleResult", package.seeall)
--local cjson	= require "json"



--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			
			require "Script/serverDB/server_SingleResultDB"
			server_SingleResultDB.SetTableBuffer(PacketData)
			
		else
			print("国战场景未开启，不执行战斗结果协议")
		end
	else
		TipLayer.createTimeLayer("服务器数据错误", 2)	
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_PVP_REWARD_INFO,Server_Excute)