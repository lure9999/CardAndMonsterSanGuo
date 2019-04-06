require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/serverDB/server_mainDB"

module("LuckyDrawLogic", package.seeall)

local getMainData			= server_mainDB.getMainData
local GetConsumeTab			= ConsumeLogic.GetConsumeTab
local GetConsumeItemData	= ConsumeLogic.GetConsumeItemData
local CreateTipLayerManager		= TipCommonLayer.CreateTipLayerManager

function GetPubIndex( nPubType )
	local nLevel = tonumber(getMainData("level"))
	if nPubType==PubType.Sliver then
		return math.ceil(nLevel/15)
	else
		return math.ceil(nLevel/15)+7
	end
end

function GetConsumeResult( nIndex, nCount, nPubType )
	local nConsumeId = pub.getFieldByIdAndIndex(nIndex, "ConsumeID")
	local tabConsume = GetConsumeTab(5, nConsumeId)
	local tabConsumeData = GetConsumeItemData(tabConsume[1].ConsumeID, tabConsume[1].nIdx, tabConsume[1].ConsumeType, tabConsume[1].IncType)
	if nCount == 1 then
		return tabConsumeData.Enough, tabConsumeData.ItemNeedNum
	else
		local nAgio = tonumber(pub.getFieldByIdAndIndex(nIndex, "Agio"))
		local nItemNeedNum = tabConsumeData.ItemNeedNum*10*nAgio
		if nPubType == PubType.Sliver then
			return getMainData("silver") >= nItemNeedNum, nItemNeedNum
		else
			return getMainData("gold") >= nItemNeedNum, nItemNeedNum
		end
	end
end

function IsHaveGeneral( tabOldGeneral, nGeneralId )
	for key, value in pairs(tabOldGeneral) do
        if tonumber(value["ItemID"]) == tonumber(nGeneralId) then
            return true
        end
    end
    return false
end

function GetSliverPubTime( )
	return tonumber(globedefine.getFieldByIdAndIndex("SilverPub", "Para_2"))*60*60
end

function GetGoldPubTime( )
	return tonumber(globedefine.getFieldByIdAndIndex("GoldPub", "Para_2"))*60*60
end

function HandleTipLayer( nPubType )

	local function GoVip( nResult )
		if nResult == false then
			MainScene.GoToVIPLayer( 0 )
		end
	end

	local pManager = CreateTipLayerManager()
	if nPubType==PubType.Sliver then
		pManager:ShowCommonTips(1003,nil)
		pManager = nil
	else
		pManager:ShowCommonTips(1002,GoVip)
		pManager = nil
	end
end