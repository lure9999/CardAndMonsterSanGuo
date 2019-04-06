

-----场景数据管理

module("Scene_BaseDB", package.seeall)

require "Script/Fight_New/ScenceScript/scriptmanage" 	
require "Script/Fight_New/Scene_PlayObj" 

--联网接口

local function InitServerFightData( self,pNetStream)	
	--联网数据数据			
	--BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerFightData(pServerDataStream))
	self.m_ScenceType = SceneDB_Type.Type_FuBen
end

local function InitServerPKData(self,pNetStream)
	
	--BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerPKData(pNetStream))
	self.m_ScenceType = SceneDB_Type.Type_PK
end

-- add by sxin 增加国战单挑接口
local function InitSingleFightData(self,pNetStream)
	self.m_ScenceType = SceneDB_Type.Type_WarSingle
	--BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerPKData(pNetStream))
	--BaseSceneDB.SetCityWarSingleScene()
	
end
-- add by sxin 增加国战战斗接口
local function InitWarFightData(self,pNetStream)
	self.m_ScenceType = SceneDB_Type.Type_CityWar
	--BaseSceneDB.SetSceneData_rapidjson(FightServer.InitServerPKData(pNetStream))
	--BaseSceneDB.SetCityWarScene()
end

--

--单机接口
local function InitTestFightData(self,Serverscenid, index )	
	self.m_ScenceType = SceneDB_Type.Type_FuBen
	--测试数据		
	local checkpointID = tonumber(scence.getFieldByIdAndIndex(Serverscenid,("ID_" .. index)))	
	local SceneID = tonumber(point.getFieldByIdAndIndex(checkpointID,"ResID"))	
	local AllTimes = tonumber(point.getFieldByIdAndIndex(checkpointID,"times"))					
			
	self.m_ScenceID = SceneID
	self.m_AllTimes = AllTimes
	self.m_checkpointID = checkpointID
	self.m_curTimes = 1
	self.m_Battle_ID = 10000
	self.m_CopyData_Star = 0
	
	--角色写死了测试的
	local hufalist = {7001,7002}
	local playList = {
					{80011,80012,80013,81011,81012,81013},
					{6002,6005,6004,6008,6010,6011,6012,},
					{6003,6005,6006,6009,6016},
					{6007,6001,6013,6014,6015,6017,6018,6019,6020},
					{80021,80032,80043,80031,80042,80053,81021,81032,81043,81031,81042,81053}}


	--local pPlaytbale = {playList[1][math.random(1,6)],playList[2][math.random(1,7)],playList[3][math.random(1,5)],playList[4][math.random(1,9)],playList[5][math.random(1,12)],hufalist[math.random(1,2)]	}
	--local pPlaytbale = {80011,6002,6004,6005,6013,-1}
	
	--local pPlaytbale = {80011,6002,6004,6005,6013,-1}
	--测试战斗角色
	--local pPlaytbale = {6008,-1,6007,6035,6001,-1}
	--local pPlaytbale = {80011,6005,80031,6016,6001,-1}
		
	--local pPlaytbale = {6007,-1,80031,-1,-1,-1}
	
	--local pPlaytbale = {-1,-1,6007,6006,6013,-1}
	
	--local pPlaytbale = {80011,-1,6002,6007,6001,-1}
	--local pPlaytbale = {6117,-1,-1,-1,6049,-1}
	--local pPlaytbale = {6115,-1,-1,-1,-1,-1}
	--local pPlaytbale = {6025,80011,80011,6042,6042,-1}
	local pPlaytbale = {6117,-1,-1,-1,-1,-1}
	
	
	local pPlaytGuidtbale = {10001,10002,10003,10004,10005,0}	
	
	
	
	
	local k = 1
	local playID = -1
	local playGUID = -1
	for k=1, 6, 1 do
		playID = pPlaytbale[k]
		playGUID = pPlaytGuidtbale[k]
		if playID ~= nil and playID > 0 then 
			local pPlayObj= Scene_PlayObj.CreateBaseObj()
			pPlayObj:Fun_CreatTestPlayObj(playID)
			pPlayObj:Fun_SetIndex(k)
			self.m_FightTeamPlay[k] = pPlayObj			
		end
	end
	
	--设置技能组先写死了顺序测试
	local skillgroup1 = {{pPlaytbale[1],}}
	self:Fun_SetSkillGroup( self.m_FightTeamPlay[1],self.m_FightTeamPlay[2],self.m_FightTeamPlay[3],self.m_FightTeamPlay[4],self.m_FightTeamPlay[5])

	--创建怪物的
	---怪的
	local i=1
	local j=0	
	local IMonstID = -1
	
	for i=1, AllTimes, 1 do	
	
		local NpcData = {}
		for j=1 , 5 , 1 do
		--for j=1 , 1 , 1 do
			local Keys = "POS_" .. i .. "_" .. j
			IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))
			if IMonstID >0 then						
				local pNpcObj= Scene_PlayObj.CreateBaseObj()
				pNpcObj:Fun_CreatTestNpcObj(IMonstID)
				pNpcObj:Fun_SetIndex(j)
				pNpcObj:Fun_SetTimes(i)
				NpcData[j] = pNpcObj
			end
		end
		
		---怪的护法
		local Keys = "hufa_" .. i
		IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))	
		if IMonstID >0 then						
			local pNpcObj= Scene_PlayObj.CreateBaseObj()
			pNpcObj:Fun_CreatTestNpcObj(IMonstID)
			pNpcObj:Fun_SetIndex(6)
			NpcData[6] = pNpcObj
		end
		
		self.m_FightTeamNpc[i] = NpcData
		
	end
