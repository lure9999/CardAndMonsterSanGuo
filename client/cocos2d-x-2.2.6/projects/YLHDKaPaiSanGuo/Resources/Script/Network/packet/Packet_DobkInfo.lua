module("Packet_DobkInfo", package.seeall)
--local cjson	= require "json"



local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	old			= 4,
	new			= 5,
}

local m_funSuccessCallBack = nil

--type 类型，0神武抢夺，1宝马抢夺
function CreatPacket(nType)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_OPEN_SNATCH )
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(tonumber(nType))

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
		require "Script/serverDB/server_dobkDB"
		server_dobkDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		NetWorkLoadingLayer.loadingHideNow()
		local errorID = pNetStream:Read()
		if errorID~=nil then
			if tonumber(errorID) == 1010 then
				TipLayer.createTimeLayer("等级不足,功能尚未开启",2)
			else
				TipLayer.createTimeLayer("服务器数据错误", 2)	
			end
		end
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_OPEN_SNATCH,Server_Excute)