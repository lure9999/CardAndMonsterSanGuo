require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/EliteDungeonData"
require "Script/serverDB/server_mainDB"

module("DungeonLogic", package.seeall)

local GetPointIdBySceneIdx 			= DungeonBaseData.GetPointIdBySceneIdx
local GetPointType					= DungeonBaseData.GetPointType

local GetMapDataBySceneId  			= server_fubenDB.GetMapDataBySceneId
local GetPointLeftTimes				= server_fubenDB.GetPointLeftTimes
local GetMainDataByKey				= server_mainDB.getMainData

local GetSceneIndex					= DungeonBaseData.GetSceneIndex
local GetSceneId 					= DungeonBaseData.GetSceneId
local GetPointId 					= DungeonBaseData.GetPointId
local GetPointRuleId 				= DungeonBaseData.GetPointRuleId
local GetSceneType					= DungeonBaseData.GetSceneType
local GetTimes						= DungeonBaseData.GetTimes
local GetNeedTiLi					= DungeonBaseData.GetNeedTiLi
local GetNeedLv						= DungeonBaseData.GetNeedLv
local GetNeedFamilyLv				= DungeonBaseData.GetNeedFamilyLv
local GetOpenWeekDay				= DungeonBaseData.GetOpenWeekDay
local GetSweep						= DungeonBaseData.GetSweep
local GetAutomatic					= DungeonBaseData.GetAutomatic
local GetSkip						= DungeonBaseData.GetSkip
local GetOnly						= DungeonBaseData.GetOnly
local GetPremiseId					= DungeonBaseData.GetPremiseID
local GetPointPos					= DungeonBaseData.GetPointPos
local GetMapCount					= DungeonBaseData.GetMapCount
local GetPointCount 				= DungeonBaseData.GetPointCount
local GetSceneRuleId				= DungeonBaseData.GetSceneRuleId
local GetActivityTimes				= DungeonBaseData.GetActivityTimes

local GetEliteTimes					= EliteDungeonData.GetEliteTimes

local CheckBConsumeByID				= ConsumeLogic.CheckBConsumeByID
ErrorCode =
{
	Success				= 0,
	NotEnoughLv 		= 1,
	NotEnoughTiLi 		= 2,
	NotEnoughTimes 		= 3,
	NotEnoughFamilyLv 	= 4,
	WrongWeekDay		= 5,
	PremiseError		= 6,
	CoolDown			= 7
}

MopupState =
{
	OK 					= 0,
	NotEnoughTiLi		= 1,
	Not3Stars			= 2,
}

local OpenType =
			{
				AllOpen 	= 127,
				SingleOpen  = 85,
				DoubleOpen  = 106,
			}

function MakePointPos( nSceneIdx, nPointIdx )
	local strPointPos = GetPointPos(nSceneIdx, nPointIdx)
	local nSplit = string.find(strPointPos, "|")
	local nPosX = tonumber(string.sub(strPointPos, 0, nSplit-1))
	local nPosY = tonumber(string.sub(strPointPos, nSplit+1, -1))
	return ccp(nPosX, nPosY)
end

function GetSceneIdxById( nTargetSceneId )
	local nSceneIdx = 0
	for key, value in pairs(scence.getTable()) do
		local nBeginIdx, nEndIdx = string.find(key, "_")
		local nIdx = tonumber(string.sub(key, nEndIdx+1))
		local nSceneId = GetSceneId(nIdx)
		if nSceneId==nTargetSceneId then
			nSceneIdx = nIdx
			break
		end
	end
	return nSceneIdx
end

function GetSceneCount( nSceneType )
	local nCount = 0
	for key, value in pairs(scence.getTable()) do
		local nBeginIdx, nEndIdx = string.find(key, "_")
		local nSceneIdx = tonumber(string.sub(key, nEndIdx+1))
		if GetSceneType(nSceneIdx)==nSceneType then
			nCount = nCount+1
		end
	end
	return nCount
end

function IsEnoughLv( nLv )
	if server_mainDB.getMainData("level")>=nLv then
		return true
	else
		return false
	end
end

