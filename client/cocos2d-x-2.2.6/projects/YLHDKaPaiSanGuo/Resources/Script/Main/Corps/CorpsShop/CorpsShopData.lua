require "Script/serverDB/item"
require "Script/serverDB/shopitem"
require "Script/serverDB/goods"
require "Script/serverDB/server_shopDB"
require "Script/serverDB/coin"
require "Script/serverDB/resimg"

module("CorpsShopData", package.seeall)

function GetShopName( nShopId )
	return shop.getFieldByIdAndIndex(nShopId, "ShopName")
end

function GetRefreshTimeByIdx( nShopId, nIdx )
	return tonumber(shop.getFieldByIdAndIndex(nShopId, "RefreshTime" .. nIdx))
end

function GetRefreshShopConsumeId( nShopId )
	return tonumber(shop.getFieldByIdAndIndex(nShopId, "ConsumptionID"))
end
--添加消耗的物品icon
function GetExpendIconPath( nItemId )
	local tabTemp = goods.getArrDataByField("ItemID", nItemId)
	local coinID = tabTemp[1][goods.getIndexByField("ConsumptionType")]
	local resID = coin.getFieldByIdAndIndex(coinID,"ResID")
	return resimg.getFieldByIdAndIndex(resID,"icon_path")
end
function GetItemName( nItemId )
	return item.getFieldByIdAndIndex(nItemId, "name")
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

function GetItemData( nShopId, nItemId )
	return goods.getArrDataBy2Field("ShopID", nShopId, "ItemID", nItemId)
end

function GetShopTipTextById( nId )
	return txt.getFieldByIdAndIndex(nId, "Txt")
end