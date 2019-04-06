-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("techeffect", package.seeall)


keys = {
	"﻿TechEffectID", "EffectType", "EffectPara1", "EffectPara2", "EffectPara3", "EffectPara4", "EffectPara5", "EffectPara6", 
}

techeffectTable = {
    id_10101 = {"6", "10", "4", "2", "200", "1", "0", },
    id_10102 = {"6", "10", "4", "3", "300", "1", "0", },
    id_10103 = {"6", "10", "4", "4", "400", "1", "0", },
    id_10104 = {"6", "10", "4", "5", "500", "1", "0", },
    id_10105 = {"6", "10", "4", "6", "600", "1", "0", },
    id_10106 = {"6", "10", "4", "7", "700", "1", "0", },
    id_10107 = {"6", "10", "4", "8", "800", "1", "0", },
    id_10108 = {"6", "10", "4", "9", "900", "1", "0", },
    id_10109 = {"6", "10", "4", "10", "1000", "1", "0", },
    id_10110 = {"6", "10", "4", "11", "1100", "1", "0", },
    id_10200 = {"2", "20", "0", "0", "0", "0", "0", },
    id_10201 = {"2", "40", "0", "0", "0", "0", "0", },
    id_10202 = {"2", "60", "0", "0", "0", "0", "0", },
    id_10203 = {"2", "80", "0", "0", "0", "0", "0", },
    id_10301 = {"3", "1", "0", "0", "0", "0", "0", },
    id_10302 = {"3", "2", "0", "0", "0", "0", "0", },
    id_10303 = {"3", "3", "0", "0", "0", "0", "0", },
    id_20301 = {"4", "1", "0", "0", "0", "0", "0", },
    id_20302 = {"4", "2", "0", "0", "0", "0", "0", },
    id_20303 = {"4", "3", "0", "0", "0", "0", "0", },
    id_10401 = {"1", "47", "50", "53", "0", "0", "0", },
    id_10402 = {"1", "48", "51", "54", "0", "0", "0", },
    id_10403 = {"1", "49", "52", "55", "0", "0", "0", },
    id_10501 = {"1", "56", "59", "62", "0", "0", "0", },
    id_10502 = {"1", "57", "60", "63", "0", "0", "0", },
    id_10503 = {"1", "58", "61", "64", "0", "0", "0", },
    id_10601 = {"5", "3", "0", "0", "0", "0", "0", },
    id_10602 = {"5", "4", "0", "0", "0", "0", "0", },
    id_10603 = {"5", "5", "0", "0", "0", "0", "0", },
    id_10700 = {"8", "7", "1", "3", "13", "0", "0", },
    id_10701 = {"8", "8", "2", "4", "14", "0", "0", },
    id_10702 = {"8", "9", "3", "5", "15", "0", "0", },
    id_10703 = {"8", "10", "4", "6", "16", "0", "0", },
    id_10801 = {"9", "0", "0", "0", "0", "0", "0", },
    id_10802 = {"9", "0", "0", "0", "0", "0", "0", },
    id_10803 = {"9", "0", "0", "0", "0", "0", "0", },
    id_10901 = {"10", "0", "0", "0", "0", "0", "0", },
    id_10902 = {"10", "0", "0", "0", "0", "0", "0", },
    id_10903 = {"10", "0", "0", "0", "0", "0", "0", },
    id_11001 = {"11", "0", "0", "0", "0", "0", "0", },
    id_11002 = {"11", "0", "0", "0", "0", "0", "0", },
    id_11003 = {"11", "0", "0", "0", "0", "0", "0", },
    id_12001 = {"7", "12001", "0", "0", "0", "0", "0", },
    id_12002 = {"7", "12002", "0", "0", "0", "0", "0", },
    id_12003 = {"7", "12003", "0", "0", "0", "0", "0", },
    id_12101 = {"7", "12101", "25", "0", "0", "0", "0", },
    id_12102 = {"7", "12102", "25", "0", "0", "0", "0", },
    id_12103 = {"7", "12103", "25", "0", "0", "0", "0", },
    id_12201 = {"7", "12201", "26", "0", "0", "0", "0", },
    id_12202 = {"7", "12202", "26", "0", "0", "0", "0", },
    id_12203 = {"7", "12203", "26", "0", "0", "0", "0", },
    id_12301 = {"7", "12301", "27", "0", "0", "0", "0", },
    id_12302 = {"7", "12302", "27", "0", "0", "0", "0", },
    id_12303 = {"7", "12303", "27", "0", "0", "0", "0", },
    id_12401 = {"7", "12401", "28", "0", "0", "0", "0", },
    id_12402 = {"7", "12402", "28", "0", "0", "0", "0", },
    id_12403 = {"7", "12403", "28", "0", "0", "0", "0", },
    id_12501 = {"7", "12501", "29", "0", "0", "0", "0", },
    id_12502 = {"7", "12502", "29", "0", "0", "0", "0", },
    id_12503 = {"7", "12503", "29", "0", "0", "0", "0", },
}


function getDataById(key_id)
    local id_data = techeffectTable["id_" .. key_id]
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

    for k, v in pairs(techeffectTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return techeffectTable
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

    for k, v in pairs(techeffectTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["techeffect"] = nil
    package.loaded["techeffect"] = nil
end
