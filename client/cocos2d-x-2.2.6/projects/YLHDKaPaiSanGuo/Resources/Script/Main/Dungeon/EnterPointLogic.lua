require "Script/Common/Common"
require "Script/Common/CommonData"

module("EnterPointLogic", package.seeall)

local GetItemPathByTempID 					= ItemData.GetItemPathByTempID
local GetItemColorPathByTempID   			= ItemData.GetItemColorPathByTempID

function GetRewardItemData( nRewardItemId )
	local tabRewardItemData = {}
	tabRewardItemData.IconPath = GetItemPathByTempID(nRewardItemId)
	tabRewardItemData.ItemColor = GetItemColorPathByTempID(nRewardItemId)
	return tabRewardItemData
end