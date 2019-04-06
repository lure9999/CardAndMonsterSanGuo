--开启牢房格子
module("Packet_OpenPrisonGrid",package.seeall)

local m_funSuccessCallBack = nil

--格子ID为1-10数字
function CreatePacket(nGrid)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_ACTIVATE_JALL_GRID)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData)
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then	
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		local errorCode = pNetStream:Read()
		if tonumber(errorCode) == 1210 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1210,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1225 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1225,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("开启牢房格子失败,请重新尝试", 2)
		end
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_ACTIVATE_JALL_GRID,Server_Excute)