module("server_ScienceSpeedUp",package.seeall)

local m_tabScienceSpeedUpDB = {}

local time = nil

function SetTableBuffer( buffer )
	m_tabScienceSpeedUpDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	time = pNetStream:Read()
	UpdateCutTime(time)
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabScienceSpeedUpDB)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabScienceSpeedUpDB = tTable
end

function GetTimeNum(  )
	if time == nil then
		time = 1
	end
	return time
end

function UpdateCutTime( time )
	-- require "Script/Main/Corps/CorpsScienceUp/CorpsScienceUpLayer"
	CorpsScienceUpLayer.UpdateCutTime(time)
end

function release()
	m_tabScienceSpeedUpDB = nil
	package.loaded["server_ScienceSpeedUp"] = nil
end