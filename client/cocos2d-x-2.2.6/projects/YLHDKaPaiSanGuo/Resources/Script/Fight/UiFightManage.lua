
--角色战斗表现逻辑方法类
--为了叫ui层的战斗表现更真实！

module("UiFightManage", package.seeall)
require "Script/Fight/BaseSceneLogic"
require "Script/Fight/FightDef"


local CreatbindBoneToEffect = BaseSceneLogic.CreatbindBoneToEffect
local onEffectFrameEvent = BaseSceneLogic.onEffectFrameEvent
local DelArmature = BaseSceneLogic.DelArmature
local GetPointAngle = BaseSceneLogic.GetPointAngle
local VibrationSceen = BaseSceneLogic.VibrationSceen

local PlaySound = BaseSceneLogic.PlaySound
local KeyID = 0
local ObjLise = {}

local Type_General = 1
local Type_monst = 2

local function GetKeyID()	
	KeyID = KeyID +1	
	return KeyID	
end

local function GetObj( KeyID )	
	return ObjLise[KeyID]	
end

local function DelObj( KeyID )	
	ObjLise[KeyID] = nil	
end

local function GetModeHeight(pArmature)	

	local obj = GetObj(pArmature:getTag())
	if obj ~= nil then
		return obj.PlayData.m_height
	else
		local rect
		rect = pArmature:boundingBox()		
		return rect.size.height		
	end	
end

local function GetModeWidth(pArmature)
	local obj = GetObj(pArmature:getTag())
	if obj ~= nil then
		return obj.PlayData.m_width
	else
		local rect
		rect = pArmature:boundingBox()		
		return rect.size.width
	end	
	
end

--//技能特效帧事件扩展用
local function onEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)	
	
	if evt == FrameEvent_Key.Event_Vibration then			
		 VibrationSceen(3)										   
	end
end

--//技能特效回调 播放完自动删除 
local function onEffectMovementEvent(Armature, MovementType, movementID)

	if MovementType == MovementEventType.start	then
	
	elseif MovementType == MovementEventType.complete then		
		DelArmature(Armature)		
	elseif MovementType == MovementEventType.loopComplete then		

	end
end

local function onBuffEffectMovementEvent(Armature, MovementType, movementID)

	if MovementType == MovementEventType.start	then
	
	elseif MovementType == MovementEventType.complete then		
		if  Armature:getAnimation():getMovementCount() > 1 then			
			Armature:getAnimation():playWithIndex(1)			
		end
	elseif MovementType == MovementEventType.loopComplete then		

	end
end

