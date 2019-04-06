
-- add by sxin
CC_PLATFORM_TYPE = {
	CC_PLATFORM_UNKNOWN 		= 0,
	CC_PLATFORM_IOS 			= 1,
	CC_PLATFORM_ANDROID 		= 2,			
	CC_PLATFORM_WIN32 			= 3,			
	CC_PLATFORM_MARMALADE 		= 4,			
	CC_PLATFORM_LINUX 			= 5,			
	CC_PLATFORM_BADA 			= 6,			
	CC_PLATFORM_BLACKBERRY 		= 7,			
	CC_PLATFORM_MAC 			= 8,			
	CC_PLATFORM_NACL 			= 9,			
	CC_PLATFORM_EMSCRIPTEN 		= 10,			
	CC_PLATFORM_TIZEN 			= 11,			
	CC_PLATFORM_WINRT 			= 12,
	CC_PLATFORM_WP8 			= 13,
}

function GetPlatformID()
	local nType = GetPlatform()
	if nType == CC_PLATFORM_TYPE.CC_PLATFORM_WIN32 or nType == CC_PLATFORM_TYPE.CC_PLATFORM_IOS then
		return 1
	end
	if nType == CC_PLATFORM_TYPE.CC_PLATFORM_ANDROID then
		return 2
	end
	
	return 0
end
	
module("StartSceneLogic", package.seeall)

local nInitNetWork = 0
local GSfd = 0
local sVersion = nil
--发FTP的包
local function ToSendPacketFtp()

	local pNetStream = NetStream()
	pNetStream:Write(0)
	pNetStream:Write(4)
	pNetStream:Write(0)
	pNetStream:Write(0)
	local nType = GetPlatformID()
	pNetStream:Write(nType)
	local Packet = pNetStream:GetPacket()
	
	if nInitNetWork == 0 then
		
		nInitNetWork = InitNetWork()
	end
	if GSfd == 0 then
		GSfd= CnnGS(CommonData.g_GSIP, CommonData.g_GSPort)
	end	
	--printTab(Packet)	
	SendPack(Packet.m_TypeID,Packet.m_LogicID, 0, 0, GSfd, #Packet.m_PacketData, Packet.m_PacketData)
end
local function GetFtpUrl()	
	
	-- 显示loading界面
	NetWorkLoadingLayer.loadingShow(true)
	ToSendPacketFtp()
	
end
function CheckBNeedUpdate(m_UIScene)
	require "Script/Login/DownLoadLayer"
	require "Script/Main/Loading/NetWorkLoadingLayer"
	require "Script/Network/packet/NetStream"
	require "Script/Common/CommonData"
	local array_action = CCArray:create()
	array_action:addObject(CCDelayTime:create(0.1))
	array_action:addObject(CCCallFunc:create(GetFtpUrl))
	local actions = CCSequence:create(array_action)
	m_UIScene:runAction(actions)
end
local function copyTab(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = copyTab(v)
        end
    end
    return tab
end
local function ReadJson(nIndex,tab)
	local data = nil
	if type(tab[nIndex]) == "table" then	
		data = copyTab(tab[nIndex])
	else
		data = tab[nIndex]
	end	
	
	return data
end

local function GetSubStr(str,n)
	return str.sub(str,n+1)
end
local function GetBDownLoadVersionNow(sVer)
	local count =0
	local sVersion  = sVer
	local tab = {}
	for sVer in string.gfind(sVer, "|") do
		count = count+1
	end
	for i=1,count do 
		local n = string.find(sVersion,"|")
		local ver1 = string.sub(sVersion,0,n-1)
		local nSize = string.find(ver1,"/")
		local sSize = string.sub(ver1,nSize+1)
		local ver = string.sub(ver1,0,nSize-1)
		if tonumber(ver)> tonumber(CommonData.g_CUR_VERSION) then
			return true
		end
		sVersion = GetSubStr(sVersion,n)
	end
	return false
end
--处理收到包
function DealGetFTP(PacketData)
	NetWorkLoadingLayer.ClearLoading()
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)

	local status = ReadJson(1,pNetStream.m_TableData)
	local list = ReadJson(2,pNetStream.m_TableData)
	
	local tabVersion = ReadJson(3,pNetStream.m_TableData)
	pNetStream = nil
	if status == 1 then
		require "Script/Login/LoadingNewLayer"	
		--这里得到url和版本号
		CommonData.g_szFtpUrl = list
		
		local g_szFtpUrl = list
		if g_szFtpUrl==nil or g_szFtpUrl == ""  then
			print("ftp地址不对")
			--直接进入游戏			
			LoadingNewLayer.ShowLoading(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_LOAD,g_strVersion,false)
		else 
			local g_strVersion = tabVersion[1]--getAllUpdateVersion(g_szFtpUrl .. "/rootver.ini")
			CCUserDefault:sharedUserDefault():setStringForKey("g_Version", g_strVersion)
			if g_strVersion~=""then
				local bUp = GetBDownLoadVersionNow(g_strVersion)
				
				if bUp==false then
					print("没有更新")
					--StartScene.ToStartLogin()
					--进入加载
					LoadingNewLayer.ShowLoading(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_LOAD,g_strVersion,false)
					--[[require "Script/Login/StartScene"
					StartScene.createStart_SceneUI()]]--
				else
					print("进入更新")
					LoadingNewLayer.ShowLoading(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_DOWN_LOAD,g_strVersion,false)
				end
			else	
			
				print("g_strVersion = nil")
				--[[require "Script/Login/StartScene"
				StartScene.createStart_SceneUI()]]--
				LoadingNewLayer.ShowLoading(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_LOAD,g_strVersion,false)
			end
		end
		--外网去掉更新
		--[[require "Script/Login/StartScene"
		StartScene.createStart_SceneUI()]]--
		
		--add by sxin 把网络层删除
		DestroyNetWork()
		
	else
		print("出错")
		
		--Pause()
		--直接退出游戏
		CCDirector:sharedDirector():endToLua()
		--[[require "Script/Login/StartScene"
		StartScene.createStart_SceneUI()]]--
	end
end