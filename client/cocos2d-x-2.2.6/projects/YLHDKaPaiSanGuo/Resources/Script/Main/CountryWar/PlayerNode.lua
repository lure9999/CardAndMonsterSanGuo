require "Script/Main/CountryWar/CountryWarCityManager"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryUILayer"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/CountryWarDef"
require "Script/Main/CountryWar/PathFinding"
require "Script/Main/CountryWar/AniNode"
require "Script/Fight/BaseSceneLogic"

module("PlayerNode", package.seeall)

local UIInterface_CreatAnimateByResID 	= 	UIInterface.CreatAnimateByResID
local GetPointAngle 					= 	BaseSceneLogic.GetPointAngle

local GetGeneralResId					= 	CountryWarData.GetGeneralResId
local GetLinkPoint						=	CountryWarLogic.GetLinkPoint
local GetCityNameByIndex				=	CountryWarData.GetCityNameByIndex
local GetTeamCity						=	CountryWarData.GetTeamCity
local GetCityCountry					=	CountryWarData.GetCityCountry
local GetTeamTab 						=	CountryWarData.GetTeamTab
local GetTeamLevel 						=	CountryWarData.GetTeamLevel
local GetTeamFace 						=	CountryWarData.GetTeamFace
local GetTeamName 						=	CountryWarData.GetTeamName
local GetTeamBlood 						=	CountryWarData.GetTeamBlood
local GetExpeDitionResImgID 			=	CountryWarData.GetExpeDitionResImgID
local GetExpeDitionRewardImgID 			=	CountryWarData.GetExpeDitionRewardImgID
local GetExpeDitionCountryID 			=	CountryWarData.GetExpeDitionCountryID
local GetPathByImageID					=	CountryWarData.GetPathByImageID
local GetLinkCityData					=	CountryWarData.GetLinkCityData
local GetTeamCurBlood					=	CountryWarData.GetTeamCurBlood
local GetTeamMistyIndex					=	CountryWarData.GetTeamMistyIndex

local SortTagTab						=	CountryWarLogic.SortTagTab
local SortTagTabAll						=	CountryWarLogic.SortTagTabAll
local GetLinkPoint						=	CountryWarLogic.GetLinkPoint
local CountDistanceByPoint				=	CountryWarLogic.CountDistanceByPoint
local GetIndexByCTag					=	CountryWarLogic.GetIndexByCTag
local PlayHeroAnimation					=	CountryWarLogic.PlayHeroAnimation

local SetRoleState						=	CountryUILayer.SetRoleState
local UpdateTeamAttr					=	CountryUILayer.UpdateTeamAttr

local PlayerId = {
	TeamerMain 	= 1000,
	Teamer1 	= 2000,
	Teamer2 	= 3000,
	Teamer3 	= 4000,
}

local Move_Type = {
	Move 	 	 = 1,
	Flash        = 2, 		-- 血战/坚守的目标城市
}


local function SetHeroDirection( nCurX, nTarX, pObj )
	-- 改变当前英雄朝向
	if nCurX < nTarX then
		pObj:setScaleX(-0.7)
		pObj:setScaleY(0.7)
	else
		pObj:setScaleX(0.7)
		pObj:setScaleY(0.7)		
	end
end

local function RemoveAllRoadPt( self )
	--if self.state == PlayerState.E_PlayerState_Move then
	PlayHeroAnimation(self.Player,GetGeneralResId(self.resId),Ani_Def_Key.Ani_stand)	
	local function removePt ( nTab, tagNum )
		if nTab ~= nil then
			for key,value in pairs(nTab) do
				if value:GetAniNode() ~= nil then
					value:Destory()
				end
			end
		else
			print("无路点")
		end
	end
	local tagNum = nil
	if self.pType == PlayerType.E_PlayerType_Main then
		tagNum = PlayerId.TeamerMain
		removePt(self.RoadPtTagTab["Main"], tagNum)
	elseif self.pType == PlayerType.E_PlayerType_1 then
		tagNum = PlayerId.Teamer1
		removePt(self.RoadPtTagTab["Teamer1"], tagNum)
	elseif self.pType == PlayerType.E_PlayerType_2 then
		tagNum = PlayerId.Teamer2
		removePt(self.RoadPtTagTab["Teamer2"], tagNum)
	elseif self.pType == PlayerType.E_PlayerType_3 then
		tagNum = PlayerId.Teamer3
		removePt(self.RoadPtTagTab["Teamer3"], tagNum)
	else
	end
	--end
