
module("UnitTime", package.seeall)


local m_nTimeAllUint = nil
local m_nTimeCurDayUint = nil
local m_nTickHand = nil

local m_nOneDay_S = 86400
local m_nHour_8_S = 28800

local function SendHeart()
	local function HeartOver(uInt)

		m_nTimeAllUint = tonumber(uInt)
		print("HeartOver = " .. m_nTimeAllUint)
		local temp = os.date("*t", m_nTimeAllUint)

 		--printTab(temp)

		m_nTimeCurDayUint = m_nTimeAllUint%m_nOneDay_S

		m_nTimeCurDayUint = m_nTimeCurDayUint + m_nHour_8_S

		print(GetTimeStringFont(m_nTimeCurDayUint))
		
		--Pause()
		
--[[
{year = 1998, month = 9, day = 16, yday = 259, wday = 4,

 hour = 23, min = 48, sec = 10, isdst = false}
 --]]
	end
	Packet_Heart.SetSuccessCallBack(HeartOver)
	network.NetWorkEvent(Packet_Heart.CreatPacket())
end

function GetTimeCurDay()
	local temp = os.date("*t", m_nTimeAllUint)
 	--printTab(temp)
 	return temp.year .. "年" .. temp.month .. "月" .. temp.day .. "日"
end

function GetCurDay()
	local temp = os.date("*t", m_nTimeAllUint)
	return tonumber(temp.day)
end

function GetCurWday( )
	return os.date("%w", m_nTimeAllUint)
end

function GetCurTime(  )
	return m_nTimeAllUint
end
-- 将一个时间数转换成"00:00:00"格式
function GetTimeString(timeInt)
	if(tonumber(timeInt) <= 0)then
		return "00:00:00"
	else
		return string.format("%02d:%02d:%02d", math.floor(timeInt/(60*60)), math.floor((timeInt/60)%60), timeInt%60)
	end
end

-- 将一个时间数转换成"00时00分00秒"格式
function GetTimeStringFont(timeInt)
	if(tonumber(timeInt) <= 0)then
		return "00时00分00秒"
	else
		return string.format("%02d时%02d分%02d秒", math.floor(timeInt/(60*60)), math.floor((timeInt/60)%60), timeInt%60)
	end
end

function GetTimeCurUInt()
	return os.date("%X")--m_nTimeCurDayUint
end

-- 将一个时间00:00:00转换成"Uint"格式
function GetTimeUInt(strTime)
	local nUintTime = 0
	local SplitIdx = string.find(strTime, ":")
	local Idx = string.sub(strTime, 0, SplitIdx-1)
	nUintTime = nUintTime + tonumber(Idx)*60*60
	SplitIdx = string.find(strTime, ":")
	strTime = string.sub(strTime, SplitIdx+1)
	SplitIdx = string.find(strTime, ":")
	Idx = string.sub(strTime, 0, SplitIdx-1)
	nUintTime = nUintTime + tonumber(Idx)*60
	strTime = string.sub(strTime, SplitIdx+1)
	nUintTime = nUintTime + tonumber(strTime)
	return nUintTime
end

local function TickUpdata(dt)
	if m_nTimeAllUint ~= nil then
		m_nTimeAllUint = m_nTimeAllUint + 1
		m_nTimeCurDayUint = m_nTimeCurDayUint + 1

		--print("TickUpdata m_nTimeCurDayUint = " .. m_nTimeCurDayUint)

		-- 心跳间隔时间
		if m_nTimeCurDayUint%CommonData.g_HeartTime == 0 then
			--print("m_nTimeCurDayUint = " .. m_nTimeCurDayUint)
			SendHeart()
		end
	
	end
end

function LoginMSOver()

	-- 第一次与服务器同步心跳
	SendHeart()

	-- 添加tick
	m_nTickHand  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(TickUpdata, 1, false)
end

function StopHeart()
	if m_nTickHand ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nTickHand)
		m_nTickHand = nil
	end
end