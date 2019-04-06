
--基本场景需求

module("BaseScene", package.seeall)

require "Script/Fight/BaseSceneDB"
require "Script/Fight/BaseSceneLogic"

--require "Script/Login/LoadingLayer"	
require "Script/Login/LoadingNewLayer"	
--require "Script/Login/LoadingFightLayer"

--测试用
require "Script/Fight/TestScence"

G_BaseScene = {}

---场景层指针
local m_FightScene = nil
local m_pGameScene = nil
local m_pGameNode_Back = nil
local m_pGameNode_Middle = nil
local m_pGameNode_Front = nil

local m_Layer_Root = nil
local m_DamageLayer = nil
local m_UILayer = nil
local m_BlackLayer = nil
local m_pFightResultManager = nil


--增加选中光环	
local m_pArmatureSelect = nil			

--战斗ui接口
local	UI_pclearEnemy 				= 	FightUILayer.clearEnemy
local	UI_paddEnemyInfo 			= 	FightUILayer.addEnemyInfo
local	UI_psetDefaultTag 			=	FightUILayer.setDefaultTag
local	UI_pSetFightDelayTime 		= 	FightUILayer.SetFightDelayTime
local	UI_pStopFightDelayTime 		=	FightUILayer.StopFightDelayTime
local	UI_pContinueFightDelayTime 	=	FightUILayer.ContinueFightDelayTime
local	UI_pSetFightTitleAround 	=	FightUILayer.SetFightTitleAround
local	UI_pSetFightHp 				=	FightUILayer.SetFightHp
local	UI_pSetFightPower 			=	FightUILayer.SetFightPower
local	UI_psetHuFaInfo 			=	FightUILayer.setHuFaInfo
local	UI_penemyDeadth 			=	FightUILayer.enemyDeadth
local	UI_psetHuFaInfo 			=	FightUILayer.setHuFaInfo
local	UI_pSetFightTitleMoney 		=	FightUILayer.SetFightTitleMoney
local	UI_pSetFightTitleBox 		=	FightUILayer.SetFightTitleBox
local	UI_pCreateFightUILayer 		=	FightUILayer.CreateFightUILayer
local	UI_psetFightContrlColor 	=	FightUILayer.setFightContrlColor

local	UI_pBeginFightByUI	 		=	FightUILayer.BeginFightByUI
local	UI_pEndFightByUI		 	=	FightUILayer.EndFightByUI

local	UI_pSetPauseEnabled			= FightUILayer.SetPauseEnabled

--战斗结果接口
local	UI_Res_pShowResultDly			= 	FightResultLayer.ShowResultDly
local	UI_Res_pSetFightData 			= 	FightResultLayer.SetFightData
local	UI_Res_pSetFightStar 			= 	FightResultLayer.SetFightStar
local	UI_Res_pSetFightName 			= 	FightResultLayer.SetFightName
local	UI_Res_pSetAwardItem 			= 	FightResultLayer.SetAwardItem
local	UI_Res_psetFightSeeData 		= 	FightResultLayer.setFightSeeData
local	UI_Res_pInitFightResultDlg 		= 	FightResultLayer.InitFightResultDlg
local	UI_Res_pSetFightAwardId 		= 	FightResultLayer.SetFightAwardId

--add by sxin 单挑的界面
local 	UI_Res_pInitCityWarSingleResultDlg  = FightResultLayer.InitCityWarSingleResultDlg
local	UI_Res_pShowCityWarSingleResultDly	= 	FightResultLayer.ShowCityWarSingleResultDly

--Loading 界面接口
local	UI_Loading_Show 			= 	LoadingNewLayer.ShowLoading--LoadingLayer.Show
local	UI_Loading_SetResTable 		= 	LoadingNewLayer.SetLoadResTable--LoadingLayer.SetResTable
local	UI_Loading_GetLoadingUI 	= 	LoadingNewLayer.GetLoadingLayerUI--LoadingLayer.GetLoadingUI
local	UI_Loading_SetCallBackFun 	= 	LoadingNewLayer.SetFCallBack--LoadingLayer.SetCallBackFun



local m_bInit = false

local function GetFightLoadingRes()
	
	local tableRes = {}
	
	local i = 1
	local pTeamData = nil
	local index = 1
	for i=1, MaxTeamPlayCount*4 , 1 do	
		pTeamData = BaseSceneDB.GetTeamData(i)
		if pTeamData ~= nil then 
			
			if pTeamData.m_TempResid ~= -1 then	
			
				tableRes[index]	 = AnimationData.getFieldByIdAndIndex(pTeamData.m_TempResid,"AnimationfileName")
				index = index + 1
				
				--加载特效文件
				local j=1
				for j=1 , 3, 1 do
										
					local  iEffectID = tonumber(SkillData.getFieldByIdAndIndex(pTeamData.m_SkillData[j].m_skillresid,"Effectid_hit")) 
					
					if iEffectID >0 then 														
						tableRes[index]	 = EffectData.getFieldByIdAndIndex(iEffectID,"fileName") 
						index = index + 1						
					end
					
					local  iEffectID = tonumber(SkillData.getFieldByIdAndIndex(pTeamData.m_SkillData[j].m_skillresid,"Effectid_bullet"))
					
					if iEffectID >0 then 														
						tableRes[index]	 = EffectData.getFieldByIdAndIndex(iEffectID,"fileName") 
						index = index + 1						
					end				
					
				end				
				
			end	
		end
	end
	
	--加载场景文件
	--local Scene_Data = SceneData.getDataById( BaseSceneDB.GetScenceID() )	
	--tableRes[index]	 = Scene_Data[SceneData.getIndexByField("ScenceFileName")]
	--index = index + 1
	--printTab(tableRes)
	--Pause()
	return tableRes
end

