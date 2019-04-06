--获得迷雾战的时候武将的数据 celina


module("Packet_GetFogWarTeam", package.seeall)
--local cjson	= require "json"



local m_funSuccessCallBack = nil
local m_listWJ = nil

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		--local 
		m_listWJ = pNetStream:Read()
	else
		--NetWorkLoadingLayer.loadingShow(false)
		TipLayer.createTimeLayer("服务器数据错误", 2)	
		
	end
	pNetStream = nil	
end
function GetWJFogData()
	print("获得的迷雾的数据")
	printTab(m_listWJ)
	return m_listWJ
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_IN_FOG_CORPS_INDEX,Server_Excute)