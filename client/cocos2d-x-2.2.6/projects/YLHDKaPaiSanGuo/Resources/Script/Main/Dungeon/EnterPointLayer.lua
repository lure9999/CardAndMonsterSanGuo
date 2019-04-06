require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Common/ItemTipLayer"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/EnterPointLogic"
require "Script/Main/Dungeon/DungeonLogic"
require "Script/Main/Dungeon/EliteDungeonData"
require "Script/Main/Dungeon/MopupLayer"
module("EnterPointLayer", package.seeall)


local m_pLayerEnterPoint = nil
local m_pLbTitle = nil
local m_pLbDesc = nil
local m_pLbTiLi = nil
local m_pLbTimes = nil
local m_pBtnAddTimes = nil
local m_pSurPlusTimes = nil
local m_pBuyType = nil
local m_pImgRewardItems = {}
local m_pImgMonsters = {}

local m_nSceneId = nil
local m_nSceneIdx = nil
local m_nLocalIdx = nil
local m_IsOnly 	  = nil
local GetPointId					= DungeonBaseData.GetPointId
local GetPointRuleId				= DungeonBaseData.GetPointRuleId
local GetPointName					= DungeonBaseData.GetPointName
local GetPointDesc					= DungeonBaseData.GetPointDesc
local GetNeedTiLi					= DungeonBaseData.GetNeedTiLi
local GetTimes 						= DungeonBaseData.GetTimes
local GetRewardList					= DungeonBaseData.GetRewardList
local GetMonsterList				= DungeonBaseData.GetMonsterList
local GetMonsterMilitary			= DungeonBaseData.GetMonsterMilitary
local GetSceneId 					= DungeonBaseData.GetSceneId
local GetSceneRuleId				= DungeonBaseData.GetSceneRuleId
local GetSceneType					= DungeonBaseData.GetSceneType
local GetActivityTimes				= DungeonBaseData.GetActivityTimes

local GetRewardItemData				= EnterPointLogic.GetRewardItemData

local GetPointLeftTimes				= server_fubenDB.GetPointLeftTimes
local SetPointLeftTimes 			= server_fubenDB.SetPointLeftTimes
local GetPointStars					= server_fubenDB.GetPointStars
local SetEliteFightedTimes 			= server_fubenDB.SetEliteFightedTimes
local GetPointRuleID 				= DungeonLogic.GetPointRuleID
local GetErrorCodeText				= DungeonLogic.GetErrorCodeText
local IsEnoughTiLi					= DungeonLogic.IsEnoughTiLi
local IsOnly						= DungeonLogic.IsOnly

local CreateStrokeLabel 			= LabelLayer.createStrokeLabel
local SetStrokeLabelText			= LabelLayer.setText
local CreateTimeLayer				= TipLayer.createTimeLayer
local MakeHeadIcon					= UIInterface.MakeHeadIcon
local CreateItemTipLayer 			= ItemTipLayer.CreateItemTipLayer
local DeleteItemTipLayer			= ItemTipLayer.DeleteItemTipLayer
local GetEliteTimes					= EliteDungeonData.GetEliteTimes

local CheckMopup					= DungeonLogic.CheckMopup
local GetMopupStateText				= DungeonLogic.GetMopupStateText

local function InitVars( )
	m_pLayerEnterPoint = nil
	m_pLbTitle = nil
	m_pLbDesc = nil
	m_pLbTiLi = nil
	m_pBuyType = nil
	m_pBtnAddTimes = nil
	m_IsOnly 	  = nil
	m_pSurPlusTimes = nil
	m_pImgRewardItems = {}
	m_pImgMonsters = {}
end

local function GotoVip(  )
	MainScene.GoToVIPLayer( 0 )
end

local function _Image_RewardItem_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		DeleteItemTipLayer()
	elseif eventType==TouchEventType.began then
		AudioUtil.PlayBtnClick()
		CreateItemTipLayer(m_pLayerEnterPoint, sender, TipType.Item, sender:getTag(), TipPosType.RightTop)
	elseif eventType==TouchEventType.canceled then
		DeleteItemTipLayer()
	end
end

local function _Image_Monster_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		DeleteItemTipLayer()
	elseif eventType==TouchEventType.began then
		AudioUtil.PlayBtnClick()
		CreateItemTipLayer(m_pLayerEnterPoint, sender, TipType.Monster, sender:getTag(), TipPosType.RightTop)
	elseif eventType==TouchEventType.canceled then
		DeleteItemTipLayer()
	end