-- 获取普通关卡的的最新地图索引和关卡索引
function GetLastSceneIdxAndPointIdx(nSceneType)
	local nTargetKey = 1
	local nPointIdx = 0
	local tabData = server_fubenDB.GetCopyTableByType(nSceneType)
	for key, value in pairs(tabData) do
		for Idx, Point in pairs(value["Point"]) do
			if tonumber(Point["PointInfo"]["Stars"])>=0 then
				nTargetKey = key
				nPointIdx = Idx
			end
		end
	end
	local nSceneId = server_fubenDB.GetSceneIdByKey(nSceneType, nTargetKey)
	local nSceneIdx = GetSceneIdxById(nSceneId)
	local nPointCount = GetPointCount(nSceneIdx)
	local nSceneRuleId = GetSceneRuleId(nSceneIdx)
	if nTargetKey < table.getn(tabData) then
		--判断下一章节是否通关
		if nPointIdx==nPointCount then
			local pTempSceneIndex = nSceneIdx + 1
			nSceneRuleId = GetSceneRuleId(pTempSceneIndex)
			if IsEnoughLv(GetNeedLv(nSceneRuleId)) == true then
				nSceneIdx = nSceneIdx + 1
				nPointIdx = 1
			else
				--判断是不是第一章，如果是则不加1，如果不是则+1
				if nSceneIdx > 1 then
					nSceneIdx = nSceneIdx + 1
				end
			end
		else
			nPointIdx = nPointIdx + 1
		end
	else
		if nPointIdx<nPointCount then
			nPointIdx = nPointIdx + 1
		end
	end
	return nSceneIdx, nPointIdx
end
-- 获取普通关卡的的最后已通关地图索引和关卡索引
function GetLastSceneIdxAndPointIdxByElite(nSceneType)
	local nTargetKey = 1
	local nPointIdx = 0
	local tabData = server_fubenDB.GetCopyTableByType(nSceneType)
	for key, value in pairs(tabData) do
		for Idx, Point in pairs(value["Point"]) do
			if tonumber(Point["PointInfo"]["Stars"])>=0 then
				nTargetKey = key
				nPointIdx = Idx
			end
		end
	end
	local nSceneId = server_fubenDB.GetSceneIdByKey(nSceneType, nTargetKey)
	local nSceneIdx = GetSceneIdxById(nSceneId)
	local nPointCount = GetPointCount(nSceneIdx)

	return nSceneIdx, nPointIdx
end

function GetSceneIdxAndPointIdxByPointId( nTargetPointId )
	for key, value in pairs(scence.getTable()) do
		local nBeginIdx, nEndIdx = string.find(key, "_")
		local nSceneIdx = tonumber(string.sub(key, nEndIdx+1))
		for i=1, 15 do
			local nPointId = GetPointId(nSceneIdx, i)
			if nPointId == nTargetPointId then
				local nSceneId = GetSceneId(nSceneIdx)
				
				local nSceneType = GetSceneType(nSceneIdx)
				-- print("SceneId = "..nSceneId.."\tpointIdx = "..i.."\tpointId = ".. nPointId)
				return nSceneIdx, nSceneId, i, nSceneType
			end
		end
	end
	return 0, 0, 0, 0
end

function GetPointImageByType( nPointType )
	if nPointType~=PointType.Small then
		return "Image/imgres/dungeon/point_big.png"
	else
		return "Image/imgres/dungeon/point_small.png"
	end
end

local function IsRightWeekDay( nWeek )
	local  nCurWday = tonumber(UnitTime.GetCurWday())
	-- 0代表星期天
	if nCurWday==0 then
		nCurWday=7
	end
	local nResult = CheckOpenWeekDay(nWeek, nCurWday)
	if nResult==1 then
		return true
	else
		return false
	end
end

function IsEnoughTiLi( nTiLi )
	if GetMainDataByKey("tili")>=nTiLi then
		return true
	else
		return false
	end
end

-- add by sxin 这里传过来的是消耗id 以后不关心消耗的内容通用消耗的接口 等判断消耗接口写好了再改都返回true
function IsEnoughConsumeID( nConsumeID )
	--print("nConsumeID =" .. nConsumeID)
	--Pause()
	if nConsumeID > 0 then
		return CheckBConsumeByID(nConsumeID)
	end
	return true
end

function IsEnoughTimes( nTimes, nSceneId, nLocalIdx )
	-- 小于零不限制次数
	if nTimes<0 then
		return true
	else
		local nLeftTimes = 0
		local nSceneIdx = GetSceneIdxById(nSceneId)
		if GetSceneType(nSceneIdx)==1 then
			nLeftTimes = nTimes - GetPointLeftTimes(GetSceneType(nSceneIdx), nSceneId, nLocalIdx)
		elseif GetSceneType(nSceneIdx)==2 then
			nLeftTimes = GetEliteTimes() - server_fubenDB.GetEliteFightedTimes()
		elseif GetSceneType(nSceneIdx)==3 then
			nLeftTimes = nTimes - GetPointLeftTimes(GetSceneType(nSceneIdx), nSceneId, nLocalIdx)
		end
		if nLeftTimes<1 then
			return false
		else
			return true
		end
	end
end

function CheckCD( nSceneIdx, nSceneId, nLocalIdx )
	local nCurTime = UnitTime.GetCurTime()
	local nCDTime = server_fubenDB.GetPointCD(GetSceneType(nSceneIdx), nSceneId, nLocalIdx)
	if nCDTime == nil then
		return false
	end
	if nCurTime>nCDTime then
		return true
	else
		return false
	end
