
--场景管理器通过这个管理器来创建战斗场景的实体

module("Scene_PlayObj", package.seeall)


--定义数据接口来创建角色obj
local function CreatPlayObj(self, DataInfo)

	self.m_Type = Obj_Type.Type_Player
end

local function CreatNpcObj(self, DataInfo)
	self.m_Type = Obj_Type.Type_Npc
end

--本地测试接口
local function CreatTestPlayObj(self, playID)
	self.m_Type = Obj_Type.Type_Player
	
	local pgeneralData = general.getDataById(playID)	
	
	self.m_baseDB.m_Serverid		= playGUID
	self.m_baseDB.m_TempID		= playID
	self.m_baseDB.m_name = pgeneralData[general.getIndexByField("Name")]
	self.m_baseDB.m_TempResid  = tonumber(pgeneralData[general.getIndexByField("ResID")])			
	self.m_baseDB.m_attack	= tonumber(pgeneralData[general.getIndexByField("attack")])
	self.m_baseDB.m_wisdom	= tonumber(pgeneralData[general.getIndexByField("wisdom")])
	self.m_baseDB.m_strength	= tonumber(pgeneralData[general.getIndexByField("strength")])
	self.m_baseDB.m_attribute	= tonumber(pgeneralData[general.getIndexByField("attribute")])			
	self.m_baseDB.m_level		= 1										
	self.m_baseDB.m_star		= tonumber(pgeneralData[general.getIndexByField("star")])	
	self.m_baseDB.m_anger		= tonumber(pgeneralData[general.getIndexByField("anger")])	
	self.m_baseDB.m_engine	= tonumber(pgeneralData[general.getIndexByField("engine")])	
	self.m_baseDB.m_Dis		= tonumber(pgeneralData[general.getIndexByField("dis")])	
	self.m_baseDB.m_FightPosType	= tonumber(pgeneralData[general.getIndexByField("Pos")])	
	self.m_baseDB.m_DropItemID	= -1
	
	--角色增加4个属性
	self.m_baseDB.m_blood_back	= tonumber(pgeneralData[general.getIndexByField("blood_back")])
	self.m_baseDB.m_engine_back	= tonumber(pgeneralData[general.getIndexByField("engine_back")])
	self.m_baseDB.m_add_gongji	= tonumber(pgeneralData[general.getIndexByField("add_gongi")])
	self.m_baseDB.m_add_fangyu	= tonumber(pgeneralData[general.getIndexByField("add_fangyu")])
	self.m_baseDB.m_State_immune	= tonumber(pgeneralData[general.getIndexByField("State_immune")])
	
	
	self.m_baseDB.m_Talent.m_id = tonumber(pgeneralData[general.getIndexByField("talent")])				
	local ptalentData = talent.getDataById(self.m_baseDB.m_Talent.m_id)						
	self.m_baseDB.m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
	self.m_baseDB.m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
	self.m_baseDB.m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
	self.m_baseDB.m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")])	
	self.m_baseDB.m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
	self.m_baseDB.m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
	self.m_baseDB.m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
	self.m_baseDB.m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
	

	self.m_baseDB.m_gongji	= (tonumber(pgeneralData[general.getIndexByField("init_gongji")])	 + 10*self.m_baseDB.m_level)*self.m_baseDB.m_Talent.m_attack
	self.m_baseDB.m_wufang	= (tonumber(pgeneralData[general.getIndexByField("init_wufang")]) + 5*self.m_baseDB.m_level)*self.m_baseDB.m_Talent.m_wufang
	self.m_baseDB.m_fafang	= (tonumber(pgeneralData[general.getIndexByField("init_fafang")]) + 5*self.m_baseDB.m_level)*self.m_baseDB.m_Talent.m_fafang
	self.m_baseDB.m_mingzhong	= 0				
	self.m_baseDB.m_allblood	= (tonumber(pgeneralData[general.getIndexByField("init_lift")]) + self.m_baseDB.m_level*50)*(1+(self.m_baseDB.m_strength -50)*0.01)*self.m_baseDB.m_Talent.m_hp					
	self.m_baseDB.m_curblood	= self.m_baseDB.m_allblood	
	self.m_baseDB.m_power		= self.m_baseDB.m_gongji*2+self.m_baseDB.m_wufang+self.m_baseDB.m_fafang+self.m_baseDB.m_allblood*0.2
	
	
	
	self.m_baseDB.m_SkillData[1].m_skillid = tonumber(pgeneralData[general.getIndexByField("attack_ID")])
	self.m_baseDB.m_SkillData[2].m_skillid = tonumber(pgeneralData[general.getIndexByField("skill_ID")])
	self.m_baseDB.m_SkillData[3].m_skillid = tonumber(pgeneralData[general.getIndexByField("Engine_ID")])
	local m = 1
	for m=1,3,1 do
		
		local pskilldata = skill.getDataById(self.m_baseDB.m_SkillData[m].m_skillid)
		
		self.m_baseDB.m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
		--//释放条件
		self.m_baseDB.m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
		--//伤害类型 1物理 2法术
		self.m_baseDB.m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
		--//施法对象	
		self.m_baseDB.m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
		--//技能类型
		self.m_baseDB.m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
		--//效果参数
		self.m_baseDB.m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
		--//伤害系数
		self.m_baseDB.m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
		--//技能cd
		self.m_baseDB.m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
		--技能距离
		self.m_baseDB.m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])
		
		--技能怒气回复
		self.m_baseDB.m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
		--技能能量回复
		self.m_baseDB.m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
		
		--buff 类扩展
		self.m_baseDB.m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
		
		self.m_baseDB.m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
		
		self.m_baseDB.m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
	end
	
	
