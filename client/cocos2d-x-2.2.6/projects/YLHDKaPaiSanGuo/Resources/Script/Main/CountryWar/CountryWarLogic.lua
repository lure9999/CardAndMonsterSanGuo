module("CountryWarLogic", package.seeall)

--require "Script/Main/CountryWar/CountryWarData"
--require "Script/Main/CountryWar/CountryWarDef"
--require "Script/serverDB/server_CountryWarTeamMesDB"

local GetCityCountry					=	CountryWarData.GetCityCountry
local GetAroundLinkCity					=	CountryWarData.GetAroundLinkCity
local GetPlayerCountry 					=	CountryWarData.GetPlayerCountry
local GetTeamTab						=	CountryWarData.GetTeamTab
local GetCityLockByState2 				=	CountryWarData.GetCityLockByState2
local GetCityManZuByState2				=	CountryWarData.GetCityManZuByState2
local GetCityCenterByState2 			=	CountryWarData.GetCityCenterByState2
local GetCityConfusByState2 			=	CountryWarData.GetCityConfusByState2
local GetTeamCell 						=	CountryWarData.GetTeamCell
local GetMistyCityID					=	CountryWarData.GetMistyCityID
local GetMistyAffectCityID				=	CountryWarData.GetMistyAffectCityID
local GetMistyDB 						=	CountryWarData.GetMistyDB
local GetMainCityByCountry				=	CountryWarData.GetMainCityByCountry
local GetCityMaxNum						=	CountryWarData.GetCityMaxNum
local GetCityTagByIndex					=	CountryWarData.GetCityTagByIndex

local NoEff_Top				=	{32,33,34}
local NoEff_Bottom			=	{2,3,4}
local NoEff_Left			=	{6,11,16,21,26}
local NoEff_Right			=	{10,15,20,25,30}
local NoEff_Left_Bottom		=	1
local NoEff_Left_Top		=	31
local NoEff_Right_Bottom	=	5
local NoEff_Right_Top		=	35

local COUNTRYCITY_ADD_NUM 	 	 	= 10
local COUNTRYCITY_ADD_NUM_INSERT 	= 10
local COUNT_NOW_ADD		 	 		= 0
local COUNT_NOW_BEGIN 	 	 		= 1


------------------------action加载城池循环--------------------------

local function CheckAction( nCount )
	if nCount <= COUNT_NOW_ADD then return true end
	return false
end

local function CheckCreateOver( nMaxNum)
	if nMaxNum > COUNT_NOW_BEGIN then return false end
	return true
end

local function GetActionArray( nCallBack )
	local array_action = CCArray:create()
	array_action:addObject(CCDelayTime:create(0.05))
	array_action:addObject(CCCallFunc:create(nCallBack))
	local action_list = CCSequence:create(array_action)
	array_action:removeAllObjects()
	array_action = nil 
	return action_list
end

function RunCreateCityAction(pAction, nLoadlItemCallBack, nMaxNum)
	pAction:stopAllActions()
	COUNT_NOW_ADD = 0
	if CheckAction(nMaxNum) == true then
		--如果数量较小直接加载
		if nLoadlItemCallBack~=nil then	
			--到界面里面去加载
			nLoadlItemCallBack(COUNT_NOW_BEGIN,nMaxNum, true)
		end
	else
		nLoadlItemCallBack(COUNT_NOW_BEGIN,COUNTRYCITY_ADD_NUM)
		COUNT_NOW_ADD = COUNTRYCITY_ADD_NUM
		local function CreateCheckCallBack()
			--print("添加主线任务中")
			pAction:stopAllActions()
			if CheckCreateOver(nMaxNum) == false then
				if (COUNT_NOW_ADD + COUNTRYCITY_ADD_NUM_INSERT) > nMaxNum then
					--pAction:stopAllActions()
					nLoadlItemCallBack(COUNT_NOW_ADD + 1,COUNT_NOW_ADD + (nMaxNum - COUNT_NOW_ADD), true)
				else
					nLoadlItemCallBack(COUNT_NOW_ADD + 1,(COUNTRYCITY_ADD_NUM_INSERT + COUNT_NOW_ADD))
					COUNT_NOW_ADD = COUNT_NOW_ADD + COUNTRYCITY_ADD_NUM_INSERT
					pAction:runAction(CCRepeatForever:create(GetActionArray(CreateCheckCallBack))) 
				end
			end
		end
		pAction:runAction(CCRepeatForever:create(GetActionArray(CreateCheckCallBack))) 
	end
