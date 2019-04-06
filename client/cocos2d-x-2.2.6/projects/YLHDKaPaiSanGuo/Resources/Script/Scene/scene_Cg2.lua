
--add by sxin 场景脚本
--场景id = 1的脚本

module("scene_Cg2", package.seeall)


function Enter(self)	

	scene_logic.Enter(self)		
	self.bCallDamagge = false	
	self.bCall80 = false	
	self.bCall60 = false	
	self.bCall10 = false	
	
	local pUI = self.m_ScenceInterface:Get_UILayer()
	if pUI ~= nil then
		pUI:setVisible(false)
	end
	
end

function EnterFinish(self)		
	
	self.m_ScenceInterface.UISetPauseEnabled(false)
	scene_logic.ShowTeamPlay(0,false)
	scene_logic.ShowTeamPlay(5,false)	
	
	BaseSceneDB.GetTeamData(6).m_curblood = 10000				
	BaseSceneDB.GetTeamData(7).m_curblood = 10000	
	BaseSceneDB.GetTeamData(8).m_curblood = 10000		
	BaseSceneDB.GetTeamData(9).m_curblood = 10000	
	BaseSceneDB.GetTeamData(10).m_curblood = 10000	
	
	BaseSceneDB.GetTeamData(6).m_allblood = 10000				
	BaseSceneDB.GetTeamData(7).m_allblood = 10000	
	BaseSceneDB.GetTeamData(8).m_allblood = 10000		
	BaseSceneDB.GetTeamData(9).m_allblood = 10000	
	BaseSceneDB.GetTeamData(10).m_allblood = 10000	
	
	local pUI = self.m_ScenceInterface:Get_UILayer()
	if pUI ~= nil then
		pUI:setVisible(false)
	end
			
end

function PlayerEnterScene(self)
	scene_logic.StopPlayerEnterScene(self)	
end


function StarFight(self, times )
	--print("StarFight")
	--print(times)
	--Pausetraceback()	
	scene_logic.StarFight(self,times)	
	
	local function Callback(nCurTalkId, nNextTalkId)		
		
		--print("对话Id = " .. nCurTalkId .. " " .. nNextTalkId)
		--Pause()			 
				
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3008 then
			
			--战斗
			
			self.m_ScenceInterface:StarFight()
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(true)
			end
		
		end
		
	end
	
	
	--第一场对话
	if times == 1 then
	
		local function EffectEntercallback()
				
			--小兵从右侧出来
			local function Runcallback()
				
				--对话
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(3007)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
			
			end
			
			scene_logic.PlayerFastRunEnter(6,self,nil)
			scene_logic.PlayerFastRunEnter(7,self,nil)
			scene_logic.PlayerFastRunEnter(8,self,nil)
			scene_logic.PlayerFastRunEnter(9,self,nil)
			scene_logic.PlayerFastRunEnter(10,self,Runcallback)	
		end
					
		--主角出场	
		scene_logic.PlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",1,false,1,self,EffectEntercallback)
	
		local pUI = self.m_ScenceInterface:Get_UILayer()
		if pUI ~= nil then
			pUI:setVisible(false)
		end
		
		return true
	
	end	

	return false
end


