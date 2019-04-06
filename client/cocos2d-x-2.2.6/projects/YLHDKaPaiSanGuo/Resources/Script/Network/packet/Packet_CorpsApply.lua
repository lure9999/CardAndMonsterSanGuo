module("Packet_CorpsApply",package.seeall)
local m_funSuccessCallBack = nil

--军团ID
function CreatePacket( nCorpsID )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_APPLY)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nCorpsID)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

--解析逻辑包
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	local nTime = pNetStream:Read()
	if status > 0 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		if errorCode == 1051 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1051,nil)
			pTips = nil
		elseif errorCode == 1055 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1055,nil)
			pTips = nil
		elseif errorCode == 1214 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1617,nil)
			pTips = nil
		elseif errorCode == 1224 then
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("该军团已经申请过", 2)
		elseif errorCode == 1049 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1049,nil)
			pTips = nil
		elseif errorCode == 1063 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1408,nil)
			pTips = nil
		elseif errorCode == 1059 then
			NetWorkLoadingLayer.loadingHideNow()
			local h_hour = math.floor(nTime/3600)
			local m_minute = math.floor(nTime/60) - h_hour*60
			local s_second = nTime - math.floor(nTime/60)*60
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1475,nil,h_hour,m_minute,s_second)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("申请失败，请重试", 2)
		end
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_APPLY,Server_Excute)