--获取体力耐力等的更新时间  celina

module("Packet_GetAttrTime", package.seeall)
--local cjson	= require "json"


--nTimeType要显示的时间的类型
local m_funSuccessCallBack = nil
function CreatPacket( nTimeType)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GET_ATTR_TIME)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nTimeType)
	
	return pNetStream:GetPacket()
end

local Return_Cmd = {
	status			= nil,
	nType           = nil,
	nTime           = nil,
}

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	
	if Return_Cmd.status == 1 then
		Return_Cmd.nType = pNetStream:Read()
		Return_Cmd.nTime = pNetStream:Read()
		if m_funSuccessCallBack~=nil then
			m_funSuccessCallBack(Return_Cmd.nTime)
			m_funSuccessCallBack = nil 
		end
	else
		print("服务器返回错误")
		TipLayer.createTimeLayer("获取失败", 2)
		NetWorkLoadingLayer.loadingShow(false)
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GET_ATTR_TIME,Server_Excute)