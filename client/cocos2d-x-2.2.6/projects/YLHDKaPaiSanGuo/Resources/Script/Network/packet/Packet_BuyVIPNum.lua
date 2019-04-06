--购买vip次数
module("Packet_BuyVIPNum",package.seeall)

local m_fullSuccessCallBack = nil

function CreatePacket( nVIPType,nSceneID,nFightID )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BUY_COUNT )
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(tonumber(nVIPType))
	pNetStream:Write(nSceneID)
	pNetStream:Write(nFightID)
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
		require "Script/serverDB/server_BuyVIP"
		server_BuyVIP.SetTableBuffer(PacketData)
		if m_fullSuccessCallBack ~= nil then
			m_fullSuccessCallBack()
			m_fullSuccessCallBack = nil
		end
	else
		if tonumber(errorCode) == 1075 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1075,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1073 then
			NetWorkLoadingLayer.loadingHideNow()
			--[[local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1073,nil)
			pTips = nil]]--
			TipLayer.createTimeLayer("购买次数已满,无法继续购买")
		elseif tonumber(errorCode) == 1023 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1023,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1005 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1611,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1010 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1010,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("服务器连接失败")
		end	
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BUY_COUNT ,Server_Excute)