-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("countrystate", package.seeall)


keys = {
	"﻿Index", "StateName", "Weiwei", "Weishu", "Weiwu", "Shuwei", "Shushu", "Shuwu", "Wuwei", "Wushu", "Wuwu", "Powerful1", "Powerful2", "Weak1", "Weak2", "WeakArmyBuffID", "WeakUesrBuffID", "TaskStandardCoun", 
}

countrystateTable = {
    id_1 = {"三国鼎力", "1", "2", "2", "2", "1", "2", "2", "2", "1", "0", "0", "0", "0", "0", "0", "3", },
    id_2 = {"吴蜀争霸", "1", "2", "2", "2", "1", "2", "2", "2", "1", "3", "2", "1", "0", "0", "0", "1", },
    id_3 = {"吴魏争霸", "1", "2", "2", "2", "1", "2", "2", "2", "1", "3", "1", "2", "0", "0", "0", "2", },
    id_4 = {"蜀魏争霸", "1", "2", "2", "2", "1", "2", "2", "2", "1", "2", "1", "3", "0", "0", "0", "3", },
    id_5 = {"吴蜀联盟", "1", "2", "2", "2", "1", "3", "2", "3", "1", "1", "0", "3", "2", "0", "0", "1", },
    id_6 = {"吴魏联盟", "1", "2", "3", "2", "1", "2", "3", "2", "1", "2", "0", "3", "1", "0", "0", "2", },
    id_7 = {"蜀魏联盟", "1", "3", "2", "3", "1", "2", "2", "2", "1", "3", "0", "2", "1", "0", "0", "3", },
}


function getDataById(key_id)
    local id_data = countrystateTable["id_" .. key_id]
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

    for k, v in pairs(countrystateTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return countrystateTable
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

    for k, v in pairs(countrystateTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["countrystate"] = nil
    package.loaded["countrystate"] = nil
end
