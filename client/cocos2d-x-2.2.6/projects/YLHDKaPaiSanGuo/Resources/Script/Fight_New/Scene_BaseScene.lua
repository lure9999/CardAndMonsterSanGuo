
--基本场景需求
module("Scene_BaseScene", package.seeall)
require "Script/Fight_New/Scene_BaseDB"
require "Script/Fight_New/Scene_BaseLogic"

--战斗ui接口 需要重构
--[[
local	UI_pclearEnemy 				= 	FightUILayer.clearEnemy
local	UI_paddEnemyInfo 			= 	FightUILayer.addEnemyInfo
local	UI_psetDefaultTag 			=	FightUILayer.setDefaultTag
local	UI_pSetFightDelayTime 		= 	FightUILayer.SetFightDelayTime
local	UI_pStopFightDelayTime 		=	FightUILayer.StopFightDelayTime
local	UI_pContinueFightDelayTime 	=	FightUILayer.ContinueFightDelayTime
local	UI_pSetFightTitleAround 	=	FightUILayer.SetFightTitleAround
local	UI_pSetFightHp 				=	FightUILayer.SetFightHp
local	UI_pSetFightPower 			=	FightUILayer.SetFightPower
local	UI_psetHuFaInfo 			=	FightUILayer.setHuFaInfo
local	UI_penemyDeadth 			=	FightUILayer.enemyDeadth
local	UI_psetHuFaInfo 			=	FightUILayer.setHuFaInfo
local	UI_pSetFightTitleMoney 		=	FightUILayer.SetFightTitleMoney
local	UI_pSetFightTitleBox 		=	FightUILayer.SetFightTitleBox
local	UI_pCreateFightUILayer 		=	FightUILayer.CreateFightUILayer
local	UI_psetFightContrlColor 	=	FightUILayer.setFightContrlColor

local	UI_pBeginFightByUI	 		=	FightUILayer.BeginFightByUI
local	UI_pEndFightByUI		 	=	FightUILayer.EndFightByUI

--战斗结果接口
local	UI_Res_pShowResultDly			= 	FightResultLayer.ShowResultDly
local	UI_Res_pSetFightData 			= 	FightResultLayer.SetFightData
local	UI_Res_pSetFightStar 			= 	FightResultLayer.SetFightStar
local	UI_Res_pSetFightName 			= 	FightResultLayer.SetFightName
local	UI_Res_pSetAwardItem 			= 	FightResultLayer.SetAwardItem
local	UI_Res_psetFightSeeData 		= 	FightResultLayer.setFightSeeData
local	UI_Res_pInitFightResultDlg 		= 	FightResultLayer.InitFightResultDlg
local	UI_Res_pSetFightAwardId 		= 	FightResultLayer.SetFightAwardId

--add by sxin 单挑的界面
local 	UI_Res_pInitCityWarSingleResultDlg  = FightResultLayer.InitCityWarSingleResultDlg
local	UI_Res_pShowCityWarSingleResultDly	= 	FightResultLayer.ShowCityWarSingleResultDly

--Loading 界面接口
local	UI_Loading_Show 			= 	LoadingLayer.Show
local	UI_Loading_SetResTable 		= 	LoadingLayer.SetResTable
local	UI_Loading_GetLoadingUI 	= 	LoadingLayer.GetLoadingUI
local	UI_Loading_SetCallBackFun 	= 	LoadingLayer.SetCallBackFun

]]--

--Loading 界面接口

require "Script/Common/Common"
require "Script/Login/DownLoadLayer"
--require "Script/Common/CommonInterface"
require "Script/Login/LoadingNewLayer"	
local	UI_Loading_Show 			= 	LoadingNewLayer.ShowLoading--LoadingLayer.Show
local	UI_Loading_SetResTable 		= 	LoadingNewLayer.SetLoadResTable--LoadingLayer.SetResTable
local	UI_Loading_GetLoadingUI 	= 	LoadingNewLayer.GetLoadingLayerUI--LoadingLayer.GetLoadingUI
local	UI_Loading_SetCallBackFun 	= 	LoadingNewLayer.SetFCallBack--LoadingLayer.SetCallBackFun


local function GetFightLoadingRes( self )
	return self.m_baseDB:Fun_GetFightLoadingRes()
end

-- 根据数据创建
local function InitPlayAndNpc( self )
		
	self.m_baseDB:Fun_CreatTeamRander(self.m_RenderData.m_Layer_Root)
	--print("创建角色的到场景")
			
