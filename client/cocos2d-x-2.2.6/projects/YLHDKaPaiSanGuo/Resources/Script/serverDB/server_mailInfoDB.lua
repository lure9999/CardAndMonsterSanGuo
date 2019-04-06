-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_mailInfoDB", package.seeall)

local Servel_Reward = {
    Sliver          =   1,
    Gold            =   2,
    Diamond         =   3,
    TiLi            =   4,
    NaiLi           =   5,
}


local m_tableMailInfoDB = {}

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_tableMailInfoDB = {}

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    m_tableMailInfoDB["ID"] = pNetStream:Read()
    m_tableMailInfoDB["Type"] = pNetStream:Read()
    m_tableMailInfoDB["Time"] = pNetStream:Read()
    m_tableMailInfoDB["Title"] = pNetStream:Read()
    m_tableMailInfoDB["SenderName"] = pNetStream:Read()
    m_tableMailInfoDB["Content"] = pNetStream:Read()
    m_tableMailInfoDB["hasReward"] = pNetStream:Read()
    if m_tableMailInfoDB["hasReward"] == 1 then         --有奖励邮件
        local rewardCoin = pNetStream:Read()
        local rewardItem = pNetStream:Read()
        m_tableMailInfoDB["RewardCoin"] = {}
        m_tableMailInfoDB["RewardItem"] = {}
        for key,value in pairs(rewardCoin) do
            m_tableMailInfoDB["RewardCoin"][key] = value
        end
        for key, value in pairs(rewardItem) do
            m_tableMailInfoDB["RewardItem"][key] = value           
        end
    else
        print("当前邮件无奖励")
    end

    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetCopyTable()
    if m_tableMailInfoDB == nil then
        return nil
    else
        return copyTab(m_tableMailInfoDB)
    end
end

-- 删除。释放
function release()
    m_tableMailInfoDB = nil
    package.loaded["server_mailInfoDB"] = nil
end