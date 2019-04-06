
module("FightResultLayer", package.seeall)

-- require "Script/Main/Activity/FightLevelLayer"
require "Script/Main/Dungeon/EnterPointLayer"
require "Script/Main/Wujiang/GeneralLvUpData"
require "Script/Main/Dungeon/DungeonLayer"
require "Script/Main/Dungeon/EliteDungeonLayer"
require "Script/Main/Dungeon/ActivitySelectLayer"
require "Script/Main/Dungeon/DungeonManagerLayer"
require "Script/Main/Dungeon/DungeonBaseUILogic"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/DungeonLogic"
require "Script/Main/Pata/PataLayer"
require "Script/Main/Pata/PataLogic"
require "Script/serverDB/server_fubenDB"

local GetSceneIdxById 					= DungeonLogic.GetSceneIdxById
local IsOnly							= DungeonLogic.IsOnly
local GetSceneType 						= DungeonBaseData.GetSceneType
local GetSceneTypeBySceneID				= DungeonBaseUILogic.GetSceneTypeBySceneID

local GetPointId						= DungeonBaseData.GetPointId
local GetPointRuleId					= DungeonBaseData.GetPointRuleId

local getMainDataByKey 					= server_mainDB.getMainData
local GetPointStars						= server_fubenDB.GetPointStars

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 
local StrokeLabel_setText 				= 	LabelLayer.setText

local CreateItemTipLayer 				= ItemTipLayer.CreateItemTipLayer
local DeleteItemTipLayer				= ItemTipLayer.DeleteItemTipLayer

local function FixItemCount(tableTemp)
	local tableRe = {}
	for i = 1, #tableTemp do
		local nId = tonumber(tableTemp[i].Id)
		local nCount = tonumber(tableTemp[i].Count)
		for j = i+1, #tableTemp do
			if nId == tonumber(tableTemp[j].Id) then
				nCount = nCount + tableTemp[j].Count
				tableTemp[j].Count = 0
			end
		end
		if nCount ~= 0 then
			table.insert(tableRe,  {["Id"] = nId, ["Count"] = nCount})
		end
	end
	return tableRe
end


local function InsertAwardItem( self, pScrollView, tabAwardItem, nStart_X, nStart_Y )

	local function _Image_RewardItem_CallBack(sender, eventType)
		if eventType == TouchEventType.ended then
			DeleteItemTipLayer()
		elseif eventType==TouchEventType.began then
			CreateItemTipLayer(self.pResultLayer, sender, TipType.Item, sender:getTag(), TipPosType.RightTop)
		elseif eventType==TouchEventType.canceled then
			DeleteItemTipLayer()
		end
	end

	for key,value in pairs(tabAwardItem) do
		local pImageIcon = ImageView:create()
		pImageIcon:setScale( 0.68 ) 
		pImageIcon:setPosition(ccp( 100 + (key - 1) * 90, 40))
		pImageIcon:setTouchEnabled(true)

		local pNewImageIcon = UIInterface.MakeHeadIcon(pImageIcon, ICONTYPE.ITEM_ICON, value.Id, nil)
		pNewImageIcon:setTag(value.Id)

		pNewImageIcon:addTouchEventListener(_Image_RewardItem_CallBack)

		local pLabelNum = Label:create()
		pLabelNum:setColor(COLOR_White)
		pLabelNum:setFontSize(22)
		pLabelNum:setPosition(ccp(-35,-40))
		pLabelNum:setText("x"..value.Count)
		pImageIcon:addChild(pLabelNum)

		pScrollView:addChild(pImageIcon,1)
	end
	pScrollView:setInnerContainerSize(CCSizeMake(nStart_X+35, 80))
end

