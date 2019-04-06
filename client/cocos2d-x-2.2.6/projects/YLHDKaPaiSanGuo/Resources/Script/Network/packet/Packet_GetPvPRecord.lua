module("Packet_GetPvPRecord", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	old			= 4,
	new			= 5,
}

local m_funSuccessCallBack = nil

function CreatPacket( )
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_PLAY_BACK)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	--pNetStream:Write(nScenceID)
	

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
		--表示有比武数据
		require "Script/serverDB/server_pvpRecordDB"
		server_pvpRecordDB.SetTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then	
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		print("得到PVP记录出错")
		TipLayer.createTimeLayer("服务器数据错误", 2)	
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_PLAY_BACK,Server_Excute)