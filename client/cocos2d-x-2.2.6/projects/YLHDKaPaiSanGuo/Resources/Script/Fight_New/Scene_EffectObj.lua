
--场景管理器通过这个管理器来创建战斗场景的实体

module("Scene_EffectObj", package.seeall)
local g_EffectObjTable = {}
local g_EffectID = 0

local function CreatID()
	g_EffectID = g_EffectID+1
	return g_EffectID
end


--绑定真正的骨骼动画接口
local g_BoneID = 1000
function CreatEffectBoneName()	
	g_BoneID = g_BoneID + 1	
	return "EffectBone" .. g_BoneID	
end

function CreatbindBoneToEffect( pEffect , pParArmature , boneName,iZorder)

	if boneName == nil then 		
		pParArmature:addChild(pEffect,iZorder)
		--//翻转特效
		pEffect:setScaleX(-(pEffect:getScaleX()))
	else		
		local pParbone = pParArmature:getBone(boneName)
		
		if pParbone ~= nil then 
			
			pEffect:setPosition(ccp( 0 , 0))		
			local bone  = CCBone:create(CreatEffectBoneName())			
			bone:addDisplay(pEffect, 0)
			bone:changeDisplayWithIndex(0, true)
			bone:setIgnoreMovementBoneData(true)
			if iZorder > 0 then 
				bone:setZOrder(iZorder)
			end
			
			pParArmature:addBone(bone, boneName)			
			
		else
		
			print("CreatBoneToEffect bonename err bonename =" .. boneName)
		end	
	
	end	
end

--特效删除接口支持骨骼绑定特效
local function DelArmature( Armature )
	local pArmature = tolua.cast(Armature, "CCArmature")
	if pArmature ~= nil then 
	
		local pbone = pArmature:getParentBone() 
	
		if pbone ~= nil then
				
			local parArmature = pbone:getArmature()
			if parArmature ~= nil then 				
				pbone:autorelease()
				pbone:retain()
				parArmature:removeBone(pbone,true)					
			else
				print("DelArmature error parArmature = NULL")			
				
			end				
		
		else
			Armature:removeFromParentAndCleanup(true)			
		end
	else
		print("DelArmature error")	
	end	
end


