-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("AnimationData", package.seeall)


keys = {
	"﻿Id", "describe", "AnimationfileName", "AnimationName", "ImagefileName_Head", "ImagefileName_Body", "ImagefileName", "Audio_Die", "Ani_stand", "Ani_run", "Ani_die", "Ani_hitted", "Ani_cheers", "Ani_attack", "Ani_skill", "Ani_manual_skill", "Ani_fly", "Ani_vertigo", 
}

AnimationDataTable = {
    id_1000 = {"女主角zs", "Image/Fight/player/nvzhu_zs/nvzhu_zs.ExportJson", "nvzhu_zs", "Image/imgres/hero/head_icon/nvzhujue_zs_1.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_zs_death.mp3", "stand_zs", "run_zs", "dead_zs", "hitted_zs", "cheers_zs", "attack_zs", "skill_zs", "manualskill_zs", "fly_zs", "vertigo_zs", },
    id_1100 = {"女主角mj", "Image/Fight/player/nvzhu_zs/nvzhu_zs.ExportJson", "nvzhu_zs", "Image/imgres/hero/head_icon/nvzhujue_zs_2.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_zs_death.mp3", "stand_mj", "run_mj", "dead_mj", "hitted_mj", "cheers_mj", "attack_mj", "skill_mj", "manualskill_mj", "fly_mj", "vertigo_mj", },
    id_1200 = {"女主角bz", "Image/Fight/player/nvzhu_zs/nvzhu_zs.ExportJson", "nvzhu_zs", "Image/imgres/hero/head_icon/nvzhujue_zs_3.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_zs_death.mp3", "stand_bz", "run_bz", "dead_bz", "hitted_bz", "cheers_bz", "attack_bz", "skill_bz", "manualskill_bz", "fly_bz", "vertigo_bz", },
    id_1010 = {"女主角ms", "Image/Fight/player/nvzhu_ms/nvzhu_ms.ExportJson", "nvzhu_ms", "Image/imgres/hero/head_icon/nvzhujue_ms_1.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_ms_death.mp3", "stand_ms", "run_ms", "dead_ms", "hitted_ms", "cheers_ms", "attack_ms", "skill_ms", "manualskill_ms", "fly_ms", "vertigo_ms", },
    id_1110 = {"女主角cs", "Image/Fight/player/nvzhu_ms/nvzhu_ms.ExportJson", "nvzhu_ms", "Image/imgres/hero/head_icon/nvzhujue_ms_2.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_ms_death.mp3", "stand_cs", "run_cs", "dead_cs", "hitted_cs", "cheers_cs", "attack_cs", "skill_cs", "manualskill_cs", "fly_cs", "vertigo_cs", },
    id_1210 = {"女主角ts", "Image/Fight/player/nvzhu_ms/nvzhu_ms.ExportJson", "nvzhu_ms", "Image/imgres/hero/head_icon/nvzhujue_ms_3.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_ms_death.mp3", "stand_ts", "run_ts", "dead_ts", "hitted_ts", "cheers_ts", "attack_ts", "skill_ts", "manualskill_ts", "fly_ts", "vertigo_ts", },
    id_1020 = {"女主角gs", "Image/Fight/player/nvzhu_gs/nvzhu_gs.ExportJson", "nvzhu_gs", "Image/imgres/hero/head_icon/nvzhujue_gs_1.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_gs_death.mp3", "stand_gs", "run_gs", "dead_gs", "hitted_gs", "cheers_gs", "attack_gs", "skill_gs", "manualskill_gs", "fly_gs", "vertigo_gs", },
    id_1120 = {"女主角fy", "Image/Fight/player/nvzhu_gs/nvzhu_gs.ExportJson", "nvzhu_gs", "Image/imgres/hero/head_icon/nvzhujue_gs_2.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_gs_death.mp3", "stand_fy", "run_fy", "dead_fy", "hitted_fy", "cheers_fy", "attack_fy", "skill_fy", "manualskill_fy", "fly_fy", "vertigo_fy", },
    id_1220 = {"女主角ly", "Image/Fight/player/nvzhu_gs/nvzhu_gs.ExportJson", "nvzhu_gs", "Image/imgres/hero/head_icon/nvzhujue_gs_3.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nvzhu_gs_death.mp3", "stand_ly", "run_ly", "dead_ly", "hitted_ly", "cheers_ly", "attack_ly", "skill_ly", "manualskill_ly", "fly_ly", "vertigo_ly", },
    id_1001 = {"男主角zs", "Image/Fight/player/nanzhu_zs/nanzhu_zs.ExportJson", "nanzhu_zs", "Image/imgres/hero/head_icon/nanzhujue_zs_1.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_zs_death.mp3", "stand_zs", "run_zs", "dead_zs", "hitted_zs", "cheers_zs", "attack_zs", "skill_zs", "manualskill_zs", "fly_zs", "vertigo_zs", },
    id_1101 = {"男主角mj", "Image/Fight/player/nanzhu_zs/nanzhu_zs.ExportJson", "nanzhu_zs", "Image/imgres/hero/head_icon/nanzhujue_zs_2.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_zs_death.mp3", "stand_mj", "run_mj", "dead_mj", "hitted_mj", "cheers_mj", "attack_mj", "skill_mj", "manualskill_mj", "fly_mj", "vertigo_mj", },
    id_1201 = {"男主角bz", "Image/Fight/player/nanzhu_zs/nanzhu_zs.ExportJson", "nanzhu_zs", "Image/imgres/hero/head_icon/nanzhujue_zs_3.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_zs_death.mp3", "stand_bz", "run_bz", "dead_bz", "hitted_bz", "cheers_bz", "attack_bz", "skill_bz", "manualskill_bz", "fly_bz", "vertigo_bz", },
    id_1011 = {"男主角ms", "Image/Fight/player/nanzhu_ms/nanzhu_ms.ExportJson", "nanzhu_ms", "Image/imgres/hero/head_icon/nanzhujue_ms_1.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_ms_death.mp3", "stand_ms", "run_ms", "dead_ms", "hitted_ms", "cheers_ms", "attack_ms", "skill_ms", "manualskill_ms", "fly_ms", "vertigo_ms", },
    id_1111 = {"男主角cs", "Image/Fight/player/nanzhu_ms/nanzhu_ms.ExportJson", "nanzhu_ms", "Image/imgres/hero/head_icon/nanzhujue_ms_2.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_ms_death.mp3", "stand_cs", "run_cs", "dead_cs", "hitted_cs", "cheers_cs", "attack_cs", "skill_cs", "manualskill_cs", "fly_cs", "vertigo_cs", },
    id_1211 = {"男主角ts", "Image/Fight/player/nanzhu_ms/nanzhu_ms.ExportJson", "nanzhu_ms", "Image/imgres/hero/head_icon/nanzhujue_ms_3.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_ms_death.mp3", "stand_ts", "run_ts", "dead_ts", "hitted_ts", "cheers_ts", "attack_ts", "skill_ts", "manualskill_ts", "fly_ts", "vertigo_ts", },
    id_1021 = {"男主角gs", "Image/Fight/player/nanzhu_gs/nanzhu_gs.ExportJson", "nanzhu_gs", "Image/imgres/hero/head_icon/nanzhujue_gs_1.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_gs_death.mp3", "stand_gs", "run_gs", "dead_gs", "hitted_gs", "cheers_gs", "attack_gs", "skill_gs", "manualskill_gs", "fly_gs", "vertigo_gs", },
    id_1121 = {"男主角fy", "Image/Fight/player/nanzhu_gs/nanzhu_gs.ExportJson", "nanzhu_gs", "Image/imgres/hero/head_icon/nanzhujue_gs_2.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_gs_death.mp3", "stand_fy", "run_fy", "dead_fy", "hitted_fy", "cheers_fy", "attack_fy", "skill_fy", "manualskill_fy", "fly_fy", "vertigo_fy", },
    id_1221 = {"男主角ly", "Image/Fight/player/nanzhu_gs/nanzhu_gs.ExportJson", "nanzhu_gs", "Image/imgres/hero/head_icon/nanzhujue_gs_3.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/nanzhu_gs_death.mp3", "stand_ly", "run_ly", "dead_ly", "hitted_ly", "cheers_ly", "attack_ly", "skill_ly", "manualskill_ly", "fly_ly", "vertigo_ly", },
    id_1 = {"关羽", "Image/Fight/player/guanyu/guanyu.ExportJson", "guanyu", "Image/imgres/hero/head_icon/touxiang_guanyu.png", "Image/hero/body_img/3.png", "Image/hero/big_body/3.png", "audio/death/guanyu_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_3 = {"炎龙", "Image/Fight/player/yanlong/yanlong.ExportJson", "yanlong", "Image/imgres/hero/head_icon/touxiang_yanlong.png", "Image/hero/body_img/3.png", "Image/hero/big_body/3.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_4 = {"吕布", "Image/Fight/player/lvbu/lvbu.ExportJson", "lvbu", "Image/imgres/hero/head_icon/touxiang_lvbu.png", "Image/hero/body_img/4.png", "Image/hero/big_body/4.png", "audio/death/lvbu_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_5 = {"甘宁", "Image/Fight/player/ganning/ganning.ExportJson", "ganning", "Image/imgres/hero/head_icon/touxiang_ganning.png", "Image/hero/body_img/5.png", "Image/hero/big_body/5.png", "audio/death/ganning_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_6 = {"赵云", "Image/Fight/player/zhaoyun/zhaoyun.ExportJson", "zhaoyun", "Image/imgres/hero/head_icon/touxiang_zhaoyun.png", "Image/hero/body_img/6.png", "Image/hero/big_body/6.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_7 = {"貂蝉", "Image/Fight/player/diaochanNew/diaochanNew.ExportJson", "diaochanNew", "Image/imgres/hero/head_icon/touxiang_diaochan01.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/diaochan_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_8 = {"投石车", "Image/Fight/player/toushiche/toushiche.ExportJson", "toushiche", "Image/imgres/hero/head_icon/touxiang_toushiche.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_9 = {"枪兵", "Image/Fight/player/qiangbing/qiangbing.ExportJson", "qiangbing", "Image/imgres/hero/head_icon/touxiang_qiangbing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_10 = {"盾兵", "Image/Fight/player/dunbing/dunbing.ExportJson", "dunbing", "Image/imgres/hero/head_icon/touxiang_dunbing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_11 = {"蒲扇兵", "Image/Fight/player/pushanbing/pushanbing.ExportJson", "pushanbing", "Image/imgres/hero/head_icon/touxiang_pushanbing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_12 = {"护法龙", "Image/Fight/player/hufa_long/hufa_long.ExportJson", "hufa_long", "Image/imgres/hero/head_icon/touxiang_hufalong.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_13 = {"马超", "Image/Fight/player/machao/machao.ExportJson", "machao", "Image/imgres/hero/head_icon/touxiang_machao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_14 = {"鼓手", "Image/Fight/animation/gushou/gushou.ExportJson", "gushou", "Image/imgres/hero/head_icon/touxiang_jigushou.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_15 = {"华佗", "Image/Fight/player/huatuo/huatuo.ExportJson", "huatuo", "Image/imgres/hero/head_icon/touxiang_huatuo.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_16 = {"护法花精", "Image/Fight/player/hufahuajing/hufahuajing.ExportJson", "hufahuajing", "Image/imgres/hero/head_icon/touxiang_huajing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nv_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_17 = {"曹仁", "Image/Fight/player/caoren/caoren.ExportJson", "caoren", "Image/imgres/hero/head_icon/touxiang_caoren.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_18 = {"曹操", "Image/Fight/player/caocao/caocao.ExportJson", "caocao", "Image/imgres/hero/head_icon/touxiang_caocao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/caocao_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_19 = {"典韦", "Image/Fight/player/dianwei/dianwei.ExportJson", "dianwei", "Image/imgres/hero/head_icon/touxiang_dianwei.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_20 = {"张飞", "Image/Fight/player/zhangfei/zhangfei.ExportJson", "zhangfei", "Image/imgres/hero/head_icon/touxiang_zhangfei.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/zhangfei_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_21 = {"董卓", "Image/Fight/player/dongzhuo/dongzhuo.ExportJson", "dongzhuo", "Image/imgres/hero/head_icon/touxiang_dongzhuo.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_22 = {"诸葛亮", "Image/Fight/player/zhugeliang/zhugeliang.ExportJson", "zhugeliang", "Image/imgres/hero/head_icon/touxiang_zhugeliang.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/zhugeliang_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_23 = {"大桥", "Image/Fight/player/daqiao/daqiao.ExportJson", "daqiao", "Image/imgres/hero/head_icon/touxiang_daqiao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/caiwenji_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_24 = {"小桥", "Image/Fight/player/xiaoqiao/xiaoqiao.ExportJson", "xiaoqiao", "Image/imgres/hero/head_icon/touxiang_xiaoqiao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/ganfuren_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_25 = {"祝融", "Image/Fight/player/zhurong/zhurong.ExportJson", "zhurong", "Image/imgres/hero/head_icon/touxiang_zhurong.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nv_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_26 = {"护法猪", "Image/Fight/player/hufazhu/hufazhu.ExportJson", "hufazhu", "Image/imgres/hero/head_icon/touxiang_hufazhu.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_27 = {"刀兵", "Image/Fight/player/daobing/daobing.ExportJson", "daobing", "Image/imgres/hero/head_icon/touxiang_daobing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_28 = {"张郃", "Image/Fight/player/zhanghe/zhanghe.ExportJson", "zhanghe", "Image/imgres/hero/head_icon/touxiang_zhanghe.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_29 = {"太史慈", "Image/Fight/player/taishici/taishici.ExportJson", "taishici", "Image/imgres/hero/head_icon/touxiang_taishici.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_30 = {"张角", "Image/Fight/player/zhangjiao/zhangjiao.ExportJson", "zhangjiao", "Image/imgres/hero/head_icon/touxiang_zhangjiao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_31 = {"黄盖", "Image/Fight/player/huanggai/huanggai.ExportJson", "huanggai", "Image/imgres/hero/head_icon/touxiang_huanggai.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_32 = {"于禁", "Image/Fight/player/yujin/yujin.ExportJson", "yujin", "Image/imgres/hero/head_icon/touxiang_yujin.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_33 = {"弓兵", "Image/Fight/player/gongjianbing/gongjianbing.ExportJson", "gongjianbing", "Image/imgres/hero/head_icon/touxiang_gongbing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_34 = {"徐晃", "Image/Fight/player/xuhuang/xuhuang.ExportJson", "xuhuang", "Image/imgres/hero/head_icon/touxiang_xuhuang.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_35 = {"郭嘉", "Image/Fight/player/guojia/guojia.ExportJson", "guojia", "Image/imgres/hero/head_icon/touxiang_guojia.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_36 = {"陆逊", "Image/Fight/player/luxun/luxun.ExportJson", "luxun", "Image/imgres/hero/head_icon/touxiang_luxun.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_37 = {"爪狼", "Image/Fight/player/zhualang/zhualang.ExportJson", "zhualang", "Image/imgres/hero/head_icon/touxiang_yanlang.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_38 = {"披甲象", "Image/Fight/player/pijiaxiang/pijiaxiang.ExportJson", "pijiaxiang", "Image/imgres/hero/head_icon/touxiang_maoxiang.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_39 = {"医疗兵", "Image/Fight/player/yiliaobing/yiliaobing.ExportJson", "yiliaobing", "Image/imgres/hero/head_icon/touxiang_yiliaobing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_40 = {"吕蒙", "Image/Fight/player/lvmeng/lvmeng.ExportJson", "lvmeng", "Image/imgres/hero/head_icon/touxiang_lvmeng.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_41 = {"贾诩", "Image/Fight/player/jiaxu/jiaxu.ExportJson", "jiaxu", "Image/imgres/hero/head_icon/touxiang_jiaxu.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_42 = {"李儒", "Image/Fight/player/liru/liru.ExportJson", "liru", "Image/imgres/hero/head_icon/touxiang_liru.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_43 = {"高顺", "Image/Fight/player/gaoshun/gaoshun.ExportJson", "gaoshun", "Image/imgres/hero/head_icon/touxiang_gaoshun.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_44 = {"鲁肃", "Image/Fight/player/lusu/lusu.ExportJson", "lusu", "Image/imgres/hero/head_icon/touxiang_lusu.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_45 = {"陈宫", "Image/Fight/player/chengong/chengong.ExportJson", "chengong", "Image/imgres/hero/head_icon/touxiang_chengong.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_46 = {"刘备", "Image/Fight/player/liubei/liubei.ExportJson", "liubei", "Image/imgres/hero/head_icon/touxiang_liubei.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/liubei_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_47 = {"华雄", "Image/Fight/player/huaxiong/huaxiong.ExportJson", "huaxiong", "Image/imgres/hero/head_icon/touxiang_huaxiong.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_48 = {"张辽", "Image/Fight/player/zhangliao/zhangliao.ExportJson", "zhangliao", "Image/imgres/hero/head_icon/touxiang_zhangliao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_49 = {"周泰", "Image/Fight/player/zhoutai/zhoutai.ExportJson", "zhoutai", "Image/imgres/hero/head_icon/touxiang_zhoutai.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_50 = {"凌统", "Image/Fight/player/lingtong/lingtong.ExportJson", "lingtong", "Image/imgres/hero/head_icon/touxiang_lingtong.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_51 = {"新小乔", "Image/Fight/player/xiaoqiao01/xiaoqiao01.ExportJson", "xiaoqiao01", "Image/imgres/hero/head_icon/touxiang_xiaoqiao01.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/xiaoqiao_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_52 = {"新大乔", "Image/Fight/player/daqiaoNew/daqiaoNew.ExportJson", "daqiaoNew", "Image/imgres/hero/head_icon/touxiang_daqiao01.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/daqiao_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_53 = {"护法女神", "Image/Fight/player/hufanvshen/hufanvshen.ExportJson", "hufanvshen", "Image/imgres/hero/head_icon/touxiang_hufanvshen.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nv_dead.mp3", "stand", "stand", "brith", "brith", "stand", "attack", "attack", "attack", "stand", "stand", },
    id_54 = {"护法男神", "Image/Fight/player/hufananshen/hufananshen.ExportJson", "hufananshen", "Image/imgres/hero/head_icon/touxiang_hufananshen.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "stand", "brith", "brith", "stand", "attack", "attack", "attack", "stand", "stand", },
    id_55 = {"魏延", "Image/Fight/player/weiyan/weiyan.ExportJson", "weiyan", "Image/imgres/hero/head_icon/touxiang_weiyan.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_56 = {"护法死神", "Image/Fight/player/hufasishen/hufasishen.ExportJson", "hufasishen", "Image/imgres/hero/head_icon/touxiang_hufasishen.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "stand", "brith", "brith", "stand", "attack", "attack", "attack", "stand", "stand", },
    id_57 = {"许褚", "Image/Fight/player/xuchu/xuchu.ExportJson", "xuchu", "Image/imgres/hero/head_icon/touxiang_xuchu.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_58 = {"夏侯惇", "Image/Fight/player/xiahoudun/xiahoudun.ExportJson", "xiahoudun", "Image/imgres/hero/head_icon/touxiang_xiahoudun.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_59 = {"黄月英", "Image/Fight/player/huangyueying/huangyueying.ExportJson", "huangyueying", "Image/imgres/hero/head_icon/touxiang_huangyueying.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/huangyueying_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_60 = {"袁绍", "Image/Fight/player/yuanshao/yuanshao.ExportJson", "yuanshao", "Image/imgres/hero/head_icon/touxiang_yuanshao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_61 = {"周瑜", "Image/Fight/player/zhouyu/zhouyu.ExportJson", "zhouyu", "Image/imgres/hero/head_icon/touxiang_zhouyu.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/zhouyu_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_62 = {"于吉", "Image/Fight/player/yuji/yuji.ExportJson", "yuji", "Image/imgres/hero/head_icon/touxiang_yuji.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_63 = {"司马懿", "Image/Fight/player/simayi/simayi.ExportJson", "simayi", "Image/imgres/hero/head_icon/touxiang_simayi.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_64 = {"孙权", "Image/Fight/player/sunquan/sunquan.ExportJson", "sunquan", "Image/imgres/hero/head_icon/touxiang_sunquan.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/sunquan_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_65 = {"孙尚香", "Image/Fight/player/sunshangxiang/sunshangxiang.ExportJson", "sunshangxiang", "Image/imgres/hero/head_icon/touxiang_sunshangxiang.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/sunshangxiang_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_66 = {"甄姬", "Image/Fight/player/zhenji/zhenji.ExportJson", "zhenji", "Image/imgres/hero/head_icon/touxiang_zhenji.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/death/zhenji_death.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_67 = {"吼狮", "Image/Fight/player/houshi/houshi.ExportJson", "houshi", "Image/imgres/hero/head_icon/touxiang_houshi.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_68 = {"战豹", "Image/Fight/player/zhanbao/zhanbao.ExportJson", "zhanbao", "Image/imgres/hero/head_icon/touxiang_zhanbao.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_69 = {"符咒熊", "Image/Fight/player/fuzhouxiong/fuzhouxiong.ExportJson", "fuzhouxiong", "Image/imgres/hero/head_icon/touxiang_fuzhouxiong.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_70 = {"机关兵", "Image/Fight/player/jiguanbing/jiguanbing.ExportJson", "jiguanbing", "Image/imgres/hero/head_icon/touxiang_jiguanbing.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_71 = {"机械BOSS", "Image/Fight/player/jixieguai/jixieguai.ExportJson", "jixieguai", "Image/imgres/hero/head_icon/touxiang_jixieguai.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_72 = {"轰炸机", "Image/Fight/player/hongzhaji/hongzhaji.ExportJson", "hongzhaji", "Image/imgres/hero/head_icon/touxiang_hongzhaji.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_73 = {"挖掘机", "Image/Fight/player/wajueji/wajueji.ExportJson", "wajueji", "Image/imgres/hero/head_icon/touxiang_wajueji.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_74 = {"孟获", "Image/Fight/player/menghuo/menghuo.ExportJson", "menghuo", "Image/imgres/hero/head_icon/touxiang_menghuo.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_75 = {"弩车", "Image/Fight/player/nuche/nuche.ExportJson", "nuche", "Image/imgres/hero/head_icon/touxiang_nuche.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", nil, "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_76 = {"马良", "Image/Fight/player/maliang/maliang.ExportJson", "maliang", "Image/imgres/hero/head_icon/touxiang_maliang.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nan_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
    id_77 = {"巫术兵", "Image/Fight/player/nvwu/nvwu.ExportJson", "nvwu", "Image/imgres/hero/head_icon/touxiang_nvwu.png", "Image/hero/body_img/7.png", "Image/hero/big_body/7.png", "audio/effect/nv_dead.mp3", "stand", "run", "dead", "hitted", "cheers", "attack", "skill", "manualskill", "fly", "vertigo", },
}


function getDataById(key_id)
    local id_data = AnimationDataTable["id_" .. key_id]
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

    for k, v in pairs(AnimationDataTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return AnimationDataTable
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

    for k, v in pairs(AnimationDataTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["AnimationData"] = nil
    package.loaded["AnimationData"] = nil
end
