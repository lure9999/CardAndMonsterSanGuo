module("server_fubenDB", package.seeall)

local m_tableFubenDB = {}
local m_tableEliteFubenDB = {}
local m_tableActivity = {}
local m_tableClimbingTower = {}
local m_UIData = {}

local m_nFightedTimes = nil

local Server_Cmd = {
    SceneID 	= 1,
    Point 		= 2,
}

local Activity_Cmd = {
	SceneID 	= 1,
	Times 		= 2,
	Point 		= 3,
}

local Point_Cmd =
{
	PointIdx 	= 1,
	PointInfo 	= 2,
}

local PointInfo_Cmd =
{
	Stars	= 1,
	CD 		= 2,
	Times	= 3,
	SurPlusTimes = 4,
}

local function InsertDataToTable( tabData, pList )
	for key, value in pairs(pList) do
    	tabData[key] = {}
    	tabData[key]["SceneID"] = value[Server_Cmd.SceneID]
    	tabData[key]["Point"] = {}
    	for Idx, Info in pairs(value[Server_Cmd.Point]) do
    		local tabPoint = {}
    		tabPoint["PointIdx"] = Idx
    		tabPoint["PointInfo"] = {}
    		tabPoint["PointInfo"]["Stars"]=Info[PointInfo_Cmd.Stars]
    		tabPoint["PointInfo"]["CD"]=Info[PointInfo_Cmd.CD]
    		tabPoint["PointInfo"]["Times"]=Info[PointInfo_Cmd.Times]
    		tabPoint["PointInfo"]["SurPlusTimes"]=Info[PointInfo_Cmd.SurPlusTimes]
    		table.insert(tabData[key]["Point"], tabPoint)
    	end
    end
end

local function InsertActivityDataToTable( tabData, pList )
	for key, value in pairs(pList) do
    	tabData[key] = {}
    	tabData[key]["SceneID"] = value[Activity_Cmd.SceneID]
    	tabData[key]["Times"] = value[Activity_Cmd.Times]
    	tabData[key]["Point"] = {}
    	for Idx, Info in pairs(value[Activity_Cmd.Point]) do
    		local tabPoint = {}
    		tabPoint["PointIdx"] = Idx
    		tabPoint["PointInfo"] = {}
    		tabPoint["PointInfo"]["Stars"]=Info[PointInfo_Cmd.Stars]
    		tabPoint["PointInfo"]["CD"]=Info[PointInfo_Cmd.CD]
    		tabPoint["PointInfo"]["Times"]=Info[PointInfo_Cmd.Times]
    		table.insert(tabData[key]["Point"], tabPoint)
    	end
    end
end

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(pBuffer)
    local pNetStream = NetStream()
    pNetStream:SetPacket(pBuffer)
    local status = pNetStream:Read()
    local nSceneType = pNetStream:Read()
    if nSceneType==DungeonsType.Normal then
    	m_tableFubenDB = {}
    	local pList = pNetStream:Read()
     	InsertDataToTable(m_tableFubenDB, pList)
    elseif nSceneType==DungeonsType.Elite then
    	-- Log(pBuffer)
    	m_tableEliteFubenDB = {}
    	m_nFightedTimes = pNetStream:Read()
    	local pList = pNetStream:Read()
    	InsertDataToTable(m_tableEliteFubenDB, pList)
    elseif nSceneType==DungeonsType.Activity then
    	m_tableActivity = {}
    	local pList = pNetStream:Read()
    	InsertActivityDataToTable(m_tableActivity, pList)
    elseif nSceneType==DungeonsType.ClimbingTower then
    	m_tableClimbingTower = {}
    	m_tableClimbingTower["MaxLayer"] = pNetStream:Read()
    	m_tableClimbingTower["CurrentLayer"] = pNetStream:Read()
    	m_tableClimbingTower["SaoDangCurTime"] = pNetStream:Read()
    	m_tableClimbingTower["SaoDangBeginTime"] = pNetStream:Read()
    	m_tableClimbingTower["SaoDangEndTime"] = pNetStream:Read()
    	m_tableClimbingTower["FreeReset"] = pNetStream:Read()
    	m_tableClimbingTower["LastRefresh"] = pNetStream:Read()
    	local pList = pNetStream:Read()
    	InsertDataToTable(m_tableClimbingTower, pList)
    end
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTableByType(nSceneType)
	if nSceneType==DungeonsType.Normal then
		return copyTab(m_tableFubenDB)
	elseif nSceneType==DungeonsType.Elite then
		return copyTab(m_tableEliteFubenDB)
	elseif nSceneType==DungeonsType.Activity then
		return copyTab(m_tableActivity)
	elseif nSceneType==DungeonsType.ClimbingTower then
		return copyTab(m_tableClimbingTower)
	end
