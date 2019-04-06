-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("globedefine", package.seeall)


keys = {
	"﻿GlobeDefine", "Para_1", "Para_2", "Para_3", "Para_4", "Para_5", "Para_6", 
}

globedefineTable = {
    id_LingBaoLv = {"60", "65", "70", "75", "80", "85", },
    id_GeneralLv = {"0", "0", "0", "9", "14", "5", },
    id_InitialUser = {"1", "-1", "-1", "-1", "-1", "-1", },
    id_UserGrowUp = {"100", "20", "10", "10", "10", "-1", },
    id_InitialJob = {"1", "600", "30", "3", "0", "-1", },
    id_InitialHeadportrait = {"141", "142", "143", "144", "145", "146", },
    id_InitialMail = {"2", "-1", "-1", "-1", "-1", "-1", },
    id_BoxMail = {"1", "-1", "-1", "-1", "-1", "-1", },
    id_RefreshTime = {"405", "1205", "-1", "-1", "-1", "-1", },
    id_JingYingTimes = {"10", "-1", "-1", "-1", "-1", "-1", },
    id_HuoDongTimes = {"10", "19", "20", "21", "22", "-1", },
    id_WarLostReward = {"50", "7", "-1", "-1", "-1", "-1", },
    id_WarLastReward = {"6", "-1", "-1", "-1", "-1", "-1", },
    id_BiWu = {"1000", "2000", "9", "10", "10", "60", },
    id_Plunder = {"6", "100", "1", "50", "20900", "15", },
    id_PaTa = {"1", "20", "4", "8", "-1", "-1", },
    id_PaTaAtt1 = {"10", "100", "-1", "-1", "-1", "-1", },
    id_PaTaAtt2 = {"10", "100", "-1", "-1", "-1", "-1", },
    id_PaTaAtt3 = {"690", "-1", "-1", "-1", "-1", "-1", },
    id_WordChatCons = {"50", "230", "-1", "-1", "-1", "-1", },
    id_SilverPub = {"5", "24", "785", "-1", "-1", "-1", },
    id_GoldPub = {"1", "24", "786", "-1", "-1", "-1", },
    id_RenameCons = {"50", "-1", "-1", "-1", "-1", "-1", },
    id_CorpsCamp = {"10", "2", "500", "1200", "2", "500", },
    id_Technology = {"10", "231", "-1", "-1", "-1", "-1", },
    id_Legio_ShenShu = {"1", "1", "1", "242", "20", "-1", },
    id_Legio_ChenYuan = {"2", "1", "1", "-1", "-1", "-1", },
    id_Legio_GuanYuan = {"3", "1", "1", "-1", "-1", "-1", },
    id_Legio_ShiTang = {"4", "1", "1", "1230", "1830", "-1", },
    id_Legio_JuanXian = {"5", "1", "1", "10", "405", "-1", },
    id_Legio_ShangDian = {"6", "1", "1", "-1", "-1", "-1", },
    id_Legio_YongBing = {"7", "1", "1", "9", "103", "-1", },
    id_Legio_LingShou = {"8", "1", "1", "-1", "-1", "-1", },
    id_Legio_RenWu = {"9", "1", "1", "-1", "-1", "-1", },
    id_Legio_LaoFang = {"10", "1", "1", "-1", "-1", "-1", },
    id_Legio_ChangKu = {"11", "0", "1", "-1", "-1", "-1", },
    id_Legio_ZhanYi = {"12", "0", "1", "-1", "-1", "-1", },
    id_AllianceState = {"103", "141", "-1", "-1", "-1", "-1", },
    id_WeiCapital = {"34", "37", "-1", "-1", "-1", "-1", },
    id_ShuCapital = {"100", "103", "-1", "-1", "-1", "-1", },
    id_WuCapital = {"190", "188", "-1", "-1", "-1", "-1", },
    id_CityShow = {"10", "180", "-1", "-1", "-1", "-1", },
    id_Mercenary = {"3", "10", "25", "35", "-1", "-1", },
    id_CorpsHP = {"100", "10", "100", "600", "232", "-1", },
    id_WarLock = {"2", "-1", "-1", "-1", "-1", "-1", },
    id_WarTujin = {"2", "-1", "-1", "-1", "-1", "-1", },
    id_WarChetui = {"2", "20", "-1", "-1", "-1", "-1", },
    id_WarDantiao = {"3", "10", "-1", "-1", "-1", "-1", },
    id_WarFenshen = {"0", "11", "-1", "-1", "-1", "-1", },
    id_WarQianggong = {"50", "12", "4", "0", "0", "-1", },
    id_WarShuailing = {"2", "13", "5", "0", "0", "-1", },
    id_ShenShuArt = {"20", "40", "60", "80", "100", "-1", },
    id_daliyboxjiangliID = {"101", "102", "103", "104", "-1", "-1", },
    id_daliyboxjifen1 = {"10", "30", "50", "70", "-1", "-1", },
    id_daliyboxjifen2 = {"20", "40", "60", "80", "-1", "-1", },
    id_daliyboxjifen3 = {"40", "60", "80", "100", "-1", "-1", },
    id_Mercenary_Hire = {"1000", "1000", "1000", "900", "-1", "-1", },
    id_Mercenary_Renew = {"900", "1000", "1000", "1000", "10", "-1", },
    id_SignIn = {"3", "3", "-1", "-1", "-1", "-1", },
    id_RoleDesc = {"15", "16", "-1", "-1", "-1", "-1", },
    id_LegioTask = {"3", "104", "4", "20", "-1", "-1", },
    id_Prison = {"300", "800", "600", "236", "237", "14", },
    id_PrisonRandom = {"500", "50", "20", "50", "20", "-1", },
    id_PrisonTimes = {"1000", "3", "1", "5", "1", "-1", },
    id_PrisonDouble = {"5", "1", "-1", "-1", "-1", "-1", },
    id_PrisonBox = {"1001", "-1", "-1", "-1", "-1", "-1", },
    id_InitialShop = {"1", "2", "-1", "-1", "-1", "-1", },
    id_EngineHurtA = {"1000", "2500", "5000", "-1", "-1", "-1", },
    id_monthcard = {"30", "10", "-1", "-1", "-1", "-1", },
}


function getDataById(key_id)
    local id_data = globedefineTable["id_" .. key_id]
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

    for k, v in pairs(globedefineTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return globedefineTable
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

    for k, v in pairs(globedefineTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["globedefine"] = nil
    package.loaded["globedefine"] = nil
end
