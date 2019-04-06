-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("scence", package.seeall)


keys = {
	"﻿Index", "ID", "Name", "SceneType", "RuleID", "Count", "ID_1", "ID_2", "ID_3", "ID_4", "ID_5", "ID_6", "ID_7", "ID_8", "ID_9", "ID_10", "ID_11", "ID_12", "ID_13", "ID_14", "ID_15", 
}

scenceTable = {
    id_1 = {"10100", "【第1章】黄巾之乱", "1", "10100", "5", "10101", "10102", "10103", "10104", "10105", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_2 = {"10200", "【第2章】黄巾覆灭", "1", "10200", "7", "10201", "10202", "10203", "10204", "10205", "10206", "10207", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_3 = {"10300", "【第3章】虎牢关之战", "1", "10300", "9", "10301", "10302", "10303", "10304", "10305", "10306", "10307", "10308", "10309", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_4 = {"10400", "【第4章】大闹凤仪亭", "1", "10400", "11", "10401", "10402", "10403", "10404", "10405", "10406", "10407", "10408", "10409", "10410", "10411", "-1", "-1", "-1", "-1", },
    id_5 = {"10500", "【第5章】董卓讨伐战", "1", "10500", "13", "10501", "10502", "10503", "10504", "10505", "10506", "10507", "10508", "10509", "10510", "10511", "10512", "10513", "-1", "-1", },
    id_6 = {"10600", "【第6章】徐州攻防战", "1", "10600", "15", "10601", "10602", "10603", "10604", "10605", "10606", "10607", "10608", "10609", "10610", "10611", "10612", "10613", "10614", "10615", },
    id_7 = {"10700", "【第7章】许都争霸战", "1", "10700", "15", "10701", "10702", "10703", "10704", "10705", "10706", "10707", "10708", "10709", "10710", "10711", "10712", "10713", "10714", "10715", },
    id_8 = {"10800", "【第8章】水攻下邳", "1", "10800", "15", "10801", "10802", "10803", "10804", "10805", "10806", "10807", "10808", "10809", "10810", "10811", "10812", "10813", "10814", "10815", },
    id_9 = {"10900", "【第9章】青梅煮酒", "1", "10900", "15", "10901", "10902", "10903", "10904", "10905", "10906", "10907", "10908", "10909", "10910", "10911", "10912", "10913", "10914", "10915", },
    id_10 = {"11000", "【第10章】刘备脱困", "1", "11000", "15", "11001", "11002", "11003", "11004", "11005", "11006", "11007", "11008", "11009", "11010", "11011", "11012", "11013", "11014", "11015", },
    id_11 = {"11100", "【第11章】决战小沛", "1", "11100", "15", "11101", "11102", "11103", "11104", "11105", "11106", "11107", "11108", "11109", "11110", "11111", "11112", "11113", "11114", "11115", },
    id_12 = {"11200", "【第12章】白马围城", "1", "11200", "15", "11201", "11202", "11203", "11204", "11205", "11206", "11207", "11208", "11209", "11210", "11211", "11212", "11213", "11214", "11215", },
    id_13 = {"11300", "【第13章】过五关", "1", "11300", "15", "11301", "11302", "11303", "11304", "11305", "11306", "11307", "11308", "11309", "11310", "11311", "11312", "11313", "11314", "11315", },
    id_14 = {"11400", "【第14章】古城重聚", "1", "11400", "15", "11401", "11402", "11403", "11404", "11405", "11406", "11407", "11408", "11409", "11410", "11411", "11412", "11413", "11414", "11415", },
    id_15 = {"11500", "【第15章】小霸王孙策", "1", "11500", "15", "11501", "11502", "11503", "11504", "11505", "11506", "11507", "11508", "11509", "11510", "11511", "11512", "11513", "11514", "11515", },
    id_16 = {"11600", "【第16章】官渡之战上", "1", "11600", "15", "11601", "11602", "11603", "11604", "11605", "11606", "11607", "11608", "11609", "11610", "11611", "11612", "11613", "11614", "11615", },
    id_17 = {"11700", "【第17章】官渡之战下", "1", "11700", "15", "11701", "11702", "11703", "11704", "11705", "11706", "11707", "11708", "11709", "11710", "11711", "11712", "11713", "11714", "11715", },
    id_18 = {"20100", "精英战役", "2", "20100", "15", "20101", "20102", "20103", "20104", "20105", "20106", "20107", "20108", "20109", "20110", "20111", "20112", "20113", "20114", "20115", },
    id_19 = {"30100", "银币活动", "3", "30100", "8", "30101", "30102", "30103", "30104", "30105", "30106", "30107", "30108", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_20 = {"30200", "经验活动", "3", "30200", "8", "30201", "30202", "30203", "30204", "30205", "30206", "30207", "30208", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_21 = {"30300", "宝马活动", "3", "30300", "8", "30301", "30302", "30303", "30304", "30305", "30306", "30307", "30308", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_22 = {"30400", "神武活动", "3", "30400", "8", "30401", "30402", "30403", "30404", "30405", "30406", "30407", "30408", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_23 = {"50100", "通天宝塔", "5", "5", "15", "50101", "50102", "50103", "50104", "50105", "50106", "50107", "50108", "50109", "50110", "50111", "50112", "50113", "50114", "50115", },
    id_24 = {"50200", "通天宝塔", "5", "5", "15", "50201", "50202", "50203", "50204", "50205", "50206", "50207", "50208", "50209", "50210", "50211", "50212", "50213", "50214", "50215", },
    id_25 = {"50300", "通天宝塔", "5", "5", "15", "50301", "50302", "50303", "50304", "50305", "50306", "50307", "50308", "50309", "50310", "50311", "50312", "50313", "50314", "50315", },
    id_26 = {"50400", "通天宝塔", "5", "5", "15", "50401", "50402", "50403", "50404", "50405", "50406", "50407", "50408", "50409", "50410", "50411", "50412", "50413", "50414", "50415", },
    id_27 = {"50500", "通天宝塔", "5", "5", "15", "50501", "50502", "50503", "50504", "50505", "50506", "50507", "50508", "50509", "50510", "50511", "50512", "50513", "50514", "50515", },
    id_28 = {"50600", "通天宝塔", "5", "5", "15", "50601", "50602", "50603", "50604", "50605", "50606", "50607", "50608", "50609", "50610", "50611", "50612", "50613", "50614", "50615", },
    id_29 = {"50700", "通天宝塔", "5", "5", "10", "50701", "50702", "50703", "50704", "50705", "50706", "50707", "50708", "50709", "50710", "-1", "-1", "-1", "-1", "-1", },
    id_30 = {"51100", "云中层楼", "5", "5", "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_31 = {"51200", "云中层楼", "5", "5", "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_32 = {"51300", "云中层楼", "5", "5", "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_33 = {"51400", "云中层楼", "5", "5", "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_34 = {"51500", "云中层楼", "5", "5", "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_35 = {"51600", "云中层楼", "5", "5", "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_36 = {"51700", "云中层楼", "5", "5", "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_1000 = {"1000", "比武战斗", "4", "4", "1", "1001", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_2001 = {"2001", "攻城战-魏国", "4", "4", "1", "2002", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_2002 = {"2002", "攻城战-蜀国", "4", "4", "1", "2003", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_2003 = {"2003", "攻城战-吴国", "4", "4", "1", "2004", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
    id_3001 = {"3001", "攻城战-单挑", "4", "4", "1", "3002", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", },
}


function getDataById(key_id)
    local id_data = scenceTable["id_" .. key_id]
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

    for k, v in pairs(scenceTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return scenceTable
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

    for k, v in pairs(scenceTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["scence"] = nil
    package.loaded["scence"] = nil
end