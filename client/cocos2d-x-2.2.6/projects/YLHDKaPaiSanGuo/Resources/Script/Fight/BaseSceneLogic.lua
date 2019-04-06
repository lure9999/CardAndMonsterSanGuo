
--场景逻辑方法类

module("BaseSceneLogic", package.seeall)

---是否要记录回调父类方法
local m_pBaseScene = nil
local m_UseingEngineSkillStopTimes = 0

local m_Stack_UseingEngineSkill = nil


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

function SetScene( PScene )
	
	m_pBaseScene = PScene
	m_UseingEngineSkillStopTimes = 0
	
	m_Stack_UseingEngineSkill = nil
	m_Stack_UseingEngineSkill = simulationStl.creatStack_Last()	
	
end

function SetAnimationUiVisible(Armature,bVel)
	
	--Armature:getChildByTag(G_BloodTag):setVisible(bVel)
	--Armature:getChildByTag(G_BloodBackTag):setVisible(bVel)
	
	local pbone = Armature:getChildByTag(G_BloodBoneTag)
	
	local pboneBack = Armature:getChildByTag(G_BloodBackBoneTag)
	
	if pbone ~= nil and pboneBack ~= nil then 
		
	--	pbone:changeDisplayWithIndex(0, bVel)
	--	pboneBack:changeDisplayWithIndex(0, bVel)
	
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

function SetAnimationUiColour(Armature,Colour3)
	
	--Armature:getChildByTag(G_BloodTag):setColor(Colour3)
	--Armature:getChildByTag(G_BloodBackTag):setColor(Colour3)
	
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


--判断停止
function CheckDis_Stop( pArmature)

	local iSourPos = pArmature:getTag()
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourPos)
	
	local iTar = pFightDataParm.m_iTarpos

	if iTar>0 then 
	
		local pArmaturetar = BaseSceneDB.GetPlayArmature(iTar)
		local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTar)	
			
		local fDisX = math.floor(math.abs(pArmature:getPositionX() - pArmaturetar:getPositionX())-(pFightDataParm.m_Mode_Width + pFightDataParmTar.m_Mode_Width)*0.5)

		if fDisX > pFightDataParm.m_AttackDis then
		
			return false
		end
	end
	return true
	
end



--判定当前位置是不是有重叠的
function CheckArmature_Overlap( pArmature)

	if BaseSceneDB.GetFightEnd() == true then		
		return
	end	
	
	local isource = pArmature:getTag()		
	
	local isource_z = pArmature:getZOrder()		
	
	local function DisActArriveToStand(pNode)
			
				local pArmature = tolua.cast(pNode, "CCArmature")
				local iPos = pArmature:getTag()
				
				if BaseSceneDB.IsDie(iPos) == false and pArmature:getAnimation():getCurrentMovementID() == GetAniName_Player(pArmature,Ani_Def_Key.Ani_run) then
					pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
				end
	end

	---场上的所有的战斗角色进行判断如果有重叠的就按zorder大小区分是向上还是向下便宜。 理论上市下面的遮盖上边
	local i=1
	for i=1 , MaxTeamPlayCount*4, 1 do
	
		local pTeamArmature = BaseSceneDB.GetPlayArmature(i)		
		
		if pTeamArmature ~= nil and  pTeamArmature ~= pArmature then --比较
			
			local ipos = pTeamArmature:getTag()
			local ipos_z = pTeamArmature:getZOrder()		
			
			if BaseSceneDB.IsDie(ipos)== false and ipos_z < isource_z then
			
				local PosSource = ccp(pArmature:getPosition())
				local PosTar 	= ccp(pTeamArmature:getPosition())
				
				local fDis = ccpDistance( PosSource,PosTar)			
				
				if fDis < MaxOverlap then --做y轴偏移
				
					local fMoveTime = MaxOverlap/MaxPlayMoveSpeed
					
					local pMoveby = nil					
						
						--向下移动
					pMoveby = CCMoveBy:create(fMoveTime,ccp(0, -MaxOverlap))					
					
					
					local pcallFunc = CCCallFuncN:create(DisActArriveToStand)
				
					local pMoveseq  = CCSequence:createWithTwoActions(pMoveby, pcallFunc)
					
					
					pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))
					pArmature:runAction(pMoveseq)	
					
					print("CheckArmature_Overlap:pos= " .. pArmature:getTag())
					--Pause()
					return--一次只做一个判断的移动
				
				end
			
			end		
			
		end
	
	end
	
end

--//按对方角色的位置远近判断目标
function GetFightTarPosByDis(iSourPos)
	
	-----直接按顺序逻辑打
	local pSourArmature = BaseSceneDB.GetPlayArmature(iSourPos)
	local pFightData = nil	
	local iTarPos = -1
	local FightTImes = BaseSceneDB.GetCurTimes()
	
	
	
	local iMinDis = 10000
	-- 玩家
	if BaseSceneDB.IsNpc(iSourPos) == false then		
				
		local i = 1					
		for i= 1, MaxTeamPlayCount, 1 do				
							
			local iNpc = i + FightTImes*MaxTeamPlayCount 
		
			if BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
				
				local pNpcArmature = BaseSceneDB.GetPlayArmature(iNpc)
				
				local temdis = ccpDistance( ccp(pSourArmature:getPosition()),ccp(pNpcArmature:getPosition()))
				
				if temdis < iMinDis then 
				
					iMinDis = temdis
					iTarPos = iNpc					
				
				end	
						
			end
			
		end 			
	else--npc 
		local i = 1			
		for i= 1, MaxTeamPlayCount, 1 do
		
			if  BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
				
				local pPlayArmature = BaseSceneDB.GetPlayArmature(i)
				
				local temdis = ccpDistance( ccp(pSourArmature:getPosition()),ccp(pPlayArmature:getPosition()))
				
				if temdis < iMinDis then 
				
					iMinDis = temdis
					iTarPos = i					
				
				end	
			end
			
		end 				
		
	end	



	return iTarPos
	
end 

--//战斗目标的逻辑
function GetFightTarPosByPos(iSourPos)
	
	
	-----直接按顺序逻辑打
	local pFightData = nil	
	local iTarPos = -1
	local FightTImes = BaseSceneDB.GetCurTimes()
	--npc
	if BaseSceneDB.IsNpc(iSourPos) == true then
		
		local i = 1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
				iTarPos = i
				break
			end
		end
	
	else		
		local i = 1
		local iNpc = nil
		
		for i=1 , MaxTeamPlayCount, 1 do
		
			iNpc = FightTImes*MaxTeamPlayCount + i
			
			if BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
				iTarPos = iNpc
				break
			end
		end	
	end
	
	

	return iTarPos;
end

--//战斗目标的逻辑
function GetFightTarPos(iSourPos)
	--if BaseSceneDB.IsPKScene() == true then 
		return GetFightTarPosByPos(iSourPos)
	--else
	--	return GetFightTarPosByDis(iSourPos)
	--end
	
end

--拆分伤害算法逻辑
function OnFightDamageLogic_0(pFightDataParm,pTeamData,iSkillIndex,iTarPos)

		--填充运算数据
	pFightDataParm.m_iSkill = pTeamData.m_SkillData[iSkillIndex].m_skillresid
	
	
	
	pFightDataParm.m_CdTime = pTeamData.m_SkillData[iSkillIndex].m_timecd
	pFightDataParm.m_iSkillIndex = iSkillIndex

	pFightDataParm.m_iSkillType = pTeamData.m_SkillData[iSkillIndex].m_type;
	
	--//施法对象 1敌方单体	2敌方横排		3敌方纵列		4敌方全面		5暗杀，第一目标为从本排后面往前数，倒着打）		6左右击杀，对目标及上下左右攻击		7己方特定单体-(如果是加血技，则选血量最少的1个，如果是加士气的，同理选除自己之外士气最少的1个）
	--//	8己方横排【施法目标在哪排就加哪排】		9己方全体-【如果是加士气的，排除自己在外】		10暗杀后面横排
	
	pFightDataParm.m_iSkillTarType = pTeamData.m_SkillData[iSkillIndex].m_site
	
	--根据技能对象的类型来算伤害的人
	
	local iTempPos = 1
	local iIndex = 1	
	pFightDataParm.m_HurtPos[iIndex] = iTarPos	
	iIndex = iIndex+1	
	
	
	if pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Enemy_Single_Param then --1敌方单体	
		if pTeamData.m_SkillData[iSkillIndex].m_paramete > 0 then 			
			pFightDataParm.m_HurtPos[1] = BaseSceneDB.GetSingleTarBySiteType(iTarPos,pTeamData.m_SkillData[iSkillIndex].m_paramete)
		end		
			
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Enemy_Single then --1敌方单体		
			
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Enemy_Line then --2敌方横排		
							
		if BaseSceneDB.IsNpc(iTarPos) == true then
			iTempPos = iTarPos - BaseSceneDB.GetCurTimes()*MaxTeamPlayCount 
		else
			iTempPos = iTarPos
		end
		
		if iTempPos%2 == 0 then --2 4			
			
			if BaseSceneDB.IsUser(iTarPos -1) == true  and  BaseSceneDB.IsDie(iTarPos -1) == false then
				pFightDataParm.m_HurtPos[iIndex] = iTarPos-1
			end
			
		else --1 3 5
						
			if iTempPos < 5 and BaseSceneDB.IsUser(iTarPos +1) == true and  BaseSceneDB.IsDie(iTarPos +1) == false then
				pFightDataParm.m_HurtPos[iIndex] = iTarPos+1
			end
		
		end
	
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Enemy_Column then --3敌方纵列
					
		if BaseSceneDB.IsNpc(iTarPos) == true then
			iTempPos = iTarPos - BaseSceneDB.GetCurTimes()*MaxTeamPlayCount 
		else
			iTempPos = iTarPos
		end
		
		if iTempPos%2 == 0 then --2 4
			
			 if iTempPos == 2 then 
				if BaseSceneDB.IsUser(iTarPos +2) == true and  BaseSceneDB.IsDie(iTarPos +2) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos+2
				end
			 else
				if BaseSceneDB.IsUser(iTarPos -2) == true and  BaseSceneDB.IsDie(iTarPos -2) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos-2
				end
			 end
			
			
		else --1 3 5
						
			if iTempPos == 1 then 
			
				if BaseSceneDB.IsUser(iTarPos +2) == true and  BaseSceneDB.IsDie(iTarPos +2) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos+2
					iIndex = iIndex+1
				end
				
				if BaseSceneDB.IsUser(iTarPos +4) == true and BaseSceneDB.IsDie(iTarPos +4) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos+4
				end
				
			 elseif iTempPos == 3 then 
			 
				if BaseSceneDB.IsUser(iTarPos -2) == true and  BaseSceneDB.IsDie(iTarPos -2) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos-2
					iIndex = iIndex+1
				end
				
				if BaseSceneDB.IsUser(iTarPos +2) == true and  BaseSceneDB.IsDie(iTarPos +2) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos+2
				end
				
			else 
			
				if BaseSceneDB.IsUser(iTarPos -4) == true and  BaseSceneDB.IsDie(iTarPos -4) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos-4
					iIndex = iIndex+1
				end
				
				if BaseSceneDB.IsUser(iTarPos -2) == true and BaseSceneDB.IsDie(iTarPos -2) == false then
					pFightDataParm.m_HurtPos[iIndex] = iTarPos-2
				end
			
			end
		
		end
	
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Enemy_All then --敌方全面
		
		if BaseSceneDB.IsNpc(iTarPos) == true then					
			local i = 1
			local iNpc = -1
			for i= 1, MaxTeamPlayCount, 1 do
				iNpc = i + BaseSceneDB.GetCurTimes()*MaxTeamPlayCount 
				if iNpc ~= iTarPos and BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
					
					pFightDataParm.m_HurtPos[iIndex] = iNpc
					iIndex = iIndex + 1
				end
				
			end 			
		else
			local i = 1			
			for i= 1, MaxTeamPlayCount, 1 do
			
				if i ~= iTarPos and BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
					
					pFightDataParm.m_HurtPos[iIndex] = i
					iIndex = iIndex + 1
				end
				
			end 				
			
		end
	
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Enemy_Scope then --范围攻击
			
		local pTarArmature = BaseSceneDB.GetPlayArmature(iTarPos)
	
		--以目标为中心的范围攻击
		if BaseSceneDB.IsNpc(iTarPos) == true then
			
					
			local i = 1
						
			for i= 1, MaxTeamPlayCount, 1 do
			
								
				local iNpc = i + BaseSceneDB.GetCurTimes()*MaxTeamPlayCount 
			
				if iNpc ~= iTarPos and BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
					
					local pNpcArmature = BaseSceneDB.GetPlayArmature(iNpc)
					
					if ccpDistance( ccp(pTarArmature:getPosition()),ccp(pNpcArmature:getPosition())) <= pTeamData.m_SkillData[iSkillIndex].m_SkillRadius then
																	
						pFightDataParm.m_HurtPos[iIndex] = iNpc
						iIndex = iIndex + 1
					
					end
					
				end
				
			end 			
		else
			local i = 1			
			for i= 1, MaxTeamPlayCount, 1 do
			
				if i ~= iTarPos and BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
					
					local pPlayArmature = BaseSceneDB.GetPlayArmature(i)
					
					if ccpDistance( ccp(pTarArmature:getPosition()),ccp(pPlayArmature:getPosition())) <= pTeamData.m_SkillData[iSkillIndex].m_SkillRadius then
					
						pFightDataParm.m_HurtPos[iIndex] = i
						iIndex = iIndex + 1
					end
				end
				
			end 				
			
		end
		
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Self_Self then --自己
		--*********************************扩展自己逻辑*****************************************
		pFightDataParm.m_HurtPos[1] = pFightDataParm.m_FightPos				
	
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Self_All then --己方全体
		iIndex = 1
		if BaseSceneDB.IsNpc(pFightDataParm.m_FightPos) == true then 
			
			local i=1
			local iNpc = -1
			for i=1 , MaxTeamPlayCount, 1 do
				iNpc = BaseSceneDB.GetCurTimes()*MaxTeamPlayCount + i
				if BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
					pFightDataParm.m_HurtPos[iIndex] = iNpc
					iIndex = iIndex + 1
				end 
				
			end
			
			
		else--人
			
			local i=1
			
			for i=1 , MaxTeamPlayCount, 1 do
				
				if BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
					pFightDataParm.m_HurtPos[iIndex] = i
					iIndex = iIndex + 1
				end 
				
			end
		
		end
		
		--printTab(pFightDataParm)
		--Pause()
	elseif pTeamData.m_SkillData[iSkillIndex].m_site == Site_Type.Site_Self_Single then ----己方单体体--param 存放选择类型 0 随即1血最少2….		
		if pTeamData.m_SkillData[iSkillIndex].m_paramete > 0 then 
			pFightDataParm.m_HurtPos[1] = BaseSceneDB.GetSingleTarBySiteType(pFightDataParm.m_FightPos,pTeamData.m_SkillData[iSkillIndex].m_paramete)	
		else
			pFightDataParm.m_HurtPos[1] = pFightDataParm.m_FightPos		
		end
		
	else
	
	end

end

function OnFightDamageLogic_1(pFightDataParm,pTeamData,iSkillIndex,iFightTarPos,iEngineSkillRate)


	
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
		
		识破 承受30%伤害，反弹30%伤害
		躲闪 免伤
		
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

	local iHitposIndex = 1
	local iTarPos = iFightTarPos
	for iHitposIndex= 1 , MaxTeamPlayCount, 1 do
		
		if pFightDataParm.m_HurtPos[iHitposIndex] > 0 then 
			iTarPos = pFightDataParm.m_HurtPos[iHitposIndex]
		else
			return
		end
		
		local pTeamDataTar = BaseSceneDB.GetTeamData(iTarPos)
		
		local ihit_rand = math.random(1,100)
		
		--add by sxin 如果是pk需要服务器给随机值
		
		if NETWORKENABLE > 0 then	
			if BaseSceneDB.IsPKScene() == true then 
			
				local iSeverRand = BaseSceneDB.GetPkData(pFightDataParm.m_FightPos)
				if  iSeverRand >= 0 then 
					ihit_rand = iSeverRand					
				end			
				
			end
		end
		
		
		local bCrit = false
		if pTeamData.m_Talent.m_crit>ihit_rand then
			bCrit = true
			pFightDataParm.m_DamageState[iHitposIndex] = DamageState.E_DamageState_BaoJi	
		end

		--增加手动技能能量增加限制几率的加成
		local fState_Rate = tonumber(globedefine.getFieldByIdAndIndex("EngineHurtA","Para_1"))*0.001	
		if iEngineSkillRate == 2 then
			fState_Rate = tonumber(globedefine.getFieldByIdAndIndex("EngineHurtA","Para_2"))*0.001	
		elseif iEngineSkillRate == 3 then
			fState_Rate = tonumber(globedefine.getFieldByIdAndIndex("EngineHurtA","Para_3"))*0.001	
		end
		
		
		local bShanbi = false
		local bshipo = false

		local type_coe = 0
		local fDamage_base = 0

		if pTeamData.m_SkillData[iSkillIndex].m_power_type == 1 then --//物理攻击
		
			if pTeamDataTar.m_Talent.m_duoshan - pTeamData.m_Talent.m_mingzhong >ihit_rand then
				bShanbi = true
				
				pFightDataParm.m_DamageState[iHitposIndex] = DamageState.E_DamageState_ShanBi	
			end
			

			type_coe = (10+(pTeamData.m_attack - pTeamDataTar.m_attack)*0.1)*0.1

			if type_coe <0.5 then
			
				type_coe = 0.5
			
			elseif type_coe >1.5 then
			
				type_coe = 1.5
			end

			fDamage_base = (pTeamData.m_gongji - pTeamDataTar.m_wufang)*type_coe;
		
		else
		
			if (pTeamDataTar.m_Talent.m_penetrate - pTeamData.m_Talent.m_mingzhong)>ihit_rand then
			
				-- 相同阵营不能触发识破！！！				
				if BaseSceneDB.IsTeam(pFightDataParm.m_FightPos,iTarPos) == false then
					bshipo = true
					pFightDataParm.m_DamageState[iHitposIndex] = DamageState.E_DamageState_ShiPo
				end
					
			end
			
			type_coe = (10+(pTeamData.m_wisdom - pTeamDataTar.m_wisdom)*0.1)*0.1

			if (type_coe <0.5) then
			
				type_coe = 0.5
			
			elseif (type_coe >1.5) then
			
				type_coe = 1.5
			end

			fDamage_base = (pTeamData.m_gongji - pTeamDataTar.m_fafang)*type_coe
		end

		if fDamage_base <=0 then
		
			--fDamage_base = rand()%10 +1
			fDamage_base = ihit_rand%10 +1
			
		end

		if bCrit == true then
		
			fDamage_base =  fDamage_base *1.5
		end
		
		--------技能类型扩展---------------------------------
		if pTeamData.m_SkillData[iSkillIndex].m_type == 1 then --////1普通技能无特效
		
			fDamage_base = fDamage_base * pTeamData.m_SkillData[iSkillIndex].m_ratio
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 2 then--//	2眩晕 伤害+眩晕Buff
		
			fDamage_base =  fDamage_base * pTeamData.m_SkillData[iSkillIndex].m_ratio

			if pTeamData.m_SkillData[iSkillIndex].m_buffchace*fState_Rate > ihit_rand then
						
				pFightDataParm.m_State = DamageState.E_DamageState_xuanyun		
				pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
				pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd		
				pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
			end

		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 3 then--//3吸血（将技能伤害按百分比吸血）
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			local iaddhp = (fDamage_base*pTeamData.m_SkillData[iSkillIndex].m_paramete)*0.01
			pFightDataParm.m_iParamDamage = iaddhp
		
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 4 then--//4治疗 治疗是-伤害
			--//治疗就是伤害 根据攻击力和智力总和*技能系数
				--fDamage_base = -((pTeamData.m_gongji + pTeamData.m_wisdom)*pTeamData.m_SkillData[iSkillIndex].m_ratio)	
				--[[
				治疗调整值0.5<（10+（施法者：统御 – 目标人物：统御）/ 10）/ 10<1.5

				基础治疗回复

				Max[(施法者:攻击力-目标人物:攻击力/2)*治疗调整值*技能加成系数,100]
				暴击:1.5倍回复量

				不受闪避、法破影响
				]]--
				
				local AdjustVel = (10 + (pTeamDataTar.m_strength - pTeamData.m_strength )*0.1)*0.1
				
				if AdjustVel <0.5 then
					AdjustVel = 0.5
				elseif AdjustVel >1.5 then
					AdjustVel = 1.5
				end			
				
				fDamage_base =(pTeamData.m_gongji - pTeamDataTar.m_gongji*0.5)*AdjustVel*pTeamData.m_SkillData[iSkillIndex].m_ratio	

				local MaxBlood = pTeamDataTar.m_allblood*0.05*pTeamData.m_SkillData[iSkillIndex].m_ratio	
				
				if fDamage_base < MaxBlood then
					fDamage_base = MaxBlood
				end

				if bCrit == true then		
					fDamage_base =  fDamage_base *1.5
				end
				
				fDamage_base = -fDamage_base
				
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 5 then--//5概率2次连击
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			if pTeamData.m_SkillData[iSkillIndex].m_paramete > ihit_rand then		
				pFightDataParm.m_iParamDamage = fDamage_base		
			else		
				pFightDataParm.m_iParamDamage = 0
			end
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 6 then--//6消减对方士气
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio

			local ishiqi = pTeamDataTar.m_anger - pTeamData.m_SkillData[iSkillIndex].m_paramete;
			if ishiqi <0 then		
				ishiqi = pTeamDataTar.m_anger		
			else		
				ishiqi = pTeamData.m_SkillData[iSkillIndex].m_paramete
			end
			pFightDataParm.m_iParamDamage = ishiqi
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 7 then--//7偷取敌方士气????
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio

			local ishiqi = pTeamDataTar.m_anger - pTeamData.m_SkillData[iSkillIndex].m_paramete
			if ishiqi <0 then
			
				ishiqi = pTeamDataTar.m_anger;
			
			else
			
				ishiqi = pTeamData.m_SkillData[iSkillIndex].m_paramete
			end
			pFightDataParm.m_iParamDamage = ishiqi
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 8 then--//8造成伤害并增益己方单体士气
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio

			pFightDataParm.m_iParamDamage = pTeamData.m_SkillData[iSkillIndex].m_paramete
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 9 then--//9造成伤害并增益己方全体士气。
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			pFightDataParm.m_iParamDamage = pTeamData.m_SkillData[iSkillIndex].m_paramete
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 10 then--//10施展某伤害技能后恢复参数A的士气---只给自己回。
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			pFightDataParm.m_iParamDamage = pTeamData.m_SkillData[iSkillIndex].m_paramete
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 11 then--//11 伤害+冰冻效果 加伤害状态Buff类
			--//从新设计
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			--print(fState_Rate, pTeamData.m_SkillData[iSkillIndex].m_buffchace,ihit_rand)
			--Pause()
			if pTeamData.m_SkillData[iSkillIndex].m_buffchace*fState_Rate > ihit_rand then
						
				pFightDataParm.m_State = DamageState.E_DamageState_bingdong			
			
				pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
				pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd		
				pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
			end
			
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 12 then--//12血量每减少10%，技能伤害系数增加参数A
			--//从新设计
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 13 then -- //13吸血并恢复。（也就是连发吸血）????
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio

			local iaddhp = (fDamage_base*pTeamData.m_SkillData[iSkillIndex].m_paramete)*0.01
			pFightDataParm.m_iParamDamage = iaddhp
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 14 then --//14生命值低于20%后技能系数翻倍（暂定是己方血量）
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio

			if pTeamData.m_allblood*0.2 >= pTeamData.m_curblood then
			
				fDamage_base = fDamage_base *2
			end
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 15 then --//15 100%眩晕并偷怒气
			
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			pFightDataParm.m_State = DamageState.E_DamageState_xuanyun
			local ishiqi = pTeamDataTar.m_anger - pTeamData.m_SkillData[iSkillIndex].m_paramete
			if ishiqi <0 then
			
				ishiqi = pTeamDataTar.m_anger
			
			else
			
				ishiqi = pTeamData.m_SkillData[iSkillIndex].m_paramete
			end
			pFightDataParm.m_iParamDamage = ishiqi
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 16 then --//16 加伤害Buff类
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			
			pFightDataParm.m_State = DamageState.E_DamageState_Dot			
			pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
			pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
		
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 17 then --//17 加防御Buff类
			
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio	
			
			pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
			pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_wufang	
			--add by sxin 修改数值
			--pFightDataParm.bBuffGainVel  = pTeamData.m_SkillData[iSkillIndex].m_paramete
			pFightDataParm.bBuffGainVel  = (1+(pTeamData.m_level*0.01))*pTeamData.m_SkillData[iSkillIndex].m_ratio*pTeamData.m_wufang			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用	
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 18 then --//击飞类技能
			
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio			

			---这里要判断对方是不是击飞免疫
			if pTeamDataTar.m_State_immune == DamageState.E_DamageState_jifei then 
			
					pFightDataParm.m_State = DamageState.E_DamageState_None				
			else
				if pTeamData.m_SkillData[iSkillIndex].m_buffchace*fState_Rate > ihit_rand then
								
					pFightDataParm.m_State = DamageState.E_DamageState_jifei		
					pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
					pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd		
					pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用
				end	
			end
			
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 19 then --//加能量数值瞬发效果类
			
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio	
			
			if pTeamData.m_SkillData[iSkillIndex].m_buffchace*fState_Rate > ihit_rand then	
				
				pFightDataParm.bBuffGainType = 	BuffGainType.E_GainType_engine	
				pFightDataParm.bBuffGainVel  = pTeamData.m_SkillData[iSkillIndex].m_paramete	
			else
				pFightDataParm.bBuffGainType = BuffGainType.E_GainType_engine	
				pFightDataParm.bBuffGainVel  = 0	
				
			end 	
			
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 20 then --//加伤害吸收盾*****
		
			--[[
			施法人物：抵挡被加盾对象当前血量的10%的伤害值
			每次人物升一级，百分比加0.1%。
			加盾值 =（10%*+（等级/100）*10%）*当前血量 = 
					= （1+（等级/100））*10%*当前血量
				pTeamData.m_SkillData[iSkillIndex].m_ratio = 10%	
			]]--
			
			fDamage_base = 0		
			pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
			pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_xishoudun				
			pFightDataParm.bBuffGainVel = (1+(pTeamData.m_level*0.01))*pTeamData.m_SkillData[iSkillIndex].m_ratio*pTeamData.m_allblood		
			
			--print("加伤害吸收盾")
			--print(pTeamData.m_level,pTeamData.m_SkillData[iSkillIndex].m_ratio,pTeamData.m_allblood)			
			--print(pFightDataParm.bBuffGainVel)			
			--Pause()
			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用			
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 21 then --//加绝对防御Buff类
			
			fDamage_base = 0
			
			pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
			pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_jueduifangyu	
			pFightDataParm.bBuffGainVel  = pTeamData.m_SkillData[iSkillIndex].m_paramete		
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用	
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 22 then --//造成伤害+回复单体能量能量
			
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio

			pFightDataParm.m_iParamDamageType = BuffGainType.E_GainType_engine
			pFightDataParm.m_iParamDamage = pTeamData.m_SkillData[iSkillIndex].m_paramete
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 23 then --//造成伤害+回复全体能量能量
			
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			
			pFightDataParm.m_iParamDamageType = BuffGainType.E_GainType_engine
			pFightDataParm.m_iParamDamage = pTeamData.m_SkillData[iSkillIndex].m_paramete
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 24 then --//造成伤害+属性减益能量
			
			fDamage_base = fDamage_base *pTeamData.m_SkillData[iSkillIndex].m_ratio
			
			pFightDataParm.m_iParamDamageType = BuffGainType.E_GainType_engine
			pFightDataParm.m_iParamDamage = pTeamData.m_SkillData[iSkillIndex].m_paramete
			
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 25 then --//Buff加数值顺发类(攻击力)		

			fDamage_base = 0			
			pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
			pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_gongji	
			
			--add by sxin 修改增加攻击方法			
			--pFightDataParm.bBuffGainVel  = (pTeamData.m_SkillData[iSkillIndex].m_paramete -1)*pTeamData.m_gongji		

			pFightDataParm.bBuffGainVel  = (1+(pTeamData.m_level*0.01))*pTeamData.m_SkillData[iSkillIndex].m_ratio*pTeamData.m_gongji					
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用			
		
		elseif pTeamData.m_SkillData[iSkillIndex].m_type == 26 then --//Buff加数值顺发类(智力)		

			fDamage_base = 0			
			pFightDataParm.bufftimes = pTeamData.m_SkillData[iSkillIndex].m_bufftimes
			pFightDataParm.bufftimecd = pTeamData.m_SkillData[iSkillIndex].m_buffcd			
			pFightDataParm.bBuffGainType = 	BuffGainType.E_BuffGainType_zhili	
			pFightDataParm.bBuffGainVel  = (pTeamData.m_SkillData[iSkillIndex].m_paramete -1)*pTeamData.m_wisdom			
			pFightDataParm.bBuffTYpe = 1--给连续动画的buff特效用			
			
		else
		
		end
		
		fDamage_base = math.floor(fDamage_base)*iEngineSkillRate	
		
		
		--扩展伤害 现在要加上根据对方的防御加成攻击加成的算法
		if fDamage_base > 0 then 
		
			fDamage_base = fDamage_base + pTeamData.m_add_gongji - pTeamDataTar.m_add_fangyu
			
			if fDamage_base <= 0 then 
				fDamage_base = 1
			end
						
		end		
		
		if bShanbi == true then
			pFightDataParm.m_Damage[iHitposIndex] = 0	
		--elseif bshipo == true then
			--pFightDataParm.m_Damage[iHitposIndex] = fDamage_base*0.5	
		else
			pFightDataParm.m_Damage[iHitposIndex] = fDamage_base	
		end			
				
	end
