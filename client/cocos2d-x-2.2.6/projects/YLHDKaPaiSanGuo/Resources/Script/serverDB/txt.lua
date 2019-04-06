-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("txt", package.seeall)


keys = {
	"﻿TxtId", "ID", "Txt", 
}

txtTable = {
    id_1 = {"1", "1. 比武每天21:00进行排名结算，按排名获得相应的段位奖励，通过邮件发送。", },
    id_2 = {"1", "2. 进攻方无论挑战成功或失败都会获得固定的功勋和银币奖励。", },
    id_3 = {"1", "3. 比武中战斗以自动形式进行，玩家不能手动控制。", },
    id_4 = {"1", "4. 若战斗胜利，且防守方的排名高于进攻方，则将双方的排名对调。", },
    id_5 = {"1", "5. 若战斗超时，则算进攻方失败。", },
    id_6 = {"1", "6. 每天每个玩家可以免费发起5次挑战，每天21:00重置次数。", },
    id_7 = {"1", "7. 每次战斗后，进攻方都会获得一个10分钟的冷却时间。", },
    id_8 = {"1", "8. 正在进行战斗的玩家无法被选作对手。", },
    id_9 = {"2", "我很忙，我只在固定的时间更新货物！", },
    id_10 = {"2", "你的手指很灵活，我很喜欢", },
    id_11 = {"2", "我是卖女孩的小火柴，不过我也卖其他物品", },
    id_12 = {"2", "轻一点，亲爱的", },
    id_13 = {"2", "已经卖没了，真可惜！", },
    id_14 = {"2", "你……还想要么？", },
    id_15 = {"3", "宇宙无敌美少男\n战无不胜攻无不克\n与天齐寿", },
    id_16 = {"3", "宇宙无敌美少女\n战无不胜攻无不克\n与天齐寿", },
}


function getDataById(key_id)
    local id_data = txtTable["id_" .. key_id]
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

    for k, v in pairs(txtTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return txtTable
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

    for k, v in pairs(txtTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["txt"] = nil
    package.loaded["txt"] = nil
end
