-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_matrixDB", package.seeall)

local m_tableMatrixDB = {}

local Server_Cmd = {
    Grid                = 1,
    Info01              = 2,
}

local Info01_Cmd = {generalgrid = 1, Info01 = 2,}

local Info01_Info01_Cmd = {equipgrid1 = 1, equipgrid2 = 2, equipgrid3 = 3, equipgrid4 = 4, equipgrid5 = 5, equipgrid6 = 6}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableMatrixDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()

    for key, value in pairs(list) do
        m_tableMatrixDB[key] = {}
        m_tableMatrixDB[key]["Grid"] = value[Server_Cmd.Grid]
        m_tableMatrixDB[key]["Info01"] = {}
        m_tableMatrixDB[key]["Info01"]["generalgrid"] = value[Server_Cmd.Info01][Info01_Cmd.generalgrid]
        m_tableMatrixDB[key]["Info01"]["Info01"] = {}
        m_tableMatrixDB[key]["Info01"]["Info01"]["equipgrid1"] = value[Server_Cmd.Info01][Info01_Cmd.Info01][Info01_Info01_Cmd.equipgrid1]
        m_tableMatrixDB[key]["Info01"]["Info01"]["equipgrid2"] = value[Server_Cmd.Info01][Info01_Cmd.Info01][Info01_Info01_Cmd.equipgrid2]
        m_tableMatrixDB[key]["Info01"]["Info01"]["equipgrid3"] = value[Server_Cmd.Info01][Info01_Cmd.Info01][Info01_Info01_Cmd.equipgrid3]
        m_tableMatrixDB[key]["Info01"]["Info01"]["equipgrid4"] = value[Server_Cmd.Info01][Info01_Cmd.Info01][Info01_Info01_Cmd.equipgrid4]
        m_tableMatrixDB[key]["Info01"]["Info01"]["equipgrid5"] = value[Server_Cmd.Info01][Info01_Cmd.Info01][Info01_Info01_Cmd.equipgrid5]
        m_tableMatrixDB[key]["Info01"]["Info01"]["equipgrid6"] = value[Server_Cmd.Info01][Info01_Cmd.Info01][Info01_Info01_Cmd.equipgrid6]
    end


    --m_tableMatrixDB = CommonInterface.DisSort(m_tableMatrixDB)
	--print("m_tableMatrixDBm_tableMatrixDBm_tableMatrixDBm_tableMatrixDB = ")
	--printTab(m_tableMatrixDB)
    pNetStream = nil
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
    return copyTab(m_tableMatrixDB)
end

-- 添加一个物品。
function AddNode(item)
    table.insert(m_tableMatrixDB, item)
end

-- 删除一个物品。
function DeleteNodeByIndex(nIndex)
    table.remove(m_tableMatrixDB, nIndex)
end

-- 判断武将是否上阵
function IsShangZhen(nGrid)
    if nGrid <= 0 then return false end
    for key, value in pairs(m_tableMatrixDB) do
        if value["Info01"]["generalgrid"] == nGrid then
            return true
        end
    end
    return false
end

-- 获得上阵个数
function GetGeneralCount()
    local nCount = 0
    for key, value in pairs(m_tableMatrixDB) do
        if tonumber(value["Info01"]["generalgrid"]) > 0 and tonumber(value["Grid"]) ~= 6 then
            nCount = nCount + 1
        end
    end

    return nCount
end

-- 判断装备是否上阵
function IsShangZhenEquip(nGrid)
    if nGrid <= 0 then return false end
    for key, value in pairs(m_tableMatrixDB) do
        --if tonumber(value["Grid"]) ~= 6 then
            if value["Info01"]["Info01"]["equipgrid1"] == nGrid then
                return true
            end
            if value["Info01"]["Info01"]["equipgrid2"] == nGrid then
                return true
            end
            if value["Info01"]["Info01"]["equipgrid3"] == nGrid then
                return true
            end
            if value["Info01"]["Info01"]["equipgrid4"] == nGrid then
                return true
            end
            if value["Info01"]["Info01"]["equipgrid5"] == nGrid then
                return true
            end
            if value["Info01"]["Info01"]["equipgrid6"] == nGrid then
                return true
            end
        --end
    end
    return false
end

-- 通过装备格子获取武将格子
function GetGeneralGridByEquipGrid(nGrid)
    if nGrid <= 0 then return nil end
    for key, value in pairs(m_tableMatrixDB) do
        if value["Info01"]["Info01"]["equipgrid1"] == nGrid then
            return value["Info01"]["generalgrid"]
        end
        if value["Info01"]["Info01"]["equipgrid2"] == nGrid then
            return value["Info01"]["generalgrid"]
        end
        if value["Info01"]["Info01"]["equipgrid3"] == nGrid then
            return value["Info01"]["generalgrid"]
        end
        if value["Info01"]["Info01"]["equipgrid4"] == nGrid then
            return value["Info01"]["generalgrid"]
        end
        if value["Info01"]["Info01"]["equipgrid5"] == nGrid then
            return value["Info01"]["generalgrid"]
        end
        if value["Info01"]["Info01"]["equipgrid6"] == nGrid then
            return value["Info01"]["generalgrid"]
        end
    end 
    return nil 
