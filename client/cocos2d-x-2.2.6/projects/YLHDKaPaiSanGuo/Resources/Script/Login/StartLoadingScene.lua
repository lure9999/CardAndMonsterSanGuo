
--游戏一开始loading的场景 celina

function __G__TRACKBACK__(msg)
   	
	print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
	
   -- local function OKCallback()
    	--CCDirector:sharedDirector():endToLua()
  --  end
	Pause()
	--require "Script/Common/TipLayer"
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
	
end
-- 请求网络事件回调函数借口 接收网络数据
function luarecv(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
	if LogicID == 4 and TypeID == 1 then
		
		StartSceneLogic.DealGetFTP(PacketData)
	else	
		--require "Script/Network/packet/PacketManage"
		require "Script/Login/StartScene"
		PacketManage.luarecv_org(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
		--StartScene.DealNetWork(TypeID, LogicID, Ex_Id01, Ex_Id02, nSocket, nLen, PacketData)
	end
	
end
function EditChangeGsIP( GsIP)	
	require "Script/Common/Common"
	CommonData.g_GSIP = GsIP
end
function EditChangeSize()		
	CommonData.g_Origin = CCDirector:sharedDirector():getVisibleOrigin()
	CommonData.g_sizeVisibleSize = CCEGLView:sharedOpenGLView():getVisibleSize()
	CommonData.g_Origin = CCDirector:sharedDirector():getVisibleOrigin()
	CommonData.g_fScreenScale = (CommonData.g_sizeVisibleSize.width/CommonData.g_sizeVisibleSize.height)/(CommonData.g_nDeginSize_Width/CommonData.g_nDeginSize_Height)
end

--anysdk接口
function AnySDKLogin_Success(userID,ChannelId)

	-- 赵燕对接下给服务器发登陆包 应该只需要发UserID,ChannelID
	print("AnySDKLogin_Success")	
	print(userID)
	print(ChannelId)
	CommonData.g_SDK_UserID = userID
	CommonData.g_SDK_ChannelId = ChannelId
	LoginLogic.DealSDKLogin(userID,ChannelId)	
end

function AnySDKInit_Success()	
	print("AnySDKInit_Success")	
end

function AnySDKonRequestResult()	
	print("AnySDKonRequestResult")	
end

function AnySDKonPayResult_Success()	
	print("AnySDKonPayResult_Success")	
end


require "Script/Login/StartSceneLogic"
module("StartLoadingScene", package.seeall)

--场景对象
local m_LoadingScene = nil



SCENE_TAG = {
	SCENE_ENTER = "enter",
	SCENE_ENTERTRANSITIONFINISH  = "enterTransitionFinish",
	SCENE_EXIT  = "exit",
	SCENE_EXITTRANSITIONSTART = "exitTransitionStart",
	SCENE_CLEANUP = "cleanup"
}
local function SceneDeal()
	local m_nHanderTime = nil
	local function NetUpdata(dt)
		UpNetWork()
	end	
	
		
	local function SceneEvent(tag)
		if tag == SCENE_TAG.SCENE_ENTER then
			StartSceneLogic.CheckBNeedUpdate(m_LoadingScene)
			m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, 0.1, false)	
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
	m_LoadingScene:registerScriptHandler(SceneEvent)
end
local function createStartLoading_SceneUI()
	m_LoadingScene = CCScene:create()
	local scene_node  = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_denglu.json")--CCScene:create()	
	m_LoadingScene:addChild(scene_node, 0, 1)
    CCDirector:sharedDirector():runWithScene(m_LoadingScene)
	SceneDeal()
end
local function LoadingMain()
		
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 1000)
	
    local cclog = function(...)
        print(string.format(...))
    end
	print("LoadingMain")
    ---------------
	-- 测试代码
	--
	require "Script/test/TestEngineLayer"
	if TestEngineLayer.TestEngine() == true then 		
		return
	end
	--
	
	createStartLoading_SceneUI()
	
end

function GetScene()
	return m_LoadingScene
end


xpcall(LoadingMain, __G__TRACKBACK__)