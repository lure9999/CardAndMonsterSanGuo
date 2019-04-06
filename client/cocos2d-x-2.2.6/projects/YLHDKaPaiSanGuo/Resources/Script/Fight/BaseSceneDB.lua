

-----场景数据管理

module("BaseSceneDB", package.seeall)

require "Script/Fight/Fight_Scene_Data"

function IDToKey( id )
	local Key = tostring(id)
	return Key
end

function KeyToID( Key )
	local ID = tonumber(Key)	
	return ID
end

--场景数据数据
local m_bAutoFight = false
local m_ObjTable = nil
local m_FightData = nil
local m_pSceneSprit = nil

local m_HufaTable = nil
--特效数据
local EffectObjTable = {}
local E_EffectIDRoot = 100
local m_EffectID = E_EffectIDRoot

--掉落数据
local m_DropObjTable = nil
local m_DropCount = 0

function InitBaseSceneDB()

	m_bAutoFight = false
	m_ObjTable = Fight_Scene_Data.Init_ObjTable()
--	m_FightData = Fight_Scene_Data.Init_FightData()
	m_HufaTable = Fight_Scene_Data.Init_HufaTable()
	m_pSceneSprit = nil	
	m_DropObjTable = {  }
	m_DropCount = 0
	m_EffectID = E_EffectIDRoot
end

function ClearBaseSceneDB()

	m_bAutoFight = false
	m_ObjTable = nil
	m_FightData = nil
	m_pSceneSprit = nil
	m_HufaTable	= nil
	m_DropObjTable = nil
	m_EffectID = E_EffectIDRoot
end

function CreateSceneScript()	
	m_pSceneSprit = scenemanage.CreateSceneScript(m_FightData.m_SceneID)
	return m_pSceneSprit
end

function GetSceneScript()
	return m_pSceneSprit
end


function GetPlayArmature(ipos)
	
	if ipos > Fight_hufa_TagID_Root then 
		return GetHufaArmature(ipos - Fight_hufa_TagID_Root)
	else
		return m_ObjTable[ipos].PayArmature
	end	
end

function SetPlayArmature(ipos, PayArmature)
	m_ObjTable[ipos].PayArmature = PayArmature
end


function GetPlayFightParm(ipos)
	if ipos > Fight_hufa_TagID_Root then 
		return GetHufaFightParm(ipos - Fight_hufa_TagID_Root)
	else
		return m_ObjTable[ipos].ObjFightDataParm
	end
	
end

function GetTeamData(ipos)	

	if ipos > Fight_hufa_TagID_Root then 
		return GethufaData(ipos - Fight_hufa_TagID_Root)
	else
		return m_FightData.m_TeamData[ipos]
	end
end

function GetPlayResID(ipos)
	
	if ipos > Fight_hufa_TagID_Root then 
		return (GethufaData(ipos - Fight_hufa_TagID_Root)).m_TempResid
	else
		return m_FightData.m_TeamData[ipos].m_TempResid
	end
	
end

--护法指针
function GetHufaArmature(iIndex)
	return m_HufaTable[iIndex].PayArmature
end

function SetHufaArmature(iIndex, PayArmature)
	m_HufaTable[iIndex].PayArmature = PayArmature
end

function GetHufaFightParm(iIndex)	
	return m_HufaTable[iIndex].ObjFightDataParm
end

function IsUseEngineSkill(iPos)		
	--对于角色自身必须要让手动技能播放完全才能再次释放
		
--	if GetPlayFightParm(iPos).m_bUseingEngineSkill == true then 
	local pPlayArmature = GetPlayArmature(iPos)
	
	if pPlayArmature ~= nil and pPlayArmature:getAnimation():getCurrentMovementID() == GetAniName_Player(pPlayArmature,Ani_Def_Key.Ani_manual_skill) then 
		
		 return true
	end	
	
	return false
end

