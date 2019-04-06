require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/serverDB/elite_copy"
require "Script/serverDB/globedefine"
module("EliteDungeonData", package.seeall)


function GetPointPos( nPointIdx )
	local nPosX = tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "pos_x"))
	local nPosY = tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "pos_y"))
	return ccp(nPosX, nPosY)
end

function GetPageWidth( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "width"))
end

function GetSceneIdx( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "scene_idx"))
end

function GetCloudAniIdx( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "ani_idx"))
end

function GetCloudOffX( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "off_x"))
end

function GetCloudOffY( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "off_y"))
end

function GetCloudScaleX( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "scale_x"))
end

function GetCloudScaleY( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "scale_y"))
end

function GetCloudRotation( nPointIdx )
	return tonumber(elite_copy.getFieldByIdAndIndex(nPointIdx, "rotation"))
end

function GetElitePointCount( )
	local nCount = 0
	for key, value in pairs(elite_copy.getTable()) do
		nCount = nCount+1
	end
	return nCount
end

function GetEliteTimes(  )
	return tonumber(globedefine.getFieldByIdAndIndex("JingYingTimes", "Para_1"))
end