end



--//战斗伤害的逻辑算法
function OnFightDamageLogic(pFightDataParm,iTarPos,bUseEngineSkill)

--	print("OnFightDamageLogic")
--	Pause()

	--//怒气规则和能量规则 暂时是一次普通攻击攻击回复2点怒气 每次普通怒气攻击回10点能量
	--//战斗技能逻辑 玩家怒气4点放怒气技能 怒气不满放普通技能 释放完技能算下手动技能是否可以释放
	--//npc 优先放能量技能 怒气技能 普通技能

	----清理上次的战斗记录
	BaseSceneDB.ClearDamageLogic(pFightDataParm)

	local pTeamData = BaseSceneDB.GetTeamData(pFightDataParm.m_FightPos)
	
	local pTeamDataTar = BaseSceneDB.GetTeamData(iTarPos)
	
	if pTeamDataTar == nil then 
		return 
	end
	
	local iSkillIndex =1
	
	local iEngineSkillRate = 1.0
	
	if BaseSceneDB.IsPKScene() == true then
		if BaseSceneDB.GetFightAuto() == true and  bUseEngineSkill == false then
		
			if pTeamData.m_engine>= MaxEngine then
			
				UseEngineSkill(pFightDataParm.m_FightPos)
				return true
			end

		end

		if bUseEngineSkill == true then
		
			iSkillIndex = 3
			pTeamData.m_engine = 0
			pFightDataParm.m_bUseingEngineSkill = true
			
			pTeamData.m_anger = pTeamData.m_anger + pTeamData.m_SkillData[iSkillIndex].m_anger_back
		
		else
		
			
			if pTeamData.m_anger >= UseAnger then
			
				iSkillIndex = 2
				pTeamData.m_anger = pTeamData.m_anger - UseAnger
			
			else
			
				iSkillIndex = 1
				pTeamData.m_anger = pTeamData.m_anger + pTeamData.m_SkillData[iSkillIndex].m_anger_back
				
			end
			
			if pTeamData.m_engine < MaxEngine then
			
				pTeamData.m_engine = pTeamData.m_engine + pTeamData.m_SkillData[iSkillIndex].m_engine_back
				
				
			end

		end

		if BaseSceneDB.IsNpc(pFightDataParm.m_FightPos) == false then	
			
			m_pBaseScene:UpFighterEngine(pFightDataParm.m_FightPos)
			
		end		
	
	else
		if BaseSceneDB.IsNpc(pFightDataParm.m_FightPos) == true then
	
			if pTeamData.m_engine >= MaxEngine then
				--Pause()
				iSkillIndex = 3
				pTeamData.m_engine = 0
				pTeamData.m_anger = pTeamData.m_anger + pTeamData.m_SkillData[iSkillIndex].m_anger_back
				
				--print(pTeamData.m_SkillData[iSkillIndex].m_anger_back)
				--Pause()

			
			elseif pTeamData.m_anger >= UseAnger then
			
				iSkillIndex = 2
				pTeamData.m_engine = pTeamData.m_engine + pTeamData.m_SkillData[iSkillIndex].m_engine_back
				pTeamData.m_anger  = pTeamData.m_anger - UseAnger
				
				--print(pTeamData.m_SkillData[iSkillIndex].m_engine_back)
				--Pause()
			
			else
			
				iSkillIndex = 1
				pTeamData.m_engine = pTeamData.m_engine + pTeamData.m_SkillData[iSkillIndex].m_engine_back
				pTeamData.m_anger  = pTeamData.m_anger + pTeamData.m_SkillData[iSkillIndex].m_anger_back
				
				--print(pTeamData.m_SkillData[iSkillIndex].m_engine_back)
				--print(pTeamData.m_SkillData[iSkillIndex].m_anger_back)
				--printTab(pTeamData)
				--Pause()
			end	
		
		else
		
			if BaseSceneDB.GetFightAuto() == true and  bUseEngineSkill == false then
			
				if pTeamData.m_engine>= MaxEngine then
				
					UseEngineSkill(pFightDataParm.m_FightPos)
					return true
				end

			end

			if bUseEngineSkill == true then
			
				iSkillIndex = 3
				--修改手动技能倍数	
				
				if pTeamData.m_engine >= MaxEngine then
						iEngineSkillRate = 1
					if pTeamData.m_engine >= MaxEngine*3 then 
						iEngineSkillRate = 3
					elseif pTeamData.m_engine >= MaxEngine*2 then 
						iEngineSkillRate = 2
					end
					
				end		
				
				
				pTeamData.m_engine = pTeamData.m_engine - iEngineSkillRate*MaxEngine	

				--print("bUseEngineSkill ipos = " .. pFightDataParm.m_FightPos .. "m_engine = " .. pTeamData.m_engine)
				pFightDataParm.m_bUseingEngineSkill = true
			--	Pause()
			
			else
			
				if pTeamData.m_anger >= UseAnger then
				
					iSkillIndex = 2

					pTeamData.m_anger = pTeamData.m_anger - UseAnger
				
				else
					iSkillIndex = 1
					pTeamData.m_anger = pTeamData.m_anger + pTeamData.m_SkillData[iSkillIndex].m_anger_back
				end
				
				if pTeamData.m_engine < UseMaxEngine then
				
					pTeamData.m_engine = pTeamData.m_engine + pTeamData.m_SkillData[iSkillIndex].m_engine_back
					if pTeamData.m_engine > UseMaxEngine then
						pTeamData.m_engine = UseMaxEngine
					end
				end
				
			end
			
			--print(pFightDataParm.m_FightPos)
			--print(pTeamData.m_engine)
			m_pBaseScene:UpFighterEngine(pFightDataParm.m_FightPos)
			--Pause()
			
		end
	
	end
		
	OnFightDamageLogic_0(pFightDataParm,pTeamData,iSkillIndex,iTarPos)
	
	OnFightDamageLogic_1(pFightDataParm,pTeamData,iSkillIndex,iTarPos,iEngineSkillRate)


	
	return false

end

function PlaySound(audioType,SoundName)	
	if SoundName ~= nil then
		SimpleAudioEngine:sharedEngine():playEffect(SoundName,false)	
	end
	
end

function PlayAttack(pArmature,iSkill)

	--print("PlayAttack iSkill=" .. iSkill)
	--Pause()
	
	if pArmature:getAnimation():getCurrentMovementID() == GetAniName_Player(pArmature,Ani_Def_Key.Ani_die) then
		return
	end
	
	if iSkill<=0 then
	
	--print("PlayAttack iSkill<=0 iSkill:" .. iSkill)
	--Pause()
		return
	end
	
	local pSkillData = SkillData.getDataById(iSkill)	
	
	local pActName = pSkillData[SkillData.getIndexByField("ActName")]
	
	--print("PlayAttack :" .. pActName .."          iSkill = " .. iSkill)
	--Pause()
	
	pArmature:getAnimation():play(pSkillData[SkillData.getIndexByField("ActName")])
	

	PlaySound(Audio_Type.E_Audio_Attack,pSkillData[SkillData.getIndexByField("Audio_Skill")])
	
	
	
end


function FightCheckDis(pArmature)
	
	local ipos = pArmature:getTag()
		
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(ipos)

	local iTar = GetFightTarPos(ipos)	
	
	if iTar>0 then
	
		pFightDataParm.m_iTarpos = iTar
		
		local pArmaturetar = BaseSceneDB.GetPlayArmature(iTar)
				
		local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTar)
		
		local fDisX = math.floor(math.abs(pArmature:getPositionX() - pArmaturetar:getPositionX())-((pFightDataParm.m_Mode_Width + pFightDataParmTar.m_Mode_Width)*0.5))

		if fDisX > pFightDataParm.m_AttackDis then
			
			--if IsNpc(ipos) == false then
			--	print("pArmature:getPositionX()=" .. pArmature:getPositionX() .. "pArmaturetar:getPositionX()" .. pArmaturetar:getPositionX())
			--	print(" FightCheckDis:fDisX > pFightDataParm.m_AttackDis=" .. pFightDataParm.m_AttackDis .. ",fDisX=" .. fDisX .. ",iPos=" .. ipos .. ",iTarPos" .. iTar)
			--	print("pArmature:getPositionX()=" .. pArmature:getPositionX() .. "pArmaturetar:getPositionX()" .. pArmaturetar:getPositionX())
			--	print("pFightDataParm.m_Mode_Width=" .. pFightDataParm.m_Mode_Width .. "pFightDataParmTar.m_Mode_Width" .. pFightDataParmTar.m_Mode_Width)
			--	Pause()
			--end
			--local arrivedis = math.floor((fDisX- pFightDataParm.m_AttackDis )*0.5)	
				
			local arrivedis = math.floor((fDisX- pFightDataParm.m_AttackDis ))	
			
			local arrivetime = arrivedis/MaxPlayMoveSpeed

			--//??????
			if BaseSceneDB.IsNpc(iTar) == false then
			
				arrivedis = -arrivedis
			end					

			local pMoveBy = CCMoveBy:create(arrivetime,ccp(arrivedis,0))
			local pcallFuncActArriveTo = CCCallFuncN:create(DisActArriveTo)
			local pSequence  = CCSequence:createWithTwoActions( pMoveBy, pcallFuncActArriveTo)
			
			pSequence:setTag(FightMoveIagID)
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))
			pArmature:runAction(pSequence)

			pFightDataParm.m_FightState = 1

			return true

		end
		pFightDataParm.m_FightState = 0
	end
	return false
end

function DisActArriveTo(pNode)

	local pArmature = tolua.cast(pNode, "CCArmature")
	local iPos = pArmature:getTag()
	if BaseSceneDB.IsDie(iPos) == false and pArmature:getAnimation():getCurrentMovementID() == GetAniName_Player(pArmature,Ani_Def_Key.Ani_run) then
		pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
	end
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(pArmature:getTag())
	
	pFightDataParm.m_FightState = 0
	
	OnFightLogic(pArmature)
	
end

function OnFight(pNode)

	
	local pArmature = tolua.cast(pNode, "CCArmature")	
	pArmature:stopActionByTag(FightTimeIagID)

	if BaseSceneDB.IsDie(pArmature:getTag()) == true then		
		return
	end	
	--print("**********OnFight: iPos = " ..pArmature:getTag())
	--判断是不是眩晕中
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(pArmature:getTag())
	
	if pFightDataParm.m_buff_state ~= nil and pFightDataParm.m_buff_state == DamageState.E_DamageState_xuanyun then 	
		SetFight(pArmature,0.1)
		return
	end	
	
	if FightCheckDis(pArmature) == false then		
		
		OnFightLogic(pArmature)		
	end	
end


function SetNodeTimer(pNode,fTime, pcallFunc, iTagID)

	local pDelay = CCDelayTime:create(fTime)	
	local pSequence  = CCSequence:createWithTwoActions(pDelay, pcallFunc)
	pSequence:setTag(iTagID)
	pNode:runAction(pSequence)
end


function SetFight( pNode, fTime)
 	
	--[[
	--保证FightTimeIagID的动作只有一个
	local  pAction = pNode:getActionByTag(FightTimeIagID)
	if pAction == nil then	
		local pcallFunc = CCCallFuncN:create(OnFight)
		SetNodeTimer(pNode,fTime,pcallFunc,FightTimeIagID)
	else
		print("SetFight err iPos = " .. pNode:getTag())				
	end
	--]]
	
	local pcallFunc = CCCallFuncN:create(OnFight)	
	SetNodeTimer(pNode,fTime,pcallFunc,FightTimeIagID)
end

function UseHufaSkill(iIndex)
	
	if BaseSceneDB.GetFightEnd() == true then		
		return
	end	
	
	local pFightDataParm = BaseSceneDB.GetHufaFightParm(iIndex)	 
	----清理上次的战斗记录
	BaseSceneDB.ClearDamageLogic(pFightDataParm)
	
	local pHufaData = BaseSceneDB.GethufaData(iIndex)
	local pArmature = BaseSceneDB.GetHufaArmature(iIndex)
	
	pHufaData.m_engine = 0
	local iTarPos = -1	
	
	if iIndex == 1 then 		
		m_pBaseScene:UpHufaEngine()		
		iTarPos = GetFightTarPos(1)
	else
		iTarPos = GetFightTarPos(6)
	end
	
	
	
	pFightDataParm.m_iTarpos = iTarPos
	
	if pFightDataParm.m_iTarpos>=0 then				
	
		OnFightDamageLogic_0(pFightDataParm,pHufaData,3,iTarPos)			
		OnFightDamageLogic_1(pFightDataParm,pHufaData,3,iTarPos,1)		
		
		pArmature:setPositionX(MaxMoveDistance*0.5 + MaxMoveDistance*(BaseSceneDB.GetCurTimes()-1))
		pArmature:setVisible(true)	
		pFightDataParm.m_bUseingEngineSkill = true
		pArmature:setColor(BlackLayerColourNor3)	
		resumeSchedulerAndActions(pArmature)				
		PlayAttack(pArmature,pFightDataParm.m_iSkill)	
		
		PAuseAllAnimation(pArmature)	
	end
	
end



--护法战斗逻辑
function OnFightHufaLogic(pArmature)		
	
	if BaseSceneDB.GetFightEnd() == true then		
		return
	end	
	
	local iIndex = pArmature:getTag() - Fight_hufa_TagID_Root
	
	local pFightDataParm = BaseSceneDB.GetHufaFightParm(iIndex)	 
	
	--运算能量
	

	local pHufaData = BaseSceneDB.GethufaData(iIndex)	

	if pHufaData.m_engine < Fight_hufa_EngMax then
		
		if m_UseingEngineSkillStopTimes <= 0 then 
		
			--print("pHufaData.m_engine_back = " .. pHufaData.m_engine_back)
			pHufaData.m_engine = pHufaData.m_engine + pHufaData.m_engine_back
			--print(pHufaData.m_engine)
		end 		
		
	else
		----使用护法逻辑
		if BaseSceneDB.IsPKScene() == true then
			UseHufaSkill(iIndex)
		else
			if iIndex == 1 then 
				if BaseSceneDB.GetFightAuto() == true then 
					
					UseHufaSkill(iIndex)
					
				end
			else
				UseHufaSkill(iIndex)
			end
			
		end
		
	end	
	--print("Index = " .. iIndex .. "m_engine = " .. pHufaData.m_engine)	
	if iIndex == 1 then 
		m_pBaseScene:UpHufaEngine()
	end
	SetHufaFight(pArmature,Fight_hufa_Time)
end

function OnHufaFight(pNode)	

	local pArmature = tolua.cast(pNode, "CCArmature")	
	pArmature:stopActionByTag(FightTimeIagID)	
	
	OnFightHufaLogic(pArmature)		
	
end

function SetHufaFight( pNode, fTime)
	 	
	--[[
	--保证FightTimeIagID的动作只有一个
	local  pAction = pNode:getActionByTag(FightTimeIagID)
	if pAction == nil then	
		local pcallFunc = CCCallFuncN:create(OnFight)
		SetNodeTimer(pNode,fTime,pcallFunc,FightTimeIagID)
	else
		print("SetFight err iPos = " .. pNode:getTag())				
	end
	--]]	
	
	local pcallFunc = CCCallFuncN:create(OnHufaFight)
	SetNodeTimer(pNode,fTime,pcallFunc,FightTimeIagID)
end



--//游戏战斗逻辑
function OnFightLogic( pArmature)

	if BaseSceneDB.GetFightEnd() == true then		
		return
	end	
	
	---//战斗逻辑接口需要算使用技能的规则和下次攻击技能的cd时间
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(pArmature:getTag())
	
	--print("pFightDataParm.m_FightPos = " .. pFightDataParm.m_FightPos .. "getTag=" .. pArmature:getTag())
	--Pause()
	 
	
	--//死亡		
	if BaseSceneDB.IsDie(pFightDataParm.m_FightPos) == false then
	
		--print("pFightDataParm.m_iTarpos = " .. pFightDataParm.m_iTarpos )
		--Pause()
		if pFightDataParm.m_iTarpos ~= -1 then
			
			
			if BaseSceneDB.IsDie(pFightDataParm.m_iTarpos)== true then
				--print("pFightDataParm.m_iTarpos IsDie")
				--Pause()
				pFightDataParm.m_iTarpos = GetFightTarPos(pFightDataParm.m_FightPos);
			end 		 
		end
		
		
		if pFightDataParm.m_iTarpos>=0 then
					
			local bEngineSkill = OnFightDamageLogic(pFightDataParm,pFightDataParm.m_iTarpos,false)		
						
			PlayAttack(pArmature,pFightDataParm.m_iSkill)	
			
			if bEngineSkill == false then
				--测试攻击频率				
				SetFight(pArmature,pFightDataParm.m_CdTime)
			end		
			
		end

	
	end
	
end

function OnDamageNumEnd(pNode)	
	
	local pUILabelBMFont = tolua.cast(pNode, "LabelBMFont")

	pUILabelBMFont:removeFromParentAndCleanup(true)	
end



