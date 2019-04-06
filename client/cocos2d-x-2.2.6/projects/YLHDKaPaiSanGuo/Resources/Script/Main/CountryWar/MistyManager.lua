require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/ClickCityLogic"
require "Script/Main/CountryWar/CountryWarRaderLayer"

local GetCityState						=	CountryWarData.GetCityState
local GetMistyDB 						=	CountryWarData.GetMistyDB
local GetMistyCityID					=	CountryWarData.GetMistyCityID
local GetMistyAffectCityID				=	CountryWarData.GetMistyAffectCityID
local GetMistyRewardResID				=	CountryWarData.GetMistyRewardResID
local GetPathByImageID					=	CountryWarData.GetPathByImageID
local GetGeneralHeadPath				=	CountryWarData.GetGeneralHeadPath
local GetTeamTab 						=	CountryWarData.GetTeamTab
local UpdateMistyState					=	CountryWarData.UpdateMistyState
local GetCityNameByIndex				=	CountryWarData.GetCityNameByIndex
local GetTeamLife						=	CountryWarData.GetTeamLife
local GetTeamCell						=	CountryWarData.GetTeamCell
local GetPathByImageID					=	CountryWarData.GetPathByImageID

local GetIndexByCTag					=	CountryWarLogic.GetIndexByCTag

--请求观战页面
local ToFogGuanZhan						=	ClickCityLogic.ToFogGuanZhan

local SetMistyState 					=	CountryWarRaderLayer.SetMistyState

module("MistyManager", package.seeall)

local Misty_Type = {
	MistyLock 			= 1,   --迷雾锁定状态
	MistyFight 			= 2,   --迷雾城市正在战斗中
	MistyWaitUnlock 	= 3,   --迷雾已经可以解锁了，需要手动解锁的状态
	MistyUnlock 		= 4,   --迷雾已解锁
}

local Misty_Attack_Type = {
	Success 		    = 1,
	Over 				= 2,
	Mismatch 			= 3,
}

local function SetMistyLayer( self, nLayer, nState )
	-- 获得迷雾层
	if nLayer ~= nil then
		self.Misty 	=	nLayer
		self.Misty:setVisible(nState)
	end
end

local function SetCityLayer( self, nLayer )
	if nLayer ~= nil then
		self.CityLayer = nLayer
	end
end

local function SetTouchLayer( self, nLayer )
	if nLayer ~= nil then
		self.TouchLayer = nLayer
	end
end

local function SetObjData( self, nData )
	if nData ~= nil then
		self.CityNodeDB = nData
	end
end

local function SetCityAreaData( self, nData )
	if nData ~= nil then
		self.CityAreaDB = nData
	end
end

local function SetAreaData( self, nData )
	if nData ~= nil then
		self.AreaDB = nData
	end
end

local function SetUITab( self, nData )
	if nData ~= nil then
		self.UIHeroDB = nData
	end	
end
--主场景的回调数据
local function SetCallBackData( self, nData )
	if nData ~= nil then
		self.CallBackData = nData
	end
end
--队伍UI数据
local function SetTeamUIData(  self, nData )
	if nData ~= nil then
		self.TeamUIDB = nData
	end
end
--队伍对象数据
local function SetPlayerData( self, nData )
	if nData ~= nil then
		self.PlayerDB = nData
	end
end

local function CloneItemWidget( pTemp )
    local pItem = pTemp:clone()
    local peer = tolua.getpeer(pTemp)
    tolua.setpeer(pItem, peer)
    return pItem
end

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

local function numIsIntab( num, tab )
	for key,value in pairs(tab) do
		if num == value then
			return true
		end
	end

	return false
end

local function SortSelectTab( self )
	if self.SelectTab ~= nil then

		local _SortTab = {}

		_SortTab[1] = "Empty"
		_SortTab[2] = "Empty"
		_SortTab[3] = "Empty"
		_SortTab[4] = "Empty"

		local _SortIndex = 1

		for i=1,4 do
			
			if self.SelectTab[i] ~= "Empty" then

				_SortTab[_SortIndex] = self.SelectTab[i]

				_SortIndex = _SortIndex + 1

			end

		end

		self.SelectTab = _SortTab

	end
end

local function InsertSelectTab( self, nValue )
	if self.SelectTab ~= nil then
		SortSelectTab( self )
		for i=1,4 do
		
			if self.SelectTab[i] == "Empty" then

				self.SelectTab[i] = nValue
				break

			end

		end
	end
