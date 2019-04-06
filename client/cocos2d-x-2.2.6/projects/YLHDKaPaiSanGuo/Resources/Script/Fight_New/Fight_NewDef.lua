

------所有战斗引用-------
require "Script/DB/SceneData"
require "Script/DB/ScriptData"
require "Script/DB/AnimationData"
require "Script/DB/EffectData"
require "Script/DB/SkillData"
require "Script/serverDB/scence"	
require "Script/serverDB/point"	
require "Script/serverDB/monst"
require "Script/serverDB/general"
require "Script/serverDB/talent"
require "Script/serverDB/skill"


--*****************************************************

Obj_Type = 
{
	Type_Obj	= 0,	-- Obj
	Type_Player	= 1,	-- 玩家
	Type_Npc	= 2,	-- Npc
	
}

Effect_Type = 
{
	Type_Obj	= 0,	-- Obj
	Type_Effect	= 1,	-- 普通特效
	Type_Bullet	= 2,	-- 子弹
	Type_Buff	= 3,	-- buff
	
}

--场景管理器通过这个管理器来创建战斗场景的实体
Scene_Type = 
{
	Type_Base	= 1,	-- 基础的场景
	Type_Other	= 2,	-- 基础的场景
}

SceneDB_Type = 
{
	Type_None	= 0,	-- 副本
	Type_FuBen	= 1,	-- 副本
	Type_PK	= 2,	-- 比武
	Type_CityWar	= 3,	-- 国战
	Type_WarSingle	= 4,	-- 单挑
}

--UI页面的消除
FightClear_Type = {
	Type_SingleClear        =   1,
	Type_DoubelClear 		=	2,
	Type_TripleClear 		=	3,
}

--*******************************************************

require "Script/Fight/simulationStl"

Brith_Ain_File_0 = "Image/Fight/skill/brith_all_001/brith_all_001.ExportJson"
Brith_Ain_Name_0 = "brith_all_001"

--UI技能池相关
FIGHTPOOL_BEGIN 		=	1
FIGHTPOOL_BOTTOM 		=	0
FIGHTPOOL_TOP 		=	9

MaxTeamPlayCount = 5
MaxMoveDistance = 960
MaxPlayMoveSpeed = 180
SceneEnterTime = MaxMoveDistance/MaxPlayMoveSpeed

MaxMoveSpeed = 1000
--y重叠便宜
MaxOverlap = 50

Off_Effect_head = 20
Play_Effect_Z = 200

Car_Width  = 100
Car_Height = 100
Car_Edge   = 20
Car_EdgeTop   = 40

--能量手动技能
Kill_Engine_Back  = 20
MaxEngine  = 100
UseMaxEngine = 300

UseAnger	= 4


Animation_off_Width = 100
Animation_off_Height = 60

--FightStarTimeinterval = 0.5
FightStarTimeinterval = 0

ApplyFightTime = 1.5
ShowFightResoutTime = 3.0
ShowCheersTime = 1.0
FightTimeMax = 90



FightWin = 1

FightLose = 2


EnemyMaxNum = 5

HufaMaxNum = 4

BlackLayerOpacity = 200


BlackLayerColour4 = ccc4(0,0,0,200)  

BlackLayerColour3 = ccc3(55,55,55)
BlackLayerColourNor3 = ccc3(255,255,255)
	


DefineWidth = 960
DefineHeight = 640

DefineResWidth = 1140
DefineResHeight = 640

DefOffY = 350

Fight_Bloodoff_y = 20

DeviceSize = CCEGLView:sharedOpenGLView():getVisibleSize()

defpointy_1 = 330 -10
defpointy_2 = 255 -20

Fight_Min_SceneY = 170

Fight_Max_SceneY = 335

--计算放缩模式
Scene_Off_x = 0
Scene_Off_y = 0
Scene_scale = 1

if DeviceSize.width/DeviceSize.height <= DefineResWidth/DefineResHeight then  --以高适配 寛被裁剪
	
	Scene_Off_x = DefineResWidth - DeviceSize.width*DefineResHeight/DeviceSize.height
	Scene_scale	= DeviceSize.height/DefineResHeight
	
else --以寛适配 高被裁剪

	Scene_Off_y = DefineResHeight - DeviceSize.height*DefineResWidth/DeviceSize.width 
	Scene_scale	= DeviceSize.width/DefineResWidth
end



