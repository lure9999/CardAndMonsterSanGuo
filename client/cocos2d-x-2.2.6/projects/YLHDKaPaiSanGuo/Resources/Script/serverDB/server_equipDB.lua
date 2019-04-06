-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_equipDB", package.seeall)

local m_tableEquipDB = {}


local Server_Cmd = {
    Grid            = 1, 
    Info01          = 2,
    TempID          = 3,
    RuleID          = 4,
    BindID          = 5,
    Price           = 6,
    Info02          = 7,
}

local Info01_Cmd = {Serial = 1, Server = 2, World = 3}
local Info02_Cmd = {GeneralID = 1, SetNum = 2, NeedLevel = 3, Updatlevel = 4, protect = 5, 
                    xilian = 6, xilianLucky = 7, xilianTimes = 8, xilianFrontType = 9 , xilianFrontTimes = 10,exp = 11, Info01 = 12,
                    }

local Info02_Info01_Cmd = {Type = 1, Value = 2, Add_Value = 3, Add_Valued = 4,}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableEquipDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()
    --print(buffer)

    for key, value in pairs(list) do
        m_tableEquipDB[key] = {}
        m_tableEquipDB[key]["Grid"] = value[Server_Cmd.Grid]

        m_tableEquipDB[key]["Info01"] = {}
        m_tableEquipDB[key]["Info01"]["Serial"] = value[Server_Cmd.Info01][Info01_Cmd.Serial]
        m_tableEquipDB[key]["Info01"]["Server"] = value[Server_Cmd.Info01][Info01_Cmd.Server]
        m_tableEquipDB[key]["Info01"]["World"] = value[Server_Cmd.Info01][Info01_Cmd.World]

        m_tableEquipDB[key]["TempID"] = value[Server_Cmd.TempID]
        m_tableEquipDB[key]["RuleID"] = value[Server_Cmd.RuleID]
        m_tableEquipDB[key]["BindID"] = value[Server_Cmd.BindID]
        m_tableEquipDB[key]["Price"] = value[Server_Cmd.Price]

        m_tableEquipDB[key]["Info02"] = {}
        m_tableEquipDB[key]["Info02"]["GeneralID"] = value[Server_Cmd.Info02][Info02_Cmd.GeneralID]
        m_tableEquipDB[key]["Info02"]["SetNum"] = value[Server_Cmd.Info02][Info02_Cmd.SetNum]
        m_tableEquipDB[key]["Info02"]["NeedLevel"] = value[Server_Cmd.Info02][Info02_Cmd.NeedLevel]
        m_tableEquipDB[key]["Info02"]["Updatlevel"] = value[Server_Cmd.Info02][Info02_Cmd.Updatlevel]
        m_tableEquipDB[key]["Info02"]["protect"] = value[Server_Cmd.Info02][Info02_Cmd.protect]
        m_tableEquipDB[key]["Info02"]["xilian"] = value[Server_Cmd.Info02][Info02_Cmd.xilian]
        m_tableEquipDB[key]["Info02"]["xilianLucky"] = value[Server_Cmd.Info02][Info02_Cmd.xilianLucky]
        m_tableEquipDB[key]["Info02"]["xilianTimes"] = value[Server_Cmd.Info02][Info02_Cmd.xilianTimes]
		m_tableEquipDB[key]["Info02"]["xilianFrontType"] = value[Server_Cmd.Info02][Info02_Cmd.xilianFrontType]
		m_tableEquipDB[key]["Info02"]["xilianFrontTimes"] = value[Server_Cmd.Info02][Info02_Cmd.xilianFrontTimes]
        m_tableEquipDB[key]["Info02"]["exp"] = value[Server_Cmd.Info02][Info02_Cmd.exp]
        
        m_tableEquipDB[key]["Info02"]["Info01"] = {}
        for key1, value1 in pairs(value[Server_Cmd.Info02][Info02_Cmd.Info01]) do
            m_tableEquipDB[key]["Info02"]["Info01"][key1] = {}
            m_tableEquipDB[key]["Info02"]["Info01"][key1]["Type"] = value1[Info02_Info01_Cmd.Type]
            m_tableEquipDB[key]["Info02"]["Info01"][key1]["Value"] = value1[Info02_Info01_Cmd.Value]
            m_tableEquipDB[key]["Info02"]["Info01"][key1]["Add_Value"] = value1[Info02_Info01_Cmd.Add_Value]
            m_tableEquipDB[key]["Info02"]["Info01"][key1]["Add_Valued"] = value1[Info02_Info01_Cmd.Add_Valued]
        end
    end

    pNetStream = nil

    --[[print("m_tableEquipDB")
    printTab(m_tableEquipDB)
	Pause()]]--
