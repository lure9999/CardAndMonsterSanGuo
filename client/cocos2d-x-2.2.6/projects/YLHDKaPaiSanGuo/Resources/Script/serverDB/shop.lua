-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("shop", package.seeall)


keys = {
	"﻿ShopID", "ShopName", "ShopImgID", "placeImgID", "RefreshTime1", "RefreshTime2", "RefreshTime3", "RefreshTime4", "RefreshNumber", "ConsumptionID", "Talk_IDGroup", "SoldOut_IDGroup", 
}

shopTable = {
    id_1 = {"应龙小铺", "10000", "0", "930", "1830", "0", "0", "5", "100", "9|10|11|12", "13|14", },
    id_2 = {"比武旺铺", "10000", "0", "930", "0", "0", "0", "5", "101", "9|10|11|12", "13|14", },
    id_3 = {"初级军团商店", "10000", "0", "930", "0", "0", "0", "5", "102", "9|10|11|12", "13|14", },
    id_4 = {"中级军团商店", "10000", "0", "930", "0", "0", "0", "5", "102", "9|10|11|12", "13|14", },
    id_5 = {"高级军团商店", "10000", "0", "930", "0", "0", "0", "5", "102", "9|10|11|12", "13|14", },
    id_6 = {"特需军团商店", "10000", "0", "930", "0", "0", "0", "5", "102", "9|10|11|12", "13|14", },
    id_11 = {"熊猫杂货", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_12 = {"熊猫小店", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_13 = {"熊猫店铺", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_14 = {"1星熊猫旺铺", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_15 = {"2星熊猫旺铺", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_16 = {"3星熊猫旺铺", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_17 = {"4星熊猫旺铺", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_18 = {"5星熊猫旺铺", "10000", "1", "0", "0", "0", "0", "1", "100", "9|10|11|12", "13|14", },
    id_100 = {"超级装备", "10000", "1", "0", "0", "0", "0", "100", "100", "9|10|11|12", "13|14", },
    id_101 = {"超级道具", "10000", "1", "0", "0", "0", "0", "100", "100", "9|10|11|12", "13|14", },
}


function getDataById(key_id)
    local id_data = shopTable["id_" .. key_id]
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

    for k, v in pairs(shopTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return shopTable
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

    for k, v in pairs(shopTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["shop"] = nil
    package.loaded["shop"] = nil
end