end

local function PauseAndWaitServerBack( self )
	CCDirector:sharedDirector():getActionManager():pauseTarget(self.Player)
	if self.resId == nil then
		PlayHeroAnimation(self.Player,GetGeneralResId(CommonData.g_MainDataTable.nModeID),Ani_Def_Key.Ani_stand)
	else
		PlayHeroAnimation(self.Player,self.resId,Ani_Def_Key.Ani_stand)
	end	
end

local function ResumeMove(self )
	CCDirector:sharedDirector():getActionManager():pauseTarget(self.Player)
	if self.resId == nil then
		PlayHeroAnimation(self.Player,GetGeneralResId(CommonData.g_MainDataTable.nModeID),Ani_Def_Key.Ani_run)
	else
		PlayHeroAnimation(self.Player,self.resId,Ani_Def_Key.Ani_run)
	end
end

--每次移动到新的城市都检测下当前城市状态，如果为交战状态，则停止移动
local function CheckCityState( self, nCityTag )
	--判断改城市是否属于本阵营
	--[[local nCountry = GetCityCountry(GetIndexByCTag(nCityTag))
	if 1 == nCountry then
		print("到达"..GetCityNameByIndex(GetIndexByCTag(nCityTag)).."该城市属于"..nCountry)
		return true
	else
		m_IsRunning = false
		RemoveAllRoadPt(self)
		print(GetCityNameByIndex(GetIndexByCTag(nCityTag)).."属于地方阵营"..nCountry)
		return false
	end]]
	return true
end

local function UpdatePlayerAni(  )
	-- body
end

local function SetStopMove( self, nPt, nCityID )
	self.IsRunning = false
	self.isiDle    = true
	self.Player:stopAllActions()
	self.Player:setPosition(nPt)
	self.CurNode = nCityID
	RemoveAllRoadPt(self)
	--更新人物形象
	--[[if self.Player ~= nil then
	    self.Player = UIInterface_CreatAnimateByResID(GetGeneralResId(self.resId))
		self.Player:setScale(0.7)
		self.Player:setPosition(ccp(nPt.x, nPt.y))
		nBase:addNode(self.Player,1301,1999 + nType)
	end]]
end

local function SetTargetNode( nTarGetNode )
	self.TargetNode = nTarGetNode
end

local function SetIsChangeTar( nTargetState )
	self.IsChangeTarget = nTargetState
end

local function GetPlayer( self )
	return self.Player
end

local function AddRoadPointAni( self, nptX, nptY, nIndex, nAngle)
	local pRoadAniObj = AniNode.Create()

	pRoadAniObj:CreateAniNode(nptX, nptY, nAngle)
	pRoadAniObj:SetActSpeed(self.CurSpeed)

	local tagNum = nil

	if self.pType == PlayerType.E_PlayerType_Main then
		tagNum = PlayerId.TeamerMain
		self.RoadPtTagTab["Main"][nIndex + tagNum] = pRoadAniObj
	elseif self.pType == PlayerType.E_PlayerType_1 then
		tagNum = PlayerId.Teamer1
		self.RoadPtTagTab["Teamer1"][nIndex + tagNum] = pRoadAniObj
	elseif self.pType == PlayerType.E_PlayerType_2 then
		tagNum = PlayerId.Teamer2
		self.RoadPtTagTab["Teamer2"][nIndex + tagNum] = pRoadAniObj
	elseif self.pType == PlayerType.E_PlayerType_3 then
		tagNum = PlayerId.Teamer3
		self.RoadPtTagTab["Teamer3"][nIndex + tagNum] = pRoadAniObj
	else
	end

	pRoadAniObj:AddParent(self.BatchNode, tagNum + nIndex)	
end

local function SetActScale( self, nSpeed )
	self.CurSpeed = nSpeed
	self.Player:setActionTimeScale(nSpeed)
end

