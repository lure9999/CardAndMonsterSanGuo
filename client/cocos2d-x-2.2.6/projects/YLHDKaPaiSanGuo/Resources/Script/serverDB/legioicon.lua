-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("legioicon", package.seeall)


keys = {
	"﻿ID", "iconid", 
}

legioiconTable = {
    id_1 = {"201", },
    id_2 = {"202", },
    id_3 = {"203", },
    id_4 = {"204", },
    id_5 = {"205", },
    id_6 = {"206", },
    id_7 = {"207", },
    id_8 = {"208", },
    id_9 = {"209", },
    id_10 = {"210", },
    id_11 = {"211", },
    id_12 = {"212", },
    id_13 = {"213", },
    id_14 = {"214", },
    id_15 = {"215", },
    id_16 = {"216", },
    id_17 = {"217", },
    id_18 = {"218", },
    id_19 = {"219", },
    id_20 = {"220", },
    id_21 = {"221", },
    id_22 = {"222", },
    id_23 = {"223", },
    id_24 = {"224", },
    id_25 = {"225", },
    id_26 = {"226", },
    id_27 = {"227", },
    id_28 = {"228", },
    id_29 = {"229", },
    id_30 = {"230", },
    id_31 = {"231", },
    id_32 = {"232", },
    id_33 = {"233", },
    id_34 = {"234", },
    id_35 = {"235", },
    id_36 = {"236", },
    id_37 = {"237", },
    id_38 = {"238", },
    id_39 = {"239", },
    id_40 = {"240", },
    id_41 = {"241", },
}


function getDataById(key_id)
    local id_data = legioiconTable["id_" .. key_id]
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

    for k, v in pairs(legioiconTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return legioiconTable
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

    for k, v in pairs(legioiconTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["legioicon"] = nil
    package.loaded["legioicon"] = nil
end
