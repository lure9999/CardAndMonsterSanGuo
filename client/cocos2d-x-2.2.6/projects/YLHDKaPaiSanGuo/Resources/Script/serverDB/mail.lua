-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("mail", package.seeall)


keys = {
	"﻿PostID", "DeleteHours", "MailResImg", "MailTitle", "RecipientName", "MailText", "", "", "", "", "", 
}

mailTable = {
    id_1 = {"30", "145", "背包已满", "系统小管家", "您的背包已满，我们为您保存了以下物品", nil, nil, nil, nil, nil, },
    id_2 = {"30", "146", "新主莅临", "系统小萌萌", "亲爱的玩家你好：|n|1|欢迎您来到《三国大一统》的世界，这里有最火爆的国战、最搞怪的武将。|n|2|欢迎加入官方QQ群与玩家，主创一起互动，以便了解游戏最新动向。QQ群号|color|255,51,0|240540111|n|2|"
", "30", "141", "邮件预留1", "系统1", "无邮件内容", },
    id_4 = {"30", "142", "邮件预留2", "系统2", "无邮件内容", nil, nil, nil, nil, nil, },
    id_5 = {"30", "143", "邮件预留3", "系统3", "无邮件内容", nil, nil, nil, nil, nil, },
    id_6 = {"30", "144", "邮件预留4", "系统4", "无邮件内容", nil, nil, nil, nil, nil, },
    id_7 = {"30", "145", "邮件预留5", "系统5", "无邮件内容", nil, nil, nil, nil, nil, },
    id_8 = {"30", "145", "通天塔奖励", "系统小萌萌", "通天塔已经扫荡完毕，恭喜您获得以下物品", nil, nil, nil, nil, nil, },
    id_9 = {"30", "145", "比武每日排名奖励", "比武场军官", "您在比武的经常表现有目共睹，截至今天21:00您的比武场排名为%d。三国军团授予您以下奖励：", nil, nil, nil, nil, nil, },
    id_10 = {"30", "145", "排名提升奖励", "比武场军官", "恭喜您的排名从%d提升到%d。三国军团授予您以下奖励：", nil, nil, nil, nil, nil, },
}


function getDataById(key_id)
    local id_data = mailTable["id_" .. key_id]
    if id_data == nil then
        return nil
    end
    return id_data
end

function getArrDataByField(fieldName, fieldValue)
    local arrData = {}
    local fieldNo = 1
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i
            break
        end
    end

    for k, v in pairs(mailTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return mailTable
end


function getFieldByIdAndIndex(key_id, fieldName)
    local fieldNo = 0
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i-1
            break
        end
    end
    return getDataById(key_id)[fieldNo]
end


function getIndexByField(fieldName)
    local fieldNo = 0
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i-1
            break
        end
    end
    return fieldNo
end


function getArrDataBy2Field(fieldName1, fieldValue1, fieldName2, fieldValue2)
	local arrData = {}
	local fieldNo1 = 1
	local fieldNo2 = 1
	for i=1, #keys do
		if keys[i] == fieldName1 then
			fieldNo1 = i
		end
		if keys[i] == fieldName2 then
			fieldNo2 = i
		end
	end

    for k, v in pairs(mailTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["mail"] = nil
    package.loaded["mail"] = nil
end