end

local function DelSelectTab( self, nValue )
	if self.SelectTab ~= nil then

		for key, value in pairs( self.SelectTab ) do

			if value == nValue then

				self.SelectTab[key] = "Empty"
				break
			end

		end
		SortSelectTab( self )
	end
end

local function _Button_Action_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitVars( self )
	self.MistyInfoLayer = nil
end

local function UICreate( self, nType, nMistyIndex, nMistyBlood, nCityID, nUIDB, idx)
	--1.创建UI
	local pRResID 		= GetMistyRewardResID(nMistyIndex)
	local nPath 		= GetPathByImageID(pRResID)

	local nCityNode 	= self.CityLayer:getChildByTag(nCityID)
	local nPtX 			= nCityNode:getPositionX()
	local nPtY 			= nCityNode:getPositionY()

	local nScale = 0.35
	if pRResID == 5 then
		nScale = 0.7
	end

	--local layout = Layout:create()
	--layout:setSize(CCSize(160,200))
	--奖励
	local spBg 			= CCSprite:createWithTexture(self.RBgBatchNode:getTexture())   --奖励背景
	local spReward 		= CCSprite:create(nPath)   								--奖励

	spReward:setPosition(ccp(nPtX - 47,nPtY + 91))
	spReward:setScale(nScale)
	spBg:setScale(0.75)
	spBg:setPosition(ccp(nPtX - 47,nPtY + 90))
	self.Misty:addChild(spReward,2)

	self.RBgBatchNode:addChild(spBg)

	--血量条
	local spBloodBg 	= CCSprite:createWithTexture(self.BBgBatchNode:getTexture())
	spBloodBg:setPosition(ccp(nPtX + 13,nPtY + 91))
	spBloodBg:setScale(0.5)	
	self.BBgBatchNode:addChild(spBloodBg)

	local proBlood 		= LoadingBar:create()
	proBlood:setName("Blood_LoadingBarBack")
	proBlood:loadTexture("Image/imgres/dungeon/bar_green.png")
	proBlood:setDirection(0)
	proBlood:setPercent(nMistyBlood)	
	proBlood:setPosition(ccp(nPtX + 13,nPtY + 91))
	proBlood:setScale(0.5)	
	self.Misty:addChild(proBlood,2)

	nUIDB["spBg"] 		= spBg
	nUIDB["spReward"] 	= spReward
	nUIDB["spBloodBg"] 	= spBloodBg
	nUIDB["proBlood"] 	= proBlood

	--设置城市的锁住状态为true
	local nCNode = self.CityNodeDB[nCityID]
	nCNode:SetLockState(true)
	nCNode:SetIsCenterMisty(true)
	nCNode:SetMistyIndex(idx) 				--每个城市node对应的迷雾索引
	
	if nType == Misty_Type.MistyLock then
		--可攻击标识
		local spAttack 	= CCSprite:createWithTexture(self.ABgBatchNode:getTexture())
		spAttack:setPosition(ccp(nPtX,nPtY + 30))
		self.ABgBatchNode:addChild(spAttack)

		nUIDB["spAttack"] 	= spAttack

	elseif Misty_Type.MistyWaitUnlock then
		--print("等待解锁"..nCityID)

		local spUnlock 	= CCSprite:create("Image/imgres/countrywar/unlockmisty.png")
		spUnlock:setPosition(ccp(nPtX,nPtY + 30))
		self.Misty:addChild(spUnlock,99999)

		nUIDB["spUnlock"] 	= spUnlock

		nCNode:SetWaitUnlock(true)

	end

	--取得其周围城市设置状态
	for i=1,10 do
		local nAffectCityID = GetMistyAffectCityID(nMistyIndex, i) 

		if nAffectCityID ~= 0 then
			local nANode = self.CityNodeDB[nAffectCityID]
			nANode:SetLockState(true)
			nANode:SetIsCenterMisty(false)
			nANode:SetMistyIndex(idx)
		else
			break
		end
	end	
end

