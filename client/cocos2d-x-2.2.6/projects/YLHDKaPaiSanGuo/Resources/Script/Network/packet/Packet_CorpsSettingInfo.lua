module("Packet_CorpsSettingInfo",package.seeall)
local m_funSuccessCallBack = nil

--军团ID
function CreatePacket( nSettingID,SettingsVal )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_SETTINGS)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nSettingID)
	pNetStream:Write(SettingsVal)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

--解析逻辑包
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	if status == 1 then
		require "Script/serverDB/server_CorpsSettingDB"
		server_CorpsSettingDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		if errorCode == 1072 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1072,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1052,nil)
			pTips = nil
		end
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_SETTINGS,Server_Excute)