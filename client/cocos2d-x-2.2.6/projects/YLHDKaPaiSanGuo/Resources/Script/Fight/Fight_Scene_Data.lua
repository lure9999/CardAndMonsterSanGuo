--战斗场景的数据


module("Fight_Scene_Data", package.seeall)
--[[
	//技能id
	int m_skillid;	
	//效果参数
	int m_paramete;
	//伤害类型  1物理 2法术
	int m_power_type;
	//伤害系数
	float m_ratio;	
	
	//施法对象 1敌方单体	2敌方横排		3敌方纵列		4敌方全面		5范围攻击		
	int m_site;
	//释放条件 1普通 2技能 3手动技能（新扩展的）
	int m_skill_type;
	//技能类型 1普通技能（无特效）	2眩晕		3吸血（将技能伤害按百分比吸血）		4治疗		5概率2次连击		6消减对方士气		7偷取敌方士气		8造成伤害并增益己方单体士气		9造成伤害并增益己方全体士气。
	//	10施展某伤害技能后恢复参数A的士气---只给自己回。11施展伤害技能并恢复自身4点士气，同时血量每减少10%，技能伤害系数增加参数A	12血量每减少10%，技能伤害系数增加参数A	13吸血并恢复自身4点士气。（也就是连发吸血）	14吸血，并且恢复4点士气，生命值低于20%后技能系数翻倍	15 100%眩晕并偷怒气
	int m_type;
	//技能cd时间
	float m_TimeCD;
	//技能名字
	char m_SkillName[32];
	//资源id
	int m_SkillResid;
	//攻击半径
	,m_SkillRadius = 0
--]]



function Init_ObjTable()
	
	local ObjTable = {	
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},

	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},

	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	  {PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	}
	
	return ObjTable	
	
end

function Init_HufaTable()
	
	local hufaTable = {	
		{PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
		{PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
		{PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
		{PayArmature = nil, ObjFightDataParm = { m_FightPos = -1, m_imageID = -1, m_Mode_Height = -1, m_Mode_Width = -1, m_FightState = -1,m_iTarpos = -1, m_iSkill = -1, m_iSkillIndex = -1, m_iSkillType = -1, m_iSkillTarType = -1, m_State = -1, m_Damage = {-1,-1,-1,-1,-1,},m_DamageState = {-1,-1,-1,-1,-1,}, m_iParamDamage = -1, m_CdTime = -1, m_HurtPos = {-1,-1,-1,-1,-1,}, m_FightPosType = -1, m_AttackDis = -1, m_Curbone = nil, m_bUseingEngineSkill = false}},
	}
	return hufaTable
end

function Init_FightData()
	local FightData = {
						m_bUpdata = false,
						m_SceneID = -1,
						m_bPKScene = false,
						-- add by sxin 增加是否是国战和单挑的逻辑
						m_bCityWarScene = false,
						m_bCityWarSingleScene = false,
						m_bCGScene = false,
						m_bFightEnd = false,
						--???????
						m_curTimes = 0,
						--??????
						m_AllTimes = 0,
						m_Battle_ID = -1,
						--副本的星级 0 没打过触发情节
						m_CopyData_Star = 0,
						--pk的奖励ID
						m_pk_rewardID = -1,
						--//全屏特效索引计数
						m_UseingEngineSkillStopTimes = 0,
						
						m_Team_EngineSkill_Tar = -1,
						
						m_FightResult = {
									m_iFightResult = -1,
						},
						
						m_TeamData = {
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,									
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
									},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
									},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0,m_xishoudun = 0, --增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
									},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0,m_xishoudun = 0, --增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
									},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
									},
						
							
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},

							
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
								
							
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
								m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,	m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
								m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
								m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
								m_SkillData = {
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
									{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
											}
								}		
						},						
						--增加护法数据 暂时一个队伍只有一个护法 理论上最多4个护法
						m_HufaData = {
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
							},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
							},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
							},
							{m_Serverid = -1,m_TempID = -1,m_name = "",m_TempResid = -1,m_attack =-1,m_wisdom = -1,m_strength = -1,m_attribute = -1,m_level=-1,m_allblood = -1,m_curblood = -1,
									m_power = -1,m_star =-1,m_anger =-1,m_engine=-1,m_Dis = -1, m_fightpostype = -1,m_DropItemID = -1, m_gongji = -1,m_wufang =-1,m_fafang = -1,m_mingzhong = -1,
									m_blood_back = 0,m_engine_back = 0,m_add_gongji = 0, m_add_fangyu = 0,m_State_immune = 0, m_xishoudun = 0,--增加5个属性
									m_Talent = { m_id = -1, m_attack = -1, m_wufang =-1, m_fafang = -1, m_hp = -1,m_duoshan = -1,m_crit = -1, m_penetrate = -1,m_mingzhong = -1 },
									m_SkillData = {
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0},	
										{m_skillid = -1,m_paramete = -1,m_power_type = -1,m_ratio = -1,m_site = -1,m_skill_type = -1,m_type = -1,m_timecd = -1,m_skillname = "",m_skillresid = -1,m_SkillRadius = 0,m_bufftimes=-1,m_buffcd = -1,m_buffchace = -1,m_anger_back = 0, m_engine_back = 0}						
												}
							}
						},
						m_dropList = {},
						m_PKData ={},
						m_PKData_Times ={1,1,1,1,1,1,1,1,1,1,1,1}
					}
	return FightData
end