function IsUseingHufaSkill()	
	--所有的护法都不能是在用技能的状态
	local i= 1
	for i=1,HufaMaxNum,1 do
		
		if m_HufaTable[i].ObjFightDataParm.m_bUseingEngineSkill == true then 
			
			 return true
		end
		
	end
	
	return false
end

--获取护法的数据 1是玩家的 2 3 4是敌对的根据波数读取
function GethufaData(iIndex)	

	if m_FightData.m_HufaData[iIndex] ~= nil and m_FightData.m_HufaData[iIndex].m_TempResid >= 0 then
	
		return m_FightData.m_HufaData[iIndex]
	
	end
	
	return nil	

end

function GetPlayerhufaData()	

	return GethufaData(1)

end
--NPC护法
function GetNpchufaData(itimes)	

	return GethufaData(1+itimes)

end


function SetFightResult( iFightResult )	

	m_FightData.m_FightResult.m_iFightResult = iFightResult
	
	--pk结果和服务器结果验证
	if NETWORKENABLE > 0 then	
		if IsPKScene() == true then 
			if iFightResult ~= GetPkResult() then 
				print("PK 战斗结果和服务器的不匹配")
				m_FightData.m_FightResult.m_iFightResult = GetPkResult()
				--Pause()
			end
		end
	end
end

function GetFightResult()	

	return m_FightData.m_FightResult.m_iFightResult

end


function SetFightEnd( bSet )

	m_FightData.m_bFightEnd = bSet

end

function GetFightEnd()

	return m_FightData.m_bFightEnd

end

function GetCurTimes()

	return m_FightData.m_curTimes
	
end

function AddCurTimes()

	m_FightData.m_curTimes = m_FightData.m_curTimes + 1
	
end

function GetAllTimes()

	return m_FightData.m_AllTimes
	
end

function GetScenceID()
	
	return m_FightData.m_SceneID
end

function GetBattleID()
	
	return m_FightData.m_Battle_ID
end

function GetpointID()
	
	return m_FightData.m_checkpointID
end



function GetBattleData_Star()
	
	return m_FightData.m_CopyData_Star
end

function GetBattleData_pk_RewardID()
	
	return m_FightData.m_pk_rewardID
end

function IsTeam(ipos1,ipos2)		
		
	if IsNpc(ipos1) == IsNpc(ipos2) then
		return true
	else
		return false
	end
end

function IsNpc(ipos)	
	
	if ipos > 5 and ipos <= 20 then	
		return true
	else
		if ipos > Fight_hufa_TagID_Root then --护法		
			
			if ipos > Fight_hufa_TagID_Root+1 then 
				return true
			else
				return false
			end
		else			
			return false		
		end
	end	
end

function IsHufa(ipos)	
	
	if ipos > Fight_hufa_TagID_Root then	
		return true
	else		
		return false			
	end	
end

function IsDie(iFighterPos)

	if iFighterPos >= 1 and iFighterPos <= MaxTeamPlayCount*4 then
		
		local pFighterData = GetTeamData(iFighterPos)
		
		if pFighterData.m_TempResid < 0 then
			return true
		end
		
	
		if pFighterData.m_curblood<= 0 then
		
			return true
		
		else
		
			return false
		end	
	end
	

	return true;
end

function IsUser(iFighterPos)

	if iFighterPos >= 1 and iFighterPos <= MaxTeamPlayCount*4 then
		
		local pFighterData = GetTeamData(iFighterPos)		
		
		if pFighterData.m_TempResid >= 0 then
			return true
		end		
		
	end
	

	return false
end


function IsPKScene()

	return m_FightData.m_bPKScene 
end

function IsCityWarScene()

	return m_FightData.m_bCityWarScene 
end

function SetCityWarScene()

	m_FightData.m_bCityWarScene = true
end

function IsCityWarSingleScene()

	return m_FightData.m_bCityWarSingleScene 
end

