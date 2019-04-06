-- 武将丹药的数据层

require "Script/Common/Common"
require "Script/serverDB/danyao"

module("GeneralDanYaoData", package.seeall)

MAX_DANYAO_COUNT = 9
MAX_JINDAN_ATTR_COUNT = 4
MAX_DANYAO_ATTR_COUNT = 9
MAX_CONSUMETYPE_COUNT = 5

-- 0 -- 生命
-- 1 -- 攻击
-- 2 -- 物防
-- 3 -- 法防
tabAttrType = {0,1,2,3}

ActiviteState =
{
	Activited 	= 0,
	CanActivite = 1,
	NotActivite = 2,
}

-- 获得前置丹药服务器数据
function GetDanYaoServerData( nGrid )
	local tabGeneral = server_generalDB.GetTableByGrid(nGrid)
	return tabGeneral["Info02"]["danyaoLv"], tabGeneral["Info02"]["danyaoindex"]
end

-- 获得丹药消耗ID
function GetDanYaoConsumeId( nLv, nIdx )
	return tonumber(danyao.getFieldByIdAndIndex(nLv+1, "Dan"..tostring(nIdx).."ConsumeID"))
end

-- 获得丹药物品ID
function GetDanYaoItemId( nLv, nIdx )
	return tonumber(danyao.getFieldByIdAndIndex(nLv+1, "Dan"..tostring(nIdx).."ItemID"))
end

-- 获得丹药属性ID
function GetDadnYaoAttrId( nLv, nIdx )
	return tonumber(danyao.getFieldByIdAndIndex(nLv+1, "Dan"..tostring(nIdx).."AttributID"))
end

-- 获得丹药属性名称
function GetDanYaoAttrName( nAttrId )
	return attribute.getFieldByIdAndIndex(nAttrId, "name")
end

-- 获得丹药属性数值
function GetDanYaoAttrValue( nAttrId )
	return tonumber(attribute.getFieldByIdAndIndex(nAttrId, "value"))
end

function GetDanYaoAttrType( nAttrId )
	return tonumber(attribute.getFieldByIdAndIndex(nAttrId, "type"))
end
-- 获得丹药图标
function GetDanYaoIcon( nLv, nIdx)
	if nLv >= 10 then nLv = 9 end
	local nItemID = GetDanYaoItemId( nLv+1, nIdx )
	local nResID = tonumber(item.getFieldByIdAndIndex(nItemID, "res_id"))
	return resimg.getFieldByIdAndIndex(nResID, "icon_path")
end

-- 获得丹药名称
function GetDanYaoName( nItemId )
	return item.getFieldByIdAndIndex(nItemId, "name")
end

function GetDanYaoDesc( nItemId )
	return item.getFieldByIdAndIndex(nItemId, "des")
end
--获得激活丹药所需要的等级
function GetDanYaoNeedLv( nLv, nIdx )
	return tonumber(danyao.getFieldByIdAndIndex(nLv+1, "Dan"..tostring(nIdx).."Lv"))
end

--获得金丹图标
function GetJinDanIcon( nLv )
	local nResID = tonumber(danyao.getFieldByIdAndIndex(nLv+1, "JDanResID"))
	return resimg.getFieldByIdAndIndex(nResID, "icon_path")
end

-- 获得金丹的属性Id
function GetJinDanAttrId( nLv, nIdx )
	return tonumber(danyao.getFieldByIdAndIndex(nLv+1, "JDanAttributID-"..tostring(nIdx)))
end

local function GetAttrValueById( nAttrType, nAttrId )
	local nValue = 0
	if nAttrId>0 then
		local nType = GetDanYaoAttrType(nAttrId)
		if nType==nAttrType then
			nValue = GetDanYaoAttrValue(nAttrId)
		end
	end
	return nValue
end

function GetJinDanAddValue( nAttrType, nJinDanLv )
	local nSumValue = 0
	for i=1, MAX_JINDAN_ATTR_COUNT do
		local nAttrId = GetJinDanAttrId(nJinDanLv, i)
		nSumValue = nSumValue+GetAttrValueById(nAttrType, nAttrId)
	end
	return nSumValue
end

-- 获得丹药对应的属性值
function GetDanYaoAttrAllValue( nAttrType, nJinDanLv, bJinDan, nDanYaoLv )
	local nSumValue = 0
	if bJinDan then
		for j=1, MAX_JINDAN_ATTR_COUNT do
			local nAttrId = GetJinDanAttrId(nJinDanLv, j)
			nSumValue = nSumValue+GetAttrValueById(nAttrType, nAttrId)
		end
	else
		-- if nJinDanLv==0 then
			for j=1, nDanYaoLv do
				local nAttrId = GetDadnYaoAttrId(nJinDanLv, j)
				nSumValue = nSumValue+GetAttrValueById(nAttrType, nAttrId)
			end
		-- else
		-- 	for i=0, nJinDanLv do
		-- 		local nIdx = 0
		-- 		if i==nJinDanLv then
		-- 			nIdx = nDanYaoLv
		-- 		else
		-- 			nIdx = MAX_DANYAO_ATTR_COUNT
		-- 		end

		-- 		for j=1, nIdx do
		-- 			local nAttrId = GetDadnYaoAttrId(i, j)
		-- 			nSumValue = nSumValue+GetAttrValueById(nAttrType, nAttrId)
		-- 		end
		-- 	end
		-- end
	end
	return nSumValue
end