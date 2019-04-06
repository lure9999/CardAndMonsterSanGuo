require "Script/Main/Wujiang/GeneralBaseData"

module("Scene_SkillUIObj", package.seeall)

local GetGeneralHeadIcon  = GeneralBaseData.GetGeneralHeadIcon

local MaxMoveTime = 0.2

local SkillType = {
	Skill_Auto		=	1,
	Skill_Normal	=	2,	
	Skill_Arround	=	3,
}

local function PlayHitAni( self, nClearType )
	if self.m_Index ~= 1 and self.m_RenderData.m_HitAni ~= nil then
		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 1 then
				if self.m_RenderData.m_HitAni ~= nil then
					self.m_RenderData.m_HitAni:removeFromParentAndCleanup(true)
					self.m_RenderData.m_HitAni = nil
				end
			end
		end
		self.m_RenderData.m_HitAni:setVisible(true)
		self.m_RenderData.m_HitAni:getAnimation():play("Animation7")
		self.m_RenderData.m_HitAni:getAnimation():setMovementEventCallFunc(onMovementEvent)
	end
end

local function DelSkillAni( self )
	if self.m_RenderData.m_SkillAni ~= nil then
		--print("del self.m_Index = "..self.m_Index)
		self.m_RenderData.m_SkillAni:removeFromParentAndCleanup(true)
		self.m_RenderData.m_SkillAni = nil
	end
end

local function SetSkillTouchEnabled( self, nState )
	if self.m_RenderData.m_SkillBg ~= nil then

		self.m_RenderData.m_SkillBg:setTouchEnabled( nState )

	end
end

local function SetAnimationGray( self, nState )
	if self.m_RenderData.m_SkillAni ~= nil then
		if nState == true then

			CCArmatureSharder(self.m_RenderData.m_SkillAni, SharderKey.E_SharderKey_Normal)

		else

			CCArmatureSharder(self.m_RenderData.m_SkillAni, SharderKey.E_SharderKey_GrayScaling)

		end
	end

	if self.m_RenderData.m_SkillAround ~= nil then
		if nState == true then

			CCArmatureSharder(self.m_RenderData.m_SkillAround, SharderKey.E_SharderKey_Normal)

		else

			CCArmatureSharder(self.m_RenderData.m_SkillAround, SharderKey.E_SharderKey_GrayScaling)

		end
	end

end

local function CreateAni( self )
	--技能动画
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/animation/zhandoutiao_texiao/zhandoutiao_texiao.ExportJson")
	self.m_RenderData.m_SkillAni = CCArmature:create("zhandoutiao_texiao")
	self.m_RenderData.m_SkillAni:setVisible(false)
	self.m_RenderData.m_SkillBg:addNode(self.m_RenderData.m_SkillAni,9)

	if self.m_Life == false then

		SetAnimationGray(self, false)

	end

end

local function SetLifeUI( self, nState )

	if self.m_RenderData.m_SkillBg ~= nil then

		self.m_Life = nState

		local pBgSp = tolua.cast(self.m_RenderData.m_SkillBg:getVirtualRenderer(), "CCSprite")
		local pSkillSp = tolua.cast(self.m_RenderData.m_Skill:getVirtualRenderer(), "CCSprite")
		local pColorSp = tolua.cast(self.m_RenderData.m_SkillColor:getVirtualRenderer(), "CCSprite")

		if self.m_TypeID == SkillType.Skill_Arround then
			if nState == true then
				--生存UI效果
				--print("生存UI效果"..self.m_Index)
				SpriteSetGray(pBgSp,0)
				SpriteSetGray(pSkillSp,0)
				SpriteSetGray(pColorSp,0)
			else
				--死亡UI效果
				--print("圆形死亡UI效果"..self.m_Index)
				SpriteSetGray(pBgSp,1)
				SpriteSetGray(pSkillSp,1)
				SpriteSetGray(pColorSp,1)
			end
		else

			if nState == true then
				--生存UI效果
				--print("生存UI效果"..self.m_Index)
				SpriteSetGray(pBgSp,0)
				SpriteSetGray(pSkillSp,0)
				SpriteSetGray(pColorSp,0)
			else
				--死亡UI效果
				--print("方块死亡UI效果"..self.m_Index)
				SpriteSetGray(pBgSp,1)
				SpriteSetGray(pSkillSp,1)
				SpriteSetGray(pColorSp,1)
			end

		end

		SetAnimationGray(self, nState)

	end
