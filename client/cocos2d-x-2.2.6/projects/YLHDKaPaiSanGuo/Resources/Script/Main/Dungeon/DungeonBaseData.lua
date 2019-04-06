-- require "Script/Common/Common"
-- require "Script/Common/CommonData"

module("DungeonBaseData", package.seeall)

MAX_MONSTER_COUNT = 5
MAX_REWARDITEM_COUNT = 4
MAXPOINTCOUNT = 15

local GetExpendData = ConsumeLogic.GetExpendData

function GetPointId( nSceneIdx, nLocalIdx )
	return tonumber(scence.getFieldByIdAndIndex(nSceneIdx, "ID_"..tostring(nLocalIdx)))
end

function GetPointRuleId( nPointId )
	return tonumber(point.getFieldByIdAndIndex(nPointId, "RuleID"))
end

function GetPointName( nPointId )
	return point.getFieldByIdAndIndex(nPointId,"Name")
end

function GetPointPos( nSceneIdx, nPointIdx )
	return nor_copy.getFieldByIdAndIndex( nSceneIdx, "point_pos"..tostring(nPointIdx))
end

function GetPointDesc( nPointId )
	return nor_copydata.getFieldByIdAndIndex(nPointId,"point_des")
end

function GetTimes( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "Times"))
end

function GetNeedTiLi( nRuleId )
	local  ConsumeID = GetConsumeID(nRuleId)
	-- 通过消耗id转化需要的体力数值 等接口	这里知道就一个
	if ConsumeID > 0 then 
		return GetExpendData(ConsumeID):GetNumByIndex(1)
	end
	
	return 0
end

-- add by sxin 这里改成消耗id
function GetConsumeID( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "ConsumeID"))
end

-- add by sxin 这里改成消耗id
function CheckConsumeID( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "ConsumeID"))
end

function GetNeedLv( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "User_lv"))
end

function GetNeedFamilyLv( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "Family_lv"))
end

function GetOpenWeekDay( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "Week"))
end

function GetSweep( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "ISSweep"))
end

function GetAutomatic( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "ISAutomatic"))
end

function GetSkip( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "ISSkip"))
end

function GetOnly( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "Only"))
end

function GetPremiseID( nRuleId )
	return tonumber(scenerule.getFieldByIdAndIndex(nRuleId, "PremiseID"))
end

function GetRewardList( nPointId )
	local tabRewardId = {}
	for i=1, MAX_REWARDITEM_COUNT do
		table.insert(tabRewardId, tonumber(nor_copydata.getFieldByIdAndIndex(nPointId, "point_item"..tostring(i))))
	end
	return tabRewardId
end

function GetMonsterType( nMonsterId )
	return tonumber(monst.getFieldByIdAndIndex(nMonsterId, "Type"))
end

function GetMonsterName( nMonsterId )
	return tostring(monst.getFieldByIdAndIndex(nMonsterId, "Name"))
end

function GetMonsterMilitary( nMonsterId )
	return tostring(monst.getFieldByIdAndIndex(nMonsterId, "Military"))
end

function GetMonsterColorIcon( nMonsterId )
	local nQuality =  tonumber(monst.getFieldByIdAndIndex(nMonsterId, "Colour"))
	if nQuality<1 then
		nQuality=1
	end
	local strColorIcon = string.format("Image/imgres/common/color/wj_pz%d.png",nQuality)
	return strColorIcon
end

function GetMonsterLevel( nMonsterId )
	return tonumber(monst.getFieldByIdAndIndex(nMonsterId, "Level"))
end

function GetMonsterResId( nMonsterId )
	return tonumber(monst.getFieldByIdAndIndex(nMonsterId, "resID"))
end

function GetMonsterIcon( nMonsterId )
	local nResId = GetMonsterResId(nMonsterId)
	return tostring(AnimationData.getFieldByIdAndIndex(nResId, "ImagefileName_Head"))
end

function GetCoinPath( nIndex )
	local nResId = coin.getFieldByIdAndIndex(nIndex, "ResID")
	return resimg.getFieldByIdAndIndex(nResId, "icon_path")
end

