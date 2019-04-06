module("Packet_CountryWarEatBlood", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local Server_Cmd = {
	TeamID  = 1,
	CanMove = 2,
}

local m_funSuccessCallBack = nil

function CreatePacket(nTeamID, nItemID, nUseNum)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_USE_ITEM)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nTeamID)
	pNetStream:Write(nItemID)
	pNetStream:Write(nUseNum)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall, nType)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local result = pNetStream:Read()  --1成功 2所选战队不存在 3物品数量不足 4 不在闲置移动状态不能使用 
	if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(result)
		end
	else
		print("move list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_USE_ITEM_RESULT,Server_Excute)