end

local function PlayArounSkillAni( self )
	local _AniStrBorn,_AniStrRepeat = nil
	if self.m_ColorID == 1 then
		_AniStrBorn 	= "Animation1"
		_AniStrRepeat 	= "Animation2"
	elseif self.m_ColorID == 2 then
		_AniStrBorn		= "Animation1_1"
		_AniStrRepeat 	= "Animation2_1"
	elseif self.m_ColorID == 3 then
		_AniStrBorn 	= "Animation1_2"
		_AniStrRepeat 	= "Animation2_2"
	end

	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if self.m_RenderData.m_SkillAround ~= nil then
				self.m_RenderData.m_SkillAround:getAnimation():play(_AniStrRepeat)
			end
		end
	end

	if self.m_RenderData.m_SkillAround ~= nil then
		self.m_RenderData.m_SkillAround:setVisible(true)
		self.m_RenderData.m_SkillAround:getAnimation():play(_AniStrBorn)
		self.m_RenderData.m_SkillAround:getAnimation():setMovementEventCallFunc(onMovementEvent)
	end
end

local function PlaySkillAni( self, nClearType )
	--if self.m_RenderData.m_SkillAni ~= nil then

	CreateAni( self )

	local _AniStr = nil
	if self.m_ColorID == 1 then
		_AniStr = "Animation4_"
	elseif self.m_ColorID == 2 then
		_AniStr = "Animation5_"
	elseif self.m_ColorID == 3 then
		_AniStr = "Animation6_"
	end

	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if nClearType == FightClear_Type.Type_DoubelClear then
				self.m_RenderData.m_SkillAni:getAnimation():play(_AniStr.."2")
				--print("双消循环")
			elseif nClearType == FightClear_Type.Type_TripleClear then
				self.m_RenderData.m_SkillAni:getAnimation():play(_AniStr.."4")
				--print("三消循环")
			end
		end
	end
	self.m_RenderData.m_SkillAni:setVisible(true)

	if nClearType == FightClear_Type.Type_DoubelClear then
		self.m_RenderData.m_SkillAni:getAnimation():play(_AniStr.."1")
		self.m_RenderData.m_SkillBg:setZOrder(998)
		--print("双消出生"..self.m_Index)
	elseif nClearType == FightClear_Type.Type_TripleClear then
		self.m_RenderData.m_SkillAni:getAnimation():play(_AniStr.."3")
		self.m_RenderData.m_SkillBg:setZOrder(999)
		print("三消出生"..self.m_Index)
	end

	self.m_RenderData.m_SkillAni:getAnimation():setMovementEventCallFunc(onMovementEvent)

end

local function InitAttr( self, nBase, nGeneralID, nSkillID, nSkillType ,nColorID, nSkillTab, nIndex, PosTab, Life )
	--print(nGeneralID, nColorID, nSkillID)
	self.m_Index 		= nIndex
	--print("self.m_Index = "..self.m_Index)
	self.m_Base  		= nBase

	self.m_SkillID   	= nSkillID

	self.m_GeneralID    = nGeneralID

	self.m_ColorID  	= nColorID

	self.Pos_Skill 		= PosTab

	self.m_TypeID		= nSkillType

	self.m_Life 		= Life

	self.SKillTab       = nSkillTab
	--print(self.m_TypeID)
end

--参数1：父节点
--参数2：技能ID
--参数3：技能索引
--参数4：技能移动回调