function GetCoinNum( nIndex )
	local num = 0
	if tonumber(nIndex) == 1 then
		num = server_mainDB.getMainData("silver")
	elseif tonumber(nIndex) == 2 then
		num = server_mainDB.getMainData("gold")
	elseif tonumber(nIndex) == 3 then
		num = server_mainDB.getMainData("tili")
	elseif tonumber(nIndex) == 4 then
		num = server_mainDB.getMainData("naili")
	elseif tonumber(nIndex) == 5 then
		num = server_mainDB.getMainData("exp")
	elseif tonumber(nIndex) == 6 then
		num = server_mainDB.getMainData("GeneralExpPool")
	elseif tonumber(nIndex) == 7 then
		num = server_mainDB.getMainData("gold")
	elseif tonumber(nIndex) == 8 then
		num = server_mainDB.getMainData("gold")
	end
	return num
end

function GetMonsterDesc( nMonsterId )
	return tostring(monst.getFieldByIdAndIndex(nMonsterId, "Des"))
end

function GetMonsterPos( nPointId, nIdx )
	return tostring(nor_copydata.getFieldByIdAndIndex(nPointId, "point_pos_"..tostring(nIdx)))
end

function GetMonsterId( nPointId, nMonsterPos )
	return tonumber(point.getFieldByIdAndIndex(nPointId, nMonsterPos))
end

function GetMonsterList( nPointId )
	local tabMonsterData = {}
	for i=1, MAX_MONSTER_COUNT do
		local nMonsterPos = GetMonsterPos(nPointId, i)
		if nMonsterPos==nil then
			return
		end
		local nMonsterId = GetMonsterId(nPointId, nMonsterPos)
		
		print("nMonsterPos = " .. nMonsterPos)
		print("nMonsterId = " .. nMonsterId)
		--Pause()
		if nMonsterId>0 then
			local tabTemp = {}
			tabTemp.MonsterId = nMonsterId
			tabTemp.MonsterType = GetMonsterType(nMonsterId)
			tabTemp.HeadIcon = GetMonsterIcon(nMonsterId)
			tabTemp.Military = GetMonsterMilitary(nMonsterId)
			tabTemp.ColorIcon = GetMonsterColorIcon(nMonsterId)
			table.insert(tabMonsterData, tabTemp)
		end
	end
	local function sortByType( Monster1, Monster2 )
		return Monster1.MonsterType < Monster2.MonsterType
	end
	table.sort( tabMonsterData, sortByType )
	return tabMonsterData
end

function GetMapCount(  )
	local nCount = 0
	for key, value in pairs(nor_copy.getTable()) do
		nCount = nCount + 1
	end
	return nCount
end

function GetSceneIndex( nIndex )
	return globedefine.getFieldByIdAndIndex("HuoDongTimes","Para_"..nIndex)
end

function GetSceneId( nIdx )
	return  tonumber(scence.getFieldByIdAndIndex(nIdx, "ID"))
end

function GetSceneType( nIdx )
	return  tonumber(scence.getFieldByIdAndIndex(nIdx, "SceneType"))
end

function GetSceneRuleId( nSceneIdx )
	return tonumber(scence.getFieldByIdAndIndex(nSceneIdx, "RuleID"))
end

function GetMapImage( nIdx )
	return tostring(nor_copy.getFieldByIdAndIndex(nIdx, "map"))
end

function GetMapName( nSceneIdx )
	return scence.getFieldByIdAndIndex(nSceneIdx, "Name")
end

function GetActivityMapName( nIndex )
	local pSceneID = globedefine.getFieldByIdAndIndex("HuoDongTimes","Para_"..nIndex)
	return scence.getFieldByIdAndIndex(pSceneID, "Name")
end

function GetActivityTimes( )
	return tonumber(globedefine.getFieldByIdAndIndex("HuoDongTimes","Para_1"))
end

function GetPointIdBySceneIdx(nSceneIdx, nPointIdx)
	return tonumber(nor_copy.getFieldByIdAndIndex( nSceneIdx, "point_id"..tostring(nPointIdx)))
end

function GetPointType( nSceneIdx, nPointIdx )
	return tonumber(nor_copy.getFieldByIdAndIndex( nSceneIdx, "point_res"..tostring(nPointIdx)))
end

function GetPointCount( nSceneIdx )
	return tonumber(scence.getFieldByIdAndIndex(nSceneIdx, "Count"))
end


