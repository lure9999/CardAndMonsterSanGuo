require "Script/Common/Common"
require "Script/Main/Wujiang/GeneralBaseData"

module("HeroArmatureLayer", package.seeall)

local GetGeneralType			= GeneralBaseData.GetGeneralType

local m_plyHeroArmaLayer = nil
local m_btnOk = nil
local m_imgState = nil
local m_imgPgBar = nil

local m_nType = nil
local m_nPos = nil
local m_funcCallBack = nil

local  function InitVars(  )
	m_plyHeroArmaLayer = nil
	m_btnOk = nil
	m_imgState = nil
	m_imgPgBar = nil
end

local strStartUp = {
					"启用成功！您的生命形态已发生本质上的变化，各种属性都将产生巨大的改变，不要担心，莫要害怕，这不会危害您的生命安全！！！",
					"启用成功！主公您果然是个闪闪发亮的变形金刚啊！要注意切换不同的主将职业所对应的缘分属性也是不一样的哦！！",
					"启用成功！因为切换了不同职业，您的属性会根据您职业的特点而各有发展呢！根据自己的喜好选择不同职业吧！"
					}

local function _Button_OK_HeroArmature_CallBack( sender, eventType)
	if eventType==TouchEventType.ended then
		sender:setScale(1.0)
		if sender:getTag()==2 then
			if m_funcCallBack~=nil then
				print("nState == "..sender:getTag())
				m_funcCallBack(m_nType, m_nPos)
			end
		end
		m_plyHeroArmaLayer:removeFromParentAndCleanup(true)
		InitVars()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function GetArmature(pAnimationfileName, pAnimationName,nScale)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)
	local pPlArmature = tolua.cast(m_plyHeroArmaLayer:getWidgetByName("Panel_Armature"), "Layout")
	local pArmature = CCArmature:create(pAnimationName)
    pArmature:setPosition(ccp(pPlArmature:getSize().width/2, pPlArmature:getSize().height/2 -80 ))
	if nScale~=nil then
		pArmature:setScale(nScale)
	else
		pArmature:setScale(1.8)
	end
    return pArmature
end

local function PlayCallSuccessfullAnimation( nGeneralId, nType, nPos, funcCallBack )
	local nResID = tonumber(general.getFieldByIdAndIndex(nGeneralId, "ResID"))
	local pAnimationfileName, pAnimationName = GeneralBaseData.GetAnimationData(nResID)
	local pArmature = GetArmature( pAnimationfileName, pAnimationName )
	pArmature:getAnimation():play(GetAniName_Res_ID(nResID, Ani_Def_Key.Ani_attack))
    m_plyHeroArmaLayer:addChild(pArmature)
    m_nType = nType
	m_nPos = nPos
	if funcCallBack~=nil then
		m_funcCallBack = funcCallBack
	end
	m_imgPgBar:setVisible(false)
	m_imgState:loadTexture("Image/imgres/wujiang/call.png")
	m_imgState:setVisible(false)
	m_imgState:setPosition( ccp(m_imgState:getPositionX(), m_imgState:getPositionY()+40) )
	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if m_btnOk:isVisible()==false then
				pArmature:getAnimation():play(GetAniName_Res_ID(nResID, Ani_Def_Key.Ani_stand))
				m_imgState:setVisible(true)
				m_btnOk:setVisible(true)
				m_btnOk:setTouchEnabled(true)
			end
		end
	end
	pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
end

local function CreateStartupTip(  )
	local pLabel = Label:create()
	pLabel:setFontSize(18)
	pLabel:setPosition(ccp(m_imgState:getPositionX(), m_imgState:getPositionY() + m_imgState:getSize().height*1.5))
	math.randomseed(os.time())
	local strText = strStartUp[math.random(1,3)]
	pLabel:setText(strText)
	return pLabel
end