--//瞬发特效播放目标的被打特效
local function PlayEffect_Prompt(pEffectData,pArmatureSour,pArmatureTar,bflip)
	
	--//添加
	local pArmature = nil	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName")])	
	pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName")])		
	
	if bflip == true then	
		--//翻转特效
		pArmature:setScaleX(-(pArmature:getScaleX()))
	end

	pArmature:setScale(tonumber(pEffectData[EffectData.getIndexByField("Scale")]))		
	pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder")])+pArmatureTar:getZOrder())		
	pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_0")]))		
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)	
	
	local pbindbone = tonumber(pEffectData[EffectData.getIndexByField("bindbone")])	
	--顺发特效都绑定到目标身上！！
	--local pbindArmature = tonumber(pEffectData[EffectData.getIndexByField("bindAnimation")])	
				
	if pbindbone > 0  then
		
		if pbindbone == 6 then --头顶
			pArmature:setPosition(ccp( 0 , GetModeHeight(pArmatureTar)+Off_Effect_head))	
		else
			pArmature:setPosition(ccp( 0, GetModeHeight(pArmatureTar)*0.5))	
		end			
	else			
		pArmature:setPosition(ccp( 0 , 0))				
	end
	
	if tonumber(pEffectData[EffectData.getIndexByField("effectzorder")]) <0 then		
		CreatbindBoneToEffect(pArmature,pArmatureTar,pEffectData[EffectData.getIndexByField("bonename")],0)		
	else	
		CreatbindBoneToEffect(pArmature,pArmatureTar,pEffectData[EffectData.getIndexByField("bonename")],Play_Effect_Z)			
	end	
	
	--扩展特效
	if pEffectData[EffectData.getIndexByField("fileName1")] ~= nil then
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName1")])	
		pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName1")])			
		if bflip == true then		
			--//翻转特效
			pArmature:setScaleX(-(pArmature:getScaleX()))
		end				
		
		pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder1")])+pArmatureTar:getZOrder())		
		pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_1")]))		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
		pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)		
		local pbindbone1 = tonumber(pEffectData[EffectData.getIndexByField("bindbone1")])			
	
		if pbindbone1 > 0  then					
			if pbindbone1 == 6 then --头顶
				pArmature:setPosition(ccp( 0 , GetModeHeight(pArmatureTar)+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, GetModeHeight(pArmatureTar)*0.5))	
			end					
		else					
			pArmature:setPosition(ccp( 0 , 0))					
		end				
		if tonumber(pEffectData[EffectData.getIndexByField("effectzorder1")]) <0 then
			pArmatureTar:addChild(pArmature,0)					
		else							
			pArmatureTar:addChild(pArmature,Play_Effect_Z)		
		end	
			
		--//翻转特效
		pArmature:setScaleX(-(pArmature:getScaleX()))				
		
	end
	
	if pEffectData[EffectData.getIndexByField("fileName2")] ~= nil then
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName2")])	
		pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName2")])			
		
		if bflip == true then			
			--//翻转特效
			pArmature:setScaleX(-(pArmature:getScaleX()))
		end	

		pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder2")])+pArmatureTar:getZOrder())		
		pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_2")]))		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
		pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
		
		local pbindbone2 = tonumber(pEffectData[EffectData.getIndexByField("bindbone2")])	
		
		if pbindbone2 > 0  then			
			if pbindbone2 == 6 then --头顶
				pArmature:setPosition(ccp( 0 , GetModeHeight(pArmatureTar)+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, GetModeHeight(pArmatureTar)*0.5))	
			end			
		else			
			pArmature:setPosition(ccp( 0 , 0))				
		end
		
		if tonumber(pEffectData[EffectData.getIndexByField("effectzorder2")]) <0 then
			pArmatureTar:addChild(pArmature,0)			
		else					
			pArmatureTar:addChild(pArmature,Play_Effect_Z)		
		end				
		--//翻转特效
		pArmature:setScaleX(-(pArmature:getScaleX()))		
	end	
end


local function OnEffectArrive(pNode)	
	--//删除子弹特效
	local pArmature = tolua.cast(pNode, "CCArmature")	
	pArmature:release()
	DelArmature(pArmature)
	
end

