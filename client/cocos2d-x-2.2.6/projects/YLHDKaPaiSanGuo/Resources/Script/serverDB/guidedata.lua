-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("guidedata", package.seeall)


keys = {
	"﻿ID", "UTag", "BName", "Property", "Info", 
}

guideDataTable = {
    id_1 = {"500", "Button_Change", "1", "主界面按钮", },
    id_2 = {"500", "Button_Copy", "1", "副本按钮", },
    id_3 = {"400", "Button_BigFootHold_1", "0", "第一场战斗", },
}


function getDataById(key_id)
    local id_data = guideDataTable["id_" .. key_id]
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

    for k, v in pairs(guideDataTable) do
        if v[fieldNo] == fieldValue then
            arrData[#arrData+1] = v
        end
    end

    return arrData
end

function getTable()
    return guideDataTable
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
    _G["guideData"] = nil
    package.loaded["guideData"] = nil
end