local function DBAnaly( self )
	for i=1,table.getn(self.DB) do
		local pMistyIndex = self.DB[i]["MistyIndex"]
		local pMistyBlood = self.DB[i]["MonsterBlood"]
		local pMistyNum   = self.DB[i]["MonsterNums"]
		if pMistyIndex ~= -1 then
			local pCityID     = GetMistyCityID(pMistyIndex)
			self.UIDB[i] 	  = {} 
			local nSTate = nil
			if pMistyNum == 0 then
				nSTate = Misty_Type.MistyWaitUnlock
			else
				nSTate = Misty_Type.MistyLock
			end
			UICreate(self, nSTate, pMistyIndex, pMistyBlood, pCityID, self.UIDB[i], i)
		else
			--取出这个城市的迷雾隐藏掉
			local pMistyNode = self.Misty:getChildByTag(i)
			pMistyNode:setVisible(false)
			if self.UIDB[i] ~= nil then
				for key,value in pairs(self.UIDB[i]) do
					if value ~= nil then value:removeFromParentAndCleanup(true) end
				end
			end
			--同步雷达的迷雾
			SetMistyState(i, false)
		end
	end
end

local function GetMistyFightingIndex( self, nIndex )
	-- 传入42个死索引
	if self.DB[nIndex] ~= nil then
		return self.DB[nIndex]["MistyIndex"]
	end

	return nil
end

local function GetMistyFightingCity( self, nIndex )
	-- 传入42个死索引
	if self.DB[nIndex] ~= nil then
		local nMistyIndex = self.DB[nIndex]["MistyIndex"]
		return GetMistyCityID(nMistyIndex)
	end

	return nil
end

local function InitInfoMonsterUI( self, nIndex, nHeadID, nLevel, nName, nMaxHp, nCurHp )

    local Image_Monster = tolua.cast(self.MistyInfoLayer:getWidgetByName("Image_Monster"), "ImageView")
    --local Image_BloodBg = tolua.cast(self.MistyInfoLayer:getWidgetByName("Image_BloodBg"), "ImageView")

    --迷雾守军血量
    local ProgressBar_Blood = tolua.cast(Image_Monster:getChildByName("ProgressBar_Blood"), "LoadingBar")
    local pBloodPer = tonumber(nCurHp) / tonumber(nMaxHp)
    ProgressBar_Blood:setPercent(pBloodPer * 100)
    local Label_CurBlood 		= tolua.cast(Image_Monster:getChildByName("Label_CurBlood"), "Label")
    Label_CurBlood:setText(nCurHp.."/"..nMaxHp)
    --迷雾守军数量
    local Label_MonsterNum = tolua.cast(self.MistyInfoLayer:getWidgetByName("Label_MonsterNum"), "Label")
    Label_MonsterNum:setText("剩余队伍数量 : "..self.DB[nIndex]["MonsterNums"])
    --迷雾守军形象
    local nHeadPath = GetGeneralHeadPath(nHeadID)
    local Image_Head = tolua.cast(Image_Monster:getChildByName("Image_Head"), "ImageView")
    Image_Head:loadTexture(nHeadPath)
    --迷雾守军等级
    local Label_MonsterLevel = tolua.cast(Image_Monster:getChildByName("Label_Level"), "Label")
    Label_MonsterLevel:setText("Lv."..nLevel)
    --迷雾守军姓名
    local nNameLabel = CreateLabel( nName, 20, ccc3(233,180,114), CommonData.g_FONT1, ccp(0,-85) )
    nNameLabel:setAnchorPoint(ccp(0.5,0))
    Image_Monster:addChild(nNameLabel)
end

