--add by sxin 场景脚本通用接口逻辑

module("scene_logic", package.seeall)


function Create( self,pScenceNode, pScenceInterface )	
	
	self.m_ScenceRoot = pScenceNode
	self.m_ScenceInterface	= pScenceInterface
	self.m_Times = 1

end


function Enter(self)			
	self.m_Times = 1
end

function EnterFinish(self)			
	
end

function Leave( self)	
	
	self.m_ScenceRoot = nil
	self.m_Times = 1
end

--战斗波数
function StarFight( self, times)	
	
	self.m_Times = times
	
	return false
		
end


--战斗波数
function EndFight( self,times )	
	
	--print("Scene_1:EndFight: times = " .. times)
	--test-加血
	TeamPlayRecovery()
	
	FightUILayer.TakeAllBox()	
	
	return false
		
end

--死亡触发事件 死亡索引 攻击者索引
function Die( self,DiePos , attackPos )	
	
	--print("Scene_1:Die: DiePos = " .. DiePos .."attackPos =" .. attackPos)
	
	PlayDropItem(self.m_Times,DiePos,attackPos)
		
end

function Damage( self,iDamagePos )	
	
	--print(iDamagePos)
	
end


--队伍推图入场
function PlayerEnterScene(self)
	
	--printTab(self)
	
	--Pause()
	
	BasePlayerEnterScene(self)
	
end

function CreateBaseScene( iSpritID )	
	
	local Scene_Base= {
				Create 			= Create,
				Enter 			= Enter,
				Leave 			= Leave,
				StarFight		= StarFight,
				EndFight		= EndFight,
				Die				= Die,	
				m_iD			= iSpritID,	
				PlayerEnterScene = PlayerEnterScene,
				Damage			= Damage,
				EnterFinish		= EnterFinish,
			
	}
		
	return Scene_Base
end

--队伍推图入场
function BasePlayerEnterScene(pSprite)
	
	local function CB_PlayerEnterScene(pNode)
			
		
		local i=1
		local pArmature = nil
		
		for i=1 , MaxTeamPlayCount, 1 do
			pArmature = BaseSceneDB.GetPlayArmature(i)
			if pArmature ~= nil then
			
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
			end		
			--NPC--------------------------------------
			local iNpc = i + MaxTeamPlayCount
			pArmature = BaseSceneDB.GetPlayArmature(iNpc)
			if pArmature ~= nil then
			
				pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
			end		
		end	
			
		BaseScene.StarFight_SenenSprite()	
	end

	local pcallFunc = CCCallFuncN:create(CB_PlayerEnterScene)
	
	BaseSceneLogic.SetNodeTimer(pSprite.m_ScenceRoot,SceneEnterTime*0.5,pcallFunc,0)

	local pMoveBy = nil
	local pArmature = nil
	local i=1
	for i=1 ,MaxTeamPlayCount,1 do
		
		pArmature = BaseSceneDB.GetPlayArmature(i)		
		--//玩家
		if pArmature ~= nil then
			
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))
			pArmature:setPositionX(pArmature:getPositionX() -MaxMoveDistance*0.5)
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.5,ccp(MaxMoveDistance*0.5,0))	
			pArmature:runAction(pMoveBy)
		end
		
		--NPC--------------------------------------
		local iNpc = i + MaxTeamPlayCount
		pArmature = BaseSceneDB.GetPlayArmature(iNpc)
		if pArmature ~= nil then
			
			pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_run))
			pArmature:setPositionX(pArmature:getPositionX() + MaxMoveDistance*0.5)
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.5,ccp(-MaxMoveDistance*0.5,0))	
			pArmature:runAction(pMoveBy)
		end
		

	end
	
end

--待机入场
function StopPlayerEnterScene(pSprite)
	
	local function CB_StopEnterScene(pNode)
				
		BaseScene.StarFight_SenenSprite()
		
	end

	local pcallFunc = CCCallFuncN:create(CB_StopEnterScene)
	
	BaseSceneLogic.SetNodeTimer(pSprite.m_ScenceRoot,0.5,pcallFunc,0)
		
end


--通用的逻辑封装调用

function ShowTeamPlay(istarpos,bshow)
	
	local i=1
	for i=1, MaxTeamPlayCount, 1 do
		
		local inpcPos = istarpos + i
		local pArmatureNpc = BaseSceneDB.GetPlayArmature(inpcPos)
		if pArmatureNpc ~= nil then				
			pArmatureNpc:setVisible(bshow)				
		end
		
	end				
	