--//冒伤害特效
function PlayEffect_Damage( iState, iSourPos, iTarPos, iDamage, iEngineSKill)

		
	--//闪避就不调用伤害了
	--if iState ~= DamageState.E_DamageState_ShanBi then
		
		---冒血的运动轨迹
		local pDelayStar = CCDelayTime:create(0.1)	
		local pScaleTo = CCScaleTo:create(0.1,2.0,2.0)
		
	--	local pScaleTo1 = CCScaleTo:create(0.1,1.0,1.0)
		local pScaleTo1 = CCScaleTo:create(0.2,1.0,1.0)
		--local pDelay = CCDelayTime:create(0.4)
		--local pScaleTo2 = CCScaleTo:create(0.1,0.1,0.1)	

			
		
		local pcallFunc = CCCallFuncN:create(OnDamageNumEnd)
		
		local arr = CCArray:create()
		arr:addObject(pDelayStar)
		arr:addObject(pScaleTo)
		arr:addObject(pScaleTo1)
		--arr:addObject(pDelay)
		--arr:addObject(pScaleTo2)
		arr:addObject(CCFadeOut:create(0.5))
		arr:addObject(pcallFunc)		
		
		local pScaleToseq  = CCSequence:create(arr)
		
		local pMoveUp = CCMoveBy:create(0.8,ccp(0,100))
		
		local spawn = CCSpawn:createWithTwoActions(pMoveUp, pScaleToseq)
		
		
		--//做伤害显示
		--// Create the LabelBMFont
		local labelBMFont = LabelBMFont:create()	
		
		--//如果是识破要反给技能施法者
		if iState == DamageState.E_DamageState_ShiPo then			

			--//施法者播放被打动画
			local pArmature = BaseSceneDB.GetPlayArmature(iSourPos) 
			
			if BaseSceneDB.IsNpc(iSourPos) == true then
				
				labelBMFont:setFntFile("Image/Fight/UI/blood/npc_norm_blood.fnt")
				
			else
			
				labelBMFont:setFntFile("Image/Fight/UI/blood/play_norm_blood.fnt")
			end
			

			local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourPos)
			
			if pArmature:getPositionY() + pFightDataParm.m_Mode_Height*0.5 > DeviceSize.height then 
	
				labelBMFont:setPosition(ccp(pArmature:getPositionX(),DeviceSize.height + Fight_Bloodoff_y - DefOffY))
			
			else
				labelBMFont:setPosition(ccp(pArmature:getPositionX(),pArmature:getPositionY() + pFightDataParm.m_Mode_Height*0.5 + Fight_Bloodoff_y))
			end	
			
			--增加骨骼绑定
			local pBone = pArmature:getBone("xuetiao")	
			if pBone ~= nil then 
			
				if pArmature:getScaleX() > 0 then
					
					labelBMFont:setPosition(ccp( pArmature:getPositionX()+ pBone:nodeToArmatureTransform().tx, pArmature:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
										
				else
				
					labelBMFont:setPosition(ccp( pArmature:getPositionX() - pBone:nodeToArmatureTransform().tx, pArmature:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
			
				end 				
	
			end
			
								
			if pArmature ~= nil then
			
				if  pArmature:getAnimation():getCurrentMovementID() == GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand) then
				
					--判断是不是被限制了
					if BaseSceneDB.IsBuff_State( iSourPos ) == false then 
					
						pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_hitted))
					
					end
					
				end					
			end				
		
		else 
		
			if (iState == DamageState.E_DamageState_BaoJi) then
			
			
				if BaseSceneDB.IsNpc(iTarPos) == true then
				
					labelBMFont:setFntFile("Image/Fight/UI/blood/npc_crit_blood.fnt")
					
				else
				
					labelBMFont:setFntFile("Image/Fight/UI/blood/play_crit_blood.fnt")
				end		
			
			else
				
				if BaseSceneDB.IsNpc(iTarPos) == true then
				
					labelBMFont:setFntFile("Image/Fight/UI/blood/npc_norm_blood.fnt")
					
				else
				
					labelBMFont:setFntFile("Image/Fight/UI/blood/play_norm_blood.fnt")
				end			
				
			end

			--//施法者播放被打动画
			local pArmatureTar = BaseSceneDB.GetPlayArmature(iTarPos) 

			local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTarPos) 
			
			
			if pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5 > DeviceSize.height then 
			
				labelBMFont:setPosition(ccp(pArmatureTar:getPositionX(),DeviceSize.height  + Fight_Bloodoff_y- DefOffY))
				
			else
			
				labelBMFont:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5 + Fight_Bloodoff_y))
				
			end
			
			--增加骨骼绑定
			local pBone = pArmatureTar:getBone("xuetiao")	
			if pBone ~= nil then 
			
				if pArmatureTar:getScaleX() > 0 then
					
					labelBMFont:setPosition(ccp( pArmatureTar:getPositionX()+ pBone:nodeToArmatureTransform().tx, pArmatureTar:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
										
				else
				
					labelBMFont:setPosition(ccp( pArmatureTar:getPositionX() - pBone:nodeToArmatureTransform().tx, pArmatureTar:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
			
				end 				
	
			end

			

		end

		
		labelBMFont:setText("-" .. iDamage)
		labelBMFont:setZOrder(iTarPos)
		labelBMFont:runAction(spawn)
		
		if iEngineSKill == true then
			
			m_pBaseScene:Get_Layer_Root():addWidget(labelBMFont)
					
		else
		
			m_pBaseScene:Get_DamageLayer():addWidget(labelBMFont)
		end		
	--end
end


--//冒加血特效
function PlayEffect_Blood( iState, iSourPos, iTarPos, iBlood, iEngineSKill)	
		
	--调用加血---
	
---冒血的运动轨迹
		local pDelayStar = CCDelayTime:create(0.1)	
		local pScaleTo = CCScaleTo:create(0.1,2.0,2.0)
		
	--	local pScaleTo1 = CCScaleTo:create(0.1,1.0,1.0)
		local pScaleTo1 = CCScaleTo:create(0.2,1.0,1.0)
		--local pDelay = CCDelayTime:create(0.4)
		--local pScaleTo2 = CCScaleTo:create(0.1,0.1,0.1)	

			
		
		local pcallFunc = CCCallFuncN:create(OnDamageNumEnd)
		
		local arr = CCArray:create()
		arr:addObject(pDelayStar)
		arr:addObject(pScaleTo)
		arr:addObject(pScaleTo1)
		--arr:addObject(pDelay)
		--arr:addObject(pScaleTo2)
		arr:addObject(CCFadeOut:create(0.5))
		arr:addObject(pcallFunc)		
		
		local pScaleToseq  = CCSequence:create(arr)
		
		local pMoveUp = CCMoveBy:create(0.8,ccp(0,100))
		
		local spawn = CCSpawn:createWithTwoActions(pMoveUp, pScaleToseq)
	
	
	--// Create the LabelBMFont
	local labelBMFont = LabelBMFont:create()			
				
	labelBMFont:setFntFile("Image/Fight/UI/blood/greenblood.fnt")		

	--//施法者播放被打动画
	local pArmatureTar = BaseSceneDB.GetPlayArmature(iTarPos)

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTarPos)

	if pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5 > DeviceSize.height then 
	
		labelBMFont:setPosition(ccp(pArmatureTar:getPositionX(),DeviceSize.height  + Fight_Bloodoff_y - DefOffY))
	
	else
		labelBMFont:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5 + Fight_Bloodoff_y))
	end	
	
	
	labelBMFont:setText("+" .. iBlood)
	labelBMFont:setZOrder(iTarPos)
	labelBMFont:runAction(spawn)
	
	if iEngineSKill == true then
	
		m_pBaseScene:Get_Layer_Root():addWidget(labelBMFont)
	
	else
	
		m_pBaseScene:Get_DamageLayer():addWidget(labelBMFont)
	end			
	
	
end



--//加能量特效
function PlayEffect_Engine(iSourPos)	
	
	local pArmatureTar = BaseSceneDB.GetPlayArmature(iSourPos)
	local pFightTarDataParm = BaseSceneDB.GetPlayFightParm(iSourPos)	
		--播放加能量特效
	local pArmatureEngine = nil
	--用鼓手的加能量特效		
	local pEffectData = EffectData.getDataById(136)
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName")])
	
	pArmatureEngine = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName")])	
	
	pArmatureEngine:setPosition(ccp(0, pFightTarDataParm.m_Mode_Height*0.5 ))	
	
	pArmatureEngine:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_0")]))	

	pArmatureEngine:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)	
	
	pArmatureTar:addChild(pArmatureEngine,Play_Effect_Z)
	
end
function PlayEffect_Engine_Number(  iSourPos, iEngine)	
		
		
	---冒血的运动轨迹
		local pDelayStar = CCDelayTime:create(0.1)	
		local pScaleTo = CCScaleTo:create(0.1,2.0,2.0)
		
	--	local pScaleTo1 = CCScaleTo:create(0.1,1.0,1.0)
		local pScaleTo1 = CCScaleTo:create(0.2,1.0,1.0)
		--local pDelay = CCDelayTime:create(0.4)
		--local pScaleTo2 = CCScaleTo:create(0.1,0.1,0.1)	

			
		
		local pcallFunc = CCCallFuncN:create(OnDamageNumEnd)
		
		local arr = CCArray:create()
		arr:addObject(pDelayStar)
		arr:addObject(pScaleTo)
		arr:addObject(pScaleTo1)
		--arr:addObject(pDelay)
		--arr:addObject(pScaleTo2)
		arr:addObject(CCFadeOut:create(0.5))
		arr:addObject(pcallFunc)		
		
		local pScaleToseq  = CCSequence:create(arr)
		
		local pMoveUp = CCMoveBy:create(0.8,ccp(0,100))
		
		local spawn = CCSpawn:createWithTwoActions(pMoveUp, pScaleToseq)
	
	
	--// Create the LabelBMFont
	local labelBMFont = LabelBMFont:create()			
				
	labelBMFont:setFntFile("Image/Fight/UI/blood/engine.fnt")		

	--//施法者播放被打动画
	local pArmatureTar = BaseSceneDB.GetPlayArmature(iSourPos)

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iSourPos)

	if pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5 > DeviceSize.height then 
	
		labelBMFont:setPosition(ccp(pArmatureTar:getPositionX(),DeviceSize.height  + Fight_Bloodoff_y - DefOffY))
	
	else
		labelBMFont:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5  + Fight_Bloodoff_y -20))
	end	
	
	if iEngine>= 0 then 	
		labelBMFont:setText("+" .. iEngine)
	else
		labelBMFont:setText(tostring(iEngine))
	end
	labelBMFont:setZOrder(iSourPos)
	labelBMFont:runAction(spawn)	
	
	m_pBaseScene:Get_DamageLayer():addWidget(labelBMFont)	
	
				
	
end


--播放欢呼动画
function PlayCheers()
	if BaseSceneDB.IsPKScene() == true then
	
		if BaseSceneDB.GetFightResult() == 1	then
			local i=1
			local pPlayer = nil
			for i=1 , MaxTeamPlayCount, 1 do
				if BaseSceneDB.IsUser(i) == true and  BaseSceneDB.IsDie(i) == false then
					pPlayer = BaseSceneDB.GetPlayArmature(i)
					if pPlayer:getAnimation():getMovementCount() >=  9 then 
						--print(i)
						--Pause()
						pPlayer:getAnimation():play(GetAniName_Player(pPlayer,Ani_Def_Key.Ani_cheers))
					else
						print("角色动画缺少动作")
					end 
				end
			end	
		else
			
			local i=6
			local pPlayer = nil
			for i=6 , MaxTeamPlayCount*2, 1 do
				if BaseSceneDB.IsUser(i) == true and  BaseSceneDB.IsDie(i) == false then
					pPlayer = BaseSceneDB.GetPlayArmature(i)
					if pPlayer:getAnimation():getMovementCount() >=  9 then 
						
						pPlayer:getAnimation():play(GetAniName_Player(pPlayer,Ani_Def_Key.Ani_cheers))
					else
						print("角色动画缺少动作")
					end 
				end
			end	
			
		end
		
		
	else

		
		
		local i=1
		local pPlayer = nil
		for i=1 , MaxTeamPlayCount, 1 do
			if BaseSceneDB.IsUser(i) == true and  BaseSceneDB.IsDie(i) == false then
				pPlayer = BaseSceneDB.GetPlayArmature(i)
				if pPlayer:getAnimation():getMovementCount() >=  9 then 
					--print(i)
					--Pause()
					pPlayer:getAnimation():play(GetAniName_Player(pPlayer,Ani_Def_Key.Ani_cheers))
				else
					print("角色动画缺少动作")
				end 
			end
		end	
	
	end
	
	
end


function CheckFightResult(diepos)
		
	if BaseSceneDB.GetFightEnd() == true then
		return
	end
	
	if BaseSceneDB.IsNpc(diepos) == true then
	
		local i=1 
		local iNpc = 1
		for i=1, MaxTeamPlayCount, 1 do
			iNpc = i+ BaseSceneDB.GetCurTimes() *MaxTeamPlayCount
			if BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
				return
			end
		end
		--胜利
		BaseSceneDB.SetFightResult(1)			
		m_pBaseScene:EndFight_SenenSprite()			
		
		
	else --玩家
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			if BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
				return
			end
		end
		
		-------失败--------
		BaseSceneDB.SetFightResult(0)
		m_pBaseScene:EndFight_SenenSprite()			
		
	end
	
end

--扩展播放伤害案伤害列表播放跟比伤害对象做不同的表现
function PlayDamageList(pEffectParm)
	
	local i = 1
	for i=1,MaxTeamPlayCount, 1 do
		
		if pEffectParm.HitPos[i] > 0 then	
			
			--PlayDamage(pEffectParm.m_iSource,pEffectParm.HitPos[i],pEffectParm.m_State,pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)	
			PlayDamage(pEffectParm.m_iSource,pEffectParm.HitPos[i],pEffectParm.m_iDamageState[i],pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)	
			
		end
		
	end
	
end

function playEngine(iSourPos,iEngine )
		
	local pFighter = BaseSceneDB.GetTeamData(iSourPos)
	
	pFighter.m_engine = pFighter.m_engine + iEngine
	
	if pFighter.m_engine > UseMaxEngine then 
		pFighter.m_engine = UseMaxEngine
	end
	
	PlayEffect_Engine_Number(iSourPos,iEngine)
	
	m_pBaseScene:UpFighterEngine(iSourPos)		
	
end

local function OnDamageStateEnd(pNode)	
	
	local pSprite = tolua.cast(pNode, "CCSprite")
	pSprite:removeFromParentAndCleanup(true)	
end

local function PlayDamageState(istate,iTarPos,iEngineSKill)
	
	local pstateEffect = nil
	if (istate == DamageState.E_DamageState_ShiPo) then
			pstateEffect = CCSprite:create("Image/Fight/UI/shipo.png")
	elseif (istate == DamageState.E_DamageState_ShanBi) then		
			pstateEffect = CCSprite:create("Image/Fight/UI/shanbi.png")
	else
		return		
	end
		
---的运动轨迹
	local pDelayStar = CCDelayTime:create(0.1)	
	local pScaleTo = CCScaleTo:create(0.1,2.0,2.0)
	local pScaleTo1 = CCScaleTo:create(0.2,1.0,1.0)		
	local pcallFunc = CCCallFuncN:create(OnDamageStateEnd)
	
	local arr = CCArray:create()
	arr:addObject(pDelayStar)
	arr:addObject(pScaleTo)
	arr:addObject(pScaleTo1)		
	arr:addObject(CCFadeOut:create(0.5))
	arr:addObject(pcallFunc)		
	
	local pScaleToseq  = CCSequence:create(arr)		
	local pMoveUp = CCMoveBy:create(0.5,ccp(0,100))		
	local spawn = CCSpawn:createWithTwoActions(pMoveUp, pScaleToseq)
		
	local pArmatureTar = BaseSceneDB.GetPlayArmature(iTarPos)
	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTarPos)

	if pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5 > DeviceSize.height then 
	
		pstateEffect:setPosition(ccp(pArmatureTar:getPositionX(),DeviceSize.height  + Fight_Bloodoff_y - DefOffY))
	
	else
		pstateEffect:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5 + Fight_Bloodoff_y))
	end	
		
	pstateEffect:setZOrder(iTarPos)
	pstateEffect:runAction(spawn)
	
	if iEngineSKill == true then	
		m_pBaseScene:Get_Layer_Root():addChild(pstateEffect)	
	else	
		m_pBaseScene:Get_DamageLayer():addChild(pstateEffect)
	end		
	
end

function PlayDamage(iSourPos,iTarPos,istate,iallDamage,iUseEngineSkill )
	
	--增加闪避识破播放效果
	PlayDamageState(istate,iTarPos,iUseEngineSkill)
	--//add by sxin 识破要把伤害算到攻击方
	local pFighter = nil
	local iFighterPos = nil
	local iDamage = iallDamage
	if (istate == DamageState.E_DamageState_ShiPo) then
		--Pause()
		--承受30%伤害，反弹30%伤害
		pFighter = BaseSceneDB.GetTeamData(iSourPos)	
		iFighterPos = iSourPos
		
		iDamage = iallDamage*0.3		
		PlayDamage(iSourPos,iTarPos,0,iDamage,iUseEngineSkill )
	else
	
		pFighter = BaseSceneDB.GetTeamData(iTarPos)	
		iFighterPos = iTarPos
	end

	-- 改成是死亡动画就不播放了
	if pFighter.m_curblood <= 0 then	
		return
	end
	
	--判断吸收罩
	if pFighter.m_xishoudun > 0 and iDamage > 0 then 		
		
		if pFighter.m_xishoudun >= iDamage then 
			
			pFighter.m_xishoudun = pFighter.m_xishoudun - iDamage
			iDamage = 0
		else				
			pFighter.m_xishoudun = 0
			iDamage =  iDamage - pFighter.m_xishoudun 
			
		end
		
	end
		

	pFighter.m_curblood = pFighter.m_curblood -iDamage

	if pFighter.m_curblood<0 then
	
		pFighter.m_curblood = 0
	end
	
	if  pFighter.m_curblood > pFighter.m_allblood then
	
		pFighter.m_curblood = pFighter.m_allblood
	end
	
	--add by sxin 强制判断pk数据和服务器的一致性 判断服务器这次伤害是否死亡	
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

	local pArmature = BaseSceneDB.GetPlayArmature(iTarPos)
	
	
	--增加显示血条
	if BaseSceneDB.GetFightEnd() ==  false then
		SetAnimationUiVisible(pArmature,true)
	end	
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iTarPos)

	--//死亡
	if pFighter.m_curblood <= 0 then	
	
		if istate == DamageState.E_DamageState_ShiPo then	
		
			pArmature = BaseSceneDB.GetPlayArmature(iSourPos) 
			pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourPos)
			
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_die))
			
			local DieSound = AnimationData.getFieldByIdAndIndex(pFightDataParm.m_imageID,"Audio_Die")
			
			PlaySound(Audio_Type.E_Audio_Die,DieSound)		

			--调用场景脚本--
			
			--识破算是被对方杀死的
						
			--BaseSceneDB.GetSceneScript():Die(iSourPos, iTarPos)
			m_pBaseScene:Die(iSourPos, iTarPos)
			CheckFightResult(iSourPos)
		else
			
			---add by sxin 判断死的时候是不是在用手动技能			
			if pFightDataParm.m_bUseingEngineSkill == true then	
				--Pause()
				ResumeAllAnimation(pArmature)
				ResumeAllEffect()
				pFightDataParm.m_bUseingEngineSkill = false
			end
			
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_die))
			
			local DieSound = AnimationData.getFieldByIdAndIndex(pFightDataParm.m_imageID,"Audio_Die")
			
			PlaySound(Audio_Type.E_Audio_Die,DieSound)	

			--调用场景脚本--
			
			--BaseSceneDB.GetSceneScript():Die(iTarPos,iSourPos)	
			m_pBaseScene:Die(iTarPos, iSourPos)			
			CheckFightResult(iTarPos)		
		end	
	else	
					
		if iDamage < 0 then
			------播放加血特效-----------
		
			local pArmatureBlood = nil
			
			local pEffectData = EffectData.getDataById(15)
			
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName")])
			
			pArmatureBlood = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName")]);	
				
			
			if BaseSceneDB.IsNpc(iTarPos) == false then
			
				--//翻转特效
				pArmatureBlood:setScaleX(-(pArmatureBlood:getScaleX()))
			end

			--//取目标角色的位置 
			local pArmatureTar = BaseSceneDB.GetPlayArmature(iTarPos)
			
			local pFightTarDataParm = BaseSceneDB.GetPlayFightParm(iTarPos)	

			if tonumber(pEffectData[EffectData.getIndexByField("bindbone")]) >0 then
			
				pArmatureBlood:setPosition(ccp(pArmatureTar:getPositionX(), pArmatureTar:getPositionY() + tonumber(pFightTarDataParm.m_Mode_Height)*0.5))	
				
			else
				pArmatureBlood:setPosition(ccp(pArmatureTar:getPositionX(), pArmatureTar:getPositionY() ))
			end 
			
			pArmatureBlood:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder")])+pArmatureTar:getZOrder())
			
			pArmatureBlood:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_0")]))
			
				
			pArmatureBlood:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

			pArmatureBlood:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)

			if iUseEngineSkill == true then			
				
				m_pBaseScene:Get_Layer_Root():addChild(pArmatureBlood)
			
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmatureBlood)				
			end	
		elseif pArmature:getAnimation():getCurrentMovementID() == GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand) then
		
			--判断是不是被限制了
			if BaseSceneDB.IsBuff_State( iTarPos ) == false then 
			
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_hitted))
			
			end			
		end				
	end

	--加血效果分开
	if iDamage < 0 then
		PlayEffect_Blood(istate,iSourPos,iTarPos,-iDamage,iUseEngineSkill)
	else
		PlayEffect_Damage(istate,iSourPos,iTarPos,iDamage,iUseEngineSkill)
	end
	

	if istate == DamageState.E_DamageState_ShiPo then	
		m_pBaseScene:UpFighterBlood(iSourPos)	
		
		m_pBaseScene:Damage(iSourPos)
	else	
		m_pBaseScene:UpFighterBlood(iTarPos)
		m_pBaseScene:Damage(iTarPos)
	end
				
end

--//技能特效帧事件扩展用
function onEffectFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)	
	
	if evt == FrameEvent_Key.Event_Vibration then			
		 VibrationSceen(3)										   
	end
end

--特效删除接口支持骨骼绑定特效
function DelArmature( Armature )
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


--//技能特效回调 播放完自动删除 
function onEffectMovementEvent(Armature, MovementType, movementID)

	if MovementType == MovementEventType.start	then
	
	elseif MovementType == MovementEventType.complete then		
	
		local iEffectTag = Armature:getTag()
		
		if iEffectTag ~= nil and iEffectTag > 0 then
			
			local pEffectParm = BaseSceneDB.GetEffectParm(iEffectTag)
			
			if pEffectParm ~= nil then 
			
				if pEffectParm.bBuffTYpe ~= nil and pEffectParm.bBuffTYpe == 1 then 
					--print("ddddddddddddddddddddddddddddddd")
					--Pause()
					Armature:getAnimation():playWithIndex(1)
					
				else
					BaseSceneDB.DelEffectParm(iEffectTag)	
					--Armature:removeFromParentAndCleanup(true)					
					DelArmature(Armature)
				end	
			else
				
				--Armature:removeFromParentAndCleanup(true)
				DelArmature(Armature)
			end
			
		else	
				
			--Armature:removeFromParentAndCleanup(true)
			DelArmature(Armature)
		end
	
	elseif MovementType == MovementEventType.loopComplete then
	
		--//每次循环完检测是不是要删除 给buff用 频率太快还是开计时器吧

	end
end