end

local function CreatTestNpcObj(self, IMonstID)
	self.m_Type = Obj_Type.Type_Npc
	
	local pmonstData = monst.getDataById(IMonstID)		

	self.m_baseDB.m_Serverid	= 0
	self.m_baseDB.m_TempID		= IMonstID
	
	self.m_baseDB.m_name = pmonstData[monst.getIndexByField("Name")]
	self.m_baseDB.m_TempResid  = tonumber(pmonstData[monst.getIndexByField("resID")])			
	self.m_baseDB.m_attack	= tonumber(pmonstData[monst.getIndexByField("attack")])
	self.m_baseDB.m_wisdom	= tonumber(pmonstData[monst.getIndexByField("wisdom")])
	self.m_baseDB.m_strength	= tonumber(pmonstData[monst.getIndexByField("strength")])
	self.m_baseDB.m_attribute	= tonumber(pmonstData[monst.getIndexByField("attribute")])			
	self.m_baseDB.m_level		= tonumber(pmonstData[monst.getIndexByField("Level")])										
	self.m_baseDB.m_star		= 1
	self.m_baseDB.m_anger		= tonumber(pmonstData[monst.getIndexByField("anger")])
	self.m_baseDB.m_engine	= tonumber(pmonstData[monst.getIndexByField("engine")])
	self.m_baseDB.m_Dis		= tonumber(pmonstData[monst.getIndexByField("dis")])	
	self.m_baseDB.m_FightPosType	= 0	
	self.m_baseDB.m_DropItemID	= tonumber(pmonstData[monst.getIndexByField("DropID")])	
	--增加限制免疫状态	
	self.m_baseDB.m_blood_back	= tonumber(pmonstData[monst.getIndexByField("blood_back")])
	self.m_baseDB.m_engine_back	= tonumber(pmonstData[monst.getIndexByField("engine_back")])
	self.m_baseDB.m_add_gongji	= tonumber(pmonstData[monst.getIndexByField("add_gongi")])
	self.m_baseDB.m_add_fangyu	= tonumber(pmonstData[monst.getIndexByField("add_fangyu")])
	self.m_baseDB.m_State_immune	= tonumber(pmonstData[monst.getIndexByField("State_immune")])
	
	self.m_baseDB.m_Talent.m_id = tonumber(pmonstData[monst.getIndexByField("talent")])	
	
	local ptalentData = talent.getDataById(self.m_baseDB.m_Talent.m_id)	
	
	self.m_baseDB.m_Talent.m_attack 	 = tonumber(ptalentData[talent.getIndexByField("attack")])
	self.m_baseDB.m_Talent.m_wufang	 = tonumber(ptalentData[talent.getIndexByField("wufang")])
	self.m_baseDB.m_Talent.m_fafang	 = tonumber(ptalentData[talent.getIndexByField("fafang")])
	self.m_baseDB.m_Talent.m_hp	 	 = tonumber(ptalentData[talent.getIndexByField("hp")]	)
	self.m_baseDB.m_Talent.m_duoshan	 = tonumber(ptalentData[talent.getIndexByField("duoshan")])
	self.m_baseDB.m_Talent.m_crit	 	 = tonumber(ptalentData[talent.getIndexByField("crit")])
	self.m_baseDB.m_Talent.m_penetrate	 = tonumber(ptalentData[talent.getIndexByField("shipo")])
	self.m_baseDB.m_Talent.m_mingzhong	 = tonumber(ptalentData[talent.getIndexByField("mingzhong")])
	

	self.m_baseDB.m_gongji	= tonumber(pmonstData[monst.getIndexByField("gongji")])	
	self.m_baseDB.m_wufang	= tonumber(pmonstData[monst.getIndexByField("wufang")])	
	self.m_baseDB.m_fafang	= tonumber(pmonstData[monst.getIndexByField("fafang")])	
	self.m_baseDB.m_mingzhong	= 0				
	self.m_baseDB.m_allblood	= tonumber(pmonstData[monst.getIndexByField("Hp")])						
	self.m_baseDB.m_curblood	= tonumber(self.m_baseDB.m_allblood)	
	self.m_baseDB.m_power		= 0
	
	
	
	self.m_baseDB.m_SkillData[1].m_skillid = tonumber(pmonstData[monst.getIndexByField("attack_id")])
	self.m_baseDB.m_SkillData[2].m_skillid = tonumber(pmonstData[monst.getIndexByField("skill_ID")])
	self.m_baseDB.m_SkillData[3].m_skillid = tonumber(pmonstData[monst.getIndexByField("engine_ID")])
	local m = 1
	for m=1,3,1 do
		
		local pskilldata = skill.getDataById(self.m_baseDB.m_SkillData[m].m_skillid)
		
		self.m_baseDB.m_SkillData[m].m_skillresid =tonumber(pskilldata[skill.getIndexByField("resID")])
		--//释放条件
		self.m_baseDB.m_SkillData[m].m_skill_type = tonumber(pskilldata[skill.getIndexByField("hurt_type")])
		--//伤害类型 1物理 2法术
		self.m_baseDB.m_SkillData[m].m_power_type = tonumber(pskilldata[skill.getIndexByField("power_type")])
		--//施法对象	
		self.m_baseDB.m_SkillData[m].m_site = tonumber(pskilldata[skill.getIndexByField("site")])
		--//技能类型
		self.m_baseDB.m_SkillData[m].m_type = tonumber(pskilldata[skill.getIndexByField("type")])
		--//效果参数
		self.m_baseDB.m_SkillData[m].m_paramete = tonumber(pskilldata[skill.getIndexByField("paramete")])
		--//伤害系数
		self.m_baseDB.m_SkillData[m].m_ratio = tonumber(pskilldata[skill.getIndexByField("ratio")])
		--//技能cd
		self.m_baseDB.m_SkillData[m].m_timecd = tonumber(pskilldata[skill.getIndexByField("timecd")])	
		--技能距离
		self.m_baseDB.m_SkillData[m].m_SkillRadius = tonumber(pskilldata[skill.getIndexByField("dis")])	
		--技能怒气回复
		self.m_baseDB.m_SkillData[m].m_anger_back = tonumber(pskilldata[skill.getIndexByField("anger_back")])
		--技能能量回复
		self.m_baseDB.m_SkillData[m].m_engine_back = tonumber(pskilldata[skill.getIndexByField("engine_back")])
		
		--buff 类扩展
		self.m_baseDB.m_SkillData[m].m_bufftimes = tonumber(pskilldata[skill.getIndexByField("buff_times")])
		
		self.m_baseDB.m_SkillData[m].m_buffcd = tonumber(pskilldata[skill.getIndexByField("buff_cd")])
		
		self.m_baseDB.m_SkillData[m].m_buffchace = tonumber(pskilldata[skill.getIndexByField("buff_chance")])
	end						
		
	
	