local function Create_Bullet_Armature(pEffectbulletData, pParArmature, pParArmatureTar, pBone ,bflip,pcallFunc)
	
	local pbindbone = tonumber(pEffectbulletData[EffectData.getIndexByField("bindbone")])	
	local pMoveTo = nil		
	local pArmature = nil	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbulletData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbulletData[EffectData.getIndexByField("EffectName")])	
	pArmature:setScale(tonumber(pEffectbulletData[EffectData.getIndexByField("Scale")]))	
	local speed = tonumber(pEffectbulletData[EffectData.getIndexByField("speed")])
	local fDis = ccpDistance( ccp(pParArmature:getPosition()),ccp(pParArmatureTar:getPosition()))
	local fMoveTime = fDis/speed
	--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
	if speed <100 then	
		fMoveTime = speed/24
	end			
	--//是否绑定骨骼 计算旋转	 
	if pbindbone > 0 and pBone ~= nil then			
		if pbindbone == 1 then --骨骼旋转		
			if pParArmature:getScaleX() > 0 then				
				pArmature:setPosition(ccp( pParArmature:getPositionX()+ pBone:nodeToArmatureTransform().tx, pParArmature:getPositionY() + pBone:nodeToArmatureTransform().ty))							
			else			
				pArmature:setPosition(ccp( pParArmature:getPositionX() - pBone:nodeToArmatureTransform().tx, pParArmature:getPositionY() + pBone:nodeToArmatureTransform().ty))	
			end 			
			
			local bulletPos = ccp(pArmature:getPosition())
			local targetPos = ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY() + GetModeHeight(pParArmatureTar)*0.5)
			local angle = GetPointAngle(bulletPos,targetPos)
			
			--增加 动画翻转不是完全靠旋转
			if bflip == true then
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end
			
			if pArmature:getScaleX() < 0 then
				angle = angle + 180				
			end
					
			pArmature:setRotation( angle )	

			fDis = ccpDistance( bulletPos,targetPos)
			--fDis = math.abs( bulletPos.x - targetPos.x)
			
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end			
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY() + GetModeHeight(pParArmatureTar)*0.5))	

		elseif pbindbone == 2 then --骨骼位置和目标点直线类型 以自己的的线路吧					
				
			if pParArmature:getScaleX() > 0 then				
				pArmature:setPosition(ccp( pParArmature:getPositionX()+ pBone:nodeToArmatureTransform().tx, pParArmature:getPositionY()))						
			else			
				pArmature:setPosition(ccp( pParArmature:getPositionX() - pBone:nodeToArmatureTransform().tx, pParArmature:getPositionY()))			
			end 						
				
			fDis = ccpDistance( ccp(pArmature:getPosition()),ccp(pParArmatureTar:getPositionX(),pArmature:getPositionY()))
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end		
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPositionX(),pArmature:getPositionY()))			
			if bflip == true then	
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end
		
			
		elseif pbindbone == 3 then --骨骼位置和目标点直线类型 初始位置在屏幕外边
		
			--计算屏幕外坐标
			local rect = pArmature:boundingBox()				
			local pSceneX =  - rect.size.width*0.5			
			
			if bflip == true then
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))				
				pSceneX = DefineWidth + rect.size.width*0.5				
			end
		
			fDis = ccpDistance( ccp(pSceneX,pParArmatureTar:getPositionY()),ccp(pParArmatureTar:getPosition()))
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end
	
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPosition()))
			
			pArmature:setPosition(ccp( pSceneX , pParArmatureTar:getPositionY() ))	
			
		elseif pbindbone == 4 then --骨骼位置和目标点直线类型 结束位置在屏幕外边
		
			--计算屏幕外坐标
			local rect = pArmature:boundingBox()				
			local pSceneX = DefineWidth + rect.size.width*0.5
			
			
			if bflip == true then
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))				
				pSceneX = - rect.size.width*0.5				
			end
		
			fDis = ccpDistance( ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY()),ccp(pSceneX,pParArmatureTar:getPositionY()))
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pSceneX,pParArmatureTar:getPositionY()))
			
			if pParArmature:getScaleX() > 0 then				
				pArmature:setPosition(ccp( pParArmature:getPositionX()+ pBone:nodeToArmatureTransform().tx, pParArmatureTar:getPositionY()))						
			else			
				pArmature:setPosition(ccp( pParArmature:getPositionX() - pBone:nodeToArmatureTransform().tx, pParArmatureTar:getPositionY()))		
			end 
			
		elseif pbindbone == 5 then --屏幕外到屏幕外
		
			--计算屏幕外坐标
			local rect = pArmature:boundingBox()			
			local pSceneStarX =  - rect.size.width*0.5			
			local pSceneEndX = DefineWidth + rect.size.width*0.5			
			
			if bflip == true then
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))				
				pSceneStarX = DefineWidth + rect.size.width*0.5
				pSceneEndX =  - rect.size.width*0.5
			end			
		
			fDis = DefineWidth + rect.size.width*2
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pSceneEndX,pParArmatureTar:getPositionY()))				
			pArmature:setPosition(ccp( pSceneStarX, pParArmatureTar:getPositionY() ))			
			
		else
		
		end		
	
	else
	
		pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY()))
		if bflip == true then
			--//翻转特效
			pArmature:setScaleX(-(pArmature:getScaleX()))
		end
		pArmature:setPosition(pParArmature:getPosition())	
	end
	
	--判断目标和自己谁的zorder高
	if pParArmatureTar:getZOrder() > pParArmature:getZOrder() then
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
	else
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pParArmature:getZOrder())
	end	
	pArmature:getAnimation():playWithIndex(tonumber(pEffectbulletData[EffectData.getIndexByField("AnimationID_0")]))	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)		
	local pcallFuncEffectArrive = CCCallFuncN:create(OnEffectArrive)	
	local pcallFunArrive = CCCallFuncN:create(pcallFunc)	
	local arr = CCArray:create()
			arr:addObject(pMoveTo)	
			arr:addObject(pcallFunArrive)	
			arr:addObject(pcallFuncEffectArrive)				
	
	local pSequence  = CCSequence:create(arr)	
	pArmature:runAction(pSequence)	
	
	pArmature:retain()
	return pArmature
	
