module("Packet_CorpsGetMemList",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket()
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_GET_MEMBER_LIST)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		--require "" --调用serverDB中的lua函数
		require "Script/serverDB/server_CorpsMember"
		server_CorpsMember.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		local errorCode = pNetStream:Read()
		if tonumber(errorCode) == 1045 then
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer(" 军团不存在", 2)
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer(" 获取军团成员列表失败", 2)
		end
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_GET_MEMBER_LIST,Server_Excute)