function SetCityWarSingleScene()

	m_FightData.m_bCityWarSingleScene = true
end

function IsCGScene()

	return m_FightData.m_bCGScene 
end

function SetCGScene()

	m_FightData.m_bCGScene = true
end


function SetFightAuto(bAuto)

	if IsPKScene() == true then
		return
	end
	m_bAutoFight = bAuto
end

function GetFightAuto()

	return m_bAutoFight
end

--设置集火目标
function SetEngineSkillTar( iTar )	
	
	BaseScene.SetAnimationSelectVisible(iTar)	
	m_FightData.m_Team_EngineSkill_Tar =  iTar	
	
end
--取得集火目标
function GetEngineSkillTar()

	return m_FightData.m_Team_EngineSkill_Tar
end


---特效类的数据管理
function CreateEffectParm()

	m_EffectID = m_EffectID +1
	
	local Parm = {}
	
	Parm.m_tagid = m_EffectID	
	Parm.m_iSource = -1
	Parm.m_iTar    = -1
	Parm.m_State	= -1
	Parm.m_iDamageState = {-1,-1,-1,-1,-1}
	Parm.m_EffectID = -1
	Parm.m_EffectType = -1
	Parm.m_EngineSkill = 0
	Parm.m_iDamage = 0	
	Parm.HitPos = {-1,-1,-1,-1,-1}
	Parm.bMusHit = false
	
	
	
	EffectObjTable[IDToKey(m_EffectID)] = Parm	
	
	return Parm
	
end

function GetEffectParm(K_id)
	
	if K_id > E_EffectIDRoot then 
	
		if EffectObjTable[IDToKey(K_id)] == nil then 
			print("GetEffectParm error K_id = " .. K_id)
			--printTab(EffectObjTable)
		end
		
		return EffectObjTable[IDToKey(K_id)]
	else
		print("GetEffectParm error K_id = " .. K_id)
		return nil
	end
		
	
	
end

function DelEffectParm(K_id)

	if EffectObjTable[IDToKey(K_id)] ~= nil then
	
		if EffectObjTable[IDToKey(K_id)].HanderTime ~= nil then
			
			--if EffectObjTable[IDToKey(K_id)].pArmature ~= nil then
			
				--EffectObjTable[IDToKey(K_id)].pArmature:getScheduler():unscheduleScriptEntry(EffectObjTable[IDToKey(K_id)].HanderTime)	
				
				--EffectObjTable[IDToKey(K_id)].pArmature:removeFromParentAndCleanup(true)
				--EffectObjTable[IDToKey(K_id)].HanderTime = nil
				--BaseSceneLogic.DelArmature(EffectObjTable[IDToKey(K_id)].pArmature)
			--else
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(EffectObjTable[IDToKey(K_id)].HanderTime)
				BaseSceneLogic.DelArmature(EffectObjTable[IDToKey(K_id)].pArmature)
			--end
			
			if EffectObjTable[IDToKey(K_id)].bBuffGainType ~= nil then 
				
				PalyBuffGain_TeamData(EffectObjTable[IDToKey(K_id)].m_iTar,EffectObjTable[IDToKey(K_id)].bBuffGainType,EffectObjTable[IDToKey(K_id)].bBuffGainVel,false)
				
			end
			
		end
		
		if EffectObjTable[IDToKey(K_id)].iSharder  and  EffectObjTable[IDToKey(K_id)].iSharder > 0 then
		
			local PArmatureTar = GetPlayArmature(EffectObjTable[IDToKey(K_id)].m_iTar)
			
			if PArmatureTar ~= nil then 
				CCArmatureSharder(PArmatureTar,SharderKey.E_SharderKey_Normal)
			end		
		end
		
		if EffectObjTable[IDToKey(K_id)].m_State ~= nil then					
						
			if EffectObjTable[IDToKey(K_id)].m_State == DamageState.E_DamageState_xuanyun or EffectObjTable[IDToKey(K_id)].m_State == DamageState.E_DamageState_bingdong then 
			
				local PArmatureTar = GetPlayArmature(EffectObjTable[IDToKey(K_id)].m_iTar)
				local pFightDataParmTar = GetPlayFightParm(EffectObjTable[IDToKey(K_id)].m_iTar)
			
				if PArmatureTar ~= nil then 
				
					resumeSchedulerAndActions(PArmatureTar)	
					--print("DelEffectParm(K_id)" .. K_id)
					--Pause()
					pFightDataParmTar.m_buff_state = nil
					
				end		
				
			end											
							
			EffectObjTable[IDToKey(K_id)].m_State = E_DamageState_None 
			EffectObjTable[IDToKey(K_id)].m_iDamageState = {-1,-1,-1,-1,-1}
		end
			 
		EffectObjTable[IDToKey(K_id)] = nil
	
	end
	