--副本类型的UI
local function CreateSkill( self, nCallBack, nClickCallBack )

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/animation/zhandoutiao_texiao/zhandoutiao_texiao.ExportJson")

	--技能背景
	if self.m_TypeID == SkillType.Skill_Normal then
		--方块技能底
		self.m_RenderData.m_SkillBg 	 = ImageView:create()
		self.m_RenderData.m_SkillBg:loadTexture("Image/imgres/Fight/UI/New/skillframe_"..self.m_ColorID..".png")

	elseif self.m_TypeID == SkillType.Skill_Arround then
		--圆形技能底
		self.m_RenderData.m_SkillBg 	 = ImageView:create()
		self.m_RenderData.m_SkillBg:loadTexture("Image/imgres/Fight/UI/New/skillarround_"..self.m_ColorID..".png")

		--圆圈技能创建动画
		self.m_RenderData.m_SkillAround = CCArmature:create("zhandoutiao_texiao")
		self.m_RenderData.m_SkillAround:setVisible(false)
		self.m_RenderData.m_SkillBg:addNode(self.m_RenderData.m_SkillAround,1)
	end

	self.m_RenderData.m_SkillColor   = ImageView:create()
	self.m_RenderData.m_SkillColor:setTouchEnabled(false)
	self.m_RenderData.m_SkillColor:loadTexture("Image/imgres/Fight/UI/New/skillbottom_"..self.m_ColorID..".png")
	self.m_RenderData.m_SkillBg:addChild(self.m_RenderData.m_SkillColor,2)

	--技能
	self.m_RenderData.m_Skill   	 = ImageView:create()
	self.m_RenderData.m_Skill:setTouchEnabled(false)
	self.m_RenderData.m_Skill:loadTexture(_Path)	
	self.m_RenderData.m_SkillBg:addChild(self.m_RenderData.m_Skill,4)

	local pSkillSp = tolua.cast(self.m_RenderData.m_Skill:getVirtualRenderer(), "CCSprite")
	local pColorSp = tolua.cast(self.m_RenderData.m_SkillColor:getVirtualRenderer(), "CCSprite")

	local _Path = GetGeneralHeadIcon( self.m_GeneralID )

	if self.m_TypeID == SkillType.Skill_Arround then
		--技能切圆
		self.m_RenderData.m_Skill:setPosition(ccp(0,10))
		MakeMaskIcon(pSkillSp, _Path, 0, 0.78, "Image/imgres/common/Mask_Round.png")
		MakeMaskIcon(pColorSp, "Image/imgres/Fight/UI/New/skillbottom_"..self.m_ColorID..".png", 0, 1.0, "Image/imgres/common/Mask_Round_2.png")
	elseif self.m_TypeID == SkillType.Skill_Normal then
		--技能切方
		self.m_RenderData.m_Skill:setPosition(ccp(2,10))
		MakeMaskIcon(pSkillSp, _Path, 0, 0.78, "Image/imgres/common/Mask_Square.png")
	end
	
	self.m_RenderData.m_SkillBg:setPosition(self.Pos_Skill[8])
	self.m_Base:addChild(self.m_RenderData.m_SkillBg, 3)

	--技能碰撞动画
	if self.m_Index ~= 1 then
		self.m_RenderData.m_HitAni = CCArmature:create("zhandoutiao_texiao")
		self.m_RenderData.m_HitAni:setVisible(false)
		self.m_RenderData.m_HitAni:setPosition(ccp(55,0))
		self.m_RenderData.m_SkillBg:addNode(self.m_RenderData.m_HitAni,999)
	end

	--判断勇士生命状态
	--print(self.m_Life, self.m_GeneralID)
	if self.m_Life == false then

		SetLifeUI( self, false )

	end

	local nTime = MaxMoveTime - ( ( MaxMoveTime / 8 ) * (self.m_Index - 1) )  		--移动时间递减

	local function _Click_ClearUp_CallBack( sender, eventType )
    	if eventType == TouchEventType.ended then
    		nClickCallBack( self.SKillTab, self.m_Index, self.m_ClearUpTag )
	    end 
	end

	self.m_RenderData.m_SkillBg:addTouchEventListener(_Click_ClearUp_CallBack)

	local function _MoveBegin_CallBack( )
		self.m_RenderData.m_SkillBg:setTouchEnabled(false)
	end

	--技能移动到指定位置后的逻辑处理
	local function _MoveEnd_CallBack( )
		nCallBack()
		PlayArounSkillAni( self )
		self.m_RenderData.m_SkillBg:setTouchEnabled(true)
	end

	local pActionArr = CCArray:create()
	pActionArr:addObject(CCCallFunc:create(_MoveBegin_CallBack))
	pActionArr:addObject(CCMoveTo:create(nTime, self.Pos_Skill[self.m_Index]))
	pActionArr:addObject(CCDelayTime:create(nTime))
	pActionArr:addObject(CCCallFunc:create(_MoveEnd_CallBack))
	self.m_RenderData.m_SkillBg:stopAllActions()
	self.m_RenderData.m_SkillBg:runAction(CCSequence:create(pActionArr))		