end

--检查任务数量 如果小于 < 5 则直接加载 如果大于>5 则分页加载
function CreateCity( nMaxNum, nLoadlItemCallBack, pRunner)		
	RunCreateCityAction(pRunner, nLoadlItemCallBack, nMaxNum)
end

------------------------其他CountryWarLogic-------------------------

function PlayHeroAnimation( pPayArmature , iResID , strAniName)
	if pPayArmature ~= nil then
		pPayArmature:getAnimation():play(GetAniName_Res_ID(iResID, strAniName))	
	end 
end

function GetIndexByCTag( nCtag )
	local tab = CountryWarData.GetCityTab()
	for key,value in pairs(tab) do
		for ck,cv in pairs(value) do
			if tonumber(ck) == 1 then 
				if tonumber(cv) == nCtag then	
					local nIndex = tonumber(string.sub(tostring(key),4,string.len(key)))
					return nIndex
				end
			end
		end
	end

	return nil
end

function SortTagTab( nTagTab, nState, num )
	local index = 1
	if num ~= nil then
		index = index + num
	end
	local newTab = {}
	for i=table.getn(nTagTab) - index, 1, -1 do
		table.insert(newTab,nTagTab[i])
		if nState == true then
			local nCountry = GetCityCountry(nTagTab[i])
			if nCountry ~= GetPlayerCountry() then
				break
			end
		end
	end
	return newTab
end

function SortTagTabAll( nTagTab )
	local newTab = {}
	for i=table.getn(nTagTab), 1, -1 do
		table.insert(newTab,nTagTab[i])
	end
	return newTab
end

function GetLinkPoint( nPt )
	local nCutIndex	= string.find(nPt,"|",1)
	local nPtX = tonumber(string.sub(nPt,1,nCutIndex - 1))
	local nPtY = tonumber(string.sub(nPt,nCutIndex + 1,string.len(nPt)))
	return nPtX,nPtY
	--print(nCutIndex,nPtX,nPtY)
	--Pause()
end

function CountDistanceByPoint( nPtCur,nPtTar )
	local disX = math.pow(nPtCur.x - nPtTar.x,2)
	local disY = math.pow(nPtCur.y - nPtTar.y,2)
	return math.sqrt(disX + disY)
end

function numIsIntab( num, tab )
	for key,value in pairs(tab) do
		if num == value then
			return true
		end
	end

	return false
end

function JudgePtInEffectiveTab( nPt, Width, Height, tab )
	local tabEffective = {7,8,9,12,13,14,17,18,19,22,23,24,27,28,29,}
	if CountCurPointIsInArea(nPt, Width,Height, tab) > 0 then
		if numIsIntab(CountCurPointIsInArea(nPt, Width,Height,tab),tabEffective) then
			return true
		end
	end
	return false
end

function CreateLabel( text, size, color, fontName, pos )
	--[[local label	= CCLabelTTF:create(text,fontName,size)
	label:setColor(color)
	label:setPosition(pos)]]
	local Label = Label:create()
	Label:setFontSize(size)
	Label:setColor(color)
	Label:setFontName(fontName)
	Label:setPosition(pos)
	Label:setText(text)
	return Label
end

