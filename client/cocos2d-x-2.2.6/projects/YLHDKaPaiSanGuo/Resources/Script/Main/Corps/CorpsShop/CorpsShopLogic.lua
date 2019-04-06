require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Corps/CorpsShop/CorpsShopData"
require "Script/serverDB/txt"
module("CorpsShopLogic",package.seeall)

local BuyCondition =
					{
						None	= 0,
						Level	= 1,
						VipLv	= 2,
						Officer = 3
					}



local GetRefreshTimeByIdx				= CorpsShopData.GetRefreshTimeByIdx
local GetTimeCurUInt					= UnitTime.GetTimeCurUInt
local GetTimeUInt 						= UnitTime.GetTimeUInt
local GetTableByGrid					= server_shopDB.GetTableByGrid

local GetShopItemCoinType				= CorpsShopData.GetShopItemCoinType
local GetShopItemCondition				= CorpsShopData.GetShopItemCondition
local GetShopItemConditionValue			= CorpsShopData.GetShopItemConditionValue
local GetItemData						= CorpsShopData.GetItemData
local GetShopTipTextById				= CorpsShopData.GetShopTipTextById

function GetShopRefreshTime(nShopId)
	local strTime = nil
	for i=1,4 do
		local nRefreshTime = GetRefreshTimeByIdx(nShopId, i)
		local strTemp = string.format("%02d:%02d:%02d", math.floor(nRefreshTime/100), math.floor(nRefreshTime%100), 0)
		local uTime = GetTimeUInt(strTemp)
		local cTime = GetTimeUInt(GetTimeCurUInt())
		if cTime < uTime then
		    strTime = strTemp
		    break
		else
		   	strTime = "00:00:00"
		end
	end
	if strTime == "00:00:00" then
		local nRefreshTime = GetRefreshTimeByIdx(nShopId, 1)
		strTime = string.format("%02d:%02d:%02d", math.floor(nRefreshTime/100), math.floor(nRefreshTime%100), 0)
		
	end
	return strTime
end

local function CheckBuyondition( nCondition, nConditionValue )
	if nCondition==BuyCondition.None then
		return true
	elseif nCondition==BuyCondition.Level then
		if CommonData.g_MainDataTable.level>= nConditionValue then
			return true
		end
	elseif nCondition==BuyCondition.VipLv then
		return true
	elseif nCondition==BuyCondition.Officer then
		return true
	end
	return false
end

local function GetValueByField( tabItem, FieldName )
	return tonumber(tabItem[1][goods.getIndexByField(FieldName)])
end

local function GetMaxCanBuyNumByCoinName( nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, strCoinName )
	local nNum = 1
	local nTotalPrice = 0
	local bEnough = true
	--[[print(nCurPrice)
	print(nIncrement)
	print(nItemNum)
	print("***************")]]--
	local perPrice = 0 
	for i=1, nItemNum do
		--[[if nIncrement>0 then
			if nTotalPrice<nMaxPrice then
				nCurPrice = nCurPrice+nIncrement
			else
				nCurPrice = nMaxPrice
			end
		end
		nNum = i
		nTotalPrice = nNum * nCurPrice]]--
		--修改算法 
		
		if nIncrement>0 then
			--[[if nTotalPrice<nMaxPrice then
				perPrice = nCurPrice+nIncrement*(i-1)
			else
				perPrice = nMaxPrice
			end]]
			perPrice = math.min(nCurPrice+nIncrement*(i-1),nMaxPrice)
		else
			nNum = i
			nTotalPrice = nNum * nCurPrice
		end
		nTotalPrice = nTotalPrice + perPrice
		if nTotalPrice>CommonData.g_MainDataTable[strCoinName] then
			-- nNum = i - 1
			-- nTotalPrice = nNum  * nCurPrice
			bEnough = false
		end
		-- if nNum > nMaxNum then
		-- 	nNum = nMaxNum
		-- 	nTotalPrice = nNum * nCurPrice
		-- 	break
		-- end
		-- if nTotalPrice>CommonData.g_MainDataTable[strCoinName] then
		-- 	nNum = i - 1
		-- 	nTotalPrice = nNum * nCurPrice
		-- 	bEnough = false
		-- 	break
		-- else
		-- 	if nNum> nMaxNum then
		-- 		nNum = nMaxNum
		-- 		nTotalPrice = nNum * nCurPrice
		-- 		break
		-- 	end

		-- end
	end
	--[[print(nTotalPrice)
	Pause()]]--
	return nNum, nTotalPrice, bEnough
end

-- 获得物品图标
local function GetItemIconByResId( nResId )
	if nResId>-1 then
		return resimg.getFieldByIdAndIndex(nResId, "icon_path")
	else
		return nil
	end
end

local function GetCoinIcon( nCoinType )
	local nResId = tonumber(coin.getFieldByIdAndIndex(nCoinType, "ResID"))
	if nResId>-1 then
		return resimg.getFieldByIdAndIndex(nResId, "icon_path")
	else
		return nil
	end
end

local function GetMaxCanBuyNumByCoinType( nIncrement, nCoinType,  nCurPrice, nMaxPrice, nItemNum, nMaxNum )
	local nNum = 0
	local nTotalPrice = 0
	local bEnough = true
	if nCoinType == CoinType.Sliver then
		nNum, nTotalPrice, bEnough = GetMaxCanBuyNumByCoinName(nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, "silver")
	elseif nCoinType == CoinType.Gold then
		nNum, nTotalPrice, bEnough = GetMaxCanBuyNumByCoinName(nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, "gold")
	elseif nCoinType == CoinType.PVP then

	elseif nCoinType == CoinType.Family then

	end
	local tabBuyItemData = {}
	tabBuyItemData.Count = nNum
	tabBuyItemData.TotalPrice = nTotalPrice
	tabBuyItemData.Enough = bEnough
	tabBuyItemData.CoinType = nCoinType
	tabBuyItemData.CoinIcon = GetCoinIcon(nCoinType)
	return tabBuyItemData
end

function GetTradeData( nShopId, nItemId, nItemNum, nCurPrice )
	local tabItem = GetItemData(nShopId, nItemId)
	local nCondition = GetValueByField(tabItem, "Conditions")
	local nConditionValue = GetValueByField(tabItem, "ConditionsParameter")

	if CheckBuyondition(nCondition, nConditionValue)==false then
		return
	end
	local nIncrement =GetValueByField(tabItem, "Increment")
	local nCoinType = GetValueByField(tabItem, "ConsumptionType")
	local nMaxPrice = GetValueByField(tabItem, "Max")
	local nMaxNum = GetValueByField(tabItem, "Reserves")
	return GetMaxCanBuyNumByCoinType(nIncrement, nCoinType, nCurPrice, nMaxPrice, nItemNum, nMaxNum)
end

function GetTradeTipInfo( nCoinType )
	local  strTip = nil
	if nCoinType == CoinType.Sliver then
		strTip = "银币不足！"
	elseif nCoinType == CoinType.Gold then
		strTip = "金币不足！"
	elseif nCoinType == CoinType.PVP then
		strTip = "竞技币不足！"
	elseif nCoinType == CoinType.Family then
		strTip = "家族币不足！"
	end
	return strTip
end