local function CreatRenderData(self,iEffectID,pRanderRoot,pTarObj,bUseEffectEx)	
	
	self:Fun_SetEffectID(iEffectID)		
	
	local function onEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)	
	
		if evt == FrameEvent_Key.Event_Vibration then			
			 VibrationSceen(3)										   
		end
	end
	
	--//技能特效回调 播放完自动删除 
	local function onEffectMovementEvent(Armature, MovementType, movementID)

		if MovementType == MovementEventType.start	then
		
		elseif MovementType == MovementEventType.complete then		
		
			local iEffectTag = Armature:getTag()	
			
			if iEffectTag ~= nil and iEffectTag > 0 then
				
				if iEffectTag ~= self.m_ID then
					print("特效数据错误跟self不一致")
					Pause()
				end
								
				if self.m_EffectParm.bBuffTYpe ~= nil and self.m_EffectParm.bBuffTYpe == 1 then 						
					Armature:getAnimation():playWithIndex(1)						
				else						
					DeleteEffectObj(iEffectTag)									
				end					
			else				
				--DeleteEffectObj(self.m_ID)	
				DelArmature(Armature)
			end
		
		elseif MovementType == MovementEventType.loopComplete then
		
			--//每次循环完检测是不是要删除 给buff用 频率太快还是开计时器吧

		end
	end
	
	--------------------------------------------------------------------------
	local pEffectData = EffectData.getDataById( iEffectID)

	--//添加
	local pArmature = nil	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName")])	
	pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName")])
		
	if pTarObj:Fun_IsNpc() == false then	
		--//翻转特效
		pArmature:setScaleX(-(pArmature:getScaleX()))
	end			
	pArmature:setScale(tonumber(pEffectData[EffectData.getIndexByField("Scale")]))		
	pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder")])+pTarObj:Fun_getZOrder())		
	pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_0")]))
		
	pArmature:setTag(self.m_ID)	
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)	
	
	local pbindbone = tonumber(pEffectData[EffectData.getIndexByField("bindbone")])	
	local pbindArmature = tonumber(pEffectData[EffectData.getIndexByField("bindAnimation")])	
	
	if  pbindArmature > 0 then 
			
		if pbindbone > 0  then
			
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( 0 , pTarObj:Fun_getModeHeight()+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, pTarObj:Fun_getModeHeight()*0.5))	
			end			
		else			
			pArmature:setPosition(ccp( 0 , 0))					
		end
		
		if tonumber(pEffectData[EffectData.getIndexByField("effectzorder")]) <0 then		
			
			CreatbindBoneToEffect(pArmature,pTarObj:Fun_GetRender_Armature(),pEffectData[EffectData.getIndexByField("bonename")],0)
			
		else					
			
			CreatbindBoneToEffect(pArmature,pTarObj:Fun_GetRender_Armature(),pEffectData[EffectData.getIndexByField("bonename")],Play_Effect_Z)			
		end
				
	else	
			--//是否绑定骨骼 计算旋转		 
		if pbindbone > 0  then			
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()+10))	
			else
				pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5))	
			end
		else
			pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY()))	
		end
		
				
		if tonumber(pEffectData[EffectData.getIndexByField("effectzorder")]) <0 then
			pRanderRoot:addChild(pArmature,0)
		else
			pRanderRoot:addChild(pArmature)
		end						
	
	end
	self.m_RenderData.m_pArmature = pArmature
	
	---add by sxin 扩展被打特效显示多个组合
	if bUseEffectEx == true then
	
		if pEffectData[EffectData.getIndexByField("fileName1")] ~= nil then
			
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName1")])		
			pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName1")])	
			
			if pTarObj:Fun_IsNpc() == false then	
				--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end		
					
			pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY()))			
			pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder1")])+pTarObj:Fun_getZOrder())			
			pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_1")]))
			
			pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
			--pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
			local pbindbone1 = tonumber(pEffectData[EffectData.getIndexByField("bindbone1")])	
			
			if  pbindArmature > 0 then 			
				if pbindbone1 > 0  then					
					if pbindbone1 == 6 then --头顶
						pArmature:setPosition(ccp( 0 , pTarObj:Fun_getModeHeight()+Off_Effect_head))	
					else
						pArmature:setPosition(ccp( 0, pTarObj:Fun_getModeHeight()*0.5))	
					end					
				else					
					pArmature:setPosition(ccp( 0 , 0))						
				end
				
				if tonumber(pEffectData[EffectData.getIndexByField("effectzorder1")]) <0 then
					pTarObj:Fun_GetRender_Armature():addChild(pArmature,0)					
				else
							
					pTarObj:Fun_GetRender_Armature():addChild(pArmature,Play_Effect_Z)		
				end	
					
				--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
				
			else
			
					--//是否绑定骨骼 计算旋转		 
				if pbindbone1 > 0  then
					
					if pbindbone1 == 6 then --头顶
						pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()+10))	
					else
						pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5))	
					end	
					
				else					
					pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY()))							
				end		
				
				if tonumber(pEffectData[EffectData.getIndexByField("effectzorder1")]) <0 then
					pRanderRoot:addChild(pArmature,0)
				else
					pRanderRoot:addChild(pArmature)
				end				
			end	
			self.m_RenderData.m_pArmature1 = pArmature
		end
		
		if pEffectData[EffectData.getIndexByField("fileName2")] ~= nil then
			
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName2")])		
			pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName2")])			
			
			if pTarObj:Fun_IsNpc() == false then	
				--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end		
					
			pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY()))	
			pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder2")])+pTarObj:Fun_getZOrder())			
			pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_2")]))
			
			pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
			--pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
			local pbindbone2 = tonumber(pEffectData[EffectData.getIndexByField("bindbone2")])	
			
			if  pbindArmature > 0 then 
			
				if pbindbone2 > 0  then
					
					if pbindbone2 == 6 then --头顶
						pArmature:setPosition(ccp( 0 , pTarObj:Fun_getModeHeight()+Off_Effect_head))	
					else
						pArmature:setPosition(ccp( 0, pTarObj:Fun_getModeHeight()*0.5))	
					end
				else					
					pArmature:setPosition(ccp( 0 , 0))						
				end
				
				if tonumber(pEffectData[EffectData.getIndexByField("effectzorder2")]) <0 then
					pTarObj:Fun_GetRender_Armature():addChild(pArmature,0)						
				else							
					pTarObj:Fun_GetRender_Armature():addChild(pArmature,Play_Effect_Z)		
				end		
				
				--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
				
			else			
				--//是否绑定骨骼 计算旋转		 
				if pbindbone2 > 0  then
					
					if pbindbone2 == 6 then --头顶
						pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()+10))	
					else
						pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5))	
					end		
					
				else					
					pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY()))					
				end
						
				if tonumber(pEffectData[EffectData.getIndexByField("effectzorder2")]) <0 then
					pRanderRoot:addChild(pArmature,0)
				else
					pRanderRoot:addChild(pArmature)
				end				
			end		
			self.m_RenderData.m_pArmature2 = pArmature
		end
	end
		
end

