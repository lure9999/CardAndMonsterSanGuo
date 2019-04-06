
module("server_ScienceAssetDB",package.seeall)

local m_tableScienceAssetDB = {}
local nType = nil
local nAssetInjection = nil

function SetTableBuffer( buffer )
	m_tableScienceAssetDB = {}

	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	-- local list = pNetStream:Read()
    nType = pNetStream:Read()
    nAssetInjection = pNetStream:Read()
    table.insert(m_tableScienceAssetDB,nType)
    table.insert(m_tableScienceAssetDB,nAssetInjection)
    UpDatePercent(nType)
	pNetStream = nil

end

function GetCopyTable()
	--[[if m_tableScienceAssetDB == nil then
		return nil
	else
		return copyTab(m_tableScienceAssetDB)
	end]]--
	return copyTab(m_tableScienceAssetDB)
end

function UpDatePercent( m_nType )
	-- require "Script/Main/Corps/CorpsScienceUp/CorpsScienceUpLayer"
	local tab = GetCopyTable()
	CorpsScienceUpLayer.GetUpDate(m_tableScienceAssetDB[1])
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tableScienceAssetDB = tTable
end

function release()
	m_tableScienceAssetDB = nil
	package.loaded["server_ScienceAssetDB"] = nil
end