local function AddRoadPointALLAni( self, nCurTag, nTarTag, nTarTagTab )
	RemoveAllRoadPt(self)

	if self.pType == PlayerType.E_PlayerType_Main then
		self.RoadPtTagTab["Main"] = {}
	elseif self.pType == PlayerType.E_PlayerType_1 then
		self.RoadPtTagTab["Teamer1"] = {}
	elseif self.pType == PlayerType.E_PlayerType_2 then
		self.RoadPtTagTab["Teamer2"] = {}
	elseif self.pType == PlayerType.E_PlayerType_3 then
		self.RoadPtTagTab["Teamer3"] = {}
	else
	end
	
	local nCur = nCurTag
	local tab = SortTagTab(nTarTagTab)
	local nIndexNum = 1

	local angle = nil
	local addRoadPtArray = CCArray:create()
	for i=1,table.getn(tab) do
		local nLinkTab = GetLinkCityData(nCur,tab[i])
		for j=1,table.getn(nLinkTab) do
			local nPtX,nPtY = GetLinkPoint(nLinkTab[j])	
			local nTarX,nTarY = nil
			
			local function addRoadPtChild(  )

				if j < table.getn(nLinkTab) then
					nTarX,nTarY = GetLinkPoint(nLinkTab[j + 1])	
				else	
					nTarX,nTarY = CountryWarScene.GetCenterCityPercent(tab[i])	
				end
				angle = GetPointAngle(ccp(nPtX,nPtY), ccp(nTarX,nTarY))

				AddRoadPointAni(self,nPtX,nPtY,nIndexNum, angle)
				nIndexNum = nIndexNum + 1
			end
			addRoadPtArray:addObject(CCCallFunc:create(addRoadPtChild))	
			addRoadPtArray:addObject(CCDelayTime:create(0.1))
		end	
		nCur = tab[i]
	end
	self.Player:runAction(CCSequence:create(addRoadPtArray))
end

local function GetCurNode( self )
	return self.CurNode
end

local function GetCurPt( self )
	return ccp(self.Player:getPositionX(), self.Player:getPositionY())
end

local function GetRouteConsTime( self, nTagTab, nTarTag )
	local tab = SortTagTabAll(nTagTab)
	local index = 1
	for i=1,table.getn(tab)-1 do
		local nCityTab = self.CityTab[tab[i]]
		local nPtTimeTab = nCityTab.canMoveIndexPtTime
		local nNext = tab[i+1]
		local nPtTimeTarTab = nPtTimeTab[nNext]
		for j=1,table.getn(nPtTimeTarTab) do
			self.RoadPtTimeTab[index] = nPtTimeTarTab[j]
			index = index + 1
		end
	end
end

