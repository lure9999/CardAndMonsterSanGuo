
local cjson = require "json"

module("server_dobkOpenBox", package.seeall)

local m_tableBoxDB = {}


local Server_Cmd = {
    status            = 1, 
	boxCount          = 2 ,
	list  = 3,
}
local boxCount = nil
local boxExp = nil 
local luckyClover = nil

local Info01_Cmd = {itemID = 1, count  = 2}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableBoxDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
	boxCount  = pNetStream:Read()
    local list = pNetStream:Read()
    for key, value in pairs(list) do
        m_tableBoxDB[key] = {}
        m_tableBoxDB[key]["itemID"] = value[Info01_Cmd.itemID]
		m_tableBoxDB[key]["count"] = value[Info01_Cmd.count]
    end
    pNetStream = nil
end


-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableBoxDB)
end

function GetBoxNum()
	if boxCount== nil then
		return 0
	end
	return boxCount
end
-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableBoxDB = tTable
end

-- 删除。释放
function release()
    m_tableBoxDB = nil
    package.loaded["server_dobkOpenBox"] = nil
end