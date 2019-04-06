-- create by:jjc time:2014.7.16
-- 此文件定义客户端与服务器之间的命令参数
-- 新增加的命令在文件最后添加
-- 请严格遵守，并写好注释

--command
C_GS_GETSRVLIST					= 1003		-- 获取服务器列表
C_GS_LOGIN						= 1004		-- 登录
C_GS_LOGOUT						= 1006		-- 登出
C_GS_JOINMS						= 1007		-- 客户端申请加入ms
MSG_CLIENT_2_GS_END				= 1999		-- 结束
 
GS_C_GETSRVLIST_RETURN			= 2003
GS_C_LOGIN_RETURN				= 2004		-- 登录返回
GS_C_CREATECHAR_RETURN			= 2006		-- 返回创建较色信息
GS_C_JOINMS						= 2007		-- 

MS_GS_LOGIN						= 3004
MS_GS_HEART						= 3005
MS_GS_LOGOUT					= 3006
MS_GS_READY_GO					= 3007		-- MS告诉GS，一切就绪，
MS_GS_PLAYER_JOINMS_RETURN		= 3008      --
MS_GS_LOADING_UI_OK				= 3009		-- MS告诉GS，客户端准备完成，此消息只在玩家登录角色的时候发来
MS_GS_PLAYER_LOST				= 3014		-- MS告诉GS有玩家在MS掉线
MS_GS_PLAYER_QUITMS_RETURN		= 3015		-- 玩家退出返回
MS_GS_HUMAN_LOGIN_TIME			= 3016		--
MS_GS_SAVE_NOTIFY_RESULT		= 3017		-- 账号同时登陆，踢掉前面的
MSG_MS_2_GS_END					= 3999		-- 结束
-- GS向MS发送的消息
MSG_GS_2_MS_BEGIN				= 4000		-- 开始
GS_MS_LOGIN_RETURN				= 4004
GS_MS_HEART						= 4005
GS_MS_PLAYER_JOINMS				= 4008		-- GS告诉MS有玩家新进入此MS，
GS_MS_PLAYER_QUITMS				= 4010		-- GS告诉MS有玩家离开此MS,
GS_MS_PLAYER_LOST				= 4014		-- GS告诉MS有玩家在GS掉线,	
MSG_GS_2_MS_END					= 4999		-- 结束
-- 客户端向MS发送的消息
MSG_CLIENT_2_MS_BEGIN			= 5000		-- 开始
C_MS_HEART						= 5001
C_MS_LOGIN						= 5002	
C_MS_LOGOUT						= 5004		-- 客户端请求基础数据
C_MS_GETBASEDATA				= 5005		-- 创建较色
C_MS_CREATECHAR					= 5006		-- 请求阵法信息
C_MS_GET_RANDOM_NAME			= 5007		-- 更改阵法信息
C_MS_GETMATRIX					= 5010		-- 请求武将列表信息
C_MS_CHANGEMATRIX				= 5011		-- 请求装备列表信息
C_MS_GETGENERALLIST				= 5101		-- 请求装备碎片信息
C_MS_GETGENERALFRAGMENT			= 5102		-- 请求武魂列表信息
C_MS_COMBINGENERALFRAGMENT		= 5103		-- 请求装备上的装备列表信息
C_MS_USEEQUIP					= 5104		-- 合成装备请求
C_MS_GETEQUIPLIST				= 5201		-- 合成武魂请求
C_MS_GETEQUIPFRAGMEN			= 5202		-- 获得物品列表
C_MS_GETEQUIPBASE				= 5203		-- 购买物品
C_MS_GETUSEEQUIPLIST			= 5204		-- 商店商品限制
C_MS_COMBINEQUIPFRAGMENT		= 5205		-- 请求随机名子
C_MS_GETBAGITEMLIST				= 5301		-- 心跳
C_MS_BUYITEM					= 5401		-- 出售一件装备
C_MS_SHOPLIST					= 5402		-- 聊天
C_MS_SELLEQUIP					= 5403		-- 战斗
C_MS_USEITEM_BOX				= 5501		-- 升级
		-- 转生
		-- 使用装备
		-- 使用物品
MSG_CLIENT_2_MS_END				= 5999		-- 结束
-- MS向客户端发送的消息
MSG_MS_2_CLIENT_BEGIN			= 6000		-- 开始
MS_C_HEART_RETURN				= 6001		-- 获得服务器列表
MS_C_LOGIN_RETURN				= 6002		-- 登录返回
MS_C_LOGOUT_RETURN				= 6004		-- 客户端请求基础数据
MS_C_GETBASEDATA_RETURN			= 6005		-- 返回创建较色信息
MS_C_CREATECHAR_RETURN			= 6006		-- 请求阵法信息
MS_C_GET_RANDOM_NAME_RETURN		= 6007		-- 更改阵法信息
MS_C_GETMATRIX_RETURN			= 6010		-- 请求武将列表信息
MS_C_CHANGEMATRIX_RETURN		= 6011		-- 请求装备列表信息
MS_C_GETGENERALLIST_RETURN		= 6101		-- 请求装备碎片信息
MS_C_GETGENERALFRAGMENT_RETURN	= 6102		-- 请求武魂列表信息
MS_C_COMBINGENERALFRAGMENT_RETURN= 6103		-- 请求装备上的装备列表信息
MS_C_USEEQUIP_RETURN			= 6104		-- 获得物品列表
MS_C_GETEQUIPLIST_RETURN		= 6201		-- 购买物品
MS_C_GETEQUIPFRAGMEN_RETURN		= 6202		-- 商店商品限制
MS_C_GETEQUIPBASE_RETURN		= 6203		-- 出售装备返回
MS_C_GETUSEEQUIPLIST_RETURN		= 6204		-- 升级
MS_C_COMBINEQUIPFRAGMENT_RETURN	= 6205		-- 返回战斗信息
MS_C_GETBAGITEMLIST_RETURN		= 6301		-- 转生
MS_C_BUYITEM_RETURN				= 6401		-- 使用物品
MS_C_SHOPLIST_RETURN			= 6402		-- 使用装备
MS_C_SELLEQUIP_RETURN			= 6403
MSG_MS_2_CLIENT_END				= 6999		-- 结束
MS_C_USEITEM_BOX_RETURN			= 6501

-- 传输类型
NET_TYPE_LOGIN					= 100 		-- 登陆
NET_TYPE_GETGENER				= 101 		-- 武将
NET_TYPE_EQUIP					= 102 		-- 装备
NET_TYPE_BATTLE					= 103 		-- 战斗
NET_TYPE_MATRIX					= 104 		-- 布阵
NET_TYPE_BAG					= 105 		-- 包裹
NET_TYPE_SHOP					= 106 		-- 商店






-- 以下数据为测试使用。
C_GS_ADDEPUIPTEN		= 300				-- 一次增加10件装备
GS_C_ADDEPUIPTEN_RETURN	= 301				 

C_GS_ADDITEMTEN			= 302
GS_C_ADDITEMTEN_RETURN	= 303