local function ShowStar( self )
	if self.pStar == nil then
		return
	end
	if self.pStar >= 1 and self.pStar <= 3 then
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson")
		if self.pResultLayer:getChildByTag(108) ~= nil then
			self.pResultLayer:getChildByTag(108):removeFromParentAndCleanup(false)
		end
		local addNum = 1
		local layout = Layout:create()
		layout:setTouchEnabled(false)
		layout:setPosition(ccp(420,480 - CommonData.g_Origin.y))
		local function CreateStar( num )
			AudioUtil.playEffect("audio/1star_fight_win.mp3")
			local PayArmature = CCArmature:create("Fight_Win_001_lq")
			PayArmature:getAnimation():play("Animation3")
			if num == 2 then
				PayArmature:setScale(1)
				PayArmature:setPosition(ccp(num * 75,0))
			else
				PayArmature:setScale(0.85)
				PayArmature:setPosition(ccp(num * 75,15))
			end
			layout:addNode(PayArmature,1,num)
			local function onMovementEvent(armatureBack,movementType,movementID)
				if movementType == 1 then
					CreateStar(num + 1)
				end
			end
			if num + 1 <= self.pStar then
				PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
			else
				if self.pStar == 3 then
					for i=1,self.pStar do
						if layout:getNodeByTag(i) ~= nil then
							layout:getNodeByTag(i):getAnimation():play("Animation4")
						end
					end	
				end
			end	
		end
		CreateStar(addNum)
		self.pResultLayer:addChild(layout, 10, 108)
	end
end

local function GetReslut( self )
	--三星过关或者多少秒过关
	if self.pStar == 3 then
		return true
	else
		return false
	end
end

