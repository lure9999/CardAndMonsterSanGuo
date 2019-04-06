module("server_AniInfoDB",package.seeall)

local m_tabInfo = {}

local nType = nil
local BHPer = nil
local ZQPer = nil
local XWPer = nil
local BHMPer = nil


function SetTableBuffer( buffer )
	m_tabInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 				= pNetStream:Read()	
	m_tabInfo["nType"] 			= pNetStream:Read()
	m_tabInfo["BlessNum"] 		= pNetStream:Read()
	m_tabInfo["Cur_BlessNum"] 	= pNetStream:Read()
	m_tabInfo["Cue_Per"] 		= pNetStream:Read()
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabInfo)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabInfo = tTable
end

function release()
	m_tabInfo = nil
	package.loaded["server_AniInfoDB"] = nil
end