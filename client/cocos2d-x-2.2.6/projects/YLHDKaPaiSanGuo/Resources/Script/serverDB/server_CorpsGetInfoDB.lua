module("server_CorpsGetInfoDB",package.seeall)

m_tableCorpsGetInfo = {}
m_tabGetInfo = {}
local nCountryID = nil
local ControbuteMoney = nil
local CorpsMoney = nil
function SetTableBuffer( buffer )
	m_tableCorpsGetInfo = {}
	m_tabGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	nCountryID = list[7]
	ControbuteMoney = list[10]
	CorpsMoney = list[11]
	if list ~= nil then
		table.insert(m_tableCorpsGetInfo,list)
	end

	m_tabGetInfo.id = list[1]
	m_tabGetInfo.name = list[2]
	m_tabGetInfo.flag = list[6]
	m_tabGetInfo.level = list[3]
	m_tabGetInfo.people = list[4]
	m_tabGetInfo.needLevel = list[5]
	m_tabGetInfo.country = list[7]
	m_tabGetInfo.brief = list[8]
	m_tabGetInfo.limitType = list[9]
	m_tabGetInfo.m_uContribute = list[10] --军团总贡献
	m_tabGetInfo.m_uCorpsMoney = list[11] --军团币
	m_tabGetInfo.m_notice = list[12]
	m_tabGetInfo.CorpsPower = list[13]
	m_tabGetInfo.curNum = list[14]

	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tableCorpsGetInfo)
end

function GetCorpsCountry(  )
	if nCountryID == nil then
		nCountryID = 1
	end
	return nCountryID
end

function GetControbuteMoney(  )
	return ControbuteMoney
end

function GetCorpsMoney(  )
	return CorpsMoney
end

function getCorpsData( keyData )
	return m_tabGetInfo[keyData]
end

function release()
	m_tableCorpsGetInfo = nil
	m_tabGetInfo = nil
	package.loaded["server_CorpsGetInfoDB"] = nil
end