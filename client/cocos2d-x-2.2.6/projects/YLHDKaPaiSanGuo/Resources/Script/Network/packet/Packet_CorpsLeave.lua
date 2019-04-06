module("Packet_CorpsLeave",package.seeall)

local m_LeaveSuccessCallBack = nil

function CreatePacket()
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_LEAVE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	return pNetStream:GetPacket()
end

function SetSuccessCallback( fullCall)
	m_LeaveSuccessCallBack = fullCall
end

--解析逻辑包
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	if status == 1 then 
		if m_LeaveSuccessCallBack ~= nil then
			m_LeaveSuccessCallBack()
			m_LeaveSuccessCallBack = nil
		end
	else
		if errorCode == 1047 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1047,nil)
			pTips = nil
		elseif errorCode == 1057 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1057,nil)
			pTips = nil
		end
	end

	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_LEAVE,Server_Excute)
