module("Packet_CorpsApplyOperator",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket( nUserId, nIsAgree )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_APPLY_OPERATOR)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nUserId)
	pNetStream:Write(nIsAgree)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack( fullCall )
	m_funSuccessCallBack = fullCall
end

function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
		require "Script/serverDB/server_mainDB"
		require "Script/Main/MainScene"
		local nCorpsId = tonumber(server_mainDB.getMainData("nCorps"))
		if nCorpsId > 0 then
			--TipLayer.createTimeLayer("已经有军团", 2)
		else
			--MainScene.createMainUI()
		end

	else
		local errorCode = pNetStream:Read()
		if errorCode == 1055 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1055,nil)
			pTips = nil
		else
			print("3...")
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("军团长处理申请操作失败", 2)
		end
		
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_APPLY_OPERATOR,Server_Excute)