end


function SetAnimationRes(self)

	local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
			 
			if evt == FrameEvent_Key.Event_attack then			   
				
				local pArmature = bone:getArmature()

				if pArmature ~= nil then				
														
					CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Normal)	
					self:Fun_SetCurBone(bone)
					-- 计算伤害--					
					Scene_BaseLogic.OnDamageLogic(self)
					
					
					
				end	
			elseif  evt == FrameEvent_Key.Event_Vibration then
						   
				Scene_BaseLogic.VibrationSceen(3)
											   
			elseif  evt == FrameEvent_Key.Event_Blur then
				--设置模糊效果
				local pArmature = bone:getArmature()

				if pArmature ~= nil then
				
					local ipos = pArmature:getTag()					
					CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Blur)			
				end	
				
			elseif  evt == FrameEvent_Key.Event_Normal then
				
				local pArmature = bone:getArmature()

				if pArmature ~= nil then				
					--local ipos = pArmature:getTag()					
					CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Normal)								
				end	
			else
			   
			end
	end

	local function onMovementEvent(armatureBack,movementType,movementID)
			
		if movementType == MovementEventType.start	then
					
			if movementID == GetAniName_Player(self,Ani_Def_Key.Ani_stand) then
			
				local ipos = armatureBack:getTag()		
			--	print("MovementEventType.start" )
			--	print("pArmature:getTag = " .. ipos)
			--	print("self index= " .. self.m_Index)
				
			end
		
		elseif movementType == MovementEventType.complete then
			
			--防止设置了sharder没有切回来
			local ipos = armatureBack:getTag()
			--print("MovementEventType.complete" )
			--print("pArmature:getTag = " .. ipos)
			--print("self index= " .. self.m_Index)
			
			if movementID == GetAniName_Player(self,Ani_Def_Key.Ani_die) then			  

				local pFadeOut = CCFadeOut:create(3)
				armatureBack:runAction(pFadeOut)				
				Scene_BaseLogic.SetObjRenderFaceUiVisible(armatureBack,false)
			else
			
				armatureBack:getAnimation():play(GetAniName_Player(self,Ani_Def_Key.Ani_stand))	
				
				--判断手动技能效果解除放到播放特效得时候
				if movementID == GetAniName_Player(self,Ani_Def_Key.Ani_manual_skill) or movementID == GetAniName_Player(self,Ani_Def_Key.Ani_skill) or movementID == GetAniName_Player(self,Ani_Def_Key.Ani_attack)then

					--判断是否有存放的技能没有释放有就释放
					Scene_BaseLogic.ObjUseStackSkill(self)
						
				end
													
							
				
			end
		
		
		elseif movementType == MovementEventType.loopComplete then
			local ipos = armatureBack:getTag()		
			--print("MovementEventType.loopComplete" )
			--print("pArmature:getTag = " .. ipos)
			--print("self index= " .. self.m_Index)
			
			--隐藏血条	
			if movementID == GetAniName_Player(self,Ani_Def_Key.Ani_stand)  then		
				Scene_BaseLogic.SetObjRenderFaceUiVisible(armatureBack,false)
			end
				
		end		
	end
	
	--******************************************************
	
	local iTempResID = self.m_baseDB.m_TempResid	
	local pAnimationfileName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationfileName")		
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)	
	local pAnimationName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationName")	
	
	local pArmature = CCArmature:create(pAnimationName)		
		
	local loadingBarBack = LoadingBar:create()
	loadingBarBack:setName("HP_LoadingBarBack")
	loadingBarBack:loadTexture("Image/Fight/UI/hpline_bg.png")
	loadingBarBack:setDirection(0)
	loadingBarBack:setTag(G_BloodBackTag)
	loadingBarBack:setPercent(100)		

	local loadingBarHp = LoadingBar:create()
	loadingBarHp:setName("HP_Loading")
	loadingBarHp:loadTexture("Image/Fight/UI/hpline.png")
	loadingBarHp:setDirection(0)
	loadingBarHp:setTag(G_BloodTag)
	loadingBarHp:setPercent(100)
	
	if self:Fun_IsNpc() == true then		
		loadingBarHp:setScaleX(-(loadingBarHp:getScaleX()))
		loadingBarHp:loadTexture("Image/Fight/UI/hpline_npc.png")
	end
	
	
	--跟头顶骨骼绑定
	
	local bone  = CCBone:create("HP_LoadingBarBack")		
	bone:addDisplay(loadingBarBack, 0)
	bone:changeDisplayWithIndex(0, true)
	bone:setIgnoreMovementBoneData(true)
	bone:setZOrder(100)
	bone:setTag(G_BloodBackBoneTag)
	pArmature:addBone(bone, "xuetiao")
	
	
	bone  = CCBone:create("HP_Loading")		
	bone:addDisplay(loadingBarHp, 0)
	bone:changeDisplayWithIndex(0, true)
	bone:setIgnoreMovementBoneData(true)
	bone:setZOrder(111)
	bone:setTag(G_BloodBoneTag)
	pArmature:addBone(bone, "xuetiao")				
		
	pArmature:getAnimation():play(GetAniName_Player(self,Ani_Def_Key.Ani_stand)) 
	
	--**************要重写时间回调
	pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)	
	
	if self:Fun_IsUser() == true then
		pArmature:setTag(self.m_Index)
	else
		pArmature:setTag(10*self.m_Times+self.m_Index)
	end
	
	
	self.m_RenderData.m_rect = pArmature:boundingBox()	
	--print(self.m_RenderData.m_rect.size.height)
	--print(self.m_RenderData.m_rect.size.width)
	--Pause()
	self.m_RenderData.m_pArmature = pArmature	

	-- add by sxin 没血了不显示
	if self.m_baseDB.m_curblood <= 0 then				
		self.m_RenderData.m_pArmature:setVisible(false)
	end	
