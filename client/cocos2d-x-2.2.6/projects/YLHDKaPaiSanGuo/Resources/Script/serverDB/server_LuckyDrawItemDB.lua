module("server_LuckyDrawItemDB", package.seeall)

local m_tableLuckyDrawItemDB = {}

local Server_Cmd =
				{
					ItemId = 1,
					ItemNum = 2,
				}

function SetTableBuffer(pBaseRID, pBuffer)
    m_tableLuckyDrawItemDB = {}
    m_tableLuckyDrawItemDB["BaseRewardID"] = pBaseRID
    m_tableLuckyDrawItemDB["ItemArrs"] = {}
    for k, v in pairs(pBuffer) do
    	local tabTemp = {}
    	-- tabTemp
    	m_tableLuckyDrawItemDB["ItemArrs"][k] = {}
    	m_tableLuckyDrawItemDB["ItemArrs"][k]["ItemId"] = v[Server_Cmd.ItemId]
    	m_tableLuckyDrawItemDB["ItemArrs"][k]["ItemNum"] = v[Server_Cmd.ItemNum]
    end

    -- printTab(m_tableLuckyDrawItemDB)
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_tableLuckyDrawItemDB ~= nil then

        return copyTab(m_tableLuckyDrawItemDB)

    end
    
end

function GetBaseRewardID( )
    if m_tableLuckyDrawItemDB ~= nil then

        return m_tableLuckyDrawItemDB["BaseRewardID"]

    end
end