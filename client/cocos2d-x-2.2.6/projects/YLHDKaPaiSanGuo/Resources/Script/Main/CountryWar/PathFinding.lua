module("PathFinding", package.seeall)

require "Script/Main/CountryWar/City"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"

local CountDistanceByPoint			=	CountryWarLogic.CountDistanceByPoint
local JudgeCityMistyState			=	CountryWarLogic.JudgeCityMistyState

local GetCityCountry 				=	CountryWarData.GetCityCountry
local GetPlayerCountry 				=	CountryWarData.GetPlayerCountry
local GetCityCenterByState2			=	CountryWarData.GetCityCenterByState2			--城市是否是中心城市被锁定
local GetCityLockByState2			=	CountryWarData.GetCityLockByState2 	 			--城市是否被锁定

local m_OpenList 	= {}
local m_CloseList 	= {}
local m_StartIndex	= nil
local m_EndIndex	= nil
local m_Consume		= nil
local m_IsBloodOrDefense = nil
local m_FailedByMisty = nil
local m_Tab			= {}

local function InitVars()
	m_OpenList 		= {}
	m_CloseList 	= {}
	m_StartIndex	= nil
	m_EndIndex		= nil
	m_Consume		= nil
	m_IsBloodOrDefense = nil
	m_FailedByMisty = nil
	m_Tab			= {}
end


local function GetCityState( nIndex )
	-- 判断城市是否可行走
	--if nIndex == 53 then
	--	return false
	--else
		return true
	--end
end

--计算消耗
local function GetFGH( nParentCity, nAroundCity)
	nAroundCity.Parent = nParentCity
	local cons = m_Consume
	nAroundCity.G = nParentCity.G + m_Consume
	nAroundCity.H = nParentCity.H + CountDistanceByPoint(CCPoint(nParentCity.X,nParentCity.Y),CCPoint(nAroundCity.X,nAroundCity.Y))
	nAroundCity.F = nAroundCity.G + nAroundCity.H

	return nAroundCity
end

local function GetMinCityF(  )
	if table.getn(m_OpenList) < 1 then
		return nil 
	end
	local num = 1
	local cityF = m_OpenList[1]
	for i=1,table.getn(m_OpenList) do
		if cityF.F > m_OpenList[i].F then
			cityF = m_OpenList[i]
			num = i
		end
	end
	table.remove(m_OpenList, num)
	return cityF
end
--判断当前周边是否有终点城池
local function GetEndCity( nCity, nTab )
	for i=1,table.getn(nCity.CanMoveCityTab) do
		if nCity.CanMoveCityTab[i] == m_EndIndex then
			return true
		end
	end
	return false
end
--建立路线
local function BuildPath( nCity ,nTab )
	local path = {}
	local sumCons = nCity.F
	while nCity do
		if table.getn(path) == 0 then
			local endCity = City.CreateCityData(m_EndIndex,nTab)
			path[table.getn(path) + 1] = endCity.SelfIndex
		else
			path[table.getn(path) + 1] = nCity.SelfIndex
			nCity = nCity.Parent			
		end
	end
	return path,sumCons
end
--判断节点是否已经在开放列表中
local function cityInOpenList( nIndex )
	for i=1,table.getn(m_OpenList) do
		if nIndex == m_OpenList[i].SelfIndex then
			return m_OpenList[i],i
		end
	end
	return nil
end
--判断节点是否已经在关闭列表中
local function cityInCloseList( nIndex )
	for i=1,table.getn(m_CloseList) do
		if nIndex == m_CloseList[i].SelfIndex then
			return m_CloseList[i],i
		end
	end
	return nil
end

