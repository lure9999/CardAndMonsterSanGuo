-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("coinshow", package.seeall)


keys = {
	"﻿Index", "ColumnType1", "Column1", "ColumnType2", "Column2", "ColumnType3", "Column3", "ColumnType4", "Column4", "ColumnType5", "Column5", 
}

coinshowTable = {
    id_1 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_2 = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", },
    id_3 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_4 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_5 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_6 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_7 = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", },
    id_8 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_9 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_10 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_11 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_12 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_13 = {"1", "2", "1", "1", "1", "4", "1", "9", "3", "1", },
    id_14 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_15 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_16 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_17 = {"1", "2", "1", "1", "1", "4", "1", "17", "3", "1", },
    id_18 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_19 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_20 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_21 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_22 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_23 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_24 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_25 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_26 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_27 = {"1", "2", "1", "1", "2", "219", "0", "0", "3", "1", },
    id_28 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_29 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_30 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_31 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_32 = {"1", "2", "1", "1", "1", "4", "1", "3", "3", "1", },
    id_33 = {"1", "2", "1", "1", "1", "4", "1", "9", "3", "1", },
}


function getDataById(key_id)
    local id_data = coinshowTable["id_" .. key_id]
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

    for k, v in pairs(coinshowTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return coinshowTable
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

    for k, v in pairs(coinshowTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["coinshow"] = nil
    package.loaded["coinshow"] = nil
end
