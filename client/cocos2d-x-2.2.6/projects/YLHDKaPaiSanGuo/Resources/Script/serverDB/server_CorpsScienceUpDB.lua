module("server_CorpsScienceUpDB",package.seeall)

local m_tableCorpsScienceDB = {}

local time = nil
local nType = nil


function SetTableBuffer( buffer )
	m_tableCorpsScienceDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	nType = pNetStream:Read()
	time = pNetStream:Read()
	table.insert(m_tableCorpsScienceDB,nType)
	table.insert(m_tableCorpsScienceDB,time)
	GetIpdate(time)
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tableCorpsScienceDB)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tableCorpsScienceDB = tTable
end

function GetTimeNum(  )
	if time == nil then
		time = 1
	end
	return m_tableCorpsScienceDB[2]
end

function GetIpdate( mtime )
	-- CorpsScienceUpLayer.GetUpdateee(mtime)
	require "Script/Main/Corps/CorpsScienceUp/CorpsScienceUpLayer"
	CorpsScienceUpLayer.GetUpdateee(mtime)
end

function release()
	m_tableCorpsScienceDB = nil
	package.loaded["server_CorpsScienceUpDB"] = nil
end