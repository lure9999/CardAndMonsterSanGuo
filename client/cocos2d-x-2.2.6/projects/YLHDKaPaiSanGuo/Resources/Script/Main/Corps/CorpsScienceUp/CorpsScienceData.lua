module("CorpsScienceData",package.seeall)
require "Script/serverDB/techeffect"
require "Script/serverDB/effect"
require "Script/serverDB/globedefine"
require "Script/serverDB/resimg"
require "Script/serverDB/server_CorpsScienceUpDB"
require "Script/serverDB/server_CorpsScienceUpDate"
require "Script/serverDB/server_ScienceAssetDB"
require "Script/serverDB/server_ScienceSpeedUp"
require "Script/serverDB/server_ScienceLevelDB"
require "Script/serverDB/server_CorpsDonate"
require "Script/serverDB/server_CorpsHall"

--得到当前注资次数
function GetScienceAmountByID( id )
	local tabLevel = {}
	local tab = server_ScienceLevelDB.GetCopyTable()
	tabLevel = tab[id]
	return tabLevel["m_CurAmount"]
	-- return 2
end
--得到当前科技研发所剩余的时间
function GetScienceTimeByID( id )
	local tabLevel = {}
	local tab = server_ScienceLevelDB.GetCopyTable()
	tabLevel = tab[id]
	return tabLevel["m_time"]
end

--科技立即完成返回的数据
function GetScienceSpeedDB(  )
	return server_ScienceSpeedUp.GetTimeNum()
end

function GetScienceZhuci(  )
	return server_ScienceAssetDB.GetCopyTable()
end

function GetArrayData( nTempID )
	return technolog.getDataById(nTempID)
	--return Technolog.getArrDataByField(nTempID,"TechDes")
end

function GetScienceID( nTempID )
	return technolog.getFieldByIdAndIndex(nTempID,"ResimgID")
end

function GetScienceTypeByID( nTempID )
	return technolog.getFieldByIdAndIndex(nTempID,"TechnologyID")
end

function GetScienceLV( nTempID )
	return technolog.getFieldByIdAndIndex(nTempID,"TechLv")
end

function getDataByFiles( nTempID,nLvID )
	
end

function GetScienceName( nTempID )
	return technolog.getFieldByIdAndIndex(nTempID,"TechName")
end

function GetScienceDes( nTempID )
	return technolog.getFieldByIdAndIndex(nTempID,"TechDes")
end

function GetScienceTime( nTempID )
	return technolog.getFieldByIdAndIndex(nTempID,"ResearchTime")
end

function GetTabData(  )
	return technolog.getTable()
end

function GetScienceImg( nTempID )
	local imgId = Technolog.getFieldByIdAndIndex(nTempID,"ResimgID")
	local nTempValue = GetArrayData(nTempID)
	return resimg.getFieldByIdAndIndex(nTempValue[3],"icon_path")
end

function GetScienceIconImg( nTempID )
	return resimg.getFieldByIdAndIndex(nTempID,"icon_path")
end

function GetItemPath( nTempID )
	return resimg.getFieldByIdAndIndex(nTempID,"icon_path")
end

function SortScienceItemData( pData,SortWay )
	local function SortByType( a,b )
		if SortWay == true then
			return a.TechnologyID > b.TechnologyID
		else
			return a.TechnologyID < b.TechnologyID
		end
	end
	table.sort(pData,SortByType)
end

function GetSortScienceTypeList( pData )
	local nScienceData = {}
	if pData == nil then
		nScienceData = GetTabData()
	else
		nScienceData = pData
	end

	if #nScienceData > 0 then
		for key,value in pairs(nScienceData) do
			print(key,value)
			SortScienceItemData(value,true)
		end
	end
	return nScienceData
end

function GetSortList(  )
	local data = GetTabData()
	return GetSortScienceTypeList(data)
end

function GetScienceUpT(  )
	return server_CorpsScienceUpDB.GetTimeNum()
end

function GetScienceEffect( nTempID )
	return effect.getDataById(nTempID)
end

function GetScienceUpdate(  )
	return server_CorpsScienceUpDate.GetCopyTable()
end

function GetScienceDonate(  )
	return server_CorpsDonate.GetCopyTable()
end

function GetScienceHall(  )
	return server_CorpsHall.GetCopyTable()
end

