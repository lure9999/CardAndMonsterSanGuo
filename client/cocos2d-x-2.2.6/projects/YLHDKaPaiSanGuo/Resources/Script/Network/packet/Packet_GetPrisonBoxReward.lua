--获取牢房奖励箱子协议
module("Packet_GetPrisonBoxReward",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket()
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_JALL_GET_BOX)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData)
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		local list = pNetStream:Read()
		-- GetGoodsLayer.createGetGoods(list)
		require "Script/serverDB/server_GetPrisonBRDB"
		server_GetPrisonBRDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		local errorCode = pNetStream:Read()
		NetWorkLoadingLayer.loadingHideNow()
		TipLayer.createTimeLayer("获取牢房奖励箱子出错,请重新尝试", 2)
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_JALL_GET_BOX,Server_Excute)