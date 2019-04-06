module("server_ShopOpenDB",package.seeall)

local m_ShopOpenDB = {}
local n_shopType = nil
local n_open = nil
local is_shopOpen = false
local n_shopID = nil

function SetTableBuffer( buffer )
	m_ShopOpenDB = {}
	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status 		 = pNetStream:Read()		
	n_shopType     = pNetStream:Read()
	n_shopID       = pNetStream:Read()
	n_open         = pNetStream:Read()
	JudgeShopIsOpen(n_open)
	pNetStream = nil

end

function GetCopyTable()	
	return copyTab(m_ShopOpenDB)	
end

--设置表数据，为本地使用
function SetTable( tTable )
	m_ShopOpenDB = tTable
end

function GetSecretShopType(  )
	return n_shopType
end

function GetSecretShopID(  )
	return n_shopID
end

function GetSecretShopOpen(  )
	return n_open
end

function JudgeShopIsOpen( n_openID )
	require "Script/Main/MainScene"
	if n_openID == 0 then
		is_shopOpen = false
	elseif n_openID == 1 then
		is_shopOpen = true
	end
	MainScene.SetSecretShop(is_shopOpen)
end

function release()
	m_ShopOpenDB = nil
	package.loaded["server_ShopOpenDB"] = nil
end