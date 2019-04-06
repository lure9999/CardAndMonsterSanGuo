module("Packet_GetChatInfo", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}
local n_ChannelID = 0
local m_funSuccessCallBack = nil

function CreatPacket(nChannelID,RecvName,ChatMsg)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CHAT)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nChannelID)
	pNetStream:Write(RecvName)
	pNetStream:Write(ChatMsg)
	n_ChannelID = nChannelID
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	require "Script/serverDB/server_ChatDB"
	if status == 1 then	
		server_ChatDB.SetTableBuffer(PacketData)

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		local nErrorID = pNetStream:Read()
		if tonumber(nErrorID) == 1 then
			server_ChatDB.errorTip(1102)
			
		elseif tonumber(nErrorID) == 2 then
			server_ChatDB.errorTip(1101)
		elseif tonumber(nErrorID) == 1060 then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1507,nil)
			pTips = nil
		elseif tonumber(nErrorID) == 1072 then
			if tonumber(n_ChannelID) ~= 2 then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1072,nil)
			pTips = nil
			end
		elseif tonumber(nErrorID) == 1236 then
			local totalTime = pNetStream:Read()
			require "Script/Main/Chat/ChatLayer"
			ChatLayer.SendMessageSpace(totalTime)
		end
		print("get ChatInfo list error the status is 0 , nErrorID = "..nErrorID)
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CHAT,Server_Excute)