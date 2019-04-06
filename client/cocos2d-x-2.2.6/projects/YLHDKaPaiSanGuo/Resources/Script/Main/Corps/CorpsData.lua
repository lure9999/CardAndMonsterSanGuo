--FileName:CorpsData
--Author:xuechao
--Purpose:军团数据
require "Script/serverDB/server_mainDB"
require "Script/serverDB/server_CorpsDB"
require "Script/serverDB/server_CorpsInfoDB"
require "Script/serverDB/server_CorpsGetInfoDB"
--require "Script/serverDB/Legioicon"
require "Script/serverDB/server_CorpsGetListDB"
require "Script/serverDB/server_CorpsMember"
require "Script/serverDB/server_CorpsGetOneInfo"
require "Script/serverDB/legioicon"
require "Script/serverDB/resimg"--
require "Script/serverDB/server_CorpsDynamicDB"
require "Script/serverDB/globedefine"
require "Script/serverDB/consume"
require "Script/serverDB/item"
require "Script/serverDB/server_ScienceLevelDB"
require "Script/serverDB/server_CorpsPersonInfo"
require "Script/serverDB/technolog"
require "Script/serverDB/effect"
require "Script/serverDB/pointreward"
require "Script/serverDB/coin"
require "Script/serverDB/prison"
require "Script/serverDB/vipfunction"
require "Script/serverDB/server_GetRecomCountryDB"
require "Script/serverDB/server_CorpsTreeDB"
module("CorpsData",package.seeall)

function GetPrisonDB( nindex )
	local tab = prison.getDataById(nindex)
	return tab
end

--神树vip功能数据
function GetVIPTreeLimit(  )
	local tabVIPData = vipfunction.getDataById(enumVIPFunction.eVipFunction_18)
end

function GetVIPLimit( nTemp )
	local tabVIPData = vipfunction.getDataById(nTemp)
	return tabVIPData[5]
end

function GetTreeGolbeData(  )
	local tabTreeData = globedefine.getDataById("ShenShuArt")
	return tabTreeData[1]/100,tabTreeData[2]/100,tabTreeData[3]/100,tabTreeData[4]/100,tabTreeData[5]/100
end

function GetPathImg(nindex )
	local pathID = nil
	if tonumber(nindex) > 20 then
		pathID = coin.getFieldByIdAndIndex(nindex,"ResID")
	else
		pathID = item.getFieldByIdAndIndex(nindex,"res_id")
	end
	return resimg.getFieldByIdAndIndex(pathID,"icon_path")
end

function GetCorpsTreeData(  )
	return server_CorpsTreeDB.GetCopyTable()
end

--获取三个国家的基本战力
function GetRecomCountryData(  )
	return server_GetRecomCountryDB.GetCopyTable()
end

--获取推荐国家ID
function GetRecomCountryID(  )
	return server_GetRecomCountryDB.GetRecomCountryID()
end
--获取魏国战力
function GetWeiCountryPower(  )
	return server_GetRecomCountryDB.GetWeiPower()
end
--获取蜀国战力
function GetShuCountryPower(  )
	return server_GetRecomCountryDB.GetShupower()
end
--获取吴国战力
function GetWuCountryPower(  )
	return server_GetRecomCountryDB.GetWuPower()
end

function GetCorpsMemberNum( ntemp )
	return effect.getFieldByIdAndIndex(tonumber(ntemp),"EffectPara1")
end

function GetCorpsShengNvNum( ntemp )
	return effect.getFieldByIdAndIndex(tonumber(ntemp),"EffectPara2")
end

function GetCorpsPersonInfo(  )
	return server_CorpsPersonInfo.GetCopyTable()
end

--获取所有的科技等级信息
function GetScienceLevel(  )
	return server_ScienceLevelDB.GetCopyTable()
end

function GetCorpsOneInfo(  )
	return server_CorpsGetOneInfo.GetCopyTable()
end

function GetCorpsInfo( )
	return server_CorpsGetInfoDB.GetCopyTable()
