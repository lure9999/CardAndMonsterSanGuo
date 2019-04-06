--add by sxin 收到服务器列表数据 逻辑处理

module("Packet_ServerList", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_GS)
	pNetStream:Write(C_GS_NET_MSG_ID.C_GS_GETSRVLIST_NEW)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write("0")
	pNetStream:Write(0)
	local nowVer = "1.3"--CCUserDefault:sharedUserDefault():getStringForKey("current-version-code")
	if nowVer== nil or nowVer== ""  then
		pNetStream:Write("0")
	else
		pNetStream:Write(nowVer)
	end
	local nType = GetPlatformID()
	pNetStream:Write(nType)
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
function ServerList_Excute( PacketData )
	-- print("ServerList_Excute")
	--Pause()
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	Return_Cmd.status = pNetStream:Read()
	Return_Cmd.list = pNetStream:Read()
	

	--print("ServerList_Excute")
	--print(PacketData)
	--Pause()
	CommonData.g_ServerListTable = {}
	
	if Return_Cmd.status == 1 then
		-- print("luaDestroyNetWork - 4")
		network.luaDestroyNetWork()

		local Server_Cmd = {
			ServerIP			= 1,
			ServerPort 			= 2,
			ServerName 			= 3,
			MapServerDynamicID 	= 4,
		}
		--[[printTab(Return_Cmd.list)
		Pause()]]--
		if Return_Cmd.list ~= nil then
	   		for key, value in pairs(Return_Cmd.list) do
	   			CommonData.g_ServerListTable[key] = {}
	   			CommonData.g_ServerListTable[key]["ServerIP"] = value[Server_Cmd.ServerIP]
	   			CommonData.g_ServerListTable[key]["ServerPort"] = value[Server_Cmd.ServerPort]
	   			CommonData.g_ServerListTable[key]["ServerName"] = value[Server_Cmd.ServerName]
	   			CommonData.g_ServerListTable[key]["MapServerDynamicID"] = value[Server_Cmd.MapServerDynamicID]
	   		end
		end

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end

	else
		local errorID = Return_Cmd.list
		--print(errorID)
		NetWorkLoadingLayer.loadingHideNow()
		if errorID~=nil then
			if tonumber(errorID) == 1 then
				local function GameOver()
					CCDirector:sharedDirector():endToLua()
				end
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1654,GameOver)
				pTips = nil
			end
			if tonumber(errorID) == 2 then
				local function GameOver()
					CCDirector:sharedDirector():endToLua()
				end
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1656,GameOver)
				pTips = nil
			end
		end
		
				
		
	end
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_GS_C,GS_C_NET_MSG_ID.GS_C_GETSRVLIST_NEW_RETURN,ServerList_Excute)