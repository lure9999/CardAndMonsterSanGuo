require "Script/Common/Common"
require "Script/Main/CountryWar/CountryWarDef"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/AtkChooseCity"
require "Script/Main/CountryWar/PathManager"
require "Script/serverDB/server_CountryWarTeamMesDB"

module("CountryWarEventManager", package.seeall)

--require "Script/Main/CountryWar/CountryWarScene"

local UIInterface_CreatAnimateByResID 	= 	UIInterface.CreatAnimateByResID
local GetPointAngle 					= 	BaseSceneLogic.GetPointAngle

local GetGeneralResId					= 	CountryWarData.GetGeneralResId
local GetLinkCityData					=	CountryWarData.GetLinkCityData
local GetPlayerCountry 					=	CountryWarData.GetPlayerCountry
local GetMainCityByCountry				=	CountryWarData.GetMainCityByCountry
local DelExpeData						=	CountryWarData.DelExpeData

local GetIndexByCTag					=	CountryWarLogic.GetIndexByCTag
local numIsIntab						=	CountryWarLogic.numIsIntab
local GetCurActType						=	CountryWarLogic.GetCurActType
local GetLinkPoint						=	CountryWarLogic.GetLinkPoint

local SetRoleState						=	CountryUILayer.SetRoleState

--local GetTeamObj						=	CountryWarScene.GetTeamObj

local ActionTag_Guide 					= 1000

local m_TeamTab = nil

--玩家向目标城市前进
local function CityEventByRoleForWardToCity( self, nData, pBase )

	local nRoleTab = {}
	local nTagTab = {}

	local function CreateRole( Base, nBornPt ,index )
		local Role = nil
		Role = UIInterface_CreatAnimateByResID(GetGeneralResId(CommonData.g_MainDataTable.nModeID))
		Role:setScale(0.7)
		Role:setOpacity(150)
		Role:setPosition(ccp(nBornPt.x, nBornPt.y))
		Base:addNode(Role,1301)
		nRoleTab[index] = Role
	end
	
	for i=1,table.getn(nData) do
		local pEventData = nData[i]
		local x,y = CountryWarScene.GetCenterCityPercent(pEventData[CityEvent_FToCity.E_CityEvent_FToCity_BornCity])
		CreateRole(pBase, ccp(x,y), i)
		local tab = {}
		tab[1] = pEventData[CityEvent_FToCity.E_CityEvent_FToCity_BornCity]
		tab[2] = pEventData[CityEvent_FToCity.E_CityEvent_FToCity_TargetCity]
		nTagTab[i] = tab
	end

	--角色移动
	for i=1,table.getn(nTagTab) do
		local Role = nRoleTab[i]
		local function DestroyFunc( )
			Role:removeFromParentAndCleanup(true)
			Role = nil
		end
		CountryWarScene.RoleForWardToCity(Role, nTagTab[i], DestroyFunc)
	end
end

local function RemoveAllRoad( self, nBase )
	if self.Roadtab ~= nil and table.getn(self.Roadtab) > 0 then
		for key,value in pairs(self.Roadtab) do
			value:removeFromParentAndCleanup(true)
		end

		self.Roadtab = {}
	end

	if self.RoadActionTab ~= nil and table.getn(self.RoadActionTab) > 0 then
		for key,value in pairs(self.RoadActionTab) do
			nBase:stopAction(value)
		end

		self.RoadActionTab = {}
	end
end

