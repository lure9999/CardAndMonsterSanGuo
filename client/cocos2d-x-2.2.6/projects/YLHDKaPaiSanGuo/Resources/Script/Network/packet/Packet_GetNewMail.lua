module("Packet_GetNewMail", package.seeall)
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

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end
--]]

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()

	print("Packet_GetNewMail")
	local function refreshMailBox()
		require "Script/Main/MainScene"
		if MainScene.GetControlUI() ~= nil then
			MainScene.ShowNewMail()
		end
	end

	if status == 1 then
		--Packet_GetMailList.SetSuccessCallBack(refreshMailBox)
		refreshMailBox()
		network.NetWorkEvent(Packet_GetMailList.CreatPacket())
	else
		print("get mail list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_MAIL_NEW,Server_Excute)