local function CreatBulletRenderData(self,iEffectID,pRanderRoot,pSourceObj,pTarObj,pBone,iFightTimes,pCallBack)	

	self:Fun_SetEffectID(iEffectID)			
	local function onEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)	
	
		if evt == FrameEvent_Key.Event_Vibration then			
			 VibrationSceen(3)										   
		end
	end
	
	local pEffectbulletData = EffectData.getDataById( iEffectID)
	local pbindbone = tonumber(pEffectbulletData[EffectData.getIndexByField("bindbone")])
	local pMoveTo = nil		
	
	--//添加
	local pArmature = nil	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbulletData[EffectData.getIndexByField("fileName")])	
	pArmature = CCArmature:create(pEffectbulletData[EffectData.getIndexByField("EffectName")])	
	pArmature:setScale(tonumber(pEffectbulletData[EffectData.getIndexByField("Scale")]))		
	
	-----------------------------
	local speed = tonumber(pEffectbulletData[EffectData.getIndexByField("speed")])
	local fDis = ccpDistance( ccp(pSourceObj:Fun_getPosition()),ccp(pTarObj:Fun_getPosition()))
	local fMoveTime = fDis/speed
	--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
	if speed <100 then	
		fMoveTime = speed/24
	end	
		
	--//是否绑定骨骼 计算旋转
	 
	if pbindbone > 0 and pBone ~= nil then		
		
		if pbindbone == 1 then --骨骼旋转
		
			if pSourceObj:Fun_getScaleX() > 0 then				
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() + pBone:nodeToArmatureTransform().tx, pSourceObj:Fun_getPositionY() + pBone:nodeToArmatureTransform().ty))							
			else			
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() - pBone:nodeToArmatureTransform().tx, pSourceObj:Fun_getPositionY() + pBone:nodeToArmatureTransform().ty))			
			end 					
			
			local bulletPos = ccp(pArmature:getPosition())
			local targetPos = ccp(pTarObj:Fun_getPositionX(),(pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5))

			local angle = GetPointAngle(bulletPos,targetPos)
			
			--增加 动画翻转不是完全靠旋转
			if pTarObj:Fun_IsNpc() == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end
			
			if pArmature:getScaleX() < 0 then
				--print(angle)
				angle = angle + 180				
				--print(angle)
				--Pause()
			end			
		
			pArmature:setRotation( angle )	
			fDis = ccpDistance( bulletPos,targetPos)
			--fDis = math.abs( bulletPos.x - targetPos.x)			
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end			
			pMoveTo = CCMoveTo:create(fMoveTime,targetPos)	

		elseif pbindbone == 2 then --骨骼位置和目标点直线类型 以自己的的线路吧
					
			if pSourceObj:Fun_getScaleX() > 0 then				
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() + pBone:nodeToArmatureTransform().tx, pSourceObj:Fun_getPositionY()))							
			else			
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() - pBone:nodeToArmatureTransform().tx, pSourceObj:Fun_getPositionY()))			
			end 	
							
				
			fDis = ccpDistance( ccp(pArmature:getPosition()),ccp(pTarObj:Fun_getPosition()))
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end
		
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pTarObj:Fun_getPositionX(),pArmature:getPositionY()))	
			
			if pTarObj:Fun_IsNpc() == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end
		
			
		elseif pbindbone == 3 then --骨骼位置和目标点直线类型 初始位置在屏幕外边
		
			--计算屏幕外坐标
			local rect = pArmature:boundingBox()			
			local pSceneX = (iFightTimes-1)*DefineWidth - rect.size.width*0.5
			
			if pTarObj:Fun_IsNpc() == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))				
				pSceneX = iFightTimes*DefineWidth + rect.size.width*0.5		
			end
		
			fDis = ccpDistance( ccp(pSceneX,pTarObj:Fun_getPositionY()),ccp(pTarObj:Fun_getPosition()))
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end
	
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pTarObj:Fun_getPosition()))			
			pArmature:setPosition(ccp( pSceneX , pTarObj:Fun_getPositionY()))	
			
		elseif pbindbone == 4 then --骨骼位置和目标点直线类型 结束位置在屏幕外边
		
			--计算屏幕外坐标
			local rect = pArmature:boundingBox()				
			local pSceneX = iFightTimes*DefineWidth + rect.size.width*0.5	
			
			if pTarObj:Fun_IsNpc() == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))				
				pSceneX = (iFightTimes-1)*DefineWidth - rect.size.width*0.5			
			end
		
			fDis = ccpDistance( ccp(pTarObj:Fun_getPosition()),ccp(pSceneX,pTarObj:Fun_getPositionY()))
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pSceneX,pTarObj:Fun_getPositionY()))
			
			if pSourceObj:Fun_getScaleX() > 0 then				
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() + pBone:nodeToArmatureTransform().tx, pTarObj:Fun_getPositionY()))							
			else			
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() - pBone:nodeToArmatureTransform().tx, pTarObj:Fun_getPositionY()))			
			end 			
			
		elseif pbindbone == 5 then --屏幕外到屏幕外
		
			--计算屏幕外坐标
			local rect = pArmature:boundingBox()				
			local pSceneStarX = (iFightTimes-1)*DefineWidth - rect.size.width*0.5			
			local pSceneEndX = iFightTimes*DefineWidth + rect.size.width*0.5		
			
			if pTarObj:Fun_IsNpc() == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
				
				pSceneStarX = iFightTimes*DefineWidth + rect.size.width*0.5
				pSceneEndX = (iFightTimes-1)*DefineWidth - rect.size.width*0.5
			end
			
		
			fDis = DefineWidth + rect.size.width*2
			fMoveTime = fDis/speed
			--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
			if speed <100 then	
				fMoveTime = speed/24
			end
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pSceneEndX,pTarObj:Fun_getPositionY()))
				
			pArmature:setPosition(ccp( pSceneStarX, pTarObj:Fun_getPositionY() ))			
			
		else
		
		end
		
	
	else
	
		pMoveTo = CCMoveTo:create(fMoveTime,ccp(pTarObj:Fun_getPosition()))
		if pTarObj:Fun_IsNpc() == false then		
			--//翻转特效
			pArmature:setScaleX(-(pArmature:getScaleX()))
		end
		pArmature:setPosition(pSourceObj:Fun_getPosition())	
	end	
	
	--判断目标和自己谁的zorder高
	if pTarObj:Fun_getZOrder() > pSourceObj:Fun_getZOrder() then
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pTarObj:Fun_getZOrder())
	else
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pSourceObj:Fun_getZOrder())
	end	
	pArmature:getAnimation():playWithIndex( tonumber(pEffectbulletData[EffectData.getIndexByField("AnimationID_0")]))
		
	pArmature:setTag(self.m_ID)	
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	
	local function OnEffectArrive(pNode)		
			--//删除子弹特效
		local pArmature = tolua.cast(pNode, "CCArmature")		
		
			local iEffectTag = pArmature:getTag()	
			
			if iEffectTag ~= nil and iEffectTag > 0 then
				
				if iEffectTag ~= self.m_ID then
					print("特效数据错误跟self不一致")
					Pause()
				else
					DeleteEffectObj(iEffectTag)		
				end											
							
			else				
				--DeleteEffectObj(self.m_ID)	
				DelArmature(Armature)
			end
	
	end
	
	local pcallFuncEffectArrive = CCCallFuncN:create(OnEffectArrive)
	
	--//damage
	local pcallFuncDamage = CCCallFuncN:create(pCallBack)	
	
	local arr = CCArray:create()
			arr:addObject(pMoveTo)	
			arr:addObject(pcallFuncDamage)
			arr:addObject(pcallFuncEffectArrive)		
	local pSequence  = CCSequence:create(arr)		
	pArmature:runAction(pSequence)
	self.m_RenderData.m_pArmature = pArmature
	pRanderRoot:addChild(pArmature)
				
