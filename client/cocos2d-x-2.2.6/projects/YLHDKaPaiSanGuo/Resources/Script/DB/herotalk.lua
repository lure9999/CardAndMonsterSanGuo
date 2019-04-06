-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("herotalk", package.seeall)


keys = {
	"﻿talk_id", "hero_name", "left_img", "right_img", "text", "next_id", "side", 
}

herotalkTable = {
    id_1 = {"赵云", "banshenxiang_zhaoyun", "empty", "风在吼，火在烧，什么东西在咆哮？？？(⊙▽⊙a)", "0", "1", },
    id_2 = {"炎龙", "empty", "banshenxiang_long", "哇哈哈~哈，三太子我随东风而来，今儿个可要大开杀戒啦！！！", "3", "0", },
    id_3 = {"貂蝉", "banshenxiang_diaochan", "banshenxiang_long", "布……我怕！(＞﹏＜)", "4", "1", },
    id_4 = {"吕布", "banshenxiang_lvbu", "banshenxiang_long", "蝉儿莫怕！有我吕布在，谁也伤不了你！", "5", "1", },
    id_5 = {"炎龙", "banshenxiang_lvbu", "banshenxiang_long", "好美的小娘子！陪三太子去龙宫耍耍！", "6", "0", },
    id_6 = {"吕布", "banshenxiang_lvbu", "banshenxiang_long", "刁龙！看打！(/ﾟДﾟ)/ ", "0", "1", },
    id_7 = {"话外音", "empty", "empty", "苍天已死，黄开当立，岁在甲子，天下大吉。", "0", "0", },
    id_8 = {"主角", "zhujue", "empty", "嗯？我这是在哪里啊？头好疼啊~~", "0", "1", },
    id_9 = {"张角", "empty", "banshenxiang_zhangjiao", "前面那小子形迹可疑，定然不是好人，给本仙师捉来做包子。", "10", "0", },
    id_10 = {"小兵", "empty", "banshenxiang_qiangbing", "好的大王，没问题大王。~(≧▽≦)/~", "0", "0", },
    id_11 = {"主角", "zhujue", "empty", "囧RZ", "0", "1", },
    id_12 = {"张角", "empty", "banshenxiang_zhangjiao", "小子有种你别跑，你给我等着 o(>﹏<)o", "0", "0", },
    id_13 = {"主角", "zhujue", "empty", "。。。。。", "0", "1", },
    id_14 = {"刘备", "banshenxiang_liubei", "empty", "在下刘备，字玄德，恰巧路过此地，看到刚才所发生的事情，小兄弟乃当世真英雄是也，敢独闯黄巾军大营，吾虽不才，但愿与小英雄一起诛杀此贼，还天下一个太平", "15", "1", },
    id_15 = {"主角", "zhujue", "empty", "哇，你就是刘备刘皇叔啊，在下仰慕你已久，今日终于见到活的了 ♪（＾∀＾●）ﾉｼ", "16", "1", },
    id_16 = {"刘备", "banshenxiang_liubei", "empty", "小英雄过誉，备不胜欣喜。但此处非叙话之地，待吾等冲出大营再说不迟", "0", "1", },
    id_17 = {"张角", "empty", "banshenxiang_zhangjiao", "上~给我上~砍了他们ヽ(#`Д´)ﾉ", "18", "0", },
    id_18 = {"小兵", "empty", "banshenxiang_qiangbing", "大王看我的！没问题大王~(≧▽≦)/~", "0", "0", },
    id_19 = {"张角", "empty", "banshenxiang_zhangjiao", "贼子厉害，小的们，先给我挡住，我去叫救兵", "0", "0", },
    id_20 = {"主角", "zhujue", "empty", "张角这货也太鸡贼了，看打不过就跑", "21", "1", },
    id_21 = {"刘备", "banshenxiang_liubei", "empty", "张角胆小慎危，为人又睚眦必报，我们还是赶紧离开，以免敌人援兵", "0", "1", },
    id_22 = {"张宝", "empty", "banshenxiang_zhugeliang", "小贼打了我大哥还想走？！", "23", "0", },
    id_23 = {"主角", "zhujue", "empty", "我说我是无辜滴，你信不信？", "24", "1", },
    id_24 = {"刘备", "banshenxiang_liubei", "empty", "此为张角之弟，地公将军张宝，善长以妖法惑人，小英雄要注意提防。待备叫二弟过来护我们杀出去", "0", "1", },
    id_25 = {"刘备", "banshenxiang_liubei", "empty", "哔~哔~哔~", "0", "1", },
    id_26 = {"关羽", "banshenxiang_guanyu", "empty", "大哥，云长来也╰（｀□′）╯", "27", "1", },
    id_27 = {"刘备", "banshenxiang_liubei", "empty", "小英雄，此乃吾二弟，关羽关云长", "28", "1", },
    id_28 = {"主角", "zhujue", "empty", "哇~这就是武圣关二爷啊♪（＾∀＾●）ﾉｼ", "29", "1", },
    id_29 = {"张宝", "empty", "banshenxiang_zhugeliang", "（（｀□′））哼，竟然还有功夫说闲话，小的们，随我一起拿下他们", "0", "0", },
    id_30 = {"刘备", "banshenxiang_liubei", "empty", "二弟，此乃以独身杀入敌营的小英雄", "31", "1", },
    id_31 = {"关羽", "banshenxiang_guanyu", "empty", "真是英雄出少年，小小年纪竟然有此勇气，以后必然一代人杰", "32", "1", },
    id_32 = {"主角", "zhujue", "empty", "二爷过誉了，恰逢此会，纯属路过(/≧▽≦/)", "33", "1", },
    id_33 = {"刘备", "banshenxiang_liubei", "empty", "小英雄真是谦虚", "34", "1", },
    id_34 = {"关羽", "banshenxiang_guanyu", "empty", "大哥，小英雄，此处非久留之地，我们还是先离开再说吧", "35", "1", },
    id_35 = {"刘备", "banshenxiang_liubei", "empty", "云长所言甚是，小英雄我们先撤吧", "0", "1", },
    id_36 = {"张角", "empty", "banshenxiang_zhugeliang", "咳••咳••欺人太甚，来了还想走，太不把我等兄弟放在眼里了吧。", "37", "0", },
    id_37 = {"刘备", "banshenxiang_liubei", "empty", "哈哈~我等要走你留得住吗？！", "38", "1", },
    id_38 = {"张角", "empty", "banshenxiang_zhugeliang", "留不留得下，手下见真章，休逞口舌之争", "0", "0", },
    id_39 = {"张飞", "banshenxiang_zhangfei", "empty", "呔，贼子休要猖狂，看你家张飞爷爷斩了你", "0", "1", },
    id_40 = {"刘备", "banshenxiang_liubei", "empty", "呵呵，小英雄休要惊慌，此乃我家三弟，张飞张益德", "41", "1", },
    id_41 = {"主角", "zhujue", "empty", "原来是张将军，久仰久仰", "42", "1", },
    id_42 = {"张飞", "banshenxiang_zhangfei", "empty", "待洒家砍了他们再回来与小英雄叙话", "0", "1", },
    id_43 = {"主角", "zhujue", "empty", "终于冲出来了，太不容易了", "44", "1", },
    id_44 = {"刘备", "banshenxiang_liubei", "empty", "哈哈，小英雄果然真性情", "45", "1", },
    id_45 = {"主角", "zhujue", "empty", "哈哈，刘皇叔就莫要取笑了", "46", "1", },
    id_46 = {"关羽", "banshenxiang_guanyu", "empty", "大哥，小英雄我们还是先撤吧，黄巾军快要追上来了", "47", "1", },
    id_47 = {"刘备", "banshenxiang_liubei", "empty", "也好", "0", "1", },
}


function getDataById(key_id)
    local id_data = herotalkTable["id_" .. key_id]
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

    for k, v in pairs(herotalkTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return herotalkTable
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

    for k, v in pairs(herotalkTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["herotalk"] = nil
    package.loaded["herotalk"] = nil
end
