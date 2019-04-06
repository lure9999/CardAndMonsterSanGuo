require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/serverDB/scence"
require "Script/serverDB/resimg"
require "Script/Main/Pata/PataData"

module("PataLogic", package.seeall)

local GetItemPathByTempID 					= ItemData.GetItemPathByTempID
local GetItemColorPathByTempID   			= ItemData.GetItemColorPathByTempID
local GetPataMopUpTime						= PataData.GetPataMopUpTime

MAX_MONSTER_COUNT = 5
--ClIMBING_TOWER_TIME = 20

function PlayRoleAnimation( pPayArmature , iResID , strAniName)
	if pPayArmature ~= nil then
		pPayArmature:getAnimation():play(GetAniName_Res_ID(iResID, strAniName))	
	end 
end

function PlayRoleCallFunc( pPayArmature, func )
	pPayArmature:getAnimation():setMovementEventCallFunc(func)
end

function GetLayerData( pAllData , pIndex )

end

function JudgeSaoDangBtnShow( nBtn, nCurLayer, nMaxLayer, nResetNum, nSDFinish, nMoneyImg)
	local nState = false
	local nEndNum = 0
	--通过层数和重置次数判断
	if nSDFinish == true then
		nEndNum = nMaxLayer - 1
	else
		nEndNum = nMaxLayer
	end
	if nCurLayer > nEndNum  or nResetNum < 0 then
		nState = false
	else
		nState = true
	end
	--print(nCurLayer,nEndNum,nResetNum,nSDFinish)
	--print(nState)
	--Pause()
	nBtn:setVisible(nState)
	nBtn:setEnabled(nState)
	nBtn:setTouchEnabled(nState)
	if nMoneyImg ~= nil then
		nMoneyImg:setVisible(nState)
	end
end

local function GetSceneIdxById( nTargetSceneId )
	local nSceneIdx = 0
	for key, value in pairs(scence.getTable()) do
		local nBeginIdx, nEndIdx = string.find(key, "_")
		local nIdx = tonumber(string.sub(key, nEndIdx+1))
		local nSceneId = scence.getFieldByIdAndIndex(nIdx,"ID")
		if tonumber(nSceneId) == nTargetSceneId then
			nSceneIdx = nIdx
			break
		end
	end
	return nSceneIdx
end

function GetPointIdxBySceneId( nSceneID ,m_PointIdx)
	local nSceneIdx = GetSceneIdxById(nSceneID)
	local nPointId = PataData.GetPointIdByIdx(nSceneIdx,m_PointIdx)
	return nPointId
end

function GetMonsterId( nPointId,nMonIdx )
	local nMonsterShowId = PataData.GetMonsterIDByPointPos(nPointId,nMonIdx)
	return tonumber(PataData.GetMonsterIdBynSceneId(nPointId , nMonsterShowId))
end

function GetMonsterList( nPointId )
	local tabMonsterData = {}
	for i=1, MAX_MONSTER_COUNT do
		local nMonsterId = GetMonsterId(nPointId, i)
		if nMonsterId == nil then return end
		if nMonsterId>0 then
			local tabTemp = {}
			tabTemp.MonsterId = nMonsterId
			tabTemp.MonsterType = PataData.GetMonsterType(nMonsterId)
			tabTemp.HeadIcon = PataData.GetMonsterIcon(nMonsterId)
			tabTemp.Military = PataData.GetMonsterMilitary(nMonsterId)
			tabTemp.ColorIcon = PataData.GetMonsterColorIcon(nMonsterId)
			--table.insert(tabMonsterData, tabTemp)
			tabMonsterData[i] = tabTemp
		end
	end
	local function sortByType( Monster1, Monster2 )
		return Monster1.MonsterType > Monster2.MonsterType
	end
	table.sort( tabMonsterData, sortByType )
	return tabMonsterData
end

function GetRewardItemData( nRewardItemId )
	local tabRewardItemData = {}
	tabRewardItemData.IconPath = GetItemPathByTempID(nRewardItemId)
	tabRewardItemData.ItemColor = GetItemColorPathByTempID(nRewardItemId)
	return tabRewardItemData
end

function GetCurItemData( nCurLayer )
	local nPointId = GetPointIdxBySceneId(PataData.GetSceneID(nCurLayer) ,PataData.GetPointIdx(nCurLayer))
	return PataData.GetRewardList(nPointId)
end