end

local function CreatBulletparabolicRenderData(self,iEffectID,pRanderRoot,pSourceObj,pTarObj,pBone,pCallBack)

	self:Fun_SetEffectID(iEffectID)			
	local function onEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)	
	
		if evt == FrameEvent_Key.Event_Vibration then			
			 VibrationSceen(3)										   
		end
	end
	
	local pEffectbulletData = EffectData.getDataById( iEffectID)
	local pbindbone = tonumber(pEffectbulletData[EffectData.getIndexByField("bindbone")])
	local pMoveTo = nil		
	
	--//添加
	local pArmature = nil	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbulletData[EffectData.getIndexByField("fileName")])	
	pArmature = CCArmature:create(pEffectbulletData[EffectData.getIndexByField("EffectName")])	
	pArmature:setScale(tonumber(pEffectbulletData[EffectData.getIndexByField("Scale")]))		
	
	
	local speed = tonumber(pEffectbulletData[EffectData.getIndexByField("speed")])
	--local fDis = ccpDistance( ccp(pSourceObj:Fun_getPosition()),ccp(pTarObj:Fun_getPosition()))
	local fDis = math.floor(math.abs(pSourceObj:Fun_getPositionX() - pTarObj:Fun_getPositionX()))
	local fMoveTime = fDis/speed
	--add by sxin 增加子弹类型 》100的是速度 小于100的是帧数
	if speed <100 then	
		fMoveTime = speed/24
	end	
	
	local bezierTo1 = nil
	
	if pbindbone > 0 and pBone ~= nil then
		
		if pbindbone == 1 then --骨骼旋转
		
			if pSourceObj:Fun_getScaleX() > 0 then				
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() + pBone:nodeToArmatureTransform().tx, pSourceObj:Fun_getPositionY() + pBone:nodeToArmatureTransform().ty))							
			else			
				pArmature:setPosition(ccp( pSourceObj:Fun_getPositionX() - pBone:nodeToArmatureTransform().tx, pSourceObj:Fun_getPositionY() + pBone:nodeToArmatureTransform().ty))			
			end 		
			
			local bulletPos = ccp(pArmature:getPosition())
			local targetPos = ccp(pTarObj:Fun_getPosition())			

			local angle = GetPointAngle(bulletPos,targetPos) 
			
		
			if pTarObj:Fun_IsNpc() == false then				
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end
			
			if pArmature:getScaleX() < 0 then				
				angle = angle + 180						
			end			
			pArmature:setRotation( angle )		
		
			local offX = pSourceObj:Fun_getPositionX() - pTarObj:Fun_getPositionX()

			local bezier2 = ccBezierConfig()			
			
			bezier2.controlPoint_1 = ccp(pSourceObj:Fun_getPositionX() - offX*0.3, pSourceObj:Fun_getPositionY()+ 450)
			bezier2.controlPoint_2 = ccp(pSourceObj:Fun_getPositionX() - offX*0.6, pSourceObj:Fun_getPositionY()+ 350)
			
			bezier2.endPosition = ccp(pTarObj:Fun_getPosition())

			bezierTo1 = CCBezierTo:create(fMoveTime, bezier2)			
					
		end
		
	end
	
			--判断目标和自己谁的zorder高
	if pTarObj:Fun_getZOrder() > pSourceObj:Fun_getZOrder() then
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pTarObj:Fun_getZOrder())
	else
		pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pSourceObj:Fun_getZOrder())
	end	
	pArmature:getAnimation():playWithIndex( tonumber(pEffectbulletData[EffectData.getIndexByField("AnimationID_0")]))
		
	pArmature:setTag(self.m_ID)	
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	
	
	local nHanderTime = nil			
	local function OnEffectArrive(pNode)	
		--清除计数器
		if nHanderTime ~= nil then
			--print("tick" .. self.m_ID)
			--Pause()
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
			nHanderTime = nil
		end
		--//删除子弹特效
		local pArmatureNode = tolua.cast(pNode, "CCArmature")			
		local iEffectTag = pArmatureNode:getTag()			
		if iEffectTag ~= nil and iEffectTag > 0 then
			
			if iEffectTag ~= self.m_ID then
				print("特效数据错误跟self不一致")
				Pause()
			else
				DeleteEffectObj(iEffectTag)		
			end											
						
		else				
			--DeleteEffectObj(self.m_ID)	
			DelArmature(pArmatureNode)
		end	
	end
	

	self.m_EffectParm.m_oldPos = ccp(pArmature:getPosition())	
	local function tick(dt)			
		--print("tick" .. self.m_ID)
		if nHanderTime ~= nil then
			local pArmaturePos = pArmature:getPosition()
			if pArmaturePos ~= nil then
				local bulletPos = ccp(pArmature:getPosition())
				local angle = GetPointAngle(self.m_EffectParm.m_oldPos,bulletPos) 					
				pArmature:setRotation( angle )		
				self.m_EffectParm.m_oldPos = bulletPos	
			end				
		end
		
	end	
	
	local pcallFuncEffectArrive = CCCallFuncN:create(OnEffectArrive)
	
	--//damage
	local pcallFuncDamage = CCCallFuncN:create(pCallBack)	
	
	local arr = CCArray:create()
			arr:addObject(bezierTo1)
			arr:addObject(pcallFuncDamage)
			arr:addObject(pcallFuncEffectArrive)		
	
	local pSequence  = CCSequence:create(arr)		
	pArmature:runAction(pSequence)	
	nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(tick, 0.01, false)
	
	self.m_RenderData.m_pArmature = pArmature
	pRanderRoot:addChild(pArmature)

