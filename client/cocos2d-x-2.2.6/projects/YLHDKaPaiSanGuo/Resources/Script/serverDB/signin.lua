-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("signin", package.seeall)


keys = {
	"﻿Index", "MonthID", "Sign_Times", "NPointRewID", "Multi_Require", "Multi_Times", "SOrderRewID", 
}

signinTable = {
    id_1 = {"4", "1", "300", "-1", "1", "1101", },
    id_2 = {"4", "2", "300", "4", "2", "1101", },
    id_3 = {"4", "3", "300", "-1", "1", "1101", },
    id_4 = {"4", "4", "300", "8", "2", "1101", },
    id_5 = {"4", "5", "300", "-1", "1", "1101", },
    id_6 = {"4", "6", "302", "4", "2", "1101", },
    id_7 = {"4", "7", "308", "-1", "1", "1101", },
    id_8 = {"4", "8", "314", "5", "2", "1101", },
    id_9 = {"4", "9", "320", "-1", "1", "1101", },
    id_10 = {"4", "10", "326", "6", "2", "1101", },
    id_11 = {"4", "11", "303", "7", "2", "1101", },
    id_12 = {"4", "12", "309", "-1", "1", "1101", },
    id_13 = {"4", "13", "315", "8", "2", "1101", },
    id_14 = {"4", "14", "321", "-1", "1", "1101", },
    id_15 = {"4", "15", "327", "9", "2", "1101", },
    id_16 = {"4", "16", "304", "10", "2", "1101", },
    id_17 = {"4", "17", "310", "-1", "1", "1101", },
    id_18 = {"4", "18", "316", "11", "2", "1101", },
    id_19 = {"4", "19", "322", "-1", "1", "1101", },
    id_20 = {"4", "20", "328", "12", "1", "1101", },
    id_21 = {"4", "21", "305", "-1", "1", "1101", },
    id_22 = {"4", "22", "311", "-1", "1", "1101", },
    id_23 = {"4", "23", "317", "13", "2", "1101", },
    id_24 = {"4", "24", "323", "-1", "1", "1101", },
    id_25 = {"4", "25", "329", "-1", "1", "1101", },
    id_26 = {"4", "26", "306", "-1", "1", "1101", },
    id_27 = {"4", "27", "312", "-1", "1", "1101", },
    id_28 = {"4", "28", "318", "-1", "1", "1101", },
    id_29 = {"4", "29", "324", "-1", "1", "1101", },
    id_30 = {"4", "30", "330", "-1", "1", "1101", },
    id_31 = {"4", "31", "319", "-1", "1", "1101", },
    id_32 = {"5", "1", "301", "1", "2", "1101", },
    id_33 = {"5", "2", "307", "-1", "1", "1101", },
    id_34 = {"5", "3", "313", "2", "2", "1101", },
    id_35 = {"5", "4", "319", "-1", "1", "1101", },
    id_36 = {"5", "5", "325", "3", "2", "1101", },
    id_37 = {"5", "6", "302", "4", "2", "1101", },
    id_38 = {"5", "7", "308", "-1", "1", "1101", },
    id_39 = {"5", "8", "314", "5", "2", "1101", },
    id_40 = {"5", "9", "320", "-1", "1", "1101", },
    id_41 = {"5", "10", "326", "6", "2", "1101", },
    id_42 = {"5", "11", "303", "7", "2", "1101", },
    id_43 = {"5", "12", "309", "-1", "1", "1101", },
    id_44 = {"5", "13", "315", "8", "2", "1101", },
    id_45 = {"5", "14", "321", "-1", "1", "1101", },
    id_46 = {"5", "15", "327", "9", "2", "1101", },
    id_47 = {"5", "16", "304", "10", "2", "1101", },
    id_48 = {"5", "17", "310", "-1", "1", "1101", },
    id_49 = {"5", "18", "316", "11", "2", "1101", },
    id_50 = {"5", "19", "322", "-1", "1", "1101", },
    id_51 = {"5", "20", "328", "12", "1", "1101", },
    id_52 = {"5", "21", "305", "-1", "1", "1101", },
    id_53 = {"5", "22", "311", "-1", "1", "1101", },
    id_54 = {"5", "23", "317", "13", "2", "1101", },
    id_55 = {"5", "24", "323", "-1", "1", "1101", },
    id_56 = {"5", "25", "329", "-1", "1", "1101", },
    id_57 = {"5", "26", "306", "-1", "1", "1101", },
    id_58 = {"5", "27", "312", "-1", "1", "1101", },
    id_59 = {"5", "28", "318", "-1", "1", "1101", },
    id_60 = {"5", "29", "324", "-1", "1", "1101", },
    id_61 = {"5", "30", "330", "-1", "1", "1101", },
    id_62 = {"5", "31", "319", "-1", "1", "1101", },
}


function getDataById(key_id)
    local id_data = signinTable["id_" .. key_id]
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

    for k, v in pairs(signinTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return signinTable
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

    for k, v in pairs(signinTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["signin"] = nil
    package.loaded["signin"] = nil
end
