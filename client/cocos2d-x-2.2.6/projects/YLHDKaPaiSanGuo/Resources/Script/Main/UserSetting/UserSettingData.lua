

--玩家设置数据 celina


module("UserSettingData", package.seeall)

require "Script/serverDB/server_mainDB"
require "Script/serverDB/globedefine"
require "Script/serverDB/expand"
require "Script/Common/ConsumeLogic"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/job"
require "Script/serverDB/head"
require "Script/serverDB/resimg"
require "Script/DB/AnimationData"
require "Script/serverDB/country"
require "Script/serverDB/server_countryLevelUpDB"
--得到玩家的形象的ID
function GetUserModelID()
	return server_mainDB.getMainData("nModeID")
	
end
--得到玩家的头像的ID
function GetUserHeadID()
	return server_mainDB.getMainData("nHeadID")
end
function GetUserName()
	return server_mainDB.getMainData("name")
end
function GetUserLv()
	return server_mainDB.getMainData("level")
end
function GetCurExp()
	return server_mainDB.getMainData("exp")
end
function GetUserSex()
	return server_mainDB.getMainData("gender")
end
function GetHeadIDByPart(strPart)
	return globedefine.getFieldByIdAndIndex("InitialHeadportrait",strPart)
end
function GetNextLvExp(nLv)
	return expand.getFieldByIdAndIndex(tonumber(nLv),"Exp")
end

function GetJTID()
	return server_mainDB.getMainData("nCorps")
end
function GetJTName()
	return server_mainDB.getMainData("corpsName")
end

function GetUserVIPLv()
	return server_mainDB.getMainData("vip")
end
function GetChangeNameTimes()
	return tonumber(server_mainDB.getMainData("NameTimes"))
end
function GetCountryTag()
	return  tonumber(server_mainDB.getMainData("nCountry"))
end
function GetCountry()
	local nTag = tonumber(server_mainDB.getMainData("nCountry"))
	if nTag ==1 then
		return "魏国"
	end
	if nTag ==2 then
		return "蜀国"
	end
	if nTag ==3 then
		return "吴国"
	end
end
function GetDeCountry(nTag)
	if tonumber(nTag) == 1 then
		return "魏"
	end
	if tonumber(nTag) == 2 then
		return "蜀"
	end
	if tonumber(nTag) == 3 then
		return "吴"
	end
end
function GetTJCountry()
	return CCUserDefault:sharedUserDefault():getIntegerForKey("country")
end	
function GetExpendData()
	--得到消耗的ID 
	local m_consumeID = globedefine.getFieldByIdAndIndex("betray","Para_1")
	local consumeTab = ConsumeLogic.GetConsumeTab(5,m_consumeID)
	local ConsumeDataTab = {}
	for i=1, table.getn(consumeTab) do
		local tableData  = ConsumeLogic.GetConsumeItemData( consumeTab[i].ConsumeID,  consumeTab[i].nIdx, consumeTab[i].ConsumeType, consumeTab[i].IncType, nil, 1, nil )
		table.insert(ConsumeDataTab,tableData)
	end
	return ConsumeDataTab
end
function GetGerneralTempID(nGrid)
	return server_generalDB.GetTempIdByGrid(nGrid)
end
--根据已经激活的主将的ID，来找出所有比他低级别已经激活的职业
function GetGerneralTab()
	return server_generalDB.GetCopyTable()
end
function GetIDByKey(nKey)
	local nLegth = string.find(nKey,"_")
	
	local nStr = string.sub(nKey,nLegth+1,string.len(nKey))
	return nStr
end
function GetJiHuoDataByGID(nTempID)
	local tableJob = job.getTable()
	local curSex = tonumber(job.getFieldByIdAndIndex(nTempID,"Gender"))
	local curJob = tonumber(job.getFieldByIdAndIndex(nTempID,"Job"))
	local curLv = tonumber(job.getFieldByIdAndIndex(nTempID,"UesrLv"))
	local tableID = {}
	for key,value in pairs(tableJob) do 
		local nSex = tonumber(value[job.getIndexByField("Gender")])
		local nJob = tonumber(value[job.getIndexByField("Job")])
		local nLv = tonumber(value[job.getIndexByField("UesrLv")])
		
		if (nLv<curLv) and (nSex== curSex) and (curJob == nJob) then
			local tab = {}
			tab.tempID = GetIDByKey(key)
			table.insert(tableID,tab)
		end
	end
	return tableID
end
--得到特殊头像表
function GetUniqueHead()
	return head.getTable()
end
function GetUniqueHeadCount()
	local nIndex = 0
	for key ,value in pairs(GetUniqueHead()) do 
		nIndex = nIndex+1
	end
	return nIndex
end
function GetHeadData( nIndex )
	return head.getDataById(nIndex)
end
function GetHeadIDByIndex(nIndex)
	return head.getFieldByIdAndIndex(nIndex,"resID")
end
function GetDesByIndex(nIndex)
	return head.getFieldByIdAndIndex(nIndex,"Des")
end
function GetUniqueHeadIDByKey(strKey)
	return string.sub(strKey,string.find(strKey,"_")+1,string.len(strKey))
end
function GetUniquePathByKey(strKey)
	return resimg.getFieldByIdAndIndex(GetUniqueHeadIDByKey(strKey),"icon_path")
end
function GetUserID()
	return  server_mainDB.getMainData("nModeID")
end

function GetExpendData(nCountry,nCountryLv)
	local dataCountry = country.getArrDataBy2Field("Country", nCountry, "CounLv", nCountryLv)
	local expendID = dataCountry[1][country.getIndexByField("ChangeConID")]
	return ConsumeLogic.GetExpendData(expendID).TabData
end

function GetChangeNameExpend()
	local nChangeTimes = GetChangeNameTimes()
	local expendID = globedefine.getFieldByIdAndIndex("RenameCons","Para_1")
	local c_ChangeNameTab = ConsumeLogic.GetConsumeTab(5,expendID,nChangeTimes,1)
	local tableChangeData = {}
	for i=1,#c_ChangeNameTab do 
		local tData = ConsumeLogic.GetConsumeItemData(c_ChangeNameTab[1].ConsumeID,c_ChangeNameTab[1].nIdx,c_ChangeNameTab[1].ConsumeType,c_ChangeNameTab[1].IncType,nChangeTimes,1)
		table.insert(tableChangeData,tData)
	end
	return tableChangeData
end	
--得到变更国家的折扣系数
function GetPriceRatio()
	local ratio = globedefine.getFieldByIdAndIndex("CorpsCamp","Para_3")
	return tonumber(ratio)/1000
end

function GetCountryLv(nCountryTag)
	if tonumber(nCountryTag) == tonumber(GetCountryTag()) then
		return server_countryLevelUpDB.GetLevel()
	end
	for i=1,2 do 
		if tonumber(nCountryTag) == server_countryLevelUpDB.GetEnemyCountry(i) then
			return server_countryLevelUpDB.GetEnemyLevel(i)
		end
	end
end
	