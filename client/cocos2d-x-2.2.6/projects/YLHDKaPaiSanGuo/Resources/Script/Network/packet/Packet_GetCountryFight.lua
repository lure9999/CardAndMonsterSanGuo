--获得三个国家的战力

module("Packet_GetCountryFight", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

function CreatPacket()

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GET_COUNTRY_POWER)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

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
	
	-- print("Packet_TianMing")

	if status == 1 then
		local nWei = pNetStream:Read()
		local nShu = pNetStream:Read()
		local nWu = pNetStream:Read()
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(nWei,nShu,nWu)
			m_funSuccessCallBack = nil
		end

	else
		print("获得三个国家战力错误")
		NetWorkLoadingLayer.loadingHideNow()
	end
	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GET_COUNTRY_POWER,Server_Excute)