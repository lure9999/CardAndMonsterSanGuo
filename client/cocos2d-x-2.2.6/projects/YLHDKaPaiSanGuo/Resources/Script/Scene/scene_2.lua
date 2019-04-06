module("scene_2", package.seeall)

local BossPos = 18

function EnterFinish(self)		
	
	--BaseSceneDB.GetTeamData(1).m_add_gongji = 1000		
	--BaseSceneDB.GetTeamData(1).m_add_fangyu = 1000	
	--BaseSceneDB.GetTeamData(1).m_curblood = 10000			
	local pBoss = BaseSceneDB.GetPlayArmature(BossPos)
		
	if pBoss ~= nil then
		pBoss:setPosition(ccp(pBoss:getPositionX()+110,195))
		pBoss:setVisible(false)				
	end	
end

function StarFight(self, times )
	
	scene_logic.StarFight(self,times)	
	
	if self.m_Times == 3 then				
		
		local function DelTimeCallBack(pNode)				
			
			local pBoss = BaseSceneDB.GetPlayArmature(BossPos)
		
			if pBoss ~= nil then	
				
				pBoss:getAnimation():play("birth")
				AudioUtil.playEffect("audio/death/jixieguai_birth.mp3",false)
				pBoss:setVisible(true)			
							
			end	
			
			
			local function DelTimeCallBack1(pNode)	
				
				self.m_ScenceInterface:StarFight()
				
			end
			local pcallFunc = CCCallFuncN:create(DelTimeCallBack1)				
			BaseSceneLogic.SetNodeTimer(self.m_ScenceRoot,2.5,pcallFunc,0)
		end

		local pcallFunc = CCCallFuncN:create(DelTimeCallBack)				
		BaseSceneLogic.SetNodeTimer(self.m_ScenceRoot,0.1,pcallFunc,0)
		
		--pBoss:setPosition(ccp(pBoss:getPositionX()+110,195))
		return true
	end

	return false
end


local scene_2 = scene_logic.CreateBaseScene(2)
scene_2.StarFight = StarFight
scene_2.EnterFinish = EnterFinish
return scene_2












