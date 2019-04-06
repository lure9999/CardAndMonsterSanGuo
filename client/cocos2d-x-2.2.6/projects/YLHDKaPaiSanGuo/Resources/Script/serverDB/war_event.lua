-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("war_event", package.seeall)


keys = {
	"﻿EveEffectID", "EffType", "EffPara1", "EffPara2", "EffPara3", "EffPara4", "EffPara5", "EffPara6", 
}

war_eventTable = {
    id_1 = {"1", "60", "2", "6", "5", nil, nil, },
    id_2 = {"1", "60", "3", "6", "6", nil, nil, },
    id_3 = {"1", "60", "4", "6", "7", nil, nil, },
    id_4 = {"2", "60", "9", "8", nil, nil, nil, },
    id_5 = {"3", "1", "1", "2", "3", "4", nil, },
    id_6 = {"3", "2", "5", "6", "7", "8", nil, },
    id_7 = {"3", "3", "9", "10", "11", "12", nil, },
    id_8 = {"4", "60", nil, nil, nil, nil, nil, },
}


function getDataById(key_id)
    local id_data = war_eventTable["id_" .. key_id]
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

    for k, v in pairs(war_eventTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return war_eventTable
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

    for k, v in pairs(war_eventTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["war_event"] = nil
    package.loaded["war_event"] = nil
end
