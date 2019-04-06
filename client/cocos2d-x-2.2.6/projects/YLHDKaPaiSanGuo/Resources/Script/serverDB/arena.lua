-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("arena", package.seeall)


keys = {
	"﻿Index", "RankMax", "RankMin", "Title", "Seat1", "Seat2", "Seat3", "RankFloat", "RankInterval", "RankMBonus", "VictoryRewardID", "LossRewardID", "DayRewardID", 
}

arenaTable = {
    id_1 = {"1", "1", "三国第一高手", "1", "2", "3", "0", "1", "105", "55", "56", "111", },
    id_2 = {"2", "2", "三国第二高手", "-1", "2", "3", "0", "1", "105", "55", "56", "112", },
    id_3 = {"3", "3", "三国第三高手", "-1", "-2", "3", "0", "1", "105", "55", "56", "113", },
    id_4 = {"4", "4", "三国第四高手", "-1", "-2", "-3", "0", "1", "105", "55", "56", "114", },
    id_5 = {"5", "5", "三国第五高手", "-1", "-2", "-3", "0", "1", "105", "55", "56", "115", },
    id_6 = {"6", "6", "三国第六高手", "-1", "-2", "-3", "0", "1", "105", "55", "56", "116", },
    id_7 = {"7", "7", "三国第七高手", "-1", "-2", "-3", "0", "1", "105", "55", "56", "117", },
    id_8 = {"8", "8", "三国第八高手", "-1", "-2", "-3", "0", "1", "105", "55", "56", "118", },
    id_9 = {"9", "9", "三国第九高手", "-1", "-2", "-3", "0", "1", "105", "55", "56", "119", },
    id_10 = {"10", "10", "三国第十高手", "-1", "-2", "-3", "0", "1", "105", "55", "56", "120", },
    id_11 = {"11", "20", " 独孤求败", "-10", "-8", "-5", "2", "1", "104", "55", "56", "121", },
    id_12 = {"21", "30", " 深不可测", "-20", "-16", "-10", "2", "1", "104", "55", "56", "122", },
    id_13 = {"31", "40", " 举世无双", "-30", "-24", "-15", "2", "1", "104", "55", "56", "123", },
    id_14 = {"41", "50", " 武林泰斗", "-40", "-32", "-20", "2", "1", "104", "55", "56", "124", },
    id_15 = {"51", "70", " 一代宗师", "-50", "-40", "-25", "3", "1", "104", "55", "56", "125", },
    id_16 = {"71", "100", " 武林盟主", "-70", "-56", "-35", "4", "1", "104", "55", "56", "126", },
    id_17 = {"101", "200", " 傲视群雄", "-100", "-80", "-50", "8", "1", "103", "55", "56", "127", },
    id_18 = {"201", "300", " 开宗立派", "-200", "-160", "-100", "8", "1", "103", "55", "56", "128", },
    id_19 = {"301", "400", " 独步武林", "-300", "-240", "-150", "8", "1", "103", "55", "56", "129", },
    id_20 = {"401", "500", " 名震江湖", "-400", "-320", "-200", "8", "1", "103", "55", "56", "130", },
    id_21 = {"501", "700", " 仗剑天涯", "-450", "-360", "-225", "10", "1", "103", "55", "56", "131", },
    id_22 = {"701", "1000", " 英雄豪杰", "-560", "-448", "-280", "25", "1", "103", "55", "56", "132", },
    id_23 = {"1001", "2000", " 武林高手", "-600", "-480", "-300", "50", "10", "102", "55", "56", "133", },
    id_24 = {"2001", "3000", " 武林新贵", "-1200", "-960", "-600", "50", "15", "101", "55", "56", "134", },
    id_25 = {"3001", "4000", " 江湖少侠", "-1800", "-1440", "-900", "50", "20", "101", "55", "56", "135", },
    id_26 = {"4001", "5000", " 后起之秀", "-2400", "-1920", "-1200", "50", "25", "101", "55", "56", "136", },
    id_27 = {"5001", "7000", " 寂寂无名", "-2500", "-2000", "-1250", "100", "30", "101", "55", "56", "137", },
    id_28 = {"7001", "10000", " 初入江湖", "-3500", "-2800", "-1750", "200", "35", "101", "55", "56", "138", },
    id_29 = {"10001", "-1", "江湖未入", "-4000", "-3200", "-2000", "500", "40", "0", "55", "56", "139", },
}


function getDataById(key_id)
    local id_data = arenaTable["id_" .. key_id]
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

    for k, v in pairs(arenaTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return arenaTable
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

    for k, v in pairs(arenaTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["arena"] = nil
    package.loaded["arena"] = nil
end