local function InitNormalWin( self, nDropData )
	local function _Button_FightDataBtn_CallBack( )
		require "Script/Fight/FightDataLayer"

		local bPkScene = false

		if self.SceneType == DungeonsType.PK then
			bPkScene = true
		end

		pFightDataLayer = FightDataLayer.showFightData( bPkScene, self.pFightOutPutData )

		self.pResultLayer:addChild( pFightDataLayer, layerFightData_Tag, layerFightData_Tag)

	end

	local function _Button_NextLevelBtn_CallBack(sender, eventType)
		--NetWorkLoadingLayer.ClearLoading()

		self.pResultLayer:removeFromParentAndCleanup(true)
		self.SceneInterFace:LeaveScene()

		if self.SceneType ~= DungeonsType.PK then

			local nSceneIdx = GetSceneIdxById(self.nSceneId)

			if self.SceneType == DungeonsType.Normal then
				DungeonManagerLayer.UpdateBaseData()
				DungeonLayer.UpdateMapData(nSceneIdx, self.nIndexId)
			elseif self.SceneType == DungeonsType.Elite then
				DungeonManagerLayer.UpdateBaseData()
				EliteDungeonLayer.UpdateEliteMap() 		--更新精英副本内容
			elseif self.SceneType == DungeonsType.Activity then
				DungeonManagerLayer.UpdateBaseData()
				ActivitySelectLayer.UpdateLayerInfo()
			elseif self.SceneType == DungeonsType.ClimbingTower then 	
				--战斗胜利						
				PataLayer.UpdatePataData() 
				if GetReslut( self ) == true then 		--如果三星通关
					PataLayer.PlayNextLayerAni()
				else
					--如果没有三星通关，判断此前是否三星通关此关，如果是直接跳层，如果没有播放失败
					PataLayer.PataFailed( self.pStar )
				end
			end
			DungeonManagerLayer.UpdateCheckBox()	--更新副本checkbox

		end

	end

	local  function _ScrollView_Award_CallBack( sender, eventType )
		if eventType==4 then
			local nPosX = sender:getInnerContainer():getPositionX()
			local nContainerWidth = sender:getInnerContainer():getSize().width
			local nViewWidth = sender:getContentSize().width

			local SliderAward = tolua.cast(self.pResultLayer:getWidgetByName("Slider_29"), "Slider")
			if nPosX>=0 and nPosX<=nViewWidth then
				SliderAward:setPercent(0)
			elseif nPosX<0 and nPosX>=-(nContainerWidth-nViewWidth) then
				SliderAward:setPercent(math.abs(nPosX)/(nContainerWidth-nViewWidth)*100)
			elseif nPosX<-(nContainerWidth-nViewWidth) then
			SliderAward:setPercent(100)
			end
		end
	end

	--战斗数据响应
    local pFightDataBtn = tolua.cast( self.pResultLayer:getWidgetByName("Button_see_data"), "Button" )
    CreateBtnCallBack( pFightDataBtn, "看数据", 36, _Button_FightDataBtn_CallBack )
    --下一关响应
    local pNextLevelBtn = tolua.cast( self.pResultLayer:getWidgetByName("Button_next_level"), "Button" )
    CreateBtnCallBack( pNextLevelBtn, nil, nil, _Button_NextLevelBtn_CallBack )
    --物品奖励滚动层
    local pScrollView_RewardItem = tolua.cast(self.pResultLayer:getWidgetByName("ScrollView_Award"), "ScrollView")
    pScrollView_RewardItem:setClippingType(1)
    pScrollView_RewardItem:addEventListenerScrollView(_ScrollView_Award_CallBack)
    --设置头像
    local nHeadResId = server_mainDB.getMainData("nHeadID")
	local strHeadPath = resimg.getFieldByIdAndIndex(nHeadResId, "icon_path")
	local pImageHead = tolua.cast(self.pResultLayer:getWidgetByName("Image_head_icon"), "ImageView")
	pImageHead:loadTexture(strPath)

    --主将等级
    local nCurLv 		= CommonData.g_MainDataTable.level
	local pLabelLevel = tolua.cast(self.pResultLayer:getWidgetByName("Label_level"), "Label")
	pLabelLevel:setText(nCurLv)

    --初始化奖励
    local function InitExpAndLevel( nAddExp )
		local nCurLv 		= CommonData.g_MainDataTable.level
		local nCurExp 		= CommonData.g_MainDataTable.exp
		local nNeedExp 		= GeneralLvUpData.GetNeedExp(nCurLv)

		if nCurLv >= 100 then
			nCurExp = 0 
			nNeedExp = 0
		end

		--增加的经验
		local pExpImg  = tolua.cast(self.pResultLayer:getWidgetByName("Image_35"), "ImageView")
		local pLabelAddExp = StrokeLabel_createStrokeLabel(25, CommonData.g_FONT1, "+ "..nAddExp, ccp(100, 0), ccc3(43,26,15), COLOR_White, true, ccp(0, 0), 2)
		pExpImg:addChild(pLabelAddExp)
		--经验条
		local pExpBarBg = tolua.cast(self.pResultLayer:getWidgetByName("Image_8"), "ImageView")
		local pTimerBar = CCProgressTimer:create(CCSprite:create("Image/imgres/wujiang/pgbar.png"))
		pTimerBar:setType(kCCProgressTimerTypeBar)
		pTimerBar:setScale(0.72)
		pTimerBar:setMidpoint(CCPointMake(0, 0))
		pTimerBar:setBarChangeRate(CCPointMake(1, 0))
		pTimerBar:setPosition(ccp(0, 0))
		pExpBarBg:addNode(pTimerBar)

		local pActUpdate=CCArray:create()
		if nCurExp > nNeedExp then
			local to1 = CCProgressTo:create(1, 100)
			pActUpdate:addObject(to1)
			nCurExp = nCurExp-nNeedExp
			nNeedExp = GeneralLvUpData.GetNeedExp(nCurLv)
			nAddExp=0

			local function ActionCallBack(  )
				pLabelLevel:setText( tostring(nCurLv) )
			end

			pActUpdate:addObject(CCCallFunc:create(ActionCallBack))
		end
		
		local to2 = CCProgressTo:create(1,  ((nCurExp)/nNeedExp)*100)
		if nCurLv >= 100 then
			to2 = CCProgressTo:create(0.1,  0)
		end
		pActUpdate:addObject(to2)
		pTimerBar:runAction(CCSequence:create(pActUpdate))

		local pExpBar = tolua.cast(self.pResultLayer:getWidgetByName("ProgressBar_exp"), "LoadingBar")
		pExpBar:setVisible(false)
    end

	local pCoinIndex = 1

	local nExp = 0

	for i = 1, 5 do
		local nType = pointreward.getFieldByIdAndIndex( self.pRewardID, "CionID_" .. i )
		if tonumber(nType) > 0 then
			local strName = coin.getFieldByIdAndIndex( nType, "Name" )
			if strName == "主将经验" then
				--初始化经验和等级
				nExp = pointreward.getFieldByIdAndIndex( self.pRewardID, "Number_" .. i )
			else
				--初始化货币奖励
				local nResId = coin.getFieldByIdAndIndex(nType,"ResID")
				local strPath = resimg.getFieldByIdAndIndex(nResId,"icon_path")
				local Image_Coin = tolua.cast(self.pResultLayer:getWidgetByName("Image_Coin_"..pCoinIndex), "ImageView")
				Image_Coin:loadTexture( strPath )

				local pCoinNum = pointreward.getFieldByIdAndIndex( self.pRewardID, "Number_" .. i )

				local pLabelCoin = StrokeLabel_createStrokeLabel(25, CommonData.g_FONT1, pCoinNum, ccp(30, 0), ccc3(43,26,15), COLOR_White, false, ccp(0, 0), 2)
				Image_Coin:addChild( pLabelCoin )

				Image_Coin:setVisible(true)
    
				pCoinIndex = pCoinIndex + 1
			end

		end
	end

	InitExpAndLevel( nExp )

	--初始化物品奖励
	local pRewardItemTab = {}
	--关卡奖励的物品
	for i = 1, 10 do
		local nItemId = pointreward.getFieldByIdAndIndex( self.pRewardID, "ItemID_" .. i )
		local nNum = pointreward.getFieldByIdAndIndex( self.pRewardID, "ItemNum_" .. i )
		if nItemId ~= nil and nNum ~= nil and tonumber(nItemId) > 0 then
			table.insert(pRewardItemTab, {["Id"] = nItemId, ["Count"] = nNum})
		end
	end
	--关卡掉落的物品
	if nDropData ~= nil then
		for key,value in pairs( nDropData ) do
			table.insert( pRewardItemTab, value )
		end
	end
	--过滤奖励插入scrollview
	local tableRe = FixItemCount( pRewardItemTab )
	if tableRe ~= nil then
		InsertAwardItem(self, pScrollView_RewardItem, tableRe, 45, 50)
	end
	--战斗胜利动画
	local Panel_FightResultWin = tolua.cast(self.pResultLayer:getWidgetByName("Panel_FightResultWin"), "Layout")
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson")
	local PayArmature = CCArmature:create("Fight_Win_001_lq")
	PayArmature:getAnimation():play("Animation1")

	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if Panel_FightResultWin:getChildByTag(108) ~= nil then
				Panel_FightResultWin:removeChildByTag(108, true)
			end

			PayArmature:getAnimation():play("Animation2")

			local layout = Layout:create()
			layout:setTouchEnabled(false)
			layout:addNode(PayArmature)
			layout:setPosition(ccp(Panel_FightResultWin:getContentSize().width/2, Panel_FightResultWin:getContentSize().height - 80))
			Panel_FightResultWin:addChild(layout, 10, 108)
			--战斗胜利星星动画
			if self.SceneType ~= DungeonsType.PK then
				local nSceneIdx = GetSceneIdxById(self.nSceneId)
				local nPointId = GetPointId(nSceneIdx, self.nIndexId)
				local nPointRuleId = GetPointRuleId(nPointId)
				if IsOnly(nPointRuleId) == false then
					ShowStar( self )
				end
			end
		end
	end

	PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)

	if Panel_FightResultWin:getChildByTag(108) ~= nil then
		Panel_FightResultWin:removeChildByTag(108, true)
	end
	layout:setPosition(ccp(Panel_FightResultWin:getContentSize().width/2, Panel_FightResultWin:getContentSize().height - 80))
	Panel_FightResultWin:addChild(layout, 10, 108)

    --设置头像
    local nHeadResId = server_mainDB.getMainData("nHeadID")
	local strHeadPath = resimg.getFieldByIdAndIndex(nHeadResId, "icon_path")
	local pImageHead = tolua.cast(self.pResultLayer:getWidgetByName("Image_head_icon"), "ImageView")
	pImageHead:loadTexture(strHeadPath)

	self.pResultLayer:setVisible(true)

	AudioUtil.playEffect("audio/win.mp3")