end

local function UpdateRewardItemInfo( nRewardItemIdTab, nParent )

	local nIndex = 1

	for k, v in pairs( nRewardItemIdTab ) do

		local pRewardId = v["RewardId"]
		local pRewardCount = v["Count"]
		local pImageIcon = ImageView:create()
		pImageIcon:setScale( 0.68 ) 
		pImageIcon:setPosition(ccp( -217 + (nIndex - 1) * 90, 1))
		pImageIcon:setTouchEnabled(true)

		local pNewImageIcon = UIInterface.MakeHeadIcon(pImageIcon, ICONTYPE.ITEM_ICON, pRewardId, nil)
		pNewImageIcon:setTag(pRewardId)
		pNewImageIcon:addTouchEventListener(_Image_RewardItem_CallBack)

		local pLabelNum = Label:create()
		pLabelNum:setColor(COLOR_White)
		pLabelNum:setFontSize(22)
		pLabelNum:setPosition(ccp(-35,-40))
		pLabelNum:setText("x"..pRewardCount)
		pImageIcon:addChild(pLabelNum)
		pLabelNum:setVisible(false)

		nParent:addChild( pImageIcon )

		nIndex = nIndex + 1

	end
end

local function UpdateMonsterInfo( tabMonsterData, pMonsterControl )
	local pLabelJob = tolua.cast(pMonsterControl:getChildByName("Label_Job"), "Label")
	if tabMonsterData.MonsterType==MonsterType.Genereal then
		pMonsterControl:setScale(1.1)
		local pNameBg = tolua.cast(pMonsterControl:getChildByName("Image_44"), "ImageView")
		pNameBg:loadTexture("Image/imgres/dungeon/monster_name_bg.png")
		pMonsterControl:removeChild(pLabelJob, true)
		local pLbJob = CreateStrokeLabel(24, CommonData.g_FONT1, tabMonsterData.Military, ccp(0, 0), ccc3(49, 16, 7), ccc3(254, 225, 78), true, ccp(0, -2), 2)
		pLbJob:setScale(1.0)
		pNameBg:addChild(pLbJob)
	else
		pMonsterControl:setScale(1.0)
		pLabelJob:setText(tabMonsterData.Military)
	end
	local pHeadIcon = tolua.cast(pMonsterControl:getChildByName("Image_Head"), "ImageView")
	pHeadIcon:loadTexture(tabMonsterData.HeadIcon)
	local pColorIcon = tolua.cast(pMonsterControl:getChildByName("Image_Color"), "ImageView")
	pColorIcon:loadTexture(tabMonsterData.ColorIcon)

	pMonsterControl:setTag(tabMonsterData.MonsterId)
	pMonsterControl:setTouchEnabled(true)
	pMonsterControl:addTouchEventListener(_Image_Monster_CallBack)
end

