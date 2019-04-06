
--add by sxin 场景脚本


module("scene_101", package.seeall)


--战斗波数
function StarFight(self, times )	
	
	self.m_Times = times
	
	local icount = 0
	local iMaxCount = 0
		
	--test ---第2次改变怪物出场效果
	if times <= 3 and times > 1 then
		
		local function callback()
			
			self.m_ScenceInterface:StarFight()
			
		end
		
		return scene_logic.TeamPlayEffectEnter("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001",1,self,callback)
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


local scene_101 = scene_logic.CreateBaseScene(5)

scene_101.StarFight = StarFight
scene_101.EndFight = EndFight

return scene_101

