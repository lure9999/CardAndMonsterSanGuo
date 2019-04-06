
--add by sxin 场景脚本
--场景id = 1的脚本

module("scene_3", package.seeall)
local BossPos = 18
--战斗波数
function StarFight(self, times )	
	
	self.m_Times = times
		
	--print("scene_3:StarFight: times = " .. times)
	
	local function Callback(nCurTalkId, nNextTalkId)
				
		local pBoss = BaseSceneDB.GetPlayArmature(BossPos)
		 
		
		if 	tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 1 then  
		
			--Pause()
			
			--播放龙出来的动画
			local m_pGameNode_Middle = self.m_ScenceRoot:getChildByTag(12000)			
						
			local pCCComRenderLong = tolua.cast(m_pGameNode_Middle:getChildByTag(12000):getChildByTag(14143):getComponent("CCArmature"),"CCComRender")
			
			local pLong = tolua.cast(pCCComRenderLong:getNode(),"CCArmature")
			
			local pCCComRenderLongwei = tolua.cast(m_pGameNode_Middle:getChildByTag(12000):getChildByTag(14116):getComponent("CCArmature"),"CCComRender")
			
			local pLongwei = tolua.cast(pCCComRenderLongwei:getNode(),"CCArmature")
			
			local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
	     
					if evt == "VibrationSceen" then
					   
					   BaseSceneLogic.VibrationSceen(1)
										   
					end
			end

			
			local function onMovementEvent(Armature, MovementType, movementID)

				if MovementType == 0	then

				
				elseif MovementType == 1 then
				
					--print("movementID" .. movementID)
					if 	movementID == "birth" then	
					
						Armature:setVisible(false)
						pLongwei:getAnimation():play("stand")
						
						if pBoss ~= nil then
						
							--设置boss位置 
							--5号位置
							--pBoss:setPosition(ccp(pBoss:getPositionX()-22,247))
							
							--3号位置
							pBoss:setPosition(ccp(pBoss:getPositionX()+128,247))
							--设置boss血条位置 因为太大看不到血条需要调整
						--	local pHpBack = pBoss:getChildByTag(19999)
						--	pHpBack:setPositionY(pHpBack:getPositionY()-250)
						--	pHpBack:setScaleX(pHpBack:getScaleX()*2)
							
						--	local pHp = pBoss:getChildByTag(20000)
						--	pHp:setPositionY(pHp:getPositionY()-250)
						--	pHp:setScaleX(pHp:getScaleX()*2)
							
							pBoss:setVisible(true)
							pBoss:getAnimation():play("stand")
						else
							--Pause()
						end
						
						Callback(0,6)						
					end
				
				elseif MovementType == 2 then
				
					
				end
			end
			
			if pLong ~= nil and pLongwei ~= nil then 
				
				pLong:getAnimation():setMovementEventCallFunc(onMovementEvent)
				pLong:getAnimation():setFrameEventCallFunc(onFrameEvent)
				pLong:getAnimation():play("birth")
				pLongwei:getAnimation():play("birth")
				AudioUtil.playEffect("audio/death/yanlong_birth.mp3",false)
				
			end			
		else
			
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 6 then
			-- 对话结束					
			self.m_ScenceInterface:StarFight()
			
		end
		
		
	end
	
	--test ---第3次调用龙出场
	if times == 3 then

		BaseSceneLogic.VibrationSceen(3)
		
		Callback(0,1)	
		
		return true
	
	end	
	
	return false
		
end


--战斗波数
function EndFight( self,times )		
	
	--print("scene_3:EndFight: times = " .. times)
	
	--test-加血
	if times <= 2 then 	
		scene_logic.TeamPlayRecovery()		
	end
	
	
	--test ---第3次调用对话
	if times == 2 then 
		
		local pBoss = BaseSceneDB.GetPlayArmature(BossPos)
		
		if pBoss ~= nil then
			pBoss:setVisible(false)	
			
			
		end
		
		--return true
	
	end	
	
	FightUILayer.TakeAllBox()
	
	return false
		
end

--死亡触发事件 死亡索引 攻击者索引
function Die( self,DiePos , attackPos )	
	
	--print("scene_3:Die: DiePos = " .. DiePos .."attackPos =" .. attackPos)
	--test-加血
	scene_logic.PlayDropItem(self.m_Times,DiePos,attackPos)
	
	if DiePos == BossPos then
		
		local m_pGameNode_Middle = self.m_ScenceRoot:getChildByTag(12000)	
		local pCCComRenderLongwei = tolua.cast(m_pGameNode_Middle:getChildByTag(12000):getChildByTag(14116):getComponent("CCArmature"),"CCComRender")
			
		local pLongwei = tolua.cast(pCCComRenderLongwei:getNode(),"CCArmature")
		
		pLongwei:getAnimation():play("dead")
		
		
		
	end
		
end



local scene_3 = scene_logic.CreateBaseScene(3)

scene_3.Die = Die
scene_3.StarFight = StarFight
scene_3.EndFight = EndFight


return scene_3

