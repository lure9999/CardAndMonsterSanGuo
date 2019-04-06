-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("nor_copy", package.seeall)


keys = {
	"﻿index", "type", "map", "scene_id", "point_res1", "point_res2", "point_res3", "point_res4", "point_res5", "point_res6", "point_res7", "point_res8", "point_res9", "point_res10", "point_res11", "point_res12", "point_res13", "point_res14", "point_res15", "point_pos1", "point_pos2", "point_pos3", "point_pos4", "point_pos5", "point_pos6", "point_pos7", "point_pos8", "point_pos9", "point_pos10", "point_pos11", "point_pos12", "point_pos13", "point_pos14", "point_pos15", 
}

nor_copyTable = {
    id_1 = {"1", "Image/imgres/dungeon/map_1.png", "10100", "1", "1", "2", "1", "2", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "259|194", "454|345", "717|381", "916|150", "928|394", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_2 = {"1", "Image/imgres/dungeon/map_5.png", "10200", "1", "1", "2", "1", "1", "2", "2", "0", "0", "0", "0", "0", "0", "0", "0", "245|182", "284|336", "435|454", "626|480", "820|443", "648|304", "890|209", nil, nil, nil, nil, nil, nil, nil, nil, },
    id_3 = {"1", "Image/imgres/dungeon/map_2.png", "10300", "1", "1", "2", "1", "1", "2", "1", "1", "2", "0", "0", "0", "0", "0", "0", "204|208", "236|338", "302|438", "438|362", "541|238", "727|233", "881|293", "867|446", "692|451", nil, nil, nil, nil, nil, nil, },
    id_4 = {"1", "Image/imgres/dungeon/map_6.png", "10400", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "2", "0", "0", "0", "0", "235|224", "255|331", "370|390", "470|330", "487|220", "641|209", "780|257", "683|351", "602|441", "760|433", "897|422", nil, nil, nil, nil, },
    id_5 = {"1", "Image/imgres/dungeon/map_7.png", "10500", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "2", "0", "0", "320|393", "227|313", "294|210", "417|225", "494|292", "595|247", "706|222", "788|268", "886|308", "880|448", "775|451", "651|453", "527|487", nil, nil, },
    id_6 = {"1", "Image/imgres/dungeon/map_3.png", "10600", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "229|409", "245|320", "296|227", "382|197", "498|201", "575|272", "530|374", "544|450", "634|488", "754|476", "820|421", "762|300", "771|232", "855|206", "937|263", },
    id_7 = {"1", "Image/imgres/dungeon/map_4.png", "10700", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "269|386", "321|280", "398|227", "504|217", "615|213", "723|215", "814|232", "854|305", "725|365", "634|371", "559|409", "654|474", "747|474", "827|461", "949|456", },
    id_8 = {"1", "Image/imgres/dungeon/map_5.png", "10800", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "194|150", "278|206", "377|254", "286|331", "388|450", "474|466", "574|476", "701|490", "834|472", "777|420", "708|390", "618|339", "694|285", "781|244", "905|221", },
    id_9 = {"1", "Image/imgres/dungeon/map_6.png", "10900", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "231|234", "255|317", "346|398", "470|378", "456|309", "521|217", "618|205", "712|218", "789|261", "718|347", "654|386", "611|439", "705|461", "791|421", "912|433", },
    id_10 = {"1", "Image/imgres/dungeon/map_7.png", "11000", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "306|398", "235|291", "259|208", "368|203", "441|236", "525|285", "616|241", "693|210", "774|258", "863|327", "904|379", "872|446", "732|445", "644|462", "543|478", },
    id_11 = {"1", "Image/imgres/dungeon/map_8.png", "11100", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "140|150", "230|180", "300|220", "366|320", "331|405", "405|438", "497|434", "592|438", "702|409", "685|346", "623|297", "695|236", "784|247", "857|282", "912|338", },
    id_12 = {"1", "Image/imgres/dungeon/map_9.png", "11200", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "235|192", "224|254", "328|283", "404|331", "454|384", "522|423", "625|419", "725|434", "829|409", "873|364", "878|296", "893|133", "795|189", "712|210", "623|236", },
    id_13 = {"1", "Image/imgres/dungeon/map_10.png", "11300", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "255|403", "226|287", "304|210", "337|302", "414|417", "540|468", "565|379", "478|300", "490|188", "600|240", "722|263", "844|198", "935|250", "860|338", "895|430", },
    id_14 = {"1", "Image/imgres/dungeon/map_11.png", "11400", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "210|416", "290|391", "376|345", "320|274", "397|224", "508|202", "605|234", "695|198", "809|170", "915|185", "928|293", "855|304", "775|362", "838|424", "934|450", },
    id_15 = {"1", "Image/imgres/dungeon/map_12.png", "11500", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "223|181", "299|246", "243|329", "292|413", "392|395", "472|435", "572|480", "624|400", "673|315", "758|279", "807|207", "913|182", "919|286", "856|370", "928|440", },
    id_16 = {"1", "Image/imgres/dungeon/map_13.png", "11600", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "228|163", "272|237", "242|372", "297|394", "379|420", "489|444", "472|361", "505|290", "595|225", "709|200", "817|186", "888|241", "922|362", "854|421", "915|466", },
    id_17 = {"1", "Image/imgres/dungeon/map_14.png", "11700", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "1", "1", "2", "226|152", "333|177", "463|180", "504|270", "392|294", "400|384", "511|431", "636|453", "667|352", "722|271", "770|190", "825|239", "872|342", "905|412", "915|480", },
}


function getDataById(key_id)
    local id_data = nor_copyTable["id_" .. key_id]
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

    for k, v in pairs(nor_copyTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return nor_copyTable
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

    for k, v in pairs(nor_copyTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["nor_copy"] = nil
    package.loaded["nor_copy"] = nil
end
