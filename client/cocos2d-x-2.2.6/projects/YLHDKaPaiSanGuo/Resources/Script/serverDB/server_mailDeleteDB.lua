-- Description: auto-created by ExcelToLua tool.
-- Author:jjc
local cjson = require "json"

module("server_mailDeleteDB", package.seeall)

local m_delId = nil

-- 设置数据字符串，字符串转为表格式
function SetTableBuffer(buffer)
    m_delId = nil

    local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)

    local status = pNetStream:Read()
    m_delId = pNetStream:Read()
    pNetStream = nil
end

-- 获得一个复制的表。使用后删除即可
function GetDelID()
    if m_delId == nil then 
        return nil
    else    
        return m_delId
    end
end

function errorTip()
   --[[ require "Script/Common/TipCommonLayer"
    TipCommonLayer.CreateTipsLayer(601,TIPS_TYPE.TIPS_TYPE_MAIL,nil,nil,nil)]]--
	local pTip = TipCommonLayer.CreateTipLayerManager()
	pTip:ShowCommonTips(601,nil)
	pTip = nil
    NetWorkLoadingLayer.loadingHideNow()
end

-- 删除。释放
function release()
    m_delId = nil
    package.loaded["server_mailDeleteDB"] = nil
end