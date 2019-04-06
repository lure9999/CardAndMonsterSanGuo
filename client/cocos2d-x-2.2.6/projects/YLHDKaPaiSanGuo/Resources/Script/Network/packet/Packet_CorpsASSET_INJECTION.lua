module("Packet_CorpsASSET_INJECTION",package.seeall)

local m_fullSuccessCallBack = nil

function CreatePacket( nScienceType )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_SCIENCE_ASSET_INJECTION)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nScienceType)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_fullSuccessCallBack = fullCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	local nType = pNetStream:Read()
	local nNum = pNetStream:Read()
	
	if status == 1 then
		require "Script/serverDB/server_ScienceAssetDB"
		server_ScienceAssetDB.SetTableBuffer(PacketData)
		if m_fullSuccessCallBack ~= nil then
			m_fullSuccessCallBack()
			m_fullSuccessCallBack = nil
		end
	else
		if tonumber(errorCode) == 1218 then
			NetWorkLoadingLayer.loadingHideNow()
			require "Script/Main/Corps/CorpsScene"
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1218,CorpsScene.EnterPresentLayer)
		elseif tonumber(errorCode) == 1217 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1217,EnterPresentLayer)
			pTips = nil
		elseif tonumber(errorCode) == 1057 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1057,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("注资失败!!!")
		end
		
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_SCIENCE_ASSET_INJECTION,Server_Excute)