local function InitInfoHeroUI( self )

	local function _Click_ChooseTeam_CallBack( sender, eventType )
		local Image_SelectFrame = tolua.cast(self.MistyInfoLayer:getWidgetByName("Image_SelectFrame_"..sender:getTag() + 1), "ImageView")
		if eventType == TouchEventType.ended then
			sender:setScale(0.68)
			Image_SelectFrame:setScale(0.68)
			local nFreeTab = CountryWarScene.GetCurStateRole(PlayerState.E_PlayerState_Free, PlayerState.E_PlayerState_Move)
			if numIsIntab(sender:getTag() + 1, nFreeTab) == true then
				if Image_SelectFrame:isVisible() == false then
					Image_SelectFrame:setVisible(true)
					InsertSelectTab( self, sender:getTag() )
				else
					DelSelectTab( self, sender:getTag() )
					Image_SelectFrame:setVisible(false)
				end 
			else
				Image_SelectFrame:setVisible(false)
				if GetTeamLife(sender:getTag()) == true then

					TipLayer.createTimeLayer("已过期,无法出战",2)
					return 

				end

				if GetTeamCell(sender:getTag()) ~= -1 then
					TipLayer.createTimeLayer("牢狱中,无法出战",2)
					return 
				end

				TipLayer.createTimeLayer("队伍无法出战",2)
			end
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.58)
			Image_SelectFrame:setScale(0.58)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(0.68)
			Image_SelectFrame:setScale(0.68)
		end	
	end

	local _SelectIndex = 1

	for key,value in pairs(GetTeamTab()) do
		local Image_Teamer = tolua.cast(self.MistyInfoLayer:getWidgetByName("Image_Teamer"..key+1), "ImageView")
		local Image_SelectFrame = tolua.cast(self.MistyInfoLayer:getWidgetByName("Image_SelectFrame_"..key + 1), "ImageView")
		Image_Teamer:setVisible(true)
		local Image_Head     = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 
		local pSpriteHeadImg = tolua.cast(Image_Head:getVirtualRenderer(), "CCSprite")
		local Image_BloodBg     = tolua.cast(Image_Teamer:getChildByName("Image_BloodBg"), "ImageView")
		local Labe_Level     = tolua.cast(Image_Teamer:getChildByName("Label_Level"), "Label")
		local Prog_Blood 	 = tolua.cast(Image_BloodBg:getChildByName("ProgressBar_Blood"), "LoadingBar")
		Labe_Level:setText(string.format("Lv%d", value.TeamLevel))

		if tonumber(key) == 0 then
			local nHeadPath = GetPathByImageID(tonumber(value.TeamFace))
			Image_Head:loadTexture(nHeadPath)
		else
			local nTempId = value.TeamRes
			local nHeadPath = GetGeneralHeadPath(nTempId)
			Image_Head:loadTexture(nHeadPath)
		end

		if GetTeamLife(key) == false and GetTeamCell(key) == -1 then 		--未过期的佣兵和不在牢狱中的佣兵在可以默认选上
			local nFreeTab = CountryWarScene.GetCurStateRole(PlayerState.E_PlayerState_Free, PlayerState.E_PlayerState_Move)
			if numIsIntab(key + 1, nFreeTab) == true then
				Image_SelectFrame:setVisible(true)
				self.SelectTab[_SelectIndex] = key
				_SelectIndex = _SelectIndex + 1
			end
		end

		Image_Teamer:setTouchEnabled(true)
		Image_Teamer:setTag(key)
		Image_Teamer:addTouchEventListener(_Click_ChooseTeam_CallBack)
		local pBloodNum = tonumber(value.TeamBloodCur) / tonumber(value.TeamBloodMax) * 100
		Prog_Blood:setPercent(pBloodNum)
		--队伍姓名
	    --[[local nNameLabel = CreateLabel( value.TeamName, 20, ccc3(233,180,114), CommonData.g_FONT1, ccp(-5,-85) )
	    nNameLabel:setAnchorPoint(ccp(0.5,0))
	    Image_Teamer:addChild(nNameLabel)	]]
	    --判断队伍是否过期
		if GetTeamLife(key) == true then
			if Image_Head:getChildByTag(99) == nil then
				local lifeImg = ImageView:create()
				lifeImg:setPosition(ccp(-8,-20))
				lifeImg:loadTexture("Image/imgres/corps/LifeEnd.png")
				Image_Head:addChild(lifeImg,1,99)
			end
		else
			if Image_Head:getChildByTag(99) ~= nil then
				Image_Head:getChildByTag(99):removeFromParentAndCleanup(true)
			end
		end
		--判断队伍是否在牢狱中
		if GetTeamCell(key) ~= -1 then
			local pCellBg = ImageView:create()
			pCellBg:setScale9Enabled(true)
			pCellBg:loadTexture("Image/imgres/countrywar/war_numName_bg.png")
			pCellBg:setSize(CCSize(105,34))
			pCellBg:setPosition(ccp(0,0))
			local pCellLabel = CreateLabel("牢狱中", 24, ccc3(226,55,9), CommonData.g_FONT1, ccp(0,0))
			pCellBg:addChild(pCellLabel)
			Image_Teamer:addChild(pCellBg, 2, 100)
			SpriteSetGray(pSpriteHeadImg,1)
		else
			if Image_Teamer:getChildByTag(100) ~= nil then
				Image_Teamer:getChildByTag(100):removeFromParentAndCleanup(true)
			end
			SpriteSetGray(pSpriteHeadImg,0)
		end
	end
