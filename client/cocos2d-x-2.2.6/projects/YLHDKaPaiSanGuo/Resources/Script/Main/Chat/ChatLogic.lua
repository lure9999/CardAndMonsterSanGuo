--require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Chat/ChatData"

module("ChatLogic", package.seeall)

function UpdateTypeTextColor( nMess,nUserName)
    local nColorMess = ""
    if tonumber(nMess.ChannelID) == 1 then
        --世界频道中别人的发言
        if tonumber(nMess.ChatType) == 0 then
        if nMess.SenderName == nUserName then
        	--自己发送的消息
        	nColorMess = "|color|214,160,150||size|18|".."[世界]"..nMess.SenderName..": ".."|color|214,160,150||size|18|"..nMess.ChatMsg
        else
        	--别人发送的消息
        	nColorMess = "|color|214,160,150||size|18|".."[世界]"..nMess.SenderName..": ".."|color|214,160,150||size|18|"..nMess.ChatMsg
      	end
        else
            nColorMess = "|color|214,160,150||size|18|".."[世界]"..nMess.SenderName..": ".."|color|216,26,26||size|18|"..nMess.ChatMsg
        end
    elseif tonumber(nMess.ChannelID) == 2 then
    	--军团频道发言
        --if tonumber(nMess.ChatType) == 0 then
    	   nColorMess = "|color|75,176,43||size|18|".."[军团]"..nMess.SenderName..": "..nMess.ChatMsg
        --else
            --nColorMess = "|color|75,176,43||size|18|".."[军团]"..nMess.SenderName..": ".."|color|216,26,26||size|18|"..nMess.ChatMsg
        --end
    elseif tonumber(nMess.ChannelID) == 3 then
    	--国家频道发言
        --if tonumber(nMess.ChatType) == 0 then
        	nColorMess = "|color|118,115,230||size|18|".."[国家]"..nMess.SenderName..": "..nMess.ChatMsg
        --else
            --nColorMess = "|color|118,115,230||size|18|".."[国家]"..nMess.SenderName..": ".."|color|216,26,26||size|18|"..nMess.ChatMsg
        --end
    elseif tonumber(nMess.ChannelID) == 4 then
    	--私聊发言
        --if tonumber(nMess.ChatType) == 0 then
    	if nMess.SenderName == nUserName then
    		require "Script/Main/Chat/ChatLayer"
    		local receiveName = ChatLayer.GetPrivateName()
    		nColorMess = "|color|217,90,154||size|18|".."[私聊]".."我对"..receiveName.."说: "..nMess.ChatMsg--18
    	else
    		nColorMess = "|color|217,90,154||size|18|".."[私聊]"..nMess.SenderName.."对你说: "..nMess.ChatMsg
    	end
        --else
            --nColorMess = "|color|217,90,154||size|18|".."[私聊]".."|color|216,26,26||size|18|"..nMess.ChatMsg
        --end
    elseif tonumber(nMess.ChannelID) == 0 then
    	--系统发言
        --if tonumber(nMess.ChatType) == 0 then
    	nColorMess = "|color|216,26,26||size|18|".."[系统]"..nMess.SenderName..": "..nMess.ChatMsg
        --else
           -- nColorMess = "|color|216,26,26||size|18|".."[系统]"..nMess.SenderName..": "..nMess.ChatMsg
        --end
    else
    	Log("ChannelID error !")
    end

    return nColorMess
end

function CheckSentText( str )
    local i = 1
    local resultStr = ""
    while true do
        if str == "" then
            resultStr = str
        else
            local c= string.sub(str,i,i)
            local b = string.byte(c)
            if b > 128  then
                local chars = string.sub(str,i,i+2)
                resultStr = resultStr .. chars
                i = i + 3
            else
                --if b == 32 then
                    --print("empty")
               -- else
                    local chars = string.sub(str,i,i)
                    resultStr = resultStr .. chars
                --end
                i = i + 1
            end     
        end
        if i > #str then
            break
        end
    end
    return resultStr
end