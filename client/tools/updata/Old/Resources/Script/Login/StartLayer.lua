-- 这个脚本主要检查是否有更新，如果有刚下载下来。完成后显示登陆界面。
function __G__TRACKBACK__(msg)
    Log("----------------------------------------")
    Log("LUA ERROR: " .. tostring(msg) .. "\n")
    Log(debug.traceback())
    Log("----------------------------------------")
end

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

local visibleSize = CCDirector:sharedDirector():getVisibleSize()
local origin = CCDirector:sharedDirector():getVisibleOrigin()
local m_UIScene = nil

function SetLoadingInfo(text, nCurCount, nAllCount)
	require "Script/Login/LoginLayer"
	LoginLayer.SetLoadingInfo(text, nCurCount, nAllCount)
end

function ShowDownLoadLayer(nCurSize, nAllSize, nState)
	local layerStart = m_UIScene:getChildByTag(layerStart_Tag)
	
	if nState == 1 then -- 开始状态
		-- 先关闭联网界面
		
		-- 显示进度条界面
		local Image_Pro_Bk = tolua.cast(layerStart:getWidgetByName("Image_Pro_Bk"), "ImageView")
		Image_Pro_Bk:setVisible(true)
	
	end
	if nState == 2 then -- 下载状态
		-- 计算进度条
		local ProgressBar_Down = tolua.cast(layerStart:getWidgetByName("ProgressBar_Down"), "LoadingBar")
		local per = nCurSize/nAllSize
		per = per*100
		ProgressBar_Down:setPercent(per)
		
		local Image_Sword = tolua.cast(layerStart:getWidgetByName("Image_Sword"), "ImageView")
		local xPt = -240+(480/100)*per
		Image_Sword:setPosition(ccp(xPt, Image_Sword:getPositionY()))
	end
	
	if nState == 3 then -- 结束状态
		-- 关闭进度条界面
		local Image_Pro_Bk = tolua.cast(layerStart:getWidgetByName("Image_Pro_Bk"), "ImageView")
		Image_Pro_Bk:setVisible(false)
		
		-- 显示进入游戏按扭
		local Button_Enter = tolua.cast(layerStart:getWidgetByName("Button_Enter"), "Button")
		Button_Enter:setVisible(true) 
	end
	if nState == 4 then -- 错误状态
	end
end


--创建登陆主界面
local function createStart_Layer()
	m_UIScene = CCScene:create()	
	
	local layerStart = TouchGroup:create()									-- 背景层
    layerStart:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/StartLayer.json") )
	
	m_UIScene:addChild(layerStart, 0, layerStart_Tag)
    CCDirector:sharedDirector():runWithScene(m_UIScene)
	
	local function _Button_Enter_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			--进入游戏登陆界面
			require "Script/Login/LoginLayer.lua"
			LoginLayer.createLoginUI()
			AudioUtil.PlayBtnClick()
		end
	end
    local Button_Enter = tolua.cast(layerStart:getWidgetByName("Button_Enter"), "Button")
    Button_Enter:addTouchEventListener(_Button_Enter_CallBack)
	-- 显示联网界面
	
	--------------------------
	
	-- 检查是否有更新
	--CheckUpdate()
	--Button_Enter:setVisible(false)
	--------------------------
	Button_Enter:setVisible(true)
	--------------------------
end
	
local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 1000)
	
    local cclog = function(...)
        Log(string.format(...))
    end
    ---------------
	createStart_Layer()
end
	





xpcall(main, __G__TRACKBACK__)
