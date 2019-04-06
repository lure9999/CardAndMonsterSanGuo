module("Packet_CorpsGetInfo",package.seeall)

local m_funSuccessCallBack = nil

function CreateStream(  )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_GET_INFO)
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
		require "Script/serverDB/server_CorpsGetInfoDB"
		server_CorpsGetInfoDB.SetTableBuffer(PacketData)
		local list = pNetStream:Read()
		require "Script/Main/Corps/CorpsScene"
		if CorpsScene.GetPLayer() ~= nil then --  GetPScene()
			CorpsScene.GetUpdateMoney(list[11],1)
		end
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
		-- TipLayer.createTimeLayer(" 获取军团信息失败", 2)
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_GET_INFO,Server_Excute)