end

local function CreatEffectArmatureBindObj(self,iEffectID,pRanderRoot,pTarObj,pBone,iExInex)
	local function onEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)	
	
		if evt == FrameEvent_Key.Event_Vibration then			
			 VibrationSceen(3)										   
		end
	end
	--//技能特效回调 播放完自动删除 
	local function onEffectMovementEvent(Armature, MovementType, movementID)

		if MovementType == MovementEventType.start	then
		
		elseif MovementType == MovementEventType.complete then		

			Armature:getAnimation():playWithIndex(1)
				
		elseif MovementType == MovementEventType.loopComplete then
		
			--//每次循环完检测是不是要删除 给buff用 频率太快还是开计时器吧

		end
	end	
	
	local Strbindbone = "bindbone"
	local StrfileName = "fileName"
	local StrEffectName = "EffectName"
	local Streffectzorder = "effectzorder"
	local Strbonename = "bonename" 
	if iExInex >0 then
		Strbindbone = "bindbone" .. iExInex
		StrfileName = "fileName" .. iExInex
		StrEffectName = "EffectName" .. iExInex
		Streffectzorder = "effectzorder" .. iExInex	
		Strbonename = "bonename" .. iExInex				
	end	
	
	local pEffectbuffData = EffectData.getDataById( iEffectID)
	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField(Strbindbone)])		
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	
	
	local pArmature = nil	
	if pEffectbuffData[EffectData.getIndexByField(StrfileName)] ~= nil then 	
		
		--print(pbindbone)
		--print(pbindArmature)
	
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField(StrfileName)])
		pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField(StrEffectName)])					
		pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField(Streffectzorder)])+pTarObj:Fun_getZOrder())
		
		if  pArmature:getAnimation():getMovementCount() > 1 then			
			--先出生 再循环
			pArmature:getAnimation():playWithIndex(0)				
			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)		
			
		else
			pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))
		end
		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)		
		
		--//是否绑定骨骼 计算旋转
		if  pbindArmature > 0 then 
			
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( 0 , pTarObj:Fun_getModeHeight()+Off_Effect_head))	
				else
					pArmature:setPosition(ccp( 0, pTarObj:Fun_getModeHeight()*0.5))	
				end				
			else
				
				pArmature:setPosition(ccp( 0 , 0))		
				
			end
			
			if tonumber(pEffectbuffData[EffectData.getIndexByField(Streffectzorder)]) <0 then
				
				CreatbindBoneToEffect(pArmature,pTarObj:Fun_GetRender_Armature(),pEffectbuffData[EffectData.getIndexByField(Strbonename)],0)
			else				
				CreatbindBoneToEffect(pArmature,pTarObj:Fun_GetRender_Armature(),pEffectbuffData[EffectData.getIndexByField(Strbonename)],Play_Effect_Z)
			end		
			
		else
		
				--//是否绑定骨骼 计算旋转		 
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()+10))	
				else
					pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5))	
				end				
			else				
				pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY()))					
			end
			
					
			if tonumber(pEffectbuffData[EffectData.getIndexByField(Streffectzorder)]) <0 then
				pRanderRoot:addChild(pArmature,0)
			else
				pRanderRoot:addChild(pArmature)
			end								
		
		end
		
		
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pTarObj:Fun_GetRender_Armature(),iSharder)
			self.m_EffectParm.m_iSharder = iSharder
		end	

		if iExInex == 0 then
			pArmature:setTag(self.m_ID)	
			self.m_RenderData.m_pArmature = pArmature
		elseif iExInex == 1 then
			self.m_RenderData.m_pArmature1 = pArmature
		else
			self.m_RenderData.m_pArmature2 = pArmature
		end
			
	end
	
	return pArmature
	