local function HeroMove( self, nTagTab, nTarTag )
	self.isiDle = false
	self.TotalTime = 0
	self.timeMark = 1
	self.FastForWard = 1
	self.TargetNode = nTarTag
	local indexNum = 1
	local nMoveState = false
	if self.isBloodOrDefening == true then
		nMoveState = false
	else
		nMoveState = true
	end
	local tab = SortTagTab(nTagTab,nMoveState)
	--printTab(tab)
	--print("客户端即将行走的目标城市")
	local maxNum = table.getn(tab)
	self.NextCity = tab[1]
	--print("self.NextCity = "..self.NextCity)
	local pTarPt = nil
	local pRoadPtNum = 1
	--记录每个点移动所消耗时间
	GetRouteConsTime(self, nTagTab, nTarTag)

	local tagNum = nil
	local removeTab = nil 
	if self.pType == PlayerType.E_PlayerType_Main then
		tagNum = PlayerId.TeamerMain
		removeTab = self.RoadPtTagTab["Main"]
	elseif self.pType == PlayerType.E_PlayerType_1 then
		tagNum = PlayerId.Teamer1
		removeTab = self.RoadPtTagTab["Teamer1"]
	elseif self.pType == PlayerType.E_PlayerType_2 then
		tagNum = PlayerId.Teamer2
		removeTab = self.RoadPtTagTab["Teamer2"]
	elseif self.pType == PlayerType.E_PlayerType_3 then
		tagNum = PlayerId.Teamer3
		removeTab = self.RoadPtTagTab["Teamer3"]
	else
	end

	local function MoveEnd( )
		if self.IsRunning == false then
			--状态判断(强行进入战斗)
			--SetRoleState(self.pType, PlayerState.E_PlayerState_Free)
			self.state = PlayerState.E_PlayerState_Free
		end
	end

	local function MoveAct(  )
		if indexNum <= maxNum then 
			--print("Move Move Move Move Move Move Move Move Move Move Move ")
			local function UpdateTargetNode( ... )
				if self.IsRunning == true then 
					--print("self.timeMark = "..self.timeMark.."到达城池"..tab[indexNum].."速度为 = "..self.CurSpeed)
					--PauseAndWaitServerBack(self)
					if self.timeMark == self.FastForWard then
						--print("self.FastForWard = "..self.FastForWard)
						SetActScale(self,1)
						self.FastForWard = 1
					end
					self.timeMark = self.timeMark + 1
					self.CurNode = tab[indexNum]
					---print("self.CurNode = "..self.CurNode)
					if nTarTag ~= self.TargetNode then
						--说明目标改变，重新计算路径
						self.MoveTab = PathFinding.Init(self.CurNode,self.TargetNode,self.CityTab)
						AddRoadPointALLAni(self, self.CurNode, nTarTag, self.MoveTab)
						if self.MoveTab ~= nil then 
							HeroMove(self, self.MoveTab,self.TargetNode)
						else
							--print("目标目标不可达")
						end
						self.IsChangeTarget = false	
					else
						--print("当前城池改为"..GetCityNameByIndex(GetIndexByCTag(self.CurNode)).."继续前往"..GetCityNameByIndex(GetIndexByCTag(nTarTag)))
						indexNum = indexNum + 1	
						if indexNum <= maxNum then
							self.NextCity = tab[indexNum]
							print("self.NextCity = "..self.NextCity)
						end
						MoveAct()
					end
				end
			end
			if CheckCityState(self, tab[indexNum]) then
				if tab[indexNum] ~= self.CurNode then
					self.IsRunning = true
					local pCurPtX,pCurPtY = CountryWarScene.GetCenterCityPercent(self.CurNode)
					local pTarPtX,pTarPtY = CountryWarScene.GetCenterCityPercent(tab[indexNum])
					local pFirstX = pCurPtX
					local pFirstY = pCurPtY
					SetHeroDirection(pTarPtX,pCurPtX, self.Player)
					local nLinkTab = GetLinkCityData(self.CurNode,tab[indexNum])
					local actionArrayMove = CCArray:create()
					local nPtX,nPtY				
					for i=1,table.getn(nLinkTab) do
						nPtX,nPtY = GetLinkPoint(nLinkTab[i])
						local nCountPtX,nCountPtY = GetLinkPoint(nLinkTab[i])

						local function UpdateCurNodeState()
							SetHeroDirection(nCountPtX,pCurPtX, self.Player)
							pCurPtX    = nCountPtX
							pCurPtY    = nCountPtY
							--print("更新路点后pCurPt点的坐标为 x = "..pCurPtX..", y = "..pCurPtY)
						end
						local function CountMoveTime(nPtX,nPtY)
							self.MoveTime = CountDistanceByPoint(CCPoint(nPtX,nPtY),CCPoint(pFirstX,pFirstY)) / self.HERO_SPEED
							pFirstX    = nPtX
							pFirstY    = nPtY
							--print("self.MoveTime = "..self.MoveTime)
							return self.MoveTime
						end

						local function PlayRoadAni( )
							self.TotalTime = self.TotalTime + self.MoveTime
							--print("耗时.."..self.TotalTime.."秒")
						    --print("self.timeMark = "..self.timeMark.."速度为 = "..self.CurSpeed)
							if removeTab[tagNum + pRoadPtNum] ~= nil then
								removeTab[tagNum + pRoadPtNum]:PlayAni("Animation2")						
								pRoadPtNum = pRoadPtNum + 1
							else
								--print(self.RoadPtTagTab[pRoadPtNum].."为空")
							end
							if self.timeMark == self.FastForWard then
								SetActScale(self,1)
								self.FastForWard = 1
							end
							self.timeMark = self.timeMark + 1
						end

						actionArrayMove:addObject(CCCallFunc:create(UpdateCurNodeState))
						actionArrayMove:addObject(CCMoveTo:create(CountMoveTime(nPtX,nPtY),ccp(nPtX,nPtY)))
						actionArrayMove:addObject(CCCallFunc:create(PlayRoadAni))
					end	
					local function UpdateHeroDir()
						SetHeroDirection(pTarPtX,pCurPtX, self.Player)
					end
					actionArrayMove:addObject(CCCallFunc:create(UpdateHeroDir))	
					self.MoveTime		= CountDistanceByPoint(CCPoint(pTarPtX,pTarPtY),CCPoint(nPtX,nPtY)) / self.HERO_SPEED
					--print("Target self.MoveTime = "..self.MoveTime)
					actionArrayMove:addObject(CCMoveTo:create(self.MoveTime,ccp(pTarPtX,pTarPtY)))
					--actionArrayMove:addObject(CCMoveTo:create(MoveToCityTime / table.getn(nLinkTab),ccp(pTarPtX,pTarPtY)))	
					actionArrayMove:addObject(CCCallFunc:create(UpdateTargetNode))
					actionArrayMove:addObject(CCCallFunc:create(MoveEnd))
					self.Player:runAction(CCSequence:create(actionArrayMove))
				
					PlayHeroAnimation(self.Player,GetGeneralResId(self.resId),Ani_Def_Key.Ani_run)
				else
					UpdateTargetNode()
					--print("起点")
				end
			end
		else
			self.IsRunning = false
			self.TotalTime = 0
			self.timeMark = 1
			self.FastForWard = 1
			--print("恢复速度")
			SetActScale(self,1)
			PlayHeroAnimation(self.Player,GetGeneralResId(self.resId),Ani_Def_Key.Ani_stand)	
		end
	end
	MoveAct( )