end


-- 更新数据
function UpdataTableBuffer(buffer)

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()
    
    --print("UpdataTableBuffer")
   -- printTab(list)

    for key, value in pairs(list) do
        --print("list[key][Server_Cmd.TempID] = " .. list[key][Server_Cmd.TempID])
        if tonumber(list[key][Server_Cmd.TempID]) > 0 then
            if GetTableByGrid(list[key][Server_Cmd.Grid]) ~= nil then
                UpdataNode(tonumber(list[key][Server_Cmd.Grid]), value)
                --print("UpdataNode")
            else
                AddNode(value)
               -- print("AddNode")
				--Pause()
            end
        else
            -- delete
                print("delete")
            DeleteNodeByGird(tonumber(list[key][Server_Cmd.Grid]))
        end
    end
   -- print("m_tableEquipDBm_tableEquipDBm_tableEquipDB")
   -- printTab(m_tableEquipDB)
end

-- 添加表数据，拼包时调用
function AddTableBuffer(buffer)
    local tableTemp = cjson.decode(buffer)

    for key, value in pairs(tableTemp) do
        AddNode(value)
    end
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	--[[printTab(m_tableEquipDB)
	print("m_tableEquipDB")
	Pause()]]--
    return copyTab(m_tableEquipDB)
end

-- 添加一个装备。
function AddNode(item)
    local tableEquipTemp = {}

    tableEquipTemp["Grid"] = item[Server_Cmd.Grid]

    tableEquipTemp["Info01"] = {}
    tableEquipTemp["Info01"]["Serial"] = item[Server_Cmd.Info01][Info01_Cmd.Serial]
    tableEquipTemp["Info01"]["Server"] = item[Server_Cmd.Info01][Info01_Cmd.Server]
    tableEquipTemp["Info01"]["World"] = item[Server_Cmd.Info01][Info01_Cmd.World]

    tableEquipTemp["TempID"] = item[Server_Cmd.TempID]
    tableEquipTemp["RuleID"] = item[Server_Cmd.RuleID]
    tableEquipTemp["BindID"] = item[Server_Cmd.BindID]
    tableEquipTemp["Price"] = item[Server_Cmd.Price]

    tableEquipTemp["Info02"] = {}
    tableEquipTemp["Info02"]["GeneralID"] = item[Server_Cmd.Info02][Info02_Cmd.GeneralID]
    tableEquipTemp["Info02"]["SetNum"] = item[Server_Cmd.Info02][Info02_Cmd.SetNum]
    tableEquipTemp["Info02"]["NeedLevel"] = item[Server_Cmd.Info02][Info02_Cmd.NeedLevel]
    tableEquipTemp["Info02"]["Updatlevel"] = item[Server_Cmd.Info02][Info02_Cmd.Updatlevel]
    tableEquipTemp["Info02"]["protect"] = item[Server_Cmd.Info02][Info02_Cmd.protect]
    tableEquipTemp["Info02"]["xilian"] = item[Server_Cmd.Info02][Info02_Cmd.xilian]
    tableEquipTemp["Info02"]["xilianLucky"] = item[Server_Cmd.Info02][Info02_Cmd.xilianLucky]
    tableEquipTemp["Info02"]["xilianTimes"] = item[Server_Cmd.Info02][Info02_Cmd.xilianTimes]
	tableEquipTemp["Info02"]["xilianFrontType"] = item[Server_Cmd.Info02][Info02_Cmd.xilianFrontType]
	tableEquipTemp["Info02"]["xilianFrontTimes"] = item[Server_Cmd.Info02][Info02_Cmd.xilianFrontTimes]
    tableEquipTemp["Info02"]["exp"] = item[Server_Cmd.Info02][Info02_Cmd.exp]

    tableEquipTemp["Info02"]["Info01"] = {}
    for key1, value1 in pairs(item[Server_Cmd.Info02][Info02_Cmd.Info01]) do
        tableEquipTemp["Info02"]["Info01"][key1] = {}
        tableEquipTemp["Info02"]["Info01"][key1]["Type"] = value1[Info02_Info01_Cmd.Type]
        tableEquipTemp["Info02"]["Info01"][key1]["Value"] = value1[Info02_Info01_Cmd.Value]
        tableEquipTemp["Info02"]["Info01"][key1]["Add_Value"] = value1[Info02_Info01_Cmd.Add_Value]
        tableEquipTemp["Info02"]["Info01"][key1]["Add_Valued"] = value1[Info02_Info01_Cmd.Add_Valued]
    end

    table.insert(m_tableEquipDB, tableEquipTemp)
	--[[printTab(m_tableEquipDB)
	print("add___________________________")
	Pause()]]--