end

function CheckPremiseId( nPremiseId )
	if nPremiseId>-1 then
		local nPreSceneIdx, nPreSceneId, nPrePointIdx ,nPreSceneType = GetSceneIdxAndPointIdxByPointId(nPremiseId)
		--print("nPreSceneIdx = "..nPreSceneIdx.."\tnPreSceneId = "..nPreSceneId.."\tnPrePointIdx = "..nPrePointIdx.."\tPremiseId = "..nPremiseId)		
		local nStars = server_fubenDB.GetPointStars(nPreSceneType, nPreSceneId, nPrePointIdx)
		--print("nStars = "..nStars)		
		--Pause()
		
		if nStars>-1 then
			return true
		else
			return false
		end
	end

	return true
end

function CheckPointStateByRuleId( nRuleId )
	-- 判断前置ID
	
	--print("CheckPremiseId nRuleId =" .. nRuleId)			
	--local PremiseId = GetPremiseId(nRuleId)	
	--print("PremiseId =" .. PremiseId)	
	--Pause()
	if CheckPremiseId(GetPremiseId(nRuleId))==false then		
		return ErrorCode.PremiseError
	end

	if IsEnoughTiLi(GetNeedTiLi(nRuleId))==false then
		return ErrorCode.NotEnoughTiLi
	end

	if IsEnoughLv(GetNeedLv(nRuleId))==false then
		return ErrorCode.NotEnoughLv
	end

	local nFamilyLv = GetNeedFamilyLv(nRuleId)

	if IsRightWeekDay(GetOpenWeekDay(nRuleId)) == false then
		return ErrorCode.WrongWeekDay
	end

	return ErrorCode.Success
end

function GetOpenRuleStr( nRuleId )
	if GetOpenWeekDay(nRuleId) == OpenType.AllOpen then
		return ""
	elseif GetOpenWeekDay(nRuleId) == OpenType.SingleOpen then
		return "一、三、五、日"
	elseif GetOpenWeekDay(nRuleId) == OpenType.DoubleOpen then
		return "二、四、六、日"
	end
end

function CheckIsOpen( nRuleId )
	-- 今天是否开放
	return IsRightWeekDay(GetOpenWeekDay(nRuleId)) == false
end

function CheckPointState( nRuleId, nSceneId, nLocalIdx, nSceneType )
	local nTimes = GetTimes(nRuleId)
	if nSceneType == DungeonsType.Elite then
		nTimes = GetEliteTimes()
	elseif nSceneType == DungeonsType.Activity then
		nTimes = GetActivityTimes()
	end

	if IsEnoughTimes(nTimes, nSceneId, nLocalIdx)==false then
		return ErrorCode.NotEnoughTimes
	end

	return CheckPointStateByRuleId(nRuleId)
end

function IsCanFight( nSceneId, nSceneIdx, nLocalIdx, nSceneType )
	--print(nSceneId, nSceneIdx, nLocalIdx, nSceneType)
	--Pause()
	if CheckCD(nSceneIdx, nSceneId, nLocalIdx)==false then
		return ErrorCode.CoolDown
	end

	local nPointId = GetPointId(nSceneIdx, nLocalIdx)
	local nRuleId = GetPointRuleId(nPointId)
	if nRuleId ~=-1 then
		return CheckPointState(nRuleId, nSceneId, nLocalIdx, nSceneType)
	end
end

function SceneCanCreate( nSceneIdx,  nSceneCount )
	if nSceneIdx <= nSceneCount then
		local nSceneRuleId = GetSceneRuleId(nSceneIdx)		
		if nSceneRuleId >0 then			
			return CheckPointStateByRuleId(nSceneRuleId)			
		end
	end
	return ErrorCode.Success
end

function IsSweep( nRuleId )
	if GetSweep(nRuleId)==1 then
		return false
	else
		return true
	end
end

function ISAutomatic( nRuleId )
	if GetAutomatic(nRuelId)==1 then
		return false
	else
		return true
	end
end

function IsSkip( nRuleId )
	if GetSkip(nRuleId)==1 then
		return false
	else
		return true
	end
end

function IsOnly( nRuleId )
	if GetOnly(nRuleId)==1 then
		return true
	else
		return false
	end
end

