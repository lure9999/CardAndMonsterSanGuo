module("server_GetRecomCountryDB",package.seeall)

local recommendID = nil
local WeiPower = nil
local ShuPower = nil
local WuPower  = nil
local m_tableRecomCountryDB = {}
function SetTableBuffer( buffer )
	m_tableRecomCountryDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	recommendID  = pNetStream:Read()
	WeiPower     = pNetStream:Read()
	ShuPower     = pNetStream:Read()
	WuPower      = pNetStream:Read()
	table.insert(m_tableRecomCountryDB,recommendID)
	table.insert(m_tableRecomCountryDB,WeiPower)
	table.insert(m_tableRecomCountryDB,ShuPower)
	table.insert(m_tableRecomCountryDB,WuPower)
	pNetStream   = nil

end

function GetCopyTable(  )
    return copyTab(m_tableRecomCountryDB)
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tableRecomCountryDB = tTable
end

function GetRecomCountryID(  )
	if recommendID == nil then
		recommendID = 1
	end
	return recommendID
end

function GetWeiPower(  )
	if WeiPower == nil then
		WeiPower = 1
	end
	return WeiPower
end

function GetShupower(  )
	if ShuPower == nil then
		ShuPower = 1
	end
	return ShuPower
end

function GetWuPower(  )
	if WuPower == nil then
		WuPower = 1
	end
	return WuPower
end

function release()
	m_tableRecomCountryDB = nil
	package.loaded["server_GetRecomCountryDB"] = nil
end