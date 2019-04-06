module("server_CorpsScienceUpDate",package.seeall)

local m_tableScienceUpdate = {}

local nMoneyType = nil
local nMoneyCount = nil
local nIntervalTime = nil
local nMaxLimite = nil
local nCurCount = nil
local nRewardID = nil
local nNextTime = nil
local nTotalTime = nil
local t_type = nil


function SetTableBuffer( buffer )
	m_tableScienceUpdate = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 	= pNetStream:Read()		
	-- local list      = pNetStream:Read()
	m_tableScienceUpdate["t_type"] 		    = pNetStream:Read()
	m_tableScienceUpdate["nMoneyType"] 		= pNetStream:Read()
	m_tableScienceUpdate["nMoneyCount"] 	= pNetStream:Read()
	m_tableScienceUpdate["nIntervalTime"] 	= pNetStream:Read()
	m_tableScienceUpdate["nMaxLimite"] 		= pNetStream:Read()
	m_tableScienceUpdate["nCurCount"]		= pNetStream:Read()
	m_tableScienceUpdate["nRewardID"] 		= pNetStream:Read()	
	m_tableScienceUpdate["nNextTime"] 		= pNetStream:Read()
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tableScienceUpdate)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tableScienceUpdate = tTable
end

function GetMoneyType(  )
	if nMoneyType == nil then
		nMoneyType = 1
	end
	return nMoneyType
end

function release()
	m_tableScienceUpdate = nil
	package.loaded["server_CorpsScienceUpDate"] = nil
end