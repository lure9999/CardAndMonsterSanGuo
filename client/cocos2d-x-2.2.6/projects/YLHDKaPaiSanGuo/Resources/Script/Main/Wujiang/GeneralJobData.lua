require "Script/Common/Common"
require "Script/serverDB/job"

module("GeneralJobData", package.seeall)

MAX_JOB_COUNT = 18		--最大职业数量
SPECIAL_COUNT= 4			--专精数量
MAX_CONSUMETYPE_COUNT=5 	--最大消耗类型
MAX_CONSUME_COUNT = 3		--最大消耗数量
local m_tabAttr = {}
local m_nCurGeneralId = nil


JobState =
{
	NotActivite	= 0,
	Activited 	= 1,
	StartUp 	= 2,
}

SpecialState =
{
	NotActivite = 0,
	Normal = 1,
	MaxLv = 2,
}

SpecErrorState =
{
	CanLvUp = 0,
	MaxLv = 1,
	NotEnouthItem = 2,
}

function GetJobName( nGeneralId )
	return job.getFieldByIdAndIndex(nGeneralId, "JopName")
end

function  GetJobIcon( nGeneralId )
	local nResID = tonumber(job.getFieldByIdAndIndex(nGeneralId, "JobImgID"))
	return resimg.getFieldByIdAndIndex(nResID, "icon_path")
end


function  GetJobDesc( nGeneralId )
	return job.getFieldByIdAndIndex(nGeneralId, "JopDes")
end

function GetSpecialIcon( nGeneralId, nIdx )
	local nResID = tonumber(job.getFieldByIdAndIndex(nGeneralId, "ZhuanJImgID_"..tostring(nIdx)))
	return resimg.getFieldByIdAndIndex(nResID, "icon_path")
end

function GetSpecialName( nAttrId )
	print(nAttrId)
	--Pause()
	return attribute.getFieldByIdAndIndex(nAttrId, "name")
end

function GetMaxSpecialLv( nGeneralId, nIdx )
	return tonumber(job.getFieldByIdAndIndex(nGeneralId, "ZhuanJLv_"..tostring(nIdx)))
end

function GetSpecialAttrValue( nAttrId )
	return attribute.getFieldByIdAndIndex( nAttrId, "value")
end

function GetSpecialConsumeId( nGeneralId, nIdx )
	return tonumber(job.getFieldByIdAndIndex(nGeneralId, "ZhuanJCon_"..tostring(nIdx)))
end

function  GetNextGeneralID( nGeneralId )
	return tonumber(job.getFieldByIdAndIndex(nGeneralId, "NextGeneralID"))
end

function GetJobNeedLv( nGeneralId )
	return tonumber(job.getFieldByIdAndIndex(nGeneralId, "UesrLv"))
end

function GetJinJieConsumeId( nGeneralId )
	return tonumber(job.getFieldByIdAndIndex(nGeneralId, "JobCon"))
end






