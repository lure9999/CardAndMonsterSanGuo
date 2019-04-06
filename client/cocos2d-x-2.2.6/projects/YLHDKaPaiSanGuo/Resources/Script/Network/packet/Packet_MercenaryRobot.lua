--获取佣兵协议
module("Packet_MercenaryRobot",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket(  )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_MERCENARY_RESERVE)
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
	local ErrorCode = pNetStream:Read()
	if status == 1 then
		require "Script/serverDB/server_MercenaryRobotDB"
		server_MercenaryRobotDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end

	else
		if ErrorCode == 1065 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1065,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			--local pTips = TipCommonLayer.CreateTipLayerManager()
			--pTips:ShowCommonTips(1466,nil)
			--pTips = nil
		end	
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_MERCENARY_RESERVE,Server_Excute)