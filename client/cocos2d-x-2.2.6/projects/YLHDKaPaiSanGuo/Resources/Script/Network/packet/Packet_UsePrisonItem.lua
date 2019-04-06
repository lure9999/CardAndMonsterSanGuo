--使用牢房加成道具协议
module("Packet_UsePrisonItem",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket(nItemID,nNum)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_JALL_USE_ITEM)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nItemID)
	pNetStream:Write(nNum)
	
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
		require "Script/serverDB/server_UsePrisonItem"
		server_UsePrisonItem.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		local errorCode = pNetStream:Read()
		if tonumber(errorCode) == 1023 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1023,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("使用道具出错,请重新尝试", 2)
		end
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_JALL_USE_ITEM,Server_Excute)