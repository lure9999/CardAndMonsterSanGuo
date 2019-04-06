-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("fuben", package.seeall)


keys = {
	"﻿ID", "Type", "ResID", "Count", 
}

fubenTable = {
    id_1 = {"1", "7", "10", },
    id_2 = {"3", "6", "30", },
    id_3 = {"3", "5", "40", },
    id_4 = {"2", "4", "10", },
    id_5 = {"1", "7", "10", },
    id_6 = {"3", "6", "30", },
    id_7 = {"3", "5", "40", },
    id_8 = {"2", "4", "10", },
    id_9 = {"1", "7", "10", },
    id_10 = {"3", "6", "30", },
    id_11 = {"3", "5", "40", },
    id_12 = {"2", "4", "10", },
    id_13 = {"1", "7", "10", },
    id_14 = {"3", "6", "30", },
    id_15 = {"3", "5", "40", },
    id_16 = {"2", "4", "10", },
    id_17 = {"2", "4", "10", },
}


function getDataById(key_id)
    local id_data = fubenTable["id_" .. key_id]
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

    for k, v in pairs(fubenTable) do
        if v[fieldNo] == fieldValue then
            arrData[#arrData+1] = v
        end
    end

    return arrData
end

function getTable()
    return fubenTable
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


function release()
    _G["fuben"] = nil
    package.loaded["fuben"] = nil
end
