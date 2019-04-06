module("server_GetPrisonBoxInfo",package.seeall)

local m_tabGetInfo = {}
local nBarlength = nil
local curBox_num = nil
function SetTableBuffer( buffer )
	m_tabGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	nBarlength = pNetStream:Read()
	curBox_num = pNetStream:Read()
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabGetInfo)
end

--得到奖励箱子的数量
function GetBoxNum(  )
	if curBox_num == nil then
		return
	else
		return curBox_num
	end
end

--得到进度条的长度
function GetBarLength(  )
	if nBarlength == nil then
		return
	else
		return nBarlength
	end
end

function getCorpsData( keyData )
	return m_tabGetInfo[keyData]
end

function release()
	m_tabGetInfo = nil
	package.loaded["server_GetPrisonBoxRewardInfo"] = nil
end