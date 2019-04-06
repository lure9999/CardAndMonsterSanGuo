module("Packet_GetCountryLevelUpData", package.seeall)


local m_funSuccessCallBack = nil

function CreatePacket(nCountry)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_QUERY_COUNTRY_INFO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nCountry)

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
	
	if status == 1 then	
		if m_funSuccessCallBack ~= nil then
			require "Script/serverDB/server_countryLevelUpDB"
			server_countryLevelUpDB.SetTableBuffer(PacketData)
			
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end	
	else
		TipLayer.createTimeLayer("国家数据错误", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_QUERY_COUNTRY_INFO_RETURN,Server_Excute)