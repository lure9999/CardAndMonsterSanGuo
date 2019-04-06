-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("qianghua", package.seeall)


keys = {
	"﻿QiangHConsumeID", "Crit%_1", "Crit%_2", "Crit%_3", "Crit%_4", "Crit%_5", "CritNum_1", "CritNum_2", "CritNum_3", "CritNum_4", "CritNum_5", 
}

qianghuaTable = {
    id_1001 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1002 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1003 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1004 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1005 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1006 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1007 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1008 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1009 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1010 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1011 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1012 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1013 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1014 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1015 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1016 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1017 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1018 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1019 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1020 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1021 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1022 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1023 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1024 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1025 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1026 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1027 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1028 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1029 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1030 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1031 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1032 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1033 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1034 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1035 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1036 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1037 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1038 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1039 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1040 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1041 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1042 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1043 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
    id_1044 = {"47", "25", "15", "8", "5", "1", "2", "3", "4", "5", },
}


function getDataById(key_id)
    local id_data = qianghuaTable["id_" .. key_id]
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

    for k, v in pairs(qianghuaTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return qianghuaTable
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

    for k, v in pairs(qianghuaTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["qianghua"] = nil
    package.loaded["qianghua"] = nil
end
