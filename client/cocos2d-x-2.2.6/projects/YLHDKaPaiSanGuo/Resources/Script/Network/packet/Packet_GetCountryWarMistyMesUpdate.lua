module("Packet_GetCountryWarMistyMesUpdate", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil
--[[
function CreatPacket()

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(MS_C_NET_MSG_ID.MS_C_MAIL_NEW)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end
--]]

local Data_Cmd = {
	FogIndex 			=	1,
	Index 				=	2,
	Num 				=	3,
	Hp 					=	4,
}

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status 	= pNetStream:Read()
	local list      = pNetStream:Read()
	local nFogIndex = list[Data_Cmd.FogIndex]
	local nIndex 	= list[Data_Cmd.Index]   -- -1表示迷雾已清除
	local nTeamNum  = list[Data_Cmd.Num]   -- 守军波数
	local nHp 		= list[Data_Cmd.Hp]   -- 守军数量

	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			require "Script/Main/CountryWar/CountryWarScene"
			CountryWarScene.MistyCityUpdate(tonumber(nFogIndex), tonumber(nIndex), tonumber(nTeamNum), tonumber(nHp))
		end
		--require "Script/serverDB/server_CountryWarMistyMesDB"
		--server_CountryWarMistyMesDB.SetTableBuffer(PacketData)
		--if m_funSuccessCallBack ~= nil then
		--	m_funSuccessCallBack()
		--	m_funSuccessCallBack = nil
		--end
	else
		print("get Packet_GetCountryWarMistyMesUpdate list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_FOG_STATUS_CHAGE,Server_Excute)