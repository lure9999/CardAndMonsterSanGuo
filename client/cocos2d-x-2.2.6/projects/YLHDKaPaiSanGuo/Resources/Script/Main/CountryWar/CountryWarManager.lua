require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/ClickCityLogic"

local GetCityState						=	CountryWarData.GetCityState
local GetMistyDB 						=	CountryWarData.GetMistyDB
local GetMistyCityID					=	CountryWarData.GetMistyCityID
local GetMistyAffectCityID				=	CountryWarData.GetMistyAffectCityID
local GetMistyRewardResID				=	CountryWarData.GetMistyRewardResID
local GetPathByImageID					=	CountryWarData.GetPathByImageID
local GetGeneralHeadPath				=	CountryWarData.GetGeneralHeadPath
local GetTeamTab 						=	CountryWarData.GetTeamTab
local GetCityLockByState2 				=	CountryWarData.GetCityLockByState2
local GetCityCenterByState2 			=	CountryWarData.GetCityCenterByState2
local SetCityLockByState2				=	CountryWarData.SetCityLockByState2
local GetCityConfusByState2 			=	CountryWarData.GetCityConfusByState2
local GetAroundLinkCity 				=	CountryWarData.GetAroundLinkCity

local GetPointAngle 					= 	BaseSceneLogic.GetPointAngle

--请求观战页面
local ToFogGuanZhan						=	ClickCityLogic.ToFogGuanZhan

module("CountryWarManager", package.seeall)

------------------------------------------------锁城事件逻辑Begin-------------------------------------------------------

local function DelLineAni( self, nCityID )
	if self.m_LockRenderData.m_LockLineAni[nCityID] ~= nil then 
		print("删除连线"..nCityID)
		self.m_LockRenderData.m_LockLineAni[nCityID]:removeFromParentAndCleanup(true)
		self.m_LockRenderData.m_LockLineAni[nCityID] = nil
	end
	if self.m_LockRenderData.m_LockClickAni[nCityID] ~= nil then 
		print("删除点击"..nCityID)
		self.m_LockRenderData.m_LockClickAni[nCityID]:removeFromParentAndCleanup(true)
		self.m_LockRenderData.m_LockClickAni[nCityID] = nil
	end
end

local function DelLockAni( self, nCityID )
	if self.m_LockRenderData.m_LockAni ~= nil and nCityID == self.m_LockData.m_LockCenter then
		print("删除能量罩"..nCityID)
		self.m_LockRenderData.m_LockAni:removeFromParentAndCleanup(true)
		self.m_LockRenderData.m_LockAni = nil
	end
end

local function FindCenterDrawLockLine( self, pCurCityID, pCenterCityID )
	-- 锁定的城市向中心城市画连线

	for key,value in pairs(self.m_Data.m_CityNodeData) do
		if value:GetCityTag() == pCenterCityID then
			self.m_LockData.m_LockCenter = key
		end
	end

	local nCenterPtX = self.m_RenderData.m_ClickPanel:getChildByTag(self.m_LockData.m_LockCenter):getPositionX()
	local nCenterPtY = self.m_RenderData.m_ClickPanel:getChildByTag(self.m_LockData.m_LockCenter):getPositionY()

	for key,value in pairs(GetAroundLinkCity(self.m_LockData.m_LockCenter)) do
		if value == pCurCityID then
			if self.m_LockRenderData.m_LockClickAni[value] == nil then
				local nLinePtX = self.m_RenderData.m_ClickPanel:getChildByTag(value):getPositionX()
				local nLinePtY = self.m_RenderData.m_ClickPanel:getChildByTag(value):getPositionY()
				self.m_LockRenderData.m_LockClickAni[value] = CCArmature:create("Scene_guozhan_suoding")
				self.m_LockRenderData.m_LockClickAni[value]:getAnimation():play("Animation2")
				self.m_LockRenderData.m_LockClickAni[value]:setPosition(ccp(nLinePtX,nLinePtY+20))
				self.m_RenderData.m_ClickPanel:addChild(self.m_LockRenderData.m_LockClickAni[value],999)
				--创建中间链接
				local nMidX = (nLinePtX + nCenterPtX) / 2
				local nMidY = (nLinePtY + nCenterPtY) / 2
				self.m_LockRenderData.m_LockLineAni[value] = CCArmature:create("Scene_guozhan_suoding")
				self.m_LockRenderData.m_LockLineAni[value]:getAnimation():play("Animation3")
				self.m_LockRenderData.m_LockLineAni[value]:setPosition(ccp(nMidX,nMidY))
				self.m_RenderData.m_ClickPanel:addChild(self.m_LockRenderData.m_LockLineAni[value],999)
				--设置朝向角度
				local nAngle = GetPointAngle(ccp(nLinePtX, nLinePtY), ccp(nCenterPtX, nCenterPtY))
				self.m_LockRenderData.m_LockLineAni[value]:setRotation(nAngle)
			end 
		end
	end
