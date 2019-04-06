-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("monster", package.seeall)


keys = {
	"﻿Index", "MonsterID", "TechLv", "MonsterName", "IconID", "MonsterDesc", "ReputType", "ReputCost", "GoldExchange", "MosterRewardID", "ReputExchange", "MosterEff1", "IncrementType1", "IncrementPara1", "MosterEff2", "IncrementType2", "IncrementPara2", 
}

monsterTable = {
    id_1 = {"1", "1", "青龙赐福1", "201", "青龙赐福说明1", "1", "100", "10", "100", "5", "2", "1", "100", "-1", "-1", "-1", },
    id_2 = {"1", "2", "青龙赐福2", "201", "青龙赐福说明2", "1", "100", "10", "100", "5", "2", "1", "100", "-1", "-1", "-1", },
    id_3 = {"1", "3", "青龙赐福3", "201", "青龙赐福说明3", "1", "100", "10", "100", "5", "2", "1", "100", "-1", "-1", "-1", },
    id_4 = {"1", "4", "青龙赐福4", "201", "青龙赐福说明4", "1", "100", "10", "100", "5", "2", "1", "100", "-1", "-1", "-1", },
    id_5 = {"2", "1", "白虎赐福1", "201", "白虎赐福说明1", "2", "100", "10", "100", "5", "2", "2", "5", "-1", "-1", "-1", },
    id_6 = {"2", "2", "白虎赐福2", "201", "白虎赐福说明2", "2", "100", "10", "100", "5", "2", "2", "5", "-1", "-1", "-1", },
    id_7 = {"2", "3", "白虎赐福3", "201", "白虎赐福说明3", "2", "100", "10", "100", "5", "2", "2", "5", "-1", "-1", "-1", },
    id_8 = {"2", "4", "白虎赐福4", "201", "白虎赐福说明4", "2", "100", "10", "100", "5", "2", "2", "5", "-1", "-1", "-1", },
    id_9 = {"3", "1", "朱雀赐福1", "201", "朱雀赐福说明1", "3", "100", "10", "100", "5", "3", "1", "100", "-1", "-1", "-1", },
    id_10 = {"3", "2", "朱雀赐福2", "201", "朱雀赐福说明2", "3", "100", "10", "100", "5", "3", "1", "100", "-1", "-1", "-1", },
    id_11 = {"3", "3", "朱雀赐福3", "201", "朱雀赐福说明3", "3", "100", "10", "100", "5", "3", "1", "100", "-1", "-1", "-1", },
    id_12 = {"3", "4", "朱雀赐福4", "201", "朱雀赐福说明4", "3", "100", "10", "100", "5", "3", "1", "100", "-1", "-1", "-1", },
    id_13 = {"4", "1", "玄武赐福1", "201", "玄武赐福说明1", "4", "100", "10", "100", "5", "3", "2", "5", "-1", "-1", "-1", },
    id_14 = {"4", "2", "玄武赐福2", "201", "玄武赐福说明2", "4", "100", "10", "100", "5", "3", "2", "5", "-1", "-1", "-1", },
    id_15 = {"4", "3", "玄武赐福3", "201", "玄武赐福说明3", "4", "100", "10", "100", "5", "3", "2", "5", "-1", "-1", "-1", },
    id_16 = {"4", "4", "玄武赐福4", "201", "玄武赐福说明4", "4", "100", "10", "100", "5", "3", "2", "5", "-1", "-1", "-1", },
    id_17 = {"5", "1", "巴哈姆特赐福1", "201", "巴哈姆特赐福说明1", "5", "100", "10", "100", "-1", "4", "3", "10210", "4", "2", "5", },
    id_18 = {"5", "2", "巴哈姆特赐福2", "201", "巴哈姆特赐福说明2", "5", "200", "10", "100", "-1", "4", "3", "10210", "4", "2", "5", },
    id_19 = {"5", "3", "巴哈姆特赐福3", "201", "巴哈姆特赐福说明3", "5", "300", "10", "100", "-1", "4", "3", "10210", "4", "2", "5", },
    id_20 = {"5", "4", "巴哈姆特赐福4", "201", "巴哈姆特赐福说明4", "5", "400", "10", "100", "-1", "4", "3", "10210", "4", "2", "5", },
}


function getDataById(key_id)
    local id_data = monsterTable["id_" .. key_id]
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

    for k, v in pairs(monsterTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return monsterTable
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

    for k, v in pairs(monsterTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["monster"] = nil
    package.loaded["monster"] = nil
end
