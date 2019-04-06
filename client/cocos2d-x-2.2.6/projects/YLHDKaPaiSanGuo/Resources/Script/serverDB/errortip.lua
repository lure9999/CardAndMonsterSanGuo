-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("errortip", package.seeall)


keys = {
	"﻿id", "text", "type", 
}

errortipTable = {
    id_1001 = {"密码错误", "1", },
    id_1002 = {"名字已存在", nil, },
    id_1003 = {"背包已满，多余物品已发送到邮箱", nil, },
    id_1004 = {"银币不足", nil, },
    id_1005 = {"金币不足", nil, },
    id_1006 = {"超过主将等级", nil, },
    id_1007 = {"体力不足", nil, },
    id_1008 = {"获取商店失败", nil, },
    id_1009 = {"主将等级限制", nil, },
    id_1010 = {"vip等级受限", nil, },
    id_1011 = {"背包已满，请清理背包再行购买", nil, },
    id_1012 = {"使用箱子超过限制", nil, },
    id_1013 = {"用过模板未找到物品", nil, },
    id_1014 = {"与服务器数据不匹配，重新获得", nil, },
    id_1015 = {"服务器掉落错误", nil, },
    id_1016 = {"该职业未激活", nil, },
    id_1017 = {"该装备限制洗练", nil, },
    id_1018 = {"装备碎片不足", nil, },
    id_1019 = {"将魂不足", nil, },
    id_1020 = {"武将已存在", nil, },
    id_1021 = {"经验不足", nil, },
    id_1022 = {"星魂不足", nil, },
    id_1030 = {"强化条件不足", nil, },
    id_1031 = {"洗练条件不足", nil, },
    id_1032 = {"精炼条件不足", nil, },
}


function getDataById(key_id)
    local id_data = errortipTable["id_" .. key_id]
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

    for k, v in pairs(errortipTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return errortipTable
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

    for k, v in pairs(errortipTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["errortip"] = nil
    package.loaded["errortip"] = nil
end
