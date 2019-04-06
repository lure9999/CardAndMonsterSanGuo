module("server_GetPrisonBRDB",package.seeall)
require "Script/Main/Item/GetGoodsLayer"
local m_tabGetInfo = {}
function SetTableBuffer( buffer )
	m_tabGetInfo = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local list1 = pNetStream:Read()
	local list2 = pNetStream:Read()
	
	if next(list2) ~= nil then
		GetGoodsLayer.createGetGoods(list2,nil)
	end
	pNetStream = nil

end

function GetCopyTable(  )
    return copyTab(m_tabGetInfo)
end

function release()
	m_tabGetInfo = nil
	package.loaded["server_GetPrisonBRDB"] = nil
end