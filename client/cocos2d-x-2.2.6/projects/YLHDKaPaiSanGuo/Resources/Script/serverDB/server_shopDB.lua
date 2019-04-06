-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_shopDB", package.seeall)

local m_tableShopDB = {}

local Server_Cmd1 = {
    nShopType                = 1,
    ShopID              = 2,
    RefreshNumber       = 3,    --已经刷新数
    nNumber             = 4,    --再次刷新需要的货币数量
    nTime               = 5,
}
local Server_Cmd2 = {
    Grid                = 1,
    ItemID              = 2,    --物品id
    nReserves           = 3,    --剩下的物品数量
    is_buy              = 4,    -- 是否可购买 0表示不可购买 1 表示可购买
}

local m_ShopID = 1
local m_ShopType = 2
-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableShopDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
	--FileStrprint("server_shopDB",buffer)
    local status = pNetStream:Read()
    local list1 = pNetStream:Read()
    local list2 = pNetStream:Read()
	
    m_ShopType = list1[Server_Cmd1.nShopType]
    local nShopId = list1[Server_Cmd1.ShopID]
    m_ShopID = nShopId
    m_tableShopDB[nShopId] = {}
    m_tableShopDB[nShopId]["nShopType"] = list1[Server_Cmd1.nShopType]
    m_tableShopDB[nShopId]["ShopID"] = list1[Server_Cmd1.ShopID]
    m_tableShopDB[nShopId]["RefreshNumber"] = list1[Server_Cmd1.RefreshNumber]
    m_tableShopDB[nShopId]["nNumber"] = list1[Server_Cmd1.nNumber]
    m_tableShopDB[nShopId]["nTime"] = list1[Server_Cmd1.nTime]
    for key, value in pairs(list2) do
        m_tableShopDB[nShopId][key] = {}
        m_tableShopDB[nShopId][key]["Grid"] = value[Server_Cmd2.Grid]
        m_tableShopDB[nShopId][key]["ItemID"] = value[Server_Cmd2.ItemID]
        m_tableShopDB[nShopId][key]["nReserves"] = value[Server_Cmd2.nReserves]
        m_tableShopDB[nShopId][key]["is_buy"] = value[Server_Cmd2.is_buy]
    end
    pNetStream = nil
end
-- 更新数据
function UpdataTableBuffer(buffer)
    if #m_tableShopDB == nil then
        return
    end
	if next(m_tableShopDB)~=nil then 
		local pNetStream = NetStream()
		pNetStream:SetPacket(buffer)
		local status = pNetStream:Read()
        local n_shoptype = pNetStream:Read()
        local n_shopId = pNetStream:Read()
		local list = pNetStream:Read()
		--list = cjson.decode(buffer)
		--Fileprint("server_shopDB1",list)
		for key, value in pairs(list) do
			if tonumber(list[key][Server_Cmd2.Grid]) > 0 then
				if GetTableByGrid(list[key][Server_Cmd2.Grid],m_ShopID ) then --list[key][Server_Cmd2.ShopID]
					UpdataNode(tonumber(list[key][Server_Cmd2.Grid]), value,m_ShopID ) --list[key][Server_Cmd2.ShopID]
					
				else
					AddNode(value,m_ShopID ) --list[key][Server_Cmd2.ShopID]
				end
			else
				-- delete
				DeleteNodeByGird(tonumber(list[key][Server_Cmd.Grid]), m_ShopID)
			end
		end
	end
	
end

-- 添加表数据，拼包时调用
function AddTableBuffer(shopId, buffer)
    local tableTemp = cjson.decode(buffer)

    for key, value in pairs(tableTemp) do
        AddNode(value, shopId)
    end
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable(shopId)
    if m_tableShopDB[m_ShopID] == nil then
        return nil
    else
        return copyTab(m_tableShopDB[m_ShopID])
    end
end

function GetCopyTableShopID(  )
    return m_ShopID
end

function GetShopType(  )
    return m_ShopType
end

-- 添加一个物品。
function AddNode(item, nShopId)
    local tableItemTemp = {}
    tableItemTemp = {}
    tableItemTemp["Grid"] = item[Server_Cmd2.Grid]
    tableItemTemp["ItemID"] = item[Server_Cmd2.ItemID]
    tableItemTemp["nReserves"] = item[Server_Cmd2.nReserves]
    tableItemTemp["is_buy"] = item[Server_Cmd2.is_buy]

    table.insert(m_tableShopDB[nShopId], tableItemTemp)
end

-- 删除一个物品。
function DeleteNodeByGird(nGird, nShopId)
    local nIndex = 0
    for key, value in pairs(m_tableShopDB[nShopId]) do
        nIndex = nIndex + 1
        if tonumber(value["Grid"]) == nGird then
            table.remove(m_tableShopDB[nShopId], nIndex)
            break
        end
    end
end

-- 更新一个物品。
function UpdataNode(nGrid, item, nShopId)
    local nIndex = 0
    for key, value in pairs(m_tableShopDB[nShopId]) do
        nIndex = nIndex + 1
        if value == m_tableShopDB[nShopId].nTime or value == m_tableShopDB[nShopId].nNumber or value == m_tableShopDB[nShopId].ShopID or value == m_tableShopDB[nShopId].RefreshNumber or value == m_tableShopDB[nShopId].nShopType then
                  
        else
            if tonumber(value["Grid"]) == tonumber(nGrid) then				
                value["ItemID"] = item[2]
                value["nReserves"] = item[3]
                value["is_buy"] = item[4]		    			
                return
            end
        end
    end
	
end

-- 根据Grid返回一个表数据，也就是返回一个装备的数据
function GetTableByGrid(nGrid, n_nShopId)
    -- print("返回一个表数据")
    for key, value in pairs(m_tableShopDB[m_ShopID]) do
       if value == m_tableShopDB[m_ShopID].nTime or value == m_tableShopDB[m_ShopID].nNumber or value == m_tableShopDB[m_ShopID].ShopID or value == m_tableShopDB[m_ShopID].RefreshNumber or value == m_tableShopDB[m_ShopID].nShopType then
			
	   else
			print(value["Grid"])
            if value["Grid"] == nGrid then
                return copyTab(value)
            end
        end
        --[[if value["Grid"] == nGrid then
            return copyTab(value)
        end]]--
    end	
    return nil
end

function GetRefreshCount( nShopId )
    return m_tableShopDB[nShopId]["RefreshNumber"]
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableShopDB = tTable
end

-- 删除。释放
function release()
    m_tableItemDB = nil
    package.loaded["server_shopDB"] = nil
end