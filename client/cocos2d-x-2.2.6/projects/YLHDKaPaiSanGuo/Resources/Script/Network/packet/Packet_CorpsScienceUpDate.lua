module("Packet_CorpsScienceUpDate",package.seeall)

local m_funSuccessCallBack = nil

function CreatePacket( nCorpsScienceID )
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CORPS_SCIENCE_UPDATE)
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

function SetSuccessCallBack1( fullCall )
	m_funSuccessCallBack1 = fullCall
end

function SetSuccessCallBack2( fullCall )
	m_funSuccessCallBack2 = fullCall
end

--解析逻辑包
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local erroeCode = pNetStream:Read()
	if status == 1 then
		require "Script/serverDB/server_CorpsScienceUpDate"
		require "Script/serverDB/server_CorpsDonate"
		require "Script/serverDB/server_CorpsHall"
		if tonumber(erroeCode) == 4 then
			server_CorpsHall.SetTableBuffer(PacketData)
			if m_funSuccessCallBack2 ~= nil then
				m_funSuccessCallBack2()
				m_funSuccessCallBack2 = nil
			end
		elseif tonumber(erroeCode) == 5 then
			server_CorpsDonate.SetTableBuffer(PacketData)
			if m_funSuccessCallBack1 ~= nil then
				m_funSuccessCallBack1()
				m_funSuccessCallBack1 = nil
			end
		else
			server_CorpsScienceUpDate.SetTableBuffer(PacketData)
			if m_funSuccessCallBack ~= nil then
				m_funSuccessCallBack()
				m_funSuccessCallBack = nil
			end
		end
		
		
	else
		if erroeCode == 1046 then
			NetWorkLoadingLayer.loadingHideNow()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1046,nil)
			pTips = nil
		else
			NetWorkLoadingLayer.loadingHideNow()
		end
		-- TipLayer.createTimeLayer("科技升级失败，请重试", 2)
		
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_SCIENCE_UPDATE,Server_Excute)