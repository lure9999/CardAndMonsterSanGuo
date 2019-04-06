module("Packet_CorpsScienceSpeedUp",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket( nScienceID,nNum )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_SCIENCE_SPEED_UP)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nScienceID)
	pNetStream:Write(nNum)
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
		require "Script/serverDB/server_ScienceSpeedUp"
		server_ScienceSpeedUp.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		if errorCode == 1053 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1053,nil)
			pTips = nil
		elseif errorCode == 1023 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1023,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			print("加速升级失败")
		end
	end
	pNetStream = nil
end
PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SCIENCE_SPEED_UP,Server_Excute)