end

local function OpenWatchLayer( self, nCityTag, nIndex, nCallBack )
	if nCallBack ~= nil then
		ToFogGuanZhan(nCityTag, nIndex-1, self.ChooseTeamTab, nCallBack)
	else
		ToFogGuanZhan(nCityTag, nIndex-1, self.ChooseTeamTab, self.CallBackData)
	end
end

local function UnlockMistyCity( self, pIndex )
	local nMistyIndex = self.DB[pIndex]["MistyIndex"]

	--更新数据
	UpdateMistyState( pIndex, false )

	local nCityID = GetMistyCityID(nMistyIndex)
	local nCNode = self.CityNodeDB[nCityID]
	nCNode:SetLockState(false)
	nCNode:SetMistyFightingState(true)

	--取得其周围城市设置状态
	for i=1,10 do
		local nAffectCityID = GetMistyAffectCityID(nMistyIndex, i) 
		if nAffectCityID ~= 0 then
			local nANode = self.CityNodeDB[nAffectCityID]
			nANode:SetLockState(false)
		else
			break
		end
	end

	local pMistyNode = self.Misty:getChildByTag(pIndex)
	pMistyNode:setVisible(false)

	if self.UIDB[pIndex] ~= nil then
		for key,value in pairs(self.UIDB[pIndex]) do
			if value ~= nil then value:removeFromParentAndCleanup(true) end
		end
	end

	--同步雷达的迷雾
	SetMistyState(pIndex, false)

end

