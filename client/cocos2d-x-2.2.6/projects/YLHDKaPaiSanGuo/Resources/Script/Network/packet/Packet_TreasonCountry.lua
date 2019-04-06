--叛离国家的协议 celina
module("Packet_TreasonCountry", package.seeall)


local m_funSuccessCallBack = nil

--要叛离国家的ID
function CreatPacket(nCountryID)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_TREASON)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nCountryID)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local function DealError(nErrID)
	NetWorkLoadingLayer.loadingShow(false)
	local pTips = TipCommonLayer.CreateTipLayerManager()
	if nErrID == 1077 then
		pTips:ShowCommonTips(1487,nil)
		
	end
	if nErrID == 1078 then
		pTips:ShowCommonTips(1434,nil)
	end
	if nErrID == 1058 then
		pTips:ShowCommonTips(1058,nil)
	end
	if nErrID == 1082 then
		pTips:ShowCommonTips(1636,nil)
	end
	pTips = nil
end
--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status~=1 then
		DealError(status)
	else
		if m_funSuccessCallBack~=nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	end
	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_TREASON,Server_Excute)