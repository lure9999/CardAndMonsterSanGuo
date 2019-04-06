require "Script/serverDB/item"
require "Script/serverDB/shopitem"
require "Script/serverDB/goods"
require "Script/serverDB/server_shopDB"
require "Script/serverDB/coin"
require "Script/serverDB/resimg"
module("ShopData", package.seeall)

local nShopMoney = {
	n_Money  = 0,
	n_Sliver = 1,
	n_Gold   = 2,
	n_BiWuMoney = 3,
	n_CorpsMoney = 4,

}

local nMAX = 100

function GetShopName( nShopId )
	return shop.getFieldByIdAndIndex(nShopId, "ShopName")
end

function GetShopHeadPath( nShopId )
	local nPath = nil
	nPath = resimg.getFieldByIdAndIndex(10000,"icon_path")
	return nPath
end

function GetShopTxtById( nShopId )
	return shop.getFieldByIdAndIndex(nShopId, "Talk_IDGroup")
end

function GetShopSoldOutById( nShopId )
	return shop.getFieldByIdAndIndex(nShopId, "SoldOut_IDGroup")
end

function GetRefreshTimeByIdx( nShopId, nIdx )
	return tonumber(shop.getFieldByIdAndIndex(nShopId, "RefreshTime" .. nIdx))
end

function GetRefreshShopConsumeId( nShopId )
	return tonumber(shop.getFieldByIdAndIndex(nShopId, "ConsumptionID"))
end
--添加消耗的物品icon
function GetExpendIconPath( consumID)
	local path_money = nil
	local nPath = nil
	if tonumber(consumID) <= nMAX then
		local coinpathID = coin.getFieldByIdAndIndex(consumID,"ResID")
		nPath = resimg.getFieldByIdAndIndex(coinpathID,"icon_path")
	else
		local coinpathID = item.getFieldByIdAndIndex(consumID,"res_id")
		nPath = resimg.getFieldByIdAndIndex(coinpathID,"icon_path")
	end
	return nPath
end
function GetItemName( nItemId )
	return item.getFieldByIdAndIndex(nItemId, "name")
end

function GetConsumTypeName( nItemId )
	return coin.getFieldByIdAndIndex(nItemId, "Name")
end

function GetItemQuality( nItemId )
	return tonumber(item.getFieldByIdAndIndex(nItemId,"pinzhi"))
end

function GetItemColorIcon( nItemId )
	local nQuality = GetItemQuality(nItemId)
	local strQuality = string.format("Image/imgres/common/color/item_pz%d.png",nQuality)
	return strQuality
end

local function GetItemResId( nItemId )
	return tonumber(item.getFieldByIdAndIndex(nItemId, "res_id"))
end

function GetItemIcon( nItemId )
	local nResId = GetItemResId(nItemId)
	return resimg.getFieldByIdAndIndex(nResId, "icon_path")
end

-- 最大数量
function GetItemReserves( nItemId )
	local tabTemp = goods.getArrDataByField("ItemID", nItemId)
	return tonumber(tabTemp[1][goods.getIndexByField("Reserves")])
end

function GetAllItemInfoShop_6( nShopId )
	local tabTemp = goods.getArrDataByField("ShopID", nShopId)
	return tabTemp
	
end

function GetShopRefreshTimes( nShopId )
	return tonumber(shop.getFieldByIdAndIndex(nShopId, "RefreshNumber"))
end

function GetShopItemCoinType( nItemId )
	return tonumber(goods.getFieldByIdAndIndex(nItemId, "ConsumptionType"))
end

function GetShopItemCondition( nItemId )
	return tonumber(goods.getFieldByIdAndIndex(nItemId, "Conditions"))
end

function GetShopItemConditionValue( nItemId )
	return tonumber(goods.getFieldByIdAndIndex(nItemId, "ConditionsParameter"))
end

function GetItemData( nShopId, nGrid )
	return goods.getArrDataBy2Field("ShopID", nShopId, "GoodsIndexes", nGrid)
end

function GetConditionType( nShopId, nGrid )
	local tabGoods = GetItemData(nShopId, nGrid)
end

function GetShopTipTextById( nId )
	return txt.getFieldByIdAndIndex(nId, "Txt")
end

function GetGridNum( nBeginIdx, nEndIdx )
	local n_selected = 1
	if nBeginIdx == 1 then
		n_selected = 1
	elseif nBeginIdx == 9 then
		n_selected = 2
	elseif nBeginIdx == 17 then
		n_selected = 3
	elseif nBeginIdx == 25 then
		n_selected = 4
	elseif nBeginIdx == 33 then
		n_selected = 5
	elseif nBeginIdx == 41 then
		n_selected = 6
	elseif nBeginIdx == 49 then
		n_selected = 7
	end
	return n_selected
end

function GetItemPath( nIndex )
	--print(nIndex)
	local tabID = item.getFieldByIdAndIndex(nIndex,"res_id")
	return resimg.getDataById(tabID)
end
