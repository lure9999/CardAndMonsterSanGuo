module("Packet_CorpsGetList",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket( nIsApply , nIsOneSelf )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_GET_LIST)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nIsApply)
	pNetStream:Write(nIsOneSelf)
	return pNetStream:GetPacket()

end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	--[[print(PacketData)
	print("推送协议")
	require "Script/serverDB/server_mainDB"
	require "Script/Main/MainScene"
	local nCorpsId = tonumber(server_mainDB.getMainData("nCorps"))
	if nCorpsId > 0 then
		TipLayer.createTimeLayer("已经有军团", 2)
	else
		--MainScene.createMainUI()
		TipLayer.createTimeLayer("没有军团", 2)
	end
	Pause()]]--
	if status == 1 then
		require "Script/serverDB/server_CorpsGetListDB"
		server_CorpsGetListDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
		TipLayer.createTimeLayer("服务器数据错误", 2)
	end
	pNetStream = nil
end
PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_GET_LIST,Server_Excute)