local function AddLoadingUI()
			
	local function CallBack( ... )	
		--显示战斗界面
		if InitFightScene()	== true then 
			SetFightTimer(0.2,E_FightTimer.E_FightTimer_SceneEnter)	
		else
			SetFightTimer(0.2,E_FightTimer.E_FightTimer_TestSceneEnter)	
		end
	end

	UI_Loading_SetResTable(GetFightLoadingRes())
	local layerTemp = UI_Loading_GetLoadingUI(LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil)
	local bCloseDoor = false 
	if layerTemp:getParent()~=nil then
		layerTemp:retain()
		layerTemp:removeFromParentAndCleanup(true)
		bCloseDoor = true
	end
	m_FightScene:addChild(layerTemp, UILoading_Z, layerLoading_Tag)
	if bCloseDoor == true then
		layerTemp:release()
	end
	--UI_Loading_Show(true)
	UI_Loading_Show(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil,false)
	UI_Loading_SetCallBackFun(CallBack)
	
end


--[[
local function AddLoadingUI()
		
	local layerTemp = UI_Loading_GetLoadingUI()
	m_FightScene:addChild(layerTemp, 10, layerLoading_Tag)
	UI_Loading_Show(true)
	UI_Loading_SetLoadingInfo(0)
	
	--InitFightScene()	
	--PlayerEnterScene()
	
end
-]]

function SetUi_EnemyInfo( times )

	--清除集火目标
	UI_pclearEnemy()
	local iCount = 0
	local iNpcPos = -1
	local i = 1	
	for i=1, MaxTeamPlayCount, 1 do
			
		iNpcPos = i + MaxTeamPlayCount*times
		
		if BaseSceneDB.IsUser(iNpcPos) == true then 
			
			--设置集火目标Ui
			local pNpcTeamData = BaseSceneDB.GetTeamData(iNpcPos)
			local iColour = 1
			
			if BaseSceneDB.IsPKScene() == true then 
				iColour  = general.getFieldByIdAndIndex(pNpcTeamData.m_TempID,"Colour")	
			else
				iColour  = monst.getFieldByIdAndIndex(pNpcTeamData.m_TempID,"Colour")
			end			
					
			local ImagefileName_Head = AnimationData.getFieldByIdAndIndex(pNpcTeamData.m_TempResid,"ImagefileName_Head")			

			UI_paddEnemyInfo(iNpcPos, pNpcTeamData.m_level, ImagefileName_Head, iColour)	
			
			if iCount == 0 then 
				UI_psetDefaultTag(iNpcPos)
				BaseSceneDB.SetEngineSkillTar(iNpcPos)
				iCount = 1
			end	
		end		
	end		
end


--开始战斗前出发脚本传入次数
function StarFight()
	UI_pBeginFightByUI()
	--战斗界面调用
	UI_pSetFightDelayTime(FightTimeMax)
	
	BaseSceneDB.SetFightEnd(false)
	
	local iNpcPos = -1
	local i = 1
	local DelayPlay = 0
	local DelayNpc = 0
	local pArmature = nil
	
	for i=1, MaxTeamPlayCount, 1 do
	
		pArmature = BaseSceneDB.GetPlayArmature(i)
		if  pArmature ~= nil then
			
			BaseSceneLogic.SetFight(pArmature,FightStarTimeinterval+ DelayPlay*0.2)	
			--DelayPlay = DelayPlay + 1
		end		

	end		
	--护法逻辑
	local pHufaArmature = nil
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1)	
	if pHufaArmature ~= nil then 
		BaseSceneLogic.SetHufaFight(pHufaArmature,Fight_hufa_Time)
	end
	
	
	
	for i=1, MaxTeamPlayCount, 1 do
		
		iNpcPos = i + MaxTeamPlayCount*BaseSceneDB.GetCurTimes()
		
		pArmature = BaseSceneDB.GetPlayArmature(iNpcPos)
				
		if pArmature ~= nil then
						
			BaseSceneLogic.SetFight(pArmature,FightStarTimeinterval+ DelayNpc*0.2)	
			
		end	
		
	end
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1+BaseSceneDB.GetCurTimes())	
	if pHufaArmature ~= nil then 
		BaseSceneLogic.SetHufaFight(pHufaArmature,Fight_hufa_Time)
	end	
end

function EndFight()

	--print("EndFight")
	UI_pEndFightByUI()
	--Pause()
	BaseSceneDB.SetFightEnd(true)
	local i = 1
	local pArmature = nil
	
	
	for i=1, MaxTeamPlayCount, 1 do
	
		pArmature = BaseSceneDB.GetPlayArmature(i)
		if  pArmature ~= nil then
			
			pArmature:stopActionByTag(FightTimeIagID)			
			BaseSceneLogic.SetAnimationUiVisible(pArmature,false)
		end
		
		iNpcPos = i + MaxTeamPlayCount*BaseSceneDB.GetCurTimes()
		
		pArmature = BaseSceneDB.GetPlayArmature(iNpcPos)
				
		if pArmature ~= nil then
						
			pArmature:stopActionByTag(FightTimeIagID)			
			BaseSceneLogic.SetAnimationUiVisible(pArmature,false)
			
		end	

	end		
	
	
	--护法逻辑
	local pHufaArmature = nil
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1)	
	if pHufaArmature ~= nil then 
		pHufaArmature:stopActionByTag(FightTimeIagID)	
	end
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1+BaseSceneDB.GetCurTimes())	
	if pHufaArmature ~= nil then 
		pHufaArmature:stopActionByTag(FightTimeIagID)	
	end
	
	UI_pStopFightDelayTime()
	
	if BaseSceneDB.GetFightResult() == 1 then
		if BaseSceneDB.GetCurTimes() < BaseSceneDB.GetAllTimes() then			
			SetFightTimer(ApplyFightTime,E_FightTimer.E_FightTimer_ApplyFight)			
		else						
			SetFightTimer(ShowCheersTime,E_FightTimer.E_FightTimer_PlayCheers)
		end
	elseif BaseSceneDB.GetFightResult() == 0 then
	---失败
		if BaseSceneDB.IsPKScene() == true then
			SetFightTimer(ShowCheersTime,E_FightTimer.E_FightTimer_PlayCheers)
		else			
			SetFightTimer(ShowFightResoutTime,E_FightTimer.E_FightTimer_ShowFightResout)
		end
	end	
	
	

