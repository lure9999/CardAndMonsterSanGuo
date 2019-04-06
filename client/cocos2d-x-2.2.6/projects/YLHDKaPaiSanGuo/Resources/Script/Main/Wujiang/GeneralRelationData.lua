require "Script/Common/Common"
require "Script/Main/Wujiang/GeneralBaseData"

module("GeneralRelationData", package.seeall)

MAX_RELATION_COUNT 		= 5
MAX_RELATION_ITEM_COUNT = 4

RelationType =
{
	General = 1,
	Equip 	= 2,
}

-- 武将缘分状态
RelationState =
{
    NotActivted = 0, --未激活
    Solidifying = 1, --固化中
    Solidified  = 2, --已固化
}

--  ItemState
ItemState =
{
    Used = 0,		-- 已使用
    UnUse = 1,		-- 未使用
    Piece = 2,		-- 碎片
}

function GetRelationId( nGeneralId, nIdx )
	return tonumber(general.getFieldByIdAndIndex(nGeneralId, "fateID-"..tostring(nIdx)))
end

function GetRelationName( nRelationId )
	return yuanfen.getFieldByIdAndIndex(nRelationId, "YFenName")
end

function GetRelatinoType( nRelationId )
	return tonumber(yuanfen.getFieldByIdAndIndex(nRelationId, "YFenTpye-1"))
end

local function GetRelationAttrId( nRelationId )
	return tonumber(yuanfen.getFieldByIdAndIndex(nRelationId, "AttributID-1"))
end

function GetRelationAttrDes( nRelationId )
	local nAttrId = GetRelationAttrId( nRelationId )
	return  attribute.getFieldByIdAndIndex(nAttrId, "des")
end

function GetRelationMaxSolidVale( nRelationId )
	return tonumber(yuanfen.getFieldByIdAndIndex(nRelationId, "Solidify"))
end

function GetItemNameByTempId( nItemId )
	return  equipt.getFieldByIdAndIndex(nItemId, "Name")
end

function GetEquipIcon( nItemId )
	local nResId = equipt.getFieldByIdAndIndex(nItemId, "AnimationID")
	return resimg.getFieldByIdAndIndex(nResId,"icon_path")
end

function GetEquipColorIcon( nItemId )
	-- bodyColor
	local nColor  = equipt.getFieldByIdAndIndex(nItemId, "Color")
	local strColorIcon =  string.format("Image/imgres/common/color/wj_pz%d.png",nColor)
    return strColorIcon
end
local function GetRelationValue( nRelationId, nIdx )
	return tonumber(yuanfen.getFieldByIdAndIndex(nRelationId, "YFenValue-"..tostring(nIdx)))
end

local function GetRelationPara( nRelationId, nIdx )
	return tonumber(yuanfen.getFieldByIdAndIndex(nRelationId, "YFenPara-"..tostring(nIdx)))
end

function GetRelationItemTab( nRelationId )
	local tabRelationItem = {}
	for i=1, MAX_RELATION_ITEM_COUNT do
		local nItemId = GetRelationValue(nRelationId, i)
		if nItemId>0 then
			local tabTemp = {}
			local nPieceId =  GetRelationPara(nRelationId, i)
			tabTemp.nIdx 	= i
			tabTemp.ItemId 	= nItemId
			tabTemp.PieceId = nPieceId
			table.insert(tabRelationItem, tabTemp)
		end
	end
	return tabRelationItem
end

function GetGeneralRelationIdTab( nGeneralId )
	local tabRelationId = {}
	for i=1, MAX_RELATION_COUNT do
		local nRelationId = GetRelationId(nGeneralId, i)
		if nRelationId>-1 then
			local tabTemp = {}
			tabTemp.nIdx = i
			tabTemp.RelationId = nRelationId
			table.insert(tabRelationId, tabTemp)
		end
	end
	return tabRelationId
end