
--add by sxin 场景脚本
--场景id = 1的脚本

module("scene_pk", package.seeall)

--战斗波数
function EndFight( self,times )	
	
	--print("scene_pk:EndFight: times = " .. times)	
	return false
		
end

--死亡触发事件 死亡索引 攻击者索引
function Die( self,DiePos , attackPos )	
	
	--print("Scene_1:Die: DiePos = " .. DiePos .."attackPos =" .. attackPos)		
	if BaseSceneDB.IsDie(attackPos) == false then 
		BaseSceneLogic.playEngine(attackPos,Kill_Engine_Back)
	end
		
end

local scene_pk = scene_logic.CreateBaseScene(100)

scene_pk.Die = Die
scene_pk.EndFight = EndFight

return scene_pk