end

function PauseFight()
	
	local i = 1
	local pArmature = nil
	for i=1, MaxTeamPlayCount, 1 do
	
		pArmature = BaseSceneDB.GetPlayArmature(i)
		if  pArmature ~= nil then
			
			pArmature:stopActionByTag(FightTimeIagID)			
			BaseSceneLogic.SetAnimationUiVisible(pArmature,false)
		end
		
		iNpcPos = i + MaxTeamPlayCount*BaseSceneDB.GetCurTimes()
		
		pArmature = BaseSceneDB.GetPlayArmature(iNpcPos)
				
		if pArmature ~= nil then
						
			pArmature:stopActionByTag(FightTimeIagID)			
			BaseSceneLogic.SetAnimationUiVisible(pArmature,false)
			
		end	

	end		
	
	
	--护法逻辑
	local pHufaArmature = nil
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1)	
	if pHufaArmature ~= nil then 
		pHufaArmature:stopActionByTag(FightTimeIagID)	
	end
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1+BaseSceneDB.GetCurTimes())	
	if pHufaArmature ~= nil then 
		pHufaArmature:stopActionByTag(FightTimeIagID)	
	end
	
	--暂停计时器
	UI_pStopFightDelayTime()		

end

function ContinueFight()
	
	--战斗界面调用
	UI_pContinueFightDelayTime()
			
	local iNpcPos = -1
	local i = 1
	local DelayPlay = 0
	local DelayNpc = 0
	local pArmature = nil
	
	for i=1, MaxTeamPlayCount, 1 do
	
		pArmature = BaseSceneDB.GetPlayArmature(i)
		if  pArmature ~= nil then			
			BaseSceneLogic.SetFight(pArmature,FightStarTimeinterval+ DelayPlay*0.2)				
		end
		
		iNpcPos = i + MaxTeamPlayCount*BaseSceneDB.GetCurTimes()
		
		pArmature = BaseSceneDB.GetPlayArmature(iNpcPos)
				
		if pArmature ~= nil then
						
			BaseSceneLogic.SetFight(pArmature,FightStarTimeinterval+ DelayNpc*0.2)	
			
		end	

	end		
	--护法逻辑
	local pHufaArmature = nil
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1)	
	if pHufaArmature ~= nil then 
		BaseSceneLogic.SetHufaFight(pHufaArmature,Fight_hufa_Time)
	end
	
	pHufaArmature = BaseSceneDB.GetHufaArmature(1+BaseSceneDB.GetCurTimes())	
	if pHufaArmature ~= nil then 
		BaseSceneLogic.SetHufaFight(pHufaArmature,Fight_hufa_Time)
	end	
	
end



function ApplicationFight()
	
	BaseSceneDB.ClearEffectParm()
	PlaySceneEnter(BaseSceneDB.GetCurTimes())	
	BaseSceneDB.AddCurTimes()
	
end

function StarFight_SenenSprite()


	if BaseSceneDB.GetSceneScript():StarFight(BaseSceneDB.GetCurTimes()) == false then
		StarFight()
	end
end

function EndFight_SenenSprite()

	if BaseSceneDB.GetSceneScript():EndFight(BaseSceneDB.GetCurTimes()) == false then
		EndFight()
	end		
		
end



--跑图逻辑
function PlaySceneEnter(itimes)
	
	local function CB_PlaySceneEnter(pNode)
	
		--[[
		local i=1
		local pArmature = nil
		for i=1 , MaxTeamPlayCount, 1 do
			
			pArmature = BaseSceneDB.GetPlayArmature(i)
			
			if pArmature ~= nil then
			
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
			end		
		end				
		--]]
		StarFight_SenenSprite()
	end

	local pcallFunc = CCCallFuncN:create(CB_PlaySceneEnter)
	
	local pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance*0.5,0))
	local pMoveseq  = CCSequence:createWithTwoActions(pMoveBy, pcallFunc)

	m_pGameNode_Back:runAction(pMoveseq)	
	
	pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance,0))	
	m_pGameNode_Middle:runAction(pMoveBy)	

	pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance*1.5,0))	
	m_pGameNode_Front:runAction(pMoveBy)	
	
	local function DisActArriveToStand(pNode)
			
				local pArmature = tolua.cast(pNode, "CCArmature")
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
	end
	
	local i=1
	
	for i=1, MaxTeamPlayCount, 1 do
				
		local pArmature = BaseSceneDB.GetPlayArmature(i)
		if pArmature ~= nil and BaseSceneDB.IsDie(i) == false then
		
			if pArmature:getAnimation():getCurrentMovementID() ~= GetAniName_Player(pArmature,Ani_Def_Key.Ani_run) then
			
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))	
			end

		

			local fmoveDis = math.abs(pArmature:getPositionX()-( PlayBirthPoint[i].x + itimes*MaxMoveDistance))

			local fmoveTime = fmoveDis/MaxPlayMoveSpeed

			local pMoveTo = CCMoveTo:create(fmoveTime, ccp(PlayBirthPoint[i].x + itimes*MaxMoveDistance, PlayBirthPoint[i].y))
			
			

			local pcallFunc = CCCallFuncN:create(DisActArriveToStand)
			
			local pMoveseq  = CCSequence:createWithTwoActions(pMoveTo, pcallFunc)

			pArmature:runAction(pMoveseq)
					
		end	
		
		--npc 跑进场景
		local iNpc = i + (itimes+1)*MaxTeamPlayCount
		pArmature= BaseSceneDB.GetPlayArmature(iNpc)
		if pArmature ~= nil then
			
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))
			pArmature:setPositionX(pArmature:getPositionX() + MaxMoveDistance)
			pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance,0))
		
			--local pDelay = CCDelayTime:create(SceneEnterTime)
			
			local pcallFunc = CCCallFuncN:create(DisActArriveToStand)
			local pMoveseq  = CCSequence:createWithTwoActions(pMoveBy, pcallFunc)
			
			pArmature:runAction(pMoveseq)
		end
		
				
	end	
	
	UI_pSetFightTitleAround( (itimes+1) ,BaseSceneDB.GetAllTimes())

	SetUi_EnemyInfo(itimes+1)
