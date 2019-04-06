module("Packet_CorpsScienceUp",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket( nCorpsScienceID )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_SCIENCE_UP)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nCorpsScienceID)
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
	local s_type = pNetStream:Read()
	local s_level = pNetStream:Read()
	if status == 1 then
		require "Script/serverDB/server_CorpsScienceUpDB"
		server_CorpsScienceUpDB.SetTableBuffer(PacketData)
		
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		require "Script/Main/Corps/CorpsScienceUp/CorpsScienceData"
		if tonumber(errorCode) == 1220 then
			NetWorkLoadingLayer.loadingHideNow()
			local strScienceName = CorpsScienceData.GetScienceUpFailedName(tonumber(s_type))
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1482,nil,strScienceName,s_level)
			pTips = nil
		elseif tonumber(errorCode) == 1222 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1222,nil)
			pTips = nil
		elseif tonumber(errorCode) == 46 then
			NetWorkLoadingLayer.loadingHideNow()
			TipLayer.createTimeLayer("读取配置表失败", 2)
		else
			NetWorkLoadingLayer.loadingHideNow()
			-- TipLayer.createTimeLayer("科技升级失败，请重试", 2)  46
		end

	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_SCIENCE_UP,Server_Excute)