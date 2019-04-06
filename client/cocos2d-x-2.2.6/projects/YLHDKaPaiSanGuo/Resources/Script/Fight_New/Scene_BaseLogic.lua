
--场景逻辑方法类

module("Scene_BaseLogic", package.seeall)

require "Script/Fight_New/Scene_EffectObj" 



local g_EffectID = 1000
function CreatEffectBoneName()
	
	g_EffectID = g_EffectID + 1
	
	return "EffectBone" .. g_EffectID
	
end




--绑定真正的骨骼动画接口
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

function SetObjRenderFaceUiVisible(Armature,bVel)

	local pbone = Armature:getChildByTag(G_BloodBoneTag)
	
	local pboneBack = Armature:getChildByTag(G_BloodBackBoneTag)
	
	if pbone ~= nil and pboneBack ~= nil then 	
	
		local pHp = tolua.cast(pbone:getDisplayRenderNode(),"LoadingBar") 
		pHp:setVisible(bVel)	
				
		local pHpback = tolua.cast(pboneBack:getDisplayRenderNode(),"LoadingBar") 
		pHpback:setVisible(bVel)	
	
	else
		
		print(pbone)
		print(pboneBack)
		Pause()
		
	end
end

function SetObjUiVisible(pObj,bVel)

	local Armature = pObj:Fun_GetRender_Armature()
	SetObjRenderFaceUiVisible(Armature,bVel)
	
end 


function UpFighterEngine(pObj)

	print("UpFighterEngine")
	
end

function UpFighterObjBlood(pObj)
			
	local iPercent = pObj:Fun_GetBaseDB().m_curblood*100/pObj:Fun_GetBaseDB().m_allblood
	if iPercent > 100 then 
		iPercent = 100
	end
	
	if iPercent < 0 then 
		iPercent = 0
	end
			
	local pbone = pObj:Fun_GetRender_Armature():getChildByTag(G_BloodBoneTag)
	
	if pbone ~= nil then 
	
		local pHp = tolua.cast(pbone:getDisplayRenderNode(),"LoadingBar") 		
		
		if pHp ~= nil then 			
			pHp:setPercent(iPercent)	
		end		

		if pObj:Fun_IsNpc() == false then		
			--UI_pSetFightHp(ipos,iPercent)
		end	
	
	else
		print("UpFighterBlood err")
		Pause()
	end
		
end


function SetAnimationUiColour(Armature,Colour3)	
	--Pause()
	
	local pbone = Armature:getChildByTag(G_BloodBoneTag)
	
	local pboneBack = Armature:getChildByTag(G_BloodBackBoneTag)
	
	if pbone ~= nil and pboneBack ~= nil then 
	
		local pHp = pbone:getDisplayRenderNode() 
		pHp:setColor(Colour3)	
		
		
		local pHpback = pboneBack:getDisplayRenderNode() 
		pHpback:setColor(Colour3)	
		
	else
		print("SetAnimationUiColour err")
		Pause()
	end
		
end 


function SetNodeTimer(pNode,fTime, pcallFunc, iTagID)

	local pDelay = CCDelayTime:create(fTime)	
	local pSequence  = CCSequence:createWithTwoActions(pDelay, pcallFunc)
	pSequence:setTag(iTagID)
	pNode:runAction(pSequence)
end

function ObjUseSkill(pScence,pSkillData)
	
	if pScence:Fun_IsFightEnd() == true then
		return false
	end
	
	if pSkillData ~= nil then
		
		if pSkillData.m_pObj:Fun_IsDie() == true then		
			return true
		end	
		
		local pobj = pSkillData.m_pObj
		
		pobj:Fun_AddskillToStack(pSkillData)
			
		--判断是不是在释放动作中	
		if pobj:Fun_ISCanUseSkill() == true then 	
			OnFightLogic(pobj,pScence)			
		end	
		
	end

	return true
end

-- baseobj
function SetFight( pBaseObj, fTime,pScence)
 	
	local function OnFight(pNode)
	
		local pArmature = tolua.cast(pNode, "CCArmature")	
		pArmature:stopActionByTag(FightTimeIagID)

		if pBaseObj:Fun_IsDie() == true then	
			
			return
			
		end			
		
		--判断是不是眩晕中		
		if pBaseObj:Fun_CheckDamageState(DamageState.E_DamageState_xuanyun) == true then 	
			SetFight(pBaseObj,0.1,pScence)
		
			return
		end	
		
		--执行战斗逻辑	
		if pBaseObj:Fun_ISCanUseSkill() == true then 	
			OnFightLogic(pBaseObj,pScence)	
			
		else
			SetFight(pBaseObj,0.1,pScence)			
		end			
			
		
	end

	local pcallFunc = CCCallFuncN:create(OnFight)	
	SetNodeTimer(pBaseObj:Fun_GetRender_Armature(),fTime,pcallFunc,FightTimeIagID)

end

--开始出技能	
function StarSkillTimer(pScence)
 	
	function Skilltick(dt)	
		local iPlay_rand = math.random(1,100)
		local igroupIndex = 1
		if iPlay_rand < 50 then
			--主角
			igroupIndex = 1
			
		elseif iPlay_rand < 75 then
			igroupIndex = 2
		else
			igroupIndex = 3
		end
		pScence:Fun_AddSkillSkilltick(igroupIndex,1)
		
		-- 测试增加手动技能
		iPlay_rand = math.random(1,100)
		if iPlay_rand < 30 then
			pScence:Fun_AddSkillSkilltick(igroupIndex,2)
		end		
		
	end				
	pScence.m_nSkillHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(Skilltick, 1, false)	
	
end

--结束出技能
function EndSkillTimer(pScence)
 	if pScence.m_nSkillHanderTime ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(pScence.m_nSkillHanderTime)
		pScence.m_nSkillHanderTime = nil							
	end	
	
end


--开始战斗前出发脚本传入次数
function StarFight( pScence )	

	pScence.m_baseDB:Fun_SetFightEnd(false)
	
	local i = 1	
	local iTimes = pScence.m_baseDB.m_pSceneSprit.m_Times	
	
	for i=1, MaxTeamPlayCount, 1 do
		if  pScence.m_baseDB.m_FightTeamPlay[i] ~= nil then			
			SetFight(pScence.m_baseDB.m_FightTeamPlay[i],FightStarTimeinterval,pScence)				
		end	
		
		if  pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil then			
			SetFight(pScence.m_baseDB.m_FightTeamNpc[iTimes][i],FightStarTimeinterval,pScence)
		
		end		

	end	

	StarSkillTimer(pScence)	
	
end


function EndFight( pScence )	
	
	--print("EndFight")
	--UI_pEndFightByUI()
	--Pause()
	pScence.m_baseDB:Fun_SetFightEnd(true)
	
	local iTimes = pScence:Fun_GetFightTimes()
	
	--print("EndFight")
	--print(iTimes)
	--Pause()
	
	local i = 1	
	for i=1, MaxTeamPlayCount , 1 do	
		if pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then 		
			pScence.m_baseDB.m_FightTeamPlay[i]:Fun_GetRender_Armature():stopActionByTag(FightTimeIagID)			
			SetObjUiVisible(pScence.m_baseDB.m_FightTeamPlay[i],false)			
		end		

		if pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then 		
			
			pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_GetRender_Armature():stopActionByTag(FightTimeIagID)			
			SetObjUiVisible(pScence.m_baseDB.m_FightTeamNpc[iTimes][i],false)	
			
		end		
		
	end	
	
	EndSkillTimer(pScence)	
	--UI_pStopFightDelayTime()
	
	-- 推图波数对接
	
	if pScence.m_baseDB:Fun_GetFightResult() == 1 then
	
		if pScence.m_baseDB:Fun_GetFightTimes() < pScence.m_baseDB:Fun_GetAllimes() then	
		
			--print("E_FightTimer_ApplyFight curtime =" .. pScence.m_baseDB:Fun_GetFightTimes() .. "Allimes =" .. pScence.m_baseDB:Fun_GetAllimes())
			pScence:Fun_SetFightTimer(ApplyFightTime,E_FightTimer.E_FightTimer_ApplyFight)	
			
		else	
		
			pScence:Fun_SetFightTimer(ShowCheersTime,E_FightTimer.E_FightTimer_PlayCheers)
			
		end
		
	elseif pScence.m_baseDB:Fun_GetFightResult() == 0 then
	---失败
		if pScence:Fun_IsPKScene() == true then
			pScence:Fun_SetFightTimer(ShowCheersTime,E_FightTimer.E_FightTimer_PlayCheers)
		else			
			pScence:Fun_SetFightTimer(ShowFightResoutTime,E_FightTimer.E_FightTimer_ShowFightResout)
		end
	end	
	
	
end

--//战斗目标的逻辑
--//按对方角色的位置远近判断目标
local function GetFightTarPosByDis(pBaseObj,pScence)
	
	if pScence:Fun_IsFightEnd() == true then
		return nil
	end
	
	-----直接按顺序逻辑打		
	local Tarobj = nil
	local iFightTImes = pScence:Fun_GetFightTimes()	
	local iMinDis = 10000
	-- 玩家
	if pBaseObj:Fun_IsUser() == true then		
				 
		local i = 1					
		for i= 1, MaxTeamPlayCount, 1 do				
								
			if pScence.m_baseDB.m_FightTeamNpc[iFightTImes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iFightTImes][i]:Fun_IsDie() == false then			
								
				local temdis = ccpDistance( ccp(pBaseObj:Fun_getPosition()),ccp(pScence.m_baseDB.m_FightTeamNpc[iFightTImes][i]:Fun_getPosition()))
				
				if temdis < iMinDis then 
				
					iMinDis = temdis
					Tarobj = pScence.m_baseDB.m_FightTeamNpc[iFightTImes][i]					
				
				end	
						
			end
			
		end 			
	else--npc 
		local i = 1			
		for i= 1, MaxTeamPlayCount, 1 do
		
			if  pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then
				
								
				local temdis = ccpDistance( ccp(pBaseObj:Fun_getPosition()),ccp(pScence.m_baseDB.m_FightTeamPlay[i]:Fun_getPosition()))
				
				if temdis < iMinDis then 
				
					iMinDis = temdis
					Tarobj = pScence.m_baseDB.m_FightTeamPlay[i]				
				
				end	
			end
			
		end 				
		
	end	

	return Tarobj
	
