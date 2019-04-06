--add by sxin 1-1场景故事剧本
module("cg_piantou", package.seeall)

local Cg_Text = 
{
	{m_Text = "汉朝末年，天子无道，荒废朝政，朝堂危如累卵。",m_time = 5,},	
	{m_Text = "朝廷内，宦官、外戚相斗夺权，不料被董卓乘虚而入。",m_time = 8},	
	{m_Text = "董卓铲除异己，纵容兵士，一时间，百姓苦不堪言。",m_time = 6},
	{m_Text = "至此，诸侯并起，天下大乱。九天仙人，悲悯苍生。",m_time = 6},
	{m_Text = "英雄破空降世，欲平定乱世以拯救天下苍生与水火。",m_time = 5},
					
}
local pTouchGroup = nil
local m_fCallBack = nil 
--播放特效片头支持字幕逐字播放 白色字体 标准大小32 默认字体
local function Play_Cg_Text(pRoot,pTable_Text,posY)

	local colorText = COLOR_White
	local sizeText = 32
	local fontText = "default"

	local _Label_ = Label:create()

	_Label_:setFontSize(sizeText)
	_Label_:setColor(colorText)

	if fontText ~= "default" then
		_Label_:setFontName(fontText)
	end
	
	_Label_:setText(pTable_Text.m_Text)

	local nTextSize = _Label_:getSize()
	
	local iPosx =  - nTextSize.width*0.5 

	_Label_:setPosition(ccp(iPosx, posY))
	_Label_:setAnchorPoint(ccp(0,0.5))		
	pRoot:addChild(_Label_,Play_Effect_Z)			
end

--创建一个特效 在播放完后回调 不循环特效 回调事件帧事件
local function createEffect_Scence(strEffectfile, strEffectName, actIndex, bflip, pRoot, Effectpos, pMovementEventcallback,pFrameEventcallback)
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strEffectfile)
	
	local function onEffectMovementEvent(Armature, MovementType, movementID)

		if MovementType == 0	then
		
		elseif MovementType == 1 then
		
			Armature:removeFromParentAndCleanup(true)	
			if pMovementEventcallback ~= nil then
				
				pMovementEventcallback()
				
			end
						
		elseif MovementType == 2 then		
			
		end
	end
	
	local function onEffectFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)	   
			
			if pFrameEventcallback ~= nil then 
				pFrameEventcallback(bone,evt,originFrameIndex,currentFrameIndex)
			end
		
	end
	
	--创建特效	
	
	local pArmature = CCArmature:create(strEffectName)
	pArmature:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
	pArmature:getAnimation():setFrameEventCallFunc( onEffectFrameEvent)				
	pArmature:setPosition(Effectpos)	
	pArmature:getAnimation():playWithIndex(actIndex)
		
	if 	bflip == true then 
		
		pArmature:setScaleX(-(pArmature:getScaleX()))
		
	end
	
	--pRoot:addChild(pArmature,Play_Effect_Z)	
	pRoot:addNode(pArmature,Play_Effect_Z)			
		
end
local function _Btn_Skip_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		pTouchGroup:removeFromParentAndCleanup(true)	
		pTouchGroup = nil
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function DelelteCg()
	if pTouchGroup~=nil then
		pTouchGroup:removeFromParentAndCleanup(true)	
		pTouchGroup = nil
	end
end
function SetFCallBack(fCallBack)
	m_fCallBack = fCallBack
end

local function AddSkipButton(pParent)
	local btn_skip = Button:create()
	btn_skip:loadTextures("Image/imgres/button/btn_skip.png","Image/imgres/button/btn_skip.png","")
	btn_skip:addTouchEventListener(_Btn_Skip_CallBack)
	btn_skip:setPosition(ccp(1025+CommonData.g_Origin.x,590+CommonData.g_Origin.y))
	pParent:addChild(btn_skip,6000)
end

function playCg()			
	pTouchGroup = nil
	pTouchGroup = TouchGroup:create()
	local pCurscene =  CCDirector:sharedDirector():getRunningScene()
	
	local pCgLayer = Layout:create()
	
	pCgLayer:setSize(CCSize(1140,640))
	pCgLayer:setTouchEnabled(true)	
	
	AddSkipButton(pCgLayer)
	pCgLayer:setZOrder(6000)
	pTouchGroup:addWidget(pCgLayer)
	pCurscene:addChild(pTouchGroup,99999)
	
	local iCgIndex = 1
	
	local function effectFrameEvent( bone,evt,originFrameIndex,currentFrameIndex )
		
		if evt == "bo" then 
		
			local pArmature = bone:getArmature()
			
			Play_Cg_Text(pArmature,Cg_Text[iCgIndex],-285)
			
		end
		
		if evt == "playbgm" then 		
			AudioUtil.playBgm("audio/cg/music_pt.mp3",false)			
		end
		
	end
	
	local function effectEnd_Over()
		--删除层
		if m_fCallBack~=nil then
			m_fCallBack()
		end
		pTouchGroup:removeFromParentAndCleanup(true)	
		pTouchGroup = nil
	end
	
	local function effectEnd_5()
		iCgIndex = 5
		
		local iSex = CommonData.g_MainDataTable["gender"]  --1--man 2--woman
		
		if iSex == 1 then 
			createEffect_Scence("Image/Fight/cg/piantou06/piantou06.ExportJson","piantou06",0,false,pCgLayer,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_Over,effectFrameEvent)
		else
			createEffect_Scence("Image/Fight/cg/piantou06/piantou06.ExportJson","piantou06",1,false,pCgLayer,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_Over,effectFrameEvent)
		end		
		
	end
	
	local function effectEnd_4()
		iCgIndex = 4
		createEffect_Scence("Image/Fight/cg/piantou05/piantou05.ExportJson","piantou05",0,false,pCgLayer,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_5,effectFrameEvent)
		
	end
	
	local function effectEnd_3()
		iCgIndex = 3
		createEffect_Scence("Image/Fight/cg/piantou04/piantou04.ExportJson","piantou04",0,false,pCgLayer,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_4,effectFrameEvent)
		
	end
	
	local function effectEnd_2()
		iCgIndex = 2
		createEffect_Scence("Image/Fight/cg/piantou03/piantou03.ExportJson","piantou03",0,false,pCgLayer,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_3,effectFrameEvent)
		
	end
	
		
	createEffect_Scence("Image/Fight/cg/piantou02/piantou02.ExportJson","piantou02",0,false,pCgLayer,ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2+ CommonData.g_Origin.y),effectEnd_2,effectFrameEvent)
			
end


