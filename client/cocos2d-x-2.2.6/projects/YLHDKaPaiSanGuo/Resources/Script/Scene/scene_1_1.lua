--add by sxin 1-1场景故事剧本
module("scene_1_1", package.seeall)

function Enter(self)	

	scene_logic.Enter(self)
	
	if BaseSceneDB.GetBattleData_Star() > 0 then 
		return
	end
		
	--优化找主角
	local i = 1
	local ifind = 0
	for i=1, MaxTeamPlayCount, 1 do
		local iTempID = BaseSceneDB.GetTeamData(i).m_TempID
		
		if iTempID	~= 80011 and  iTempID	~= 81011 then 
			--删除角色
			BaseSceneDB.GetTeamData(i).m_TempID = -1
			BaseSceneDB.GetTeamData(i).m_TempResid = -1
		else			
			ifind = 1
		end
	end
	if ifind == 0 then 
		--创建主角
		print("创建主角")
		--Pause()
		if FightServer.CreatPlayData(1,80011) == false then 
	
			print("创建角色失败")
		
		end
	end	
	
	self.bCallDamagge = false
	
	local pUI = self.m_ScenceInterface:Get_UILayer()
	if pUI ~= nil then
		pUI:setVisible(false)
	end
	
end

function EnterFinish(self)			
	
	if BaseSceneDB.GetBattleData_Star() > 0 then 
		return
	end
	
	scene_logic.ShowTeamPlay(0,false)
	scene_logic.ShowTeamPlay(5,false)
	scene_logic.ShowTeamPlay(15,false)
	
end

function PlayerEnterScene(self)
	
	if BaseSceneDB.GetBattleData_Star() > 0 then 
		scene_logic.BasePlayerEnterScene(self)
		return
	end
	scene_logic.StopPlayerEnterScene(self)
	
end


function StarFight(self, times )

	scene_logic.StarFight(self,times)
	
	if BaseSceneDB.GetBattleData_Star() > 0 then 
		
		return false
	end
		
	local function Callback(nCurTalkId, nNextTalkId)		
	
		--print("对话Id = " .. nCurTalkId .. " " .. nNextTalkId)
		--Pause()			 

		if 	tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 7 then  						
		
			local function EffectEntercallback()
				
				--对话
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(8)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
			
			end
			
			--主角出场
			--scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",1,false,2,14,ccp(PlayBirthPoint[2].x,PlayBirthPoint[2].y),self,EffectEntercallback)
			scene_logic.PlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",1,false,1,self,EffectEntercallback)
			--scene_logic.PlayerFastRunEnter(1,self,EffectEntercallback)
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 8  then
			
			--张角带着小兵从右侧冲出来
			local function Runcallback()
				
				--对话
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(9)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
			
			end
			
			scene_logic.PlayerFastRunEnter(6,self,nil)
			scene_logic.PlayerFastRunEnter(7,self,nil)
			
			self.Ain_zhangjiao = scene_logic.CreatPlayer_NotFight(8,1010523,ccp(EnemyBirthPoint[3].x,EnemyBirthPoint[3].y),self)			
			scene_logic.PlayerFastRun_Armature( self.Ain_zhangjiao,true,self,1 , Runcallback)
			
			--self.Ain_zhangjiao = scene_logic.CreatPlayerEffectEnter_NotFight(Brith_Ain_File_0,Brith_Ain_Name_0,0,false,8,20004,ccp(EnemyBirthPoint[3].x,EnemyBirthPoint[3].y),self,Runcallback)
		
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 10  then
		
			
			local function Run_zhangjiaocallback()
				
				self.Ain_zhangjiao:setPosition(EnemyBirthPoint[5].x + (self.m_Times-1)*MaxMoveDistance , EnemyBirthPoint[5].y+50)	
				self.Ain_zhangjiao:setVisible(true)				
				--对话
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(11)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
			
			end
			--张角跳到场边观战
			self.Ain_zhangjiao:setVisible(false)
			scene_logic.createEnterEffect(Brith_Ain_File_0,Brith_Ain_Name_0,0,true,self,ccp(EnemyBirthPoint[5].x,EnemyBirthPoint[5].y+50),Run_zhangjiaocallback)
			
			
		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 16  then
		
			
			local function Runcallback()
				
						
				--对话
				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(17)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
			
			end
			--张角带兵冲出来
			
			scene_logic.PlayerFastRunEnter(16,self,nil)
			scene_logic.PlayerFastRunEnter(17,self,nil)					
			scene_logic.PlayerFastRunEnter( 20,self,Runcallback)
			
		end
		
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 11  or tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 18  then
			
			
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
				
		HeroTalkLayer.setCallBackFun( Callback )
		HeroTalkLayer.createHeroTalkUI(7)
		local pUI = self.m_ScenceInterface:Get_UILayer()
		if pUI ~= nil then
			pUI:setVisible(false)
		end
		
		return true
	
	end	
	
	if times == 3 then
				
		local function EffectEntercallback()
				
			HeroTalkLayer.setCallBackFun( Callback )
			HeroTalkLayer.createHeroTalkUI(14)
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(false)
			end
			
		end
		
		--主角出场
		local pos = ccp(PlayBirthPoint[2].x,PlayBirthPoint[2].y)
		scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,true,2,6003,pos,self,EffectEntercallback)
		
		
		return true
	
	end	

	return false
