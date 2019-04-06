-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("vipfunction", package.seeall)


keys = {
	"﻿ID", "Type", "TypePara", "PlayerLv", "LvPara", "Segment1", "Para1", "Segment2", "Para2", "Segment3", "Para3", "Segment4", "Para4", "Segment5", "Para5", 
}

vipfunctionTable = {
    id_1 = {"0", "0", "40", "-1", "2", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_2 = {"0", "0", "45", "-1", "1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_3 = {"0", "0", "-1", "-1", "2", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_4 = {"0", "0", "-1", "-1", "3", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_5 = {"0", "0", "25", "-1", "1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_6 = {"0", "0", "35", "-1", "2", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_7 = {"0", "0", "20", "-1", "1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_8 = {"0", "0", "60", "-1", "3", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_9 = {"0", "0", "-1", "-1", "5", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_10 = {"0", "0", "40", "-1", "2", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_11 = {"1", "150", "1", "1", "1", "2", "3", "3", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_12 = {"1", "151", "-1", "-1", "5", "1", "7", "2", "9", "3", "-1", "-1", "-1", "-1", },
    id_13 = {"1", "152", "-1", "-1", "6", "1", "8", "2", "10", "3", "-1", "-1", "-1", "-1", },
    id_14 = {"1", "155", "-1", "-1", "11", "1", "13", "2", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_15 = {"1", "153", "1", "1", "2", "2", "4", "3", "6", "4", "8", "5", "-1", "-1", },
    id_16 = {"1", "156", "-1", "-1", "3", "1", "6", "2", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_17 = {"1", "157", "-1", "-1", "4", "1", "7", "2", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_18 = {"2", "0", "-1", "-1", "1", "150", "3", "200", "5", "250", "7", "300", "9", "350", },
    id_19 = {"1", "154", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_20 = {"1", "154", "-1", "-1", "10", "1", "12", "2", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_21 = {"0", "0", "50", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_22 = {"0", "0", "55", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_23 = {"0", "0", "30", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_24 = {"0", "0", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_25 = {"0", "0", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_26 = {"0", "0", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_27 = {"0", "0", "10", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_28 = {"0", "0", "25", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_29 = {"0", "0", "30", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
}


function getDataById(key_id)
    local id_data = vipfunctionTable["id_" .. key_id]
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

    for k, v in pairs(vipfunctionTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return vipfunctionTable
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

    for k, v in pairs(vipfunctionTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["vipfunction"] = nil
    package.loaded["vipfunction"] = nil
end
