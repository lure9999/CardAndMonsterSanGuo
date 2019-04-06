-- Filename:network.lua
-- Author: 	qiankun
-- Date: 	2014-05-26
-- Purpose: 网络服务


function LuaNetWorkConect(bRun)
	local function callback()
		local function GetListOver()
			if table.getn(CommonData.g_ServerListTable) <= 0 then
				print("没有服务器列表LuaNetWorkConect")
				--[[TipLayer.createTimeLayer("没有服务器列表", 2)
				return]]--
				StartScene.ReLogin()
			end
			local select_str = CCUserDefault:sharedUserDefault():getStringForKey("server_name") 
			if select_str == "" then
				select_str = CommonData.g_ServerListTable[1]["ServerName"]
			end
			CommonData.g_nCurServerIndex, CommonData.g_nCurServerMapID= LoginLogic.getServerID(select_str)
		
			NetWorkLoadingLayer.loadingHideNow()
			
		end
		Packet_ServerList.SetSuccessCallBack(GetListOver)
		network.NetWorkEvent(Packet_ServerList.CreatPacket())
	end
	network.luaDestroyNetWork()
	
	--TipLayer.createOkTipLayer("network error! please enter OK button to link server again!", callback)
	
	-- 停止心跳
	UnitTime.StopHeart()
	if bRun == false then
		callback()
	else
		StartScene.ReLogin()
	end
	
end
 
function LuaNetWorkerror()

	print("***********LuaNetWorkerror******************")
	local m_nHanderTime = nil
	local function callback( )
		--CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
		local function GetListOver()
			
			print("获得服务器列表GetListOver")
			
			if table.getn(CommonData.g_ServerListTable) <= 0 then
				print("没有服务器列表")
				--[[TipLayer.createTimeLayer("没有服务器列表", 2)
				return]]--
				--直接回登陆界面
				--StartScene.ReLogin()
				return 
			end
			
			local select_str = CCUserDefault:sharedUserDefault():getStringForKey("server_name") 
			if select_str == "" then
				select_str = CommonData.g_ServerListTable[1]["ServerName"]
			end
			
			CommonData.g_nCurServerIndex ,CommonData.g_nCurServerMapID= LoginLogic.getServerID(select_str)
		
			local function linkOver(nTag)
				print("link over")
				NetWorkLoadingLayer.loadingHideNow()
				if nTag == 0 then
					print("==========没有角色==")
				end
				local bMainScene = CCUserDefault:sharedUserDefault():getBoolForKey("isMainScene")
				if bMainScene == false then
					local function FGetPacketOK()
						
						print("不在主场景获得登录包m_Rellink == 0")
						network.SetReLinkState(0)
						network.NetWorkReLink_Packet()
						--切换主场景
						LoginCommon.ShowLoading()
					end
					network.SetReLinkState(0)
					LoginLogic.GetLoginData(FGetPacketOK)
					network.SetReLinkState(1)
				else
					network.SetReLinkState(0)
					print("在主场景不处理m_Rellink == 0")
					network.NetWorkReLink_Packet()
				end
				
			end
			print("FirstLoginLayer.LinkServer")			
			--FirstLoginLayer.LinkServer(linkOver)			
			if CommonData.IsAnySDK() == false then
				LoginLogic.dealLogin_ReLink(linkOver)
			else
				
				local strUserID = nil
				local strChannelID = nil
				if CommonData.g_SDK_UserID == nil then
					strUserID = AnySDKgetUserId()
				else
					strUserID = CommonData.g_SDK_UserID
				end
				
				if CommonData.g_SDK_ChannelId == nil then
					strChannelID = AnySDKgetChannelId()
				else
					strChannelID = CommonData.g_SDK_ChannelId
				end				
				LoginLogic.DealSDKLogin_Again(strUserID,strChannelID)				
			end			
			
		end
		NetWorkLoadingLayer.ClearLoading()
		NetWorkLoadingLayer.loadingShow(true)
		Packet_ServerList.SetSuccessCallBack(GetListOver)
		--Pause()
		print("连接获得服务器列表")
		network.NetWorkEvent_Opt(Packet_ServerList.CreatPacket())
		--Pause()
		
	end
	print("luaDestroyNetWork - 1")	
	network.SetReLinkState(1)
	print("m_Rellink == 1")
	network.luaDestroyNetWork()
	
	-- 停止心跳
	UnitTime.StopHeart()	
	
	--TipLayer.createOkTipLayer("network error! please enter OK button to link server again!", callback)	
	
	--m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callback, 1, false)
	callback()