end

local function InitNormalFailied( self )
	local function _Button_FightDataBtn_CallBack( )
		require "Script/Fight/FightDataLayer"

		local bPkScene = false

		if self.SceneType == DungeonsType.PK then
			bPkScene = true
		end

		pFightDataLayer = FightDataLayer.showFightData( bPkScene, self.pFightOutPutData )

		self.pResultLayer:addChild( pFightDataLayer, layerFightData_Tag, layerFightData_Tag)

	end

	local function _Button_NextLevelBtn_CallBack(sender, eventType)
		--NetWorkLoadingLayer.ClearLoading()

		self.pResultLayer:removeFromParentAndCleanup(true)
		self.SceneInterFace:LeaveScene()

		if self.SceneType ~= DungeonsType.PK then

			local nSceneIdx = GetSceneIdxById(self.nSceneId)

			if self.SceneType == DungeonsType.Normal then
				DungeonManagerLayer.UpdateBaseData()
				DungeonLayer.UpdateMapData(nSceneIdx, self.nIndexId)
			elseif self.SceneType == DungeonsType.Elite then
				DungeonManagerLayer.UpdateBaseData()
				EliteDungeonLayer.UpdateEliteMap() 		--更新精英副本内容
			elseif self.SceneType == DungeonsType.Activity then
				DungeonManagerLayer.UpdateBaseData()
				ActivitySelectLayer.UpdateLayerInfo()
			elseif self.SceneType == DungeonsType.ClimbingTower then 	
				--战斗胜利						
				PataLayer.UpdatePataData() 
				if GetReslut( self ) == true then 		--如果三星通关
					PataLayer.PlayNextLayerAni()
				else
					--如果没有三星通关，判断此前是否三星通关此关，如果是直接跳层，如果没有播放失败
					if self.pStar ~= nil then
						PataLayer.PataFailed( self.pStar )
					end
				end
			end
			DungeonManagerLayer.UpdateCheckBox()	--更新副本checkbox

		end

	end

	local  function _ScrollView_Award_CallBack( sender, eventType )
		if eventType==4 then
			local nPosX = sender:getInnerContainer():getPositionX()
			local nContainerWidth = sender:getInnerContainer():getSize().width
			local nViewWidth = sender:getContentSize().width

			local SliderAward = tolua.cast(self.pResultLayer:getWidgetByName("Slider_29"), "Slider")
			if nPosX>=0 and nPosX<=nViewWidth then
				SliderAward:setPercent(0)
			elseif nPosX<0 and nPosX>=-(nContainerWidth-nViewWidth) then
				SliderAward:setPercent(math.abs(nPosX)/(nContainerWidth-nViewWidth)*100)
			elseif nPosX<-(nContainerWidth-nViewWidth) then
			SliderAward:setPercent(100)
			end
		end
	end

	--战斗数据响应
    local pFightDataBtn = tolua.cast( self.pResultLayer:getWidgetByName("Button_see_data"), "Button" )
    CreateBtnCallBack( pFightDataBtn, "看数据", 36, _Button_FightDataBtn_CallBack )
    --下一关响应
    local pNextLevelBtn = tolua.cast( self.pResultLayer:getWidgetByName("Button_next_level"), "Button" )
    CreateBtnCallBack( pNextLevelBtn, nil, nil, _Button_NextLevelBtn_CallBack )
    if self.SceneType == DungeonsType.PK then
	    --初始化奖励
	    local function InitExpAndLevel( nAddExp )
			local nCurLv 		= CommonData.g_MainDataTable.level
			local nCurExp 		= CommonData.g_MainDataTable.exp
			local nNeedExp 		= GeneralLvUpData.GetNeedExp(nCurLv)

			if nCurLv >= 100 then
				nCurExp = 0 
				nNeedExp = 0
			end

			--等级label
			local pLabelLevel = tolua.cast(self.pResultLayer:getWidgetByName("Label_level"), "Label")
			pLabelLevel:setText(nCurLv)
			--增加的经验
			local pExpImg  = tolua.cast(self.pResultLayer:getWidgetByName("Image_35"), "ImageView")
			local pLabelAddExp = StrokeLabel_createStrokeLabel(25, CommonData.g_FONT1, "+ "..nAddExp, ccp(100, 0), ccc3(43,26,15), COLOR_White, true, ccp(0, 0), 2)
			pExpImg:addChild(pLabelAddExp)
			--经验条
			local pExpBarBg = tolua.cast(self.pResultLayer:getWidgetByName("Image_8"), "ImageView")
			local pTimerBar = CCProgressTimer:create(CCSprite:create("Image/imgres/wujiang/pgbar.png"))
			pTimerBar:setType(kCCProgressTimerTypeBar)
			pTimerBar:setScale(0.72)
			pTimerBar:setMidpoint(CCPointMake(0, 0))
			pTimerBar:setBarChangeRate(CCPointMake(1, 0))
			pTimerBar:setPosition(ccp(0, 0))
			pExpBarBg:addNode(pTimerBar)

		    --主将等级
		    local nCurLv 		= CommonData.g_MainDataTable.level
			local pLabelLevel = tolua.cast(self.pResultLayer:getWidgetByName("Label_level"), "Label")
			pLabelLevel:setText(nCurLv)

			local pActUpdate=CCArray:create()
			if nCurExp+nAddExp > nNeedExp then
				local to1 = CCProgressTo:create(1, 100)
				pActUpdate:addObject(to1)
				nCurExp = nCurExp-nNeedExp
				nNeedExp = GeneralLvUpData.GetNeedExp(nCurLv)
				nAddExp=0

				local function ActionCallBack(  )
					pLabelLevel:setText( tostring(nCurLv) )
				end

				pActUpdate:addObject(CCCallFunc:create(ActionCallBack))
			end
			local to2 = CCProgressTo:create(1,  ((nCurExp+nAddExp)/nNeedExp)*100)
			if nCurLv >= 100 then
				to2 = CCProgressTo:create(0.1,  0)
			end
			pActUpdate:addObject(to2)
			pTimerBar:runAction(CCSequence:create(pActUpdate))

			local pExpBar = tolua.cast(self.pResultLayer:getWidgetByName("ProgressBar_exp"), "LoadingBar")
			pExpBar:setVisible(false)
	    end

		local pCoinIndex = 1

		local nExp = 0

		for i = 1, 5 do
			local nType = pointreward.getFieldByIdAndIndex( self.pRewardID, "CionID_" .. i )
			if tonumber(nType) > 0 then
				local strName = coin.getFieldByIdAndIndex( nType, "Name" )
				if strName == "主将经验" then
					--初始化经验和等级
					nExp = pointreward.getFieldByIdAndIndex( self.pRewardID, "Number_" .. i )
				else
					--初始化货币奖励
					local nResId = coin.getFieldByIdAndIndex(nType,"ResID")
					local strPath = resimg.getFieldByIdAndIndex(nResId,"icon_path")
					local Image_Coin = tolua.cast(self.pResultLayer:getWidgetByName("Image_Coin_"..pCoinIndex), "ImageView")
					Image_Coin:loadTexture( strPath )

					local pCoinNum = pointreward.getFieldByIdAndIndex( self.pRewardID, "Number_" .. i )

					local pLabelCoin = StrokeLabel_createStrokeLabel(25, CommonData.g_FONT1, pCoinNum, ccp(30, 0), ccc3(43,26,15), COLOR_White, false, ccp(0, 0), 2)
					Image_Coin:addChild( pLabelCoin )

					Image_Coin:setVisible(true)
	    
					pCoinIndex = pCoinIndex + 1
				end

			end
		end

		InitExpAndLevel( nExp )

	    --设置头像
	    local nHeadResId = server_mainDB.getMainData("nHeadID")
		local strHeadPath = resimg.getFieldByIdAndIndex(nHeadResId, "icon_path")
		local pImageHead = tolua.cast(self.pResultLayer:getWidgetByName("Image_head_icon"), "ImageView")
		pImageHead:loadTexture(strHeadPath)

	end

