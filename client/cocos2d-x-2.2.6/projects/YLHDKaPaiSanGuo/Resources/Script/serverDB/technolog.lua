-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("technolog", package.seeall)


keys = {
	"﻿Index", "TechnologyID", "TechLv", "ResimgID", "TechName", "TechDes", "UpConditionID", "UpConsumeID", "ConsumeNum", "ResearchTime", "TechEffID1", "TechEffID2", "TechEffID3", "TechEffID4", 
}

technologTable = {
    id_1 = {"1", "1", "10201", "大本营Lv1", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "0", "700", "1", "300", "10001", "0", "0", "0", },
    id_2 = {"1", "2", "10201", "大本营Lv2", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "401", "700", "2", "600", "10002", "0", "0", "0", },
    id_3 = {"1", "3", "10201", "大本营Lv3", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "402", "700", "3", "900", "10003", "0", "0", "0", },
    id_4 = {"1", "4", "10201", "大本营Lv4", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "403", "700", "4", "1200", "10004", "0", "0", "0", },
    id_5 = {"1", "5", "10201", "大本营Lv5", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "404", "700", "5", "1500", "10005", "0", "0", "0", },
    id_6 = {"1", "6", "10201", "大本营Lv6", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "405", "700", "6", "1800", "10006", "0", "0", "0", },
    id_7 = {"1", "7", "10201", "大本营Lv7", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "406", "700", "7", "2100", "10007", "0", "0", "0", },
    id_8 = {"1", "8", "10201", "大本营Lv8", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "407", "700", "8", "2400", "10008", "0", "0", "0", },
    id_9 = {"1", "9", "10201", "大本营Lv9", "军团的核心科技，是升级其他军团科技的前提，升级后玩家可以在军团神树处领取更多奖励", "408", "700", "9", "2700", "10009", "0", "0", "0", },
    id_10 = {"1", "10", "10201", "大本营Lv10", "军团的核心科技，是升级其他军团科技的前提", "409", "700", "10", "0", "10010", "0", "0", "0", },
    id_11 = {"2", "1", "10202", "成员上限Lv1", "军团成员最多可容纳20人，升级该科技后扩充为40人", "401", "701", "3", "3600", "11001", "0", "0", "0", },
    id_12 = {"2", "2", "10202", "成员上限Lv2", "军团成员最多可容纳40人，升级该科技后扩充为60人", "405", "701", "6", "7200", "11002", "0", "0", "0", },
    id_13 = {"2", "3", "10202", "成员上限Lv3", "军团成员最多可容纳60人，升级该科技后扩充为80人", "409", "701", "9", "10800", "11003", "0", "0", "0", },
    id_14 = {"2", "4", "10202", "成员上限Lv4", "军团成员最多可容纳80人", "0", "701", "0", "0", "11004", "0", "0", "0", },
    id_15 = {"3", "1", "10203", "官员上限Lv1", "升级科技后，军团中圣女数量和护法数量都提升到1名", "401", "701", "3", "3600", "0", "0", "0", "0", },
    id_16 = {"3", "2", "10203", "官员上限Lv2", "当前军团中圣女和护法数量都是1名，升级科技后，圣女和护法数量都提升到2名", "405", "701", "6", "7200", "12001", "12101", "0", "0", },
    id_17 = {"3", "3", "10203", "官员上限Lv3", "当前军团中圣女和护法数量都是2名，升级科技后，圣女和护法数量都提升到3名", "409", "701", "9", "10800", "12002", "12102", "0", "0", },
    id_18 = {"3", "4", "10203", "官员上限Lv4", "当前军团中圣女和护法数量都是3名", "0", "701", "0", "0", "12003", "12103", "0", "0", },
    id_19 = {"4", "1", "10204", "军团食堂Lv1", "每日可以在食堂中从饭桌、单间、雅座中选取一个领取两次少量体力", "401", "701", "3", "3600", "13001", "0", "0", "0", },
    id_20 = {"4", "2", "10204", "军团食堂Lv2", "每日可以在食堂中从饭桌、单间、雅座中选取一个领取两次中量体力", "405", "701", "6", "7200", "13002", "0", "0", "0", },
    id_21 = {"4", "3", "10204", "军团食堂Lv3", "每日可以在食堂中从饭桌、单间、雅座中选取一个领取两次大量体力", "409", "701", "9", "10800", "13003", "0", "0", "0", },
    id_22 = {"4", "4", "10204", "军团食堂Lv4", "每日可以在食堂中从饭桌、单间、雅座中选取一个领取两次巨量体力", "0", "701", "0", "0", "13004", "0", "0", "0", },
    id_23 = {"5", "1", "10205", "军团慈善Lv1", "每日可以在捐献中进行10次捐献，换取少量军团声望和军团银币", "401", "701", "3", "3600", "14001", "0", "0", "0", },
    id_24 = {"5", "2", "10205", "军团慈善Lv2", "每日可以在捐献中进行10次捐献，换取中量军团声望和军团银币", "405", "701", "6", "7200", "14002", "0", "0", "0", },
    id_25 = {"5", "3", "10205", "军团慈善Lv3", "每日可以在捐献中进行10次捐献，换取大量军团声望和军团银币", "409", "701", "9", "10800", "14003", "0", "0", "0", },
    id_26 = {"5", "4", "10205", "军团慈善Lv4", "每日可以在捐献中进行10次捐献，换取巨量军团声望和军团银币", "0", "701", "0", "0", "14004", "0", "0", "0", },
    id_27 = {"6", "1", "10206", "军团商店Lv1", "军团成员在家族商店中可以花费军团贡献购买稀有道具，科技升级后商店中将出现更为稀有的道具", "401", "702", "3", "7200", "15001", "0", "0", "0", },
    id_28 = {"6", "2", "10206", "军团商店Lv2", "军团成员在家族商店中可以花费军团贡献购买稀有道具，科技升级后商店中将出现更为稀有的道具", "405", "702", "6", "14400", "15002", "0", "0", "0", },
    id_29 = {"6", "3", "10206", "军团商店Lv3", "军团成员在家族商店中可以花费军团贡献购买稀有道具，科技升级后商店中将出现更为稀有的道具", "409", "702", "9", "21600", "15003", "0", "0", "0", },
    id_30 = {"6", "4", "10206", "军团商店Lv4", "军团成员在家族商店中可以花费军团贡献购买稀有道具", "0", "702", "0", "0", "15004", "0", "0", "0", },
    id_31 = {"7", "1", "10207", "军团佣兵Lv1", "军团成员可在兵营中雇佣能力较弱的佣兵，科技升级后佣兵能力提升", "401", "702", "3", "7200", "16001", "0", "0", "0", },
    id_32 = {"7", "2", "10207", "军团佣兵Lv2", "军团成员可在兵营中雇佣能力稍强的佣兵，科技升级后佣兵能力提升", "405", "702", "6", "14400", "16002", "0", "0", "0", },
    id_33 = {"7", "3", "10207", "军团佣兵Lv3", "军团成员可在兵营中雇佣能力强大的佣兵，科技升级后佣兵能力提升", "409", "702", "9", "21600", "16003", "0", "0", "0", },
    id_34 = {"7", "4", "10207", "军团佣兵Lv4", "军团成员可在兵营中雇佣能力最强的佣兵", "0", "702", "0", "0", "16004", "0", "0", "0", },
    id_35 = {"8", "1", "10208", "军团灵兽Lv1", "军团成员进贡灵兽可以获得较弱的灵兽赐福，科技升级后灵兽赐福增强", "401", "702", "3", "7200", "0", "0", "0", "0", },
    id_36 = {"8", "2", "10208", "军团灵兽Lv2", "军团成员进贡灵兽可以获得稍强的灵兽赐福，科技升级后灵兽赐福增强", "405", "702", "6", "14400", "0", "0", "0", "0", },
    id_37 = {"8", "3", "10208", "军团灵兽Lv3", "军团成员进贡灵兽可以获得较强的灵兽赐福，科技升级后灵兽赐福增强", "409", "702", "9", "21600", "0", "0", "0", "0", },
    id_38 = {"8", "4", "10208", "军团灵兽Lv4", "军团成员进贡灵兽可以获得最强的灵兽赐福", "0", "702", "0", "0", "0", "0", "0", "0", },
    id_39 = {"9", "1", "10210", "军团任务Lv1", "军团会发布较低难度的军团任务，相应奖励也会较低", "401", "702", "3", "7200", "0", "0", "0", "0", },
    id_40 = {"9", "2", "10210", "军团任务Lv2", "军团会发布稍高难度的军团任务，相应奖励也会适当提升", "405", "702", "6", "14400", "0", "0", "0", "0", },
    id_41 = {"9", "3", "10210", "军团任务Lv3", "军团会发布较高难度的军团任务，相应奖励也会适当提升", "409", "702", "9", "21600", "0", "0", "0", "0", },
    id_42 = {"9", "4", "10210", "军团任务Lv4", "军团会发布很高难度的军团任务，相应奖励也会大幅提升", "0", "702", "0", "0", "0", "0", "0", "0", },
    id_43 = {"10", "1", "10209", "军团牢房Lv1", "牢房科技，升级到2级后，可多解锁一个牢房，每日可领取更多抓捕奖励", "401", "702", "3", "7200", "0", "0", "0", "0", },
    id_44 = {"10", "2", "10209", "军团牢房Lv2", "牢房科技，升级到3级后，可多解锁一个牢房，每日可领取更多抓捕奖励", "404", "702", "6", "14400", "0", "0", "0", "0", },
    id_45 = {"10", "3", "10209", "军团牢房Lv3", "牢房科技，升级到4级后，可多解锁一个牢房，每日可领取更多抓捕奖励", "406", "702", "9", "21600", "0", "0", "0", "0", },
    id_46 = {"10", "4", "10209", "军团牢房Lv4", "牢房科技，升级到5级后，可多解锁一个牢房，每日可领取更多抓捕奖励", "409", "702", "12", "28800", "0", "0", "0", "0", },
    id_47 = {"10", "5", "10209", "军团牢房Lv5", "牢房科技，已解锁全部军团科技对应的牢房", "0", "702", "0", "0", "0", "0", "0", "0", },
    id_48 = {"20", "1", "50", "初级食堂Lv1", "与家族食堂同步升级", "0", "0", "0", "0", "23001", "0", "0", "0", },
    id_49 = {"20", "2", "50", "初级食堂Lv2", "与家族食堂同步升级", "0", "0", "0", "0", "23002", "0", "0", "0", },
    id_50 = {"20", "3", "50", "初级食堂Lv3", "与家族食堂同步升级", "0", "0", "0", "0", "23003", "0", "0", "0", },
    id_51 = {"20", "4", "50", "初级食堂Lv4", "与家族食堂同步升级", "0", "0", "0", "0", "23004", "0", "0", "0", },
    id_52 = {"21", "1", "50", "中级食堂Lv1", "与家族食堂同步升级", "0", "0", "0", "0", "24001", "0", "0", "0", },
    id_53 = {"21", "2", "50", "中级食堂Lv2", "与家族食堂同步升级", "0", "0", "0", "0", "24002", "0", "0", "0", },
    id_54 = {"21", "3", "50", "中级食堂Lv3", "与家族食堂同步升级", "0", "0", "0", "0", "24003", "0", "0", "0", },
    id_55 = {"21", "4", "50", "中级食堂Lv4", "与家族食堂同步升级", "0", "0", "0", "0", "24004", "0", "0", "0", },
    id_56 = {"22", "1", "50", "高级食堂Lv1", "与家族食堂同步升级", "0", "0", "0", "0", "25001", "0", "0", "0", },
    id_57 = {"22", "2", "50", "高级食堂Lv2", "与家族食堂同步升级", "0", "0", "0", "0", "25002", "0", "0", "0", },
    id_58 = {"22", "3", "50", "高级食堂Lv3", "与家族食堂同步升级", "0", "0", "0", "0", "25003", "0", "0", "0", },
    id_59 = {"22", "4", "50", "高级食堂Lv4", "与家族食堂同步升级", "0", "0", "0", "0", "25004", "0", "0", "0", },
    id_60 = {"23", "1", "50", "初级慈善Lv1", "与家族慈善同步升级", "0", "0", "0", "0", "20001", "0", "0", "0", },
    id_61 = {"23", "2", "50", "初级慈善Lv2", "与家族慈善同步升级", "0", "0", "0", "0", "20002", "0", "0", "0", },
    id_62 = {"23", "3", "50", "初级慈善Lv3", "与家族慈善同步升级", "0", "0", "0", "0", "20003", "0", "0", "0", },
    id_63 = {"23", "4", "50", "初级慈善Lv4", "与家族慈善同步升级", "0", "0", "0", "0", "20004", "0", "0", "0", },
    id_64 = {"24", "1", "50", "中级慈善Lv1", "与家族慈善同步升级", "0", "0", "0", "0", "21001", "0", "0", "0", },
    id_65 = {"24", "2", "50", "中级慈善Lv2", "与家族慈善同步升级", "0", "0", "0", "0", "21002", "0", "0", "0", },
    id_66 = {"24", "3", "50", "中级慈善Lv3", "与家族慈善同步升级", "0", "0", "0", "0", "21003", "0", "0", "0", },
    id_67 = {"24", "4", "50", "中级慈善Lv4", "与家族慈善同步升级", "0", "0", "0", "0", "21004", "0", "0", "0", },
    id_68 = {"25", "1", "50", "高级慈善Lv1", "与家族慈善同步升级", "0", "0", "0", "0", "22001", "0", "0", "0", },
    id_69 = {"25", "2", "50", "高级慈善Lv2", "与家族慈善同步升级", "0", "0", "0", "0", "22002", "0", "0", "0", },
    id_70 = {"25", "3", "50", "高级慈善Lv3", "与家族慈善同步升级", "0", "0", "0", "0", "22003", "0", "0", "0", },
    id_71 = {"25", "4", "50", "高级慈善Lv4", "与家族慈善同步升级", "0", "0", "0", "0", "22004", "0", "0", "0", },
}


function getDataById(key_id)
    local id_data = technologTable["id_" .. key_id]
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

    for k, v in pairs(technologTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return technologTable
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

    for k, v in pairs(technologTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["technolog"] = nil
    package.loaded["technolog"] = nil
end
