
--add by sxin 场景脚本


module("scene_100", package.seeall)

function Enter(self)			
	self.m_Times = 1		
	scene_logic.ShowTeamPlay(5,false)		
end

--战斗波数
function StarFight(self, times )	
	
	self.m_Times = times
			
	--test ---第2次改变怪物出场效果
	if times <= 3 and times >= 1 then
		
		local function callback()
			
			self.m_ScenceInterface:StarFight()
			
		end
		
		return scene_logic.TeamPlayEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",0,self,callback)
		
	end	
	
	return false
		
end


--战斗波数
function EndFight( self,times )		
	
	--print("scene_3:EndFight: times = " .. times)
	--Pause()
	if times <= 2 then 		
		scene_logic.ShowTeamPlay((times+1)*5,false)		
	end
		

	if times <= 2 then 	
		scene_logic.TeamPlayRecovery()		
	end
	
		
	FightUILayer.TakeAllBox()
	
	return false
		
end


local scene_100 = scene_logic.CreateBaseScene(4)

scene_100.Enter = Enter
scene_100.StarFight = StarFight
scene_100.EndFight = EndFight

return scene_100