end

function GetPataSurPlusTimes(  )
	if m_tableClimbingTower["FreeReset"] ~= nil then
		return m_tableClimbingTower["FreeReset"]
	end
end

function GetStarsFromTableData( tabData, nSceneID, nLocalIdx )
	if table.getn(tabData)==0 then
		return
	end
	-- print("nSceneID = "..nSceneID.."\tnLocalIdx = "..nLocalIdx)
	for key, value in pairs(tabData) do
		if tonumber(nSceneID) == tonumber(value["SceneID"]) then
			for Idx, Point in pairs(value["Point"]) do
				if tonumber(nLocalIdx)==tonumber(Point["PointIdx"]) then
					return tonumber(Point["PointInfo"]["Stars"])
				end
			end
		end
	end
	return -1
end

-- 获取关卡星级
function GetPointStars(nSceneType, nSceneID, nLocalIdx)
	--print("nSceneType = "..nSceneType.."\tnSceneID = "..nSceneID.."\tnLocalIdx = "..nLocalIdx)
	if nSceneType==DungeonsType.Normal then
		return GetStarsFromTableData(m_tableFubenDB, nSceneID, nLocalIdx)
	elseif nSceneType==DungeonsType.Elite then
		return GetStarsFromTableData(m_tableEliteFubenDB, nSceneID, nLocalIdx)
	elseif nSceneType==DungeonsType.Activity then
		return GetStarsFromTableData(m_tableActivity, nSceneID, nLocalIdx)
	elseif nSceneType== DungeonsType.ClimbingTower then
		return GetStarsFromTableData(m_tableClimbingTower,nSceneID,nLocalIdx)
	end
end

function GetCDFromTableData( tabData, nSceneID, nLocalIdx )
	if #tabData==0 then
		return
	end
	for key, value in pairs(tabData) do
		if tonumber(nSceneID) == tonumber(value["SceneID"]) then
			for Idx, Point in pairs(value["Point"]) do
				if tonumber(nLocalIdx)==tonumber(Point["PointIdx"]) then
					-- print("idx = "..nLocalIdx.."   cd = "..Point["PointInfo"]["CD"])
					return tonumber(Point["PointInfo"]["CD"])
				end
			end
		end
	end
	return -1
end

-- 获取关卡CD
function GetPointCD(nSceneType, nSceneID, nLocalIdx)
	if nSceneType==DungeonsType.Normal then
		return GetCDFromTableData(m_tableFubenDB, nSceneID, nLocalIdx)
	elseif nSceneType==DungeonsType.Elite then
		return GetCDFromTableData(m_tableEliteFubenDB, nSceneID, nLocalIdx)
	elseif nSceneType==DungeonsType.Activity then
		return GetCDFromTableData(m_tableActivity, nSceneID, nLocalIdx)
	end
end

function GetLeftTimesFromTableData( tabData, nSceneType, nSceneID, nLocalIdx )
	if #tabData==0 then
		return
	end
	for key, value in pairs(tabData) do
		if tonumber(nSceneID) == tonumber(value["SceneID"]) then
			if nSceneType==DungeonsType.Activity then
				return tonumber(value["Times"])
			else
			-- printTab(value)
				for Idx, Point in pairs(value["Point"]) do
					if tonumber(nLocalIdx)==tonumber(Point["PointIdx"]) then
						-- print("idx = "..nLocalIdx.."   cd = "..Point["PointInfo"]["CD"])
						return tonumber(Point["PointInfo"]["Times"])
					end
				end
			end
		end
	end
	return -1
end