--[[local function UpdateTimesByBtn( nLeftTimes, isTen )
	local pBtnFightTen = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Button_Fight_10"),"Button")

	local nPointId = GetPointId(m_nSceneIdx, m_nLocalIdx)
	nAllTimes = GetTimes(GetPointRuleId( nPointId ))
	--nLeftTimes = nAllTimes - GetPointLeftTimes(DungeonsType.Normal, m_nSceneId, m_nLocalIdx)
	local Str = "战多次"
	local nStrTab = {}
	nStrTab[1] = "战一次"
	nStrTab[2] = "战两次"
	nStrTab[3] = "战三次"
	nStrTab[4] = "战四次"
	nStrTab[5] = "战五次"
	nStrTab[6] = "战六次"
	nStrTab[7] = "战七次"
	nStrTab[8] = "战八次"
	nStrTab[9] = "战九次"
	nStrTab[10] = "战十次"

	if nLeftTimes < 1 then
		nLeftTimes = 1
	end

	Str = nStrTab[nLeftTimes]

	if pBtnFightTen:getChildByTag(199) ~= nil then

		SetStrokeLabelText(pBtnFightTen:getChildByTag(199), Str)

	else

		local pLabel = CreateStrokeLabel(36, CommonData.g_FONT1, Str, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pBtnFightTen:addChild(pLabel,199,199)

	end

	if nLeftTimes < 2 then
		pBtnFightTen:setEnabled(false)
	else
		pBtnFightTen:setEnabled(true)
	end

	if isTen == true and nLeftTimes >= 9 then
		pBtnFightTen:setEnabled(false)
	end

end]]

local function UpdateTimes( nSceneIdx, nLocalIdx, nPointId )
	local nSceneType = GetSceneType(nSceneIdx)
	local nSceneId = GetSceneId(nSceneIdx)
	local nAllTimes = 0
	local nLeftTimes = 0
	if nSceneType==DungeonsType.Normal then
		nAllTimes = GetTimes(GetPointRuleId( nPointId ))
		nLeftTimes = nAllTimes - GetPointLeftTimes(DungeonsType.Normal, m_nSceneId, nLocalIdx)
	elseif nSceneType==DungeonsType.Elite then
		nAllTimes = GetEliteTimes()
		nLeftTimes = nAllTimes - server_fubenDB.GetEliteFightedTimes()
	elseif nSceneType==DungeonsType.Activity then
		local nAllTimes = GetActivityTimes()
		local nLeftTimes =nAllTimes - GetPointLeftTimes(nSceneType, nSceneId, nil)
	end
	-- print("SceneIdx = "..nSceneIdx.."\tLocalIdx = "..nLocalIdx.."\tPointId = "..nPointId.."\tAllTimes = "..nAllTimes.."\tLeftTimes = "..nLeftTimes)
	if nAllTimes<0 then
		m_pLbTimes:setText("无限")
		m_pBtnAddTimes:setVisible(false)
		m_pBtnAddTimes:setTouchEnabled(false)
	else
		m_pLbTimes:setText(tostring(nLeftTimes).."/"..tostring(nAllTimes))
		if nLeftTimes>0 then
			m_pBtnAddTimes:setEnabled(false)
			--print("---------` 0 W 0 `: 隐藏啦 bi bi bi bi---------")
		else
			m_pBtnAddTimes:setEnabled(true)
		end
		if nSceneType==DungeonsType.Activity then
			local left_activity_times = GetActivityTimes() - GetPointLeftTimes(nSceneType, nSceneId, nil)
			m_pLbTimes:setText(tostring(left_activity_times).."/"..tostring(GetActivityTimes()))
			if left_activity_times>0 then
				m_pBtnAddTimes:setEnabled(false)
			else
				m_pBtnAddTimes:setEnabled(true)
			end
		end
	end
end

local function GetStars( nSceneIdx, nSceneId, nLocalIdx )
	local nSceneType = GetSceneType(nSceneIdx)
	local nStar = GetPointStars(nSceneType, nSceneId, nLocalIdx)

	return nStar
end

local function numIsIntab( num, tab )
	for key,value in pairs(tab) do
		if num == value then
			return true
		end
	end

	return false
end

local function FilterSameReward( pRewardTab )

	local pEndTab = {}

	local function GetSameNum( pTab, value, key, pFTab )
		local pSameNum = 0

		for k, v in pairs( pTab ) do
			if tonumber(value) == v then
				pSameNum = pSameNum + 1
			end
		end

		pEndTab[key] = {}
		pEndTab[key]["RewardId"] = value
		pEndTab[key]["Count"] = pSameNum

	end

	local pFiliterTab = {}

	for k, v in pairs(pRewardTab) do
		if numIsIntab(v, pFiliterTab) == false then
			GetSameNum( pRewardTab, v, k, pFiliterTab )
			table.insert(pFiliterTab, v)
		end
	end

	return pEndTab

end

local function UpdatePointInfo( nSceneIdx, nLocalIdx )
	local  nPointId = GetPointId(nSceneIdx, nLocalIdx)
	SetStrokeLabelText(m_pLbTitle, GetPointName(nPointId))

	m_pLbDesc:setText(GetPointDesc(nPointId))

	local nRuleId = GetPointRuleId( nPointId )
	-- print("nRuleId = "..nRuleId)
	local nNeedTili = GetNeedTiLi(nRuleId)
	m_pLbTiLi:setText(tostring(nNeedTili))
	if IsEnoughTiLi(nNeedTili)==true then
		m_pLbTiLi:setColor(ccc3(99,216,53))
	else
		m_pLbTiLi:setColor(ccc3(255,87,35))
	end

	UpdateTimes(nSceneIdx, nLocalIdx, nPointId)

	local tabRewardId = GetRewardList(nPointId)

	tabRewardId = FilterSameReward( tabRewardId ) 

	local pRewardBase = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Image_77"),"ImageView")

	--for i=1, DungeonBaseData.MAX_REWARDITEM_COUNT do
	UpdateRewardItemInfo( tabRewardId, pRewardBase ) 
	--end

	local tabMonster = GetMonsterList(nPointId)

	if #tabMonster==0 then
		for i=1, DungeonBaseData.MAX_MONSTER_COUNT do
			m_pImgMonsters[i]:setVisible(false)
		end
	else
		for i=1, DungeonBaseData.MAX_MONSTER_COUNT do
			if i<=#tabMonster then
				m_pImgMonsters[i]:setVisible(true)
				UpdateMonsterInfo(tabMonster[i], m_pImgMonsters[i])
			else
				m_pImgMonsters[i]:setVisible(false)
			end
		end
	end

	local nStarNum = GetStars(nSceneIdx ,m_nSceneId, nLocalIdx)

	local layout = tolua.cast(m_pLayerEnterPoint:getChildByTag(108), "Layout")
	if layout ~= nil and m_IsOnly == false then
		--判断如果是小关卡则不显示星星
		--先显示无星状态，再计算当前几颗星
		for i=1,3 do
			layout:getNodeByTag(i):getAnimation():gotoAndPause(0)
		end

		if nStarNum > 0 then
			for i=1,nStarNum do
				if layout:getNodeByTag(i) ~= nil then
					if nStarNum == 1 then
						if i == 1 then layout:getNodeByTag(i):getAnimation():play("Animation3") end
					elseif nStarNum == 2 then
						if i == 1 or i == 2 then layout:getNodeByTag(i):getAnimation():play("Animation3") end
					elseif nStarNum == 3 then
						layout:getNodeByTag(i):getAnimation():play("Animation3")
					end
				end 
			end	
		end	
	end
end

function UpdateLeftTimes(  )
	if m_pLbTimes ~= nil then
		local nPointId = GetPointId(m_nSceneIdx, m_nLocalIdx)
		nAllTimes_New = GetTimes(GetPointRuleId( nPointId ))
		nLeftTimes_New = nAllTimes_New - GetPointLeftTimes(DungeonsType.Normal, m_nSceneId, m_nLocalIdx)
		m_pLbTimes:setText(tostring(nLeftTimes_New).."/"..tostring(nAllTimes_New))
		--print("扫荡完后的剩余次数 = "..nLeftTimes_New)
		--print("nAllTimes_New = "..nAllTimes_New)
		if tonumber(nLeftTimes_New) <= 0 then
			m_pBtnAddTimes:setEnabled(true)
			--print("显示购买按钮")
			--Pause()
		elseif nLeftTimes_New == nAllTimes_New then
			if m_pBtnAddTimes:isVisible() == true then
				m_pBtnAddTimes:setEnabled(false)
				--print("隐藏购买按钮")
				--Pause()
			end
		end
	end
end

function UpdateLeftTimesFull(  )
	-- 将剩余次数置满
	if m_pLbTimes ~= nil then

		if GetSceneType(m_nSceneIdx) == DungeonsType.Normal then

			local nPointId = GetPointId(m_nSceneIdx, m_nLocalIdx)
			nAllTimes_New = GetTimes(GetPointRuleId( nPointId ))
			nLeftTimes_New = nAllTimes_New - GetPointLeftTimes(GetSceneType(m_nSceneIdx), m_nSceneId, m_nLocalIdx)
			m_pLbTimes:setText(tostring(nAllTimes_New).."/"..tostring(nAllTimes_New))
			SetPointLeftTimes(GetSceneType(m_nSceneIdx), m_nSceneId, m_nLocalIdx, 0)
			if m_pBtnAddTimes:isVisible() == true then
				m_pBtnAddTimes:setEnabled(false)
			end

		elseif GetSceneType(m_nSceneIdx) == DungeonsType.Elite then

			local nLeftTimes = GetEliteTimes()
			m_pLbTimes:setText(tostring(nLeftTimes).."/"..tostring(GetEliteTimes()))
			if nLeftTimes>0 then
				m_pBtnAddTimes:setVisible(false)
				m_pBtnAddTimes:setTouchEnabled(false)
			else
				m_pBtnAddTimes:setVisible(true)
				m_pBtnAddTimes:setTouchEnabled(true)
			end		
			
			EliteDungeonLayer.UpdateLeftTimesFull()	

		elseif GetSceneType(m_nSceneIdx) == DungeonsType.Activity then

			local nLeftTimes = GetActivityTimes()
			m_pLbTimes:setText(tostring(nLeftTimes).."/"..tostring(GetActivityTimes()))
			if nLeftTimes>0 then
				m_pBtnAddTimes:setVisible(false)
				m_pBtnAddTimes:setTouchEnabled(false)
			else
				m_pBtnAddTimes:setVisible(true)
				m_pBtnAddTimes:setTouchEnabled(true)
			end		

			ActivitySelectLayer.UpdateLeftTimesFull()

			ActivityLayer.UpdateLeftTimesFull()

		end


	end
end

local function _Btn_Return_EnterPoint_CallBack(  )
	--CoinInfoBar.ShowHideBar(true)
	AudioUtil.PlayBtnClick()
	m_pLayerEnterPoint:removeFromParentAndCleanup(true)
	InitVars()
end

local function _Btn_Mopup_EnterPoint_CallBack( sender, eventType )
	-- CreateTimeLayer("敬请期待！", 2)
	AudioUtil.PlayBtnClick()
	if eventType==TouchEventType.ended then
		sender:setScale(1.0)
		--1.判断体力和是否三星通关
		local nState = CheckMopup(m_nSceneIdx, m_nLocalIdx, sender:getTag())
		if nState ~= DungeonLogic.MopupState.OK then
			local strText = GetMopupStateText(nState)
			CreateTimeLayer(strText, 2)
			return
		end
		--2.如果当前可以战多次则判断剩余次数是否足够
		local nPointId = GetPointId(m_nSceneIdx, m_nLocalIdx)
		nAllTimes = GetTimes(GetPointRuleId( nPointId ))
		nLeftTimes = nAllTimes - GetPointLeftTimes(DungeonsType.Normal, m_nSceneId, m_nLocalIdx)

		if tonumber(nLeftTimes) <= 0 then
			--TipLayer.createTimeLayer("剩余次数不足", 2)
			--return
			local bVTab = MainScene.CheckVIPFunction( m_pBuyType )
			local function GoBuy( bState )
				if bState == true then
					if tonumber(server_mainDB.getMainData("gold")) < bVTab.NeedNum then
						--TipLayer.createTimeLayer("元宝不足", 2)
						GotoVip()
						return
					end
					local nPointId = GetPointId(m_nSceneIdx, m_nLocalIdx)

					MainScene.BuyCountFunction( m_pBuyType, m_nSceneId, m_nLocalIdx, UpdateLeftTimesFull )
				end
			end
			
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1629,GoBuy,bVTab.NeedNum, bVTab.name, m_pSurPlusTimes)
			pTips = nil
			return 
		end
		--3.战多次功能是否开启，判断vip等级是否足够，根据vip等级或者人物等级判断是否可以扫荡
		if sender:getTag() == 10 then
			local bVipTab = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_1)
			if tonumber(bVipTab.vipLimit) == 0 then
				--功能未开启
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1505,GotoVip,bVipTab.level, bVipTab.vipLevel)
				pTips = nil
				return 
			end
		end

		local nJudgeTimes = 1 
		if sender:getTag() == 10 then

			nJudgeTimes = nLeftTimes
		
		end

		if nJudgeTimes > 10 then
			nJudgeTimes = 10
		end

		local function MopupOver( nResult )
			NetWorkLoadingLayer.loadingHideNow()
			if nResult == 1 then

				local pMopupLyaer = MopupLayer.CreateMopupLayer()
				m_pLayerEnterPoint:addChild(pMopupLyaer, 100, 100)

				local nPointId_MopUp = GetPointId(m_nSceneIdx, m_nLocalIdx)
				nAllTimes_MopUp = GetTimes(GetPointRuleId( nPointId_MopUp ))
				nLeftTimes_MopUp = nAllTimes_MopUp - GetPointLeftTimes(DungeonsType.Normal, m_nSceneId, m_nLocalIdx)

				--刷新次数
				UpdateLeftTimes()

			else

				TipLayer.createTimeLayer("扫荡失败", 2)

			end
		end
		Packet_BattleMopUp.SetSuccessCallBack(MopupOver)
		network.NetWorkEvent(Packet_BattleMopUp.CreatPacket(m_nSceneId, m_nLocalIdx, nJudgeTimes))
		NetWorkLoadingLayer.loadingShow(true)
	elseif eventType==TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType==TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function HandleErrorState( nErrorCode )
	local strError = GetErrorCodeText(nErrorCode)
	CreateTimeLayer(strError, 2)