end


-- 删除一个装备。
function DeleteNodeByGird(nGird)
    local nIndex = 0
    for key, value in pairs(m_tableEquipDB) do
        nIndex = nIndex + 1
        if tonumber(value["Grid"]) == nGird then
            table.remove(m_tableEquipDB, nIndex)
            break
        end
    end
end

-- 更新一个物品。
function UpdataNode(nGrid, item)
    local nIndex = 0

    for key, value in pairs(m_tableEquipDB) do
        nIndex = nIndex + 1
        if value["Grid"] == nGrid then
            table.remove(m_tableEquipDB, nIndex)


            local tableEquipTemp = {}

            tableEquipTemp["Grid"] = item[Server_Cmd.Grid]

            tableEquipTemp["Info01"] = {}
            tableEquipTemp["Info01"]["Serial"] = item[Server_Cmd.Info01][Info01_Cmd.Serial]
            tableEquipTemp["Info01"]["Server"] = item[Server_Cmd.Info01][Info01_Cmd.Server]
            tableEquipTemp["Info01"]["World"] = item[Server_Cmd.Info01][Info01_Cmd.World]

            tableEquipTemp["TempID"] = item[Server_Cmd.TempID]
            tableEquipTemp["RuleID"] = item[Server_Cmd.RuleID]
            tableEquipTemp["BindID"] = item[Server_Cmd.BindID]
            tableEquipTemp["Price"] = item[Server_Cmd.Price]

            tableEquipTemp["Info02"] = {}
            tableEquipTemp["Info02"]["GeneralID"] = item[Server_Cmd.Info02][Info02_Cmd.GeneralID]
            tableEquipTemp["Info02"]["SetNum"] = item[Server_Cmd.Info02][Info02_Cmd.SetNum]
            tableEquipTemp["Info02"]["NeedLevel"] = item[Server_Cmd.Info02][Info02_Cmd.NeedLevel]
            tableEquipTemp["Info02"]["Updatlevel"] = item[Server_Cmd.Info02][Info02_Cmd.Updatlevel]
            tableEquipTemp["Info02"]["protect"] = item[Server_Cmd.Info02][Info02_Cmd.protect]
            tableEquipTemp["Info02"]["xilian"] = item[Server_Cmd.Info02][Info02_Cmd.xilian]
            tableEquipTemp["Info02"]["xilianLucky"] = item[Server_Cmd.Info02][Info02_Cmd.xilianLucky]
            tableEquipTemp["Info02"]["xilianTimes"] = item[Server_Cmd.Info02][Info02_Cmd.xilianTimes]
			tableEquipTemp["Info02"]["xilianFrontType"] = item[Server_Cmd.Info02][Info02_Cmd.xilianFrontType]
			tableEquipTemp["Info02"]["xilianFrontTimes"] = item[Server_Cmd.Info02][Info02_Cmd.xilianFrontTimes]
			
            tableEquipTemp["Info02"]["exp"] = item[Server_Cmd.Info02][Info02_Cmd.exp]

            tableEquipTemp["Info02"]["Info01"] = {}
            for key1, value1 in pairs(item[Server_Cmd.Info02][Info02_Cmd.Info01]) do
                tableEquipTemp["Info02"]["Info01"][key1] = {}
                tableEquipTemp["Info02"]["Info01"][key1]["Type"] = value1[Info02_Info01_Cmd.Type]
                tableEquipTemp["Info02"]["Info01"][key1]["Value"] = value1[Info02_Info01_Cmd.Value]
                tableEquipTemp["Info02"]["Info01"][key1]["Add_Value"] = value1[Info02_Info01_Cmd.Add_Value]
                tableEquipTemp["Info02"]["Info01"][key1]["Add_Valued"] = value1[Info02_Info01_Cmd.Add_Valued]
            end
            
            table.insert(m_tableEquipDB, nIndex, tableEquipTemp)
            return
        end
    end
