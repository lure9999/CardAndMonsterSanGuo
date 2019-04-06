--获得攻城战界面的详细战斗 celina

module("Packet_GetCountryWarFightData", package.seeall)

--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil
--nCityID
function CreatPacket(nCityID,nType)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_CITYPVPINFO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
	pNetStream:Write(nCityID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			if m_funSuccessCallBack ~= nil then
				m_funSuccessCallBack(pNetStream)
				m_funSuccessCallBack = nil
			end
		else
			print("国战场景未开启，不执行GetCountryWarFightData协议")
		end
	else
		NetWorkLoadingLayer.loadingShow(false)
	end 
	
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_CITYPVPINFO_RETURN,Server_Excute)
