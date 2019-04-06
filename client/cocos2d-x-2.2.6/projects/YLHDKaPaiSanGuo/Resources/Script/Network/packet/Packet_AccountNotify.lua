--账号在其他设备登陆等推送 celina

module("Packet_AccountNotify", package.seeall)

--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}


--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local errorID = pNetStream:Read()
	if status == 1 then	
		
	else
		if tonumber(errorID) == 45 then 
			--说明账号在其他设备登陆
			MainScene.DeleteAllObjects()
			print("3=======")
			network.LuaNetWorkConect(true)
			
		end
	end 
	
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_FORCE_OFFLINE,Server_Excute)