PlayBirthPoint = 
{
	{ x = Scene_scale*(410+90), y = Scene_scale*defpointy_1 },
	--{ x = Scene_scale*(410+90), y = 180 },
	{ x = Scene_scale*(315+90), y = Scene_scale*defpointy_2 },
	{ x = Scene_scale*(260+90), y = Scene_scale*defpointy_1 },
	{ x = Scene_scale*(165+90), y = Scene_scale*defpointy_2 },
	{ x = Scene_scale*(110+90), y = Scene_scale*defpointy_1 },
}



EnemyBirthPoint =
{
	{ x = Scene_scale*(550+90), y = Scene_scale*defpointy_1 },
	{ x = Scene_scale*(645+90), y = Scene_scale*defpointy_2 },
	{ x = Scene_scale*(700+90), y = Scene_scale*defpointy_1 },
	{ x = Scene_scale*(795+90), y = Scene_scale*defpointy_2 },
	{ x = Scene_scale*(850+90), y = Scene_scale*defpointy_1 },
}


FightSceneState = 
{
	READY_STATE				= 1,	--?????????
	FIGHT_STATE				= 2,	--??????
	GOING_NEXT_LEVEL_STATE 	= 3,	--?????????????
	OVER_STATE 				= 4,	--??????????
    SETTLEMENT_STATE        = 5,    --??????
}

E_FightTimer = 
{ 
	E_FightTimer_TestSceneEnter = 0,
	E_FightTimer_SceneEnter = 1000,
	E_FightTimer_ApplyFight = 1001,
	E_FightTimer_ShowFightResout = 1002,
	E_FightTimer_PlayCheers = 1003,
	
}

DamageState = 
{ 	
	E_DamageState_None =0,
	E_DamageState_BaoJi = 1,
	E_DamageState_ShanBi = 2,
	E_DamageState_ShiPo =3,	
	E_DamageState_xuanyun =4,
	E_DamageState_bingdong =5,
	E_DamageState_jifei =6,
	E_DamageState_Dot =7,
}

EffectType =
{ 	
	E_EffectType_Prompt=0,--//瞬发
	E_EffectType_Bullet =1,--//子弹
	E_EffectType_Bullet_parabolic_one =2,--//抛物线类型的炸弹类 单体
	E_EffectType_Bullet_parabolic_Mul =3,--//抛物线类型的炸弹类 多目标
	E_EffectType_Prompt_buff_One =4,--//伤害buff单体
	E_EffectType_Prompt_buff_Gain =5,--//增益buff单体
	E_EffectType_Prompt_buff_State =6,--//伤害+限制类的buff 有几率的 填表大于100就必然触发了
	E_EffectType_Prompt_buff_State_jifei =7,--//伤害+限制类jifeibuff (眩晕)有几率的 填表大于100就必然触发了
	E_EffectType_Prompt_Gain =8,--//增益瞬发单体
	E_EffectType_Prompt_buff_xishoudun =9,--//吸收盾逻辑
	E_EffectType_Prompt_Back_one =10,--//伤害+回复（单体）
	E_EffectType_Prompt_Back_all =11,--//伤害+回复（全体）
	E_EffectType_Prompt_ShuXing_one =12,--//伤害+属性（单体）
	E_EffectType_Bullet_buff_State =13,--//子弹伤害+限制类的buff 有几率的 填表大于100就必然触发了
	E_EffectType_Bullet_Sequence =14,--//子弹伤害+范围顺序到达播放伤害
}

BuffGainType = 
{
	E_BuffGainType_gongji= 0,--//攻击
	E_BuffGainType_wufang= 1,--//物防
	E_BuffGainType_fafang= 2,--//法防
	E_BuffGainType_mingzhong= 3,--//命中
	E_BuffGainType_baoji= 4,--//暴击
	E_BuffGainType_duoshan= 5,--//躲闪
	E_BuffGainType_shipo= 6,--//识破
	E_GainType_engine= 7,--//能量
	E_BuffGainType_xishoudun= 8,--//吸收盾
	E_BuffGainType_jueduifangyu= 9,--//绝对防御
	E_BuffGainType_zhili= 10,--//智力
	
}

EffectTypeTarg =
{ 	
	E_EffectType_OneTarget=0,--//单个特效
	E_EffectType_combination_One =1,--//组合特效第一有效
	E_EffectType_combination_All =2,--//组合特效全有效	

}

FightPosType =
{ 	
	E_FightPos_melee =0,--// 近战
	E_FightPos_middle=1,--//中距离
	E_FightPos_remote=2,--//远程

}