function Damage( self,iDamagePos )	
		
	if self.bCallDamagge == true then 	
		return	
	end
	
	local function Callback(nCurTalkId, nNextTalkId)

		if  tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3009  then
		
			self.m_ScenceInterface:ContinueFight()
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(true)
			end
			
		end
		
		if  tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3018 then
		
			require "Script/Main/NewGuide/ClickCallBackLayer"
			
			local function ClickCallBack()
				self.m_ScenceInterface:ContinueFight()	
				BaseSceneLogic.UseEngineSkill(5)	
				--增加怪物的攻击力
			--	BaseSceneDB.GetTeamData(6).m_add_gongji = 10				
			--	BaseSceneDB.GetTeamData(7).m_add_gongji = 10		
			--	BaseSceneDB.GetTeamData(8).m_add_gongji = 10		
			--	BaseSceneDB.GetTeamData(9).m_add_gongji = 10		
			--	BaseSceneDB.GetTeamData(10).m_add_gongji = 10		
				
			end
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(true)
			end
			
			ClickCallBackLayer.Create(ccp(346,88),ClickCallBack)			
		end
		
				
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3013  then
		--马超出场
			local function EffectEntercallback()
				
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(3014)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
				
			end
		
			--local pos = ccp(PlayBirthPoint[2].x,PlayBirthPoint[2].y)
			--scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,true,2,6006,pos,self,EffectEntercallback)		
		
			BaseScene.CreatPlayer(2,6006)
			scene_logic.PlayerFastRunEnter(2,self,EffectEntercallback)
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3014  then
		--大桥出场
		
			local function EffectEntercallback()
				
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(3015)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
				
			end
		
			local pos = ccp(PlayBirthPoint[3].x,PlayBirthPoint[3].y)
			scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,true,3,6046,pos,self,EffectEntercallback)		
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3015  then
		--诸葛亮出场
			local function EffectEntercallback()
				
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(3016)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
				
			end
		
			local pos = ccp(PlayBirthPoint[4].x,PlayBirthPoint[4].y)
			scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,true,4,6013,pos,self,EffectEntercallback)		
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3016  then
		--孙尚香出场
			local function EffectEntercallback()
				
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(3017)				
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end			
			end
		
			--local pos = ccp(PlayBirthPoint[5].x,PlayBirthPoint[5].y)
			--scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,true,5,6038,pos,self,EffectEntercallback)		
		
			BaseScene.CreatPlayer(5,6038)
			scene_logic.PlayerFastRunEnter(5,self,EffectEntercallback)
		end

		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3017  then	
			
			local function TalkCallBack(pNode)				
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(3018)
				
				--让主将能量满
				BaseSceneDB.GetTeamData(5).m_engine = 300				
				self.m_ScenceInterface:UpFighterEngine(5)
				
				BaseSceneDB.GetTeamData(4).m_engine = 80				
				self.m_ScenceInterface:UpFighterEngine(4)
				
				BaseSceneDB.GetTeamData(3).m_engine = 60				
				self.m_ScenceInterface:UpFighterEngine(3)
				
				BaseSceneDB.GetTeamData(2).m_engine = 40				
				self.m_ScenceInterface:UpFighterEngine(2)		
				
				
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end		
			end

			local pcallFunc = CCCallFuncN:create(TalkCallBack)				
			BaseSceneLogic.SetNodeTimer(self.m_ScenceRoot,0.5,pcallFunc,0)
		
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 3021  then
			--结束战斗		
			self.m_ScenceInterface:EndFight()			
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(true)
			end
			
			--BaseSceneDB.SetFightResult(1)							
			self.m_ScenceInterface:LeaveScene()
							
		end		
							
	end
	
	--print(iDamagePos)
	if iDamagePos == 1 then
		
		local pFighter = BaseSceneDB.GetTeamData(iDamagePos)	
		
		if self.bCall80 == false and pFighter.m_curblood <=  pFighter.m_allblood*0.8 then
			--self.bCallDamagge = true	
			self.bCall80 = true
			--触发情节
			self.m_ScenceInterface:PauseFight()	
			--对话
			HeroTalkLayer.setCallBackFun( Callback )
			HeroTalkLayer.createHeroTalkUI(3009)
			
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(false)
			end
			
		elseif self.bCall60 == false and pFighter.m_curblood <=  pFighter.m_allblood*0.6 then
			--self.bCallDamagge = true
			self.bCall60 = true
			--触发情节
			self.m_ScenceInterface:PauseFight()	
			--对话
			HeroTalkLayer.setCallBackFun( Callback )
			HeroTalkLayer.createHeroTalkUI(3010)
			
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(false)
			end
		
		elseif self.bCall10 == false and pFighter.m_curblood <=  pFighter.m_allblood*0.2 then
			
			self.bCallDamagge = true
			self.bCall10 = true
			--触发情节
			self.m_ScenceInterface:PauseFight()	
			--对话
			HeroTalkLayer.setCallBackFun( Callback )
			HeroTalkLayer.createHeroTalkUI(3019)
			
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(false)
			end		
			
		end
		
	end
	
end

function Leave( self)	
	self.m_ScenceInterface.UISetPauseEnabled(true)
	self.m_ScenceRoot = nil
	self.m_Times = 1
end

local scene_Cg2 = scene_logic.CreateBaseScene(1002)

scene_Cg2.Enter = Enter
scene_Cg2.StarFight = StarFight
scene_Cg2.Damage = Damage
scene_Cg2.EnterFinish = EnterFinish
scene_Cg2.Leave = Leave
scene_Cg2.PlayerEnterScene = PlayerEnterScene

return scene_Cg2

