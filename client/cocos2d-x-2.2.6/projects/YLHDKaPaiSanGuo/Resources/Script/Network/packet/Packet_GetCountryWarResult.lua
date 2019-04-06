
--获得攻城战的结果
module("Packet_GetCountryWarResult", package.seeall)
--local cjson	= require "json"


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
		if CommonData.g_IsUnlockCountryWar == true then
			require "Script/serverDB/server_countrywarResultDB"
			server_countrywarResultDB.SetTableBuffer(PacketData)
			if m_funSuccessCallBack ~= nil then
				m_funSuccessCallBack()
				m_funSuccessCallBack = nil
			end
		else
			print("国战场景未开启，不执行战斗结果协议")
		end
	else
		TipLayer.createTimeLayer("服务器数据错误", 2)	
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_BATTLE_RESULT,Server_Excute)