
module("Packet_LoginMS", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	GlobalID 		= 2,
	Token 			= 3,
	DynamicMSID 	= 4,
}

function CreatPacket( )
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_LOGIN)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(CommonData.g_nDynamicMSID)
	
	--[[print("LoginMS")
	print(CommonData.g_nGlobalID)
	print(CommonData.g_szToken)
	print(CommonData.g_nDynamicMSID)
	Pause()]]--
	
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	First			= nil,
}

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.First = pNetStream:Read()
	
	--print("LoginMS"..Return_Cmd.First)
	--Pause()
	if Return_Cmd.status == 1 then
		-- print("LoginMS成功")

		if m_funSuccessCallBack ~= nil then
			--Pause()
			--print("LoginMS成功")
			m_funSuccessCallBack(Return_Cmd.First)
			m_funSuccessCallBack = nil
		end
	elseif Return_Cmd.status ~= 2 then
		Return_Cmd.First = pNetStream:Read()
		print("==============================")
		print(PacketData)
		print("==============================")
		if Return_Cmd.First~=nil and Return_Cmd.First == 45 then
			--说明账号在其他设备登陆
			local pTips = TipCommonLayer.CreateTipLayerManager()
			local function ReLogin()
				if m_funSuccessCallBack ~= nil then
					m_funSuccessCallBack(false)
					m_funSuccessCallBack = nil
				end
			end
			pTips:ShowCommonTips(1484,ReLogin)
			pTips = nil
		else
			TipLayer.createTimeLayer("登陆失败，请重新登陆",2)
			NetWorkLoadingLayer.loadingHideNow()
		end
	else
		TipLayer.createTimeLayer("登陆失败，请重新登陆",2)
		NetWorkLoadingLayer.loadingHideNow()
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_LOGIN_RETURN,Server_Excute)