--[[function __G__TRACKBACK__(msg)
   	
	print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
	
   -- local function OKCallback()
    	--CCDirector:sharedDirector():endToLua()
  --  end
	Pause()
	require "Script/Common/TipLayer"
   -- TipLayer.createOkTipLayer("程序出错，请点击确定重新启动游戏，点击关闭不重新启动游戏。", OKCallback)
    print("----------------------------------------")	
	FileLog_traceback_Msg(msg)
	
	CCDirector:sharedDirector():endToLua()
end

function FileLog_traceback_Msg(Msg)

	print("LUA ERROR: " .. tostring(msg) .. "\n")
	local Text = "----------------------------------------\n" .. "LUA ERROR: " .. tostring(msg) .. "\n" .. debug.traceback() .. "\n----------------------------------------\n"
	os.execute('mkdir Log')
	local f = io.open( "Log/".."traceback_Msg.txt", "a+" )		
	f:write( Text )
	f:close() 
	
end

function Pausetraceback()

	print("\n LUA traceback begin: ---------------------------------------\n" )
	print(debug.traceback())
	print("\n LUA traceback end: -----------------------------------------\n" )
	Pause() 
	
end]]--


--给编辑器用
--[[function EditChangeSize()		
	CommonData.g_Origin = CCDirector:sharedDirector():getVisibleOrigin()
	CommonData.g_sizeVisibleSize = CCEGLView:sharedOpenGLView():getVisibleSize()
	CommonData.g_Origin = CCDirector:sharedDirector():getVisibleOrigin()
	CommonData.g_fScreenScale = (CommonData.g_sizeVisibleSize.width/CommonData.g_sizeVisibleSize.height)/(CommonData.g_nDeginSize_Width/CommonData.g_nDeginSize_Height)
end]]--

