module("server_MercenaryCampInfo",package.seeall)

local m_tabMercenaryInfo = {}
local b_tabConsumInfo = {}
local h_tabConsumInfo = {}
local isHire = nil
local Server_Cmd1 = {
	faceID       	= 1,
	level        	= 2,
	starLevel       = 3,
}

local Server_Cmd2 = {
	bConsumType = 1,
	bConsumID   = 2,
	bConsumNum  = 3,
}

local Server_Cmd3 = {
	hConsumType = 1,
	hConsumID   = 2,
	hConsumNum  = 3,
}

function SetTableBuffer( buffer )
	m_tabMercenaryInfo = {}
	b_tabConsumInfo = {}
	h_tabConsumInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 	= pNetStream:Read()		
	isHire = pNetStream:Read()
	local blood_consum = pNetStream:Read()
	for key,value in pairs(blood_consum) do
		b_tabConsumInfo[key] = {}
		b_tabConsumInfo[key]["bConsumType"] = value[Server_Cmd2.bConsumType]
		b_tabConsumInfo[key]["bConsumID"] = value[Server_Cmd2.bConsumID]
		b_tabConsumInfo[key]["bConsumNum"]  = value[Server_Cmd2.bConsumNum]
	end
	local hire_consumType = pNetStream:Read()
	for key,value in pairs(hire_consumType) do
		h_tabConsumInfo[key] = {}
		h_tabConsumInfo[key]["hConsumType"] = value[Server_Cmd3.hConsumType]
		h_tabConsumInfo[key]["hConsumID"] = value[Server_Cmd3.hConsumID]
		h_tabConsumInfo[key]["hConsumNum"]  = value[Server_Cmd3.hConsumNum]
	end
	local list = pNetStream:Read()
	for key,value in pairs(list) do
		m_tabMercenaryInfo[key] = {}
		m_tabMercenaryInfo[key]["faceID"] = value[Server_Cmd1.faceID]
		m_tabMercenaryInfo[key]["level"] = value[Server_Cmd1.level]
		m_tabMercenaryInfo[key]["starLevel"]  = value[Server_Cmd1.starLevel]
	end
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabMercenaryInfo)	
end

function GetBComsumTable(  )
	return copyTab(b_tabConsumInfo)
end

function GetHConsumTable(  )
	return copyTab(h_tabConsumInfo)
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabMercenaryInfo = tTable
end

function GetIsHire(  )
	return isHire
end

function release()
	m_tabMercenaryInfo = nil
	b_tabConsumInfo    = nil
	h_tabConsumInfo    = nil
	package.loaded["server_MercenaryCampInfo"] = nil
end