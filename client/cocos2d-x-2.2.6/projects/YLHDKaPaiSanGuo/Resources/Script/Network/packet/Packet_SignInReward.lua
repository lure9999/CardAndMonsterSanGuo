--签到奖励协议
module("Packet_SignInReward",package.seeall)

local m_funSuccessFunCallBack = nil

function CreatePacket()
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_SIGN_IN_GET_TAB)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	
	print("Packet_SignInReward")
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
		require "Script/serverDB/server_SignInReward"
		server_SignInReward.SetTableBuffer(PacketData)
		if m_funSuccessFunCallBack ~= nil then
			m_funSuccessFunCallBack(MS_C_NET_MSG_ID.MS_C_SIGN_IN_GET_TAB)
			m_funSuccessFunCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SIGN_IN_GET_TAB,Server_Excute)