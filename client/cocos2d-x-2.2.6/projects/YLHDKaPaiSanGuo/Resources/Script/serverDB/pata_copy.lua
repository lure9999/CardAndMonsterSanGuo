-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("pata_copy", package.seeall)


keys = {
	"﻿index", "sceneID", "pointindex", 
}

pata_copyTable = {
    id_1 = {"50100", "1", },
    id_2 = {"50100", "2", },
    id_3 = {"50100", "3", },
    id_4 = {"50100", "4", },
    id_5 = {"50100", "5", },
    id_6 = {"50100", "6", },
    id_7 = {"50100", "7", },
    id_8 = {"50100", "8", },
    id_9 = {"50100", "9", },
    id_10 = {"50100", "10", },
    id_11 = {"50100", "11", },
    id_12 = {"50100", "12", },
    id_13 = {"50100", "13", },
    id_14 = {"50100", "14", },
    id_15 = {"50100", "15", },
    id_16 = {"50200", "1", },
    id_17 = {"50200", "2", },
    id_18 = {"50200", "3", },
    id_19 = {"50200", "4", },
    id_20 = {"50200", "5", },
    id_21 = {"50200", "6", },
    id_22 = {"50200", "7", },
    id_23 = {"50200", "8", },
    id_24 = {"50200", "9", },
    id_25 = {"50200", "10", },
    id_26 = {"50200", "11", },
    id_27 = {"50200", "12", },
    id_28 = {"50200", "13", },
    id_29 = {"50200", "14", },
    id_30 = {"50200", "15", },
    id_31 = {"50300", "1", },
    id_32 = {"50300", "2", },
    id_33 = {"50300", "3", },
    id_34 = {"50300", "4", },
    id_35 = {"50300", "5", },
    id_36 = {"50300", "6", },
    id_37 = {"50300", "7", },
    id_38 = {"50300", "8", },
    id_39 = {"50300", "9", },
    id_40 = {"50300", "10", },
    id_41 = {"50300", "11", },
    id_42 = {"50300", "12", },
    id_43 = {"50300", "13", },
    id_44 = {"50300", "14", },
    id_45 = {"50300", "15", },
    id_46 = {"50400", "1", },
    id_47 = {"50400", "2", },
    id_48 = {"50400", "3", },
    id_49 = {"50400", "4", },
    id_50 = {"50400", "5", },
    id_51 = {"50400", "6", },
    id_52 = {"50400", "7", },
    id_53 = {"50400", "8", },
    id_54 = {"50400", "9", },
    id_55 = {"50400", "10", },
    id_56 = {"50400", "11", },
    id_57 = {"50400", "12", },
    id_58 = {"50400", "13", },
    id_59 = {"50400", "14", },
    id_60 = {"50400", "15", },
    id_61 = {"50500", "1", },
    id_62 = {"50500", "2", },
    id_63 = {"50500", "3", },
    id_64 = {"50500", "4", },
    id_65 = {"50500", "5", },
    id_66 = {"50500", "6", },
    id_67 = {"50500", "7", },
    id_68 = {"50500", "8", },
    id_69 = {"50500", "9", },
    id_70 = {"50500", "10", },
    id_71 = {"50500", "11", },
    id_72 = {"50500", "12", },
    id_73 = {"50500", "13", },
    id_74 = {"50500", "14", },
    id_75 = {"50500", "15", },
    id_76 = {"50600", "1", },
    id_77 = {"50600", "2", },
    id_78 = {"50600", "3", },
    id_79 = {"50600", "4", },
    id_80 = {"50600", "5", },
    id_81 = {"50600", "6", },
    id_82 = {"50600", "7", },
    id_83 = {"50600", "8", },
    id_84 = {"50600", "9", },
    id_85 = {"50600", "10", },
    id_86 = {"50600", "11", },
    id_87 = {"50600", "12", },
    id_88 = {"50600", "13", },
    id_89 = {"50600", "14", },
    id_90 = {"50600", "15", },
    id_91 = {"50700", "1", },
    id_92 = {"50700", "2", },
    id_93 = {"50700", "3", },
    id_94 = {"50700", "4", },
    id_95 = {"50700", "5", },
    id_96 = {"50700", "6", },
    id_97 = {"50700", "7", },
    id_98 = {"50700", "8", },
    id_99 = {"50700", "9", },
    id_100 = {"50700", "10", },
}


function getDataById(key_id)
    local id_data = pata_copyTable["id_" .. key_id]
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

    for k, v in pairs(pata_copyTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return pata_copyTable
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

    for k, v in pairs(pata_copyTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["pata_copy"] = nil
    package.loaded["pata_copy"] = nil
end
