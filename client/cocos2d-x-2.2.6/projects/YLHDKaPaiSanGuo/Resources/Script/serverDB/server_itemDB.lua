-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_itemDB", package.seeall)

local m_tableItemDB = {}


local Server_Cmd = {
    Grid            = 1, 
    Info01          = 2,
    Type            = 3,
    ItemID          = 4,
    RuleID          = 5,
    BindID          = 6,
    Price           = 7,
    Info02          = 8,
    Info03          = 9,
}

local Info01_Cmd = {Serial = 1, Server = 2, World = 3}
local Info02_Cmd = {Param = 1,}
local Info03_Cmd = {Count = 1, EventType = 2,}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableItemDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()
    
    --print(buffer)

    for key, value in pairs(list) do
        m_tableItemDB[key] = {}
        m_tableItemDB[key]["Grid"] = value[Server_Cmd.Grid]
        m_tableItemDB[key]["Info01"] = {}
        m_tableItemDB[key]["Info01"]["Serial"] = value[Server_Cmd.Info01][Info01_Cmd.Serial]
        m_tableItemDB[key]["Info01"]["Server"] = value[Server_Cmd.Info01][Info01_Cmd.Server]
        m_tableItemDB[key]["Info01"]["World"] = value[Server_Cmd.Info01][Info01_Cmd.World]
        m_tableItemDB[key]["Type"] = value[Server_Cmd.Type]
        m_tableItemDB[key]["ItemID"] = value[Server_Cmd.ItemID]
        m_tableItemDB[key]["RuleID"] = value[Server_Cmd.RuleID]
        m_tableItemDB[key]["BindID"] = value[Server_Cmd.BindID]
        m_tableItemDB[key]["Price"] = value[Server_Cmd.Price]
        m_tableItemDB[key]["Info02"] = {}
        m_tableItemDB[key]["Info02"]["Param"] = value[Server_Cmd.Info02][Info02_Cmd.Param]
        m_tableItemDB[key]["Info03"] = {}
        m_tableItemDB[key]["Info03"]["Count"] = value[Server_Cmd.Info03][Info03_Cmd.Count]
        m_tableItemDB[key]["Info03"]["EventType"] = value[Server_Cmd.Info03][Info03_Cmd.EventType]
    end


    pNetStream = nil
end
-- 更新数据
function UpdataTableBuffer(buffer)
	--[[print("UpdataTableBuffer")
	print(buffer)
	Pause()]]--
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()
    for key, value in pairs(list) do
        if tonumber(list[key][Server_Cmd.Info03][Info03_Cmd.Count]) > 0 then
			
            if GetTableByGrid(list[key][Server_Cmd.Grid])~= nil  then
				--print("update=============")
				--Pause()
                UpdataNode(tonumber(list[key][Server_Cmd.Grid]), value)
            else
                AddNode(value)
            end
        else
            -- delete
            DeleteNodeByGird(tonumber(list[key][Server_Cmd.Grid]))
        end
    end

end


-- 添加表数据，拼包时调用
function AddTableBuffer(buffer)
	--[[print("AddTableBuffer")
	print(buffer)
	Paue()]]--
    local tableTemp = cjson.decode(buffer)

    for key, value in pairs(tableTemp) do
        AddNode(value)
    end
end

-- 获得一个物品的格子
function GetGridByIndex(nIndex)
    return m_tableItemDB[nIndex]["Grid"]
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableItemDB)
end

-- 添加一个物品。
function AddNode(item)
     local tableItemTemp = {}
    tableItemTemp["Grid"] = item[Server_Cmd.Grid]
    tableItemTemp["Info01"] = {}
    tableItemTemp["Info01"]["Serial"] = item[Server_Cmd.Info01][Info01_Cmd.Serial]
    tableItemTemp["Info01"]["Server"] = item[Server_Cmd.Info01][Info01_Cmd.Server]
    tableItemTemp["Info01"]["World"] = item[Server_Cmd.Info01][Info01_Cmd.World]
    tableItemTemp["Type"] = item[Server_Cmd.Type]
    tableItemTemp["ItemID"] = item[Server_Cmd.ItemID]
    tableItemTemp["RuleID"] = item[Server_Cmd.RuleID]
    tableItemTemp["BindID"] = item[Server_Cmd.BindID]
    tableItemTemp["Price"] = item[Server_Cmd.Price]
    tableItemTemp["Info02"] = {}
    tableItemTemp["Info02"]["Param"] = item[Server_Cmd.Info02][Info02_Cmd.Param]
    tableItemTemp["Info03"] = {}
    tableItemTemp["Info03"]["Count"] = item[Server_Cmd.Info03][Info03_Cmd.Count]
    tableItemTemp["Info03"]["EventType"] = item[Server_Cmd.Info03][Info03_Cmd.EventType]
    table.insert(m_tableItemDB, tableItemTemp)
end

