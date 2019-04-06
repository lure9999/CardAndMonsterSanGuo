module("Packet_MainStay_ChangeJob", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket(nGrid, nGeneralID)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_MAINSTAY_CHANGEJOP)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)		-- 主将格子
	pNetStream:Write(nGeneralID)		-- 需要转职的武将模板ID
	return pNetStream:GetPacket()

end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	list 			= nil,
}

--解析包逻辑
function Server_Excute( PacketData )
	BeginTime()
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.list = pNetStream:Read()
	EndTime()
	-- print("Packet_MainStay_ChangeJob")
	-- print(PacketData)
		   	
	if Return_Cmd.status == 1 then

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		
	end
	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_MAINSTAY_CHANGEJOP_RETURN,Server_Excute)