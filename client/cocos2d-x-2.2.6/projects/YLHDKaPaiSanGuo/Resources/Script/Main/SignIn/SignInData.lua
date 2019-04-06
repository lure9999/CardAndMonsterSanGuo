require "Script/serverDB/globedefine"
require "Script/serverDB/pointreward"
require "Script/serverDB/item"
require "Script/serverDB/resimg"
require "Script/serverDB/signin"
require "Script/serverDB/coin"
require "Script/serverDB/server_SignInReward"
module("SignInData",package.seeall)

--豪华签到的信息
function GetLuxuryInfo(  )
	return server_SignInReward.GetLuxuryTable()
end
--普通签到的信息
function GetDailyInfo(  )
	return server_SignInReward.GetDailyTable()
end
--得到签到次数
function GetSignInNum(  )
	return server_SignInReward.GetSignInNum()
end
--得到日常签到的状态
function GetDailyStatus(  )
	return server_SignInReward.GetDailyStatus()
end
--得到豪华签到的状态
function GetLuxurtStatus(  )
	return server_SignInReward.GetLuxStatus()
end

function GetVIPLimitLevel(  )
	local tab = globedefine.getDataById("SignIn")
	local tabReward = pointreward.getDataById(tab[2])
	local tabItem1 = item.getDataById(tabReward[11])
	local tabItem2 = item.getDataById(tabReward[13])
	local icon1 = resimg.getFieldByIdAndIndex(tabItem1[1],"icon_path")
	local icon2 = resimg.getFieldByIdAndIndex(tabItem2[1],"icon_path")
	return tab[1],tabReward[12],tabReward[14],tabItem1[1],tabItem1[2],tabItem2[1],tabItem2[2],icon1,icon2,tabReward
end

function GetVIPIcon( icon_id )
	local tabIcon = item.getDataById(icon_id)
	local icon_path = resimg.getFieldByIdAndIndex(tabIcon[1],"icon_path")
	return icon_path
end

function GetDailyMonthData( nMonthID )
	local TotalMonth = signin.getTable()
	local curMonthData = {}
	local sortMonth = {}
	for key,value in pairs(TotalMonth) do
		if tonumber(value[1]) == nMonthID then
			sortMonth = {}
			sortMonth.MonthID = value[1]
			sortMonth.Sign_Times = value[2]
			sortMonth.NPointRewID = value[3]
			sortMonth.Multi_Require = value[4]
			sortMonth.Multi_Times = value[5]
			sortMonth.SOrderRewID = value[6]

			table.insert(curMonthData,sortMonth)
		end
	end
	return curMonthData
end

function GetDailySignInDB( nPointRewardID )
	local tabRewardDB = {}
	local tabItemDB = {}
	if tonumber(nPointRewardID) == 13001 or tonumber(nPointRewardID) == 13002 or tonumber(nPointRewardID) == 13003 or tonumber(nPointRewardID) == 13004 then
		tabRewardDB = pointreward.getDataById(nPointRewardID)
		tabItemDB = item.getDataById(tabRewardDB[11])
		return tabRewardDB[12],tabItemDB[1],tabItemDB[2],tabItemDB[5],tabItemDB[3]
	else
		tabRewardDB = pointreward.getDataById(nPointRewardID)
		tabItemDB = coin.getDataById(tabRewardDB[1])
		return tabRewardDB[2],tabItemDB[2],tabItemDB[1]
	end

end

function JudgeSignInStatus(  )
	return server_SignInReward.JudgeUnSignInStatus()
end

function GetRewardInfoByID1( nID )
	local num = nil
	if nID == 1 then
		num = server_mainDB.getMainData("silver")
	elseif nID == 2 then
		num = server_mainDB.getMainData("gold")
	elseif nID == 3 then
		num = server_mainDB.getMainData("tili")
	elseif nID == 4 then
		num = server_mainDB.getMainData("naili")
	elseif nID == 5 then
		num = server_mainDB.getMainData("exp")
	elseif nID == 6 then
		num = server_mainDB.getMainData("GeneralExpPool")
	end
	return coin.getDataById(nID),num
end

function GetRewardInfoByID2( nID )
	return item.getDataById(nID)
end

--得到每一天签到获取物品的需求，奖励倍数
function GetMonthDayNum( ntempID )
	local cur_timeTab = os.date("*t")
	local sm_tab = GetDailyMonthData(cur_timeTab.month)
	local cur_monthTab = {}
	cur_monthTab = SignInLogic.SortSignInFromStatus(sm_tab,false)
	return cur_monthTab[ntempID].Multi_Require,cur_monthTab[ntempID].Multi_Times,cur_monthTab[ntempID].SOrderRewID,cur_monthTab[ntempID].NPointRewID
end

--通过奖励ID获取奖励数量
function GetRewardNum( ntempID,RewardID )
	-- print(ntempID,RewardID)
	-- Pause()
	local nRequire,nTimes,nSordID,nPointID = GetMonthDayNum(ntempID)
	local tab = pointreward.getDataById(nPointID)
	-- printTab(tab)
	if tonumber(tab[1]) <= 0 then
		--为什么要等于第十一个值？ RewardID是什么
		--if tonumber(tab[11]) == tonumber(RewardID) then
			return tab[12]
		--end
	else
		--为什么要等于第十一个值？???????? RewardID是什么
		--if tonumber(tab[1]) == RewardID then
			return tab[2]
		--end
	end
end

function GetRewardInfoByDay( ntempID )
	local nRequire,nTimes,nSordID,nPointID = GetMonthDayNum(ntempID)
	local tab = pointreward.getDataById(nPointID)
	if tonumber(tab[1]) <= 0 then
		return tab[11],tab[12],nRequire,nTimes
	else
		return tab[1],tab[2],nRequire,nTimes
	end
end

function GetRewardInfoDataByDay( nPointID )
	local tab = pointreward.getDataById(nPointID)
	if tonumber(tab[1]) <= 0 then
		return tab[11],tab[12],nRequire,nTimes
	else
		return tab[1],tab[2],nRequire,nTimes
	end
end

function  GetVIPStr( ntempID )
	local nRequire,nTimes,nSordID,nPointID = GetMonthDayNum(ntempID)
	local strVIP = nil
	if tonumber(nTimes) == 1 then
		strVIP = "一"
	elseif tonumber(nTimes) == 2 then
		strVIP = "二"
	elseif tonumber(nTimes) == 3 then
		strVIP = "三"
	elseif tonumber(nTimes) == 4 then
		strVIP = "四"
	elseif tonumber(nTimes) == 5 then
		strVIP = "五"
	elseif tonumber(nTimes) == 6 then
		strVIP = "六"
	elseif tonumber(nTimes) == 7 then
		strVIP = "七"
	elseif tonumber(nTimes) == 8 then
		strVIP = "八"
	elseif tonumber(nTimes) == 9 then
		strVIP = "九"
	elseif tonumber(nTimes) == 10 then
		strVIP = "十"
	elseif tonumber(nTimes) == 11 then
		strVIP = "十一"
	elseif tonumber(nTimes) == 12 then
		strVIP = "十二"
	elseif tonumber(nTimes) == 13 then
		strVIP = "十三"
	end
	return strVIP
end

function GetDaysInMonth( nYearsID,nMonthID )
	local d = nil
	local tab_day = {31,28,31,30,31,30,31,31,30,31,30,31}
	if tonumber(nMonthID) == 2 then

	end

end

function GetItemTypeByINdex( valueID )
	-- return item.getIndexByField(valueID)
	return item.getFieldByIdAndIndex(valueID,"event_type")
end