function JudgePtInAreType( nAreaNum	)
	if numIsIntab(nAreaNum , NoEff_Left) == true then
		--在左边的无效区域
		return 3
	elseif numIsIntab(nAreaNum , NoEff_Right) == true then
		--在右边的无效区域
		return 4
	elseif numIsIntab(nAreaNum , NoEff_Top) == true then
		--在上边的无效区域
		return 1
	elseif numIsIntab(nAreaNum , NoEff_Bottom) == true then
		--在下边的无效区域
		return 2
	elseif nAreaNum == NoEff_Left_Bottom then
		--在左下顶点的无效区域
		return 5
	elseif nAreaNum == NoEff_Left_Top then
		--在左上顶点的无效区域
		return 6
	elseif nAreaNum == NoEff_Right_Bottom then
		--在右下顶点的无效区域
		return 7
	elseif nAreaNum == NoEff_Right_Top then
		--在右下顶点的无效区域
		return 8
	end
	return -1
end

function CountCurPointIsInArea( nPt,Width, Height ,tab )
	local bRet = false
	for key,value in pairs(tab) do
		local rect = CCRectMake(value.BeginX, value.BeginY, Width, Height)
		bRet = rect:containsPoint(nPt)
		if bRet == true then
			return key
		end
	end
	return -1
end

function CountCurPoints( nPt,Width, Height )
	local floor = math.floor
	local col = floor(nPt.x / Width)
	local line  = floor(nPt.y / Height)
	--print(nPt.y,line,nPt.x,col)
	--Pause()
	local nAreaNum
	if line < 1 and col >= 1 then 
		nAreaNum = col + 1 
	elseif line >= 1 and col < 1 then
		nAreaNum = line * 5 + 1
	else 
		nAreaNum = line * 5 + col + 1 
	end
	return nAreaNum
end

function CopyItemWidget( pItemTemp )
    local pItem = pItemTemp:clone()
    local peer = tolua.getpeer(pItem)
    tolua.setpeer(pItem, peer)
    return pItem
end
--判断当前城市是否有可撤退城市
function GetCityIsRetreat( nCityID, nCountry, nNodeTab )
	local nArroundCity = GetAroundLinkCity(nCityID)
	local tabRetreat = {}
	for i=1,table.getn(nArroundCity) do
		if nCountry == GetCityCountry(nArroundCity[i]) then
			--如果是同国家，再判断状态是否为和平
			local nCityNode = nNodeTab[nArroundCity[i]]
			if nCityNode:GetState() == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
				table.insert(tabRetreat, nArroundCity[i])
			end
		end
	end

	return tabRetreat
end

--判断当前城市是否有可突进的城市
function GetCityIsDart( nCityID, nCountry, nNodeTab )
	local nArroundCity = GetAroundLinkCity(nCityID)
	local tabDart = {}
	for i=1,table.getn(nArroundCity) do
		if nCountry ~= GetCityCountry(nArroundCity[i]) then
			--如果不同国家，可以直接突进
			table.insert(tabDart, nArroundCity[i])
		else
			--如果国家相同，战斗中的也可以突进
			local nCityNode = nNodeTab[nArroundCity[i]]
			if nCityNode:GetState() == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN then
				table.insert(tabDart, nArroundCity[i])
			end
		end
	end

	return tabDart
end
--返回当前是血战还是坚守
function GetCurActType( nCityID )
	local nCountry   	= GetCityCountry(nCityID)
	local nMineCountry	= GetPlayerCountry()
	if tonumber(nCountry) ~= tonumber(nMineCountry) then
		return PlayerState.E_PlayerState_BloodWar
	else
		return PlayerState.E_PlayerState_Defense
	end
end
--判断是更新还是添加
function JudgeUpdateType( nIndex )
	local nTeamTab = GetTeamTab()

	for key,value in pairs(nTeamTab) do
		if key == nIndex then
			return true
		end
	end

	return false
end

--队伍数据源管理
function InsertSomeTeamInfo( nTab )
	server_CountryWarTeamMesDB.AddTeamMess(nTab)
