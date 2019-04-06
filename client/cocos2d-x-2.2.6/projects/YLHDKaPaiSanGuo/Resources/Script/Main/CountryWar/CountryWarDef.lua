CityEvent_FToCity = 
{ 	
	E_CityEvent_FToCity_PlayerInfo 			=	1,
	E_CityEvent_FToCity_BornCity 			=	2,
	E_CityEvent_FToCity_TargetCity 			=	3,
}

CityRoad_Struct_Pt = 
{
	E_CityRoad_Struct_Pt_X 				=	1,
	E_CityRoad_Struct_Pt_Y 				=	2,
}

CityRoad_Struct_TarGetNode = 
{
	E_CityRoad_Struct_TarGetNode 			=	1,
	E_CityRoad_Struct_TarGetPoint			=	2,
}

CityRoad_Struct = 
{
	E_CityRoad_Struct_Node 					=	1,
	E_CityRoad_Struct_TarGets				=	2,
}

PlayerType = 
{
	E_PlayerType_Main 						= 	1,
	E_PlayerType_1 							= 	2,
	E_PlayerType_2 							= 	3,
	E_PlayerType_3 							= 	4,	
}

PlayerState =
{
	E_PlayerState_Free 						=	1,		--空闲
	E_PlayerState_Move 						=	2,		--移动
	E_PlayerState_CWar 						=	3,		--国战
	E_PlayerState_Battle					=	4,		--上阵
	E_PlayerState_Solo						=	5,		--单挑
	E_PlayerState_Rest 						=	6,		--休息
	E_PlayerState_Give_Way                  =   7,      --撤退
	E_PlayerState_Dart                      =   8,      --突进
	E_PlayerState_Fight                     =   9,      --战斗
	E_PlayerState_BloodWar 					=	10,     --血战
	E_PlayerState_Defense 					=	11, 	--坚守
	E_PlayerState_Misty 					=	12, 	--迷雾战
	E_PlayerState_Cell	 					=	13, 	--牢狱
}

CityEventState = 
{
	E_CityEventState_Retreat 				=	1, 		--撤退
	E_CityEventState_Dart 					=	2, 		--突进
	E_CityEventState_Normal 				=	3, 		--正常
}

COUNTRYWAR_CITY_STATE = {
	COUNTRYWAR_CITY_PEACE				= 1,		--和平
	COUNTRYWAR_CITY_BURN 				= 2,		--交战
	COUNTRYWAR_CITY_LOCATION 			= 3,		--定位
	COUNTRYWAR_CITY_SIEGE	 			= 4,		--围攻
	COUNTRYWAR_CITY_ATTACK	 			= 5,		--可攻击
}

COUNTRY_TYPE = 
{
	COUNTRY_TYPE_WEI 			= 1,		--魏国
	COUNTRY_TYPE_SHU 			= 2, 		--蜀国
	COUNTRY_TYPE_WU 			= 3,  		--吴国
	COUNTRY_TYPE_QUN 			= 4,  		--群雄
	COUNTRY_TYPE_BEIDI 			= 5,  		--北狄
	COUNTRY_TYPE_XIRONG 		= 6,  		--西戎
	COUNTRY_TYPE_DONGYI 		= 7,  		--东夷
	COUNTRY_TYPE_HUANG 			= 8,  		--黄巾军

}

TEAM_ATTR =
{
	Blood 						= 0, 		--战队的总HP
}

CreatePlayerType = {
	Player      = 1,		--玩家佣兵
	ExpeDition  = 2, 		--远征军
}

Country_EventType = {
	BeAttack     = 1,			--可攻击显示
	AnExpeDition = 2,			--远征显示
}

CWAR_EVENTTYPE = {
	LOCKCITY  		= 1, 		--围城的事件逻辑
}
