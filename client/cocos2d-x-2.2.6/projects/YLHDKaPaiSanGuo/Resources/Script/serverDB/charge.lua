-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("charge", package.seeall)


keys = {
	"﻿Index", "Type", "Name", "ResImg", "Text", "AfterText", "Gold", "Price", "AddGold", "Tag", "FristCharge", 
}

chargeTable = {
    id_1 = {"0", "50|元宝", "8301", "购买礼包可获得%d元宝", "0", "50", "5", "5", "0", "50", },
    id_2 = {"0", "200|元宝", "8302", "购买礼包可获得%d元宝", "0", "200", "20", "20", "1", "200", },
    id_3 = {"0", "500|元宝", "8303", "购买礼包可获得%d元宝", "0", "500", "50", "50", "1", "500", },
    id_4 = {"0", "1280|元宝", "8304", "购买礼包可获得%d元宝", "0", "1280", "128", "128", "1", "1280", },
    id_5 = {"2", "凤卡（10日）", "8306", "立即赠送%d元宝，10天每天可领取30元宝。", "每日在任务界面领取30元宝，剩余%d天。", "30", "3", "3", "3", "30", },
    id_6 = {"1", "龙卡（30日）", "8305", "立即赠送%d元宝，30天每天可领取50元宝。", "每日在任务界面领取50元宝，剩余%d天。", "60", "6", "6", "3", "60", },
}


function getDataById(key_id)
    local id_data = chargeTable["id_" .. key_id]
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

    for k, v in pairs(chargeTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return chargeTable
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

    for k, v in pairs(chargeTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["charge"] = nil
    package.loaded["charge"] = nil
end