end

--nRewardID = 奖励ID
--nPointName = 关卡名称
local function ShowNormalWinResultLayer( self, pRoot, nPointName, nRewardID, nDropData, nStar )
	--战斗胜利界面
	self.pResultLayer = TouchGroup:create()	
	self.pResultLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/FightResultWinLayer.json") )
	self.pResultLayer:setVisible(false)

	self.pRewardID = nRewardID

	self.pStar = nStar

	local function BattleEndOver( )
		--NetWorkLoadingLayer.loadingHideNow()
		NetWorkLoadingLayer.ClearLoading()
		InitNormalWin( self, nDropData )
	end

	--发送战斗结束协议
	if self.SceneType ~= DungeonsType.PK then

		local pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_10
		if tonumber(self.nIndexId) == 1 then
			pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_10
		elseif tonumber(self.nIndexId) == 2 then 
			pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_11
		elseif tonumber(self.nIndexId) == 3 then 
			pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_12
		end

		Packet_BattleEnd.SetSuccessCallBack(BattleEndOver)
		if NewGuideManager.GetBGuide() == true then
			--print("NewGuideManager self.nSceneId = "..self.nSceneId.." self.nIndexId = "..self.nIndexId.." self.pStar = "..self.pStar)
			--Pause()
			NewGuideManager.PostPacket(pNetType, self.nSceneId, self.nIndexId, self.pStar)
		else
			print("Send Packet_BattleEnd")
			network.NetWorkEvent(Packet_BattleEnd.CreatPacket(self.nSceneId, self.nIndexId, self.pStar))
		end

		--NetWorkLoadingLayer.ClearLoading()
		NetWorkLoadingLayer.loadingShow(true)

	else

		BattleEndOver()

	end

	pRoot:addChild( self.pResultLayer )

