
require "Script/serverDB/countrycity"
require "Script/serverDB/cityroad_edit"
require "Script/serverDB/general"
require "Script/serverDB/globedefine"
require "Script/serverDB/server_mainDB"
require "Script/Main/CountryWar/CountryWarDef"
 
require "Script/serverDB/server_CountryWarAllMesDB"
require "Script/serverDB/server_CountryWarTeamOrderDB"
require "Script/serverDB/server_CountryWarTeamMesDB"
require "Script/serverDB/server_CountryWarPalyerInfoDB"
require "Script/serverDB/server_countryLevelUpDB"
require "Script/serverDB/server_CountryWarTeamLifeDB"
require "Script/serverDB/server_CountryWarExpeditionMesDB"
require "Script/serverDB/server_CountryAnimalBuffDB"
require "Script/serverDB/server_CountryPattern"
require "Script/serverDB/server_CountryWarMistyMesDB"
require "Script/serverDB/country"
require "Script/serverDB/resani"
require "Script/serverDB/expendition"
require "Script/Main/CountryWar/CountryWarDef"
require "Script/Main/Item/ItemData"

module("CountryWarData", package.seeall)

local GetGeneralHeadIcon  = GeneralBaseData.GetGeneralHeadIcon

--add by sxin
--do
	-- declare local variables
	--// exportstring( string )
	--// returns a "Lua" portable version of the string
	local function exportstring( s )
		return string.format("%q", s)
	end

	--// The Save Function
	function table.save(  tbl,filename )
		local charS,charE = "   ","\n"
		local file,err = io.open( filename, "wb" )
		if err then return err end

		-- initiate variables for save procedure
		local tables,lookup = { tbl },{ [tbl] = 1 }
		file:write( "return {"..charE )

		for idx,t in ipairs( tables ) do
			file:write( "-- Table: {"..idx.."}"..charE )
			file:write( "{"..charE )
			local thandled = {}

			for i,v in ipairs( t ) do
				thandled[i] = true
				local stype = type( v )
				-- only handle value
				if stype == "table" then
					if not lookup[v] then
						table.insert( tables, v )
						lookup[v] = #tables
					end
					file:write( charS.."{"..lookup[v].."},"..charE )
				elseif stype == "string" then
					file:write(  charS..exportstring( v )..","..charE )
				elseif stype == "number" then
					file:write(  charS..tostring( v )..","..charE )
				end
			end

			for i,v in pairs( t ) do
				-- escape handled values
				if (not thandled[i]) then
				
					local str = ""
					local stype = type( i )
					-- handle index
					if stype == "table" then
						if not lookup[i] then
							table.insert( tables,i )
							lookup[i] = #tables
						end
						str = charS.."[{"..lookup[i].."}]="
					elseif stype == "string" then
						str = charS.."["..exportstring( i ).."]="
					elseif stype == "number" then
						str = charS.."["..tostring( i ).."]="
					end
				
					if str ~= "" then
						stype = type( v )
						-- handle value
						if stype == "table" then
							if not lookup[v] then
								table.insert( tables,v )
								lookup[v] = #tables
							end
							file:write( str.."{"..lookup[v].."},"..charE )
						elseif stype == "string" then
							file:write( str..exportstring( v )..","..charE )
						elseif stype == "number" then
							file:write( str..tostring( v )..","..charE )
						end
					end
				end
			end
			file:write( "},"..charE )
		end
		file:write( "}" )
		file:close()
	end
	
	--// The Load Function
	function table.load( sfile )
		local ftables,err = loadfile( sfile )
		if err then return _,err end
		local tables = ftables()
		for idx = 1,#tables do
			local tolinki = {}
			for i,v in pairs( tables[idx] ) do
				if type( v ) == "table" then
					tables[idx][i] = tables[v[1]]
				end
				if type( i ) == "table" and tables[i[1]] then
					table.insert( tolinki,{ i,tables[i[1]] } )
				end
			end
			-- link indices
			for _,v in ipairs( tolinki ) do
				tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
			end
		end
		return tables[1]
	end