end

local function CreatBuffRenderData(self,iEffectID,pRanderRoot,pSourceObj,pTarObj,pBone,pCallBack,iBuffTImes,iBuffcd,BuffType)
		
	self:Fun_SetEffectID(iEffectID)		
	--[[
	local function onEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)	
	
		if evt == FrameEvent_Key.Event_Vibration then			
			 VibrationSceen(3)										   
		end
	end
	--//技能特效回调 播放完自动删除 
	local function onEffectMovementEvent(Armature, MovementType, movementID)

		if MovementType == MovementEventType.start	then
		
		elseif MovementType == MovementEventType.complete then		

			Armature:getAnimation():playWithIndex(1)
				
		elseif MovementType == MovementEventType.loopComplete then
		
			--//每次循环完检测是不是要删除 给buff用 频率太快还是开计时器吧

		end
	end	
	

	local pEffectbuffData = EffectData.getDataById( iEffectID)
	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])		
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])		
	
	if pEffectbuffData[EffectData.getIndexByField("fileName")] ~= nil then 	
			
		local pArmature = nil	
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
		pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])					
		pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pTarObj:Fun_getZOrder())
		
		if  pArmature:getAnimation():getMovementCount() > 1 then			
			--先出生 再循环
			pArmature:getAnimation():playWithIndex(0)				
			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)		
			
		else
			pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))
		end
		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
		pArmature:setTag(self.m_ID)	
		self.m_RenderData.m_pArmature = pArmature
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pTarObj:Fun_GetRender_Armature(),iSharder)
			self.m_EffectParm.m_iSharder = iSharder
		end		
		
					--//是否绑定骨骼 计算旋转
		if  pbindArmature > 0 then 
			
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( 0 , pTarObj:Fun_getModeHeight()+Off_Effect_head))	
				else
					pArmature:setPosition(ccp( 0, pTarObj:Fun_getModeHeight()*0.5))	
				end				
			else
				
				pArmature:setPosition(ccp( 0 , 0))		
				
			end
			
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				
				CreatbindBoneToEffect(pArmature,pTarObj:Fun_GetRender_Armature(),pEffectbuffData[EffectData.getIndexByField("bonename")],0)
			else				
				CreatbindBoneToEffect(pArmature,pTarObj:Fun_GetRender_Armature(),pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
			end		
			
		else
		
				--//是否绑定骨骼 计算旋转		 
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()+10))	
				else
					pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5))	
				end				
			else				
				pArmature:setPosition(ccp( pTarObj:Fun_getPositionX() , pTarObj:Fun_getPositionY()))					
			end
			
					
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				pRanderRoot:addChild(pArmature,0)
			else
				pRanderRoot:addChild(pArmature)
			end								
		
		end		
						
		local buffitmes = 1
		local bufftime =0
		local function bufftick(dt)		
			
			if buffitmes > iBuffTImes  or ( pTarObj.Fun_IsDie ~= nil and pTarObj:Fun_IsDie() == true )then
				
				--print(buffitmes)
				--print(iBuffTImes)				
				--print("bufftick timeover ")
				--Pause()
				
				if self.m_EffectParm.m_nHanderTime ~= nil then
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_EffectParm.m_nHanderTime)
					self.m_EffectParm.m_nHanderTime = nil							
				end	
				
				if iSharder > 0 then			
					CCArmatureSharder(pTarObj:Fun_GetRender_Armature(),SharderKey.E_SharderKey_Normal)	
					self.m_EffectParm.m_iSharder = 0					
				end	
				DeleteEffectObj(self.m_ID)					
			else				
				bufftime = bufftime+G_Fight_BUff_Tick_Time
				if bufftime >= iBuffcd then
					bufftime = 0
					buffitmes = buffitmes + 1	
					if pCallBack ~= nil then
						pCallBack()
					end					
				end				
									
			end		
			
		end			
			
		self.m_EffectParm.m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)		
	end
	]]--
	
	
	CreatEffectArmatureBindObj(self,iEffectID,pRanderRoot,pTarObj,pBone,0)	
	CreatEffectArmatureBindObj(self,iEffectID,pRanderRoot,pTarObj,pBone,1)	
	CreatEffectArmatureBindObj(self,iEffectID,pRanderRoot,pTarObj,pBone,2)
	
	local buffitmes = 1
	local bufftime =0
	local pArmatureTar = pTarObj:Fun_GetRender_Armature()
	local function bufftick(dt)		
		
		if buffitmes > iBuffTImes  or ( pTarObj.Fun_IsDie ~= nil and pTarObj:Fun_IsDie() == true )then
			
			--print(buffitmes)
			--print(iBuffTImes)				
			--print("bufftick timeover ")
			--Pause()
			
			if self.m_EffectParm.m_nHanderTime ~= nil then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_EffectParm.m_nHanderTime)
				self.m_EffectParm.m_nHanderTime = nil							
			end	
			
			if self.m_EffectParm.m_iSharder > 0 then			
				CCArmatureSharder(pArmatureTar,SharderKey.E_SharderKey_Normal)	
				self.m_EffectParm.m_iSharder = 0					
			end	
			
			if self.m_EffectParm.m_State == DamageState.E_DamageState_xuanyun then
				--清除定身
				--print("时间到清除定身")				
				resumeSchedulerAndActions(pArmatureTar)		
			end
			DeleteEffectObj(self.m_ID)					
		else				
			bufftime = bufftime+G_Fight_BUff_Tick_Time
			
			if bufftime >= iBuffcd then
				bufftime = 0
				buffitmes = buffitmes + 1	
				if pCallBack ~= nil then
					pCallBack()
				end	
			else
				if self.m_EffectParm.m_State > 0 then
					if pTarObj ~= nil and pTarObj:Fun_GetFightDataParm().m_buff_state ~= self.m_EffectParm.m_State then
						DeleteEffectObj(self.m_ID)
						--print("buff 状态改变深处")
						--Pause()
					end
				end
			end				
								
		end		
		
	end			
		
	self.m_EffectParm.m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)		

