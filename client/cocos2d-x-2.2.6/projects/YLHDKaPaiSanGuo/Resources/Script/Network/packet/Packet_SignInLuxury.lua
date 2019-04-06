--豪华签到协议
module("Packet_SignInLuxury",package.seeall)

local m_funSuccessFunCallBack = nil

function CreatePacket()
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_SIGN_IN_GET_ADVANCED)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

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
		if m_funSuccessFunCallBack ~= nil then
			m_funSuccessFunCallBack()
			m_funSuccessFunCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1472,nil)
		pTips = nil
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SIGN_IN_GET_ADVANCED,Server_Excute)