
module("Packet_LoginGS", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	username 		= 2,
	password 		= 3,
}

local  getUserName  = LoginLogic.GetUserName
local  getPassdWord = LoginLogic.GetPassWord
local  saveUserInfo = LoginLogic.SaveUserInfo
local  GetDynamicID = LoginLogic.GetDynamicID

function CreatPacket( )

	local UserName = getUserName()
	local PassdWord = getPassdWord()
	local DynamicID = GetDynamicID()
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_GS)
	pNetStream:Write(C_GS_NET_MSG_ID.C_GS_LOGIN)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write("0")
	pNetStream:Write(0)
	pNetStream:Write(UserName)
	pNetStream:Write(PassdWord)
	pNetStream:Write(DynamicID)
	local nowVer = "1.3"--CCUserDefault:sharedUserDefault():getStringForKey("current-version-code")
	if nowVer== nil or nowVer== ""  then
		pNetStream:Write("0")
	else
		pNetStream:Write(nowVer)
	end
	local nType = GetPlatformID()
	pNetStream:Write(nType)
	print("Packet_LoginGS")
	print(UserName)
	print(PassdWord)
	print(DynamicID)
	
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	
	m_funSuccessCallBack = funCall
end

local Return_Cmd = {
	status			= nil,
	GlobalID 		= nil,
	Type 			= nil,
	First 			= nil,
	Token 			= nil,
	DynamicGSID 	= nil,
}

--解析包逻辑
function Server_Excute( PacketData )
	
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.GlobalID = pNetStream:Read()
	Return_Cmd.Type = pNetStream:Read()
	Return_Cmd.First = pNetStream:Read()
	Return_Cmd.Token = pNetStream:Read()
	Return_Cmd.DynamicGSID = pNetStream:Read()
	
	
	if Return_Cmd.status == 1 then
		CommonData.g_nGlobalID    = Return_Cmd.GlobalID
		--Pause()
		CommonData.g_szToken	  = Return_Cmd.Token
		--print("CommonData.g_szToken"..CommonData.g_szToken)
		--Pause()
		CommonData.g_nDynamicGSID = Return_Cmd.DynamicGSID
		if m_funSuccessCallBack ~= nil then
			
			m_funSuccessCallBack(true)
			m_funSuccessCallBack = nil
		end

	else
		
		if Return_Cmd.GlobalID~=nil  then
			if Return_Cmd.GlobalID == 45 then
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
			end
			if Return_Cmd.GlobalID == 1001 then
				--密码错误
				TipLayer.createTimeLayer("密码错误",2)
				NetWorkLoadingLayer.loadingHideNow()
			end
			if Return_Cmd.GlobalID == 1002 then
				--账户名错误
				TipLayer.createTimeLayer("账号名错误",2)
				NetWorkLoadingLayer.loadingHideNow()
			end
			if Return_Cmd.GlobalID == 1028 then
				local function GameOver()
					CCDirector:sharedDirector():endToLua()
				end
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1656,GameOver)
				pTips = nil
			end
		else
			print("登陆失败")
			TipLayer.createTimeLayer("登陆失败，请重新登陆",2)
			NetWorkLoadingLayer.loadingHideNow()
			--[[if m_funSuccessCallBack ~= nil then
				
				m_funSuccessCallBack(false)
				m_funSuccessCallBack = nil
			end]]--
		end
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_GS_C,GS_C_NET_MSG_ID.GS_C_LOGIN_RETURN,Server_Excute)