end 

--//战斗目标的逻辑
local function GetFightTarPosByPos(pBaseObj,pScence)
	
	
	-----直接按顺序逻辑打
	
	local Tarobj = nil
	local iFightTImes = pScence:Fun_GetFightTimes()	
	-- 玩家
	if pBaseObj:Fun_IsUser() == true then		
				 
		local i = 1					
		for i= 1, MaxTeamPlayCount, 1 do				
								
			if pScence.m_baseDB.m_FightTeamNpc[iFightTImes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iFightTImes][i]:Fun_IsDie() == false then	
								
				Tarobj = pScence.m_baseDB.m_FightTeamNpc[iFightTImes][i]
				break		
			end
			
		end 			
	else--npc 
		local i = 1			
		for i= 1, MaxTeamPlayCount, 1 do
		
			if  pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then
												
				Tarobj = pScence.m_baseDB.m_FightTeamPlay[i]
				break		
			end
			
		end 				
		
	end	

	return Tarobj
end


function GetFightTarObj(pBaseObj,pScence)
	if pScence:Fun_IsPKScene() == true then 
		return GetFightTarPosByPos(pBaseObj,pScence)
	else
		return GetFightTarPosByDis(pBaseObj,pScence)
	end
	
end

local function GetTarBySiteType(plistTable ,iSiteType)
	local TarObj = nil
	
	if iSiteType == Site_Single_Param.Type_Random then --随机
		
		local icount = table.maxn(plistTable)
		if icount > 0 then 
			TarObj = plistTable[math.random(1, icount)]	
		end		
	
	elseif iSiteType == Site_Single_Param.Type_Blood_Min then --血最少
	
		local TempBlood = 99999999
		for k, v in pairs(plistTable) do
			
			local Tempvel = v:Fun_GetBloodRate()
			if Tempvel < TempBlood then 
				
				TempBlood = Tempvel
				TarObj = v
			end 
		end
		
	else
		print("GetTarBySiteType iSiteType Error iSiteType = " .. iSiteType)
	end
	
	return TarObj
end


-- 根据类型选择一个目标
local function GetSingleTarBySiteType(pTarObj,iSiteType)	
	
	local pScence = Scene_Manger.GetCurpScence()	
	
	if pTarObj:Fun_IsNpc() == true then 
			
		return GetTarBySiteType(pScence.m_baseDB:Fun_GetNpcList(),iSiteType)
		
	else--人
		
		return GetTarBySiteType(pScence.m_baseDB:Fun_GetPlayList(),iSiteType)
	
	end	
	
end



--拆分伤害算法逻辑
local function OnFightDamageLogic_0(pSourceObj)

		
	--//施法对象 1敌方单体	2敌方横排		3敌方纵列		4敌方全面		5暗杀，第一目标为从本排后面往前数，倒着打）		6左右击杀，对目标及上下左右攻击		7己方特定单体-(如果是加血技，则选血量最少的1个，如果是加士气的，同理选除自己之外士气最少的1个）
	--//	8己方横排【施法目标在哪排就加哪排】		9己方全体-【如果是加士气的，排除自己在外】		10暗杀后面横排
	
		
	--根据技能对象的类型来算伤害的人
	
	local pScence = Scene_Manger.GetCurpScence()	
	local iTimes = pScence:Fun_GetFightTimes()
	
	--print(iTimes)
	--Pause()
	
	local iIndex = 1	
	pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pSourceObj.m_FightDataParm.m_pTarObj	
	iIndex = iIndex+1	
	
	local iSkillIndex = pSourceObj:Fun_GetUseSkillIndex()
	local pSkillData = pSourceObj:Fun_GetSkillData(iSkillIndex)
	
	
	if pSkillData.m_site == Site_Type.Site_Enemy_Single_Param then --1敌方单体	
		if pSkillData.m_paramete > 0 then 			
			pSourceObj.m_FightDataParm.m_HurtPos[1] = GetSingleTarBySiteType(pSourceObj.m_FightDataParm.m_pTarObj,pSkillData.m_paramete)
		end		
			
	elseif pSkillData.m_site == Site_Type.Site_Enemy_Single then --1敌方单体		
			
	elseif pSkillData.m_site == Site_Type.Site_Enemy_Line then --2敌方横排		
				
		local iTarPos = pSourceObj.m_FightDataParm.m_pTarObj.m_Index		
		
		if iTarPos%2 == 0 then --2 4			
			
			if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
				if pScence.m_baseDB.m_FightTeamPlay[iTarPos -1] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos -1]:Fun_IsDie() == false then
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos -1]
				end	
			else
				if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -1] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -1]:Fun_IsDie() == false then
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -1]
				end	
			end						
			
		else --1 3 5

			if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
				if iTarPos < 5 and pScence.m_baseDB.m_FightTeamPlay[iTarPos +1] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos +1]:Fun_IsDie() == false then
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos +1]
				end
				
			else
				
				if iTarPos < 5 and pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +1] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +1]:Fun_IsDie() == false then
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +1]
				end
			
			end	
		
		end
	
	elseif pSkillData.m_site == Site_Type.Site_Enemy_Column then --3敌方纵列
					
		local iTarPos = pSourceObj.m_FightDataParm.m_pTarObj.m_Index	
		
		if iTarPos%2 == 0 then --2 4
			
			 if iTarPos == 2 then 
				
				if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos +2] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos +2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos +2]
					end
					
				else
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2]
					end
				
				end	
						
				
			 else
			 
				if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos -2] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos -2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos -2]
					end
					
				else
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2]
					end
				
				end	
				
			 end
			
			
		else --1 3 5
						
			if iTarPos == 1 then 				
				
				if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos +2] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos +2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos +2]
						iIndex = iIndex+1
					end
					
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos +4] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos +4]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos +4]
						iIndex = iIndex+1
					end
					
				else
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2]
						iIndex = iIndex+1
					end
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +4] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +4]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +4]
					end
				
				end					
				
			 elseif iTarPos == 3 then 
			 
				if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos -2] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos -2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos -2]
						iIndex = iIndex+1
					end
					
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos +2] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos +2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos +2]
						
					end
					
				else
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2]
						iIndex = iIndex+1
					end
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos +2]
					end
				
				end				
				
			else 
			
				
				if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos -4] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos -4]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos -4]
						iIndex = iIndex+1
					end
					
					if pScence.m_baseDB.m_FightTeamPlay[iTarPos -2] ~= nil  and  pScence.m_baseDB.m_FightTeamPlay[iTarPos -2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[iTarPos -2]
						
					end
					
				else
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -4] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -4]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -4]
						iIndex = iIndex+1
					end
					
					if pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2] ~= nil  and  pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2]:Fun_IsDie() == false then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][iTarPos -2]
					end
				
				end		
				
			end
		
		end
	
	elseif pSkillData.m_site == Site_Type.Site_Enemy_All then --敌方全面
		--print("敌方全面")
		--Pause()
		local iTarPos = pSourceObj.m_FightDataParm.m_pTarObj.m_Index	
		
		if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
			local i = 1		
			for i= 1, MaxTeamPlayCount, 1 do
				
				if i ~= iTarPos and pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then
					
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[i]
					iIndex = iIndex + 1
				end
				
			end 			
			
		else
			
			local i = 1		
			for i= 1, MaxTeamPlayCount, 1 do
				
				if i ~= iTarPos and pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then
					
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][i]
					iIndex = iIndex + 1
				end
				
			end 		
		
		end	
		
	
	elseif pSkillData.m_site == Site_Type.Site_Enemy_Scope then --范围攻击		
	
		--以目标为中心的范围攻击
		local iTarPos = pSourceObj.m_FightDataParm.m_pTarObj.m_Index	
		
		if pSourceObj.m_FightDataParm.m_pTarObj:Fun_IsUser() == true then 
			
			local i = 1		
			for i= 1, MaxTeamPlayCount, 1 do
				
				if i ~= iTarPos and pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then
				
					local temdis = ccpDistance( ccp(pSourceObj.m_FightDataParm.m_pTarObj:Fun_getPosition()),ccp(pScence.m_baseDB.m_FightTeamPlay[i]:Fun_getPosition()))
					
					if temdis <= pSkillData.m_SkillRadius then
																	
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[i]
						iIndex = iIndex + 1
					
					end
					
				end
				
			end 			
			
		else
			
			local i = 1		
			for i= 1, MaxTeamPlayCount, 1 do
				
				if i ~= iTarPos and pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then
								
					local temdis = ccpDistance( ccp(pSourceObj.m_FightDataParm.m_pTarObj:Fun_getPosition()),ccp(pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_getPosition()))
					if temdis <= pSkillData.m_SkillRadius then
						pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][i]
						iIndex = iIndex + 1
					end
				end
				
			end 		
		
		end	
		
		
		
	elseif pSkillData.m_site == Site_Type.Site_Self_Self then --自己
		--*********************************扩展自己逻辑*****************************************
		pSourceObj.m_FightDataParm.m_HurtPos[1] = pSourceObj
	
	elseif pSkillData.m_site == Site_Type.Site_Self_All then --己方全体
		iIndex = 1		
		if pSourceObj:Fun_IsUser() == true then 
			
			local i = 1					
			for i= 1, MaxTeamPlayCount, 1 do
				
				if pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then
					
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamPlay[i]
					iIndex = iIndex + 1
				end
				
			end 			
			
		else
			
			local i = 1		
			for i= 1, MaxTeamPlayCount, 1 do
				
				if pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then
					
					pSourceObj.m_FightDataParm.m_HurtPos[iIndex] = pScence.m_baseDB.m_FightTeamNpc[iTimes][i]
					iIndex = iIndex + 1
				end
				
			end 		
		
		end	
		
	elseif pSkillData.m_site == Site_Type.Site_Self_Single then ----己方单体体--param 存放选择类型 0 随即1血最少2….
			
		if pSkillData.m_paramete > 0 then 			
			pSourceObj.m_FightDataParm.m_HurtPos[1] = GetSingleTarBySiteType(pSourceObj,pSkillData.m_paramete)
		else
			pSourceObj.m_FightDataParm.m_HurtPos[1] = pSourceObj		
		end		
		
	else
	
	end

