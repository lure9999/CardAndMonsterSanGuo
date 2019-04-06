--获得攻城战界面的详细战队信息 celina

local cjson = require "json"

module("server_getWarList", package.seeall)

local m_tableWarListDB = {}
local Server_Cmd = {
	nStatus= 1,
	Info01 = 2,
	Info02 = 3,
}
local orgNum = 0
local Info01_Cmd = {power = 1, num = 2,Info02_Cmd=3}
local Info02_Cmd = {lv = 1, nameTeam = 2, nameSelf = 3,state=4,nType =5 }
local nPage = 0
local nTeamNum  = 0
-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableWarListDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local nStatus = pNetStream:Read()
	local nTeamType = pNetStream:Read() --攻方还是守方
	nPage = pNetStream:Read() --当前页数
	nTeamNum = pNetStream:Read() --队伍数量
	local list  = pNetStream:Read()
	--printTab(list)
	--Pause()
	for key, value in pairs(list) do
		m_tableWarListDB[key] = {}
		m_tableWarListDB[key]["lv"] = value[Info02_Cmd.lv]
		m_tableWarListDB[key]["nameTeam"] = value[Info02_Cmd.nameTeam]
		m_tableWarListDB[key]["nameSelf"] = value[Info02_Cmd.nameSelf]
		m_tableWarListDB[key]["state"] = value[Info02_Cmd.state]
		m_tableWarListDB[key]["nType"] = value[Info02_Cmd.nType]
    end
	--[[printTab(m_tableWarListDB)
	Pause()]]--
	--[[print("更新列表")
	--AtkCityScene.SetUpdateList(true)
	AtkCityScene.UpdateListInfo()
	if MainScene.GetObserver()~=nil then
		MainScene.GetObserver():Notify()
	end]]--
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    return copyTab(m_tableWarListDB)
end


function GetPageNum()
	return nPage
end
function GetTeamNum()
	return nTeamNum
end
-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableWarListDB = tTable
end

-- 删除。释放
function release()
    m_tableWarListDB = nil
    package.loaded["server_getWarList"] = nil
end