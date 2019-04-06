-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("EffectData", package.seeall)


keys = {
	"﻿id", "effectdes", "fileName", "EffectName", "AnimationID_0", "Audio_Animation_0", "speed", "sharder", "Scale", "effectzorder", "bindbone", "bonename", "bindAnimation", "fileName1", "EffectName1", "AnimationID_1", "effectzorder1", "bindbone1", "bonename1", "fileName2", "EffectName2", "AnimationID_2", "effectzorder2", "bindbone2", "bonename2", 
}

EffectDataTable = {
    id_1010 = {"女主角手动技能子弹", "Image/Fight/skill/nvzhu_zs_manualskill/nvzhu_zs_manualskill.ExportJson", "nvzhu_zs_manualskill", "0", "audio/effect/qiang_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1009 = {"女主角mj手动技能子弹", "Image/Fight/skill/nvzhu_zs_manualskill_2/nvzhu_zs_manualskill_2.ExportJson", "nvzhu_zs_manualskill_2", "0", "audio/effect/qiang_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1008 = {"女主角bz手动技能子弹", "Image/Fight/skill/nvzhu_zs_manualskill_3/nvzhu_zs_manualskill_3.ExportJson", "nvzhu_zs_manualskill_3", "0", "audio/effect/qiang_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1011 = {"女主角自动技能 盾吸", "Image/Fight/skill/nvzhu_zs_skill01/nvzhu_zs_skill01.ExportJson", "nvzhu_zs_skill01", "0", "audio/effect/nanzhu_zs_skill_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1021 = {"女主角mj自动技能 盾吸", "Image/Fight/skill/nvzhu_mj_skill01/nvzhu_mj_skill01.ExportJson", "nvzhu_mj_skill01", "0", "audio/effect/nanzhu_zs_skill_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1031 = {"女主角bz自动技能 盾吸", "Image/Fight/skill/nvzhu_bz_skill01/nvzhu_bz_skill01.ExportJson", "nvzhu_bz_skill01", "0", "audio/effect/nanzhu_zs_skill_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1012 = {"女主角ms火球特效", "Image/Fight/skill/nvzhu_ms_attack/nvzhu_ms_attack.ExportJson", "nvzhu_ms_attack", "0", "audio/effect/fire_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1022 = {"女主角cs火球特效", "Image/Fight/skill/nanzhu_cs_dandao/nanzhu_cs_dandao.ExportJson", "nanzhu_cs_dandao", "0", "audio/effect/fire_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1032 = {"女主角ts火球特效", "Image/Fight/skill/skill_bullet_nanzhu_ts/skill_bullet_nanzhu_ts.ExportJson", "skill_bullet_nanzhu_ts", "0", "audio/effect/fire_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1013 = {"女主角ms手动火球特效", "Image/Fight/skill/nvzhu_ms_attack/nvzhu_ms_attack.ExportJson", "nvzhu_ms_attack", "0", "audio/effect/fire_attack.mp3", "1000", "0", "2", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1023 = {"女主角cs手动火球特效", "Image/Fight/skill/manualskill_bullet_nanzhu_cs/manualskill_bullet_nanzhu_cs.ExportJson", "manualskill_bullet_nanzhu_cs", "0", "audio/effect/fire_attack.mp3", "1000", "0", "2", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1033 = {"女主角ts手动火球特效", "Image/Fight/skill/manualskill_fireball_nanzhu_ts/manualskill_fireball_nanzhu_ts.ExportJson", "manualskill_fireball_nanzhu_ts", "0", "audio/effect/fire_attack.mp3", "1000", "0", "2", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1014 = {"女主角gs 普通攻击子弹", "Image/Fight/skill/nvzhu_gs_attack/nvzhu_gs_attack.ExportJson", "nvzhu_gs_attack", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1015 = {"女主角gs 手动攻击子弹", "Image/Fight/skill/nvzhu_gs_manualskill/nvzhu_gs_manualskill.ExportJson", "nvzhu_gs_manualskill", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1025 = {"女主角fy 手动攻击子弹", "Image/Fight/skill/manualskill_bullet_nanzhu_fy/manualskill_bullet_nanzhu_fy.ExportJson", "manualskill_bullet_nanzhu_fy", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1035 = {"女主角ly 手动攻击子弹", "Image/Fight/skill/manualskill_bullet_nanzhu_fy/manualskill_bullet_nanzhu_fy.ExportJson", "manualskill_bullet_nanzhu_fy", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1026 = {"女主角fy 自动攻击子弹", "Image/Fight/skill/bullet_nanzhu_fy/bullet_nanzhu_fy.ExportJson", "bullet_nanzhu_fy", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1036 = {"女主角ly 自动攻击子弹", "Image/Fight/skill/bullet_nanzhu_ly/bullet_nanzhu_ly.ExportJson", "bullet_nanzhu_ly", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1020 = {"男主角手动技能子弹", "Image/Fight/skill/nanzhu_zs_manualskill/nanzhu_zs_manualskill.ExportJson", "nanzhu_zs_manualskill", "0", "audio/effect/qiang_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_2 = {"男主角cs手动被打", "Image/Fight/skill/manualskill_hitted_nanzhu_cs/manualskill_hitted_nanzhu_cs.ExportJson", "manualskill_hitted_nanzhu_cs", "0", "audio/effect/zhurong_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_3 = {"男主角ts自动技能被打", "Image/Fight/skill/skill_hitted_nanzhu_ts/skill_hitted_nanzhu_ts.ExportJson", "skill_hitted_nanzhu_ts", "0", "audio/effect/zhurong_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_4 = {"男主角ts手动技能被打", "Image/Fight/skill/manualskill_hitted_nanzhu_ts/manualskill_hitted_nanzhu_ts.ExportJson", "manualskill_hitted_nanzhu_ts", "0", "audio/effect/zhurong_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_1 = {"选中光圈特效", "Image/Fight/skill/xuanzhong_guangquan001/xuanzhong_guangquan001.ExportJson", "xuanzhong_guangquan001", "0", "audio/effect/zhiliao_buff.mp3", "1000", "0", "1", "-1", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_15 = {"回血", "Image/Fight/skill/buff_huixue001/buff_huixue001.ExportJson", "buff_huixue001", "0", "audio/effect/zhiliao_buff.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_100 = {"ganning_hitted", "Image/Fight/skill/ganning_hitted/ganning_hitted.ExportJson", "ganning_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_101 = {"ganning_skill(子弹)", "Image/Fight/skill/ganning_skill/ganning_skill.ExportJson", "ganning_skill", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "2", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_102 = {"ganning_manualskill（子弹）", "Image/Fight/skill/ganning_manualskill/ganning_manualskill.ExportJson", "ganning_manualskill", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "2", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_103 = {"lvbu_hitted（被打）", "Image/Fight/skill/lvbu_hitted/lvbu_hitted.ExportJson", "lvbu_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_104 = {"lvbu_manualskill（被打）", "Image/Fight/skill/lvbu_hitted/lvbu_hitted.ExportJson", "lvbu_hitted", "0", "audio/effect/lvbu_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", "Image/Fight/skill/lvbu_manualskill01/lvbu_manualskill01.ExportJson", "lvbu_manualskill01", "0", "0", "0", nil, "Image/Fight/skill/lvbu_manualskill02/lvbu_manualskill02.ExportJson", "lvbu_manualskill02", "0", "-1", "0", nil, },
    id_105 = {"ganning_attack(子弹)", "Image/Fight/skill/ganning_attack/ganning_attack.ExportJson", "ganning_attack", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "2", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_106 = {"zhaoyun_hitted", "Image/Fight/skill/zhaoyun_hitted/zhaoyun_hitted.ExportJson", "zhaoyun_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_107 = {"zhaoyun_skill(子弹)", "Image/Fight/skill/zhaoyun_skill/zhaoyun_skill.ExportJson", "zhaoyun_skill", "0", "audio/effect/zhaoyun_skill_dandao.mp3", "500", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_108 = {"zhaoyun_manualskill（子弹）", "Image/Fight/skill/zhaoyun_manualskill/zhaoyun_manualskill.ExportJson", "zhaoyun_manualskill", "0", "audio/effect/zhaoyun_manualskill_dandao.mp3", "1000", "0", "1", "0", "3", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_109 = {"zhaoyun_hitted(2倍)", "Image/Fight/skill/zhaoyun_hitted/zhaoyun_hitted.ExportJson", "zhaoyun_hitted", "0", "audio/effect/gushou_attack_dandao.mp3", "1000", "0", "2", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_110 = {"toushiche_attack001（投石车普通攻击子弹）", "Image/Fight/skill/toushiche_attack001/toushiche_attack001.ExportJson", "toushiche_attack001", "0", "audio/effect/qiang_attack.mp3", "700", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_111 = {"toushiche_skill001(投石车技能子弹)", "Image/Fight/skill/toushiche_skill001/toushiche_skill001.ExportJson", "toushiche_skill001", "0", "audio/effect/qiang_attack.mp3", "700", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_112 = {"toushiche_hitted（普通被打）", "Image/Fight/skill/toushiche_hitted/toushiche_hitted.ExportJson", "toushiche_hitted", "0", "audio/effect/dao_hard_attack.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_113 = {"toushiche_hitted002（技能被打）", "Image/Fight/skill/toushiche_hitted002/toushiche_hitted002.ExportJson", "toushiche_hitted002", "0", "audio/effect/dao_hard_attack.mp3", "1000", "0", "1", "-1", "0", nil, "0", "Image/Fight/skill/toushiche_hitted002_01/toushiche_hitted002_01.ExportJson", "toushiche_hitted002_01", "0", "0", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_114 = {"yanlong（普通技能被打被打）", "Image/Fight/skill/yanlong_hitted001_02/yanlong_hitted001_02.ExportJson", "yanlong_hitted001_02", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "0", nil, "1", "Image/Fight/skill/yanlong_hitted001_01/yanlong_hitted001_01.ExportJson", "yanlong_hitted001_01", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_115 = {"yanlong_attack001(普通攻击子弹)", "Image/Fight/skill/yanlong_attack001/yanlong_attack001.ExportJson", "yanlong_attack001", "0", "audio/effect/fire_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_116 = {"yanlong（技能被打被打）", "Image/Fight/skill/yanlong_hitted002_01/yanlong_hitted002_01.ExportJson", "yanlong_hitted002_01", "0", "audio/effect/fire_attack.mp3", "1000", "0", "1", "-1", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_117 = {"貂蝉被打特效", "Image/Fight/skill/diaochan_hitted001/diaochan_hitted001.ExportJson", "diaochan_hitted001", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_118 = {"yanlong技能特效buff", "Image/Fight/skill/yanlong_hitted002_02/yanlong_hitted002_02.ExportJson", "yanlong_hitted002_02", "0", "audio/effect/nengliang.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_119 = {"yanlong手动技能被打特效", "Image/Fight/skill/yanlong_hitted003/yanlong_hitted003.ExportJson", "yanlong_hitted003", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_120 = {"貂蝉子弹普通攻击(子弹)", "Image/Fight/skill/diaochan_attack/diaochan_attack.ExportJson", "diaochan_attack", "0", "audio/effect/gushou_attack_dandao.mp3", "600", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_121 = {"貂蝉手动被击", "Image/Fight/skill/zhaoyun_hitted/zhaoyun_hitted.ExportJson", "zhaoyun_hitted", "0", "audio/effect/diaochan_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_122 = {"貂蝉手动循环buff", "Image/Fight/skill/diaochan_hitted003_01/diaochan_hitted003_01.ExportJson", "diaochan_hitted003_01", "0", "audio/effect/diaochan_manualskill_hitted.mp3", "1000", "5", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_123 = {"赵云手动技能被击", "Image/Fight/skill/zhaoyun_hitted03_01/zhaoyun_hitted03_01.ExportJson", "zhaoyun_hitted03_01", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_124 = {"貂蝉手动循环buff(不带特效的)", nil, nil, "0", "audio/effect/diaochan_manualskill_hitted.mp3", "1000", "5", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_125 = {"盾兵手动技能特效（buff）头顶", "Image/Fight/skill/dunbing_manualskill/dunbing_manualskill.ExportJson", "dunbing_manualskill", "0", "audio/effect/jiadun_buff.mp3", "1000", "0", "1", "0", "6", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_126 = {"盾兵 骑兵 技能被打特效", "Image/Fight/skill/qiangbing_attack001/qiangbing_attack001.ExportJson", "qiangbing_attack001", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_127 = {"关羽技能被击特效", "Image/Fight/skill/guanyu_hitted001/guanyu_hitted001.ExportJson", "guanyu_hitted001", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_128 = {"蒲扇兵子弹特效", "Image/Fight/skill/pushanbing_bullet001/pushanbing_bullet001.ExportJson", "pushanbing_bullet001", "0", "audio/effect/lei_attack.mp3", "500", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_129 = {"蒲扇兵普通被击特效", "Image/Fight/skill/pushanbing_hitted001/pushanbing_hitted001.ExportJson", "pushanbing_hitted001", "0", "audio/effect/dongzhuo_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_130 = {"蒲扇兵技能 手动技能 被击特效", "Image/Fight/skill/pushanbing_skill001/pushanbing_skill001.ExportJson", "pushanbing_skill001", "0", "audio/effect/zhugeliang_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_131 = {"马超技能眩晕特效 buff", "Image/Fight/skill/machao_buff001/machao_buff001.ExportJson", "machao_buff001", "0", "audio/effect/yun_buff.mp3", "1000", "0", "1", "0", "6", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_132 = {"马超技能 被击特效特效 ", "Image/Fight/skill/machao_hitted001/machao_hitted001.ExportJson", "machao_hitted001", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_133 = {"护法龙被打特效", "Image/Fight/skill/hufalong_hitted001/hufalong_hitted001.ExportJson", "hufalong_hitted001", "0", "audio/effect/zhurong_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_134 = {"鼓手子弹普通攻击(子弹)", "Image/Fight/skill/gushou_attack001/gushou_attack001.ExportJson", "gushou_attack001", "0", "audio/effect/gushou_attack_dandao.mp3", "600", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_135 = {"鼓手技能被击特效", "Image/Fight/skill/gushou_hitted001/gushou_hitted001.ExportJson", "gushou_hitted001", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_136 = {"鼓手手动技能加怒气特效 怒气通用特效", "Image/Fight/skill/gushou_hitted03/gushou_hitted03.ExportJson", "gushou_hitted03", "0", "audio/effect/nengliang_buff.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_137 = {"华佗加血技能特效 （被打）", "Image/Fight/skill/huatuo_skill01/huatuo_skill01.ExportJson", "huatuo_skill01", "0", "audio/effect/zhiliao_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/huatuo_skill01_02/huatuo_skill01_02.ExportJson", "huatuo_skill01_02", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_138 = {"华佗加盾特效 （buff）", "Image/Fight/skill/huatuo_skill02_01/huatuo_skill02_01.ExportJson", "huatuo_skill02_01", "0", "audio/effect/jiadun_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/huatuo_skill02_02/huatuo_skill02_02.ExportJson", "huatuo_skill02_02", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_139 = {"曹仁加盾特效 （buff）", "Image/Fight/skill/caoren_skill02_01/caoren_skill02_01.ExportJson", "caoren_skill02_01", "0", "audio/effect/jiadun_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/caoren_skill02_02/caoren_skill02_02.ExportJson", "caoren_skill02_02", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_140 = {"典韦 手动技能 被击特效", "Image/Fight/skill/dianwei_hitted03/dianwei_hitted03.ExportJson", "dianwei_hitted03", "0", "audio/effect/dianwei_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_141 = {"诸葛亮attack(子弹)贴地", "Image/Fight/skill/zhugeliangattack/zhugeliangattack.ExportJson", "zhugeliangattack", "0", "audio/effect/lei_attack.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_142 = {"诸葛亮skill （buff）", "Image/Fight/skill/zhugeliangbuff01/zhugeliangbuff01.ExportJson", "zhugeliangbuff01", "0", "audio/effect/nengliang_buff.mp3", "1000", "0", "1", "-1", "0", nil, "1", "Image/Fight/skill/zhugeliangbuff02/zhugeliangbuff02.ExportJson", "zhugeliangbuff02", "0", "0", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_143 = {"小乔攻击(子弹)", "Image/Fight/skill/xiaoqiao_attack/xiaoqiao_attack.ExportJson", "xiaoqiao_attack", "0", "audio/effect/du_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_144 = {"小乔技能被击特效", "Image/Fight/skill/hitted_xiaoqiao/hitted_xiaoqiao.ExportJson", "hitted_xiaoqiao", "0", "audio/effect/nengliang_buff.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_145 = {"小乔手动技能 （buff）", "Image/Fight/skill/buff_manualskill01_xiaoqiao/buff_manualskill01_xiaoqiao.ExportJson", "buff_manualskill01_xiaoqiao", "0", "audio/effect/ganfuren_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/buff_manualskill02_xiaoqiao/buff_manualskill02_xiaoqiao.ExportJson", "buff_manualskill02_xiaoqiao", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_146 = {"大乔普通技能 （buff）", "Image/Fight/skill/daqiao_buff01/daqiao_buff01.ExportJson", "daqiao_buff01", "0", "audio/effect/nengliang_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/daqiao_buff02/daqiao_buff02.ExportJson", "daqiao_buff02", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_147 = {"大乔加盾技能 （buff）", "Image/Fight/skill/daqiao_skill02_01/daqiao_skill02_01.ExportJson", "daqiao_skill02_01", "0", "audio/effect/jiadun_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/daqiao_skill02_02/daqiao_skill02_02.ExportJson", "daqiao_skill02_02", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_148 = {"祝融普通攻击(子弹)", "Image/Fight/skill/zhurong_attack/zhurong_attack.ExportJson", "zhurong_attack", "0", "audio/effect/feidao_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_149 = {"祝融自动技能(子弹)", "Image/Fight/skill/zhurong_skill/zhurong_skill.ExportJson", "zhurong_skill", "0", "audio/effect/feidao_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_150 = {"祝融自动技能被打", "Image/Fight/skill/zhurong_skillhitted/zhurong_skillhitted.ExportJson", "zhurong_skillhitted", "0", "audio/effect/zhurong_skill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_151 = {"祝融自动技能Buff", "Image/Fight/skill/buff_chixudiaoxue_zhurong/buff_chixudiaoxue_zhurong.ExportJson", "buff_chixudiaoxue_zhurong", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_152 = {"祝融手动技能被打", "Image/Fight/skill/zhurong_manualskill/zhurong_manualskill.ExportJson", "zhurong_manualskill", "0", "audio/effect/zhurong_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_153 = {"马超技能 skill被击特效特效 ", "Image/Fight/skill/machao_skill01/machao_skill01.ExportJson", "machao_skill01", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "-1", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_154 = {"董卓自动攻击子弹", "Image/Fight/skill/dongzhuo_bullet/dongzhuo_bullet.ExportJson", "dongzhuo_bullet", "0", "audio/effect/lei_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_155 = {"董卓技能被击特效", "Image/Fight/skill/dongzhuo_hitted/dongzhuo_hitted.ExportJson", "dongzhuo_hitted", "0", "audio/effect/dongzhuo_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_156 = {"太史慈自动攻击子弹", "Image/Fight/skill/skill_taishici/skill_taishici.ExportJson", "skill_taishici", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_157 = {"太史慈_manualskill（被打）", "Image/Fight/skill/manualskill_hitted_taishici/manualskill_hitted_taishici.ExportJson", "manualskill_hitted_taishici", "0", "audio/effect/taishici_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", "Image/Fight/skill/manualskill_hitted01_taishici/manualskill_hitted01_taishici.ExportJson", "manualskill_hitted01_taishici", "0", "-1", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_158 = {"黄盖被击特效", "Image/Fight/skill/huanggai_hitted/huanggai_hitted.ExportJson", "huanggai_hitted", "0", "audio/effect/huanggai_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_159 = {"张角攻击子弹", "Image/Fight/skill/zhangjiao_attack/zhangjiao_attack.ExportJson", "zhangjiao_attack", "0", "audio/effect/lei_attack.mp3", "10", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_160 = {"张郃攻击子弹", "Image/Fight/skill/zhanghe_attack/zhanghe_attack.ExportJson", "zhanghe_attack", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_161 = {"张郃被击特效", "Image/Fight/skill/huanggai_hitted/huanggai_hitted.ExportJson", "huanggai_hitted", "0", "audio/effect/zhanghe_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", "Image/Fight/skill/zhanghe_manualskill/zhanghe_manualskill.ExportJson", "zhanghe_manualskill", "0", "0", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_162 = {"张角自动 被击特效", "Image/Fight/skill/zhangjiao_skill/zhangjiao_skill.ExportJson", "zhangjiao_skill", "0", "audio/effect/dongzhuo_skill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_163 = {"张角手动动 被击特效", "Image/Fight/skill/gushou_hitted001/gushou_hitted001.ExportJson", "gushou_hitted001", "0", "audio/effect/zhangjiao_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", "Image/Fight/skill/zhangjiao_manualskill/zhangjiao_manualskill.ExportJson", "zhangjiao_manualskill", "0", "0", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_164 = {"弓兵攻击子弹", "Image/Fight/skill/attack_gongjianbing/attack_gongjianbing.ExportJson", "attack_gongjianbing", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_165 = {"弓兵_manualskill（被打）", "Image/Fight/skill/manualskill_hittde02_gongjianbing/manualskill_hittde02_gongjianbing.ExportJson", "manualskill_hittde02_gongjianbing", "0", "audio/effect/dianwei_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", "Image/Fight/skill/manualskill_hittde01_gongjianbing/manualskill_hittde01_gongjianbing.ExportJson", "manualskill_hittde01_gongjianbing", "0", "-1", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_166 = {"郭嘉自动技能 （buff）", "Image/Fight/skill/guojia_skill_hitted/guojia_skill_hitted.ExportJson", "guojia_skill_hitted", "0", "audio/effect/nengliang_buff.mp3", "1000", "0", "1", "0", "0", "jiaoxia", "1", "Image/Fight/skill/goujia_skill_buff/goujia_skill_buff.ExportJson", "goujia_skill_buff", "0", "0", "6", nil, nil, nil, nil, nil, nil, nil, },
    id_167 = {"郭嘉普通 被击特效", "Image/Fight/skill/guojia_attack_hitted/guojia_attack_hitted.ExportJson", "guojia_attack_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_168 = {"陆逊手动被击（buff）", "Image/Fight/skill/luxun_manualskill_buff/luxun_manualskill_buff.ExportJson", "luxun_manualskill_buff", "0", "audio/effect/fire_attack.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_169 = {"陆逊手动被击特效", "Image/Fight/skill/luxun_manualskill_beiji/luxun_manualskill_beiji.ExportJson", "luxun_manualskill_beiji", "0", "audio/effect/luxun_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_170 = {"陆逊自动被击特效", "Image/Fight/skill/luxun_skill_beiji/luxun_skill_beiji.ExportJson", "luxun_skill_beiji", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_171 = {"陆逊自动攻击(子弹)", "Image/Fight/skill/luxun_skill_dandao/luxun_skill_dandao.ExportJson", "luxun_skill_dandao", "0", "audio/effect/fire_attack.mp3", "2000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_172 = {"医疗兵子弹普通攻击(子弹)", "Image/Fight/skill/bullet_yiliaobing/bullet_yiliaobing.ExportJson", "bullet_yiliaobing", "0", "audio/effect/du_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_173 = {"医疗兵普通 被击特效", "Image/Fight/skill/hitted_yiliaobing/hitted_yiliaobing.ExportJson", "hitted_yiliaobing", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_174 = {"医疗兵加血技能特效 （被打）", "Image/Fight/skill/skill01_yiliaobing/skill01_yiliaobing.ExportJson", "skill01_yiliaobing", "0", "audio/effect/zhiliao_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/skill02_yiliaobing/skill02_yiliaobing.ExportJson", "skill02_yiliaobing", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_175 = {"吕蒙技能被击特效", "Image/Fight/skill/lvmeng_skill_hitted/lvmeng_skill_hitted.ExportJson", "lvmeng_skill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_176 = {"贾诩子弹普通攻击(子弹)", "Image/Fight/skill/jiaxu_skill_dandao/jiaxu_skill_dandao.ExportJson", "jiaxu_skill_dandao", "0", "audio/effect/fire_attack.mp3", "800", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_177 = {"贾诩手动技能被击特效", "Image/Fight/skill/jiaxu_manualskill_hitted/jiaxu_manualskill_hitted.ExportJson", "jiaxu_manualskill_hitted", "0", "audio/effect/jiaxu_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_178 = {"李儒普通攻击被击特效", "Image/Fight/skill/liru_attack_hitted/liru_attack_hitted.ExportJson", "liru_attack_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_179 = {"李儒skill技能 （buff）", "Image/Fight/skill/liru_skill_buff/liru_skill_buff.ExportJson", "liru_skill_buff", "0", "audio/effect/jiaxu_manualskill_hitted.mp3", "1000", "0", "1", "0", "6", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_180 = {"李儒_manualskill（被打）", "Image/Fight/skill/liru_manualskill/liru_manualskill.ExportJson", "liru_manualskill", "0", "audio/effect/liru_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_181 = {"高顺skill技能 （buff）", "Image/Fight/skill/gaoshun_skill_buff/gaoshun_skill_buff.ExportJson", "gaoshun_skill_buff", "0", "audio/effect/nengliang_buff.mp3", "1000", "0", "1", "0", "6", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_182 = {"鲁肃子弹普通攻击(子弹)", "Image/Fight/skill/lusu_attack_dandao/lusu_attack_dandao.ExportJson", "lusu_attack_dandao", "0", "audio/effect/fire_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_183 = {"鲁肃子弹skill攻击(子弹)", "Image/Fight/skill/lusu_skill_dandao/lusu_skill_dandao.ExportJson", "lusu_skill_dandao", "0", "audio/effect/gushou_attack_dandao.mp3", "600", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_184 = {"鲁肃子弹手动攻击(子弹)", "Image/Fight/skill/lusu_manualskill_dandao/lusu_manualskill_dandao.ExportJson", "lusu_manualskill_dandao", "0", "audio/effect/dao_hard_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_185 = {"鲁肃skill（被打）", "Image/Fight/skill/lusu_skill_hitted/lusu_skill_hitted.ExportJson", "lusu_skill_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_186 = {"鲁肃_manualskill（被打）", "Image/Fight/skill/lusu_manualskill__hitted/lusu_manualskill__hitted.ExportJson", "lusu_manualskill__hitted", "0", "audio/effect/zhurong_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", "Image/Fight/skill/lusu_manualskill_hitted_dimian/lusu_manualskill_hitted_dimian.ExportJson", "lusu_manualskill_hitted_dimian", "0", "-1", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_187 = {"陈宫子弹skill攻击(子弹)", "Image/Fight/skill/chengong_skill_dandao/chengong_skill_dandao.ExportJson", "chengong_skill_dandao", "0", "audio/effect/du_attack.mp3", "24", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_188 = {"陈宫子弹普通攻击(子弹)", "Image/Fight/skill/chengong_attack_dandao/chengong_attack_dandao.ExportJson", "chengong_attack_dandao", "0", "audio/effect/du_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_189 = {"陈宫skill技能 （buff）", "Image/Fight/skill/chengong_skill_buff/chengong_skill_buff.ExportJson", "chengong_skill_buff", "0", "audio/effect/zuzhou_buff.mp3", "1000", "0", "1", "0", "6", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_190 = {"陈宫skill技能被击特效", "Image/Fight/skill/chengong_skill_hitted/chengong_skill_hitted.ExportJson", "chengong_skill_hitted", "0", "audio/effect/chengong_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_191 = {"陈宫_manualskill（被打）", "Image/Fight/skill/chengong_manualskill_hitted/chengong_manualskill_hitted.ExportJson", "chengong_manualskill_hitted", "0", "audio/effect/chengong_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_192 = {"陈宫_manualskill（buff）", "Image/Fight/skill/chengong_manualskill_buff/chengong_manualskill_buff.ExportJson", "chengong_manualskill_buff", "0", "audio/effect/zuzhou_buff.mp3", "1000", "0", "1", "0", "1", nil, "1", "Image/Fight/skill/chengong_manualskill_buff_1/chengong_manualskill_buff_1.ExportJson", "chengong_manualskill_buff_1", "0", "-1", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_193 = {"刘备手动技能被击特效", "Image/Fight/skill/liubei_manualskill_hitted/liubei_manualskill_hitted.ExportJson", "liubei_manualskill_hitted", "0", "audio/effect/dao_hard_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_194 = {"周泰skill技能被击特效", "Image/Fight/skill/zhoutai_skill_hitted/zhoutai_skill_hitted.ExportJson", "zhoutai_skill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_195 = {"周泰手动技能被击特效", "Image/Fight/skill/zhoutai_manualskill_hitted/zhoutai_manualskill_hitted.ExportJson", "zhoutai_manualskill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_196 = {"凌统手动技能特效 （buff）", "Image/Fight/skill/lingtong_manualskill_dot/lingtong_manualskill_dot.ExportJson", "lingtong_manualskill_dot", "0", "audio/effect/lingtong_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", "Image/Fight/skill/caoren_skill02_02/caoren_skill02_02.ExportJson", "caoren_skill02_02", "0", "-1", "0", "jiaoxia", nil, nil, nil, nil, nil, nil, },
    id_197 = {"凌统手动技能被击特效", "Image/Fight/skill/lingtong_manualskill_hitted/lingtong_manualskill_hitted.ExportJson", "lingtong_manualskill_hitted", "0", "audio/effect/lingtong_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_198 = {"新小乔普通攻击（子弹）", "Image/Fight/skill/xiaoqiao01_attack_dandao/xiaoqiao01_attack_dandao.ExportJson", "xiaoqiao01_attack_dandao", "0", "audio/effect/du_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_199 = {"新小乔skill技能被击特效", "Image/Fight/skill/xiaoqiao01_skill_hitted/xiaoqiao01_skill_hitted.ExportJson", "xiaoqiao01_skill_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_200 = {"新小乔手动技能被击特效", "Image/Fight/skill/xiaoqiao01_manualskill_hitted/xiaoqiao01_manualskill_hitted.ExportJson", "xiaoqiao01_manualskill_hitted", "0", "audio/effect/xiaoqiao_manualskill_hitted.mp4", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_201 = {"新大桥乔普通攻击（子弹）", "Image/Fight/skill/daqiaoNew_attack_dandao/daqiaoNew_attack_dandao.ExportJson", "daqiaoNew_attack_dandao", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_202 = {"新大乔skill（子弹）", "Image/Fight/skill/daqiaoNew_skill_dandao/daqiaoNew_skill_dandao.ExportJson", "daqiaoNew_skill_dandao", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_203 = {"新大乔skill技能被击特效", "Image/Fight/skill/daqiaoNew_skill_hitted/daqiaoNew_skill_hitted.ExportJson", "daqiaoNew_skill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_204 = {"新大乔手动技能被击特效", "Image/Fight/skill/daqiaoNew_manualskill_hitted/daqiaoNew_manualskill_hitted.ExportJson", "daqiaoNew_manualskill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_205 = {"护法女神技能被击特效", "Image/Fight/skill/hufanvshen_attatk_hitted/hufanvshen_attatk_hitted.ExportJson", "hufanvshen_attatk_hitted", "0", "audio/effect/hufanvshen_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_206 = {"护法男神技能被击特效", "Image/Fight/skill/hufananshen_attack_hitted/hufananshen_attack_hitted.ExportJson", "hufananshen_attack_hitted", "0", "audio/effect/zhurong_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_207 = {"许褚手动技能被击特效", "Image/Fight/skill/xuchu_manualskill_hitted/xuchu_manualskill_hitted.ExportJson", "xuchu_manualskill_hitted", "0", "audio/effect/zhurong_manualskill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_208 = {"黄月英普通攻击（子弹）", "Image/Fight/skill/huangyueying_attack_dandao/huangyueying_attack_dandao.ExportJson", "huangyueying_attack_dandao", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_209 = {"黄月英被击特效", "Image/Fight/skill/huangyueying_hitted/huangyueying_hitted.ExportJson", "huangyueying_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_210 = {"袁绍skill被击特效", "Image/Fight/skill/yuanshao_skill_hitted/yuanshao_skill_hitted.ExportJson", "yuanshao_skill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_211 = {"袁绍手动技能被击特效", "Image/Fight/skill/yuanshao_manuakskill_hitted/yuanshao_manuakskill_hitted.ExportJson", "yuanshao_manuakskill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_212 = {"周瑜英普通攻击（子弹）", "Image/Fight/skill/zhouyu_attack_dandao/zhouyu_attack_dandao.ExportJson", "zhouyu_attack_dandao", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_213 = {"周瑜skill攻击（子弹）", "Image/Fight/skill/zhouyu_skill_dandao/zhouyu_skill_dandao.ExportJson", "zhouyu_skill_dandao", "0", "audio/effect/arrow_attack.mp3", "10", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_214 = {"周瑜skill技能被击特效", "Image/Fight/skill/zhouyu_skill_hitted/zhouyu_skill_hitted.ExportJson", "zhouyu_skill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_215 = {"周瑜手动技能被击特效", "Image/Fight/skill/zhouyu_manualskill_hitted/zhouyu_manualskill_hitted.ExportJson", "zhouyu_manualskill_hitted", "0", "audio/effect/zhouyu_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_216 = {"于吉攻击（子弹）", "Image/Fight/skill/yuji_attack_dandao/yuji_attack_dandao.ExportJson", "yuji_attack_dandao", "0", "audio/effect/du_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_217 = {"于吉普通技能被击特效", "Image/Fight/skill/yuji_attack_hitted/yuji_attack_hitted.ExportJson", "yuji_attack_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_218 = {"于吉skill技能被击特效", "Image/Fight/skill/yuji_skill_hitted/yuji_skill_hitted.ExportJson", "yuji_skill_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_219 = {"于吉手动技能被击特效", "Image/Fight/skill/yuji_manualskill_hitted/yuji_manualskill_hitted.ExportJson", "yuji_manualskill_hitted", "0", "audio/effect/yuji_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_220 = {"司马懿攻击（子弹）", "Image/Fight/skill/simayi_attack_dandao/simayi_attack_dandao.ExportJson", "simayi_attack_dandao", "0", "audio/effect/du_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_221 = {"司马懿普通技能被击特效", "Image/Fight/skill/simayi_attack_hitted/simayi_attack_hitted.ExportJson", "simayi_attack_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_222 = {"司马懿手动技能被击特效", "Image/Fight/skill/simayi_manualskill_hitted/simayi_manualskill_hitted.ExportJson", "simayi_manualskill_hitted", "0", "audio/effect/lvbu_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_223 = {"孙尚香攻击（子弹）", "Image/Fight/skill/sunshangxiang_skill_dandao/sunshangxiang_skill_dandao.ExportJson", "sunshangxiang_skill_dandao", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_224 = {"孙尚香普通技能被击特效", "Image/Fight/skill/sunshangxiang_skill_hitted/sunshangxiang_skill_hitted.ExportJson", "sunshangxiang_skill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_225 = {"孙尚香手动技能被击特效", "Image/Fight/skill/sunshangxiang_manualskill_hitted/sunshangxiang_manualskill_hitted.ExportJson", "sunshangxiang_manualskill_hitted", "0", "audio/effect/zhurong_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", "Image/Fight/skill/sunshangxiang_manualskill_hitted1/sunshangxiang_manualskill_hitted1.ExportJson", "sunshangxiang_manualskill_hitted1", "0", "-1", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_226 = {"甄姬skill技能被击特效", "Image/Fight/skill/zhenji_skill_hitted/zhenji_skill_hitted.ExportJson", "zhenji_skill_hitted", "0", "audio/effect/jiaxu_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_227 = {"甄姬手动技能被击特效", "Image/Fight/skill/zhenji_manualskill_hitted_1/zhenji_manualskill_hitted_1.ExportJson", "zhenji_manualskill_hitted_1", "0", "audio/effect/zhenji_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "0", "Image/Fight/skill/zhenji_manualskill_hitted_2/zhenji_manualskill_hitted_2.ExportJson", "zhenji_manualskill_hitted_2", "0", "-1", "0", nil, nil, nil, nil, nil, nil, nil, },
    id_228 = {"符咒熊技能法术防御特效 buff", "Image/Fight/skill/buff_fgashufangyu/buff_fgashufangyu.ExportJson", "buff_fgashufangyu", "0", "audio/effect/jiadun_buff.mp3", "1000", "0", "1", "0", "6", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_229 = {"轰炸机攻击（子弹）", "Image/Fight/skill/hongzhaji_maualskill_dandao/hongzhaji_maualskill_dandao.ExportJson", "hongzhaji_maualskill_dandao", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_230 = {"轰炸机手动技能被击特效", "Image/Fight/skill/hongzhaji_maualskill_hitted/hongzhaji_maualskill_hitted.ExportJson", "hongzhaji_maualskill_hitted", "0", "audio/effect/zhurong_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_231 = {"华雄普通技能被击特效", "Image/Fight/skill/huaxiong_attack_hitted/huaxiong_attack_hitted.ExportJson", "huaxiong_attack_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_232 = {"华雄手动技能被击特效", "Image/Fight/skill/huaxiong_manualskill_hitted/huaxiong_manualskill_hitted.ExportJson", "huaxiong_manualskill_hitted", "0", "audio/effect/dao_attack.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_233 = {"张辽skill技能被击特效", "Image/Fight/skill/zhangliao_skill_hitted/zhangliao_skill_hitted.ExportJson", "zhangliao_skill_hitted", "0", "audio/effect/zhangjiao_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_234 = {"孟获加盾buff", "Image/Fight/skill/menghuo_skill_buff/menghuo_skill_buff.ExportJson", "menghuo_skill_buff", "0", "audio/effect/jiadun_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_235 = {"弩车攻击（子弹）", "Image/Fight/skill/arrow_dandao_nuche/arrow_dandao_nuche.ExportJson", "arrow_dandao_nuche", "0", "audio/effect/arrow_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_236 = {"马良攻击（子弹）", "Image/Fight/skill/maliang_attack_dandao/maliang_attack_dandao.ExportJson", "maliang_attack_dandao", "0", "audio/effect/du_attack.mp3", "1000", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_237 = {"马良skill（子弹）", "Image/Fight/skill/maliang_skill_dandao/maliang_skill_dandao.ExportJson", "maliang_skill_dandao", "0", "audio/effect/du_attack.mp3", "600", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_238 = {"马良封印buff", "Image/Fight/skill/maliang_manualskill_buff/maliang_manualskill_buff.ExportJson", "maliang_manualskill_buff", "0", "audio/effect/zuzhou_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_239 = {"马良被击特效", "Image/Fight/skill/maliang_attack_hitted/maliang_attack_hitted.ExportJson", "maliang_attack_hitted", "0", "audio/effect/guojia_attack_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_240 = {"马良skill被击特效", "Image/Fight/skill/maliang_skill_hitted/maliang_skill_hitted.ExportJson", "maliang_skill_hitted", "0", "audio/effect/chengong_skill_hitted.mp3", "1000", "0", "1", "0", "1", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_241 = {"马良手动技能被击特效", "Image/Fight/skill/maliang_manualskill_hitted/maliang_manualskill_hitted.ExportJson", "maliang_manualskill_hitted", "0", "audio/effect/chengong_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_242 = {"弩车手动攻击（子弹）", "Image/Fight/skill/arrow_dandao_nuche/arrow_dandao_nuche.ExportJson", "arrow_dandao_nuche", "0", "audio/effect/arrow_attack.mp3", "800", "0", "1", "0", "1", nil, "0", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_243 = {"护法花精技能被击特效", "Image/Fight/skill/hufahuajing_hitted/hufahuajing_hitted.ExportJson", "hufahuajing_hitted", "0", "audio/effect/dianwei_manualskill_hitted.mp3", "1000", "0", "1", "0", "0", nil, "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
    id_244 = {"女巫兵skill技能（buff）", "Image/Fight/skill/nvwu_skill_buff/nvwu_skill_buff.ExportJson", "nvwu_skill_buff", "0", "audio/effect/jiadun_buff.mp3", "1000", "0", "1", "0", "1", "shenshang", "1", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
}


function getDataById(key_id)
    local id_data = EffectDataTable["id_" .. key_id]
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

    for k, v in pairs(EffectDataTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return EffectDataTable
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

    for k, v in pairs(EffectDataTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["EffectData"] = nil
    package.loaded["EffectData"] = nil
end