end
local function InitFightScene( self )

--获取场景ID
	local Scene_Data = SceneData.getDataById( self.m_baseDB:Fun_GetScenceID() )		
	self.m_RenderData.m_pGameScene = SceneReader:sharedSceneReader():createNodeWithSceneFile(Scene_Data[SceneData.getIndexByField("ScenceFileName")])
	self.m_RenderData.m_FightScene:addChild(self.m_RenderData.m_pGameScene)
	self.m_RenderData.m_pGameNode_Back = self.m_RenderData.m_pGameScene:getChildByTag(G_FightScene_Layer_Back_TagID)
	self.m_RenderData.m_pGameNode_Middle = self.m_RenderData.m_pGameScene:getChildByTag(G_FightScene_Layer_Middle_TagID)
	self.m_RenderData.m_pGameNode_Front = self.m_RenderData.m_pGameScene:getChildByTag(G_FightScene_Layer_Front_TagID)	
	self.m_RenderData.m_Layer_Root = TouchGroup:create()
	self.m_RenderData.m_DamageLayer = TouchGroup:create()			
	self.m_RenderData.m_UILayer = TouchGroup:create()	
	self.m_RenderData.m_FightScene:addChild(self.m_RenderData.m_UILayer,UILayer_Z)	
	self.m_RenderData.m_BlackLayer = CCLayerColor:create(BlackLayerColour4,1140*4,640)
	self.m_RenderData.m_BlackLayer:setOpacity(0)
	self.m_RenderData.m_Layer_Root:addChild(self.m_RenderData.m_BlackLayer,0)	
	self.m_RenderData.m_pGameNode_Middle:addChild(self.m_RenderData.m_Layer_Root,Layer_Root_Z)
	self.m_RenderData.m_pGameNode_Middle:addChild(self.m_RenderData.m_DamageLayer,EffectLayer_Z)	
	
	--创建选择光环
	local pEffectData = EffectData.getDataById(1)	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pEffectData[EffectData.getIndexByField("fileName")])	
	self.m_RenderData.m_pArmatureSelect = CCArmature:create(pEffectData[EffectData.getIndexByField("EffectName")])	
	self.m_RenderData.m_pArmatureSelect:setTag(G_SelectGuangquanTag)
	self.m_RenderData.m_pArmatureSelect:getAnimation():playWithIndex( tonumber(pEffectData[EffectData.getIndexByField("AnimationID_0")]))
	self.m_RenderData.m_pArmatureSelect:retain()			
	
	--创建脚本	
	local pSceneSprit = self.m_baseDB:Fun_CreateSceneScript()	
	pSceneSprit:Fun_Create(self)	
	pSceneSprit:Fun_Enter()	
	
	---战场可以一样的ui也可以不一样
	if self.m_baseDB:Fun_IsPKScene() == true then	
		-----pk要锁住自动施法
		self.m_baseDB.m_bAutoFight = true				
	else	
		
	end		
	
	InitPlayAndNpc(self)		
	pSceneSprit:Fun_EnterFinish()

	if self.m_UIInterface ~= nil then
		self.m_UIInterface:Fun_CreateTestUI( self.m_RenderData.m_UILayer )

	end	
	
	return true
end

local function AddLoadingUI( self )
		
	local function CallBack( ... )		
		--显示战斗界面		
		if InitFightScene(self)	== true then 	
			
			self:Fun_SetFightTimer(0.2,E_FightTimer.E_FightTimer_SceneEnter)	
		else
			self:Fun_SetFightTimer(0.2,E_FightTimer.E_FightTimer_TestSceneEnter)				
		end
	end
	
	UI_Loading_SetResTable(GetFightLoadingRes(self))
	local layerTemp = UI_Loading_GetLoadingUI(LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil)
	--local layerTemp = UI_Loading_GetLoadingUI(4,nil)
	self.m_RenderData.m_FightScene:addChild(layerTemp, 10, layerLoading_Tag)	
	--self.m_RenderData.m_FightScene:addChild(layerTemp, 10, 1000)	
	UI_Loading_Show(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil,false)
	--UI_Loading_Show(true,4,nil,false)
	UI_Loading_SetCallBackFun(CallBack)
	
	
end


