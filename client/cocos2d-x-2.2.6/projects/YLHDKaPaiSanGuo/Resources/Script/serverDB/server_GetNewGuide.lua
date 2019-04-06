
--新手引导的存储 celina
local cjson = require "json"

module("server_GetNewGuide", package.seeall)

local m_tableNewGuide = {}




-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableNewGuide = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
	local nMenuIndex = pNetStream:Read()
	local nSubIndex = pNetStream:Read()
	m_tableNewGuide.nMenu = nMenuIndex
    m_tableNewGuide.nSub = nSubIndex
    pNetStream = nil
	
end





-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
	
    return copyTab(m_tableNewGuide)
end



-- 设置表数据，只为本地测试用。
function SetTable(tTable)
    m_tableNewGuide = tTable
end

-- 删除。释放
function release()
    m_tableNewGuide = nil
    package.loaded["server_GetNewGuide"] = nil
end