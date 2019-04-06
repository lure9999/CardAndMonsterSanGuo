-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_dobkResultData", package.seeall)

local m_tableDobkResultDB = {}


local Server_Cmd = {
	fightResult          = 1 ,
    boxCount            = 2, 
	boxExp  = 3,
	luckNum = 4,
	dobkWin = 5,
	Info01_Cmd = 6,
}


local Info01_Cmd = {itemID = 1, count  = 2}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableDobkResultDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
	local list =  pNetStream:Read()
	
	if list~=nil then
		for key, value in pairs(list) do
			m_tableDobkResultDB[key] = {}
			m_tableDobkResultDB[key]["fightResult"] = value[Server_Cmd.fightResult]
			m_tableDobkResultDB[key]["boxCount"] = value[Server_Cmd.boxCount]
			m_tableDobkResultDB[key]["boxExp"] = value[Server_Cmd.boxExp]
			m_tableDobkResultDB[key]["luckNum"] = value[Server_Cmd.luckNum]
			m_tableDobkResultDB[key]["dobkWin"] = value[Server_Cmd.dobkWin]
			m_tableDobkResultDB[key]["Info01_Cmd"]={}
			for key1, value1 in pairs(value[Server_Cmd.Info01_Cmd]) do
				m_tableDobkResultDB[key]["Info01_Cmd"][key1] = {}
				m_tableDobkResultDB[key]["Info01_Cmd"][key1]["itemID"] = value1[Info01_Cmd.itemID]
				m_tableDobkResultDB[key]["Info01_Cmd"][key1]["count"] = value1[Info01_Cmd.count]
			end
		end
		pNetStream = nil
	end
end

--得到碎片的数据
function GetSPData(nIndex)
	--返回暂时数据
	if table.getn(m_tableDobkResultDB[nIndex]["Info01_Cmd"])==0 then
		local tabTempData = {}
		local tabD = {}
		tabD.itemID = 21161
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 21162
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 21164
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 21163
		tabD.count = 2
		table.insert(tabTempData,tabD)
		local tabD = {}
		tabD.itemID = 21162
		tabD.count = 2
		table.insert(tabTempData,tabD)
		return tabTempData
	else
		return m_tableDobkResultDB[nIndex]["Info01_Cmd"]
	end
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableDobkResultDB)
end
--得到失败还是胜利
function GetDobkResult(nIndex)
	
	if m_tableDobkResultDB[nIndex]["fightResult"]== nil then
		return 1
	end
	
	return  m_tableDobkResultDB[nIndex]["fightResult"]
end
--返回是否抢夺到碎片
function GetBDobkWin(nIndex)
	if m_tableDobkResultDB[nIndex]["dobkWin"]== nil then
		return false
	end
	if tonumber(m_tableDobkResultDB[nIndex]["dobkWin"]) == 0 then
		return false
	end
	
	return true
end
--得到幸运草的数量
function GetLuckyCloverNum(nIndex)
	if m_tableDobkResultDB[nIndex]["luckNum"]== nil then
		return 1
	end
	return m_tableDobkResultDB[nIndex]["luckNum"]
end
--得到箱子的数量
function GetBoxNum(nIndex)
	if m_tableDobkResultDB[nIndex]["boxCount"]== nil then
		return 1
	end
	return m_tableDobkResultDB[nIndex]["boxCount"]
end
--得到宝箱的经验
function GetBoxExp(nIndex)
	if m_tableDobkResultDB[nIndex]["boxExp"]== nil then
		return 10
	end
	return m_tableDobkResultDB[nIndex]["boxExp"]
end
-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableDobkResultDB = tTable
end

-- 删除。释放
function release()
    m_tableDobkResultDB = nil
    package.loaded["server_dobkDB"] = nil
end