-- 删除一个物品。
function DeleteNodeByGird(nGird)
    local nIndex = 0
    for key, value in pairs(m_tableItemDB) do
        nIndex = nIndex + 1
        if tonumber(value["Grid"]) == nGird then
            table.remove(m_tableItemDB, nIndex)
            break
        end
    end
end

-- 更新一个物品。
function UpdataNode(nGrid, item)
    local nIndex = 0

    for key, value in pairs(m_tableItemDB) do
        nIndex = nIndex + 1
        if value["Grid"] == nGrid then
            table.remove(m_tableItemDB, nIndex)

            local tableItemTemp = {}
            tableItemTemp["Grid"] = item[Server_Cmd.Grid]
            tableItemTemp["Info01"] = {}
            tableItemTemp["Info01"]["Serial"] = item[Server_Cmd.Info01][Info01_Cmd.Serial]
            tableItemTemp["Info01"]["Server"] = item[Server_Cmd.Info01][Info01_Cmd.Server]
            tableItemTemp["Info01"]["World"] = item[Server_Cmd.Info01][Info01_Cmd.World]
            tableItemTemp["Type"] = item[Server_Cmd.Type]
            tableItemTemp["ItemID"] = item[Server_Cmd.ItemID]
            tableItemTemp["RuleID"] = item[Server_Cmd.RuleID]
            tableItemTemp["BindID"] = item[Server_Cmd.BindID]
            tableItemTemp["Price"] = item[Server_Cmd.Price]
            tableItemTemp["Info02"] = {}
            tableItemTemp["Info02"]["Param"] = item[Server_Cmd.Info02][Info02_Cmd.Param]
            tableItemTemp["Info03"] = {}
            tableItemTemp["Info03"]["Count"] = item[Server_Cmd.Info03][Info03_Cmd.Count]
            tableItemTemp["Info03"]["EventType"] = item[Server_Cmd.Info03][Info03_Cmd.EventType]

            table.insert(m_tableItemDB, nIndex, tableItemTemp)
            return
        end
    end
end

-- 根据key返回一个表数据，也就是返回一个物品的数据
function GetTableByKey(key)
    return m_tableItemDB[key]
end

-- 获得物品数量
function GetItemNumber(nIndex)
    return m_tableItemDB[nIndex]["Info03"]["Count"]
end

-- 获得物品数量
function GetItemNumberByGrid(nGrid)
    for key, value in pairs(m_tableItemDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
             return value["Info03"]["Count"]
        end
    end
    return 0
end
-- 获得物品数量
function GetItemNumberByTempId(nTempID)
    for key, value in pairs(m_tableItemDB) do
        if tonumber(value["ItemID"]) == tonumber(nTempID) then
             return value["Info03"]["Count"]
        end
    end
    return 0
end

function GetAllItemNumByTempId(nTempID)
	local nCount = 0
	local tabItem = nil
	for key, value in pairs(m_tableItemDB) do
        if tonumber(value["ItemID"]) == tonumber(nTempID) then
			nCount = nCount +1
			tabItem = value
            return value["Info03"]["Count"]
        end
    end
	if nCount == 1 then
		return value["Info03"]["Count"]
	else
		return nCount
	end
    return 0
end

-- 根据Grid返回一个表数据，也就是返回一个装备的数据
function GetTableByGrid(nGrid)
    for key, value in pairs(m_tableItemDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
            return copyTab(value)
        end
    end
    return nil
end

-- 获得模版ID
function GetTempId(nIndex)
    return m_tableItemDB[nIndex]["ItemID"]
end
--根据格子获得ID
function GetTempIdByGird(nGird)
	for key, value in pairs(m_tableItemDB) do
        if tonumber(value["Grid"]) == tonumber(nGird) then
            return value["ItemID"]
        end
    end
    return nil
end
--根据ID获得格子
function GetGird(nTempID)
	--[[print(#m_tableItemDB)
	Pause()
	printTab(m_tableItemDB)
	Pause()]]--
	for key, value in pairs(m_tableItemDB) do
        if tonumber(value["ItemID"]) == tonumber(nTempID) then
            return value["Grid"]
        end
    end
    return nil
end

-- 获得数量
function GetCount()
    return table.getn(m_tableItemDB)
end

-- 通过模版id和类型找对应的格子，主要用于箱子开启时，判断钥匙
function GetGridByTempIdAndType(nTempId, nType)
    for key, value in pairs(m_tableItemDB) do
        if tonumber(value["ItemID"]) == tonumber(nTempId) and tonumber(value["Type"]) == tonumber(nType) then
            return value["Grid"]
        end
    end
    return nil
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableItemDB = tTable
end

-- 删除。释放
function release()
    m_tableItemDB = nil
    package.loaded["server_itemDB"] = nil
end

--add by sxin 增加对item table的封装
function Get_ItemNumber(pItemData)
   return pItemData["Info03"]["Count"]
end

function Get_ItemTempID(pItemData)
   return pItemData["ItemID"]
end

function Get_ItemEventType(pItemData)
   return pItemData["Info03"]["EventType"]
end