--开始战斗前出发脚本传入次数
local function StarFight( self )
	--print("StarFight")
	--Pause()
	
	if self.m_baseDB.m_pSceneSprit:Fun_StarFight() == false then		
		Scene_BaseLogic.StarFight(self)
	end
	
end

local function EndFight(self)
	
	--更新当前的战斗次数	
	if self.m_baseDB.m_pSceneSprit:Fun_EndFight() == false then			
		Scene_BaseLogic.EndFight(self)
	end
	self.m_baseDB:Fun_AddTimes()	
end

local function PauseFight(self)
		
end

local function ContinueFight(self)
			
end



--跑图逻辑
local function PlaySceneEnter(self)

	local function CB_PlaySceneEnter(pNode)
		
		self:Fun_StarFight()
	end
		
	local pcallFunc = CCCallFuncN:create(CB_PlaySceneEnter)
	
	local pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance*0.5,0))
	local pMoveseq  = CCSequence:createWithTwoActions(pMoveBy, pcallFunc)

	self.m_RenderData.m_pGameNode_Back:runAction(pMoveseq)	
	
	pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance,0))	
	self.m_RenderData.m_pGameNode_Middle:runAction(pMoveBy)	

	pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance*1.5,0))	
	self.m_RenderData.m_pGameNode_Front:runAction(pMoveBy)	
	
	--角色进入场景	
	self.m_baseDB:Fun_PlaySceneEnter()	
	--UI_pSetFightTitleAround( (itimes+1) ,BaseSceneDB.GetAllTimes())

	--SetUi_EnemyInfo(itimes+1)
	
	
end

local function Die( self,Dieobj , attackobj )	
	
				
end

local function Damage( self,Damageobj )	
	
					
end


--时间到了战斗结束
local function OnTimeOver(self)
	self:Fun_EndFight()	
end


local function SetFightTimer(self,fTime, pData)
	
	local function OnFightTimer(pNode)	
		
		if pNode == self.m_RenderData.m_FightScene then		
			
			if pNode:getTag() == E_FightTimer.E_FightTimer_ApplyFight then				
				
				PlaySceneEnter(self)
				
				--test 结束				
				--Scene_Manger.LeaveBaseScene()				
				
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_PlayCheers then		

				self.m_baseDB:Fun_PlayCheers()					
				self:Fun_SetFightTimer(ShowFightResoutTime-ShowCheersTime,E_FightTimer.E_FightTimer_ShowFightResout)
				
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_ShowFightResout then
						
				if self.m_baseDB:Fun_IsCityWarSingleScene() == true then
				
					if self.m_baseDB:Fun_GetFightResult() ==1 then			
					
						--UI_Res_pShowCityWarSingleResultDly(true)
						
					elseif self.m_baseDB:Fun_GetFightResult() ==0 then
						
						--UI_Res_pShowCityWarSingleResultDly(false)	
						
					end
				
					
				elseif self.m_baseDB:Fun_IsCityWarScene() == true then
					
					--无界面
					self:Fun_LeaveScene()
					
				else
				
					local iPointID = self.m_baseDB:Fun_GetpointID()
					local pointname = point.getFieldByIdAndIndex(iPointID,"Name")
				
					if self.m_baseDB:Fun_GetFightResult() ==1 then
					
						--PlayCheers()--显示 金币 银币 经验	显示物品	
						local rewardID = tonumber(point.getFieldByIdAndIndex(iPointID,"RewardID"))
						
						--UI_Res_pSetFightAwardId(rewardID)									
						--UI_Res_pSetFightStar(BaseSceneDB.GetBattleFight_Star())					
						--UI_Res_pSetFightName(pointname)						
						--UI_Res_pSetAwardItem(BaseSceneDB.GetDropData())
						--UI_Res_pShowResultDly(true)
						
					elseif self.m_baseDB:Fun_GetFightResult() ==0 then
						--UI_Res_pSetFightAwardId(-1)				
						--UI_Res_pSetFightStar(-1)					
						--UI_Res_pSetFightName(pointname)		
						--UI_Res_pShowResultDly(false)	
						
					end
					
					--local pBattleDamageList = FightbattleData.GetBattleFight_Damage_Data(BaseSceneDB.GetBattleID())
					--UI_Res_psetFightSeeData(pBattleDamageList)
					
					--test 结束					
					--Scene_Manger.LeaveBaseScene()
				
				end				
				
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_SceneEnter then	
								
				self.m_baseDB.m_pSceneSprit:Fun_PlayerEnterScene()
				UI_Loading_Show(false)
				
			elseif pNode:getTag() == E_FightTimer.E_FightTimer_TestSceneEnter then	
							
				UI_Loading_Show(false)
											
			end
			
			
		end
		
	end

	local pcallFunc = CCCallFuncN:create(OnFightTimer)
	
	local pDelay = CCDelayTime:create(fTime)
	
	local pSequence  = CCSequence:createWithTwoActions(pDelay, pcallFunc)
	
	self.m_RenderData.m_FightScene:setTag(pData)
	self.m_RenderData.m_FightScene:runAction(pSequence)
	
	
