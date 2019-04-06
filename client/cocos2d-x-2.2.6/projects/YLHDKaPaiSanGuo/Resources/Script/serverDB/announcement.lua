-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("announcement", package.seeall)


keys = {
	"﻿ID", "order", "mode1", "para1", "mode2", "para2", "text", 
}

announcementTable = {
    id_1 = {"2", "1", "0", "0", "0", "【%s】竟然通过了【%s】，我和我的小伙伴都惊呆了！", },
    id_2 = {"2", "1", "0", "0", "0", "【%s】竟然得到了传说中的神兵【%s】，羡慕嫉妒恨啊~~", },
    id_3 = {"2", "1", "0", "0", "0", "【%s】竟然获得了紫色武将【%s】，小伙伴快来沾点仙气儿吧~", },
    id_13 = {"1", "2", "0", "0", "0", "欢迎主公又回到三国大一统的世界，让我随您驰骋在这战火纷飞的年代吧！~", },
    id_14 = {"1", "2", "1", "3", "0", "距离关服时间还有30分钟。", },
    id_15 = {"1", "2", "1", "3", "0", "距离关服时间还有15分钟。", },
    id_16 = {"1", "2", "1", "3", "0", "距离关服时间还有10分钟。", },
    id_17 = {"1", "2", "1", "3", "0", "距离关服时间还有5分钟。", },
    id_18 = {"1", "2", "1", "3", "0", "距离关服时间还有1分钟。", },
    id_19 = {"1", "2", "1", "0", "0", "三国交战之时，新的任务30分钟后发布，请主公整装待发！", },
    id_20 = {"1", "2", "1", "3", "0", "三国交战之时，新的任务15分钟后发布，请主公整装待发！", },
    id_21 = {"1", "2", "1", "3", "0", "三国交战之时，新的任务10分钟后发布，请主公整装待发！", },
    id_22 = {"1", "2", "1", "3", "0", "三国交战之时，新的任务5分钟后发布，请主公整装待发！", },
    id_23 = {"1", "2", "1", "3", "0", "三国之战硝烟弥漫，保和平，为国家，就是保家乡！国战任务现在开始！", },
    id_24 = {"10", "1", "1", "2", "3", "【%s】的【%s】攻陷了【%s】的【%s】！", },
    id_25 = {"10", "1", "1", "2", "3", "【%s%s】在激烈的三国攻防战中取得了胜利，战胜了【%s，%s】，祝贺你们！", },
    id_26 = {"10", "1", "1", "2", "3", "【%s%s】在激烈的三国攻防战中被【%s，%s】击败，不要气馁胜败乃兵家常事！", },
    id_1000 = {"1", "1", "0", "0", "0", "战火纷飞的年代里，快来加入官方QQ群和玩家一起畅谈吧~群号：240540111。进群次日送礼包哟~", },
}


function getDataById(key_id)
    local id_data = announcementTable["id_" .. key_id]
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

    for k, v in pairs(announcementTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return announcementTable
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

    for k, v in pairs(announcementTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["announcement"] = nil
    package.loaded["announcement"] = nil
end
