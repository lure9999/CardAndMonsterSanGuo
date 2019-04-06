module("Packet_TreeSpeedUp",package.seeall)

local m_fullSuccessCallBack = nil

function CreatePacket( nIndex )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_TREE_SPEED_UP )
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
		if tonumber(errorCode) == 1239 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1239,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1023 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1023,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("服务器连接失败")
		end	
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_TREE_SPEED_UP ,Server_Excute)