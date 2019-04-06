require "Script/Main/Mall/ShopLayer"
module("Packet_RefreshShop", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket(nShopId)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_REFRSHSHOP)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nShopId)

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

	-- print("Packet_RefreshShop")
	-- print(PacketData)

	if status == 1 then
		-- require "Script/serverDB/server_shopDB"
		-- server_shopDB.SetTableBuffer(PacketData).
		ShopLayer.SetLeftRefreshCount(pNetStream:Read())
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
		
	else
		local errorCode = pNetStream:Read()
		if tonumber(errorCode) == 1026 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1026,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1027 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1027,nil)
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
		elseif tonumber(errorCode) == 1223 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1223,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
		end
		print("get shop list error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_REFRSHSHOP_RETURN,Server_Excute)