end

local function OnFightDamageLogic_1(pSourceObj)

		--[[
	//计算伤害
	////武将初始规则
	//	攻击力'attack' => 50,
	//	物防 'wufang' => 25,
	//	法防 'cefang' => 25,
	//	生命值 'hp' => 250

	//武将升级规则
	/*"  攻击力'attack' => 10,
	物防 'wufang' => 5,
	法防 'cefang' => 5,
	生命值 'hp' => 50"
	*/

	/*武将攻击力		（武器攻击力 + 武将初始攻击力 + 武将升级规则 * 等级）* 天赋攻击力
	武将物御		（装备物防 + 武将初始物防 + 武将升级规则 * 等级）* 天赋物防
	武将法防		（装备法防 + 武将初始法防 + 武将升级规则 * 等级）* 天赋法防
	武将生命值		（装备生命 + 武将初始生命 + 武将升级规则 * 等级）* （1 + （武将体力 - 50）/ 100））* 天赋生命
	武将战斗力		武将攻击力 * 2 + 武将物御 + 武将法防 + 武将生命值 / 5*/

/*	1、随机一个1到100的基数 hit_rand
	2、计算暴击 天赋crit > hit_rand 暴击成立
	3、被攻击武将位置---------------------------------------------------------------------------------------------------->
	4、命中--天赋中取
	5、计算闪避，识破， 随机rand1
		A物理 被攻击方躲闪天赋dodge - 攻击方命中 〉 躲闪随机rand1 躲闪成功
		B法术 被攻击方天赋penetrate - 攻击方命中 〉 躲闪随机rand1 识破成功
	6、伤害计算 
		A 区间计算 type_coe = （10 + （攻击方[武力或者智力] - 防御方[武力或者智力]）/ 10）/10
		B、调整区间  0.5 < type_coe < 1.5
	7、技能增益
		A、攻击类型  11施展伤害技能并恢复自身4点士气，同时血量每减少10%，技能伤害系数增加参数A ratio = ratio +　（（队伍ｈｐ　－攻击者ｈｐ）／队伍ｈｐ　＊　１０）技能paramete
		B、攻击类型　12血量每减少10%，技能伤害系数增加参数A　ratio = ratio +　（（队伍Hp　－攻击者Hp）／队伍Hp　*　１０）技能paramete
		C、攻击类型  14吸血，并且恢复4点士气，生命值低于20%后技能系数翻倍 ratio = 攻击者hp /队伍hp * 10) *技能paramete;
	8、基础战斗伤害 hurt = （攻击 - 防御）* type_coe * ratio
	9、暴击 hurt = hurt * 1.5
	10、未破防御 随机1-10 伤害
	11、吸血
	12、连击 技能的paramete >= (1-100)随机数
	13、消减士气 newpawer = 被攻击武将士气 - 技能paramete 负值取0
	*/
--]]

	local pScence = Scene_Manger.GetCurpScence()	
	local iTimes = pScence:Fun_GetFightTimes()
	local iSkillIndex = pSourceObj:Fun_GetUseSkillIndex()
	local pSkillData = pSourceObj:Fun_GetSkillData(iSkillIndex)
	local pTalentData = pSourceObj:Fun_GetTalent()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()

	local iHitposIndex = 1
	local Tarobj = pSourceObj.m_FightDataParm.m_pTarObj	
	for iHitposIndex= 1 , MaxTeamPlayCount, 1 do
		
		if pSourceObj.m_FightDataParm.m_HurtPos[iHitposIndex] ~= nil then 
			Tarobj = pSourceObj.m_FightDataParm.m_HurtPos[iHitposIndex]
		else
			return
		end
			
		
		local ihit_rand = math.random(1,100)
		
		--add by sxin 如果是pk需要服务器给随机值
		
		if NETWORKENABLE > 0 then
		
			if pScence:Fun_IsPKScene() == true then 
			
				--对接服务器的随机数据稍后对接
				--local iSeverRand = BaseSceneDB.GetPkData(pFightDataParm.m_FightPos)
				--if  iSeverRand >= 0 then 
				--	ihit_rand = iSeverRand					
				--end					
			end
			
		end
		
		
		local bCrit = false
		
		if pTalentData.m_crit>ihit_rand then
			bCrit = true
		end

		--增加手动技能能量增加限制几率的加成
		local fState_Rate = 1.0
		
		if pFightDataParm.m_iSkillRate == 2 then
			fState_Rate = 1.2
		elseif pFightDataParm.m_iSkillRate == 3 then
			fState_Rate = 1.5
		end
		
		
		
		local bShanbi = false
		local bshipo = false

		local type_coe = 0
		local fDamage_base = 0

		if pSkillData.m_power_type == 1 then --//物理攻击
		
			if Tarobj:Fun_GetTalent().m_duoshan - pTalentData.m_mingzhong >ihit_rand then
				bShanbi = true
			end
			

			type_coe = (10+(pSourceObj:Fun_GetBaseDB().m_attack - Tarobj:Fun_GetBaseDB().m_attack)*0.1)*0.1

			if type_coe <0.5 then
			
				type_coe = 0.5
			
			elseif type_coe >1.5 then
			
				type_coe = 1.5
			end

			fDamage_base = (pSourceObj:Fun_GetBaseDB().m_gongji - Tarobj:Fun_GetBaseDB().m_wufang)*type_coe;
		
		else
		
			if (Tarobj:Fun_GetTalent().m_penetrate - pTalentData.m_mingzhong)>ihit_rand then
				bshipo = true
			end
			
			type_coe = (10+(pSourceObj:Fun_GetBaseDB().m_wisdom - Tarobj:Fun_GetBaseDB().m_wisdom)*0.1)*0.1

			if (type_coe <0.5) then
			
				type_coe = 0.5
			
			elseif (type_coe >1.5) then
			
				type_coe = 1.5
			end

			fDamage_base = (pSourceObj:Fun_GetBaseDB().m_gongji - Tarobj:Fun_GetBaseDB().m_fafang)*type_coe
		end

		if fDamage_base <=0 then
		
			--fDamage_base = rand()%10 +1
			fDamage_base = ihit_rand%10 +1
			
		end

		if bCrit == true then
		
			fDamage_base =  fDamage_base *1.5
		end
		
		
		--------技能类型扩展---------------------------------
		if pSkillData.m_type == 1 then --////1普通技能无特效
		
			fDamage_base = fDamage_base * pSkillData.m_ratio
			
		elseif pSkillData.m_type == 2 then--//	2眩晕 伤害+眩晕Buff
		
			fDamage_base =  fDamage_base * pSkillData.m_ratio

			if pSkillData.m_buffchace*fState_Rate > ihit_rand then
						
				pFightDataParm.m_State = DamageState.E_DamageState_xuanyun		
				pFightDataParm.bufftimes = pSkillData.m_bufftimes
				pFightDataParm.bufftimecd = pSkillData.m_buffcd		
				pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
			end

		elseif pSkillData.m_type == 3 then--//3吸血（将技能伤害按百分比吸血）
			fDamage_base = fDamage_base *pSkillData.m_ratio
			local iaddhp = (fDamage_base*pSkillData.m_paramete)*0.01
			pFightDataParm.m_iParamDamage = iaddhp
		
		elseif pSkillData.m_type == 4 then--//4治疗 治疗是-伤害
			--//治疗就是伤害 根据攻击力和智力总和*技能系数
				fDamage_base = -((pSourceObj:Fun_GetBaseDB().m_gongji + pSourceObj:Fun_GetBaseDB().m_wisdom)*pSkillData.m_ratio)			
				
		elseif pSkillData.m_type == 5 then--//5概率2次连击
			fDamage_base = fDamage_base *pSkillData.m_ratio
			if pSkillData.m_paramete > ihit_rand then		
				pFightDataParm.m_iParamDamage = fDamage_base		
			else		
				pFightDataParm.m_iParamDamage = 0
			end
		elseif pSkillData.m_type == 6 then--//6消减对方士气
			fDamage_base = fDamage_base *pSkillData.m_ratio

			local ishiqi = Tarobj:Fun_GetBaseDB().m_anger - pSkillData.m_paramete;
			if ishiqi <0 then		
				ishiqi = Tarobj:Fun_GetBaseDB().m_anger		
			else		
				ishiqi = pSkillData.m_paramete
			end
			pFightDataParm.m_iParamDamage = ishiqi
		elseif pSkillData.m_type == 7 then--//7偷取敌方士气????
			fDamage_base = fDamage_base *pSkillData.m_ratio

			local ishiqi = Tarobj:Fun_GetBaseDB().m_anger - pSkillData.m_paramete
			if ishiqi <0 then
			
				ishiqi = pTeamDataTar.m_anger;
			
			else
			
				ishiqi = pSkillData.m_paramete
			end
			pFightDataParm.m_iParamDamage = ishiqi
		elseif pSkillData.m_type == 8 then--//8造成伤害并增益己方单体士气
			fDamage_base = fDamage_base *pSkillData.m_ratio

			pFightDataParm.m_iParamDamage = pSkillData.m_paramete
			
		elseif pSkillData.m_type == 9 then--//9造成伤害并增益己方全体士气。
			fDamage_base = fDamage_base *pSkillData.m_ratio
			pFightDataParm.m_iParamDamage = pSkillData.m_paramete
			
		elseif pSkillData.m_type == 10 then--//10施展某伤害技能后恢复参数A的士气---只给自己回。
			fDamage_base = fDamage_base *pSkillData.m_ratio
			pFightDataParm.m_iParamDamage = pSkillData.m_paramete
			
		elseif pSkillData.m_type == 11 then--//11 伤害+冰冻效果 加伤害状态Buff类
			--//从新设计
			fDamage_base = fDamage_base *pSkillData.m_ratio
			
			if pSkillData.m_buffchace*fState_Rate > ihit_rand then
						
				pFightDataParm.m_State = DamageState.E_DamageState_bingdong			
			
				pFightDataParm.bufftimes = pSkillData.m_bufftimes
				pFightDataParm.bufftimecd = pSkillData.m_buffcd		
				pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
			end
			
			
		elseif pSkillData.m_type == 12 then--//12血量每减少10%，技能伤害系数增加参数A
			--//从新设计
			fDamage_base = fDamage_base *pSkillData.m_ratio
		elseif pSkillData.m_type == 13 then -- //13吸血并恢复。（也就是连发吸血）????
			fDamage_base = fDamage_base *pSkillData.m_ratio

			local iaddhp = (fDamage_base*pSkillData.m_paramete)*0.01
			pFightDataParm.m_iParamDamage = iaddhp
			
		elseif pSkillData.m_type == 14 then --//14生命值低于20%后技能系数翻倍（暂定是己方血量）
			fDamage_base = fDamage_base *pSkillData.m_ratio

			if pSourceObj:Fun_GetBaseDB().m_allblood*0.2 >= pSourceObj:Fun_GetBaseDB().m_curblood then
			
				fDamage_base = fDamage_base *2
			end
		elseif pSkillData.m_type == 15 then --//15 100%眩晕并偷怒气
			
			fDamage_base = fDamage_base *pSkillData.m_ratio
			pFightDataParm.m_State = DamageState.E_DamageState_xuanyun
			local ishiqi = Tarobj:Fun_GetBaseDB().m_anger - pSkillData.m_paramete
			if ishiqi <0 then
			
				ishiqi = Tarobj:Fun_GetBaseDB().m_anger
			
			else
			
				ishiqi = pSkillData.m_paramete
			end
			pFightDataParm.m_iParamDamage = ishiqi
			
		elseif pSkillData.m_type == 16 then --//16 加伤害Buff类
			fDamage_base = fDamage_base *pSkillData.m_ratio
			
			pFightDataParm.m_State = DamageState.E_DamageState_Dot			
			pFightDataParm.bufftimes = pSkillData.m_bufftimes
			pFightDataParm.bufftimecd = pSkillData.m_buffcd			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
		
		elseif pSkillData.m_type == 17 then --//17 加防御Buff类
			
			fDamage_base = fDamage_base *pSkillData.m_ratio	
			
			pFightDataParm.bufftimes = pSkillData.m_bufftimes
			pFightDataParm.bufftimecd = pSkillData.m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_wufang	
			pFightDataParm.bBuffGainVel  = pSkillData.m_paramete		
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用	
		elseif pSkillData.m_type == 18 then --//击飞类技能
			
			fDamage_base = fDamage_base *pSkillData.m_ratio			

			---这里要判断对方是不是击飞免疫
			--print(Tarobj:Fun_GetBaseDB().m_State_immune)
			--Pause()
			if Tarobj:Fun_GetBaseDB().m_State_immune == DamageState.E_DamageState_jifei then 
			
					pFightDataParm.m_State = DamageState.E_DamageState_None				
			else
				--print(pSkillData.m_buffchace)
				--print(fState_Rate)
				--print(pSkillData.m_buffchace*fState_Rate)
				--print(ihit_rand)
				--Pause()
				if pSkillData.m_buffchace*fState_Rate > ihit_rand then
								
					pFightDataParm.m_State = DamageState.E_DamageState_jifei		
					pFightDataParm.bufftimes = pSkillData.m_bufftimes
					pFightDataParm.bufftimecd = pSkillData.m_buffcd		
					pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
					
					--print(pFightDataParm.m_State)
					--Pause()
				end	
			end
			
			
		elseif pSkillData.m_type == 19 then --//加能量数值瞬发效果类
			
			fDamage_base = fDamage_base *pSkillData.m_ratio	
			
			if pSkillData.m_buffchace*fState_Rate > ihit_rand then	
				
				pFightDataParm.bBuffGainType = BuffGainType.E_GainType_engine	
				pFightDataParm.bBuffGainVel  = pSkillData.m_paramete	
			else
				pFightDataParm.bBuffGainType = BuffGainType.E_GainType_engine	
				pFightDataParm.bBuffGainVel  = 0	
				
			end 	
			
			
		elseif pSkillData.m_type == 20 then --//加伤害吸收盾*****
			
			fDamage_base = 0		
			pFightDataParm.bufftimes = pSkillData.m_bufftimes
			pFightDataParm.bufftimecd = pSkillData.m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_xishoudun	
			pFightDataParm.bBuffGainVel  = pSkillData.m_ratio			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用			
			
		elseif pSkillData.m_type == 21 then --//加绝对防御Buff类
			
			fDamage_base = 0
			
			pFightDataParm.bufftimes = pSkillData.m_bufftimes
			pFightDataParm.bufftimecd = pSkillData.m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_jueduifangyu	
			pFightDataParm.bBuffGainVel  = pSkillData.m_paramete		
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用	
			
		elseif pSkillData.m_type == 22 then --//造成伤害+回复单体能量能量
			
			fDamage_base = fDamage_base *pSkillData.m_ratio

			pFightDataParm.m_iParamDamageType = BuffGainType.E_GainType_engine
			pFightDataParm.m_iParamDamage = pSkillData.m_paramete
			
		elseif pSkillData.m_type == 23 then --//造成伤害+回复全体能量能量
			
			fDamage_base = fDamage_base *pSkillData.m_ratio
			
			pFightDataParm.m_iParamDamageType = BuffGainType.E_GainType_engine
			pFightDataParm.m_iParamDamage = pSkillData.m_paramete
			
		elseif pSkillData.m_type == 24 then --//造成伤害+属性减益能量
			
			fDamage_base = fDamage_base *pSkillData.m_ratio
			
			pFightDataParm.m_iParamDamageType = BuffGainType.E_GainType_engine
			pFightDataParm.m_iParamDamage = pSkillData.m_paramete
			
		elseif pSkillData.m_type == 25 then --//Buff加数值顺发类(攻击力)		

			fDamage_base = 0			
			pFightDataParm.bufftimes = pSkillData.m_bufftimes
			pFightDataParm.bufftimecd = pSkillData.m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_gongji	
			pFightDataParm.bBuffGainVel  = (pSkillData.m_paramete -1)*pSourceObj:Fun_GetBaseDB().m_gongji			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用			
		
		elseif pSkillData.m_type == 26 then --//Buff加数值顺发类(智力)		

			fDamage_base = 0			
			pFightDataParm.bufftimes = pSkillData.m_bufftimes
			pFightDataParm.bufftimecd = pSkillData.m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_zhili	
			pFightDataParm.bBuffGainVel  = (pSkillData.m_paramete -1)*pSourceObj:Fun_GetBaseDB().m_wisdom			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用			
			
		else
		
		end
		
		fDamage_base = math.floor(fDamage_base)*pFightDataParm.m_iSkillRate
		
		
		--扩展伤害 现在要加上根据对方的防御加成攻击加成的算法
		if fDamage_base > 0 then 
		
			fDamage_base = fDamage_base + pSourceObj:Fun_GetBaseDB().m_add_gongji - Tarobj:Fun_GetBaseDB().m_add_fangyu
			
			if fDamage_base <= 0 then 
				fDamage_base = 1
			end
						
		end		

		pFightDataParm.m_Damage[iHitposIndex] = fDamage_base		
				
	end