end


local function InitTestPKData(self,SceneID, index)
	self.m_ScenceType = SceneDB_Type.Type_PK
	--	BaseSceneDB.SetSceneData_rapidjson(FightServer.InitTestPKData(1000,1))
	
end

local function GetScenceID(self)
	return self.m_ScenceID
end

local function CreateSceneScript(self)	
	self.m_pSceneSprit = scriptmanage.CreateSceneScript(self.m_ScenceID)	
	return self.m_pSceneSprit
end

local function GetFightLoadingRes(self)
	local tableRes = {}	
	local index = 1		
	local i = 0
	local j = 0
	local k = 0
	-- 玩家
	for i=1, 6 , 1 do	
		if self.m_FightTeamPlay[i] ~= nil then 		
			
			if self.m_FightTeamPlay[i].m_baseDB.m_TempResid ~= -1  then 
				tableRes[index]	 = AnimationData.getFieldByIdAndIndex(self.m_FightTeamPlay[i].m_baseDB.m_TempResid,"AnimationfileName")
				index = index + 1
				
				--加载特效文件				
				for k=1 , 3, 1 do
										
					local  iEffectID = tonumber(SkillData.getFieldByIdAndIndex(self.m_FightTeamPlay[i].m_baseDB.m_SkillData[k].m_skillresid,"Effectid_hit")) 
					
					if iEffectID >0 then 														
						tableRes[index]	 = EffectData.getFieldByIdAndIndex(iEffectID,"fileName") 
						index = index + 1						
					end
					
					local  iEffectID = tonumber(SkillData.getFieldByIdAndIndex(self.m_FightTeamPlay[i].m_baseDB.m_SkillData[k].m_skillresid,"Effectid_bullet"))
					
					if iEffectID >0 then 														
						tableRes[index]	 = EffectData.getFieldByIdAndIndex(iEffectID,"fileName") 
						index = index + 1						
					end				
					
				end				
				
			end
			
		end				
	end

	-- NPC 
	for i=1, self.m_AllTimes , 1 do	
		if self.m_FightTeamNpc[i] ~= nil then 
			for j=1, 6 , 1 do	
				if self.m_FightTeamNpc[i][j] ~= nil then 		
					
					if self.m_FightTeamNpc[i][j].m_baseDB.m_TempResid ~= -1  then 
						tableRes[index]	 = AnimationData.getFieldByIdAndIndex(self.m_FightTeamNpc[i][j].m_baseDB.m_TempResid,"AnimationfileName")
						index = index + 1
						
						--加载特效文件				
						for k=1 , 3, 1 do
												
							local  iEffectID = tonumber(SkillData.getFieldByIdAndIndex(self.m_FightTeamNpc[i][j].m_baseDB.m_SkillData[k].m_skillresid,"Effectid_hit")) 
							
							if iEffectID >0 then 														
								tableRes[index]	 = EffectData.getFieldByIdAndIndex(iEffectID,"fileName") 
								index = index + 1						
							end
							
							local  iEffectID = tonumber(SkillData.getFieldByIdAndIndex(self.m_FightTeamNpc[i][j].m_baseDB.m_SkillData[k].m_skillresid,"Effectid_bullet"))
							
							if iEffectID >0 then 														
								tableRes[index]	 = EffectData.getFieldByIdAndIndex(iEffectID,"fileName") 
								index = index + 1						
							end				
							
						end				
						
					end
					
				end		
			end
		end
		
	end
	
	
	return tableRes