local function AddShowRoadAni( self, nCurTag, nTarTagTab, nBase )

	self.Roadtab = {}

	self.RoadActionTab = {}

	RemoveAllRoad(self)

	local function AddRoadPointAni( nptX, nptY, nAngle)
		local pRoadAniObj = AniNode.Create()

		pRoadAniObj:CreateAniNode(nptX, nptY, nAngle)
		pRoadAniObj:SetActSpeed(1)

		local pNode = pRoadAniObj:GetAniNode()
		nBase:addChild(pNode)

		table.insert(self.Roadtab, pNode)
	end


	local angle = nil
	for i=1,table.getn(nTarTagTab) do
		local addRoadPtArray = CCArray:create()
		local nLinkTab = GetLinkCityData(nCurTag,nTarTagTab[i])
		for j=1,table.getn(nLinkTab) do
			local nPtX,nPtY = GetLinkPoint(nLinkTab[j])	
			local nTarX,nTarY = nil
			
			local function addRoadPtChild(  )

				if j < table.getn(nLinkTab) then
					nTarX,nTarY = GetLinkPoint(nLinkTab[j + 1])	
				else	
					nTarX,nTarY = CountryWarScene.GetCenterCityPercent(nTarTagTab[i])	
				end
				angle = GetPointAngle(ccp(nPtX,nPtY), ccp(nTarX,nTarY))

				AddRoadPointAni( nPtX,nPtY, angle)
			end
			addRoadPtArray:addObject(CCCallFunc:create(addRoadPtChild))	
			addRoadPtArray:addObject(CCDelayTime:create(0.1))
		end	
		local pAction = CCSequence:create(addRoadPtArray)
		pAction:setTag(ActionTag_Guide + i)
		nBase:runAction(pAction)
		table.insert(self.RoadActionTab, pAction)
	end
	
end

--突进事件
local function CityEventByRoleDart( self, nState, nBase, nPosX, nPosY, nRemoveCallFunc )
	print("突进事件")
	if nBase:getNodeByTag(1900) == nil then
		local pChooseLayer = AtkChooseCity.ChooseAtkCity(nState, nRemoveCallFunc)
		if pChooseLayer ~= nil then
			pChooseLayer:setPosition(ccp(nPosX - 170, nPosY - 105))
			nBase:addNode(pChooseLayer,1301,1900)
		else 
			return false
		end
	end
	return true
end
--撤退
local function CityEventByRoleRetreat( self, nState, nBase, nPosX, nPosY, nRemoveCallFunc)
	print("撤退事件")
	if nBase:getNodeByTag(1900) == nil then
		local pChooseLayer = AtkChooseCity.ChooseAtkCity(nState, nRemoveCallFunc)
		if pChooseLayer ~= nil then
			pChooseLayer:setPosition(ccp(nPosX - 170, nPosY - 105))
			nBase:addNode(pChooseLayer,1301,1900)
		else
			return false
		end
	end
	return true
end
--远征军/等等扩展类型的移动事件
function AnexpeditionArmyEvent( nGrid, nTarCityID )
	--[[print("nGrid = "..nGrid)
	print("nTarCityID = "..nTarCityID)
	print("ExpDitionMove MOVEEEEEEEEEEEEEEEEEEEEEEEE")
	local nExpdTab = CountryWarScene.GetExpeDitionbj()
	printTab(nExpdTab)
	if nExpdTab ~= nil then
		for i=1,table.getn(nExpdTab) do
			print("nExpdTab[i]:GetGrid() = "..nExpdTab[i]:GetGrid())
			if nExpdTab[i]:GetGrid() == nGrid then
				nExpdTab[i]:ExpDitionMove(nGrid, nTarCityID)
				break
			end
		end
	end]]
end 

--远征军数据源删除
function AnexpeditionArmyEventDel( nGrid )
	if nGrid ~= nil then
		DelExpeData(nGrid)
	else
		print("删除远征军索引为空, Error in CountryWarEventManager line 114")
	end
end

