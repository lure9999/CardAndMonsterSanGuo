-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("legion_monster", package.seeall)


keys = {
	"﻿Index", "MonsterID", "TechLv", "MonsterName", "IconID", "MonsterDesc", "ReputType", "ReputCost", "GoldExchange", "ContributeTimes", "MosterRewardID", "ReputExchange", "MosterEff1", "IncrementType1", "IncrementPara1", "MosterEff2", "IncrementType2", "IncrementPara2", "RepuDesc", "end", 
}

legion_monsterTable = {
    id_1 = {"1", "1", "青龙赐福Lv1", "201", "|color|100,49,24|出战队伍每拥有一层青龙赐福，队伍所有武|n|1||n|1|将会增加攻击穿透属性|color|1,255,253|100|color|100,49,24|点，属性叠加上|n|1||n|1|限|color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "1", "50", "10", "3", "2000", "5", "2", "1", "100", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|3|color|100,49,24|次", "0", },
    id_2 = {"1", "2", "青龙赐福Lv2", "201", "|color|100,49,24|出战队伍每拥有一层青龙赐福，队伍所有武|n|1||n|1|将会增加攻击穿透属性|color|1,255,253|150|color|100,49,24|点，属性叠加上|n|1||n|1|限|color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "1", "70", "10", "5", "2001", "5", "2", "1", "150", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|5|color|100,49,24|次", "0", },
    id_3 = {"1", "3", "青龙赐福Lv3", "201", "|color|100,49,24|出战队伍每拥有一层青龙赐福，队伍所有武|n|1||n|1|将会增加攻击穿透属性|color|1,255,253|200|color|100,49,24|点，属性叠加上|n|1||n|1|限|color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "1", "90", "10", "10", "2002", "5", "2", "1", "200", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|10|color|100,49,24|次", "0", },
    id_4 = {"1", "4", "青龙赐福Lv4", "201", "|color|100,49,24|出战队伍每拥有一层青龙赐福，队伍所有武|n|1||n|1|将会增加攻击穿透属性|color|1,255,253|250|color|100,49,24|点，属性叠加上|n|1||n|1|限|color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "1", "110", "10", "15", "2003", "5", "2", "1", "250", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|15|color|100,49,24|次", "0", },
    id_5 = {"2", "1", "白虎赐福Lv1", "201", "|color|100,49,24|给已经拥有青龙赐福的队伍施加白虎赐福，|n|1||n|1|会增加其青龙赐福的有效次数|color|1,255,253|5|color|100,49,24|次，当青龙|n|1||n|1|赐福的有效次数消耗至0后，青龙赐福增加|n|1||n|1|的攻击穿透属性将归零", "2", "50", "10", "3", "2010", "5", "2", "2", "5", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|3|color|100,49,24|次", "0", },
    id_6 = {"2", "2", "白虎赐福Lv2", "201", "|color|100,49,24|给已经拥有青龙赐福的队伍施加白虎赐福，|n|1||n|1|会增加其青龙赐福的有效次数|color|1,255,253|7|color|100,49,24|次，当青龙|n|1||n|1|赐福的有效次数消耗至0后，青龙赐福增加|n|1||n|1|的攻击穿透属性将归零", "2", "70", "10", "5", "2011", "5", "2", "2", "7", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|5|color|100,49,24|次", "0", },
    id_7 = {"2", "3", "白虎赐福Lv3", "201", "|color|100,49,24|给已经拥有青龙赐福的队伍施加白虎赐福，|n|1||n|1|会增加其青龙赐福的有效次数|color|1,255,253|10|color|100,49,24|次，当青龙|n|1||n|1|赐福的有效次数消耗至0后，青龙赐福增加|n|1||n|1|的攻击穿透属性将归零", "2", "90", "10", "10", "2012", "5", "2", "2", "10", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|10|color|100,49,24|次", "0", },
    id_8 = {"2", "4", "白虎赐福Lv4", "201", "|color|100,49,24|给已经拥有青龙赐福的队伍施加白虎赐福，|n|1||n|1|会增加其青龙赐福的有效次数|color|1,255,253|15|color|100,49,24|次，当青龙|n|1||n|1|赐福的有效次数消耗至0后，青龙赐福增加|n|1||n|1|的攻击穿透属性将归零", "2", "110", "10", "15", "2013", "5", "2", "2", "15", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|15|color|100,49,24|次", "0", },
    id_9 = {"3", "1", "朱雀赐福Lv1", "201", "|color|100,49,24|出战队伍每拥有一层朱雀赐福，队伍所有|n|1||n|1|武将会增加韧性属性|color|1,255,253|100|color|100,49,24|点，属性叠加上限|n|1||n|1||color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "3", "50", "10", "3", "2020", "5", "3", "1", "100", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|3|color|100,49,24|次", "0", },
    id_10 = {"3", "2", "朱雀赐福Lv2", "201", "|color|100,49,24|出战队伍每拥有一层朱雀赐福，队伍所有|n|1||n|1|武将会增加韧性属性|color|1,255,253|150|color|100,49,24|点，属性叠加上限|n|1||n|1||color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "3", "70", "10", "5", "2021", "5", "3", "1", "150", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|5|color|100,49,24|次", "0", },
    id_11 = {"3", "3", "朱雀赐福Lv3", "201", "|color|100,49,24|出战队伍每拥有一层朱雀赐福，队伍所有|n|1||n|1|武将会增加韧性属性|color|1,255,253|200|color|100,49,24|点，属性叠加上限|n|1||n|1||color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "3", "90", "10", "10", "2022", "5", "3", "1", "200", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|10|color|100,49,24|次", "0", },
    id_12 = {"3", "4", "朱雀赐福Lv4", "201", "|color|100,49,24|出战队伍每拥有一层朱雀赐福，队伍所有|n|1||n|1|武将会增加韧性属性|color|1,255,253|250|color|100,49,24|点，属性叠加上限|n|1||n|1||color|1,255,253|1000|color|100,49,24|点，只在国战战斗中生效。贡品可以|n|1||n|1|在消灭敌国灵兽守军时获得", "3", "110", "10", "15", "2023", "5", "3", "1", "250", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|15|color|100,49,24|次", "0", },
    id_13 = {"4", "1", "玄武赐福Lv1", "201", "|color|100,49,24|给已经拥有朱雀赐福的队伍施加玄武赐福，|n|1||n|1|会增加其朱雀赐福的有效次数|color|1,255,253|5|color|100,49,24|次，当朱雀|n|1||n|1|赐福的有效次数消耗至0后，朱雀赐福增加|n|1||n|1|的韧性属性将归零", "4", "50", "10", "3", "2030", "5", "3", "2", "5", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|3|color|100,49,24|次", "0", },
    id_14 = {"4", "2", "玄武赐福Lv2", "201", "|color|100,49,24|给已经拥有朱雀赐福的队伍施加玄武赐福，|n|1||n|1|会增加其朱雀赐福的有效次数|color|1,255,253|7|color|100,49,24|次，当朱雀|n|1||n|1|赐福的有效次数消耗至0后，朱雀赐福增加|n|1||n|1|的韧性属性将归零", "4", "70", "10", "5", "2031", "5", "3", "2", "7", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|5|color|100,49,24|次", "0", },
    id_15 = {"4", "3", "玄武赐福Lv3", "201", "|color|100,49,24|给已经拥有朱雀赐福的队伍施加玄武赐福，|n|1||n|1|会增加其朱雀赐福的有效次数|color|1,255,253|10|color|100,49,24|次，当朱雀|n|1||n|1|赐福的有效次数消耗至0后，朱雀赐福增加|n|1||n|1|的韧性属性将归零", "4", "90", "10", "10", "2032", "5", "3", "2", "10", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|10|color|100,49,24|次", "0", },
    id_16 = {"4", "4", "玄武赐福Lv4", "201", "|color|100,49,24|给已经拥有朱雀赐福的队伍施加玄武赐福，|n|1||n|1|会增加其朱雀赐福的有效次数|color|1,255,253|15|color|100,49,24|次，当朱雀|n|1||n|1|赐福的有效次数消耗至0后，朱雀赐福增加|n|1||n|1|的韧性属性将归零", "4", "110", "10", "15", "2033", "5", "3", "2", "15", "-1", "-1", "-1", "灵兽事件持续事件内最多可赐福|color|1,255,253|15|color|100,49,24|次", "0", },
    id_17 = {"5", "1", "灵兽军团Lv1", "201", "|color|100,49,24|灵兽军团赐福的队伍会暂时替换成|color|1,255,253|较强的|color|100,49,24|灵兽军|n|1||n|1|团阵容，持续|color|1,255,253|5|color|100,49,24|场战斗，重复赐福同一战队将叠加|n|1||n|1|生效次数，效果只在国战中生效。获得其他四种|n|1||n|1|灵兽贡品的同时会以一定比例获得灵兽军团贡品", "5", "100", "10", "3", "2040", "-1", "4", "3", "81", "4", "2", "5", "灵兽事件持续事件内最多可赐福|color|1,255,253|3|color|100,49,24|次", "0", },
    id_18 = {"5", "2", "灵兽军团Lv2", "201", "|color|100,49,24|灵兽军团赐福的队伍会暂时替换成|color|1,255,253|稍强的|color|100,49,24|灵兽军|n|1||n|1|团阵容，持续|color|1,255,253|5|color|100,49,24|场战斗，重复赐福同一战队将叠加|n|1||n|1|生效次数，效果只在国战中生效。获得其他四种|n|1||n|1|灵兽贡品的同时会以一定比例获得灵兽军团贡品", "5", "120", "10", "5", "2041", "-1", "4", "3", "82", "4", "2", "5", "灵兽事件持续事件内最多可赐福|color|1,255,253|5|color|100,49,24|次", "0", },
    id_19 = {"5", "3", "灵兽军团Lv3", "201", "|color|100,49,24|灵兽军团赐福的队伍会暂时替换成|color|1,255,253|很强的|color|100,49,24|灵兽军|n|1||n|1|团阵容，持续|color|1,255,253|5|color|100,49,24|场战斗，重复赐福同一战队将叠加|n|1||n|1|生效次数，效果只在国战中生效。获得其他四种|n|1||n|1|灵兽贡品的同时会以一定比例获得灵兽军团贡品", "5", "150", "10", "10", "2042", "-1", "4", "3", "83", "4", "2", "5", "灵兽事件持续事件内最多可赐福|color|1,255,253|10|color|100,49,24|次", "0", },
    id_20 = {"5", "4", "灵兽军团Lv4", "201", "|color|100,49,24|灵兽军团赐福的队伍会暂时替换成|color|1,255,253|最强的|color|100,49,24|灵兽军|n|1||n|1|团阵容，持续|color|1,255,253|5|color|100,49,24|场战斗，重复赐福同一战队将叠加|n|1||n|1|生效次数，效果只在国战中生效。获得其他四种|n|1||n|1|灵兽贡品的同时会以一定比例获得灵兽军团贡品", "5", "200", "10", "15", "2043", "-1", "4", "3", "84", "4", "2", "5", "灵兽事件持续事件内最多可赐福|color|1,255,253|15|color|100,49,24|次", "0", },
}


function getDataById(key_id)
    local id_data = legion_monsterTable["id_" .. key_id]
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

    for k, v in pairs(legion_monsterTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return legion_monsterTable
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

    for k, v in pairs(legion_monsterTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["legion_monster"] = nil
    package.loaded["legion_monster"] = nil
end
