--celina 攻城战的相关数据

require "Script/serverDB/server_atkcityDB"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/serverDB/server_getCountryWarInfo"
require "Script/serverDB/server_getWarList"
require "Script/serverDB/server_getCityFightCountryInfo"
require "Script/serverDB/server_getWarTCDB"
require "Script/serverDB/server_countrywarResultDB"
require "Script/serverDB/server_SingleResultDB"
require "Script/serverDB/server_BloorOrDefenseResultDB"
require "Script/serverDB/coin"
require "Script/serverDB/resimg"
require "Script/serverDB/globedefine"
module("AtkCityData", package.seeall)



--数据
local GetAtkCityTestData = server_atkcityDB.GetAtkCityTestData


local GetGeneralNameByGeneralID = GeneralBaseData.GetGeneralNameByGeneralID

function GetAllBufferTableDB()

	return server_getCountryWarInfo.GetAllBufferTableDB()
end
local function GetTabWarCityInfo()
	--得到缓存数据
	return server_getCountryWarInfo.GetBufferTableDB()
end
--得到每一次战斗的时间
function GetWarTime()
	if tonumber(server_getCountryWarInfo.GetStatyTime())<CITYWAR_TIME then
		return 2--tonumber(server_getCountryWarInfo.GetStatyTime())
	end
	return tonumber(server_getCountryWarInfo.GetStatyTime())
end
function GetTotalTime()
	return tonumber(server_getCountryWarInfo.GetTotalTime())
end
--修改为得到当前的信息，
function GetAtkData()
	GetAtkCityTestData()
end
--得到当前打斗的武将
function GetCurAtkWJ()
	return GetTabWarCityInfo()
end
--得到我方的人员
function GetMyNum()
	local tab = GetTabWarCityInfo()
	if tab == nil then
		return 
	end
	return tonumber(tab[1].nNum)-1
end
function GetEnemyNum()
	local tab = GetTabWarCityInfo()
	if tab == nil then
		return 
	end
	return tonumber(tab[2].nNum)-1
end
--[[function GetMyTeamBlood()
	return 100
end
function GetOtherTeamBlood()
	return 100
end]]--
function GetWJNameByID(nWjID)
	return GetGeneralNameByGeneralID(nWjID)
end
function GetMyResult()
	return server_getCountryWarInfo.GetCityWarResult()
end

function GetCountryType(nType)
	local tab = GetTabWarCityInfo()
	return tab[nType].nCountry
end
function GetCountryArmyNum(nType)
	local tab = GetTabWarCityInfo()
	return tab[nType].nNum
end

function GetListTabData()
	return server_getWarList.GetCopyTable()
end
--
function GetTeamNum(nType)
	--[[local tabTeam = GetListTabData()
	return tabTeam[nType].num]]--
	return server_getWarList.GetTeamNum()
end
function GetCurListPageNum()
	return server_getWarList.GetPageNum()
end
function DeleteFightedDB()
	server_getCountryWarInfo.DeleteBufferTableDB()
end

function GetBloodPercend(curHP,totalHP)
	--print(curHP,totalHP)
	--Pause()
	local percent =( tonumber(curHP)/tonumber(totalHP) )*100
	if percent<0 then
		percent = 0
	end
	return percent
end

local function GetCityFightInfoTab()
	return server_getCityFightCountryInfo.GetCopyTable()
end

function GetCityArmyData(nType)
	local tab = GetCityFightInfoTab()
	return tab[nType]
end
--获得撤退或者突进的数据
function GetWarCTData()
	return server_getWarTCDB.GetCopyTable()
end

function DeleteAllBufferData()
	server_getCountryWarInfo.DeleteBufferData()
end
--获得战斗结果
function GetResultBWin(nType)
	if tonumber(nType) ==1 then
		return server_countrywarResultDB.GetResultWin()
	elseif tonumber(nType) ==2 then
		return server_SingleResultDB.GetResultWin()
	elseif tonumber(nType) ==3 then
		return server_BloorOrDefenseResultDB.GetResultWin()
	end
end
--获得最大连杀
function GetResultMaxLS(nType)
	if tonumber(nType) ==1 then
		return server_countrywarResultDB.GetResultMaxLS()
	elseif tonumber(nType) ==2 then
		return server_SingleResultDB.GetResultMaxLS()
	elseif tonumber(nType) ==3 then
		return server_BloorOrDefenseResultDB.GetResultMaxLS()
	end
end
--获得歼敌血量
function GetResultHP(nType)
	if tonumber(nType) ==1 then
		return server_countrywarResultDB.GetResultHurt()
	elseif tonumber(nType) ==2 then
		return server_SingleResultDB.GetResultHurt()
	elseif tonumber(nType) ==3 then
		return server_BloorOrDefenseResultDB.GetResultHurt()
	end
end
--获得损失血量
function GetResultLostHP(nType)
	if tonumber(nType) ==1 then
		return server_countrywarResultDB.GetResultLost()
	elseif tonumber(nType) ==2 then
		return server_SingleResultDB.GetResultLost()
	elseif tonumber(nType) ==3 then
		return server_BloorOrDefenseResultDB.GetResultLost()
	end
end

--获得结果的奖励数据
function GetResultRewardData(nType)
	if nType ==1 then
		return server_countrywarResultDB.GetResultReWard()
	end
	if nType ==2 then
		return server_SingleResultDB.GetResultReWard()
	end
	if nType ==3 then
		return server_BloorOrDefenseResultDB.GetResultReWard()
	end
end
function GetImgPathByID(nCoinID)
	local resID = coin.getFieldByIdAndIndex(nCoinID,"ResID")
	return resimg.getFieldByIdAndIndex(resID,"icon_path")
end
function GetCityNameByCityID(nCityID)
	local index = CountryWarLogic.GetIndexByCTag(nCityID)
	return CountryWarData.GetCityNameByIndex(index)
end
--新的获取左右两边的国家以及数量
function GetCountryAndNum()
	return Packet_GetCityWarTeamNum.GetTeamNum()
end
function GetCountryPathByTag(nTag)	
	if nTag>=5 and nTag~=8 then
		nTag = 5
	end
	return "Image/imgres/common/country/country_"..nTag..".png"
end

function GetConsumeFenShenID()
	return globedefine.getFieldByIdAndIndex("WarFenshen","Para_2")
end
local EnumTypeName  = {
	EnumTypeName_E_Null = 0,
	EnumTypeName_E_Player = 1,--玩家
	EnumTypeName_E_Mercenaries = 3,--佣兵
	EnumTypeName_E_Guard = 4, --守卫
	EnumTypeName_E_Clone = 5,--分身
	EnumTypeName_E_Expendition = 6,--远征军
	EnumTypeName_E_BahaumuteSrc = 7,--变身

}
function GetColorByType(nType)
	if tonumber(nType) == tonumber(EnumTypeName.EnumTypeName_E_Mercenaries) then
		return ccc3(229,71,1)
	end
	if tonumber(nType) == tonumber(EnumTypeName.EnumTypeName_E_Clone) then
		return ccc3(194,21,188)
	end
	if tonumber(nType) == tonumber(EnumTypeName.EnumTypeName_E_Guard) then
		return ccc3(13,148,226)
	end
	return ccc3(255,217,7)
end