end

local function CreatTeamRander(self,pRoot)
	
	--创建play
	local i = 0
	local j = 0
	for i=1, 5 , 1 do	
		if self.m_FightTeamPlay[i] ~= nil then 		
			self.m_FightTeamPlay[i]:Fun_CreatRenderData(pRoot)		
			self.m_FightTeamPlay[i]:Fun_GetRender_Armature():setZOrder((1 - i%2)*10+i+1)			
			self.m_FightTeamPlay[i]:Fun_GetRender_Armature():setPosition(ccp(PlayBirthPoint[i].x,PlayBirthPoint[i].y))			
		end				
	end
	local Size = CCDirector:sharedDirector():getVisibleSize()
	--传创建护法
	if self.m_FightTeamPlay[6] ~= nil then 		
		self.m_FightTeamPlay[6]:Fun_CreatRenderData(pRoot)		
		self.m_FightTeamPlay[6]:Fun_GetRender_Armature():setZOrder(Fight_hufa_Z)	
			
		self.m_FightTeamPlay[6]:Fun_GetRender_Armature():setPosition(ccp(Size.width*0.5, Size.height*0.5))	
		self.m_FightTeamPlay[6]:Fun_GetRender_Armature():setVisible(false)		
	end				
	
	--创建怪物
	for i=1, self.m_AllTimes , 1 do	
		if self.m_FightTeamNpc[i] ~= nil then 
			for j=1, 5 , 1 do	
				if self.m_FightTeamNpc[i][j] ~= nil then 		
					self.m_FightTeamNpc[i][j]:Fun_CreatRenderData(pRoot)		
					self.m_FightTeamNpc[i][j]:Fun_GetRender_Armature():setZOrder((1 - j%2)*10+j)		
					self.m_FightTeamNpc[i][j]:Fun_GetRender_Armature():setScaleX(-(self.m_FightTeamNpc[i][j]:Fun_GetRender_Armature():getScaleX()))	
					self.m_FightTeamNpc[i][j]:Fun_GetRender_Armature():setPosition(ccp(EnemyBirthPoint[j].x+MaxMoveDistance*(i-1),EnemyBirthPoint[j].y))			
				end		
			end
			
			--传创建护法
			if self.m_FightTeamNpc[i][6] ~= nil then 		
				self.m_FightTeamNpc[i][6]:Fun_CreatRenderData(pRoot)		
				self.m_FightTeamNpc[i][6]:Fun_GetRender_Armature():setZOrder(Fight_hufa_Z)						
				self.m_FightTeamNpc[i][6]:Fun_GetRender_Armature():setPosition(ccp(Size.width*0.5, Size.height*0.5))	
				self.m_FightTeamNpc[i][6]:Fun_GetRender_Armature():setVisible(false)		
			end			
	
		end
		
	end
	
end
--完善接口
local function IsPKScene(self)
	return self.m_ScenceType == SceneDB_Type.Type_PK
end

local function IsCityWarSingleScene( self)
	return self.m_ScenceType == SceneDB_Type.Type_WarSingle
end

local function IsCityWarScene( self)
	return self.m_ScenceType == SceneDB_Type.Type_CityWar
end

local function IsPFubencene(self)
	return self.m_ScenceType == SceneDB_Type.Type_FuBen
end

local function GetFightResult(self)
	return self.m_FightResout
end

local function SetFightResult(self,iResult)
	self.m_FightResout = iResult
end

local function IsFightEnd(self)
	return 	self.m_bFightEnd
end

local function SetFightEnd(self,bend)
	self.m_bFightEnd = bend
end

local function GetFightTimes(self)
	return 	self.m_curTimes
end

local function GetAllimes(self)
	return 	self.m_AllTimes
end

