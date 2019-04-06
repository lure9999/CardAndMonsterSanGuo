--进贡
module("Packet_AniTribute",package.seeall)

local m_fullSuccessCallBack = nil

function CreatePacket( nType,nIndex )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_ANIMAL_TRIBUTE )
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
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
		require "Script/serverDB/server_AniCurPer"
		server_AniCurPer.SetTableBuffer(PacketData)
		if m_fullSuccessCallBack ~= nil then
			m_fullSuccessCallBack()
			m_fullSuccessCallBack = nil
		end
	else
		if errorCode == 1080 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1080,nil)
			pTips = nil
		elseif errorCode == 1227 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1227,nil)
			pTips = nil
		elseif errorCode == 1228 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1228,nil)
			pTips = nil
		elseif errorCode == 1229 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1229,nil)
			pTips = nil
		elseif errorCode == 1005 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1611,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("服务器连接失败")
		end	
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_ANIMAL_TRIBUTE ,Server_Excute)