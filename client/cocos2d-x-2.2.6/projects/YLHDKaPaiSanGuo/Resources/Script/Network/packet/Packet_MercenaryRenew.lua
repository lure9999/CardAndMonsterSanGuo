--续费协议
module("Packet_MercenaryRenew",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket( GridID,nDay )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_MERCENARY_RENEW)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(GridID)
	pNetStream:Write(nDay)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	if status == 1 then		
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		if errorCode == 1069 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1069,nil)
			pTips = nil
		elseif errorCode == 1070 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1070,nil)
			pTips = nil
		elseif errorCode == 1023 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1023,nil)
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

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_MERCENARY_RENEW,Server_Excute)