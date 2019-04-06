module("Packet_GetPvpInfo", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	old			= 4,
	new			= 5,
}

local m_funSuccessCallBack = nil

function CreatPacket(nScenceID, nIndexID,pID,nRank)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_PVPINFO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nScenceID)
	pNetStream:Write(nIndexID)
	
	pNetStream:Write(pID)
	pNetStream:Write(nRank)
	--pNetStream:Write(MAPID)
	--pNetStream:Write(fGlobalID)
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	--FileStrprint("pvps",PacketData)
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	--[[printTab(pNetStream)
	Pause()]]--
	if status == 1 then
		--print(PacketData)
		--printTab(pNetStream)
		--Pause()
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(pNetStream)
			m_funSuccessCallBack = nil
		end
	else
		local errID = pNetStream:Read()
		if errID==nil then
			TipLayer.createTimeLayer("服务器数据错误", 2)	
			return
		end
		if errID~=0 then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(errID,nil)
			pTips = nil
		else
			TipLayer.createTimeLayer("服务器数据错误", 2)	
		end
		
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(false)
			m_funSuccessCallBack = nil
		end
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_PVPINFO_RETURN,Server_Excute)