end


function SetFightTimer(fTime, pData)

	
	local function OnFightTimer(pNode)
		
		
		if pNode == m_FightScene then
		
			
			if pNode:getTag() == E_FightTimer.E_FightTimer_ApplyFight then			
				
				if BaseSceneLogic.IsShowBlackLayer() == true then 
					SetFightTimer(ApplyFightTime,E_FightTimer.E_FightTimer_ApplyFight)	
				else
					ApplicationFight()
				end
				
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_PlayCheers then
				
				BaseSceneLogic.PlayCheers()	
				SetFightTimer(ShowFightResoutTime-ShowCheersTime,E_FightTimer.E_FightTimer_ShowFightResout)
				
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_ShowFightResout then
						
				if BaseSceneDB.IsCityWarSingleScene() == true then

					--单挑奖励待定
					--走国战的结算界面
					--CreateAtkWarResultLayer()
					local function Over_CallBack()
						
						LeaveBaseScene()
					end
					AddLabelImg(AtkCityResultLayer.CreateAtkWarResultLayer(2,Over_CallBack),100,m_UILayer)
				elseif BaseSceneDB.IsCityWarScene() == true then
					
					--无界面
					LeaveBaseScene()	

				elseif BaseSceneDB.IsCGScene() == true then	
					--设置回调？？
					LeaveBaseScene()	
					
				elseif BaseSceneDB.IsPKScene() == true then
					--比武胜利失败都有数据传入
					local pointname = point.getFieldByIdAndIndex(BaseSceneDB.GetpointID(),"Name")
					local rewardID = BaseSceneDB.GetBattleData_pk_RewardID()

					m_pFightResultManager:Fun_ExternalReferenceAndInitAttr( BaseSceneDB.GetFightResult(), G_BaseScene )

					if BaseSceneDB.GetFightResult() ==1 then

						m_pFightResultManager:Fun_ShowNormalWinResultLayer( m_UILayer, pointname, rewardID, BaseSceneDB.GetDropData(), BaseSceneDB.GetBattleFight_Star() )
					
					else

						m_pFightResultManager:Fun_ShowNormalFailiedResultLayer( m_UILayer, pointname, rewardID, BaseSceneDB.GetBattleFight_Star() )

					end

					local pBattleDamageList = FightbattleData.GetBattleFight_Damage_Data(BaseSceneDB.GetBattleID())
					m_pFightResultManager:Fun_SetFightOutPutData( pBattleDamageList )			
				
				else
					--副本
					local pointname = point.getFieldByIdAndIndex(BaseSceneDB.GetpointID(),"Name")

					m_pFightResultManager:Fun_ExternalReferenceAndInitAttr( BaseSceneDB.GetFightResult(), G_BaseScene )
				
					if BaseSceneDB.GetFightResult() ==1 then					
										
						--PlayCheers()--显示 金币 银币 经验	显示物品	
						local rewardID = tonumber(point.getFieldByIdAndIndex(BaseSceneDB.GetpointID(),"RewardID"))
						 
						m_pFightResultManager:Fun_ShowNormalWinResultLayer( m_UILayer, pointname, rewardID, BaseSceneDB.GetDropData(), BaseSceneDB.GetBattleFight_Star() )
						
					elseif BaseSceneDB.GetFightResult() ==0 then

						local rewardID = tonumber(point.getFieldByIdAndIndex(BaseSceneDB.GetpointID(),"RewardID"))
						 
						m_pFightResultManager:Fun_ShowNormalFailiedResultLayer( m_UILayer, pointname, rewardID, -1 )						
					end
					
					local pBattleDamageList = FightbattleData.GetBattleFight_Damage_Data(BaseSceneDB.GetBattleID())
					m_pFightResultManager:Fun_SetFightOutPutData( pBattleDamageList )
				
				end				
				
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_SceneEnter then	
				--Pause()
				UI_Loading_Show(false)
				PlayerEnterScene()	
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_TestSceneEnter then	
							
				UI_Loading_Show(false)
											
			end
			
			
		end
		
	end

	local pcallFunc = CCCallFuncN:create(OnFightTimer)
	
	local pDelay = CCDelayTime:create(fTime)
	
	local pSequence  = CCSequence:createWithTwoActions(pDelay, pcallFunc)
	
	m_FightScene:setTag(pData)
	m_FightScene:runAction(pSequence)
end


function UpFighterBlood(self,ipos)	
	
		
	local TeamData = BaseSceneDB.GetTeamData(ipos)
		
	local iPercent = TeamData.m_curblood*100/TeamData.m_allblood
	if iPercent > 100 then 
		iPercent = 100
	end
	
	if iPercent < 0 then 
		iPercent = 0
	end
	
	--local pHp = tolua.cast(BaseSceneDB.GetPlayArmature(ipos):getChildByTag(G_BloodTag),"LoadingBar") 
	
	local pbone = BaseSceneDB.GetPlayArmature(ipos):getChildByTag(G_BloodBoneTag)
	
	if pbone ~= nil then 
	
		local pHp = tolua.cast(pbone:getDisplayRenderNode(),"LoadingBar") 		
		
		if pHp ~= nil then 			
			pHp:setPercent(iPercent)	
		end
		
		--pbone:changeDisplayWithIndex(0, true)

		if BaseSceneDB.IsNpc(ipos) == false then
		
			UI_pSetFightHp(ipos,iPercent)
		end	
	
	else
		print("UpFighterBlood err")
		Pause()
	end
	
	
end 