end

function DelSomeTeamInfo( nIndex )
	server_CountryWarTeamMesDB.DelTeamMess(nIndex)
end

function UpdateSomeTeamInfo( nTab, nIndex )
	server_CountryWarTeamMesDB.UpdateTeamMess(nTab, nIndex)
end

--锁城
function JudgeCityCenter( nCityID )
	local nResult = GetCityCenterByState2(nCityID)
	if tonumber(nResult) == 1 then
		return true
	end 

	return false
end

function JudgeCityLock( nCityID )
	local nResult = GetCityLockByState2(nCityID)
	if tonumber(nResult) == 1 then
		return true
	end 

	return false
end

function JudgeCityManZu( nCityID )
	local nResult = GetCityManZuByState2(nCityID)
	if tonumber(nResult) == 1 then
		return true
	end 

	return false
end
--取得蛮族入侵事件的城市
function GetManZuCity(  )
	local tabManZu = {}
	for i=1,GetCityMaxNum() do
		local nCTag  = GetCityTagByIndex(i)
		if JudgeCityManZu( nCTag ) == true then
			tabManZu[nCTag] = {}
			tabManZu[nCTag]["CityID"] = nCTag
			tabManZu[nCTag]["Type"] = 1
		end

		if JudgeCityLock( nCTag ) == true then
			tabManZu[nCTag] = {}
			tabManZu[nCTag]["CityID"] = nCTag
			tabManZu[nCTag]["Type"] = 2
		end

		if JudgeCityCenter( nCTag ) == true then
			tabManZu[nCTag] = {}
			tabManZu[nCTag]["CityID"] = nCTag
			tabManZu[nCTag]["Type"] = 2
		end

	end

	return tabManZu
end

--判断某个城市是否在迷雾中或者为迷雾的中心城市
function JudgeCityMistyState( nCityID )
	local pMistyDB = GetMistyDB()

	--print(nCityID)
	--Pause()

	for i=1,table.getn(pMistyDB) do
		local pMistyIndex = pMistyDB[i]["MistyIndex"]

		if pMistyIndex ~= -1 then
			
			local pCenterCityID     = GetMistyCityID(pMistyIndex) 		--迷雾中心城市

			if nCityID == pCenterCityID then
				--print(nCityID.."和"..pCenterCityID.."中心城市相等，迷雾覆盖中")
				--Pause()
				--当前成还被迷雾覆盖中
				return false
			
			else

				--如果不是迷雾中心城市，则判断是否在周围影响城市中
				for j=1,10 do
					local pAffectCityID = GetMistyAffectCityID(pMistyIndex, j)  --中心迷雾城市影响到的其他城市

					if pAffectCityID ~= 0 then
						if nCityID == pAffectCityID then
							--print(nCityID.."和"..pCenterCityID.."城市影响到的城市"..pAffectCityID.."相等，迷雾覆盖中")
							--Pause()

							return false

						end
					else
						break
					end
				end				

			end

		end
	end

	return true

end


--牢狱
function JudgeIsUnlockCellAll(  )
	for i=0,3 do
		local pCell = GetTeamCell(i)
		if pCell ~= -1 then
			return false
		end
	end

	return true
end

--判断当前队伍是否可以血战到目标城市
function JudgeBloodWarByTeam( nTeamIndex, nCityID )
	return CountryWarEventManager.IsCanBloodWarOrDefense(nTeamIndex, nCityID)
end

--判断当前城市是否为敌方的主城
function JudgeIsEnemyMainCity( nCityID )
	local pMainCountry  = GetPlayerCountry()
	local pMainCity = GetMainCityByCountry(pMainCountry)

	local tabMainCity = {}

	for i=1,3 do
		local pCity = GetMainCityByCountry(i)
		if nCityID == pCity and nCityID ~= pMainCity then
			return true
		end
	end

	return false
end