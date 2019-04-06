

--新手引导第一大部 celina
module("NewGuideServerOne", package.seeall)

require "Script/Main/CountryWar/CountryWarGuideManager"
require "Script/Main/NewGuide/ServerOne/NewGuideServerOne_GuanZhan"
require "Script/Main/NewGuide/ServerOne/NewGuideServerOne_AddNPC"

--界面
local CreateGuideLayer = NewGuideLayer.CreateNewGuideLayer
local GetNewGuideTouchGroup = NewGuideLayer.GetNewGuideTouchGroup
local GetNewGuideLayer = NewGuideLayer.GetNewGuideLayer
local AddGuideIcon = NewGuideLayer.AddGuideIcon

local CreateAddNPC = NewGuideServerOne_AddNPC.CreateAddNPC
--local PlayNPCAtk = NewGuideServerOne_AddNPC.PlayAtk
local DeleteGuide = NewGuideLayer.DeleteGuide
--local UpdateNewGuideProcess = NewGuideManager.UpdateNewGuideProcess
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteNewGuideTouchGroup = NewGuideLayer.DeleteNewGuideTouchGroup
local pManager =nil

local function _Close_LvUp_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		HeroUpGradeLayer.CloseUpGradeLayer()
		local pGuideAnimation = GetGuideIcon()
		if pGuideAnimation~=nil then
			DeleteGuide()
		end
		--DeleteNewGuideTouchGroup()
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_2)
	end
end
local function UpOver()
	local pGuideAnimation = GetGuideIcon()
	if pGuideAnimation==nil then
		AddGuideIcon(ccp(825,576))
		pGuideAnimation = GetGuideIcon()
	end
	if pGuideAnimation~=nil then
		pGuideAnimation:setTouchEnabled(true)
		pGuideAnimation:addTouchEventListener(_Close_LvUp_CallBack)
	end
end
local function ToLevelUP()
	--去调用升级的特效
	--Pause()
	HeroUpGradeLayer.CreateLayer(UpOver)
	
end
local function ShowNPC()
	--添加孙尚香
	
	CreateAddNPC(ToLevelUP)
end


local function ToNPCTalk()
	HeroTalkLayer.createHeroTalkUI(3022)
	
	local function FinishTalk()
		--播放孙尚香的攻击动画
		ShowNPC()
		--[[print("FinishTalk")
		Pause()]]--
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(0))
		NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_1)
		--[[DeleteGuide()
		DeleteNewGuideTouchGroup()]]--
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
end

local function ToGuanZhan()
	local function EndGuanZhan()
		--ShowNPC()
		--关闭小手
		DeleteGuide()
		ToNPCTalk()
	end
	NewGuideServerOne_GuanZhan.CreateGuideGuanZhan(EndGuanZhan,pManager)
end
local function _Guide_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		local pIconAnimation = NewGuideLayer.GetGuideIcon()
		if pIconAnimation~=nil then
			DeleteGuide()
		end
		ToGuanZhan()
	end
end
local function GotoTalk()
	HeroTalkLayer.createHeroTalkUI(3000)
	
	local function FinishTalk()
		--点击一个城市
		local nCountry = tonumber(server_mainDB.getMainData("nCountry"))
		local posX,posY =0,0
		if nCountry == 1 then
			posX,posY = 681,70--pManager:Fun_GetWorldPosByCityID(58)
		elseif nCountry == 2 then
			posX,posY = 745,213--pManager:Fun_GetWorldPosByCityID(105)
		else
			posX,posY = 937,226--pManager:Fun_GetWorldPosByCityID(228)
		end
		local pIconAnimation = NewGuideLayer.GetGuideIcon()
		if pIconAnimation == nil then
			AddGuideIcon(ccp(posX-60,posY-15))
			pIconAnimation = NewGuideLayer.GetGuideIcon()
		end
		if pIconAnimation~=nil then
			pIconAnimation:setVisible(true)
			pIconAnimation:setPosition(ccp(posX-60,posY-15))
			pIconAnimation:setTouchEnabled(true)
			pIconAnimation:addTouchEventListener(_Guide_CallBack)
		
		end
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
end
local function GoToWar()
	--完成以后执行第三个步骤
	--MainScene.OpenCountryWarMap(MainScene.GetPScene())
	pManager = CountryWarGuideManager.Create()
	
	local function WarEnd(  )
		print("camera move end")
		--pManager:Fun_ShowUI()
		GotoTalk()
	end

	pManager:Fun_HideUI()
	pManager:Fun_CameraMoveByMainCity(WarEnd)
	
end
local function DeleteBtn()
	local pGuideLayer = GetNewGuideLayer()
	if pGuideLayer~=nil then
		if pGuideLayer:getChildByTag(6000)~=nil then
			pGuideLayer:getChildByTag(6000):removeFromParentAndCleanup(true)
		end
	end
end
local function _Btn_Skip_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--[[local pGuideIcon = NewGuideLayer.GetGuideIcon()
		if pGuideIcon~=nil then
			pGuideIcon:setVisible(false)
			DeleteGuide()
		end]]--
		DeleteBtn()
		cg_piantou.DelelteCg()
		--执行第二步骤去国战
		--[[local function _Load_End()
			GoToWar()
		end
		LoadingNewLayer.SetFCallBack(_Load_End)
		LoadingNewLayer.ShowLoading(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_GUOZHAN,"",false)]]--
		GoToWar()
	end
end
local function _See_Over()
	--[[local pGuideIcon = NewGuideLayer.GetGuideIcon()
	if pGuideIcon~=nil then
		pGuideIcon:setVisible(false)
		DeleteGuide()
	end]]--
	DeleteBtn()
	--执行第二步骤去国战
	GoToWar()
end
local function PlayAnimation()
	require "Script/cg/cg_piantou"
	cg_piantou.playCg()
	cg_piantou.SetFCallBack(_See_Over)
	local pGuide = GetNewGuideTouchGroup()
	if pGuide == nil then
		CreateGuideLayer()
		
	end
--[[	local pGuideIcon = NewGuideLayer.GetGuideIcon()
	if pGuideIcon==nil then
		pGuideIcon = AddGuideIcon(ccp(1025+CommonData.g_Origin.x,590+CommonData.g_Origin.y))
		pGuideIcon = NewGuideLayer.GetGuideIcon()
		pGuideIcon:setTouchEnabled(true)
		pGuideIcon:addTouchEventListener(_Btn_Skip_CallBack)
	end]]--
	local pGuideLayer = GetNewGuideLayer()
	local btn_skip = Button:create()
	btn_skip:loadTextures("Image/imgres/button/btn_skip.png","Image/imgres/button/btn_skip.png","")
	btn_skip:setTouchEnabled(true)
	btn_skip:addTouchEventListener(_Btn_Skip_CallBack)
	btn_skip:setPosition(ccp(1025+CommonData.g_Origin.x,590+CommonData.g_Origin.y))
	btn_skip:setVisible(true)
	pGuideLayer:addChild(btn_skip,6000,6000)
end

function CreateServerOne()
	--第一小步骤
	PlayAnimation()

end