--[[function EditChangeGsIP( GsIP)	
	require "Script/Common/Common"
	CommonData.g_GSIP = GsIP
end]]--
--end
-- 这个脚本主要检查是否有更新，如果有刚下载下来。完成后显示登陆界面。
--创建界面
--require "Script/Network/network"
--require "Script/Network/network"
--require "Script/Common/Common"
--require "Script/Main/MainScene"
--require "Script/Audio/AudioUtil"
--require "Script/Login/LoginLayer"
--require "Script/Login/AutoUpdateLayer"
--require "Script/Login/DownLoadLayer"
--require "Script/Login/CreateRoleScene"
--require "Script/test/TestEngineLayer"
--------change by celina 0129-------
--require "Script/Login/StartSceneLogic"
----*进游戏之前的场景创建-----------
-- 请求网络事件回调函数借口 接收网络数据
--[[function luarecv(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
	if LogicID == 4 and TypeID == 1 then
		
		StartSceneLogic.DealGetFTP(PacketData)
	else	
		--require "Script/Network/packet/PacketManage"
		PacketManage.luarecv_org(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
	end
	
end]]--

module("StartScene", package.seeall)


SCENE_TAG = {
	SCENE_ENTER = "enter",
	SCENE_ENTERTRANSITIONFINISH  = "enterTransitionFinish",
	SCENE_EXIT  = "exit",
	SCENE_EXITTRANSITIONSTART = "exitTransitionStart",
	SCENE_CLEANUP = "cleanup"
}

LAYER_TAG = 100
--场景对象
local m_UIScene = nil

--layer 层
local createLayer = nil --LoginLayer.createLoginLayer--AutoUpdateLayer.createAutoUpdateLayer
local deleteLayer = nil --LoginLayer.deleteLayer

--网络的loading
local loadingLayerShow = nil --NetWorkLoadingLayer.loadingShow
local loadingLayerHide = nil --NetWorkLoadingLayer.loadingHideNow

local bPopScene = false 
local bRelogin = false --重新登陆


function SetPopScene(bPop)
	bPopScene = bPop
end


function changeScene()
	
	MainScene.createMainUI()
	if NETWORKENABLE > 0 then
		UnitTime.LoginMSOver()
	end
end

function changeCreateRoleScene()
	CreateRoleScene.createRoleUI()
end

--[[function changeLayer(nLayer)
	if m_UIScene:getChildByTag(LAYER_TAG) ~=nil then
		m_UIScene:getChildByTag(LAYER_TAG):setVisible(false)
		m_UIScene:getChildByTag(LAYER_TAG):removeFromParentAndCleanup(true)
	end
	m_UIScene:addChild(nLayer,LAYER_TAG,LAYER_TAG)
end]]--
local function showLogin()
	local layer_login = createLayer()
	
	if m_UIScene:getChildByTag(LAYER_TAG) ~=nil then
		deleteLayer()
	end
	m_UIScene:addChild(layer_login,LAYER_TAG,LAYER_TAG)
end


--创建主场景
local function createStart_Scene()
	
	createLayer = LoginLayer.createLoginLayer--AutoUpdateLayer.createAutoUpdateLayer
	deleteLayer = LoginLayer.deleteLayer

	--网络的loading
	loadingLayerShow = NetWorkLoadingLayer.loadingShow
	loadingLayerHide = NetWorkLoadingLayer.loadingHideNow
	NETWORKENABLE = 1
	--connectNetWork()
	--if CheckSDKLogin()==1 then
		--走的SDK的登陆
		
	--else
		--Pause()
		--showLogin()
		
	--end
	if CommonData.IsAnySDK() == false then
		showLogin()
	else
		AnySDKLogin()
	end
	
end
--[[local pLoadLua = nil

local tab = {
	
	"Script/Login/DownLoadLayer",
	"Script/Login/LoadingNewLayer",
	"Script/Common/Common",
	"Script/Login/LoginLayer",
	--"Script/Login/AutoUpdateLayer",
	"Script/Network/network",
	"Script/Audio/AudioUtil",
	"Script/Login/CreateRoleScene",
	"Script/test/TestEngineLayer",
	"Script/Network/packet/PacketNewRequire",
}
local function send(x)
	coroutine.yield(x)
end
local function ReLoad()
	local i=0
	while i<9 do 
		i=i+1
		local s = require (tab[i])
		send(i)
	end
end
local function receive()
	local status,value = coroutine.resume(pLoadLua)
	return value
end]]--
local function CheckSoundOpen()
	AudioUtil.initAudioInfo()
	if(CCUserDefault:sharedUserDefault():getBoolForKey("m_isBgmOpen")==false)then
		AudioUtil.muteBgm()
	
	end
	if (CCUserDefault:sharedUserDefault():getBoolForKey("m_isSoundEffectOpen")==false)then
		AudioUtil.muteSoundEffect()
		
	end	
end
--[[local function Consumer(start,endNum)
	
	for i=start,endNum do 
		local i = receive()
		if i==endNum then
			CheckSoundOpen()
			createStart_Scene()
		end
	end
end]]--
local function ReLoginDeal()
	CheckSoundOpen()
	createLayer = LoginLayer.createLoginLayer--AutoUpdateLayer.createAutoUpdateLayer
	deleteLayer = LoginLayer.deleteLayer

	--网络的loading
	loadingLayerShow = NetWorkLoadingLayer.loadingShow
	loadingLayerHide = NetWorkLoadingLayer.loadingHideNow
	
	local function EnterLogin()
		showLogin()
	end
	local pTips = TipCommonLayer.CreateTipLayerManager()
	pTips:ShowCommonTips(1483,EnterLogin)
	pTips = nil
	
end

local function SceneDeal()
	--local m_nHanderTime = nil
	local function NetUpdata(dt)
		UpNetWork()
	end	
	
	--[[local function LoadUpdata(dt)		
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
		pLoadLua = coroutine.create(ReLoad)
		Consumer(1,9)
	end]]--
		
	local function SceneEvent(tag)
		if tag == SCENE_TAG.SCENE_ENTER then
			if bPopScene == false then
				--m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(LoadUpdata, 0.001, false)
				CheckSoundOpen()
				createStart_Scene()
			else
				if CommonData.IsAnySDK() == false then
					if bRelogin == true then
						ReLoginDeal()
					else
						LoginLayer.SetEnterTouch()
						AccountLoginLayer.SetEnterGame(true)
					end
				else
					createStart_Scene()
				end
				m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, CommonData.g_nNetUpdataTime, false)	
			end
		end

		if tag == SCENE_TAG.SCENE_ENTERTRANSITIONFINISH then	
		end	

		if tag == SCENE_TAG.SCENE_EXIT then	
			--CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
			
		end	

		if tag == SCENE_TAG.SCENE_EXITTRANSITIONSTART then		
		end	

		if tag == SCENE_TAG.SCENE_CLEANUP then		
		end	
	end
	m_UIScene:registerScriptHandler(SceneEvent)
end




function createStart_SceneUI()
	
	m_UIScene = CCScene:create()
	local scene_node  = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_denglu.json")--CCScene:create()	
	m_UIScene:addChild(scene_node, 0, 1)
    --CCDirector:sharedDirector():runWithScene(m_UIScene)
	
	SceneDeal()
	CCDirector:sharedDirector():replaceScene(m_UIScene)
	--connectNetWork()
end

function ReLogin()
	m_UIScene = CCScene:create()
	local scene_node  = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_denglu.json")--CCScene:create()	
	m_UIScene:addChild(scene_node, 0, 1)
	bPopScene = true 
	bRelogin = true
	
	CCDirector:sharedDirector():replaceScene(m_UIScene)
	--bPopScene = false 
	SceneDeal()
end

--[[local function main()
		
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 1000)
	
    local cclog = function(...)
        print(string.format(...))
    end
    ---------------
	-- 测试代码
	--
	require "Script/test/TestEngineLayer"
	if TestEngineLayer.TestEngine() == true then 		
		return
	end
	--
	createStart_SceneUI()
	
end

xpcall(main, __G__TRACKBACK__)]]--
