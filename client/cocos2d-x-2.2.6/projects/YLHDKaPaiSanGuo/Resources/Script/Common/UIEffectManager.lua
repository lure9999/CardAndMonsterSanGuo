--继承自UIFightMange
--加入入场动画
--celina

module("UIEffectManager", package.seeall)


local CreatUIAminationObj = UiFightManage.CreatUIAminationObj
local DelArmature = BaseSceneLogic.DelArmature

 
--[[local function GetFlip(self)
	
	return self.m_bflip
end]]--
local function GetPScene(self)
	return self.m_pScence
end
local function GetAnimationArmature(self)
	return self.m_pArmature
end
local function EffctInit(self,strEffectJsonPath,strEffectJsonName,bFlip)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strEffectJsonPath)
	local PayArmature = CCArmature:create(strEffectJsonName)
	if bFlip == true then
		PayArmature:setScaleX(-(PayArmature:getScaleX()))			
	end
	
	return PayArmature 
end


--进场动画需要将帧事件回调 要播放的帧动画名字，以及事件帧传过来
local function PlayEffect( self,strEffectJsonPath,strEffectJsonName,strPlayName ,bFlip,fCallBack )
	local pArmature = EffctInit(self,strEffectJsonPath,strEffectJsonName,bFlip) 
	--self.EffectCallBack = fCallBack
	
	if  pArmature~=nil  then
		local function onFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
			 if evt == FrameEvent_Key.Event_shownpc then    
				--帧事件回调将人物显示出来
				if fCallBack~=nil then
					fCallBack()
					fCallBack = nil
				end
			end
		end
		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == MovementEventType.start	then				
				
			elseif movementType == MovementEventType.complete then
				DelArmature(armatureBack)
				if fCallBack~=nil then
					fCallBack()
					fCallBack = nil
				end
			elseif movementType == MovementEventType.loopComplete then		
			end	
			
			
		end
		pArmature:getAnimation():setFrameEventCallFunc(onFrameEvent)
		pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
		pArmature:getAnimation():play(strPlayName)
		pArmature:setPosition( GetAnimationArmature(self):getPosition() )
		local zOrder = GetAnimationArmature(self):getZOrder()+100
		pArmature:setZOrder(zOrder)
		pArmature:setTag(zOrder)
		if GetPScene(self):getNodeByTag(zOrder)~=nil then
			GetPScene(self):removeNodeByTag(zOrder)
		end
		GetPScene(self):addNode(pArmature)
	end
	
end
local function OnDamageNumEnd(pNode)	
	local pUILabelBMFont = tolua.cast(pNode, "LabelBMFont")
	pUILabelBMFont:removeFromParentAndCleanup(true)	
end
local function AddBloodEffect(self,lDamage,pParent)
	--冒血的动作 按三秒的时候自动冒血
	
	local pDelayStar = CCDelayTime:create(0.1)	
	local pScaleTo = CCScaleTo:create(0.1,2.0,2.0)
	local pScaleTo1 = CCScaleTo:create(0.2,1.0,1.0)
	local pcallFunc = CCCallFuncN:create(OnDamageNumEnd)
		
	local arr = CCArray:create()
	arr:addObject(pDelayStar)
	arr:addObject(pScaleTo)
	arr:addObject(pScaleTo1)
	arr:addObject(CCFadeOut:create(0.5))
	arr:addObject(pcallFunc)
	local pScaleToseq  = CCSequence:create(arr)
		
	local pMoveUp = CCMoveBy:create(0.8,ccp(0,100))
	
	local spawn = CCSpawn:createWithTwoActions(pMoveUp, pScaleToseq)
	
	local labelBMFont = LabelBMFont:create()
	
	--都设置为红色的
	labelBMFont:setFntFile("Image/Fight/UI/blood/play_norm_blood.fnt")	
	--增加骨骼绑定
	local pArmatureTar = GetAnimationArmature(self)
	local pBone = pArmatureTar:getBone("xuetiao")	
	if pBone ~= nil then 
	
		if pArmatureTar:getScaleX() > 0 then
			
			labelBMFont:setPosition(ccp( pArmatureTar:getPositionX()+ pBone:nodeToArmatureTransform().tx, pArmatureTar:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
						
		else
		
			labelBMFont:setPosition(ccp( pArmatureTar:getPositionX() - pBone:nodeToArmatureTransform().tx, pArmatureTar:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
	
		end 				

	end
	if tonumber(lDamage)<=0 then
		lDamage = 1 --容错
	end
	labelBMFont:setText("-"..lDamage)
	
	labelBMFont:runAction(spawn)
	--[[labelBMFont:setName("damage")
	if pParent:getWidgetByName("damage")~=nil then
		pParent:getWidgetByName("damage"):removeFromParentAndCleanup(true)
	end]]--
	labelBMFont:setZOrder(pArmatureTar:getZOrder()+5000)
	pParent:addChild(labelBMFont)
end




function CreateUIEffectObj()
	local UIEffectObj = CreatUIAminationObj()
	--重载UiFightManage的一些方法 暂时不需要
	--[[UIEffectObj.Base = {}
	UIEffectObj.Base.Create = UIEffectObj.Create
	UIEffectObj.Create = Create]]--
	UIEffectObj.PlayEffect = PlayEffect
	UIEffectObj.AddBloodEffect = AddBloodEffect
	return UIEffectObj
end