end

function BattleBegin( )
	if m_pLayerEnterPoint ~= nil then
		function BattleBeginOver(pServerDataStream)
			-- _Btn_Return_EnterPoint_CallBack( )
			if pServerDataStream ~= nil then 
				require "Script/Fight/BaseScene"
				BaseScene.createBaseScene()
				if NETWORKENABLE > 0 then
					BaseScene.InitServerFightData(pServerDataStream)
				else
					----add by sxin 单机测试
					BaseScene.InitTestFightData(m_nSceneId,m_nLocalIdx)
				end
				_Btn_Return_EnterPoint_CallBack( )
				NetWorkLoadingLayer.loadingHideNow()
				BaseScene.EnterBaseScene()
			end
		end

		if NETWORKENABLE > 0 then
			print("ScenedId = "..m_nSceneId.."\tLocalIdx = "..m_nLocalIdx)
			local nSceneType = GetSceneType(m_nSceneIdx)
			local nErrorCode = DungeonLogic.IsCanFight(m_nSceneId, m_nSceneIdx, m_nLocalIdx, nSceneType)
			--print("nErrorCode = "..nErrorCode)
			--Pause()
			if nErrorCode==DungeonLogic.ErrorCode.Success then
				Packet_BattleBegin.SetSuccessCallBack(BattleBeginOver)
				network.NetWorkEvent(Packet_BattleBegin.CreatPacket(m_nSceneId, m_nLocalIdx))
				NetWorkLoadingLayer.loadingShow(true)
			else
				--print("_Btn_StartFight_EnterPoint_CallBack nErrorCode =" .. nErrorCode)
				--Pause()
				HandleErrorState(nErrorCode)
			end
		else
			BattleBeginOver()
		end
	end
