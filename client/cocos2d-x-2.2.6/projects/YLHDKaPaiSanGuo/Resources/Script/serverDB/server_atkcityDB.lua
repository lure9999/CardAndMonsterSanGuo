
--攻城战的数据 celina
-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_atkcityDB", package.seeall)

local table_wj_war = {
	{"6001","6002"},
	{"6003","6004"},
	{"6005","6006"},
	{"6007","6008"},
	{"6009","6010"},
	{"6011","6012"},
	{"80011","80021"},
	{"80012","80032"},
	{"80013","80043"},
	{"81011","81021"},
	{"81012","81032"},
	{"81013","81043"},
	{"6014","6015"},
}
local m_tableAtkCtiyDB = {}


local Server_Cmd = {
    status            = 1, 
	
}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableAtkCtiyDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
	
	
	
	
    pNetStream = nil
end

--暂时先写一个测试数据
function GetAtkCityTestData()
	--暂时先写界面用到的一些数据，到时候再和服务器对
	--需要前面12组人的信息 每组第一个表示正在打斗的
	m_tableAtkCtiyDB.MyTeamNum = math.random(3,15)
	m_tableAtkCtiyDB.OtherTeamNum = math.random(3,15)
	--只存当前正在打斗一组数据
	local curNum = math.random(1,12)
	m_tableAtkCtiyDB.TeamAtk = {}
	table.insert(m_tableAtkCtiyDB.TeamAtk,table_wj_war[curNum])
	return m_tableAtkCtiyDB
end

--得到当前打斗的数据
function GetCurAtkData()
	return m_tableAtkCtiyDB.TeamAtk[1]
end
--得到当前的我方列表数据
function GetMyTeamNum()
	return m_tableAtkCtiyDB.MyTeamNum
end
function GetOtherTeamNum()
	return m_tableAtkCtiyDB.OtherTeamNum
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableAtkCtiyDB)
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableAtkCtiyDB = tTable
end

-- 删除。释放
function release()
    m_tableAtkCtiyDB = nil
    package.loaded["server_atkcityDB"] = nil
end