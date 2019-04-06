-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("xilian", package.seeall)


keys = {
	"﻿XiLian_Type", "XiL_ConsumeID", "XiL_Odds_1", "XiL_Odds_2", "XiL_Odds_3", "XiL_Odds_4", "XiL_Odds_5", "Up_Odds", "Luck", "Grow", "Up_Min", "Up_Max", "Down_Min", "Down_Max", 
}

xilianTable = {
    id_1 = {"5", "35", "40", "20", "4", "1", "60", "20", "0.25", "0.35", "1.25", "0.05", "0.35", },
    id_2 = {"6", "5", "20", "45", "25", "5", "62", "20", "0.25", "0.35", "1.55", "0.05", "0.35", },
    id_3 = {"7", "3", "25", "45", "20", "7", "64", "20", "0.25", "0.35", "2.25", "0.05", "0.35", },
}


function getDataById(key_id)
    local id_data = xilianTable["id_" .. key_id]
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

    for k, v in pairs(xilianTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return xilianTable
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

    for k, v in pairs(xilianTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["xilian"] = nil
    package.loaded["xilian"] = nil
end