end

function ClearEffectParm()
				
	 for k, v in pairs(EffectObjTable) do
        if type(v) == "table" then
						 
            DelEffectParm(KeyToID(k))
        else
            print("ClearEffectParm Error")
        end
    end	
	
	
end

function AddDropData( pDropItme )
	
	m_DropCount = m_DropCount + 1
	m_DropObjTable[m_DropCount] = pDropItme
	
end

function GetDropData( )		
	return m_DropObjTable	
end

--获取战斗评星
function GetBattleFight_Star()	

	local iStar = 3	
	
	local i = 1
	for i= 1, MaxTeamPlayCount , 1 do		
		
		if IsUser(i)== true and  IsDie(i) == true then 
			iStar = iStar -1
		end
		
	end	
	
	if iStar < 0 then 
		iStar = 0
	end
	
	return iStar

end


function SetSceneData_rapidjson(tabBattleData)
	
	--[[
	local i = 1
	for i = 1, 20 do
		if tonumber(tabBattleData.m_TeamData[i].m_TempResid) > 0 then
			m_FightData.m_TeamData[i] = tabBattleData.m_TeamData[i]		
		end
	end
	--增加护法数据 暂时一队只有一个
	for i = 1, 4 do
		if tonumber(tabBattleData.m_HufaData[i].m_TempResid) > 0 then
				m_FightData.m_HufaData[i] = tabBattleData.m_HufaData[i]		
		end
	end
		
	m_FightData.m_SceneID  = tabBattleData.m_SceneID
	m_FightData.m_AllTimes = tabBattleData.m_AllTimes
	m_FightData.m_curTimes = 1
	m_FightData.m_bPKScene = tabBattleData.m_bPKScene
	m_FightData.m_Battle_ID = tabBattleData.m_Battle_ID
	
	--增加掉落数据
	m_FightData.m_dropList = tabBattleData.m_dropList
	
	--]]
	
	m_FightData = tabBattleData	
	if m_FightData.m_bPKScene == true then 
		m_bAutoFight = true
	end
	
	--保存队伍信息
	FightbattleData.SetBattleFightData(m_FightData.m_Battle_ID,tabBattleData)	
	
end