function IsCanBloodWarOrDefense( nTeamID, nCityID )
	-- 判断某个队伍是否可以血战或坚守
	m_TeamTab = CountryWarScene.GetTeamObj()
	local nType = GetCurActType(nCityID)
	if tonumber(nTeamID) == PlayerType.E_PlayerType_Main - 1 then
		if m_TeamTab["MainGeneral"] ~= nil then
			local pIsMove = m_TeamTab["MainGeneral"]:IsPlayerCanMove(nCityID, PlayerType.E_PlayerType_Main, nType)
			return pIsMove
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_1 - 1 then
		if m_TeamTab["Teamer1"] ~= nil then
			local pIsMove = m_TeamTab["Teamer1"]:IsPlayerCanMove(nCityID, PlayerType.E_PlayerType_1, nType)
			return pIsMove
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_2 - 1 then
		if m_TeamTab["Teamer2"] ~= nil then
			local pIsMove = m_TeamTab["Teamer2"]:IsPlayerCanMove(nCityID, PlayerType.E_PlayerType_2, nType)
			return pIsMove
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_3 - 1 then
		if m_TeamTab["Teamer3"] ~= nil then
			local pIsMove = m_TeamTab["Teamer3"]:IsPlayerCanMove(nCityID, PlayerType.E_PlayerType_3, nType)
			return pIsMove
		end 
	end
end

--血战/坚守事件
function CountryWarCityBloodWar( nTeamID, nCityID )
	m_TeamTab = CountryWarScene.GetTeamObj()
	local nType = GetCurActType(nCityID)
	if tonumber(nTeamID) == PlayerType.E_PlayerType_Main - 1 then
		if m_TeamTab["MainGeneral"] ~= nil then
			m_TeamTab["MainGeneral"]:PlayerMove(nCityID, PlayerType.E_PlayerType_Main, nType)
			if nType == PlayerState.E_PlayerState_BloodWar then
				m_TeamTab["MainGeneral"]:SetBloodState(true)
			elseif nType == PlayerState.E_PlayerState_Defense then
				m_TeamTab["MainGeneral"]:SetDefenseState(true)
				print(nType, nCityID)
				--Pause()
			end
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_1 - 1 then
		if m_TeamTab["Teamer1"] ~= nil then
			m_TeamTab["Teamer1"]:PlayerMove(nCityID, PlayerType.E_PlayerType_1, nType)
			if nType == PlayerState.E_PlayerState_BloodWar then
				m_TeamTab["Teamer1"]:SetBloodState(true)
			elseif nType == PlayerState.E_PlayerState_Defense then
				m_TeamTab["Teamer1"]:SetDefenseState(true)
			end
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_2 - 1 then
		if m_TeamTab["Teamer2"] ~= nil then
			m_TeamTab["Teamer2"]:PlayerMove(nCityID, PlayerType.E_PlayerType_2, nType)
			if nType == PlayerState.E_PlayerState_BloodWar then
				m_TeamTab["Teamer2"]:SetBloodState(true)
			elseif nType == PlayerState.E_PlayerState_Defense then
				m_TeamTab["Teamer2"]:SetDefenseState(true)
			end
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_3 - 1 then
		if m_TeamTab["Teamer3"] ~= nil then
			m_TeamTab["Teamer3"]:PlayerMove(nCityID, PlayerType.E_PlayerType_3, nType)
			if nType == PlayerState.E_PlayerState_BloodWar then
				m_TeamTab["Teamer3"]:SetBloodState(true)
			elseif nType == PlayerState.E_PlayerState_Defense then
				m_TeamTab["Teamer3"]:SetDefenseState(true)
			end
		end 
	end
end