function CountCurMonsterRes( nCurLayer )
	local nPointId = GetPointIdxBySceneId(PataData.GetSceneID(nCurLayer) ,PataData.GetPointIdx(nCurLayer))
	local tabMonster = GetMonsterList(nPointId)
	for key,value in pairs(tabMonster) do
		if value.MonsterType == MonsterType.Genereal then
			return PataData.GetMonsterResId(value.MonsterId)
		else
			if key == table.getn(tabMonster) then
				return PataData.GetMonsterResId(value.MonsterId)
			end	
		end 	
	end
	return nil
end

function GetMonsterID( nCurLayer )
	local nPointId = GetPointIdxBySceneId(PataData.GetSceneID(nCurLayer) ,PataData.GetPointIdx(nCurLayer))
	local tabMonster = GetMonsterList(nPointId)
	for key,value in pairs(tabMonster) do
		if value.MonsterType == MonsterType.Genereal then
			return value.MonsterId
		else
			if key == table.getn(tabMonster) then
				return value.MonsterId
			end
		end 
	end

	return nil
end

function CountLayerNum( nBeginTime, nCurTime, nEndTime,nInitLayer ,nState )
	local nTimeDiff 
	if nState == true then
		nTimeDiff = math.floor(( nCurTime - nBeginTime ) / GetPataMopUpTime())
	else
		nTimeDiff = math.floor(( nEndTime - nBeginTime ) / GetPataMopUpTime())
	end
	local nCurLayer = nInitLayer + nTimeDiff
	return nCurLayer
end
--判断当前是否可播放下层动画
function JudgePlayNextLevel( nBeginTime ,nCurTime, nEndTime)
	--求出当前层还剩多少秒
	if nCurTime < nEndTime then
		--print("nCurTime "..nCurTime)
		--print("nBeginTime "..nBeginTime)
		local nDiff = GetPataMopUpTime() - ( nCurTime - nBeginTime ) % GetPataMopUpTime()
		if nDiff <= 1 then
			return true,nDiff
		else
			return false,nDiff
		end
	end
end

function GetTimeThisLayer( nBeginTime ,nCurTime, nEndTime )
	if nCurTime < nEndTime then
		local nDiff = GetPataMopUpTime() - ( nCurTime - nBeginTime ) % GetPataMopUpTime()
		return nDiff
	end
end

function GetRewardCoinData( nPointId )
	local tab = PataData.GetRewardTabByPointID(nPointId)
	return tab[1]
end

function GetConsumeMoneyMax( nCurLayer, nMaxLayer )
	if (nMaxLayer - nCurLayer) * PataData.GetConsumeNum() > 0 then
		return (nMaxLayer - nCurLayer) * PataData.GetConsumeNum()
	else
		return 0
	end
end

function MopEndJudge( nCurLayer, nMaxLayer )
	local nConsumMoney = (nMaxLayer - 1 - nCurLayer) * PataData.GetConsumeNum()
	local nConsumeTab = PataData.GetConsumeData()
	if nConsumMoney > nConsumeTab.ItemNum then
		return false
	else
		return true
	end
end

function PauseCondJudgment_1( nPauseTime, nBeginTime, nEndTime )
	--条件1 ：PauseTime >= pataTime
	if nPauseTime >= nEndTime - nBeginTime then
		print("暂停时间 > 爬塔总时间")
		return true
	end

	return false
end

function PauseCondJudgment_2( nPauseTime, nCurTime, nEndTime )
	--条件2 ：PauseTime >= pataTime
	if nPauseTime + nCurTime >= nEndTime then
		print("暂停时间+已爬塔时间 > 爬塔总时间")
		return true
	end

	return false 
end

function PauseCondJudgment_3( nPauseTime )
	--条件3 ：PauseTime < layerTime
	if nPauseTime < 20 then 
		print("暂停时间小于一层时间")
		return true
	end

	return false 
end

function PauseCondJudgment_4( nPauseTime )
	--条件4 ：PauseTime > layerTime
	if nPauseTime >= 20 then
		print("暂停时间大于一层时间")
		return true
	end

	return false
end

function IsEnoughConsumeID( nConsumeID )
	if nConsumeID > 0 then
		return CheckBConsumeByID(nConsumeID)
	end
	return true
end

function GetItemIconByResId( nResId )
	if nResId>-1 then
		return resimg.getFieldByIdAndIndex(nResId, "icon_path")
	else
		return nil
	end
end

function GetConsumeItemIconByType( nConsumeType )
	local nResId = tonumber(coin.getFieldByIdAndIndex(nConsumeType, "ResID"))
	return GetItemIconByResId( nResId )
end