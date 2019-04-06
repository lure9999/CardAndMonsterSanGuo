--获得攻城战结果的信息  celina

local cjson = require "json"

module("server_BloorOrDefenseResultDB", package.seeall)

local m_tableBloodOrDefenseResultDB = {}

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
    m_tableBloodOrDefenseResultDB = {}

	local pNetStream = NetStream()
	pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	local isAct  = pNetStream:Read()
	local isSuccess = pNetStream:Read()

	nWin = -1
	nNumLS = pNetStream:Read()
	nNumHurt = pNetStream:Read()
	nNumLostHp = pNetStream:Read()


	local pRewardCoinDB = pNetStream:Read()
	local pRewardItemDB = pNetStream:Read()

	m_tableBloodOrDefenseResultDB["BaseReward"] = {}
	m_tableBloodOrDefenseResultDB["ItemReWard"] = {}

	if pRewardCoinDB == nil or pRewardItemDB == nil then
		return 
	end

	for key,value in pairs(pRewardCoinDB) do 
		m_tableBloodOrDefenseResultDB["BaseReward"][key] = {}
		m_tableBloodOrDefenseResultDB["BaseReward"][key]["Type"] = value[Info01_Cmd.Type]
		m_tableBloodOrDefenseResultDB["BaseReward"][key]["Num"] = value[Info01_Cmd.Num]
	end

	for key,value in pairs(pRewardItemDB) do
		m_tableBloodOrDefenseResultDB["ItemReWard"][key] = {}
		m_tableBloodOrDefenseResultDB["ItemReWard"][key]["ItemID"] = value[Info02_Cmd.ItemID]
		m_tableBloodOrDefenseResultDB["ItemReWard"][key]["ItemNum"] = value[Info02_Cmd.ItemNum]
	end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    return copyTab(m_tableBloodOrDefenseResultDB)
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
	return m_tableBloodOrDefenseResultDB
end
-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableBloodOrDefenseResultDB = tTable
end

-- 删除。释放
function release()
    m_tableBloodOrDefenseResultDB = nil
    package.loaded["server_BloorOrDefenseResultDB"] = nil
end