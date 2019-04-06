module("server_LuckyOpenDB",package.seeall)

local m_tableInfo = {}
local sliver_time = 0
local gold_time = 0
function SetTableBuffer( buffer )
	m_tableInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	sliver_time  = pNetStream:Read()
	gold_time    = pNetStream:Read()
end

function GetServerTime(  )
	if sliver_time ~= nil then
		return sliver_time
	end
end

function GetGoldTime(  )
	if gold_time ~= nil then
		return gold_time
	end
end

function release()
	m_tableInfo = nil
	package.loaded["server_LuckyOpenDB"] = nil
end