--//瞬发特效播放目标的被打特效
function PlayEffect_Prompt(iEffectID_hit,iSourcePos,iTargetPos,bUseEffectEx)

	--print("PlayEffect_Prompt" .. iEffectID_hit .."," .. iSourcePos .. "," .. iTargetPos)
	--Pause()
	--//特效在技能事件触发直接播放受攻击的人被打动画 在动画镇里播放被打特效
	--//add by sxin 如果死亡就不调用了
	--if IsDie(iTargetPos) == true then
	
	--	return
	--end

	local pEffectData = EffectData.getDataById( iEffectID_hit);	

	--//添加
	local pArmature = nil
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName")])
	
	pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName")]);	
		
	
	if BaseSceneDB.IsNpc(iTargetPos) == false then
	
		--//翻转特效
		pArmature:setScaleX(-(pArmature:getScaleX()))
	end

	--//取目标角色的位置 
	local pArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)
	
	local pFightTarDataParm = BaseSceneDB.GetPlayFightParm(iTargetPos)	
	
	--print("pEffectDataScale = " .. tonumber(pEffectData[EffectData.getIndexByField("Scale")]))
	pArmature:setScale(tonumber(pEffectData[EffectData.getIndexByField("Scale")]))
	
	
	
	pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder")])+pArmatureTar:getZOrder())	
	
	pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_0")]))
	
	--//设置所属数据
	local pArmatureSour = BaseSceneDB.GetPlayArmature(iSourcePos) 
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos) 	
	
	-- add by sxin 增加绑定特效参数	
	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos
	pEffectParm.m_State	= pFightDataParm.m_State
	pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
	pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
	pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
		
	pArmature:setTag(pEffectParm.m_tagid)	
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

	pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
	
	
	local pbindbone = tonumber(pEffectData[EffectData.getIndexByField("bindbone")])	
	local pbindArmature = tonumber(pEffectData[EffectData.getIndexByField("bindAnimation")])	
	
	if  pbindArmature > 0 then 
			
		if pbindbone > 0  then
			
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( 0 , pFightTarDataParm.m_Mode_Height+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, pFightTarDataParm.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmature:setPosition(ccp( 0 , 0))		
			
		end
		
		if tonumber(pEffectData[EffectData.getIndexByField("effectzorder")]) <0 then
		
			--pArmatureTar:addChild(pArmature,0)
			CreatbindBoneToEffect(pArmature,pArmatureTar,pEffectData[EffectData.getIndexByField("bonename")],0)
			
		else
					
			--pArmatureTar:addChild(pArmature,Play_Effect_Z)	
			CreatbindBoneToEffect(pArmature,pArmatureTar,pEffectData[EffectData.getIndexByField("bonename")],Play_Effect_Z)			
		end
			
		--//翻转特效
		--pArmature:setScaleX(-(pArmature:getScaleX()))
		
	else
	
			--//是否绑定骨骼 计算旋转		 
		if pbindbone > 0  then
			
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height+10))	
			else
				pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY()))		
			
		end
		
				
		if tonumber(pEffectData[EffectData.getIndexByField("effectzorder")]) <0 then
			m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
		else
			m_pBaseScene:Get_Layer_Root():addChild(pArmature)
		end		
					
	
	end
		
	
	
	---add by sxin 扩展被打特效显示多个组合
	if bUseEffectEx == true then
	
		if pEffectData[EffectData.getIndexByField("fileName1")] ~= nil then
			
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName1")])
		
			pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName1")]);	
				
			
			if BaseSceneDB.IsNpc(iTargetPos) == false then
			
				--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end

					
			pArmature:setPosition(ccp(pArmatureTar:getPositionX(), pArmatureTar:getPositionY()))

			
			pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder1")])+pArmatureTar:getZOrder())
			
			pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_1")]))
			
			pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
			local pbindbone1 = tonumber(pEffectData[EffectData.getIndexByField("bindbone1")])	
			
			if  pbindArmature > 0 then 
			
				if pbindbone1 > 0  then
					
					if pbindbone1 == 6 then --头顶
						pArmature:setPosition(ccp( 0 , pFightTarDataParm.m_Mode_Height+Off_Effect_head))	
					else
						pArmature:setPosition(ccp( 0, pFightTarDataParm.m_Mode_Height*0.5))	
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
				--pArmature:setScaleX(-(pArmature:getScaleX()))
				
			else
			
					--//是否绑定骨骼 计算旋转		 
				if pbindbone1 > 0  then
					
					if pbindbone1 == 6 then --头顶
						pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height+10))	
					else
						pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height*0.5))	
					end
					
					
				else
					
					pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY()))		
					
				end
		
				
				if tonumber(pEffectData[EffectData.getIndexByField("effectzorder1")]) <0 then
					m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
				else
					m_pBaseScene:Get_Layer_Root():addChild(pArmature)
				end		
						
		
			end			
		end
		
		if pEffectData[EffectData.getIndexByField("fileName2")] ~= nil then
			
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName2")])
		
			pArmature = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName2")]);	
				
			
			if BaseSceneDB.IsNpc(iTargetPos) == false then
			
				--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end

					
			pArmature:setPosition(ccp(pArmatureTar:getPositionX(), pArmatureTar:getPositionY()))	

			pArmature:setZOrder(tonumber(pEffectData[EffectData.getIndexByField("effectzorder2")])+pArmatureTar:getZOrder())
			
			pArmature:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_2")]))
			
			pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
			local pbindbone2 = tonumber(pEffectData[EffectData.getIndexByField("bindbone2")])	
			
			if  pbindArmature > 0 then 
			
				if pbindbone2 > 0  then
					
					if pbindbone2 == 6 then --头顶
						pArmature:setPosition(ccp( 0 , pFightTarDataParm.m_Mode_Height+Off_Effect_head))	
					else
						pArmature:setPosition(ccp( 0, pFightTarDataParm.m_Mode_Height*0.5))	
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
				--pArmature:setScaleX(-(pArmature:getScaleX()))
				
			else
			
					--//是否绑定骨骼 计算旋转		 
				if pbindbone2 > 0  then
					
					if pbindbone2 == 6 then --头顶
						pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height+10))	
					else
						pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height*0.5))	
					end
					
					
				else
					
					pArmature:setPosition(ccp( pArmatureTar:getPositionX() , pArmatureTar:getPositionY()))		
					
				end
		
				
				if tonumber(pEffectData[EffectData.getIndexByField("effectzorder2")]) <0 then
					m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
				else
					m_pBaseScene:Get_Layer_Root():addChild(pArmature)
				end		
						
		
			end				
		end
	end
	

	--//播放伤害特效
	--PlayDamage(iSourcePos,iTargetPos,pFightDataParm.m_State,BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage),pFightDataParm.m_bUseingEngineSkill )
	
	PlayDamage(iSourcePos,iTargetPos,BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_DamageState),BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage),pFightDataParm.m_bUseingEngineSkill )
	
end

--角度转弧度
function degrees_to_radians( angle )
	return angle * 0.01745329252
end

--弧度转角度
function radians_to_degrees( angle )
	return angle * 57.29577951
end


function GetPointAngle( pSour,  pTar)

	local  vectorTaget = ccpSub( pTar, pSour )
	
	if vectorTaget == nil then
		return 0
	end
	
	--local angle =  radians_to_degrees(vectorTaget:getAngle( ccp( 1, 0 ) ))
	
	local angle =  radians_to_degrees(ccpAngleSigned(vectorTaget,ccp( 1, 0 )))
	
	return angle
end


--//伤害回调
function OnDamage(pNode)

		
	local iEffecttagid = (pNode:getTag())

	local pEffectParm = BaseSceneDB.GetEffectParm(iEffecttagid)
	
	if pEffectParm ~= nil then
	
		if pEffectParm.bMusHit == true then
			PlayDamageList(pEffectParm)
		else
			--PlayDamage(pEffectParm.m_iSource,pEffectParm.m_iTar,pEffectParm.m_State,pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)
			PlayDamage(pEffectParm.m_iSource,pEffectParm.m_iTar,pEffectParm.m_iDamageState[1],pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)		
		end		
		
	else
		print("OnDamage:pEffectParm == nil ")
		--Pause()
	end	

end

--子弹dot类型
function Play_Bullet_Buff(pEffectParmData,iTarPos,iDamage)

	local iEffectID_hit = pEffectParmData.m_EffectID
	local iSourcePos	= pEffectParmData.m_iSource
	local iTargetPos	= iTarPos

	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbuffData = EffectData.getDataById( pEffectParmData.iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
	
	
		
	--//添加-----------扩展没有buff的特效只是sharder的影响
	
	if pEffectbuffData[EffectData.getIndexByField("fileName")] == nil then 
	
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pParArmatureTar,iSharder)
		end				
		
		local pEffectParm = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm.m_iSource = iSourcePos
		pEffectParm.m_iTar    = iTargetPos
		pEffectParm.m_State	= pEffectParmData.m_State
		pEffectParm.m_EffectID = iEffectID_hit
		pEffectParm.m_EffectType = pEffectParmData.m_iSkillType
		pEffectParm.m_EngineSkill = pEffectParmData.m_bUseingEngineSkill
		pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pEffectParmData.HitPos,iTargetPos,pEffectParmData.m_Damage)
		pEffectParm.HitPos = copyTab(pEffectParmData.HitPos)				
		pEffectParm.bufftimes = pEffectParmData.bufftimes
		pEffectParm.bufftimecd = pEffectParmData.bufftimecd	
		pEffectParm.bBuffTYpe = pEffectParmData.bBuffTYpe
		pEffectParm.iSharder  = iSharder	
		
		
		local nHanderTime	
		local buffitmes = 1
		local bufftime =0
		local function bufftick(dt)		
			if m_UseingEngineSkillStopTimes > 0 then 
				return
			end 
			if buffitmes > pEffectParm.bufftimes or BaseSceneDB.IsDie(pEffectParm.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true then
						
				if nHanderTime ~= nil then
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
					nHanderTime = nil
					pEffectParm.HanderTime = nil					
				end	
				
				if iSharder > 0 then			
					CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)	
					pEffectParm.iSharder = 0					
				end	

				DelEffectParm(pEffectParm.m_tagid)	
				
			else
				
				bufftime = bufftime+G_Fight_BUff_Tick_Time
				if bufftime >= pEffectParm.bufftimecd then
					bufftime = 0
					buffitmes = buffitmes + 1	
						
					PlayDamage(pEffectParm.m_iSource,pEffectParm.m_iTar,pEffectParm.m_State,pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)
				end				
									
			end		
			
		end			
			
		nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)		
				
		pEffectParm.HanderTime = nHanderTime
		pEffectParm.pArmature = nil
	
	else
	
		local pArmature = nil
	
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
		pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])			
				
		pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
		
		if  pArmature:getAnimation():getMovementCount() > 1 then
			
			--先出生 再循环
			pArmature:getAnimation():playWithIndex(0)		
				
			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)

			
			
		else
			pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))
		end
		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
		
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pParArmatureTar,iSharder)
		end
				

		local pEffectParm = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm.m_iSource = iSourcePos
		pEffectParm.m_iTar    = iTargetPos
		pEffectParm.m_State	= pEffectParmData.m_State
		pEffectParm.m_EffectID = iEffectID_hit
		pEffectParm.m_EffectType = pEffectParmData.m_iSkillType
		pEffectParm.m_EngineSkill = pEffectParmData.m_bUseingEngineSkill
		pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pEffectParmData.HitPos,iTargetPos,pEffectParmData.m_Damage)
		pEffectParm.HitPos = copyTab(pEffectParmData.HitPos)
		
		
		--增加buff特效得特殊属性
				
		pEffectParm.bufftimes = pEffectParmData.bufftimes
		pEffectParm.bufftimecd = pEffectParmData.bufftimecd	
		pEffectParm.bBuffTYpe = pEffectParmData.bBuffTYpe
		pEffectParm.iSharder  = iSharder
			
		local nHanderTime	
		local buffitmes = 1
		local bufftime =0
		local function bufftick(dt)		
			
			if m_UseingEngineSkillStopTimes > 0 then 
				return
			end 
			
			if buffitmes > pEffectParm.bufftimes or BaseSceneDB.IsDie(pEffectParm.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true then
						
				if nHanderTime ~= nil then
					--if pArmature ~= nil then
					--	pArmature:getScheduler():unscheduleScriptEntry(nHanderTime)	
					--else
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
					--end					
					nHanderTime = nil
					pEffectParm.HanderTime = nil
				end	
				
				if pEffectParm.iSharder > 0 then			
					CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)
					pEffectParm.iSharder = 0 
				end
				
				BaseSceneDB.DelEffectParm(pEffectParm.m_tagid)	
				--pArmature:removeFromParentAndCleanup(true)
				DelArmature(pArmature)
			else
				
				bufftime = bufftime+G_Fight_BUff_Tick_Time
				if bufftime >= pEffectParm.bufftimecd then
					bufftime = 0
					buffitmes = buffitmes + 1	

					PlayDamage(pEffectParm.m_iSource,pEffectParm.m_iTar,pEffectParm.m_State,pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)
				end				
				
			end		
			
		end	
		
			
		nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)	
		pEffectParm.HanderTime = nHanderTime
		pEffectParm.pArmature = pArmature
			
		pArmature:setTag(pEffectParm.m_tagid)	
		
			--//是否绑定骨骼 计算旋转
		if  pbindArmature > 0 then 
			
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( 0 , pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
				else
					pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( 0 , 0))		
				
			end
			
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				--pParArmatureTar:addChild(pArmature,0)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)		
			else
				--pParArmatureTar:addChild(pArmature,Play_Effect_Z)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)	
			end		
			--//翻转特效
			--pArmature:setScaleX(-(pArmature:getScaleX()))
		else
		
				--//是否绑定骨骼 计算旋转		 
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+10))	
				else
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
				
			end
			
					
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmature)
			end		
						
		
		end
	
	end
	
	
	
	---创建 被打特效
	
	local pEffectHitData = EffectData.getDataById( iEffectID_hit);	

	--//添加
	local pArmatureHit = nil
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectHitData[EffectData.getIndexByField("fileName")])
	
	pArmatureHit = CCArmature:create(pEffectHitData[EffectData.getIndexByField("EffectName")]);	
		
	
	if BaseSceneDB.IsNpc(iTargetPos) == false then
	
		--//翻转特效
		pArmatureHit:setScaleX(-(pArmatureHit:getScaleX()))
	end

	pArmatureHit:setScale(tonumber(pEffectHitData[EffectData.getIndexByField("Scale")]))
		
	
	
	pArmatureHit:setZOrder(tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
	pArmatureHit:getAnimation():playWithIndex( tonumber(pEffectHitData[EffectData.getIndexByField("AnimationID_0")]))
	
		
	-- add by sxin 增加绑定特效参数		
	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos
	pEffectParm.m_State	  = nil
	pEffectParm.m_iDamageState	= copyTab(pEffectParmData.m_iDamageState)
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pEffectParmData.m_iSkillType
	pEffectParm.m_EngineSkill = pEffectParmData.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pEffectParmData.HitPos,iTargetPos,pEffectParmData.m_Damage)
	pEffectParm.HitPos = copyTab(pEffectParmData.HitPos)
		
	pArmatureHit:setTag(pEffectParm.m_tagid)	
	
	pArmatureHit:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

	pArmatureHit:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
	
		
	local pbindboneHit = tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")])	
	local pbindArmatureHit = tonumber(pEffectHitData[EffectData.getIndexByField("bindAnimation")])
	
	
	if  pbindArmatureHit > 0 then 
			
		if pbindboneHit > 0  then
			
			if pbindboneHit == 6 then --头顶
				pArmatureHit:setPosition(ccp( 0 , pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
			else
				pArmatureHit:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmatureHit:setPosition(ccp( 0 , 0))		
			
		end
		
		if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
			--pParArmatureTar:addChild(pArmatureHit,0)
			CreatbindBoneToEffect(pArmatureHit,pParArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],0)	
		else
			--pParArmatureTar:addChild(pArmatureHit,Play_Effect_Z)
			CreatbindBoneToEffect(pArmatureHit,pParArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],Play_Effect_Z)	
		end		
		--//翻转特效
		--pArmatureHit:setScaleX(-(pArmatureHit:getScaleX()))
	else
	
			--//是否绑定骨骼 计算旋转		 
		if pbindboneHit > 0  then
			
			if pbindboneHit == 6 then --头顶
				pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+10))	
			else
				pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
			
		end
		
				
		if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
			m_pBaseScene:Get_Layer_Root():addChild(pArmatureHit,0)
		else
			m_pBaseScene:Get_Layer_Root():addChild(pArmatureHit)
		end		
					
	
	end
	
	
end

--子弹类的状态限制
function Play_Bullet_State(pEffectParm,iTarPos,iDamage)

				
	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(pEffectParm.m_iSource)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTarPos)

	local pEffectbuffData = EffectData.getDataById( pEffectParm.iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	
	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTarPos)	

	--------判断技能状态		

	if pEffectParm.m_State > DamageState.E_DamageState_None  and  pFightDataParmTar.m_buff_state ~= pEffectParm.m_State then 
				
		--目标是击飞状态	
		if pFightDataParmTar.m_buff_state == DamageState.E_DamageState_jifei then 
		
			pParArmatureTar:stopActionByTag(Fight_jifeiMoveTagID)
			
		end
		
		
		---根据状态暂停动作
		if  pEffectParm.m_State == DamageState.E_DamageState_bingdong then 		
			
				pFightDataParmTar.m_buff_state = pEffectParm.m_State	
				
				--技能被打断
				--防止死亡动作的时候打
				if pParArmatureTar:getAnimation():getCurrentMovementID() ~= GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_die) then			
					pParArmatureTar:getAnimation():play(GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_stand))			
				end	
					
				
				pauseSchedulerAndActions(pParArmatureTar)	
		
		elseif pEffectParm.m_State == DamageState.E_DamageState_xuanyun then 
			
				pFightDataParmTar.m_buff_state = pEffectParm.m_State
				
				--防止自动技能被打断
				if pParArmatureTar:getAnimation():getCurrentMovementID() == GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_manual_skill) then
					
					--判断手动技能效果解除				
					if pFightDataParmTar.m_bUseingEngineSkill == true then
						--Pause()
						pFightDataParmTar.m_bUseingEngineSkill = false
						ResumeAllAnimation(pParArmatureTar)
						ResumeAllEffect()
					
					end
					
				end
			
				if pParArmatureTar:getAnimation():getCurrentMovementID() ~= GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_die) then
										
					resumeSchedulerAndActions(pParArmatureTar)						
					pParArmatureTar:getAnimation():play(GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_vertigo))			
				end					
			
		end		
	
		
		local pArmature = nil
	
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
		pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])
			
				
		pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
		
		
		
		if  pArmature:getAnimation():getMovementCount() > 1 then
			
			--先出生 再循环
			pArmature:getAnimation():playWithIndex(0)				
			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)			
			
		else			
			pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))
		end
				
		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
		
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pParArmatureTar,iSharder)
		end
		
		--创建限制特效				

		local pEffectParmbuff = BaseSceneDB.CreateEffectParm()	
		
		pEffectParmbuff.m_iSource 	= pEffectParm.m_iSource
		pEffectParmbuff.m_iTar    	= iTarPos
		pEffectParmbuff.m_State		= pEffectParm.m_State
		pEffectParmbuff.m_EffectID 	= pEffectParm.m_EffectID
		pEffectParmbuff.m_EffectType = pEffectParm.m_iSkillType
		pEffectParmbuff.m_EngineSkill = pEffectParm.m_bUseingEngineSkill
		pEffectParmbuff.m_iDamage 	= BaseSceneDB.GetHurtDamagebyHitPos(pEffectParm.HitPos,iTarPos,pEffectParm.m_Damage)
		pEffectParmbuff.HitPos 		= copyTab(pEffectParm.HitPos)
		
		
		--增加buff特效得特殊属性
				
		pEffectParmbuff.bufftimes = pEffectParm.bufftimes
		pEffectParmbuff.bufftimecd = pEffectParm.bufftimecd	
		pEffectParmbuff.bBuffTYpe = pEffectParm.bBuffTYpe
		pEffectParmbuff.iSharder  = iSharder
		
		-----修改Buff方法 统一1秒回调 这样增加Buff的判断机制
		local nHanderTime	
		local buffitmes = 1
		local bufftime =0
		
		local function bufftick_State(dt)		
			--print("buffitmes = " .. buffitmes)
			
			if m_UseingEngineSkillStopTimes > 0 then 
				return
			end 
				
			if pFightDataParmTar.m_buff_state_reset ~= nil and pFightDataParmTar.m_buff_state_reset == 1 then
				
				buffitmes = 1
				bufftime = 0
				
				pFightDataParmTar.m_buff_state_reset = nil
			end
			
			if buffitmes > pEffectParmbuff.bufftimes or BaseSceneDB.IsDie(pEffectParmbuff.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true 
				or (pFightDataParmTar.m_buff_state ~= nil and pEffectParmbuff.m_State ~= pFightDataParmTar.m_buff_state )then
					
				--print("buffitmes > pEffectParmbuff.bufftimes = " .. buffitmes)
				
				if nHanderTime ~= nil then
					
					--if pArmature ~= nil then
					--	pArmature:getScheduler():unscheduleScriptEntry(nHanderTime)	
					--else
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
					--end		
					nHanderTime = nil
					pEffectParmbuff.HanderTime = nil
				end	
				
				if pEffectParmbuff.iSharder > 0 then			
					CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)
					pEffectParmbuff.iSharder = 0 
				end
				
				
				if pEffectParmbuff.m_State > 0 then		

					if pEffectParmbuff.m_State	~= pFightDataParmTar.m_buff_state then 
					
						--删除特效的时候不影响目标的状态
						pEffectParmbuff.m_State = nil
						
					
					else
						
						if  pEffectParmbuff.m_State == DamageState.E_DamageState_bingdong then 
						
							------解锁暂停需要看是不是在暂停状态--
							if m_UseingEngineSkillStopTimes <= 0 then 
								resumeSchedulerAndActions(pParArmatureTar)	
							end	
							
							pFightDataParmTar.m_buff_state = nil			
						
							
						elseif pEffectParmbuff.m_State == DamageState.E_DamageState_xuanyun then 
							
							if pParArmatureTar:getAnimation():getCurrentMovementID() == GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_vertigo) then
							
								pParArmatureTar:getAnimation():play(GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_stand))	
								
							end	
								
							pFightDataParmTar.m_buff_state = nil
							
						
						end					
						
					
					end
									
					pEffectParmbuff.m_State = E_DamageState_None
				end					
				
				BaseSceneDB.DelEffectParm(pEffectParmbuff.m_tagid)					
				--pArmature:removeFromParentAndCleanup(true)
				DelArmature(pArmature)
			
			else	
				bufftime = bufftime+G_Fight_BUff_Tick_Time
				if bufftime >= pEffectParmbuff.bufftimecd then
					bufftime = 0
					buffitmes = buffitmes + 1					
				end
									
			end		
			
		end		
		
		nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(bufftick_State, G_Fight_BUff_Tick_Time, false)
		pEffectParmbuff.HanderTime = nHanderTime
		pEffectParmbuff.pArmature = pArmature
			
		pArmature:setTag(pEffectParmbuff.m_tagid)
							
		
		--//是否绑定骨骼 计算旋转
		if  pbindArmature > 0 then 
			
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( 0 , pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
				else
					pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( 0 , 0))		
				
			end
			
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				--pParArmatureTar:addChild(pArmature,0)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)
			else
				--pParArmatureTar:addChild(pArmature,Play_Effect_Z)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
			end	
				
			--//翻转特效
			--pArmature:setScaleX(-(pArmature:getScaleX()))
			
		else
		
				--//是否绑定骨骼 计算旋转		 
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+10))	
				else
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
				
			end
			
					
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmature)
			end		
						
		
		end
	
	else
	
		--print("状态相同")
		--print(pEffectParm.m_State)
		--print(pFightDataParmTar.m_buff_state)
		
		if pEffectParm.m_State > DamageState.E_DamageState_None and pFightDataParmTar.m_buff_state == pEffectParm.m_State then 
		
			--print("pEffectParm.m_State > DamageState.E_DamageState_None and pFightDataParmTar.m_buff_state == pEffectParm.m_State")
			pFightDataParmTar.m_buff_state_reset = 1
			
			
		else
			print("！！！状态错误！！！")
			Pause()
			
		end
		
	
	end 
		
				
	--播放伤害	
	--PlayDamage(pEffectParm.m_iSource,iTarPos,pEffectParm.m_State,iDamage,pEffectParm.m_EngineSkill)		
	PlayDamage(pEffectParm.m_iSource,iTarPos,BaseSceneDB.GetHurtDamagebyHitPos(pEffectParm.HitPos,iTarPos,pEffectParm.m_iDamageState),iDamage,pEffectParm.m_EngineSkill)	
	
end


--//子弹类伤害+状态限制回调回调
function OnBulletDamageState(pNode)
	
	local iEffecttagid = (pNode:getTag())

	local pEffectParm = BaseSceneDB.GetEffectParm(iEffecttagid)
	
	if pEffectParm ~= nil then
	
		
		if pEffectParm.ActType == EffectTypeTarg.E_EffectType_OneTarget then
		
			if pEffectParm.m_State == DamageState.E_DamageState_Dot then
			
				Play_Bullet_Buff(pEffectParm,pEffectParm.m_iTar,pEffectParm.m_iDamage)
				
			else
			
				Play_Bullet_State(pEffectParm,pEffectParm.m_iTar,pEffectParm.m_iDamage)
			
			end			
		
		else
		
			local i = 1
			for i=1,MaxTeamPlayCount, 1 do
				
				if pEffectParm.HitPos[i] > 0 then	
					
					if pEffectParm.m_State == DamageState.E_DamageState_Dot then
						Play_Bullet_Buff(pEffectParm,pEffectParm.HitPos[i],pEffectParm.m_Damage[i])
					else
						--查限制第一个人！！！
						Play_Bullet_State(pEffectParm,pEffectParm.HitPos[i],pEffectParm.m_Damage[i])
					end
									
				end
			
			end		
	
		end
		
	else
		print("OnDamage:pEffectParm == nil ")
		--Pause()
	end	

end

--//子弹特效到达回调播放被打特效(先不支持动画绑定)
function OnBulletEffectArrive(pNode)

	local pArmature = tolua.cast(pNode, "CCArmature")
	
	local iEffecttagid = (pArmature:getTag())

	local pEffectParm = BaseSceneDB.GetEffectParm(iEffecttagid)
	
	if pEffectParm == nil then
		print("iEffecttagid not find iEffecttagid=" .. iEffecttagid)
		return
	end

