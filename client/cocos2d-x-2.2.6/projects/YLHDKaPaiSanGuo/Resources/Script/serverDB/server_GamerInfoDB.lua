-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
module("server_GamerInfoDB", package.seeall)

local m_tableGamerDB = {}
local m_AllChatMessDB = {}
local messID  = 1


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)   
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    m_tableGamerDB = {}
    m_tableGamerDB["GlobalID"]    =  pNetStream:Read()
    m_tableGamerDB["level"]       =  pNetStream:Read()
    m_tableGamerDB["vipLevel"]    =  pNetStream:Read()
    m_tableGamerDB["face"]        =  pNetStream:Read()
    m_tableGamerDB["power"]       =  pNetStream:Read()
    m_tableGamerDB["name"]        =  pNetStream:Read()
    m_tableGamerDB["bang_pai"]    =  pNetStream:Read()
    m_tableGamerDB["color"]       =  pNetStream:Read()
    --RefreshChatList()
    pNetStream = nil
end

function GetCopyTable()
    if m_tableGamerDB == nil then
        return nil
    else
        return copyTab(m_tableGamerDB)
    end
end

--[[
function RefreshChatList()
    local messDB = GetCopyTable()
    require "Script/Main/Chat/ChatLayer"
    ChatLayer.LoadList(messDB)
    require "Script/Main/MainScene"
    MainScene.UpDateChatList(messDB)
    m_AllChatMessDB["messID"..messID] = messDB
    messID = messID + 1
end
--]]

--[[function errorTip( nErrorID )
    require "Script/Common/TipCommonLayer"
    TipCommonLayer.CreateTipsLayer(nErrorID,TIPS_TYPE.TIPS_TYPE_CHAT,nil,nil,nil)
    --NetWorkLoadingLayer.loadingHideNow()
end]]--

-- 删除。释放
function release()
    m_delId = nil
    package.loaded["server_GamerInfoDB"] = nil
end