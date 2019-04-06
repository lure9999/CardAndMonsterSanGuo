module("Packet_RandName", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

function CreatPacket(nSex)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_RANDNAME)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nSex)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	Name 			= nil,
	NameCode		= nil,
	--NLast         = nil ,
	NCountry = nil,
	
}
local NFightWei = nil
local NFightShu = nil
local NFightWu = nil

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.Name = pNetStream:Read()
	Return_Cmd.NameCode = pNetStream:Read()
	--Return_Cmd.NLast = pNetStream:Read()
	Return_Cmd.NCountry = pNetStream:Read()
	NFightWei = pNetStream:Read()
	NFightShu = pNetStream:Read()
	NFightWu = pNetStream:Read()
	pNetStream = nil
		   
	print("Packet_RandName")
	
	if Return_Cmd.status == 1 then	
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(Return_Cmd.Name, Return_Cmd.NameCode,Return_Cmd.NCountry)
			m_funSuccessCallBack = nil
		end	
	
	end
		
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_RANDNAME_RETURN,Server_Excute)