function GetErrorCodeText( nErrorCode )
	local strError = nil
	if nErrorCode == ErrorCode.NotEnoughLv then
		local pCurSceneIndex, pCurPointIdx = GetLastSceneIdxAndPointIdx(DungeonsType.Normal)
		local nSceneId = server_fubenDB.GetSceneIdByKey(DungeonsType.Normal, pCurSceneIndex)
		local nSceneIdx = GetSceneIdxById(nSceneId) + 1
		--print("GetSceneIdxById(nSceneId) = "..GetSceneIdxById(nSceneId))
		if GetSceneIdxById(nSceneId) <= 1 then
			nSceneIdx = 2
		else
			nSceneIdx = GetSceneIdxById(nSceneId)
		end
		local nRuleId  = GetSceneRuleId(nSceneIdx)

		local nNeedLv = GetNeedLv(nRuleId)
		strError = "主将等级达到"..nNeedLv.."级开启下一章节"
	elseif nErrorCode == ErrorCode.NotEnoughTiLi then
		strError = "体力不足！"
	elseif nErrorCode == ErrorCode.NotEnoughTimes then
		strError = "次数不足！"
	elseif nErrorCode == ErrorCode.NotEnoughFamilyLv then
		strError = "家族等级不足！"
	elseif nErrorCode == ErrorCode.WrongWeekDay then
		strError = "今天不开放！"
	elseif nErrorCode == ErrorCode.PremiseError then
		strError = "前置未通关！"
	elseif nErrorCode == ErrorCode.CoolDown then
		strError = "冷却时间未到！"
	end
	return strError
end

function GetMopupStateText( nState )
	local strText = nil
	print(nState)
	if nState == MopupState.NotEnoughTiLi then
		strText = "体力不足！"
	elseif nState == MopupState.Not3Stars then
		strText = "未3星通关！"
	end
	return strText
end

function CheckMopup( nSceneIdx, nPointIdx, nTimes )
	local nStars = server_fubenDB.GetPointStars(GetSceneType(nSceneIdx), GetSceneId(nSceneIdx), nPointIdx )
	if nStars~=nil and nStars < 3 then
		return MopupState.Not3Stars
	end

	local nPointId = GetPointId(nSceneIdx, nPointIdx)
	local nRuleId = GetPointRuleId(nPointId)
	local nTiLi = GetNeedTiLi(nRuleId)
	
	
	if GetMainDataByKey("tili")<nTiLi*nTimes then
		return MopupState.NotEnoughTiLi
	end

	return MopupState.OK
end

function CheckPointIsBoss( nSceneIdx, nPointIdx )
	local nPointCount = GetPointCount(nSceneIdx)
	if nPointIdx == nPointCount then 
		return true 
	end

	return false
end

function GetOpenActivityRule(  )
	--得到开启活动关卡的等级
	local nSceneIdx = GetSceneIndex(2) 			--第一个副本
	local nSceneId = GetSceneId(nSceneIdx)
	local nSceneType = GetSceneType(nSceneIdx)
	local nSceneRuleId = GetSceneRuleId(nSceneIdx)
	local nNeedLv = GetNeedLv(nSceneRuleId)

	return nNeedLv
end

function CheckEliteOpen( bTips )
	--精英关卡开放检测
	local nSceneId = server_fubenDB.GetSceneIdByKey(DungeonsType.Elite, 1)
	local nSceneIdx = GetSceneIdxById(nSceneId)
	local nRuleId  = GetSceneRuleId(nSceneIdx)
	local nPermiseId = GetPremiseId(nRuleId) 		   --当前正在检测的关卡ID的前置条件

	local nCurNormalSceneIdx, nCurNormalPointIdx = GetLastSceneIdxAndPointIdxByElite(DungeonsType.Normal)
	local nCurPointId = GetPointId(nCurNormalSceneIdx, nCurNormalPointIdx)

	local nNeedLv = GetNeedLv(nRuleId)

	--print(nSceneId, nSceneIdx, nRuleId, nPermiseId, nCurPointId, nNeedLv)

	
	if nCurPointId ~= nil then

		if nCurPointId >= nPermiseId and server_mainDB.getMainData("level") >= nNeedLv then 
			return true

		end

	end
	local pTipSceneIndex = GetSceneIdxAndPointIdxByPointId(nPermiseId)
	if bTips == true then

		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1657,nil,nNeedLv,pTipSceneIndex)
		pTips = nil		

	end

	return false

end

function CheckEliteDunOpen( nEliteSceneIdx, nNormalSceneIdx, nLastPointIdx, nCurPointIdx )
	--检测精英关卡中的某一关是否开启
	local nLastPointId = GetPointId(nNormalSceneIdx, nLastPointIdx)  --当前普通副本最后一关的关卡ID
	local nCurPointId  = GetPointId(nEliteSceneIdx, nCurPointIdx)   --当前正在检测的关卡ID

	local nPointRuleId = GetPointRuleId(nCurPointId)
	local nCurPermiseId = GetPremiseId(nPointRuleId) 		   --当前正在检测的关卡ID的前置条件

	if nLastPointId >= nCurPermiseId then 		--前置条件ID为当前副本的最后一关ID相同

		return true

	end

	return false
end