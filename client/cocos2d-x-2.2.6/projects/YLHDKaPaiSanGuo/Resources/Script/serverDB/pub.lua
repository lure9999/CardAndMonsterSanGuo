-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("pub", package.seeall)


keys = {
	"﻿Index", "PubType", "Level", "ConsumeID", "Agio", "BuyReward", "SingleDrop", "TenMustDrop", 
}

pubTable = {
    id_1 = {"0", "15", "8", "0.9", "9", "731", "741", },
    id_2 = {"0", "30", "8", "0.9", "9", "731", "741", },
    id_3 = {"0", "45", "8", "0.9", "9", "732", "742", },
    id_4 = {"0", "60", "8", "0.9", "9", "733", "743", },
    id_5 = {"0", "75", "8", "0.9", "9", "734", "744", },
    id_6 = {"0", "90", "8", "0.9", "9", "735", "745", },
    id_7 = {"0", "105", "8", "0.9", "9", "735", "745", },
    id_8 = {"1", "15", "9", "0.9", "8", "751", "761", },
    id_9 = {"1", "30", "9", "0.9", "8", "751", "761", },
    id_10 = {"1", "45", "9", "0.9", "8", "752", "762", },
    id_11 = {"1", "60", "9", "0.9", "8", "753", "763", },
    id_12 = {"1", "75", "9", "0.9", "8", "754", "764", },
    id_13 = {"1", "90", "9", "0.9", "8", "755", "765", },
    id_14 = {"1", "105", "9", "0.9", "8", "755", "765", },
}


function getDataById(key_id)
    local id_data = pubTable["id_" .. key_id]
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

    for k, v in pairs(pubTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return pubTable
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

    for k, v in pairs(pubTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["pub"] = nil
    package.loaded["pub"] = nil
end
