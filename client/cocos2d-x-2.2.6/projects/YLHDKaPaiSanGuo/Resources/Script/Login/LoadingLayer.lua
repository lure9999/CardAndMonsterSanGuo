-- for CCLuaEngine traceback

module("LoadingLayer", package.seeall)

local m_pLoading = nil
local m_tableRes = {}
local m_pBladeSprite = nil
local m_pProgressBar_Loading = nil
local m_pImage_Blade = nil

local m_nAllResCount = 0
local m_nCurResCount = 0
local m_pCallBackFun = nil
local m_nCurProPos = 0
local m_nDesProPos = 0
local m_PauseNum = 0

--创建刀序列帧动画
local function createBladeAnimation(LoadingLayer)

	local rect = CCRectMake(0, 0, 140, 115)
	local BladeFrames = CCArray:create()

	for i = 1, 3 do
		local BladePath = string.format("Image/imgres/loading/blade_%d.png", i)
		local BladeTexture = CCTextureCache:sharedTextureCache():addImage(BladePath)
		local BladeFrame = CCSpriteFrame:createWithTexture(BladeTexture, rect)
		BladeFrames:addObject(BladeFrame)
	end

    m_pBladeSprite = CCSprite:create()
    m_pBladeSprite.isPaused = false
	m_pBladeSprite:setPosition(35, 125)

    local BladeAnimation = CCAnimation:createWithSpriteFrames(BladeFrames,0.1)
    local BladeAnimate = CCAnimate:create(BladeAnimation);
    m_pBladeSprite:runAction(CCRepeatForever:create(BladeAnimate))
    LoadingLayer:addChild(m_pBladeSprite,0,100)

end 

local function DoAsysResTwice( isTwice )
	if isTwice == nil then
		--m_pProgressBar_Loading:setPercent(0)

		if m_pBladeSprite ~= nil then
			local xPt = (920/100)*0 +10
			m_pBladeSprite:setPosition(ccp(xPt, m_pProgressBar_Loading:getPositionY()+37))
		end
		--[[print("DoAsysResTwice")
		Pause()]]--
		for key, value in pairs(m_tableRes) do
			m_nAllResCount =  m_nAllResCount + 1
		end

		m_nCurResCount = m_nCurResCount + 1
		myAddImageAsync(m_tableRes[m_nCurResCount])
	else
		m_PauseNum = 0
	end

	local function AysAddPro()
		--[[print("AysAddPro")
		print(m_nCurProPos)
		print(m_nDesProPos)
		Pause()]]--
		if m_nCurProPos < m_nDesProPos then
			m_nCurProPos = m_nCurProPos + 1
			--print(m_nCurProPos)
		end
		if m_pProgressBar_Loading ~= nil then
			--显示进度条的进度
			m_pProgressBar_Loading:setPercent(m_nCurProPos)
		end
		--设置刀序列帧的位置
		if m_pBladeSprite ~= nil then
			local xPt = (920/100)*m_nCurProPos +100
			m_pBladeSprite:setPosition(ccp(xPt, m_pProgressBar_Loading:getPositionY()+37))
		end

		if m_PauseNum ~= 0 then
			if isTwice == nil then
				if m_nCurResCount >= m_PauseNum then
					if m_pCallBackFun ~= nil then
						m_pCallBackFun()
					end
					m_pLoading:stopAllActions()
				end
			end
		else
			if m_nCurProPos >= 100 then
				if m_pCallBackFun ~= nil then
					m_pCallBackFun()
				end
				m_pLoading:stopAllActions()
			end
		end
	end

	local actionCur = CCArray:create()
	actionCur:addObject(CCCallFuncN:create(AysAddPro))
	m_pLoading:runAction(CCRepeatForever:create(CCSequence:create(actionCur)))
end

local function DoAsysRes()
	---------------------
	m_pProgressBar_Loading:setPercent(0)

	if m_pBladeSprite ~= nil then
		local xPt = (920/100)*0 +10
		m_pBladeSprite:setPosition(ccp(xPt, m_pProgressBar_Loading:getPositionY()+37))
	end

	for key, value in pairs(m_tableRes) do
		m_nAllResCount =  m_nAllResCount + 1
	end

	m_nCurResCount = m_nCurResCount + 1
	myAddImageAsync(m_tableRes[m_nCurResCount])

