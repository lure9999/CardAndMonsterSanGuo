-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("head", package.seeall)


keys = {
	"﻿ID", "resID", "Sex", "Des", "Para_1", "Para_2", 
}

headTable = {
    id_1 = {"147", "0", "vip3解锁", "1", "3", },
    id_2 = {"148", "0", "vip5解锁", "1", "5", },
    id_3 = {"149", "0", "vip7解锁", "1", "7", },
    id_4 = {"150", "1", "比武第一解锁", "2", "1", },
    id_5 = {"151", "2", "比武第一解锁", "2", "1", },
}


function getDataById(key_id)
    local id_data = headTable["id_" .. key_id]
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

    for k, v in pairs(headTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return headTable
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

    for k, v in pairs(headTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["head"] = nil
    package.loaded["head"] = nil
end
