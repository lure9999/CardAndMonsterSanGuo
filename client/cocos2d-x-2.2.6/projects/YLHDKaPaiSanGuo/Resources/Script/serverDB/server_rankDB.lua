-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_rankDB", package.seeall)

local m_tableRankDB = {}


local Server_Cmd = {
    UserID            = 1, 
    FaceID            = 2,
    Level             = 3,
    Power             = 4,
    Name              = 5,
    Corps             = 6,
}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableRankDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
	local nType  = pNetStream:Read()
	local nRanking = pNetStream:Read()
    local list = pNetStream:Read()

    m_tableRankDB["Ranking"] = nRanking
    for key, value in pairs(list) do
        m_tableRankDB[key] = {}
        m_tableRankDB[key]["UserID"] = value[Server_Cmd.UserID]
		m_tableRankDB[key]["FaceID"] = value[Server_Cmd.FaceID]
		m_tableRankDB[key]["Level"] = value[Server_Cmd.Level]
		m_tableRankDB[key]["Power"] = value[Server_Cmd.Power]
		m_tableRankDB[key]["Name"] = value[Server_Cmd.Name]
        m_tableRankDB[key]["Corps"] = value[Server_Cmd.Corps]
    end
    
    pNetStream = nil
	--printTab(m_tableRankDB)
	--Pause()
end





-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableRankDB)
end



-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableRankDB = tTable
end

-- 删除。释放
function release()
    m_tableRankDB = nil
    package.loaded["server_rankDB"] = nil
end