end

local function ShowNormalFailiedResultLayer( self, pRoot, nPointName, nRewardID, nStar )
	-- 战斗失败界面

	self.pResultLayer = TouchGroup:create()	

	self.pRewardID = nRewardID

	self.pStar = nStar

	if self.SceneType == DungeonsType.PK then
		--比武战斗失败的奖励界面
		self.pResultLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/FightResultFailLayerByBiwu.json") )
	else
		--普通战斗失败的奖励界面
		self.pResultLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/FightResultFailLayer.json") )
	end

	--如果战斗是普通副本,直接显示界面
	pRoot:addChild( self.pResultLayer )

	local function BattleEndOver( )
		--NetWorkLoadingLayer.loadingHideNow()
		NetWorkLoadingLayer.ClearLoading()
		InitNormalFailied( self )
		AudioUtil.playEffect("audio/fail.mp3")
	end

	if self.SceneType ~= DungeonsType.PK then

		local pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_10
		if tonumber(self.nIndexId) == 1 then
			pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_10
		elseif tonumber(self.nIndexId) == 2 then 
			pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_11
		elseif tonumber(self.nIndexId) == 3 then 
			pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_12
		end

		Packet_BattleEnd.SetSuccessCallBack(BattleEndOver)
		if NewGuideManager.GetBGuide() == true then
			NewGuideManager.PostPacket(pNetType, self.nSceneId, self.nIndexId, self.pStar)
		else
			print("send Packet_BattleEnd")
			network.NetWorkEvent(Packet_BattleEnd.CreatPacket(self.nSceneId, self.nIndexId, self.pStar))
		end
		--NetWorkLoadingLayer.ClearLoading()
		NetWorkLoadingLayer.loadingShow(true)

	else

		BattleEndOver()

	end

