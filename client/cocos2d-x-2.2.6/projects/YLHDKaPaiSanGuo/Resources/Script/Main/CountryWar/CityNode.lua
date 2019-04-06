require "Script/Main/CountryWar/CountryWarCityManager"
require "Script/Main/CountryWar/CountryWarRaderLayer"
require "Script/Main/CountryWar/CountryWarData"

local SetPtState						=	CountryWarRaderLayer.SetPtState

local GetCityState						=	CountryWarData.GetCityState
local GetCityCountry					=	CountryWarData.GetCityCountry
local GetExpeDitionResImgID 			=	CountryWarData.GetExpeDitionResImgID
local GetExpeDitionRewardImgID 			=	CountryWarData.GetExpeDitionRewardImgID
local GetExpeDitionCountryID 			=	CountryWarData.GetExpeDitionCountryID
local GetPathByImageID					=	CountryWarData.GetPathByImageID
local GetDataByGrid						=	CountryWarData.GetDataByGrid
local GetExpeDitionRaderImgID			=	CountryWarData.GetExpeDitionRaderImgID
local SetCityLockByState2				=	CountryWarData.SetCityLockByState2
local SetCityManZuByState2				=	CountryWarData.SetCityManZuByState2
local SetCityCenterByState2				=	CountryWarData.SetCityCenterByState2

module("CityNode", package.seeall)

local function UpdateNode( self )
	self.isShow = self.rect:containsPoint(CCPoint(self.NodeX,self.NodeY))
	if self.isShow == true then		--在显示区域
		--激战显示
		if self.State == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN then
			if self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN) ~= nil then
				if self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN):isVisible() == false then
					self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN):setVisible(true)
				end
			else
				print("nil nil ")
				Pause()
			end
		elseif self.State == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
			if self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN):isVisible() == true then
				--print("隐藏")
				self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN):setVisible(false)
			end
		end
	elseif self.isShow == false then	--不在显示区域
		--交战隐藏
		if self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN) ~= nil then
			self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN):setVisible(self.isShow)
		end
	end
end

local function GetState( self )
	return self.State
end

local function GetNode( self )
	return self.Node
end

local function HideAllAni( self )
	self.pCityObj:HideAllAnimate()
end

local function AddOtherCityState( self, nCityState, nState )
	-- 添加其他城市状态
	if nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK then
		--可攻击状态
		self.pCityObj:SetOtherState(COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK, nState, self.Tag)
	end
end

local function GetOtherCityState( self, nCityState )
	if nCityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK then
		--可攻击状态
		return self.pCityObj:GetOtherState(COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK)
	end
end

--激战，和平
local function CreateAniObj( self, nCityState, nCtag )


	self.pCityObj = CountryWarCityManager.CreateCityObject()

	pCityObjTab = {
		CityTag  	    = nCtag,
		CityState 	 	= nCityState,
		CallFunc 		= _Click_City_CallFunc,
		CityName    	= nName,
		CityCountry 	= nCamp,
		CityPt 			= ccp(self.Node:getPositionX(),self.Node:getPositionY()),
		CityBase 		= nAreaNum,
	}

	if pCityObjTab.CityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN then
		self.State = COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN
	elseif pCityObjTab.CityState == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then 
		self.State = COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE
	end

	self.pCityObj:Create(pCityObjTab, self.Node)

	self.pCityObj:GetAnimate(100 + COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN):setPosition(ccp(0,0))
	self.CityObjTab = pCityObjTab.CityStateTab
end

local function CreateEventUI( self, nIndex, nCityID, nGrid )
	local nResId 		= GetExpeDitionResImgID(nIndex)
	local nShowPath		= GetPathByImageID(nResId)
	if self.Node:getChildByTag(2222) == nil then
		--未存在直接创建
		--print("城市"..nCityID.."创建远征军"..nGrid)
		self.pEventUIObj = ImageView:create()
		self.pEventUIObj:loadTexture(nShowPath)
		self.pEventUIObj:setPosition(ccp(5,110))
		self.Node:addChild(self.pEventUIObj,99,2222)
	else
		--已存在直接更新显示
		--print("城市"..self.Tag.."更新事件状态"..nGrid)
		self.pEventUIObj:loadTexture(nShowPath)
	end
	--创建雷达显示
	local nRaderResID = GetExpeDitionRaderImgID(nIndex)
	CountryWarRaderLayer.SetPtEvent(true, Country_EventType.AnExpeDition, nCityID, nRaderResID, nGrid)
