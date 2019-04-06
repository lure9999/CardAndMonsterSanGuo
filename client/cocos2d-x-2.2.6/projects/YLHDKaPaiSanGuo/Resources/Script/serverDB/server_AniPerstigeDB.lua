module("server_AniPerstigeDB",package.seeall)

local m_tabPerstige = {}

local QLPer = nil
local BHPer = nil
local ZQPer = nil
local XWPer = nil
local BHMPer = nil


function SetTableBuffer( buffer )
	m_tabPerstige = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 			= pNetStream:Read()	
	local list              = pNetStream:Read()
	for key,value in pairs(list) do
		m_tabPerstige[key] = {}
		m_tabPerstige[key]["prestige"] = value[1]
		m_tabPerstige[key]["is_open"] = value[2]
	end
	GetRefreshTab()
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabPerstige)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabPerstige = tTable
end

function GetRefreshTab(  )
	require "Script/Main/Corps/CorpsSpirit/CorpsSpiritlayer"
	CorpsSpiritlayer.ShowRightUI()
end

function release()
	m_tabPerstige = nil
	package.loaded["server_AniPerstigeDB"] = nil
end