-- close do
--end



--[[
--AnalyzeRoadPt 解析路点数据 require的时候直接初始化

local PointData = cityroad_edit.getjsonData()

--local pNetStream = nil
local pNetStream = NetStream()
pNetStream:SetPacket(PointData)

local tab = {}

if pNetStream ~= nil then
	for i=1,254 do	
		local PointTab = pNetStream:Read()
		tab[i] = {}
		tab[i]["CurNode"] = PointTab[CityRoad_Struct.E_CityRoad_Struct_Node]
		local Targets = PointTab[CityRoad_Struct.E_CityRoad_Struct_TarGets]
		tab[i]["TarGetArrs"] = {}
		for j=1,table.getn(Targets) do
			tab[i]["TarGetArrs"][j] = {}
			tab[i]["TarGetArrs"][j]["TarNode"] = Targets[j][CityRoad_Struct_TarGetNode.E_CityRoad_Struct_TarGetNode]
			local Points = Targets[j][CityRoad_Struct_TarGetNode.E_CityRoad_Struct_TarGetPoint]
			tab[i]["TarGetArrs"][j]["Points"] = {}
			for k=1,table.getn(Points) do	
				tab[i]["TarGetArrs"][j]["Points"][k] = Points[k]
			end
		end
	end
end
]]--

local SAVEFILE="cityroad_edit.moe"
local LOADFILE="Script/Main/CountryWar/cityroad_edit.lua"
local tab = {}
--add by sxin 增加接口
function Initcityroad_editData()
	
	local PointData = cityroad_edit.getjsonData()
	local pNetStream = NetStream()
	pNetStream:SetPacket(PointData)
	local tab = {}
	if pNetStream ~= nil then
		for i=1,254 do
			local PointTab = pNetStream:Read()
			tab[i] = {}
			tab[i]["CurNode"] = PointTab[CityRoad_Struct.E_CityRoad_Struct_Node]
			local Targets = PointTab[CityRoad_Struct.E_CityRoad_Struct_TarGets]
			tab[i]["TarGetArrs"] = {}
			for j=1,table.getn(Targets) do
				tab[i]["TarGetArrs"][j] = {}
				tab[i]["TarGetArrs"][j]["TarNode"] = Targets[j][CityRoad_Struct_TarGetNode.E_CityRoad_Struct_TarGetNode]
				local Points = Targets[j][CityRoad_Struct_TarGetNode.E_CityRoad_Struct_TarGetPoint]
				tab[i]["TarGetArrs"][j]["Points"] = {}
				for k=1,table.getn(Points) do	
					tab[i]["TarGetArrs"][j]["Points"][k] = Points[k]
				end
			end
		end
	end
	table.save( tab , SAVEFILE )
	
end

function Loadcityroad_editData()

	local function table_load( sfile )		
		local tables = require( sfile )			
		for idx = 1,table.getn(tables) do
			local tolinki = {}
			for i,v in pairs( tables[idx] ) do
				if type( v ) == "table" then
					tables[idx][i] = tables[v[1]]
				end
				if type( i ) == "table" and tables[i[1]] then
					table.insert( tolinki,{ i,tables[i[1]] } )
				end
			end
			-- link indices
			for _,v in ipairs( tolinki ) do
				tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
			end
		end
		return tables[1]
	end

	tab = table_load(LOADFILE)	
end

function GetGeneralHeadPath( nTempID )
	return GetGeneralHeadIcon(nTempID)
end

function GetAroundLinkCity( nCityTag )
	local aroundTab = nil
	for i=1,table.getn(tab) do
		local nCurNode = tab[i]["CurNode"]
		if nCityTag == nCurNode then
			aroundTab = tab[i]
		end
	end
	local nTarNodes = aroundTab["TarGetArrs"]
	local nTarCitys = {}
	for i=1,table.getn(nTarNodes) do
		table.insert(nTarCitys, nTarNodes[i]["TarNode"])
	end

	return nTarCitys