end


local function OnDamageNumEnd(pNode)		
	local pUILabelBMFont = tolua.cast(pNode, "LabelBMFont")
	pUILabelBMFont:removeFromParentAndCleanup(true)	
end

--//冒加血特效
local function PlayEffect_Blood( pTarObj, iBlood )	

---冒血的运动轨迹
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
	
	
	--// Create the LabelBMFont
	local labelBMFont = LabelBMFont:create()				
	labelBMFont:setFntFile("Image/Fight/UI/blood/greenblood.fnt")		

	--//施法者播放被打动画	
	if pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5 > DeviceSize.height then 	
		labelBMFont:setPosition(ccp(pTarObj:Fun_getPositionX(),DeviceSize.height  + Fight_Bloodoff_y - DefOffY))	
	else
		labelBMFont:setPosition(ccp(pTarObj:Fun_getPositionX(),pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5 + Fight_Bloodoff_y))
	end		
	
	labelBMFont:setText("+" .. iBlood)
	labelBMFont:setZOrder(pTarObj:Fun_getZOrder())
	labelBMFont:runAction(spawn)
	
	local pScence = Scene_Manger.GetCurpScence()
	pScence:Fun_Get_DamageLayer():addWidget(labelBMFont)	
	
end

--//冒伤害特效
local function PlayEffect_Damage( pTarObj,istate,iDamage )
		
	--//闪避就不调用伤害了
	if iState ~= DamageState.E_DamageState_ShanBi then
		
		---冒血的运动轨迹
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
		
		--//做伤害显示
		--// Create the LabelBMFont
		local labelBMFont = LabelBMFont:create()			
		
		if (iState == DamageState.E_DamageState_BaoJi) then	
		
			if pTarObj:Fun_IsNpc() == true then				
				labelBMFont:setFntFile("Image/Fight/UI/blood/npc_crit_blood.fnt")					
			else				
				labelBMFont:setFntFile("Image/Fight/UI/blood/play_crit_blood.fnt")
			end		
		
		else
			
			if pTarObj:Fun_IsNpc() == true then				
				labelBMFont:setFntFile("Image/Fight/UI/blood/npc_norm_blood.fnt")				
			else			
				labelBMFont:setFntFile("Image/Fight/UI/blood/play_norm_blood.fnt")
			end
			
		end
		
		--//施法者播放被打动画
		if pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5 > DeviceSize.height then 	
			labelBMFont:setPosition(ccp(pTarObj:Fun_getPositionX(),DeviceSize.height  + Fight_Bloodoff_y - DefOffY))	
		else
			labelBMFont:setPosition(ccp(pTarObj:Fun_getPositionX(),pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5 + Fight_Bloodoff_y))
		end		
		
		--增加骨骼绑定
		local pBone = pTarObj:Fun_GetRender_Armature():getBone("xuetiao")	
		if pBone ~= nil then			
			if pTarObj:Fun_GetRender_Armature():getScaleX() > 0 then					
				labelBMFont:setPosition(ccp( pTarObj:Fun_getPositionX() + pBone:nodeToArmatureTransform().tx, pTarObj:Fun_getPositionY() + pBone:nodeToArmatureTransform().ty ))											
			else				
				labelBMFont:setPosition(ccp( pTarObj:Fun_getPositionX() - pBone:nodeToArmatureTransform().tx, pTarObj:Fun_getPositionY() + pBone:nodeToArmatureTransform().ty ))			
			end 		
		end
		
		if  pTarObj:Fun_GetCurrentMovementID() == GetAniName_Player(pTarObj,Ani_Def_Key.Ani_stand) then
		
			--判断是不是被限制了
			if pTarObj:Fun_IsBuff_State( ) == false then 				
				pTarObj:Fun_play_Key(Ani_Def_Key.Ani_hitted)					
			end				
		end	

		labelBMFont:setText("-" .. iDamage)
		labelBMFont:setZOrder(pTarObj:Fun_getZOrder())
		labelBMFont:runAction(spawn)
		
		local pScence = Scene_Manger.GetCurpScence()
		pScence:Fun_Get_DamageLayer():addWidget(labelBMFont)
		
	end
