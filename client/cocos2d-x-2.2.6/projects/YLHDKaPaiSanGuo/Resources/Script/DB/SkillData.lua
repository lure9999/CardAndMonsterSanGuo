-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("SkillData", package.seeall)


keys = {
	"﻿Skillid", "SkillName", "SkillType", "ActIndex", "ActName", "ActType", "Audio_Skill", "skillDesID", "Effectid_bullet", "Effectid_hit", "Effectid_Buff", 
}

SkillDataTable = {
    id_1010 = {"女主zs普通攻击", "0", nil, "attack_zs", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_1011 = {"女主zs技能攻击", "9", nil, "skill_zs", "0", "audio/skill/nvzhu_zs_skill.mp3", "1012", "1011", "0", "0", },
    id_1012 = {"女主zs能量攻击", "14", nil, "manualskill_zs", "0", "audio/skill/nvzhu_zs_manualskill.mp3", "1012", "1010", "135", "0", },
    id_1110 = {"女主mj普通攻击", "0", nil, "attack_mj", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_1111 = {"女主mj技能攻击", "9", nil, "skill_mj", "0", "audio/skill/nvzhu_zs_skill.mp3", "1012", "1021", "0", "0", },
    id_1112 = {"女主mj能量攻击", "14", nil, "manualskill_mj", "0", "audio/skill/nvzhu_zs_manualskill.mp3", "1012", "1009", "135", "0", },
    id_1210 = {"女主bz普通攻击", "0", nil, "attack_bz", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_1211 = {"女主bz技能攻击", "9", nil, "skill_bz", "0", "audio/skill/nvzhu_zs_skill.mp3", "1012", "1031", "0", "0", },
    id_1212 = {"女主bz能量攻击", "14", nil, "manualskill_bz", "0", "audio/skill/nvzhu_zs_manualskill.mp3", "1012", "1008", "135", "0", },
    id_1013 = {"女主ms普通攻击", "1", nil, "attack_ms", "0", "audio/effect/zhang_attack.mp3", "1012", "1012", "135", "0", },
    id_1014 = {"女主ms技能攻击", "1", nil, "skill_ms", "0", "audio/skill/nvzhu_ms_skill.mp3", "1012", "1012", "135", "0", },
    id_1015 = {"女主ms能量攻击", "1", nil, "manualskill_ms", "0", "audio/skill/nvzhu_ms_manualskill.mp3", "1012", "1013", "133", "0", },
    id_1113 = {"女主cs普通攻击", "1", nil, "attack_cs", "0", "audio/effect/zhang_attack.mp3", "1012", "1012", "135", "0", },
    id_1114 = {"女主cs技能攻击", "1", nil, "skill_cs", "0", "audio/skill/nvzhu_ms_skill.mp3", "1012", "1022", "129", "0", },
    id_1115 = {"女主cs能量攻击", "1", nil, "manualskill_cs", "0", "audio/skill/nvzhu_ms_manualskill.mp3", "1012", "1023", "2", "0", },
    id_1213 = {"女主ts普通攻击", "1", nil, "attack_ts", "0", "audio/effect/zhang_attack.mp3", "1012", "1012", "135", "0", },
    id_1214 = {"女主ts技能攻击", "1", nil, "skill_ts", "0", "audio/skill/nvzhu_ms_skill.mp3", "1012", "1032", "3", "0", },
    id_1215 = {"女主ts能量攻击", "1", nil, "manualskill_ts", "0", "audio/skill/nvzhu_ms_manualskill.mp3", "1012", "1033", "4", "0", },
    id_1016 = {"女主gs普通攻击", "3", nil, "attack_gs", "0", "audio/skill/taishici_attack.mp3", "1014", "1014", "135", "0", },
    id_1017 = {"女主gs技能攻击", "3", nil, "skill_gs", "0", "audio/skill/nvzhu_gs_skill.mp3", "1014", "1014", "135", "0", },
    id_1018 = {"女主gs能量攻击", "1", nil, "manualskill_gs", "0", "audio/skill/nvzhu_gs_manualskill.mp3", "1015", "1015", "135", "0", },
    id_1116 = {"女主fy普通攻击", "3", nil, "attack_fy", "0", "audio/skill/taishici_attack.mp3", "1014", "1014", "135", "0", },
    id_1117 = {"女主fy技能攻击", "3", nil, "skill_fy", "0", "audio/skill/nvzhu_gs_skill.mp3", "1014", "1026", "135", "0", },
    id_1118 = {"女主fy能量攻击", "1", nil, "manualskill_fy", "0", "audio/skill/nvzhu_gs_manualskill.mp3", "1015", "1025", "135", "0", },
    id_1216 = {"女主ly普通攻击", "3", nil, "attack_ly", "0", "audio/skill/taishici_attack.mp3", "1014", "1014", "135", "0", },
    id_1217 = {"女主ly技能攻击", "3", nil, "skill_ly", "0", "audio/skill/nvzhu_gs_skill.mp3", "1014", "1036", "135", "0", },
    id_1218 = {"女主ly能量攻击", "1", nil, "manualskill_ly", "0", "audio/skill/nvzhu_gs_manualskill.mp3", "1015", "1035", "135", "0", },
    id_1020 = {"男主zs普通攻击", "0", nil, "attack_zs", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_1021 = {"男主zs技能攻击", "9", nil, "skill_zs", "0", "audio/skill/nanzhu_zs_skill.mp3", "1012", "1011", "0", "0", },
    id_1022 = {"男主zs能量攻击", "14", nil, "manualskill_zs", "0", "audio/skill/nanzhu_zs_manualskill.mp3", "1012", "1010", "135", "0", },
    id_1120 = {"男主mj普通攻击", "0", nil, "attack_mj", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_1121 = {"男主mj技能攻击", "9", nil, "skill_mj", "0", "audio/skill/nanzhu_zs_skill.mp3", "1012", "1021", "0", "0", },
    id_1122 = {"男主mj能量攻击", "14", nil, "manualskill_mj", "0", "audio/skill/nanzhu_zs_manualskill.mp3", "1012", "1009", "135", "0", },
    id_1220 = {"男主bz普通攻击", "0", nil, "attack_bz", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_1221 = {"男主bz技能攻击", "9", nil, "skill_bz", "0", "audio/skill/nanzhu_zs_skill.mp3", "1012", "1031", "0", "0", },
    id_1222 = {"男主bz能量攻击", "14", nil, "manualskill_bz", "0", "audio/skill/nanzhu_zs_manualskill.mp3", "1012", "1008", "135", "0", },
    id_1023 = {"男主ms普通攻击", "1", nil, "attack_ms", "0", "audio/effect/zhang_attack.mp3", "1012", "1012", "135", "0", },
    id_1024 = {"男主ms技能攻击", "1", nil, "skill_ms", "0", "audio/skill/nanzhu_ms_skill.mp3", "1012", "1012", "135", "0", },
    id_1025 = {"男主ms能量攻击", "1", nil, "manualskill_ms", "0", "audio/skill/nanzhu_ms_manualskill.mp3", "1012", "1013", "133", "0", },
    id_1123 = {"男主cs普通攻击", "1", nil, "attack_cs", "0", "audio/effect/zhang_attack.mp3", "1012", "1012", "135", "0", },
    id_1124 = {"男主cs技能攻击", "1", nil, "skill_cs", "0", "audio/skill/nanzhu_ms_skill.mp3", "1012", "1022", "129", "0", },
    id_1125 = {"男主cs能量攻击", "1", nil, "manualskill_cs", "0", "audio/skill/nanzhu_ms_manualskill.mp3", "1012", "1023", "2", "0", },
    id_1223 = {"男主ts普通攻击", "1", nil, "attack_ts", "0", "audio/effect/zhang_attack.mp3", "1012", "1012", "135", "0", },
    id_1224 = {"男主ts技能攻击", "1", nil, "skill_ts", "0", "audio/skill/nanzhu_ms_skill.mp3", "1012", "1032", "3", "0", },
    id_1225 = {"男主ts能量攻击", "1", nil, "manualskill_ts", "0", "audio/skill/nanzhu_ms_manualskill.mp3", "1012", "1033", "4", "0", },
    id_1026 = {"男主gs普通攻击", "3", nil, "attack_gs", "0", "audio/skill/taishici_attack.mp3", "1014", "1014", "135", "0", },
    id_1027 = {"男主gs技能攻击", "3", nil, "skill_gs", "0", "audio/skill/nanzhu_gs_skill.mp3", "1014", "1014", "135", "0", },
    id_1028 = {"男主gs能量攻击", "1", nil, "manualskill_gs", "0", "audio/skill/nanzhu_gs_manualskill.mp3", "1015", "1015", "135", "0", },
    id_1126 = {"男主fy普通攻击", "3", nil, "attack_fy", "0", "audio/skill/taishici_attack.mp3", "1014", "1014", "135", "0", },
    id_1127 = {"男主fy技能攻击", "3", nil, "skill_fy", "0", "audio/skill/nanzhu_gs_skill.mp3", "1014", "1026", "135", "0", },
    id_1128 = {"男主fy能量攻击", "1", nil, "manualskill_fy", "0", "audio/skill/nanzhu_gs_manualskill.mp3", "1015", "1025", "135", "0", },
    id_1226 = {"男主ly普通攻击", "3", nil, "attack_ly", "0", "audio/skill/taishici_attack.mp3", "1014", "1014", "135", "0", },
    id_1227 = {"男主ly技能攻击", "3", nil, "skill_ly", "0", "audio/skill/nanzhu_gs_skill.mp3", "1014", "1036", "135", "0", },
    id_1228 = {"男主ly能量攻击", "1", nil, "manualskill_ly", "0", "audio/skill/nanzhu_gs_manualskill.mp3", "1015", "1035", "135", "0", },
    id_1 = {"护法龙能量技能", "0", nil, "attack", "2", "audio/skill/hufalong_attack.mp3", "1", "0", "133", "0", },
    id_2 = {"护法花精能量技能", "0", nil, "attack", "2", "audio/skill/hufahuaxian_attack.mp3", "1", "0", "243", "0", },
    id_3 = {"护法猪能量技能", "0", nil, "attack", "2", "audio/skill/hufazhu_attack.mp3", "1", "0", "135", "0", },
    id_4 = {"护法女神能量技能", "0", nil, "attack", "2", "audio/skill/hufanvshen_attack.mp3", "1", "0", "205", "0", },
    id_5 = {"护法男神能量技能", "0", nil, "attack", "2", "audio/skill/hufananshen_attack.mp3", "1", "0", "206", "0", },
    id_6 = {"护法死神能量技能", "0", nil, "attack", "2", "audio/skill/hufasishen_attack.mp3", "1", "0", "135", "0", },
    id_7 = {"yanlong远程攻击", "1", nil, "attack", "0", "audio/effect/dao_hard_attack.mp3", "1002", "115", "114", "0", },
    id_8 = {"yanlong远程技能", "4", nil, "skill", "0", "audio/skill/yanlong_skill.mp3", "1003", "118", "116", "0", },
    id_9 = {"yanlong远程能量技能", "0", nil, "manualskill", "0", "audio/skill/yanlong_manualskill.mp3", "1003", "0", "119", "0", },
    id_10 = {"甘宁普通攻击", "1", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1004", "105", "100", "0", },
    id_11 = {"甘宁技能攻击", "1", nil, "skill", "0", "audio/effect/dao_attack.mp3", "1005", "101", "100", "0", },
    id_12 = {"甘宁能量攻击", "1", nil, "manualskill", "0", "audio/skill/ganning_manualskill.mp3", "1006", "102", "100", "0", },
    id_13 = {"吕布普通攻击", "0", nil, "attack", "0", "audio/effect/qiang_attack.mp3", "1007", "0", "103", "0", },
    id_14 = {"吕布技能攻击", "0", nil, "skill", "0", "audio/skill/lvbu_skill.mp3", "1008", "0", "103", "0", },
    id_15 = {"吕布能量攻击", "0", nil, "manualskill", "1", "audio/skill/lvbu_manualskill.mp3", "1009", "0", "104", "0", },
    id_16 = {"赵云普通攻击", "0", nil, "attack", "0", "audio/effect/qiang_attack.mp3", "1007", "0", "135", "0", },
    id_17 = {"赵云技能攻击", "1", nil, "skill", "0", "audio/skill/dongzhuo_attack.mp3", "1008", "107", "109", "0", },
    id_18 = {"赵云能量攻击", "1", nil, "manualskill", "0", "audio/skill/zhaoyun_manualskill.mp3", "1009", "108", "123", "0", },
    id_19 = {"貂蝉普通攻击", "1", nil, "attack", "0", "audio/skill/diaochan_attack.mp3", "1007", "120", "117", "0", },
    id_20 = {"貂蝉技能攻击", "0", nil, "skill", "0", "audio/skill/diaochan_skill.mp3", "1008", "0", "117", "0", },
    id_21 = {"貂蝉能量攻击", "6", nil, "manualskill", "0", "audio/skill/diaochan_manualskill.mp3", "1009", "122", "117", "0", },
    id_22 = {"投石车普通攻击", "2", nil, "attack", "0", "audio/skill/gongchengche_attack.mp3", "1010", "110", "112", "0", },
    id_23 = {"投石车技能攻击", "2", nil, "skill", "0", "audio/skill/gongchengche_skill.mp3", "1011", "111", "113", "0", },
    id_24 = {"投石车能量攻击", "3", nil, "manualskill", "0", "audio/skill/gongchengche_manualskill.mp3", "1012", "111", "113", "0", },
    id_25 = {"盾兵普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_26 = {"盾兵技能攻击", "6", nil, "skill", "0", "audio/effect/dao_hard_attack.mp3", "1012", "131", "135", "0", },
    id_27 = {"盾兵能量攻击", "5", nil, "manualskill", "0", "audio/skill/dunbing_manualskill.mp3", "1012", "125", "0", "0", },
    id_28 = {"枪兵普通攻击", "0", nil, "attack", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "126", "0", },
    id_29 = {"枪兵技能攻击", "0", nil, "skill", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "126", "0", },
    id_30 = {"枪兵能量攻击", "0", nil, "manualskill", "0", "audio/skill/qiangbing_manualskill.mp3", "1012", "0", "126", "0", },
    id_31 = {"关羽普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_32 = {"关羽技能攻击", "0", nil, "skill", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_33 = {"关羽能量攻击", "0", nil, "manualskill", "0", "audio/skill/guanyu_manualskill.mp3", "1012", "0", "127", "0", },
    id_34 = {"蒲扇兵普通攻击", "1", nil, "attack", "0", "audio/skill/simayi_attack.mp3", "1012", "128", "129", "0", },
    id_35 = {"蒲扇兵技能攻击", "0", nil, "skill", "0", "audio/skill/simayi_attack.mp3", "1012", "0", "130", "0", },
    id_36 = {"蒲扇兵能量攻击", "0", nil, "manualskill", "0", "audio/skill/dongzhuo_skill.mp3", "1012", "0", "130", "0", },
    id_37 = {"马超普通攻击", "0", nil, "attack", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_38 = {"马超技能攻击", "6", nil, "skill", "1", "audio/skill/machao_skill.mp3", "1012", "131", "153", "0", },
    id_39 = {"马超能量攻击", "7", nil, "manualskill", "0", "audio/skill/machao_manualskill.mp3", "1012", "131", "135", "0", },
    id_40 = {"鼓手普通攻击", "1", nil, "attack", "0", "audio/effect/zhang_attack.mp3", "1012", "134", "135", "0", },
    id_41 = {"鼓手技能攻击", "1", nil, "skill", "0", "audio/skill/gushou_skill.mp3", "1012", "134", "135", "0", },
    id_42 = {"鼓手能量攻击", "8", nil, "manualskill", "0", "audio/skill/gushou_manualskill.mp3", "1012", "136", "0", "0", },
    id_43 = {"华佗普通攻击（单加血）", "0", nil, "attack", "2", "audio/effect/zhiliao_buff.mp3", "1012", "0", "137", "0", },
    id_44 = {"华佗技能攻击（单加吸收盾）", "9", nil, "skill", "0", "audio/skill/caiwenji_attack.mp3", "1012", "138", "0", "0", },
    id_45 = {"华佗能量攻击（全体加血）", "0", nil, "manualskill", "2", "audio/skill/huatuo_manualskill.mp3", "1012", "0", "137", "0", },
    id_46 = {"曹仁普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_47 = {"曹仁技能攻击", "0", nil, "skill", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_48 = {"曹仁能量攻击", "5", nil, "manualskill", "0", "audio/skill/caoren_manualskill.mp3", "1012", "139", "0", "0", },
    id_49 = {"曹操普通攻击", "10", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_50 = {"曹操技能攻击", "10", nil, "skill", "0", "audio/skill/caocao_skill.mp3", "1012", "0", "135", "0", },
    id_51 = {"曹操能量攻击", "11", nil, "manualskill", "0", "audio/skill/caocao_manualskill.mp3", "1012", "0", "135", "0", },
    id_52 = {"典韦普通攻击", "0", nil, "attack", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_53 = {"典韦技能攻击", "0", nil, "skill", "0", "audio/skill/dianwei_skill.mp3", "1012", "0", "135", "0", },
    id_54 = {"典韦能量攻击", "0", nil, "manualskill", "0", "audio/skill/dianwei_manualskill.mp3", "1012", "0", "140", "0", },
    id_55 = {"董卓普通攻击", "0", nil, "attack", "0", "audio/skill/dongzhuo_attack.mp3", "1012", "0", "135", "0", },
    id_56 = {"董卓技能攻击", "1", nil, "skill", "1", "audio/skill/dongzhuo_skill.mp3", "1012", "154", "155", "0", },
    id_57 = {"董卓能量攻击", "0", nil, "manualskill", "0", "audio/skill/dongzhuo_manualskill.mp3", "1012", "0", "135", "0", },
    id_58 = {"张飞普通攻击", "0", nil, "attack", "0", "audio/effect/qiang_attack.mp3", "1012", "0", "135", "0", },
    id_59 = {"张飞技能攻击", "12", nil, "skill", "0", "audio/skill/lvbu_skill.mp3", "1012", "0", "135", "0", },
    id_60 = {"张飞能量攻击", "12", nil, "manualskill", "0", "audio/skill/zhangfei_manualskill.mp3", "1012", "0", "135", "0", },
    id_61 = {"诸葛亮普通攻击", "0", nil, "attack", "0", "audio/skill/zhugeliang_attack.mp3", "1012", "0", "135", "0", },
    id_62 = {"诸葛亮技能攻击", "8", nil, "skill", "0", "audio/skill/caiwenji_attack.mp3", "1012", "142", "142", "0", },
    id_63 = {"诸葛亮能量攻击", "0", nil, "manualskill", "0", "audio/skill/zhugeliang_manualskill.mp3", "1012", "0", "130", "0", },
    id_64 = {"小乔普通攻击", "13", nil, "attack", "1", "audio/effect/zhang_attack.mp3", "1012", "143", "144", "131", },
    id_65 = {"小乔技能攻击", "0", nil, "skill", "0", "audio/skill/xiaoqiao_skill.mp3", "1012", "0", "137", "0", },
    id_66 = {"小乔能量攻击", "5", nil, "manualskill", "0", "audio/skill/ganfuren_manualskill.mp3", "1012", "145", "0", "0", },
    id_67 = {"大桥普通攻击", "5", nil, "attack", "0", "audio/skill/caiwenji_attack.mp3", "1012", "146", "0", "0", },
    id_68 = {"大桥技能攻击", "9", nil, "skill", "0", "audio/skill/caiwenji_skill.mp3", "1012", "147", "0", "0", },
    id_69 = {"大桥能量攻击", "0", nil, "manualskill", "2", "audio/skill/caiwenji_manualskill.mp3", "1012", "0", "137", "0", },
    id_70 = {"祝融普通攻击", "1", nil, "attack", "0", "audio/effect/feidao_attack.mp3", "1012", "148", "135", "0", },
    id_71 = {"祝融技能攻击", "13", nil, "skill", "0", "audio/skill/zhurong_skill.mp3", "1012", "149", "150", "151", },
    id_72 = {"祝融能量攻击", "0", nil, "manualskill", "0", "audio/skill/zhurong_manualskill.mp3", "1012", "0", "152", "0", },
    id_73 = {"刀兵普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_74 = {"刀兵技能攻击", "0", nil, "skill", "0", "audio/skill/dianwei_skill.mp3", "1012", "0", "135", "0", },
    id_75 = {"刀兵能量攻击", "6", nil, "manualskill", "0", "audio/skill/xiahoudun_skill.mp3", "1012", "131", "135", "131", },
    id_76 = {"太史慈普通攻击", "3", nil, "attack", "0", "audio/skill/taishici_attack.mp3", "1012", "1014", "135", "0", },
    id_77 = {"太史慈技能攻击", "1", nil, "skill", "0", "audio/skill/taishici_skill.mp3", "1012", "156", "135", "0", },
    id_78 = {"太史慈能量攻击", "0", nil, "manualskill", "0", "audio/skill/taishici_manualskill.mp3", "1012", "0", "157", "0", },
    id_79 = {"张郃普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "158", "0", },
    id_80 = {"张郃技能攻击", "13", nil, "skill", "0", "audio/skill/zhanghe_skill.mp3", "1012", "160", "158", "151", },
    id_81 = {"张郃能量攻击", "0", nil, "manualskill", "1", "audio/skill/zhanghe_manualskill.mp3", "1012", "0", "161", "0", },
    id_82 = {"张角普通攻击", "1", nil, "attack", "0", "audio/effect/lei_attack.mp3", "1012", "159", "135", "0", },
    id_83 = {"张角技能攻击", "0", nil, "skill", "0", "audio/effect/zhang_attack.mp3", "1012", "0", "162", "0", },
    id_84 = {"张角能量攻击", "0", nil, "manualskill", "1", "audio/skill/zhangjiao_manualskill.mp3", "1012", "0", "163", "0", },
    id_85 = {"黄盖普通攻击", "0", nil, "attack", "0", "audio/skill/dongzhuo_attack.mp3", "1012", "0", "158", "0", },
    id_86 = {"黄盖技能攻击", "0", nil, "skill", "0", "audio/skill/huanggai_skill.mp3", "1012", "0", "158", "0", },
    id_87 = {"黄盖能量攻击", "6", nil, "manualskill", "0", "audio/skill/huanggai_manualskill.mp3", "1012", "131", "158", "131", },
    id_88 = {"于禁普通攻击", "0", nil, "attack", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_89 = {"于禁技能攻击", "5", nil, "skill", "0", "audio/skill/caiwenji_attack.mp3", "1012", "125", "0", "125", },
    id_90 = {"于禁能量攻击", "6", nil, "manualskill", "0", "audio/skill/yujin_manualskill.mp3", "1012", "131", "135", "131", },
    id_91 = {"弓兵普通攻击", "1", nil, "attack", "0", "audio/skill/taishici_attack.mp3", "1012", "164", "135", "0", },
    id_92 = {"弓兵技能攻击", "3", nil, "skill", "0", "audio/skill/taishici_attack.mp3", "1012", "164", "135", "0", },
    id_93 = {"弓兵能量攻击", "0", nil, "manualskill", "2", "audio/skill/taishici_skill.mp3", "1012", "0", "165", "0", },
    id_94 = {"徐晃普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_95 = {"徐晃技能攻击", "0", nil, "skill", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_96 = {"徐晃能量攻击", "0", nil, "manualskill", "0", "audio/skill/xuhuang_manualskill.mp3", "1012", "0", "135", "0", },
    id_97 = {"郭嘉普通攻击", "0", nil, "attack", "0", "audio/effect/shui_attack.mp3", "1012", "0", "167", "0", },
    id_98 = {"郭嘉技能攻击", "5", nil, "skill", "0", "audio/skill/guojia_skill.mp3", "1012", "166", "0", "0", },
    id_99 = {"郭嘉能量攻击", "0", nil, "manualskill", "0", "audio/skill/guojia_manualskill.mp3", "1012", "0", "135", "0", },
    id_100 = {"陆逊普通攻击", "0", nil, "attack", "0", "audio/skill/luxun_attack.mp3", "1012", "0", "135", "0", },
    id_101 = {"陆逊技能攻击", "14", nil, "skill", "0", "audio/skill/luxun_skill.mp3", "1012", "171", "170", "0", },
    id_102 = {"陆逊能量攻击", "4", nil, "manualskill", "0", "audio/skill/luxun_manualskill.mp3", "1012", "168", "169", "0", },
    id_103 = {"爪狼普通攻击", "0", nil, "attack", "0", "audio/skill/luxun_attack.mp3", "1007", "0", "135", "0", },
    id_104 = {"爪狼技能攻击", "0", nil, "skill", "0", "audio/skill/machao_skill.mp3", "1008", "0", "135", "0", },
    id_105 = {"爪狼能量攻击", "0", nil, "manualskill", "0", "audio/skill/zhualang_manualskill.mp3", "1009", "0", "135", "0", },
    id_106 = {"披甲象普通攻击", "0", nil, "attack", "0", "audio/skill/dongzhuo_attack.mp3", "1012", "0", "135", "0", },
    id_107 = {"披甲象技能攻击", "5", nil, "skill", "0", "audio/skill/pijiaxiang_skill.mp3", "1012", "138", "0", "138", },
    id_108 = {"披甲象能量攻击", "0", nil, "manualskill", "0", "audio/skill/pijiaxiang_manualskill.mp3", "1012", "0", "135", "0", },
    id_109 = {"医疗兵普通攻击", "1", nil, "attack", "0", "audio/effect/du_attack.mp3", "1007", "172", "173", "0", },
    id_110 = {"医疗兵技能攻击", "0", nil, "skill", "2", "audio/skill/caiwenji_attack.mp3", "1008", "0", "174", "0", },
    id_111 = {"医疗兵能量攻击", "0", nil, "manualskill", "0", "audio/skill/yiliaobing_manualskill.mp3", "1009", "0", "137", "0", },
    id_112 = {"吕蒙普通攻击", "0", nil, "attack", "0", "audio/skill/luxun_attack.mp3", "1012", "0", "135", "0", },
    id_113 = {"吕蒙技能攻击", "0", nil, "skill", "0", "audio/skill/lvmeng_skill.mp3", "1012", "0", "175", "0", },
    id_114 = {"吕蒙能量攻击", "0", nil, "manualskill", "0", "audio/skill/lvmeng_manualskill.mp3", "1012", "0", "175", "0", },
    id_115 = {"贾诩普通攻击", "0", nil, "attack", "0", "audio/skill/jiaxu_attack.mp3", "1012", "0", "135", "0", },
    id_116 = {"贾诩技能攻击", "1", nil, "skill", "0", "audio/skill/jiaxu_skill.mp3", "1012", "176", "117", "0", },
    id_117 = {"贾诩能量攻击", "0", nil, "manualskill", "0", "audio/skill/jiaxu_manualskill.mp3", "1012", "0", "177", "0", },
    id_118 = {"李儒普通攻击", "0", nil, "attack", "0", "audio/effect/zhang_attack.mp3", "1012", "0", "178", "0", },
    id_119 = {"李儒技能攻击", "0", nil, "skill", "0", "audio/skill/liru_skill.mp3", "1012", "0", "178", "0", },
    id_120 = {"李儒能量攻击", "0", nil, "manualskill", "1", "audio/skill/liru_manualskill.mp3", "1012", "0", "180", "0", },
    id_121 = {"高顺普通攻击", "0", nil, "attack", "0", "audio/skill/luxun_attack.mp3", "1012", "0", "135", "0", },
    id_122 = {"高顺技能攻击", "5", nil, "skill", "0", "audio/skill/liru_skill.mp3", "1012", "181", "0", "181", },
    id_123 = {"高顺能量攻击", "0", nil, "manualskill", "0", "audio/skill/gaoshun_manualskill.mp3", "1012", "0", "135", "0", },
    id_124 = {"鲁肃普通攻击", "1", nil, "attack", "0", "audio/effect/fire_attack.mp3", "1012", "182", "135", "0", },
    id_125 = {"鲁肃技能攻击", "1", nil, "skill", "0", "audio/effect/gushou_attack_dandao.mp3", "1012", "183", "185", "0", },
    id_126 = {"鲁肃能量攻击", "2", nil, "manualskill", "0", "audio/skill/lusu_manualskill.mp3", "1012", "184", "186", "0", },
    id_127 = {"陈宫普通攻击", "1", nil, "attack", "0", "audio/effect/du_attack.mp3", "1012", "188", "135", "0", },
    id_128 = {"陈宫技能攻击", "13", nil, "skill", "0", "audio/skill/jiaxu_skill.mp3", "1012", "187", "190", "189", },
    id_129 = {"陈宫能量攻击", "4", nil, "manualskill", "0", "audio/skill/chengong_manualskill.mp3", "1012", "192", "191", "0", },
    id_130 = {"刘备普通攻击", "6", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "131", "135", "131", },
    id_131 = {"刘备技能攻击", "8", nil, "skill", "0", "audio/skill/caiwenji_attack.mp3", "1012", "142", "142", "0", },
    id_132 = {"刘备能量攻击", "6", nil, "manualskill", "0", "audio/skill/liubei_manualskill.mp3", "1012", "131", "193", "131", },
    id_133 = {"华雄普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "231", "0", },
    id_134 = {"华雄技能攻击", "9", nil, "skill", "0", "audio/skill/caiwenji_attack.mp3", "1012", "138", "0", "0", },
    id_135 = {"华雄能量攻击", "0", nil, "manualskill", "0", "audio/skill/huaxiong_manualskill.mp3", "1012", "0", "232", "0", },
    id_136 = {"张辽普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_137 = {"张辽技能攻击", "0", nil, "skill", "0", "audio/skill/zhangliao_skill.mp3", "1012", "0", "233", "0", },
    id_138 = {"张辽能量攻击", "0", nil, "manualskill", "0", "audio/skill/zhangliao_manualskill.mp3", "1012", "0", "135", "0", },
    id_139 = {"周泰普通攻击", "0", nil, "attack", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_140 = {"周泰技能攻击", "0", nil, "skill", "0", "audio/effect/dao_attack.mp3", "1012", "0", "194", "0", },
    id_141 = {"周泰能量攻击", "0", nil, "manualskill", "0", "audio/skill/zhoutai_manualskill.mp3", "1012", "0", "195", "0", },
    id_142 = {"凌统普通攻击", "0", nil, "attack", "0", "audio/skill/lingtong_attack.mp3", "1012", "0", "135", "0", },
    id_143 = {"凌统技能攻击", "0", nil, "skill", "0", "audio/skill/lingtong_skill.mp3", "1012", "0", "135", "0", },
    id_144 = {"凌统能量攻击", "6", nil, "manualskill", "0", "audio/skill/lingtong_manualskill.mp3", "1012", "196", "197", "196", },
    id_145 = {"新小乔普通攻击", "1", nil, "attack", "0", "audio/skill/xiaoqiao_attack.mp3", "1012", "198", "135", "0", },
    id_146 = {"新小乔技能攻击", "0", nil, "skill", "0", "audio/skill/xiaoqiao_skill.mp3", "1012", "0", "199", "0", },
    id_147 = {"新小乔能量攻击", "0", nil, "manualskill", "0", "audio/skill/xiaoqiao_manualskill.mp3", "1012", "0", "200", "0", },
    id_148 = {"新大乔普通攻击", "1", nil, "attack", "0", "audio/effect/arrow_attack.mp3", "1012", "201", "117", "0", },
    id_149 = {"新大乔技能攻击", "1", nil, "skill", "0", "audio/skill/daqiao_skill.mp3", "1012", "202", "203", "0", },
    id_150 = {"新大乔能量攻击", "0", nil, "manualskill", "0", "audio/skill/daqiao_manualskill.mp3", "1012", "0", "204", "0", },
    id_151 = {"魏延普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_152 = {"魏延技能攻击", "0", nil, "skill", "0", "audio/skill/machao_skill.mp3", "1012", "0", "135", "0", },
    id_153 = {"魏延能量攻击", "0", nil, "manualskill", "0", "audio/skill/weiyan_manualskill.mp3", "1012", "0", "135", "0", },
    id_154 = {"许褚普通攻击", "0", nil, "attack", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_155 = {"许褚技能攻击", "0", nil, "skill", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_156 = {"许褚能量攻击", "0", nil, "manualskill", "0", "audio/skill/xuchu_manualskill.mp3", "1012", "0", "207", "0", },
    id_157 = {"夏侯惇普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_158 = {"夏侯惇技能攻击", "0", nil, "skill", "0", "audio/skill/xiahoudun_skill.mp3", "1012", "0", "135", "0", },
    id_159 = {"夏侯惇能量攻击", "0", nil, "manualskill", "0", "audio/skill/xiahoudun_manualskill.mp3", "1012", "0", "135", "0", },
    id_160 = {"黄月英普通攻击", "1", nil, "attack", "0", "audio/effect/arrow_attack.mp3", "1012", "208", "135", "0", },
    id_161 = {"黄月英技能攻击", "0", nil, "skill", "0", "audio/skill/huangyueying_skill.mp3", "1012", "0", "209", "0", },
    id_162 = {"黄月英能量攻击", "0", nil, "manualskill", "0", "audio/skill/huangyueying_manualskill.mp3", "1012", "0", "209", "0", },
    id_163 = {"袁绍普通攻击", "0", nil, "attack", "0", "audio/skill/luxun_attack.mp3", "1012", "0", "135", "0", },
    id_164 = {"袁绍技能攻击", "0", nil, "skill", "0", "audio/effect/dao_attack.mp3", "1012", "0", "210", "0", },
    id_165 = {"袁绍能量攻击", "0", nil, "manualskill", "0", "audio/skill/yuanshao_manualskill.mp3", "1012", "0", "211", "0", },
    id_166 = {"周瑜普通攻击", "1", nil, "attack", "0", "audio/effect/arrow_attack.mp3", "1012", "212", "135", "0", },
    id_167 = {"周瑜技能攻击", "1", nil, "skill", "0", "audio/skill/zhouyu_skill.mp3", "1012", "213", "214", "0", },
    id_168 = {"周瑜能量攻击", "0", nil, "manualskill", "0", "audio/skill/zhouyu_manualskill.mp3", "1012", "0", "215", "0", },
    id_169 = {"于吉普通攻击", "1", nil, "attack", "0", "audio/skill/simayi_attack.mp3", "1012", "216", "217", "0", },
    id_170 = {"于吉技能攻击", "0", nil, "skill", "0", "audio/skill/yuji_skill.mp3", "1012", "0", "218", "0", },
    id_171 = {"于吉能量攻击", "6", nil, "manualskill", "1", "audio/skill/yuji_manualskill.mp3", "1012", "131", "219", "131", },
    id_172 = {"司马懿普通攻击", "1", nil, "attack", "0", "audio/skill/simayi_attack.mp3", "1012", "220", "221", "0", },
    id_173 = {"司马懿技能攻击", "0", nil, "skill", "0", "audio/skill/simayi_skill.mp3", "1012", "0", "135", "0", },
    id_174 = {"司马懿能量攻击", "6", nil, "manualskill", "1", "audio/skill/simayi_manualskill.mp3", "1012", "131", "222", "131", },
    id_175 = {"孙权普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_176 = {"孙权技能攻击", "0", nil, "skill", "0", "audio/skill/sunquan_skill.mp3", "1012", "0", "135", "0", },
    id_177 = {"孙权能量攻击", "0", nil, "manualskill", "0", "audio/skill/sunquan_manualskill.mp3", "1012", "0", "135", "0", },
    id_178 = {"孙尚香普通攻击", "1", nil, "attack", "0", "audio/skill/taishici_attack.mp3", "1012", "223", "224", "0", },
    id_179 = {"孙尚香技能攻击", "1", nil, "skill", "0", "audio/skill/taishici_skill.mp3", "1012", "223", "224", "0", },
    id_180 = {"孙尚香能量攻击", "0", nil, "manualskill", "0", "audio/skill/sunshangxiang_manualskill.mp3", "1012", "0", "225", "0", },
    id_181 = {"甄姬普通攻击", "0", nil, "attack", "0", "audio/skill/zhenji_attack.mp3", "1012", "0", "135", "0", },
    id_182 = {"甄姬技能攻击", "0", nil, "skill", "0", "audio/skill/zhenji_skill.mp3", "1012", "0", "226", "0", },
    id_183 = {"甄姬能量攻击", "6", nil, "manualskill", "0", "audio/skill/zhenji_manualskill.mp3", "1012", "131", "227", "131", },
    id_184 = {"吼狮普通攻击", "0", nil, "attack", "0", "audio/skill/houshi_attack.mp3", "1012", "0", "135", "0", },
    id_185 = {"吼狮技能攻击", "0", nil, "skill", "0", "audio/skill/houshi_skill.mp3", "1012", "0", "135", "0", },
    id_186 = {"吼狮能量攻击", "0", nil, "manualskill", "0", "audio/skill/houshi_manualskill.mp3", "1012", "0", "135", "0", },
    id_187 = {"战豹普通攻击", "0", nil, "attack", "0", "audio/skill/houshi_attack.mp3", "1012", "0", "135", "0", },
    id_188 = {"战豹技能攻击", "0", nil, "skill", "0", "audio/skill/machao_skill.mp3", "1012", "0", "135", "0", },
    id_189 = {"战豹能量攻击", "0", nil, "manualskill", "0", "audio/skill/zhanbao_manualskill.mp3", "1012", "0", "135", "0", },
    id_190 = {"咒符熊普通攻击", "0", nil, "attack", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_191 = {"咒符熊技能攻击", "5", nil, "skill", "0", "audio/skill/fuzhouxiong_skill.mp3", "1012", "228", "0", "228", },
    id_192 = {"咒符熊能量攻击", "0", nil, "manualskill", "0", "audio/skill/fuzhouxiong_manualskill.mp3", "1012", "0", "135", "0", },
    id_193 = {"机关兵普通攻击", "0", nil, "attack", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_194 = {"机关兵技能攻击", "0", nil, "skill", "0", "audio/skill/jiguanbing_skill.mp3", "1012", "0", "135", "0", },
    id_195 = {"机关兵能量攻击", "0", nil, "manualskill", "0", "audio/skill/jiguanbing_manualskill.mp3", "1012", "0", "135", "0", },
    id_196 = {"机械怪普通攻击", "0", nil, "attack", "0", "audio/skill/jixieguai_attack.mp3", "1012", "0", "135", "0", },
    id_197 = {"机械怪技能攻击", "0", nil, "skill", "0", "audio/skill/jixieguai_skill.mp3", "1012", "0", "135", "0", },
    id_198 = {"机械怪能量攻击", "0", nil, "manualskill", "0", "audio/skill/jixieguai_manualskill.mp3", "1012", "0", "135", "0", },
    id_199 = {"轰炸机普通攻击", "0", nil, "attack", "0", "audio/skill/hongzhaji_attack.mp3", "1012", "0", "135", "0", },
    id_200 = {"轰炸机技能攻击", "0", nil, "skill", "0", "audio/skill/hongzhaji_skill.mp3", "1012", "0", "135", "0", },
    id_201 = {"轰炸机能量攻击", "1", nil, "manualskill", "0", "audio/skill/hongzhaji_manualskill.mp3", "1012", "229", "230", "0", },
    id_202 = {"挖掘机普通攻击", "0", nil, "attack", "0", "audio/effect/dao_hard_attack.mp3", "1012", "0", "135", "0", },
    id_203 = {"挖掘机技能攻击", "0", nil, "skill", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_204 = {"挖掘机能量攻击", "0", nil, "manualskill", "0", "audio/skill/dongzhuo_skill.mp3", "1012", "0", "135", "0", },
    id_205 = {"孟获普通攻击", "0", nil, "attack", "0", "audio/effect/dao_attack.mp3", "1012", "0", "135", "0", },
    id_206 = {"孟获机技能攻击", "9", nil, "skill", "0", "audio/skill/dunbing_manualskill.mp3", "1012", "234", "0", "0", },
    id_207 = {"孟获机能量攻击", "6", nil, "manualskill", "0", "audio/skill/menghuo_manualskill.mp3", "1012", "131", "135", "131", },
    id_208 = {"弩车普通攻击", "1", nil, "attack", "0", "audio/skill/taishici_attack.mp3", "1012", "235", "135", "0", },
    id_209 = {"弩车技能攻击", "1", nil, "skill", "0", "audio/skill/taishici_attack.mp3", "1012", "235", "135", "0", },
    id_210 = {"弩车能量攻击", "2", nil, "manualskill", "0", "audio/skill/taishici_skill.mp3", "1012", "242", "135", "0", },
    id_211 = {"马良普通攻击", "1", nil, "attack", "0", "audio/effect/zhang_attack.mp3", "1012", "236", "239", "0", },
    id_212 = {"马良技能攻击", "1", nil, "skill", "0", "audio/skill/dongzhuo_attack.mp3", "1012", "237", "240", "0", },
    id_213 = {"马良能量攻击", "6", nil, "manualskill", "0", "audio/skill/maliang_manualskill.mp3", "1012", "238", "241", "238", },
    id_214 = {"女巫普通攻击", "0", nil, "attack", "0", "audio/effect/zhang_attack.mp3", "1012", "0", "135", "0", },
    id_215 = {"女巫技能攻击", "9", nil, "skill", "0", "audio/skill/caiwenji_attack.mp3", "1012", "244", "135", "244", },
    id_216 = {"女巫能量攻击", "4", nil, "manualskill", "0", "audio/skill/jiaxu_skill.mp3", "1012", "192", "191", "0", },
}


function getDataById(key_id)
    local id_data = SkillDataTable["id_" .. key_id]
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

    for k, v in pairs(SkillDataTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return SkillDataTable
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

    for k, v in pairs(SkillDataTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["SkillData"] = nil
    package.loaded["SkillData"] = nil
end
