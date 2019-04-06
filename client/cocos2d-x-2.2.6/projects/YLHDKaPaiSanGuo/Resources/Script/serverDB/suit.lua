-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("suit", package.seeall)


keys = {
	"﻿SuitID", "SuitName", "EquipID_1", "EquipID_2", "EquipID_3", "EquipID_4", "SuitAttitude2_1", "SuitAttitude2_2", "SuitAttitude3_1", "SuitAttitude3_2", "SuitAttitude4_1", "SuitAttitude4_2", "SuitAttitude4_3", "SuitAttitude4_4", 
}

suitTable = {
    id_1 = {"七星套装", "2051", "2052", "2053", "2054", "1013", "1014", "1011", "1012", "1011", "1012", "1013", "1014", },
    id_2 = {"降龙套装", "2091", "2092", "2093", "2094", "1023", "1024", "1021", "1022", "1021", "1022", "1023", "1024", },
    id_3 = {"伏虎套装", "2101", "2102", "2103", "2104", "1033", "1034", "1031", "1032", "1031", "1032", "1033", "1034", },
    id_4 = {"蚩尤套装", "2141", "2142", "2143", "2144", "1043", "1044", "1041", "1042", "1041", "1042", "1043", "1044", },
    id_5 = {"盘古套装", "2151", "2152", "2153", "2154", "1053", "1054", "1051", "1052", "1051", "1052", "1053", "1054", },
}


function getDataById(key_id)
    local id_data = suitTable["id_" .. key_id]
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

    for k, v in pairs(suitTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return suitTable
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

    for k, v in pairs(suitTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["suit"] = nil
    package.loaded["suit"] = nil
end