end

local function MovePos( self )

	local function CallBack(  )
		--print(self.m_Index.." = true")
		self.m_RenderData.m_SkillBg:setTouchEnabled(true)
	end
	--print("====================="..self.m_Index)
	if self.m_Index ~= 0 then
		local pActionArr = CCArray:create()
		pActionArr:addObject(CCMoveTo:create(0.1, self.Pos_Skill[self.m_Index]))
		pActionArr:addObject(CCCallFunc:create(CallBack))
		self.m_RenderData.m_SkillBg:stopAllActions()
		self.m_RenderData.m_SkillBg:runAction(CCSequence:create(pActionArr))	
	end

end

local function SetSkillID( self, nSKillID )
	self.m_SkillID = nSKillID
end

local function GetSkillID( self )
	return self.m_SkillID
end

local function SetSkillIndex( self, nSKillIndex )
	self.m_Index = nSKillIndex
	--[[local nStrIndex = "Index"..self.m_Index
	self.m_SkillInDexLabel:setText(nStrIndex)]]
end

local function GetSkillIndex( self )
	return self.m_Index
end

local function SetClearUpTag( self, nClearUpTag )
	self.m_ClearUpTag = nClearUpTag

	if self.m_TypeID ~= FightClear_Type.Type_TripleClear and self.m_RenderData.m_SkillBg ~= nil then

		self.m_RenderData.m_SkillBg:setZOrder(3)

	end

end

local function GetClearUpTag( self )
	return self.m_ClearUpTag
end

local function GetSkillType( self )
	return self.m_TypeID 
end

local function GetSKillGeneralID( self )
	return self.m_GeneralID
end

local function DelFromParent( self )
	self.m_RenderData.m_SkillBg:removeFromParentAndCleanup(true)
	self.m_RenderData.m_SkillBg = nil
end

local function Release( self )
	self.m_Index 						= 	nil
	self.m_SkillID 						=	nil
	self.m_ClearUpTag					=	nil
	self.m_GeneralID 					=	nil
	self.m_Life							=	nil
	self.m_GeneralID 					=	nil

	self.m_RenderData.m_SkillBg  		=	nil
	self.m_RenderData.m_Skill  			=	nil
	self.m_RenderData.m_SkillColor  	=	nil
	self.m_RenderData.m_SkillAni  		=	nil
	self.m_RenderData.m_SkillAround  	=	nil
	self.m_RenderData  					=	nil
end

function CreateBaseObj()

	local Obj = {
				--funciton
				Fun_InitAttr				=	InitAttr,
				Fun_CreateSkill 			=	CreateSkill,
				Fun_GetSkillID 				=	GetSkillID,
				Fun_SetSkillIndex 			=	SetSkillIndex,
				Fun_GetSkillIndex 			=	GetSkillIndex,
				Fun_PlaySkillAni 			=	PlaySkillAni,
				Fun_DelSkillAni				=	DelSkillAni,
				Fun_PlayHitAni				=	PlayHitAni,
				Fun_SetClearUpTag 			=	SetClearUpTag,
				Fun_GetClearUpTag 			=	GetClearUpTag,
				Fun_GetSkillType			=	GetSkillType,
				Fun_SetSkillTouchEnabled	=	SetSkillTouchEnabled,
				Fun_MovePos					=	MovePos,
				Fun_SetLifeUI				=	SetLifeUI,
				Fun_GetSKillGeneralID		=	GetSKillGeneralID,
				Fun_SetAnimationGray		=	SetAnimationGray,

				Fun_DelFromParent 			=	DelFromParent,
				Fun_Release 				=	Release,
				--member
				m_RenderData = {
					m_SkillBg 				=	nil,
					m_Skill 				=	nil,
					m_SkillColor 			=	nil,
					m_SkillAni 				=	nil,
					m_SkillAround			=	nil,
					m_HitAni				=	nil,
				},


				m_DeathList = {

				},

				m_SkillID 					=	nil,
				m_Base 						=	nil,
				m_ColorID 					=	nil,
				m_SkillMoveSpeed            =   100,
				m_TypeID					=	nil,
				m_Life 						=	nil,
				m_GeneralID					=	nil,
				m_ClearUpTag 				=	FightClear_Type.Type_SingleClear,
			}
	return Obj
end