function PalyBuffGain_TeamData(iPos,pBuffGainType,pBuffGainVel,beffective)

	local pTeamData = GetTeamData(iPos)
	
	local _buffvel = pBuffGainVel
	
	if beffective == false then --无效	
		_buffvel = -pBuffGainVel		
	end	
		
	if pBuffGainType == BuffGainType.E_BuffGainType_gongji then 			
		pTeamData.m_gongji = pTeamData.m_gongji + _buffvel	
	elseif pBuffGainType == BuffGainType.E_BuffGainType_wufang then 		
		pTeamData.m_wufang = pTeamData.m_wufang + _buffvel	
	elseif pBuffGainType == BuffGainType.E_BuffGainType_fafang then 
		pTeamData.m_fafang = pTeamData.m_fafang + _buffvel
	elseif pBuffGainType == BuffGainType.E_BuffGainType_mingzhong then 
		pTeamData.m_mingzhong = pTeamData.m_mingzhong + _buffvel
		
	elseif pBuffGainType == BuffGainType.E_BuffGainType_baoji then 
	
		pTeamData.m_Talent.m_crit = pTeamData.m_Talent.m_crit + _buffvel
	elseif pBuffGainType == BuffGainType.E_BuffGainType_duoshan then 
		pTeamData.m_Talent.m_duoshan = pTeamData.m_Talent.m_duoshan + _buffvel
	elseif pBuffGainType == BuffGainType.E_BuffGainType_shipo then 
		pTeamData.m_Talent.m_penetrate = pTeamData.m_Talent.m_penetrate + _buffvel
	elseif pBuffGainType == BuffGainType.E_GainType_engine then 
		pTeamData.m_engine = pTeamData.m_engine + _buffvel	
		if pTeamData.m_engine > UseMaxEngine then
			pTeamData.m_engine = UseMaxEngine
		end
	elseif pBuffGainType == BuffGainType.E_BuffGainType_xishoudun then 
	
		pTeamData.m_xishoudun  = pTeamData.m_xishoudun + _buffvel
			
		if pTeamData.m_xishoudun < 0 then 
			pTeamData.m_xishoudun = 0
		end
	elseif pBuffGainType == BuffGainType.E_BuffGainType_jueduifangyu then 		
		pTeamData.m_add_fangyu = pTeamData.m_add_fangyu + _buffvel	
		
		if pTeamData.m_add_fangyu < 0 then 
			pTeamData.m_add_fangyu = 0
		end
	elseif pBuffGainType == BuffGainType.E_BuffGainType_zhili then 	
		
		--print(pTeamData.m_wisdom)
		--print(_buffvel)
		pTeamData.m_wisdom = pTeamData.m_wisdom + _buffvel	
		
		if pTeamData.m_wisdom < 0 then 
			pTeamData.m_wisdom = 0
		end
		--print(pTeamData.m_wisdom)
		--Pause()
	else
	
		
		print("PalyBuffGain_TeamData pBuffGainType Error")
	end
	
end
   
function ClearDamageLogic(pFightDataParm)
	
	pFightDataParm.m_State = DamageState.E_DamageState_None
	pFightDataParm.m_Damage = {-1,-1,-1,-1,-1,}
	pFightDataParm.m_DamageState = {-1,-1,-1,-1,-1,}
	pFightDataParm.m_iParamDamage = 0
	pFightDataParm.m_iParamDamageType = nil
	pFightDataParm.m_HurtPos = {-1,-1,-1,-1,-1,}
	pFightDataParm.m_Curbone =nil
	pFightDataParm.m_bUseingEngineSkill = false
	pFightDataParm.bBuffTYpe = nil
	pFightDataParm.bufftimes = nil
	pFightDataParm.bufftimecd = nil
end

function IsBuff_State(iPos)
	
	local pFightDataParm = GetPlayFightParm(iPos)
	
	if pFightDataParm.m_buff_state ~= nil then
		
		if pFightDataParm.m_buff_state == DamageState.E_DamageState_xuanyun or pFightDataParm.m_buff_state == DamageState.E_DamageState_bingdong then 
			return true
		end
		
	end
	return false
end

local function GetTarBySiteType(plistTable ,iSiteType)
	local iTarPos = -1
	
	if iSiteType == Site_Single_Param.Type_Random then --随机
		
		local icount = table.maxn(plistTable)
		if icount > 0 then 
			iTarPos = plistTable[math.random(1, icount)]	
		end		
	
	elseif iSiteType == Site_Single_Param.Type_Blood_Min then --血最少
	
		local TempBlood = 99999999
		for k, v in pairs(plistTable) do
			local pTeamData = GetTeamData(v)
			local Tempvel = pTeamData.m_curblood/pTeamData.m_allblood 
			if Tempvel < TempBlood then 
				
				TempBlood = Tempvel
				iTarPos = v
			end 
		end
		
	else
		print("GetTarBySiteType iSiteType Error iSiteType = " .. iSiteType)
	end
	
	return iTarPos