end

--nEventType:事件类型（远征军，流寇，等等..），表现形式统一
--nEventData:事件数据
local function InsertEventTab( self, nEventData )
	local nCurIndex = table.getn(self.EventTab)
	self.EventTab[nCurIndex+1] = tonumber(nEventData["Grid"])
	CreateEventUI(self, nEventData["Index"], nEventData["CityID"], nEventData["Grid"])
end

local function UpdateUI( self, nEventData )
	CreateEventUI(self, nEventData["Index"], nEventData["CityID"], nEventData["Grid"])
	--print("城市"..self.Tag.."显示最上层的事件ID = "..nEventData["Index"])
end

local function DelEventUI( self, nDelGrid )
	--删除某组数据啊 依然取表里最上层进行显示
	local nMaxNum = table.getn(self.EventTab)
	--nDelGrid 刚刚删除的那个事件显示，用于雷达的删除
	CountryWarRaderLayer.SetPtEvent(false, Country_EventType.AnExpeDition, self.Tag, nil, nDelGrid)
	if nMaxNum > 0 then
		--printTab(self.EventTab)
		local nGrid   = self.EventTab[nMaxNum]  			--用于国战的最上层显示
		local nData  = GetDataByGrid(nGrid)
		if nData ~= nil then
			UpdateUI(self, nData)
		end
	else
		--print("城市"..self.Tag.."已经没有事件了，直接删除")
		self.pEventUIObj:removeFromParentAndCleanup(true)
	end
end

--事件类型表中删除某个事件
local function DelEventByEventTab( self, nGrid )
	local nDelIndex = nil
	--print("Del nGrid = "..nGrid)
	local nDelGrid = nGrid
	if table.getn(self.EventTab) > 0 then
		for i=1,table.getn(self.EventTab) do
			--print("self.EventTab[i] = "..self.EventTab[i])
			if self.EventTab[i] == nGrid then
				nDelIndex = i
				--print("城市"..self.Tag.."的事件表"..i.."号事件删除，其动态ID为"..nGrid)
				break
			end
		end
		if nDelIndex ~= nil then
			table.remove(self.EventTab, nDelIndex)
			DelEventUI(self, nDelGrid)
		else
			print("删除索引为空")
		end
	else
		print("城市事件表为空,del failed")
	end
end

local function RefreshAction( self )
	local function UpdateCityNode( )
		UpdateNode(self)
		--[[if table.getn(self.EventTab) > 0 then
			print("城市 "..self.Tag)
			printTab(self.EventTab)
		end]]
		--self.State = GetCityState(self.Tag)
		if self.State == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN then
			SetPtState(1, self.Tag, true)
		elseif self.State == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
			SetPtState(0, self.Tag, false)
		end
	end

	self.actionArrayRefresh = CCArray:create()
	self.actionArrayRefresh:addObject(CCCallFunc:create(UpdateCityNode))
	self.actionArrayRefresh:addObject(CCDelayTime:create(0.5))
	self.Node:runAction(CCRepeatForever:create(CCSequence:create(self.actionArrayRefresh)))
end

local function SetCityState( self, nState )
	self.State = nState
end

local function Resume( self )
	self.State = COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_BURN
end

local function Destory( self )
	self.State = COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE
end

local function SetCitytHeart( self, nState )
	--停止/开启城市自身心跳检测
	if nState == false then
		self.Node:stopAllActions()
	else
		RefreshAction(self)
	end
end

local function GetLockState( self )
	return self.isLock
end

local function SetLockState( self, nState )
	self.isLock = nState
end

local function GetWaitUnlock( self )
	return self.WaitLock
end

local function SetWaitUnlock( self, nState )
	self.WaitLock = nState
end

local function GetIsCenterMisty( self )
	return self.isMistyCenter
end

local function SetIsCenterMisty( self, nState )
	self.isMistyCenter = nState
end

local function GetMistyIndex( self )
	return self.MistyIndex
