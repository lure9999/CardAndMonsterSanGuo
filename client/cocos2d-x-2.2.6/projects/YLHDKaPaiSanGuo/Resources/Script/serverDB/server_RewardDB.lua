module("server_RewardDB",package.seeall)

m_tabRewardInfo = {}
Server_Cmd = {
	id		= 1,
	num 	= 2,
	name 	= 3,
}

function SetTableBuffer( buffer )
	m_tabRewardInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
	for key,value in pairs(list) do
		m_tabRewardInfo[key] = {}
		m_tabRewardInfo[key]["id"] = value[1]
		m_tabRewardInfo[key]["num"] = value[2]
		m_tabRewardInfo[key]["name"] = value[3]
	end
	RefreshListView()
	JudgeIsOpen()
	RefreshBtnStatus()
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabRewardInfo)
end

function getCorpsData( keyData )
	return m_tabRewardInfo[keyData]
end

function RefreshListView(  )
	local messDB = GetCopyTable()
    require "Script/Main/CountryReward/CountryRewardLayer"
    CountryRewardLayer.GetDataByServer()
end

--判断是否显示打开国战奖励的图标
function JudgeIsOpen(  )
	local tab = GetCopyTable()
	if next(tab) ~= nil then
		return true
	end
	return false
end

--及时更新图标的状态
function RefreshBtnStatus(  )
	require "Script/Main/CountryWar/CountryUILayer"
	local tab = GetCopyTable()
	CountryUILayer.SetRewardPoint()
end

function release()
	m_tabRewardInfo = nil
	package.loaded["server_RewardDB"] = nil
end