end

local function GeneralChangeSpeed( self, nDeltaTime )
	-- 武将修改移动速度
	SetActScale(self,50)
	local nCurTime = self.TotalTime + nDeltaTime 
	local nTime = 0
	for i=1,table.getn(self.RoadPtTimeTab) do
		nTime = nTime + self.RoadPtTimeTab[i]
		if nTime > nCurTime then
			self.FastForWard = i
			break
		end
		if i == table.getn(self.RoadPtTimeTab) then
			self.FastForWard = table.getn(self.RoadPtTimeTab)
			break
		end
	end
end

local function ChangseTeamState( self, nState )
	self.state = nState
	SetRoleState(self.pType, nState)
	UpdateTeamAttr(self.pType-1, TEAM_ATTR.Blood, GetTeamCurBlood(self.pType-1))
end

--参数1：所有要经过的城池节点表
--参数2：当前的目标节点
local function PlayerMove( self, nTarTag, nTeamID, nActType, isSendToServer )
	if self.IsContrack == false then
		print(nTeamID.."已过期，无法移动")
		return
	end

	if nActType == PlayerState.E_PlayerState_Move and self.IsBlood == true then
		TipLayer.createTimeLayer("血战尚未结束,无法移动")
		return
	end

	local index = GetIndexByCTag(nTarTag)
	local isCanMove = false
	self.isBloodOrDefening = false
	if nActType == PlayerState.E_PlayerState_BloodWar or nActType == PlayerState.E_PlayerState_Defense then
		self.isBloodOrDefening = true
	end
	if self.IsRunning == false then
		if nTarTag ~= self.CurNode then
			isCanMove = true
		end
	else
		if nTarTag ~= self.NextCity then
			isCanMove = true
		end
	end

	if isCanMove == true then
		local function WaitMoveOrder( ... )
			if self.IsRunning == false then
				--print("Move Move Move")
				self.TargetNode = nTarTag
				AddRoadPointALLAni(self, self.CurNode, nTarTag, self.MoveTab)
				HeroMove(self, self.MoveTab, nTarTag)
				--SetRoleState(self.pType, PlayerState.E_PlayerState_Move)
				self.state = PlayerState.E_PlayerState_Move
			else
				--print("ChangeTarget IsRunning")
				--print("英雄正在移动，更改目标城市为 = "..GetCityNameByIndex(GetIndexByCTag(nTarTag)))
				self.IsChangeTarget = true
				self.TargetNode = nTarTag
			end
		end
		--发送服务器移动指令（队伍索引，移动的城池数量，移动的城池数组）
		local tab = {}
		if self.IsRunning == true then
			--移动中更换目标点
			--print("移动中更换目标点 NextCity = "..self.NextCity)
			if self.isBloodOrDefening == true then
				self.MoveTab, isFailedByMisty = PathFinding.Init(self.NextCity, nTarTag, self.CityTab, true)
			else
				self.MoveTab, isFailedByMisty = PathFinding.Init(self.NextCity, nTarTag, self.CityTab)
			end
			if self.MoveTab == nil then
				if isFailedByMisty == true then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1502,nil)
					pTips = nil
				else
					TipLayer.createTimeLayer("目的地不可达",2)
				end
				return false
			end
			if self.isBloodOrDefening == true then
				tab = SortTagTab(self.MoveTab, false)
				--print("血战路点")
			else
				tab = SortTagTab(self.MoveTab, true)
			end
		else
			--print("空闲中移动")
			if self.isBloodOrDefening == true then
				self.MoveTab, isFailedByMisty = PathFinding.Init(self.CurNode, nTarTag, self.CityTab, true)
			else
				self.MoveTab, isFailedByMisty = PathFinding.Init(self.CurNode, nTarTag, self.CityTab)
			end
			if self.MoveTab == nil then
				if isFailedByMisty == true then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1502,nil)
					pTips = nil
				else
					TipLayer.createTimeLayer("目的地不可达",2)
				end
				return false
			end
			if self.isBloodOrDefening == true then
				--printTab(self.MoveTab)
				tab = SortTagTab(self.MoveTab, false)
				--print("血战路点--------")
			else
				tab = SortTagTab(self.MoveTab, true)
			end
		end
		if isSendToServer == nil then
			--print("当前移动的状态是 = "..nActType)
			--print("向服务器发送即将走过的城市")
			--判断所走城池走是否有地方国家如果有则只到那个国家
			Packet_CountryWarMove.SetSuccessCallBack(WaitMoveOrder, nTeamID)
			network.NetWorkEvent(Packet_CountryWarMove.CreatPacket(nTeamID-1, nActType, table.getn(tab), tab))
		else
			WaitMoveOrder()
			--print("不向服务器发移动消息")
		end
	else
		print("原地")
	end	

	return true
