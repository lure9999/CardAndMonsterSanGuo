
module("FightbattleData", package.seeall)


--//战斗数据

local BattleDataDB = nil

local ID_BattleDataDB_Root = 200000

--模拟服务器的唯一id
function CreateBattleID()
	ID_BattleDataDB_Root = ID_BattleDataDB_Root +1
	return ID_BattleDataDB_Root
end

--初始化战斗db
function CreateBattleDataDB()
	
	if BattleDataDB == nil then
	
		BattleDataDB = {}	
		
	end
end

--创建战斗数据
local function CreateBattleData( Battle_id )
	
	local BattleData = {}
	
	---暂时模拟	
	BattleData.m_id = Battle_id	
	
	BattleDataDB["Battleid_"..Battle_id] = BattleData	
	
	return BattleData
	
end

--获取战斗数据
local function GetBattleData(Battle_id)
	
	if BattleDataDB ~= nil then
		return BattleDataDB["Battleid_"..Battle_id]
	else
		CreateBattleDataDB()
		return nil
	end
	
end

--删除战斗数据
local function DelBattleData(Battle_id)

	if BattleDataDB["Battleid_"..Battle_id] ~= nil then				 
		BattleDataDB["Battleid_"..Battle_id] = nil	
	end
	
end

--清除战斗数据
function ClearBattleDataDB()
	
		
	--FileLog("Log_BattleData.lua",BattleDataDB)
	--FileLog_json("Log_BattleData.json",BattleDataDB)
	
	if BattleDataDB ~= nil then
	
		for k, v in pairs(BattleDataDB) do
			if type(v) == "table" then
							 
				DelBattleData(k)
			else
				print("ClearEffectParm Error")
			end
		end
		
		BattleDataDB = nil
	end
end


local function GetBattleRoundData( BattleData , iRound)
	
	local BattleData_Round = BattleData["Roundid_"..iRound]
	if BattleData_Round == nil then
	
		BattleData_Round = {}
		BattleData_Round.m_iRound = iRound		
		--设置当前的轮数
		BattleData.Battle_TeamData.m_curTimes = iRound
		
		BattleData["Roundid_"..iRound] = BattleData_Round
		
	end
		
	return BattleData_Round
end


--[[
ObjFightDataParm = { 
m_FightPos = -1, 
m_imageID = -1, 
m_Mode_Height = -1, 
m_Mode_Width = -1, 
m_FightState = -1,--0 1 判断是跑动中还是原地
m_iTarpos = -1, 
m_iSkill = -1, 
m_iSkillIndex = -1, 
m_iSkillType = -1, 
m_iSkillTarType = -1, 
m_State = -1, 
m_Damage = {-1,-1,-1,-1,-1,}, 
m_iParamDamage = -1, 
m_CdTime = -1, 
m_HurtPos = {-1,-1,-1,-1,-1,}, 
m_FightPosType = -1, 
m_AttackDis = -1, 
m_Curbone = nil, 
m_bUseingEngineSkill = false}
}
--]]

local function copyFightDataParm(FightDataParm)

	local _copyFightData = {}
	_copyFightData.m_FightPos 			= FightDataParm.m_FightPos
	_copyFightData.m_iTarpos 			= FightDataParm.m_iTarpos
	_copyFightData.m_State				= FightDataParm.m_State
	_copyFightData.m_iSkill 			= FightDataParm.m_iSkill
	_copyFightData.m_iSkillIndex		= FightDataParm.m_iSkillIndex
	_copyFightData.m_Damage 			= copyTab(FightDataParm.m_Damage)
	_copyFightData.m_iParamDamage 		= FightDataParm.m_iParamDamage
	_copyFightData.m_CdTime 			= FightDataParm.m_CdTime
	_copyFightData.m_bUseingEngineSkill = FightDataParm.m_bUseingEngineSkill
	
	_copyFightData.m_HurtPos 			= copyTab(FightDataParm.m_HurtPos)
	
	return _copyFightData
end

