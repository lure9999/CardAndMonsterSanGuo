--豪华签到数据解析
module("server_SignInLuxuryDB",package.seeall)

local m_tabSignInLuxury = {}


function SetTableBuffer( buffer )
	m_tabSignInLuxury = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 	= pNetStream:Read()
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_tabSignInLuxury)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_tabSignInLuxury = tTable
end

function release()
	m_tabSignInLuxury = nil
	package.loaded["server_SignInLuxuryDB"] = nil
end