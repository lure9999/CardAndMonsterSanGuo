-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("event", package.seeall)


keys = {
	"﻿EventID", "EveEffectID1", "EveEffectID2", "EveEffectID3", "EveEffectID4", "EveScriptID", 
}

eventTable = {
    id_1000 = {"101", "111", nil, nil, nil, },
    id_1001 = {"101", "112", nil, nil, nil, },
    id_1002 = {"101", "113", nil, nil, nil, },
    id_1003 = {"101", "131", nil, nil, nil, },
    id_1004 = {"101", "132", nil, nil, nil, },
    id_1005 = {"101", "133", nil, nil, nil, },
    id_1006 = {"101", "151", nil, nil, nil, },
    id_1007 = {"101", "152", nil, nil, nil, },
    id_1008 = {"101", "153", nil, nil, nil, },
}


function getDataById(key_id)
    local id_data = eventTable["id_" .. key_id]
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

    for k, v in pairs(eventTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return eventTable
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

    for k, v in pairs(eventTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["event"] = nil
    package.loaded["event"] = nil
end