end


local function GetRender_Armature(self)
	
	--暂时只有动画
	return self.m_RenderData.m_pArmature
end

local function IsEffect(self)	
	
	return (self.m_Type ==  Effect_Type.Type_Effect)
end

local function IsBullet(self)	
	
	return (self.m_Type ==  Effect_Type.Type_Bullet)
end
local function IsBuff(self)	
	
	return (self.m_Type ==  Effect_Type.Type_Buff)
end


local function SetEffectID(self,EffectID)		
	self.m_EffectID = EffectID
	
end

local function SetTagObj(self,pObj)	
	
	self.m_EffectParm.m_pTarObj = pObj
end

local function GetTagObj(self)	
	
	return self.m_EffectParm.m_pTarObj
end

local function GetEffectParm(self)		
	return self.m_EffectParm
end

local function SetEffectState(self,eState)
	self.m_EffectParm.m_State = eState
end

-- 对引擎播放的接口支持

local function Obj_play_Name(self,AniName)	
	
	self.m_RenderData.m_pArmature:getAnimation():play(AniName)
end


local function Obj_runAction(self,pAct)		
	self.m_RenderData.m_pArmature:runAction(pAct)
end

local function GetCurrentMovementID(self)		
	return self.m_RenderData.m_pArmature:getAnimation():getCurrentMovementID()