end


function StopTeamPlay(istarpos)
	
	local i=1
	for i=1, MaxTeamPlayCount, 1 do
		
		local inpcPos = istarpos + i
		local pArmatureNpc = BaseSceneDB.GetPlayArmature(inpcPos)
		if pArmatureNpc ~= nil then	
			pArmatureNpc:stopAllActions()	
			pArmatureNpc:getAnimation():play(GetAniName_Player(pArmatureNpc,Ani_Def_Key.Ani_stand))			
		end
		
	end				
	
end

--玩家的
function TeamPlayRecovery()
	
	local i=1		
	for i=1 , 5 , 1 do			
		
		if  BaseSceneDB.IsUser(i) == true  and  BaseSceneDB.IsDie(i) == false then				
			
			local pFighter = BaseSceneDB.GetTeamData(i)

			local blood = math.floor(pFighter.m_allblood * pFighter.m_blood_back*0.01)
			
			BaseSceneLogic.PlayDamage(i,i,0,-blood,false)
			
			BaseSceneLogic.playEngine(i,pFighter.m_engine_back)
			
		end		
	end
	
end

--死亡掉落
function PlayDropItem(times, DiePos , attackPos)

	if BaseSceneDB.IsNpc(DiePos) == true then
		
		if BaseSceneDB.IsDie(attackPos) == false then 
			BaseSceneLogic.playEngine(attackPos,Kill_Engine_Back)
		end
		
		local pDie = BaseSceneDB.GetPlayArmature(DiePos)
		local pTeamData = BaseSceneDB.GetTeamData(DiePos)		
		local DropPos = ccp(pDie:getPositionX() - (times-1)*960,pDie:getPositionY())
		--[[
		print(times)
		print("DropPos" .. DropPos.x .. "," .. DropPos.y)
		if(DropPos.x >= 960) then
			Pause()
		end
		--]]
		
		
		if NETWORKENABLE > 0 then			
			
			local itemIDTable = BaseSceneDB.GetFightDropList(DiePos)
			
			for k, v in pairs(itemIDTable or {}) do
			
				
				FightUILayer.AddBox(DropPos,tonumber(v[1]),tonumber(v[2]))	
						
				BaseSceneDB.AddDropData({Id = v[1],Count = v[2]})
			end	
				
			
			
		else
			----add by sxin 单机测试								
			--读表的掉落ID
			local iDroID = pTeamData.m_DropItemID	
			
			require "Script/Common/CommonFun"
			if iDroID >0 then 
			
				local itemIDTable = CommonFun.getItemTableByDropId(iDroID)
				
				for k, v in pairs(itemIDTable or {}) do
					FightUILayer.AddBox(DropPos,tonumber(v["Id"]),tonumber(v["Count"]))			
					BaseSceneDB.AddDropData(v)
				end	
				
			
			end				
		end	
		
	else 
		
	end
	
end


