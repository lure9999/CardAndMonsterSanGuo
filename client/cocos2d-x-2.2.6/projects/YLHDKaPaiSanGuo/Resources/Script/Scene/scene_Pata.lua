
--add by sxin 场景脚本
--场景id = 200的脚本 爬塔的场景专用脚本

module("scene_Pata", package.seeall)

local m_Shixiang_Tag = 14086
local m_Middle_Tag = 12000
--战斗波数
function EndFight( self,times )		
	
	--test-加血
	if times < BaseSceneDB.GetAllTimes() then 	
		scene_logic.TeamPlayRecovery()		
	end
	
	if times == BaseSceneDB.GetAllTimes() then 
		
		--播放龙出来的动画
			local m_pGameNode_Middle = self.m_ScenceRoot:getChildByTag(m_Middle_Tag)			
						
			local pCCComRenderShixiang = tolua.cast(m_pGameNode_Middle:getChildByTag(m_Middle_Tag):getChildByTag(m_Shixiang_Tag):getComponent("CCArmature"),"CCComRender")	
			
			if pCCComRenderShixiang ~= nil then 
				
				local pShixiang = tolua.cast(pCCComRenderShixiang:getNode(),"CCArmature")
			
				pShixiang:getAnimation():play("Animation2")
			
			end	
	end	
			
	FightUILayer.TakeAllBox()
	
	return false
		
end

local scene_Pata = scene_logic.CreateBaseScene(200)

scene_Pata.EndFight = EndFight

return scene_Pata