local function PlayStartUpAnimation( nGeneralId )
	local nResID = tonumber(general.getFieldByIdAndIndex(nGeneralId, "ResID"))
	local pAnimationfileName, pAnimationName = GeneralBaseData.GetAnimationData(nResID)
	local pArmature = GetArmature( pAnimationfileName, pAnimationName )
	pArmature:getAnimation():play(GetAniName_Res_ID(nResID, Ani_Def_Key.Ani_attack))
    m_plyHeroArmaLayer:addChild(pArmature)

	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			m_imgPgBar:setVisible(false)
			if m_btnOk:isVisible()==false then
				pArmature:getAnimation():play(GetAniName_Res_ID(nResID, Ani_Def_Key.Ani_cheers))
				m_imgState:loadTexture("Image/imgres/wujiang/success.png")
				m_btnOk:setVisible(true)
				m_btnOk:setTouchEnabled(true)
				m_plyHeroArmaLayer:addChild(CreateStartupTip())
			end
		end
	end

	local proTimer = CCProgressTimer:create(CCSprite:create("Image/imgres/wujiang/pgbar.png"))
	proTimer:setType(1)
	proTimer:setPercentage(0)
	proTimer:setPosition(0, 0)
	proTimer:setBarChangeRate(CCPointMake(1, 0))
	proTimer:setMidpoint(CCPointMake(0, 1))
	m_imgPgBar:addNode(proTimer)

	local proTo = CCProgressTo:create(1, 100)
	local actArr = CCArray:create()
	actArr:addObject(proTo)
	actArr:addObject(CCDelayTime:create(1))
	proTimer:runAction(CCSequence:create(actArr))
	pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
end
--激活点击
local function _Click_JH_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		m_plyHeroArmaLayer:removeFromParentAndCleanup(true)
		m_plyHeroArmaLayer = nil
	end

end
--激活的特效
local function PlayActivateAnimation( nGeneralId, nPosX, nPosY )
	--先播一个特效再播人物出来
	m_btnOk:setVisible(false)
	m_btnOk:setTouchEnabled(false)
	m_imgState:setVisible(false)
	m_imgPgBar:setVisible(false)
	local nResID = tonumber(general.getFieldByIdAndIndex(nGeneralId, "ResID"))
	local pAnimationfileName, pAnimationName = GeneralBaseData.GetAnimationData(nResID)
	local pArmature = GetArmature( pAnimationfileName, pAnimationName,1.35 )
	pArmature:setVisible(false)
	m_plyHeroArmaLayer:addChild(pArmature)
	local function ActionCallBack(pAnimation)
		local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)	   
				if evt == "birth" then 
					--Pause()
					pArmature:setVisible(true)
					pArmature:getAnimation():play(GetAniName_Res_ID(nResID, Ani_Def_Key.Ani_manual_skill))
					local pPlArmature = tolua.cast(m_plyHeroArmaLayer:getWidgetByName("Panel_Armature"), "Layout")
					local function onMovementEvent(armatureBack,movementType,movementID)
						if movementType == 1 then
							--[[local function PlayOver( )
								m_plyHeroArmaLayer:removeFromParentAndCleanup(true)
								m_plyHeroArmaLayer = nil
							end

							local actMove = CCMoveTo:create(1, ccp(nPosX, nPosY))
							local actScale = CCScaleTo:create(1, 0)
							local actArr = CCArray:create()
							actArr:addObject(CCSpawn:createWithTwoActions(actMove, actScale))
							actArr:addObject(CCCallFuncN:create(PlayOver))
							pArmature:runAction(CCSequence:create(actArr))]]--
							--0318修改为切换为呼吸动作 点击以后删除
							pArmature:getAnimation():play(GetAniName_Res_ID(nResID, Ani_Def_Key.Ani_stand))
							pPlArmature:setTouchEnabled(true)
							pPlArmature:addTouchEventListener(_Click_JH_CallBack)
						end
					end
					pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
				end
			
		end
		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 1 then
				if pAnimation~=nil then
					--pAnimation:removeFromParentAndCleanup(true)
				end
			end
		end
	
		pAnimation:setFrameEventCallFunc(onFrameEvent)	
		pAnimation:setMovementEventCallFunc(onMovementEvent)
		pAnimation:play("Animation1")
	end
	CommonInterface.GetAnimationToPlay("Image/imgres/effectfile/zhujue_jihuo_texiao/zhujue_jihuo_texiao.ExportJson", 
										"zhujue_jihuo_texiao", 
										"Animation1", 
										m_plyHeroArmaLayer, 
										ccp(570, 320),
										ActionCallBack)
	