function SetLeftTimesFromTableData( tabData, nSceneType, nSceneID, nLocalIdx, Leftimes )
	if #tabData==0 then
		return
	end
	for key, value in pairs(tabData) do
		if tonumber(nSceneID) == tonumber(value["SceneID"]) then
			if nSceneType==DungeonsType.Activity then
				return tonumber(value["Times"])
			else
			-- printTab(value)
				for Idx, Point in pairs(value["Point"]) do
					if tonumber(nLocalIdx)==tonumber(Point["PointIdx"]) then
						-- print("idx = "..nLocalIdx.."   cd = "..Point["PointInfo"]["CD"])
						Point["PointInfo"]["Times"] = Leftimes
					end
				end
			end
		end
	end
	return -1
end

--获取普通副本根据当前VIP等级可购买的剩余次数
function GetNormalFubenCanBuySurPlusTimes( nSceneID, nLocalIdx )
	if #m_tableFubenDB==0 then
		return
	end

	for key, value in pairs( m_tableFubenDB ) do
		if tonumber(nSceneID) == tonumber(value["SceneID"]) then
			for Idx, Point in pairs(value["Point"]) do
				if tonumber(nLocalIdx)==tonumber(Point["PointIdx"]) then
					return tonumber(Point["PointInfo"]["SurPlusTimes"])
				end
			end
		end
	end

	return -1
end

--更新当前关卡的数据
function UpdateNormalPointData( nSceneID, nLocalIdx, nStars, nCD, nTimes, nSurplusTimes )
	if #m_tableFubenDB==0 then
		return
	end

	for key, value in pairs( m_tableFubenDB ) do
		if tonumber(nSceneID) == tonumber(value["SceneID"]) then
			for Idx, Point in pairs(value["Point"]) do
				if tonumber(nLocalIdx)==tonumber(Point["PointIdx"]) then
					Point["PointInfo"]["Stars"] 		= nStars
					Point["PointInfo"]["CD"] 			= nCD
					Point["PointInfo"]["Times"] 		= nTimes
					Point["PointInfo"]["SurPlusTimes"]  = nSurplusTimes
				end
			end
		end
	end
end

-- 获取关卡剩余次数
function GetPointLeftTimes(nSceneType, nSceneID, nLocalIdx)
	if nSceneType==DungeonsType.Normal then
		return GetLeftTimesFromTableData(m_tableFubenDB, DungeonsType.Normal, nSceneID, nLocalIdx)
	elseif nSceneType==DungeonsType.Elite then
		return GetLeftTimesFromTableData(m_tableEliteFubenDB, DungeonsType.Elite, nSceneID, nLocalIdx)
	elseif nSceneType==DungeonsType.Activity then
		return GetLeftTimesFromTableData(m_tableActivity, DungeonsType.Activity, nSceneID, nLocalIdx)
	end
end

--设置关卡剩余次数
function SetPointLeftTimes(nSceneType, nSceneID, nLocalIdx, nLeftTimes )
	if nSceneType==DungeonsType.Normal then
		return SetLeftTimesFromTableData(m_tableFubenDB, DungeonsType.Normal, nSceneID, nLocalIdx, nLeftTimes )
	elseif nSceneType==DungeonsType.Elite then
		return SetLeftTimesFromTableData(m_tableEliteFubenDB, DungeonsType.Elite, nSceneID, nLocalIdx)
	elseif nSceneType==DungeonsType.Activity then
		return SetLeftTimesFromTableData(m_tableActivity, DungeonsType.Activity, nSceneID, nLocalIdx)
	end
end

function GetEliteFightedTimes()
	return m_nFightedTimes
end

function SetEliteFightedTimes( nTimes )
	if nTimes ~= nil then

		m_nFightedTimes = nTimes

	end
end

local function GetSceneIdFromTableData( tabData, nKey )
	if table.getn(tabData)==0 then
		return
	end
	return tabData[nKey]["SceneID"]
end

function GetSceneIdByKey( nSceneType, nKey )
	if nSceneType==DungeonsType.Normal then
		return GetSceneIdFromTableData(m_tableFubenDB, nKey)
	elseif nSceneType==DungeonsType.Elite then
		return GetSceneIdFromTableData(m_tableEliteFubenDB, nKey)
	elseif nSceneType==DungeonsType.Activity then

	end
end

function GetActivityIdxBySceneId( nSceneID )
	
	for key, value in pairs(m_tableActivity) do
		if nSceneID==value["SceneID"] then
			for Idx, Point in pairs(value["Point"]) do
				--if tonumber(Point["PointInfo"]["Stars"])>-1 then
					return Idx
				--end
			end
		end
	end
	return 0		
end