--玩家移动中被停止
function CountryWarStopMove( nTeamID, nCityID )
	m_TeamTab = CountryWarScene.GetTeamObj()
	if tonumber(nTeamID) == PlayerType.E_PlayerType_Main - 1 then
		if m_TeamTab["MainGeneral"] ~= nil then
			local x,y  = CountryWarScene.GetCenterCityPercent(nCityID)
			m_TeamTab["MainGeneral"]:SetStopMove(ccp(x,y), nCityID)
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_1 - 1 then
		if m_TeamTab["Teamer1"] ~= nil then
			local x,y  = CountryWarScene.GetCenterCityPercent(nCityID)
			m_TeamTab["Teamer1"]:SetStopMove(ccp(x,y), nCityID)
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_2 - 1 then
		if m_TeamTab["Teamer2"] ~= nil then
			local x,y  = CountryWarScene.GetCenterCityPercent(nCityID)
			m_TeamTab["Teamer2"]:SetStopMove(ccp(x,y), nCityID)
		end 
	end
	if tonumber(nTeamID) == PlayerType.E_PlayerType_3 - 1 then
		if m_TeamTab["Teamer3"] ~= nil then
			local x,y  = CountryWarScene.GetCenterCityPercent(nCityID)
			m_TeamTab["Teamer3"]:SetStopMove(ccp(x,y), nCityID)
		end 
	end
end

function PlayerChangeLife( nTeamID, nState )
	m_TeamTab = CountryWarScene.GetTeamObj()
	if m_TeamTab ~= nil then
		if tonumber(nTeamID) == PlayerType.E_PlayerType_1 - 1 then
			if m_TeamTab["Teamer1"] ~= nil then
				m_TeamTab["Teamer1"]:SetContractState(nState)
			end 
		end
		if tonumber(nTeamID) == PlayerType.E_PlayerType_2 - 1 then
			if m_TeamTab["Teamer2"] ~= nil then
				m_TeamTab["Teamer2"]:SetContractState(nState)
			end 
		end
		if tonumber(nTeamID) == PlayerType.E_PlayerType_3 - 1 then
			if m_TeamTab["Teamer3"] ~= nil then
				m_TeamTab["Teamer3"]:SetContractState(nState)
			end 
		end
	end
end

--玩家状态改变
function PlayerChangeState( nTeamID, nTeamState )
	m_TeamTab = CountryWarScene.GetTeamObj()
	if m_TeamTab ~= nil then
		if tonumber(nTeamID) == PlayerType.E_PlayerType_Main - 1 then
			if m_TeamTab["MainGeneral"] ~= nil then
				m_TeamTab["MainGeneral"]:ChangseTeamState(nTeamState)
			end 
		end
		if tonumber(nTeamID) == PlayerType.E_PlayerType_1 - 1 then
			if m_TeamTab["Teamer1"] ~= nil then
				m_TeamTab["Teamer1"]:ChangseTeamState(nTeamState)
			end 
		end
		if tonumber(nTeamID) == PlayerType.E_PlayerType_2 - 1 then
			if m_TeamTab["Teamer2"] ~= nil then
				m_TeamTab["Teamer2"]:ChangseTeamState(nTeamState)
			end 
		end
		if tonumber(nTeamID) == PlayerType.E_PlayerType_3 - 1 then
			if m_TeamTab["Teamer3"] ~= nil then
				m_TeamTab["Teamer3"]:ChangseTeamState(nTeamState)
			end 
		end	
	end
end

--游戏切入后台运行
function CountryWarEnterBackground( )
	-- 渲染停止
	m_TeamTab = CountryWarScene.GetTeamObj()
	if m_TeamTab ~= nil then
		if m_TeamTab["MainGeneral"] ~= nil then 
			if m_TeamTab["MainGeneral"]:GetState() == PlayerState.E_PlayerState_Move then
				m_TeamTab["MainGeneral"]:SetIsBack(true)
			end
		end
		if m_TeamTab["Teamer1"] ~= nil then 
			if m_TeamTab["Teamer1"]:GetState() == PlayerState.E_PlayerState_Move then
				m_TeamTab["Teamer1"]:SetIsBack(true)
			end
		end
		if m_TeamTab["Teamer2"] ~= nil then 
			if m_TeamTab["Teamer2"]:GetState() == PlayerState.E_PlayerState_Move then
				m_TeamTab["Teamer2"]:SetIsBack(true)
			end
		end
		if m_TeamTab["Teamer3"] ~= nil then 
			if m_TeamTab["Teamer3"]:GetState() == PlayerState.E_PlayerState_Move then
				m_TeamTab["Teamer3"]:SetIsBack(true)
			end
		end
	end
