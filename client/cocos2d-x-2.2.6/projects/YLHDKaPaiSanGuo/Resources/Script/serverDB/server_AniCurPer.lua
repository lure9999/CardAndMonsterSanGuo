module("server_AniCurPer",package.seeall)

local m_tabPerstige = {}
local cur_per = nil
function SetTableBuffer( buffer )
	m_tabPerstige = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 			= pNetStream:Read()	
	cur_per                 = pNetStream:Read()
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabPerstige)	
end

function GetCurPerByServer(  )
	return cur_per
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabPerstige = tTable
end

function release()
	m_tabPerstige = nil
	package.loaded["server_AniCurPer"] = nil
end