function UpFighterEngine(self,ipos)

	if ipos > Fight_hufa_TagID_Root then 
		Pause()
		return
	end
	
	if BaseSceneDB.IsNpc(ipos) == false then
	
		local iPercent = BaseSceneDB.GetTeamData(ipos).m_engine	
		--print("UpFighterEngine ipos = " .. ipos .. "m_engine = " .. iPercent)		
		UI_pSetFightPower(ipos,iPercent)
	end
end

function UpHufaEngine(self)
	
	local pHufaData = BaseSceneDB.GetPlayerhufaData()
	if pHufaData ~= nil then
		UI_psetHuFaInfo(pHufaData.m_engine)
	end
end

function Die( self,DiePos , attackPos )	
	
	BaseSceneDB.GetSceneScript():Die(DiePos, attackPos)	
	if BaseSceneDB.IsNpc(DiePos) == true then 
	
		UI_penemyDeadth(DiePos)		
		if BaseSceneDB.GetEngineSkillTar() == DiePos then 
		
			--local iTar = BaseSceneLogic.GetFightTarPos(1)	
			local iTar = BaseSceneLogic.GetFightTarPos(attackPos)	
			UI_psetDefaultTag(iTar)
			BaseSceneDB.SetEngineSkillTar(iTar)
		end
	end
	
			
end

function Damage( self,iDamagePos )	
	
	BaseSceneDB.GetSceneScript():Damage(iDamagePos)	
				
end


--脚本创建--创建一个剧情角色 不参加战斗
function CreatPlayerNotFight(ipos,iTempID)

	local iTempResID = nil
	if BaseSceneDB.IsNpc(ipos) == false then
		iTempResID = tonumber(general.getFieldByIdAndIndex(iTempID, "ResID"))
	else
		iTempResID = tonumber(monst.getFieldByIdAndIndex(iTempID, "resID"))
	end
		
	local pAnimationfileName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationfileName")
			
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)
	
	local pAnimationName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationName")
	
	local pArmature = CCArmature:create(pAnimationName)
		
			
	pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand)) 	
	--pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)
	--pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)	

	if BaseSceneDB.IsNpc(ipos) == false then
		pArmature:setZOrder((1 - ipos%2)*10+ipos+1)	
		pArmature:setPosition(ccp(PlayBirthPoint[ipos].x,PlayBirthPoint[ipos].y))
	else
		pArmature:setScaleX(-(pArmature:getScaleX()))
		local iNpcPos = ipos%5
		pArmature:setZOrder((1 - iNpcPos%2)*10+iNpcPos)	
		pArmature:setPosition(ccp(EnemyBirthPoint[iNpcPos].x,EnemyBirthPoint[iNpcPos].y))
	end	
	
	m_Layer_Root:addChild( pArmature )		 
	
	return pArmature 	  	
end

--脚本创建--创建一个剧情角色 参加战斗
function CreatPlayer(ipos,itempID)

	local TeamData = nil
	local pArmature = nil
	
	if FightServer.CreatPlayData(ipos,itempID) == false then 
	
		return nil
		
	end
	
	TeamData = BaseSceneDB.GetTeamData(ipos)
	
	if TeamData ~= nil then 
		
		if TeamData.m_TempResid ~= -1 then
						
			local ImagefileName_Head = AnimationData.getFieldByIdAndIndex(TeamData.m_TempResid,"ImagefileName_Head")	
						
			pArmature = BaseSceneLogic.SetAnimationRes(ipos)
					
						
			local iColour = general.getFieldByIdAndIndex(TeamData.m_TempID,"Colour")
			
			pArmature:setZOrder((1 - ipos%2)*10+ipos+1)	
			pArmature:setPosition(ccp(PlayBirthPoint[ipos].x,PlayBirthPoint[ipos].y))
			
			UI_pSetFightHp(ipos,100,ImagefileName_Head,iColour)
					
			G_BaseScene:UpFighterEngine(ipos)
					
						
			--隐藏血条
			BaseSceneLogic.SetAnimationUiVisible(pArmature,false)
			m_Layer_Root:addChild( pArmature )		 
			
			return pArmature 			
		
		end
	end
  	
end

function InitPlayAndNpc()
		
	local i = 0
	local TeamData = nil
	local pArmature = nil
	for i=1, 20 , 1 do	
		TeamData = BaseSceneDB.GetTeamData(i)
		if TeamData ~= nil then 
			
			if TeamData.m_TempResid ~= -1 then
							
				local ImagefileName_Head = AnimationData.getFieldByIdAndIndex(TeamData.m_TempResid,"ImagefileName_Head")	
				
				
				
				pArmature = BaseSceneLogic.SetAnimationRes(i)
				
				-- add by sxin 没血了不显示
				if TeamData.m_curblood <= 0 then				
					pArmature:setVisible(false)
				end
				
				--add by sxin 怪物的放缩比例扩展
				if BaseSceneDB.IsPKScene() == false and BaseSceneDB.IsNpc(i) == true then
					
					local fScale = monst.getFieldByIdAndIndex(TeamData.m_TempID,"Scale")				
					pArmature:setScaleX(fScale*pArmature:getScaleX())
					pArmature:setScaleY(fScale*pArmature:getScaleY())
				
				end
				
				
				
				if i <= 5 then
				
					local iColour = general.getFieldByIdAndIndex(TeamData.m_TempID,"Colour")
					--print("InitPlayAndNpc: i=" .. i)
					pArmature:setZOrder((1 - i%2)*10+i+1)	
					pArmature:setPosition(ccp(PlayBirthPoint[i].x,PlayBirthPoint[i].y))
					
					UI_pSetFightHp(i,100,ImagefileName_Head,iColour)
					
					G_BaseScene:UpFighterEngine(i)
					
				
				elseif i<=10 then
					
					local iz = i - 5				
					pArmature:setZOrder((1 - iz%2)*10+iz)	
					pArmature:setScaleX(-(pArmature:getScaleX()))									
					pArmature:setPosition(ccp(EnemyBirthPoint[iz].x,EnemyBirthPoint[iz].y))
				
				elseif i<= 15 then
					
					local iz = i - 10				
					pArmature:setZOrder((1 - iz%2)*10+iz)	
					pArmature:setScaleX(-(pArmature:getScaleX()))					
					pArmature:setPosition(ccp(EnemyBirthPoint[iz].x + MaxMoveDistance,EnemyBirthPoint[iz].y))
					
				else
				
					local iz = i - 15				
					pArmature:setZOrder((1 - iz%2)*10+iz)	
					--???
					pArmature:setScaleX(-(pArmature:getScaleX()))
					
					pArmature:setPosition(ccp(EnemyBirthPoint[iz].x + 2*MaxMoveDistance,EnemyBirthPoint[iz].y))
				
				end
				
				G_BaseScene:UpFighterBlood(i)
				--隐藏血条
				BaseSceneLogic.SetAnimationUiVisible(pArmature,false)
				m_Layer_Root:addChild( pArmature )			
			
			end
		end
    end	
	
	----初始化护法
	local HufaData = nil
	for i=1, 4 , 1 do	
		HufaData = BaseSceneDB.GethufaData(i)
		if HufaData ~= nil and 	HufaData.m_TempResid ~= -1 then
				--头像	
				if i == 1 then 
					local ImagefileName_Head = AnimationData.getFieldByIdAndIndex(HufaData.m_TempResid,"ImagefileName_Head")	
					local iColour = general.getFieldByIdAndIndex(HufaData.m_TempID,"Colour")
					UI_psetHuFaInfo(HufaData.m_engine,ImagefileName_Head,iColour)
				end	
				--加载护法资源
				pArmature = BaseSceneLogic.SetHufaAnimationRes(i)				
				pArmature:setZOrder(Fight_hufa_Z)	
				pArmature:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.5))
				pArmature:setVisible(false)					
				m_Layer_Root:addChild( pArmature )						
		end
		
	end
	
