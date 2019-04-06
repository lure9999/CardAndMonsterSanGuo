require "Script/Common/Common"
require "Script/Common/UnitTime"
require "Script/Audio/AudioUtil"
require "Script/Main/LuckyDraw/LuckyDrawLogic"
require "Script/Main/LuckyDraw/LuckyDrawItemLayer"

module("LuckyDrawLayer", package.seeall)

-- 存储抽卡之前的武将列表，用于判断是否抽到新的武将
local m_tabOldGeneral = nil

local m_pLayerLcukyDraw = nil
local m_pLabelSliver = nil
local m_pLabelGold = nil
local m_pLabelSliverFreeTimes = nil
local m_pLabelGoldFreeTimes = nil
local m_FreeTime_1 = nil
local m_FreeTime_2 = nil

local getMainData						= server_mainDB.getMainData
local CreateStrokeLabel 				= LabelLayer.createStrokeLabel
local SetStrokeLabelText				= LabelLayer.setText
local GetPubIndex						= LuckyDrawLogic.GetPubIndex
local GetConsumeResult					= LuckyDrawLogic.GetConsumeResult
local GetSliverPubTime					= LuckyDrawLogic.GetSliverPubTime
local GetGoldPubTime					= LuckyDrawLogic.GetGoldPubTime
local HandleTipLayer					= LuckyDrawLogic.HandleTipLayer

local GetTimeString						= UnitTime.GetTimeString

local function  InitVars()
	m_pLayerLcukyDraw = nil
	m_pLabelSliver = nil
	m_pLabelGold = nil
	m_pLabelSliverFreeTimes = nil
	m_pLabelGoldFreeTimes = nil
 	m_FreeTime_1 = nil
 	m_FreeTime_2 = nil
end

local function _BtnBack_LuckyDraw_CallBack(  )
	m_pLayerLcukyDraw:removeFromParentAndCleanup(true)
	InitVars()
	MainScene.PopUILayer()
end

local function UpdateBtnLabel( pBtnLabel, nFreeTimes ,sub_time)
	if nFreeTimes > 0 then
		if tonumber(sub_time) > 0 then
			SetStrokeLabelText(pBtnLabel, "买一次")
		else
			SetStrokeLabelText(pBtnLabel, "免费")
		end
	else
		SetStrokeLabelText(pBtnLabel, "买一次")
	end
end

local function UpdateCountDown( pLabelTime, pBtnLabel, strTimeType, strTimesType, nPubTime,nCoinType)
	--[[local nOldTime = getMainData(strTimeType)
	local nNowTime = os.time()
	local nRefreshTime = nPubTime + nOldTime - nNowTime]]
	local FreeCount = getMainData(strTimesType)
	-- local nRefreshTime = getMainData(strTimeType)
	local nRefreshTime = nPubTime
	print(strTimeType,nRefreshTime)
	Pause()
	
	local function SubTime(  )
		pLabelTime:setText(GetTimeString(nRefreshTime)) --nRefreshTime
		local pArrAction = CCArray:create()
		local function CountDown( )
			pLabelTime:setText("免费倒计时："..GetTimeString(nRefreshTime))
			nRefreshTime = nRefreshTime - 1
			if nRefreshTime<=0 then
				pLabelTime:stopAllActions()
				local nFreeTimes = getMainData(strTimesType)
				if nFreeTimes>0 then
					pLabelTime:setText("免费次数："..tostring(nFreeTimes))
				end
				UpdateBtnLabel(pBtnLabel, nFreeTimes,nRefreshTime)
				return
			end
		end
		pArrAction:addObject(CCCallFunc:create(CountDown))
		pArrAction:addObject(CCDelayTime:create(1))
		pLabelTime:stopAllActions()
		pLabelTime:runAction(CCRepeatForever:create(CCSequence:create(pArrAction)))
	end
	if tonumber(nCoinType) == 1 then
		if tonumber(FreeCount) == 0 then
			pLabelTime:setText("今日免费次数已经用完")
		else
			if tonumber(nPubTime) > 0 then
				SubTime()
			end
		end
	elseif tonumber(nCoinType) == 2 then
		SubTime()
	end
	--[[if tonumber(FreeCount) == 0 and tonumber(nCoinType) == 0 then
		pLabelTime:setText("今日免费次数已经用完")
	else
		pLabelTime:setText(GetTimeString(nPubTime)) --nRefreshTime
		local pArrAction = CCArray:create()
		local function CountDown( )
			pLabelTime:setText("免费倒计时："..GetTimeString(nRefreshTime))
			nRefreshTime = nRefreshTime - 1
			if nRefreshTime<=0 then
				pLabelTime:stopAllActions()
				local nFreeTimes = getMainData(strTimesType)
				if nFreeTimes>0 then
					pLabelTime:setText("免费次数："..tostring(nFreeTimes))
				end
				UpdateBtnLabel(pBtnLabel, nFreeTimes)
				return
			end
		end
		pArrAction:addObject(CCCallFunc:create(CountDown))
		pArrAction:addObject(CCDelayTime:create(1))
		pLabelTime:stopAllActions()
		pLabelTime:runAction(CCRepeatForever:create(CCSequence:create(pArrAction)))
	end]]--
