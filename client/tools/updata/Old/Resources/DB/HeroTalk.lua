-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("HeroTalk", package.seeall)


keys = {
	"﻿talk_id", "hero_name", "hero_img", "text", "next_id", 
}

HeroTalkTable = {
    id_1 = {"金建成", "3", "什么时候请吃欢言？", "2", },
    id_2 = {"钱叫兽", "8", "今天天气挺好！^-^", "3", },
    id_3 = {"金建成", "3", "别扯蛋,赶紧说,什么时候请！", "4", },
    id_4 = {"钱叫兽", "8", "刚才过去的妹子不错.", "5", },
    id_5 = {"金建成", "3", "妹子没了,饭还是要请的啊！", "6", },
    id_6 = {"钱叫兽", "8", "没妹子就不吃饭了。", "7", },
    id_7 = {"金建成", "3", "你是个禽兽！", "0", },
}


function getDataById(key_id)
    local id_data = HeroTalkTable["id_" .. key_id]
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

    for k, v in pairs(Activitycopy) do
        if v[fieldNo] == fieldValue then
            arrData[#arrData+1] = v
        end
    end

    return arrData
end


function release()
    _G["HeroTalk"] = nil
    package.loaded["HeroTalk"] = nil
end