end


local function CreatRenderData(self,pRoot)
	
	--暂时只有动画
	if self.m_baseDB.m_TempResid ~= -1 then
		--local ImagefileName_Head = AnimationData.getFieldByIdAndIndex(TeamData.m_TempResid,"ImagefileName_Head")	
		self:Fun_SetAnimationRes()			
		pRoot:addChild( self.m_RenderData.m_pArmature )		
		
	end	
end

local function GetRender_Armature(self)
	
	--暂时只有动画
	return self.m_RenderData.m_pArmature
end

local function IsUser(self)	
	
	return (self.m_Type ==  Obj_Type.Type_Player)
end

local function IsNpc(self)	
	
	return (self.m_Type ==  Obj_Type.Type_Npc)
end


--设置索引位置
local function SetIndex(self,iIndex)	
	
	self.m_Index = iIndex
end

local function SetTimes(self,iTimes)	
	
	self.m_Times = iTimes
end

local function IsDie(self)	
	
	return (self.m_baseDB.m_curblood <= 0)
end


local function ISCanUseSkill(self)	
	
	if self:Fun_GetCurrentMovementID() == GetAniName_Player(self,Ani_Def_Key.Ani_stand) or self:Fun_GetCurrentMovementID() == GetAniName_Player(self,Ani_Def_Key.Ani_hitted) or self:Fun_GetCurrentMovementID() == GetAniName_Player(self,Ani_Def_Key.Ani_run)then 	
		return true
	else
		return false
	end		
	