end

--游戏恢复前台运行
function CountryWarEnterForeground( nTime )
	-- 渲染恢复 计算当前人物需要快进多少 
	m_TeamTab = CountryWarScene.GetTeamObj()
	if m_TeamTab ~= nil then
		if m_TeamTab["MainGeneral"] ~= nil then 
			if m_TeamTab["MainGeneral"]:GetIsBack() == true and m_TeamTab["MainGeneral"]:GetState() == PlayerState.E_PlayerState_Move then 
				--说明在后台运行前 主将是正在移动的
				print("计算主将需要快进多少秒")
				m_TeamTab["MainGeneral"]:SetIsBack(false)
				m_TeamTab["MainGeneral"]:GeneralChangeSpeed(nTime)
			end
		end
		if m_TeamTab["Teamer1"] ~= nil then 
			if m_TeamTab["Teamer1"]:GetIsBack() == true and m_TeamTab["Teamer1"]:GetState() == PlayerState.E_PlayerState_Move then 
				--说明在后台运行前 主将是正在移动的
				print("计算主将需要快进多少秒")
				m_TeamTab["Teamer1"]:SetIsBack(false)
				m_TeamTab["Teamer1"]:GeneralChangeSpeed(nTime)
			end
		end
		if m_TeamTab["Teamer2"] ~= nil then 
			if m_TeamTab["Teamer2"]:GetIsBack() == true and m_TeamTab["Teamer2"]:GetState() == PlayerState.E_PlayerState_Move then 
				--说明在后台运行前 主将是正在移动的
				print("计算主将需要快进多少秒")
				m_TeamTab["Teamer2"]:SetIsBack(false)
				m_TeamTab["Teamer2"]:GeneralChangeSpeed(nTime)
			end
		end
		if m_TeamTab["Teamer3"] ~= nil then 
			if m_TeamTab["Teamer3"]:GetIsBack() == true and m_TeamTab["Teamer3"]:GetState() == PlayerState.E_PlayerState_Move then 
				--说明在后台运行前 主将是正在移动的
				print("计算主将需要快进多少秒")
				m_TeamTab["Teamer3"]:SetIsBack(false)
				m_TeamTab["Teamer3"]:GeneralChangeSpeed(nTime)
			end
		end
	end
end

local function CountEnemyCity( self, nCityTab, nNodeTab)
	--计算敌方城市
	PathManager.InitVars()
	local nMainCity  = GetMainCityByCountry(GetPlayerCountry())
	local tab_Attack = PathManager.Create(nMainCity, nCityTab, GetPlayerCountry())
	for key,value in pairs(nCityTab) do
		local tag = value.cityIndex
		local nCityNode = nNodeTab[tag]
		if numIsIntab(tag, tab_Attack) then
			nCityNode:AddOtherCityState(COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK ,true)		
		else
			if nCityNode:GetOtherCityState(COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK) == true then
				nCityNode:AddOtherCityState(COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK ,false)
			end
		end
	end
	printTab(tab_Attack)
	--Pause()
end

local function Destroy( nType )

end

function CreateCityObject( )
	local CityEventObject = {
		CityEventByRoleForWardToCity 				= CityEventByRoleForWardToCity,
		CityEventByRoleDart							= CityEventByRoleDart,
		CityEventByRoleRetreat						= CityEventByRoleRetreat,
		--CountryWarEnterBackground					= CountryWarEnterBackground,
		--CountryWarEnterForeground					= CountryWarEnterForeground,
		AddShowRoadAni								= AddShowRoadAni,
		CountEnemyCity 								= CountEnemyCity,
		RemoveAllRoad								= RemoveAllRoad,
		Destroy 									= Destroy,
	}

	return CityEventObject
end