end

local function Obj_getPosition(self)		
	return self.m_RenderData.m_pArmature:getPosition()
end


local function Obj_getZOrder(self)		
	return self.m_RenderData.m_pArmature:getZOrder()
end


local function Release(self)

	if self.m_EffectParm.m_nHanderTime ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_EffectParm.m_nHanderTime)
		self.m_EffectParm.m_nHanderTime = nil							
	end
	
	DelArmature(self.m_RenderData.m_pArmature)
	
	if self.m_RenderData.m_pArmature1 ~= nil then
		DelArmature(self.m_RenderData.m_pArmature1)
	end
	
	if self.m_RenderData.m_pArmature2 ~= nil then
		DelArmature(self.m_RenderData.m_pArmature2)
	end	
	
	self = nil	
end

local function CreateEffectObj()

	local Obj = {
			-- 创建接口
			Fun_Release = Release,
			Fun_SetEffectID = SetEffectID,			
			Fun_IsEffect = IsEffect ,					
			Fun_IsBullet = IsBullet,
			Fun_IsBuff = IsBuff,
			
			--渲染层接口
			Fun_CreatRenderData = CreatRenderData,
			Fun_CreatBulletRenderData = CreatBulletRenderData,
			Fun_CreatBulletparabolicRenderData = CreatBulletparabolicRenderData,
			Fun_CreatBuffRenderData = CreatBuffRenderData,
			Fun_GetRender_Armature = GetRender_Armature ,	
			Fun_play_Name	= Obj_play_Name,
			Fun_runAction	= Obj_runAction,
			Fun_getPosition = Obj_getPosition,
			Fun_GetCurrentMovementID = GetCurrentMovementID,
			Fun_getZOrder = Obj_getZOrder,
			-- 战斗接口				
			Fun_SetTagObj	= SetTagObj,
			Fun_GetTagObj	= GetTagObj,
			Fun_GetEffectParm	= GetEffectParm,
			Fun_SetEffectState = SetEffectState,
					
			m_RenderData = {	
							m_pArmature = nil, 
							m_pArmature1 = nil,
							m_pArmature2 = nil,
									
							},		
			m_EffectParm = { 								
							m_TarObj = nil,	
							m_SourceObj = nil,							
							m_State	= -1,							
							m_EffectType = -1,							
							m_iDamage = 0,	
							m_HitPos = {},
							m_bMusHit = false,
							m_BulltHitEffectID = -1,
							m_oldPos = nil,
							m_iSharder = 0,
							m_nHanderTime = nil,
							},
			--变量
			m_Type = Effect_Type.Type_Obj,		
			m_EffectID = -1,
			m_ID = CreatID()
			}
			
	g_EffectObjTable[Obj.m_ID] = Obj			
	return Obj
end

function CreatEffectObj()

	local Obj = CreateEffectObj()
	Obj.m_Type = Effect_Type.Type_Effect
	return Obj
end

function CreatBulletObj()
	local Obj = CreateEffectObj()
	Obj.m_Type = Effect_Type.Type_Bullet
	return Obj
end

function CreatBuffObj()
	
	local Obj = CreateEffectObj()
	Obj.m_Type = Effect_Type.Type_Buff
	return Obj
end

function DeleteEffectObj( iID )
	
	g_EffectObjTable[iID]:Fun_Release()
	g_EffectObjTable[iID] = nil
end








