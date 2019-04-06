-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("misty_copy", package.seeall)


keys = {
	"﻿MCopyID", "ani_idx", "off_x", "off_y", "scale_x", "scale_y", "rotation", 
}

misty_copyTable = {
    id_1 = {"2", "0", "0", "1.3", "1.3", "-8.84", },
    id_2 = {"3", "2", "-33", "1.6", "1.8", "0", },
    id_3 = {"3", "-27", "-16", "1.1", "1.7", "0", },
    id_4 = {"2", "41", "8", "1.6", "1.5", "-5.39", },
    id_5 = {"2", "-43", "-35", "1.7", "1.9", "0", },
    id_6 = {"1", "-7", "19", "1.3", "1.5", "0", },
    id_7 = {"3", "-13", "16", "1.1", "1.4", "0", },
    id_8 = {"1", "85", "4", "1.9", "1.4", "0", },
    id_9 = {"2", "-2", "23", "1.4", "1.9", "0", },
    id_10 = {"1", "5", "-71", "2.2", "2.3", "0", },
    id_11 = {"3", "7", "20", "1.1", "1.2", "-4.75", },
    id_12 = {"2", "-8", "31", "1.9", "1.9", "0", },
    id_13 = {"1", "16", "17", "1.6", "1.9", "0", },
    id_14 = {"1", "70", "12", "1.5", "1.5", "0", },
    id_15 = {"3", "37", "40", "1.9", "2.4", "0", },
}


function getDataById(key_id)
    local id_data = misty_copyTable["id_" .. key_id]
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

    for k, v in pairs(misty_copyTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return misty_copyTable
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

    for k, v in pairs(misty_copyTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["misty_copy"] = nil
    package.loaded["misty_copy"] = nil
end
