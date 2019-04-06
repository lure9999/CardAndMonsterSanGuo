-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("expenditionpath", package.seeall)


keys = {
	"﻿Index", "PathID", "Node1", "Node2", "Node3", "Node4", "Node5", "Node6", "Node7", "Node8", "Node9", "Node10", "Node11", "Node12", "Node13", "Node14", "Node15", "Node16", "Node17", "Node18", "Node19", "Node20", 
}

expenditionpathTable = {
    id_1 = {"1", "34", "64", "65", "24", "21", "20", "22", "18", "8", "6", "5", "11", "10", "256", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_2 = {"1", "34", "64", "65", "24", "21", "20", "22", "18", "8", "6", "5", "11", "10", "256", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_3 = {"2", "34", "60", "63", "73", "74", "56", "57", "78", "246", "248", "251", "250", "234", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_4 = {"2", "34", "60", "63", "73", "74", "56", "57", "78", "246", "248", "251", "250", "234", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_5 = {"3", "34", "60", "61", "73", "75", "76", "79", "80", "82", "142", "140", "139", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_6 = {"4", "34", "60", "61", "73", "75", "76", "79", "81", "84", "204", "201", "198", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_7 = {"5", "100", "105", "109", "106", "110", "113", "112", "256", "10", "11", "5", "6", "8", "18", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_8 = {"5", "100", "105", "109", "106", "110", "113", "112", "256", "10", "11", "5", "6", "8", "18", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_9 = {"6", "100", "104", "126", "124", "131", "130", "134", "155", "156", "165", "164", "166", "170", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_10 = {"6", "100", "104", "126", "124", "131", "130", "134", "155", "156", "165", "164", "166", "170", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_11 = {"7", "100", "105", "121", "120", "123", "118", "139", "140", "142", "82", "80", "79", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_12 = {"8", "100", "105", "121", "120", "123", "118", "139", "141", "144", "202", "200", "198", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_13 = {"9", "190", "189", "195", "193", "196", "207", "235", "234", "250", "251", "248", "246", "78", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_14 = {"9", "190", "189", "195", "193", "196", "207", "235", "234", "250", "251", "248", "246", "78", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_15 = {"10", "190", "187", "188", "186", "185", "173", "180", "170", "166", "164", "165", "156", "155", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_16 = {"10", "190", "187", "188", "186", "185", "173", "180", "170", "166", "164", "165", "156", "155", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_17 = {"11", "190", "189", "193", "184", "196", "197", "198", "201", "204", "84", "81", "79", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_18 = {"12", "190", "189", "193", "184", "196", "197", "198", "200", "202", "144", "141", "139", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
}


function getDataById(key_id)
    local id_data = expenditionpathTable["id_" .. key_id]
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

    for k, v in pairs(expenditionpathTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return expenditionpathTable
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

    for k, v in pairs(expenditionpathTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["expenditionpath"] = nil
    package.loaded["expenditionpath"] = nil
end