end

local function IsPlayerCanMove( self, nTarTag, nTeamID, nActType, isSendToServer )
	if self.IsContrack == false then
		return
	end
	local index = GetIndexByCTag(nTarTag)
	local isCanMove = false
	self.isBloodOrDefening = false
	if nActType == PlayerState.E_PlayerState_BloodWar or nActType == PlayerState.E_PlayerState_Defense then
		self.isBloodOrDefening = true
	end
	if self.IsRunning == false then
		if nTarTag ~= self.CurNode then
			isCanMove = true
		end
	else
		if nTarTag ~= self.NextCity then
			isCanMove = true
		end
	end

	if isCanMove == true then
		local function WaitMoveOrder( ... )
			if self.IsRunning == false then
				self.TargetNode = nTarTag
				self.state = PlayerState.E_PlayerState_Move
			else
				self.IsChangeTarget = true
				self.TargetNode = nTarTag
			end
		end
		local tab = {}
		if self.IsRunning == true then
			--移动中更换目标点
			--print("移动中更换目标点 NextCity = "..self.NextCity)
			if self.isBloodOrDefening == true then
				self.MoveTab = PathFinding.Init(self.NextCity, nTarTag, self.CityTab, true)
			else
				self.MoveTab = PathFinding.Init(self.NextCity, nTarTag, self.CityTab)
			end
			if self.MoveTab == nil then
				TipLayer.createTimeLayer("目的地不可达",2)
				return false
			end
			if self.isBloodOrDefening == true then
				tab = SortTagTab(self.MoveTab, false)
			else
				tab = SortTagTab(self.MoveTab, true)
			end
		else
			if self.isBloodOrDefening == true then
				self.MoveTab = PathFinding.Init(self.CurNode, nTarTag, self.CityTab, true)
			else
				self.MoveTab = PathFinding.Init(self.CurNode, nTarTag, self.CityTab)
			end
			if self.MoveTab == nil then
				TipLayer.createTimeLayer("目的地不可达",2)
				return false
			end
			if self.isBloodOrDefening == true then				tab = SortTagTab(self.MoveTab, false)
			else
				tab = SortTagTab(self.MoveTab, true)
			end
		end
	else
		print("原地")
	end	

	return true
end

local function SetState( self, nState )
	self.state = nState
end

local function GetState( self )
	return self.state
end