end

local function PlayerEnterScene_0()
	
	
	--[[
	local pArmature = nil
	local i=1
	for i=1 ,MaxTeamPlayCount,1 do
		
		pArmature = BaseSceneDB.GetPlayArmature(i)		
		--//玩家
		if pArmature ~= nil then			
			pArmature:setPositionX(pArmature:getPositionX() -MaxMoveDistance*0.5)			
		end
		
		--NPC--------------------------------------
		local iNpc = i + MaxTeamPlayCount
		pArmature = BaseSceneDB.GetPlayArmature(iNpc)
		if pArmature ~= nil then			
			pArmature:setPositionX(pArmature:getPositionX() + MaxMoveDistance*0.5)			
		end		

	end
	--]]
	UI_pSetFightDelayTime(FightTimeMax)
	UI_pStopFightDelayTime()
	UI_pSetFightTitleMoney(0)
	UI_pSetFightTitleBox(0)	
	UI_pSetFightTitleAround(1, BaseSceneDB.GetAllTimes())
	SetUi_EnemyInfo(1)
end

---修改进入方式由脚本实现
function PlayerEnterScene()
	
	--[[
	local function CB_PlayerEnterScene(pNode)
			
		
		local i=1
		local pArmature = nil
		
		for i=1 , MaxTeamPlayCount, 1 do
			pArmature = BaseSceneDB.GetPlayArmature(i)
			if pArmature ~= nil then
			
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
			end		
			--NPC--------------------------------------
			local iNpc = i + MaxTeamPlayCount
			pArmature = BaseSceneDB.GetPlayArmature(iNpc)
			if pArmature ~= nil then
			
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
			end		
		end	
				
		StarFight_SenenSprite()	
	end

	local pcallFunc = CCCallFuncN:create(CB_PlayerEnterScene)
	BaseSceneLogic.SetNodeTimer(m_FightScene,SceneEnterTime*0.5,pcallFunc,0)

	local pMoveBy = nil
	local pArmature = nil
	local i=1
	for i=1 ,MaxTeamPlayCount,1 do
		
		pArmature = BaseSceneDB.GetPlayArmature(i)		
		--//玩家
		if pArmature ~= nil then
			
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))
			--pArmature:setPositionX(pArmature:getPositionX() -MaxMoveDistance*0.5)
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.5,ccp(MaxMoveDistance*0.5,0))	
			pArmature:runAction(pMoveBy)
		end
		
		--NPC--------------------------------------
		local iNpc = i + MaxTeamPlayCount
		pArmature = BaseSceneDB.GetPlayArmature(iNpc)
		if pArmature ~= nil then
			
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))
			--pArmature:setPositionX(pArmature:getPositionX() + MaxMoveDistance*0.5)
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.5,ccp(-MaxMoveDistance*0.5,0))	
			pArmature:runAction(pMoveBy)
		end
		

	end

	--]]
	
	BaseSceneDB.GetSceneScript():PlayerEnterScene()
	
end



function ClearData()
	m_FightScene = nil
	m_pGameScene = nil
	m_pGameNode_Back = nil
	m_pGameNode_Middle = nil
	m_pGameNode_Front = nil

	m_Layer_Root = nil
	m_DamageLayer = nil
	m_UILayer = nil
	m_BlackLayer = nil	
	m_pArmatureSelect:release()
	m_pArmatureSelect = nil	
	
	m_bInit = false	
end