Audio_Type =
{ 	
	E_Audio_Scene = 0,--//????
	E_Audio_Attack = 1,--//???????
	E_Audio_AttackEffect = 2,--//????????	
	E_Audio_Die = 3,--//????
	E_Audio_Hitted = 4,--//????
}

MovementEventType = 
{
    start = 0,
    complete = 1,
    loopComplete = 2, 
}

Site_Type =
{
	Site_Enemy_Single_Param = 0, 	--1敌方单体--param 存放选择类型 0 随即1血最少2….
	Site_Enemy_Single = 1, 	--1敌方单体默认目标的
	Site_Enemy_Line = 2, 	--2敌方横排	
	Site_Enemy_Column = 3,	--3敌方纵列
	Site_Enemy_All = 4,		--敌方全体
	Site_Enemy_Scope = 5,	--敌方范围
	Site_Self_Self = 6,		--自己
	Site_Self_All = 7,		--己方全体
	Site_Self_Single = 8,	--己方单体体--param 存放选择类型 0 随即1血最少2….
}

Site_Single_Param =
{
	Type_Random = 1,	--随机
	Type_Blood_Min =2,	--当前血和总血比值最小的
}

--add by sxin 整理播放动作定义 修改支持扩展的职业动作播放逻辑
Ani_Def_Key =
{
	Ani_stand = "Ani_stand",
	Ani_run = "Ani_run",
	Ani_die = "Ani_die",
	Ani_hitted = "Ani_hitted",
	Ani_cheers = "Ani_cheers",
	Ani_attack = "Ani_attack",
	Ani_skill = "Ani_skill",
	Ani_manual_skill = "Ani_manual_skill",
	Ani_fly = "Ani_fly",
	Ani_vertigo = "Ani_vertigo",
}


Ani_Def_Name =
{
	Ani_stand = "stand",
	Ani_run = "run",
	Ani_die = "dead",
	Ani_hitted = "hitted",
	Ani_cheers = "cheers",
	Ani_attack = "attack",
	Ani_skill = "skill",
	Ani_manual_skill = "manualskill",
	Ani_fly = "fly",
	Ani_vertigo = "vertigo",
}

--播放接口 通过读资源表来播放相应的动作
function GetAniName_Res_ID( ResID , Ani_Key)
	
	--print(ResID)
	--print(Ani_Key)
	--Pause()
	--local name = "GetAniName_Res_ID" .. AnimationData.getFieldByIdAndIndex(ResID,Ani_Key) 
	--print(name)
	return AnimationData.getFieldByIdAndIndex(ResID,Ani_Key)	
end

function GetAniName_Def( Ani_Key)

	--print("GetAniName_Def" .. Ani_Def_Name[Ani_Key])
	--Pause()
	return Ani_Def_Name[Ani_Key]
	
end

--战斗play调用的接口别人不能调用
function GetAniName_Player(pObj , Ani_Key)
	
	if pObj:Fun_IsUser() == true then 
		local iResID = pObj.m_baseDB.m_TempResid
		return GetAniName_Res_ID(iResID , Ani_Key)	
	end
	
	return  GetAniName_Def(Ani_Key)
end

--震屏效果
function VibrationSceen(iTimes)

	--print("VibrationSceen")	
	local go = CCMoveBy:create(0.05, ccp(0,-15) )
	--local go = CCMoveBy:create(0.02, ccp(6,0) )
	local goBack = go:reverse()		
	local arr = CCArray:create()
	arr:addObject(go)
	arr:addObject(goBack)		
	local i=1	
	for i=1, iTimes, 1 do		
		arr:addObject(go:copy():autorelease())
		arr:addObject(goBack:copy():autorelease())		
	end	
	
	local seq = CCSequence:create(arr)
	
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	
	runningScene:runAction( (seq ))	
end

--技能效果
--角度转弧度
function degrees_to_radians( angle )
	return angle * 0.01745329252
end

--弧度转角度
function radians_to_degrees( angle )
	return angle * 57.29577951
end


function GetPointAngle( pSour,  pTar)

	local  vectorTaget = ccpSub( pTar, pSour )
	
	if vectorTaget == nil then
		return 0
	end
	
	local angle =  radians_to_degrees(ccpAngleSigned(vectorTaget,ccp( 1, 0 )))
	
	return angle
end


Ani_fly_Dis = 150
Ani_fly_Damage_Dis = 200
Ani_fly_Time = 0.5

FrameEvent_Key =
{
	Event_attack = "attact_effect",
	Event_Vibration = "VibrationSceen",
	Event_Blur = "effect_blur",
	Event_Normal = "effect_normal",
	Event_shownpc = "shownpc",
	
}