end

local function SetMistyIndex( self, nIndex )
	self.MistyIndex = nIndex
end

local function GetMistyFightingState( self )
	return self.isMistyFighting
end

local function SetMistyFightingState( self, nState )
	self.isMistyFighting = nState
end

local function GetIsCenter( self )
	return self.isCenter
end

local function SetIsCenter( self, nState )
	self.isCenter = nState
	local pState = 1 
	if nState == true then
		pState = 1
	else
		pState = 0
	end
	SetCityCenterByState2(self.Tag, pState)
end

local function GetIsLockByState2( self )
	return self.isLockByState2
end

local function SetIsLockByState2( self, nState )
	self.isLockByState2 = nState
	local pState = 1 
	if nState == true then
		pState = 1
	else
		pState = 0
	end
	SetCityLockByState2(self.Tag, pState)
end

local function SetManzuEvent( self, nState )
	if tonumber( nState ) == 1 then
		self.isManZu = true
	else
		self.isManZu = false
	end

	SetCityManZuByState2( self.Tag, nState )
end

local function GetManzuEvent( self )
	return self.isManZu
end

local function GetCityTag( self )
	return self.Tag
end

local function GetCityImgCountry( self )
	return self.ImgCountry
end

local function SetCityImgCountry( self, nImgCountry )
	self.ImgCountry = nImgCountry
end

local function CreateCityNode(self, nBase, nTag, rect, nCityState, nCountry)
	self.Tag  = nTag

	self.Base = nBase

	self.Node = self.Base:getChildByTag(self.Tag)

	self.isLock = false  			--每个城池是否锁住

	self.isMistyCenter = false  	--是否是迷雾中心城市

	self.WaitLock = false 			--是否等待解锁状态

	self.MistyIndex = -1 			--迷雾索引

	self.isMistyFighting = false 	--是否正在迷雾战

	self.isCenter = false 			--是否为中心城市

	self.isManZu  = false 			--是否为蛮族城市

	self.isLockByState2 = true 	--是否在二级状态中锁住

	self.ImgCountry = nCountry 		--当前城市的国家img资源

	self.NodeX = self.Node:getPositionX()

	self.NodeY = self.Node:getPositionY()

	self.rect = rect

	self.EventTab = {} 				--每个城池的事件管理表

	self.CityObjTab = {}

	if nCityState == nil then

		nCityState = COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE

		self.State = COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE

	end

	CreateAniObj(self, nCityState, self.Tag)

	RefreshAction(self)

	if self.Node == nil then
		return false
	end
end

function Create(  )
	local tab = {
		CreateCityNode 			= CreateCityNode,
		SetCitytHeart  			= SetCitytHeart,
		HideAllAni 	   			= HideAllAni,
		SetCityState   			= SetCityState,
		GetNode 	   			= GetNode,
		GetState 	   			= GetState,
		Destory		   			= Destory,
		Resume 		   			= Resume,
		AddOtherCityState 		= AddOtherCityState,
		GetOtherCityState 		= GetOtherCityState,
		InsertEventTab 			= InsertEventTab,
		DelEventByEventTab 		= DelEventByEventTab,
		SetLockState 			= SetLockState,
		GetLockState 			= GetLockState,
		SetIsCenterMisty 		= SetIsCenterMisty,
		GetIsCenterMisty 		= GetIsCenterMisty,
		SetMistyIndex 			= SetMistyIndex,
		GetMistyIndex 			= GetMistyIndex,
		SetWaitUnlock 			= SetWaitUnlock,
		GetWaitUnlock 			= GetWaitUnlock,
		GetMistyFightingState   = GetMistyFightingState,
		SetMistyFightingState   = SetMistyFightingState,
		GetIsCenter 			= GetIsCenter,
		SetIsCenter 			= SetIsCenter,
		GetIsLockByState2       = GetIsLockByState2,
		SetIsLockByState2       = SetIsLockByState2,
		SetManzuEvent			= SetManzuEvent,
		GetManzuEvent			= GetManzuEvent,
		GetCityTag				= GetCityTag,
		SetCityImgCountry		= SetCityImgCountry,
		GetCityImgCountry		= GetCityImgCountry,
	}

	return tab
end