local function AddTimes(self)	
	self.m_curTimes = self.m_curTimes +1
	--Pausetraceback()
end

local function GetpointID(self)	
	return self.m_checkpointID
end

local function Release(self)
		
	--析构角色 和脚本
	self.m_pSceneSprit:Fun_Release()
		
	local i = 0	
	for i=1, 6 , 1 do	
		if self.m_FightTeamPlay[i] ~= nil then 		
			self.m_FightTeamPlay[i]:Fun_Release()	
			self.m_FightTeamPlay[i] = nil
		end				
	end	
	self.m_FightTeamPlay = nil
	
	for i=1, 3 , 1 do	
		if self.m_FightTeamNpc[i] ~= nil then 
			for j=1, 5 , 1 do	
				if self.m_FightTeamNpc[i][j] ~= nil then 		
					self.m_FightTeamNpc[i][j]:Fun_Release()	
					self.m_FightTeamNpc[i][j] = nil					
				end		
			end	
			self.m_FightTeamNpc[i] = nil
		end		
	end
	self.m_FightTeamNpc = nil
	
	
end

local function GetPlayList(self)
	
	local pListTable = {}
	local iIndex = 1
	
	local i = 0	
	for i=1, MaxTeamPlayCount , 1 do	
		if self.m_FightTeamPlay[i] ~= nil and self.m_FightTeamPlay[i]:Fun_IsDie() == false then 		
			
			pListTable[iIndex] = self.m_FightTeamPlay[i]				
			iIndex = iIndex + 1
			
		end				
	end	
	
	return pListTable
	
end

local function GetNpcList(self)
	
	local pListTable = {}
	local iIndex = 1
	local iTimes = self.m_curTimes
	local i = 0	
	for i=1, MaxTeamPlayCount , 1 do	
		if self.m_FightTeamNpc[iTimes][i] ~= nil and self.m_FightTeamNpc[iTimes][i]:Fun_IsDie() == false then 		
			
			pListTable[iIndex] = self.m_FightTeamNpc[iTimes][i]			
			iIndex = iIndex + 1
			
		end				
	end	
	
	return pListTable
	
end

local function GetSkillGroup(self,iGroupIndex)
	
	if iGroupIndex >0 and iGroupIndex <= 3 then
		
		return self.m_SkillGroup[iGroupIndex]
		
	else
		return nil
	end
	
end

local function SetSkillGroup(self,pobj1,pobj2,pobj3,pobj4,pobj5)
	
	print("SetSkillGroup")
	
	
	local function CreatSkillData(pobj,iskillIndex,igroupIndex)
		
		if pobj ~= nil then
			local tempData = {}
			tempData.m_FaceID  = pobj:Fun_GetBaseDB().m_TempID
			tempData.m_SkillIndex = iskillIndex
			tempData.m_SkillID = pobj:Fun_GetSkillID(iskillIndex)
			tempData.m_groupIndex = igroupIndex
			tempData.m_pObj = pobj
			tempData.m_iCount = 1
			return tempData
		else
			return nil			
		end
	end
	
	self.m_SkillGroup[1] = {CreatSkillData(pobj1,2,1),CreatSkillData(pobj1,3,1)}	
	self.m_SkillGroup[2] = {CreatSkillData(pobj2,2,2),CreatSkillData(pobj3,3,2)}	
	self.m_SkillGroup[3] = {CreatSkillData(pobj4,2,3),CreatSkillData(pobj5,3,3)}	
	
	
end

local function PlayCheers(self)		
	
	local i = 0	
	for i=1, MaxTeamPlayCount , 1 do	
		if self.m_FightTeamPlay[i] ~= nil and self.m_FightTeamPlay[i]:Fun_IsDie() == false then 			
			self.m_FightTeamPlay[i]:Fun_play_Key(Ani_Def_Key.Ani_cheers)					
		end				
	end		
	
end