end

local function PlayEffect_Engine(pTarObj,iEngine )			

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
	
	--// Create the LabelBMFont
	local labelBMFont = LabelBMFont:create()					
	labelBMFont:setFntFile("Image/Fight/UI/blood/engine.fnt")		

	--//施法者播放被打动画
	if pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5 > DeviceSize.height then 	
		labelBMFont:setPosition(ccp(pTarObj:Fun_getPositionX(),DeviceSize.height  + Fight_Bloodoff_y - DefOffY))	
	else
		labelBMFont:setPosition(ccp(pTarObj:Fun_getPositionX(),pTarObj:Fun_getPositionY() + pTarObj:Fun_getModeHeight()*0.5 + Fight_Bloodoff_y -20))
	end		
		
	
	if iEngine>= 0 then 	
		labelBMFont:setText("+" .. iEngine)
	else
		labelBMFont:setText(tostring(iEngine))
	end
	labelBMFont:setZOrder(pTarObj:Fun_getZOrder())
	labelBMFont:runAction(spawn)	
	
	local pScence = Scene_Manger.GetCurpScence()
	pScence:Fun_Get_DamageLayer():addWidget(labelBMFont)
	
	
end

local function playEngine(pTarObj,iEngine )
	
	pTarObj:Fun_PalyBuffGain(BuffGainType.E_GainType_engine,iEngine,true)
	PlayEffect_Engine(pTarObj,iEngine)	
	UpFighterEngine(pTarObj)

end

-- 播放伤害效果
local function PlayDamage(pSourObj,pTarObj,istate,iDamage )

	if iDamage == nil then
		print("PlayDamage iDamage == nil!!!!!!!!!!!!")
		return
	end
	
	--//add by sxin 识破要把伤害算到攻击方
	local pFighter = nil	
	
	if (istate == DamageState.E_DamageState_ShiPo) then		
		pFighter = pSourObj			
	else	
		pFighter = pTarObj		
	end

	-- 改成是死亡动画就不播放了
	if pFighter:Fun_IsDie() == true then	
		return
	end
	
	--判断吸收罩
	if pFighter:Fun_GetBaseDB().m_xishoudun > 0 and iDamage > 0 then 		
		
		if pFighter:Fun_GetBaseDB().m_xishoudun >= iDamage then 
			
			pFighter:Fun_GetBaseDB().m_xishoudun = pFighter:Fun_GetBaseDB().m_xishoudun - iDamage
			iDamage = 0
		else				
			pFighter:Fun_GetBaseDB().m_xishoudun = 0
			iDamage =  iDamage - pFighter:Fun_GetBaseDB().m_xishoudun 
			
		end
		
	end
		

	pFighter:Fun_GetBaseDB().m_curblood = pFighter:Fun_GetBaseDB().m_curblood - iDamage

	if pFighter:Fun_GetBaseDB().m_curblood<0 then
	
		pFighter:Fun_GetBaseDB().m_curblood = 0
	end
	
	if  pFighter:Fun_GetBaseDB().m_curblood > pFighter:Fun_GetBaseDB().m_allblood then
	
		pFighter:Fun_GetBaseDB().m_curblood = pFighter:Fun_GetBaseDB().m_allblood
	end
	
	--add by sxin 强制判断pk数据和服务器的一致性 判断服务器这次伤害是否死亡	
	--[[
	if NETWORKENABLE > 0 then	
		if BaseSceneDB.IsPKScene() == true then 
		
			if  BaseSceneDB.IsHaveGetPkData(iFighterPos) == true then 			
				if pFighter.m_curblood <= 0 then 					
					--pFighter.m_curblood = 1
				end
			else
				--pFighter.m_curblood = 0
			end			
			
		end
	end
	]]--
	
	local pScence = Scene_Manger.GetCurpScence()
		
	--增加显示血条
	if pScence:Fun_IsFightEnd() == false then		
		SetObjUiVisible(pTarObj,true)
	end	
	
	--//死亡
	if pFighter:Fun_IsDie() == true then	
	
		pFighter:Fun_play_Key(Ani_Def_Key.Ani_die)				
		local DieSound = AnimationData.getFieldByIdAndIndex(pFighter:Fun_GetBaseDB().m_TempResid,"Audio_Die")			
		PlaySound(Audio_Type.E_Audio_Die,DieSound)		
			
		if istate == DamageState.E_DamageState_ShiPo then					
			--调用场景脚本--			
			--识破算是被对方杀死的				
			pScence.m_baseDB.m_pSceneSprit:Fun_Die(pFighter,pTarObj)			
		else
			--调用场景脚本--			
			pScence.m_baseDB.m_pSceneSprit:Fun_Die(pFighter,pSourObj)				
		end	
		
		--设置死亡给UI
		if pFighter:Fun_IsUser() == true then
			if pScence.m_UIInterface ~= nil then
				pScence.m_UIInterface:Fun_CheckListLife(pFighter:Fun_GetBaseDB().m_TempID)				
			end	
		end		
		
		CheckFightResult(pFighter)	
	else	
					
		if iDamage < 0 then
			------播放加血特效-----------ID 15 
			local pEffectObj = Scene_EffectObj.CreatEffectObj()
			pEffectObj:Fun_CreatRenderData(15,pScence:Fun_Get_pLayerRoot(),pFighter,true,nil)	
			
		elseif pFighter:Fun_GetCurrentMovementID() == GetAniName_Player(pFighter,Ani_Def_Key.Ani_stand) then
		
			--判断是不是被限制了
			if pFighter:Fun_IsBuff_State() == false then 				
				pFighter:Fun_play_Key(Ani_Def_Key.Ani_hitted)
			end			
		end				
	end

	--加血效果分开
	if iDamage < 0 then
		PlayEffect_Blood(pFighter,-iDamage)
	else
		PlayEffect_Damage(pFighter,istate,iDamage)
	end
		
	UpFighterObjBlood(pFighter)
	pScence.m_baseDB.m_pSceneSprit:Fun_Damage(pFighter)		
				
end

--//瞬发特效播放目标的被打特效
local function PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,iDamage,bUseEffectEx)

	--print("PlayEffect_Prompt" .. iEffectID_hit .."," .. iSourcePos .. "," .. iTargetPos)
	--Pause()
	--//特效在技能事件触发直接播放受攻击的人被打动画 在动画镇里播放被打特效
	--//add by sxin 如果死亡就不调用了

	local pScence = Scene_Manger.GetCurpScence()
	local pEffectObj = Scene_EffectObj.CreatEffectObj()
	pEffectObj:Fun_CreatRenderData(iEffectID_hit,pScence:Fun_Get_pLayerRoot(),pTarObj,bUseEffectEx)
	
	--//播放伤害特效	
	PlayDamage(pSourceObj,pTarObj,pSourceObj:Fun_GetFightDataParm().m_State,iDamage)
	
end

----------增益-瞬发单体类特效-------------
local function PlayEffect_Prompt_Gain(iEffectID_hit, pSourceObj, pTarObj, pBone,bBuffGainType,bBuffGainVel)
	
	local pScence = Scene_Manger.GetCurpScence()
	local pEffectObj = Scene_EffectObj.CreatEffectObj()
	pEffectObj:Fun_CreatRenderData(iEffectID_hit,pScence:Fun_Get_pLayerRoot(),pTarObj,true)
	
	--//播放增益特效		
	if bBuffGainType == BuffGainType.E_GainType_engine and bBuffGainVel > 0 then 			
		playEngine(pTarObj,bBuffGainVel)
	else
		pTarObj:Fun_PalyBuffGain(bBuffGainType,bBuffGainVel,true)
	end
	
end