end

local function UpdateTimesData(  )
	local m_FreeTime_1 = server_mainDB.getMainData("nLuckydrawNum_Sliver")
	local nSliver = server_mainDB.getMainData("nLuckydrawNum_Sliver")
	local sliver_time = server_LuckyOpenDB.GetServerTime()
	if tonumber(m_FreeTime_1) == 0 then
		UpdateCountDown(m_pLabelSliverFreeTimes, m_pLabelSliver, "nCountDown_Sliver", "nLuckydrawNum_Sliver", sliver_time,1) --GetSliverPubTime()
	else
		if tonumber(m_FreeTime_1) ~= 0 and tonumber(sliver_time) > 0 then
			UpdateCountDown(m_pLabelSliverFreeTimes, m_pLabelSliver, "nCountDown_Sliver", "nLuckydrawNum_Sliver", sliver_time,1) --GetSliverPubTime()
	
		else
			m_pLabelSliverFreeTimes:setText("免费次数："..tostring(m_FreeTime_1))
		end
	end

	local m_FreeTime_2 = server_mainDB.getMainData("nLuckydrawNum_Gold")
	local nGold = server_mainDB.getMainData("nLuckydrawNum_Gold")
	local gold_time = server_LuckyOpenDB.GetGoldTime()
	if tonumber(m_FreeTime_2) == 0 then
		UpdateCountDown(m_pLabelGoldFreeTimes, m_pLabelGold, "nCountDown_Gold", "nLuckydrawNum_Gold",gold_time,2 ) --GetGoldPubTime()
	else
		if tonumber(m_FreeTime_2) ~= 0 and tonumber(gold_time) > 0 then
			UpdateCountDown(m_pLabelGoldFreeTimes, m_pLabelGold, "nCountDown_Gold", "nLuckydrawNum_Gold",gold_time,2 ) --GetGoldPubTime()
	
		else
			m_pLabelGoldFreeTimes:setText("免费次数："..tostring(m_FreeTime_2))
		end
	end

	UpdateBtnLabel(m_pLabelSliver, m_FreeTime_1,sliver_time)
	UpdateBtnLabel(m_pLabelGold, m_FreeTime_2,sliver_time)

	return nSliver,nGold
end

