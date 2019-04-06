require "Script/serverDB/item"
require "Script/serverDB/coin"
require "Script/serverDB/resimg"
require "Script/serverDB/globedefine"
require "Script/serverDB/pointreward"
require "Script/serverDB/monster"
require "Script/serverDB/monster_para"
require "Script/serverDB/legion_monster"
require "Script/serverDB/legion_monsterpara"
require "Script/serverDB/technolog"
require "Script/serverDB/effect"
require "Script/serverDB/server_AniInfoDB"
require "Script/serverDB/server_AniPerstigeDB"
require "Script/serverDB/server_AniCurPer"
require "Script/serverDB/server_AniQueryInfo"
require "Script/serverDB/server_AniBHMRobot"
require "Script/serverDB/cityroad"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/CountryWarData"
module("CorpsSpiritData",package.seeall)
-- require "Script/Main/Corps/CorpsSpirit/CorpsSpiritLogic"

function GetCityInfo( nCityID )
	local nIndex = CountryWarLogic.GetIndexByCTag(nCityID)
	local tab = CountryWarData.GetCountryCityRes(nIndex)
	return tab
end

function GetCityType( nCityID )
	local nIndex = CountryWarLogic.GetIndexByCTag(nCityID)
	local pCityType = tonumber(countrycity.getFieldByIdAndIndex(nIndex,"CityType"))
	return pCityType
end

function GetMonsterInfo( nIndex )
	local tabMonster = {}
	local tab = legion_monster.getArrDataByField("MonsterID",nIndex)
	for key,value in pairs(tab) do
		tabMonster[key] = {}
		tabMonster[key]["MonsterID"] = value[1]
		tabMonster[key]["TechLv"] = value[2]
		tabMonster[key]["MonsterName"] = value[3]
		tabMonster[key]["IconID"] = value[4]
		tabMonster[key]["MonsterDesc"] = value[5]
		tabMonster[key]["ReputType"] = value[6]
		tabMonster[key]["ReputCost"] = value[7]
		tabMonster[key]["GoldExchange"] = value[8]
		tabMonster[key]["ContributeTimes"] = value[9]
		tabMonster[key]["MosterRewardID"] = value[10]
		tabMonster[key]["ReputExchange"] = value[11]
		tabMonster[key]["MosterEff1"] = value[12]
		tabMonster[key]["IncrementType1"] = value[13]
		tabMonster[key]["IncrementPara1"] = value[14]
		tabMonster[key]["MosterEff2"] = value[15]
		tabMonster[key]["IncrementType2"] = value[16]
		tabMonster[key]["IncrementPara2"] = value[17]
		tabMonster[key]["RepuDesc"] = value[18]
	end
	return tabMonster
end
--得到科技等级
function GetMonsterLevel(  )
	local tabLevel = {}
	local TotalLevel = CorpsData.GetScienceLevel()
	-- printTab(TotalLevel)
	tabLevel = TotalLevel[8]
	return tabLevel
end

function GetBlessNumTotal( num )
	local tabBless = {}
	local tab = legion_monsterpara.getArrDataByField("BlessType",num)
	for key,value in pairs(tab) do
		tabBless = {}
		tabBless["BlessType"]  = value[1]
		tabBless["BlessBegin"] = value[2]
		tabBless["EffType"]    = value[3]
		tabBless["EffMax"]     = value[4]
		tabBless["TimesMax"]   = value[5]
	end
	return tabBless
end

function GetMonster_para( nIndex )
	return legion_monsterpara.getDataById(nIndex)
end

function GetSpiritLevelInfo(  )
	
	local tabTech = {}
	for i=35,38 do
		local arrayTab = technolog.getDataById(i)
		table.insert(tabTech,arrayTab)
	end
	return tabTech
end

local function GetSpiritBlessNumInfo(  )
	local tabeffect = {}
	local tabLevelInfo = CorpsSpiritLogic.CkeckTechLevel()
	local tab = effect.getDataById(tabLevelInfo["TechEffID1"])
	tabeffect["EffectType"] = tab[1]
	tabeffect["QLNum"] 		= tab[2]
	tabeffect["BHNum"] 		= tab[3]
	tabeffect["ZQNum"] 		= tab[4]
	tabeffect["XWNum"] 		= tab[5]
	tabeffect["BHMNum"] 	= tab[6]
	tabeffect["EffectPara6"] = tab[7]
	return tabeffect
end

-----从服务器获得数据
function GetAniPerstigDB(  )
	return server_AniPerstigeDB.GetCopyTable()
end

function GetAniInfoDB(  )
	return server_AniInfoDB.GetCopyTable()
end

function GetCurPerByServer(  )
	return server_AniCurPer.GetCurPerByServer()
end

function GetQueryInfo(  )
	return server_AniQueryInfo.GetCopyTable()
end

function GetCityName( nIndex )
	local tab = cityroad.getArrDataByField("CityID",nIndex)
	return tab[1][3]
end

function GetSpiritRobot(  )
	return server_AniBHMRobot.GetCopyTable()
end