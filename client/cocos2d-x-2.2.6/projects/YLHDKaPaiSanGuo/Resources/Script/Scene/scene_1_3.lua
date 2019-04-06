--add by sxin 1-1场景故事剧本
module("scene_1_3", package.seeall)

local Cg_Text = 
{
	{m_Text = "汉朝末年，天子无道，荒废朝政，朝堂危如累卵。",m_time = 5,},	
	{m_Text = "朝廷内，宦官、外戚相斗夺权，不料被董卓乘虚而入。",m_time = 8},	
	{m_Text = "董卓铲除异己，纵容兵士，一时间，百姓苦不堪言。",m_time = 6},
	{m_Text = "至此，诸侯并起，天下大乱。九天仙人，悲悯苍生。",m_time = 6},
	{m_Text = "英雄破空降世，欲平定乱世以拯救天下苍生与水火。",m_time = 5},
					
}

function Enter(self)	

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
	
	if BaseSceneDB.GetBattleData_Star() > 0 then 
		return
	end
	
	scene_logic.ShowTeamPlay(0,false)
	scene_logic.ShowTeamPlay(5,false)
	
	local iCgIndex = 1
	
	local function effectFrameEvent( bone,evt,originFrameIndex,currentFrameIndex )
		
		if evt == "bo" then 
		
			local pArmature = bone:getArmature()
			
			scene_logic.Play_Cg_Text(pArmature,Cg_Text[iCgIndex],-285)
			
		end
		
	end
	
	local function effectEnd_Over()
	
		scene_logic.BasePlayerEnterScene(self)
		scene_logic.ShowTeamPlay(0,true)
		scene_logic.ShowTeamPlay(5,true)
		
		local pUI = self.m_ScenceInterface:Get_UILayer()
		if pUI ~= nil then
			pUI:setVisible(true)
		end
	
	end
	
	local function effectEnd_5()
		iCgIndex = 5
		
		local iSex = CommonData.g_MainDataTable["gender"]  --1--man 2--woman
		
		if iSex == 1 then 
			scene_logic.createEffect_Scence("Image/Fight/cg/piantou06/piantou06.ExportJson","piantou06",0,false,self,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_Over,effectFrameEvent)
		else
			scene_logic.createEffect_Scence("Image/Fight/cg/piantou06/piantou06.ExportJson","piantou06",1,false,self,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_Over,effectFrameEvent)
		end		
		
	end
	
	local function effectEnd_4()
		iCgIndex = 4
		scene_logic.createEffect_Scence("Image/Fight/cg/piantou05/piantou05.ExportJson","piantou05",0,false,self,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_5,effectFrameEvent)
		
	end
	
	local function effectEnd_3()
		iCgIndex = 3
		scene_logic.createEffect_Scence("Image/Fight/cg/piantou04/piantou04.ExportJson","piantou04",0,false,self,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_4,effectFrameEvent)
		
	end
	
	local function effectEnd_2()
		iCgIndex = 2
		scene_logic.createEffect_Scence("Image/Fight/cg/piantou03/piantou03.ExportJson","piantou03",0,false,self,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_3,effectFrameEvent)
		
	end
	
		
	scene_logic.createEffect_Scence("Image/Fight/cg/piantou02/piantou02.ExportJson","piantou02",0,false,self,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_2,effectFrameEvent)
	
end

function PlayerEnterScene(self)	

	--scene_logic.BasePlayerEnterScene(self)
	
end

function StarFight(self, times )

	scene_logic.StarFight(self,times)
	
	return false
	
end


local Scene_1_3 = scene_logic.CreateBaseScene(8)

Scene_1_3.Enter = Enter
Scene_1_3.EnterFinish = EnterFinish
Scene_1_3.StarFight = StarFight
Scene_1_3.PlayerEnterScene = PlayerEnterScene
return Scene_1_3