local function UpdateCostData(  )
	local nSliverIndex = GetPubIndex(PubType.Sliver)
	local pLabelSliverOneCost = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Label_SliverOneCost"), "Label")
	local bOneSliverEnough, nOneSliverItemNeedNum = GetConsumeResult(nSliverIndex, 1, PubType.Sliver)
	pLabelSliverOneCost:setText(tostring(nOneSliverItemNeedNum))

	local pLabelSliverTenCost = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Label_SliverTenCost"), "Label")
	local bTenSliverEnough, nTenSliverItemNeedNum = GetConsumeResult(nSliverIndex, 10, PubType.Sliver)
	pLabelSliverTenCost:setText(tostring(nTenSliverItemNeedNum))

	local nGoldIndex = GetPubIndex(PubType.Gold)
	local pLabelGoldOneCost = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Label_GoldOneCost"), "Label")
	local bOneGoldEnough, nOneGoldItemNeedNum = GetConsumeResult(nGoldIndex, 1, PubType.Gold)
	pLabelGoldOneCost:setText(tostring(nOneGoldItemNeedNum))

	local pLabelGoldTenCost = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Label_GoldTenCost"), "Label")
	local bTenGoldEnough, nTenGoldItemNeedNum = GetConsumeResult(nGoldIndex, 10, PubType.Gold)
	pLabelGoldTenCost:setText(tostring(nTenGoldItemNeedNum))
end

local function HandleBuyUILogic(pSender, strLcukDrawType, nPubType)
	local nCount = 0
	local bEnough  = true
	local nItemNeedNum = 0
	if pSender:getTag()==1 then
		nCount = 1
		if getMainData(strLcukDrawType)<1 then
			bEnough, nItemNeedNum = GetConsumeResult(GetPubIndex(nPubType), nCount, nPubType)
			if bEnough==false then
				HandleTipLayer(nPubType)
				return
			end
		end
	elseif pSender:getTag()==10 then
		nCount = 10
		bEnough, nItemNeedNum = GetConsumeResult(GetPubIndex(nPubType), nCount, nPubType)
		if bEnough==false then
			HandleTipLayer(nPubType)
			return
		end
	end
	local nFreeT = nil 

	local function BuyOver()
		NetWorkLoadingLayer.loadingHideNow()
		local nS,nG = UpdateTimesData()

		if tostring(strLcukDrawType) == "nLuckydrawNum_Sliver" then
			nFreeT = nS

		elseif tostring(strLcukDrawType) == "nLuckydrawNum_Gold" then
			nFreeT = nG
		end

		local  pLuckyDrawItemLayer = LuckyDrawItemLayer.CreateLuckyDrawLayer(nPubType, nCount, m_tabOldGeneral, UpdateTimesData, nFreeT, m_tabOldGeneral)
		m_pLayerLcukyDraw:addChild(pLuckyDrawItemLayer)
	end

	m_tabOldGeneral = server_generalDB.GetCopyTable()

	Packet_LuckyDraw.SetSuccessCallBack(BuyOver)
	network.NetWorkEvent(Packet_LuckyDraw.CreatPacket(nPubType, nCount))
	NetWorkLoadingLayer.loadingShow(true)
end

