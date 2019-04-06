-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("SceneData", package.seeall)


keys = {
	"﻿SceneID", "ScenceFileName", "ScenceType", "ScriptID", 
}

SceneDataTable = {
    id_1 = {"publish/Scene_jingjichang.json", "1", "100", },
    id_2 = {"publish/Scene_duoyi.json", "0", "10000", },
    id_3 = {"publish/Scene_shinei01.json", "0", "200", },
    id_4 = {"publish/Scene_shinei01_reversal.json", "0", "200", },
    id_5 = {"publish/Scene_shinei01_02.json", "0", "200", },
    id_6 = {"publish/Scene_shinei01_02_reversal.json", "0", "200", },
    id_7 = {"publish/Scene_shinei01_01.json", "0", "200", },
    id_8 = {"publish/Scene_shinei01_01_reversal.json", "0", "200", },
    id_11 = {"publish/Scene_zhanchang_wu.json", "1", "100", },
    id_12 = {"publish/Scene_zhanchang_shu.json", "1", "100", },
    id_13 = {"publish/Scene_zhanchang_wei.json", "1", "100", },
    id_14 = {"publish/Scene_jingjichang.json", "1", "100", },
    id_15 = {"publish/Scene_duoyi.json", "0", "1", },
    id_16 = {"publish/Scene_duoyi_reversal.json", "0", "1", },
    id_1000 = {"publish/Scene_chibi.json", "0", "3", },
    id_1001 = {"publish/Scene_duoyi.json", "0", "2", },
    id_1002 = {"publish/Scene_duoyi.json", "0", "0", },
    id_1003 = {"publish/Scene_chibi.json", "0", "0", },
    id_1004 = {"publish/Scene_rancheng.json", "0", "0", },
    id_1005 = {"publish/Scene_hongtu.json", "0", "0", },
    id_1006 = {"publish/Scene_xuejing.json", "0", "0", },
    id_1007 = {"publish/Scene_anyi.json", "0", "0", },
    id_1008 = {"publish/Scene_gaoqiang.json", "0", "0", },
    id_1009 = {"publish/Scene_shanpo.json", "0", "0", },
    id_1010 = {"publish/Scene_xuejing01.json", "0", "0", },
    id_1011 = {"publish/Scene_duoyi_reversal.json", "0", "0", },
    id_1012 = {"publish/Scene_chibi_reversal.json", "0", "0", },
    id_1013 = {"publish/Scene_rancheng_reversal.json", "0", "0", },
    id_1014 = {"publish/Scene_hongtu_reversal.json", "0", "0", },
    id_1015 = {"publish/Scene_xuejing_reversal.json", "0", "0", },
    id_1016 = {"publish/Scene_anyi_reversal.json", "0", "0", },
    id_1017 = {"publish/Scene_gaoqiang_reversal.json", "0", "0", },
    id_1018 = {"publish/Scene_shanpo_reversal.json", "0", "0", },
    id_1019 = {"publish/Scene_xuejing01_reversal.json", "0", "0", },
    id_10001 = {"publish/Scene_duoyi.json", "0", "10001", },
    id_10002 = {"publish/Scene_duoyi.json", "0", "10002", },
}


function getDataById(key_id)
    local id_data = SceneDataTable["id_" .. key_id]
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

    for k, v in pairs(SceneDataTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return SceneDataTable
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

    for k, v in pairs(SceneDataTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["SceneData"] = nil
    package.loaded["SceneData"] = nil
end
