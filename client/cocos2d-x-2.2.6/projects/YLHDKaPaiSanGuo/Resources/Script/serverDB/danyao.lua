-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("danyao", package.seeall)


keys = {
	"﻿JinDanLv", "JDanName", "JDanResID", "Dan1ItemID", "Dan2ItemID", "Dan3ItemID", "Dan4ItemID", "Dan5ItemID", "Dan6ItemID", "Dan7ItemID", "Dan8ItemID", "Dan9ItemID", "JDanDes", "JDanAttributID-1", "JDanAttributID-2", "JDanAttributID-3", "JDanAttributID-4", "Dan1ConsumeID", "Dan2ConsumeID", "Dan3ConsumeID", "Dan4ConsumeID", "Dan5ConsumeID", "Dan6ConsumeID", "Dan7ConsumeID", "Dan8ConsumeID", "Dan9ConsumeID", "Dan1Lv", "Dan2Lv", "Dan3Lv", "Dan4Lv", "Dan5Lv", "Dan6Lv", "Dan7Lv", "Dan8Lv", "Dan9Lv", "Dan1AttributID", "Dan2AttributID", "Dan3AttributID", "Dan4AttributID", "Dan5AttributID", "Dan6AttributID", "Dan7AttributID", "Dan8AttributID", "Dan9AttributID", 
}

danyaoTable = {
    id_1 = {"凝神成丹", "30", "301", "302", "303", "304", "305", "306", "307", "308", "309", "欲成金丹，先炼黄芽", "0", "0", "0", "0", "301", "302", "303", "304", "305", "306", "307", "308", "309", "9", "10", "11", "12", "13", "14", "15", "16", "17", "5001", "5002", "5003", "5004", "5001", "5003", "5004", "5001", "5002", },
    id_2 = {"金丹壹转", "31", "311", "312", "313", "314", "315", "316", "317", "318", "319", "金丹壹转，辟谷为先", "4011", "4012", "4013", "4014", "311", "312", "313", "314", "315", "316", "317", "318", "319", "16", "17", "18", "19", "20", "21", "22", "23", "24", "5011", "5012", "5013", "5014", "5011", "5013", "5014", "5011", "5012", },
    id_3 = {"金丹贰转", "32", "321", "322", "323", "324", "325", "326", "327", "328", "329", "金丹贰转，固本培元", "4021", "4022", "4023", "4024", "321", "322", "323", "324", "325", "326", "327", "328", "329", "23", "24", "25", "26", "27", "28", "29", "30", "31", "5021", "5022", "5023", "5024", "5021", "5023", "5024", "5021", "5022", },
    id_4 = {"金丹叁转", "33", "331", "332", "333", "334", "335", "336", "337", "338", "339", "金丹叁转，筑基炼形", "4031", "4032", "4033", "4034", "331", "332", "333", "334", "335", "336", "337", "338", "339", "30", "31", "32", "33", "34", "35", "36", "37", "38", "5031", "5032", "5033", "5034", "5031", "5033", "5034", "5031", "5032", },
    id_5 = {"金丹肆转", "34", "341", "342", "343", "344", "345", "346", "347", "348", "349", "金丹肆转，洗髓脱胎", "4041", "4042", "4043", "4044", "341", "342", "343", "344", "345", "346", "347", "348", "349", "37", "38", "39", "40", "41", "42", "43", "44", "45", "5041", "5042", "5043", "5044", "5041", "5043", "5044", "5041", "5042", },
    id_6 = {"金丹伍转", "35", "351", "352", "353", "354", "355", "356", "357", "358", "359", "金丹伍转，真元凝神", "4051", "4052", "4053", "4054", "351", "352", "353", "354", "355", "356", "357", "358", "359", "44", "45", "46", "47", "48", "49", "50", "51", "52", "5051", "5052", "5053", "5054", "5051", "5053", "5054", "5051", "5052", },
    id_7 = {"金丹陆转", "36", "361", "362", "363", "364", "365", "366", "367", "368", "369", "金丹陆转，聚灵成魂", "4061", "4062", "4063", "4064", "361", "362", "363", "364", "365", "366", "367", "368", "369", "51", "52", "53", "54", "55", "56", "57", "58", "59", "5061", "5062", "5063", "5064", "5061", "5063", "5064", "5061", "5062", },
    id_8 = {"金丹柒转", "37", "371", "372", "373", "374", "375", "376", "377", "378", "379", "金丹柒转，婴儿出世", "4071", "4072", "4073", "4074", "371", "372", "373", "374", "375", "376", "377", "378", "379", "58", "59", "60", "61", "62", "63", "64", "65", "66", "5071", "5072", "5073", "5074", "5071", "5073", "5074", "5071", "5072", },
    id_9 = {"金丹捌转", "38", "381", "382", "383", "384", "385", "386", "387", "388", "389", "金丹捌转，涅槃重生", "4081", "4082", "4083", "4084", "381", "382", "383", "384", "385", "386", "387", "388", "389", "65", "66", "67", "68", "69", "70", "71", "72", "73", "5081", "5082", "5083", "5084", "5081", "5083", "5084", "5081", "5082", },
    id_10 = {"金丹玖转", "39", "391", "392", "393", "394", "395", "396", "397", "398", "399", "金丹玖转，长视久生", "4091", "4092", "4093", "4094", "391", "392", "393", "394", "395", "396", "397", "398", "399", "72", "73", "74", "75", "76", "77", "78", "79", "80", "5091", "5092", "5093", "5094", "5091", "5093", "5094", "5091", "5092", },
    id_11 = {"鸿蒙待诏", "40", "401", "402", "403", "404", "405", "406", "407", "408", "409", "鸿蒙待诏，世间法尽头", "4101", "4102", "4103", "4104", "401", "402", "403", "404", "405", "406", "407", "408", "409", "79", "80", "81", "82", "83", "84", "85", "86", "87", "5101", "5102", "5103", "5104", "5101", "5103", "5104", "5101", "5102", },
}


function getDataById(key_id)
    local id_data = danyaoTable["id_" .. key_id]
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

    for k, v in pairs(danyaoTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return danyaoTable
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

    for k, v in pairs(danyaoTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["danyao"] = nil
    package.loaded["danyao"] = nil
end
