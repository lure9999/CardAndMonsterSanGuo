--add by sxin 收到服务器列表数据 逻辑处理

module("Packet_GetFtpUrl", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_GS)
	pNetStream:Write(C_GS_NET_MSG_ID.C_GS_FTPSERVER)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write("0")
	pNetStream:Write(0)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	list 			= nil,
}

--解析包逻辑
function ServerList_Excute( PacketData )
	
	network.luaDestroyNetWork()
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.list = pNetStream:Read()
	pNetStream = nil

	
	if Return_Cmd.status == 1 then
		--这里得到url和版本号
		CommonData.g_szFtpUrl = Return_Cmd.list[1]
		local g_szFtpUrl = Return_Cmd.list[1]
		--[[print(g_szFtpUrl)
		Pause()]]--
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		
	end

	NetWorkLoadingLayer.loadingShow(false)
	
		
end

--PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_GS_C,GS_C_NET_MSG_ID.GS_C_FTPSERVER_RETURN,ServerList_Excute)