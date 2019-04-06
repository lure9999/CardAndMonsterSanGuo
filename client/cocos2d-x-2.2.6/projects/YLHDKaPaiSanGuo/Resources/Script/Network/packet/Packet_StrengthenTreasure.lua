module("Packet_StrengthenTreasure", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket(nGrid, nGrid1, nGrid2, nGrid3, nGrid4, nGrid5)
	--[[print(nGrid)
	print(nGrid1)
	print(nGrid2)
	Pause()]]--
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_STRENGTHENTREASURE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	pNetStream:Write(nGrid1)
	pNetStream:Write(nGrid2)
	pNetStream:Write(nGrid3)
	pNetStream:Write(nGrid4)
	pNetStream:Write(nGrid5)

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
	local list = pNetStream:Read()
	pNetStream = nil
	
	--[[print("Packet_StrengthenTreasure")
	print(PacketData)
	
	Pause()]]--
	if status == 1 then

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(true)
			m_funSuccessCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(false)
			m_funSuccessCallBack = nil
		end
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_STRENGTHENTREASURE_RETURN,Server_Excute)