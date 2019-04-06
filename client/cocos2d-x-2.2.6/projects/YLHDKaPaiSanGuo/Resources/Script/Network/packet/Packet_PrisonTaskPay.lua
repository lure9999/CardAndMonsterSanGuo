--交付牢房任务协议
module("Packet_PrisonTaskPay",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket(nGrid)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_JALL_DELIVERABLES)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData)
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		local errorCode = pNetStream:Read()
		if tonumber(errorCode) == 1226 then
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("该军团任务已经完成过", 2)
			--[[local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1046,nil)
			pTips = nil]]--
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("交付牢房任务出错,请重新尝试", 2)
		end
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_JALL_DELIVERABLES,Server_Excute)