--	//创建被打特效
	--StartScene.FileLog_traceback_Msg( pEffectParm.m_EffectID)
	--FileStrprint("m_EffectID",pEffectParm.m_EffectID)
	local pEffectHitData = EffectData.getDataById( pEffectParm.m_EffectID)
	
	if pEffectHitData == nil then
		print("EffectID not find EffectID=" .. pEffectParm.m_EffectID)
		return
	end
	
	--//添加	
	local pHitArmature = nil
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectHitData[EffectData.getIndexByField("fileName")])
	pHitArmature = CCArmature:create(pEffectHitData[EffectData.getIndexByField("EffectName")])	

	--//取当前角色的位置	
		
	local pArmatureSour = BaseSceneDB.GetPlayArmature(pEffectParm.m_iSource)	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(pEffectParm.m_iSource)

	local pArmatureTar = BaseSceneDB.GetPlayArmature(pEffectParm.m_iTar)
	local pFightTarDataParm = BaseSceneDB.GetPlayFightParm(pEffectParm.m_iTar)

	pHitArmature:setScale(tonumber(pEffectHitData[EffectData.getIndexByField("Scale")]))
	
	
	
	pHitArmature:setZOrder(tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")])+pArmatureTar:getZOrder())

	pHitArmature:getAnimation():playWithIndex(tonumber(pEffectHitData[EffectData.getIndexByField("AnimationID_0")]))
	
	pHitArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

	pHitArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
	
		
	local pbindArmature = tonumber(pEffectHitData[EffectData.getIndexByField("bindAnimation")])
	
	if pbindArmature > 0 then 
	
		--在身上还是脚底
		if tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")]) >0 then
		
			pHitArmature:setPosition(ccp(0, pFightTarDataParm.m_Mode_Height*0.5))
			
		else
			pHitArmature:setPosition(ccp(0,0))
		end	
	
		if pEffectParm.m_EngineSkill == true then
	
			CreatbindBoneToEffect(pHitArmature,pArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
		
		else
			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
				--m_pBaseScene:Get_Layer_Root():addChild(pHitArmature,0)
				pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height*0.5))
				CreatbindBoneToEffect(pHitArmature,pArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],0)
				
			else
				--m_pBaseScene:Get_Layer_Root():addChild(pHitArmature)		
				CreatbindBoneToEffect(pHitArmature,pArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
				
			end		
		end	
	else
	
		--在身上还是脚底
		if tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")]) >0 then
		
			pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height*0.5))
			
		else
			pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY()))
		end
	
		if pEffectParm.m_EngineSkill == true then
	
			m_pBaseScene:Get_Layer_Root():addChild(pHitArmature,100)
		
		else
			
			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pHitArmature,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pHitArmature)
				--m_DamageLayer:addChild(pHitArmature)
			end			
			
		end	
		
	end

	
	
	------扩展多个组合
	if pEffectHitData[EffectData.getIndexByField("fileName1")] ~= nil then
			
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectHitData[EffectData.getIndexByField("fileName1")])
	
		pHitArmature = CCArmature:create(pEffectHitData[EffectData.getIndexByField("EffectName1")]);	
			
		
		if BaseSceneDB.IsNpc(pEffectParm.m_iTar) == false then
		
			--//翻转特效
			pHitArmature:setScaleX(-(pHitArmature:getScaleX()))
		end

				
		pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(), pArmatureTar:getPositionY()))

		
		pHitArmature:setZOrder(tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder1")])+pArmatureTar:getZOrder())
		
		pHitArmature:getAnimation():playWithIndex( tonumber(pEffectHitData[EffectData.getIndexByField("AnimationID_1")]))
		
		pHitArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

		pHitArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
		
		
		if pbindArmature > 0 then 
		
			--在身上还是脚底
			if tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")]) >0 then
			
				pHitArmature:setPosition(ccp(0, pFightTarDataParm.m_Mode_Height*0.5))
				
			else
				pHitArmature:setPosition(ccp(0,0))
			end	
		
			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
				--m_pBaseScene:Get_Layer_Root():addChild(pHitArmature,0)
				CreatbindBoneToEffect(pHitArmature,pArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],0)
			else
				--m_pBaseScene:Get_Layer_Root():addChild(pHitArmature)		
				CreatbindBoneToEffect(pHitArmature,pArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
			end		
				
		else
		
			--在身上还是脚底
			if tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")]) >0 then
			
				pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height*0.5))
				
			else
				pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY()))
			end

			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder1")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pHitArmature,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pHitArmature)
				--m_DamageLayer:addChild(pHitArmature)
			end			
		end
	end
	
	if pEffectHitData[EffectData.getIndexByField("fileName2")] ~= nil then
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectHitData[EffectData.getIndexByField("fileName2")])
	
		pHitArmature = CCArmature:create(pEffectHitData[EffectData.getIndexByField("EffectName2")]);	
			
		
		if BaseSceneDB.IsNpc(pEffectParm.m_iTar) == false then
		
			--//翻转特效
			pHitArmature:setScaleX(-(pHitArmature:getScaleX()))
		end

				
		pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(), pArmatureTar:getPositionY()))		
		
		pHitArmature:setZOrder(tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder2")])+pArmatureTar:getZOrder())
		
		pHitArmature:getAnimation():playWithIndex( tonumber(pEffectHitData[EffectData.getIndexByField("AnimationID_2")]))
		
		pHitArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

		pHitArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
		
		if pbindArmature > 0 then 
		
			--在身上还是脚底
			if tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")]) >0 then
			
				pHitArmature:setPosition(ccp(0, pFightTarDataParm.m_Mode_Height*0.5))
				
			else
				pHitArmature:setPosition(ccp(0,0))
			end	
		
			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
				--m_pBaseScene:Get_Layer_Root():addChild(pHitArmature,0)
				CreatbindBoneToEffect(pHitArmature,pArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],0)
			else
				--m_pBaseScene:Get_Layer_Root():addChild(pHitArmature)		
				CreatbindBoneToEffect(pHitArmature,pArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
			end		
				
		else
		
			--在身上还是脚底
			if tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")]) >0 then
			
				pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY() + pFightTarDataParm.m_Mode_Height*0.5))
				
			else
				pHitArmature:setPosition(ccp(pArmatureTar:getPositionX(),pArmatureTar:getPositionY()))
			end
			
			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder2")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pHitArmature,0)
			else
			
				m_pBaseScene:Get_Layer_Root():addChild(pHitArmature)
			--	m_DamageLayer:addChild(pHitArmature)
			end		
		end
			
		
	end
end

function OnDeleteBulletEffect(pNode)
	
	--//删除子弹特效
	local pArmature = tolua.cast(pNode, "CCArmature")
	
	local iEffecttagid = (pArmature:getTag())

	local pEffectParm = BaseSceneDB.GetEffectParm(iEffecttagid)
	if pEffectParm ~= nil then
		pEffectParm.m_State = nil
		if pEffectParm.HanderTime ~= nil then
			pArmature:getScheduler():unscheduleScriptEntry(pEffectParm.HanderTime)
			
		end
		BaseSceneDB.DelEffectParm(iEffecttagid)	
	end
		
	
	
	DelArmature(pArmature)
	--自己删除
	pArmature:release()
	
end

--//子弹特效到达后播放特效删除子弹
function OnEffectArrive(pNode)	
	
	OnBulletEffectArrive(pNode)
	OnDeleteBulletEffect(pNode)
	
end



function Create_Bullet_Armature(iEffectID_bullet, iSourcePos, iTargetPos, pBone ,pcallFunc)

	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbulletData = EffectData.getDataById( iEffectID_bullet)

	local pbindbone = tonumber(pEffectbulletData[EffectData.getIndexByField("bindbone")])
	
	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)

	local pMoveTo = nil	
	
	--//添加
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
			local targetPos = ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5)

			local angle = GetPointAngle(bulletPos,targetPos)
			
			--增加 动画翻转不是完全靠旋转
			if BaseSceneDB.IsNpc(iTargetPos) == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end
			
			if pArmature:getScaleX() < 0 then
				print(angle)
				angle = angle + 180
				
				print(angle)
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
			
			pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))
	

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
			
			if BaseSceneDB.IsNpc(iTargetPos) == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
			end
		
			
		elseif pbindbone == 3 then --骨骼位置和目标点直线类型 初始位置在屏幕外边
		
			--计算屏幕外坐标
			local rect = pArmature:boundingBox()	
			
			local pSceneX = (BaseSceneDB.GetCurTimes()-1)*DefineWidth - rect.size.width*0.5
			
			
			if BaseSceneDB.IsNpc(iTargetPos) == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
				
				pSceneX = (BaseSceneDB.GetCurTimes())*DefineWidth + rect.size.width*0.5
				
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
			
			local pSceneX = (BaseSceneDB.GetCurTimes())*DefineWidth + rect.size.width*0.5
			
			
			if BaseSceneDB.IsNpc(iTargetPos) == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
				
				pSceneX = (BaseSceneDB.GetCurTimes()-1)*DefineWidth - rect.size.width*0.5
				
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
			
			local pSceneStarX = (BaseSceneDB.GetCurTimes()-1)*DefineWidth - rect.size.width*0.5
			
			local pSceneEndX = (BaseSceneDB.GetCurTimes())*DefineWidth + rect.size.width*0.5
			
			
			if BaseSceneDB.IsNpc(iTargetPos) == false then		
			--//翻转特效
				pArmature:setScaleX(-(pArmature:getScaleX()))
				
				pSceneStarX = (BaseSceneDB.GetCurTimes())*DefineWidth + rect.size.width*0.5
				pSceneEndX = (BaseSceneDB.GetCurTimes()-1)*DefineWidth - rect.size.width*0.5
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
		if BaseSceneDB.IsNpc(iTargetPos) == false then		
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
	
	--//damage
	local pcallFuncDamage = CCCallFuncN:create(pcallFunc)	
	
	local arr = CCArray:create()
			arr:addObject(pMoveTo)
			arr:addObject(pcallFuncDamage)
			arr:addObject(pcallFuncEffectArrive)				
	
	local pSequence  = CCSequence:create(arr)	
	
	pArmature:runAction(pSequence)
	
	--add by sxin 子弹类的特殊处理下	
	pArmature:retain()
	
	return pArmature
	
end

--创建顺序伤害子弹特效 只能是直线

function Create_Bullet_Sequence_Armature(iEffectID_bullet, iSourcePos, TargetPosList, pBone ,pcallFunc)



	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pEffectbulletData = EffectData.getDataById( iEffectID_bullet)

	local pbindbone = tonumber(pEffectbulletData[EffectData.getIndexByField("bindbone")])
	
	local speed = tonumber(pEffectbulletData[EffectData.getIndexByField("speed")])
		
	--//添加
	local pArmature = nil	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbulletData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbulletData[EffectData.getIndexByField("EffectName")])
	
	pArmature:getAnimation():playWithIndex(tonumber(pEffectbulletData[EffectData.getIndexByField("AnimationID_0")]))
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	
	
	local iTargetPosList = {}
	local iIndex = 1
	local function OnMoveToNext(pNode)
					
		iIndex = iIndex +1				
		local iNextPos = iTargetPosList[iIndex]
		if iNextPos ~= nil then 
			
			local pArmatureNextTar = BaseSceneDB.GetPlayArmature(iNextPos)
			local pFightDataParmNextTar = BaseSceneDB.GetPlayFightParm(iNextPos)
			--旋转方向
			if pbindbone == 1 then --骨骼旋转
				
				--pNode:setRotation( 0 )	
				
				local bulletPos = ccp(pNode:getPosition())
				local targetPos = ccp(pArmatureNextTar:getPositionX(),pArmatureNextTar:getPositionY() + pFightDataParmNextTar.m_Mode_Height*0.5)

				local angle = GetPointAngle(bulletPos,targetPos)
				
				--print("OnMoveToNext angle = " .. angle)
				
				--增加 动画翻转不是完全靠旋转
				if BaseSceneDB.IsNpc(iNextPos) == false then		
				--//翻转特效
					pNode:setScaleX(-(pNode:getScaleX()))
				end
				
				if pNode:getScaleX() < 0 then					
					angle = angle + 180				
				end		
				--print("OnMoveToNext angle = " .. angle)
				pNode:setRotation( angle )						
				--Pause()					
			end				
		
			--判断目标和自己谁的zorder高
			if pArmatureNextTar:getZOrder() > pNode:getZOrder() then
				pNode:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pArmatureNextTar:getZOrder())
			else
				pNode:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pNode:getZOrder())
			end
			
			
			local iEffecttagid = (pNode:getTag())

			local pEffectParm = BaseSceneDB.GetEffectParm(iEffecttagid)
			
			if pEffectParm ~= nil then					
			
				pEffectParm.m_iTar    = iNextPos	
				
				if pEffectParm.Damage == nil then
					print(iNextPos)
					Pause()
				end
				
				pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pEffectParm.HitPos,iNextPos,pEffectParm.Damage)										
			else
				print("OnDamage:pEffectParm == nil ")
				--Pause()
			end	
			
		end		
	
	end
	
	
	local pParArmatureTar = nil
	local pFightDataParmTar = nil
	local pMoveTo = nil	
	--子弹动作列表
	local arr = CCArray:create()
	
	local i = 1
	local icount = 0
	for i= 1, MaxTeamPlayCount, 1 do	
		
		local iTargetPos = TargetPosList[i]
		if  iTargetPos ~= -1 then 
			
			pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)
			pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
			
			local fDis = ccpDistance( ccp(pParArmature:getPosition()),ccp(pParArmatureTar:getPosition()))
	
			local fMoveTime = fDis/speed
			
			if pbindbone == 1 then --骨骼旋转			
				pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY()+pFightDataParmTar.m_Mode_Height*0.5))								
			else			
				pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY()))							
			end
					
			
			if icount == 0 then --第一个
			
				--旋转方向
				if pbindbone == 1 then --骨骼旋转
				
					if pParArmature:getScaleX() > 0 then						
						pArmature:setPosition(ccp( pParArmature:getPositionX()+ pBone:nodeToArmatureTransform().tx, pParArmature:getPositionY() + pBone:nodeToArmatureTransform().ty))	
					else					
						pArmature:setPosition(ccp( pParArmature:getPositionX() - pBone:nodeToArmatureTransform().tx, pParArmature:getPositionY() + pBone:nodeToArmatureTransform().ty))	
					end 						
					
					local bulletPos = ccp(pArmature:getPosition())
					local targetPos = ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5)

					local angle = GetPointAngle(bulletPos,targetPos)
					print("第一个" .. angle)
					--增加 动画翻转不是完全靠旋转
					if BaseSceneDB.IsNpc(iTargetPos) == false then		
					--//翻转特效
						pArmature:setScaleX(-(pArmature:getScaleX()))
					end
					
					if pArmature:getScaleX() < 0 then
						print(angle)
						angle = angle + 180
						
						print(angle)
						--Pause()
					end
					
				
					pArmature:setRotation( angle )	
					--Pause()
					fDis = ccpDistance( bulletPos,targetPos)
					--fDis = math.abs( bulletPos.x - targetPos.x)
					
					fMoveTime = fDis/speed
					
					pMoveTo = CCMoveTo:create(fMoveTime,ccp(pParArmatureTar:getPositionX(),pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))
					
				else
					
					if BaseSceneDB.IsNpc(iTargetPos) == false then		
						--//翻转特效
						pArmature:setScaleX(-(pArmature:getScaleX()))
					end
								
				end
				
			
				--判断第一个目标和自己谁的zorder高
				if pParArmatureTar:getZOrder() > pParArmature:getZOrder() then
					pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
				else
					pArmature:setZOrder(tonumber(pEffectbulletData[EffectData.getIndexByField("effectzorder")])+pParArmature:getZOrder())
				end
				
				
				
			end
			
			--//damage
			local pcallFuncDamage = CCCallFuncN:create(pcallFunc)
			local pcallFuncOnBulletEffectArrive = CCCallFuncN:create(OnBulletEffectArrive)
			--转方向	
			local pcallFuncMoveToNext = CCCallFuncN:create(OnMoveToNext)
			
			
			icount = icount + 1
			iTargetPosList[icount] = iTargetPos
			arr:addObject(pMoveTo)
			arr:addObject(pcallFuncOnBulletEffectArrive)	
			arr:addObject(pcallFuncDamage)
			arr:addObject(pcallFuncMoveToNext)			
			
		end		
	
	end			
	
	local pcallFuncEffectArrive = CCCallFuncN:create(OnDeleteBulletEffect)
	
	arr:addObject(pcallFuncEffectArrive)				
	
	local pSequence  = CCSequence:create(arr)	
	
	pArmature:runAction(pSequence)	
	
	--add by sxin 子弹自己删除
	pArmature:retain()
	
	return pArmature
	
end
--


--//子弹类特效
function PlayEffect_Bullet(iEffectID_bullet, iEffectID_hit, iSourcePos, iTargetPos, pBone,bMusHit)

	--//add by sxin 如果死亡就不调用了
	--if IsDie(iTargetPos) == true then
	
	--	return;
	--end

	local pArmature = Create_Bullet_Armature(iEffectID_bullet,iSourcePos, iTargetPos, pBone,OnDamage)
	
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)

	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos
	pEffectParm.m_State	= pFightDataParm.m_State
	pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
	pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
	pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)	
	pEffectParm.bMusHit = bMusHit
		
	pArmature:setTag(pEffectParm.m_tagid)	

	if pFightDataParm.m_bUseingEngineSkill == true  then
	
		m_pBaseScene:Get_Layer_Root():addChild(pArmature,100)
	
	else
		m_pBaseScene:Get_Layer_Root():addChild(pArmature)
		--m_DamageLayer:addChild(pArmature)
	end

end



--抛物线特效子弹 范围攻击*****************************
function PlayEffect_Bullet_parabolic(iEffectID_bullet, iEffectID_hit, iSourcePos, iTargetPos, pBone,bMusHit)

		--//add by sxin 如果死亡就不调用了
	--if IsDie(iTargetPos) == true then
	
	--	return;
	--end

	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbulletData = EffectData.getDataById( iEffectID_bullet)

	local pbindbone = tonumber(pEffectbulletData[EffectData.getIndexByField("bindbone")])	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
	
	
	--//添加
	local pArmature = nil
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbulletData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbulletData[EffectData.getIndexByField("EffectName")])
	
	
	--local fDis = ccpDistance( ccp(pParArmature:getPosition()),ccp(pParArmatureTar:getPosition()))
	
	local fDis = math.floor(math.abs(pParArmature:getPositionX() - pParArmatureTar:getPositionX()))
	local speed = tonumber(pEffectbulletData[EffectData.getIndexByField("speed")])
	local fMoveTime = fDis/speed
	
	local bezierTo1 = nil
	
	--//是否绑定骨骼 计算旋转
	 
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
	
	
	local pcallFuncEffectArrive = CCCallFuncN:create(OnEffectArrive)
	
	--//damage
	local pcallFuncDamage = CCCallFuncN:create(OnDamage)	
	
	local arr = CCArray:create()
			arr:addObject(bezierTo1)
			arr:addObject(pcallFuncDamage)
			arr:addObject(pcallFuncEffectArrive)				
	
	local pSequence  = CCSequence:create(arr)		
	
	
	pArmature:runAction(pSequence)
	--add by sxin 子弹类的特殊处理下	
	pArmature:retain()
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)

	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos
	pEffectParm.m_State	= pFightDataParm.m_State
	pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
	pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
	pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
	pEffectParm.bMusHit = bMusHit
	
	--增加抛物线特效得特殊属性
	--print("增加抛物线特效得特殊属性 pEffectParm.m_tagid = " .. pEffectParm.m_tagid)
	local nHanderTime	
	
	local function tick(dt)
		
		if m_UseingEngineSkillStopTimes > 0 then 
			return
		end 
		
		local bulletPos = ccp(pArmature:getPosition())
		local angle = GetPointAngle(pEffectParm.oldPos,bulletPos) 					
		pArmature:setRotation( angle )
		
		pEffectParm.oldPos = bulletPos
		
	end	
	
	pEffectParm.oldPos = ccp(pArmature:getPosition())		
	nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(tick, 0.01, false)
	pEffectParm.HanderTime = nHanderTime
	
	--------------------------------------------------------------------------------------------
		
	pArmature:setTag(pEffectParm.m_tagid)	

	if pFightDataParm.m_bUseingEngineSkill == true  then
	
	--	m_Layer_Root:addChild(pArmature,100)
		m_pBaseScene:Get_Layer_Root():addChild(pArmature)
	
	else
		m_pBaseScene:Get_Layer_Root():addChild(pArmature)
		--m_DamageLayer:addChild(pArmature)
	end
	
end