end

--创建引擎场景
local function InitBaseScene( self )
	
	local index = 0
	local function NetUpdata(dt)
		UpNetWork()
		
		--测试退出
		--index = index +1
		--print("UpNetWork" .. index)
		
		--if index == 90 then
		--	self:Fun_OnTimeOver()
		--	Scene_Manger.LeaveBaseScene()
		--end
	end	

	local function BaseSceneEvent(tag)
	
		if tag == "enter" then				
			--self.m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, CommonData.g_nNetUpdataTime, false)	
			self.m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, 1, false)	
			AddLoadingUI(self)
		end
		
		if tag == "enterTransitionFinish" then	
		
		end	
		
		if tag == "exit" then				
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nHanderTime)	
				
		end	
		
		if tag == "exitTransitionStart" then		
			
		end	
		
		if tag == "cleanup" then			
			--print("release scence")	
			Scene_Manger.ReleaseScence()
			
		end	
		
	end
	
			
	self.m_RenderData.m_FightScene = CCScene:create()			
	self.m_RenderData.m_FightScene:registerScriptHandler(BaseSceneEvent)			

	return true
	
end


-- 解析各种战斗数据 根据类型扩展 1推图 2pk等写枚举
local function InitServerData(self,pNetStream)
	--数据层解析网络数据
	--self.m_baseDB:InitServerFightData(pNetStream)
	-- 根据m_Scene_Type 来区分子接口
	--测试接口 先不对接网络数据
	
	self.m_baseDB:Fun_InitTestFightData(1,2)
	--self.m_baseDB:Fun_InitTestFightData(math.random(1, 5),math.random(1, 5))
	
	--从pNetStream里先解析出技能组和
	
end


local function LeaveBaseScene(self)	
	--self:Fun_EndFight()	
	CCDirector:sharedDirector():popScene()
end

local function EnterBaseScene(self)

	--初始化战斗场景数据				
	InitBaseScene(self)
	
	--InitFightScene( self )
	
	CCDirector:sharedDirector():pushScene(self.m_RenderData.m_FightScene);
	
end

-- 添加节点的获取方法便于脚本层调用
local function Get_pGameScene(self)
	return 	self.m_RenderData.m_pGameScene
end

local function Get_pLayerRoot(self)
	return 	self.m_RenderData.m_Layer_Root
end

local function Get_DamageLayer(self)
	return 	self.m_RenderData.m_DamageLayer
end

local function IsFightEnd(self)
	return 	self.m_baseDB:Fun_IsFightEnd()
end

local function IsPKScene(self)
	return 	self.m_baseDB:Fun_IsPKScene()
end

local function IsCityWarSingleScene(self)
	return 	self.m_baseDB:Fun_IsCityWarSingleScene()
end

local function IsCityWarScene(self)
	return 	self.m_baseDB:Fun_IsCityWarScene()
end

local function IsPFubencene(self)
	return 	self.m_baseDB:Fun_IsPFubencene()
end

local function GetFightTimes(self)
	return 	self.m_baseDB:Fun_GetFightTimes()
end

local function UI_UseSkill(self,pSkillData,icount)	
	--ui调用
	--print("UI_UseSkill")
	--Pause()
	if icount>0 and icount <= 3 then
		pSkillData.m_iCount = icount
	end
	return Scene_BaseLogic.ObjUseSkill(self,pSkillData)	
end

local function SetUIInterface(self,pUIInterface)
	
	print("SetUIInterface")
	self.m_UIInterface = pUIInterface
	
end