local function InitMistyInfoLayer( self, nParent, nIndex, nCityTag )
	InitVars(self)

	local function InitLayer( nType, nHeadID, nLevel, nName, nMaxHp, nCurHp )
		NetWorkLoadingLayer.loadingHideNow()
		if nType == Misty_Type.MistyLock then
			self.MistyInfoLayer = TouchGroup:create()								
		    self.MistyInfoLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryWarMistyLayer.json"))

			local function _Click_Close_CallBack( sender, eventType )
				if eventType == TouchEventType.ended then
					sender:setScale(1.0)
					self.MistyInfoLayer:removeFromParentAndCleanup(true)
					InitVars(self)
				elseif  eventType == TouchEventType.began then
					sender:setScale(0.9)
				elseif eventType == TouchEventType.canceled then
					sender:setScale(1.0)
				end
			end

			local Button_Return = tolua.cast(self.MistyInfoLayer:getWidgetByName("Button_Return"), "Button")
		    Button_Return:setTouchEnabled(true)
		    Button_Return:addTouchEventListener(_Click_Close_CallBack)

			local function _Click_Attack_CallBack( sender, eventType )
				if eventType == TouchEventType.ended then
					sender:setScale(1.0)
					sender:setTouchEnabled(false)
					local nTab = {}
					--[[for i=1,4 do
						local Image_SelectFrame = tolua.cast(self.MistyInfoLayer:getWidgetByName("Image_SelectFrame_"..i), "ImageView")
						if Image_SelectFrame:isVisible() == true then
							table.insert(nTab, i-1)
						end
					end]]
					local nTabIndex = 1
					for i=1,4 do
						if self.SelectTab[i] ~= "Empty" then
							nTab[nTabIndex] = self.SelectTab[i]
							nTabIndex = nTabIndex + 1
						end
					end

					if table.getn(nTab) > 0 then
						--printTab(nTab)
						--设置playnode的属性当前正在攻打哪个城的哪块雾
						for i=1,table.getn(nTab) do
							if nTab[i] == 0 and self.PlayerDB["MainGeneral"] ~= nil then
								self.PlayerDB["MainGeneral"]:SetAttackMistyIndex(nIndex)
							elseif nTab[i] == 1 and self.PlayerDB["Teamer1"] ~= nil then
								self.PlayerDB["Teamer1"]:SetAttackMistyIndex(nIndex)
							elseif nTab[i] == 2 and self.PlayerDB["Teamer2"] ~= nil then
								self.PlayerDB["Teamer2"]:SetAttackMistyIndex(nIndex)
							elseif nTab[i] == 3 and self.PlayerDB["Teamer3"] ~= nil then
								self.PlayerDB["Teamer3"]:SetAttackMistyIndex(nIndex)
							end
						end		
						self.ChooseTeamTab = {} 			--每次tab初始化
						local nTeamTabIndex = 1
						for key,value in pairs(nTab) do
							self.ChooseTeamTab[nTeamTabIndex] = self.TeamUIDB[value+1]
							nTeamTabIndex = nTeamTabIndex + 1
						end
						--print(nWjTab)
						--Pause()
						--发送开始战斗协议
						local function StartWarResult( nResult )
							NetWorkLoadingLayer.loadingHideNow()
							if nResult == Misty_Attack_Type.Success then
								print("战斗请求成功,修改观战状态")
								local nCNode = self.CityNodeDB[nCityTag]
								nCNode:SetMistyFightingState(true)
								--调用请求观战的接口 (cmd1 : 城市ID， cmd2 : 武将表， cmd3 :主场景回调表)
								ToFogGuanZhan(nCityTag, nIndex-1, self.ChooseTeamTab, self.CallBackData)
								if self.MistyInfoLayer ~= nil then
									self.MistyInfoLayer:removeFromParentAndCleanup(true)
								end
								InitVars(self)	

							elseif nResult == Misty_Attack_Type.Over then
								TipLayer.createTimeLayer("该城市战斗已结束",2)
								sender:setTouchEnabled(true)
							elseif nResult == Misty_Attack_Type.Mismatch then
								TipLayer.createTimeLayer("没有队伍可出战",2)
								sender:setTouchEnabled(true)
							end
						end

						Packet_CountryWarBeginMistyWar.SetSuccessCallBack(StartWarResult)
						network.NetWorkEvent(Packet_CountryWarBeginMistyWar.CreatePacket(nIndex-1, table.getn(nTab), nTab))
						NetWorkLoadingLayer.loadingShow(true)
					else
						sender:setTouchEnabled(true)
						TipLayer.createTimeLayer("请选择出战队伍",2)
					end
				elseif  eventType == TouchEventType.began then
					sender:setScale(0.9)
				elseif eventType == TouchEventType.canceled then
					sender:setScale(1.0)
				end
			end

			local Button_Attack = tolua.cast(self.MistyInfoLayer:getWidgetByName("Button_Attack"), "Button")
		    Button_Attack:setTouchEnabled(true)
		    Button_Attack:addTouchEventListener(_Click_Attack_CallBack)

		    local nAttackLabel = LabelLayer.createStrokeLabel(25, CommonData.g_FONT3, "确定攻打", ccp(0, 0), ccc3(33,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
		    Button_Attack:addChild(nAttackLabel)

		    InitInfoMonsterUI(self, nIndex, nHeadID, nLevel, nName, nMaxHp, nCurHp)
		    InitInfoHeroUI(self)



		    nParent:addChild(self.MistyInfoLayer,100)
		elseif nType == Misty_Type.MistyFight then
			OpenWatchLayer(self, nCityTag, nIndex)
		elseif nType == Misty_Type.MistyWaitUnlock then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			local pName = GetCityNameByIndex(GetIndexByCTag(nCityTag))
			pTips:ShowCommonTips(1503,nil,tostring(pName))
			pTips = nil
			UnlockMistyCity(self, nIndex)
		end
	end

	Packet_CountryMistyCityInfo.SetSuccessCallBack(InitLayer)
	network.NetWorkEvent(Packet_CountryMistyCityInfo.CreatePacket(nIndex-1))
	NetWorkLoadingLayer.loadingShow(true)
end

local function UpdateMistyCityInfo( self, nFogIndex, nIndex, nTeamNum, nHp )
	local nUIDB = self.UIDB[nFogIndex+1]
	local nDB   = self.DB[nFogIndex+1]
	local pCityID = GetMistyCityID(nDB["MistyIndex"])
	if nIndex == -1 then
		--迷雾已解开
		print("迷雾已解开,删除所有UI"..pCityID)
		for key,value in pairs(nUIDB) do
			if value ~= nil then
				value:removeFromParentAndCleanup(true)
			end
		end
	else
		--更新UI
		if nTeamNum == 0 then
			print(pCityID.."的守军数量为0已被攻占,可解锁迷雾")
			--创建新的解锁图片
			nUIDB["spUnlock"] 	= CCSprite:create("Image/imgres/countrywar/unlockmisty.png")
			nUIDB["spUnlock"]:setPosition(ccp(nUIDB["spAttack"]:getPositionX(),nUIDB["spAttack"]:getPositionY()))
			self.Misty:addChild(nUIDB["spUnlock"],99999)
			--删除攻击标志
			if nUIDB["spAttack"] ~= nil then nUIDB["spAttack"]:removeFromParentAndCleanup(true) end
			nUIDB["spAttack"] = nil
			--改变城市的等待解锁状态为true
			local nCNode = self.CityNodeDB[pCityID]
			nCNode:SetWaitUnlock(true)
		end

		print("更新迷雾城市"..pCityID.."的UI血量"..nHp)
		nUIDB["proBlood"]:setPercent(nHp)
		
	end
end

local function UpdateSyncMisty( self )
	-- 断线同步迷雾

	self.DB    =  GetMistyDB()

	if self.DB == nil then
		return
	end
	for i=1,table.getn(self.DB) do
		local pMistyIndex = self.DB[i]["MistyIndex"]
		local pMistyBlood = self.DB[i]["MonsterBlood"]
		local pMistyNum   = self.DB[i]["MonsterNums"]

		local nUIDB = self.UIDB[i]

		if tonumber( pMistyIndex ) ~= -1 then

			if tonumber( pMistyBlood ) == 0 and tonumber( pMistyNum ) == 0 then

				local pCityID = GetMistyCityID(tonumber(pMistyIndex))

				local nCNode = self.CityNodeDB[pCityID]

				if nCNode:GetWaitUnlock() == false then

					print(pCityID.."的守军数量为0已被攻占,可解锁迷雾")
					--创建新的解锁图片
					nUIDB["spUnlock"] 	= CCSprite:create("Image/imgres/countrywar/unlockmisty.png")
					nUIDB["spUnlock"]:setPosition(ccp(nUIDB["spAttack"]:getPositionX(),nUIDB["spAttack"]:getPositionY()))
					self.Misty:addChild(nUIDB["spUnlock"],99999)
					--删除攻击标志
					if nUIDB["spAttack"] ~= nil then nUIDB["spAttack"]:removeFromParentAndCleanup(true) end
					nUIDB["spAttack"] = nil
					--改变城市的等待解锁状态为true
					
					nCNode:SetWaitUnlock(true)
					nUIDB["proBlood"]:setPercent(tonumber( pMistyBlood ))

				end

			end

		end

	end
end

local function InitMistyCity( self )
	-- 初始化迷雾的城池
	self.DB 			   = GetMistyDB()

	self.UIDB 			   = {}

	self.SelectTab  	   = {}

	self.SelectTab[1] 	   = "Empty"
	self.SelectTab[2] 	   = "Empty"
	self.SelectTab[3] 	   = "Empty"
	self.SelectTab[4] 	   = "Empty"

	self.RBgBatchNode = CCSpriteBatchNode:create("Image/imgres/main/chatBtn_Bg.png", 50)
	self.Misty:addChild(self.RBgBatchNode,1)

	self.BBgBatchNode = CCSpriteBatchNode:create("Image/imgres/dungeon/bar_bg.png", 50)
	self.Misty:addChild(self.BBgBatchNode,1)

	self.ABgBatchNode = CCSpriteBatchNode:create("Image/imgres/countrywar/attack.png", 50)
	self.Misty:addChild(self.ABgBatchNode,1)

	DBAnaly(self)
end

function Create(  )
	local tab = {
		Fun_InitMistyCity 				= InitMistyCity,
		Fun_SetMistyLayer 				= SetMistyLayer,
		Fun_SetCityLayer				= SetCityLayer,
		Fun_SetTouchLayer				= SetTouchLayer,
		Fun_SetObjData 					= SetObjData,
		Fun_SetCityAreaData 			= SetCityAreaData,
		Fun_SetAreaData 				= SetAreaData,
		Fun_InitMistyInfoLayer  		= InitMistyInfoLayer,
		Fun_SetUITab					= SetUITab,
		Fun_UpdateMistyCityInfo 		= UpdateMistyCityInfo,
		Fun_SetCallBackData				= SetCallBackData,
		Fun_SetTeamUIData				= SetTeamUIData,
		Fun_UnlockMistyCity				= UnlockMistyCity,
		Fun_OpenWatchLayer    			= OpenWatchLayer,
		Fun_SetPlayerData 				= SetPlayerData,
		Fun_GetMistyFightingIndex		= GetMistyFightingIndex,
		Fun_GetMistyFightingCity		= GetMistyFightingCity,
		Fun_UpdateSyncMisty				= UpdateSyncMisty,
	}

	return tab
end

