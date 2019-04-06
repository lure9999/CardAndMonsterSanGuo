-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("talentrate", package.seeall)


keys = {
	"﻿index", "talentrate", "numerical", 
}

talentrateTable = {
    id_1 = {"E", "3", },
    id_2 = {"D", "6", },
    id_3 = {"C", "9", },
    id_4 = {"B", "12", },
    id_5 = {"A", "15", },
    id_6 = {"S", "18", },
    id_7 = {"2S", "21", },
    id_8 = {"3S", "24", },
    id_9 = {"4S", "27", },
    id_10 = {"5S", "30", },
    id_11 = {"6S", "42", },
    id_12 = {"7S", "54", },
    id_13 = {"8S", "66", },
    id_14 = {"9S", "78", },
}


function getDataById(key_id)
    local id_data = talentrateTable["id_" .. key_id]
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

    for k, v in pairs(talentrateTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return talentrateTable
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

    for k, v in pairs(talentrateTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["talentrate"] = nil
    package.loaded["talentrate"] = nil
end
