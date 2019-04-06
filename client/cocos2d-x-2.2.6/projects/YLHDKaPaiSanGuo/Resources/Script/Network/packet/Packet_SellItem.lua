module("Packet_SellItem", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	token		= 2,
	GlobalID	= 3,
	shopid 		= 4,
	itemid 		= 5,
	number 		= 6,
	price 		= 7,
}

function CreatPacket(nGrid, nCount,nType)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_SELLITEM)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	pNetStream:Write(nCount)
	pNetStream:Write(nType)
	--nType 0表示道具，1表示装备
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

	--print("卖成功"..PacketData)
	if status == 1 then
		--add celina 1027 暂时写死
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(list)
			m_funSuccessCallBack = nil
		end
	else
		
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SELLITEM_RETURN,Server_Excute)