end

local function CheckDamageState(self,eDamageState)	
	
	return (self.m_FightDataParm.m_buff_state == eDamageState)
end

local function IsBuff_State(self,eDamageState)	
	
		
	if self.m_FightDataParm.m_buff_state ~= nil then
		
		if self.m_FightDataParm.m_buff_state == DamageState.E_DamageState_xuanyun or self.m_FightDataParm.m_buff_state == DamageState.E_DamageState_bingdong then 
			return true
		end
		
	end
	return false
end


local function SetTagObj(self,pObj)	
	
	self.m_FightDataParm.m_pTarObj = pObj
end

local function GetTagObj(self)	
	
	return self.m_FightDataParm.m_pTarObj
end

local function SetUseSkillIndex(self,iSkillIndex)		
	self.m_FightDataParm.m_iSkillIndex = iSkillIndex
end

local function GetUseSkillIndex(self)		
	return self.m_FightDataParm.m_iSkillIndex
end

local function SetUseSkillRate(self,icount)		
	self.m_FightDataParm.m_iSkillRate = icount
end

local function GetUseSkillRate(self)		
	return self.m_FightDataParm.m_iSkillRate 
end

local function SetCurBone(self,pbone)		
	self.m_FightDataParm.m_Curbone = pbone	
end

local function GetCurBone(self)		
	return self.m_FightDataParm.m_Curbone 
end

local function GetFightDataParm(self)		
	return self.m_FightDataParm
end


-- 对引擎播放的接口支持


local function Obj_play_Name(self,AniName)	
	
	self.m_RenderData.m_pArmature:getAnimation():play(AniName)
end

local function Obj_play_Key(self,AniKey)		
	self:Fun_play_Name(GetAniName_Player(self,AniKey))	
end

local function Obj_runAction(self,pAct)		
	self.m_RenderData.m_pArmature:runAction(pAct)
end

local function GetCurrentMovementID(self)		
	return self.m_RenderData.m_pArmature:getAnimation():getCurrentMovementID()
end

local function Obj_getPosition(self)		
	return self.m_RenderData.m_pArmature:getPosition()
end

local function Obj_SetPosition(self,pos)		
	return self.m_RenderData.m_pArmature:setPosition(pos)
end

local function Obj_getPositionX(self)		
	return self.m_RenderData.m_pArmature:getPositionX()
end


local function Obj_SetPositionX(self,posX)		
	return self.m_RenderData.m_pArmature:setPositionX(posX)
end

local function Obj_getPositionY(self)		
	return self.m_RenderData.m_pArmature:getPositionY()
end

local function Obj_getZOrder(self)		
	return self.m_RenderData.m_pArmature:getZOrder()
end

local function Obj_getModeHeight(self)		
	return self.m_RenderData.m_rect.size.height
end

local function Obj_getModeWidth(self)		
	return self.m_RenderData.m_rect.size.width
end

local function Obj_getScaleX(self)		
	return self.m_RenderData.m_pArmature:getScaleX()
end

local function GetSkillCdTime(self,iSkillIndex)		
	return self.m_baseDB.m_SkillData[iSkillIndex].m_timecd
end

local function GetSkillID(self,iSkillIndex)		
	return self.m_baseDB.m_SkillData[iSkillIndex].m_skillid
end

local function GetSkillResID(self,iSkillIndex)		
	return self.m_baseDB.m_SkillData[iSkillIndex].m_skillresid
end

local function GetSkillData(self,iSkillIndex)		
	return self.m_baseDB.m_SkillData[iSkillIndex]
end

local function GetBloodRate(self)		
	return (self.m_baseDB.m_curblood / self.m_baseDB.m_allblood)
end

local function GetTalent(self)
	return self.m_baseDB.m_Talent
end

local function GetBaseDB(self)
	return self.m_baseDB
end

local function AddskillToStack(self,pskill)
	self.m_SkillStack:PushStack(pskill)
end

local function GetskillFromStack(self)
	return self.m_SkillStack:PopStack()
end