end

--//子弹类特效
local function PlayEffect_Bullet(iEffectID_bullet, iEffectID_hit, pObj)	
	
	--//子弹特效到达回调播放被打特效(先不支持动画绑定)
	local function OnBulletEffectArrive(pNode)	
	--	//创建被打特效
		local pEffectHitData = EffectData.getDataById( iEffectID_hit)		
		PlayEffect_Prompt(pEffectHitData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)		
	end
	
	local pEffectData = EffectData.getDataById(iEffectID_bullet)	
	local pArmature = Create_Bullet_Armature(pEffectData,pObj.m_pArmature, pObj.m_target, pObj.m_Curbone,pObj.m_bflip,OnBulletEffectArrive)
	pObj.m_pScence:addNode(pArmature)	
end

--抛物线特效子弹 范围攻击*****************************
function PlayEffect_Bullet_parabolic(iEffectID_bullet, iEffectID_hit, pObj)

	local nHanderTime	
	--//子弹特效到达回调播放被打特效(先不支持动画绑定)
	local function OnparabolicBulletEffectArrive(pNode)	
	--	//创建被打特效
		local pEffectHitData = EffectData.getDataById( iEffectID_hit)		
		PlayEffect_Prompt(pEffectHitData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
	end
	
	local pParArmature = pObj.m_pArmature
	local pParArmatureTar = pObj.m_target
	local pEffectbulletData = EffectData.getDataById( iEffectID_bullet)
	local pbindbone = tonumber(pEffectbulletData[EffectData.getIndexByField("bindbone")])		
	--//添加
	local pArmature = nil	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbulletData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbulletData[EffectData.getIndexByField("EffectName")])	
	local fDis = math.floor(math.abs(pParArmature:getPositionX() - pParArmatureTar:getPositionX()))
	local speed = tonumber(pEffectbulletData[EffectData.getIndexByField("speed")])
	local fMoveTime = fDis/speed	
	local bezierTo1 = nil
	local pBone = pObj.m_Curbone
	--print(pBone)
	--Pause()
	if pbindbone > 0 and pBone ~= nil then	
		if pbindbone == 1 then --骨骼旋转		
			pArmature:setPosition(ccp( pParArmature:getPositionX() + pBone:nodeToArmatureTransform().tx, pParArmature:getPositionY() + pBone:nodeToArmatureTransform().ty))			
			local bulletPos = ccp(pArmature:getPosition())			
			local targetPos = ccp(pParArmatureTar:getPosition())
			local angle = GetPointAngle(bulletPos,targetPos) 					
			pArmature:setRotation( angle )			
			local offX = pParArmature:getPositionX() - pParArmatureTar:getPositionX()
			local bezier2 = ccBezierConfig()			
			bezier2.controlPoint_1 = ccp(pParArmature:getPositionX() - offX*0.3, pParArmature:getPositionY()+ 450)
			bezier2.controlPoint_2 = ccp(pParArmature:getPositionX() - offX*0.6, pParArmature:getPositionY()+ 350)			
			bezier2.endPosition = ccp(pParArmatureTar:getPosition())
			bezierTo1 = CCBezierTo:create(fMoveTime, bezier2)					
		end		
	end
	
	--判断目标和自己谁的zorder高
	if pParArmatureTar:getZOrder() > pParArmature:getZOrder() then
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
	else
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pParArmature:getZOrder())
	end
	
	pArmature:getAnimation():playWithIndex(tonumber(pEffectbulletData[EffectData.getIndexByField("AnimationID_0")]))	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)		
	pArmature:retain()
	
	local pcallFuncEffectArrive = CCCallFuncN:create(OnEffectArrive)
	
	
	local pcallFuncArrive = CCCallFuncN:create(OnparabolicBulletEffectArrive)	
	
	local arr = CCArray:create()
			arr:addObject(bezierTo1)
			arr:addObject(pcallFuncArrive)
			arr:addObject(pcallFuncEffectArrive)				
	
	local pSequence  = CCSequence:create(arr)		
	pArmature:runAction(pSequence)
	
	
	local oldPos = ccp(pArmature:getPosition())		
	local function tick(dt)		
		if pArmature == nil then
			return 
		end
		local bulletPos = ccp(pArmature:getPosition())
		local angle = GetPointAngle(oldPos,bulletPos) 					
		pArmature:setRotation( angle )		
		oldPos = bulletPos		
	end			
	nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(tick, 0.01, false)	
	pObj.m_pScence:addNode(pArmature)	