--搜索路径
local function SearchPath( nTab )
	--1.判断当前所选择的终点城市是否为可选城市
	if GetCityState(m_EndIndex) == false then
		return
	end

	--最小的消耗城市
	local pMinCity = nil

	local pMinCons = nil 

	--2.把开始节点放入open列表中 不需要检查了
	local city_Start = City.CreateCityData(m_StartIndex,nTab)
	table.insert(m_OpenList,city_Start)

	while table.getn(m_OpenList) > 0 do
		local city = GetMinCityF()
		--print("nCityIndex = "..city.SelfIndex.."and F = "..city.F)
		if GetEndCity(city, nTab) == true then
			--发现终点了先不建立路线，继续等带并更新消耗
			local city_End = City.CreateCityData(m_EndIndex,nTab)
			GetFGH(city,city_End)	
			if pMinCity == nil and pMinCons == nil then

				pMinCity = city

				pMinCons = city_End.F

			else
				if pMinCons > city_End.F then

					pMinCons = city_End.F

					pMinCity = city

				end
			end
		end
		--检测当前城池可行走的下一个城池
		for i=1,table.getn(city.CanMoveCityTab) do
			if GetCityState(city.CanMoveCityTab[i]) == true then
				local arroundCity = City.CreateCityData(city.CanMoveCityTab[i],nTab)
				--判断这个国家是否为敌方国家，如果是则直接放入关闭列表中
				local nCityCountry = GetCityCountry(arroundCity.SelfIndex)
				local nPlayerCountry = GetPlayerCountry()
				if m_IsBloodOrDefense == nil then
					if tonumber(nCityCountry) ~= tonumber(nPlayerCountry) then
						table.insert(m_CloseList,arroundCity)
					end
				end
				--print(arroundCity.SelfIndex, m_EndIndex)
				--Pause()
				--判断这个城市是否属于迷雾状态中
				if JudgeCityMistyState(arroundCity.SelfIndex) == false then
					table.insert(m_CloseList,arroundCity)
					m_FailedByMisty = true
				end

				--判断这个城市是否被锁定中
				if GetCityLockByState2(arroundCity.SelfIndex) == 1 then
					table.insert(m_CloseList,arroundCity)
				end

				--判断这个城市是否是事件的中心城市
				if GetCityCenterByState2(arroundCity.SelfIndex) == 1 then
					table.insert(m_CloseList,arroundCity)
				end
				
				local curCity = GetFGH(city,arroundCity)				--计算到周边城池的消耗
				local openCity,openIndex = cityInOpenList(city.CanMoveCityTab[i])
				local closeCity,closeIndex = cityInCloseList(city.CanMoveCityTab[i])
				if openCity == nil and closeCity == nil then
					--当前城市不在开放和关闭表中。已经检测过直接加入开放表
					table.insert(m_OpenList,curCity)
					--print("城市"..curCity.SelfIndex.."加入开放列表中,消耗为"..curCity.F)
				elseif openCity ~= nil then
					--在开放表中
					if openCity.F > curCity.F then
						--更新开放表中的消耗比
						m_OpenList[openIndex] = curCity
					end
				elseif closeCity ~= nil then
					--在关闭表中
					if closeCity.F > curCity.F then
						table.insert(m_OpenList,curCity)
						table.remove(m_CloseList,closeIndex)
						--print("城池.."..value.SelfIndex.."加入关闭列表")
					end
				end
			end
		end
		table.insert(m_CloseList,city)
	end

	if pMinCity == nil then

		return nil

	else

		return BuildPath(pMinCity ,nTab)

	end
end

function Init( nStartIndex,nEndIndex,nTab, nState )
	InitVars()
	m_StartIndex 	= nStartIndex
	m_EndIndex 	  	= nEndIndex
	m_Consume		= 10
	m_Tab			= nTab
	m_FailedByMisty = false

	if nState ~= nil then
		--说明当前是血战或者坚守状态,路径计算不区分国家
		m_IsBloodOrDefense = nState 
	end		
	local pathTab = SearchPath(nTab)

	--[[if pathTab ~= nil then 
		for key,value in pairs(pathTab) do
			print(key,CountryWarData.GetCityNameByIndex(CountryWarLogic.GetIndexByCTag(value)))
		end
	end]]
	return pathTab, m_FailedByMisty
end