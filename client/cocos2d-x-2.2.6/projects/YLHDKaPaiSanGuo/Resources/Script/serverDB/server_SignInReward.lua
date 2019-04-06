module("server_SignInReward",package.seeall)

local m_tabSignInLuxury = {}
local m_tabSignInDaily = {}

local signIn_num = 0
local daily_status = 0
local luxury_status = 0
local Server_Cmd = {
	is_coin       = 1,
	is_item       = 2,
	num        = 3,
}

function SetTableBuffer( buffer )
	m_tabSignInLuxury = {}
	m_tabSignInDaily  = {}
	local pNetStream  = NetStream()
	pNetStream:SetPacket(buffer)
	local status 	 = pNetStream:Read()
	signIn_num       = pNetStream:Read()
	daily_status     = pNetStream:Read()
	luxury_status    = pNetStream:Read()
	local list_Luxury = pNetStream:Read()
	local list_daily = pNetStream:Read()
	local daily_tag = 1
	--豪华签到奖励ID
	for key,value in pairs(list_Luxury) do
		m_tabSignInLuxury[key] = {}
		m_tabSignInLuxury[key]["is_coin"] = value[Server_Cmd.is_coin]
		m_tabSignInLuxury[key]["is_item"] = value[Server_Cmd.is_item]
		m_tabSignInLuxury[key]["num"] = value[Server_Cmd.num]
	end
	pNetStream = nil

end

function GetLuxuryTable()	
	return copyTab(m_tabSignInLuxury)	
end

function GetDailyTable(  )
	return copyTab(m_tabSignInDaily)
end

function GetSignInNum(  )
	return signIn_num
end

function GetDailyStatus(  )
	return daily_status
end

function GetLuxStatus(  )
	return luxury_status
end

function JudgeUnSignInStatus(  )
	local daily1_stus = GetDailyStatus()
	local luxury1_stus = GetLuxStatus()
	if daily1_stus == 1 and luxury1_stus == 1 then
		return false
	else
		return true
	end
	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabMercenaryInfo = tTable
end

function release()
	m_tabSignInLuxury = nil
	m_tabSignInDaily  = nil    
	package.loaded["server_SignInReward"] = nil
end