end

-----------buff类特效-------------
function PlayEffect_Prompt_buff(iEffectID_buff, iEffectID_hit, pObj, bSelfTar)

	local function OnbuffEffect()	
	--	//创建被打特效
		if iEffectID_hit >0 then
			local pEffectHitData = EffectData.getDataById( iEffectID_hit)			
			PlayEffect_Prompt(pEffectHitData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)	
		end			
	end
	
	--//取当前角色的位置	
	local pParArmature = pObj.m_pArmature	
	local pParArmatureTar = pObj.m_target
	if bSelfTar == true then
		pParArmatureTar = pObj.m_pArmature
	end
	local pEffectbuffData = EffectData.getDataById( iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])		
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	
	
	local pArmature = nil
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])				
	pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())	
	if  pArmature:getAnimation():getMovementCount() > 1 then		
		--先出生 再循环
		pArmature:getAnimation():playWithIndex(0)			
		pArmature:getAnimation():setMovementEventCallFunc(onBuffEffectMovementEvent)		
	else
		pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))
	end
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	
	--增加sharder效果
	local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
	
	if iSharder > 0 then		
		CCArmatureSharder(pParArmatureTar,iSharder)
	end
			
	local nHanderTime	
	local buffitmes = 1
	local bufftime =0
	local function bufftick(dt)			
		if buffitmes > 3  then
					
			if nHanderTime ~= nil then				
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)					
				nHanderTime = nil				
			end	
			
			if iSharder > 0 then			
				CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)				
			end		
			DelArmature(pArmature)
		else			
			bufftime = bufftime+G_Fight_BUff_Tick_Time
			if bufftime >= 1 then
				bufftime = 0
				buffitmes = buffitmes + 1	
				--OnbuffEffect()
			end				
		end			
	end				
	nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)	
		
		--//是否绑定骨骼 计算旋转
	if  pbindArmature > 0 then 		
		if pbindbone > 0  then			
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( 0 , GetModeHeight(pParArmatureTar)+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, GetModeHeight(pParArmatureTar)*0.5))	
			end			
		else			
			pArmature:setPosition(ccp( 0 , 0))				
		end
		
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then			
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)
		else			
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
		end		
		--//翻转特效
		--pArmature:setScaleX(-(pArmature:getScaleX()))
	else	
			--//是否绑定骨骼 计算旋转		 
		if pbindbone > 0  then			
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + GetModeHeight(pParArmatureTar)+10))	
			else
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + GetModeHeight(pParArmatureTar)*0.5))	
			end			
			
		else			
			pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))				
		end
						
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
			pObj.m_pScence:addNode(pArmature,0)
		else
			pObj.m_pScence:addNode(pArmature)
		end						
	
	end		
	