local function PalyBuffGain(self,pBuffGainType,pBuffGainVel,beffective)

	local pTeamData = self.m_baseDB
		
	local _buffvel = pBuffGainVel
	
	if beffective == false then --无效	
		_buffvel = -pBuffGainVel		
	end	
		
	if pBuffGainType == BuffGainType.E_BuffGainType_gongji then 			
		pTeamData.m_gongji = pTeamData.m_gongji + _buffvel	
	elseif pBuffGainType == BuffGainType.E_BuffGainType_wufang then 		
		pTeamData.m_wufang = pTeamData.m_wufang + _buffvel	
	elseif pBuffGainType == BuffGainType.E_BuffGainType_fafang then 
		pTeamData.m_fafang = pTeamData.m_fafang + _buffvel
	elseif pBuffGainType == BuffGainType.E_BuffGainType_mingzhong then 
		pTeamData.m_mingzhong = pTeamData.m_mingzhong + _buffvel
		
	elseif pBuffGainType == BuffGainType.E_BuffGainType_baoji then 
	
		pTeamData.m_Talent.m_crit = pTeamData.m_Talent.m_crit + _buffvel
	elseif pBuffGainType == BuffGainType.E_BuffGainType_duoshan then 
		pTeamData.m_Talent.m_duoshan = pTeamData.m_Talent.m_duoshan + _buffvel
	elseif pBuffGainType == BuffGainType.E_BuffGainType_shipo then 
		pTeamData.m_Talent.m_penetrate = pTeamData.m_Talent.m_penetrate + _buffvel
	elseif pBuffGainType == BuffGainType.E_GainType_engine then 
		pTeamData.m_engine = pTeamData.m_engine + _buffvel	
		if pTeamData.m_engine > UseMaxEngine then
			pTeamData.m_engine = UseMaxEngine
		end
	elseif pBuffGainType == BuffGainType.E_BuffGainType_xishoudun then 
	
		--吸收盾不能叠加只能重置
		if pTeamData.m_xishoudun > 0 then
			pTeamData.m_xishoudun = 0
		end
		
		pTeamData.m_xishoudun  = pTeamData.m_xishoudun + _buffvel
			
		if pTeamData.m_xishoudun < 0 then 
			pTeamData.m_xishoudun = 0
		end
		
	elseif pBuffGainType == BuffGainType.E_BuffGainType_jueduifangyu then 		
		pTeamData.m_add_fangyu = pTeamData.m_add_fangyu + _buffvel	
		
		if pTeamData.m_add_fangyu < 0 then 
			pTeamData.m_add_fangyu = 0
		end
	elseif pBuffGainType == BuffGainType.E_BuffGainType_zhili then 	
		
		--print(pTeamData.m_wisdom)
		--print(_buffvel)
		pTeamData.m_wisdom = pTeamData.m_wisdom + _buffvel	
		
		if pTeamData.m_wisdom < 0 then 
			pTeamData.m_wisdom = 0
		end
		--print(pTeamData.m_wisdom)
		--Pause()
	else
	
		
		print("PalyBuffGain_TeamData pBuffGainType Error")
	end
	
end

local function PalyBuffState(self,eState)
	
	local pFightDataParm = self.m_FightDataParm
	--------判断技能状态
	if eState > DamageState.E_DamageState_None  and  pFightDataParm.m_buff_state ~= eState then 
				
				
		if pFightDataParm.m_buff_state == DamageState.E_DamageState_jifei then 
		
			self:Fun_GetRender_Armature():stopActionByTag(Fight_jifeiMoveTagID)
			
		end
		
		---根据状态暂停动作
		if  eState == DamageState.E_DamageState_bingdong then 		
			
				pFightDataParm.m_buff_state = eState
				
				--技能被打断
				--防止死亡动作的时候打
				if self:Fun_GetCurrentMovementID() ~= GetAniName_Player(self,Ani_Def_Key.Ani_die) then			
					self:Fun_play_Name(GetAniName_Player(self,Ani_Def_Key.Ani_stand))			
				end	
								
				pauseSchedulerAndActions(self:Fun_GetRender_Armature())	
		
		elseif eState == DamageState.E_DamageState_xuanyun then 
			
				pFightDataParm.m_buff_state = eState
				
				if self:Fun_GetCurrentMovementID() ~= GetAniName_Player(self,Ani_Def_Key.Ani_die) then	
					resumeSchedulerAndActions(self:Fun_GetRender_Armature())	
					self:Fun_play_Name(GetAniName_Player(self,Ani_Def_Key.Ani_vertigo))			
				end				
		end		
	end
end

