-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_dobkDB", package.seeall)

local m_tableDobkDB = {}


local Server_Cmd = {
    status            = 1, 
	boxCount          = 2 ,
    boxExp            = 3, 
	luckyClover  = 4,
	listSW = 5,
	listBW = 6,
}
local boxCount = nil
local boxExp = nil 
local luckyClover = nil

local Info01_Cmd = {itemID = 1, count  = 2}

-- ���������ַ������ַ���תΪ���ʽ
function SetTableBuffer(buffer)
    m_tableDobkDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
	boxCount  = pNetStream:Read()
	boxExp = pNetStream:Read()
	luckyClover = pNetStream:Read()
    local listSW = pNetStream:Read()
	local listBW = pNetStream:Read()
	
	m_tableDobkDB[1] = {}
    for key, value in pairs(listSW) do
        m_tableDobkDB[1][key] = {}
        m_tableDobkDB[1][key]["itemID"] = value[Info01_Cmd.itemID]
		m_tableDobkDB[1][key]["count"] = value[Info01_Cmd.count]
    end
	m_tableDobkDB[2] = {}
    for key, value in pairs(listBW) do
        m_tableDobkDB[2][key] = {}
        m_tableDobkDB[2][key]["itemID"] = value[Info01_Cmd.itemID]
		m_tableDobkDB[2][key]["count"] = value[Info01_Cmd.count]
    end
	
    pNetStream = nil
end

--�õ���Ƭ������
function GetSPData(nType)
	--������ʱ����
	if table.getn(m_tableDobkDB)==0 then
		local tabTempData = {}
		local tabD = {}
		tabD.itemID = 23212
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 23213
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 23214
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 23221
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 23211
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 23200
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 23201
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 23202
		tabD.count = 2
		table.insert(tabTempData,tabD)
		return tabTempData
	else
		return m_tableDobkDB[nType+1]
	end
	
end

-- ���һ�����Ƶı�ʹ�ú�ɾ������
function GetCopyTable()
	
    return copyTab(m_tableDobkDB)
end
--�õ����ĵ�����
function GetBoxExp()
	if boxExp== nil then
		return 3
	end
	return boxExp
end
--�õ����˲ݵ�����
function GetLuckyCloverNum()
	if luckyClover== nil then
		return 0
	end
	return luckyClover
end
function GetBoxNum()
	if boxCount== nil then
		return 0
	end
	return boxCount
end
-- ���ñ����ݣ�ֻΪ���ز����á�
function SetTable(tTable)
    m_tableDobkDB = tTable
end

-- ɾ�����ͷ�
function release()
    m_tableDobkDB = nil
    package.loaded["server_dobkDB"] = nil
end