require "Script/Main/CountryWar/CountryWarRaderLayer"


module("CountryWarCityManager", package.seeall)

local GetCityBurnAniByCityID	=	CountryWarData.GetCityBurnAniByCityID
local GetIndexByCTag 			=	CountryWarLogic.GetIndexByCTag

--可攻击
local function PlayAnimateByAttack( self , nState )
	if self.AttackArm ~= nil then 
		self.AttackArm:getAnimation():play("Animation3")
		self.AttackArm:setScale(0.7)
		self.AttackArm:setVisible(nState)
	else
		--动画为空 创建
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
		self.AttackArm = CCArmature:create("Scene_guozhan_leida01")
		self.AttackArm:getAnimation():play("Animation3")
		self.AttackArm:setScale(0.7)
		self.AttackArm:setPosition(ccp(0,0))
		self.AttackArm:setVisible(nState)
		self.Base:addChild(self.AttackArm,2,100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK)
	end
end
--定位
local function PlayAnimateByLocation( self )
	if self.LocationArm ~= nil then 
		self.LocationArm:setVisible(nState)
		self.LocationArm:getAnimation():play("Animation4")
	end
end
--围攻
local function PlayAnimateBySiege( self )
	if self.SiegeArm ~= nil then 
		self.SiegeArm:setVisible(nState)
		self.SiegeArm:getAnimation():play("Animation5")
	else
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
		self.SiegeArm = CCArmature:create("Scene_guozhan_leida01")
		self.SiegeArm:setVisible(nState)
		self.SiegeArm:getAnimation():play("Animation5")
		self.Base:addChild(self.SiegeArm,1,100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_SIEGE)
	end
end
--激战燃城
local function PlayAnimateByBurn( self, nState )
	if self.BurnArm ~= nil then 
		self.BurnArm:setVisible(nState)
		--根据资源配置取得当前播放的哪种火焰动画
		local pCityIndex = GetIndexByCTag(self.CityTag)
		local pAniIndex  = GetCityBurnAniByCityID(pCityIndex)
		self.BurnArm:getAnimation():play("Animation"..pAniIndex)
	else
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
		self.BurnArm = CCArmature:create("Scene_guozhan_leida01")
		local pCityIndex = GetIndexByCTag(self.CityTag)
		local pAniIndex  = GetCityBurnAniByCityID(pCityIndex)
		self.BurnArm:getAnimation():play("Animation"..pAniIndex)
		self.BurnArm:setVisible(nState)
		self.Base:addChild(self.BurnArm,1,100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN)
	end
end

local function HideAllAnimate( self )
	if self.BurnArm ~= nil then 
		self.BurnArm:setVisible(false)
	end
end

local function SetCurState( self )
	HideAllAnimate(self)
	if self.CityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN then
		PlayAnimateByBurn(self, true)
	elseif self.CityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
		PlayAnimateByBurn(self, false)
	end
end

local function Destroy( self )		
	--self.Entity:removeFromParentAndCleanup(true)
	self = nil	
end

local function GetAnimate( self, nStateNum )
	if self.Base ~= nil then
		return self.Base:getChildByTag(nStateNum)	
	end
end

local function SetOtherState( self, nCityState, nState, nCtag )
	if nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK then
		PlayAnimateByAttack(self, nState)   --更改国战状态
		CountryWarRaderLayer.SetPtEvent(nState, Country_EventType.BeAttack, nCtag)	--更改雷达显示
	elseif nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_SIEGE then
		PlayAnimateBySiege(self, nState)
	elseif nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_LOCATION then
		PlayAnimateByLocation(self, nState)
	end
end

local function GetOtherState( self, nCityState )
	if nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK then
		if self.AttackArm ~= nil then
			return self.AttackArm:isVisible()
		end
	elseif nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_SIEGE then
		if self.SiegeArm ~= nil then
			return self.SiegeArm:isVisible()
		end
	elseif nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_LOCATION then
		if self.LocationArm ~= nil then
			return self.LocationArm:isVisible()
		end
	end
	return nil
end

local function CreateStateAni(self)
	--[[CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
	激战动画
	self.BurnArm = CCArmature:create("Scene_guozhan_leida01")
	self.Base:addChild(self.BurnArm,1,100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN)
	可攻击动画
	self.AttackArm = CCArmature:create("Scene_guozhan_leida01")
	self.AttackArm:setPosition(ccp(0,0))
	self.AttackArm:setVisible(false)
	self.Base:addChild(self.AttackArm,2,100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK)
	围攻动画
	self.SiegeArm = CCArmature:create("Scene_guozhan_leida01")
	self.SiegeArm:setVisible(false)
	self.Base:addChild(self.SiegeArm,1,100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_SIEGE)
	定位动画
	self.LocationArm = CCArmature:create("Scene_guozhan_leida01")
	self.LocationArm:setPosition(ccp(self.CityPt.x,self.CityPt.y))
	self.LocationArm:setVisible(false)
	self.Base:addChild(self.LocationArm,1,100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_LOCATION)--]]

	SetCurState(self)


	return true
end

local function InitCity( self )
	if CreateStateAni(self) == true then
		--print("bibibi --- 动画创建成功")
		return true
	end

	return false
end

--nCityTab 参数table
--cityTag 城池ID
--cityState 城池状态
--CallFunc 城池点击回调
--CityName 城池名称
--CityCountry 城池所属国家
local function Create( self, nCityTab, pBase )
	self.CityTag   		= nCityTab.CityTag

	self.CityState      = nCityTab.CityState

	self.CallFunc  		= nCityTab.CallFunc

	self.Base 			= pBase

	self.CityPt 		= nCityTab.CityPt

	self.CityBase 		= nCityTab.CityBase 			--父区域

	if InitCity(self) == true then
		return true
	end

	return false
end

function CreateCityObject( )
	local CityObject = {
		Create 					= Create,
		GetAnimate 				= GetAnimate,
		PlayAnimateByAttack		= PlayAnimateByAttack,
		PlayAnimateByLocation   = PlayAnimateByLocation,
		PlayAnimateBySiege		= PlayAnimateBySiege,
		PlayAnimateByBurn 		= PlayAnimateByBurn,
		HideAllAnimate			= HideAllAnimate,
		SetOtherState 			= SetOtherState,
		GetOtherState			= GetOtherState,
		SetCurState				= SetCurState,
		Destroy 				= Destroy,
	}

	return CityObject
end

