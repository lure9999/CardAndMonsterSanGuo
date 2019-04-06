module("Packet_CorpsFindOne",package.seeall)

local m_funSuccessFunCallBack = nil

function CreatePacket(nType , nTempInfo)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_FIND_ONE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
	pNetStream:Write(nTempInfo)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fulCall )
	m_funSuccessFunCallBack = fulCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local list = pNetStream:Read()

	if status == 1 then
		--require ""--调用serverDB中的函数
		require "Script/serverDB/server_CorpsGetOneInfo"
		server_CorpsGetOneInfo.SetTableBuffer(PacketData)
		if m_funSuccessFunCallBack ~= nil then
			m_funSuccessFunCallBack()
			m_funSuccessFunCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1413,nil)
		pTips = nil
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_FIND_ONE,Server_Excute)