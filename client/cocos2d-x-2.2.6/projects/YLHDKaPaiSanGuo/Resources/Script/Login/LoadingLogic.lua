--加载界面逻辑 celina

module("LoadingLogic", package.seeall)



function GetAnimationByName(strJsonPath, strJsonName, strPlayName, pParentUI, ptPos, callBackFun, nTag)
	
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local PayArmature = CCArmature:create(strJsonName)
	PayArmature:setPosition(ptPos)  
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)	

    local function onMovementEvent(armatureBack,movementType,movementID)
        if movementType == 1 then
            layout:removeFromParentAndCleanup(true)    
            if callBackFun ~= nil then
                callBackFun()
				callBackFun = nil
				
            end
		elseif movementType == 2 then
			
        end
		if strJsonName ==  "brith_all_001" then
			--print(movementID)
			
		end
    end
	local function onFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
		if evt == "attact_effect" then  
			AudioUtil.playEffect("audio/loading/close_door_scene.mp3")
			if callBackFun ~= nil then
                callBackFun(PayArmature:getAnimation())
				callBackFun = nil
				
            end
			
			PayArmature:getAnimation():play("Animation5")
		end
	end
    PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	PayArmature:getAnimation():play(strPlayName)
	PayArmature:getAnimation():setFrameEventCallFunc(onFrameEvent)
    if nTag ~= nil then
		if pParentUI:getChildByTag(nTag)~=nil then
			pParentUI:getChildByTag(nTag):removeFromParentAndCleanup(true)
		end
        pParentUI:addChild(layout, 1, nTag)
    else
		
        pParentUI:addChild(layout, 1)
    end
	return PayArmature
end
function GetBackGroundImage(nType)
	--[[if nType == LOADING_TYPE.LOADING_TYPE_NONE then
		return "Image/imgres/loading/loading_bg01.png"
	else]]--
		local iNum = math.random(1,3)
		return "Image/imgres/loading/loading_bg0"..iNum..".png"
	--end
	

end

function GetUpdateVer(strAllVersion)
	local ver = ""
	local sSize = ""
	if strAllVersion~="" then
		local idx = string.find(strAllVersion,"|")
		if idx~=nil then
			verSize = string.sub(strAllVersion,0,idx-1)
			local nSize = string.find(verSize,"/")
			ver = string.sub(verSize,0,nSize-1)
			sSize = string.sub(verSize,nSize+1)
			CCUserDefault:sharedUserDefault():setStringForKey("g_Version", strAllVersion)
			strAllVersion = string.sub(strAllVersion,idx+1)
			LoadingNewLayer.UpdateVersion(strAllVersion)
			
		end
	end
	return ver,sSize
	
end
local function GetUpdateUrl(strAllV)
	--[[print("GetUpdateUrl:"..strAllV)
	Pause()]]--
	if strAllV == nil then
		return nil
	end
	local url = ""
	local ver = GetUpdateVer(strAllV)
	
	local nowVer = CCUserDefault:sharedUserDefault():getStringForKey("current-version-code")
	
	if nowVer== nil or nowVer== "" then
		if ver~="" then
			url = string.format(CommonData.g_szFtpUrl .. "/pub/%s/ver.ini",tostring(ver))
		end
		return url
	end
	if tonumber(ver)> tonumber(nowVer) then
		if ver~="" then
			url = string.format(CommonData.g_szFtpUrl .. "/pub/%s/ver.ini",tostring(ver))
		end
		
		return url
		
	else
		local fVersion = LoadingNewLayer.GetUpdateVersion()
		if fVersion~="" then
			local url =  GetUpdateUrl(fVersion)
			 return url
		end
	end
	return nil
end
function ToGetUpUrl(strAllV)
	--if CommonData.g_strVersion~="" then
		-- 获取第一个需要更新的URL
		local url=GetUpdateUrl(strAllV)
		print(url)
		print("ToGetUpUrl")
		--Pause()
		-- 根据第一个URL来检测是否有更新包
		if url==nil then	
			print("获取不到地址,没有更新包")
			return false
		else
			CheckUpdate(url)
			return true
		end
		
		return false
  --	end
end

function ToLogicDownLoadOK(strVersion,pText,fCallBack)
	
	if strVersion== nil or strVersion == "" then
		print(strVersion,pText,fCallBack)
		--Pause()
		if fCallBack~=nil then
			if pText~=nil then
				pText:setVisible(true)
				pText:setText("恭喜您更新到最新版本，正在努力进入游戏，请稍等")
			end
			fCallBack()
			return 
		end
	end
	local url = GetUpdateUrl(strVersion)
	
	if url~=nil then
		-- 根据URL检测是否更新
		if pText~=nil then
			pText:setVisible(true)
			--pText:setText("正在检查最新版本")
		end
		CheckUpdate(url)
		--if pText~=nil then
			--pText:setVisible(false)
		--end
	else	
		if pText~=nil then
			pText:setVisible(true)
			pText:setText("恭喜您更新到最新版本，正在努力进入游戏，请稍等")
		end
		if fCallBack~=nil then
			fCallBack()
		end
	end
end
local function GetAnimationToPlay(strJsonPath, strJsonName, strPlayName, pParentUI, ptPos,callBackFun)
	 CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local PayArmature = CCArmature:create(strJsonName)
	PayArmature:setPosition(ptPos)  

	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)	
	if pParentUI:getChildByTag(1)~=nil then
		pParentUI:getChildByTag(1):removeFromParentAndCleanup(true)
	end
	pParentUI:addChild(layout, 1,1)
	if callBackFun~=nil then
		callBackFun(PayArmature:getAnimation())
	end
end

--创建loading动画
function CreateLoadingAnimation(strJsonPath, strJsonName, strPlayName, pParentUI, ptPos, callBackFun)
	local function GetAnimation(pAnimation)
		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 2 then
				if pParentUI:getChildByTag(1) ~=nil then
					if pParentUI:getChildByTag(1):getPositionX() >= (pParentUI:getContentSize().width-354) then
						if callBackFun~=nil then
							pAnimation:play("Animation2")
							callBackFun(pAnimation)
							callBackFun = nil
							
						end
					end
				end
			end
		end
		pAnimation:setMovementEventCallFunc(onMovementEvent)
		pAnimation:play(strPlayName)
		pAnimation:setSpeedScale(pAnimation:getSpeedScale()*1.5)
	end
	GetAnimationToPlay(strJsonPath, strJsonName, strPlayName, pParentUI, ptPos, GetAnimation)

end

function GetLoadingAciton(fCallBack)
	local actionCur = CCArray:create()
	actionCur:addObject(CCCallFuncN:create(fCallBack))
	return CCRepeatForever:create(CCSequence:create(actionCur))
end

function CheckBEnd(bEnd,pLayer,fCallBack)
	if bEnd == true then
		if fCallBack~=nil then
			fCallBack()
		end
		pLayer:stopAllActions()
	end
end

function RandomLoaingType()
	local iNum = math.random(1,3)
	return iNum
end
function GetActionDelay(fCallBack)
	local actionCur = CCArray:create()
	actionCur:addObject(CCDelayTime:create(0.3))
	actionCur:addObject(CCCallFuncN:create(fCallBack))
	return CCRepeatForever:create(CCSequence:create(actionCur))
end
function TabLabelShow(tab,count)
	for i=1,3 do 
		local pLabel = tolua.cast(tab[i],"Label")
		if pLabel== nil then
			return 
		end
		if i<= count then
			pLabel:setVisible(true)
		else
			pLabel:setVisible(false)
		end
	end
end