--add by sxin 场景脚本通用接口逻辑

module("script_logic", package.seeall)


local function Create( self,pScence)	
	
	self.m_ScenceInterface	= pScence
	
end


local function Enter(self)			
	self.m_Times = 1
end

local function EnterFinish(self)			
	
end

local function Leave( self)	
	
	self.m_ScenceInterface = nil
	self.m_Times = 1
end

--战斗波数
local function StarFight( self)	
	
		
	return false
		
end


--战斗波数
local function EndFight( self,times )		
	
	self.m_Times = self.m_Times+1
	return false
		
end

--死亡触发事件 死亡索引 攻击者索引
local function Die( self,DieObj , attackObj )	
	
	--PlayDropItem(self.m_Times,DiePos,attackPos)
		
end

local function Damage( self,DamageObj )	
	
	--print(iDamagePos)
	
end


--队伍推图入场
local function PlayerEnterScene(self)
	
	BasePlayerEnterScene(self)
	
end

local function Release(self)

	self.m_ScenceInterface 	= nil
	self.m_Times			= 0
				
end

function CreateBaseScene( iSpritID )	
	
	local Scene_Base= {
				Fun_Create 			= Create,
				Fun_Release 		= Release,
				Fun_Enter 			= Enter,
				Fun_Leave 			= Leave,
				Fun_StarFight		= StarFight,
				Fun_EndFight		= EndFight,
				Fun_Die				= Die,	
				Fun_PlayerEnterScene = PlayerEnterScene,
				Fun_Damage			= Damage,
				Fun_EnterFinish		= EnterFinish,
				
				--变量
				m_iD				= iSpritID,	
				
				-- 需要重置的数据 脚本本身是复用的
				m_ScenceInterface 	= nil,
				m_Times				= 0
			
	}
		
	return Scene_Base
end

--脚本的扩展方法
--队伍推图入场
function BasePlayerEnterScene(pSprite)
	
	print("BasePlayerEnterScene")
	
	local function CB_PlayerEnterScene(pNode)			
		
		local i=1
		for i=1,5,1 do		
				--//玩家
			if pSprite.m_ScenceInterface.m_baseDB.m_FightTeamPlay[i] ~= nil then
				
				pSprite.m_ScenceInterface.m_baseDB.m_FightTeamPlay[i]:Fun_play_Key(Ani_Def_Key.Ani_stand)					
			end
			
			--NPC--------------------------------------
			
			local iTimes = pSprite.m_Times
			if pSprite.m_ScenceInterface.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil then			
				pSprite.m_ScenceInterface.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_play_Key(Ani_Def_Key.Ani_stand)				
			end	

		end
			
		pSprite.m_ScenceInterface:Fun_StarFight()	
	end
	
	local pcallFunc = CCCallFuncN:create(CB_PlayerEnterScene)		
	Scene_BaseLogic.SetNodeTimer(pSprite.m_ScenceInterface:Fun_Get_pGameScene(),SceneEnterTime*0.5,pcallFunc,0)	

	local pMoveBy = nil
	local i=1
		
	for i=1,5,1 do		
				--//玩家
		if pSprite.m_ScenceInterface.m_baseDB.m_FightTeamPlay[i] ~= nil then
			
			pSprite.m_ScenceInterface.m_baseDB.m_FightTeamPlay[i]:Fun_play_Key(Ani_Def_Key.Ani_run)			
			pSprite.m_ScenceInterface.m_baseDB.m_FightTeamPlay[i]:Fun_GetRender_Armature():setPositionX(pSprite.m_ScenceInterface.m_baseDB.m_FightTeamPlay[i]:Fun_GetRender_Armature():getPositionX() -MaxMoveDistance*0.5)			
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.5,ccp(MaxMoveDistance*0.5,0))	
			pSprite.m_ScenceInterface.m_baseDB.m_FightTeamPlay[i]:Fun_runAction(pMoveBy)
		end
		
		--NPC--------------------------------------
		
		local iTimes = pSprite.m_Times
		if pSprite.m_ScenceInterface.m_baseDB.m_FightTeamNpc[iTimes][i] ~= nil then			
			pSprite.m_ScenceInterface.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_play_Key(Ani_Def_Key.Ani_run)
			pSprite.m_ScenceInterface.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_GetRender_Armature():setPositionX(pSprite.m_ScenceInterface.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_GetRender_Armature():getPositionX() + MaxMoveDistance*0.5)
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.5,ccp(-MaxMoveDistance*0.5,0))	
			pSprite.m_ScenceInterface.m_baseDB.m_FightTeamNpc[iTimes][i]:Fun_runAction(pMoveBy)
		end	

	end
	
end

--待机入场
function StopPlayerEnterScene(pSprite)
	
			
end


--通用的逻辑封装调用

function ShowTeamPlay(pSprite,istarpos,bshow)
	
	
end


function StopTeamPlay(pSprite,istarpos)
	
		
end

--玩家的
function TeamPlayRecovery(pSprite)
	
	
	
end

--死亡掉落
function PlayDropItem(pSprite,DieObj , attackObj)

	
	
end