-----------buff类特效-------------
function PlayEffect_Prompt_buff(iEffectID_buff, iEffectID_hit, iSourcePos, iTargetPos, pBone)

	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbuffData = EffectData.getDataById( iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)
	
	--//添加-----------扩展没有buff的特效只是sharder的影响
	
	if pEffectbuffData[EffectData.getIndexByField("fileName")] == nil then 
	
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pParArmatureTar,iSharder)
		end				
		
		local pEffectParm = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm.m_iSource = iSourcePos
		pEffectParm.m_iTar    = iTargetPos
		pEffectParm.m_State	= pFightDataParm.m_State
		pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
		pEffectParm.m_EffectID = iEffectID_hit
		pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
		pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
		pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
		pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)				
		pEffectParm.bufftimes = pFightDataParm.bufftimes
		pEffectParm.bufftimecd = pFightDataParm.bufftimecd	
		pEffectParm.bBuffTYpe = pFightDataParm.bBuffTYpe
		pEffectParm.iSharder  = iSharder	
		
		
		local nHanderTime	
		local buffitmes = 1
		local bufftime =0
		local function bufftick(dt)		
			if m_UseingEngineSkillStopTimes > 0 then 
				return
			end 
			if buffitmes > pEffectParm.bufftimes or BaseSceneDB.IsDie(pEffectParm.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true then
						
				if nHanderTime ~= nil then
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
					nHanderTime = nil
					pEffectParm.HanderTime = nil					
				end	
				
				if iSharder > 0 then			
					CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)	
					pEffectParm.iSharder = 0					
				end	

				DelEffectParm(pEffectParm.m_tagid)	
				
			else
				
				bufftime = bufftime+G_Fight_BUff_Tick_Time
				if bufftime >= pEffectParm.bufftimecd then
					bufftime = 0
					buffitmes = buffitmes + 1	
						
					PlayDamage(pEffectParm.m_iSource,pEffectParm.m_iTar,pEffectParm.m_State,pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)
				end				
									
			end		
			
		end			
			
		nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)		
				
		pEffectParm.HanderTime = nHanderTime
		pEffectParm.pArmature = nil
	
	else
	
		local pArmature = nil
	
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
		pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])			
				
		pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
		
		if  pArmature:getAnimation():getMovementCount() > 1 then
			
			--先出生 再循环
			pArmature:getAnimation():playWithIndex(0)		
				
			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)

			
			
		else
			pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))
		end
		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
		
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pParArmatureTar,iSharder)
		end
				

		local pEffectParm = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm.m_iSource = iSourcePos
		pEffectParm.m_iTar    = iTargetPos
		pEffectParm.m_State	= pFightDataParm.m_State
		pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
		pEffectParm.m_EffectID = iEffectID_hit
		pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
		pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
		pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
		pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
		
		
		--增加buff特效得特殊属性
				
		pEffectParm.bufftimes = pFightDataParm.bufftimes
		pEffectParm.bufftimecd = pFightDataParm.bufftimecd	
		pEffectParm.bBuffTYpe = pFightDataParm.bBuffTYpe
		pEffectParm.iSharder  = iSharder
			
		local nHanderTime	
		local buffitmes = 1
		local bufftime =0
		local function bufftick(dt)		
			
			if m_UseingEngineSkillStopTimes > 0 then 
				return
			end 
			
			if buffitmes > pEffectParm.bufftimes or BaseSceneDB.IsDie(pEffectParm.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true then
						
				if nHanderTime ~= nil then
					--if pArmature ~= nil then
					--	pArmature:getScheduler():unscheduleScriptEntry(nHanderTime)	
					--else
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
					--end		
					nHanderTime = nil					
					pEffectParm.HanderTime = nil
				end	
				
				if pEffectParm.iSharder > 0 then			
					CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)
					pEffectParm.iSharder = 0 
				end
				
				BaseSceneDB.DelEffectParm(pEffectParm.m_tagid)	
				--pArmature:removeFromParentAndCleanup(true)
				DelArmature(pArmature)
			else
				
				bufftime = bufftime+G_Fight_BUff_Tick_Time
				if bufftime >= pEffectParm.bufftimecd then
					bufftime = 0
					buffitmes = buffitmes + 1	

					PlayDamage(pEffectParm.m_iSource,pEffectParm.m_iTar,pEffectParm.m_State,pEffectParm.m_iDamage,pEffectParm.m_EngineSkill)
				end				
				
			end		
			
		end	
		
			
		nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)	
		pEffectParm.HanderTime = nHanderTime
		pEffectParm.pArmature = pArmature
			
		pArmature:setTag(pEffectParm.m_tagid)	
		
			--//是否绑定骨骼 计算旋转
		if  pbindArmature > 0 then 
			
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( 0 , pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
				else
					pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( 0 , 0))		
				
			end
			
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				--pParArmatureTar:addChild(pArmature,0)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)
			else
				--pParArmatureTar:addChild(pArmature,Play_Effect_Z)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
			end		
			--//翻转特效
			--pArmature:setScaleX(-(pArmature:getScaleX()))
		else
		
				--//是否绑定骨骼 计算旋转		 
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+10))	
				else
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
				
			end
			
					
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmature)
			end		
						
		
		end
	
	end
	
	
	
	---创建 被打特效
	
	local pEffectHitData = EffectData.getDataById( iEffectID_hit);	

	--//添加
	local pArmatureHit = nil
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectHitData[EffectData.getIndexByField("fileName")])
	
	pArmatureHit = CCArmature:create(pEffectHitData[EffectData.getIndexByField("EffectName")]);	
		
	
	if BaseSceneDB.IsNpc(iTargetPos) == false then
	
		--//翻转特效
		pArmatureHit:setScaleX(-(pArmatureHit:getScaleX()))
	end

	pArmatureHit:setScale(tonumber(pEffectHitData[EffectData.getIndexByField("Scale")]))
		
	
	
	pArmatureHit:setZOrder(tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
	pArmatureHit:getAnimation():playWithIndex( tonumber(pEffectHitData[EffectData.getIndexByField("AnimationID_0")]))
	
		
	-- add by sxin 增加绑定特效参数		
	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos
	pEffectParm.m_State	  = nil
	pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
	pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
	pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
		
	pArmatureHit:setTag(pEffectParm.m_tagid)	
	
	pArmatureHit:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

	pArmatureHit:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
	
		
	local pbindboneHit = tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")])	
	local pbindArmatureHit = tonumber(pEffectHitData[EffectData.getIndexByField("bindAnimation")])
	
	
	if  pbindArmatureHit > 0 then 
			
		if pbindboneHit > 0  then
			
			if pbindboneHit == 6 then --头顶
				pArmatureHit:setPosition(ccp( 0 , pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
			else
				pArmatureHit:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmatureHit:setPosition(ccp( 0 , 0))		
			
		end
		
		if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
			--pParArmatureTar:addChild(pArmatureHit,0)
			CreatbindBoneToEffect(pArmatureHit,pParArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],0)
		else
			--pParArmatureTar:addChild(pArmatureHit,Play_Effect_Z)
			CreatbindBoneToEffect(pArmatureHit,pParArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
		end		
		--//翻转特效
		--pArmatureHit:setScaleX(-(pArmatureHit:getScaleX()))
	else
	
			--//是否绑定骨骼 计算旋转		 
		if pbindboneHit > 0  then
			
			if pbindboneHit == 6 then --头顶
				pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+10))	
			else
				pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
			
		end
		
				
		if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
			m_pBaseScene:Get_Layer_Root():addChild(pArmatureHit,0)
		else
			m_pBaseScene:Get_Layer_Root():addChild(pArmatureHit)
		end		
					
	
	end
	
end



----------增益-buff单体类特效-------------
function PlayEffect_Prompt_buff_Gain(iEffectID_buff, iEffectID_hit, iSourcePos, iTargetPos, pBone)	

	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbuffData = EffectData.getDataById( iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)
	
			
	local pArmature = nil

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])
		
	
	
	
	pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
	
	pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))	
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	
	--增加sharder效果
	local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
	
	if iSharder > 0 then		
		CCArmatureSharder(pParArmatureTar,iSharder)
	end
	
	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos
	pEffectParm.m_State	= pFightDataParm.m_State
	pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
	pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
	pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
	
	
	--增加buff特效得特殊属性
			
	pEffectParm.bufftimes = pFightDataParm.bufftimes
	pEffectParm.bufftimecd = pFightDataParm.bufftimecd	
	pEffectParm.bBuffTYpe = pFightDataParm.bBuffTYpe
	pEffectParm.iSharder  = iSharder		
	pEffectParm.bBuffGainType  = pFightDataParm.bBuffGainType	
	pEffectParm.bBuffGainVel  = pFightDataParm.bBuffGainVel		
	
	--print("PalyBuffGain_TeamData" .. pEffectParm.bBuffGainVel)
	--Pause() 
	
	BaseSceneDB.PalyBuffGain_TeamData(pEffectParm.m_iTar,pEffectParm.bBuffGainType,pEffectParm.bBuffGainVel,true)
	
	
		--扩展特效类型
	local pArmature1 = nil
	local pEffectParm1 = nil
	local pbindbone1 = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone1")])	
	if pEffectbuffData[EffectData.getIndexByField("fileName1")] ~= nil then
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName1")])
		pArmature1 = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName1")])	
		
		
		pArmature1:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
		
		pArmature1:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_1")]))	
		
		pArmature1:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
						
		pEffectParm1 = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm1.m_iSource = iSourcePos
		pEffectParm1.m_iTar    = iTargetPos
		pEffectParm1.m_State	= pFightDataParm.m_State
		pEffectParm1.m_EffectID = iEffectID_hit
		pEffectParm1.m_EffectType = pFightDataParm.m_iSkillType
		pEffectParm1.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
		pEffectParm1.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
		pEffectParm1.HitPos = copyTab(pFightDataParm.m_HurtPos)	
		
		pEffectParm1.pArmature = pArmature1
		
		pArmature1:setTag(pEffectParm1.m_tagid)
	
	end 	
	
		
	local nHanderTime	
	local buffitmes = 1
	local bufftime =0
	
	local function bufftick(dt)	

		if m_UseingEngineSkillStopTimes > 0 then 
			return
		end 
		
		if buffitmes > pEffectParm.bufftimes or BaseSceneDB.IsDie(pEffectParm.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true then
					
			if nHanderTime ~= nil then
				--if pArmature ~= nil then
				--	pArmature:getScheduler():unscheduleScriptEntry(nHanderTime)	
				--else
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
				--end			
				nHanderTime = nil	
				pEffectParm.HanderTime = nil
			end	
			
			if pEffectParm.iSharder > 0 then			
				CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)
				pEffectParm.iSharder = 0 
			end
			
			if pEffectParm.bBuffGainType ~= nil then 
				
				BaseSceneDB.PalyBuffGain_TeamData(pEffectParm.m_iTar,pEffectParm.bBuffGainType,pEffectParm.bBuffGainVel,false)
				
			end
			
			BaseSceneDB.DelEffectParm(pEffectParm.m_tagid)	
			--pArmature:removeFromParentAndCleanup(true)
			DelArmature(pArmature)
			
			if pArmature1 ~= nil then 
				BaseSceneDB.DelEffectParm(pEffectParm1.m_tagid)	
				--pArmature1:removeFromParentAndCleanup(true)
				DelArmature(pArmature1)
			end
		
		else
			bufftime = bufftime+G_Fight_BUff_Tick_Time
			if bufftime >= pEffectParm.bufftimecd then
				bufftime = 0
				buffitmes = buffitmes + 1					
			end						
		end		
		
	end		
		
	nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)	
	pEffectParm.HanderTime = nHanderTime
	pEffectParm.pArmature = pArmature
		
	pArmature:setTag(pEffectParm.m_tagid)


	----修改跟动画绑定判定---
	
	--//是否绑定骨骼 计算旋转
	if  pbindArmature > 0 then 
		
		if pbindbone > 0  then
		
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
			end		
			
		else			
			pArmature:setPosition(ccp( 0 , 0))				
		end
		
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
			
		
			--pParArmatureTar:addChild(pArmature,0)
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)
			
		else
		
		
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
			
			
		end	
		--//翻转特效
		--pArmature:setScaleX(-(pArmature:getScaleX()))
			
		if pArmature1 ~= nil then 
			if pbindbone1 > 0  then
		
				if pbindbone1 == 6 then --头顶
					pArmature1:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
				else
					pArmature1:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
				end		
				
			else			
				pArmature1:setPosition(ccp( 0 , 0))				
			end	
				
			--print("??????????????????")
			--Pause()
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder1")]) <0 then
				--pParArmatureTar:addChild(pArmature1,0)
				CreatbindBoneToEffect(pArmature1,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename1")],0)
				
			else
				--pParArmatureTar:addChild(pArmature1,Play_Effect_Z)
				CreatbindBoneToEffect(pArmature1,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename1")],Play_Effect_Z)
			end	
				
			--//翻转特效
			--pArmature1:setScaleX(-(pArmature1:getScaleX()))
		end	
	
	else
		
		if pbindbone > 0  then
		
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+50))	
			else
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
			
		end		
	
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
			m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
		else
			m_pBaseScene:Get_Layer_Root():addChild(pArmature)
		end	


		if pArmature1 ~= nil then 
			if pbindbone1 > 0  then
		
				if pbindbone1 == 6 then --头顶
					pArmature1:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+50))	
				else
					pArmature1:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature1:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
				
			end		
		
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder1")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pArmature1,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmature1)
			end	
		end
	
	end
	
	
end


----------增益-瞬发单体类特效-------------
function PlayEffect_Prompt_Gain(iEffectID_buff, iEffectID_hit, iSourcePos, iTargetPos, pBone)	

	if BaseSceneDB.IsDie(iTargetPos) == true then 
		return
	end
	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbuffData = EffectData.getDataById( iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)
	
			
	local pArmature = nil

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])
	
	
	pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
	
	pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))	
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)	
		
	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos	
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
	pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
	pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
	
		
	pEffectParm.bBuffGainType  = pFightDataParm.bBuffGainType	
	pEffectParm.bBuffGainVel  = pFightDataParm.bBuffGainVel	
	
	--播放增加数字效果
	
	
	if pEffectParm.bBuffGainType == BuffGainType.E_GainType_engine and pEffectParm.bBuffGainVel > 0 then 	
		
		BaseSceneDB.PalyBuffGain_TeamData(pEffectParm.m_iTar,pEffectParm.bBuffGainType,pEffectParm.bBuffGainVel,true)		
		playEngine(pEffectParm.m_iTar,pEffectParm.bBuffGainVel)			
	else
	
	end
	
	
		
	pArmature:setTag(pEffectParm.m_tagid)

	----修改跟动画绑定判定---
	
	--//是否绑定骨骼 计算旋转
	if  pbindArmature > 0 then 
		
		if pbindbone > 0  then
		
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
			end		
			
		else			
			pArmature:setPosition(ccp( 0 , 0))				
		end
		
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
			--pParArmatureTar:addChild(pArmature,0)
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)
		else
			--pParArmatureTar:addChild(pArmature,Play_Effect_Z)
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)
		end		
		--//翻转特效
		--pArmature:setScaleX(-(pArmature:getScaleX()))
	else
		
		if pbindbone > 0  then
		
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+50))	
			else
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
			end			
		else			
			pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))				
		end		
	
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
			m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
		else
			m_pBaseScene:Get_Layer_Root():addChild(pArmature)
		end		
	
	end
	
	
	
	
end

----------增益-buff吸收盾特效----***************************************************---------
function PlayEffect_Prompt_buff_xishoudun(iEffectID_buff, iEffectID_hit, iSourcePos, iTargetPos, pBone)	

	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbuffData = EffectData.getDataById( iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)
	
	
	---如果已经有盾了就不在套盾了而是更新数据
	local pTeamData = BaseSceneDB.GetTeamData(iTargetPos)
	if pTeamData.m_xishoudun > 0 then 
		
		BaseSceneDB.PalyBuffGain_TeamData(iTargetPos,BuffGainType.E_BuffGainType_xishoudun,9999999,false)
		
		BaseSceneDB.PalyBuffGain_TeamData(iTargetPos,pFightDataParm.bBuffGainType,pFightDataParm.bBuffGainVel,true)
		return
		
	else
		
		BaseSceneDB.PalyBuffGain_TeamData(iTargetPos,pFightDataParm.bBuffGainType,pFightDataParm.bBuffGainVel,true)
		
	end 	
			
	local pArmature = nil

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
	pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])	
	
	
	pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
	
	pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))	
	
	pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
	--自动切换
	--pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)	
	--增加sharder效果
	local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
	
	if iSharder > 0 then		
		CCArmatureSharder(pParArmatureTar,iSharder)
	end
	
	local pEffectParm = BaseSceneDB.CreateEffectParm()	
	
	pEffectParm.m_iSource = iSourcePos
	pEffectParm.m_iTar    = iTargetPos
	pEffectParm.m_State	= pFightDataParm.m_State
	pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
	pEffectParm.m_EffectID = iEffectID_hit
	pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
	pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
	pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
	pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
	
	
	--增加buff特效得特殊属性
	if 	pFightDataParm.bufftimes >0 then 
		pEffectParm.bufftimes = pFightDataParm.bufftimes
	else
		pEffectParm.bufftimes = 9999999
	end
	
	pEffectParm.bufftimecd = pFightDataParm.bufftimecd	
	pEffectParm.bBuffTYpe = pFightDataParm.bBuffTYpe
	pEffectParm.iSharder  = iSharder		
	pEffectParm.bBuffGainType  = pFightDataParm.bBuffGainType	
	pEffectParm.bBuffGainVel  = pFightDataParm.bBuffGainVel		
	
	--print(pEffectParm.bBuffTYpe)
	--Pause()	

	
	
	--扩展特效类型
	local pArmature1 = nil
	local pEffectParm1 = nil
	local pbindbone1 = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone1")])	
	if pEffectbuffData[EffectData.getIndexByField("fileName1")] ~= nil then
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName1")])
		pArmature1 = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName1")])	
		
		
		pArmature1:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
		
		pArmature1:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_1")]))	
		
		pArmature1:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
						
		pEffectParm1 = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm1.m_iSource = iSourcePos
		pEffectParm1.m_iTar    = iTargetPos
		pEffectParm1.m_State	= pFightDataParm.m_State
		pEffectParm1.m_EffectID = iEffectID_hit
		pEffectParm1.m_EffectType = pFightDataParm.m_iSkillType
		pEffectParm1.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
		pEffectParm1.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
		pEffectParm1.HitPos = copyTab(pFightDataParm.m_HurtPos)	
		
		pEffectParm1.pArmature = pArmature1
		
		pArmature1:setTag(pEffectParm1.m_tagid)
	
	end 	
		
	local nHanderTime	
	local buffitmes = 1
	local bufftime =0
	
	local function bufftick(dt)		
		
		if m_UseingEngineSkillStopTimes > 0 then 
			return
		end 
		
		local pTeamData = BaseSceneDB.GetTeamData(pEffectParm.m_iTar)
		if pTeamData.m_xishoudun <= 0 or buffitmes > pEffectParm.bufftimes or BaseSceneDB.IsDie(pEffectParm.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true then
					
			if nHanderTime ~= nil then
				--if pArmature ~= nil then
				--	pArmature:getScheduler():unscheduleScriptEntry(nHanderTime)	
				--else
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
				--end		
				nHanderTime = nil
				pEffectParm.HanderTime = nil
			end	
			
			if pEffectParm.iSharder > 0 then			
				CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)
				pEffectParm.iSharder = 0 
			end
			
			if pEffectParm.bBuffGainType ~= nil then 
				
				BaseSceneDB.PalyBuffGain_TeamData(pEffectParm.m_iTar,pEffectParm.bBuffGainType,pEffectParm.bBuffGainVel,false)
				
			end
			
			BaseSceneDB.DelEffectParm(pEffectParm.m_tagid)	
			--pArmature:removeFromParentAndCleanup(true)
			DelArmature(pArmature)
			
			if pArmature1 ~= nil then 
				BaseSceneDB.DelEffectParm(pEffectParm1.m_tagid)	
				--pArmature1:removeFromParentAndCleanup(true)
				DelArmature(pArmature1)
			end
			
		else
		
			bufftime = bufftime+G_Fight_BUff_Tick_Time
			if bufftime >= pEffectParm.bufftimecd then
				bufftime = 0
				buffitmes = buffitmes + 1					
			end		
				
			
		end		
		
	end		
		
	nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(bufftick, G_Fight_BUff_Tick_Time, false)	
	pEffectParm.HanderTime = nHanderTime
	pEffectParm.pArmature = pArmature
		
	pArmature:setTag(pEffectParm.m_tagid)
	----修改跟动画绑定判定---
	
	--//是否绑定骨骼 计算旋转
	if  pbindArmature > 0 then 
		
		if pbindbone > 0  then
		
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
			else
				pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
			end		
			
		else			
			pArmature:setPosition(ccp( 0 , 0))				
		end		
		
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then			
						
			--pParArmatureTar:addChild(pArmature,0)			
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)		
			
		else
		
			
			--pParArmatureTar:addChild(pArmature,Play_Effect_Z)
			CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)	
			
			
		end	
			
		--//翻转特效
		--pArmature:setScaleX(-(pArmature:getScaleX()))
		
		if pArmature1 ~= nil then 
			if pbindbone1 > 0  then
		
				if pbindbone1 == 6 then --头顶
					pArmature1:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
				else
					pArmature1:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
				end		
				
			else			
				pArmature1:setPosition(ccp( 0 , 0))				
			end		
			
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder1")]) <0 then
				--pParArmatureTar:addChild(pArmature1,0)
				CreatbindBoneToEffect(pArmature1,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename1")],0)		
			else
				--pParArmatureTar:addChild(pArmature1,Play_Effect_Z)
				CreatbindBoneToEffect(pArmature1,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename1")],Play_Effect_Z)		
			end	
			
			--//翻转特效
			--pArmature1:setScaleX(-(pArmature1:getScaleX()))
		end	
		
		
	
	else
		
		if pbindbone > 0  then
		
			if pbindbone == 6 then --头顶
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+50))	
			else
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
			end
			
			
		else
			
			pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
			
		end		
	
		if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
			m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
		else
			m_pBaseScene:Get_Layer_Root():addChild(pArmature)
		end	



		if pArmature1 ~= nil then 
			if pbindbone1 > 0  then
		
				if pbindbone1 == 6 then --头顶
					pArmature1:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+50))	
				else
					pArmature1:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature1:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
				
			end		
		
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder1")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pArmature1,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmature1)
			end	
		end
	
	end
	
	
end



----伤害+状态限制Buff 有几率的
function PlayEffect_Prompt_buff_State(iEffectID_buff, iEffectID_hit, iSourcePos, iTargetPos, pBone,bShow)	
	
	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)

	local pEffectbuffData = EffectData.getDataById( iEffectID_buff)

	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	local pbindArmature = tonumber(pEffectbuffData[EffectData.getIndexByField("bindAnimation")])	
	

	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)
	
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)
	
	--------判断技能状态
	if pFightDataParm.m_State > DamageState.E_DamageState_None  and  pFightDataParmTar.m_buff_state ~= pFightDataParm.m_State then 
				
				
		if pFightDataParmTar.m_buff_state == DamageState.E_DamageState_jifei then 
		
			pParArmatureTar:stopActionByTag(Fight_jifeiMoveTagID)
			
		end
		---根据状态暂停动作
		if  pFightDataParm.m_State == DamageState.E_DamageState_bingdong then 		
			
				pFightDataParmTar.m_buff_state = pFightDataParm.m_State	
				
				--技能被打断
				--防止死亡动作的时候打
				if pParArmatureTar:getAnimation():getCurrentMovementID() ~= GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_die) then			
					pParArmatureTar:getAnimation():play(GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_stand))			
				end	
					
				
				pauseSchedulerAndActions(pParArmatureTar)	
		
		elseif pFightDataParm.m_State == DamageState.E_DamageState_xuanyun then 
			
				pFightDataParmTar.m_buff_state = pFightDataParm.m_State	
				
				
				if pParArmatureTar:getAnimation():getCurrentMovementID() ~= GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_die) then	
					resumeSchedulerAndActions(pParArmatureTar)	
					pParArmatureTar:getAnimation():play(GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_vertigo))			
				end					
			
		end		
	
		local pArmature = nil
	
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectbuffData[EffectData.getIndexByField("fileName")])
		pArmature = CCArmature:create(pEffectbuffData[EffectData.getIndexByField("EffectName")])
			
				
		pArmature:setZOrder(tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
		
		print(pEffectbuffData[EffectData.getIndexByField("EffectName")])
		
		if  pArmature:getAnimation():getMovementCount() > 1 then
			
			--先出生 再循环
			pArmature:getAnimation():playWithIndex(0)				
			pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)			
			
		else			
			pArmature:getAnimation():playWithIndex(tonumber(pEffectbuffData[EffectData.getIndexByField("AnimationID_0")]))
		end
				
		
		pArmature:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)
		
		--增加sharder效果
		local iSharder = tonumber(pEffectbuffData[EffectData.getIndexByField("sharder")]) 
		
		if iSharder > 0 then		
			CCArmatureSharder(pParArmatureTar,iSharder)
		end
				

		local pEffectParm = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm.m_iSource 	= iSourcePos
		pEffectParm.m_iTar    	= iTargetPos
		pEffectParm.m_State		= pFightDataParm.m_State
		pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
		pEffectParm.m_EffectID 	= iEffectID_hit
		pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
		pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
		pEffectParm.m_iDamage 	= BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
		pEffectParm.HitPos 		= copyTab(pFightDataParm.m_HurtPos)
		
		
		--增加buff特效得特殊属性
				
		pEffectParm.bufftimes = pFightDataParm.bufftimes
		pEffectParm.bufftimecd = pFightDataParm.bufftimecd	
		pEffectParm.bBuffTYpe = pFightDataParm.bBuffTYpe
		pEffectParm.iSharder  = iSharder
		
		-----修改Buff方法 统一1秒回调 这样增加Buff的判断机制
		local nHanderTime	
		local buffitmes = 1
		local bufftime =0
		
		local function bufftick_State(dt)		
			--print("buffitmes = " .. buffitmes)
			
			if m_UseingEngineSkillStopTimes > 0 then 
				return
			end 
				
			if pFightDataParmTar.m_buff_state_reset ~= nil and pFightDataParmTar.m_buff_state_reset == 1 then
				
				buffitmes = 1
				bufftime = 0
				
				pFightDataParmTar.m_buff_state_reset = nil
			end
			
			if buffitmes > pEffectParm.bufftimes or BaseSceneDB.IsDie(pEffectParm.m_iTar) == true  or BaseSceneDB.GetFightEnd() == true 
				or (pFightDataParmTar.m_buff_state ~= nil and pEffectParm.m_State ~= pFightDataParmTar.m_buff_state )then
					
				--print("buffitmes > pEffectParm.bufftimes = " .. buffitmes)
				
				if nHanderTime ~= nil then
					
					--if pArmature ~= nil then
					--	pArmature:getScheduler():unscheduleScriptEntry(nHanderTime)	
					--else
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
					--end			
					nHanderTime = nil	
					pEffectParm.HanderTime = nil
				end	
				
				if pEffectParm.iSharder > 0 then			
					CCArmatureSharder(pParArmatureTar,SharderKey.E_SharderKey_Normal)
					pEffectParm.iSharder = 0 
				end
				
				
				if pEffectParm.m_State > 0 then		

					if pEffectParm.m_State	~= pFightDataParmTar.m_buff_state then 
					
						
					
					else
						
						if  pEffectParm.m_State == DamageState.E_DamageState_bingdong then 
						
							------解锁暂停需要看是不是在暂停状态--
							if m_UseingEngineSkillStopTimes <= 0 then 
								resumeSchedulerAndActions(pParArmatureTar)	
							end						
							pFightDataParmTar.m_buff_state = nil
							
						elseif pEffectParm.m_State == DamageState.E_DamageState_xuanyun then 
							
							if pParArmatureTar:getAnimation():getCurrentMovementID() == GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_vertigo) then			
								pParArmatureTar:getAnimation():play(GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_stand))			
							end	
								
							pFightDataParmTar.m_buff_state = nil
						
						end					
						
					
					end
						
					pEffectParm.m_State = E_DamageState_None
				end					
				
				BaseSceneDB.DelEffectParm(pEffectParm.m_tagid)					
				--pArmature:removeFromParentAndCleanup(true)
				DelArmature(pArmature)
			
			else	
				bufftime = bufftime+G_Fight_BUff_Tick_Time
				if bufftime >= pEffectParm.bufftimecd then
					bufftime = 0
					buffitmes = buffitmes + 1					
				end
									
			end		
			
		end		
		
		nHanderTime  = pArmature:getScheduler():scheduleScriptFunc(bufftick_State, G_Fight_BUff_Tick_Time, false)
		pEffectParm.HanderTime = nHanderTime
		pEffectParm.pArmature = pArmature
			
		pArmature:setTag(pEffectParm.m_tagid)
		
		--//是否绑定骨骼 计算旋转
		if  pbindArmature > 0 then 
			
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( 0 , pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
				else
					pArmature:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( 0 , 0))		
				
			end
			
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				--pParArmatureTar:addChild(pArmature,0)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],0)	
			else
				--pParArmatureTar:addChild(pArmature,Play_Effect_Z)
				CreatbindBoneToEffect(pArmature,pParArmatureTar,pEffectbuffData[EffectData.getIndexByField("bonename")],Play_Effect_Z)	
			end	
				
			--//翻转特效
			--pArmature:setScaleX(-(pArmature:getScaleX()))
			
		else
		
				--//是否绑定骨骼 计算旋转		 
			if pbindbone > 0  then
				
				if pbindbone == 6 then --头顶
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+10))	
				else
					pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmature:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
				
			end
			
					
			if tonumber(pEffectbuffData[EffectData.getIndexByField("effectzorder")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pArmature,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmature)
			end		
						
		
		end
	
	else
		
		if pFightDataParm.m_State > DamageState.E_DamageState_None and pFightDataParmTar.m_buff_state == pFightDataParm.m_State then 		
			pFightDataParmTar.m_buff_state_reset = 1					
		end		
		
	end 
	
	
	--PlayDamage(iSourcePos,iTargetPos,pFightDataParm.m_State,BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage),pFightDataParm.m_bUseingEngineSkill)	
	PlayDamage(iSourcePos,iTargetPos,BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_DamageState),BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage),pFightDataParm.m_bUseingEngineSkill)	
	
	
	---创建 被打特效
	
	if bShow == true then
	
		local pEffectHitData = EffectData.getDataById( iEffectID_hit)		

		--//添加
		local pArmatureHit = nil
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectHitData[EffectData.getIndexByField("fileName")])
		
		pArmatureHit = CCArmature:create(pEffectHitData[EffectData.getIndexByField("EffectName")])
			
		
		if BaseSceneDB.IsNpc(iTargetPos) == false then
		
			--//翻转特效
			pArmatureHit:setScaleX(-(pArmatureHit:getScaleX()))
		end

		pArmatureHit:setScale(tonumber(pEffectHitData[EffectData.getIndexByField("Scale")]))	
		
		pArmatureHit:setZOrder(tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")])+pParArmatureTar:getZOrder())
		pArmatureHit:getAnimation():playWithIndex( tonumber(pEffectHitData[EffectData.getIndexByField("AnimationID_0")]))
		
			
		-- add by sxin 增加绑定特效参数		
		local pEffectParmhit = BaseSceneDB.CreateEffectParm()	
		
		pEffectParmhit.m_iSource = iSourcePos
		pEffectParmhit.m_iTar    = iTargetPos
		pEffectParmhit.m_State	= nil --pFightDataParm.m_State
		pEffectParmhit.m_EffectID = iEffectID_hit
		pEffectParmhit.m_EffectType = pFightDataParm.m_iSkillType
		pEffectParmhit.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
		pEffectParmhit.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
		pEffectParmhit.HitPos = copyTab(pFightDataParm.m_HurtPos)
			
		pArmatureHit:setTag(pEffectParmhit.m_tagid)	
		
		pArmatureHit:getAnimation():setFrameEventCallFunc(onEffectFrameEvent)

		pArmatureHit:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)	
		

		local pbindboneHit = tonumber(pEffectHitData[EffectData.getIndexByField("bindbone")])	
		local pbindArmatureHit = tonumber(pEffectHitData[EffectData.getIndexByField("bindAnimation")])
		
		
		if  pbindArmatureHit > 0 then 
				
			if pbindboneHit > 0  then
				
				if pbindboneHit == 6 then --头顶
					pArmatureHit:setPosition(ccp( 0 , pFightDataParmTar.m_Mode_Height+Off_Effect_head))	
				else
					pArmatureHit:setPosition(ccp( 0, pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmatureHit:setPosition(ccp( 0 , 0))		
				
			end
			
			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
				--pParArmatureTar:addChild(pArmatureHit,0)
				CreatbindBoneToEffect(pArmatureHit,pParArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],0)	
			else
				--pParArmatureTar:addChild(pArmatureHit,Play_Effect_Z)
				CreatbindBoneToEffect(pArmatureHit,pParArmatureTar,pEffectHitData[EffectData.getIndexByField("bonename")],Play_Effect_Z)	
			end		
			--pArmatureHit:setScaleX(-(pArmatureHit:getScaleX()))
		else
		
				--//是否绑定骨骼 计算旋转		 
			if pbindboneHit > 0  then
				
				if pbindboneHit == 6 then --头顶
					pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height+10))	
				else
					pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY() + pFightDataParmTar.m_Mode_Height*0.5))	
				end
				
				
			else
				
				pArmatureHit:setPosition(ccp( pParArmatureTar:getPositionX() , pParArmatureTar:getPositionY()))		
				
			end
			
					
			if tonumber(pEffectHitData[EffectData.getIndexByField("effectzorder")]) <0 then
				m_pBaseScene:Get_Layer_Root():addChild(pArmatureHit,0)
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmatureHit)
			end		
						
		
		end
	end	
	