end

local function CreateLockUI( self )
	local nCityPtX = self.m_RenderData.m_ClickPanel:getChildByTag(self.m_LockData.m_LockCenter):getPositionX()
	local nCityPtY = self.m_RenderData.m_ClickPanel:getChildByTag(self.m_LockData.m_LockCenter):getPositionY()
	--print(self.m_LockRenderData.m_LockAni)
	--print(nCityPtX, nCityPtY)
	--Pause()
	--创建能量罩动画
	--print(self.m_LockRenderData.m_LockAni)
	--Pause()
	if self.m_LockRenderData.m_LockAni == nil then
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_suoding/Scene_guozhan_suoding.ExportJson")
		self.m_LockRenderData.m_LockAni = CCArmature:create("Scene_guozhan_suoding")
		self.m_LockRenderData.m_LockAni:getAnimation():play("Animation1")
		self.m_LockRenderData.m_LockAni:setPosition(ccp(nCityPtX,nCityPtY))
		self.m_RenderData.m_ClickPanel:addChild(self.m_LockRenderData.m_LockAni,999)
	end
	--取得周边城市,周边城市如果是锁定状态则创建点击动画
	for key,value in pairs(GetAroundLinkCity(self.m_LockData.m_LockCenter)) do
		local lockState = GetCityLockByState2(value)
		if self.m_LockRenderData.m_LockClickAni[value] == nil and tonumber(lockState) == 1 then
			local nLinePtX = self.m_RenderData.m_ClickPanel:getChildByTag(value):getPositionX()
			local nLinePtY = self.m_RenderData.m_ClickPanel:getChildByTag(value):getPositionY()
			self.m_LockRenderData.m_LockClickAni[value] = CCArmature:create("Scene_guozhan_suoding")
			self.m_LockRenderData.m_LockClickAni[value]:getAnimation():play("Animation2")
			self.m_LockRenderData.m_LockClickAni[value]:setPosition(ccp(nLinePtX,nLinePtY+20))
			self.m_RenderData.m_ClickPanel:addChild(self.m_LockRenderData.m_LockClickAni[value],999)
			--创建中间链接
			local nMidX = (nLinePtX + nCityPtX) / 2
			local nMidY = (nLinePtY + nCityPtY) / 2
			self.m_LockRenderData.m_LockLineAni[value] = CCArmature:create("Scene_guozhan_suoding")
			self.m_LockRenderData.m_LockLineAni[value]:getAnimation():play("Animation3")
			self.m_LockRenderData.m_LockLineAni[value]:setPosition(ccp(nMidX,nMidY))
			self.m_RenderData.m_ClickPanel:addChild(self.m_LockRenderData.m_LockLineAni[value],999)
			--设置朝向角度
			local nAngle = GetPointAngle(ccp(nLinePtX, nLinePtY), ccp(nCityPtX, nCityPtY))
			self.m_LockRenderData.m_LockLineAni[value]:setRotation(nAngle)
		end
	end

end

local function EventLockCity( self )
	-- 取得中心城市
	for key,value in pairs(self.m_Data.m_CityNodeData) do
		if value:GetIsCenter() == true then
			self.m_LockData.m_LockCenter = key
			CreateLockUI(self)	-- 创建UI
			break 				--以后如果有多个中心城市再取消
		end
	end
end

local function SetCMDByLockCity( self, nClickLayer, nNodeObj )
	if nClickLayer ~= nil then
		self.m_RenderData.m_ClickPanel = nClickLayer
	end

	if nNodeObj ~= nil then
		self.m_Data.m_CityNodeData = nNodeObj
	end

end

local function InitCWarEvent( self, nType )
	if nType ~= nil then 
		self.EventType = nType
	end

	if self.EventType == CWAR_EVENTTYPE.LOCKCITY then
		EventLockCity(self)
	end
end

------------------------------------------------锁城事件逻辑End-------------------------------------------------------

function Create(  )
	local tab = {
		Fun_InitCWarEvent 						= InitCWarEvent,
		Fun_SetCMDByLockCity 					= SetCMDByLockCity,
		Fun_DelLineAni 							= DelLineAni,
		Fun_DelLockAni 							= DelLockAni,
		Fun_FindCenterDrawLockLine				= FindCenterDrawLockLine,
		m_RenderData = {	
							m_ClickPanel 		= nil,
					   },
		m_Data 		 = {
							m_CityNodeData 		= nil,

					   },
		m_LockData 		 = {  					--锁城事件的相关数据
							m_LockCenter 		= nil,

					   },
		m_LockRenderData = {  					--锁城事件的相关引擎数据
							m_LockAni 			= nil,
							m_LockLineAni       = {},
							m_LockClickAni      = {},
					   },									 
	}

	return tab
end

