module("Packet_CreateCorps",package.seeall)
require "Script/Main/Corps/CorpsData"
local m_funSuccessCallBack = nil

--名称 军旗ID 国家ID
function CreatePacket(name, FlagID, CountryID)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_CREATE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(name)
	pNetStream:Write(FlagID)
	pNetStream:Write(CountryID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack( funCall )
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	local nTime = pNetStream:Read()
	if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		if tonumber(errorCode) == 1058 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1058,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1023 then
			NetWorkLoadingLayer.loadingHideNow()
			local c_name = CorpsData.GetCreateCorpsConsumName()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(113,nil,c_name)
			pTips = nil
		elseif tonumber(errorCode) ==1072 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1072,nil)
			pTips = nil
		elseif tonumber(errorCode) ==1005 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1611,nil)
			pTips = nil
		elseif tonumber(errorCode) ==1041 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1041,nil)
			pTips = nil
		elseif tonumber(errorCode) == 1059 then
			NetWorkLoadingLayer.loadingHideNow()
			local h_hour = math.floor(nTime/3600)
			local m_minute = math.floor(nTime/60) - h_hour*60
			local s_second = nTime - math.floor(nTime/60)*60
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1475,nil,h_hour,m_minute,s_second)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("创建军团失败,请重试", 2)
		end

		
	end
	pNetStream = nil

end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_CREATE,Server_Excute)