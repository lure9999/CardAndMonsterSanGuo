
module("FightServer", package.seeall)

require "Script/serverDB/general"
require "Script/serverDB/monst"
require "Script/serverDB/point"
require "Script/serverDB/scence"
require "Script/serverDB/skill"
require "Script/serverDB/talent"


--//测试数据

local tabBattleData = nil


function InittabBattleData()	
	
	tabBattleData = Fight_Scene_Data.Init_FightData()		
end



function InitServerFightData(pServerDataStream)
	
	InittabBattleData()	
	
	local Serverscenid 			= pServerDataStream:Read()
	local PointIndex			= pServerDataStream:Read()
	local Battle_ID				= pServerDataStream:Read()
	tabBattleData.m_dropList	= pServerDataStream:Read()	
	local MatrixData 			= pServerDataStream:Read()
	
	--print(Battle_ID)
	--printTab(tabBattleData.m_dropList)	
	--printTab(MatrixData)	
	
	--FileLog_json("Log_Battle_MatrixData.json",MatrixData)	
	local tabSceneData = scence.getArrDataByField("ID", Serverscenid)
	local nPointIdx = tonumber(scence.getIndexByField("ID_" .. PointIndex))
	local checkpointID = tonumber(tabSceneData[1][nPointIdx])
	-- local checkpointID = tonumber(scence.getFieldByIdAndIndex(Serverscenid,("ID_" .. PointIndex)))	
	local SceneID = tonumber(point.getFieldByIdAndIndex(checkpointID,"ResID"))	
	local AllTimes = tonumber(point.getFieldByIdAndIndex(checkpointID,"times"))	
	
	tabBattleData.m_checkpointID = checkpointID
	tabBattleData.m_SceneID = SceneID
	
	tabBattleData.m_curTimes = 1
	tabBattleData.m_AllTimes = AllTimes
	tabBattleData.m_Battle_ID = Battle_ID
	
	--add by sxin 是否出发情节--服务器传
	tabBattleData.m_CopyData_Star = 0
	
	
	--读取角色数据
	local k = 1
	local playID = -1
	local playGUID = -1
	
	local pMatrixData_Vel = nil
	local pMatrixData_Talent = nil
	local pMatrixData_Skill = nil
		
	for k=1, 5, 1 do
		
		if table.getn(MatrixData[k]) > 0 then
		--if MatrixData[k] ~= nil then
		
			pMatrixData_Vel = MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_Vel]
			pMatrixData_Talent = MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_Talent]
			pMatrixData_Skill = MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_Skill]
			
			playID 		= tonumber(MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_nItemIndexID])
			playGUID 	= tonumber(MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_nSerial][1])	
		else
			
			playID = -1
			playGUID = -1
			pMatrixData_Vel = nil
			pMatrixData_Talent = nil
			pMatrixData_Skill = nil
			
		end
		
		if playID ~= nil and playID > 0 then 
			
			local pgeneralData = general.getDataById(playID)			
			
			tabBattleData.m_TeamData[k].m_Serverid		= playGUID
			tabBattleData.m_TeamData[k].m_TempID		= playID
			tabBattleData.m_TeamData[k].m_name 			= pgeneralData[general.getIndexByField("Name")]
			tabBattleData.m_TeamData[k].m_TempResid = tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTmpID]) 	--tonumber(pgeneralData[general.getIndexByField("ResID")])			
			tabBattleData.m_TeamData[k].m_attack	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nWuLi]) 	--tonumber(pgeneralData[general.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_wisdom	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nZhiLi]) 	--tonumber(pgeneralData[general.getIndexByField("wisdom")])
			tabBattleData.m_TeamData[k].m_strength	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTiLi]) 	--tonumber(pgeneralData[general.getIndexByField("strength")])
			tabBattleData.m_TeamData[k].m_attribute	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nPowerType]) 	--tonumber(pgeneralData[general.getIndexByField("attribute")])			
			tabBattleData.m_TeamData[k].m_level		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nLv]) 	--1									
			tabBattleData.m_TeamData[k].m_star		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nStar]) 	--tonumber(pgeneralData[general.getIndexByField("star")])	
			tabBattleData.m_TeamData[k].m_anger		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_anger]) 	--tonumber(pgeneralData[general.getIndexByField("anger")])	
			tabBattleData.m_TeamData[k].m_engine	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine")])	
			tabBattleData.m_TeamData[k].m_Dis		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nHitDis]) 	--tonumber(pgeneralData[general.getIndexByField("dis")])	
			tabBattleData.m_TeamData[k].m_FightPosType	= 	tonumber(pgeneralData[general.getIndexByField("Pos")])	
			tabBattleData.m_TeamData[k].m_DropItemID	= -1
					
		
			--角色增加4个属性
			tabBattleData.m_TeamData[k].m_blood_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_Lift]) 	--tonumber(pgeneralData[general.getIndexByField("blood_back")])
			tabBattleData.m_TeamData[k].m_engine_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine_back")])
			tabBattleData.m_TeamData[k].m_add_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_gongji]) 	--tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			tabBattleData.m_TeamData[k].m_add_fangyu	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_fangyu]) 	--tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
			tabBattleData.m_TeamData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
			
			
			tabBattleData.m_TeamData[k].m_Talent.m_id = tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nID]) 	--tonumber(pgeneralData[general.getIndexByField("talent")])				
			--local ptalentData = talent.getDataById(tabBattleData.m_TeamData[k].m_Talent.m_id)						
			tabBattleData.m_TeamData[k].m_Talent.m_attack 		= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHurtRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_Talent.m_wufang		= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nPyhDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_TeamData[k].m_Talent.m_fafang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_TeamData[k].m_Talent.m_hp	 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nBloodRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("hp")])	
						
			tabBattleData.m_TeamData[k].m_Talent.m_duoshan	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nDodgeRatio]) 	--tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_TeamData[k].m_Talent.m_crit	 	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nFatalRatio]) 	--tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_TeamData[k].m_Talent.m_penetrate	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDiscovery]) 	--tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_TeamData[k].m_Talent.m_mingzhong	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHitRatio]) 	--tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			--tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji])	 + 10*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_attack
			--tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			--tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			--tabBattleData.m_TeamData[k].m_mingzhong	= 0				
			--tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]) + tabBattleData.m_TeamData[k].m_level*50)*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			
			tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]))
			tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]))
			tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]))
			tabBattleData.m_TeamData[k].m_mingzhong	= 0		
			tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]))					
			
			tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			tabBattleData.m_TeamData[k].m_power		= tabBattleData.m_TeamData[k].m_gongji*2+tabBattleData.m_TeamData[k].m_wufang+tabBattleData.m_TeamData[k].m_fafang+tabBattleData.m_TeamData[k].m_allblood*0.2
			
			
			--技能数据
			--tabBattleData.m_TeamData[k].m_SkillData[1].m_skillid = tonumber(pMatrixData_Skill[1][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			--tabBattleData.m_TeamData[k].m_SkillData[2].m_skillid = tonumber(pMatrixData_Skill[2][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			--tabBattleData.m_TeamData[k].m_SkillData[3].m_skillid = tonumber(pMatrixData_Skill[3][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				--local pskilldata = skill.getDataById(tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid)
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
							
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillresid 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nResID]) --tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skill_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_hurt_type]) --tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_TeamData[k].m_SkillData[m].m_power_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_power_type]) --tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_TeamData[k].m_SkillData[m].m_site 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_site]) --tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_TeamData[k].m_SkillData[m].m_type 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_type]) --tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_paramete 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_paramete])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_ratio 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_ratio])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_TeamData[k].m_SkillData[m].m_timecd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_timecd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_TeamData[k].m_SkillData[m].m_SkillRadius	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_dis]) --tonumber(pskilldata[skill.getIndexByField("dis")])
				
				--技能怒气回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_anger_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_anger_back]) --tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_engine_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_engine_back]) --tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_TeamData[k].m_SkillData[m].m_bufftimes 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_times]) --tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffcd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_cd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffchace 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_chance]) --tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
							
		end
	
	end
	
	--角色的护法
		
	if table.getn(MatrixData[6]) > 0 then
	
		pMatrixData_Vel = MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Vel]
		pMatrixData_Talent = MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Talent]
		pMatrixData_Skill = MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Skill]
		
		playID 		= tonumber(MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_nItemIndexID])
		playGUID 	= tonumber(MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_nSerial][1])	
	else
	
		playID = -1
		playGUID = -1
	end		
	
	if playID ~= nil and playID > 0 then 
		k = 1
		local pgeneralData = general.getDataById(playID)			
		
		tabBattleData.m_HufaData[k].m_Serverid		= playGUID
		tabBattleData.m_HufaData[k].m_TempID		= playID
		tabBattleData.m_HufaData[k].m_name 			= pgeneralData[general.getIndexByField("Name")]
		tabBattleData.m_HufaData[k].m_TempResid  	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTmpID]) 	--tonumber(pgeneralData[general.getIndexByField("ResID")])			
		tabBattleData.m_HufaData[k].m_attack		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nWuLi]) 	--tonumber(pgeneralData[general.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_wisdom		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nZhiLi]) 	--tonumber(pgeneralData[general.getIndexByField("wisdom")])
		tabBattleData.m_HufaData[k].m_strength		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTiLi]) 	--tonumber(pgeneralData[general.getIndexByField("strength")])
		tabBattleData.m_HufaData[k].m_attribute		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nPowerType]) 	--tonumber(pgeneralData[general.getIndexByField("attribute")])			
		tabBattleData.m_HufaData[k].m_level			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nLv]) 	--1	
		
		tabBattleData.m_HufaData[k].m_star			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nStar]) 	--tonumber(pgeneralData[general.getIndexByField("star")])	
		tabBattleData.m_HufaData[k].m_anger			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_anger]) 	--tonumber(pgeneralData[general.getIndexByField("anger")])	
		tabBattleData.m_HufaData[k].m_engine		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine")])
		tabBattleData.m_HufaData[k].m_Dis			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nHitDis]) 	--tonumber(pgeneralData[general.getIndexByField("dis")])	
		tabBattleData.m_HufaData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
		tabBattleData.m_HufaData[k].m_DropItemID	= -1	
			
		--角色增加4个属性
		tabBattleData.m_HufaData[k].m_blood_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_Lift]) 	--tonumber(pgeneralData[general.getIndexByField("blood_back")])
		tabBattleData.m_HufaData[k].m_engine_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine_back")])
		tabBattleData.m_HufaData[k].m_add_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_gongji]) 	--tonumber(pgeneralData[general.getIndexByField("add_gongi")])
		tabBattleData.m_HufaData[k].m_add_fangyu	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_fangyu]) 	--tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
		tabBattleData.m_HufaData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
		
		tabBattleData.m_HufaData[k].m_Talent.m_id 			= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nID]) 	--tonumber(pgeneralData[general.getIndexByField("talent")])				
		local ptalentData = talent.getDataById(tabBattleData.m_HufaData[k].m_Talent.m_id)						
		tabBattleData.m_HufaData[k].m_Talent.m_attack 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHurtRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_Talent.m_wufang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nPyhDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("wufang")])
		tabBattleData.m_HufaData[k].m_Talent.m_fafang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("fafang")])
		tabBattleData.m_HufaData[k].m_Talent.m_hp	 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nBloodRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("hp")])	
		tabBattleData.m_HufaData[k].m_Talent.m_duoshan	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nDodgeRatio]) 	--tonumber(ptalentData[talent.getIndexByField("duoshan")])
		tabBattleData.m_HufaData[k].m_Talent.m_crit	 	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nFatalRatio]) 	--tonumber(ptalentData[talent.getIndexByField("crit")])
		tabBattleData.m_HufaData[k].m_Talent.m_penetrate	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDiscovery]) 	--tonumber(ptalentData[talent.getIndexByField("shipo")])
		tabBattleData.m_HufaData[k].m_Talent.m_mingzhong	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHitRatio]) 	--tonumber(ptalentData[talent.getIndexByField("mingzhong")])
		

		--tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]) + 10*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_attack
		--tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_wufang
		--tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_fafang
		--tabBattleData.m_HufaData[k].m_mingzhong	= 0				
		--tabBattleData.m_HufaData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]) + tabBattleData.m_HufaData[k].m_level*50)*(1+(tabBattleData.m_HufaData[k].m_strength -50)*0.01)*tabBattleData.m_HufaData[k].m_Talent.m_hp					
		--tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		
		tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]))
		tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]))
		tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]))
		tabBattleData.m_HufaData[k].m_mingzhong	= 0				
		tabBattleData.m_HufaData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]))					
		tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		
		tabBattleData.m_HufaData[k].m_power		= tabBattleData.m_HufaData[k].m_gongji*2+tabBattleData.m_HufaData[k].m_wufang+tabBattleData.m_HufaData[k].m_fafang+tabBattleData.m_HufaData[k].m_allblood*0.2
				
		
		local m = 1
		for m=1,3,1 do
			
			--local pskilldata = skill.getDataById(tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid)
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillresid 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nResID]) --tonumber(pskilldata[skill.getIndexByField("resID")])
			--//释放条件
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skill_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_hurt_type]) --tonumber(pskilldata[skill.getIndexByField("hurt_type")])
			--//伤害类型 1物理 2法术
			tabBattleData.m_HufaData[k].m_SkillData[m].m_power_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_power_type]) --tonumber(pskilldata[skill.getIndexByField("power_type")])
			--//施法对象	
			tabBattleData.m_HufaData[k].m_SkillData[m].m_site 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_site]) --tonumber(pskilldata[skill.getIndexByField("site")])
			--//技能类型
			tabBattleData.m_HufaData[k].m_SkillData[m].m_type 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_type]) --tonumber(pskilldata[skill.getIndexByField("type")])
			--//效果参数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_paramete 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_paramete])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("paramete")])
			--//伤害系数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_ratio 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_ratio])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("ratio")])
			--//技能cd
			tabBattleData.m_HufaData[k].m_SkillData[m].m_timecd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_timecd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("timecd")])	
			--技能距离
			tabBattleData.m_HufaData[k].m_SkillData[m].m_SkillRadius 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_dis]) --tonumber(pskilldata[skill.getIndexByField("dis")])
			--技能怒气回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_anger_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_anger_back]) --tonumber(pskilldata[skill.getIndexByField("anger_back")])
			--技能能量回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_engine_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_engine_back]) --tonumber(pskilldata[skill.getIndexByField("engine_back")])
			--buff 类扩展
			tabBattleData.m_HufaData[k].m_SkillData[m].m_bufftimes 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_times]) --tonumber(pskilldata[skill.getIndexByField("buff_times")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffcd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_cd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("buff_cd")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffchace 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_chance]) --tonumber(pskilldata[skill.getIndexByField("buff_chance")])
		end
						
	end
	
	---怪的
	local i=1
	local j=0
	local index = -1
	local IMonstID = -1
	
	
	
	for i=1, AllTimes, 1 do
		
		for j=1 , 5 , 1 do
			
			local Keys = "POS_" .. i .. "_" .. j
			--print(Keys)
			
			
			IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))
			--print(IMonstID)
			--Pause()
			
			if IMonstID >0 then
			
				index = i*5 + j
				
				local pmonstData = monst.getDataById(IMonstID)			
			
				tabBattleData.m_TeamData[index].m_Serverid		= 20000+index
				tabBattleData.m_TeamData[index].m_TempID		= IMonstID
				
				tabBattleData.m_TeamData[index].m_name = pmonstData[monst.getIndexByField("Name")]
				tabBattleData.m_TeamData[index].m_TempResid  = tonumber(pmonstData[monst.getIndexByField("resID")])			
				tabBattleData.m_TeamData[index].m_attack	= tonumber(pmonstData[monst.getIndexByField("attack")])
				tabBattleData.m_TeamData[index].m_wisdom	= tonumber(pmonstData[monst.getIndexByField("wisdom")])
				tabBattleData.m_TeamData[index].m_strength	= tonumber(pmonstData[monst.getIndexByField("strength")])
				tabBattleData.m_TeamData[index].m_attribute	= tonumber(pmonstData[monst.getIndexByField("attribute")])			
				tabBattleData.m_TeamData[index].m_level		= tonumber(pmonstData[monst.getIndexByField("Level")])										
				tabBattleData.m_TeamData[index].m_star		= 1
				tabBattleData.m_TeamData[index].m_anger		= tonumber(pmonstData[monst.getIndexByField("anger")])
				tabBattleData.m_TeamData[index].m_engine	= tonumber(pmonstData[monst.getIndexByField("engine")])
				tabBattleData.m_TeamData[index].m_Dis		= tonumber(pmonstData[monst.getIndexByField("dis")])	
				tabBattleData.m_TeamData[index].m_FightPosType	= 0	
				tabBattleData.m_TeamData[index].m_DropItemID	= tonumber(pmonstData[monst.getIndexByField("DropID")])	
				--增加限制免疫状态	
				tabBattleData.m_TeamData[index].m_blood_back	= tonumber(pmonstData[monst.getIndexByField("blood_back")])
				tabBattleData.m_TeamData[index].m_engine_back	= tonumber(pmonstData[monst.getIndexByField("engine_back")])
				tabBattleData.m_TeamData[index].m_add_gongji	= tonumber(pmonstData[monst.getIndexByField("add_gongi")])
				tabBattleData.m_TeamData[index].m_add_fangyu	= tonumber(pmonstData[monst.getIndexByField("add_fangyu")])
				tabBattleData.m_TeamData[index].m_State_immune	= tonumber(pmonstData[monst.getIndexByField("State_immune")])
				
				tabBattleData.m_TeamData[index].m_Talent.m_id = tonumber(pmonstData[monst.getIndexByField("talent")])	
				
				local ptalentData = talent.getDataById(tabBattleData.m_TeamData[index].m_Talent.m_id)	
				
				tabBattleData.m_TeamData[index].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
				tabBattleData.m_TeamData[index].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
				tabBattleData.m_TeamData[index].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
				tabBattleData.m_TeamData[index].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")]	)
				tabBattleData.m_TeamData[index].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
				tabBattleData.m_TeamData[index].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
				tabBattleData.m_TeamData[index].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
				tabBattleData.m_TeamData[index].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])			
				
				tabBattleData.m_TeamData[index].m_gongji	= tonumber(pmonstData[monst.getIndexByField("gongji")])*tabBattleData.m_TeamData[index].m_Talent.m_attack	
				tabBattleData.m_TeamData[index].m_wufang	= tonumber(pmonstData[monst.getIndexByField("wufang")])*tabBattleData.m_TeamData[index].m_Talent.m_wufang	
				tabBattleData.m_TeamData[index].m_fafang	= tonumber(pmonstData[monst.getIndexByField("fafang")])*tabBattleData.m_TeamData[index].m_Talent.m_fafang	
				tabBattleData.m_TeamData[index].m_mingzhong	= 0				
				tabBattleData.m_TeamData[index].m_allblood	= (tonumber(pmonstData[monst.getIndexByField("Hp")]))*(1+(tabBattleData.m_TeamData[index].m_strength -50)*0.01)*tabBattleData.m_TeamData[index].m_Talent.m_hp										
							
				tabBattleData.m_TeamData[index].m_curblood	= tonumber(tabBattleData.m_TeamData[index].m_allblood)	
				tabBattleData.m_TeamData[index].m_power		= 0
							
				
				tabBattleData.m_TeamData[index].m_SkillData[1].m_skillid = tonumber(pmonstData[monst.getIndexByField("attack_id")])
				tabBattleData.m_TeamData[index].m_SkillData[2].m_skillid = tonumber(pmonstData[monst.getIndexByField("skill_ID")])
				tabBattleData.m_TeamData[index].m_SkillData[3].m_skillid = tonumber(pmonstData[monst.getIndexByField("engine_ID")])
				local m = 1
				for m=1,3,1 do
					
					local pskilldata = skill.getDataById(tabBattleData.m_TeamData[index].m_SkillData[m].m_skillid)
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
					--//释放条件
					tabBattleData.m_TeamData[index].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
					--//伤害类型 1物理 2法术
					tabBattleData.m_TeamData[index].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
					--//施法对象	
					tabBattleData.m_TeamData[index].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
					--//技能类型
					tabBattleData.m_TeamData[index].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
					--//效果参数
					tabBattleData.m_TeamData[index].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
					--//伤害系数
					tabBattleData.m_TeamData[index].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
					--//技能cd
					tabBattleData.m_TeamData[index].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
					--技能距离
					tabBattleData.m_TeamData[index].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
					--技能怒气回复
					tabBattleData.m_TeamData[index].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
					--技能能量回复
					tabBattleData.m_TeamData[index].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
					
					--buff 类扩展
					tabBattleData.m_TeamData[index].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
				end						
							
							
			end
		
		end
		
		---怪的护法
		local Keys = "hufa_" .. i
				
		IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))	
		
		if IMonstID >0 then
		
			index = i + 1
			
			local pmonstData = monst.getDataById(IMonstID)			
		
			tabBattleData.m_HufaData[index].m_Serverid		= 20000+index
			tabBattleData.m_HufaData[index].m_TempID		= IMonstID
			
			tabBattleData.m_HufaData[index].m_name = pmonstData[monst.getIndexByField("Name")]
			tabBattleData.m_HufaData[index].m_TempResid  = tonumber(pmonstData[monst.getIndexByField("resID")])			
			tabBattleData.m_HufaData[index].m_attack	= tonumber(pmonstData[monst.getIndexByField("attack")])
			tabBattleData.m_HufaData[index].m_wisdom	= tonumber(pmonstData[monst.getIndexByField("wisdom")])
			tabBattleData.m_HufaData[index].m_strength	= tonumber(pmonstData[monst.getIndexByField("strength")])
			tabBattleData.m_HufaData[index].m_attribute	= tonumber(pmonstData[monst.getIndexByField("attribute")])			
			tabBattleData.m_HufaData[index].m_level		= tonumber(pmonstData[monst.getIndexByField("Level")])										
			tabBattleData.m_HufaData[index].m_star		= 1
			tabBattleData.m_HufaData[index].m_anger		= tonumber(pmonstData[monst.getIndexByField("anger")])
			tabBattleData.m_HufaData[index].m_engine	= tonumber(pmonstData[monst.getIndexByField("engine")])
			tabBattleData.m_HufaData[index].m_Dis		= tonumber(pmonstData[monst.getIndexByField("dis")])	
			tabBattleData.m_HufaData[index].m_FightPosType	= 0	
			tabBattleData.m_HufaData[index].m_DropItemID	= tonumber(pmonstData[monst.getIndexByField("DropID")])	

			tabBattleData.m_HufaData[index].m_blood_back	= tonumber(pmonstData[monst.getIndexByField("blood_back")])
			tabBattleData.m_HufaData[index].m_engine_back	= tonumber(pmonstData[monst.getIndexByField("engine_back")])
			tabBattleData.m_HufaData[index].m_add_gongji	= tonumber(pmonstData[monst.getIndexByField("add_gongi")])
			tabBattleData.m_HufaData[index].m_add_fangyu	= tonumber(pmonstData[monst.getIndexByField("add_fangyu")])
			tabBattleData.m_HufaData[index].m_State_immune	= tonumber(pmonstData[monst.getIndexByField("State_immune")])
		
			tabBattleData.m_HufaData[index].m_Talent.m_id = tonumber(pmonstData[monst.getIndexByField("talent")])	
			
			local ptalentData = talent.getDataById(tabBattleData.m_HufaData[index].m_Talent.m_id)	
			
			tabBattleData.m_HufaData[index].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_HufaData[index].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_HufaData[index].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_HufaData[index].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")]	)
			tabBattleData.m_HufaData[index].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_HufaData[index].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_HufaData[index].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_HufaData[index].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			
			
			tabBattleData.m_HufaData[index].m_gongji	= tonumber(pmonstData[monst.getIndexByField("gongji")])	*tabBattleData.m_HufaData[index].m_Talent.m_attack
			tabBattleData.m_HufaData[index].m_wufang	= tonumber(pmonstData[monst.getIndexByField("wufang")])	*tabBattleData.m_HufaData[index].m_Talent.m_wufang
			tabBattleData.m_HufaData[index].m_fafang	= tonumber(pmonstData[monst.getIndexByField("fafang")])	*tabBattleData.m_HufaData[index].m_Talent.m_fafang
			tabBattleData.m_HufaData[index].m_mingzhong	= 0				
			tabBattleData.m_HufaData[index].m_allblood	= tonumber(pmonstData[monst.getIndexByField("Hp")])						
			tabBattleData.m_HufaData[index].m_curblood	= tonumber(tabBattleData.m_HufaData[index].m_allblood)	
			tabBattleData.m_HufaData[index].m_power		= 0
			
			
			
			tabBattleData.m_HufaData[index].m_SkillData[1].m_skillid = tonumber(pmonstData[monst.getIndexByField("attack_id")])
			tabBattleData.m_HufaData[index].m_SkillData[2].m_skillid = tonumber(pmonstData[monst.getIndexByField("skill_ID")])
			tabBattleData.m_HufaData[index].m_SkillData[3].m_skillid = tonumber(pmonstData[monst.getIndexByField("engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(tabBattleData.m_HufaData[index].m_SkillData[m].m_skillid)
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_HufaData[index].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_HufaData[index].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_HufaData[index].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_HufaData[index].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_HufaData[index].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_HufaData[index].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_HufaData[index].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_HufaData[index].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
				
				--技能怒气回复
				tabBattleData.m_HufaData[index].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_HufaData[index].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_HufaData[index].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end						
						
						
		end	
	
	end	
	
	--FileLog_json("Log_Battle_tabBattleData.json",tabBattleData)	
	--Pause()
	
	return tabBattleData
end

--给脚本动态创建一个剧情角色 服务器不知道的
function CreatPlayData( ipos, iTempID)
	
	if BaseSceneDB.IsNpc(ipos) == false then	
		
		local PlayData = BaseSceneDB.GetTeamData(ipos)	
		
		if PlayData.m_TempID > 0 then 
			
			return false
			
		end
		
		if iTempID ~= nil and iTempID > 0 then 			
			
			local pgeneralData = general.getDataById(iTempID)			
			
			PlayData.m_Serverid		= -1
			PlayData.m_TempID		= iTempID
			PlayData.m_name 		= pgeneralData[general.getIndexByField("Name")]
			PlayData.m_TempResid  	= tonumber(pgeneralData[general.getIndexByField("ResID")])			
			PlayData.m_attack		= tonumber(pgeneralData[general.getIndexByField("attack")])
			PlayData.m_wisdom		= tonumber(pgeneralData[general.getIndexByField("wisdom")])
			PlayData.m_strength		= tonumber(pgeneralData[general.getIndexByField("strength")])
			PlayData.m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
			PlayData.m_level		= 1										
			PlayData.m_star			= tonumber(pgeneralData[general.getIndexByField("star")])	
			PlayData.m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])	
			PlayData.m_engine		= tonumber(pgeneralData[general.getIndexByField("engine")])	
			PlayData.m_Dis			= tonumber(pgeneralData[general.getIndexByField("dis")])	
			PlayData.m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
			PlayData.m_DropItemID	= -1
			
			--角色增加4个属性
			PlayData.m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
			PlayData.m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
			PlayData.m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			PlayData.m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
			PlayData.m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
			
			
			PlayData.m_Talent.m_id 			= tonumber(pgeneralData[general.getIndexByField("talent")])				
			local ptalentData 				= talent.getDataById(PlayData.m_Talent.m_id)						
			PlayData.m_Talent.m_attack 	 	= tonumber(ptalentData[talent.getIndexByField("attack")])
			PlayData.m_Talent.m_wufang	 	= tonumber(ptalentData[talent.getIndexByField("wufang")])
			PlayData.m_Talent.m_fafang	 	= tonumber(ptalentData[talent.getIndexByField("fafang")])
			PlayData.m_Talent.m_hp	 	 	= tonumber(ptalentData[talent.getIndexByField("hp")])	
			PlayData.m_Talent.m_duoshan	 	= tonumber(ptalentData[talent.getIndexByField("duoshan")])
			PlayData.m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			PlayData.m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			PlayData.m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			PlayData.m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*PlayData.m_level)*PlayData.m_Talent.m_attack
			PlayData.m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*PlayData.m_level)*PlayData.m_Talent.m_wufang
			PlayData.m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*PlayData.m_level)*PlayData.m_Talent.m_fafang
			PlayData.m_mingzhong	= 0				
			PlayData.m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + PlayData.m_level*50)*(1+(PlayData.m_strength -50)*0.01)*PlayData.m_Talent.m_hp					
			PlayData.m_curblood	= PlayData.m_allblood	
			PlayData.m_power		= PlayData.m_gongji*2+PlayData.m_wufang+PlayData.m_fafang+PlayData.m_allblood*0.2
			
			
			
			PlayData.m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			PlayData.m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			PlayData.m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(PlayData.m_SkillData[m].m_skillid)
				
				PlayData.m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				PlayData.m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				PlayData.m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				PlayData.m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				PlayData.m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				PlayData.m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				PlayData.m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				PlayData.m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				PlayData.m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])
				
				--技能怒气回复
				PlayData.m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				PlayData.m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				PlayData.m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				PlayData.m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				PlayData.m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
			
			return true
							
		end		
		
	end
		
	return false	
