module("Packet_CountryWarStopHighOrder", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

function CreatPacket( nType, nTagID, nTeamNum, nTab)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_PLAYER_BLOOD)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
	pNetStream:Write(nTagID)
	pNetStream:Write(nTeamNum)
	pNetStream:Write(nTab)

	return pNetStream:GetPacket()
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local isAct  = pNetStream:Read()
	local isSuccess = pNetStream:Read()
	local pResultDB = pNetStream:Read()

	if status == 1 then
		if tonumber(isAct) == 1 then
			if m_funSuccessCallBack ~= nil then
				m_funSuccessCallBack(isSuccess)
				m_funSuccessCallBack = nil
			end
		else
			require "Script/serverDB/server_BloorOrDefenseResultDB"
			server_BloorOrDefenseResultDB.SetTableBuffer( PacketData )
			require "Script/Main/CountryWar/CountryWarScene"
			require "Script/Main/CountryWar/CountryChildLayer"
			CountryWarScene.StopActType()
			CountryChildLayer.RefreshOverUI()
			CountryWarScene.OpenBloodOrDefenseRewardUI()
		end
	else
		print("error to stop blood war")
	end
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_PLAYER_BLOOD_RETURN,Server_Excute)