end


-- 根据类型选择一个目标
function GetSingleTarBySiteType(iSourPos,iSiteType)
	
	local pListTable = {}
	local iIndex = 1
	if BaseSceneDB.IsNpc(iSourPos) == true then 
			
		local i=1
		local iNpc = -1
		for i=1 , MaxTeamPlayCount, 1 do
			iNpc = BaseSceneDB.GetCurTimes()*MaxTeamPlayCount + i
			if BaseSceneDB.IsUser(iNpc) == true and BaseSceneDB.IsDie(iNpc) == false then
				
				pListTable[iIndex] = iNpc				
				iIndex = iIndex + 1
			end 
			
		end		
		
	else--人
		
		local i=1
		
		for i=1 , MaxTeamPlayCount, 1 do
			
			if BaseSceneDB.IsUser(i) == true and BaseSceneDB.IsDie(i) == false then
				pListTable[iIndex] = i
				iIndex = iIndex + 1
			end 
			
		end
	
	end	

	return GetTarBySiteType(pListTable,iSiteType)
end

function GetHurtDamagebyHitPos(hitposList, ihitpos, DamageList)
	
	local i=1		
	for i=1 , MaxTeamPlayCount, 1 do
		
		if hitposList[i] > 0 and hitposList[i] == ihitpos then
			return DamageList[i]
		end 
		
	end
	
	return 0
end

function SumDamageList(DamageList)
	
	local iDamage = 0
	local i=1		
	for i=1 , MaxTeamPlayCount, 1 do		
		if DamageList[i] > 0 then
			iDamage = iDamage + DamageList[i]
		end 		
	end
	
	return iDamage
end

---获取怪物掉落物品的列表
function GetFightDropList(iPos)
	
	if IsNpc(iPos) == true then
		local Index = iPos - MaxTeamPlayCount
		return m_FightData.m_dropList[Index]
		
	end
		
	return {}
end
--获取战斗随机数据
function GetPkData(iPos)
	
	if table.getn(m_FightData.m_PKData) <=0 then
		return -1
	end
	
	local tempPos = iPos
	
	if iPos >= Fight_hufa_TagID_Root then 
		tempPos = iPos - Fight_hufa_TagID_Root + 10
		
		--print(tempPos)
		--Pause()
	end
	
	
	if m_FightData.m_PKData[2][tempPos] ~= nil then 
	
		local iRand = m_FightData.m_PKData[2][tempPos][m_FightData.m_PKData_Times[tempPos]]
		
		m_FightData.m_PKData_Times[tempPos] = m_FightData.m_PKData_Times[tempPos] +1
		
		if iRand ~= nil then 
			return tonumber(iRand)	
		end
		
		print("GetPkData Error iPos = " .. tempPos.."Times = " .. m_FightData.m_PKData_Times[tempPos]-1)
		--Pause()
	else
		
		print("GetPkData Error iPos = " .. tempPos.."Times = NUll" )
		--Pause()
	end
	
	
	return -1
	
end

--判断是不是服务器已经死了
function IsHaveGetPkData(iPos)
	
	if table.getn(m_FightData.m_PKData) <=0 then
		return false
	end
	
	if m_FightData.m_PKData[2][iPos] ~= nil then 
	
		local iRand = m_FightData.m_PKData[2][iPos][m_FightData.m_PKData_Times[iPos]]
				
		if iRand ~= nil then 
			return true	
		end
		
	end	
	
	return false
	
end

--服务器的战斗结果
function GetPkResult()
	return m_FightData.m_PKData[1]
end

