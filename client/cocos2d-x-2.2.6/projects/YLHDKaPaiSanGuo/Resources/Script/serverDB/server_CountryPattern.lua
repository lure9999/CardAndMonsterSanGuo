-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_CountryPattern", package.seeall)

local m_CountryPatternDB = {}


local Server_Cmd = {
    SanGuoState                = 1,            --三国格局
    CountryNum                 = 2,            --国家占有城池
    CountryLevel               = 3,            --国家等级
}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_CountryPatternDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list = pNetStream:Read()

    m_CountryPatternDB["SanGuoState"] = list[Server_Cmd.SanGuoState]
    m_CountryPatternDB["CountryNum"]  = list[Server_Cmd.CountryNum]
    m_CountryPatternDB["CountryLevel"]  = list[Server_Cmd.CountryLevel]

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	if m_CountryPatternDB ~= nil then
        return copyTab(m_CountryPatternDB)
    else
        print("m_CountryPatternDB error")
    end
end

-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_CountryPatternDB = tTable
end

-- 删除。释放
function release()
    m_CountryPatternDB = nil
    package.loaded["server_CountryPattern"] = nil
end