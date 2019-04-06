-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("itemfixedrandgroup", package.seeall)


keys = {
	"﻿id", "item_id_1", "item_number_1", "item_value_1", "item_id_2", "item_number_2", "item_value_2", "item_id_3", "item_number_3", "item_value_3", "item_id_4", "item_number_4", "item_value_4", "item_id_5", "item_number_5", "item_value_5", "item_id_6", "item_number_6", "item_value_6", "item_id_7", "item_number_7", "item_value_7", "item_id_8", "item_number_8", "item_value_8", "item_id_9", "item_number_9", "item_value_9", "item_id_10", "item_number_10", "item_value_10", "item_id_11", "item_number_11", "item_value_11", "item_id_12", "item_number_12", "item_value_12", "item_id_13", "item_number_13", "item_value_13", "item_id_14", "item_number_14", "item_value_14", "item_id_15", "item_number_15", "item_value_15", "item_id_16", "item_number_16", "item_value_16", "item_id_17", "item_number_17", "item_value_17", "item_id_18", "item_number_18", "item_value_18", "item_id_19", "item_number_19", "item_value_19", "item_id_20", "item_number_20", "item_value_20", "version", 
}

itemfixedrandgroupTable = {
    id_1 = {"301", "1", "100", "302", "1", "100", "303", "1", "100", "304", "1", "100", "305", "1", "100", "306", "1", "100", "307", "1", "100", "308", "1", "100", "309", "1", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "0", },
    id_2 = {"311", "1", "100", "312", "1", "100", "313", "1", "100", "314", "1", "100", "315", "1", "100", "316", "1", "100", "317", "1", "100", "318", "1", "100", "319", "1", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "0", },
    id_3 = {"321", "1", "100", "322", "1", "100", "323", "1", "100", "324", "1", "100", "325", "1", "100", "326", "1", "100", "327", "1", "100", "328", "1", "100", "329", "1", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "0", },
    id_4 = {"331", "1", "100", "332", "1", "100", "333", "1", "100", "334", "1", "100", "335", "1", "100", "336", "1", "100", "337", "1", "100", "338", "1", "100", "339", "1", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "0", },
    id_5 = {"341", "1", "100", "342", "1", "100", "343", "1", "100", "344", "1", "100", "345", "1", "100", "346", "1", "100", "347", "1", "100", "348", "1", "100", "349", "1", "100", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "0", },
}


function getDataById(key_id)
    local id_data = itemfixedrandgroupTable["id_" .. key_id]
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

    for k, v in pairs(itemfixedrandgroupTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return itemfixedrandgroupTable
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

    for k, v in pairs(itemfixedrandgroupTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["itemfixedrandgroup"] = nil
    package.loaded["itemfixedrandgroup"] = nil
end