local function SetBattleFighterPar( Battle_Data_Round, iFighterKey,	FightDataParm)
	
	local Fighter_data = Battle_Data_Round["FighterKey_"..iFighterKey]
	
	if Fighter_data == nil then 
		
		Fighter_data = {}
		Fighter_data.m_FighterKey = iFighterKey
		Fighter_data.m_iIndex = 0	
		Fighter_data.m_attack_Damage = 0	
		Fighter_data.m_skill_Damage = 0
		Fighter_data.m_engine_Damage = 0
		Fighter_data.m_all_Damage = 0
		--Fighter_data.FightDataTimes = {}
		Battle_Data_Round["FighterKey_"..iFighterKey] = Fighter_data
		
	end
	
	Fighter_data.m_iIndex = Fighter_data.m_iIndex + 1
	
	local Fight_Data_Times = {}
	Fight_Data_Times.m_Times = Fighter_data.m_iIndex
	
	--重写需要的数据FightDataParm里有服务器不需要的数据
	Fight_Data_Times.FightDataParm = copyFightDataParm(FightDataParm)
		
	
	--统计战斗数据
	local iSumDamage = BaseSceneDB.SumDamageList(FightDataParm.m_Damage)
	
	if FightDataParm.m_iSkillIndex == 1 then 
		Fighter_data.m_attack_Damage = Fighter_data.m_attack_Damage + iSumDamage
	elseif FightDataParm.m_iSkillIndex == 2 then 
		Fighter_data.m_skill_Damage = Fighter_data.m_skill_Damage + iSumDamage
	elseif FightDataParm.m_iSkillIndex == 3 then 
		Fighter_data.m_engine_Damage = Fighter_data.m_engine_Damage + iSumDamage
	end
	
	Fighter_data.m_all_Damage = Fighter_data.m_all_Damage + iSumDamage
	
	Fighter_data["FighterIndex_"..Fighter_data.m_iIndex] = Fight_Data_Times	
	--table.insert( Fighter_data.FightDataTimes, Fight_Data_Times)
		 
end

--战斗id 轮输 战斗位置 战斗数据 
function SetBattleData(Battle_id,iRound,iFighterKey,FightDataParm)

	local Battle_Data = GetBattleData(Battle_id)
	
	if Battle_Data == nil then 		
		Battle_Data = CreateBattleData( Battle_id )	
	end
	
	local Battle_Data_Round = GetBattleRoundData( Battle_Data , iRound)	
	SetBattleFighterPar(Battle_Data_Round,tonumber(iFighterKey),FightDataParm)	
	
end

function SetBattleFightData(Battle_id,TeamData)

	print(Battle_id,111111)	
	local Battle_Data = GetBattleData(Battle_id)
	
	if Battle_Data == nil then 		
		Battle_Data = CreateBattleData( Battle_id )			
	end
	
	local Battle_TeamData = copyTab(TeamData)
	Battle_Data.Battle_TeamData = Battle_TeamData
	
	--FileLog_json("Log_BattleFightData.json",Battle_Data)
	--Pause()
end

--获取当前局的
function GetBattleFight_Damage_Data(Battle_id)	
	
	local Battle_Data = GetBattleData(Battle_id)
	
	if Battle_Data == nil then 		
		print("GetBattleFight_Damage_Data : Battle_id Error")	
		return nil
	end
	
	local iToundID = Battle_Data.Battle_TeamData.m_curTimes
	
	local Round_Data = Battle_Data["Roundid_"..iToundID]
	
	if Round_Data == nil then 		
		print("GetBattleFight_Damage_Data : iRound_id Error")	
		return nil
	end
	
	local dataList = {}
	local i = 1
	local iIndex = 1
	local j = 1
	for i= 1, 10 , 1 do
	
		if i <= 5 then 
			iIndex = i
		else
			iIndex = 5* (iToundID -1) + i
		end
	
		local pTeamData = Battle_Data.Battle_TeamData.m_TeamData[iIndex]
		if pTeamData.m_Serverid > 0 and  pTeamData.m_TempID > 0 then 
			--如果角色当前战斗死亡算0
			local data = {m_Guid = pTeamData.m_Serverid, m_TempID = pTeamData.m_TempID ,m_PosID = iIndex, m_Damage = 0}
			
			local Fighter_data = Round_Data["FighterKey_"..iIndex]
			if Fighter_data ~= nil then 
				data.m_Damage = Fighter_data.m_all_Damage
				
				if data.m_Damage < 0 then 
					data.m_Damage = 0
				end 
			end			
			
			dataList[j] = data
			j = j+1
		end
		
	end
		
	return dataList	
	
end






