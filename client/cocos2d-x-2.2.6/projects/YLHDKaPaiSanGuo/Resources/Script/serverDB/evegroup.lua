-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("evegroup", package.seeall)


keys = {
	"﻿Index", "EveGroupID", "TrigOdds", "EveCondID", "EventID", "GoOn", 
}

evegroupTable = {
    id_1 = {"1", "1000", "1149", "1000", "0", },
    id_2 = {"1", "1000", "1151", "1001", "0", },
    id_3 = {"1", "1000", "1152", "1002", "0", },
    id_4 = {"1", "1000", "1153", "1003", "0", },
    id_5 = {"1", "1000", "1154", "1004", "0", },
    id_6 = {"1", "1000", "1155", "1005", "0", },
    id_7 = {"1", "1000", "1156", "1006", "0", },
    id_8 = {"1", "1000", "1157", "1007", "0", },
    id_9 = {"1", "1000", "1158", "1008", "0", },
}


function getDataById(key_id)
    local id_data = evegroupTable["id_" .. key_id]
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

    for k, v in pairs(evegroupTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return evegroupTable
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

    for k, v in pairs(evegroupTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["evegroup"] = nil
    package.loaded["evegroup"] = nil
end
