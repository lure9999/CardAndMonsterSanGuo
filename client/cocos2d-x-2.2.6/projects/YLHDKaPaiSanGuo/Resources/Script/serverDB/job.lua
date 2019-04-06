-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("job", package.seeall)


keys = {
	"﻿GeneralID", "Gender", "Job", "JobImgID", "JopName", "JopDes", "UesrLv", "JobCon", "NextGeneralID", "ZhuanJImgID_1", "ZhuanJImgID_2", "ZhuanJImgID_3", "ZhuanJImgID_4", "ZhuanJAttID_1", "ZhuanJAttID_2", "ZhuanJAttID_3", "ZhuanJAttID_4", "ZhuanJCon_1", "ZhuanJCon_2", "ZhuanJCon_3", "ZhuanJCon_4", "ZhuanJLv_1", "ZhuanJLv_2", "ZhuanJLv_3", "ZhuanJLv_4", 
}

jobTable = {
    id_80011 = {"1", "1", "50", "战士", "前排，防御型职业", "0", "900", "80012", "51", "52", "53", "54", "3011", "3012", "3013", "3014", "941", "942", "943", "944", "39", "39", "39", "39", },
    id_80021 = {"1", "2", "55", "谋士", "后排，法术型职业", "20", "903", "80032", "56", "57", "58", "59", "3021", "3022", "3023", "3024", "945", "946", "947", "948", "39", "39", "39", "39", },
    id_80031 = {"1", "3", "60", "弓手", "中排，物理型职业", "20", "906", "80042", "61", "62", "63", "64", "3031", "3032", "3033", "3034", "949", "950", "951", "952", "39", "39", "39", "39", },
    id_80012 = {"1", "1", "50", "猛将", "前排，防御型职业", "40", "901", "80013", "51", "52", "53", "54", "3011", "3012", "3013", "3014", "941", "942", "943", "944", "69", "69", "69", "69", },
    id_80032 = {"1", "2", "55", "策士", "后排，法术型职业", "40", "904", "80043", "56", "57", "58", "59", "3021", "3022", "3023", "3024", "945", "946", "947", "948", "69", "69", "69", "69", },
    id_80042 = {"1", "3", "60", "飞羽", "中排，物理型职业", "40", "907", "80053", "61", "62", "63", "64", "3031", "3032", "3033", "3034", "949", "950", "951", "952", "69", "69", "69", "69", },
    id_80013 = {"1", "1", "50", "霸者", "前排，防御型职业", "70", "902", "-1", "51", "52", "53", "54", "3011", "3012", "3013", "3014", "941", "942", "943", "944", "99", "99", "99", "99", },
    id_80043 = {"1", "2", "55", "天师", "后排，法术型职业", "70", "905", "-1", "56", "57", "58", "59", "3021", "3022", "3023", "3024", "945", "946", "947", "948", "99", "99", "99", "99", },
    id_80053 = {"1", "3", "60", "翎羽", "中排，物理型职业", "70", "908", "-1", "61", "62", "63", "64", "3031", "3032", "3033", "3034", "949", "950", "951", "952", "99", "99", "99", "99", },
    id_81011 = {"2", "1", "50", "战士", "前排，防御型职业", "0", "900", "81012", "51", "52", "53", "54", "3011", "3012", "3013", "3014", "941", "942", "943", "944", "39", "39", "39", "39", },
    id_81021 = {"2", "2", "55", "谋士", "后排，法术型职业", "20", "903", "81032", "56", "57", "58", "59", "3021", "3022", "3023", "3024", "945", "946", "947", "948", "39", "39", "39", "39", },
    id_81031 = {"2", "3", "60", "弓手", "中排，物理型职业", "20", "906", "81042", "61", "62", "63", "64", "3031", "3032", "3033", "3034", "949", "950", "951", "952", "39", "39", "39", "39", },
    id_81012 = {"2", "1", "50", "猛将", "前排，防御型职业", "40", "901", "81013", "51", "52", "53", "54", "3011", "3012", "3013", "3014", "941", "942", "943", "944", "69", "69", "69", "69", },
    id_81032 = {"2", "2", "55", "策士", "后排，法术型职业", "40", "904", "81043", "56", "57", "58", "59", "3021", "3022", "3023", "3024", "945", "946", "947", "948", "69", "69", "69", "69", },
    id_81042 = {"2", "3", "60", "飞羽", "中排，物理型职业", "40", "907", "81053", "61", "62", "63", "64", "3031", "3032", "3033", "3034", "949", "950", "951", "952", "69", "69", "69", "69", },
    id_81013 = {"2", "1", "50", "霸者", "前排，防御型职业", "70", "902", "-1", "51", "52", "53", "54", "3011", "3012", "3013", "3014", "941", "942", "943", "944", "99", "99", "99", "99", },
    id_81043 = {"2", "2", "55", "天师", "后排，法术型职业", "70", "905", "-1", "56", "57", "58", "59", "3021", "3022", "3023", "3024", "945", "946", "947", "948", "99", "99", "99", "99", },
    id_81053 = {"2", "3", "60", "翎羽", "中排，物理型职业", "70", "908", "-1", "61", "62", "63", "64", "3031", "3032", "3033", "3034", "949", "950", "951", "952", "99", "99", "99", "99", },
}


function getDataById(key_id)
    local id_data = jobTable["id_" .. key_id]
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

    for k, v in pairs(jobTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return jobTable
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

    for k, v in pairs(jobTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["job"] = nil
    package.loaded["job"] = nil
end