function InitFightScene()

	--print(BaseSceneDB.GetScenceID())	
	local Scene_Data = SceneData.getDataById( BaseSceneDB.GetScenceID() )
	--print(Scene_Data[SceneData.getIndexByField("ScenceFileName")])
	
	m_pGameScene = SceneReader:sharedSceneReader():createNodeWithSceneFile(Scene_Data[SceneData.getIndexByField("ScenceFileName")])

	m_FightScene:addChild(m_pGameScene)

	m_pGameNode_Back = m_pGameScene:getChildByTag(G_FightScene_Layer_Back_TagID)

	m_pGameNode_Middle = m_pGameScene:getChildByTag(G_FightScene_Layer_Middle_TagID)

	m_pGameNode_Front = m_pGameScene:getChildByTag(G_FightScene_Layer_Front_TagID)
	
	m_Layer_Root = TouchGroup:create()

	m_DamageLayer = TouchGroup:create()
			
	m_UILayer = TouchGroup:create()
	
	m_FightScene:addChild(m_UILayer,UILayer_Z)
	--新的战斗结果管理
	m_pFightResultManager = FightResultLayer.Create()
	
	m_BlackLayer = CCLayerColor:create(BlackLayerColour4,1140*4,640)
	m_BlackLayer:setOpacity(0)
	m_Layer_Root:addChild(m_BlackLayer,0)
	
	m_pGameNode_Middle:addChild(m_Layer_Root,Layer_Root_Z)

	m_pGameNode_Middle:addChild(m_DamageLayer,EffectLayer_Z)	
	
	--创建选择光环
	local pEffectData = EffectData.getDataById(1)	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName")])	
	m_pArmatureSelect = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName")])	
	m_pArmatureSelect:setTag(G_SelectGuangquanTag)
	m_pArmatureSelect:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_0")]))
	m_pArmatureSelect:retain()	
	
	
	
	--测试用
	if TestScence.Test(G_BaseScene) == true then
		return false
	end
	
	
	--创建脚本
	
	local pSceneSprit = BaseSceneDB.CreateSceneScript()	
	pSceneSprit:Create(m_pGameScene,G_BaseScene)
	
	
	BaseSceneDB.GetSceneScript():Enter()
	
	
	---战场可以一样的ui也可以不一样
	if BaseSceneDB.IsPKScene() == true then
	
		-----pk要锁住自动施法
		BaseSceneDB.m_bAutoFight = true
		
		UI_pCreateFightUILayer(m_UILayer, G_BaseScene)
		
		-- add by sxin 根据不同的战斗区分结束界面
		if BaseSceneDB.IsCityWarScene() == true then		
			
			
		elseif BaseSceneDB.IsCityWarSingleScene() == true then
			
		else
			
		end
		
		InitPlayAndNpc()		
	else
		
		UI_pCreateFightUILayer(m_UILayer,G_BaseScene)		
		InitPlayAndNpc()	
		
	end	
	
	
	PlayerEnterScene_0()
	
	BaseSceneDB.GetSceneScript():EnterFinish()
		
	return true
end


function createBaseScene()
	
	if m_bInit == true then 
		return
	else
		m_bInit = true
	end
	
	local m_nHanderTime = nil
	local function NetUpdata(dt)
		UpNetWork()
	end	
	
	local function BaseSceneEvent(tag)
		if tag == "enter" then	
			--print("*************enter**************")
			--Scence_OnBegin()
			AddLoadingUI()	
			--InitFightScene()

			m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, CommonData.g_nNetUpdataTime, false)			
	

		end
		if tag == "enterTransitionFinish" then	
			--print("********enterTransitionFinish***************")		
			if CommonData.g_CountryWarLayer ~= nil then
				print("国战层已创建,挂接到战斗场景")
				require "Script/Main/CountryWar/CountryWarScene"
				--CommonData.g_CountryWarLayer:setVisible(false)
				CountryWarScene.ChangeCurParentNode(m_FightScene, 2)
			else
				print("国战层还未创建")
			end
		end	
		
		if tag == "exit" then	
			--print("********exit***************")	
			if CommonData.g_CountryWarLayer ~= nil then
				--CommonData.g_CountryWarLayer:setVisible(true)
				CommonData.g_CountryWarLayer:removeFromParentAndCleanup(false)
				--CommonData.g_CountryWarLayer:setZOrder(99)
			end	
			BaseSceneDB.ClearEffectParm()
			ClearData()			
			BaseSceneDB.GetSceneScript():Leave()
			Scence_OnExit()
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
		end	
		
		if tag == "exitTransitionStart" then		
			
		end	
		
		if tag == "cleanup" then	
			--print("**********cleanup******************")
			
			--package.loaded["FightScene"] = nil
			BaseSceneDB.ClearBaseSceneDB()
			FightbattleData.ClearBattleDataDB()
			
		end	
		
	end
	
	
	--print("初始化数据db")
	--Pause()
	--初始化数据db
	BaseSceneDB.InitBaseSceneDB()
	--初始化战斗数据存储
	FightbattleData.CreateBattleDataDB()
	
	--设置逻辑回调
	BaseSceneLogic.SetScene(G_BaseScene)	
		
	m_FightScene = CCScene:create()	
	m_FightScene:registerScriptHandler(BaseSceneEvent)
	m_FightScene:retain()	
	
end

--联网接口

function InitServerFightData(pServerDataStream)	
	--联网数据数据		
	print("InitServerFightData")
	BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerFightData(pServerDataStream))
	
end

function InitServerPKData(pNetStream)
	
	BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerPKData(pNetStream))
	
end

-- add by sxin 增加国战单挑接口
function InitSingleFightData(pNetStream)
	
	BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerPKData(pNetStream))
	BaseSceneDB.SetCityWarSingleScene()
	
end
-- add by sxin 增加国战战斗接口
function InitWarFightData(pNetStream)
	
	BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerPKData(pNetStream))
	BaseSceneDB.SetCityWarScene()
end

--

--单机接口
function InitTestFightData(SceneID, index )	
	
	--print(SceneID)
	--print(index)
	
	--测试数据		
	if SceneID ~= nil and index ~= nil then
		if tonumber(SceneID) >0 and tonumber(index) >0 and tonumber(index) <= 15 then---测试数据写死
		
			BaseSceneDB.SetSceneData_rapidjson(FightServer.InitTestFightData(tonumber(SceneID),tonumber(index)))
		else	
			--Pause()
			BaseSceneDB.SetSceneData_rapidjson(FightServer.InitTestFightData(1,5))
		end
	else	
		--Pause()	
		BaseSceneDB.SetSceneData_rapidjson(FightServer.InitTestFightData(1,5))
	end
end