end

local function _Btn_StartFight_EnterPoint_CallBack( sender, eventType )
	if eventType==TouchEventType.began then
		AudioUtil.PlayBtnClick()
	end
	BattleBegin()
end

local function _Btn_AddTimes_EnterPoint_CallBack(  )
	--根据Vip等级来决定是否可以购买
	AudioUtil.PlayBtnClick()

	local bVipTab = MainScene.CheckVIPFunction( m_pBuyType )

	local nSceneType = GetSceneType(m_nSceneIdx)

	if nSceneType == DungeonsType.Normal then

		m_pBuyType = enumVIPFunction.eVipFunction_11
		--当前可购买的剩余次数
		m_pSurPlusTimes = server_fubenDB.GetNormalFubenCanBuySurPlusTimes(m_nSceneId, m_nLocalIdx)

		--[[print(m_nSceneId, m_nLocalIdx, m_pSurPlusTimes)
		Pause()]]

	elseif nSceneType == DungeonsType.Elite then

		m_pBuyType = enumVIPFunction.eVipFunction_12

		m_pSurPlusTimes = server_mainDB.getMainData("VipFuben")

	elseif nSceneType == DungeonsType.Activity then

		m_pBuyType = enumVIPFunction.eVipFunction_13

		m_pSurPlusTimes = server_mainDB.getMainData("VipActivity")

	end

	if m_pSurPlusTimes > 0 then
		--弹出是否购买的Vip页面
		--printTab(bVipTab)
		--Pause()
		local function GoBuy( bState )
			if bState == true then
				if tonumber(server_mainDB.getMainData("gold")) < bVipTab.NeedNum then
					--TipLayer.createTimeLayer("元宝不足", 2)
					GotoVip()
					return
				end
				local nPointId = GetPointId(m_nSceneIdx, m_nLocalIdx)

				MainScene.BuyCountFunction( m_pBuyType, m_nSceneId, m_nLocalIdx, UpdateLeftTimesFull )
			end
		end
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1629,GoBuy,bVipTab.NeedNum, bVipTab.name, m_pSurPlusTimes)
		pTips = nil
	else
		--弹出去充值的vip页面
		--print("m_pSurPlusTimes = "..m_pSurPlusTimes)
		local pTips = TipCommonLayer.CreateTipLayerManager()
		--print(bVipTab.level, bVipTab.nextVIP, bVipTab.nextNum)
		if tonumber(bVipTab.level) <= 0 then
			pTips:ShowCommonTips(1644,GotoVip,bVipTab.nextVIP, bVipTab.nextNum)
			pTips = nil
		else
			if tonumber( bVipTab.most_Tap ) == 0 then
				pTips:ShowCommonTips(1649,nil,bVipTab.nextVIP, bVipTab.nextNum)
				pTips = nil
			else
				pTips:ShowCommonTips(1506, GotoVip, bVipTab.nextVIP, bVipTab.nextNum)
				pTips = nil	
			end
		end
	end