end

--先写死cg数据
function InitCGFightData(pointID)

	InittabBattleData()	

	local checkpointID = pointID

	local SceneID = tonumber(point.getFieldByIdAndIndex(checkpointID,"ResID"))	
	local AllTimes = tonumber(point.getFieldByIdAndIndex(checkpointID,"times"))	
	
	tabBattleData.m_checkpointID = checkpointID
	tabBattleData.m_SceneID = SceneID
	
	tabBattleData.m_curTimes = 1
	tabBattleData.m_AllTimes = AllTimes
	tabBattleData.m_Battle_ID = FightbattleData.CreateBattleID()
	tabBattleData.m_CopyData_Star = 0	
		
	local pPlaytbale = {}
	local pPlaytGuidtbale = {}		
	local layDataTable = CommonInterface.getMatrixForFight()
	
	if layDataTable ~= nil then 
		local t=1
		for t=1, 6, 1 do
			
			pPlaytbale[t] = layDataTable[t]["TempID"]
			pPlaytGuidtbale[t] = layDataTable[t]["GID"]
		end
	end	
		
	local k = 1
	local playID = -1
	local playGUID = -1
	for k=1, 5, 1 do
		
		playID = pPlaytbale[k]
		playGUID = pPlaytGuidtbale[k]
		if playID ~= nil and playID > 0 then 
			
			local pgeneralData = general.getDataById(playID)			
			
			tabBattleData.m_TeamData[k].m_Serverid		= playGUID
			tabBattleData.m_TeamData[k].m_TempID		= playID
			tabBattleData.m_TeamData[k].m_name = pgeneralData[general.getIndexByField("Name")]
			tabBattleData.m_TeamData[k].m_TempResid  = tonumber(pgeneralData[general.getIndexByField("ResID")])			
			tabBattleData.m_TeamData[k].m_attack	= tonumber(pgeneralData[general.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_wisdom	= tonumber(pgeneralData[general.getIndexByField("wisdom")])
			tabBattleData.m_TeamData[k].m_strength	= tonumber(pgeneralData[general.getIndexByField("strength")])
			tabBattleData.m_TeamData[k].m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
			tabBattleData.m_TeamData[k].m_level		= 1										
			tabBattleData.m_TeamData[k].m_star		= tonumber(pgeneralData[general.getIndexByField("star")])	
			tabBattleData.m_TeamData[k].m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])	
			tabBattleData.m_TeamData[k].m_engine	= tonumber(pgeneralData[general.getIndexByField("engine")])	
			tabBattleData.m_TeamData[k].m_Dis		= tonumber(pgeneralData[general.getIndexByField("dis")])	
			tabBattleData.m_TeamData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
			tabBattleData.m_TeamData[k].m_DropItemID	= -1
			
			--角色增加4个属性
			tabBattleData.m_TeamData[k].m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
			tabBattleData.m_TeamData[k].m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
			tabBattleData.m_TeamData[k].m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			tabBattleData.m_TeamData[k].m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
			tabBattleData.m_TeamData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
			
			
			tabBattleData.m_TeamData[k].m_Talent.m_id = tonumber(pgeneralData[general.getIndexByField("talent")])				
			local ptalentData = talent.getDataById(tabBattleData.m_TeamData[k].m_Talent.m_id)						
			tabBattleData.m_TeamData[k].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_TeamData[k].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_TeamData[k].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")])	
			tabBattleData.m_TeamData[k].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_TeamData[k].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_TeamData[k].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_TeamData[k].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_attack
			tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			tabBattleData.m_TeamData[k].m_mingzhong	= 0				
			tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + tabBattleData.m_TeamData[k].m_level*50)*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			tabBattleData.m_TeamData[k].m_power		= tabBattleData.m_TeamData[k].m_gongji*2+tabBattleData.m_TeamData[k].m_wufang+tabBattleData.m_TeamData[k].m_fafang+tabBattleData.m_TeamData[k].m_allblood*0.2
			
			
			
			tabBattleData.m_TeamData[k].m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			tabBattleData.m_TeamData[k].m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			tabBattleData.m_TeamData[k].m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid)
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_TeamData[k].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_TeamData[k].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_TeamData[k].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_TeamData[k].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_TeamData[k].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])
				
				--技能怒气回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_TeamData[k].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
							
		end
	
	end
	
	--角色的护法
	playID = pPlaytbale[6]
	if playID ~= nil and playID > 0 then 
		k = 1
		local pgeneralData = general.getDataById(playID)			
		
		tabBattleData.m_HufaData[k].m_Serverid		= 10000+k
		tabBattleData.m_HufaData[k].m_TempID		= playID
		tabBattleData.m_HufaData[k].m_name = pgeneralData[general.getIndexByField("Name")]
		tabBattleData.m_HufaData[k].m_TempResid  = tonumber(pgeneralData[general.getIndexByField("ResID")])			
		tabBattleData.m_HufaData[k].m_attack	= tonumber(pgeneralData[general.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_wisdom	= tonumber(pgeneralData[general.getIndexByField("wisdom")])
		tabBattleData.m_HufaData[k].m_strength	= tonumber(pgeneralData[general.getIndexByField("strength")])
		tabBattleData.m_HufaData[k].m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
		tabBattleData.m_HufaData[k].m_level		= 1										
		tabBattleData.m_HufaData[k].m_star		= tonumber(pgeneralData[general.getIndexByField("star")])	
		tabBattleData.m_HufaData[k].m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])	
		tabBattleData.m_HufaData[k].m_engine	= tonumber(pgeneralData[general.getIndexByField("engine")])
		tabBattleData.m_HufaData[k].m_Dis		= tonumber(pgeneralData[general.getIndexByField("dis")])	
		tabBattleData.m_HufaData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
		tabBattleData.m_HufaData[k].m_DropItemID	= -1	
			
		--角色增加4个属性
		tabBattleData.m_HufaData[k].m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
		tabBattleData.m_HufaData[k].m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
		tabBattleData.m_HufaData[k].m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
		tabBattleData.m_HufaData[k].m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
		tabBattleData.m_HufaData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
		
		tabBattleData.m_HufaData[k].m_Talent.m_id = tonumber(pgeneralData[general.getIndexByField("talent")])				
		local ptalentData = talent.getDataById(tabBattleData.m_HufaData[k].m_Talent.m_id)						
		tabBattleData.m_HufaData[k].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
		tabBattleData.m_HufaData[k].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
		tabBattleData.m_HufaData[k].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")])	
		tabBattleData.m_HufaData[k].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
		tabBattleData.m_HufaData[k].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
		tabBattleData.m_HufaData[k].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
		tabBattleData.m_HufaData[k].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
		

		tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_attack
		tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_wufang
		tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_fafang
		tabBattleData.m_HufaData[k].m_mingzhong	= 0				
		tabBattleData.m_HufaData[k].m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + tabBattleData.m_HufaData[k].m_level*50)*(1+(tabBattleData.m_HufaData[k].m_strength -50)*0.01)*tabBattleData.m_HufaData[k].m_Talent.m_hp					
		tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		tabBattleData.m_HufaData[k].m_power		= tabBattleData.m_HufaData[k].m_gongji*2+tabBattleData.m_HufaData[k].m_wufang+tabBattleData.m_HufaData[k].m_fafang+tabBattleData.m_HufaData[k].m_allblood*0.2
		
		
		
		tabBattleData.m_HufaData[k].m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
		tabBattleData.m_HufaData[k].m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
		tabBattleData.m_HufaData[k].m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
		local m = 1
		for m=1,3,1 do
			
			local pskilldata = skill.getDataById(tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid)
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
			--//释放条件
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
			--//伤害类型 1物理 2法术
			tabBattleData.m_HufaData[k].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
			--//施法对象	
			tabBattleData.m_HufaData[k].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
			--//技能类型
			tabBattleData.m_HufaData[k].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
			--//效果参数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
			--//伤害系数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
			--//技能cd
			tabBattleData.m_HufaData[k].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
			--技能距离
			tabBattleData.m_HufaData[k].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])
			--技能怒气回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
			--技能能量回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
			--buff 类扩展
			tabBattleData.m_HufaData[k].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
		end
						
	end
	
	
		
	---怪的
	local i=1
	local j=0
	local index = -1
	local IMonstID = -1
	
	
	
	for i=1, AllTimes, 1 do
		
		for j=1 , 5 , 1 do
			
			local Keys = "POS_" .. i .. "_" .. j
			--print(Keys)
			
			
			IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))
			--print(IMonstID)
			--Pause()
			
			if IMonstID >0 then
			
				index = i*5 + j
				
				local pmonstData = monst.getDataById(IMonstID)			
			
				tabBattleData.m_TeamData[index].m_Serverid		= 20000+index
				tabBattleData.m_TeamData[index].m_TempID		= IMonstID
				
				tabBattleData.m_TeamData[index].m_name = pmonstData[monst.getIndexByField("Name")]
				tabBattleData.m_TeamData[index].m_TempResid  = tonumber(pmonstData[monst.getIndexByField("resID")])			
				tabBattleData.m_TeamData[index].m_attack	= tonumber(pmonstData[monst.getIndexByField("attack")])
				tabBattleData.m_TeamData[index].m_wisdom	= tonumber(pmonstData[monst.getIndexByField("wisdom")])
				tabBattleData.m_TeamData[index].m_strength	= tonumber(pmonstData[monst.getIndexByField("strength")])
				tabBattleData.m_TeamData[index].m_attribute	= tonumber(pmonstData[monst.getIndexByField("attribute")])			
				tabBattleData.m_TeamData[index].m_level		= tonumber(pmonstData[monst.getIndexByField("Level")])										
				tabBattleData.m_TeamData[index].m_star		= 1
				tabBattleData.m_TeamData[index].m_anger		= tonumber(pmonstData[monst.getIndexByField("anger")])
				tabBattleData.m_TeamData[index].m_engine	= tonumber(pmonstData[monst.getIndexByField("engine")])
				tabBattleData.m_TeamData[index].m_Dis		= tonumber(pmonstData[monst.getIndexByField("dis")])	
				tabBattleData.m_TeamData[index].m_FightPosType	= 0	
				tabBattleData.m_TeamData[index].m_DropItemID	= tonumber(pmonstData[monst.getIndexByField("DropID")])	
				--增加限制免疫状态	
				tabBattleData.m_TeamData[index].m_blood_back	= tonumber(pmonstData[monst.getIndexByField("blood_back")])
				tabBattleData.m_TeamData[index].m_engine_back	= tonumber(pmonstData[monst.getIndexByField("engine_back")])
				tabBattleData.m_TeamData[index].m_add_gongji	= tonumber(pmonstData[monst.getIndexByField("add_gongi")])
				tabBattleData.m_TeamData[index].m_add_fangyu	= tonumber(pmonstData[monst.getIndexByField("add_fangyu")])
				tabBattleData.m_TeamData[index].m_State_immune	= tonumber(pmonstData[monst.getIndexByField("State_immune")])
				
				tabBattleData.m_TeamData[index].m_Talent.m_id = tonumber(pmonstData[monst.getIndexByField("talent")])	
				
				local ptalentData = talent.getDataById(tabBattleData.m_TeamData[index].m_Talent.m_id)	
				
				tabBattleData.m_TeamData[index].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
				tabBattleData.m_TeamData[index].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
				tabBattleData.m_TeamData[index].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
				tabBattleData.m_TeamData[index].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")]	)
				tabBattleData.m_TeamData[index].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
				tabBattleData.m_TeamData[index].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
				tabBattleData.m_TeamData[index].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
				tabBattleData.m_TeamData[index].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
				

				tabBattleData.m_TeamData[index].m_gongji	= tonumber(pmonstData[monst.getIndexByField("gongji")])	
				tabBattleData.m_TeamData[index].m_wufang	= tonumber(pmonstData[monst.getIndexByField("wufang")])	
				tabBattleData.m_TeamData[index].m_fafang	= tonumber(pmonstData[monst.getIndexByField("fafang")])	
				tabBattleData.m_TeamData[index].m_mingzhong	= 0				
				tabBattleData.m_TeamData[index].m_allblood	= tonumber(pmonstData[monst.getIndexByField("Hp")])						
				tabBattleData.m_TeamData[index].m_curblood	= tonumber(tabBattleData.m_TeamData[index].m_allblood)	
				tabBattleData.m_TeamData[index].m_power		= 0
				
				
				
				tabBattleData.m_TeamData[index].m_SkillData[1].m_skillid = tonumber(pmonstData[monst.getIndexByField("attack_id")])
				tabBattleData.m_TeamData[index].m_SkillData[2].m_skillid = tonumber(pmonstData[monst.getIndexByField("skill_ID")])
				tabBattleData.m_TeamData[index].m_SkillData[3].m_skillid = tonumber(pmonstData[monst.getIndexByField("engine_ID")])
				local m = 1
				for m=1,3,1 do
					
					local pskilldata = skill.getDataById(tabBattleData.m_TeamData[index].m_SkillData[m].m_skillid)
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
					--//释放条件
					tabBattleData.m_TeamData[index].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
					--//伤害类型 1物理 2法术
					tabBattleData.m_TeamData[index].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
					--//施法对象	
					tabBattleData.m_TeamData[index].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
					--//技能类型
					tabBattleData.m_TeamData[index].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
					--//效果参数
					tabBattleData.m_TeamData[index].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
					--//伤害系数
					tabBattleData.m_TeamData[index].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
					--//技能cd
					tabBattleData.m_TeamData[index].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
					--技能距离
					tabBattleData.m_TeamData[index].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
					--技能怒气回复
					tabBattleData.m_TeamData[index].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
					--技能能量回复
					tabBattleData.m_TeamData[index].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
					
					--buff 类扩展
					tabBattleData.m_TeamData[index].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
				end						
							
							
			end
		
		end
		
		---怪的护法
		local Keys = "hufa_" .. i
				
		IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))	
		
		if IMonstID >0 then
		
			index = i + 1
			
			local pmonstData = monst.getDataById(IMonstID)			
		
			tabBattleData.m_HufaData[index].m_Serverid		= 20000+index
			tabBattleData.m_HufaData[index].m_TempID		= IMonstID
			
			tabBattleData.m_HufaData[index].m_name = pmonstData[monst.getIndexByField("Name")]
			tabBattleData.m_HufaData[index].m_TempResid  = tonumber(pmonstData[monst.getIndexByField("resID")])			
			tabBattleData.m_HufaData[index].m_attack	= tonumber(pmonstData[monst.getIndexByField("attack")])
			tabBattleData.m_HufaData[index].m_wisdom	= tonumber(pmonstData[monst.getIndexByField("wisdom")])
			tabBattleData.m_HufaData[index].m_strength	= tonumber(pmonstData[monst.getIndexByField("strength")])
			tabBattleData.m_HufaData[index].m_attribute	= tonumber(pmonstData[monst.getIndexByField("attribute")])			
			tabBattleData.m_HufaData[index].m_level		= tonumber(pmonstData[monst.getIndexByField("Level")])										
			tabBattleData.m_HufaData[index].m_star		= 1
			tabBattleData.m_HufaData[index].m_anger		= tonumber(pmonstData[monst.getIndexByField("anger")])
			tabBattleData.m_HufaData[index].m_engine	= tonumber(pmonstData[monst.getIndexByField("engine")])
			tabBattleData.m_HufaData[index].m_Dis		= tonumber(pmonstData[monst.getIndexByField("dis")])	
			tabBattleData.m_HufaData[index].m_FightPosType	= 0	
			tabBattleData.m_HufaData[index].m_DropItemID	= tonumber(pmonstData[monst.getIndexByField("DropID")])	

			tabBattleData.m_HufaData[index].m_blood_back	= tonumber(pmonstData[monst.getIndexByField("blood_back")])
			tabBattleData.m_HufaData[index].m_engine_back	= tonumber(pmonstData[monst.getIndexByField("engine_back")])
			tabBattleData.m_HufaData[index].m_add_gongji	= tonumber(pmonstData[monst.getIndexByField("add_gongi")])
			tabBattleData.m_HufaData[index].m_add_fangyu	= tonumber(pmonstData[monst.getIndexByField("add_fangyu")])
			tabBattleData.m_HufaData[index].m_State_immune	= tonumber(pmonstData[monst.getIndexByField("State_immune")])
		
			tabBattleData.m_HufaData[index].m_Talent.m_id = tonumber(pmonstData[monst.getIndexByField("talent")])	
			
			local ptalentData = talent.getDataById(tabBattleData.m_HufaData[index].m_Talent.m_id)	
			
			tabBattleData.m_HufaData[index].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_HufaData[index].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_HufaData[index].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_HufaData[index].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")]	)
			tabBattleData.m_HufaData[index].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_HufaData[index].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_HufaData[index].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_HufaData[index].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			tabBattleData.m_HufaData[index].m_gongji	= tonumber(pmonstData[monst.getIndexByField("gongji")])	
			tabBattleData.m_HufaData[index].m_wufang	= tonumber(pmonstData[monst.getIndexByField("wufang")])	
			tabBattleData.m_HufaData[index].m_fafang	= tonumber(pmonstData[monst.getIndexByField("fafang")])	
			tabBattleData.m_HufaData[index].m_mingzhong	= 0				
			tabBattleData.m_HufaData[index].m_allblood	= tonumber(pmonstData[monst.getIndexByField("Hp")])						
			tabBattleData.m_HufaData[index].m_curblood	= tonumber(tabBattleData.m_HufaData[index].m_allblood)	
			tabBattleData.m_HufaData[index].m_power		= 0
			
			
			
			tabBattleData.m_HufaData[index].m_SkillData[1].m_skillid = tonumber(pmonstData[monst.getIndexByField("attack_id")])
			tabBattleData.m_HufaData[index].m_SkillData[2].m_skillid = tonumber(pmonstData[monst.getIndexByField("skill_ID")])
			tabBattleData.m_HufaData[index].m_SkillData[3].m_skillid = tonumber(pmonstData[monst.getIndexByField("engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(tabBattleData.m_HufaData[index].m_SkillData[m].m_skillid)
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_HufaData[index].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_HufaData[index].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_HufaData[index].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_HufaData[index].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_HufaData[index].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_HufaData[index].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_HufaData[index].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_HufaData[index].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
				
				--技能怒气回复
				tabBattleData.m_HufaData[index].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_HufaData[index].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_HufaData[index].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end						
						
						
		end		
	
	end	
	
	return tabBattleData

end

function InitTestFightData(Serverscenid ,index)

	InittabBattleData()	
	
	local checkpointID = tonumber(scence.getFieldByIdAndIndex(Serverscenid,("ID_" .. index)))	

	local SceneID = tonumber(point.getFieldByIdAndIndex(checkpointID,"ResID"))	
	local AllTimes = tonumber(point.getFieldByIdAndIndex(checkpointID,"times"))	
	
	tabBattleData.m_checkpointID = checkpointID
	tabBattleData.m_SceneID = SceneID
	
	tabBattleData.m_curTimes = 1
	tabBattleData.m_AllTimes = AllTimes
	tabBattleData.m_Battle_ID = FightbattleData.CreateBattleID()
	--add by sxin 是否出发情节--服务器传
	tabBattleData.m_CopyData_Star = 0
	
	--角色写死了测试的
	local hufalist = {7001,7002,7003}
	local playList = {
					{80011,80012,80013,81011,81012,81013},
					{6002,6005,6004,6008,6010,6011,6012,},
					{6003,6005,6006,6009,6016},
					{6007,6001,6013,6014,6015,6017,6018,6019,6020},
					{80021,80032,80043,80031,80042,80053,81021,81032,81043,81031,81042,81053}}

	local testhufa = hufalist[math.random(1,3)]
	
	
	local pPlaytbale = {playList[1][math.random(1,6)],playList[2][math.random(1,7)],playList[3][math.random(1,5)],playList[4][math.random(1,9)],playList[5][math.random(1,12)],testhufa}
	
	--测试武将用
	--pPlaytbale = {10,-1,-1,-1,18,19}
	
	local pPlaytGuidtbale = {10001,10002,10003,10004,10005}	
	
	--联网模拟取账号的上阵信息
	--if NETWORKENABLE > 0 then		
		local layDataTable = CommonInterface.getMatrixForFight()
		
		if layDataTable ~= nil then 
			local t=1
			for t=1, 6, 1 do
				
				pPlaytbale[t] = layDataTable[t]["TempID"]
				pPlaytGuidtbale[t] = layDataTable[t]["GID"]
			end
		end	
	--end
	
	local k = 1
	local playID = -1
	local playGUID = -1
	for k=1, 5, 1 do
		
		playID = pPlaytbale[k]
		playGUID = pPlaytGuidtbale[k]
		if playID ~= nil and playID > 0 then 
			
			local pgeneralData = general.getDataById(playID)			
			
			tabBattleData.m_TeamData[k].m_Serverid		= playGUID
			tabBattleData.m_TeamData[k].m_TempID		= playID
			tabBattleData.m_TeamData[k].m_name = pgeneralData[general.getIndexByField("Name")]
			tabBattleData.m_TeamData[k].m_TempResid  = tonumber(pgeneralData[general.getIndexByField("ResID")])			
			tabBattleData.m_TeamData[k].m_attack	= tonumber(pgeneralData[general.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_wisdom	= tonumber(pgeneralData[general.getIndexByField("wisdom")])
			tabBattleData.m_TeamData[k].m_strength	= tonumber(pgeneralData[general.getIndexByField("strength")])
			tabBattleData.m_TeamData[k].m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
			tabBattleData.m_TeamData[k].m_level		= 1										
			tabBattleData.m_TeamData[k].m_star		= tonumber(pgeneralData[general.getIndexByField("star")])	
			tabBattleData.m_TeamData[k].m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])	
			tabBattleData.m_TeamData[k].m_engine	= tonumber(pgeneralData[general.getIndexByField("engine")])	
			tabBattleData.m_TeamData[k].m_Dis		= tonumber(pgeneralData[general.getIndexByField("dis")])	
			tabBattleData.m_TeamData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
			tabBattleData.m_TeamData[k].m_DropItemID	= -1
			
			--角色增加4个属性
			tabBattleData.m_TeamData[k].m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
			tabBattleData.m_TeamData[k].m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
			tabBattleData.m_TeamData[k].m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			tabBattleData.m_TeamData[k].m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
			tabBattleData.m_TeamData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
			
			
			tabBattleData.m_TeamData[k].m_Talent.m_id = tonumber(pgeneralData[general.getIndexByField("talent")])				
			local ptalentData = talent.getDataById(tabBattleData.m_TeamData[k].m_Talent.m_id)						
			tabBattleData.m_TeamData[k].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_TeamData[k].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_TeamData[k].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")])	
			tabBattleData.m_TeamData[k].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_TeamData[k].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_TeamData[k].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_TeamData[k].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_attack
			tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			tabBattleData.m_TeamData[k].m_mingzhong	= 0				
			tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + tabBattleData.m_TeamData[k].m_level*50)*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			tabBattleData.m_TeamData[k].m_power		= tabBattleData.m_TeamData[k].m_gongji*2+tabBattleData.m_TeamData[k].m_wufang+tabBattleData.m_TeamData[k].m_fafang+tabBattleData.m_TeamData[k].m_allblood*0.2
			
			
			
			tabBattleData.m_TeamData[k].m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			tabBattleData.m_TeamData[k].m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			tabBattleData.m_TeamData[k].m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid)
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_TeamData[k].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_TeamData[k].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_TeamData[k].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_TeamData[k].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_TeamData[k].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])
				
				--技能怒气回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_TeamData[k].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
							
		end
	
	end
	
	--角色的护法
	playID = pPlaytbale[6]
	if playID ~= nil and playID > 0 then 
		k = 1
		local pgeneralData = general.getDataById(playID)			
		
		tabBattleData.m_HufaData[k].m_Serverid		= 10000+k
		tabBattleData.m_HufaData[k].m_TempID		= playID
		tabBattleData.m_HufaData[k].m_name = pgeneralData[general.getIndexByField("Name")]
		tabBattleData.m_HufaData[k].m_TempResid  = tonumber(pgeneralData[general.getIndexByField("ResID")])			
		tabBattleData.m_HufaData[k].m_attack	= tonumber(pgeneralData[general.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_wisdom	= tonumber(pgeneralData[general.getIndexByField("wisdom")])
		tabBattleData.m_HufaData[k].m_strength	= tonumber(pgeneralData[general.getIndexByField("strength")])
		tabBattleData.m_HufaData[k].m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
		tabBattleData.m_HufaData[k].m_level		= 1										
		tabBattleData.m_HufaData[k].m_star		= tonumber(pgeneralData[general.getIndexByField("star")])	
		tabBattleData.m_HufaData[k].m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])	
		tabBattleData.m_HufaData[k].m_engine	= tonumber(pgeneralData[general.getIndexByField("engine")])
		tabBattleData.m_HufaData[k].m_Dis		= tonumber(pgeneralData[general.getIndexByField("dis")])	
		tabBattleData.m_HufaData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
		tabBattleData.m_HufaData[k].m_DropItemID	= -1	
			
		--角色增加4个属性
		tabBattleData.m_HufaData[k].m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
		tabBattleData.m_HufaData[k].m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
		tabBattleData.m_HufaData[k].m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
		tabBattleData.m_HufaData[k].m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
		tabBattleData.m_HufaData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
		
		tabBattleData.m_HufaData[k].m_Talent.m_id = tonumber(pgeneralData[general.getIndexByField("talent")])				
		local ptalentData = talent.getDataById(tabBattleData.m_HufaData[k].m_Talent.m_id)						
		tabBattleData.m_HufaData[k].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
		tabBattleData.m_HufaData[k].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
		tabBattleData.m_HufaData[k].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")])	
		tabBattleData.m_HufaData[k].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
		tabBattleData.m_HufaData[k].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
		tabBattleData.m_HufaData[k].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
		tabBattleData.m_HufaData[k].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
		

		tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_attack
		tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_wufang
		tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_fafang
		tabBattleData.m_HufaData[k].m_mingzhong	= 0				
		tabBattleData.m_HufaData[k].m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + tabBattleData.m_HufaData[k].m_level*50)*(1+(tabBattleData.m_HufaData[k].m_strength -50)*0.01)*tabBattleData.m_HufaData[k].m_Talent.m_hp					
		tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		tabBattleData.m_HufaData[k].m_power		= tabBattleData.m_HufaData[k].m_gongji*2+tabBattleData.m_HufaData[k].m_wufang+tabBattleData.m_HufaData[k].m_fafang+tabBattleData.m_HufaData[k].m_allblood*0.2
		
		
		
		tabBattleData.m_HufaData[k].m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
		tabBattleData.m_HufaData[k].m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
		tabBattleData.m_HufaData[k].m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
		local m = 1
		for m=1,3,1 do
			
			local pskilldata = skill.getDataById(tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid)
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
			--//释放条件
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
			--//伤害类型 1物理 2法术
			tabBattleData.m_HufaData[k].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
			--//施法对象	
			tabBattleData.m_HufaData[k].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
			--//技能类型
			tabBattleData.m_HufaData[k].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
			--//效果参数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
			--//伤害系数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
			--//技能cd
			tabBattleData.m_HufaData[k].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
			--技能距离
			tabBattleData.m_HufaData[k].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])
			--技能怒气回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
			--技能能量回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
			--buff 类扩展
			tabBattleData.m_HufaData[k].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
		end
						
	end
	
	
		
	---怪的
	local i=1
	local j=0
	local index = -1
	local IMonstID = -1
	
	
	
	for i=1, AllTimes, 1 do
		
		for j=1 , 5 , 1 do
			
			local Keys = "POS_" .. i .. "_" .. j
			--print(Keys)
			
			
			IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))
			--print(IMonstID)
			--Pause()
			
			if IMonstID >0 then
			
				index = i*5 + j
				
				local pmonstData = monst.getDataById(IMonstID)			
			
				tabBattleData.m_TeamData[index].m_Serverid		= 20000+index
				tabBattleData.m_TeamData[index].m_TempID		= IMonstID
				
				tabBattleData.m_TeamData[index].m_name = pmonstData[monst.getIndexByField("Name")]
				tabBattleData.m_TeamData[index].m_TempResid  = tonumber(pmonstData[monst.getIndexByField("resID")])			
				tabBattleData.m_TeamData[index].m_attack	= tonumber(pmonstData[monst.getIndexByField("attack")])
				tabBattleData.m_TeamData[index].m_wisdom	= tonumber(pmonstData[monst.getIndexByField("wisdom")])
				tabBattleData.m_TeamData[index].m_strength	= tonumber(pmonstData[monst.getIndexByField("strength")])
				tabBattleData.m_TeamData[index].m_attribute	= tonumber(pmonstData[monst.getIndexByField("attribute")])			
				tabBattleData.m_TeamData[index].m_level		= tonumber(pmonstData[monst.getIndexByField("Level")])										
				tabBattleData.m_TeamData[index].m_star		= 1
				tabBattleData.m_TeamData[index].m_anger		= tonumber(pmonstData[monst.getIndexByField("anger")])
				tabBattleData.m_TeamData[index].m_engine	= tonumber(pmonstData[monst.getIndexByField("engine")])
				tabBattleData.m_TeamData[index].m_Dis		= tonumber(pmonstData[monst.getIndexByField("dis")])	
				tabBattleData.m_TeamData[index].m_FightPosType	= 0	
				tabBattleData.m_TeamData[index].m_DropItemID	= tonumber(pmonstData[monst.getIndexByField("DropID")])	
				--增加限制免疫状态	
				tabBattleData.m_TeamData[index].m_blood_back	= tonumber(pmonstData[monst.getIndexByField("blood_back")])
				tabBattleData.m_TeamData[index].m_engine_back	= tonumber(pmonstData[monst.getIndexByField("engine_back")])
				tabBattleData.m_TeamData[index].m_add_gongji	= tonumber(pmonstData[monst.getIndexByField("add_gongi")])
				tabBattleData.m_TeamData[index].m_add_fangyu	= tonumber(pmonstData[monst.getIndexByField("add_fangyu")])
				tabBattleData.m_TeamData[index].m_State_immune	= tonumber(pmonstData[monst.getIndexByField("State_immune")])
				
				tabBattleData.m_TeamData[index].m_Talent.m_id = tonumber(pmonstData[monst.getIndexByField("talent")])	
				
				local ptalentData = talent.getDataById(tabBattleData.m_TeamData[index].m_Talent.m_id)	
				
				tabBattleData.m_TeamData[index].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
				tabBattleData.m_TeamData[index].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
				tabBattleData.m_TeamData[index].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
				tabBattleData.m_TeamData[index].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")]	)
				tabBattleData.m_TeamData[index].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
				tabBattleData.m_TeamData[index].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
				tabBattleData.m_TeamData[index].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
				tabBattleData.m_TeamData[index].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
				

				tabBattleData.m_TeamData[index].m_gongji	= tonumber(pmonstData[monst.getIndexByField("gongji")])	
				tabBattleData.m_TeamData[index].m_wufang	= tonumber(pmonstData[monst.getIndexByField("wufang")])	
				tabBattleData.m_TeamData[index].m_fafang	= tonumber(pmonstData[monst.getIndexByField("fafang")])	
				tabBattleData.m_TeamData[index].m_mingzhong	= 0				
				tabBattleData.m_TeamData[index].m_allblood	= tonumber(pmonstData[monst.getIndexByField("Hp")])						
				tabBattleData.m_TeamData[index].m_curblood	= tonumber(tabBattleData.m_TeamData[index].m_allblood)	
				tabBattleData.m_TeamData[index].m_power		= 0
				
				
				
				tabBattleData.m_TeamData[index].m_SkillData[1].m_skillid = tonumber(pmonstData[monst.getIndexByField("attack_id")])
				tabBattleData.m_TeamData[index].m_SkillData[2].m_skillid = tonumber(pmonstData[monst.getIndexByField("skill_ID")])
				tabBattleData.m_TeamData[index].m_SkillData[3].m_skillid = tonumber(pmonstData[monst.getIndexByField("engine_ID")])
				local m = 1
				for m=1,3,1 do
					
					local pskilldata = skill.getDataById(tabBattleData.m_TeamData[index].m_SkillData[m].m_skillid)
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
					--//释放条件
					tabBattleData.m_TeamData[index].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
					--//伤害类型 1物理 2法术
					tabBattleData.m_TeamData[index].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
					--//施法对象	
					tabBattleData.m_TeamData[index].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
					--//技能类型
					tabBattleData.m_TeamData[index].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
					--//效果参数
					tabBattleData.m_TeamData[index].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
					--//伤害系数
					tabBattleData.m_TeamData[index].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
					--//技能cd
					tabBattleData.m_TeamData[index].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
					--技能距离
					tabBattleData.m_TeamData[index].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
					--技能怒气回复
					tabBattleData.m_TeamData[index].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
					--技能能量回复
					tabBattleData.m_TeamData[index].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
					
					--buff 类扩展
					tabBattleData.m_TeamData[index].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
					
					tabBattleData.m_TeamData[index].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
				end						
							
							
			end
		
		end
		
		---怪的护法
		local Keys = "hufa_" .. i
				
		IMonstID = 	tonumber(point.getFieldByIdAndIndex(checkpointID,Keys))	
		
		if IMonstID >0 then
		
			index = i + 1
			
			local pmonstData = monst.getDataById(IMonstID)			
		
			tabBattleData.m_HufaData[index].m_Serverid		= 20000+index
			tabBattleData.m_HufaData[index].m_TempID		= IMonstID
			
			tabBattleData.m_HufaData[index].m_name = pmonstData[monst.getIndexByField("Name")]
			tabBattleData.m_HufaData[index].m_TempResid  = tonumber(pmonstData[monst.getIndexByField("resID")])			
			tabBattleData.m_HufaData[index].m_attack	= tonumber(pmonstData[monst.getIndexByField("attack")])
			tabBattleData.m_HufaData[index].m_wisdom	= tonumber(pmonstData[monst.getIndexByField("wisdom")])
			tabBattleData.m_HufaData[index].m_strength	= tonumber(pmonstData[monst.getIndexByField("strength")])
			tabBattleData.m_HufaData[index].m_attribute	= tonumber(pmonstData[monst.getIndexByField("attribute")])			
			tabBattleData.m_HufaData[index].m_level		= tonumber(pmonstData[monst.getIndexByField("Level")])										
			tabBattleData.m_HufaData[index].m_star		= 1
			tabBattleData.m_HufaData[index].m_anger		= tonumber(pmonstData[monst.getIndexByField("anger")])
			tabBattleData.m_HufaData[index].m_engine	= tonumber(pmonstData[monst.getIndexByField("engine")])
			tabBattleData.m_HufaData[index].m_Dis		= tonumber(pmonstData[monst.getIndexByField("dis")])	
			tabBattleData.m_HufaData[index].m_FightPosType	= 0	
			tabBattleData.m_HufaData[index].m_DropItemID	= tonumber(pmonstData[monst.getIndexByField("DropID")])	

			tabBattleData.m_HufaData[index].m_blood_back	= tonumber(pmonstData[monst.getIndexByField("blood_back")])
			tabBattleData.m_HufaData[index].m_engine_back	= tonumber(pmonstData[monst.getIndexByField("engine_back")])
			tabBattleData.m_HufaData[index].m_add_gongji	= tonumber(pmonstData[monst.getIndexByField("add_gongi")])
			tabBattleData.m_HufaData[index].m_add_fangyu	= tonumber(pmonstData[monst.getIndexByField("add_fangyu")])
			tabBattleData.m_HufaData[index].m_State_immune	= tonumber(pmonstData[monst.getIndexByField("State_immune")])
		
			tabBattleData.m_HufaData[index].m_Talent.m_id = tonumber(pmonstData[monst.getIndexByField("talent")])	
			
			local ptalentData = talent.getDataById(tabBattleData.m_HufaData[index].m_Talent.m_id)	
			
			tabBattleData.m_HufaData[index].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_HufaData[index].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_HufaData[index].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_HufaData[index].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")]	)
			tabBattleData.m_HufaData[index].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_HufaData[index].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_HufaData[index].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_HufaData[index].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			tabBattleData.m_HufaData[index].m_gongji	= tonumber(pmonstData[monst.getIndexByField("gongji")])	
			tabBattleData.m_HufaData[index].m_wufang	= tonumber(pmonstData[monst.getIndexByField("wufang")])	
			tabBattleData.m_HufaData[index].m_fafang	= tonumber(pmonstData[monst.getIndexByField("fafang")])	
			tabBattleData.m_HufaData[index].m_mingzhong	= 0				
			tabBattleData.m_HufaData[index].m_allblood	= tonumber(pmonstData[monst.getIndexByField("Hp")])						
			tabBattleData.m_HufaData[index].m_curblood	= tonumber(tabBattleData.m_HufaData[index].m_allblood)	
			tabBattleData.m_HufaData[index].m_power		= 0
			
			
			
			tabBattleData.m_HufaData[index].m_SkillData[1].m_skillid = tonumber(pmonstData[monst.getIndexByField("attack_id")])
			tabBattleData.m_HufaData[index].m_SkillData[2].m_skillid = tonumber(pmonstData[monst.getIndexByField("skill_ID")])
			tabBattleData.m_HufaData[index].m_SkillData[3].m_skillid = tonumber(pmonstData[monst.getIndexByField("engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(tabBattleData.m_HufaData[index].m_SkillData[m].m_skillid)
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_HufaData[index].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_HufaData[index].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_HufaData[index].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_HufaData[index].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_HufaData[index].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_HufaData[index].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_HufaData[index].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_HufaData[index].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
				
				--技能怒气回复
				tabBattleData.m_HufaData[index].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_HufaData[index].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_HufaData[index].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_HufaData[index].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end						
						
						
		end
		
		
	
	end	
	
	return tabBattleData
	
end


--服务器的pk数据
function InitServerPKData(pServerDataStream)

	print("InitServerPKData")
	--Pause()
	InittabBattleData()	
	
	local Serverscenid 			= pServerDataStream:Read()
	local PointIndex			= pServerDataStream:Read()
	local Battle_ID				= pServerDataStream:Read()	
	local MatrixData 			= pServerDataStream:Read()
	local MatrixDataEnemy 		= pServerDataStream:Read()
	tabBattleData.m_PKData      = pServerDataStream:Read()
	
	-- add by sxin 增加pk奖励id
	local Battle_pk_rewardID	= pServerDataStream:Read()
	
	--print(Battle_ID)
	--printTab(tabBattleData.m_dropList)	
	--printTab(MatrixData)	
	
	--FileLog_json("Log_Battle_MatrixData.json",MatrixData)	
	--Pause()
	
	local checkpointID = tonumber(scence.getFieldByIdAndIndex(Serverscenid,("ID_" .. PointIndex)))	
	local SceneID = tonumber(point.getFieldByIdAndIndex(checkpointID,"ResID"))	
	local AllTimes = tonumber(point.getFieldByIdAndIndex(checkpointID,"times"))	
	
	tabBattleData.m_checkpointID = checkpointID
	tabBattleData.m_SceneID = SceneID
	
	tabBattleData.m_curTimes = 1
	tabBattleData.m_AllTimes = AllTimes
	tabBattleData.m_Battle_ID = Battle_ID
	
	--add by sxin 是否出发情节--服务器传
	tabBattleData.m_CopyData_Star = 0
	tabBattleData.m_bPKScene = true	
	tabBattleData.m_pk_rewardID = Battle_pk_rewardID
	
	--读取角色数据
	local k = 1
	local playID = -1
	local playGUID = -1
	
	local pMatrixData_Vel = nil
	local pMatrixData_Talent = nil
	local pMatrixData_Skill = nil
		
	for k=1, 5, 1 do
		
		if table.getn(MatrixData[k]) > 0 then
		--if MatrixData[k] ~= nil then
		
			pMatrixData_Vel = MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_Vel]
			pMatrixData_Talent = MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_Talent]
			pMatrixData_Skill = MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_Skill]
			
			playID 		= MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_nItemIndexID]
			playGUID 	= MatrixData[k][Fight_Battle_Begin_Data_MatrixData.MatrixData_nSerial][1]	
		else
			
			playID = -1
			playGUID = -1
			pMatrixData_Vel = nil
			pMatrixData_Talent = nil
			pMatrixData_Skill = nil
			
		end
		
		if playID ~= nil and playID > 0 then 
			
			local pgeneralData = general.getDataById(playID)			
			
			tabBattleData.m_TeamData[k].m_Serverid		= playGUID
			tabBattleData.m_TeamData[k].m_TempID		= playID
			tabBattleData.m_TeamData[k].m_name 			= pgeneralData[general.getIndexByField("Name")]
			tabBattleData.m_TeamData[k].m_TempResid = tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTmpID]) 	--tonumber(pgeneralData[general.getIndexByField("ResID")])			
			tabBattleData.m_TeamData[k].m_attack	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nWuLi]) 	--tonumber(pgeneralData[general.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_wisdom	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nZhiLi]) 	--tonumber(pgeneralData[general.getIndexByField("wisdom")])
			tabBattleData.m_TeamData[k].m_strength	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTiLi]) 	--tonumber(pgeneralData[general.getIndexByField("strength")])
			tabBattleData.m_TeamData[k].m_attribute	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nPowerType]) 	--tonumber(pgeneralData[general.getIndexByField("attribute")])			
			tabBattleData.m_TeamData[k].m_level		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nLv]) 	--1									
			tabBattleData.m_TeamData[k].m_star		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nStar]) 	--tonumber(pgeneralData[general.getIndexByField("star")])	
			tabBattleData.m_TeamData[k].m_anger		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_anger]) 	--tonumber(pgeneralData[general.getIndexByField("anger")])	
			tabBattleData.m_TeamData[k].m_engine	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine")])	
			tabBattleData.m_TeamData[k].m_Dis		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nHitDis]) 	--tonumber(pgeneralData[general.getIndexByField("dis")])	
			tabBattleData.m_TeamData[k].m_FightPosType	= 	tonumber(pgeneralData[general.getIndexByField("Pos")])	
			tabBattleData.m_TeamData[k].m_DropItemID	= -1
					
		
			--角色增加4个属性
			tabBattleData.m_TeamData[k].m_blood_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_Lift]) 	--tonumber(pgeneralData[general.getIndexByField("blood_back")])
			tabBattleData.m_TeamData[k].m_engine_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine_back")])
			tabBattleData.m_TeamData[k].m_add_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_gongji]) 	--tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			tabBattleData.m_TeamData[k].m_add_fangyu	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_fangyu]) 	--tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
			tabBattleData.m_TeamData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
			
			
			tabBattleData.m_TeamData[k].m_Talent.m_id = tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nID]) 	--tonumber(pgeneralData[general.getIndexByField("talent")])				
			--local ptalentData = talent.getDataById(tabBattleData.m_TeamData[k].m_Talent.m_id)						
			tabBattleData.m_TeamData[k].m_Talent.m_attack 		= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHurtRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_Talent.m_wufang		= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nPyhDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_TeamData[k].m_Talent.m_fafang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_TeamData[k].m_Talent.m_hp	 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nBloodRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("hp")])	
						
			tabBattleData.m_TeamData[k].m_Talent.m_duoshan	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nDodgeRatio]) 	--tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_TeamData[k].m_Talent.m_crit	 	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nFatalRatio]) 	--tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_TeamData[k].m_Talent.m_penetrate	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDiscovery]) 	--tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_TeamData[k].m_Talent.m_mingzhong	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHitRatio]) 	--tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			--tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji])	 + 10*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_attack
			--tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			--tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			--tabBattleData.m_TeamData[k].m_mingzhong	= 0				
			--tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]) + tabBattleData.m_TeamData[k].m_level*50)*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			
			--tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]))*tabBattleData.m_TeamData[k].m_Talent.m_attack
			--tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]))*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			--tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]))*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			
			tabBattleData.m_TeamData[k].m_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji])
			tabBattleData.m_TeamData[k].m_wufang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang])
			tabBattleData.m_TeamData[k].m_fafang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang])
			
			tabBattleData.m_TeamData[k].m_mingzhong	= 0	
			-- add by sxin 服务器已经算过了
		--	tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]))*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			tabBattleData.m_TeamData[k].m_allblood	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift])				
			
			--add by sxin 当前的血从服务器发来
			--tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			
			tabBattleData.m_TeamData[k].m_curblood	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.curBlood])
			if tabBattleData.m_TeamData[k].m_curblood == nil then
				print("m_curblood error")
				tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			end
			
			tabBattleData.m_TeamData[k].m_power		= tabBattleData.m_TeamData[k].m_gongji*2+tabBattleData.m_TeamData[k].m_wufang+tabBattleData.m_TeamData[k].m_fafang+tabBattleData.m_TeamData[k].m_allblood*0.2
			
			
			--技能数据
			--tabBattleData.m_TeamData[k].m_SkillData[1].m_skillid = tonumber(pMatrixData_Skill[1][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			--tabBattleData.m_TeamData[k].m_SkillData[2].m_skillid = tonumber(pMatrixData_Skill[2][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			--tabBattleData.m_TeamData[k].m_SkillData[3].m_skillid = tonumber(pMatrixData_Skill[3][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				--local pskilldata = skill.getDataById(tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid)
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
							
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillresid 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nResID]) --tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skill_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_hurt_type]) --tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_TeamData[k].m_SkillData[m].m_power_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_power_type]) --tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_TeamData[k].m_SkillData[m].m_site 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_site]) --tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_TeamData[k].m_SkillData[m].m_type 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_type]) --tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_paramete 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_paramete])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_ratio 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_ratio])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_TeamData[k].m_SkillData[m].m_timecd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_timecd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_TeamData[k].m_SkillData[m].m_SkillRadius	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_dis]) --tonumber(pskilldata[skill.getIndexByField("dis")])
				
				--技能怒气回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_anger_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_anger_back]) --tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_engine_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_engine_back]) --tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_TeamData[k].m_SkillData[m].m_bufftimes 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_times]) --tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffcd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_cd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffchace 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_chance]) --tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
							
		end
	
	end
	
	--角色的护法
		
	if table.getn(MatrixData[6]) > 0 then
	
		pMatrixData_Vel = MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Vel]
		pMatrixData_Talent = MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Talent]
		pMatrixData_Skill = MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Skill]
		
		playID 		= MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_nItemIndexID]
		playGUID 	= MatrixData[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_nSerial][1]	
		
		--print("juese 的护法")
		--Pause()
	else
	
		playID = -1
		playGUID = -1
	end		
	
	if playID ~= nil and playID > 0 then 
		k = 1
		local pgeneralData = general.getDataById(playID)			
		
		tabBattleData.m_HufaData[k].m_Serverid		= playGUID
		tabBattleData.m_HufaData[k].m_TempID		= playID
		tabBattleData.m_HufaData[k].m_name 			= pgeneralData[general.getIndexByField("Name")]
		tabBattleData.m_HufaData[k].m_TempResid  	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTmpID]) 	--tonumber(pgeneralData[general.getIndexByField("ResID")])			
		tabBattleData.m_HufaData[k].m_attack		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nWuLi]) 	--tonumber(pgeneralData[general.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_wisdom		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nZhiLi]) 	--tonumber(pgeneralData[general.getIndexByField("wisdom")])
		tabBattleData.m_HufaData[k].m_strength		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTiLi]) 	--tonumber(pgeneralData[general.getIndexByField("strength")])
		tabBattleData.m_HufaData[k].m_attribute		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nPowerType]) 	--tonumber(pgeneralData[general.getIndexByField("attribute")])			
		tabBattleData.m_HufaData[k].m_level			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nLv]) 	--1	
		
		tabBattleData.m_HufaData[k].m_star			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nStar]) 	--tonumber(pgeneralData[general.getIndexByField("star")])	
		tabBattleData.m_HufaData[k].m_anger			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_anger]) 	--tonumber(pgeneralData[general.getIndexByField("anger")])	
		tabBattleData.m_HufaData[k].m_engine		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine")])
		tabBattleData.m_HufaData[k].m_Dis			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nHitDis]) 	--tonumber(pgeneralData[general.getIndexByField("dis")])	
		tabBattleData.m_HufaData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
		tabBattleData.m_HufaData[k].m_DropItemID	= -1	
			
		--角色增加4个属性
		tabBattleData.m_HufaData[k].m_blood_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_Lift]) 	--tonumber(pgeneralData[general.getIndexByField("blood_back")])
		tabBattleData.m_HufaData[k].m_engine_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine_back")])
		tabBattleData.m_HufaData[k].m_add_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_gongji]) 	--tonumber(pgeneralData[general.getIndexByField("add_gongi")])
		tabBattleData.m_HufaData[k].m_add_fangyu	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_fangyu]) 	--tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
		tabBattleData.m_HufaData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
		
		tabBattleData.m_HufaData[k].m_Talent.m_id 			= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nID]) 	--tonumber(pgeneralData[general.getIndexByField("talent")])				
		local ptalentData = talent.getDataById(tabBattleData.m_HufaData[k].m_Talent.m_id)						
		tabBattleData.m_HufaData[k].m_Talent.m_attack 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHurtRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_Talent.m_wufang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nPyhDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("wufang")])
		tabBattleData.m_HufaData[k].m_Talent.m_fafang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("fafang")])
		tabBattleData.m_HufaData[k].m_Talent.m_hp	 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nBloodRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("hp")])	
		tabBattleData.m_HufaData[k].m_Talent.m_duoshan	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nDodgeRatio]) 	--tonumber(ptalentData[talent.getIndexByField("duoshan")])
		tabBattleData.m_HufaData[k].m_Talent.m_crit	 	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nFatalRatio]) 	--tonumber(ptalentData[talent.getIndexByField("crit")])
		tabBattleData.m_HufaData[k].m_Talent.m_penetrate	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDiscovery]) 	--tonumber(ptalentData[talent.getIndexByField("shipo")])
		tabBattleData.m_HufaData[k].m_Talent.m_mingzhong	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHitRatio]) 	--tonumber(ptalentData[talent.getIndexByField("mingzhong")])
		

		--tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]) + 10*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_attack
		--tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_wufang
		--tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_fafang
		--tabBattleData.m_HufaData[k].m_mingzhong	= 0				
		--tabBattleData.m_HufaData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]) + tabBattleData.m_HufaData[k].m_level*50)*(1+(tabBattleData.m_HufaData[k].m_strength -50)*0.01)*tabBattleData.m_HufaData[k].m_Talent.m_hp					
		--tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		
		--tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]))*tabBattleData.m_HufaData[k].m_Talent.m_attack
		--tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]))*tabBattleData.m_HufaData[k].m_Talent.m_wufang
		--tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]))*tabBattleData.m_HufaData[k].m_Talent.m_fafang
		
		tabBattleData.m_HufaData[k].m_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji])
		tabBattleData.m_HufaData[k].m_wufang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang])
		tabBattleData.m_HufaData[k].m_fafang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang])
		
		tabBattleData.m_HufaData[k].m_mingzhong	= 0		
		
		tabBattleData.m_HufaData[k].m_allblood	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift])					
		tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		
		tabBattleData.m_HufaData[k].m_power		= tabBattleData.m_HufaData[k].m_gongji*2+tabBattleData.m_HufaData[k].m_wufang+tabBattleData.m_HufaData[k].m_fafang+tabBattleData.m_HufaData[k].m_allblood*0.2
				
		
		local m = 1
		for m=1,3,1 do
			
			--local pskilldata = skill.getDataById(tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid)
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillresid 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nResID]) --tonumber(pskilldata[skill.getIndexByField("resID")])
			--//释放条件
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skill_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_hurt_type]) --tonumber(pskilldata[skill.getIndexByField("hurt_type")])
			--//伤害类型 1物理 2法术
			tabBattleData.m_HufaData[k].m_SkillData[m].m_power_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_power_type]) --tonumber(pskilldata[skill.getIndexByField("power_type")])
			--//施法对象	
			tabBattleData.m_HufaData[k].m_SkillData[m].m_site 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_site]) --tonumber(pskilldata[skill.getIndexByField("site")])
			--//技能类型
			tabBattleData.m_HufaData[k].m_SkillData[m].m_type 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_type]) --tonumber(pskilldata[skill.getIndexByField("type")])
			--//效果参数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_paramete 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_paramete])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("paramete")])
			--//伤害系数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_ratio 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_ratio])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("ratio")])
			--//技能cd
			tabBattleData.m_HufaData[k].m_SkillData[m].m_timecd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_timecd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("timecd")])	
			--技能距离
			tabBattleData.m_HufaData[k].m_SkillData[m].m_SkillRadius 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_dis]) --tonumber(pskilldata[skill.getIndexByField("dis")])
			--技能怒气回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_anger_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_anger_back]) --tonumber(pskilldata[skill.getIndexByField("anger_back")])
			--技能能量回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_engine_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_engine_back]) --tonumber(pskilldata[skill.getIndexByField("engine_back")])
			--buff 类扩展
			tabBattleData.m_HufaData[k].m_SkillData[m].m_bufftimes 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_times]) --tonumber(pskilldata[skill.getIndexByField("buff_times")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffcd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_cd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("buff_cd")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffchace 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_chance]) --tonumber(pskilldata[skill.getIndexByField("buff_chance")])
		end
						
	end
	
	--敌方 MatrixDataEnemy
	
	for j=1, 5, 1 do
		
		if table.getn(MatrixDataEnemy[j]) > 0 then	
		
			pMatrixData_Vel = MatrixDataEnemy[j][Fight_Battle_Begin_Data_MatrixData.MatrixData_Vel]
			pMatrixData_Talent = MatrixDataEnemy[j][Fight_Battle_Begin_Data_MatrixData.MatrixData_Talent]
			pMatrixData_Skill = MatrixDataEnemy[j][Fight_Battle_Begin_Data_MatrixData.MatrixData_Skill]
			
			playID 		= MatrixDataEnemy[j][Fight_Battle_Begin_Data_MatrixData.MatrixData_nItemIndexID]
			playGUID 	= MatrixDataEnemy[j][Fight_Battle_Begin_Data_MatrixData.MatrixData_nSerial][1]	
		else
			
			playID = -1
			playGUID = -1
			pMatrixData_Vel = nil
			pMatrixData_Talent = nil
			pMatrixData_Skill = nil
			
		end
		
		local k = 5 + j
		if playID ~= nil and playID > 0 then 
			
			local pgeneralData = general.getDataById(playID)			
			
			tabBattleData.m_TeamData[k].m_Serverid		= playGUID
			tabBattleData.m_TeamData[k].m_TempID		= playID
			tabBattleData.m_TeamData[k].m_name 			= pgeneralData[general.getIndexByField("Name")]
			tabBattleData.m_TeamData[k].m_TempResid = tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTmpID]) 	--tonumber(pgeneralData[general.getIndexByField("ResID")])			
			tabBattleData.m_TeamData[k].m_attack	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nWuLi]) 	--tonumber(pgeneralData[general.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_wisdom	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nZhiLi]) 	--tonumber(pgeneralData[general.getIndexByField("wisdom")])
			tabBattleData.m_TeamData[k].m_strength	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTiLi]) 	--tonumber(pgeneralData[general.getIndexByField("strength")])
			tabBattleData.m_TeamData[k].m_attribute	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nPowerType]) 	--tonumber(pgeneralData[general.getIndexByField("attribute")])			
			tabBattleData.m_TeamData[k].m_level		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nLv]) 	--1									
			tabBattleData.m_TeamData[k].m_star		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nStar]) 	--tonumber(pgeneralData[general.getIndexByField("star")])	
			tabBattleData.m_TeamData[k].m_anger		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_anger]) 	--tonumber(pgeneralData[general.getIndexByField("anger")])	
			tabBattleData.m_TeamData[k].m_engine	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine")])	
			tabBattleData.m_TeamData[k].m_Dis		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nHitDis]) 	--tonumber(pgeneralData[general.getIndexByField("dis")])	
			tabBattleData.m_TeamData[k].m_FightPosType	= 	tonumber(pgeneralData[general.getIndexByField("Pos")])	
			tabBattleData.m_TeamData[k].m_DropItemID	= -1
					
		
			--角色增加4个属性
			tabBattleData.m_TeamData[k].m_blood_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_Lift]) 	--tonumber(pgeneralData[general.getIndexByField("blood_back")])
			tabBattleData.m_TeamData[k].m_engine_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine_back")])
			tabBattleData.m_TeamData[k].m_add_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_gongji]) 	--tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			tabBattleData.m_TeamData[k].m_add_fangyu	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_fangyu]) 	--tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
			tabBattleData.m_TeamData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
			
			
			tabBattleData.m_TeamData[k].m_Talent.m_id = tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nID]) 	--tonumber(pgeneralData[general.getIndexByField("talent")])				
			--local ptalentData = talent.getDataById(tabBattleData.m_TeamData[k].m_Talent.m_id)						
			tabBattleData.m_TeamData[k].m_Talent.m_attack 		= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHurtRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_Talent.m_wufang		= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nPyhDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_TeamData[k].m_Talent.m_fafang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_TeamData[k].m_Talent.m_hp	 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nBloodRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("hp")])	
						
			tabBattleData.m_TeamData[k].m_Talent.m_duoshan	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nDodgeRatio]) 	--tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_TeamData[k].m_Talent.m_crit	 	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nFatalRatio]) 	--tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_TeamData[k].m_Talent.m_penetrate	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDiscovery]) 	--tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_TeamData[k].m_Talent.m_mingzhong	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHitRatio]) 	--tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			--tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji])	 + 10*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_attack
			--tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			--tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			--tabBattleData.m_TeamData[k].m_mingzhong	= 0				
			--tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]) + tabBattleData.m_TeamData[k].m_level*50)*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			
			--tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]))*tabBattleData.m_TeamData[k].m_Talent.m_attack
			--tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]))*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			--tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]))*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			--机器人算过了
			tabBattleData.m_TeamData[k].m_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji])
			tabBattleData.m_TeamData[k].m_wufang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang])
			tabBattleData.m_TeamData[k].m_fafang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang])
			
			tabBattleData.m_TeamData[k].m_mingzhong	= 0		
			
			
			-- add by sxin 服务器已经算过了
		--	tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]))*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			tabBattleData.m_TeamData[k].m_allblood	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift])				
			
			--add by sxin 当前的血从服务器发来
			--tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			
			tabBattleData.m_TeamData[k].m_curblood	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.curBlood])
			if tabBattleData.m_TeamData[k].m_curblood == nil then
				print("m_curblood error")
				tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			end			
			
			tabBattleData.m_TeamData[k].m_power		= tabBattleData.m_TeamData[k].m_gongji*2+tabBattleData.m_TeamData[k].m_wufang+tabBattleData.m_TeamData[k].m_fafang+tabBattleData.m_TeamData[k].m_allblood*0.2
			
			
			--技能数据
			--tabBattleData.m_TeamData[k].m_SkillData[1].m_skillid = tonumber(pMatrixData_Skill[1][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			--tabBattleData.m_TeamData[k].m_SkillData[2].m_skillid = tonumber(pMatrixData_Skill[2][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			--tabBattleData.m_TeamData[k].m_SkillData[3].m_skillid = tonumber(pMatrixData_Skill[3][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				--local pskilldata = skill.getDataById(tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid)
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
							
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillresid 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nResID]) --tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skill_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_hurt_type]) --tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_TeamData[k].m_SkillData[m].m_power_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_power_type]) --tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_TeamData[k].m_SkillData[m].m_site 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_site]) --tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_TeamData[k].m_SkillData[m].m_type 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_type]) --tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_paramete 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_paramete])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_ratio 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_ratio])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_TeamData[k].m_SkillData[m].m_timecd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_timecd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_TeamData[k].m_SkillData[m].m_SkillRadius	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_dis]) --tonumber(pskilldata[skill.getIndexByField("dis")])
				
				--技能怒气回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_anger_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_anger_back]) --tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_engine_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_engine_back]) --tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_TeamData[k].m_SkillData[m].m_bufftimes 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_times]) --tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffcd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_cd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffchace 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_chance]) --tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
							
		end
	
	end
	
	--角色的护法
		
	if table.getn(MatrixDataEnemy[6]) > 0 then
	
		pMatrixData_Vel = MatrixDataEnemy[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Vel]
		pMatrixData_Talent = MatrixDataEnemy[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Talent]
		pMatrixData_Skill = MatrixDataEnemy[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_Skill]
		
		playID 		= MatrixDataEnemy[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_nItemIndexID]
		playGUID 	= MatrixDataEnemy[6][Fight_Battle_Begin_Data_MatrixData.MatrixData_nSerial][1]	
		
		
	else
	
		playID = -1
		playGUID = -1
	end		
	
	if playID ~= nil and playID > 0 then 
		k = 2
		local pgeneralData = general.getDataById(playID)			
		
		tabBattleData.m_HufaData[k].m_Serverid		= playGUID
		tabBattleData.m_HufaData[k].m_TempID		= playID
		tabBattleData.m_HufaData[k].m_name 			= pgeneralData[general.getIndexByField("Name")]
		tabBattleData.m_HufaData[k].m_TempResid  	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTmpID]) 	--tonumber(pgeneralData[general.getIndexByField("ResID")])			
		tabBattleData.m_HufaData[k].m_attack		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nWuLi]) 	--tonumber(pgeneralData[general.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_wisdom		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nZhiLi]) 	--tonumber(pgeneralData[general.getIndexByField("wisdom")])
		tabBattleData.m_HufaData[k].m_strength		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nTiLi]) 	--tonumber(pgeneralData[general.getIndexByField("strength")])
		tabBattleData.m_HufaData[k].m_attribute		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nPowerType]) 	--tonumber(pgeneralData[general.getIndexByField("attribute")])			
		tabBattleData.m_HufaData[k].m_level			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nLv]) 	--1	
		
		tabBattleData.m_HufaData[k].m_star			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nStar]) 	--tonumber(pgeneralData[general.getIndexByField("star")])	
		tabBattleData.m_HufaData[k].m_anger			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_anger]) 	--tonumber(pgeneralData[general.getIndexByField("anger")])	
		tabBattleData.m_HufaData[k].m_engine		= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine")])
		tabBattleData.m_HufaData[k].m_Dis			= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nHitDis]) 	--tonumber(pgeneralData[general.getIndexByField("dis")])	
		tabBattleData.m_HufaData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
		tabBattleData.m_HufaData[k].m_DropItemID	= -1	
			
		--角色增加4个属性
		tabBattleData.m_HufaData[k].m_blood_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_Lift]) 	--tonumber(pgeneralData[general.getIndexByField("blood_back")])
		tabBattleData.m_HufaData[k].m_engine_back	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.back_engine]) 	--tonumber(pgeneralData[general.getIndexByField("engine_back")])
		tabBattleData.m_HufaData[k].m_add_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_gongji]) 	--tonumber(pgeneralData[general.getIndexByField("add_gongi")])
		tabBattleData.m_HufaData[k].m_add_fangyu	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.add_fangyu]) 	--tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
		tabBattleData.m_HufaData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
		
		tabBattleData.m_HufaData[k].m_Talent.m_id 			= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nID]) 	--tonumber(pgeneralData[general.getIndexByField("talent")])				
		local ptalentData = talent.getDataById(tabBattleData.m_HufaData[k].m_Talent.m_id)						
		tabBattleData.m_HufaData[k].m_Talent.m_attack 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHurtRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("attack")])
		tabBattleData.m_HufaData[k].m_Talent.m_wufang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nPyhDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("wufang")])
		tabBattleData.m_HufaData[k].m_Talent.m_fafang	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDefRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("fafang")])
		tabBattleData.m_HufaData[k].m_Talent.m_hp	 	 	= (tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nBloodRatio])/MatrixData_Talent_Ratio) 	--tonumber(ptalentData[talent.getIndexByField("hp")])	
		tabBattleData.m_HufaData[k].m_Talent.m_duoshan	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nDodgeRatio]) 	--tonumber(ptalentData[talent.getIndexByField("duoshan")])
		tabBattleData.m_HufaData[k].m_Talent.m_crit	 	 	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nFatalRatio]) 	--tonumber(ptalentData[talent.getIndexByField("crit")])
		tabBattleData.m_HufaData[k].m_Talent.m_penetrate	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nMagicDiscovery]) 	--tonumber(ptalentData[talent.getIndexByField("shipo")])
		tabBattleData.m_HufaData[k].m_Talent.m_mingzhong	= tonumber(pMatrixData_Talent[MatrixData_Talent_Key.nHitRatio]) 	--tonumber(ptalentData[talent.getIndexByField("mingzhong")])
		

		--tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]) + 10*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_attack
		--tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_wufang
		--tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_fafang
		--tabBattleData.m_HufaData[k].m_mingzhong	= 0				
		--tabBattleData.m_HufaData[k].m_allblood	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift]) + tabBattleData.m_HufaData[k].m_level*50)*(1+(tabBattleData.m_HufaData[k].m_strength -50)*0.01)*tabBattleData.m_HufaData[k].m_Talent.m_hp					
		--tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		
		--tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji]))*tabBattleData.m_HufaData[k].m_Talent.m_attack
		--tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang]))*tabBattleData.m_HufaData[k].m_Talent.m_wufang
		--tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang]))*tabBattleData.m_HufaData[k].m_Talent.m_fafang
		
		tabBattleData.m_HufaData[k].m_gongji	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_gongji])
		tabBattleData.m_HufaData[k].m_wufang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_wufang])
		tabBattleData.m_HufaData[k].m_fafang	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.Init_fafang])
		
		tabBattleData.m_HufaData[k].m_mingzhong	= 0				
		tabBattleData.m_HufaData[k].m_allblood	= tonumber(pMatrixData_Vel[MatrixData_Vel_Key.nInit_Lift])
		tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
		
		tabBattleData.m_HufaData[k].m_power		= tabBattleData.m_HufaData[k].m_gongji*2+tabBattleData.m_HufaData[k].m_wufang+tabBattleData.m_HufaData[k].m_fafang+tabBattleData.m_HufaData[k].m_allblood*0.2
				
		
		local m = 1
		for m=1,3,1 do
			
			--local pskilldata = skill.getDataById(tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid)
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nID]) --tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skillresid 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nResID]) --tonumber(pskilldata[skill.getIndexByField("resID")])
			--//释放条件
			tabBattleData.m_HufaData[k].m_SkillData[m].m_skill_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_hurt_type]) --tonumber(pskilldata[skill.getIndexByField("hurt_type")])
			--//伤害类型 1物理 2法术
			tabBattleData.m_HufaData[k].m_SkillData[m].m_power_type 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_power_type]) --tonumber(pskilldata[skill.getIndexByField("power_type")])
			--//施法对象	
			tabBattleData.m_HufaData[k].m_SkillData[m].m_site 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_site]) --tonumber(pskilldata[skill.getIndexByField("site")])
			--//技能类型
			tabBattleData.m_HufaData[k].m_SkillData[m].m_type 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_type]) --tonumber(pskilldata[skill.getIndexByField("type")])
			--//效果参数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_paramete 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_paramete])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("paramete")])
			--//伤害系数
			tabBattleData.m_HufaData[k].m_SkillData[m].m_ratio 			= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_ratio])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("ratio")])
			--//技能cd
			tabBattleData.m_HufaData[k].m_SkillData[m].m_timecd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_timecd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("timecd")])	
			--技能距离
			tabBattleData.m_HufaData[k].m_SkillData[m].m_SkillRadius 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_dis]) --tonumber(pskilldata[skill.getIndexByField("dis")])
			--技能怒气回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_anger_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_anger_back]) --tonumber(pskilldata[skill.getIndexByField("anger_back")])
			--技能能量回复
			tabBattleData.m_HufaData[k].m_SkillData[m].m_engine_back 	= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_engine_back]) --tonumber(pskilldata[skill.getIndexByField("engine_back")])
			--buff 类扩展
			tabBattleData.m_HufaData[k].m_SkillData[m].m_bufftimes 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_times]) --tonumber(pskilldata[skill.getIndexByField("buff_times")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffcd 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_cd])/MatrixData_Talent_Ratio --tonumber(pskilldata[skill.getIndexByField("buff_cd")])
			
			tabBattleData.m_HufaData[k].m_SkillData[m].m_buffchace 		= tonumber(pMatrixData_Skill[m][MatrixData_Skill_Key.nSkill_buff_chance]) --tonumber(pskilldata[skill.getIndexByField("buff_chance")])
		end
						
	end
	
	return tabBattleData