--怪物队伍出场方式 --顺序出场
function TeamPlayEffectEnter(strEffectfile, strEffectName, actIndex , pSprite,pcallback)

	local icount = 0
	local iMaxCount = 0

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strEffectfile)
			
	local function onMovementEvent(Armature, MovementType, movementID)

		if MovementType == 0	then

		
		elseif MovementType == 1 then
		
			Armature:removeFromParentAndCleanup(true)
			
			--最后一个开始战斗
			icount = icount + 1
			if iMaxCount <= icount then 
				
				if pcallback ~= nil then
					pcallback()
				end
			end
			
							
		elseif MovementType == 2 then
		
			
		end
	end

	local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
	     
		if evt == FrameEvent_Key.Event_shownpc then
			
		   local pArmature = bone:getArmature()
			--播放npc	
			local ipos = pArmature:getTag()
			
			local pArmatureNpc = BaseSceneDB.GetPlayArmature(ipos)
			
			if pArmatureNpc ~= nil then 
				pArmatureNpc:setVisible(true)
				pArmatureNpc:getAnimation():play(GetAniName_Player(pArmatureNpc,Ani_Def_Key.Ani_stand))
			end
			
			local iIndex = ipos - pSprite.m_Times*5	+ 1				
			
			
			for iIndex = ipos - pSprite.m_Times*5 + 1, MaxTeamPlayCount, 1 do
				
				local inpcPos = pSprite.m_Times*5 + iIndex
				
				local pArmatureNpc = BaseSceneDB.GetPlayArmature(inpcPos)
				if pArmatureNpc ~= nil then			
					pArmatureNpc:setVisible(false)
					local pArmature = CCArmature:create(strEffectName)
					pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
					pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)
					
					pArmature:setPosition(ccp(EnemyBirthPoint[iIndex].x,EnemyBirthPoint[iIndex].y))		
					
					pArmature:setTag(inpcPos)				
					pArmature:getAnimation():playWithIndex(actIndex)	
					pSprite.m_ScenceRoot:addChild(pArmature,Play_Effect_Z)		
					iMaxCount = iMaxCount + 1
					return
				end				
				
			end					
							   
		end
	end
	
	--创建特效	
	
	local i=1
	for i=1, MaxTeamPlayCount, 1 do
		
		local inpcPos = pSprite.m_Times*5 + i			
		
		local pArmatureNpc = BaseSceneDB.GetPlayArmature(inpcPos)
		if pArmatureNpc ~= nil then
			
			pArmatureNpc:setVisible(false)
			local pArmature = CCArmature:create(strEffectName)
			pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
			pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)				
			pArmature:setPosition(ccp(EnemyBirthPoint[i].x,EnemyBirthPoint[i].y))				
			pArmature:setTag(inpcPos)			
			pArmature:getAnimation():playWithIndex(actIndex)	
			pSprite.m_ScenceRoot:addChild(pArmature,Play_Effect_Z)		
			iMaxCount = iMaxCount + 1
			return true
		end
		
	end		
	
	return true


end

function GetiPosPosition(ipos)
	
	if BaseSceneDB.IsNpc(ipos) == true then
	
		local iNpcPos = ipos%5
		return ccp(EnemyBirthPoint[iNpcPos].x,EnemyBirthPoint[iNpcPos].y)
		
	else
		
		return ccp(PlayBirthPoint[ipos].x,PlayBirthPoint[ipos].y)
	end
	
	
end

--角色出场动画改变
function PlayerEffectEnter(strEffectfile, strEffectName, actIndex , bflip , iPlaypos, pSprite,pcallback)

	local pArmatureNpc = BaseSceneDB.GetPlayArmature(iPlaypos)
	if pArmatureNpc == nil then		
		print("PlayerEffectEnter error")
	else
		pArmatureNpc:setVisible(false)		
	end
	
	local function Callback()
		
		if pArmatureNpc == nil then	
			print("iPlaypos error iPlaypos = " .. iPlaypos)
		else
			pArmatureNpc:setVisible(true)				
			pArmatureNpc:getAnimation():play(GetAniName_Player(pArmatureNpc,Ani_Def_Key.Ani_stand))	
		end
				
				
			--回调
		if pcallback ~= nil then 
			pcallback()
		end		
		
	end
		
	createEnterEffect(strEffectfile, strEffectName, actIndex, bflip, pSprite, GetiPosPosition(iPlaypos), Callback)	

	return true	

end

--快速跑动表现itype: 1跑入 2 跑出

