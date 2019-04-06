module("server_AniQueryInfo",package.seeall)

local m_tabQUERY = {}

function SetTableBuffer( buffer )
	m_tabQUERY = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 	= pNetStream:Read()	
	local list      = pNetStream:Read()
	for key,value in pairs(list) do
		m_tabQUERY[key] = {}
		m_tabQUERY[key]["nType"] = value[1]
		m_tabQUERY[key]["nCountryID"] = value[2]
		m_tabQUERY[key]["nTime"] = value[3]
		m_tabQUERY[key]["nTotalTime"] = value[4]
	end
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabQUERY)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabQUERY = tTable
end

function release()
	m_tabQUERY = nil
	package.loaded["server_AniQueryInfo"] = nil
end