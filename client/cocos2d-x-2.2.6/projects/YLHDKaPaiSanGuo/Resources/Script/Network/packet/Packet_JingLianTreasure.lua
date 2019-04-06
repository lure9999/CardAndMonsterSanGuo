module("Packet_JingLianTreasure", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket(nGrid)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_XILIANTREASURE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	pNetStream:Write(0)

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
	
	-- print("Packet_JingLianTreasure")
	-- print(PacketData)
	--Pause()
	if status == 1 then

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		print("精炼数据错误")
		NetWorkLoadingLayer.loadingHideNow()
		if tonumber(list) == 1032 then
			TipLayer.createTimeLayer("洗炼消耗品不足",2)
		elseif  tonumber(list) == 1010 then
			TipLayer.createTimeLayer("等级不足,功能尚未开启",2)
		end
		
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_XILIANTREASURE_RETURN,Server_Excute)