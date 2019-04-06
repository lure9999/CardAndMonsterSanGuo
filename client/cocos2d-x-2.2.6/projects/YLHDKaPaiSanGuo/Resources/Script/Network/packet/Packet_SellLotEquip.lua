
--批量出售装备
module("Packet_SellLotEquip", package.seeall)
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

function CreatPacket(tabGrid, nTotalCount,nType)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BULK_SALE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)--类型1表示装备
	pNetStream:Write(nTotalCount)--总共的装备数量
	for i=1,nTotalCount do 
		pNetStream:Write(tabGrid[i][1])--格子
		pNetStream:Write(tabGrid[i][2])--每个装备的数量
	end
	
	
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
	

	print("卖成功"..PacketData)
	if status == 1 then
		--add celina 1027 暂时写死
		local list = pNetStream:Read()
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(list)
			m_funSuccessCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
		local errorID = pNetStream:Read()
		if tonumber(errorID) == 1237  then
			TipLayer.createTimeLayer("没有选中任何装备",2)
		end
		if tonumber(errorID) == 1238  then
			TipLayer.createTimeLayer("出售的类型错误",2)
		end
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BULK_SALE_RESULT,Server_Excute)