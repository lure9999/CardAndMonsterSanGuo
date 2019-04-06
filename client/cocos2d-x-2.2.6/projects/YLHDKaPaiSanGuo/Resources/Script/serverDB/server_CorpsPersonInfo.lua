module("server_CorpsPersonInfo",package.seeall)

local m_tablePersonInfo = {}

function SetTableBuffer( buffer )
	m_tablePersonInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	m_tablePersonInfo.m_uPlayerID = pNetStream:Read()  
	m_tablePersonInfo.m_nLevel = pNetStream:Read()
	m_tablePersonInfo.m_nPower = pNetStream:Read()
	m_tablePersonInfo.m_nFace = pNetStream:Read()
	m_tablePersonInfo.m_nOfficial = pNetStream:Read()
	m_tablePersonInfo.m_nContributeRecent = pNetStream:Read()
	m_tablePersonInfo.m_nContribute = pNetStream:Read()
	m_tablePersonInfo.m_tLastTime = pNetStream:Read()
	m_tablePersonInfo.m_szName = pNetStream:Read()
	m_tablePersonInfo.m_nLegioCoin = pNetStream:Read()

end

function getMainData(keyData)
	return m_tablePersonInfo[keyData]
end

function GetCopyTable(  )
    return copyTab(m_tablePersonInfo)
end

function release()
	m_tablePersonInfo = nil
	package.loaded["server_CorpsPersonInfo"] = nil
end