local function ClearBuffState(self,eState)
	
	local pFightDataParm = self.m_FightDataParm
	--------判断技能状态
	if eState > DamageState.E_DamageState_None  and  pFightDataParm.m_buff_state == eState then 
				
		---根据状态暂停动作
		if  eState == DamageState.E_DamageState_bingdong then 		
			
			pFightDataParm.m_buff_state = DamageState.E_DamageState_None
			
			if self.m_RenderData.m_pArmature ~= nil then				
				resumeSchedulerAndActions(self.m_RenderData.m_pArmature)					
			end
			
		elseif eState == DamageState.E_DamageState_xuanyun then 
			
				pFightDataParm.m_buff_state = DamageState.E_DamageState_None	
				
				if self:Fun_GetCurrentMovementID() ~= GetAniName_Player(self,Ani_Def_Key.Ani_die) then						
					self:Fun_play_Name(GetAniName_Player(self,Ani_Def_Key.Ani_stand))			
				end				
		end		
	end
	
end

local function Release(self)
	print("playobjrelease")
	--Pause()
	self.m_RenderData.m_pArmature:removeFromParentAndCleanup(true)	
	self.m_RenderData.m_pArmature = nil
	
end

local function ClearDamageLogic(self)
									
	self.m_FightDataParm.m_FightState = -1
	self.m_FightDataParm.m_buff_state = DamageState.E_DamageState_None
	self.m_FightDataParm.m_pTarObj = nil
	--self.m_FightDataParm.m_iSkill = -1
	self.m_FightDataParm.m_iSkillIndex = -1
	self.m_FightDataParm.m_iSkillRate = 1
	--self.m_FightDataParm.m_iSkillType = -1
	--self.m_FightDataParm.m_iSkillTarType = -1
	self.m_FightDataParm.m_State = -1
	self.m_FightDataParm.m_Damage = {0,0,0,0,0}
	self.m_FightDataParm.m_iParamDamage = 0
	--self.m_FightDataParm.m_CdTime = -1
	self.m_FightDataParm.m_HurtPos = nil
	self.m_FightDataParm.m_HurtPos ={}	
	self.m_FightDataParm.m_Curbone = nil							
								
end