end

function GetLinkCityData( nSourceTag,nTargetTag )
	local linkTab = {}
	--找到当前节点
	local NodeTab = nil 
	for i=1,table.getn(tab) do
		local nCurNode = tab[i]["CurNode"]
		if nSourceTag == nCurNode then
			NodeTab = tab[i]
		end
	end

	local nTarNodes = NodeTab["TarGetArrs"]
	for i=1,table.getn(nTarNodes) do
		local nTarNodesArrs = nTarNodes[i]
		local nTarNode = nTarNodesArrs["TarNode"]
		if tonumber(nTarNode) == tonumber(nTargetTag) then
			--找到目标点
			local nPtArrs = nTarNodesArrs["Points"]
			for j=1,table.getn(nPtArrs) do
				local nPtX = nPtArrs[j][CityRoad_Struct_Pt.E_CityRoad_Struct_Pt_X]
				local nPtY = nPtArrs[j][CityRoad_Struct_Pt.E_CityRoad_Struct_Pt_Y]
				local nlinkPt = nPtX.."|"..nPtY
				--print("第"..j.."个坐标有值加入tab = "..nlinkPt)
				table.insert(linkTab,nlinkPt)
			end
		end
	end

	return linkTab
end

function GetCityTagByIndex( nIndex )
	return tonumber(countrycity.getFieldByIdAndIndex(nIndex,"CityID"))
end

function GetCityCampByIndex( nIndex )
	return tonumber(countrycity.getFieldByIdAndIndex(nIndex,"InitialCoun"))
end

function GetCityNameByIndex( nIndex )
	return tostring(countrycity.getFieldByIdAndIndex(nIndex,"CityName"))
end

function GetCityBurnAniByCityID( nIndex )
	return tostring(countrycity.getFieldByIdAndIndex(nIndex,"EffRes"))
end

function GetCityTab( )
	return countrycity.getTable()
end

function GetCityMaxNum( )
	local num = 0
	for key,value in pairs(countrycity.getTable()) do
		num = num + 1
	end
	return num
end

function GetGeneralResId( nmodId )
	return tonumber(general.getFieldByIdAndIndex( nmodId , "ResID" ))
end
--城市基本数据Begin
function GetCityCountry( nCityID )
	return tonumber(server_CountryWarAllMesDB.GetCityCountry(nCityID))
end

function GetCityState( nCityID )
	return server_CountryWarAllMesDB.GetCityState(nCityID)
end

function GetCityLockByState2( nCityID )
	return tonumber(server_CountryWarAllMesDB.GetCityLockByState2(nCityID))
end

function SetCityLockByState2( nCityID, nState )
	return server_CountryWarAllMesDB.SetCityLockByState2(nCityID, nState)
end

function SetCityCenterByState2( nCityID, nState )
	return server_CountryWarAllMesDB.SetCityCenterByState2(nCityID, nState)
end

function SetCityManZuByState2( nCityID, nState )
	return server_CountryWarAllMesDB.SetCityManZuByState2(nCityID, nState)
end

function GetCityCenterByState2( nCityID )
	return tonumber(server_CountryWarAllMesDB.GetCityCenterByState2(nCityID))
end

function GetCityConfusByState2( nCityID )
	return server_CountryWarAllMesDB.GetCityConfusByState2(nCityID)
end

function GetCityManZuByState2( nCityID )
	return server_CountryWarAllMesDB.GetCityManZuByState2(nCityID)
end
--城市基本数据End

function GetTeamTab()
	return server_CountryWarTeamMesDB.GetCopyTable()
end

function GetTeamCount()
	return table.getn(server_CountryWarTeamMesDB.GetCopyTable())
end