local function SetSpeed( self, nSpeed )
	self.HERO_SPEED = nSpeed
end

local function GetPlayScale( self )
	return self.PlayScale
end

local function SetPlayScale( self, nScale )
	self.PlayScale = nScale
	self.Player:getAnimation():setSpeedScale(nScale)
end

local function AsyncRoadWithServer( ... )
	-- 当游戏后台运行之后恢复运行时，要和服务器做同步
end

local function SetIsBack( self, nIsBack )
	self.IsBack = nIsBack
end

local function GetIsBack( self )
	return self.IsBack
end

local function SetBloodState( self, nState )
	self.IsBlood = nState
end

local function GetBloodState( self )
	return self.IsBlood
end

local function SetDefenseState( self, nState )
	self.IsDefense = nState
end

local function GetDefenseState( self )
	return self.IsDefense
end

local function SetPlayerAttr( self, nState, nResId )
	self.isChangeAttr = nState
	self.resId = nResId
end

local function GetPlayerAttr( self )
	return self.isChangeAttr
end
--设置当前佣兵的合约状态（续期 or 到期）
local function SetContractState( self, nState )
	self.IsContrack = nState
end

local function GetContractState( self )
	return self.IsContrack
end

------------------------------------------远征军----------------------------------------
local function CreateShowHead( nIndex, nPt )
	local nResId 		= GetExpeDitionResImgID(nIndex)
	local nShowPath		= GetPathByImageID(nResId)
	local imgShow 		= ImageView:create()
	imgShow:loadTexture(nShowPath)
	imgShow:setPosition(ccp(nPt.x - 50 + (nIndex * 2), nPt.y+ 50))
	return imgShow
end

local function ExpDitionMove( self, nGrid, nTarCityID )
	--瞬移到达目标点
	local pTarPtX,pTarPtY = CountryWarScene.GetCenterCityPercent(nTarCityID)
	local actionMove = CCArray:create()
	actionMove:addObject(CCScaleTo:create(0.2, 1.0, 1.2))
	actionMove:addObject(CCScaleTo:create(0.2, 0, 0))
	actionMove:addObject(CCMoveTo:create(0.01, ccp(pTarPtX - 20 + (nGrid * 10),pTarPtY)))
	actionMove:addObject(CCScaleTo:create(0.2, 1.0, 1.2))
	actionMove:addObject(CCScaleTo:create(0.2, 1.0, 1.0))
	self.Player:runAction(CCSequence:create(actionMove))

	self.CurCity = nTarCityID
	print("目标城市更换为 = "..self.CurCity)
end

local function GetGrid( self )
	return self.Grid
end

local function CreateExpeDition( self, nBase, nCurNode, nCityTab, nPt, nRoadBase, nIndex, nGrid )
	if nBase:getChildByTag(2999 + nIndex) ~= nil then
		nBase:getChildByTag(2999 + nIndex):removeFromParentAndCleanup(true)
		self.Player = nil
	end

	self.Grid    = nGrid

	self.CurCity = nCurNode

	self.Player = CreateShowHead(nIndex, nPt)

	nBase:addChild(self.Player,1302,2999 + nIndex)

end

local function SetAttackMistyIndex( self, nFogIndex )
	if nFogIndex ~= nil then
		self.AttackingMistyIndex = nFogIndex
	end
end

local function GetAttackMistyIndex( self )
	if self.AttackingMistyIndex >= 0 then
		return self.AttackingMistyIndex
	end

	return nil
end

local function PlayerChangeAni( self, nTempID )

	self.resId = nTempID

	local strAnimationfileName = AnimationData.getFieldByIdAndIndex(GetGeneralResId(nTempID),"AnimationfileName")
	print("pAnimationfileNamepAnimationfileName = " .. strAnimationfileName)		
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strAnimationfileName)

	local strAnimationName = AnimationData.getFieldByIdAndIndex(GetGeneralResId(nTempID),"AnimationName")
	print("strAnimationName = "..strAnimationName)
		
	self.Player:init(tostring(strAnimationName))
	local pState = Ani_Def_Key.Ani_stand
	if self.state == PlayerState.E_PlayerState_Free then
		pState = Ani_Def_Key.Ani_stand
	elseif self.state == PlayerState.E_PlayerState_Move then
		pState = Ani_Def_Key.Ani_run
	end

	self.Player:getAnimation():play(GetAniName_Res_ID(GetGeneralResId(nTempID), pState))	
