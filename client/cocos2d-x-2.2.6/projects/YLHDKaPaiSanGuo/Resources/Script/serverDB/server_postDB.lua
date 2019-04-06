-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_postDB", package.seeall)

local m_tablePostDB = {}


local Server_Cmd = {
    postid              = 1, 
    posttype            = 2, 
    state               = 3,
    posttime            = 4,
    abandontime         = 5,
    posttitle           = 6,
    postdescribe        = 7,
    coin                = 8,
    intem               = 9,
}
local coint_info = {
    cointype            = 1, 
    count               = 2,
}
local item_info = {
    itemindex           = 1, 
    count               = 2,
}
-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tablePostDB = {}
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
    local status = pNetStream:Read()
    local list   = pNetStream:Read()

    print(buffer)
    for key, value in pairs(list) do
        m_tablePostDB[key] = {}
        m_tablePostDB[key]["postid"]        = value[Server_Cmd.postid] 
        m_tablePostDB[key]["posttype"]      = value[Server_Cmd.posttype]
        m_tablePostDB[key]["state"]         = value[Server_Cmd.state]
        m_tablePostDB[key]["posttime"]      = value[Server_Cmd.posttime]
        m_tablePostDB[key]["abandontime"]   = value[Server_Cmd.abandontime]
        m_tablePostDB[key]["posttitle"]     = value[Server_Cmd.posttitle]
        m_tablePostDB[key]["postdescribe"]  = value[Server_Cmd.postdescribe]
        for Idx, Info in pairs(value[Server_Cmd.coin]) do
            local tabCoin = {}
            tabCoin["cointype"] = Info[coint_info.cointype]
            tabCoin["count"]    = Info[coint_info.count]
            table.insert(m_tablePostDB[key]["coin"], tabCoin)
        end
        for Idx, Info in pairs(value[Server_Cmd.intem]) do
            local tabItem = {}
            tabItem["itemindex"] = Info[item_info.itemindex]
            tabItem["count"]     = Info[item_info.count]
            table.insert(m_tablePostDB[key]["intem"], tabItem)
        end
    end
    pNetStream = nil

    print("m_tablePostDB")
   -- printTab(m_tablePostDB)
end

