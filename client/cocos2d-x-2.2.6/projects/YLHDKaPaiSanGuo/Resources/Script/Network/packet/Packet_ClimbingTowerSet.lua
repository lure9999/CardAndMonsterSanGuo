module("Packet_ClimbingTowerSet", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local EClimbingTowerCMD = {
    ClimbingTower_CMD_Reset                 = 0,
    ClimbingTower_CMD_StarMopUp             = 1,
    ClimbingTower_CMD_EndMopUp            	= 2,  
    ClimbingTower_CMD_ConsumptionEndMop		= 3,  
}

local m_funSuccessCallBack = nil

function CreatPacket(ServerCmd)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CLIMBINGTOWERSET)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(ServerCmd)

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
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		print("send pata  error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CLIMBINGTOWERSET_RETURN,Server_Excute)