end

function EndFight( self,times )		
	
	scene_logic.EndFight(self,times)	
	
	if BaseSceneDB.GetBattleData_Star() > 0 then 
		
		return false
	end
	
	local function Callback(nCurTalkId, nNextTalkId)

		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 12  then
	
			local function delcallback()
				
				self.Ain_zhangjiao:removeFromParentAndCleanup(true)			
				self.Ain_zhangjiao = nil

				HeroTalkLayer.setCallBackFun( Callback )
				HeroTalkLayer.createHeroTalkUI(13)

				
			
			end
			
			scene_logic.PlayerFastRun_Armature( self.Ain_zhangjiao,true,self,2 , delcallback)	

		end
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 13  then
			--结束战斗
			self.m_ScenceInterface:EndFight()
			
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(true)
			end
		end		
		
	end
	
	--test ---第3次调用对话
	if times == 1 then 
	
			--对话
		HeroTalkLayer.setCallBackFun( Callback )
		HeroTalkLayer.createHeroTalkUI(12)
		
		local pUI = self.m_ScenceInterface:Get_UILayer()
		if pUI ~= nil then
			pUI:setVisible(false)
		end
		
		return true
	
	end	
	
	
	
	return false
		
end

function Damage( self,iDamagePos )	
	
	if BaseSceneDB.GetBattleData_Star() > 0 then 		
		return
	end
	
	if self.bCallDamagge == true then 
	
		return
	
	end
	
	--print(iDamagePos)
	if iDamagePos == 20 then
		
		local pFighter = BaseSceneDB.GetTeamData(iDamagePos)	
		
		if pFighter.m_curblood <=  pFighter.m_allblood*0.5 then
		
			self.bCallDamagge = true
			
			
			local function Callback(nCurTalkId, nNextTalkId)			
					
				if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 19  then
						
					local function Runcallback()
								
							local pUI = self.m_ScenceInterface:Get_UILayer()
							if pUI ~= nil then
								pUI:setVisible(true)
							end
							
							BaseSceneDB.SetFightResult(1)							
							self.m_ScenceInterface:EndFight_SenenSprite()	
							
							
					end						
					--张角跑出屏幕
					scene_logic.PlayerFastRunLeave( 20,self,Runcallback)
					
				end
				
			end
			
			--触发情节
			self.m_ScenceInterface:PauseFight()	
			--对话
			HeroTalkLayer.setCallBackFun( Callback )
			HeroTalkLayer.createHeroTalkUI(19)
			
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(false)
			end
			
		end
		
	end
	
end

local Scene_1_1 = scene_logic.CreateBaseScene(6)

Scene_1_1.Enter = Enter
Scene_1_1.StarFight = StarFight
Scene_1_1.EndFight = EndFight
Scene_1_1.PlayerEnterScene = PlayerEnterScene
Scene_1_1.Damage = Damage
Scene_1_1.EnterFinish = EnterFinish

return Scene_1_1