--cg接口
function InitCGFightData( pointID )	
	
	BaseSceneDB.SetSceneData_rapidjson(FightServer.InitCGFightData(pointID))
	BaseSceneDB.SetCGScene()
end

local g_PKindex = 0
function InitTestPKData(SceneID, index)
	
	if SceneID ~= nil and index ~= nil then
		BaseSceneDB.SetSceneData_rapidjson(FightServer.InitTestPKData(SceneID,index))
	else
	
		local index = g_PKindex%5 +1
		g_PKindex = g_PKindex + 1
		--print("InitTestFightData: index = " .. index)
		
		BaseSceneDB.SetSceneData_rapidjson(FightServer.InitTestPKData(1000,index))
	end
	
end
--

function SetAnimationSelectVisible(iPos)

	m_pArmatureSelect:removeFromParentAndCleanup(false)
	
	if iPos >0 then 
		local pArmature = BaseSceneDB.GetPlayArmature(iPos)
		
		if pArmature ~= nil then 		
			pArmature:addChild(m_pArmatureSelect,0)		
		end	
	end
end 

function Get_Layer_Root()
	return m_Layer_Root
end

function Get_DamageLayer()
	return m_DamageLayer
end

function Get_BlackLayer()
	return m_BlackLayer
end

function Get_UILayer()
	return m_UILayer
end

function Get_GameNode_Middle()
	return m_pGameNode_Middle
end

function SetFightAuto(self, bAuto)
	BaseSceneDB.SetFightAuto(bAuto)
end

function IsPKScene()
	return BaseSceneDB.IsPKScene()
end

--时间到了战斗结束
function OnTimeOver()
	BaseSceneDB.SetFightResult(0)
	EndFight()
	--BaseSceneDB.SetFightResult(0)
	--SetFightTimer(ShowFightResoutTime,E_FightTimer.E_FightTimer_ShowFightResout)
	
end


function UseEngineSkill(self,iPos)
	--判断是不是被限制
	if BaseSceneDB.IsBuff_State(iPos) == false and BaseSceneDB.IsPKScene() == false then
		BaseSceneLogic.UseEngineSkill(iPos)	
	end
	
end

function SetEngineSkillTar(self,iTar)
	
	if  BaseSceneDB.IsPKScene() == false then
		BaseSceneDB.SetEngineSkillTar(iTar)
	end
end



function CanUseEngineSkill(self,iPos)
	
	
	if BaseSceneDB.GetFightEnd() == false and  BaseSceneDB.IsBuff_State(iPos) == false and BaseSceneDB.IsUseingHufaSkill() == false and BaseSceneDB.IsUseEngineSkill(iPos) == false then
		
		local pTeamData = BaseSceneDB.GetTeamData(iPos)
		if pTeamData.m_engine >= MaxEngine then 		
			return true
		else
			return false			
		end
	else
		return false
	end
	
end

function JudgeGamePause(self)	
	return BaseSceneLogic.IsShowBlackLayer()		
end

function UseHufaSkill(self)
	--判断是不是竞技场
	if  self:CanUseHufaSkill() == true then
		BaseSceneLogic.UseHufaSkill(1)	
	end
	
end

function CanUseHufaSkill(self)
		
	if BaseSceneDB.IsPKScene() == false and BaseSceneDB.GetFightEnd() == false and  BaseSceneDB.IsUseingHufaSkill() == false then
				
		local pFightDataParm = BaseSceneDB.GetHufaFightParm(1)	 
		local pHufaData = BaseSceneDB.GethufaData(1)	
	
	
		if pHufaData.m_engine >= MaxEngine then 		
			return true
		else
			return false			
		end
	else
		return false
	end
	
end



function LeaveBaseScene()	
	EndFight()	
	CCDirector:sharedDirector():popScene()
	m_FightScene:release()
end


function EnterBaseScene()
	local function CloseDoor()
		CCDirector:sharedDirector():pushScene(m_FightScene)
	end
	local layerTemp = UI_Loading_GetLoadingUI(LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil,CloseDoor)
	if LoadingNewLayer.GetBgType() == 3 then
		--先关门然后再进入场景
		UI_Loading_Show(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil,false)
		local pScene = CCDirector:sharedDirector():getRunningScene()
		if layerTemp== nil then
			return 
		end
		pScene:addChild(layerTemp, UILoading_Z, layerLoading_Tag)	
	else
		CCDirector:sharedDirector():pushScene(m_FightScene)
	end
	
end

function SetUIColour(self,colour)	
	UI_psetFightContrlColor(colour)
end


--对对回调调用的方法
G_BaseScene = {
	OnTimeOver		= OnTimeOver,
	UseEngineSkill  = UseEngineSkill,
	LeaveScene  = LeaveBaseScene,
	EnterScene  = EnterBaseScene,
	StarFight		= StarFight,
	EndFight		= EndFight,
	UpFighterEngine = UpFighterEngine,
	UpFighterBlood	= UpFighterBlood,
	Get_Layer_Root  = Get_Layer_Root,
	Get_DamageLayer = Get_DamageLayer,
	EndFight_SenenSprite = EndFight_SenenSprite,
	Get_BlackLayer 	= Get_BlackLayer,
	Get_UILayer		= Get_UILayer,
	Get_GameNode_Middle = Get_GameNode_Middle,
	SetFightAuto	= SetFightAuto,
	IsPKScene		= IsPKScene,
	CanUseEngineSkill = CanUseEngineSkill,
	UpHufaEngine	= UpHufaEngine,
	SetEngineSkillTar = SetEngineSkillTar,
	CanUseHufaSkill = CanUseHufaSkill,
	UseHufaSkill	= UseHufaSkill,
	Die				= Die,
	SetUIColour		= SetUIColour,
	Damage			= Damage,
	PauseFight      = PauseFight,
	ContinueFight	= ContinueFight,
	JudgeGamePause  = JudgeGamePause,	
	UISetPauseEnabled = UI_pSetPauseEnabled,
}

function GetScenePtr()
	
	return G_BaseScene 
	
end








