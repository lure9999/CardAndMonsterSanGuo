-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("resani", package.seeall)


keys = {
	"﻿id", "ani_path", "ani_name", "ani_act", 
}

resaniTable = {
    id_20000 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wei01/Scene_guozhan_wei01.ExportJson", "Scene_guozhan_wei01", "putong_n", },
    id_20001 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wei02/Scene_guozhan_wei02.ExportJson", "Scene_guozhan_wei02", "putong_n", },
    id_20002 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wei03/Scene_guozhan_wei03.ExportJson", "Scene_guozhan_wei03", "putong_n", },
    id_20003 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wei04/Scene_guozhan_wei04.ExportJson", "Scene_guozhan_wei04", "putong_n", },
    id_20004 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_luoyang01/Scene_guozhan_luoyang01.ExportJson", "Scene_guozhan_luoyang01", "putong_n", },
    id_20005 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_shu01/Scene_guozhan_shu01.ExportJson", "Scene_guozhan_shu01", "putong_n", },
    id_20006 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_shu02/Scene_guozhan_shu02.ExportJson", "Scene_guozhan_shu02", "putong_n", },
    id_20007 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_shu03/Scene_guozhan_shu03.ExportJson", "Scene_guozhan_shu03", "putong_n", },
    id_20008 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_shu04/Scene_guozhan_shu04.ExportJson", "Scene_guozhan_shu04", "putong_n", },
    id_20009 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_chengdu01/Scene_guozhan_chengdu01.ExportJson", "Scene_guozhan_chengdu01", "putong_n", },
    id_20010 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wu01/Scene_guozhan_wu01.ExportJson", "Scene_guozhan_wu01", "putong_n", },
    id_20011 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wu02/Scene_guozhan_wu02.ExportJson", "Scene_guozhan_wu02", "putong_n", },
    id_20012 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wu03/Scene_guozhan_wu03.ExportJson", "Scene_guozhan_wu03", "putong_n", },
    id_20013 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_wu04/Scene_guozhan_wu04.ExportJson", "Scene_guozhan_wu04", "putong_n", },
    id_20014 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_jianye01/Scene_guozhan_jianye01.ExportJson", "Scene_guozhan_jianye01", "putong_n", },
    id_20015 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_guanka01/Scene_guozhan_guanka01.ExportJson", "Scene_guozhan_guanka01", "putong_n", },
    id_20016 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_guanka02/Scene_guozhan_guanka02.ExportJson", "Scene_guozhan_guanka02", "putong_n", },
    id_20017 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_guanka03/Scene_guozhan_guanka03.ExportJson", "Scene_guozhan_guanka03", "putong_n", },
    id_20018 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_shuiyu01/Scene_guozhan_shuiyu01.ExportJson", "Scene_guozhan_shuiyu01", "putong_n", },
    id_20019 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_tuntian01/Scene_guozhan_tuntian01.ExportJson", "Scene_guozhan_tuntian01", "putong_n", },
    id_20020 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_xiangyang01/Scene_guozhan_xiangyang01.ExportJson", "Scene_guozhan_xiangyang01", "putong_n", },
    id_20021 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_zhucheng/Scene_guozhan_zhucheng.ExportJson", "Scene_guozhan_zhucheng", "putong_n", },
    id_20022 = {"Image/Fight/animation/Scene_guozhan/Scene_guozhan_juntuan/Scene_guozhan_juntuan.ExportJson", "Scene_guozhan_juntuan", "putong_n", },
}


function getDataById(key_id)
    local id_data = resaniTable["id_" .. key_id]
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

    for k, v in pairs(resaniTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return resaniTable
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

    for k, v in pairs(resaniTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["resani"] = nil
    package.loaded["resani"] = nil
end
