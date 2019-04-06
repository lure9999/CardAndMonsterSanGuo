-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("coin", package.seeall)


keys = {
	"﻿CionID", "Name", "ResID", "go", "object", 
}

coinTable = {
    id_0 = {"道具", "-1", "0", "1", },
    id_1 = {"银币", "1", "1", "1", },
    id_2 = {"元宝", "2", "2", "1", },
    id_3 = {"鸡腿(体力)", "3", "3", "1", },
    id_4 = {"包子(耐力)", "4", "4", "1", },
    id_5 = {"主将经验", "5", "5", "1", },
    id_6 = {"武将经验", "6", "6", "1", },
    id_7 = {"预留待定", "-1", "-1", "-1", },
    id_8 = {"宝物经验", "-1", "0", "4", },
    id_9 = {"比武声望", "9", "7", "1", },
    id_10 = {"军团贡献", "10", "8", "1", },
    id_11 = {"国战声望", "12", "2", "1", },
    id_12 = {"国家经验", "12", "9", "3", },
    id_13 = {"军团银币", "13", "10", "2", },
    id_14 = {"国家经验", "12", "9", "3", },
    id_15 = {"预留待定", "-1", "1", "1", },
    id_16 = {"预留待定", "-1", "2", "1", },
    id_17 = {"星魂", "17", "11", "1", },
}


function getDataById(key_id)
    local id_data = coinTable["id_" .. key_id]
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

    for k, v in pairs(coinTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return coinTable
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

    for k, v in pairs(coinTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["coin"] = nil
    package.loaded["coin"] = nil
end