end



-- 表现
local function PlayEffectMage(pObj)		
	local pSkillData = SkillData.getDataById( pObj.PlayData.m_SkillData[pObj.m_iSkill].m_skillid_res)
	local pEffectData = nil	
	
	local bselfTag = false
	if pObj.PlayData.m_SkillData[pObj.m_iSkill].m_skillid_Site == Site_Type.Site_Self_Self or 
		pObj.PlayData.m_SkillData[pObj.m_iSkill].m_skillid_Site == Site_Type.Site_Self_All or
		pObj.PlayData.m_SkillData[pObj.m_iSkill].m_skillid_Site == Site_Type.Site_Self_Single then
		bselfTag = true
	end
	
	--//瞬发
	if tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt then	
		
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	
		
		if bselfTag == true then 
			PlayEffect_Prompt(pEffectData,pObj.m_pArmature,pObj.m_pArmature,pObj.m_bflip)
		else
			PlayEffect_Prompt(pEffectData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)
		end		 
	
	--//子弹类
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])				
		PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj)			
				
	--//抛物线朝向类的特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_parabolic_one then
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])					
		PlayEffect_Bullet_parabolic(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj)
		
	--//抛物线朝向类的特效技能多目标的
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_parabolic_Mul then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		
		PlayEffect_Bullet_parabolic(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj)
		
	----buf类特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_One then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		
					
		PlayEffect_Prompt_buff(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj,bselfTag)
				
	----增益buf类特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_Gain then	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		
		PlayEffect_Prompt_buff(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj,bselfTag)		
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_State then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	
		-- 暂时先按普通buff做不做限制了
		PlayEffect_Prompt_buff(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj,bselfTag)	
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_State_jifei then		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		
		
		if bselfTag == true then 
			PlayEffect_Prompt(pEffectData,pObj.m_pArmature,pObj.m_pArmature,pObj.m_bflip)
		else
			PlayEffect_Prompt(pEffectData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)		
		end
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Gain then --//增益瞬发单体
		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	

		-- 暂时先按普通buff做
		PlayEffect_Prompt_buff(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj,bselfTag)		
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_xishoudun then --//吸收盾逻辑		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	
		-- 暂时先按普通buff做
		PlayEffect_Prompt_buff(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj,bselfTag)					
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Back_one then --//伤害+回复（单体）
	
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		 
		 PlayEffect_Prompt(pEffectData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)						
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Back_all then --//伤害+回复（全体）
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		PlayEffect_Prompt(pEffectData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)	
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_ShuXing_one then --//伤害+属性（单体）
				
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])
		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")]) 
		 
		PlayEffect_Prompt(pEffectData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)	
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_buff_State then --//子弹伤害+状态限制
				
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	
		--PlayEffect_Bullet(pEffectData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)	
		PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj)
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_Sequence then --//子弹伤害+顺序伤害
				
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	
		--PlayEffect_Bullet(pEffectData,pObj.m_pArmature,pObj.m_target,pObj.m_bflip)	
		PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pObj)
	else	
	
	end	
	
end