local function _BtnSliver_LuckyDraw_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		if m_pLayerLcukyDraw:getChildByTag(1990) ~= nil then
			m_pLayerLcukyDraw:getChildByTag(1990):removeFromParentAndCleanup(true)
		end
		HandleBuyUILogic(sender, "nLuckydrawNum_Sliver", PubType.Sliver)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _BtnGold_LuckyDraw_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		if m_pLayerLcukyDraw:getChildByTag(1990) ~= nil then
			m_pLayerLcukyDraw:getChildByTag(1990):removeFromParentAndCleanup(true)
		end
		HandleBuyUILogic(sender, "nLuckydrawNum_Gold", PubType.Gold)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function GetLuckyDrawByNewGuilde( nType, nCallBack_1, nCallBack_2 )

	local pSender = ImageView:create()
	pSender:setTag(1)

	if tonumber(nType) == 0 then
		--银币抽奖
		LuckyDrawItemLayer.SetNewGuildeCallBack(nCallBack_1, nCallBack_2)
		--HandleBuyUILogic(pSender, "nLuckydrawNum_Sliver", PubType.Sliver)
		local function BuyOver()
			NetWorkLoadingLayer.loadingHideNow()
			local nS,nG = UpdateTimesData()

			local nFreeT = nS 

			local pLuckyDrawItemLayer = LuckyDrawItemLayer.CreateLuckyDrawLayer(PubType.Sliver, 1, m_tabOldGeneral, UpdateTimesData, nFreeT, m_tabOldGeneral)
			m_pLayerLcukyDraw:addChild(pLuckyDrawItemLayer)
		end

		Packet_LuckyDraw.SetSuccessCallBack(BuyOver)
		NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_2)

	elseif tonumber(nType) == 1 then
		--金币抽奖
		LuckyDrawItemLayer.SetNewGuildeCallBack(nCallBack_1, nCallBack_2)
		--HandleBuyUILogic(pSender, "nLuckydrawNum_Gold", PubType.Gold)
		local function BuyOver()
			NetWorkLoadingLayer.loadingHideNow()
			local nS,nG = UpdateTimesData()

			local nFreeT = nG

			local pLuckyDrawItemLayer = LuckyDrawItemLayer.CreateLuckyDrawLayer(PubType.Gold, 1, m_tabOldGeneral, UpdateTimesData, nFreeT, m_tabOldGeneral)
			m_pLayerLcukyDraw:addChild(pLuckyDrawItemLayer)
		end

		Packet_LuckyDraw.SetSuccessCallBack(BuyOver)
		NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_3)
	elseif tonumber(nType) == 2 then
		--退出界面
		m_pLayerLcukyDraw:removeFromParentAndCleanup(true)
		InitVars()
		MainScene.PopUILayer()
	elseif tonumber(nType) == 3 then
		--退出武将展示界面
		LuckyDrawItemLayer.HideWJShow()
	elseif tonumber(nType) == 4 then
		--退出抽奖展示界面
		LuckyDrawItemLayer.ExitShowList()
	end

end

