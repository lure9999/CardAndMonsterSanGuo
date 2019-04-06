-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("prison", package.seeall)


keys = {
	"﻿PrisonID", "OpenType", "ConditionPara", "RewardCondition", "RewardID", "OPenDesc", "PrisonBG", 
}

prisonTable = {
    id_1 = {"1", "0", "40", "2050", "-1", "8201", },
    id_2 = {"1", "300", "80", "2051", "牢房科技2级开启", "8202", },
    id_3 = {"1", "301", "120", "2052", "牢房科技3级开启", "8203", },
    id_4 = {"1", "302", "160", "2053", "牢房科技4级开启", "8204", },
    id_5 = {"1", "303", "200", "2054", "牢房科技5级开启", "8205", },
    id_6 = {"2", "15", "70", "2055", "花费100元宝解锁", "8206", },
    id_7 = {"2", "16", "140", "2056", "花费200元宝解锁", "8207", },
    id_8 = {"2", "17", "210", "2057", "花费300元宝解锁", "8208", },
    id_9 = {"2", "18", "280", "2058", "花费400元宝解锁", "8209", },
    id_10 = {"2", "19", "350", "2059", "花费500元宝解锁", "8210", },
}


function getDataById(key_id)
    local id_data = prisonTable["id_" .. key_id]
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

    for k, v in pairs(prisonTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return prisonTable
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

    for k, v in pairs(prisonTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["prison"] = nil
    package.loaded["prison"] = nil
end
