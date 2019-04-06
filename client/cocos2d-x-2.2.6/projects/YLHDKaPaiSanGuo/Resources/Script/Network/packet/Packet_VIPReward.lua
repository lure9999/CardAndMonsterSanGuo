---领取VIP奖励协议
module("Packet_VIPReward",package.seeall)
require "Script/Main/ChargeVIP/ChargeVIPData"
local m_funSuccessCallBack = nil
local nVIPLevel = nil

function CreatePacket(nVIP)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GET_VIP_REWARD)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nVIP)
	nVIPLevel = nVIP
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData)
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorCode = pNetStream:Read()
	if status == 1 then	

		--[[local img_1ID,img_num1,img_2ID,img_num2,img_3ID,img_num3 = ChargeVIPData.GetVIPRewardInfoByVIP(nVIPLevel)
		print(img_1ID,img_num1,img_2ID,img_num2,img_3ID,img_num3)
		Pause()]]--
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		if errorCode == 1010 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1010,nil)
			pTips = nil
		elseif errorCode == 1076 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1076,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("VIP奖励领取失败", 2)
		end
		
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GET_VIP_REWARD,Server_Excute)