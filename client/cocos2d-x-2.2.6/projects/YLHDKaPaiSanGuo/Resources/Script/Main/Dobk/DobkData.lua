--夺宝数据celina

module("DobkData", package.seeall)

require "Script/serverDB/server_dobkDB"
require "Script/serverDB/item"
require "Script/serverDB/server_itemDB"
require "Script/serverDB/server_dobkEnemyListDB"
require "Script/serverDB/server_mainDB"
require "Script/serverDB/server_dobkResultData"
require "Script/serverDB/plunderitem"
require "Script/Common/RewardLogic"
require "Script/serverDB/globedefine"
require "Script/serverDB/server_dobkOpenBox"
require "Script/serverDB/server_equipDB"


local function GetColorByItemID(nItemID)
	return item.getFieldByIdAndIndex(nItemID,"pinzhi")
end
local function SortSPData(tabData)
	if tabData ==nil then
		return 
	end
	local function sortColorDes(a,b)
		return GetColorByItemID(a.itemID)>GetColorByItemID(b.itemID)
	end
	table.sort(tabData,sortColorDes)
	return tabData
end
--获得碎片的数据
function GetTabSPData(nType)
	--排序
	
	return SortSPData( server_dobkDB.GetSPData(nType) )
end

function GetItemName(nTempID)
	return item.getFieldByIdAndIndex(nTempID,"name")
end
function GetItemCount(nTempID,nType)
	--local tabData = 
	local dataTab = GetTabSPData(nType)
	for key,value in pairs(dataTab) do 
		if tonumber(value.itemID) == tonumber(nTempID) then
			return value.count
		end
	end
	return 0
end
function GetItemNeedCount(nTempID)
	return item.getFieldByIdAndIndex(nTempID,"event_para_A")
end
--得到消耗的耐力
function GetExpendNL()
	--现在得到的是消耗的ID
	--[[local consumeTab = ConsumeLogic.GetConsumeTab(5,globedefine.getFieldByIdAndIndex("Plunder","Para_1"))
	--这里知道知道是消耗一种，如果多种会错误
	for i=1,table.getn(consumeTab) do 
		local tableExpendData = ConsumeLogic.GetConsumeItemData(consumeTab[i].ConsumeID,consumeTab[i].nIdx,consumeTab[i].ConsumeType,consumeTab[i].IncType)
		return  tableExpendData.ItemNeedNum
	end]]--
	return globedefine.getFieldByIdAndIndex("Plunder","Para_1")
	--return 0
end
function GetPlayerNaili()
	return tonumber(server_mainDB.getMainData("naili"))
end
--得到幸运草的数量（幸运值）
function GetLuckNum()
	return server_dobkDB.GetLuckyCloverNum()
end
function GetBoxNum()
	return server_dobkDB.GetBoxNum()
end
function GetBoxExp()
	return server_dobkDB.GetBoxExp()
end
--得到掠夺对象表 
function GetDobkListData()
	return server_dobkEnemyListDB.GetCopyTable()
end

--得到我的形象ID
function GetPlayerModelID()
	--[[if server_mainDB.getMainData("nModeID")== 0 then
		--Pause()
	end]]--
	return server_mainDB.getMainData("nModeID")
end
--得到抽奖的ID
function GetRewardTabData(nType,nTempID)
	local tabCol = plunderitem.getArrDataBy2Field("Type",nType+1,"ItemID",nTempID)
	local nIndex = plunderitem.getIndexByField("LotteryID")
	return RewardLogic.GetBaseRewardTable(tabCol[1][nIndex])
	
end
--得到抽奖的数据
function GetRewardData(nIndex)
	return server_dobkResultData.GetSPData(nIndex)
end
function GetChouZhongItemID(nIndex)
	local tabData = server_dobkResultData.GetSPData(nIndex)
	local nItemID = tabData[1].itemID
	
	return nItemID
end
function GetBDobkWin(nIndex)
	return server_dobkResultData.GetBDobkWin(nIndex)
end

function GetBoxTabData()
	return server_dobkOpenBox.GetCopyTable()
end
function GetItemGridByID(nTempID)
	return server_itemDB.GetGird(nTempID)
end

function GetResultData()
	return server_dobkResultData.GetCopyTable()
end
function GetCurEquipNum()
	return tonumber(server_equipDB.GetCount())
end
--是否抢到碎片
function GetbSpByIndex(nIndex)
	
	return server_dobkResultData.GetBDobkWin(nIndex)
end
function GetTenRewardData(nIndex,nGetItemID)
	local tabTenData = {}
	if 	GetbSpByIndex(nIndex) == true then
		local tableGet = {}
		tableGet.itemID = nGetItemID
		table.insert(tabTenData,tableGet)
	end
	local tableChouJiang  = GetRewardData(nIndex)
	table.insert(tabTenData,tableChouJiang[1])
	return tabTenData
end

function GetItemTypeByID(nItemID)
	return item.getFieldByIdAndIndex(nItemID,"item_type")
end