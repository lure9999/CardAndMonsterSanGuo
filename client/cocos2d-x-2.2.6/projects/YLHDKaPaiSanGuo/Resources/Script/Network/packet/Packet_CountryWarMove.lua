module("Packet_CountryWarMove", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local Server_Cmd = {
	TeamID  = 1,
	CanMove = 2,
}

local m_funSuccessCallBack_1 = nil
local m_funSuccessCallBack_2 = nil
local m_funSuccessCallBack_3 = nil
local m_funSuccessCallBack_4 = nil

function CreatPacket(nTeamID, nActType, nRoadNum, nRoadCityTab)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_MOVE)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nTeamID)
	pNetStream:Write(nActType)
	pNetStream:Write(nRoadNum)
	pNetStream:Write(nRoadCityTab)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall, nType)
	if nType == PlayerType.E_PlayerType_Main then
		m_funSuccessCallBack_1 = funCall
	elseif nType == PlayerType.E_PlayerType_1 then
		m_funSuccessCallBack_2 = funCall
	elseif nType == PlayerType.E_PlayerType_2 then
		m_funSuccessCallBack_3 = funCall
	elseif nType == PlayerType.E_PlayerType_3 then
		m_funSuccessCallBack_4 = funCall
	end
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	if status == 1 then
		if tonumber(list[Server_Cmd.CanMove]) == 1 then
			if tonumber(list[Server_Cmd.TeamID]) == PlayerType.E_PlayerType_Main - 1 and m_funSuccessCallBack_1 ~= nil then
				m_funSuccessCallBack_1()
				print("-------------------主将移动了")
				m_funSuccessCallBack_1 = nil
			elseif tonumber(list[Server_Cmd.TeamID]) == PlayerType.E_PlayerType_1 - 1 and m_funSuccessCallBack_2 ~= nil then
				m_funSuccessCallBack_2()
				print("--------------------队伍1移动了")
				m_funSuccessCallBack_2 = nil
			elseif tonumber(list[Server_Cmd.TeamID]) == PlayerType.E_PlayerType_2 - 1 and m_funSuccessCallBack_3 ~= nil then
				m_funSuccessCallBack_3()
				print("--------------------队伍2移动了")
				m_funSuccessCallBack_3 = nil
			elseif tonumber(list[Server_Cmd.TeamID]) == PlayerType.E_PlayerType_3 - 1 and m_funSuccessCallBack_4 ~= nil then
				m_funSuccessCallBack_4()
				print("--------------------队伍3移动了")
				m_funSuccessCallBack_4 = nil
			end
		end
	else
		print("move list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_MOVE_RESULT,Server_Excute)