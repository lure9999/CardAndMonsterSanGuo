-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("wargrid", package.seeall)


keys = {
	"﻿Gindex", "CionID", "CionPara", 
}

wargridTable = {
    id_1 = {"1", "-1", },
    id_2 = {"17", "-1", },
    id_3 = {"6", "-1", },
    id_4 = {"13", "-1", },
    id_5 = {"10", "-1", },
    id_6 = {"0", "208", },
    id_7 = {"0", "232", },
    id_8 = {"0", "233", },
    id_9 = {"0", "231", },
    id_10 = {"0", "238", },
    id_11 = {"0", "239", },
    id_12 = {"0", "240", },
    id_13 = {"0", "241", },
    id_14 = {"0", "236", },
    id_15 = {"0", "237", },
    id_16 = {"-1", "-1", },
    id_17 = {"-1", "-1", },
    id_18 = {"-1", "-1", },
    id_19 = {"-1", "-1", },
    id_20 = {"-1", "-1", },
}


function getDataById(key_id)
    local id_data = wargridTable["id_" .. key_id]
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

    for k, v in pairs(wargridTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return wargridTable
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

    for k, v in pairs(wargridTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["wargrid"] = nil
    package.loaded["wargrid"] = nil
end
