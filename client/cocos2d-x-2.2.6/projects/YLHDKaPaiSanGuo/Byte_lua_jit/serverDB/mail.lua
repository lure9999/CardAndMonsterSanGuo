-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("mail", package.seeall)


keys = {
	"﻿PostID", "DeleteHours", "MailResImg", "MailTitle", "RecipientName", "MailText", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
}

mailTable = {
    id_1 = {"30", "145", "背包已满", "系统小管家", "您的背包已满，我们为您保存了以下物品", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_2 = {"1", "146", "春节公告", "系统小萌萌", "亲爱的童鞋们：|n|1|放假期间，各项目组妥善安排好各项工作，保存好相关文档资料，最后离开公司者请锁好门窗。|n|1|2、放假在外玩耍的童鞋们注意安全，保管好随身财物，注意昼夜温差，适当保暖。|n|2|辞旧迎新，预祝大家节日快乐，身体康健。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_3 = {"30", "141", "四行邮件", "春节小元元", "|color|255,51,0|床前明月光，|n|1|疑是地上霜，|n|1|举头望明月，|n|1|低头思故乡。"
", "30", "142", "圣诞奖励", "圣诞老人", "|color|255,204,0|.一天，在瑞典首都发生了一起奇怪的爆炸事件，一个单身的音乐家从外面回到家里"
", "30", "143", "A派克奖励", "习大大", "|color|0,102,153|A派克来啦，给大家发奖励啦"
", "30", "144", "五一奖励", "春菇凉", "|color|0,128,0|五一到了，放假了！|n|1|大家开心哈！"
", "30", "145", "九月九奖励", "重阳女", "九月九|n|1|登高楼|n|1|给大家发奖励啦", },
    id_8 = {"30", "145", "通天塔奖励", "系统小萌萌", "通天塔已经扫荡完毕，恭喜您获得以下物品", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_9 = {"30", "145", "比武每日排名奖励", "比武场军官", "您在比武的经常表现有目共睹，截至今天21:00您的比武场排名为%d。三国军团授予您以下奖励：", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_10 = {"30", "145", "排名提升奖励", "比武场军官", "恭喜您的排名从%d提升到%d。三国军团授予您以下奖励：", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
