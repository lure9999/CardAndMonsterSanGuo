-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("evetrigger", package.seeall)


keys = {
	"﻿TrigType", "TrigOdds", "CounterID", "SampProc", "SampPara", 
}

evetriggerTable = {
    id_1 = {"500", "1", "1", "1", },
    id_2 = {"500", "1", "1", "1", },
    id_3 = {"500", "1", "1", "1", },
    id_4 = {"0", "2", "1", "2", },
    id_5 = {"0", "3", "1", "2", },
    id_6 = {"0", "4", "1", "2", },
    id_7 = {"0", "4", "1", "2", },
    id_8 = {"0", "5", "1", "2", },
    id_9 = {"0", "5", "1", "2", },
    id_10 = {"0", "6", "1", "2", },
}


function getDataById(key_id)
    local id_data = evetriggerTable["id_" .. key_id]
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

    for k, v in pairs(evetriggerTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return evetriggerTable
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

    for k, v in pairs(evetriggerTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["evetrigger"] = nil
    package.loaded["evetrigger"] = nil
end