end
--获取军团币以及军团贡献
function GetCorpsMoney(  )
	local tab = GetCorpsInfo()
	local contribute = tab[1][10]
	local corpsMoney = tab[1][11]
	return contribute,corpsMoney
end

function GetCorpsListData()
	return server_CorpsInfoDB.GetCopyTable()
end

function GetCorpsOnlyID( key )
	return server_CorpsInfoDB.GetCorpsID(key)
end

function GetCorpsCountryID(key)
	return server_CorpsInfoDB.GetCountryID(key)
end

function GetCorpsName( key )
	return server_CorpsInfoDB.GetCorpsName(key)
end

function GetIconByLegio( nitemID )
	return legioicon.getFieldByIdAndIndex(nitemID,"iconid")
end

function GetIconDataID( nitemID )
	local iconid = legioicon.getFieldByIdAndIndex(nitemID,"iconid")
	return resimg.getFieldByIdAndIndex(iconid,"icon_path")
end

--获取英雄头像路径
function GetHeadImgPath( nHeadID )
	local headID = 0
	if nHeadID == nil then
		headID = server_mainDB.getMainData("nHeadID")
	else
		headID = nHeadID
	end
	headID = 1
	return resimg.getFieldByIdAndIndex(headID,"icon_path")
end

function GetAllCorpsData( )
	return server_CorpsGetListDB.GetCopyTable()
end

function GetIconTableByFile()
	return legioicon.getTable()
end

function getDataById( nitemID )
	return legioicon.getDataById(nitemID)
end

function GetimsgDataTable(  )
	return resimg.getTable()
end

function GetIndexByField( FileName )
	return resimg.getIndexByField(FileName)
end

function GetIndexByFieldLogio(FileName )
	return legioicon.getIndexByField(FileName)
end

--获取军团成员列表
function GetMemberList(  )
	return server_CorpsMember.GetCopyTable()
end

--获取当前页数
function GetnPageNum(  )
	return server_CorpsInfoDB.GetPageNum()
end
--获取服务器返回总页数
function GetnTotalNum(  )
	return server_CorpsInfoDB.GetTotalNum()
end

--获取军团动态信息
function GetCorpsDynamicInfo(  )
	return server_CorpsDynamicDB.GetCopyTable()
end

function GetShenShuArt( ntemp )
	return globedefine.getFieldByIdAndIndex("ShenShuArt","Para_1")
end

function GetCorpsCamp(  )
	return globedefine.getDataById("CorpsCamp")
end

function GetPowerBeishu(  )
	return globedefine.getFieldByIdAndIndex("CorpsCamp","Para_4")
end
--军团消耗
function GetCorpsConsume( ntemp )
	return consume.getDataById(ntemp)
end

function GetConsumName( ntemp )
	local tab = GetCorpsConsume(ntemp)
	local name = item.getFieldByIdAndIndex(tab[3],"name")
	return name
end

--获取军团国家ID
function GetCorpsCountry(  )
	return server_CorpsGetInfoDB.GetCorpsCountry()
end

function GetEffectPara( ntempid )
	return effect.getDataById(ntempid)
end

function GetScienceDataByID( nTempID )
	return technolog.getDataById(nTempID)
end

function GetSciencePriData( nTempID )
	local tableData = effect.getDataById(nTempID)--通过ID获取食堂效果信息
	local priTab = tableData[2]--获取初级食堂的id
	local tableData1 = technolog.getDataById(priTab)--获取初级食堂效果ID对应的信息
	local tableData2 = effect.getDataById(tableData1[10])
	local tableData3 = pointreward.getDataById(tableData2[2])
	return tableData3[1], tableData3[2]
end

function GetScienceMiddleData( nTempID )
	local tableData = effect.getDataById(nTempID)--通过ID获取食堂效果信息
	local priTab = tableData[3]--获取中级食堂的id
	local tableData1 = technolog.getDataById(priTab)--获取中级食堂效果ID对应的信息
	local tableData2 = effect.getDataById(tableData1[10])
	local tableData3 = pointreward.getDataById(tableData2[2])
	return tableData3[1], tableData3[2]
