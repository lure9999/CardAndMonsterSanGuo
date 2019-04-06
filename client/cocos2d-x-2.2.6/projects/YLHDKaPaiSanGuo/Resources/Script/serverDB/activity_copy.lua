-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("activity_copy", package.seeall)


keys = {
	"﻿id", "name", "title", "map", "limit_count", 
}

activity_copyTable = {
    id_1 = {"经验之战", "12", "12", "5", },
    id_2 = {"宝物之战", "13", "13", "6", },
    id_3 = {"限时活动", "14", "14", "7", },
    id_4 = {"装备之战", "15", "15", "8", },
    id_5 = {"经验之战", "12", "12", "5", },
    id_6 = {"宝物之战", "13", "13", "6", },
    id_7 = {"限时活动", "14", "14", "7", },
    id_8 = {"装备之战", "15", "15", "8", },
    id_9 = {"宝物之战", "13", "13", "6", },
    id_10 = {"限时活动", "14", "14", "7", },
    id_11 = {"装备之战", "15", "15", "8", },
}


function getDataById(key_id)
    local id_data = activity_copyTable["id_" .. key_id]
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

    for k, v in pairs(activity_copyTable) do
        if v[fieldNo] == fieldValue then
            arrData[#arrData+1] = v
        end
    end

    return arrData
end

function getTable()
    return activity_copyTable
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
    _G["activity_copy"] = nil
    package.loaded["activity_copy"] = nil
end