end

-- 获得等级
function GetLevel(nIndex)
    return m_tableEquipDB[nIndex]["Info02"]["Updatlevel"]
end
function GetFrontTypeByGrid(nGrid)
	for key, value in pairs(m_tableEquipDB) do
		--print("value__-------:"..value["Grid"])
        if value["Grid"] == tonumber(nGrid) then
			--print("p============"..value["Info02"]["Updatlevel"])
            return value["Info02"]["xilianFrontType"]
        end
    end
    return nil

end

function GetFrontTimesByGrid(nGrid)
	for key, value in pairs(m_tableEquipDB) do
		--print("value__-------:"..value["Grid"])
        if value["Grid"] == tonumber(nGrid) then
			--print("p============"..value["Info02"]["Updatlevel"])
            return value["Info02"]["xilianFrontTimes"]
        end
    end
    return nil
end
function GetListVauledByGird(nGrid)
	local templist = {}
	--print("nGrid:"..nGrid)
	for key, value in pairs(m_tableEquipDB) do
		if tonumber(value["Grid"]) == tonumber(nGrid) then
			local table_temp = value["Info02"]["Info01"]
			for key1,value1 in pairs(table_temp) do 
				local table_list = {}
				print(value1["Add_Valued"])
				table.insert(table_list,value1["Add_Valued"])
				table.insert(templist,table_list)
			end
			
		end
	end
	--[[print("===================")
	printTab(templist)]]--
	return templist
end
-- 获得等级
function GetLevelByGrid(nGrid)
	---print("nGrid=------------------:"..nGrid)
	--printTab(m_tableEquipDB)
    for key, value in pairs(m_tableEquipDB) do
		--print("value__-------:"..value["Grid"])
        if value["Grid"] == nGrid then
			--print("p============"..value["Info02"]["Updatlevel"])
            return value["Info02"]["Updatlevel"]
        end
    end
    return nil
end

-- 根据key返回一个表数据，也就是返回一个物品的数据
function GetTableByKey(key)
    return m_tableEquipDB[key]
end

-- 根据Grid返回一个表数据，也就是返回一个装备的数据
function GetTableByGrid(nGrid)
    for key, value in pairs(m_tableEquipDB) do
        if value["Grid"] == nGrid then
            return copyTab(value)
        end
    end
    return nil
