-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("ScriptData", package.seeall)


keys = {
	"﻿ScriptID", "Scriptfile", 
}

ScriptDataTable = {
    id_0 = {"Script/Scene/scene_Base", },
    id_1 = {"Script/Scene/scene_1", },
    id_2 = {"Script/Scene/scene_2", },
    id_3 = {"Script/Scene/scene_3", },
    id_4 = {"Script/Scene/scene_100", },
    id_5 = {"Script/Scene/scene_101", },
    id_6 = {"Script/Scene/scene_1_1", },
    id_7 = {"Script/Scene/scene_1_2", },
    id_8 = {"Script/Scene/scene_1_3", },
    id_100 = {"Script/Scene/scene_pk", },
    id_200 = {"Script/Scene/scene_Pata", },
    id_10000 = {"Script/Scene/scene_Piantou", },
    id_10001 = {"Script/Scene/scene_Cg1", },
    id_10002 = {"Script/Scene/scene_Cg2", },
}


function getDataById(key_id)
    local id_data = ScriptDataTable["id_" .. key_id]
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

    for k, v in pairs(ScriptDataTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return ScriptDataTable
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

    for k, v in pairs(ScriptDataTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["ScriptData"] = nil
    package.loaded["ScriptData"] = nil
end