--//子弹类特效
local function PlayEffect_Bullet(iEffectID_bullet, iEffectID_hit, pSourceObj, pTarObj, pBone,bMusHit,iHitIndex)

	local pScence = Scene_Manger.GetCurpScence()
	local pBulletObj = Scene_EffectObj.CreatBulletObj()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	--//伤害回调
	local function OnArrive(pNode)		
		if pFightDataParm ~= nil then		
			if bMusHit == true then
				local i = 1
				for i=1,MaxTeamPlayCount, 1 do					
					if pFightDataParm.m_HurtPos[i] ~= nil then							
						PlayEffect_Prompt(iEffectID_hit,pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],true)						
					end					
				end
			else				
				PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,pFightDataParm.m_Damage[iHitIndex],true)
			end		
			
		else
			print("OnArrive:pFightDataParm == nil ")
			--Pause()
		end	

	end	
	
	pBulletObj:Fun_CreatBulletRenderData(iEffectID_bullet,pScence:Fun_Get_pLayerRoot(),pSourceObj,pTarObj,pBone,pScence:Fun_GetFightTimes(),OnArrive)	
	
end

--抛物线特效子弹 范围攻击*****************************
local function PlayEffect_Bullet_parabolic(iEffectID_bullet, iEffectID_hit, pSourceObj, pTarObj, pBone,bMusHit,iHitIndex)

	local pScence = Scene_Manger.GetCurpScence()
	local pBulletObj = Scene_EffectObj.CreatBulletObj()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	--//伤害回调
	local function OnArrive(pNode)			
		
		if pFightDataParm ~= nil then
		
			if bMusHit == true then
				local i = 1
				for i=1,MaxTeamPlayCount, 1 do
					
					if pFightDataParm.m_HurtPos[i] ~= nil then	
						
						PlayEffect_Prompt(iEffectID_hit,pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],true)
						
					end
					
				end
			else				
				PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,pFightDataParm.m_Damage[iHitIndex],true)
			end		
			
		else
			print("OnArrive:pFightDataParm == nil ")
			--Pause()
		end	

	end	
	
	pBulletObj:Fun_CreatBulletparabolicRenderData(iEffectID_bullet,pScence:Fun_Get_pLayerRoot(),pSourceObj,pTarObj,pBone,OnArrive)	
		
end

-----------buff类特效-------------
local function PlayEffect_Prompt_buff(iEffectID_buff, iEffectID_hit, pSourceObj, pTarObj, pBone,iBuffTImes,iBuffcd,BuffType)

	local pScence = Scene_Manger.GetCurpScence()
	local pBuffObj = Scene_EffectObj.CreatBuffObj()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	local iDamage = pFightDataParm.m_Damage[1]
	--//伤害回调
	local function OnHurt()			
		
		if pFightDataParm ~= nil then		
			
			if pTarObj.Fun_IsDie ~= nil and pTarObj:Fun_IsDie() == false then
				PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,iDamage,true)	
			else
				Scene_EffectObj.DeleteEffectObj(pBuffObj.m_ID)
			end			
		else
			print("OnHurt:pFightDataParm == nil ")
			--Pause()
		end	

	end	
		
	pBuffObj:Fun_CreatBuffRenderData(iEffectID_buff,pScence:Fun_Get_pLayerRoot(),pSourceObj,pTarObj,pBone,OnHurt,iBuffTImes,iBuffcd,BuffType)	
	PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,iDamage,true)
end


----------增益-buff单体类特效-------------
local function PlayEffect_Prompt_buff_Gain(iEffectID_buff, iEffectID_hit, pSourceObj, pTarObj, pBone,iBuffTImes,iBuffcd,BuffType,bBuffGainType,bBuffGainVel)	

	local pScence = Scene_Manger.GetCurpScence()
	local pBuffObj = Scene_EffectObj.CreatBuffObj()	
	
	--//伤害回调
	local function OnEnd()						
		if pTarObj.Fun_IsDie ~= nil and pTarObj:Fun_IsDie() == false then
			pTarObj:Fun_PalyBuffGain(bBuffGainType,bBuffGainVel,false)	
		else
			Scene_EffectObj.DeleteEffectObj(pBuffObj.m_ID)
		end				
	end	
		
	pBuffObj:Fun_CreatBuffRenderData(iEffectID_buff,pScence:Fun_Get_pLayerRoot(),pSourceObj,pTarObj,pBone,OnEnd,iBuffTImes,iBuffcd,BuffType)	
	pTarObj:Fun_PalyBuffGain(bBuffGainType,bBuffGainVel,true)

end

local function PlayEffect_Prompt_buff_xishoudun(iEffectID_buff, iEffectID_hit, pSourceObj, pTarObj, pBone,iBuffTImes,iBuffcd,BuffType,bBuffGainType,bBuffGainVel)	

	if pTarObj:Fun_GetBaseDB().m_xishoudun > 0 then
		pTarObj:Fun_PalyBuffGain(bBuffGainType,bBuffGainVel,true)	
		return
	end			
					
	local pScence = Scene_Manger.GetCurpScence()
	local pBuffObj = Scene_EffectObj.CreatBuffObj()	
		
	local function OnEnd()						
		if pTarObj.Fun_IsDie ~= nil and pTarObj:Fun_IsDie() == false then
			if pTarObj:Fun_GetBaseDB().m_xishoudun <= 0 then
				Scene_EffectObj.DeleteEffectObj(pBuffObj.m_ID)
			end			
		else
			Scene_EffectObj.DeleteEffectObj(pBuffObj.m_ID)
		end				
	end	
		
	pTarObj:Fun_PalyBuffGain(bBuffGainType,bBuffGainVel,true)	
	pBuffObj:Fun_CreatBuffRenderData(iEffectID_buff,pScence:Fun_Get_pLayerRoot(),pSourceObj,pTarObj,pBone,OnEnd,9999999,0.1,BuffType)		

end

----伤害+状态限制Buff 有几率的
local function PlayEffect_Prompt_buff_State(iEffectID_buff, iEffectID_hit, pSourceObj, pTarObj, iHurPosIndex,pBone,bShow,iBuffTImes,iBuffcd,BuffType)

	local pScence = Scene_Manger.GetCurpScence()
	local pBuffObj = Scene_EffectObj.CreatBuffObj()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	local iDamage = pFightDataParm.m_Damage[iHurPosIndex]
	local Estate = pFightDataParm.m_State
	
	--//伤害回调
	local function OnEnd()	
	
		print("PlayEffect_Prompt_buff_State OnEnd")
		
		if pFightDataParm ~= nil then				
			if pTarObj.Fun_IsDie ~= nil then				
				pTarObj:Fun_ClearBuffState(Estate)
			else
				--Scene_EffectObj.DeleteEffectObj(pBuffObj.m_ID)
			end			
		else
			print("OnEnd:pFightDataParm == nil ")
			--Pause()
		end	
	end	
	pBuffObj:Fun_SetEffectState(Estate)
	pBuffObj:Fun_CreatBuffRenderData(iEffectID_buff,pScence:Fun_Get_pLayerRoot(),pSourceObj,pTarObj,pBone,OnEnd,iBuffTImes,iBuffcd,BuffType)	
	pTarObj:Fun_PalyBuffState(Estate)
	
	if bShow == true then
		PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,iDamage,true)
	else
		PlayDamage(pSourceObj,pTarObj,pFightDataParm.m_State,iDamage)
	end
	
end

----扩展子弹类+限制Buff
local function PlayEffect_Bullet_buff_State(iEffectID_bullet, iEffectID_hit, iEffectID_buff,pSourceObj, pTarObj, iHurPosIndex,pBone,bMusHit,iBuffTImes,iBuffcd,BuffType)

	local pScence = Scene_Manger.GetCurpScence()
	local pBulletObj = Scene_EffectObj.CreatBulletObj()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	--//伤害回调
	local function OnArrive(pNode)		
		if pFightDataParm ~= nil then		
			if bMusHit == true then
				local i = 1
				for i=1,MaxTeamPlayCount, 1 do					
					if pFightDataParm.m_HurtPos[i] ~= nil then							
						PlayEffect_Prompt_buff_State(iEffectID_buff,iEffectID_hit,pSourceObj,pFightDataParm.m_HurtPos[i],i,pFightDataParm.m_Curbone,bShow,iBuffTImes,iBuffcd,BuffType)						
					end					
				end
			else				
				PlayEffect_Prompt_buff_State(iEffectID_buff,iEffectID_hit,pSourceObj,pTarObj,i,pFightDataParm.m_Curbone,bShow,iBuffTImes,iBuffcd,BuffType)						
			end		
			
		else
			print("OnArrive:pFightDataParm == nil ")
			
		end	

	end	
	
	pBulletObj:Fun_CreatBulletRenderData(iEffectID_bullet,pScence:Fun_Get_pLayerRoot(),pSourceObj,pTarObj,pBone,pScence:Fun_GetFightTimes(),OnArrive)	
	
end

