
--奖励通用的接口界面
module("RewardLogic", package.seeall)

require "Script/serverDB/pointreward"
require "Script/serverDB/coin"
require "Script/serverDB/resimg"
require "Script/serverDB/item"
require "Script/serverDB/lottery"







local function GetCoinTable(nID)
	local tableCoin = {}
	for i=1,5 do
		local coinID = pointreward.getFieldByIdAndIndex(nID,"CionID_"..i)
		if tonumber(coinID)>0 then
			local tableCoin_Per = {}
			local coinResID = coin.getFieldByIdAndIndex(coinID,"ResID")
			tableCoin_Per.CoinID   = coinID
			tableCoin_Per.CoinPath = resimg.getFieldByIdAndIndex(coinResID,"icon_path")
			tableCoin_Per.CoinName = tostring(coin.getFieldByIdAndIndex(coinID, "Name"))
			tableCoin_Per.CoinNum = pointreward.getFieldByIdAndIndex(nID,"Number_"..i)
			if tonumber(coinID) == 1 then
				tableCoin_Per.CoinScale = 0.5
			else
				tableCoin_Per.CoinScale = 1.0
			end
			table.insert(tableCoin,tableCoin_Per)
		end
		
	end
	
	return tableCoin
end	
local function GetItemTable(nID)
	local tableItem = {}
	for i=1,10 do
		
		local itemID = pointreward.getFieldByIdAndIndex(nID,"ItemID_"..i)
		if tonumber(itemID)>0 then
			local tableItem_Per = {}
			local itemResID = item.getFieldByIdAndIndex(itemID,"res_id")
			tableItem_Per.ItemID   = itemID 
			tableItem_Per.ItemPath = resimg.getFieldByIdAndIndex(itemResID,"icon_path")
			tableItem_Per.ItemName = tostring(item.getFieldByIdAndIndex(itemID, "name"))
			tableItem_Per.ItemNum  = pointreward.getFieldByIdAndIndex(nID,"ItemNum_"..i)
			table.insert(tableItem,tableItem_Per)
		end
		
	end
	return tableItem
end

--参数说明
--rID 奖励的规则
function GetRewardTable(rID)
	
	local tableReward = {}
	table.insert(tableReward,GetCoinTable(rID))
	table.insert(tableReward,GetItemTable(rID))
	return tableReward
end

local function GetLetteryTable(nRID)
	local tableBase = {}
	for i=1,5 do 
		local CoinID = lottery.getFieldByIdAndIndex(nRID,"CionID_"..i)
		
		if tonumber(CoinID)>0 then
			local CoinNum = lottery.getFieldByIdAndIndex(nRID,"Number_"..i)
			local tabTemp = {}
			tabTemp.coinType = CoinID
			tabTemp.coinNum = CoinNum
			tabTemp.iconPath = resimg.getFieldByIdAndIndex(CoinID,"icon_path")
			table.insert(tableBase,tabTemp)
		end
	end
	return tableBase
end
--夺宝奖励表的基础奖励nRID奖励ID
function GetBaseRewardTable(nRID)
	return GetLetteryTable(nRID)
end