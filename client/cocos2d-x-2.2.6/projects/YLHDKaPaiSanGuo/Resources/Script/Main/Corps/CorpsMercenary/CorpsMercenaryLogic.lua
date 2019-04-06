require "Script/serverDB/globedefine"
module("CorpsMercenaryLogic",package.seeall)
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryData"


ICON_BG_COMMON_PATH = "Image/imgres/equip/icon/bottom.png"

function SetRefreshStatus( nRefreshState )
	CCUserDefault:sharedUserDefault():setBoolForKey("nRefreshState", nRefreshState)
end

function SaveTimeStatus(nTimeDay)
	CCUserDefault:sharedUserDefault():setIntegerForKey("nTimeDay", nTimeDay)
end

function GetDayStatus(  )
	return CCUserDefault:sharedUserDefault():getIntegerForKey("nTimeDay")
end

function GetMonthStatus(  )
	return CCUserDefault:sharedUserDefault():getIntegerForKey("nTimeMonth")
end
function GetYearStatus(  )
	return CCUserDefault:sharedUserDefault():getIntegerForKey("nTimeYears")
end

function GetRefreshStatus(  )
	return CCUserDefault:sharedUserDefault():getBoolForKey("nRefreshState")
end

function SaveCheckBoxStatus( IsCheckBox )
	CCUserDefault:sharedUserDefault():setBoolForKey("nBoxState", IsCheckBox)
end
function GetCheckBoxStatus(  )
	return CCUserDefault:sharedUserDefault():getBoolForKey("nBoxState")
end
--判断是时间
function IsTimeJudge( nDay,nMonth,nYear )
	local timeDay = GetDayStatus()
	local timeMonth = GetMonthStatus()
	local timeYear = GetYearStatus()
	if timeYear == nYear and timeMonth == nMonth and timeDay == nDay then
		return true
	end
	return false
end

function CheckMercenaryByID( id,value )
	if id == value.id then
		return true
	end
	return false
end

function CheckWhetherOwn( id ,tab )
	for key,value in pairs(tab) do
		if id == value.onlyID then
			return true
		end
	end
	return false
end

--判断人物等级是否大于限定级别
function JudgeLevelLinit( nLevel ,nNum)
	local TotalHireNum,LevelLimitTen,LevelLimitTwenty,LevelLimitThirty = CorpsMercenaryData.GetHireTotalNum()
	if nLevel >= LevelLimitTen and nLevel < LevelLimitTwenty then
		if nNum == 0 then
			return true
		end
	elseif nLevel >= LevelLimitTwenty and nLevel < LevelLimitThirty then
		if nNum == 0 or nNum ==1 then
			return true
		end
	elseif nLevel >= LevelLimitThirty then
		if nNum == 0 or nNum == 1 or nNum == 2 then
			return true
		end
	end
	return false
end


function cleanListView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:removeAllItems()
	end 
end