function CreateBaseObj()

	local Obj = {
			-- 创建接口
			Fun_Release = Release,
			Fun_CreatPlayObj = CreatPlayObj,
			Fun_CreatNpcObj = CreatNpcObj,
			Fun_CreatRenderData = CreatRenderData,
			Fun_SetAnimationRes = SetAnimationRes,
			Fun_IsUser = IsUser ,	
			Fun_IsNpc = IsNpc ,					
			Fun_SetIndex = SetIndex,
			Fun_SetTimes = SetTimes,
			Fun_ISCanUseSkill = ISCanUseSkill ,	
			
			--渲染层接口
			Fun_GetRender_Armature = GetRender_Armature,
			Fun_play_Key	= Obj_play_Key,
			Fun_play_Name	= Obj_play_Name,
			Fun_runAction	= Obj_runAction,
			Fun_getPosition = Obj_getPosition,
			Fun_SetPosition = Obj_SetPosition,
			Fun_getPositionX = Obj_getPositionX,
			Fun_SetPositionX = Obj_SetPositionX,
			Fun_getPositionY = Obj_getPositionY,
			Fun_GetCurrentMovementID = GetCurrentMovementID,
			Fun_getZOrder = Obj_getZOrder,
			Fun_getModeHeight = Obj_getModeHeight,
			Fun_getModeWidth = Obj_getModeWidth,
			Fun_getScaleX	= Obj_getScaleX,
			-- 战斗接口
			Fun_IsDie				= IsDie,
			Fun_CheckDamageState 	= CheckDamageState,
			Fun_IsBuff_State 		= IsBuff_State,
			Fun_SetTagObj 			= SetTagObj, 
			Fun_GetTagObj 			= GetTagObj,
			Fun_GetSkillCdTime 		= GetSkillCdTime,
			Fun_GetSkillID 			= GetSkillID,
			Fun_GetSkillResID		= GetSkillResID,
			Fun_GetSkillData 		= GetSkillData,
			Fun_SetUseSkillIndex    = SetUseSkillIndex,
			Fun_GetUseSkillIndex	= GetUseSkillIndex,
			Fun_ClearDamageLogic	= ClearDamageLogic,
			Fun_GetBloodRate		= GetBloodRate,
			Fun_GetTalent			= GetTalent,
			Fun_GetFightDataParm    = GetFightDataParm,
			Fun_GetBaseDB			= GetBaseDB,
			Fun_GetCurBone = GetCurBone,
			Fun_SetCurBone = SetCurBone,
			Fun_PalyBuffGain = PalyBuffGain,
			Fun_PalyBuffState = PalyBuffState,
			Fun_ClearBuffState = ClearBuffState,
			
			Fun_AddskillToStack = AddskillToStack,
			Fun_GetskillFromStack = GetskillFromStack,
			Fun_SetUseSkillRate = SetUseSkillRate,
			Fun_GetUseSkillRate = GetUseSkillRate,
			
			-- 测试接口
			Fun_CreatTestPlayObj = CreatTestPlayObj,
			Fun_CreatTestNpcObj = CreatTestNpcObj,
			
			
			m_RenderData = {	
							m_pArmature = nil, 
							m_rect	= nil,	
									
							},
			m_baseDB = {
						m_Serverid		= 0,
						m_TempID		= 0,
						m_name = "",
						m_TempResid  = 0,
						m_attack	= 0,
						m_wisdom	= 0,
						m_strength	= 0,
						m_attribute	= 0,		
						m_level		= 1,										
						m_star		= 0,
						m_anger		= 0,
						m_engine	= 0,
						m_Dis		= 0,	
						m_FightPosType	= 0,
						m_DropItemID	= -1,
						
						--角色增加5个属性
						m_blood_back	= 0,
						m_engine_back	= 0,
						m_add_gongji	= 0,
						m_add_fangyu	= 0,
						m_State_immune	= 0,
						m_xishoudun = 0,
						
						m_Talent ={
									m_id = 0,											
									m_attack 	 = 0,
									m_wufang	 = 0,
									m_fafang	 = 0,
									m_hp	 	 = 0,
									m_duoshan	 = 0,
									m_crit	 	 = 0,
									m_penetrate	 = 0,
									m_mingzhong	 = 0,
									},					
						

						m_gongji	= 0,
						m_wufang	= 0,
						m_fafang	= 0,
						m_mingzhong	= 0,			
						m_allblood	= 0,
						m_curblood	= 0,
						m_power		= 0,
						
						
						m_SkillData = {	
											{
												m_skillid = 0,
												m_skillresid =0,
												--//释放条件
												m_skill_type = 0,
												--//伤害类型 1物理 2法术
												m_power_type = 0,
												--//施法对象	
												m_site = 0,
												--//技能类型
												m_type = 0,
												--//效果参数
												m_paramete = 0,
												--//伤害系数
												m_ratio = 0,
												--//技能cd
												m_timecd = 0,
												--技能距离
												m_SkillRadius = 0,
												
												--技能怒气回复
												m_anger_back = 0,
												--技能能量回复
												m_engine_back = 0,
												
												--buff 类扩展
												m_bufftimes = 0,										
												m_buffcd = 0,										
												m_buffchace = 0,
											},
											{
												m_skillid = 0,
												m_skillresid =0,
												--//释放条件
												m_skill_type = 0,
												--//伤害类型 1物理 2法术
												m_power_type = 0,
												--//施法对象	
												m_site = 0,
												--//技能类型
												m_type = 0,
												--//效果参数
												m_paramete = 0,
												--//伤害系数
												m_ratio = 0,
												--//技能cd
												m_timecd = 0,
												--技能距离
												m_SkillRadius = 0,
												
												--技能怒气回复
												m_anger_back = 0,
												--技能能量回复
												m_engine_back = 0,
												
												--buff 类扩展
												m_bufftimes = 0,										
												m_buffcd = 0,										
												m_buffchace = 0,
											},
											{
												m_skillid = 0,
												m_skillresid =0,
												--//释放条件
												m_skill_type = 0,
												--//伤害类型 1物理 2法术
												m_power_type = 0,
												--//施法对象	
												m_site = 0,
												--//技能类型
												m_type = 0,
												--//效果参数
												m_paramete = 0,
												--//伤害系数
												m_ratio = 0,
												--//技能cd
												m_timecd = 0,
												--技能距离
												m_SkillRadius = 0,
												
												--技能怒气回复
												m_anger_back = 0,
												--技能能量回复
												m_engine_back = 0,
												
												--buff 类扩展
												m_bufftimes = 0,										
												m_buffcd = 0,										
												m_buffchace = 0,
											}
										
									  },	
												
			
						},
			m_FightDataParm = { 								
								m_FightState = -1,--0 1 判断是跑动中还是原地
								m_buff_state = DamageState.E_DamageState_None,
								m_pTarObj = nil, 
								--m_iSkill = -1, 
								m_iSkillIndex = -1,
								m_iSkillRate = 1,
								--m_iSkillType = -1, 
								--m_iSkillTarType = -1, 
								m_State = -1, 
								m_Damage = {-1,-1,-1,-1,-1}, 
								m_iParamDamage = -1, 
								--m_CdTime = -1, 
								m_HurtPos = {}, 									
								m_Curbone = nil, 	
								
								bufftimes = 0,
								bufftimecd = 0,	
								bBuffTYpe = 0,--给连续动画的buff特效用
				
								},
			--变量
			m_SkillStack = simulationStl.creatStack_First(),
			m_Type = Obj_Type.Type_Obj,		
			m_Index = 0,
			m_Times = 0,
			
			}
	return Obj
end










