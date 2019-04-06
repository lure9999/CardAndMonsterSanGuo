module("Packet_BuyItem", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	token		= 2,
	GlobalID	= 3,
	shopid 		= 4,
	itemid 		= 5,
	number 		= 6,
	price 		= 7,
}

function CreatPacket(shopId, nGrid, nNumber, nPrice)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BUYITEM)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(shopId)
	pNetStream:Write(nGrid)
	pNetStream:Write(nNumber)
	pNetStream:Write(nPrice)

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
	local errorCode = pNetStream:Read()
	pNetStream = nil
	-- print("购买成功")
	if tonumber(status) == 1 then

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		if tonumber(errorCode) == 1009 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1615,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1004 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1610,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1005 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1611,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1006 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1612,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1007 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1613,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1008 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1614,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1010 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1010,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1026 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1621,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1027 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1027,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1211 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1211,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1212 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1212,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1213 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1213,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1025 then
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("商店商品数量不足",2)
		else
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1023,nil)
			pTips = nil
		end
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BUYITEM_RETURN,Server_Excute)