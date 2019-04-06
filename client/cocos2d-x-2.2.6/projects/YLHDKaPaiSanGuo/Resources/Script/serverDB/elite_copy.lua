-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("elite_copy", package.seeall)


keys = {
	"﻿index", "scene_idx", "point_idx", "pos_x", "pos_y", "ani_idx", "width", "off_x", "off_y", "scale_x", "scale_y", "rotation", 
}

elite_copyTable = {
    id_1 = {"18", "1", "235", "381", "2", "1150", "0", "0", "1.3", "1.3", "-8.84", },
    id_2 = {"18", "2", "422", "201", "3", "1248", "2", "-33", "1.6", "1.8", "0", },
    id_3 = {"18", "3", "596", "309", "3", "1445", "-27", "-16", "1.1", "1.7", "0", },
    id_4 = {"18", "4", "768", "438", "2", "1672", "41", "8", "1.6", "1.5", "-5.39", },
    id_5 = {"18", "5", "985", "220", "2", "1848", "-43", "-35", "1.7", "1.9", "0", },
    id_6 = {"18", "6", "1190", "215", "1", "2020", "-7", "19", "1.3", "1.5", "0", },
    id_7 = {"18", "7", "1338", "362", "3", "2210", "-13", "16", "1.1", "1.4", "0", },
    id_8 = {"18", "8", "1498", "468", "1", "2440", "85", "4", "1.9", "1.4", "0", },
    id_9 = {"18", "9", "1670", "318", "2", "2535", "-2", "23", "1.4", "1.9", "0", },
    id_10 = {"18", "10", "1885", "256", "1", "2785", "5", "-71", "2.2", "2.3", "0", },
    id_11 = {"18", "11", "2115", "370", "3", "3015", "7", "20", "1.1", "1.2", "-4.75", },
    id_12 = {"18", "12", "2300", "205", "2", "3060", "-8", "31", "1.9", "1.9", "0", },
    id_13 = {"18", "13", "2480", "445", "1", "3060", "16", "17", "1.6", "1.9", "0", },
    id_14 = {"18", "14", "2670", "270", "1", "3060", "70", "12", "1.5", "1.5", "0", },
    id_15 = {"18", "15", "2890", "382", "3", "3060", "37", "40", "1.9", "2.4", "0", },
}


function getDataById(key_id)
    local id_data = elite_copyTable["id_" .. key_id]
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

    for k, v in pairs(elite_copyTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return elite_copyTable
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

    for k, v in pairs(elite_copyTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["elite_copy"] = nil
    package.loaded["elite_copy"] = nil
end
