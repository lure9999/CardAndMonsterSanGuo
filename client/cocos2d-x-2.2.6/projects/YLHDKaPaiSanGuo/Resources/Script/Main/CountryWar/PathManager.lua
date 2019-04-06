module("PathManager", package.seeall)

require "Script/Main/CountryWar/City"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"

local GetCityCountry					=	CountryWarData.GetCityCountry

local m_CityTab = nil

local m_Country = nil

local m_StartIndex = nil

local m_MineCountry = {}

local m_EnemyCountry = {}

--判断城市是否已经在我方城池中
local function CityInMineCoutryList( nIndex )
	for i=1,table.getn(m_MineCountry) do
		if nIndex == m_MineCountry[i].SelfIndex then
			return m_MineCountry[i],i
		end
	end
	return nil
end
--判断城市是否已经在敌方城池中
local function CityInEnemyCoutryList( nIndex )
	for i=1,table.getn(m_EnemyCountry) do
		if nIndex == m_EnemyCountry[i].SelfIndex then
			return m_EnemyCountry[i],i
		end
	end
	return nil
end

local function GetCityState( ... )
	return true
end

local function FindEnemyCity( nTab )

	local city_Start = City.CreateCityData(m_StartIndex,m_CityTab)
	table.insert(m_MineCountry,city_Start)
	--print("当前城市为 = "..m_StartIndex)
	--Pause()

	local function CheckCity( city )
		--1.取出周边可到达城市
		for i=1,table.getn(city.CanMoveCityTab) do
			local arroundCity = City.CreateCityData(city.CanMoveCityTab[i],nTab)
			arroundCity.Parent = city   --建立城市之间的父子关系
			--print("发现周边城市 "..city.CanMoveCityTab[i].." 他的父城市是 "..city.SelfIndex)
			--Pause()
			--2.判断其是否已经在敌方列表中
			local nEnemyCity,nEnemyIndex = CityInEnemyCoutryList(city.CanMoveCityTab[i])
			local nMineCity,nMineIndex = CityInMineCoutryList(city.CanMoveCityTab[i])
			if nEnemyCity == nil and nMineCity == nil then --不在列表中,可继续判断遍历
				--print("城市 "..city.CanMoveCityTab[i].." 不在敌方城市列表中")
				 if GetCityCountry(city.CanMoveCityTab[i]) ~= m_Country then
				 	--发现敌方城市 加入敌方城市列表
				 	--print("城市 "..city.CanMoveCityTab[i].." 是敌方城市加入敌方城市列表")
				 	--Pause()
				 	table.insert(m_EnemyCountry, arroundCity)
				 else
				 	--没有发现敌方城市，继续遍历该城市的子节点，并把该城市加入到我方城市列表
				 	--print("城市 "..city.CanMoveCityTab[i].." 是我方城 市加入我方城市列表".." 并继续遍历他的子城市")
				 	--Pause()
				 	table.insert(m_MineCountry, arroundCity)
				 	CheckCity(arroundCity)
				 end
			end
		end
	end

	CheckCity(city_Start)

	local nEnemyTab = {}
	for i=1,table.getn(m_EnemyCountry) do
		table.insert(nEnemyTab, m_EnemyCountry[i].SelfIndex)
	end

	return nEnemyTab

end

function InitVars( )
	m_CityTab 		= nil
	m_Country 		= nil
	m_StartIndex 	= nil	
	m_MineCountry   = {}
	m_EnemyCountry  = {}
end

function Create( nStartIndex, nCityTab, nCountry )
	m_CityTab = nCityTab
	m_Country = nCountry
	m_StartIndex = nStartIndex

	return FindEnemyCity(m_CityTab)
end