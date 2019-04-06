-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_rankMatrixDB", package.seeall)

local m_tableRankMatrixDB = {}


local Server_Cmd = {
    FaceID            = 1,
    Level             = 2,
    Star              = 3,
}


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableRankMatrixDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()

    for key, value in pairs(list) do
        m_tableRankMatrixDB[key] = {}
        m_tableRankMatrixDB[key]["FaceID"] = value[Server_Cmd.FaceID]
		m_tableRankMatrixDB[key]["Level"] = value[Server_Cmd.Level]
		m_tableRankMatrixDB[key]["Star"] = value[Server_Cmd.Star]
    end

    pNetStream = nil
	--[[printTab(m_tableRankDB)
	Pause()]]--
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableRankMatrixDB)
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableRankMatrixDB = tTable
end

-- 删除。释放
function release()
    m_tableRankMatrixDB = nil
    package.loaded["server_rankDB"] = nil
end