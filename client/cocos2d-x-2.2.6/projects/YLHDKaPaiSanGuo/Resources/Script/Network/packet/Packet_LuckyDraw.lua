module("Packet_LuckyDraw", package.seeall)

local m_funSuccessCallBack = nil

local nType = 0
function CreatPacket(nLuckydrawType , nCount)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_LUCKYDRAM)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(tonumber(nLuckydrawType ))
	pNetStream:Write(tonumber(nCount))
	nType = tonumber(nLuckydrawType )
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
	local baserewardID = pNetStream:Read()
	-- print("Packet_LuckyDraw")
	--print(PacketData)
	--Pause()
	if status == 1 then
		--[[if nType ==0 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(1))
		elseif nType ==1 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(2))
		end]]--
		require "Script/serverDB/server_LuckyDrawItemDB"
		server_LuckyDrawItemDB.SetTableBuffer(baserewardID, pNetStream:Read())
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else

	end
	pNetStream = nil

end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_LUCKYDRAM_RETURN,Server_Excute)