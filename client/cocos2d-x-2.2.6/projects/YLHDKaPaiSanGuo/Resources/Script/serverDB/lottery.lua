-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("lottery", package.seeall)


keys = {
	"﻿LotteryID", "CionID_1", "Number_1", "CionID_2", "Number_2", "CionID_3", "Number_3", "CionID_4", "Number_4", "CionID_5", "Number_5", "DropNum", "DropID", 
}

lotteryTable = {
    id_1 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "701", },
    id_2 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "702", },
    id_3 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "703", },
    id_4 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "704", },
    id_5 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "711", },
    id_6 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "712", },
    id_7 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "713", },
    id_8 = {"5", "12", "6", "12", "1", "480", "-1", "-1", "-1", "-1", "5", "714", },
}


function getDataById(key_id)
    local id_data = lotteryTable["id_" .. key_id]
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

    for k, v in pairs(lotteryTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return lotteryTable
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

    for k, v in pairs(lotteryTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["lottery"] = nil
    package.loaded["lottery"] = nil
end