end

local function _Btn_CheckResult_EnterPoint_CallBack(  )
	CreateTimeLayer("敬请期待！", 2)
end  

local function InitWidgets( nSceneIdx )
	m_pLayerEnterPoint = TouchGroup:create()
	m_pLayerEnterPoint:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/EnterPointLayer.json"))

	local pImgPointName =  tolua.cast(m_pLayerEnterPoint:getWidgetByName("Image_Title"),"ImageView")
	if pImgPointName==nil then
		print("pImgPointName is nil")
		return false
	else
		m_pLbTitle = CreateStrokeLabel(24, CommonData.g_FONT1, "标题", ccp(0, 0), ccc3(49, 16, 7), ccc3(254, 225, 78), true, ccp(0, -2), 2)
		pImgPointName:addChild(m_pLbTitle)
	end

	m_pLbDesc = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Label_Desc"),"Label")
	if m_pLbDesc==nil then
		print("m_pLbDesc is nil")
		return false
	end

	m_pLbTiLi = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Label_TiLi"),"Label")
	if m_pLbTiLi==nil then
		print("m_pLbTiLi is nil")
		return false
	end

	m_pLbTimes = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Label_LeftTimes"),"Label")
	if m_pLbTimes==nil then
		print("m_pLbTimes is nil")
		return false
	end

	local pBtnReturn = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Button_Retrun"),"Button")
	if pBtnReturn==nil then
		print("pBtnReturn is nil")
		return false
	else
		CreateBtnCallBack(pBtnReturn, nil, nil, _Btn_Return_EnterPoint_CallBack)
	end

	local pBtnFightTen = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Button_Fight_10"),"Button")
	local nSceneType = GetSceneType(nSceneIdx)
	if nSceneType == DungeonsType.Activity or nSceneType == DungeonsType.Elite then 
		pBtnFightTen:setVisible(false) 
		pBtnFightTen:setTouchEnabled(false)
	else
		pBtnFightTen:setVisible(true) 
		pBtnFightTen:setTouchEnabled(true)		
	end
	if pBtnFightTen==nil then
		print("pBtnFightTen is nil")
		return false
	else
		pBtnFightTen:setTag(10)
		--判断当前副本可以战几次
		local nPointId = GetPointId(m_nSceneIdx, m_nLocalIdx)
		nAllTimes = GetTimes(GetPointRuleId( nPointId ))
		nLeftTimes = nAllTimes - GetPointLeftTimes(DungeonsType.Normal, m_nSceneId, m_nLocalIdx)

		local pLabel = CreateStrokeLabel(36, CommonData.g_FONT1, "战十次", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pBtnFightTen:addChild(pLabel,199,199)
		pBtnFightTen:addTouchEventListener(_Btn_Mopup_EnterPoint_CallBack)
		local Label_12 = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Label_12"),"Label")
		if m_IsOnly == true then
			pBtnFightTen:setEnabled(false)
			m_pLbTimes:setVisible(false)
			Label_12:setVisible(false)
		else
			pBtnFightTen:setEnabled(true)
			m_pLbTimes:setVisible(true)
			Label_12:setVisible(true)			
		end

	end

	local pBtnFightOne = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Button_Fight_1"),"Button")
	if pBtnFightOne==nil then
		print("pBtnFightOne is nil")
		return false
	else
		pBtnFightOne:setTag(1)
		local pLabel = CreateStrokeLabel(36, CommonData.g_FONT1, "战1次", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pBtnFightOne:addChild(pLabel)
		pBtnFightOne:addTouchEventListener(_Btn_Mopup_EnterPoint_CallBack)
	end
	if nSceneType == DungeonsType.Activity or nSceneType == DungeonsType.Elite then 
		pBtnFightOne:setVisible(false) 
		pBtnFightOne:setTouchEnabled(false)
	else
		pBtnFightOne:setVisible(true) 
		pBtnFightOne:setTouchEnabled(true)		
	end

	if m_IsOnly == true then
		pBtnFightOne:setEnabled(false)
	else
		pBtnFightOne:setEnabled(true)		
	end

	local pBtnStartFight = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Button_StartFight"),"Button")
	if pBtnStartFight==nil then
		print("pBtnStartFight is nil")
		return false
	else
		CreateBtnCallBack(pBtnStartFight, nil, nil, _Btn_StartFight_EnterPoint_CallBack)
	end

	m_pBtnAddTimes = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Button_AddTimes"),"Button")
	if m_pBtnAddTimes==nil then
		print("m_pBtnAddTimes is nil")
		return false
	else
		CreateBtnCallBack(m_pBtnAddTimes, nil, nil, _Btn_AddTimes_EnterPoint_CallBack)
	end

	local pBtnCheckResult = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Button_CheckResult"),"Button")
	if pBtnCheckResult==nil then
		print("pBtnCheckResult is nil")
		return false
	else
		CreateBtnCallBack(pBtnCheckResult, nil, nil, _Btn_CheckResult_EnterPoint_CallBack)
	end

	local pImg = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Image_25"), "ImageView")
	if pImg==nil then
		print("pImg is nil")
		return false
	else
		local pLabel = CreateStrokeLabel(20, CommonData.g_FONT1, "查看战报", ccp(0, 0), COLOR_Black, ccc3(175,175,175), true, ccp(0, -2), 2)
		pImg:addChild(pLabel)
	end
	local bVipTab = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_1)

	local Label_VIP_Lv = tolua.cast(m_pLayerEnterPoint:getWidgetByName("Label_VIP_Lv"), "Label")
	Label_VIP_Lv:setText( "VIP "..bVipTab.vipLevel ) 

	--[[for i=1, DungeonBaseData.MAX_REWARDITEM_COUNT do
		m_pImgRewardItems[i]=tolua.cast(m_pLayerEnterPoint:getWidgetByName("Image_Reward_"..tostring(i)), "ImageView")
		if m_pImgRewardItems[i]==nil then
			print("m_pImgRewardItems_"..tostring(i).."is nil")
			return false
		end
	end]]

	for i=1, DungeonBaseData.MAX_MONSTER_COUNT  do
		m_pImgMonsters[i]=tolua.cast(m_pLayerEnterPoint:getWidgetByName("Image_HeadIcon_"..tostring(i)), "ImageView")
		if m_pImgMonsters[i]==nil then
			print("m_pImgMonsters_"..tostring(i).."is nil")
			return false
		end
	end

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/UI/Animation/Fight_Win_001_lq.ExportJson")
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:setPosition(ccp(435,530 - CommonData.g_Origin.y))

	if m_IsOnly == false then
		for i=1,3 do
			local PayArmature = CCArmature:create("Fight_Win_001_lq")
			PayArmature:getAnimation():play("Animation3")
			--PayArmature:getAnimation():gotoAndPause(0)
			if i == 2 then
				PayArmature:setScale(1)
				PayArmature:setPosition(ccp(i * 75,-10))
			else
				PayArmature:setScale(0.85)
				PayArmature:setPosition(ccp(i * 75,5))
			end
			layout:addNode(PayArmature,1,i)
			if PayArmature == nil then
				return false
			end
		end
		m_pLayerEnterPoint:addChild(layout,1,108)
	end
	return true
end

function CreateEnterPointLayer( nSceneIdx, nLocalIdx )
	InitVars()

	local nPointId = GetPointId(nSceneIdx, nLocalIdx)
	local nPointRuleId = GetPointRuleId(nPointId)
	m_IsOnly = IsOnly(nPointRuleId)

	m_nSceneIdx = nSceneIdx
	m_nSceneId = GetSceneId(nSceneIdx)
	m_nLocalIdx = nLocalIdx

	local nSceneType = GetSceneType(m_nSceneIdx)

	--当前的购买类型
	m_pBuyType = enumVIPFunction.eVipFunction_11

	
	if nSceneType == DungeonsType.Normal then

		m_pBuyType = enumVIPFunction.eVipFunction_11
		--当前可购买的剩余次数
		m_pSurPlusTimes = server_fubenDB.GetNormalFubenCanBuySurPlusTimes(m_nSceneId, m_nLocalIdx)

	elseif nSceneType == DungeonsType.Elite then

		m_pBuyType = enumVIPFunction.eVipFunction_12

		m_pSurPlusTimes = server_mainDB.getMainData("VipFuben")

	elseif nSceneType == DungeonsType.Activity then

		m_pBuyType = enumVIPFunction.eVipFunction_13

		m_pSurPlusTimes = server_mainDB.getMainData("VipActivity")

	end

	if InitWidgets( nSceneIdx )==false then
		return
	end

	--CoinInfoBar.ShowHideBar(false)
		
	UpdatePointInfo(nSceneIdx, nLocalIdx)
	return m_pLayerEnterPoint
end

function GetFightSceneId()
	return m_nSceneId
end

function GetFightIndexId()
	return m_nLocalIdx
end