end



----伤害+击飞+状态限制Buff (有几率的)
function PlayEffect_Prompt_buff_State_jitui(iEffectID_buff, iEffectID_hit, iSourcePos, iTargetPos, pBone)	
	
	
	--//取当前角色的位置	
	local pParArmature = BaseSceneDB.GetPlayArmature(iSourcePos)
	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)

	local pParArmatureTar = BaseSceneDB.GetPlayArmature(iTargetPos)
	local pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iTargetPos)

	local pEffectbuffData = EffectData.getDataById( iEffectID_buff)
	local pbindbone = tonumber(pEffectbuffData[EffectData.getIndexByField("bindbone")])	
	
	
	local function jifeiArrive(pNode)
		
		local pTarArmature = tolua.cast(pNode, "CCArmature")
		local iTarPos = pTarArmature:getTag()
		
		if pFightDataParmTar.m_buff_state ==  DamageState.E_DamageState_jifei then 
		
			pFightDataParm.m_State = DamageState.E_DamageState_xuanyun
			
			--PlayEffect_Prompt_buff_State(iEffectID_buff,iEffectID_hit,iSourcePos,iTarPos,pBone)
			--击飞的本人不做眩晕
			PlayEffect_Prompt(iEffectID_hit,iSourcePos,iTarPos,false)
			--在落地的地方算下范围内的怪
			--以目标为中心的范围攻击
			local index =1
			if BaseSceneDB.IsNpc(iTarPos) == true then		
						
				local i = 1					
				for i= 1, MaxTeamPlayCount, 1 do				
									
					local iNpc = i + BaseSceneDB.GetCurTimes()*MaxTeamPlayCount 
				
					if iNpc ~= iTarPos and BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
						
						local pNpcArmature = BaseSceneDB.GetPlayArmature(iNpc)
						
						if ccpDistance( ccp(pTarArmature:getPosition()),ccp(pNpcArmature:getPosition())) <= Ani_fly_Damage_Dis then							
							
							index = index+1
							pFightDataParm.m_HurtPos[index] = iNpc
							--暂时默认被砸都减少200血
							pFightDataParm.m_Damage[index] = 200
							
							PlayEffect_Prompt_buff_State(iEffectID_buff,iEffectID_hit,iSourcePos,iNpc,pBone,true)				
						
						end
						
					end
					
				end 			
			else
				local i = 1			
				for i= 1, MaxTeamPlayCount, 1 do
				
					if i ~= iTarPos and BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
						
						local pPlayArmature = BaseSceneDB.GetPlayArmature(i)
						
						if ccpDistance( ccp(pTarArmature:getPosition()),ccp(pPlayArmature:getPosition())) <= Ani_fly_Damage_Dis then
							
							index = index+1
							pFightDataParm.m_HurtPos[index] = i
							--暂时默认被砸都减少200血
							pFightDataParm.m_Damage[index] = 200
						
							PlayEffect_Prompt_buff_State(iEffectID_buff,iEffectID_hit,iSourcePos,i,pBone,true)							
						end
					end
					
				end 				
				
			end	
			
		end
		
		
			
	end
	
	--------判断技能状态
	if pFightDataParm.m_State == DamageState.E_DamageState_jifei then 				
					
		pFightDataParmTar.m_buff_state = pFightDataParm.m_State			
		
		if pParArmatureTar:getAnimation():getCurrentMovementID() ~= GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_die) then	
			--------------播放击飞效果----写死移动固定距离---Ani_fly_Dis--0.5秒固定时间	Ani_fly_Time		
			pParArmatureTar:getAnimation():play(GetAniName_Player(pParArmatureTar,Ani_Def_Key.Ani_fly))
				
			local pMoveBy = nil
			
			local ijifeiDis = 0
			local ipParArmatureTar_Pos_x = pParArmatureTar:getPositionX()
			local iSCenceEnd_Pos_X = MaxMoveDistance*BaseSceneDB.GetCurTimes()
			local iSCenceBegin_Pos_X = iSCenceEnd_Pos_X - MaxMoveDistance
			if BaseSceneDB.IsNpc(iTargetPos) == true then 
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
			
			pParArmatureTar:runAction(pMoveseq)
		end	
	
	else--免疫击飞效果按普通的伤害执行
	
		PlayEffect_Prompt(iEffectID_hit,iSourcePos,iTargetPos,false)
	
	end 
	
end




--扩展子弹类+限制Buff
function PlayEffect_Bullet_buff_State(iEffectID_bullet, iEffectID_hit, iEffectID_buff,iSourcePos, iTargetPos, pBone,ActType)


	local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)
		
	
	if pFightDataParm.m_State > DamageState.E_DamageState_None then
	
	
		local pArmature = nil
		if pFightDataParm.m_State == DamageState.E_DamageState_xuanyun or pFightDataParm.m_State == DamageState.E_DamageState_Dot then
		
			pArmature = Create_Bullet_Armature(iEffectID_bullet,iSourcePos,iTargetPos,pBone,OnBulletDamageState)
			
		end	
		
		if pArmature ~= nil then 
		
			local pEffectParm = BaseSceneDB.CreateEffectParm()	
			
			pEffectParm.m_iSource = iSourcePos
			pEffectParm.m_iTar    = iTargetPos
			pEffectParm.m_State	= pFightDataParm.m_State
			pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
			pEffectParm.m_EffectID = iEffectID_hit
			pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
			pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
			pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,iTargetPos,pFightDataParm.m_Damage)
			pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
			
			
			--给子弹限制Buff的
			pEffectParm.iEffectID_buff = iEffectID_buff	
			pEffectParm.m_Damage = copyTab(pFightDataParm.m_Damage)
			pEffectParm.bufftimes = pFightDataParm.bufftimes
			pEffectParm.bufftimecd = pFightDataParm.bufftimecd	
			pEffectParm.bBuffTYpe = pFightDataParm.bBuffTYpe
			pEffectParm.ActType = ActType	
		
				
			pArmature:setTag(pEffectParm.m_tagid)	

			if pFightDataParm.m_bUseingEngineSkill == true  then
			
				m_pBaseScene:Get_Layer_Root():addChild(pArmature,100)
			
			else
				m_pBaseScene:Get_Layer_Root():addChild(pArmature)
				--m_DamageLayer:addChild(pArmature)
			end
		end
	else
		
		if ActType == EffectTypeTarg.E_EffectType_OneTarget then
			
			PlayEffect_Bullet(iEffectID_bullet,iEffectID_hit,iSourcePos,iTargetPos,pBone,false)
			
		elseif ActType == EffectTypeTarg.E_EffectType_combination_One then		
			
			PlayEffect_Bullet(iEffectID_bullet,iEffectID_hit,iSourcePos,iTargetPos,pBone,true)
		
		end		
		
	end

end

--子弹类顺序攻击目标伤害
function PlayEffect_Bullet_Sequence(iEffectID_bullet, iEffectID_hit, iEffectID_buff,iSourcePos, HitList, pBone)

	local pArmature = nil
	
	pArmature = Create_Bullet_Sequence_Armature(iEffectID_bullet,iSourcePos,HitList,pBone,OnDamage)
	
	
	if pArmature ~= nil then 
	
		local pFightDataParm = BaseSceneDB.GetPlayFightParm(iSourcePos)
		
		local pEffectParm = BaseSceneDB.CreateEffectParm()	
		
		pEffectParm.m_iSource = iSourcePos
		pEffectParm.m_iTar    = HitList[1]
		pEffectParm.m_State	= pFightDataParm.m_State
		pEffectParm.m_iDamageState	= copyTab(pFightDataParm.m_DamageState)
		pEffectParm.m_EffectID = iEffectID_hit
		pEffectParm.m_EffectType = pFightDataParm.m_iSkillType
		pEffectParm.m_EngineSkill = pFightDataParm.m_bUseingEngineSkill
		pEffectParm.m_iDamage = BaseSceneDB.GetHurtDamagebyHitPos(pFightDataParm.m_HurtPos,HitList[1],pFightDataParm.m_Damage)
		pEffectParm.HitPos = copyTab(pFightDataParm.m_HurtPos)
		pEffectParm.Damage = copyTab(pFightDataParm.m_Damage)				
		pArmature:setTag(pEffectParm.m_tagid)	

		if pFightDataParm.m_bUseingEngineSkill == true  then
		
			m_pBaseScene:Get_Layer_Root():addChild(pArmature,100)
		
		else
			m_pBaseScene:Get_Layer_Root():addChild(pArmature)			
		end
	end

	
end 


function PlayEffectMage_Player(ipos)

	local FightDataParm = BaseSceneDB.GetPlayFightParm(ipos) 
	PlayEffectMage(FightDataParm)
end

function PlayEffectMage_Hufa(iIndex)

	--print(iIndex)
	
	local FightDataParm = BaseSceneDB.GetHufaFightParm(iIndex) 
	--printTab(FightDataParm)
	--Pause()
	PlayEffectMage(FightDataParm)
	
	----清理上次的战斗记录
	BaseSceneDB.ClearDamageLogic(FightDataParm)
end


function PlayEffectMage(FightDataParm)
		
	if BaseSceneDB.IsDie(FightDataParm.m_iTarpos)== true and FightDataParm.m_FightPos < Fight_hufa_TagID_Root then
		
			
		 local iTar = GetFightTarPos(FightDataParm.m_FightPos)
		
		--local bEngineSkill = OnFightDamageLogic(pFightDataParm,pFightDataParm.m_iTarpos,false)
		if iTar > 0 then 
			FightDataParm.m_iTarpos = iTar
		end
		
	end 	

	---****---记录战斗记录------------------
	FightbattleData.SetBattleData(BaseSceneDB.GetBattleID(),BaseSceneDB.GetCurTimes(),FightDataParm.m_FightPos,FightDataParm)	
	-------------------------------------------
		
	local pSkillData = SkillData.getDataById( FightDataParm.m_iSkill)


	local pEffectData = nil	

	--//瞬发
	if tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt then
	
		--print("瞬发" )
		--Pause()
		
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])
		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])

		--//单目标
		if tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_OneTarget then
		
		--	print("瞬发单目标" )
		--	Pause()
			
			local i=1
			for i=1, MaxTeamPlayCount, 1 do
				
				if FightDataParm.m_HurtPos[i] > 0 then
				
					PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],false)
				
				end
				
			end		

		
		--//组合特效第一有效
		elseif tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then
			
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do
				
				if FightDataParm.m_HurtPos[i] > 0 then
					
					if i == 1 then
						PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],true)
					else
						PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],false)
					end
				
				end
				
			end		

		
		--//组合特效全有效
		elseif tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_All then
		
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do
				
				if FightDataParm.m_HurtPos[i] > 0 then
				
					PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],true)
				
				end
				
			end		
		end

	
	--//子弹类
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		
		--print("子弹类单目标" )
		--Pause()
		
		if tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then
		
			PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[1],FightDataParm.m_Curbone,true)					
			
		else
		
			local i=1
			for i=1, MaxTeamPlayCount, 1 do
				
				if FightDataParm.m_HurtPos[i] > 0 then
				
					PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone,false)					
				end
				
			end			
		
		end
		
			
		
	--//抛物线朝向类的特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_parabolic_one then
	
		--print("抛物线朝向类的特效技能")
		--Pause()
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		
		----改写接口	
	--	PlayEffect_Bullet(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_iTarpos,FightDataParm.m_Curbone);
		
		PlayEffect_Bullet_parabolic(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_iTarpos,FightDataParm.m_Curbone,true)
		
	
	--//抛物线朝向类的特效技能多目标的
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_parabolic_Mul then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		
		--print("抛物线朝向类的特效技能多目标的")
		--Pause()
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if FightDataParm.m_HurtPos[i] > 0 then			
				
				PlayEffect_Bullet_parabolic(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone,false)
		
			end
			
		end		
	----buf类特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_One then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
				
		PlayEffect_Prompt_buff(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_iTarpos,FightDataParm.m_Curbone)
		
		
	----增益buf类特效技能
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_Gain then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		
		
		--PlayEffect_Prompt_buff_Gain(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_iTarpos,FightDataParm.m_Curbone)
		--扩展多个伤害取伤害链表
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if FightDataParm.m_HurtPos[i] > 0 then			
				
				PlayEffect_Prompt_buff_Gain(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone)
		
			end
			
		end		
		
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_State then
	
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])		

		if tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then
		
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do
				
				if FightDataParm.m_HurtPos[i] > 0 then
					
					if i == 1 then
						PlayEffect_Prompt_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone,true)
			
					else
						PlayEffect_Prompt_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone,false)
			
					end
				
				end
			end
				
		else	
			
			--扩展多个伤害取伤害链表
			local i=1
			for i=1 , MaxTeamPlayCount, 1 do
				
				if FightDataParm.m_HurtPos[i] > 0 then			
					
					PlayEffect_Prompt_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone,true)
			
				end
				
			end		
		end	
		--PlayEffect_Prompt_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_iTarpos,FightDataParm.m_Curbone)
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_State_jifei then
		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])			
			
		PlayEffect_Prompt_buff_State_jitui(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_iTarpos,FightDataParm.m_Curbone)
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Gain then --//增益瞬发单体
		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	

		--扩展多个伤害取伤害链表
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if FightDataParm.m_HurtPos[i] > 0 then			
				--print(FightDataParm.m_HurtPos[i])
				PlayEffect_Prompt_Gain(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone)
				--Pause()
				
			end
			
		end		
			
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_buff_xishoudun then --//吸收盾逻辑
		
		
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	

		--扩展多个伤害取伤害链表
		local i=1
		for i=1 , MaxTeamPlayCount, 1 do
			
			if FightDataParm.m_HurtPos[i] > 0 then			
				--print(FightDataParm.m_HurtPos[i])
				PlayEffect_Prompt_buff_xishoudun(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone)
				--Pause()
				
			end
			
		end		
			
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Back_one then --//伤害+回复（单体）
	
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])
		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])
		 
		 --播放回复类型特效
		 if FightDataParm.m_iParamDamage > 0 then 
			
			if FightDataParm.m_iParamDamageType == BuffGainType.E_GainType_engine then 
				playEngine(FightDataParm.m_FightPos,FightDataParm.m_iParamDamage)
				PlayEffect_Engine(FightDataParm.m_FightPos)
			else
			
			end
			
			
		 end
		 
		 
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			
			if FightDataParm.m_HurtPos[i] > 0 then
			
				PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],false)
			
			end
			
		end		
					
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_Back_all then --//伤害+回复（全体）
		
		
		 --播放回复类型特效
		if FightDataParm.m_iParamDamage > 0 then 
			
			if FightDataParm.m_iParamDamageType == BuffGainType.E_GainType_engine then 
				
				local i=1	
				local iPos = 1
				for i=1 , MaxTeamPlayCount , 1 do			
					if BaseSceneDB.IsNpc(FightDataParm.m_FightPos) == true then 						
						iPos = BaseSceneDB.GetCurTimes()*MaxTeamPlayCount + i
					else
						iPos = i
					end
					
					if  BaseSceneDB.IsUser(iPos) == true  and  BaseSceneDB.IsDie(iPos) == false then								
												
						playEngine(iPos,FightDataParm.m_iParamDamage)	
						PlayEffect_Engine(iPos)
					end		
				end				
			end
		end 
		 
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			
			if FightDataParm.m_HurtPos[i] > 0 then
			
				PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],false)
			
			end
			
		end		
			
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Prompt_ShuXing_one then --//伤害+属性（单体）
				
		 pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_hit")])
		 
		 PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")]) 
		 
		local i=1
		for i=1, MaxTeamPlayCount, 1 do
			
			if FightDataParm.m_HurtPos[i] > 0 then
			
				PlayEffect_Prompt(tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],false)
				
				 --播放属性类型特效					
				if FightDataParm.m_iParamDamageType == BuffGainType.E_GainType_engine then 
					playEngine(FightDataParm.m_HurtPos[i],FightDataParm.m_iParamDamage)
					PlayEffect_Engine(FightDataParm.m_HurtPos[i])
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
				
				if FightDataParm.m_HurtPos[i] > 0 then			
					
					PlayEffect_Bullet_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_Buff")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[i],FightDataParm.m_Curbone,EffectTypeTarg.E_EffectType_OneTarget)
			
				end
				
			end		
		elseif tonumber(pSkillData[SkillData.getIndexByField("ActType")]) == EffectTypeTarg.E_EffectType_combination_One then
			
			PlayEffect_Bullet_buff_State(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_Buff")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos[1],FightDataParm.m_Curbone,EffectTypeTarg.E_EffectType_combination_One)
		end			
		
	elseif tonumber(pSkillData[SkillData.getIndexByField("SkillType")]) == EffectType.E_EffectType_Bullet_Sequence then --//子弹伤害+顺序伤害
				
		pEffectData = EffectData.getDataById(pSkillData[SkillData.getIndexByField("Effectid_bullet")])
		 
		PlaySound(Audio_Type.E_Audio_AttackEffect,pEffectData[EffectData.getIndexByField("Audio_Animation_0")])	

					
		PlayEffect_Bullet_Sequence(tonumber(pSkillData[SkillData.getIndexByField("Effectid_bullet")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_hit")]),tonumber(pSkillData[SkillData.getIndexByField("Effectid_Buff")]),FightDataParm.m_FightPos,FightDataParm.m_HurtPos,FightDataParm.m_Curbone)
	
		
	else
	
	
	
	
	end	
	
end


function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
	     
        if evt == FrameEvent_Key.Event_attack then
           
			
			local pArmature = bone:getArmature()

			if pArmature ~= nil then
			
				local ipos = pArmature:getTag()
				local pFightParm = BaseSceneDB.GetPlayFightParm(ipos)
				pFightParm.m_Curbone = bone
											
				PlayEffectMage_Player(ipos)
				
				--判断手动技能效果解除				
				
				if pFightParm.m_bUseingEngineSkill == true then
					--Pause()
					pFightParm.m_bUseingEngineSkill = false
					ResumeAllAnimation(pArmature)
					ResumeAllEffect()
				
				end
				
			
			end	
		elseif  evt == FrameEvent_Key.Event_Vibration then
					   
			VibrationSceen(3)
										   
		elseif  evt == FrameEvent_Key.Event_Blur then
			--设置模糊效果
			local pArmature = bone:getArmature()

			if pArmature ~= nil then
			
				local ipos = pArmature:getTag()
				BaseSceneDB.GetPlayFightParm(ipos).bUseSharder = true
				CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Blur)			
			end	
			
		elseif  evt == FrameEvent_Key.Event_Normal then
			
			local pArmature = bone:getArmature()

			if pArmature ~= nil then
			
				local ipos = pArmature:getTag()
				local pFightParm = BaseSceneDB.GetPlayFightParm(ipos)
				
				if pFightParm.bUseSharder ~= nil  and pFightParm.bUseSharder == true then
					pFightParm.bUseSharder = false
					CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Normal)	
				end
						
			end	
		else
		   
        end
end

function onMovementEvent(armatureBack,movementType,movementID)
	local id = movementID
		
	
	if movementType == MovementEventType.start	then
				
		if id == GetAniName_Player(armatureBack,Ani_Def_Key.Ani_stand) then
		
			local ipos = armatureBack:getTag()
			
			-----暂时屏蔽掉  判断手动技能自动释放
			--[[
			if BaseSceneDB.IsPKScene() == false then 
				if BaseSceneDB.IsNpc(ipos) == false and BaseSceneDB.GetFightEnd() == false then
					if BaseSceneDB.GetTeamData(ipos).m_engine >= 100 and BaseSceneDB.GetFightAuto() == true then
						UseEngineSkill(ipos)
						return
					end
				end
			end
			--]]
			
		--	CheckArmature_Overlap(armatureBack)
			
		end
	
	elseif movementType == MovementEventType.complete then
		
		--防止设置了sharder没有切回来
		local ipos = armatureBack:getTag()
		local pFightParm = BaseSceneDB.GetPlayFightParm(ipos)		
		if pFightParm.bUseSharder ~= nil  and pFightParm.bUseSharder == true then
			pFightParm.bUseSharder = false
			CCArmatureSharder(armatureBack,SharderKey.E_SharderKey_Normal)	
		end
		
		
		if id == GetAniName_Player(armatureBack,Ani_Def_Key.Ani_die) then
		   -- //??????????

			local pFadeOut = CCFadeOut:create(3)
			armatureBack:runAction(pFadeOut)				
			SetAnimationUiVisible(armatureBack,false)
		else
			--判断手动技能效果解除放到播放特效得时候
			if id == GetAniName_Player(armatureBack,Ani_Def_Key.Ani_manual_skill) then
							
				if pFightParm.m_bUseingEngineSkill == true then
					--Pause()				
					ResumeAllAnimation(armatureBack)
					ResumeAllEffect()
					pFightParm.m_bUseingEngineSkill = false
				end 
			
			end
												
			armatureBack:getAnimation():play(GetAniName_Player(armatureBack,Ani_Def_Key.Ani_stand))	
			
			CheckArmature_Overlap(armatureBack)
			
		end
	
	
	elseif movementType == MovementEventType.loopComplete then
		
		--隐藏血条	
		if id == GetAniName_Player(armatureBack,Ani_Def_Key.Ani_stand)  then		
			SetAnimationUiVisible(armatureBack,false)
		end
			
			
		local ipos = armatureBack:getTag()
		
		local pFightParm = BaseSceneDB.GetPlayFightParm(ipos)
		
		if pFightParm.m_FightState == 1 then
		
			local pAction = armatureBack:getActionByTag(FightMoveIagID)
			if pAction ~= nil then
					
				--//判断距离
				if CheckDis_Stop(armatureBack) == true then
				
					pFightParm.m_FightState = 0
					armatureBack:stopAction(pAction)
					armatureBack:getAnimation():play(GetAniName_Player(armatureBack,Ani_Def_Key.Ani_stand))
					OnFightLogic(armatureBack)
					
				end
			end	
		else
			--[[
			--判断手动技能自动释放
			if IsNpc(ipos) == false  and id == GetAniName_Player(armatureBack,Ani_Def_Key.Ani_stand)  then
				if GetTeamData(ipos).m_engine >= 100 and m_bAutoFight == true then
					UseEngineSkill(ipos)
				end
			end
			--]]
			
		end				
		
	end		
end

function SetAnimationRes(ipos)
	
	local iTempResID = BaseSceneDB.GetTeamData(ipos).m_TempResid
	
	--print("SetAnimationRes(ipos): ipos:" .. ipos .. "iTempResID:" .. iTempResID)	
	
	
	local pAnimationfileName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationfileName")
	
	--print(pAnimationfileName)
	--Pause()
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)
	
	local pAnimationName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationName")
	
	--print(pAnimationName)
	--Pause()

	local pArmature = CCArmature:create(pAnimationName)
	
	BaseSceneDB.SetPlayArmature(ipos,pArmature)
	
	pArmature:setTag(ipos)
	
	local loadingBarBack = LoadingBar:create()
	loadingBarBack:setName("HP_LoadingBarBack")
	loadingBarBack:loadTexture("Image/Fight/UI/hpline_bg.png")
	loadingBarBack:setDirection(0)
	loadingBarBack:setTag(G_BloodBackTag)
	loadingBarBack:setPercent(100)		

	local loadingBarHp = LoadingBar:create()
	loadingBarHp:setName("HP_Loading")
	loadingBarHp:loadTexture("Image/Fight/UI/hpline.png")
	loadingBarHp:setDirection(0)
	loadingBarHp:setTag(G_BloodTag)
	loadingBarHp:setPercent(100)
	
	if BaseSceneDB.IsNpc(ipos) == true then
		loadingBarHp:setScaleX(-(loadingBarHp:getScaleX()))
		loadingBarHp:loadTexture("Image/Fight/UI/hpline_npc.png")
	end
	
	
	--pArmature:addChild(loadingBarBack,100)
	--pArmature:addChild(loadingBarHp,111)
	
	--跟头顶骨骼绑定
	
	local bone  = CCBone:create("HP_LoadingBarBack")		
	bone:addDisplay(loadingBarBack, 0)
	bone:changeDisplayWithIndex(0, true)
	bone:setIgnoreMovementBoneData(true)
	bone:setZOrder(100)
	bone:setTag(G_BloodBackBoneTag)
	pArmature:addBone(bone, "xuetiao")
	
	
	bone  = CCBone:create("HP_Loading")		
	bone:addDisplay(loadingBarHp, 0)
	bone:changeDisplayWithIndex(0, true)
	bone:setIgnoreMovementBoneData(true)
	bone:setZOrder(111)
	bone:setTag(G_BloodBoneTag)
	pArmature:addBone(bone, "xuetiao")	
			
		
	pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand)) 
	
	pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	
	
	--//数据
	--print("数据 ipos = " .. ipos)
	--Pause()
	local pFightParm = BaseSceneDB.GetPlayFightParm(ipos)
	local pTeamData  = BaseSceneDB.GetTeamData(ipos)
	
	pFightParm.m_FightPos = ipos
	
	--print("ObjTable[ipos].ObjFightDataParm.m_FightPos= " .. ObjTable[ipos].ObjFightDataParm.m_FightPos)
	--Pause()
	
	pFightParm.m_imageID = iTempResID
	
	pFightParm.m_FightPosType = pTeamData.m_FightPosType
	pFightParm.m_AttackDis = pTeamData.m_Dis
	
	local rect
	rect = pArmature:boundingBox()	
	
	pFightParm.m_Mode_Height = rect.size.height;
	pFightParm.m_Mode_Width  = rect.size.width;
	
	--printTab(ObjTable[ipos].ObjFightDataParm)
	--Pause()
	
	--loadingBarBack:setPosition(ccp(0,rect.size.height))
	--loadingBarHp:setPosition(ccp(0,rect.size.height))	
		
	return pArmature
		
