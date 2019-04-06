
local m_strUpdateVer = nil
local m_strShowText = nil


--local m_strUpdateVer = nil
--local m_strShowText = nil
function SetLoadingInfo(text, nCurCount, nAllCount)
	require "Script/Login/LoadingNewLayer"
	LoadingNewLayer.SetLoadingInfo(text, nCurCount, nAllCount)
end

function ShowDownLoadLayer(nCurSize, nAllSize, nState)
	local pUIScene = CCDirector:sharedDirector():getRunningScene()
	local layerUpdate = pUIScene:getChildByTag(998)
	local function deleteUpdateLayer()
		layerUpdate:removeFromParentAndCleanup(true)
		layerUpdate = nil
	end
	
	if nState == 1 then -- 开始状态
		-- 先关闭联网界面
		-- 显示进度条界面
		print("开始下载")
		--Pause()
		LoadingNewLayer.ToDownLoad()
		
	end
	if nState == 2 then -- 下载状态
		print("下载状态")
		LoadingNewLayer.UpdateProgress(nCurSize,nAllSize)
		
	end

	if nState == 3 then -- 结束状态,没有新版本
		--　获取更新的URL
		print("结束状态")
		local function EnterGame()
			--LoginCommon.handleToMainLayer(deleteUpdateLayer)
			LoadingNewLayer.DeleteUpdateNewLayer()
			local nowVer = CCUserDefault:sharedUserDefault():getStringForKey("g_Version")
			--print(nowVer)
			--Pause()
			LoadingNewLayer.ShowLoading(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_LOAD,nowVer,false)
			--[[require "Script/Login/StartScene"
			StartScene.createStart_SceneUI()]]--
		end
		LoadingNewLayer.DownLoadEnterGame(EnterGame)
		
	end
	if nState == 4 then -- 错误状态, 暂时处理为进入游戏
		--错误退出游戏
		print("出错了退出游戏")
		CCDirector:sharedDirector():endToLua()
		--LoginCommon.handleToMainLayer(deleteUpdateLayer)
		--[[require "Script/Login/StartScene"
		StartScene.createStart_SceneUI()]]--
		-- require "Script/Common/TestServerData"
		-- TestServerData.InitServerData()

		-- require "Script/Login/FirstLoginLayer"
		-- FirstLoginLayer.createLoginUI()
		-- AudioUtil.PlayBtnClick()
	end
end