end

local function GetPlayRes( self )
	if self.resId ~= nil then

		return tonumber(self.resId)

	end
end

------------------------------------------远征军----------------------------------------

--创建玩家佣兵对象
local function CreatePlayer( self, nBase, nCurNode, nCityTab, nPt, nRoadBase, resId, nType, isLife )

	self.resId = resId

	if nBase:getNodeByTag(1999 + nType) ~= nil then
		nBase:getNodeByTag(1999 + nType):removeFromParentAndCleanup(true)
		self.Player = nil
	end

    self.Player = UIInterface_CreatAnimateByResID(GetGeneralResId(self.resId))

	self.Player:setScale(0.7)
	self.Player:setPosition(ccp(nPt.x, nPt.y))
	nBase:addNode(self.Player,1301,1999 + nType)	

	self.state 			= PlayerState.E_PlayerState_Free

	self.PlayScale 		= self.Player:getAnimation():getSpeedScale()

	self.IsBlood 		= false 	--是否在血战

	self.IsDefense 		= false 	--是否在坚守

	self.IsContrack     = true		--佣兵是否有效（在合约期内）

	self.AttackingMistyIndex = GetTeamMistyIndex( nType - 1 ) + 1 	--正在攻打的迷雾索引

	if isLife ~= nil and nType ~= PlayerType.E_PlayerType_Main then
		if isLife == true then
			--过期
			self.IsContrack = false 
		end    
	end

	self.Parent 		= nBase

	self.isiDle 		= true

	self.CurSpeed 		= 1

	self.CityTab   		= nCityTab

	self.IsRunning 		= false

	self.CurNode   		= nCurNode

	self.IsBack 		= false 		--是否进入后台

	self.IsStop 		= false

	self.isChangeAttr   = false 		--是否更新了属性头像动画形象等等

	self.MoveTime 		= 0

	self.IsChangeTarget = true

	self.HERO_SPEED     = 100.5

	self.RoadBase 		= nRoadBase

	self.pType 			= nType

	self.timeMark 		= 1

	self.TotalTime  	= 0

	self.FastForWard 	= 1

	self.NextCity  		= 0

	self.isBloodOrDefening = false

	self.RoadPtTagTab = {}

	self.RoadPtTagTab["Main"] = {}

	self.RoadPtTagTab["Teamer1"] = {}

	self.RoadPtTagTab["Teamer2"] = {}

	self.RoadPtTagTab["Teamer3"] = {}

	self.RoadPtTimeTab = {} 		--记录行走的每个路点所需要的时间

	self.BatchNode = CCBatchNode:create()

	self.RoadBase:addChild(self.BatchNode)
end

function Create(  )
	local tab = {
		CreatePlayer	   = CreatePlayer,
		PlayerMove		   = PlayerMove,
		SetTargetNode      = SetTargetNode,
		GetPlayer 		   = GetPlayer,
		GetCurPt 		   = GetCurPt,
		GetCurNode 		   = GetCurNode,
		GetPlayScale	   = GetPlayScale,
		SetPlayScale	   = SetPlayScale,
		SetState 		   = SetState,
		GetState		   = GetState,
		SetSpeed		   = SetSpeed,
		SetIsBack		   = SetIsBack,
		GetIsBack		   = GetIsBack,
		SetActScale 	   = SetActScale,
		GeneralChangeSpeed = GeneralChangeSpeed,
		SetStopMove 	   = SetStopMove,
		ChangseTeamState   = ChangseTeamState,
		SetBloodState 	   = SetBloodState,
		GetBloodState 	   = GetBloodState,
		SetDefenseState    = SetDefenseState,
		GetDefenseState    = GetDefenseState,
		SetContractState   = SetContractState,
		GetContractState   = GetContractState,
		SetAttackMistyIndex = SetAttackMistyIndex,
		GetAttackMistyIndex = GetAttackMistyIndex,
		IsPlayerCanMove		= IsPlayerCanMove,
		PlayerChangeAni		= PlayerChangeAni,
		GetPlayRes 			= GetPlayRes,
	}

	return tab
end

function CreateByExpeDition( )
	local tab = {
		CreateExpeDition	   = CreateExpeDition,
	}

	return tab
end