end


local function onHufaMovementEvent(armatureBack,movementType,movementID)
		
	if movementType == MovementEventType.start	then				
			
	elseif movementType == MovementEventType.complete then				
		armatureBack:setVisible(false)
		
	elseif movementType == MovementEventType.loopComplete then			
		
	end		
end
	
local function onHufaFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
	if evt == FrameEvent_Key.Event_attack then
	
	   local pArmature = bone:getArmature()

			if pArmature ~= nil then
			
				local iIndex = pArmature:getTag() - Fight_hufa_TagID_Root
				
				local pFightParm = BaseSceneDB.GetHufaFightParm(iIndex)
				pFightParm.m_Curbone = bone
							
				--判断手动技能效果解除				
				if pFightParm.m_bUseingEngineSkill == true then
					--Pause()
					pFightParm.m_bUseingEngineSkill = false
					ResumeAllAnimation(pArmature)
					ResumeAllEffect()
				
				end
				--增加护法的技能播放逻辑
				PlayEffectMage_Hufa(iIndex)
			
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
		
			local ipos = pArmature:getTag()				
			CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Normal)					
					
		end	
	else
	   
	end
end

function SetHufaAnimationRes(iIndex)

	local iTempResID = BaseSceneDB.GethufaData(iIndex).m_TempResid	
	local pAnimationfileName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationfileName")	

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)
	
	local pAnimationName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationName")	

	local pArmature = CCArmature:create(pAnimationName)
	
	BaseSceneDB.SetHufaArmature(iIndex,pArmature)
	
	pArmature:setTag(Fight_hufa_TagID_Root+iIndex)
		
	---敌对翻转
	if iIndex > 1 then
		pArmature:setScaleX(-(pArmature:getScaleX()))
	end		
	pArmature:getAnimation():setFrameEventCallFunc( onHufaFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onHufaMovementEvent)
	
	
	--//数据
	--print("数据 ipos = " .. ipos)
	--Pause()
	local pFightParm = BaseSceneDB.GetHufaFightParm(iIndex)
	local pHufaData  = BaseSceneDB.GethufaData(iIndex)
	
	pFightParm.m_FightPos = iIndex + Fight_hufa_TagID_Root
	
	--print("ObjTable[ipos].ObjFightDataParm.m_FightPos= " .. ObjTable[ipos].ObjFightDataParm.m_FightPos)
	--Pause()
	
	pFightParm.m_imageID = iTempResID
	
	pFightParm.m_FightPosType = pHufaData.m_FightPosType
	pFightParm.m_AttackDis = pHufaData.m_Dis
	
	local rect
	rect = pArmature:boundingBox()	
	
	pFightParm.m_Mode_Height = rect.size.height;
	pFightParm.m_Mode_Width  = rect.size.width;
	
	--printTab(ObjTable[ipos].ObjFightDataParm)
	--Pause()
		
	return pArmature		
	
end

function PAuseAllAnimation( pArmature )

	if m_UseingEngineSkillStopTimes <= 0 then 
	
		ShowBlackLayer(true)
		
	end	
	
	m_Stack_UseingEngineSkill:PushStack(pArmature)	
	
	m_UseingEngineSkillStopTimes = m_UseingEngineSkillStopTimes+1	
	
	
	
	--print("PAuseAllAnimation: m_UseingEngineSkillStopTimes = " .. m_UseingEngineSkillStopTimes)
	
	if BaseSceneDB.IsPKScene() == true then
		local i = 1
		local pPlayArmature = nil
		
		for i=1, MaxTeamPlayCount*2, 1 do
				
			pPlayArmature = BaseSceneDB.GetPlayArmature(i)
			
			if pPlayArmature ~= nil then
			
				if 	pPlayArmature ~= pArmature then 			
					pPlayArmature:setColor(BlackLayerColour3)
					SetAnimationUiColour(pPlayArmature,BlackLayerColour3)
					pauseSchedulerAndActions(pPlayArmature)
				end				
			end			
					
		end
	else
		local i = 1
		local pPlayArmature = nil
		
		for i=1, MaxTeamPlayCount, 1 do
				
			pPlayArmature = BaseSceneDB.GetPlayArmature(i)
			
			if pPlayArmature ~= nil then
			
				if 	pPlayArmature ~= pArmature then 	
				
					pPlayArmature:setColor(BlackLayerColour3)
					SetAnimationUiColour(pPlayArmature,BlackLayerColour3)	
					pauseSchedulerAndActions(pPlayArmature)
				end				
			end
			
			local iNPcPos = i+MaxTeamPlayCount*BaseSceneDB.GetCurTimes()
			pPlayArmature = BaseSceneDB.GetPlayArmature(iNPcPos)
			if pPlayArmature ~= nil then
			
				pPlayArmature:setColor(BlackLayerColour3)
				SetAnimationUiColour(pPlayArmature,BlackLayerColour3)
				pauseSchedulerAndActions(pPlayArmature)
			end
					
		end	
	end
	
	--护法 				
	local pPlayArmature = BaseSceneDB.GetHufaArmature(1)			
	if pPlayArmature ~= nil then
	
		if 	pPlayArmature ~= pArmature then 	
		
			pPlayArmature:setColor(BlackLayerColour3)
				
			pauseSchedulerAndActions(pPlayArmature)
		end				
	end
	
	local iNPcIndex = 1+BaseSceneDB.GetCurTimes()			
	pPlayArmature = BaseSceneDB.GetHufaArmature(iNPcIndex)
	if pPlayArmature ~= nil then
		
		if 	pPlayArmature ~= pArmature then 	
		
			pPlayArmature:setColor(BlackLayerColour3)
				
			pauseSchedulerAndActions(pPlayArmature)
		end						
	end		
		
	PAuseAllEffect()
end

function IsShowBlackLayer()
	if m_UseingEngineSkillStopTimes <= 0 then 
		return false
	else
		return true
	end
end

function ShowBlackLayer(bShow)

	if bShow == true then
	
			
		m_pBaseScene:Get_BlackLayer():setOpacity(200)
		m_pBaseScene:SetUIColour(BlackLayerColour3)

		m_pBaseScene:Get_Layer_Root():retain()
		m_pBaseScene:Get_Layer_Root():removeFromParentAndCleanup(false)
		local x = m_pBaseScene:Get_GameNode_Middle():getPositionX() - CommonData.g_Origin.x
		local y = m_pBaseScene:Get_GameNode_Middle():getPositionY() + CommonData.g_Origin.y
		m_pBaseScene:Get_Layer_Root():setPositionX(x)
		m_pBaseScene:Get_Layer_Root():setPositionY(y)	
		m_pBaseScene:Get_UILayer():addChild(m_pBaseScene:Get_Layer_Root(),-1)
	
	else
	
		m_pBaseScene:Get_BlackLayer():setOpacity(0)
		m_pBaseScene:SetUIColour(BlackLayerColourNor3)
		m_pBaseScene:Get_Layer_Root():removeFromParentAndCleanup(false)
		m_pBaseScene:Get_Layer_Root():setPositionX(0)	
		m_pBaseScene:Get_Layer_Root():setPositionY(0)
		m_pBaseScene:Get_GameNode_Middle():addChild(m_pBaseScene:Get_Layer_Root(),Layer_Root_Z)
		m_pBaseScene:Get_Layer_Root():release()
	end
	
end

function ResumeAllAnimation(pArmature)

	local pPauseArmature =  m_Stack_UseingEngineSkill:PopStack()
	if pPauseArmature ~= nil then 
		
		if pArmature ~= pPauseArmature then 		
			
			m_Stack_UseingEngineSkill:empty_Stack(pArmature)	
			m_Stack_UseingEngineSkill:PushStack(pPauseArmature)			
			m_UseingEngineSkillStopTimes = m_UseingEngineSkillStopTimes-1				
			return
		else		
		end
	else		
	end

	m_UseingEngineSkillStopTimes = m_UseingEngineSkillStopTimes-1
	--print("ResumeAllAnimation: m_UseingEngineSkillStopTimes = " .. m_UseingEngineSkillStopTimes)	

	if m_UseingEngineSkillStopTimes <= 0 then		
		ShowBlackLayer(false)
		if BaseSceneDB.IsPKScene() == true then
			
			local i = 1
			local pPlayArmature = nil
			local pFightDataParmTar = nil
			
			for i=1, MaxTeamPlayCount*2, 1 do
			
				pPlayArmature = BaseSceneDB.GetPlayArmature(i)
				pFightDataParmTar = BaseSceneDB.GetPlayFightParm(i)
				if pPlayArmature ~= nil then			
				
					pPlayArmature:setColor(BlackLayerColourNor3)
					SetAnimationUiColour(pPlayArmature,BlackLayerColourNor3)
					
					if pFightDataParmTar.m_buff_state ~= nil then
						
						if  pFightDataParmTar.m_buff_state == DamageState.E_DamageState_bingdong then 
							
							pauseSchedulerAndActions(pPlayArmature)
						else							
							resumeSchedulerAndActions(pPlayArmature)
						end
						
					else						
						resumeSchedulerAndActions(pPlayArmature)
					end
										
				end	
				
			end
			
		else
			local i = 1
			local pPlayArmature = nil
			local pFightDataParmTar = nil
			for i=1, MaxTeamPlayCount, 1 do
			
				pPlayArmature = BaseSceneDB.GetPlayArmature(i)
				pFightDataParmTar = BaseSceneDB.GetPlayFightParm(i)
				if pPlayArmature ~= nil then			
				
					pPlayArmature:setColor(BlackLayerColourNor3)					
					SetAnimationUiColour(pPlayArmature,BlackLayerColourNor3)
					if pFightDataParmTar.m_buff_state ~= nil then
						
						if pFightDataParmTar.m_buff_state == DamageState.E_DamageState_bingdong then 
							
							pauseSchedulerAndActions(pPlayArmature)
						else
							resumeSchedulerAndActions(pPlayArmature)
						end
						
					else						
						resumeSchedulerAndActions(pPlayArmature)
					end
					
				end		

				local iNPcPos = i+MaxTeamPlayCount*BaseSceneDB.GetCurTimes()
				pPlayArmature = BaseSceneDB.GetPlayArmature(iNPcPos)
				pFightDataParmTar = BaseSceneDB.GetPlayFightParm(iNPcPos)
				if pPlayArmature ~= nil then
				
					pPlayArmature:setColor(BlackLayerColourNor3)	
					SetAnimationUiColour(pPlayArmature,BlackLayerColourNor3)
					if pFightDataParmTar.m_buff_state ~= nil then
						
						if  pFightDataParmTar.m_buff_state == DamageState.E_DamageState_bingdong then 
							--print("pauseSchedulerAndActions")
							
							pauseSchedulerAndActions(pPlayArmature)
							--Pause()
						else							
							resumeSchedulerAndActions(pPlayArmature)
						end
						
					else						
						resumeSchedulerAndActions(pPlayArmature)
					end			
				end
			end
		end
		
		
		--护法 				
		local pPlayArmature = BaseSceneDB.GetHufaArmature(1)			
		if pPlayArmature ~= nil then
		
			local pFightDataParm = BaseSceneDB.GetHufaFightParm(1)

			if pFightDataParm.m_bUseingEngineSkill == false then
			
				pPlayArmature:setColor(BlackLayerColourNor3)
					
				resumeSchedulerAndActions(pPlayArmature)
			end				
		end
		
		local iNPcIndex = 1+BaseSceneDB.GetCurTimes()			
		pPlayArmature = BaseSceneDB.GetHufaArmature(iNPcIndex)
		if pPlayArmature ~= nil then
			
			local pFightDataParm = BaseSceneDB.GetHufaFightParm(iNPcIndex)
			if pFightDataParm.m_bUseingEngineSkill == false then
			
				pPlayArmature:setColor(BlackLayerColourNor3)
					
				resumeSchedulerAndActions(pPlayArmature)
			end						
		end		
		
		ResumeAllEffect()
		
	else
		
		pPauseArmature =  m_Stack_UseingEngineSkill:PopStack()
		
		if pPauseArmature ~= nil then 
			m_Stack_UseingEngineSkill:PushStack(pPauseArmature)
			pPauseArmature:setColor(BlackLayerColourNor3)	
			SetAnimationUiColour(pPauseArmature,BlackLayerColourNor3)
			resumeSchedulerAndActions(pPauseArmature)
		else
			--print("111111111111111111112222222222222222222222")
			--Pause()
		end
			
	end	
end

function PAuseAllEffect()

	local count = 0
	local pArray = m_pBaseScene:Get_DamageLayer():getChildren()
	
	if pArray ~= nil then
	
		count = pArray:count()
	end

	local pArmature = nil
	local i = 0
	for i = 0, count-1, 1 do 
	
		pArmature = tolua.cast(pArray:objectAtIndex(i), "CCNode")		
		--pArmature:pauseSchedulerAndActions()
		pauseSchedulerAndActions(pArmature)
		
	end
end

function ResumeAllEffect()

	local count = 0
	local pArray = m_pBaseScene:Get_DamageLayer():getChildren()
	if pArray ~= nil then
	
		count = pArray:count()
	end

	local pArmature = nil
	local i = 0
	for i = 0, count-1, 1 do 
	
		pArmature = tolua.cast(pArray:objectAtIndex(i), "CCNode")		
		--pArmature:resumeSchedulerAndActions()
		resumeSchedulerAndActions(pArmature)
		
	end	
end

--暂停
function OnPause()
	
	CCDirector:sharedDirector():pause()
		
end
--恢复
function OnResum()

	CCDirector:sharedDirector():resume()
		
end


--震屏效果
function VibrationSceen(iTimes)

	--print("VibrationSceen")	
	local go = CCMoveBy:create(0.05, ccp(0,-15) )
	--local go = CCMoveBy:create(0.02, ccp(6,0) )
	local goBack = go:reverse()		
	local arr = CCArray:create()
	arr:addObject(go)
	arr:addObject(goBack)		
	local i=1	
	for i=1, iTimes, 1 do		
		arr:addObject(go:copy():autorelease())
		arr:addObject(goBack:copy():autorelease())		
	end	
	
	local seq = CCSequence:create(arr)
	
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	
	runningScene:runAction( (seq ))	
end

function UseEngineSkill(iPos)
	
	if BaseSceneDB.IsPKScene() == true then
		if BaseSceneDB.GetFightEnd() == false then
				
			local itarpos = GetFightTarPos(iPos)

			if itarpos>0 then	
				
				--判断死了没
				if BaseSceneDB.IsDie(iPos) == true then
					return
				end
						
				local pFightArmature = BaseSceneDB.GetPlayArmature(iPos)
				local pFightDataParm = BaseSceneDB.GetPlayFightParm(iPos)
				
				local  pAction = pFightArmature:getActionByTag(FightTimeIagID)
				
				if pAction ~= nil then		
					
					pFightArmature:stopAction(pAction)
					
				end
					
				if pFightDataParm.m_FightState == 1 then
			
					local  pActionMove = pFightArmature:getActionByTag(FightMoveIagID)
					if pActionMove ~= nil then
					
						pFightArmature:stopAction(pActionMove)	
						pFightDataParm.m_FightState = 0	
					else
						print("pActionMove == nil, iPos = " .. iPos)						
					end					
				end								
				
				
				pFightDataParm.m_iTarpos = itarpos						
											
				pFightArmature:setColor(BlackLayerColourNor3)				
				SetAnimationUiColour(pFightArmature,BlackLayerColourNor3)
				resumeSchedulerAndActions(pFightArmature)
				
				OnFightDamageLogic(pFightDataParm,pFightDataParm.m_iTarpos,true)
				
				PlayAttack(pFightArmature,pFightDataParm.m_iSkill)	
				
				PAuseAllAnimation(pFightArmature)
				--resumeSchedulerAndActions(pFightArmature)
				SetFight(pFightArmature,pFightDataParm.m_CdTime)
				
			end	
		end
		
		
	else
		if BaseSceneDB.IsNpc(iPos) == false and BaseSceneDB.GetFightEnd() == false then
	
			local itarpos = BaseSceneDB.GetEngineSkillTar()
			
			if itarpos < 0 then
				itarpos = GetFightTarPos(iPos)
			end

			if itarpos>0 then	
			
				--判断死了没
				if BaseSceneDB.IsDie(iPos) == true then
					return
				end
										
				local pFightArmature = BaseSceneDB.GetPlayArmature(iPos)
				local pFightDataParm = BaseSceneDB.GetPlayFightParm(iPos)
				
				--//时间有问题
				local  pAction = pFightArmature:getActionByTag(FightTimeIagID)
				if pAction ~= nil then						
					pFightArmature:stopAction(pAction)	
				end
					
				if pFightDataParm.m_FightState == 1 then
			
					local  pActionMove = pFightArmature:getActionByTag(FightMoveIagID)
					if pActionMove ~= nil then
					
						pFightArmature:stopAction(pActionMove)	
						pFightDataParm.m_FightState = 0
					else
						print("pActionMove == nil, iPos = " .. iPos)						
					end						
				end				
				-------手动技能目标以后改成选择----------
				pFightDataParm.m_iTarpos = itarpos						
										
				pFightArmature:setColor(BlackLayerColourNor3)	
				SetAnimationUiColour(pFightArmature,BlackLayerColourNor3)
				resumeSchedulerAndActions(pFightArmature)				
				OnFightDamageLogic(pFightDataParm,pFightDataParm.m_iTarpos,true)				
				PlayAttack(pFightArmature,pFightDataParm.m_iSkill)				
				PAuseAllAnimation(pFightArmature)	
				--resumeSchedulerAndActions(pFightArmature)				
				SetFight(pFightArmature,pFightDataParm.m_CdTime)
				
			end	
		end
	end
	
end










