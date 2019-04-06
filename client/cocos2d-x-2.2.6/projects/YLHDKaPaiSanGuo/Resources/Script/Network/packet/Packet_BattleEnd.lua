module("Packet_BattleEnd", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

local mIndexID = 0
function CreatPacket(nSceneID, nIndexID, nResult)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BATTLEEND)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(tonumber(nSceneID))
	pNetStream:Write(tonumber(nIndexID))
	pNetStream:Write(tonumber(nResult))
	--print(nSceneID,nIndexID,nResult)
	--Pause()
	mIndexID = nIndexID
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

	-- print("Packet_BattleEnd")
	
	--Pause()
	if status == 1 then
		--[[if tonumber(mIndexID) == 10101 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(9))
		end
		if tonumber(mIndexID) == 10102 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(10))
		end
		if tonumber(mIndexID) == 10103 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(11))
		end]]--
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		
	end
	pNetStream = nil

end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BATTLEEND_RETURN,Server_Excute)