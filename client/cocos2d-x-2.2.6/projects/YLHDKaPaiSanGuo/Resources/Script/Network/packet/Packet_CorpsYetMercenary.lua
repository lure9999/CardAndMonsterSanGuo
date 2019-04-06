module("Packet_CorpsYetMercenary",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket(  )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_MERCENARY_SERVICE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		require "Script/serverDB/server_MercenaryInfoDB"
		server_MercenaryInfoDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end

	else
		NetWorkLoadingLayer.loadingHideNow()
		TipLayer.createTimeLayer("获取佣兵失败,请检查网络设置", 2)
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_MERCENARY_SERVICE,Server_Excute)