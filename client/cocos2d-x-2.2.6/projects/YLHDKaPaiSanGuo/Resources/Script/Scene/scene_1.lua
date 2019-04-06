
--add by sxin 场景脚本
--场景id = 1的脚本
--这个脚本不能点击战斗界面的暂停按钮

module("scene_1", package.seeall)

function Enter( self )
	scene_logic.Enter(self)
	if BaseSceneDB.GetBattleData_Star() > 0 then
		return
	end
	local pUI = self.m_ScenceInterface:Get_UILayer()
	if pUI ~= nil then
		pUI:setVisible(false)
	end
end

function EnterFinish(self)		
	self.m_ScenceInterface.UISetPauseEnabled(false)	
	scene_logic.ShowTeamPlay(0,false)
	scene_logic.ShowTeamPlay(5,false)
	scene_logic.ShowTeamPlay(15,false)		

end

--测试
function PlayerEnterScene( self )
	if BaseSceneDB.GetBattleData_Star() > 0 then
		scene_logic.BasePlayerEnterScene(self)
		return
	end
	scene_logic.StopPlayerEnterScene(self)
end

function StarFight( self,times )
	scene_logic.StarFight(self,times)
	if BaseSceneDB.GetBattleData_Star() > 0 then
		return false
	end
	local function Callback( nCurTalkId,nNextTalkId )
		print("0.............",nCurTalkId,nNextTalkId)
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 1000 then
			local function EffectEntercallback(  )
				--对话
				HeroTalkLayer.setCallBackFun(Callback)
				HeroTalkLayer.createHeroTalkUI(1001)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(true)
				end
			end
			--主角出场
			-- scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",1,false,2,14,ccp(PlayBirthPoint[2].x,PlayBirthPoint[2].y),self,EffectEntercallback)
			-- scene_logic.PlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",1,false,1,self,EffectEntercallback)
			-- scene_logic.PlayerFastRunEnter(1,self,EffectEntercallback)

		end
		
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 1001 then
			local function EffectEntercallback(  )
				--对话
				HeroTalkLayer.setCallBackFun(Callback)
				HeroTalkLayer.createHeroTalkUI(1003)
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(false)
				end
			end
			-- self.Ain_sunshangxiang
			-- scene_logic.PlayerFastRunLeave(4,self,nil)
			local pos = ccp(PlayBirthPoint[4].x,PlayBirthPoint[4].y)
			scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,true,4,6013,pos,self,EffectEntercallback)		
		
		end	
		
		if tonumber(nCurTalkId) == 0 and tonumber(nNextTalkId) == 1005 then
			local function EffectEntercallback(  )
				self.m_ScenceInterface:StarFight()
				local pUI = self.m_ScenceInterface:Get_UILayer()
				if pUI ~= nil then
					pUI:setVisible(true)
				end
			end
			EffectEntercallback()
		end	
	end
	if times == 1 then
		local function EffectEntercallback(  )
			HeroTalkLayer.setCallBackFun(Callback)
			HeroTalkLayer.createHeroTalkUI(1000)
		end
		
		scene_logic.PlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",1,false,1,self,EffectEntercallback)
		BaseScene.CreatPlayer(5,6038)
		scene_logic.CreatPlayerEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,true,5,6038,pos,self,nil)		
		
		local pUI = self.m_ScenceInterface:Get_UILayer()
		if pUI ~= nil then
			pUI:setVisible(false)
		end
		return true
	end
	if times == 2 then
		HeroTalkLayer.setCallBackFun(Callback)
		HeroTalkLayer.createHeroTalkUI(1002)
		local pUI = self.m_ScenceInterface:Get_UILayer()
		if pUI ~= nil then
			pUI:setVisible(false)
		end
		return true
	end
	if times == 3 then
		local function EffectEntercallback()
				
			HeroTalkLayer.setCallBackFun( Callback )
			HeroTalkLayer.createHeroTalkUI(1003)
			local pUI = self.m_ScenceInterface:Get_UILayer()
			if pUI ~= nil then
				pUI:setVisible(false)
			end
		end
		EffectEntercallback()
		
		return true
	end
	return false
end

function EndFight( self,times )
	scene_logic.EndFight(self,times)
	if BaseSceneDB.GetBattleData_Star() > 0 then
		return false
	end

	return false
end

local scene_1 = scene_logic.CreateBaseScene(1)

-- scene_1.Enter = Enter
-- scene_1.StarFight = StarFight
-- scene_1.EndFight = EndFight
-- scene_1.PlayerEnterScene = PlayerEnterScene
-- scene_1.EnterFinish = EnterFinish



return scene_1

