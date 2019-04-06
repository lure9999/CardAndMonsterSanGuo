module("Packet_BattleMopUp", package.seeall)
local m_funSuccessCallBack = nil

function CreatPacket(nSceneID, nIndexID, nTimes)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BATTLEMOPUP)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(tonumber(nSceneID))
	pNetStream:Write(tonumber(nIndexID))
	pNetStream:Write(tonumber(nTimes))

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
	local result = pNetStream:Read()
	-- print("Packet_BattleMopUp")
	-- print(PacketData)
	if status == 1 then
		if tonumber(result) == 1 then
			require "Script/serverDB/server_MopupDB"
			server_MopupDB.SetTableBuffer(PacketData)
		end

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack( tonumber(result) )
			m_funSuccessCallBack = nil
		end
	else

	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.C_MS_BATTLEMOPUP_RETURN,Server_Excute)