--[[
	local function AysAddCount()
		if m_nAllResCount == 0 then
			m_pLoading:stopAllActions()
			return
		end
		m_nCurResCount = m_nCurResCount + 1
		--myAddImageAsync(res.getFieldByIdAndIndex(m_nCurResCount, "img"))
		myAddImageAsync(m_tableRes[m_nCurResCount])
		if m_nCurResCount == m_nAllResCount then
			m_pLoading:stopAllActions()
		end
	end

	local actionCur = CCArray:create()
	actionCur:addObject(CCDelayTime:create(0.2))
	actionCur:addObject(CCCallFuncN:create(AysAddCount))
	m_pLoading:runAction(CCRepeatForever:create(CCSequence:create(actionCur)))
	--]]

	local function AysAddPro()
		--print("AysAddPro================")
		--Pause()
		if m_nCurProPos < m_nDesProPos then
			--if m_nDesProPos - m_nCurProPos > 10 then
			--	m_nCurProPos = m_nCurProPos + (m_nDesProPos - m_nCurProPos)/10
			--else
			--	m_nCurProPos = m_nCurProPos + 1
			--end
			m_nCurProPos = m_nCurProPos + 1
		end
		--Pause()
		--print(m_nCurProPos)
		--print(m_nDesProPos)
		if m_pProgressBar_Loading ~= nil then
			--显示进度条的进度
			m_pProgressBar_Loading:setPercent(m_nCurProPos)
		end
		--print("====================:="..m_nCurProPos)
		--Pause()
		--设置刀序列帧的位置
		if m_pBladeSprite ~= nil then
			local xPt = (920/100)*m_nCurProPos +100
			m_pBladeSprite:setPosition(ccp(xPt, m_pProgressBar_Loading:getPositionY()+37))
		end
		
		if m_nCurProPos >= 100 then
			if m_pCallBackFun ~= nil then
				m_pCallBackFun()
			end
			m_pLoading:stopAllActions()
		end
	end

	local actionCur = CCArray:create()
	actionCur:addObject(CCCallFuncN:create(AysAddPro))
	m_pLoading:runAction(CCRepeatForever:create(CCSequence:create(actionCur)))

end

local function createLoadingLayerUI()
	m_pLoading = TouchGroup:create()									-- 背景层
    m_pLoading:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/LoadingLayer.json") )
	--print("createLoadingLayerUI================================")
	--m_pProgressBar_Loading = tolua.cast(m_pLoading:getWidgetByName("ProgressBar_Loading"), "LoadingBar")
	--local m_pImage_Blade = tolua.cast(m_pLoading:getWidgetByName("Image_Blade"), "ImageView")
	--m_pImage_Blade:setVisible(false)
	--createBladeAnimation(m_pLoading)
	m_pLoading:setVisible(false)
	m_pLoading:retain()
end
-- 删除控制，在退出的时候调用
function DeleteLoading()
	m_pLoading:removeFromParentAndCleanup(true)
	m_pLoading = nil
end
-- 设置资源加载表
function SetResTable(tempTable, pauseNum)
	--print("SetResTable")
	m_nAllResCount = 0
	m_nCurResCount = 0
	m_nCurProPos = 0
	m_nDesProPos = 0
	m_pCallBackFun = nil
	ReSetAsync()
	--Pause()
	if pauseNum ~= nil then
		m_PauseNum = pauseNum
	end

	m_tableRes = tempTable
end

-- 是否显示
function Show(bFlag, isTwice)
	if m_pLoading == nil then
		createLoadingLayerUI()
	end
	print("show")
	m_pLoading:setVisible(bFlag)

	if bFlag == true and m_pLoading ~= nil then
		--DoAsysRes()
		if isTwice ~= nil then
			print("DoAsysResTwice(isTwice)")
			DoAsysResTwice(isTwice)
		else
			print("DoAsysResTwice")
			DoAsysResTwice()
		end
	else
		m_pLoading:removeFromParentAndCleanup(false)
	end

end
-- 设置回调
function SetCallBackFun(fun)
	--print("SetCallBackFun====================")
	m_pCallBackFun = fun
end
-- 获得加载控件
function GetLoadingUI()
	
	if m_pLoading == nil then
		createLoadingLayerUI()
	end

	return m_pLoading
end

local function SetLoadingInfo(text, nCurCount, nAllCount)
   
	nAllCount = m_nAllResCount
	if m_pLoading ~= nil then
		
		local fPer = nCurCount/m_nAllResCount
		fPer = fPer*100
		
		m_nDesProPos = fPer
		if fPer == 100 then
		else
			local function AysAddCount()
				--[[ print("SetLoadingInfo")
				Pause()]]--
				m_nCurResCount = m_nCurResCount + 1
				myAddImageAsync(m_tableRes[m_nCurResCount])
			end
			local actionCur = CCArray:create()
			local ff = nCurCount/m_nAllResCount
			actionCur:addObject(CCCallFuncN:create(AysAddCount))
			m_pLoading:runAction(CCSequence:create(actionCur))
		end
	end
end