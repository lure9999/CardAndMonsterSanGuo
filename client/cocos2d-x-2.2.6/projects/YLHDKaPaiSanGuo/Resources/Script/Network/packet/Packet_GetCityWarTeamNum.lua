--攻城战的列表数量 celina

module("Packet_GetCityWarTeamNum", package.seeall)
--local cjson	= require "json"



local m_funSuccessCallBack = nil
local gTeam = nil
local sNum = 0
local nCountry = nil
function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	--print(PacketData)
	if status == 1 then
		gTeam= pNetStream:Read()
		nCountry = pNetStream:Read()
		sNum = pNetStream:Read()
		AtkCityScene.UpdateTeamNum(gTeam,nCountry,sNum)
	else
		TipLayer.createTimeLayer("服务器数据错误", 2)	
	end
	pNetStream = nil	
end
function GetTeamNum()
	return gTeam,nCountry,sNum
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_LOOK_CITY_CORPS_NUM,Server_Excute)