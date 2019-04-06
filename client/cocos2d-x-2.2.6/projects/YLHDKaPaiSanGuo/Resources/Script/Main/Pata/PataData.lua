require "Script/serverDB/pata_copy"
require "Script/serverDB/general"
require "Script/serverDB/pata_copy"
require "Script/serverDB/nor_copydata"
require "Script/serverDB/scence"
require "Script/serverDB/point"
require "Script/serverDB/monst"
require "Script/serverDB/consume"
require "Script/serverDB/server_fubenDB"
require "Script/Common/RewardLogic"
require "Script/Common/ConsumeLogic"
require "Script/serverDB/globedefine"
module("PataData", package.seeall)

MAX_REWARDITEM_COUNT = 4

--根据当前层数获取到战役ID
function GetSceneID( pCurLayer )
	return tonumber(pata_copy.getFieldByIdAndIndex( pCurLayer, "sceneID"))
end

function GetPointIdx( pCurLayer )
	return tonumber(pata_copy.getFieldByIdAndIndex( pCurLayer, "pointindex"))
end

function GetGeneralResId( nmodId )
	return tonumber(general.getFieldByIdAndIndex( nmodId , "ResID" ))
end

function GetGeneralId( nmodId )
	return tonumber(general.getFieldByIdAndIndex( nmodId , "﻿ID" ))
end

--通过战役ID获得每一关显示ID
function GetPointIdByIdx( pSceneIdx ,pPointIdx)
	return tonumber(scence.getFieldByIdAndIndex(pSceneIdx,"ID_"..tostring(pPointIdx)))
end

function GetRuleTextByPointID( nPointID )
	return tostring(nor_copydata.getFieldByIdAndIndex(nPointID,"point_des"))
end

function GetMonsterIDByPointPos( nPointID,nMonIdx )
	return tostring(nor_copydata.getFieldByIdAndIndex(nPointID,"point_pos_"..tostring(nMonIdx)))
end

function GetMonsterIdBynSceneId( nPointId , nPosId)
	return tonumber(point.getFieldByIdAndIndex(nPointId,tostring(nPosId)))
end

function GetMonsterResId( nMonsterId )
	return tonumber(monst.getFieldByIdAndIndex(nMonsterId,"resID"))
end

function GetMonsterType( nMonsterId )
	return tonumber(monst.getFieldByIdAndIndex(nMonsterId, "Type"))
end

function GetMonsterMilitary( nMonsterId )
	return tostring(monst.getFieldByIdAndIndex(nMonsterId, "Military"))
end

function GetPataResetNum( )
	return globedefine.getFieldByIdAndIndex("PaTa","Para_1")
end

function GetPataMopUpTime( )
	return globedefine.getFieldByIdAndIndex("PaTa","Para_2")
end

local function GetPataMopEndConsumeID( )
	return globedefine.getFieldByIdAndIndex("PaTa","Para_3")
end

function GetMonsterColorIcon( nMonsterId )
	local nQuality =  tonumber(monst.getFieldByIdAndIndex(nMonsterId, "Colour"))
	if nQuality<1 then
		nQuality=1
	end
	local strColorIcon = string.format("Image/imgres/common/color/wj_pz%d.png",nQuality)
	return strColorIcon
end

function GetMonsterIcon( nMonsterId )
	local nResId = GetMonsterResId(nMonsterId)
	return tostring(AnimationData.getFieldByIdAndIndex(nResId, "ImagefileName_Head"))
end

function GetRewardList( nPointId )
	local tabRewardId = {}
	for i=1, MAX_REWARDITEM_COUNT do
		table.insert(tabRewardId, tonumber(nor_copydata.getFieldByIdAndIndex(nPointId, "point_item"..tostring(i))))
	end
	return tabRewardId
end

function GetRewardTabByPointID( nPointID )
	local nRewardId = tonumber(point.getFieldByIdAndIndex(nPointID,"RewardID"))
	return RewardLogic.GetRewardTable(nRewardId)
end

local function GetConsumeItemData( nConsumeID, nItemIdex, nItemType, nIncType )
	return ConsumeLogic.GetConsumeItemData(nConsumeID,nItemIdex,nItemType,nIncType,nil,nil,nil)
end

local function GetIncType( nConsumeID )
	return tonumber(consume.getFieldByIdAndIndex(nConsumeID, "IncrementalLimit"))
end

function GetConsumeNum( )
	return tonumber(consume.getFieldByIdAndIndex(GetPataMopEndConsumeID(), "Type_1_para_A"))
end

function GetConsumeData(  )
	local data = ConsumeLogic.GetConsumeTab(5,GetPataMopEndConsumeID(),nil,nil)
	return GetConsumeItemData(GetPataMopEndConsumeID(),data[1].nIdx,data[1].ConsumeType,GetIncType(GetPataMopEndConsumeID()))
end

function GetPataFreeSetTimes(  )
	return server_fubenDB.GetPataSurPlusTimes()
end

function GetRefreshFightConsID( nType )
	return globedefine.getFieldByIdAndIndex("PaTaAtt"..tonumber(nType),"Para_1")
end

function GetRefreshFightBuffPercent( nType )
	return globedefine.getFieldByIdAndIndex("PaTaAtt"..tonumber(nType),"Para_2")
end