----伤害+击飞+状态限制Buff (有几率的)
local function PlayEffect_Prompt_buff_State_jitui(iEffectID_buff, iEffectID_hit, pSourceObj, pTarObj, pBone)

	local pScence = Scene_Manger.GetCurpScence()	
	local iTimes = pScence:Fun_GetFightTimes()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	local iDamage = pFightDataParm.m_Damage[1]	
		
	local function jifeiArrive(pNode)	
		--print("jifeiArrive")
		--Pause()		
		--击飞的本人不做眩晕
		PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,iDamage,true)
		--在落地的地方算下范围内的怪
		--以目标为中心的范围攻击
		local index =1
		if pTarObj:Fun_IsNpc() == true then		
					
			local i = 1					
			for i= 1, MaxTeamPlayCount, 1 do				
			
				if pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~=  pTarObj and pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then
															
					if ccpDistance( ccp(pTarObj:Fun_getPosition()),ccp(pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_getPosition())) <= Ani_fly_Damage_Dis then							
						
						index = index+1
						pFightDataParm.m_HurtPos[index] = pScence.m_baseDB.m_FightTeamNpc[iTimes][i]
						--暂时默认被砸都减少200血
						pFightDataParm.m_Damage[index] = 200							
						PlayEffect_Prompt_buff_State(iEffectID_buff,iEffectID_hit,pSourceObj,pFightDataParm.m_HurtPos[index],index,pFightDataParm.m_Curbone,true,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)				
					
					end
					
				end
				
			end 			
		else
			local i = 1			
			for i= 1, MaxTeamPlayCount, 1 do
			
				if pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i] ~=  pTarObj and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then				
															
					if ccpDistance( ccp(pTarObj:Fun_getPosition()),ccp(pScence.m_baseDB.m_FightTeamPlay[i]:Fun_getPosition())) <= Ani_fly_Damage_Dis then
						
						index = index+1
						pFightDataParm.m_HurtPos[index] = pScence.m_baseDB.m_FightTeamPlay[i]
						--暂时默认被砸都减少200血
						pFightDataParm.m_Damage[index] = 200								
						PlayEffect_Prompt_buff_State(iEffectID_buff,iEffectID_hit,pSourceObj,pFightDataParm.m_HurtPos[index],index,pFightDataParm.m_Curbone,true,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)				
					
					end
				end
				
			end 				
			
		end	
			
				
	end
	
	--------判断技能状态 
	--print(pFightDataParm.m_State)	
	if pFightDataParm.m_State == DamageState.E_DamageState_jifei then 		
		
		if pTarObj:Fun_GetCurrentMovementID() ~= GetAniName_Player(pTarObj,Ani_Def_Key.Ani_die) then	
			--------------播放击飞效果----写死移动固定距离---Ani_fly_Dis--0.5秒固定时间	Ani_fly_Time		
			pTarObj:Fun_play_Key(Ani_Def_Key.Ani_fly)
				
			local pMoveBy = nil
			
			local ijifeiDis = 0
			local ipParArmatureTar_Pos_x = pTarObj:Fun_getPositionX()
			local iSCenceEnd_Pos_X = MaxMoveDistance*iTimes
			local iSCenceBegin_Pos_X = iSCenceEnd_Pos_X - MaxMoveDistance
			if pTarObj:Fun_IsNpc() == true then 
				--需要判断是不是出屏幕了
				if  ipParArmatureTar_Pos_x + Ani_fly_Dis >  iSCenceEnd_Pos_X then
					ijifeiDis = iSCenceEnd_Pos_X - ipParArmatureTar_Pos_x
				else
					ijifeiDis = Ani_fly_Dis
				end				
				
				pMoveBy = CCMoveBy:create(Ani_fly_Time,ccp(ijifeiDis,0))
			else
				
				if  ipParArmatureTar_Pos_x - Ani_fly_Dis < iSCenceBegin_Pos_X then
					ijifeiDis = iSCenceBegin_Pos_X - ipParArmatureTar_Pos_x
				else
					ijifeiDis = -Ani_fly_Dis
				end		
				
				pMoveBy = CCMoveBy:create(Ani_fly_Time,ccp(ijifeiDis,0))
			end
			
			local pcallFunc = CCCallFuncN:create(jifeiArrive)			
					
			local pMoveseq  = CCSequence:createWithTwoActions(pMoveBy, pcallFunc)		

			pMoveseq:setTag(Fight_jifeiMoveTagID)
			
			pTarObj:Fun_runAction(pMoveseq)			
		end	
	
	else--免疫击飞效果按普通的伤害执行
		--print("免疫击飞效果按普通的伤害执行")
		--Pause()	
		PlayEffect_Prompt(iEffectID_hit,pSourceObj,pTarObj,iDamage,true)
	end 
	
end

--子弹类顺序攻击目标伤害
function PlayEffect_Bullet_Sequence(iEffectID_bullet, iEffectID_hit, pSourceObj, pBone)

	local pScence = Scene_Manger.GetCurpScence()	
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	local pBulletObj = nil
	--//伤害回调
	local icurIndex = 1
	local function OnArrive(pNode)		
		if pFightDataParm ~= nil then				
			PlayEffect_Prompt(iEffectID_hit,pSourceObj,pFightDataParm.m_HurtPos[icurIndex],pFightDataParm.m_Damage[icurIndex],true)		
			icurIndex = icurIndex+1
			if pFightDataParm.m_HurtPos[icurIndex] ~= nil then
			
				local pBulletObj = Scene_EffectObj.CreatBulletObj()
				pBulletObj:Fun_CreatBulletRenderData(iEffectID_bullet,pScence:Fun_Get_pLayerRoot(),pFightDataParm.m_HurtPos[icurIndex-1],pFightDataParm.m_HurtPos[icurIndex],pBone,pScence:Fun_GetFightTimes(),OnArrive)		
	
			end
			
		else
			print("OnArrive:pFightDataParm == nil ")
			--Pause()
		end	

	end	
	local pBulletObj = Scene_EffectObj.CreatBulletObj()
	pBulletObj:Fun_CreatBulletRenderData(iEffectID_bullet,pScence:Fun_Get_pLayerRoot(),pSourceObj,pFightDataParm.m_HurtPos[icurIndex],pBone,pScence:Fun_GetFightTimes(),OnArrive)		
	
end 


--播放技能效果
local function PlayEffectMage_Player(pSourceObj)
	
	--print("PlayEffectMage_Player")
	
	local pScence = Scene_Manger.GetCurpScence()	
	local iTimes = pScence:Fun_GetFightTimes()
	local iSkillIndex = pSourceObj:Fun_GetUseSkillIndex()
	local pObjSkillData = pSourceObj:Fun_GetSkillData(iSkillIndex)

	
	--local pTalentData = pSourceObj:Fun_GetTalent()
	local pFightDataParm = pSourceObj:Fun_GetFightDataParm()
	
	
	local Tarobj = pSourceObj.m_FightDataParm.m_pTarObj	
	if Tarobj:Fun_IsDie()== true then
				
		local pTarObj = GetFightTarObj(pSourceObj,pScence)	
		
		if pTarObj ~= nil then 
			pSourceObj.m_FightDataParm.m_pTarObj = pTarObj
			Tarobj = pTarObj
		end
		
	end 	

	---****---记录战斗记录------------------

	--FightbattleData.SetBattleData(BaseSceneDB.GetBattleID(),BaseSceneDB.GetCurTimes(),FightDataParm.m_FightPos,FightDataParm)	
	-------------------------------------------
	
	local pSkillData = SkillData.getDataById( pObjSkillData.m_skillresid)
	
	if pSkillData == nil then
		
		print(pObjSkillData.m_skillresid)
		print(pSourceObj.m_baseDB.m_TempID)		
		Pause()
	end
	
	local pEffectData = nil	

	--//瞬发
	if tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt then
	
		--print("瞬发" )
		--Pause()
		
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])

		--//单目标
		if tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_OneTarget then
			local i=1
			for i=1, MaxTeamPlayCount, 1 do				
				if pFightDataParm.m_HurtPos[i] ~= nil then				
					PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],false)
						--print(pSourceObj.m_baseDB.m_TempID .. "瞬发单目标:" ..  pFightDataParm.m_HurtPos[i].m_baseDB.m_TempID)			
						--Pause()				
				end				
			end				
		--//组合特效第一有效
		elseif tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then			
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do				
				if pFightDataParm.m_HurtPos[i] ~= nil then	
					
					if i == 1 then
						PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],true)
					else
						PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],false)
					end
				
				end
				
			end	
		
		--//组合特效全有效
		elseif tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_All then		
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do				
				if pFightDataParm.m_HurtPos[i] ~= nil then				
					PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],true)	
				end				
			end			
		else
		
		end


	--//子弹类
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		
		--print("子弹类单目标" )
		--Pause()
		
		if tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then
		
			PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[1],pFightDataParm.m_Curbone,true,1)					
			
		else
		
			local i=1
			for i=1, MaxTeamPlayCount, 1 do
				
				if pFightDataParm.m_HurtPos[i] ~= nil then
				
					PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Curbone,false,i)					
				end
				
			end			
		
		end	
			
	
	--//抛物线朝向类的特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_parabolic_one then
	
		--print("抛物线朝向类的特效技能")
		--Pause()		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	
		
		PlayEffect_Bullet_parabolic(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[1],pFightDataParm.m_Curbone,true,1)
		

	--//抛物线朝向类的特效技能多目标的
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_parabolic_Mul then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	
		
		--print("抛物线朝向类的特效技能多目标的")
		--Pause()
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if pFightDataParm.m_HurtPos[i] ~= nil then	
				
				PlayEffect_Bullet_parabolic(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Curbone,false,i)
		
			end
			
		end	
		
	----buf类特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_One then
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		
		
		PlayEffect_Prompt_buff(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,Tarobj,pFightDataParm.m_Curbone,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)
		

	----增益buf类特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_Gain then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])			
		--扩展多个伤害取伤害链表
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if pFightDataParm.m_HurtPos[i] ~= nil then		
				
				PlayEffect_Prompt_buff_Gain(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Curbone,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe,pFightDataParm.bBuffGainType,pFightDataParm.bBuffGainVel)
		
			end
			
		end		
		
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_State then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])				
		if tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then
		
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do
				
				if pFightDataParm.m_HurtPos[i] ~= nil then	
					
					if i == 1 then
						PlayEffect_Prompt_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],i,pFightDataParm.m_Curbone,true,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)
			
					else
						PlayEffect_Prompt_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],i,pFightDataParm.m_Curbone,false,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)
			
					end
				
				end
			end
				
		else	
			
			--扩展多个伤害取伤害链表
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do
				
				if pFightDataParm.m_HurtPos[i] ~= nil then		
					
					PlayEffect_Prompt_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],i,pFightDataParm.m_Curbone,true,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)
			
				end
				
			end		
		end	
	
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_State_jifei then		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])				
			
		PlayEffect_Prompt_buff_State_jitui(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,Tarobj,pFightDataParm.m_Curbone)
	
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Gain then --//增益瞬发单体		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		

		--扩展多个伤害取伤害链表
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do			
			if pFightDataParm.m_HurtPos[i] ~= nil then				
				PlayEffect_Prompt_Gain(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Curbone,pFightDataParm.bBuffGainType,pFightDataParm.bBuffGainVel	)
			end			
		end		
			
	
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_xishoudun then --//吸收盾逻辑
		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])			

		--扩展多个伤害取伤害链表
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if pFightDataParm.m_HurtPos[i] ~= nil then
			
				PlayEffect_Prompt_buff_xishoudun(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Curbone,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe,pFightDataParm.bBuffGainType,pFightDataParm.bBuffGainVel)
		
			end
			
		end		
			
	
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Back_one then --//伤害+回复（单体）
	
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])	
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		 
		 --播放回复类型特效
		 if pFightDataParm.m_iParamDamage > 0 then 			
			if pFightDataParm.m_iParamDamageType == BuffGainType.E_GainType_engine then 				
				playEngine(pSourceObj,pFightDataParm.m_iParamDamage)				
			else
			
			end			
		 end		 
		 
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			
			if pFightDataParm.m_HurtPos[i] ~= nil then
			
				PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],true)
			
			end
			
		end		
					
	
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Back_all then --//伤害+回复（全体）
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])	
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		
		 --播放回复类型特效
		 if pFightDataParm.m_iParamDamage > 0 then 		
			
			if pFightDataParm.m_iParamDamageType == BuffGainType.E_GainType_engine then 	
				
				if pSourceObj:Fun_IsNpc() == true then		
							
					local i = 1					
					for i= 1, MaxTeamPlayCount, 1 do				
					
						if pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then
							playEngine(pScence.m_baseDB.m_FightTeamNpc[iTimes][i],pFightDataParm.m_iParamDamage)
						end
						
					end 			
				else
					local i = 1			
					for i= 1, MaxTeamPlayCount, 1 do
					
						if pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then				
							playEngine(pScence.m_baseDB.m_FightTeamPlay[i],pFightDataParm.m_iParamDamage)
						end
						
					end 				
					
				end	
			end
		end 
		 
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			
			if pFightDataParm.m_HurtPos[i] ~= nil then
			
				PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],true)
			
			end
			
		end		
			
	
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_ShuXing_one then --//伤害+属性（单体）
				
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")]) 
		 
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			
			if pFightDataParm.m_HurtPos[i] ~= nil then
			
				PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_HurtPos[i],pFightDataParm.m_Damage[i],true)				
				 --播放属性类型特效					
				if pFightDataParm.m_iParamDamageType == BuffGainType.E_GainType_engine then 
					playEngine(pFightDataParm.m_HurtPos[i],pFightDataParm.m_iParamDamage)
				else
				
				end				
			
			end
			
		end		
	
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_buff_State then --//子弹伤害+状态限制
				
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	

		--扩展多个伤害取伤害链表
		--ActType 0 作用单个伤害目标的目标的
		--ctType 1 作用当前目标不针对伤害目标的
		--//单目标
		if tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_OneTarget then
			--Pause()
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do
				
				if pFightDataParm.m_HurtPos[i] ~= nil then	
				
					PlayEffect_Bullet_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_Buff")]),pSourceObj,pFightDataParm.m_HurtPos[i],i,pFightDataParm.m_Curbone,false,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)
			
				end
				
			end		
		elseif tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then
			
			PlayEffect_Bullet_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_Buff")]),pSourceObj,pFightDataParm.m_HurtPos[1],1,pFightDataParm.m_Curbone,true,pFightDataParm.bufftimes,pFightDataParm.bufftimecd,pFightDataParm.bBuffTYpe)
			
		end			
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_Sequence then --//子弹伤害+顺序伤害
				
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])						
		PlayEffect_Bullet_Sequence(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),pSourceObj,pFightDataParm.m_Curbone)
			
	else
		
	
	
	end	

