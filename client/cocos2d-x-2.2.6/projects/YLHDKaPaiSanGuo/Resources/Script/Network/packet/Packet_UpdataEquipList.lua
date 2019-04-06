module("Packet_UpdataEquipList", package.seeall)
--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_UPDATEEQUIPBAG)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)

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
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.list = pNetStream:Read()
	--[[os.execute('mkdir Log')
	
	local f = io.open( "Log/".."update.txt", "w+" )			
	f:write( PacketData )
	f:close() ]]--
	--[[print("Packet_UpdataEquipList")
	print(PacketData)
	Pause()]]--
	if Return_Cmd.status == 1 then
		require "Script/serverDB/server_equipDB"
		server_equipDB.UpdataTableBuffer(PacketData)
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		print("get equip list error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_UPDATEEQUIPBAG_RETURN,Server_Excute)