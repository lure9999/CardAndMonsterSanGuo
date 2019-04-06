module("Packet_GetCountryWarExpeDitionMes", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}
--[[
local m_funSuccessCallBack = nil

function CreatPacket()

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(MS_C_NET_MSG_ID.MS_C_MAIL_NEW)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

	return pNetStream:GetPacket()
end
--]]
function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end


--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()

	if status == 1 then
		print("Packet_GetCountryWarExpeDitionMes")
		require "Script/serverDB/server_CountryWarExpeditionMesDB"
		server_CountryWarExpeditionMesDB.SetTableBuffer(PacketData)
	else
		print("get Packet_GetCountryWarTeamMes list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_EXPEDITION_DATA,Server_Excute)