end

function GetScienceGaojiData( nTempID )
	local tableData = effect.getDataById(nTempID)--通过ID获取食堂效果信息
	local priTab = tableData[4]--获取高级食堂的id
	local tableData1 = technolog.getDataById(priTab)--获取高级食堂效果ID对应的信息
	local tableData2 = effect.getDataById(tableData1[10])
	local tableData3 = pointreward.getDataById(tableData2[2])
	return tableData3[1], tableData3[2]
end

--获取图标信息
function GetRewardIconPath( nTempID )
	local tableDataImg = coin.getDataById(nTempID)
	local imgPath = resimg.getFieldByIdAndIndex(tableDataImg[2],"icon_path")
	local name = tableDataImg[1]
	return imgPath,name
end

--获取消耗类型信息
function GetMessConsumeMiddleInfo( nTempID )
	local tableData = effect.getDataById(nTempID)--通过ID获取食堂效果信息
	local priTab = tableData[3]--获取中级食堂的id
	local tableData1 = technolog.getDataById(priTab)--获取中级食堂效果ID对应的信息
	local tableData2 = effect.getDataById(tableData1[10])
	local tableData3 = consume.getDataById(tableData2[3])--消耗数据
	return tableData3[2], tableData3[3]
end

function GetMessConsumeBigInfo( nTempID )
	local tableData = effect.getDataById(nTempID)--通过ID获取食堂效果信息
	local priTab = tableData[4]--获取中级食堂的id
	local tableData1 = technolog.getDataById(priTab)--获取中级食堂效果ID对应的信息
	local tableData2 = effect.getDataById(tableData1[10])
	local tableData3 = consume.getDataById(tableData2[3])--消耗数据
	return tableData3[2], tableData3[3]
end

function GetArrayData( nTempID )
	return technolog.getDataById(nTempID)
	--return Technolog.getArrDataByField(nTempID,"TechDes")
end
--获取神树增长时间间隔
function GetTimeInterval( nLevel )
	local tabTeech = {}
	for i=1,10 do
		local ArrayData = GetArrayData(i)
		table.insert(tabTeech,ArrayData)
	end
	local tabTreed = tabTeech[1]
	local times = effect.getFieldByIdAndIndex(tabTreed[10],"EffectPara1")
	return times
end

function GetCreateCorpsConsumName(  )
	local tab = GetCorpsCamp()

	local tabConsumType = consume.getFieldByIdAndIndex(tab[1],"Consume_Type_1")
	local n_name = nil
	if tonumber(tabConsumType) < 20 then
		n_name = coin.getFieldByIdAndIndex(tabConsumType,"Name")
	else
		n_name = item.getFieldByIdAndIndex(tabConsumType,"name")
	end
	return n_name
end

function CheckTechTime( tab )
	for key,value in pairs(tab) do
		if tonumber(value["m_time"]) ~= 0 then
			return true
		end
	end
	return false
end

function GetGodTreeData(  )
	local tab = globedefine.getDataById("Legio_ShenShu")
	local item_img = item.getFieldByIdAndIndex(tab[4],"res_id")
	local path_item = resimg.getFieldByIdAndIndex(item_img,"icon_path")
	return tab[4],tab[5],path_item
end

function GetIndexByTag( nTag )
	local n_Index = 0
	if nTag == 1 then
		n_Index = 14017
	elseif nTag == 2 then
		n_Index = 14018
	elseif nTag == 3 then
		n_Index = 14019
	elseif nTag == 4 then
		n_Index = 14020
	elseif nTag == 5 then
		n_Index = 14021
	elseif nTag == 6 then
		n_Index = 14022
	elseif nTag == 7 then
		n_Index = 14023
	elseif nTag == 8 then
		n_Index = 14024
	elseif nTag == 9 then
		n_Index = 14025
	elseif nTag == 10 then
		n_Index = 14026
	elseif nTag == 11 then
		n_Index = 14027
	end
	return n_Index
end
