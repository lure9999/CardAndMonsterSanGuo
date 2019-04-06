
--一键强化 celina

module("Packet_OneKeyStrengthen", package.seeall)

local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	old			= 4,
	new			= 5,
}

local m_funSuccessCallBack = nil

--nMarixIndex阵容索引
function CreatPacket( nMarixIndex )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_STRENGTHENEQUIP_AUTO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nMarixIndex)
	
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
	if status == 1 then
		local list =  pNetStream:Read()
		local tab = {}
		tab[1] = list[1]
		tab[2] = list[2]
		tab[3] = list[3]
		tab[4] = list[4]
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(tab,nil)
			m_funSuccessCallBack = nil
		end
	else
		local errorID = pNetStream:Read()
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(nil,tonumber(errorID))
			m_funSuccessCallBack = nil
		end
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_STRENGTHENEQUIP_AUTO,Server_Excute)