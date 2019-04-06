

--装备炼化

module("Packet_Refining_Equip", package.seeall)

--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

--格子，数量，炼化类型
function CreatPacket(nGrid,nCount,nType)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_REFINING_EQUIP)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	pNetStream:Write(nCount)
	pNetStream:Write(nType)

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
	
	--print("Packet_Refining_Equip")
	--print(PacketData)
	if status == 1 then
		local list = pNetStream:Read()
		
		local tableCoin = list[1]
		local tableItem = list[2]
		
		
		--炼化后获得的物品
		GetGoodsLayer.createGetGoods(tableItem,tableCoin)	
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_REFINING_EQUIP_RETURN,Server_Excute)