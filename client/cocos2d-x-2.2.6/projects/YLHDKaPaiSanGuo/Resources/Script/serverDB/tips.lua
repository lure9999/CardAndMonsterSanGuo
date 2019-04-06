-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("tips", package.seeall)


keys = {
	"﻿Index", "TipsType", "TipsTypePara", "TipsPos", "TipsValue", "TipsValuePara", "TipsWidth", 
}

tipsTable = {
    id_1 = {"1", "0", "1", "1", "|size|22||color|233,180,114|银币 |n|1||size|18||color|233,180,114|可以用来强化装备、雇佣佣兵、银币酒馆购买等。|n|2|您可以通过签到、国战、完成任务等获取 银币。", "250", },
    id_2 = {"1", "0", "2", "1", "|size|22||color|233,180,114|元宝 |n|1||size|18||color|233,180,114| 可以用来在商店购买强力道具、雇佣强力佣兵、清除各种冷却等功能。|n|2|您可以通过充值、签到、完成任务等获取 |color|255,204,0| 元宝。", "250", },
    id_3 = {"1", "0", "3", "1", "|size|22||color|233,180,114|鸡腿 |n|1||size|18||color|233,180,114|征战必须消耗，您可以在军团食堂中每天领取，鸡腿也会自动恢复。|n|2|鸡腿每5分钟恢复1点", "250", },
    id_4 = {"1", "0", "4", "1", "|size|22||color|233,180,114|包子 |n|1||size|18||color|233,180,114|比武、夺宝必须消耗，您可以在军团食堂中每天领取，包子也会自动恢复。|n|2|包子每5分钟恢复1点", "250", },
    id_5 = {"1", "0", "5", "1", "|size|22||color|233,180,114|主将经验 |n|1||size|18||color|233,180,114|主将经验积满后，主将会提升等级，主将等级提升后会解锁更多上阵武将栏位。|n|2|您可以通过征战获得主将经验，获得武将经验的同时会获得等量的上阵护法经验。", "250", },
    id_6 = {"1", "0", "6", "1", "|size|22||color|233,180,114|武将经验 |n|1||size|18||color|233,180,114|您可以使用武将经验来提升除了主将之外的所有武将等级，武将等级提升后将能穿戴更高品级的装备。|n|2|武将经验可以通过国战、比武等功能来获取。", "250", },
    id_7 = {"1", "0", "9", "1", "|size|22||color|233,180,114|比武声望 |n|1||size|18||color|233,180,114|您可以在比武商店中消耗比武声望来购买比武商店中特有的道具。|n|2|在比武场中获取胜利可以获得比武声望。", "250", },
    id_8 = {"1", "0", "10", "1", "|size|22||color|233,180,114|军团贡献 |n|1||size|18||color|233,180,114|您可以在军团商店中消耗军团贡献来购买军团商店中特有的道具。|n|2|您可以通过向自己所在的军团捐献银币或者元宝来获得军团贡献。", "250", },
    id_9 = {"1", "0", "12", "1", "|size|22||color|233,180,114|国家经验 |n|1||size|18||color|233,180,114|每个国家都有对应的国家经验和国家等级，当国家经验积满后，对应国家会自动提升等级，国家等级提升后会提升守军能力。|n|2|国家内所有成员在完成国家任务后，对应国家都会增加", "250", },
    id_10 = {"1", "0", "13", "1", "|size|22||color|233,180,114|军团银币 |n|1||size|18||color|233,180,114|注资军团科技的必需货币。|n|2|军团成员向自己军团中捐献银币或者元宝的时候，军团银币会增加，军团银币是军团成员共用的货币。", "250", },
    id_11 = {"1", "0", "14", "1", "|size|22||color|233,180,114|国家经验 |n|1||size|18||color|233,180,114|每个国家都有对应的国家经验和国家等级，当国家经验积满后，对应国家会自动提升等级，国家等级提升后会提升守军能力。|n|2|国家内所有成员在完成国家任务后，对应国家都会增加", "250", },
    id_12 = {"1", "0", "17", "1", "|size|22||color|233,180,114|星魂 |n|1||size|18||color|233,180,114|培养主将属性的必要资源。|n|2|您可以在重楼中战斗胜利获得星魂。", "250", },
    id_13 = {"1", "1", "1", "1", "|size|22||color|233,180,114|玩家战斗力 |n|1||size|18||color|233,180,114|根据当前您阵容上所有武将的战斗力计算出您的当前战斗力|n|2|您可以通过强化装备、培养主将属性、提升丹药等级、提升天命等级等提升战斗力", "250", },
    id_14 = {"1", "1", "2", "1", "|size|22||color|233,180,114|军团战斗力 |n|1||size|18||color|233,180,114|军团中所有军团成员战斗力总和。", "250", },
    id_15 = {"1", "1", "3", "1", "|size|22||color|233,180,114|国家战斗力 |n|1||size|18||color|233,180,114|当前国家的总战斗力，国家内所有成员的战斗力总和。", "250", },
    id_16 = {"2", "7", "1", "1", "|size|22||color|233,180,114|星魂 |n|1||size|18||color|233,180,114|培养主将属性的必要资源。|n|2|您可以在重楼中战斗胜利获得星魂。", "250", },
    id_17 = {"2", "13", "1", "1", "|size|22||color|233,180,114|包子 |n|1||size|18||color|233,180,114|比武、夺宝必须消耗，您可以在军团食堂中每天领取，包子也会自动恢复。|n|2|包子每5分钟恢复1点", "250", },
    id_18 = {"2", "14", "1", "1", "|size|22||color|233,180,114|夺宝累计宝箱 |n|1||size|18||color|233,180,114|每夺宝10次，可以领取1个夺宝累计宝箱。", "250", },
    id_19 = {"2", "14", "2", "1", "|size|22||color|233,180,114|幸运草 |n|1||size|18||color|233,180,114|每次夺宝都会有几率获得幸运草，幸运草会提升夺宝获得碎片的概率，每次成功获得碎片都会扣除1个幸运草。", "250", },
    id_20 = {"2", "15", "1", "1", "|size|22||color|233,180,114|丹药等级 |n|1||size|18||color|233,180,114|您可以提升武将的丹药等级来提升武将的战斗力", "250", },
    id_21 = {"2", "15", "2", "1", "|size|22||color|233,180,114|武将缘分 |n|1||size|18||color|233,180,114|当前武将缘分的激活情况，您可以在武将缘分界面查看该武将的所有缘分", "250", },
    id_22 = {"2", "28", "1", "1", "|size|22||color|233,180,114|武将经验 |n|1||size|18||color|233,180,114|您可以使用武将经验来提升除了主将之外的所有武将等级，武将等级提升后将能穿戴更高品级的装备。|n|2|武将经验可以通过国战、比武等功能来获取。", "250", },
}


function getDataById(key_id)
    local id_data = tipsTable["id_" .. key_id]
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

    for k, v in pairs(tipsTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return tipsTable
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

    for k, v in pairs(tipsTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["tips"] = nil
    package.loaded["tips"] = nil
end