end


--//战斗伤害的逻辑算法
function OnDamageLogic(pSourceObj)

	local pScence = Scene_Manger.GetCurpScence()	
	if pScence:Fun_IsFightEnd() == true then
		return
	end
	
	--print("OnDamageLogic pSourceObj = " .. pSourceObj.m_Index)
--	Pause()
--计算技能释放的怒气和能量
	
	local iSkillIndex = pSourceObj:Fun_GetUseSkillIndex()
	if iSkillIndex == 1 then		
	
		pSourceObj.m_baseDB.m_anger = pSourceObj.m_baseDB.m_anger + pSourceObj.m_baseDB.m_SkillData[iSkillIndex].m_anger_back		
		pSourceObj.m_baseDB.m_engine = pSourceObj.m_baseDB.m_engine + pSourceObj.m_baseDB.m_SkillData[iSkillIndex].m_engine_back
		
	elseif iSkillIndex == 2 then 
		
		pSourceObj.m_baseDB.m_anger = pSourceObj.m_baseDB.m_anger - UseAnger
		pSourceObj.m_baseDB.m_engine = pSourceObj.m_baseDB.m_engine + pSourceObj.m_baseDB.m_SkillData[iSkillIndex].m_engine_back
		
	elseif iSkillIndex == 3 then
	
		pSourceObj.m_baseDB.m_engine = 0
		pSourceObj.m_baseDB.m_anger = pSourceObj.m_baseDB.m_anger + pSourceObj.m_baseDB.m_SkillData[iSkillIndex].m_anger_back
		
	else
		-- 技能索引错误
		Pause()	
	end
		
	
	
	OnFightDamageLogic_0(pSourceObj)
	
	OnFightDamageLogic_1(pSourceObj)	
	
	--播放技能
	PlayEffectMage_Player(pSourceObj)

end

function PlaySound(audioType,SoundName)	
	SimpleAudioEngine:sharedEngine():playEffect(SoundName,false)	
end

local function PlayAttack(pBaseObj,iSkillID)

	if pBaseObj:Fun_GetCurrentMovementID() == GetAniName_Player(pBaseObj,Ani_Def_Key.Ani_die) then
		return
	end
	
	if iSkillID <= 0 then		
		return
	end
	
	--print(iSkillID)
	--Pause()
	
	local pSkillData = SkillData.getDataById(iSkillID)	
	
--	local pActName = pSkillData[SkillData.getIndexByField("ActName")]
	
	pBaseObj:Fun_play_Name(pSkillData[SkillData.getIndexByField("ActName")])

	PlaySound(Audio_Type.E_Audio_Attack,pSkillData[SkillData.getIndexByField("Audio_Skill")])	
	
end
-- 取得当前使用的技能接口
local function SetObjSkillIndex( pBaseObj )
	
	--return math.random(1, 3)
	local pskillData = pBaseObj:Fun_GetskillFromStack()
	
	if pskillData ~= nil then
		pBaseObj:Fun_SetUseSkillIndex(pskillData.m_SkillIndex)	
		pBaseObj:Fun_SetUseSkillRate(pskillData.m_iCount) 
		return pskillData.m_SkillIndex
	else
		pBaseObj:Fun_SetUseSkillIndex(1)	
		pBaseObj:Fun_SetUseSkillRate(1) 		
		return 1
	end		
	
end

function CheckFightResult(pDieObj)
		
	local pScence = Scene_Manger.GetCurpScence()	
	local iTimes = pScence:Fun_GetFightTimes()
	--增加显示血条
	if pScence:Fun_IsFightEnd() == true then		
		return
	end	
		
	-- monster
	if pDieObj:Fun_IsNpc() == true then
		local i=1	
		for i=1, MaxTeamPlayCount, 1 do
			
			if pScence.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil and pScence.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then
				return
			end
		end
		--胜利
		
		pScence.m_baseDB:Fun_SetFightResult(1)		
		pScence:Fun_EndFight()		
		
	else --玩家
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			if pScence.m_baseDB.m_FightTeamPlay[i] ~= nil and pScence.m_baseDB.m_FightTeamPlay[i]:Fun_IsDie() == false then
				return
			end
		end
		
		-------失败--------
		pScence.m_baseDB:Fun_SetFightResult(0)
		pScence:Fun_EndFight()	
		
	end
	
end

function ObjUseStackSkill(pBaseObj)
		
	local pskillData = pBaseObj:Fun_GetskillFromStack()
	
	if pskillData ~= nil then
		pBaseObj:Fun_SetUseSkillIndex(pskillData.m_SkillIndex)	
		pBaseObj:Fun_SetUseSkillRate(pskillData.m_iCount) 		
		PlayAttack(pBaseObj,pBaseObj:Fun_GetSkillResID(pskillData.m_SkillIndex))			
	end	

end

--//游戏战斗逻辑
function OnFightLogic( pBaseObj,pScence)

	--print("OnFightLogic pBaseObj = " .. pBaseObj.m_Index)
	
	if pScence:Fun_IsFightEnd() == true then		
		return
	end	
	
	---//战斗逻辑接口需要算使用技能的规则和下次攻击技能的cd时间
		
	--//死亡		
	if pBaseObj:Fun_IsDie() == false then
	
		--如果在释放技能就不能打断
		
		----清理上次的战斗记录
		pBaseObj:Fun_ClearDamageLogic()
		
		local pTarObj = GetFightTarObj(pBaseObj,pScence)				
		pBaseObj:Fun_SetTagObj(pTarObj)		
		if pTarObj ~= nil then
			--战斗逻辑放到播放玩动作再计算		
			--OnDamageLogic(pBaseObj,pTarObj)
			
			local iSkillIndex = SetObjSkillIndex(pBaseObj)				
			PlayAttack(pBaseObj,pBaseObj:Fun_GetSkillResID(iSkillIndex))								
			SetFight(pBaseObj,pBaseObj:Fun_GetSkillCdTime(iSkillIndex),pScence)						
		end

	end
	
end

