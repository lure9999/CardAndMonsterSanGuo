-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("event_limit", package.seeall)


keys = {
	"﻿id", "limit", "limit_value", "type", "data_1_a", "data_1_b", "data_1_c", "data_2_a", "data_2_b", "data_2_c", 
}

event_limitTable = {
    id_1 = {"1", "10", "1", "2", "177", nil, nil, nil, nil, },
    id_2 = {"2", "10", "2", "1", "177", nil, nil, nil, nil, },
    id_3 = {"3", "10", "3", "2", "177", nil, nil, nil, nil, },
    id_4 = {"1", "10", "1", "4", "177", nil, nil, nil, nil, },
    id_5 = {"2", "10", "2", "3", "177", nil, nil, nil, nil, },
    id_6 = {"3", "10", "3", "5", "177", nil, nil, nil, nil, },
    id_7 = {"1", "10", "1", "2", "177", nil, nil, nil, nil, },
    id_8 = {"2", "10", "1", "4", "177", nil, nil, nil, nil, },
    id_9 = {"3", "10", "2", "3", "177", nil, nil, nil, nil, },
    id_10 = {"1", "10", "2", "4", "177", nil, nil, nil, nil, },
    id_11 = {"2", "10", "2", "4", "177", nil, nil, nil, nil, },
}


function getDataById(key_id)
    local id_data = event_limitTable["id_" .. key_id]
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

    for k, v in pairs(event_limitTable) do
        if v[fieldNo] == fieldValue then
            arrData[#arrData+1] = v
        end
    end

    return arrData
end

function getTable()
    return event_limitTable
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
    _G["event_limit"] = nil
    package.loaded["event_limit"] = nil
end
