require "Script/Common/Common"
require "Script/Main/MissionNormal/MissionNormalData"
require "Script/Main/Item/GetGoodsLayer"

module("MissionNormalLogic", package.seeall)

local GetCondRelation						=	MissionNormalData.GetCondRelation
local GetCondCountNum						=	MissionNormalData.GetCondCountNum
local GetCondRelationCount					=	MissionNormalData.GetCondRelationCount
local GetCondType							=	MissionNormalData.GetCondType
local GetCondSubClass						=	MissionNormalData.GetCondSubClass
local GetCondIdxByCondID					=	MissionNormalData.GetCondIdxByCondID
local GetMissionTab							=	MissionNormalData.GetMissionTab
local GetMainLineTab						=	MissionNormalData.GetMainLineTab

local OperMode = {
	Equal 				= 0,
	LessThanAndEqual 	= 1,
	MoreThanAndEqual 	= 2,
	LessThan 			= 3,
	MoreThan 			= 4,
	Advance 			= 5,
}

local MISSION_ADD_NUM 	 	 	= 10
local MISSION_ADD_NUM_INSERT 	= 10
local COUNT_NOW_ADD		 	 	= 0
local COUNT_NOW_BEGIN 	 	 	= 1
local COUNT_NOW_ADD_MAINLINE 	= 0
local COUNT_NOW_BEGIN_MAINLINE	= 1

function GetScoreStage( nLevel )
	if tonumber(nLevel) >= 1 and tonumber(nLevel) <= 30 then
		return 1
	elseif tonumber(nLevel) > 30 and tonumber(nLevel) <= 80 then
		return 2
	elseif tonumber(nLevel) > 80 and tonumber(nLevel) <= 100 then
		return 3
	else 
		return nil 
	end

	return nil
end

function SortMissionByState( pData, SortWay)
	local function sortAscStatus( a,b )
		if SortWay == false then
			return a:getTag() < b:getTag()
		else
			return a:getTag() > b:getTag()
		end
	end
	table.sort(pData,sortAscStatus)
end

function SortMissionByState_2( pData, SortWay)
	--先按状态排序，再按ID排序
	local function sortAscTaskID( a, b )
		local result
		local a_State = tonumber(a["TaskState"])
		local b_State = tonumber(b["TaskState"])
		local a_TID   = tonumber(a["TaskID"])
		local b_TID   = tonumber(b["TaskID"])
		if SortWay == false then
			if a_State == b_State then

				result = a_TID < b_TID

			else			

				result = a_State < b_State

			end

			return result
		else
			if a_State == b_State then

				result = a_TID > b_TID

			else			

				result = a_State > b_State

			end

			return result
		end		
	end

	table.sort(pData,sortAscTaskID)
end

--判断条件(参数 = 序列奖励的规则ID)
function JudgeCondtion( nRewCondID )

end

function ShowGoodsLayer( nTab1, nTab2, nCallBack )
	GetGoodsLayer.createGetGoods(nTab1, nTab2, nCallBack)
end

function DelGoodLayer(  )
	GetGoodsLayer.DeleteForGuide()
end

local function CheckAction( nCount )
	if nCount <= MISSION_ADD_NUM then return true end
	return false
end

local function CheckAddListOver( nTableData)
	if #nTableData > COUNT_NOW_BEGIN then return false end
	return true
end

local function CheckAddListOverMainLine( nTableData)
	if #nTableData > COUNT_NOW_BEGIN_MAINLINE then return false end
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

function RunGetListAction(pAction, nLoadlItemCallBack, tableData)
	pAction:stopAllActions()
	COUNT_NOW_ADD = 0
	if CheckAction(#tableData) == true then
		--如果数量较小直接加载
		if nLoadlItemCallBack~=nil then	
			--到界面里面去加载
			nLoadlItemCallBack(COUNT_NOW_BEGIN,#tableData, true)
			--print("直接完成啦！")
		end
	else
		nLoadlItemCallBack(COUNT_NOW_BEGIN,MISSION_ADD_NUM)
		COUNT_NOW_ADD = MISSION_ADD_NUM
		local function listCheckCallBack()
			--print("添加日常任务中")
			pAction:stopAllActions()
			if CheckAddListOver(tableData) == false then
				if (COUNT_NOW_ADD + MISSION_ADD_NUM_INSERT) > #tableData then
					--pAction:stopAllActions()
					nLoadlItemCallBack(COUNT_NOW_ADD + 1,COUNT_NOW_ADD + (#tableData - COUNT_NOW_ADD), true)
					--print("完成啦！")
				else
					nLoadlItemCallBack(COUNT_NOW_ADD + 1,(MISSION_ADD_NUM_INSERT + COUNT_NOW_ADD))
					COUNT_NOW_ADD = COUNT_NOW_ADD + MISSION_ADD_NUM_INSERT
					pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
				end
			end
		end
		pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
	end
end

function RunGetListActionMainLine(pAction, nLoadlItemCallBack, tableData)
	pAction:stopAllActions()
	COUNT_NOW_ADD_MAINLINE = 0
	if CheckAction(#tableData) == true then
		--如果数量较小直接加载
		if nLoadlItemCallBack~=nil then	
			--到界面里面去加载
			nLoadlItemCallBack(COUNT_NOW_BEGIN_MAINLINE,#tableData, true)
		end
	else
		nLoadlItemCallBack(COUNT_NOW_BEGIN_MAINLINE,MISSION_ADD_NUM)
		COUNT_NOW_ADD_MAINLINE = MISSION_ADD_NUM
		local function listCheckCallBack()
			--print("添加主线任务中")
			pAction:stopAllActions()
			if CheckAddListOverMainLine(tableData) == false then
				if (COUNT_NOW_ADD_MAINLINE + MISSION_ADD_NUM_INSERT) > #tableData then
					--pAction:stopAllActions()
					nLoadlItemCallBack(COUNT_NOW_ADD_MAINLINE + 1,COUNT_NOW_ADD_MAINLINE + (#tableData - COUNT_NOW_ADD_MAINLINE), true)
				else
					nLoadlItemCallBack(COUNT_NOW_ADD_MAINLINE + 1,(MISSION_ADD_NUM_INSERT + COUNT_NOW_ADD_MAINLINE))
					COUNT_NOW_ADD_MAINLINE = COUNT_NOW_ADD_MAINLINE + MISSION_ADD_NUM_INSERT
					pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
				end
			end
		end
		pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
	end
end

local function ClearListView( nList )
	if nList:getItems():count()~=0 then
		nList:removeAllItems()
	end
end

--检查任务数量 如果小于 < 5 则直接加载 如果大于>5 则分页加载
function UpdateListItem( nData, nLoadlItemCallBack, nList, nType)
	ClearListView(nList)				--清除列表
	if nType == 0 then
		RunGetListActionMainLine(nList, nLoadlItemCallBack, nData)
	else
		RunGetListAction(nList, nLoadlItemCallBack, nData)
	end
end

function GetRewardIDByTaskID( pTaskID )
	local pDB = GetMissionTab()

	if pDB == nil then

		return 1 

	end

	local pNormalMissionDB = pDB["Mission"]

	for key,value in pairs( pNormalMissionDB ) do

		if tonumber( value["TaskID"] ) == tonumber( pTaskID ) then

			return value["RewardID"]

		end

	end

	return 1

end

function GetRewardIDByTaskIDByMainLine( pTaskID )
	local pDB = GetMainLineTab()


    for key,value in pairs(pDB) do
		if tonumber( value["TaskID"] ) == tonumber( pTaskID ) then

			return value["RewardID"]

		end
    end

    return 1

end