local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
	     
        if evt == FrameEvent_Key.Event_attack then           			
			local pArmature = bone:getArmature()
			if pArmature ~= nil then
			
				local KeyID = pArmature:getTag()
				local pObj = GetObj(KeyID)				
				pObj.m_Curbone = bone					
				PlayEffectMage(pObj)							
			end	
		elseif  evt == FrameEvent_Key.Event_Vibration then					   
			VibrationSceen(3)										   
		elseif  evt == FrameEvent_Key.Event_Blur then
			--设置模糊效果
			local pArmature = bone:getArmature()
			if pArmature ~= nil then							
				CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Blur)			
			end				
		elseif  evt == FrameEvent_Key.Event_Normal then
			
			local pArmature = bone:getArmature()
			if pArmature ~= nil then			
				CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Normal)							
			end	
		else
		   
        end
end

local function onMovementEvent(armatureBack,movementType,movementID)
	local id = movementID	
	
	if movementType == MovementEventType.start	then				
		
	elseif movementType == MovementEventType.complete then		
		CCArmatureSharder(armatureBack,SharderKey.E_SharderKey_Normal)	
		local KeyID = armatureBack:getTag()
		local pObj = GetObj(KeyID)		
				
		if id == GetAniName_Res_ID(pObj.PlayData.m_TempResid,Ani_Def_Key.Ani_die) then
			local pFadeOut = CCFadeOut:create(3)
			armatureBack:runAction(pFadeOut)			
		else														
			armatureBack:getAnimation():play(GetAniName_Res_ID(pObj.PlayData.m_TempResid,Ani_Def_Key.Ani_stand))				
		end	
		
		if pObj.m_AnimationCallBack ~= nil then
			pObj.m_AnimationCallBack()
			pObj.m_AnimationCallBack = nil
		end
		
	elseif movementType == MovementEventType.loopComplete then		
	end		
end

local function CreatUiAnimate( resID )
	
	local pAnimationfileName = AnimationData.getFieldByIdAndIndex(resID,"AnimationfileName")	
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)
	
	local pAnimationName = AnimationData.getFieldByIdAndIndex(resID,"AnimationName")
	
	local pArmature = CCArmature:create(pAnimationName)	
	
	pArmature:getAnimation():play(GetAniName_Res_ID(resID,Ani_Def_Key.Ani_stand)) 
	
	pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	
	return pArmature
	
end

local function InitObjData( self ,ID , itype)
	
	if ID ~= nil and ID > 0 then 
	
		local pgeneralData = nil
		
		if Type_General == itype then
		
			pgeneralData = general.getDataById(ID)	
			
		elseif Type_monst == itype then
		
			pgeneralData = monst.getDataById(ID)	
			
		else
		
		end	
		
		-- 保存需要的数据
		self.PlayData ={}
		self.PlayData.m_TempID		= ID
		self.PlayData.m_name 		= pgeneralData[general.getIndexByField("Name")]
		self.PlayData.m_TempResid  	= tonumber(pgeneralData[general.getIndexByField("ResID")])			
		self.PlayData.m_SkillData = {}
		self.PlayData.m_SkillData[1] = {}
		self.PlayData.m_SkillData[2] = {}
		self.PlayData.m_SkillData[3] = {}
		if Type_General == itype then
			self.PlayData.m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			self.PlayData.m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			self.PlayData.m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])	
		elseif Type_monst == itype then
			self.PlayData.m_SkillData[1].m_skillid = tonumber(pgeneralData[monst.getIndexByField("attack_id")])
			self.PlayData.m_SkillData[2].m_skillid = tonumber(pgeneralData[monst.getIndexByField("skill_ID")])
			self.PlayData.m_SkillData[3].m_skillid = tonumber(pgeneralData[monst.getIndexByField("engine_ID")])	
		else

		end
		
		self.PlayData.m_SkillData[1].m_skillid_res =tonumber(skill.getFieldByIdAndIndex(self.PlayData.m_SkillData[1].m_skillid, "resID"))	
		self.PlayData.m_SkillData[1].m_skillid_Site=tonumber(skill.getFieldByIdAndIndex(self.PlayData.m_SkillData[1].m_skillid, "site"))
		self.PlayData.m_SkillData[2].m_skillid_res =tonumber(skill.getFieldByIdAndIndex(self.PlayData.m_SkillData[2].m_skillid, "resID"))	
		self.PlayData.m_SkillData[2].m_skillid_Site=tonumber(skill.getFieldByIdAndIndex(self.PlayData.m_SkillData[2].m_skillid, "site"))		
		self.PlayData.m_SkillData[3].m_skillid_res =tonumber(skill.getFieldByIdAndIndex(self.PlayData.m_SkillData[3].m_skillid, "resID"))
		self.PlayData.m_SkillData[3].m_skillid_Site=tonumber(skill.getFieldByIdAndIndex(self.PlayData.m_SkillData[3].m_skillid, "site"))
		-- 创建动画对象
		self.m_pArmature = CreatUiAnimate(self.PlayData.m_TempResid)		
		self.m_pArmature:setTag(self.m_KeyID)
		
		-- 计算动画高度
		local rect
		rect = self.m_pArmature:boundingBox()		
		self.PlayData.m_height = rect.size.height
		self.PlayData.m_width  = rect.size.width
		
		return true
	end
	
	return false