end

module("network", package.seeall)

--require "Script/Common/Common"
require "Script/Network/packet/PacketManage"

local GSfd = 0
local MSfd = 0
local nInitNetWork = 0

--增加断线重新链接的状态
local m_Rellink = 0
local m_PacketStack = simulationStl.creatStack_First()
function SetReLinkState( iState )
	m_Rellink = iState
end


-- 请求网络事件  
local function GSNetWorkEvent(Packet) 
	
	BeginTime()
	print("GSNetWorkEvent")	
	if nInitNetWork == 0 then
		
		nInitNetWork = InitNetWork()
		print("nInitNetWork = " ..nInitNetWork)
		
	end
	
	if GSfd == 0 then
	
		GSfd= CnnGS(CommonData.g_GSIP, CommonData.g_GSPort)
		
		print("GSfd = " ..GSfd)
		--Pause()
	end	
	
	--printTab(Packet)	
	SendPack(Packet.m_TypeID,Packet.m_LogicID, 0, 0, GSfd, #Packet.m_PacketData, Packet.m_PacketData)
	
	Packet = nil	
	
end  
-- 请求网络事件  
local function MSNetWorkEvent(Packet) 
	BeginTime()
	print("MSNetWorkEvent")	
	if nInitNetWork == 0 then
		print("nInitNetWork = " ..nInitNetWork)
		nInitNetWork = InitNetWork()		
		print("nInitNetWork = " ..nInitNetWork)
	end
	if MSfd == 0 then
		MSfd= CnnMS(CommonData.g_ServerListTable[CommonData.g_nCurServerIndex].ServerIP, CommonData.g_ServerListTable[CommonData.g_nCurServerIndex].ServerPort)
		print("MSfd = " ..MSfd)
	end
	--printTab(Packet)
	--Pause()
	SendPack(Packet.m_TypeID,Packet.m_LogicID, 0, 0, MSfd, #Packet.m_PacketData, Packet.m_PacketData)	
	Packet = nil	

end  
function  luaDestroyNetWork()

	GSfd = 0
	MSfd = 0
	nInitNetWork = 0
	DestroyNetWork()
	--Pause()
end
-- 客户端发网络消息
function NetWorkEvent(Packet)

	if Packet == nil then print("send packet is null") return end
	
	--add by sxin 这里要判断是不是重连中！！！
	if m_Rellink == 1 then
		
		--重连中把包压栈
		print("m_Rellink == 1 PushStack Packet")
		m_PacketStack:PushStack(Packet)
		
	else
		--print("NetWorkEvent_Opt")
		NetWorkEvent_Opt(Packet)
	end
		
end
--执行包子逻辑
function NetWorkEvent_Opt(Packet)
	
	if Packet.m_TypeID == NET_MSG_TYPE_ID.TYPE_C_GS then
		GSNetWorkEvent(Packet)
		return
	end

	if Packet.m_TypeID == NET_MSG_TYPE_ID.TYPE_C_MS then
		MSNetWorkEvent(Packet)
		return
	end

	if Packet.m_TypeID == NET_MSG_TYPE_ID.TYPE_C_BS then
		MSNetWorkEvent(Packet)
		return		
	end
	print("-=-=-")	
	print("send Paket LogicID is error" .. Packet.m_TypeID)
	Pause()			
end

--重连处理堆积的逻辑包
function NetWorkReLink_Packet()

	print("NetWorkReLink_Packet")
	local packet = nil
	while true do
	    packet = m_PacketStack:PopStack()
	    if packet == nil then 		 
			break 	
		else
			print("NetWorkReLink_Packet:NetWorkEvent_Opt")
			--重连后修改新的Token
			local pNetStream = NetStream_Packet(packet)
			pNetStream:RestToken(CommonData.g_szToken)
			NetWorkEvent_Opt(pNetStream:GetPacket())
		end	     
	end
	
end