function PlayerFastRun_Armature( pArmatureNpc, bNpc, pSprite,itype, pcallback)
	
	local function PlayerEnterScene(pNode)		
		
		local pArmature = tolua.cast(pNode, "CCArmature")
		
		pArmature:getAnimation():setSpeedScale(pArmature:getAnimation():getSpeedScale()*0.5)	
		pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand))
		
		if itype == 2 then 
			pArmature:setScaleX(-pArmature:getScaleX())
		end

		if pcallback ~= nil then 
			pcallback()
		end		
			
	end	
	
	local pMoveBy = nil
	
	if itype == 1 then 
		
		if bNpc == false then
			pArmatureNpc:setPositionX(pArmatureNpc:getPositionX() - MaxMoveDistance*0.5)
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.25,ccp(MaxMoveDistance*0.5,0))	
		else
			
			pArmatureNpc:setPositionX(pArmatureNpc:getPositionX() + MaxMoveDistance*0.5)
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.25,ccp(-MaxMoveDistance*0.5,0))	
		end
		
	
	elseif itype == 2 then 
		--翻转
		pArmatureNpc:setScaleX(-pArmatureNpc:getScaleX())
		if bNpc == false then				
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.25,ccp(-MaxMoveDistance*0.5,0))				
		else			
			pMoveBy = CCMoveBy:create(SceneEnterTime*0.25,ccp(MaxMoveDistance*0.5,0))	
		end
	
	else
		print("PlayerFastRun:itype: error")
	end
	
	
	--pArmatureNpc:setPositionX(pArmatureNpc:getPositionX() - MaxMoveDistance*0.5)
			
	pArmatureNpc:getAnimation():play(GetAniName_Player(pArmatureNpc,Ani_Def_Key.Ani_run))
	pArmatureNpc:getAnimation():setSpeedScale(pArmatureNpc:getAnimation():getSpeedScale()*2)	
	
	local pcallFunc = CCCallFuncN:create(PlayerEnterScene)	
	
	--local pMoveBy = CCMoveBy:create(SceneEnterTime*0.25,ccp(MaxMoveDistance*0.5,0))	
	
	local pMoveseq  = CCSequence:createWithTwoActions(pMoveBy, pcallFunc)
	
	pArmatureNpc:runAction(pMoveseq)
	
	pArmatureNpc:setVisible(true)
	
	
end

function PlayerFastRun( iPlaypos, pSprite,itype, pcallback)

	local pArmatureNpc = BaseSceneDB.GetPlayArmature(iPlaypos)
	if pArmatureNpc == nil then		
		print("PlayerFastRun error")

	end	
	
	PlayerFastRun_Armature( pArmatureNpc,BaseSceneDB.IsNpc(iPlaypos),pSprite,itype,pcallback)
	
end

--脚本角色出场 快速跑入 
function PlayerFastRunEnter( iPlaypos, pSprite,pcallback)

	PlayerFastRun( iPlaypos, pSprite,1, pcallback)
		
end
--快速跑出
function PlayerFastRunLeave( iPlaypos, pSprite,pcallback)

	PlayerFastRun( iPlaypos, pSprite,2, pcallback)
	
end



--脚本角色出场 特效出场
function CreatPlayerEffectEnter(strEffectfile, strEffectName, actIndex , bflip , iPlaypos, iTempID, PointPos, pSprite,pcallback)
			
	local pArmatureNpc = BaseSceneDB.GetPlayArmature(iPlaypos)
	if pArmatureNpc == nil then		
		--创建角色
		pArmatureNpc = BaseScene.CreatPlayer(iPlaypos,iTempID)	
		
		pArmatureNpc:setPositionX(PointPos.x + (pSprite.m_Times-1)*MaxMoveDistance)		
		
	end
	
	if pArmatureNpc ~= nil then		
		pArmatureNpc:setVisible(false)		
	end
	
	PlayerEffectEnter(strEffectfile,strEffectName,actIndex,bflip,iPlaypos,pSprite,pcallback)
		
	return true		

end

--创建一个特效 在播放完后回调 不循环特效 回调事件帧事件
function createEffect_Scence(strEffectfile, strEffectName, actIndex, bflip, pSprite, Effectpos, pMovementEventcallback,pFrameEventcallback)
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strEffectfile)
	
	local function onEffectMovementEvent(Armature, MovementType, movementID)

		if MovementType == 0	then
		
		elseif MovementType == 1 then
		
			Armature:removeFromParentAndCleanup(true)	
			if pMovementEventcallback ~= nil then
				
				pMovementEventcallback()
				
			end
						
		elseif MovementType == 2 then		
			
		end
	end
	
	local function onEffectFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)	   
			
			if pFrameEventcallback ~= nil then 
				pFrameEventcallback(bone,evt,originFrameIndex,currentFrameIndex)
			end
		
	end
	
	--创建特效	
	
	local pArmature = CCArmature:create(strEffectName)
	pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
	pArmature:getAnimation():setFrameEventCallFunc( onEffectFrameEvent)				
	pArmature:setPosition(Effectpos)	
	pArmature:getAnimation():playWithIndex(actIndex)
		
	if 	bflip == true then 
		
		pArmature:setScaleX(-(pArmature:getScaleX()))
		
	end

	pSprite.m_ScenceRoot:addChild(pArmature,Play_Effect_Z)		
		
end