local function InitWidgets()
	m_pLayerLcukyDraw = TouchGroup:create()
	m_pLayerLcukyDraw:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/BuyCardLayer.json" ) )

	local pBtnBack = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Button_Back"), "Button")
	if pBtnBack==nil then
		print("pBtnBack is nil")
		return false
	else
		CreateBtnCallBack(pBtnBack, nil, nil, _BtnBack_LuckyDraw_CallBack)
	end

	local pBtnSliverOne = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Button_Sliver_One"), "Button")
	if pBtnSliverOne==nil then
		print("pBtnSliverOne is nil")
		return false
	else
		m_pLabelSliver = CreateStrokeLabel(36, CommonData.g_FONT1, "免费", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pBtnSliverOne:addChild(m_pLabelSliver)
		pBtnSliverOne:setTag(1)
		pBtnSliverOne:addTouchEventListener(_BtnSliver_LuckyDraw_CallBack)
	end

	local pBtnSliverTen = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Button_Sliver_Ten"), "Button")
	if pBtnSliverTen==nil then
		print("pBtnSliverTen is nil")
		return false
	else
		local pLabelSliver = CreateStrokeLabel(36, CommonData.g_FONT1, "十连抽", ccp(0, 0), COLOR_Black, ccc3(254,244,84), true, ccp(0, -2), 2)
		pBtnSliverTen:addChild(pLabelSliver)
		pBtnSliverTen:setTag(10)
		pBtnSliverTen:addTouchEventListener(_BtnSliver_LuckyDraw_CallBack)
	end

	local pBtnGoldOne = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Button_Gold_One"), "Button")
	if pBtnGoldOne==nil then
		print("pBtnGoldOne is nil")
		return false
	else
		m_pLabelGold = CreateStrokeLabel(36, CommonData.g_FONT1, "免费", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pBtnGoldOne:addChild(m_pLabelGold)
		pBtnGoldOne:setTag(1)
		pBtnGoldOne:addTouchEventListener(_BtnGold_LuckyDraw_CallBack)
	end

	local pBtnGoldTen = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Button_Gold_Ten"), "Button")
	if pBtnGoldTen==nil then
		print("pBtnGoldTen is nil")
		return false
	else
		local pLabelGold = CreateStrokeLabel(36, CommonData.g_FONT1, "十连抽", ccp(0, 0), COLOR_Black, ccc3(254,244,84), true, ccp(0, -2), 2)
		pBtnGoldTen:addChild(pLabelGold)
		pBtnGoldTen:setTag(10)
		pBtnGoldTen:addTouchEventListener(_BtnGold_LuckyDraw_CallBack)
	end

	local pSliverPanel = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Panel_Sliver"), "Layout")
	if pSliverPanel==nil then
		print("pSliverPanel is nil")
		return false
	else
		local pLabel = CreateStrokeLabel(30, CommonData.g_FONT1, "十连抽必送", ccp(210, 518), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pSliverPanel:addChild(pLabel)
	end

	local pGoldPanel = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Panel_Gold"), "Layout")
	if pGoldPanel==nil then
		print("pGoldPanel is nil")
		return false
	else
		local pLabel = CreateStrokeLabel(30, CommonData.g_FONT1, "十连抽必送", ccp(210, 518), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		pGoldPanel:addChild(pLabel)
	end

	local pImageSliverBg = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Image_SliverBg"), "ImageView")
	if pImageSliverBg==nil then
		print("pImageSliverBg is nil")
		return false
	else
		pImageSliverBg:runAction(CCRepeatForever:create(CCRotateBy:create(3, 360)))
	end

	local pImageGoldBg = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Image_GoldBg"), "ImageView")
	if pImageGoldBg==nil then
		print("pImageGoldBg is nil")
		return false
	else
		pImageGoldBg:runAction(CCRepeatForever:create(CCRotateBy:create(3, 360)))
	end

	m_pLabelSliverFreeTimes = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Label_SliverFreeTimes"), "Label")
	if m_pLabelSliverFreeTimes==nil then
		print("m_pLabelSliverFreeTimes is nil")
		return false
	end

	m_pLabelGoldFreeTimes = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Label_GoldFreeTimes"), "Label")
	if m_pLabelGoldFreeTimes==nil then
		print("m_pLabelGoldFreeTimes is nil")
		return false
	end

	return true
end
--nTypeID : 0 = 任意， 1 = 银币酒馆, 2 = 金币酒馆
function GotoManagerCallFuncByJiuGuan( nTypeID )
	if nTypeID == 0 then
		nTypeID = 1 
	end

	local nPt = ccp(0,0)
	if nTypeID == 1 then
		local pSliverPanel = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Panel_Sliver"), "Layout")
		nPt.x = pSliverPanel:getPositionX()
		nPt.y = pSliverPanel:getPositionY()
	elseif nTypeID == 2 then
		local pGoldPanel = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Panel_Gold"), "Layout")
		nPt.x = pGoldPanel:getPositionX()
		nPt.y = pGoldPanel:getPositionY()
	else
		local pGoldPanel = tolua.cast(m_pLayerLcukyDraw:getWidgetByName("Panel_Gold"), "Layout")
		nPt.x = pGoldPanel:getPositionX()
		nPt.y = pGoldPanel:getPositionY()		
	end

	--指引点击效果
	if m_pLayerLcukyDraw:getChildByTag(1990) ~= nil then
		m_pLayerLcukyDraw:getChildByTag(1990):removeFromParentAndCleanup(true)
	end

    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/zhiyin01.ExportJson")
	local GuideAnimation = CCArmature:create("zhiyin01")
	GuideAnimation:getAnimation():play("Animation1")

	GuideAnimation:setPosition(ccp(nPt.x + 210, nPt.y + 220))

	m_pLayerLcukyDraw:addChild(GuideAnimation, 1990, 1990)


end

function CreateLuckyDrawLayer(  )
	InitVars()
	if InitWidgets()==false then
		return
	end
	m_tabOldGeneral = server_generalDB.GetCopyTable()
	UpdateCostData()
	UpdateTimesData()
	return m_pLayerLcukyDraw
end