function GetTeamLevel( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamLevel"]
		end
	end
	return nil
end

function GetTeamFace( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamFace"]
		end
	end
	return nil
end

function GetTeamRes( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamRes"]
		end
	end
	return nil
end

function GetTeamName( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamName"]
		end
	end
	return nil
end

function GetTeamBlood( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			local pMaxBlood =  nTeamTab[key]["TeamBloodMax"]
			local pCurBlood =  nTeamTab[key]["TeamBloodCur"]
			return tonumber(pCurBlood) / tonumber(pMaxBlood) * 100
		end
	end
	return nil
end

function GetTeamMistyIndex( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamMistyIndex"]
		end
	end
	return nil
end

function GetTeamMaxBlood( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamBloodMax"]
		end
	end
	return nil
end

function GetTeamCurBlood( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamBloodCur"]
		end
	end
	return nil
end
--国战吃血瓶消耗
function GetRecoveryBloodCons(  )
	return tonumber(globedefine.getFieldByIdAndIndex("CorpsHP", "Para_5"))
end
--云南白药的恢复血量值	
function GetReconveryBloodNum( nItemID )
	return tonumber(item.getFieldByIdAndIndex(nItemID, "event_para_A"))
end
--获得道具的名称
function GetReconveryBloodName( nItemID )
	return tostring(item.getFieldByIdAndIndex(nItemID, "name"))
end
--当前拥有的某个物品的数量
function GetCurHaveItemNum( nItemID )
	return tonumber(ItemData.GetNumByTempID(nItemID))
end

function GetTeamCity( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return nTeamTab[key]["TeamCity"]
		end
	end
	return nil
end

function GetTeamTargetCity( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return tonumber(nTeamTab[key]["TeamTarCity"])
		end
	end
	return nil
end

function GetTeamBloodCity( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return tonumber(nTeamTab[key]["TeamBloodWCity"])
		end
	end
	return nil
end

function GetTeamBloodCityTime( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			if nTeamTab[key]["TeamBloodWTime"] ~= -1 then
				return tonumber(nTeamTab[key]["TeamBloodWTime"])
			end
		end
	end
	return nil
end

function GetTeamState( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return tonumber(nTeamTab[key]["TeamState"])
		end
	end
	return nil
end

function GetTeamID( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return tonumber(nTeamTab[key]["TeamID"])
		end
	end
	return nil
end

function GetConsNeedNum( nTeamIndex )
	local pTeamID = GetTeamID(key)
	if pTeamID > 0 then
		local pConsID = GetBloodConsID(pTeamID)
		local pConsTab = GetExpendData(pConsID)

		return tonumber(pConsTab.TabData[1].ItemNeedNum) 
	end
end

function SetTeamCurBlood( nTeamIndex, nBlood )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			server_CountryWarTeamMesDB.UpdateAttr( nTeamIndex, TEAM_ATTR.Blood, nBlood )
		end
	end
end

function GetConsName( nConsType, nConsNeedNum )
	return ConsumeLogic.GetConsumeTypeName(nConsType)
end

function GetBloodConsID( nTeamID )
	return tonumber(mercenary.getFieldByIdAndIndex(nTeamID,"BloodCostID"))
end

function GetPlayerCountry( )
	--local tab = server_CountryWarPalyerInfoDB.GetCopyTable()
	--return tonumber(tab["Country"])
	return tonumber(server_mainDB.getMainData("nCountry"))
end

function GetBloodOrDefenseTime( )
	local tab = server_CountryWarPalyerInfoDB.GetCopyTable()
	return tonumber(tab["BloodTime"])
end

function GetMainCityByCountry( nCountry )
	local nStr = nil
	if tonumber(nCountry) == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
		nStr = "WeiCapital"
	elseif tonumber(nCountry) == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
		nStr = "ShuCapital"
	elseif tonumber(nCountry) == COUNTRY_TYPE.COUNTRY_TYPE_WU then
		nStr = "WuCapital"
	end
	return tonumber(globedefine.getFieldByIdAndIndex(nStr, "Para_1"))
end

----佣兵队伍数据end

function GetTunTianByCountry( nCountry )
	local nStr = nil
	if tonumber(nCountry) == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
		nStr = "WeiCapital"
	elseif tonumber(nCountry) == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
		nStr = "ShuCapital"
	elseif tonumber(nCountry) == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
		nStr = "WuCapital"
	end
	return tonumber(globedefine.getFieldByIdAndIndex(nStr, "Para_2"))
end

----国家升级页面相关数据
function GetCountry( )
	return server_countryLevelUpDB.GetCoutry()
end

function GetPower( )
	return server_countryLevelUpDB.GetPower()
end

function GetLevel( )
	return server_countryLevelUpDB.GetLevel()
end

function GetExp( )
	return server_countryLevelUpDB.GetExp()
end

function GetNormalArmyName( )
	return server_countryLevelUpDB.GetNormalArmyName()
end

function GetNormalArmyLv( )
	return server_countryLevelUpDB.GetNormalArmyLv()
end

function GetEliteArmyName( )
	return server_countryLevelUpDB.GetEliteArmyName()
end

function GetEliteArmyLv( )
	return server_countryLevelUpDB.GetEliteArmyLv()
end

function GetExp( )
	return server_countryLevelUpDB.GetExp()
end

function GetEnemyCountry( nIndex )
	return server_countryLevelUpDB.GetEnemyCountry(nIndex)
end

function GetEnemyLevel( nIndex )
	return server_countryLevelUpDB.GetEnemyLevel(nIndex)
end

function GetEnemyExp( nIndex )
	return server_countryLevelUpDB.GetEnemyExp(nIndex)
end

function GetIdByInfo( nCountry, nLevel )
	local index = 1
	for key,value in pairs(country.getTable()) do
		if tonumber(country.getFieldByIdAndIndex(index, "Country")) == tonumber(nCountry) then
			if tonumber(country.getFieldByIdAndIndex(index, "CounLv")) == tonumber(nLevel) then
				print(tonumber(country.getFieldByIdAndIndex(index, "CounLv")))
				return index
			end
		end
		index = index + 1
	end
	return nil
end
--获取普通守军ID
function GetNormalDefenseArmyID()
	return server_countryLevelUpDB.GetNormalDefenseID()
end
--获取精英守军ID
function GetEliteDefenseArmyID()
	return server_countryLevelUpDB.GetEliteDefenseID()
end
--获取当前升级上限
function GetLevelUpMax( nCountry, nLevel )
	local id = GetIdByInfo(nCountry, nLevel)
	return tonumber(country.getFieldByIdAndIndex(id, "CounUpExp"))
end
--获取当前国家城池形象资源路径
function GetCountryRes( nCountry, nLevel )
	local id = GetIdByInfo(nCountry, nLevel)
	local pResID =  tonumber(country.getFieldByIdAndIndex(id, "CounImgID"))
	local pAniTab = {}
	if pResID > 0 then
		pAniTab["AniPath"] = resani.getFieldByIdAndIndex(pResID, "ani_path")
		pAniTab["AniName"] = resani.getFieldByIdAndIndex(pResID, "ani_name")
		pAniTab["AniAct"] = resani.getFieldByIdAndIndex(pResID, "ani_act")

		return pAniTab

	end

	return nil
end

--获取每个城市的城市形象
function GetCountryCityRes( nCityIndex )
	local pResID = tonumber(countrycity.getFieldByIdAndIndex(nCityIndex,"CityImg"))
	local pAniTab = {}
	if pResID > 0 then
		pAniTab["AniPath"] = resani.getFieldByIdAndIndex(pResID, "ani_path")
		pAniTab["AniName"] = resani.getFieldByIdAndIndex(pResID, "ani_name")
		pAniTab["AniAct"] = resani.getFieldByIdAndIndex(pResID, "ani_act")

		return pAniTab

	end

	return nil
end

----国家升级页面相关数据end

--获取国战队伍当前是否过期
function GetTeamLife( nIndex )
	local nTab = server_CountryWarTeamLifeDB.GetCopyTable()
	if nTab ~= nil then 
		local nStatus = nTab[nIndex]
		if tonumber(nStatus) == 1 then
			return true
		end
	end
	return false
end
--获得国战队伍是否坐牢
function GetTeamCell( nTeamIndex )
	local nTeamTab = GetTeamTab()
	for key,value in pairs(nTeamTab) do
		if key == nTeamIndex then
			return tonumber(nTeamTab[key]["CellTime"])
		end
	end
	return nil
end

---------------------------------远征军或者其他事件数据------------------------------
function GetExpeDitionCount( )
	return tonumber(server_CountryWarExpeditionMesDB.GetExpeDitionCount())
end

function GetExpeDitionDataByIndex( iIndex )
	local tab = server_CountryWarExpeditionMesDB.GetCopyTable()
	if tab ~= nil then return tab[iIndex] end
end

function GetExpeDitionIndex( nIndex )
	return tonumber(server_CountryWarExpeditionMesDB.GetExpeDitionIndex(nIndex))
end

function GetExpeDitionGrid( nIndex )
	return tonumber(server_CountryWarExpeditionMesDB.GetExpeDitionGrid(nIndex))
end

function GetExpeDitionCityID( nIndex )
	return tonumber(server_CountryWarExpeditionMesDB.GetExpeDitionCityID(nIndex))
end

function GetPathByImageID( nResId )
	return tostring(resimg.getFieldByIdAndIndex(nResId, "icon_path"))
end

function GetExpeDitionResImgID( nIndex )
	return tonumber(expendition.getFieldByIdAndIndex(nIndex, "AResImgID"))
end

function GetExpeDitionRewardImgID( nIndex )
	return tonumber(expendition.getFieldByIdAndIndex(nIndex, "RResImgID"))
end
--雷达资源
function GetExpeDitionRaderImgID( nIndex )
	return tonumber(expendition.getFieldByIdAndIndex(nIndex, "LResImgID"))
end

function GetExpeDitionCountryID( nIndex )
	return tonumber(expendition.getFieldByIdAndIndex(nIndex, "CountryID"))
end
--获取远征军类型
function GetExpeDitionType( nIndex )
	return tonumber(expendition.getFieldByIdAndIndex(nIndex, "ExpenOrMons"))
end

function DelExpeData( nGrid )
	if nGrid ~= nil then
		server_CountryWarExpeditionMesDB.DeltabByGrid(nGrid)
	else
		print("Error in CountryWarData line 397") 
	end
end

function GetDataByGrid( nGrid )
	for i=1,GetExpeDitionCount() do
	 	local nData = GetExpeDitionDataByIndex(i)
	 	if nData["Grid"] == nGrid then
	 		return nData
	 	end
	end 

	return nil
end

function UpdateDataByGrid( nGrid, nCityID )
	server_CountryWarExpeditionMesDB.UpdateDataByGrid(nGrid, nCityID)
end

--------------------------------------迷雾数据-------------------------------------------

function GetMistyDB( )
	return server_CountryWarMistyMesDB.GetCopyTable()
end

function GetMistyCityID( nMistyIndex )
	require "Script/serverDB/misty"
	return tonumber(misty.getFieldByIdAndIndex(nMistyIndex, "CityID"))
end

function GetMistyAffectCityID( nMistyIndex, nIndex )
	return tonumber(misty.getFieldByIdAndIndex(nMistyIndex, "MistyCityID"..nIndex))
end

function GetMistyRewardResID( nMistyIndex )
	return tonumber(misty.getFieldByIdAndIndex(nMistyIndex, "ResIcon"))
end

function UpdateMistyState( nIndex, bState )
	server_CountryWarMistyMesDB.UpdateCityMistyState( nIndex, bState )
end

------牢房
function GetUnlockPrisonConsume( )
	return tonumber(globedefine.getFieldByIdAndIndex("Prison", "Para_6"))
end

---神兽buff数据
function GetAnimalBuffInfo(  )
	return server_CountryAnimalBuffDB.GetCopyTable()
end

--三国格局数据
function GetSanGuoPattern(  )
	return server_CountryPattern.GetCopyTable()
end