local function RunPlay( pObj,itimes,iIndex)

	local function DisActArriveToStand(pNode)			
		pObj:Fun_play_Key(Ani_Def_Key.Ani_stand)	
	end
		
	pObj:Fun_play_Key(Ani_Def_Key.Ani_run)	
	local fmoveDis = math.abs(pObj:Fun_getPositionX()-( PlayBirthPoint[iIndex].x + itimes*MaxMoveDistance))
	local fmoveTime = fmoveDis/MaxPlayMoveSpeed
	local pMoveTo = CCMoveTo:create(fmoveTime, ccp(PlayBirthPoint[iIndex].x + itimes*MaxMoveDistance, PlayBirthPoint[iIndex].y))	
	local pcallFunc = CCCallFuncN:create(DisActArriveToStand)			
	local pMoveseq  = CCSequence:createWithTwoActions(pMoveTo, pcallFunc)

	pObj:Fun_runAction(pMoveseq)
end

local function RunNpc( pObj)

	local function DisActArriveToStand(pNode)			
		pObj:Fun_play_Key(Ani_Def_Key.Ani_stand)	
	end	
	
	pObj:Fun_play_Key(Ani_Def_Key.Ani_run)	
	pObj:Fun_SetPositionX(pObj:Fun_getPositionX() + MaxMoveDistance)
	pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance,0))
	
	local pcallFunc = CCCallFuncN:create(DisActArriveToStand)
	local pMoveseq  = CCSequence:createWithTwoActions(pMoveBy, pcallFunc)
	
	pObj:Fun_runAction(pMoveseq)
	
	
end

local function PlaySceneEnter(self)		
		
	local itimes = self.m_curTimes
	--print(itimes)
	--Pause()
		
	local i=1
	
	for i=1, MaxTeamPlayCount, 1 do
	
		if self.m_FightTeamPlay[i] ~= nil and self.m_FightTeamPlay[i]:Fun_IsDie() == false then 	
		
			RunPlay(self.m_FightTeamPlay[i],itimes-1,i)			
		end	
		
		if self.m_FightTeamNpc[itimes][i] ~= nil and self.m_FightTeamNpc[itimes][i]:Fun_IsDie() == false then 		
			
			RunNpc(self.m_FightTeamNpc[itimes][i])
			
		end		
		
	end		

end


function CreateBaseDB( )

	DB = {
			-- 接口方法
			Fun_Release		   			= Release,
			Fun_InitServerFightData 	= InitServerFightData,
			Fun_InitServerPKData 		= InitServerPKData,
			Fun_InitSingleFightData 	= InitSingleFightData,
			Fun_InitWarFightData 		= InitWarFightData,
			--测试接口
			Fun_InitTestFightData 		= InitTestFightData,
			Fun_InitTestPKData 			= InitTestPKData,
			
			Fun_GetScenceID 			= GetScenceID,
			Fun_CreateSceneScript 		= CreateSceneScript,

			
			Fun_IsPKScene 				= IsPKScene,
			Fun_IsCityWarSingleScene 	= IsCityWarSingleScene,
			Fun_IsCityWarScene 			= IsCityWarScene,
			Fun_IsPFubencene 			= IsPFubencene,
			Fun_GetFightResult 			= GetFightResult,
			Fun_SetFightResult			= SetFightResult,
			Fun_GetFightLoadingRes 		= GetFightLoadingRes,
			Fun_IsFightEnd				= IsFightEnd,
			Fun_SetFightEnd				= SetFightEnd,
			Fun_GetAllimes 				= GetAllimes,
			Fun_GetFightTimes			= GetFightTimes,
			Fun_AddTimes				= AddTimes,
			Fun_GetPlayList				= GetPlayList,
			Fun_GetNpcList				= GetNpcList,
			Fun_GetpointID 				= GetpointID,
			
			Fun_PlayCheers				= PlayCheers,
			Fun_PlaySceneEnter			= PlaySceneEnter,
			
			Fun_CreatTeamRander = CreatTeamRander,
			Fun_SetSkillGroup = SetSkillGroup,
			Fun_GetSkillGroup = GetSkillGroup,
			-- 变量
			m_ScenceType = SceneDB_Type.Type_None,
			m_bAutoFight = false,
			m_pSceneSprit = nil,
			m_SkillGroup = {},
			
			m_ScenceID = -1,
			m_AllTimes = 0,		
			m_checkpointID = -1,
			m_curTimes = 0,
			m_Battle_ID = 0,
			m_CopyData_Star = 0,			
			m_FightTeamPlay ={},
			m_FightTeamNpc ={},
			m_FightResout = 0,
			m_bFightEnd = false,
			
			}
			
	return DB

end