--公共骨骼绑定名字
BoneName =
{
	bone_xuetiao = "xuetiao",
	bone_shenshang = "shenshang",
	bone_jiaoxia = "jiaoxia",	
}

		

G_FightScene_Root_TagID 		=	10000
G_FightScene_Layer_Back_TagID 	=	13000
G_FightScene_Layer_Middle_TagID =	12000
G_FightScene_Layer_Front_TagID 	=	11000

G_BloodBoneTag = 18888
G_BloodBackBoneTag = G_BloodBoneTag +1
G_BloodTag = 19999
G_BloodBackTag = G_BloodTag+1

G_SelectGuangquanTag = 30000

--//???????tagid
FightTimeIagID = 66666
FightMoveIagID  = 999999
Fight_jifeiMoveTagID = 199999

G_FightScene_Layer_Back_Z =	10
G_FightScene_Layer_Middle_Z =	20
G_FightScene_Layer_Front_Z =	30

Fight_hufa_Z = 1000
Fight_hufa_TagID_Root = 30000
Fight_hufa_Time = 1

Fight_hufa_EngMax = 100
Fight_hufa_EngBack = 5

Layer_Root_Z = 1000
EffectLayer_Z = 1001
UILayer_Z = 1100

--最小的Buff更新时间
G_Fight_BUff_Tick_Time = 0.5


---初始化随机种子
math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 		
--math.randomseed(os.time())


--服务器包数据索引定义

MatrixData_Talent_Ratio = 1

Fight_Battle_Begin_Data = 
{
	Battle_Data_Res				= 1,	--申请副本结果
	Battle_Data_SceneID			= 2,	--场景id
	Battle_Data_PointIndex 		= 3,	--关卡索引
	Battle_Data_DropList 		= 4,	--掉落列表
    Battle_Data_MatrixData      = 5,    --阵容武将数据
}

Fight_Battle_Begin_Data_MatrixData = 
{
	MatrixData_nGridID		= 1,
	MatrixData_nSerial		= 2,
	MatrixData_nItemIndexID	= 3,
	MatrixData_Vel			= 4,	--申请副本结果
	MatrixData_Talent		= 5,	--场景id
	MatrixData_Skill		= 6,	--关卡索引
	
}

MatrixData_Vel_Key = 
{
	nMainStay			= 1,	--是否主将
	nGoOut				= 2,	--是否上阵
	nTmpID				= 3,	--资源id
	nPowerType			= 4,	--战斗类型 1 物理 2 法术
	Quality				= 5,	--资质
	nHitDis				= 6,	--攻击距离
	nInit_Lift			= 7,	--
	Init_gongji 		= 8,	--
	Init_wufang			= 9,	--
	Init_fafang			= 10,	--
	Init_duoshan		= 11,	--
	Init_crit			= 12,	--
	Init_shipo			= 13,	--
	Init_anger			= 14,	--
	Init_engine			= 15,	--
	back_Lift			= 16,	--
	back_engine			= 17,	--
	add_gongji			= 18,	--
	add_fangyu			= 19,	--
	nWuLi				= 20,	--
	nZhiLi				= 21,	--
	nTiLi				= 22,	--
	nStar				= 23,	--
	nColour				= 24,	--
	nTurn				= 25,	--
	nLv					= 26,	--
	danyaoLv			= 27,	--
	danyaoindex			= 28,	--
	curBlood			= 29,	--
}

MatrixData_Talent_Key = 
{
	nID						= 1,	--
	nHurtRatio				= 2,	--
	nPyhDefRatio			= 3,	--
	nMagicDefRatio			= 4,	--
	nBloodRatio				= 5,	--
	nDodgeRatio				= 6,	--
	nFatalRatio				= 7,	--
	nMagicDiscovery 		= 8,	--
	nHitRatio				= 9,	--
}

MatrixData_Skill_Key = 
{
	nID						= 1,	--
	nResID					= 2,	--
	nSkill_hurt_type		= 3,	--
	nSkill_power_type		= 4,	--
	nSkill_site				= 5,	--
	nSkill_type				= 6,	--
	nSkill_paramete			= 7,	--
	nSkill_ratio 			= 8,	--
	nSkill_timecd			= 9,	--
	nSkill_anger_back		= 10,	--
	nSkill_engine_back		= 11,	--
	nSkill_dis				= 12,	--
	nSkill_buff_times		= 13,	--
	nSkill_buff_cd			= 14,	--
	nSkill_buff_chance		= 15,	--
}

