module("Packet_CountryMistyCityInfo", package.seeall)


local m_funSuccessCallBack = nil

function CreatePacket(nIndex)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_CLICK_FOG_CITY)  --213
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nIndex)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status 	= pNetStream:Read()
	local nIndex    = pNetStream:Read()
	local nType  	= pNetStream:Read() 			--1 返回该城市数据  2 = 战斗结果（单走另一个消息） 3 = 可以解开迷雾
    local ImageID   = pNetStream:Read()
    local Level     = pNetStream:Read()
    local Name      = pNetStream:Read()
    local nMaxHp 	= pNetStream:Read()
    local nCurHp 	= pNetStream:Read()
	
	if status == 1 then	
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(nType, ImageID, Level, Name, nMaxHp, nCurHp)
			m_funSuccessCallBack = nil
		end	
	else
		TipLayer.createTimeLayer("获取迷雾中心城市信息失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CLICK_FOG_CITY_RETURN,Server_Excute)