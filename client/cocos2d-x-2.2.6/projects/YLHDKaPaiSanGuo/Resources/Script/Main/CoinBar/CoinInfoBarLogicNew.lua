
--提示条的逻辑 celina
module("CoinInfoBarLogicNew", package.seeall)

require "Script/serverDB/coin"
require "Script/serverDB/resimg"
require "Script/serverDB/item"


ENUM_TYPE_BAR = {
	ENUM_TYPE_BAR_COIN = 1,
	ENUM_TYPE_BAR_ITEM = 2,
	ENUM_TYPE_BAR_FIGHT = 3,
}

function GetCoinPathByID(nCoinID)
	if tonumber(nCoinID )<=0 then
		return nil
	end
	local resID = coin.getFieldByIdAndIndex(nCoinID,"ResID")
	return resimg.getFieldByIdAndIndex(resID,"icon_path")

end

function GetItemPathByID(nItemID)
	if nItemID <= 0 then
		return nil 
	end
	print(nItemID)
	local resID = item.getFieldByIdAndIndex(nItemID,"res_id")
	return resimg.getFieldByIdAndIndex(resID,"icon_path")
end

function GetPathByTypeID(nType,nID)
	local strPath = nil
	if tonumber(nType) == ENUM_TYPE_BAR.ENUM_TYPE_BAR_COIN then
		strPath = GetCoinPathByID(nID)
	end
	if tonumber(nType) == ENUM_TYPE_BAR.ENUM_TYPE_BAR_ITEM then
		
		strPath = GetItemPathByID(nID)
	end
	return strPath
end
function GetCoinNum(sNum)
	return server_mainDB.getMainData(sNum)
end

--更新值 nIndex需要更新第几个
local function GetCoinNumByID(nCoinID)
	local nType =tonumber(nCoinID) 
	local nCoinNum = 0
	--银币
	if nType == 1 then
		nCoinNum = GetCoinNum("silver")
	elseif nType == 2 then
		nCoinNum = GetCoinNum("gold")
	elseif nType == 3 then
		nCoinNum = GetCoinNum("tili").. "/" ..GetCoinNum("max_tili") 
	elseif nType == 4 then
		nCoinNum = GetCoinNum("naili").."/"..GetCoinNum("max_naili")
	elseif nType == 5 then
		nCoinNum = GetCoinNum("exp") 
	elseif nType == 6 then
		nCoinNum = GetCoinNum("GeneralExpPool") 
	--[[elseif nType == 8 then
		nCoinNum = GetCoinNum("naili") ]]--
	elseif nType == 9 then
		nCoinNum = GetCoinNum("BiWu_Prestige") 
	elseif nType == 10 then
		nCoinNum = GetCoinNum("Family_Prestige")
	elseif nType == 13 then
		--军团币添加
		nCoinNum = CorpsScene.GetCorpsMoney()
	--[[elseif nType == 12 then
		nCoinNum = GetCoinNum("naili")
	elseif nType == 13 then
		nCoinNum = GetCoinNum("naili")
	elseif nType == 14 then
		nCoinNum = GetCoinNum("naili")]]--
	elseif nType == 17 then
		nCoinNum = GetCoinNum("XingHun")
	end
	return nCoinNum
end
local function GetItemNumByID(nID)
	return ItemData.GetNumByTempID(nID)
end
function GetNumOnBarByType(nType,nID)
	local nNum = 0
	if tonumber(nType) == ENUM_TYPE_BAR.ENUM_TYPE_BAR_COIN then
		nNum = GetCoinNumByID(nID)
	end
	if tonumber(nType) == ENUM_TYPE_BAR.ENUM_TYPE_BAR_ITEM then
		nNum = GetItemNumByID(nID)
	end
	if tonumber(nType) == ENUM_TYPE_BAR.ENUM_TYPE_BAR_FIGHT then
		nNum = GetCoinNum("power")
	end
	return nNum
end