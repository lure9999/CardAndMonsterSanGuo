module("server_ScienceLevelUpDB",package.seeall)

m_tabScienceLevelInfo = {}
local s_type = nil
local s_level = nil

function SetTableBuffer( buffer )
	m_tabScienceLevelInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	s_type = pNetStream:Read()
	s_level = pNetStream:Read()
	table.insert(m_tabScienceLevelInfo,s_type)
	table.insert(m_tabScienceLevelInfo,s_level)
	RefreshScienceLevelUI()
	RefreshScienceLevel(s_type,s_level)
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabScienceLevelInfo)
end

function GetUpType(  )
	return s_type
end

function GetCurUpLevel(  )
	return s_level
end

function RefreshScienceLevel( s_type,s_level )
	require "Script/serverDB/server_ScienceLevelDB"
	server_ScienceLevelDB.RefreshTableDataByServer(s_type,s_level)
end

function getCorpsData( keyData )
	return m_tabScienceLevelInfo[keyData]
end

function RefreshScienceLevelUI(  )
	require "Script/Main/Corps/CorpsScienceUp/CorpsScienceUpLayer"
	CorpsScienceUpLayer.UpdateScienceLevelUI(m_tabScienceLevelInfo)
	require "Script/Main/Corps/CorpsScene"
	CorpsScene.SetCorpsLevel(m_tabScienceLevelInfo[2])
end

function release()
	m_tabScienceLevelInfo = nil
	package.loaded["server_ScienceLevelUpDB"] = nil
end