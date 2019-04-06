module("Packet_GetFuBenInfo", package.seeall)
--local cjson	= require "json"

local m_funNormalSuccessCallBack = nil
local m_funEliteSuccessCallBack = nil
local m_funActivitySuccessCallBack = nil
local m_funClimbingTowerSucessCallBack = nil
function CreatPacket( nType )
	-- print("nType============"..nType)
	-- Pause()
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_FUBENBTNINFO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
	
	print("Packet_GetFuBenInfo")
	return pNetStream:GetPacket()

end

function SetSuccessCallBack(funCall, nType)
	if nType==DungeonsType.Normal then
		m_funNormalSuccessCallBack = funCall
	elseif nType==DungeonsType.Elite then
		m_funEliteSuccessCallBack = funCall
	elseif nType==DungeonsType.Activity then
		m_funActivitySuccessCallBack = funCall
	elseif nType==DungeonsType.ClimbingTower then
		m_funClimbingTowerSucessCallBack = funCall
	end
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local nState = pNetStream:Read()

	if nState == 1 then
		require "Script/serverDB/server_fubenDB"
		server_fubenDB.SetTableBuffer(PacketData)
  		local nType = pNetStream:Read()
		if nType==DungeonsType.Normal then
			if m_funNormalSuccessCallBack ~= nil then
				m_funNormalSuccessCallBack(MS_C_NET_MSG_ID.MS_C_FUBENBTNINFO_RETURN,nType)
				m_funNormalSuccessCallBack = nil
			end
		elseif nType==DungeonsType.Elite then
			if m_funEliteSuccessCallBack ~= nil then
				m_funEliteSuccessCallBack(MS_C_NET_MSG_ID.MS_C_FUBENBTNINFO_RETURN,nType)
				m_funEliteSuccessCallBack = nil
			end
		elseif nType==DungeonsType.Activity then
			if m_funActivitySuccessCallBack ~= nil then
				m_funActivitySuccessCallBack(MS_C_NET_MSG_ID.MS_C_FUBENBTNINFO_RETURN,nType)
				m_funActivitySuccessCallBack = nil
			end
		elseif nType== DungeonsType.ClimbingTower then
			if m_funClimbingTowerSucessCallBack ~= nil then
				m_funClimbingTowerSucessCallBack()
				m_funClimbingTowerSucessCallBack = nil
			end
		end
	else
		print("Get Fuben  error the status is 0")
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_FUBENBTNINFO_RETURN,Server_Excute)