end

--pk测试数据
function InitTestPKData(Serverscenid ,index)

	InittabBattleData()
		
	local checkpointID = tonumber(scence.getFieldByIdAndIndex(Serverscenid,("ID_" .. index)))	

	local SceneID = tonumber(point.getFieldByIdAndIndex(checkpointID,"ResID"))	
	local AllTimes = tonumber(point.getFieldByIdAndIndex(checkpointID,"times"))			
	
	tabBattleData.m_SceneID = SceneID
	tabBattleData.m_checkpointID = checkpointID
	tabBattleData.m_curTimes = 1
	tabBattleData.m_AllTimes = 1
	tabBattleData.m_bPKScene = true
	tabBattleData.m_Battle_ID = FightbattleData.CreateBattleID()
	
	
	local playList = {{6002,6008,6012},{6005,6010,6011},{6003,6004,6013},{6006,6007},{6001,6009,6014,6015,6016}}	
	
	local pPlaytbale = {playList[1][math.random(1,3)],playList[2][math.random(1,3)],playList[3][math.random(1,3)],playList[4][math.random(1,2)],playList[5][math.random(1,5)],
						playList[1][math.random(1,3)],playList[2][math.random(1,3)],playList[3][math.random(1,3)],playList[4][math.random(1,2)],playList[5][math.random(1,5)]}

	local pPlaytGuidtbale = {10001,10002,10003,10004,10005,10006,10007,10008,10009,10010}	
	
	
	
	--pPlaytbale = {10001,-1,-1,-1,-1,-1,-1,6009,6016,6015}
	--pPlaytbale = {-1,6017,-1,-1,-1,-1,-1,6009,6016,6015}
	
	--pPlaytbale = {-1,-1,6020,-1,-1,-1,-1,6009,6016,6015}
	
	--pPlaytbale = {-1,-1,-1,6018,-1,-1,-1,6009,6016,6015}
	
	--pPlaytbale = {-1,-1,-1,-1,6019,-1,-1,6009,6016,6015}
	
	--pPlaytbale = {10001,6017,6020,6018,6019,-1,-1,6009,6016,6015}
	
	--pPlaytbale = {6017,-1,-1,6018,-1,-1,-1,6009,6016,6015}
	--pPlaytbale = {6017,6020,-1,-1,-1,-1,-1,6009,6014,6015}
	--pPlaytbale = {80011,80021,80031,-1,-1,-1,-1,-1,6014,6015}
	--pPlaytbale = {81011,81021,81031,-1,-1,-1,-1,-1,-1,6015}
	
	--pPlaytbale = {10001,-1,-1,10002,-1,-1,-1,10001,-1,-1}
	--pPlaytbale = {80011,6029,-1,-1,-1,-1,-1,10001,-1,-1}
	
	--pPlaytbale = {6028,-1,-1 ,-1,-1,6028,-1,10002,-1,10002}
	pPlaytbale = {10004,10003,-1 ,-1,10005,10004,10003,-1,-1,10005}
	--pPlaytbale = {6028,-1,6035 ,-1,6035,10004,-1,-1,-1,-1}
	--pPlaytbale = {6028,-1,6035 ,-1,6035,10005,-1,-1,-1,-1}
	
	--联网模拟取账号的上阵信息
	--[[
	if NETWORKENABLE > 0 then		
		local layDataTable = CommonInterface.getMatrixForFight()
		
		if layDataTable ~= nil then 
			local t=1
			for t=1, 5, 1 do
				
				pPlaytbale[t] = layDataTable[t]["TempID"]
				pPlaytGuidtbale[t] = layDataTable[t]["GID"]
			end
		end	
	end
	--]]
	
		
	local k = 1
	local playID = -1
	local playGUID = -1
	for k=1, 10, 1 do
		
		playID = pPlaytbale[k]
		playGUID = pPlaytGuidtbale[k]
		if playID ~= nil and playID > 0 then 
			
			local pgeneralData = general.getDataById(playID)			
			
			tabBattleData.m_TeamData[k].m_Serverid		= playGUID
			tabBattleData.m_TeamData[k].m_TempID		= playID
			tabBattleData.m_TeamData[k].m_name = pgeneralData[general.getIndexByField("Name")]
			tabBattleData.m_TeamData[k].m_TempResid  = tonumber(pgeneralData[general.getIndexByField("ResID")])			
			tabBattleData.m_TeamData[k].m_attack	= tonumber(pgeneralData[general.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_wisdom	= tonumber(pgeneralData[general.getIndexByField("wisdom")])
			tabBattleData.m_TeamData[k].m_strength	= tonumber(pgeneralData[general.getIndexByField("strength")])
			tabBattleData.m_TeamData[k].m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
			tabBattleData.m_TeamData[k].m_level		= 1--math.random(1,3)										
			tabBattleData.m_TeamData[k].m_star		= tonumber(pgeneralData[general.getIndexByField("star")])	
			tabBattleData.m_TeamData[k].m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])	
			tabBattleData.m_TeamData[k].m_engine	= tonumber(pgeneralData[general.getIndexByField("engine")])	
			tabBattleData.m_TeamData[k].m_Dis		= tonumber(pgeneralData[general.getIndexByField("dis")])	
			tabBattleData.m_TeamData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
			tabBattleData.m_TeamData[k].m_DropItemID	= -1
				
			--角色增加4个属性
			tabBattleData.m_TeamData[k].m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
			tabBattleData.m_TeamData[k].m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
			tabBattleData.m_TeamData[k].m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			tabBattleData.m_TeamData[k].m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")]) + 70
			tabBattleData.m_TeamData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
			
			tabBattleData.m_TeamData[k].m_Talent.m_id = tonumber(pgeneralData[general.getIndexByField("talent")])				
			local ptalentData = talent.getDataById(tabBattleData.m_TeamData[k].m_Talent.m_id)						
			tabBattleData.m_TeamData[k].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_TeamData[k].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_TeamData[k].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_TeamData[k].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")])	
			tabBattleData.m_TeamData[k].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_TeamData[k].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_TeamData[k].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_TeamData[k].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			tabBattleData.m_TeamData[k].m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_attack
			tabBattleData.m_TeamData[k].m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_wufang
			tabBattleData.m_TeamData[k].m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*tabBattleData.m_TeamData[k].m_level)*tabBattleData.m_TeamData[k].m_Talent.m_fafang
			tabBattleData.m_TeamData[k].m_mingzhong	= 0				
			tabBattleData.m_TeamData[k].m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + tabBattleData.m_TeamData[k].m_level*50)*(1+(tabBattleData.m_TeamData[k].m_strength -50)*0.01)*tabBattleData.m_TeamData[k].m_Talent.m_hp					
			tabBattleData.m_TeamData[k].m_curblood	= tabBattleData.m_TeamData[k].m_allblood	
			tabBattleData.m_TeamData[k].m_power		= tabBattleData.m_TeamData[k].m_gongji*2+tabBattleData.m_TeamData[k].m_wufang+tabBattleData.m_TeamData[k].m_fafang+tabBattleData.m_TeamData[k].m_allblood*0.2
			
			
			
			tabBattleData.m_TeamData[k].m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			tabBattleData.m_TeamData[k].m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			tabBattleData.m_TeamData[k].m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(tabBattleData.m_TeamData[k].m_SkillData[m].m_skillid)
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])				
				--//释放条件
				tabBattleData.m_TeamData[k].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_TeamData[k].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_TeamData[k].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_TeamData[k].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_TeamData[k].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_TeamData[k].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_TeamData[k].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])
				
				--技能怒气回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_TeamData[k].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_TeamData[k].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_TeamData[k].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
							
		end
	
	end
	
	
	
	--角色护法写死了测试的	
	local pPlayhufatbale = {7002,7001}
	for k=1, 2, 1 do
		
		playID = pPlayhufatbale[k]
		if playID ~= nil and playID > 0 then 
			
			local pgeneralData = general.getDataById(playID)			
			
			tabBattleData.m_HufaData[k].m_Serverid		= 10000+k
			tabBattleData.m_HufaData[k].m_TempID		= playID
			tabBattleData.m_HufaData[k].m_name = pgeneralData[general.getIndexByField("Name")]
			tabBattleData.m_HufaData[k].m_TempResid  = tonumber(pgeneralData[general.getIndexByField("ResID")])			
			tabBattleData.m_HufaData[k].m_attack	= tonumber(pgeneralData[general.getIndexByField("attack")])
			tabBattleData.m_HufaData[k].m_wisdom	= tonumber(pgeneralData[general.getIndexByField("wisdom")])
			tabBattleData.m_HufaData[k].m_strength	= tonumber(pgeneralData[general.getIndexByField("strength")])
			tabBattleData.m_HufaData[k].m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
			tabBattleData.m_HufaData[k].m_level		= 1										
			tabBattleData.m_HufaData[k].m_star		= tonumber(pgeneralData[general.getIndexByField("star")])	
			tabBattleData.m_HufaData[k].m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])
			tabBattleData.m_HufaData[k].m_engine		= tonumber(pgeneralData[general.getIndexByField("engine")])
			tabBattleData.m_HufaData[k].m_Dis		= tonumber(pgeneralData[general.getIndexByField("dis")])	
			tabBattleData.m_HufaData[k].m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
			tabBattleData.m_HufaData[k].m_DropItemID	= -1	


			--角色增加4个属性
			tabBattleData.m_HufaData[k].m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
			tabBattleData.m_HufaData[k].m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
			tabBattleData.m_HufaData[k].m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
			tabBattleData.m_HufaData[k].m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
			tabBattleData.m_HufaData[k].m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
		
			
			tabBattleData.m_HufaData[k].m_Talent.m_id = tonumber(pgeneralData[general.getIndexByField("talent")])				
			local ptalentData = talent.getDataById(tabBattleData.m_HufaData[k].m_Talent.m_id)						
			tabBattleData.m_HufaData[k].m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
			tabBattleData.m_HufaData[k].m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
			tabBattleData.m_HufaData[k].m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
			tabBattleData.m_HufaData[k].m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")])	
			tabBattleData.m_HufaData[k].m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
			tabBattleData.m_HufaData[k].m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
			tabBattleData.m_HufaData[k].m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
			tabBattleData.m_HufaData[k].m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
			

			tabBattleData.m_HufaData[k].m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_attack
			tabBattleData.m_HufaData[k].m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_wufang
			tabBattleData.m_HufaData[k].m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*tabBattleData.m_HufaData[k].m_level)*tabBattleData.m_HufaData[k].m_Talent.m_fafang
			tabBattleData.m_HufaData[k].m_mingzhong	= 0				
			tabBattleData.m_HufaData[k].m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + tabBattleData.m_HufaData[k].m_level*50)*(1+(tabBattleData.m_HufaData[k].m_strength -50)*0.01)*tabBattleData.m_HufaData[k].m_Talent.m_hp					
			tabBattleData.m_HufaData[k].m_curblood	= tabBattleData.m_HufaData[k].m_allblood	
			tabBattleData.m_HufaData[k].m_power		= tabBattleData.m_HufaData[k].m_gongji*2+tabBattleData.m_HufaData[k].m_wufang+tabBattleData.m_HufaData[k].m_fafang+tabBattleData.m_HufaData[k].m_allblood*0.2
			
			
			
			tabBattleData.m_HufaData[k].m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
			tabBattleData.m_HufaData[k].m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
			tabBattleData.m_HufaData[k].m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
			local m = 1
			for m=1,3,1 do
				
				local pskilldata = skill.getDataById(tabBattleData.m_HufaData[k].m_SkillData[m].m_skillid)
				
				tabBattleData.m_HufaData[k].m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
				--//释放条件
				tabBattleData.m_HufaData[k].m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
				--//伤害类型 1物理 2法术
				tabBattleData.m_HufaData[k].m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
				--//施法对象	
				tabBattleData.m_HufaData[k].m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
				--//技能类型
				tabBattleData.m_HufaData[k].m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
				--//效果参数
				tabBattleData.m_HufaData[k].m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
				--//伤害系数
				tabBattleData.m_HufaData[k].m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
				--//技能cd
				tabBattleData.m_HufaData[k].m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
				--技能距离
				tabBattleData.m_HufaData[k].m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
				
				--技能怒气回复
				tabBattleData.m_HufaData[k].m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
				--技能能量回复
				tabBattleData.m_HufaData[k].m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
				
				--buff 类扩展
				tabBattleData.m_HufaData[k].m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
				
				tabBattleData.m_HufaData[k].m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
				
				tabBattleData.m_HufaData[k].m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
			end
							
		end
	
	end
	
	
		
		
	return tabBattleData
	
end