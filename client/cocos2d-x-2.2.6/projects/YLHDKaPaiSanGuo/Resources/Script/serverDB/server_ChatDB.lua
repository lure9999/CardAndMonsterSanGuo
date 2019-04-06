-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
module("server_ChatDB", package.seeall)

local Server_ChannelID = {
    CHAT_CHANNEL_SYSTEM     = 0,
    CHAT_CHANNEL_WORLD      = 1,
    CHAT_CHANNEL_GUILD      = 2,
    CHAT_CHANNEL_TEAM       = 3,
    CHAT_CHANNEL_PRIVATE    = 4,
}


local m_tableChatDB = {}
--[[
local m_tableChatDB_World = {}
local m_tableChatDB_Guild = {}
local m_tableChatDB_Team = {}
local m_tableChatDB_Private = {}
--]]


-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)  
    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    m_tableChatDB = {}
    m_tableChatDB["ChannelID"]   =  pNetStream:Read()
    m_tableChatDB["SenderID"]    =  pNetStream:Read()
    m_tableChatDB["SenderName"]  =  pNetStream:Read()
    m_tableChatDB["VIPLevel"]    =  pNetStream:Read()
    m_tableChatDB["Level"]       =  pNetStream:Read()
    m_tableChatDB["Time"]        =  pNetStream:Read()
    m_tableChatDB["ResIMGID"]    =  pNetStream:Read()
    m_tableChatDB["Color"]       =  pNetStream:Read()
    m_tableChatDB["ChatMsg"]     =  pNetStream:Read()
    m_tableChatDB["ChatType"]     =  0
    m_tableChatDB["ColorType"]     =  0
    --[[
    local function AllMessInfo()
        if tonumber(m_tableChatDB["ChannelID"]) == Server_ChannelID.CHAT_CHANNEL_WORLD then
            table.insert(m_tableChatDB_World,m_tableChatDB) 
        elseif tonumber(m_tableChatDB["ChannelID"]) == Server_ChannelID.CHAT_CHANNEL_GUILD then
            table.insert(m_tableChatDB_Guild,m_tableChatDB)
            Log("insert Guild = "..#m_tableChatDB_Guild)
        elseif tonumber(m_tableChatDB["ChannelID"]) == Server_ChannelID.CHAT_CHANNEL_TEAM then
            table.insert(m_tableChatDB_Team,m_tableChatDB)
        elseif tonumber(m_tableChatDB["ChannelID"]) == Server_ChannelID.CHAT_CHANNEL_PRIVATE then
            table.insert(m_tableChatDB_Private,m_tableChatDB)
        elseif tonumber(m_tableChatDB["ChannelID"]) == Server_ChannelID.CHAT_CHANNEL_SYSTEM then
            table.insert(m_tableChatDB_World,m_tableChatDB)
        end
    end
    AllMessInfo()
    --]]
    RefreshChatList()
    pNetStream = nil
end

function GetCopyTable()
    if m_tableChatDB == nil then
        return nil
    else
        return copyTab(m_tableChatDB)
    end
end

function RefreshChatList()
    local messDB = GetCopyTable()
    require "Script/Main/Chat/ChatLayer"
    ChatLayer.LoadList(messDB)
    require "Script/Main/MainScene"
    require "Script/Main/Chat/ChatShowLayer"
    --MainScene.UpDateChatList(messDB)
    ChatShowLayer.UpDateChatList(messDB)
    --[[
    m_AllChatMessDB["messID"..messID] = messDB
    messID = messID + 1
    for key,value in pairs(m_AllChatMessDB) do
        print(key,value.ChatMsg)
    end
    --]]
end

function GetTypeChatMess( nTypeID )
    --[[
    if nTypeID == Server_ChannelID.CHAT_CHANNEL_WORLD then
        if m_tableChatDB_World == nil then
            return nil
        else
            Log("return World")
            return m_tableChatDB_World
        end
    elseif nTypeID == Server_ChannelID.CHAT_CHANNEL_GUILD then
        if m_tableChatDB_Guild == nil then
            return nil
        else
            Log("return Guild")
            return m_tableChatDB_Guild        
        end
    elseif nTypeID == Server_ChannelID.CHAT_CHANNEL_TEAM then
        if m_tableChatDB_Team == nil then
            return nil
        else
            Log("return Team")
            return m_tableChatDB_Team         
        end
    elseif nTypeID == Server_ChannelID.CHAT_CHANNEL_PRIVATE then
        if m_tableChatDB_Private == nil then
            return nil
        else
            Log("return Private")
            return m_tableChatDB_Privated
        end
    end
    --]]
end

--[[
function GetMessDB( nKey )
    if m_AllChatMessDB == nil then
        return nil
    else
        return m_AllChatMessDB["messID"..nKey]
    end    -- body
end
--]]

function errorTip( nErrorID,nNum )
    --[[require "Script/Common/TipCommonLayer"
    if nMsg ~= nil then
        TipCommonLayer.CreateTipsLayer(nErrorID,TIPS_TYPE.TIPS_TYPE_CHAT,nil,nil,nMsg)
    else
        TipCommonLayer.CreateTipsLayer(nErrorID,TIPS_TYPE.TIPS_TYPE_CHAT,nil,nil,nil)
    end]]--
    --NetWorkLoadingLayer.loadingHideNow()
	--修改 celina 只限于传入无回调的 一个数字匹配符的
	local pTips = TipCommonLayer.CreateTipLayerManager()
	if nNum ~= nil then
        pTips:ShowCommonTips(nErrorID,nil,nNum)
		pTips = nil
    else
        pTips:ShowCommonTips(nErrorID,nil)
		pTips = nil
    end
	
end

-- 删除。释放
function release()
    m_delId = nil
    package.loaded["server_ChatDB"] = nil
end