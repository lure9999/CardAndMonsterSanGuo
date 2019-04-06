
--服务器包数据索引定义

CorpsDataType = 1

Corps_Type_Info_Data = {
	Corps_Info_Data_id = 1,
	Corps_Info_Data_name = 2,
	Corps_Info_Data_level = 3,
	Corps_Info_Data_people = 4,
	Corps_Info_Data_needLevel = 5,
	Corps_Info_Data_flag = 6,
	Corps_Info_Data_brief = 7,
}

Corps_Type_Get_Data = {
	Corps_Apply_Data_userID = 1,
	Corps_Apply_Data_faceID = 2,
	Corps_Apply_Data_level = 3,
	Corps_Apply_Data_name = 4,
	Corps_Apply_Data_power = 5,
}

Corps_Type_MemBer_Data = {
	Corps_Member_Data_userID = 1,
	Corps_Member_Data_faceID = 2,
	Corps_Member_Data_level = 3,
	Corps_Member_Data_power = 4,
	Corps_Member_Data_position = 5,
	Corps_Member_Data_lastTime = 6,
	Corps_Member_Data_seven = 7,
	Corps_Member_Data_name = 8,
}

C_MemberStatus = {
	C_MemberLastTime = 1,
	C_MemberWeekContribute = 2,
	C_MemberTotalContribute = 3,
}

C_CORPSCONTENTSTATUS = {
	C_ContentSet = 1,
	C_ContentMember = 2,
	C_ContentDynamic = 3,
}

--科技类型
Science_Type = 
{
	E_SCIENCE_TYPE_CORPS_TREE = 1,	 --军团神树科技
	E_SCIENCE_TYPE_CORPS_MEMBER,		-- 军团成员科技
	E_SCIENCE_TYPE_CORPS_OFFICER,		-- 军团官员科技
	E_SCIENCE_TYPE_CORPS_MESS,			-- 军团食堂科技
	E_SCIENCE_TYPE_CORPS_DONATE,		-- 军团捐献科技
	E_SCIENCE_TYPE_CORPS_SHOP,			-- 军团商店科技
	E_SCIENCE_TYPE_CORPS_MERCENARY,	-- 军团佣兵科技
	E_SCIENCE_TYPE_CORPS_ANIMAL,		-- 军团灵兽科技
	E_SCIENCE_TYPE_CORPS_TASK,			-- 军团任务科技
	E_SCIENCE_TYPE_CORPS_EVENT,		-- 军团事件科技
	E_SCIENCE_TYPE_CORPS_STORAGE,	-- 军团仓库科技
	E_SCIENCE_TYPE_CORPS_BATTLE,		-- 军团战役科技
}
