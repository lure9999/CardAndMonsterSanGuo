-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("shopitem", package.seeall)


keys = {
	"﻿id", "shop_id", "item_id", "cost_type", "cost_num", "cost_up", "cost_limit", "cost_all", "limit_buy_type", "limit_buy_value", 
}

shopitemTable = {
    id_1 = {"2", "1", "8", "10", "14", "20", "2", "2", "1", },
    id_2 = {"3", "2", "8", "10", "14", "20", "2", "2", "1", },
    id_3 = {"1", "1", "8", "10", "14", "20", "2", "2", "1", },
    id_4 = {"3", "2", "8", "10", "14", "20", "2", "2", "1", },
    id_5 = {"2", "3", "8", "10", "14", "20", "2", "2", "1", },
    id_6 = {"3", "4", "8", "10", "14", "20", "2", "2", "1", },
    id_7 = {"1", "7", "8", "10", "14", "20", "2", "2", "1", },
    id_8 = {"3", "5", "8", "10", "14", "20", "2", "2", "1", },
    id_9 = {"2", "7", "8", "10", "14", "20", "2", "2", "1", },
    id_10 = {"2", "6", "8", "10", "14", "20", "2", "2", "1", },
    id_11 = {"1", "7", "8", "10", "14", "20", "2", "2", "1", },
    id_12 = {"1", "12", "8", "10", "14", "20", "2", "2", "1", },
    id_13 = {"1", "13", "8", "10", "14", "20", "2", "2", "1", },
    id_14 = {"1", "14", "8", "10", "14", "20", "2", "2", "1", },
    id_15 = {"1", "15", "8", "10", "14", "20", "2", "2", "1", },
}


function getDataById(key_id)
    local id_data = shopitemTable["id_" .. key_id]
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

    for k, v in pairs(shopitemTable) do
        if v[fieldNo] == fieldValue then
            arrData[#arrData+1] = v
        end
    end

    return arrData
end

function getTable()
    return shopitemTable
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
    _G["shopitem"] = nil
    package.loaded["shopitem"] = nil
end
