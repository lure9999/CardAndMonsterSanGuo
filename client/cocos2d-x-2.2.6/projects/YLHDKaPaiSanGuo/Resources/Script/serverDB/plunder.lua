-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("plunder", package.seeall)


keys = {
	"﻿index", "Level", "High_Max", "High_Min", "High_Robot", "High_Winrate", "Normal_Max", "Normal_Min", "Normal_Robot", "Normal_Winrate", "Low_Max", "Low_Min", "Low_Robot", "Low_Winrate", "BoxDropID", 
}

plunderTable = {
    id_1 = {"30", "7029", "5709", "100", "0.65", "2535", "2055", "108", "0.85", "2535", "2055", "116", "1.8", "721", },
    id_2 = {"40", "10400", "8480", "101", "0.6", "9417", "7737", "109", "0.8", "9417", "7737", "117", "1.8", "722", },
    id_3 = {"50", "50944", "41704", "102", "0.55", "44491", "36451", "110", "0.75", "44491", "36451", "118", "1.8", "723", },
    id_4 = {"60", "50882", "41642", "103", "0.5", "18962", "15482", "111", "0.7", "18962", "15482", "119", "1.8", "724", },
    id_5 = {"70", "27720", "22680", "104", "0.45", "75865", "62065", "112", "0.65", "75865", "62065", "120", "1.8", "725", },
    id_6 = {"80", "89237", "73037", "105", "0.4", "65489", "53609", "113", "0.6", "65489", "53609", "121", "1.8", "726", },
    id_7 = {"90", "94427", "77267", "106", "0.35", "69508", "56908", "114", "0.55", "32122", "26242", "122", "1.8", "727", },
    id_8 = {"100", "101207", "82847", "107", "0.3", "85009", "69529", "115", "0.5", "42165", "34485", "123", "1.8", "728", },
}


function getDataById(key_id)
    local id_data = plunderTable["id_" .. key_id]
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

    for k, v in pairs(plunderTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return plunderTable
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

    for k, v in pairs(plunderTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["plunder"] = nil
    package.loaded["plunder"] = nil
end