end

-- 通过武将格子获取武将的装备列表
function GetEquipListByGeneralGrid( nGrid )
    local tabEquipList = {}
      for key, value in pairs(m_tableMatrixDB) do
        if value["Info01"]["generalgrid"] == nGrid then
            for i=1,6 do
                 table.insert(tabEquipList, value["Info01"]["Info01"]["equipgrid"..tostring(i)])
            end
        end
    end
    return tabEquipList
end

function SetGeneralGrid(nGrid, nIndex)
   m_tableMatrixDB[nIndex]["Info01"]["generalgrid"] = nGrid
end

function SetEquipGrid(nGrid, nIndexRoot, nIndex)
    m_tableMatrixDB[nIndexRoot]["Info01"]["Info01"]["equipgrid" .. nIndex] = nGrid
end

function DeleteEquipByEquipGrid(nGrid, nIndex)

    for key, value in pairs(m_tableMatrixDB) do
        --if tonumber(value["Grid"]) ~= 6 then
            if tonumber(value["Info01"]["Info01"]["equipgrid" .. nIndex]) == tonumber(nGrid) then
                value["Info01"]["Info01"]["equipgrid" .. nIndex] = 0
                break
            end
        --end
    end

end

-- 通过阵容格子得到装备格子
function GetEquipGrid(nGrid, nIndex)
    local nGridTemp = -1
    for key, value in pairs(m_tableMatrixDB) do
        if tonumber(value["Grid"]) == nGrid then
            nGridTemp = value["Info01"]["Info01"]["equipgrid" .. nIndex]
            break
        end
    end
    
    return nGridTemp
end

-- 与服务器同步阵容信息
function SendMatrixToServer(tableMatrix, callBack)

	--[[
    function comps(a,b)
        if a["Grid"] > b["Grid"] then
            return true
        else
            return false
        end
    end
    table.sort(tableMatrix, comps)

    local sendTable = {}
    tableMatrix[2]["Grid"] = 1
    table.insert(sendTable, tableMatrix[2])
    tableMatrix[3]["Grid"] = 2
    table.insert(sendTable, tableMatrix[3])
    tableMatrix[4]["Grid"] = 3
    table.insert(sendTable, tableMatrix[4])
    tableMatrix[5]["Grid"] = 4
    table.insert(sendTable, tableMatrix[5])
    tableMatrix[6]["Grid"] = 5
    table.insert(sendTable, tableMatrix[6])
    table.insert(sendTable, tableMatrix[1])
	]]
	
    function deleteKeyTab(st)
        local tab = {}
        for k, v in pairs(st or {}) do
            if type(v) ~= "table" then
                local nF = string.find(k, "equipgrid")
                if nF ~= nil then
                    for i = 1, 6 do
                        table.insert(tab, i, st["equipgrid" .. i])
                    end
                    return tab
                else
                    table.insert(tab, v)
                end
            else
                table.insert(tab, deleteKeyTab(v))
            end
        end
        return tab
    end

    local sendTable = deleteKeyTab(tableMatrix)

    --Pause()
	--printTab(sendTable)
	--Pause()
    Packet_ChangeMatrix.SetSuccessCallBack(callBack)
    network.NetWorkEvent(Packet_ChangeMatrix.CreatPacket(sendTable))
end

-- 通过阵容格子得到武将格子
function GetGeneralGrid(nGrid)
    local nGridTemp = 0
    for key, value in pairs(m_tableMatrixDB) do
        if value["Grid"] == nGrid then
            nGridTemp = value["Info01"]["generalgrid"]
            break
        end
    end
    
    return nGridTemp
end

--获得当前上阵的武将Grid
function GetWJGridInMatrix( )
    local tab = {}
    for key ,value in pairs(GetCopyTable()) do
        local nWJGrid = GetGeneralGrid(tonumber(value["Grid"]))
        if nWJGrid > 0 then
            table.insert(tab,nWJGrid)
        end
    end
    return tab
end

--通过武将格子获得阵容格子
function GetMatrixDBByWJ(nWJGrid)
	 for key, value in pairs(m_tableMatrixDB) do
		if tonumber(value["Info01"]["generalgrid"]) == tonumber(nWJGrid) then
			return value["Grid"]
		end
    end
    
    return nil
end
-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableMatrixDB = tTable
end

-- 删除。释放
function release()
    m_tableMatrixDB = nil
    package.loaded["server_matrixDB"] = nil
end