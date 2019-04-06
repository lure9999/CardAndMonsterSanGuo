

--新手引导的服务器步骤第八大步骤之打开日志 celina
module("NewGuideServerEight_OpenFlog", package.seeall)



local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide
local AddGuideIcon = NewGuideLayer.AddGuideIcon

local m_flog_CallBack1 = nil 
local m_flog_CallBack2 = nil 
local m_flog_animation = nil 
local m_flog_type  = 0
local m_missstion_tag = 0

local function ToNine()
	if m_flog_type==1 or  m_flog_type==3 then
		if m_flog_CallBack1~=nil then
			m_flog_CallBack1()
			m_flog_CallBack1 = nil 
			return 
		end
	end
	if m_flog_type==2 then
		if m_flog_CallBack2~=nil then
			m_flog_CallBack2()
			m_flog_CallBack2 = nil 
			return 
		end
	end
end
local function _Click_OK_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		
		if m_flog_type == 1 then	
			MissionNormalLayer.GetMissionByNewGuilde(1,3,ToNine,m_missstion_tag)
			return 
		end
		if m_flog_type == 2 then
			MissionNormalLayer.GetMissionByNewGuilde(1,4,ToNine,m_missstion_tag)
			return 
		end
		if m_flog_type == 3 then
			MissionNormalLayer.GetMissionByNewGuilde(1,19,ToNine,m_missstion_tag)
			return 
		end
	end
end
local function LingQuOK()
	--[[if m_flog_type ==1 then
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(7))
	end
	if m_flog_type ==2 then
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(8))
	end
	if m_flog_type ==3 then
		network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(12))
	end]]--
	if m_flog_animation~=nil then
		m_flog_animation:setPosition(ccp(500,180))
		m_flog_animation:addTouchEventListener(_Click_OK_CallBack)
	end
end
local function _Click_LingQu_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--点击了领取
		if m_flog_type == 1 then
			MissionNormalLayer.GetMissionByNewGuilde(0,3,LingQuOK,m_missstion_tag)
			return
		end
		if m_flog_type == 2 then
			MissionNormalLayer.GetMissionByNewGuilde(0,4,LingQuOK,m_missstion_tag)
			return
		end
		if m_flog_type == 3 then
			MissionNormalLayer.GetMissionByNewGuilde(0,1,LingQuOK,m_missstion_tag)
			return
		end
	end
end
local function ShowGuideAnimation()
	m_flog_animation =  GetGuideIcon()
	if m_flog_animation== nil then
		if m_flog_type == 3 then
			AddGuideIcon(ccp(620,380))
		else
			AddGuideIcon(ccp(620,270))
		end
		m_flog_animation =  GetGuideIcon()
	end
	if m_flog_animation~=nil then
		if m_flog_type == 3 then
			m_flog_animation:setPosition(ccp(620,380))
		else
			m_flog_animation:setPosition(ccp(620,270))
		end
		m_flog_animation:setTouchEnabled(true)
		m_flog_animation:addTouchEventListener(_Click_LingQu_CallBack)
	end

end
--0表示主线 1表示日常
function ShowFlog(fCallBack,nType,nTag)
	print("ShowFlog:"..nType)
	if nType == 2 then
		m_flog_CallBack2 = fCallBack
	else
		m_flog_CallBack1 = fCallBack
	end
	if nType == 3 then
		m_missstion_tag =0
	else
		m_missstion_tag =1
	end
	
	m_flog_type = nType
	--测试
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerMissionNormal_tag)
	require "Script/Main/MissionNormal/MissionNormalLayer"
	if tempCur == nil  then
		local function openMissionLayer()
			NetWorkLoadingLayer.loadingHideNow()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			MainScene.DeleteUILayer(MissionNormalLayer.GetUIControl())
			local mission = nil
			if m_flog_type == 3 then
				mission =  MissionNormalLayer.CreateMissionNormalLayer(0)
			else
				mission =  MissionNormalLayer.CreateMissionNormalLayer(1)	
			end
			scenetemp:addChild(mission,layerMissionNormal_tag,layerMissionNormal_tag)

			MainScene.PushUILayer(mission)
			ShowGuideAnimation()
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_GetNormalMissionData.SetSuccessCallBack(openMissionLayer)
		if m_flog_type == 3 then
			
			network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(0)) --0=主线任务。1=日常任务
		else
			
			network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(1))
		end
	else
		ShowGuideAnimation()
	end
end