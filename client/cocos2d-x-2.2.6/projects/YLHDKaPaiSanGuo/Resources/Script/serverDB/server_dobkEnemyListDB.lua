-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_dobkEnemyListDB", package.seeall)

local m_tableDobkListDB = {}


local Server_Cmd = {
	headID          = 1 ,--头像
	modelID         = 2,
    level            = 3, 
	name  = 4,
	power = 5,
	winRate = 6,
	eID      = 7,
}



-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    server_dobkEnemyListDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()
    for key, value in pairs(list) do
        server_dobkEnemyListDB[key] = {}
        server_dobkEnemyListDB[key]["headID"] = value[Server_Cmd.headID]
		server_dobkEnemyListDB[key]["modelID"] = value[Server_Cmd.modelID]
		server_dobkEnemyListDB[key]["level"] = value[Server_Cmd.level]
		server_dobkEnemyListDB[key]["name"] = value[Server_Cmd.name]
		server_dobkEnemyListDB[key]["power"] = value[Server_Cmd.power]
		server_dobkEnemyListDB[key]["winRate"] = value[Server_Cmd.winRate]
		server_dobkEnemyListDB[key]["eID"] = value[Server_Cmd.eID]
    end
	
    pNetStream = nil
end



-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
   return copyTab(server_dobkEnemyListDB)
end


-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    server_dobkEnemyListDB = tTable
end

-- 删除。释放
function release()
    server_dobkEnemyListDB = nil
    package.loaded["server_dobkDB"] = nil
end