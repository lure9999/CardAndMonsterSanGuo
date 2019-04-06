require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Mall/ShopData"
require "Script/serverDB/txt"

module("ShopLogic", package.seeall)

local BuyCondition =
					{
						None	= 0,
						Level	= 1,
						VipLv	= 2,
						Officer = 3,
						power   = 1060,
						nLevel  = 1151,

					}




local GetRefreshTimeByIdx				= ShopData.GetRefreshTimeByIdx
local GetTimeCurUInt					= UnitTime.GetTimeCurUInt
local GetTimeUInt 						= UnitTime.GetTimeUInt
local GetTableByGrid					= server_shopDB.GetTableByGrid

local GetShopItemCoinType				= ShopData.GetShopItemCoinType
local GetShopItemCondition				= ShopData.GetShopItemCondition
local GetShopItemConditionValue			= ShopData.GetShopItemConditionValue
local GetItemData						= ShopData.GetItemData
local GetShopTipTextById				= ShopData.GetShopTipTextById
local GetAllItemInfoShop_6              = ShopData.GetAllItemInfoShop_6
local GetExpendIconPath                 = ShopData.GetExpendIconPath
local GetShopTxtById                	= ShopData.GetShopTxtById
local GetShopSoldOutById                = ShopData.GetShopSoldOutById

local nKeys = {
	nKey = "|",
}

function GetTolkIDByShopID( n_ShopID )
	local textTab = GetShopTxtById(n_ShopID)
	local tabData = {}
	local function FindwordKeys( nData )
		local str_num = string.find(nData,nKeys.nKey,1)
		local lengths = string.len(nData)
		local str_word = nil
		local str_word2 = nil
		if str_num ~= nil then
			str_word = string.sub(nData,1,str_num-1)
			str_word2 = string.sub(nData,str_num+1,lengths)
			table.insert(tabData,str_word)
			FindwordKeys(str_word2)
		else
			str_word2 = nData
			table.insert(tabData,str_word2)
		end
	end
	FindwordKeys(textTab)
	return tabData
end

function GetTolkSoldOutByShopID( n_ShopID )
	local textTab = GetShopSoldOutById(n_ShopID)
	local tabData = {}
	local function FindwordKeys( nData )
		local str_num = string.find(nData,nKeys.nKey,1)
		local lengths = string.len(nData)
		local str_word = nil
		local str_word2 = nil
		if str_num ~= nil then
			str_word = string.sub(nData,1,str_num-1)
			str_word2 = string.sub(nData,str_num+1,lengths)
			table.insert(tabData,str_word)
			FindwordKeys(str_word2)
		else
			str_word2 = nData
			table.insert(tabData,str_word2)
		end
	end
	FindwordKeys(textTab)
	return tabData
end

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
	elseif nCondition==BuyCondition.power then
		return true
	elseif nCondition==BuyCondition.nLevel then
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
		nNum, nTotalPrice, bEnough = GetMaxCanBuyNumByCoinName(nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, "BiWu_Prestige")
	elseif nCoinType == CoinType.Family then
		nNum, nTotalPrice, bEnough = GetMaxCanBuyNumByCoinName(nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, "Family_Prestige")
		
	elseif nCoinType == CoinType.CorpsPri then
		nNum, nTotalPrice, bEnough = GetMaxCanBuyNumByCoinName(nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, "Family_Prestige")
	elseif nCoinType == CoinType.BiWuMoney then
		nNum, nTotalPrice, bEnough = GetMaxCanBuyNumByCoinName(nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, "Family_Prestige")
	elseif nCoinType == CoinType.HunJue then
		nNum, nTotalPrice, bEnough = GetMaxCanBuyNumByCoinName(nIncrement, nCurPrice, nMaxPrice, nItemNum, nMaxNum, "Family_Prestige")
			
	end
	local tabBuyItemData = {}
	tabBuyItemData.Count = nNum
	tabBuyItemData.TotalPrice = nTotalPrice
	tabBuyItemData.Enough = bEnough
	tabBuyItemData.CoinType = nCoinType
	tabBuyItemData.CoinIcon = GetExpendIconPath(nCoinType)
	return tabBuyItemData
end

function GetItemCurPrice( nShopId, nGrid, nItemNum )
	local tabItem = GetItemData(nShopId, nGrid)
	local nIncrement =GetValueByField(tabItem, "Increment")
	local nMaxPrice = GetValueByField(tabItem, "Max")
	local nCurPrice = GetValueByField(tabItem, "Number")
	local nNum = 1
	local perPrice = 0 
	perPrice = math.min(nCurPrice + nIncrement*nItemNum,nMaxPrice)
	return perPrice
end

function GetTradeData( nShopId, nItemId, nItemNum, nCurPrice )
	local tabItem = GetItemData(nShopId, nItemId)
	local nCondition = GetValueByField(tabItem, "Conditions")
	local nConditionValue = GetValueByField(tabItem, "ConditionsParameter")

	--[[if CheckBuyondition(nCondition, nConditionValue)==false then
		return
	end]]--
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
		strTip = "比武币不足！"
	elseif nCoinType == CoinType.Family then
		strTip = "军团币不足！"
	end
	return strTip
end

function CheckItemByGrid( tabItem,m_selectedID )
	for key,value in pairs(tabItem) do
		if tonumber(value["ItemID"]) == tonumber(m_selectedID) then
			tab_Grid = value["Grid"]
			return true
		end
	end
	return false
end

function CheckItemByItemID( nGrid ,nShopID)
	local tabShop = GetAllItemInfoShop_6(nShopID)
	local m_tabShop = {}
	
	for key,value in pairs(tabShop) do
		if tonumber(nGrid) == tonumber(value[2]) then
			m_tabShop["ConditionsText"] = value[11]
			m_tabShop["TagImg"] = value[12]
			m_tabShop["Discount"] = value[13]
			m_tabShop["Conditions"] = value[10]
			return m_tabShop
		end
	end
end

function GetAnimationAction( nShopType )
	local Animation11 = nil
	local Animation12 = nil
	if tonumber(nShopType) == 1 then
		Animation11 = "Image/imgres/effectfile/diaochanshangcheng/diaochanshangcheng.ExportJson"
		Animation12 = "diaochanshangcheng"
	elseif tonumber(nShopType) == 2 then
		Animation11 = "Image/imgres/effectfile/biwushop/biwushop.ExportJson"
		Animation12 = "biwushop"
	elseif tonumber(nShopType) == 4 then
		Animation11 = "Image/imgres/effectfile/pandashop/pandashop.ExportJson"
		Animation12 = "pandashop"
	elseif tonumber(nShopType) == 3 then
		Animation11 = "Image/imgres/effectfile/juntuanshop/juntuanshop.ExportJson"
		Animation12 = "juntuanshop"
	end
	return Animation11,Animation12
end