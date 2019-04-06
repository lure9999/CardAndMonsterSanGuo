--获得攻城战结果的信息  celina

local cjson = require "json"

module("server_countrywarResultDB", package.seeall)

local m_tableWarResultDB = {}

local nWin = 0
local nNumLS = 0
local nNumHurt  = 0
local nNumLostHp= 0
local Server_Cmd = {
	nStatus= 1,
	Info01 = 2,
}

local Info01_Cmd = {Type = 1, Num = 2}
local Info02_Cmd = {ItemID = 1, ItemNum = 2}
-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)	
    m_tableWarResultDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local nStatus = pNetStream:Read()
	nWin = pNetStream:Read()
	nNumLS = pNetStream:Read()
	nNumHurt = pNetStream:Read()
	nNumLostHp = pNetStream:Read()
	local listBaseReWard = pNetStream:Read()
	local listItemReWard = pNetStream:Read()
	m_tableWarResultDB["BaseReward"] = {}
	for key,value in pairs(listBaseReWard) do 
		m_tableWarResultDB["BaseReward"][key] = {}
		m_tableWarResultDB["BaseReward"][key]["Type"] = value[Info01_Cmd.Type]
		m_tableWarResultDB["BaseReward"][key]["Num"] = value[Info01_Cmd.Num]
	end
	m_tableWarResultDB["ItemReWard"] = {}
	for key,value in pairs(listItemReWard) do
		m_tableWarResultDB["ItemReWard"][key] = {}
		m_tableWarResultDB["ItemReWard"][key]["ItemID"] = value[Info02_Cmd.ItemID]
		m_tableWarResultDB["ItemReWard"][key]["ItemNum"] = value[Info02_Cmd.ItemNum]
	end
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    return copyTab(m_tableWarResultDB)
end

function GetResultWin()
	return nWin
end
function GetResultMaxLS()
	return nNumLS
end
function GetResultHurt()
	return nNumHurt
end
function GetResultLost()
	return nNumLostHp
end
function GetResultReWard()
	return m_tableWarResultDB
end
-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableWarResultDB = tTable
end

-- 删除。释放
function release()
    m_tableWarResultDB = nil
    package.loaded["server_countrywarResultDB"] = nil
end