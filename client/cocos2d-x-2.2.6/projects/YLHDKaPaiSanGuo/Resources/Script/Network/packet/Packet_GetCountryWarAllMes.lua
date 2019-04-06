module("Packet_GetCountryWarAllMes", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()

	if status == 1 then
		print("Packet_GetCountryWarAllMes")
		require "Script/serverDB/server_CountryWarAllMesDB"
		server_CountryWarAllMesDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then	
			print("初始化所有城市信息开始")
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		print("get CountryWarAllMesDB list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_ALL_CITY_STATE,Server_Excute)