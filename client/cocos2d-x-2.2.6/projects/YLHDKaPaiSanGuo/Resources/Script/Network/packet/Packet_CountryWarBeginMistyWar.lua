module("Packet_CountryWarBeginMistyWar", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

function CreatePacket( nFogIndex, nTeamNum, nTeamTab)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_CORPS_START_FOG_WAR)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nFogIndex)
	pNetStream:Write(nTeamNum)
	pNetStream:Write(nTeamTab)

	return pNetStream:GetPacket()
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local result = pNetStream:Read()  		--结果

	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			if m_funSuccessCallBack ~= nil then
				m_funSuccessCallBack(tonumber(result))
				m_funSuccessCallBack = nil
			end
		end
	else
		print("error to attack misty city")
	end
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CORPS_START_FOG_WAR_RETURN,Server_Excute)