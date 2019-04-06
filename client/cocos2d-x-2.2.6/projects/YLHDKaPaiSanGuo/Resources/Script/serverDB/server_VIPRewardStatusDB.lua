module("server_VIPRewardStatusDB",package.seeall)

local m_VIPRewardDB = {}

function SetTableBuffer( buffer )
	m_VIPRewardDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	m_VIPRewardDB = pNetStream:Read()
	-- RefreshRewardStatus()
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_VIPRewardDB)	
end

function RefreshRewardStatus(  )
	require "Script/Main/ChargeVIP/ChargeVIPLayer"
	local cur_vips = server_mainDB.getMainData("vip")
	ChargeVIPLayer.UpdatePanelTe()
end

function GetGetVIPStatus(  )
	local tabDB = GetCopyTable()
	for key,value in pairs(tabDB) do
		if tonumber(value) == 1 then
			return true
		end
	end
	return false
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_VIPRewardDB = tTable
end

function release()
	m_VIPRewardDB = nil
	package.loaded["server_VIPRewardStatusDB"] = nil
end