--增加技能
local function AddSkillSkilltick(self,groupIndex,groupType)		
	--print("AddSkillSkilltick")	
	if self.m_UIInterface ~= nil then
		local skillgroup = self.m_baseDB:Fun_GetSkillGroup(groupIndex)
		local skillData = skillgroup[groupType]
		--[[print(groupIndex,groupType)
		print(skillData.igroupIndex)
		Pause()]]
		if skillData ~= nil then
			self.m_UIInterface:Fun_AddSkill(skillData.m_FaceID,skillData.m_SkillID,skillData.m_SkillIndex,skillData.m_groupIndex,skillData)
		end
		
	end
		
end



local function Release(self)	
		
	self.Fun_InitServerData = nil					
	self.Fun_Release	    = nil
	self.Fun_EnterScene  = nil
	self.Fun_LeaveScene  = nil
	self.Fun_OnTimeOver		= nil
	self.Fun_StarFight		= nil
	self.Fun_EndFight		= nil	
	self.Fun_PauseFight		= nil
	self.Fun_ContinueFight	= nil		
	self.Fun_SetFightTimer 	= nil
	self.Fun_Get_pGameScene  = nil
	self.Fun_IsFightEnd		= nil	
	self.Fun_IsPKScene 				= nil
	self.Fun_IsCityWarSingleScene 	= nil
	self.Fun_IsCityWarScene 		= nil
	self.Fun_IsPFubencene 			= nil
	self.Fun_GetFightTimes			= nil
	
	--增加UI调用接口
	self.Fun_UI_UseSkill			= nil
	
	--渲染接口指针
	self.m_RenderData.m_FightScene = nil
	self.m_RenderData.m_pGameScene = nil
	self.m_RenderData.m_pGameNode_Back = nil
	self.m_RenderData.m_pGameNode_Middle = nil
	self.m_RenderData.m_pGameNode_Front = nil
	self.m_RenderData.m_Layer_Root = nil
	self.m_RenderData.m_DamageLayer = nil
	self.m_RenderData.m_UILayer = nil
	self.m_RenderData.m_BlackLayer = nil
	self.m_RenderData.m_pArmatureSelect = nil	
	self.m_RenderData = nil
	
	--战队数据 初始化战队数据 封装战队数据这里创建接口	
	self.m_nHanderTime =nil
	self.m_Scene_Type = nil
	self.m_baseDB:Fun_Release()	
	
	
end

function CreatBaseSceneData()

	local SceneData = {
					-- 操作接口
					-- 初始化网络数据
					
					Fun_InitServerData = InitServerData,					
					Fun_Release		   = Release,
					Fun_EnterScene  = EnterBaseScene,
					Fun_LeaveScene  = LeaveBaseScene,

					Fun_OnTimeOver		= OnTimeOver,
					Fun_StarFight		= StarFight,
					Fun_EndFight		= EndFight,		
					Fun_PauseFight		= PauseFight,
					Fun_ContinueFight	= ContinueFight,		
					Fun_SetFightTimer 	= SetFightTimer,
					Fun_Get_pGameScene  = Get_pGameScene,
					Fun_Get_pLayerRoot  = Get_pLayerRoot,
					Fun_Get_DamageLayer	= Get_DamageLayer,
					Fun_IsFightEnd		= IsFightEnd,
					
					Fun_IsPKScene 				= IsPKScene,
					Fun_IsCityWarSingleScene 	= IsCityWarSingleScene,
					Fun_IsCityWarScene 			= IsCityWarScene,
					Fun_IsPFubencene 			= IsPFubencene,
					Fun_GetFightTimes			= GetFightTimes,
					
					--增加UI调用接口
					Fun_UI_UseSkill			= UI_UseSkill,
					Fun_SetUIInterface		= SetUIInterface,
					Fun_AddSkillSkilltick	= AddSkillSkilltick,					
					
					--渲染接口指针
					m_RenderData = {	
									m_FightScene = nil, 
									m_pGameScene = nil,
									m_pGameNode_Back = nil,
									m_pGameNode_Middle = nil,
									m_pGameNode_Front = nil,
									m_Layer_Root = nil,
									m_DamageLayer = nil,
									m_UILayer = nil,
									m_BlackLayer = nil,
									m_pArmatureSelect = nil,	
									
									},
					--战队数据 初始化战队数据 封装战队数据这里创建接口	
					m_nHanderTime =nil,
					m_nSkillHanderTime =nil,
					m_Scene_Type = Scene_Type.Type_Base,
					m_baseDB = Scene_BaseDB.CreateBaseDB(),
					m_UIInterface = nil,					
					}	
	return  SceneData
	
end