end

--nSceneType:当前战斗类型
--战斗结果：胜利或者失败
local function ExternalReferenceAndInitAttr( self, nFightResult, nSceneInterFace )

	self.SceneInterFace    = nSceneInterFace

	self.FightRes  		   = nFightResult

	if self.SceneInterFace:IsPKScene() == false then

		if PataLayer.PataFighting() ~= nil then 		--当前是爬塔

			self.nSceneId 	   = PataLayer.GetPataSceneId()

			self.nIndexId 	   = PataLayer.GetPataIndexId()

		else
														--当前是副本
			self.nSceneId 	   = EnterPointLayer.GetFightSceneId()

			self.nIndexId 	   = EnterPointLayer.GetFightIndexId()

		end
		--根据场景ID和关卡索引判断当前的关卡类型
		self.SceneType     = GetSceneTypeBySceneID( self.nSceneId )

	else

		self.SceneType 	   = DungeonsType.PK 		    --当前是比武

	end
	
end

local function SetFightOutPutData( self, nData )
	if nData ~= nil then
		self.pFightOutPutData = nData
	end
end

local function GetFightOutPutData( self )
	if self.pFightOutPutData ~= nil then
		return self.pFightOutPutData
	end
end


function Create(  )
	local tab = {
		Fun_ShowNormalWinResultLayer		= 	ShowNormalWinResultLayer,
		Fun_ShowNormalFailiedResultLayer    = 	ShowNormalFailiedResultLayer,
		Fun_ExternalReferenceAndInitAttr	= 	ExternalReferenceAndInitAttr,
		Fun_SetFightOutPutData 				=	SetFightOutPutData,
		Fun_GetFightOutPutData				=	GetFightOutPutData,
	}

	return tab
end