end

--bflip 是否翻转 true 翻转
local function Create( self,generalID, bflip , pScence)	
	
	if InitObjData(self,generalID,Type_General) == true then	
		self.m_generalID = generalID
		self.m_bflip = bflip
		self.m_pScence = pScence
		if bflip == true then
			self.m_pArmature:setScaleX(-(self.m_pArmature:getScaleX()))			
		end
		
		--pScence:addChild(self.m_pArmature)
		pScence:addNode(self.m_pArmature)
		return true
	end 
	
	return false
end

local function Create_Monst( self,monstID, bflip , pScence)	
	
	if InitObjData(self,monstID,Type_monst) == true then	
		self.m_generalID = monstID
		self.m_bflip = bflip
		self.m_pScence = pScence
		if bflip == true then
			self.m_pArmature:setScaleX(-(self.m_pArmature:getScaleX()))			
		end
		
		--pScence:addChild(self.m_pArmature)
		pScence:addNode(self.m_pArmature)
		return true
	end 
	
	return false
end

local function Destroy( self )		
	self.m_pArmature:removeFromParentAndCleanup(true)
	DelObj(self.m_KeyID)
	self = nil	
end

local function GetAnimate( self )		
	return self.m_pArmature	
end

-- 要给个目标节点 这样才能打出特效 
local function playAttack( self,  target)	
	self.m_iSkill = 1
	self.m_target = target		
	self.m_pArmature:getAnimation():play(GetAniName_Res_ID(self.PlayData.m_TempResid,Ani_Def_Key.Ani_attack))	
end

local function playSkill( self,  target)	
	self.m_iSkill = 2
	self.m_target = target	
	self.m_pArmature:getAnimation():play(GetAniName_Res_ID(self.PlayData.m_TempResid,Ani_Def_Key.Ani_skill))
end

local function playManualSkill( self,  target)	
	self.m_iSkill = 3
	self.m_target = target	
	self.m_pArmature:getAnimation():play(GetAniName_Res_ID(self.PlayData.m_TempResid,Ani_Def_Key.Ani_manual_skill))	
end

local function playAnimation( self,  AnimationName, pcallback )	
	self.m_pArmature:getAnimation():play(AnimationName)
	self.m_AnimationCallBack = pcallback
end

--创建对象
function CreatUIAminationObj()

	local UIAminationObj = 
	{
		Create 	= Create,
		Create_Monst = Create_Monst,
		Destroy = Destroy,
		playAttack = playAttack,
		playSkill = playSkill,
		playManualSkill = playManualSkill,
		playAnimation = playAnimation,
		GetAnimate = GetAnimate,
		m_KeyID = GetKeyID(),
	}
	
	ObjLise[UIAminationObj.m_KeyID] = UIAminationObj
	
	return UIAminationObj
end