function GetScienceCurCount(  )
	local ScienceTable = GetScienceZhuci()
	for key,value in pairs(ScienceTable) do
		--if tonumber(value.nType) == tonumber(nTempID) then
			--return value.nAssetInjection
		--end

	end
	return 0
end



function GetSpeedUpData(  )
	local TabSUData = globedefine.getDataById("Technology")
	local ntime = TabSUData[1]
	local consumTypeID =  TabSUData[2]
	local tab = ConsumeLogic.GetExpendData(TabSUData[2])
	local tabSpeedConsum = tab.TabData
	return ntime,tabSpeedConsum[1].IconPath,tabSpeedConsum[1].ItemNeedNum,tabSpeedConsum[1].ItemNum
end

function GetSpeedUpDataByID(  )
	local TabSUData = globedefine.getDataById("Technology")
	local ntime = TabSUData[1]
	local consumTypeID =  TabSUData[2]
	local nPath = resimg.getFieldByIdAndIndex(consumTypeID, "icon_path")
	return ntime,consumTypeID,nPath
end

function GetScienceInfo(  )
	local totalTable = {}
	local tableTreeData 		= {}
	local tablePersonNumData 	= {}
	local tableOfficalData 		= {}
	local tableMessData 		= {}
	local tableDonateData 		= {}
	local tableShopData 		= {}
	local tableYongBingData 	= {}
	local tableSpiritData 		= {}
	local tableTaskData 		= {}
	local tableRandomData 		= {}
	local tablePrisonData       = {}
	for i=1,10 do
		local ArrayData = GetArrayData(i)
		table.insert(tableTreeData,ArrayData)

	end
	table.insert(totalTable,tableTreeData)
	for i=11,14 do
		local ArrayMemData = GetArrayData(i)
		table.insert(tablePersonNumData,ArrayMemData)
	end
	table.insert(totalTable,tablePersonNumData)
	for i=15,18 do
		local ArrayData = GetArrayData(i)
		table.insert(tableOfficalData,ArrayData)
	end
	table.insert(totalTable,tableOfficalData)
	for i=19,22 do
		local ArrayData = GetArrayData(i)
		table.insert(tableMessData,ArrayData)
	end
	table.insert(totalTable,tableMessData)
	for i=23,26 do
		local ArrayData = GetArrayData(i)
		table.insert(tableDonateData,ArrayData)
	end
	table.insert(totalTable,tableDonateData)
	for i=27,30 do
		local ArrayData = GetArrayData(i)
		table.insert(tableShopData,ArrayData)
	end
	table.insert(totalTable,tableShopData)
	for i=31,34 do
		local ArrayData = GetArrayData(i)
		table.insert(tableYongBingData,ArrayData)
	end
	table.insert(totalTable,tableYongBingData)
	for i=35,38 do
		local ArrayData = GetArrayData(i)
		table.insert(tableSpiritData,ArrayData)
	end
	table.insert(totalTable,tableSpiritData)
	for i=39,42 do
		local ArrayData = GetArrayData(i)
		table.insert(tableTaskData,ArrayData)
	end
	table.insert(totalTable,tableTaskData)
	for i=43,47 do
		local ArrayData = GetArrayData(i)
		table.insert(tablePrisonData,ArrayData)
	end
	table.insert(totalTable,tablePrisonData)
	return totalTable
end

function GetSItemNeedCount( nTempID,nLevel )
	local tabTotal = GetScienceInfo()
	local tabTechTotal = tabTotal[nTempID]
	for key,value in pairs(tabTechTotal) do
		if tonumber(value[2]) == tonumber(nLevel) then
			return value[8]
		end
	end
end

function GetScienceUpFailedName( id )
	local str = nil
	if id == 1 then
		str = "大本营科技"
	elseif id == 2 then
		str = "成员上限科技"
	elseif id == 3 then
		str = "官员上限科技"
	elseif id == 4 then
		str = "军团食堂科技"
	elseif id == 5 then
		str = "军团慈善科技"
	elseif id == 6 then
		str = "军团商店科技"
	elseif id == 7 then
		str = "军团佣兵科技"
	elseif id == 8 then
		str = "军团灵兽科技"
	elseif id == 9 then
		str = "任务事件科技"
	elseif id == 10 then
		str = "随机事件科技"
	elseif id == 11 then
		str = "牢房科技"
	end
	return str
end