--创建入场动画特效方法
function createEnterEffect(strEffectfile, strEffectName, actIndex, bflip, pSprite, Effectpos, pcallback)
			
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strEffectfile)
	
	local function onMovementEvent(Armature, MovementType, movementID)

		if MovementType == 0	then
		
		elseif MovementType == 1 then
		
			Armature:removeFromParentAndCleanup(true)			
						
		elseif MovementType == 2 then		
			
		end
	end
	
	local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
	     
		if evt == FrameEvent_Key.Event_shownpc then
			--回调
			if pcallback ~= nil then 
				pcallback()
			end		
							   
		end
	end
	
	--创建特效	
	
	local pArmature = CCArmature:create(strEffectName)
	pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)				
	pArmature:setPosition(Effectpos)	
	pArmature:getAnimation():playWithIndex(actIndex)
		
	if 	bflip == true then 
		
		pArmature:setScaleX(-(pArmature:getScaleX()))
		
	end
	pSprite.m_ScenceRoot:addChild(pArmature,Play_Effect_Z)		
	
end



--创建一个不参加战斗的角色
function CreatPlayerEffectEnter_NotFight( strEffectfile, strEffectName, actIndex , bflip , iPlaypos, iTempID, PointPos, pSprite,pcallback)
							
	local pArmatureNpc = BaseScene.CreatPlayerNotFight(iPlaypos,iTempID)
	
	if pArmatureNpc ~= nil then	
		pArmatureNpc:setPositionX(PointPos.x + (pSprite.m_Times-1)*MaxMoveDistance )		
		pArmatureNpc:setVisible(false)		
	end
	
	
	local function Callback()
		
				
		pArmatureNpc:setVisible(true)				
		pArmatureNpc:getAnimation():play(GetAniName_Player(pArmatureNpc,Ani_Def_Key.Ani_stand))			
				
			--回调
		if pcallback ~= nil then 
			pcallback()
		end		
		
	end
		
	createEnterEffect(strEffectfile, strEffectName, actIndex, bflip, pSprite, GetiPosPosition(iPlaypos), Callback)	
			
	return pArmatureNpc		
end

--创建一个不参加战斗的角色
function CreatPlayer_NotFight( iPlaypos, iTempID, PointPos, pSprite)
	
	local pArmatureNpc = BaseScene.CreatPlayerNotFight(iPlaypos,iTempID)
	
	if pArmatureNpc ~= nil then	
		pArmatureNpc:setPositionX(PointPos.x + (pSprite.m_Times-1)*MaxMoveDistance )		
		pArmatureNpc:setVisible(false)		
	end
	return pArmatureNpc	
end

--播放特效片头支持字幕逐字播放 白色字体 标准大小32 默认字体
function Play_Cg_Text(pRoot,pTable_Text,posY)

	local colorText = COLOR_White
	local sizeText = 32
	local fontText = "default"
	

	local _Label_ = Label:create()

	_Label_:setFontSize(sizeText)
	_Label_:setColor(colorText)

	if fontText ~= "default" then
		_Label_:setFontName(fontText)
	end
	
	_Label_:setText(pTable_Text.m_Text)

	local nTextSize = _Label_:getSize()
	
	local iPosx =  - nTextSize.width*0.5 

	_Label_:setPosition(ccp(iPosx, posY))
	_Label_:setAnchorPoint(ccp(0,0.5))
	
	
	--[[
	--按事件顺序打印
	local iTextNum = string.len(pTable_Text.m_Text)
	
	local TextPlaySpeed = (pTable_Text.m_time - 0.1)/iTextNum*3
	
	local iTextEndPos = 3
	
	local tempTex = string.sub(pTable_Text.m_Text, 1, iTextEndPos)		
	_Label_:setText(tempTex)
	
	local nHanderTime = nil
	
	local function PrintCGText()
		iTextEndPos = iTextEndPos +3
		
		if iTextEndPos > iTextNum then 			
			
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
			nHanderTime = nil
			
		else			
			
			tempTex = string.sub(pTable_Text.m_Text, 1, iTextEndPos)	
						
			if _Label_ ~= nil then 
				_Label_:setText(tempTex)
			else
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(nHanderTime)
				nHanderTime = nil				
			end
			
			
		end
		
		
	end
	
	--nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(PrintCGText, TextPlaySpeed, false)	

	--]]
	
	pRoot:addChild(_Label_,Play_Effect_Z)			
end





