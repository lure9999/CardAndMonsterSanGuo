module("Packet_CorpsMessHall",package.seeall)

local m_fullSuccessCallBack = nil

function CreatePacket( nIndex )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_SCIENCE_MESS_GET )
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nIndex)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_fullSuccessCallBack = fullCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode   = pNetStream:Read()
	if status == 1 then
		if m_fullSuccessCallBack ~= nil then
			m_fullSuccessCallBack()
			m_fullSuccessCallBack = nil
		end
	else
		if errorCode == 1054 then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1054,nil)
			pTips = nil
		elseif errorCode == 1010 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1010,nil)
			pTips = nil
		elseif errorCode == 1004 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1610,nil)
			pTips = nil
		elseif errorCode == 1005 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1611,nil)
			pTips = nil
		elseif errorCode == 1006 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1621,nil)
			pTips = nil
		elseif errorCode == 1026 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1621,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1023,nil)
			pTips = nil
		end	
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_SCIENCE_MESS_GET ,Server_Excute)