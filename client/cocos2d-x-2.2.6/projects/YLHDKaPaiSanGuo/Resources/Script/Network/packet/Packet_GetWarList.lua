--获得攻城战界面的详细战队信息 celina

module("Packet_GetWarList", package.seeall)

--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil
--nType ==1 表示城市观战，2表示迷雾,nTeamType, 1表示攻方，2表示守方,nPage,当前的页号，从1开始
function CreatPacket(nType,nTeamType,nPage)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_LOOK_CITY_CORPSLIST)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
	pNetStream:Write(nTeamType)
	pNetStream:Write(nPage)
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
		require "Script/serverDB/server_getWarList"
		server_getWarList.SetTableBuffer(PacketData)
		if m_funSuccessCallBack~=nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	elseif status == 0 then
		print("战斗已经结束")
	else
		--服务器数据出错
		print("获得攻城战列表信息出错")
	
	end 
	
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_LOOK_CITY_CORPSLIST_RETURN,Server_Excute)
