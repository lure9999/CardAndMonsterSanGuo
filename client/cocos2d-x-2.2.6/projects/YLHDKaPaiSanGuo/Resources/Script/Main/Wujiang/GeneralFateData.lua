require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/serverDB/tianming"

module("GeneralFateData", package.seeall)


MAX_STAR_COUNT = 6
MAX_CONSUME_TYPE = 3

local GetConsumeParaAType		= ConsumeLogic.GetConsumeParaAType
local GetConsumeTypeName		= ConsumeLogic.GetConsumeTypeName
local GetConsumeTab				= ConsumeLogic.GetConsumeTab
local GetConsumeItemData		= ConsumeLogic.GetConsumeItemData
local GetItemsData				= ConsumeLogic.GetItemsData

-- 获得天命ID
function GetGeneralTianMingId( nGeneralId )
	return tonumber(general.getFieldByIdAndIndex(nGeneralId, "TianmingID"))
end

-- 获得天命所需等级
function GetTianMingNeedLv( nFateId, nIdx )
	return tonumber(tianming.getFieldByIdAndIndex(nFateId,"TMingLv_"..tostring(nIdx)))
end

-- 获得天命消耗ID
function GetTianMingConsumeId( nFateId, nStar )
	return tonumber(tianming.getFieldByIdAndIndex(nFateId, "Consume_Tian"..tostring(nStar)))
end

-- 获得最大天命值
function GetMaxStars( nFateId )
	return tonumber(tianming.getFieldByIdAndIndex(nFateId, "TMingMax"))
end

-- 获得天命属性ID
function GetTianMingAttrId( nFateId, nIdx )
	return tonumber(tianming.getFieldByIdAndIndex(nFateId, "MingXingID_"..tostring(nIdx)))
end

-- 获得天命属性描述
function GetAttrDes( nFateId, nIdx )
	local nAttrId = GetTianMingAttrId(nFateId, nIdx)
	return attribute.getFieldByIdAndIndex(nAttrId,"des")
end