end

local function InitWidgets( nState )
	m_btnOk = tolua.cast(m_plyHeroArmaLayer:getWidgetByName("Button_OK"), "Button")
	if m_btnOk==nil then
		print("m_btnOk is nil")
		return false
	else
		m_btnOk:setTag(nState)
		m_btnOk:setVisible(false)
	    m_btnOk:setTouchEnabled(false)
	    local pLabel = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black,  COLOR_White, true, ccp(0, -2), 2)
	    m_btnOk:addChild(pLabel)
	    m_btnOk:addTouchEventListener(_Button_OK_HeroArmature_CallBack)
	end

	m_imgState = tolua.cast(m_plyHeroArmaLayer:getWidgetByName("Image_State"), "ImageView")
	if m_imgState==nil then
		print("m_imgState is nil")
		return false
	end

	m_imgPgBar = tolua.cast(m_plyHeroArmaLayer:getWidgetByName("Image_Pro_Bg"), "ImageView")
	if m_imgPgBar==nil then
		print("m_imgPgBar is nil")
		return false
	end
	return true
end

local function _Click_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		m_plyHeroArmaLayer:removeFromParentAndCleanup(true)
		m_plyHeroArmaLayer = nil
	end
end
--进阶
local function PlayJinJieAnimation( nGeneralId, nPosX, nPosY )
	local nResID = tonumber(general.getFieldByIdAndIndex(nGeneralId, "ResID"))
	local jobType = tonumber(job.getFieldByIdAndIndex(nGeneralId, "Job"))
	local pAnimationfileName, pAnimationName = GeneralBaseData.GetAnimationData(nResID)
	local pArmature = GetArmature( pAnimationfileName, pAnimationName ,1.35)
	local nSex = tonumber(job.getFieldByIdAndIndex(nGeneralId, "Gender"))
	local nJjGeneralID = 80011
	local JinjieStep = 1
	if jobType == 1 then
		if tonumber(nGeneralId)==80012 or tonumber(nGeneralId)== 81012 then
			if nSex == 1 then
				nJjGeneralID = 80012
			else
				nJjGeneralID = 81012
			end
			pArmature:getAnimation():play("shengji_zs")
			JinjieStep = 2
		else
			pArmature:getAnimation():play("shengji_mj")
			if nSex == 1 then
				nJjGeneralID = 80013
			else
				nJjGeneralID = 81013
			end
			JinjieStep = 3
		end
	elseif jobType==2 then
		if tonumber(nGeneralId)==80032 or tonumber(nGeneralId)== 81032 then
			pArmature:getAnimation():play("shengji_ms")
			if nSex == 1 then
				nJjGeneralID = 80032
			else
				nJjGeneralID = 81032
			end
			JinjieStep = 2
		else
			pArmature:getAnimation():play("shengji_cs")
			if nSex == 1 then
				nJjGeneralID = 80043
			else
				nJjGeneralID = 81043
			end
			JinjieStep = 3
		end
		
	else
		if tonumber(nGeneralId)==80042 or tonumber(nGeneralId)== 81042 then
			pArmature:getAnimation():play("shengji_gs")
			if nSex == 1 then
				nJjGeneralID = 80042
			else
				nJjGeneralID = 81042
			end
			JinjieStep = 2
		else
			pArmature:getAnimation():play("shengji_fy")
			if nSex == 1 then
				nJjGeneralID = 80053
			else
				nJjGeneralID = 81053
			end
			JinjieStep = 3
		end
		
	end
	--添加将要变身的
	local nResIDNext = tonumber(general.getFieldByIdAndIndex(nJjGeneralID, "ResID"))
	local pAnimationfileNameNext, pAnimationNameNext = GeneralBaseData.GetAnimationData(nResIDNext)
	local pArmatureNext = GetArmature( pAnimationfileName, pAnimationName ,1.35)
	pArmatureNext:getAnimation():play(GetAniName_Res_ID(nResIDNext, Ani_Def_Key.Ani_stand))
	pArmatureNext:setVisible(false)
	m_plyHeroArmaLayer:addChild(pArmatureNext,600,600)
	--end
	local pPlArmature = tolua.cast(m_plyHeroArmaLayer:getWidgetByName("Panel_Armature"), "Layout")
	local pos = ccp(pPlArmature:getSize().width/2-5, pPlArmature:getSize().height/2 -80 )

	print("JinjieStep = "..JinjieStep)

	local pAniStr = "shengji_zs_jinjie_1"

	if JinjieStep == 3 then

		pAniStr = "shengji_zs_jinjie_3"

	end
	
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/nanzhu_zs_jinjie/nanzhu_zs_jinjie.ExportJson", 
				"nanzhu_zs_jinjie", 
				pAniStr, 
				m_plyHeroArmaLayer, 
				pos,
				nil,
				900,
				true)
	m_plyHeroArmaLayer:addChild(pArmature,600,600)
	
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/nanzhu_zs_jinjie/nanzhu_zs_jinjie.ExportJson", 
				"nanzhu_zs_jinjie", 
				"shengji_zs_jinjie_2", 
				m_plyHeroArmaLayer, 
				pos,
				nil,
				500,
				true)
	
				
    m_btnOk:setVisible(false)
   	m_btnOk:setTouchEnabled(false)
   	m_imgState:setVisible(false)
   	m_imgPgBar:setVisible(false)

    local function onMovementEvent(armatureBack,movementType,movementID)
    	if movementType == 1 then
			pArmature:removeFromParentAndCleanup(true)
			pArmatureNext:setVisible(true)
    		local function PlayOver( )
    			--播技能
				local function onMovementNextEvent(armatureBack,movementType,movementID)
					if movementType == 1 then
						pArmatureNext:getAnimation():play(GetAniName_Res_ID(nResIDNext, Ani_Def_Key.Ani_stand))
						pPlArmature:setTouchEnabled(true)
						
						
						pPlArmature:addTouchEventListener(_Click_CallBack)
					end
				end
				
				pArmatureNext:getAnimation():play(GetAniName_Res_ID(nResIDNext, Ani_Def_Key.Ani_manual_skill))
				pArmatureNext:getAnimation():setMovementEventCallFunc(onMovementNextEvent)
			end
			
			local actDelay = CCDelayTime:create(1)
			local actArr = CCArray:create()
			actArr:addObject(actDelay)
			actArr:addObject(CCCallFuncN:create(PlayOver))
			pArmatureNext:runAction(CCSequence:create(actArr))
    	end
    end
	local function onFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
		if evt == "VibrationSceen02" then    
			--开始震屏
			BaseSceneLogic.VibrationSceen(14)
		end
	end
    pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	pArmature:getAnimation():setFrameEventCallFunc(onFrameEvent)
end
function CreateHeroArmaLayer( nGeneralId, nState, Param1, Param2, funcCallBack)
	InitVars()
	m_plyHeroArmaLayer = TouchGroup:create()
	m_plyHeroArmaLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/HeroArmatureLayer.json" ))

	if InitWidgets(nState)==false then
		return
	end
	if nState==0 then
		--激活
		PlayActivateAnimation(nGeneralId, Param1, Param2)
	elseif nState==1 then
		PlayStartUpAnimation(nGeneralId)
	elseif nState==2 then
		PlayCallSuccessfullAnimation(nGeneralId, Param1, Param2, funcCallBack)
	elseif nState == 3 then
		--进阶
		PlayJinJieAnimation(nGeneralId, Param1, Param2)
	end
	return m_plyHeroArmaLayer
end