end

-- 根据Grid返回一个模版ID
function GetTempIdByGrid(nGrid)
    for key, value in pairs(m_tableEquipDB) do
        if tonumber( value["Grid"]) == tonumber(nGrid) then
            return value["TempID"]
        end
    end
    return nil
end

function GetGridByIndex(nIndex)
    return m_tableEquipDB[nIndex]["Grid"]
end

-- 获得模版ID
function GetTempId(nGrid)
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
            return value["TempID"]
        end
    end
    return nil
end
--根据服务器次序获得洗练次数
function GetXLTimes(nGrid)
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
            return value["Info02"]["xilianTimes"]
        end
    end
    return nil
end
--根据服务器次序获得当前的经验
function GetExp(nGrid)
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
            return value["Info02"]["exp"]
        end
    end
    return nil
end
--根据格子返回当前的经验
function GetExpByGrid(nGrid)
	--print("--============")
	--printTab(m_tableEquipDB)
	for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
            return value["Info02"]["exp"]
        end
    end
    return nil
end
--获得洗练次数
function GetXLTimesByGrid(nGrid)
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
            return value["Info02"]["xilianTimes"]
        end
    end
    return nil
end


function GetStrengthenByGrid(nGrid)
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["Grid"]) == tonumber(nGrid) then
            return value["Info02"]["Info01"]
        end
    end
    return nil
end

-- 获得所有模板ID相同的装备格子
function GetGridTabByTempId(nTempId)
    local tabGrid = {}
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["TempID"]) == tonumber(nTempId) then
            table.insert(tabGrid, value["Grid"])
        end
    end
    return tabGrid
end

function GetUnEquipedGridByTempId( nTempId )
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["TempID"]) == tonumber(nTempID) then
            require "Script/serverDB/server_matrixDB"
            if  server_matrixDB.IsShangZhenEquip(value["Grid"]) == false then
                return value["Grid"]
            end
        end
    end
end

-- 获得物品数量
function GetEquipNumberByTempId(nTempID)
    local nCount = 0
    for key, value in pairs(m_tableEquipDB) do
        if tonumber(value["TempID"]) == tonumber(nTempID) then
             nCount = nCount + 1
        end
    end
    return nCount
end
--获得减掉已装备的装备的数量
function GetEquipNumByTempId(nTempID)
    local nCount = 0
    for key, value in pairs(m_tableEquipDB) do
		--[[local nItemType = tonumber(ItemData.GetItemTypeByTempID(value["TempID"]))
		if nItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
			print(value["TempID"])
			Pause()
		end]]--
        if tonumber(value["TempID"]) == tonumber(nTempID) then
			require "Script/serverDB/server_matrixDB"
			if	server_matrixDB.IsShangZhenEquip(value["Grid"]) == false then
				nCount = nCount + 1
			end
        end
    end
    return nCount
end

-- 获得Grid
function GetGridByTempId(nTempId)
    for key, value in pairs(m_tableEquipDB) do
        if value["TempID"] == nTempId then
            return value["Grid"]
        end
    end
    return nil
end

-- 获得Grid
function GetIndexByTempId(nTempId)
    for key, value in pairs(m_tableEquipDB) do
        if value["TempID"] == nTempId then
            return key
        end
    end
    return nil
end

-- 获得Grid
function GetIndexByGrid(nTempId)
    for key, value in pairs(m_tableEquipDB) do
        if value["Grid"] == nTempId then
            return key
        end
    end
    return nil
end


-- 获得数量
function GetCount()
    return table.getn(m_tableEquipDB)
end

function GetCountByType(nType)
	for key, value in pairs(m_tableEquipDB) do
        if value["Grid"] == nTempId then
            return key
        end
    end
    return 0
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableEquipDB = tTable
end

-- 删除。释放
function release()
    m_tableEquipDB = nil
    package.loaded["server_equipDB"] = nil
end