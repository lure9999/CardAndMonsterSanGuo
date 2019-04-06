-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("dailytask", package.seeall)


keys = {
	"﻿ID", "Area", "InterceptID", "TaskID", "Point", "Go", "CondID1", "CondID2", "CondID3", 
}

dailytaskTable = {
    id_1 = {"1", "200", "2019", "5", "17", "0", "0", "0", },
    id_2 = {"1", "200", "2021", "10", "17", "0", "0", "0", },
    id_3 = {"1", "200", "2016", "5", "9", "1", "0", "0", },
    id_4 = {"1", "200", "2017", "5", "9", "2", "0", "0", },
    id_5 = {"1", "200", "2001", "5", "1", "0", "0", "0", },
    id_6 = {"1", "200", "2002", "5", "6", "0", "0", "0", },
    id_7 = {"1", "200", "2003", "5", "7", "0", "0", "0", },
    id_8 = {"1", "200", "2004", "5", "8", "0", "0", "0", },
    id_9 = {"1", "200", "2005", "5", "10", "2", "0", "0", },
    id_10 = {"1", "206", "2006", "4", "2", "0", "0", "0", },
    id_11 = {"1", "200", "2007", "5", "5", "0", "0", "0", },
    id_12 = {"1", "200", "2008", "5", "5", "0", "0", "0", },
    id_13 = {"1", "213", "2009", "3", "5", "0", "0", "0", },
    id_14 = {"1", "210", "2010", "3", "5", "0", "0", "0", },
    id_15 = {"1", "211", "2011", "5", "5", "0", "0", "0", },
    id_16 = {"1", "200", "2012", "5", "4", "0", "0", "0", },
    id_17 = {"1", "206", "2013", "5", "4", "0", "0", "0", },
    id_18 = {"1", "200", "2014", "5", "4", "0", "0", "0", },
    id_19 = {"1", "200", "2015", "5", "3", "0", "0", "0", },
    id_20 = {"1", "200", "2018", "5", "11", "1", "212", "0", },
    id_21 = {"1", "200", "2020", "5", "11", "1", "211", "0", },
    id_22 = {"1", "200", "2022", "5", "16", "3", "0", "0", },
    id_23 = {"1", "200", "2023", "5", "16", "4", "0", "0", },
}


function getDataById(key_id)
    local id_data = dailytaskTable["id_" .. key_id]
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

    for k, v in pairs(dailytaskTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return dailytaskTable
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

    for k, v in pairs(dailytaskTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["dailytask"] = nil
    package.loaded["dailytask"] = nil
end
