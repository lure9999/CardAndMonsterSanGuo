require "Script/Common/Common"
require "Script/Main/MissionNormal/MissionNormalData"
require "Script/Main/MissionNormal/MissionNormalLogic"
require "Script/Main/MissionNormal/MissionNormalRewardLayer"
require "Script/Common/UIGotoManager"

module("MissionNormalLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 

local MainScene_PopUILayer				= 	MainScene.PopUILayer

local GetBoxScore						=	MissionNormalData.GetBoxScore
local GetBoxMaxScore					=	MissionNormalData.GetBoxMaxScore
local GetMissionName					=	MissionNormalData.GetMissionName
local GetMissionText					=	MissionNormalData.GetMissionText
local GetMissionIcon					=	MissionNormalData.GetMissionIcon
local GetMissionRewardIcon				=	MissionNormalData.GetMissionRewardIcon
local GetMisiionOrderRewID				=	MissionNormalData.GetMisiionOrderRewID
local GetMissionPath					=	MissionNormalData.GetMissionPath
local GetCondNum						=	MissionNormalData.GetCondNum
local GetCurSocre						=	MissionNormalData.GetCurSocre
local GetBoxState						=	MissionNormalData.GetBoxState
local GetBoxRewardID					=	MissionNormalData.GetBoxRewardID
local GetMissionTab						=	MissionNormalData.GetMissionTab
local GetRewCondID						=	MissionNormalData.GetRewCondID
local GetRewType						=	MissionNormalData.GetRewType
local GetRewPara						=	MissionNormalData.GetRewPara
local GetRewDataByID					=	MissionNormalData.GetRewDataByID
local GetMissionRewardData				=	MissionNormalData.GetMissionRewardData
local GetMissionRewardDataNum			=	MissionNormalData.GetMissionRewardDataNum
local GetMissionRewardItemData			=	MissionNormalData.GetMissionRewardItemData
local GetMissionRewardItemDataNum		=	MissionNormalData.GetMissionRewardItemDataNum
local GetRewardPath						=	MissionNormalData.GetRewardPath
local GetGotoUIID						=	MissionNormalData.GetGotoUIID
local GetCoinName						=	MissionNormalData.GetCoinName
local GetPromptState					=	MissionNormalData.GetPromptState
local GetTaskExampleID					=	MissionNormalData.GetTaskExampleID
local GetTaskIntergal					=	MissionNormalData.GetTaskIntergal
local GetDailyMissionCmd				=	MissionNormalData.GetDailyMissionCmd
local GetMissionRewardRes				=	MissionNormalData.GetMissionRewardRes
--主线数据
local GetMainLineTab 					=	MissionNormalData.GetMainLineTab
local GetTaskExampleID_MainLine			=	MissionNormalData.GetTaskExampleID_MainLine
local GetGotoUIID_MainLine 				=	MissionNormalData.GetGotoUIID_MainLine
local GetMainLineUnlockText				=	MissionNormalData.GetMainLineUnlockText
local GetTaskGroupID_MainLine			=	MissionNormalData.GetTaskGroupID_MainLine
local GetMainMissionCmd					=	MissionNormalData.GetMainMissionCmd
--国战任务数据
local GetMissionCountryWarState			=	MissionNormalData.GetMissionCountryWarState
local GetMissionCountryWarType			=	MissionNormalData.GetMissionCountryWarType
local GetMissionCountryWarTime			=	MissionNormalData.GetMissionCountryWarTime
local GetMissionCWarDB					=	MissionNormalData.GetMissionCWarDB
local GetCityName						=	MissionNormalData.GetCityName
local GetMissionCountryWarSurPlusTime	=   MissionNormalData.GetMissionCountryWarSurPlusTime
local GetCWarMissionReleaseTime			=	MissionNormalData.GetCWarMissionReleaseTime
local GetCWarArrayDB					=	MissionNormalData.GetCWarArrayDB
local GetCoinResID						=	MissionNormalData.GetCoinResID
local GetItemResID						=	MissionNormalData.GetItemResID
--国家升级任务数据
local GetMissionCountryWarState_LevelUp	=	MissionNormalData.GetMissionCountryWarState_LevelUp
local GetMissionCountryWarType_LevelUp	=	MissionNormalData.GetMissionCountryWarType_LevelUp
local GetMissionDB_LevelUp 				=	MissionNormalData.GetMissionDB_LevelUp
local GetCWarArrayDB_LevelUp			=	MissionNormalData.GetCWarArrayDB_LevelUp
--国家试炼任务
local GetMissionShiLianWarState			=	MissionNormalData.GetMissionShiLianWarState
local GetMissionCountryWarType_ShiLian	=	MissionNormalData.GetMissionCountryWarType_ShiLian
local GetMissionDB_ShiLian				=	MissionNormalData.GetMissionDB_ShiLian
local GetCWarArrayDB_ShiLian			=	MissionNormalData.GetCWarArrayDB_ShiLian
local GetMissionShiLianSurPlusTime		=	MissionNormalData.GetMissionShiLianSurPlusTime
local GetMissionShiLianTime 			=	MissionNormalData.GetMissionShiLianTime
--军团任务数据
local GetCorpsMission_SurPlusFinishTimes=	MissionNormalData.GetCorpsMission_SurPlusFinishTimes
local GetCorpsMission_FreeRefreshTimes	=	MissionNormalData.GetCorpsMission_FreeRefreshTimes
local GetCorpsMission_TopFinishTimes	=	MissionNormalData.GetCorpsMission_TopFinishTimes
local GetCorpsMission_MissionDB			=	MissionNormalData.GetCorpsMission_MissionDB
local GetCorpsMission_RefreshConfuse	=	MissionNormalData.GetCorpsMission_RefreshConfuse
local GetItemNameByItemID				=	MissionNormalData.GetItemNameByItemID
local GetCoinNameByConsumeType			=	MissionNormalData.GetCoinNameByConsumeType
local GetMissionCond_2Info				=	MissionNormalData.GetMissionCond_2Info

local GetScoreStage						=	MissionNormalLogic.GetScoreStage
local SortMissionByState				=	MissionNormalLogic.SortMissionByState
local SortMissionByState_2				=	MissionNormalLogic.SortMissionByState_2
local ShowGoodsLayer					=	MissionNormalLogic.ShowGoodsLayer
local DelGoodLayer						=	MissionNormalLogic.DelGoodLayer
local UpdateListItem					=	MissionNormalLogic.UpdateListItem
local GetRewardIDByTaskID				=	MissionNormalLogic.GetRewardIDByTaskID
local GetRewardIDByTaskIDByMainLine		=	MissionNormalLogic.GetRewardIDByTaskIDByMainLine
--local JudgeCondtion						=	MissionNormalLogic.JudgeCondtion

local CreateTipLayerManager				= TipCommonLayer.CreateTipLayerManager

local m_MissionNormalLayer 					= nil
local m_CurType 		   					= nil
local m_LoadMainLineFinish 					= nil
local m_LoadDailyFinish    					= nil
local m_TabMissionIndex    					= nil
local m_CurTagCutNum 	   					= nil
local m_Panel_Daily        					= nil
local m_Panel_MainLine     					= nil
local m_Panel_CountryWar   					= nil
local m_Panel_Corps 						= nil
local m_Panel_Special 						= nil
local m_ListView_MissionList  		   		= nil
local m_ListView_MissionList_MainLine    	= nil
local m_ListView_MissionList_CountryWar  	= nil
local m_ListView_MissionList_Special	  	= nil
local m_Image_DailyBtn 						= nil
local m_Image_MainLineBtn 					= nil
local m_Image_CountryWarBtn 				= nil
local m_Image_CorpsBtn 						= nil
local m_Image_SpecialBtn 					= nil
local m_nHanderTime 						= nil
--local m_nDelayTime							= nil
local m_IsCorpsComeIn						= nil 	--从军团场景进入
local m_IsCWarComeIn						= nil 	--从国战场景进入
local m_IsBeginLevelUpTask 					= nil   --国家升级任务是否开启
local m_IsBeginShiLianTask 					= nil   --试炼任务是否开启
local m_BeiginLevelUpIndex 					= nil   --国家升级任务开始索引
local m_BeiginShiLianIndex					= nil   --试炼升级任务开始索引
local m_CWarFinishNum 						= 0
local m_CWarFinishNumTotal					= 0
local m_CWarMissionDelayTime 				= nil   --国战任务计时
local m_ShiLianMissionDelayTime 		    = nil   --试炼任务计时
local m_isBeginCWarCount 					= false --是否开始国战任务计时
local m_isBeginShiLianCount 				= false --是否开始试炼任务计时
local m_ShiLianTitleLayer 					= nil

local function InitVars()
	m_MissionNormalLayer   					= nil
	m_CurType 		   	   					= nil
	m_LoadMainLineFinish   					= nil
	m_LoadDailyFinish      					= nil
	m_LoadCountryWarFinish 					= nil
	m_LoadCorpsFinish      					= nil
	m_loadSpecialFinish 					= nil
	m_TabMissionIndex      					= nil
	m_CurTagCutNum 	   	   					= nil
	m_Panel_Daily          					= nil
	m_Panel_MainLine       					= nil
	m_Panel_CountryWar     					= nil
	m_ListView_MissionList  		   		= nil
	m_ListView_MissionList_MainLine   	 	= nil
	m_ListView_MissionList_CountryWar  		= nil
	m_Image_DailyBtn 						= nil
	m_Image_MainLineBtn 					= nil
	m_Image_CountryWarBtn 					= nil
	m_Image_CorpsBtn 						= nil
	--m_nDelayTime							= nil
	m_Panel_Corps 							= nil
	m_IsBeginLevelUpTask 					= nil   --国家升级任务是否开启
	m_IsBeginShiLianTask 					= nil   --试炼任务是否开启
	m_BeiginLevelUpIndex 					= nil   --国家升级任务开始索引
	m_BeiginShiLianIndex					= nil   --试炼升级任务开始索引
	m_CWarFinishNum 						= 0
	m_CWarFinishNumTotal 					= 0
	m_CWarMissionDelayTime					= nil
	m_ShiLianMissionDelayTime 				= nil
	m_ShiLianTitleLayer 					= nil
	--m_IsCorpsComeIn							= nil 	--从军团场景进入
	--m_IsCWarComeIn							= nil 	--从国战场景进入
end

local Mission_Type = {
	Mission_MainLine    	= 0,
	Mission_Daily			= 1,
	Mission_Corps			= 2,
	Mission_CountryWar		= 3,
	Mission_Special 		= 4,
	Mission_ShiLian 		= 5,
}

local Mission_State = {
	FinishedNotReceived 			= 0,  --完未领取
	NotFinished						= 1,  --未完成
	HaveReceived 					= 2,  --完成已领取
	MissionFaied 					= 3,  --任务失败
	MissionLock 					= 4,  --未解锁
}

local MissionSpecialType = {
	Mission_LevelUp 	= 1,
	Mission_ShiLian 	= 2,
}

local COMEIN_TYPE = {
	COMEIN_MAINSCENE = 1,
	COMEIN_CORPSCENE = 2,
}

local function CheckCountryWarMissionOpen(  )
	local bOpenTab = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_26)
	if tonumber(bOpenTab.vipLimit) == 0 then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1643,nil,"国战任务",tonumber(bOpenTab.level))
		pTips = nil
		return false
	else
		return true
	end
end

local function CheckCorpsMissionOpen(  )
	-- 检测军团任务是否开启
	local tabCorps = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_25)
	if tonumber(tabCorps["vipLimit"]) == 1 then
		return true
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1643,nil,"军团任务",tabCorps["level"])
		pTips = nil
		return false
	end
end

local function UIReleaseToCWar( )
	if m_Panel_CountryWar ~= nil then
		if m_nHanderTime ~= nil then
			m_Panel_CountryWar:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
		end
		m_MissionNormalLayer:removeFromParentAndCleanup(true)
		InitVars()
		print(m_IsCorpsComeIn, m_IsCWarComeIn)
		if m_IsCorpsComeIn == false then
			--不是从军团进入的，继续判断是不是在国战层点击的日志
			if m_IsCWarComeIn == false then
				--如果也不是从国战层进入的则直接可以pop
				MainScene_PopUILayer()
				MainScene.ClearRootBtn()
			end
		end
	end
end

local function SetCorpsLabelShow( nState )
	if m_MissionNormalLayer == nil then
		return 
	end
	
	local Lable_1 = tolua.cast(m_MissionNormalLayer:getWidgetByName("Label_CorpsInfo_1"),"Label")
	local Lable_2 = tolua.cast(m_MissionNormalLayer:getWidgetByName("Label_CorpsInfo_2"),"Label")

	Lable_1:setVisible(nState)
	Lable_2:setVisible(nState)

end

local function UIRelease( )
	if m_Panel_CountryWar ~= nil then
		if m_nHanderTime ~= nil then
			m_Panel_CountryWar:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
		end
		m_MissionNormalLayer:removeFromParentAndCleanup(true)
		InitVars()
		m_CWarFinishNum 						= nil
		m_CWarFinishNumTotal 					= nil


		if MainScene.GetCurParent() == true then
			--不是从军团进入的，继续判断是不是在国战层点击的日志
			if m_IsCWarComeIn == false then
				--如果也不是从国战层进入的则直接可以pop
				MainScene_PopUILayer()
			end
		end
	end
end

local function CreateLabel( text, size, color, fontName, pos, isAnchor )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	if isAnchor == true then
		label:setAnchorPoint(ccp(0,0.5))
	end
	return label
end

local function SetCheckBoxImageFalse( )
	m_Image_DailyBtn:loadTexture("Image/imgres/button/btn_page_n.png")
	m_Image_MainLineBtn:loadTexture("Image/imgres/button/btn_page_n.png")
	m_Image_CountryWarBtn:loadTexture("Image/imgres/button/btn_page_n.png")
	m_Image_CorpsBtn:loadTexture("Image/imgres/button/btn_page_n.png")
	m_Image_SpecialBtn:setScale(1.0)

	m_Image_DailyBtn:setTouchEnabled(false)
	m_Image_MainLineBtn:setTouchEnabled(false)
	m_Image_CountryWarBtn:setTouchEnabled(false)
	m_Image_CorpsBtn:setTouchEnabled(false)
	m_Image_SpecialBtn:setTouchEnabled(false)

	m_Panel_Daily:setVisible(false)
	m_Panel_MainLine:setVisible(false)
	m_Panel_CountryWar:setVisible(false)
	m_Panel_Corps:setVisible(false)
	m_Panel_Special:setVisible(false)

	m_Panel_Daily:setPositionX(m_Panel_Daily:getPositionX() + 10000)
	m_Panel_MainLine:setPositionX(m_Panel_Daily:getPositionX() + 10000)
	m_Panel_CountryWar:setPositionX(m_Panel_Daily:getPositionX() + 10000)
	m_Panel_Corps:setPositionX(m_Panel_Daily:getPositionX() + 10000)
	m_Panel_Special:setPositionX(m_Panel_Special:getPositionX() + 10000)

	if m_Image_DailyBtn:getChildByTag(99) ~= nil then
		m_Image_DailyBtn:getChildByTag(99):removeFromParentAndCleanup(true)
		local nDailyLabel 				= CreateLabel( "日常", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		m_Image_DailyBtn:addChild(nDailyLabel,1,99)
	end

	if m_Image_MainLineBtn:getChildByTag(99) ~= nil then
		m_Image_MainLineBtn:getChildByTag(99):removeFromParentAndCleanup(true)
		local nMainLineLabel 			= CreateLabel( "主线", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		m_Image_MainLineBtn:addChild(nMainLineLabel,1,99)
	end

	if m_Image_CountryWarBtn:getChildByTag(99) ~= nil then
		m_Image_CountryWarBtn:getChildByTag(99):removeFromParentAndCleanup(true)
		local nCountryWarLabel 			= CreateLabel( "国战", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		m_Image_CountryWarBtn:addChild(nCountryWarLabel,1,99)
	end

	if m_Image_CorpsBtn:getChildByTag(99) ~= nil then
		m_Image_CorpsBtn:getChildByTag(99):removeFromParentAndCleanup(true)
		local nCorpsLabel 				= CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		m_Image_CorpsBtn:addChild(nCorpsLabel,1,99)
	end

	--[[if m_Image_SpecialBtn:getChildByTag(99) ~= nil then
		m_Image_SpecialBtn:getChildByTag(99):removeFromParentAndCleanup(true)
		local nSpecialLabel 				= CreateLabel( "特殊", 30, ccc3(255,243,143), CommonData.g_FONT1, ccp(7,0))
		m_Image_SpecialBtn:addChild(nSpecialLabel,1,99)
	end]]
end

local function UnlockTypeBtnTouch( nState, nType )
	if m_MissionNormalLayer ~= nil then
		m_Image_DailyBtn:setTouchEnabled(nState)
		m_Image_MainLineBtn:setTouchEnabled(nState)
		m_Image_CountryWarBtn:setTouchEnabled(nState)
		m_Image_CorpsBtn:setTouchEnabled(nState)
		m_Image_SpecialBtn:setTouchEnabled(nState)
		if nType == 0 then
			m_LoadMainLineFinish   = true
		elseif nType == 1 then
			m_LoadDailyFinish 	   = true
		elseif nType == 2 then
			m_LoadCountryWarFinish = true
		elseif nType == 3 then
			m_LoadCorpsFinish 	   = true
		elseif nType == 4 then
			m_loadSpecialFinish    = true
		elseif nType == 5 then
			m_loadSpecialFinish    = true
		end
	end
end

local function UnlockMissionItemTouch( nState, nType )
	if nType == 1 then
		print("日常ITEM触摸解锁")
		--Pause()
		local nItems = m_ListView_MissionList:getItems()
		for i=1,nItems:count() do
			local pItem = nItems:objectAtIndex(i-1)
			local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
			local pBtn = tolua.cast(Image_ItemBg:getChildByName("Button_GotoMission"),"Button")
			pBtn:setTouchEnabled(nState)
		end
	elseif nType == 0 then
		print("主线ITEM触摸解锁")
		--Pause()
		local nItems = m_ListView_MissionList_MainLine:getItems()
		for i=1,nItems:count() do
			local pItem = nItems:objectAtIndex(i-1)
			local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
			local pBtn = tolua.cast(Image_ItemBg:getChildByName("Button_GotoMission"),"Button")
			pBtn:setTouchEnabled(nState)
		end	
	elseif nType == 2 then
		print("国战ITEM触摸解锁")
		local nItems = m_ListView_MissionList_CountryWar:getItems()
		for i=1,nItems:count() do
			local pItem = nItems:objectAtIndex(i-1)
			local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
			local pBtn = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
			pBtn:setTouchEnabled(nState)
		end	
	elseif nType == 3 then
		print("军团ITEM触摸解锁")
		local nItems = m_ListView_MissionList_Corps:getItems()
		for i=1,nItems:count() do
			local pItem = nItems:objectAtIndex(i-1)
			local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
			local pBtn = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
			pBtn:setTouchEnabled(nState)
		end	
	elseif nType == 4 or nType == 5 then
		print("特殊ITEM触摸解锁")
		local nItems = m_ListView_MissionList_Special:getItems()
		for i=1,nItems:count() do
			if i-1 ~= m_BeiginLevelUpIndex and i-1 ~= m_BeiginShiLianIndex then

				local pItem = nItems:objectAtIndex(i-1)
				local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
				local pBtn = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
				pBtn:setTouchEnabled(nState)

			end
		end		
	end
end

local function SetMainItemTouch( nState )
	local nItems = m_ListView_MissionList_MainLine:getItems()
	for i=1,nItems:count() do
		local pItem = nItems:objectAtIndex(i-1)
		pItem:setTouchEnabled(nState)
	end		
end

local function CloneItemWidget( pTemp )
    local pItem = pTemp:clone()
    local peer = tolua.getpeer(pTemp)
    tolua.setpeer(pItem, peer)
    return pItem
end

local function _Button_Return_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
        UIRelease()
        if m_IsCWarComeIn == true then
        	require "Script/Main/CountryWar/CountryUILayer"
			CountryUILayer.SetRedPointState()
		end
		CorpsScene.SetRedPointMission()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function UpdateItemStatus( pItemBg, nStatus )
	local pSpItem = tolua.cast(pItemBg:getVirtualRenderer(), "CCScale9Sprite")

	local pTitleItem   = tolua.cast(pItemBg:getChildByName("Image_NameBg"),"ImageView")
	local pTitleSpItem = tolua.cast(pTitleItem:getVirtualRenderer(), "CCSprite")

	local pHeadItem   = tolua.cast(pItemBg:getChildByName("Image_Item"),"ImageView")
	local pHeadSpItem = tolua.cast(pHeadItem:getVirtualRenderer(), "CCSprite")

	local pColorItem   = tolua.cast(pItemBg:getChildByName("Image_Color"),"ImageView")
	local pColorSpItem = tolua.cast(pColorItem:getVirtualRenderer(), "CCSprite")

	local pRewardItem_1 = tolua.cast(pItemBg:getChildByName("Image_Reward_1"),"ImageView")
	local pRewardSpItem_1 = tolua.cast(pRewardItem_1:getVirtualRenderer(), "CCSprite")

	local pRewardItem_2 = tolua.cast(pItemBg:getChildByName("Image_Reward_2"),"ImageView")
	local pRewardSpItem_2 = tolua.cast(pRewardItem_2:getVirtualRenderer(), "CCSprite")

	local pImage_RewardImg = tolua.cast(pItemBg:getChildByName("Image_RewardImg"),"ImageView")
	local pImage_RewardSp = tolua.cast(pImage_RewardImg:getVirtualRenderer(), "CCSprite")

	if nStatus == true then 
		Scale9SpriteSetGray(pSpItem,1)
		SpriteSetGray(pTitleSpItem,1)
		SpriteSetGray(pHeadSpItem,1)
		SpriteSetGray(pColorSpItem,1)
		SpriteSetGray(pRewardSpItem_1,1)
		SpriteSetGray(pRewardSpItem_2,1)
		SpriteSetGray(pImage_RewardSp,1)
	else
		Scale9SpriteSetGray(pSpItem,0)
		SpriteSetGray(pTitleSpItem,0)
		SpriteSetGray(pHeadSpItem,0)
		SpriteSetGray(pColorSpItem,0)
		SpriteSetGray(pRewardSpItem_1,0)
		SpriteSetGray(pRewardSpItem_2,0)
		SpriteSetGray(pImage_RewardSp,0)
	end

end

-- 110 = 竖线
-- 210 = 积分label
-- 310 = 奖励盒子
-- 410 = 点击按钮
local function InitDailyUI_MissionProgress( nParent )
	--任务进度条
	local Progress_Mission = tolua.cast(nParent:getChildByName("ProgressBar_Mission"),"LoadingBar")

	local nStage 	   	   = GetScoreStage(CommonData.g_MainDataTable.level)			--当前积分阶段

	local nMaxScore        = GetBoxMaxScore(nStage) 									--当前积分上限

	local nSizeWidth       = Progress_Mission:getSize().width

	local nLastLinePosX    = -nSizeWidth * 0.5 

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/pata_baoxiang01.ExportJson")

	for i=1,4 do
		--求出当前阶段每个奖励的需求积分数并得出百分比
		local nScore 	   = GetBoxScore(nStage, i)
		local nScorePer    = nScore / nMaxScore
		local nPosX        = nSizeWidth * nScorePer - nSizeWidth * 0.5
		local nBoxState    = GetBoxState(i)
		local pCurScore    = GetCurSocre()
		Progress_Mission:setPercent( (pCurScore / nMaxScore) * 100 )

		if i < 4 then 
			if Progress_Mission:getNodeByTag(110 + i) ~= nil then 
				Progress_Mission:getNodeByTag(110 + i):setPositionX(nPosX)
				Progress_Mission:getNodeByTag(110 + i):setPositionY(0)
			else
				local nlineSp      = CCSprite:create("Image/imgres/corps/flap.png")
				nlineSp:setPositionX(nPosX)
				nlineSp:setPositionY(0)
				Progress_Mission:addNode(nlineSp,11,110 + i)
			end
		end

		local diffWidth = nil
		if nPosX > nLastLinePosX then
			diffWidth = ( nPosX - nLastLinePosX ) * 0.5
			--[[print("nPosX = "..nPosX)
			print("nLastLinePosX = "..nLastLinePosX)
			print("diffWidth = "..diffWidth)
			Pause()]]
		else
			diffWidth = ( nLastLinePosX - nPosX ) * 0.5
		end

		--算出分数label的坐标
		if Progress_Mission:getChildByTag(210 + i) ~= nil then
			Progress_Mission:getChildByTag(210 + i):removeFromParentAndCleanup(true)
		end
		local nScoreLabel  = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT3, nScore, ccp(nPosX - math.abs(diffWidth), 0), COLOR_Black, COLOR_White, true, ccp(0, 0), 1)
		Progress_Mission:addChild(nScoreLabel,11,210 + i)

		--奖励页面回调
		local function _Button_RewardBox_CallBack( sender, eventType )
			local Progress_Mission 		= tolua.cast(m_Panel_Daily:getChildByName("ProgressBar_Mission"),"LoadingBar")
			if eventType == TouchEventType.ended then
		        --sender:setScale(1.0)
				if Progress_Mission:getNodeByTag(310 + sender:getTag()) ~= nil then
					Progress_Mission:getNodeByTag(310 + sender:getTag()):setScale(0.6)
					local nBoxState    = GetBoxState(sender:getTag())
					local nStage 	   = GetScoreStage(CommonData.g_MainDataTable.level)			--当前积分阶段
					local nScore 	   = GetBoxScore(nStage, sender:getTag())
					local nBoxRewardID = GetBoxRewardID(sender:getTag())

					local function ReceiveCallback()
						local function ReceiveSuccessByBox()
							--刷新宝箱和进度条
							--[[local function RefreshRewardBox( )
								InitDailyUI_MissionProgress(m_Panel_Daily)
								--展示奖励
							end
							--刷新数据源
							Packet_GetNormalMissionData.SetSuccessCallBack(RefreshRewardBox)
							network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(1)) --0=主线任务。1=日常任务]]
						end
						Packet_GetReceiveMissionBoxData.SetSuccessCallBack(ReceiveSuccessByBox)
						network.NetWorkEvent(Packet_GetReceiveMissionBoxData.CreatePacket(sender:getTag() - 1)) -- 宝箱索引
					end

					if nBoxState == Mission_State.FinishedNotReceived then
						--显示领取按钮
						local pRewardLayer = MissionNormalRewardLayer.CreateMissionNormalRewardLayer(Mission_State.FinishedNotReceived, nScore, nBoxRewardID, ReceiveCallback)
						if pRewardLayer ~= nil then 
							m_MissionNormalLayer:addChild(pRewardLayer,9999)
						end
					else
						--不显示领取按钮
						local pRewardLayer = MissionNormalRewardLayer.CreateMissionNormalRewardLayer(Mission_State.NotFinished, nScore, nBoxRewardID)
						if pRewardLayer ~= nil then 
							m_MissionNormalLayer:addChild(pRewardLayer,9999)
						end
					end
				end
			elseif eventType == TouchEventType.began then
				if Progress_Mission:getNodeByTag(310 + sender:getTag()) ~= nil then
					Progress_Mission:getNodeByTag(310 + sender:getTag()):setScale(0.5)
				end
			elseif eventType == TouchEventType.canceled then
				if Progress_Mission:getNodeByTag(310 + sender:getTag()) ~= nil then
					Progress_Mission:getNodeByTag(310 + sender:getTag()):setScale(0.6)
				end
			end
		end

		--创建奖励盒子 
		local pAniStrNum = nil
		if i == 1 then
			--木箱子
			pAniStrNum = 5
		elseif i == 2 then
			--宝箱
			pAniStrNum = 9
		elseif i == 3 then
			--金箱子
			pAniStrNum = 1
		elseif i == 4 then
			--钻石箱子
			pAniStrNum = 13
		else
			pAniStrNum = 1
		end
		if Progress_Mission:getNodeByTag(310 + i) ~= nil then 
			local pBoxArmature = Progress_Mission:getNodeByTag(310 + i)

			if nBoxState == Mission_State.NotFinished then
				--pBoxArmature:getAnimation():play("Animation1")
				--pBoxArmature:getAnimation():playWithIndex(0)
			elseif nBoxState == Mission_State.FinishedNotReceived then
				pBoxArmature:getAnimation():play("Animation"..pAniStrNum + 1)
			elseif nBoxState == Mission_State.HaveReceived then
				pBoxArmature:getAnimation():play("Animation"..pAniStrNum + 2)
				pBoxArmature:getAnimation():gotoAndPlay(28)
			end
			Progress_Mission:getChildByTag(i):setPosition(ccp(pBoxArmature:getPositionX(), pBoxArmature:getPositionY()))
		else
		    local PayArmature = CCArmature:create("pata_baoxiang01")
			PayArmature:setPosition(ccp(nPosX - math.abs(diffWidth), 58)) 
			if nBoxState == Mission_State.NotFinished then
				PayArmature:getAnimation():play("Animation"..pAniStrNum)
				--PayArmature:getAnimation():playWithIndex(0)
			elseif nBoxState == Mission_State.FinishedNotReceived then
				PayArmature:getAnimation():play("Animation"..pAniStrNum + 1)
			elseif nBoxState == Mission_State.HaveReceived then
				PayArmature:getAnimation():play("Animation"..pAniStrNum + 2)
				PayArmature:getAnimation():gotoAndPlay(28)
			end
			--创建盒子点击按钮
			local Btn_Node = Widget:create()
			Btn_Node:setEnabled(true)
			Btn_Node:setTouchEnabled(true)
			Btn_Node:ignoreContentAdaptWithSize(false)
		    Btn_Node:setSize(CCSize(70, 70))
			Btn_Node:setTag(i)
			Btn_Node:addTouchEventListener(_Button_RewardBox_CallBack)
			Btn_Node:setPosition(ccp(PayArmature:getPositionX(), PayArmature:getPositionY() - 10))
			Btn_Node:setVisible(false)
			Progress_Mission:addChild(Btn_Node,2, i)
			
			PayArmature:setScale(0.6)
			Progress_Mission:addNode(PayArmature,1,310 + i)

		end

		nLastLinePosX = nPosX
	end
end

local function _Button_Goto_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setTouchEnabled(false)
        sender:setScale(1.0) 
        local nUIID = nil
        local nCmdTab = {}
        if m_CurType == Mission_Type.Mission_Daily then
        	sender:setTouchEnabled(true)
       		nUIID = GetGotoUIID(sender:getTag())
       		for i=1,3 do
       			nCmdTab[i] = GetDailyMissionCmd(sender:getTag(), i)
       		end
       		CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer)
       	elseif m_CurType == Mission_Type.Mission_MainLine then
       		sender:setTouchEnabled(true)
       		nUIID = GetGotoUIID_MainLine(sender:getTag())
       		for i=1,3 do
       			nCmdTab[i] = GetMainMissionCmd(sender:getTag(), i)
       		end
       		CommonData.g_GuildeManager:SetAttr(true, UIReleaseToCWar)
       		CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer)
       	elseif m_CurType == Mission_Type.Mission_CountryWar then
       		sender:setTouchEnabled(true)
       		nUIID = 13
       		nCmdTab[1] = sender:getTag()
       		nCmdTab[2] = nil
       		nCmdTab[3] = nil
       		CommonData.g_GuildeManager:SetAttr(true, UIReleaseToCWar)
       		if MainScene.GetCurParent() == true then
       			CommonData.g_GuildeManager:SetComeInType(COMEIN_TYPE.COMEIN_MAINSCENE) 
       			CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer)  
       		else
       			require "Script/Main/Corps/CorpsScene"
       			CorpsScene.ShowHideCoinBar(false)
       			CommonData.g_GuildeManager:SetComeInType(COMEIN_TYPE.COMEIN_CORPSCENE) 
       			CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer) 	
       		end  
       	elseif m_CurType == Mission_Type.Mission_Corps then
       		sender:setTouchEnabled(true)
        	nUIID = 13
       		nCmdTab[1] = sender:getTag()
       		nCmdTab[2] = nil
       		nCmdTab[3] = nil
       		CommonData.g_GuildeManager:SetAttr(true, UIReleaseToCWar)
       		if MainScene.GetCurParent() == true then  		--当前的场景是主场景
       			CommonData.g_GuildeManager:SetComeInType(COMEIN_TYPE.COMEIN_MAINSCENE) 
       			CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer)   		
       		else
       			require "Script/Main/Corps/CorpsScene" 		--当前的场景是军团场景
       			CorpsScene.ShowHideCoinBar(false)
       			CommonData.g_GuildeManager:SetComeInType(COMEIN_TYPE.COMEIN_CORPSCENE) 
       			CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer) 		
       		end  
       	elseif m_CurType == Mission_Type.Mission_Special or m_CurType == Mission_Type.Mission_ShiLian then	
       		sender:setTouchEnabled(true)
       		nUIID = 13
       		nCmdTab[1] = sender:getTag()
       		nCmdTab[2] = nil
       		nCmdTab[3] = nil
       		CommonData.g_GuildeManager:SetAttr(true, UIReleaseToCWar)
       		if MainScene.GetCurParent() == true then
       			CommonData.g_GuildeManager:SetComeInType(COMEIN_TYPE.COMEIN_MAINSCENE)
       			CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer)    
       		else
       			require "Script/Main/Corps/CorpsScene"
       			CorpsScene.ShowHideCoinBar(false)
       			CommonData.g_GuildeManager:SetComeInType(COMEIN_TYPE.COMEIN_CORPSCENE)
       			CommonData.g_GuildeManager:SetParent(m_MissionNormalLayer) 	 
       		end  
       	end
        if nUIID ~= nil then
        	CommonData.g_GuildeManager:ReplaceUI(nUIID, nCmdTab[1], nCmdTab[2], nCmdTab[3])
        else
        	print(sender:getTag().."的nUIID为空")
        end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitDailyItem( pItem, pMisDB,nIndex )
	if pMisDB["TaskID"] == 0 then
		return false
	end
	--获取任务数据
	local pTaskID 	   = GetTaskExampleID(pMisDB["TaskID"]) 		--任务实例ID
	local pIntergal    = GetTaskIntergal(pMisDB["TaskID"])
	local pTaskState   = tonumber(pMisDB["TaskState"])
	local pCount 	   = tonumber(pMisDB["Count"])
	local pRewardID    = tonumber(pMisDB["RewardID"])
	pItem:setTouchEnabled(false)
	pItem:setTag(pMisDB["TaskID"])

	local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
	local Image_NameBg = tolua.cast(Image_ItemBg:getChildByName("Image_NameBg"),"ImageView")
	Image_ItemBg:setTag(pTaskState)
	--任务名称
	local nNameLabel   = StrokeLabel_createStrokeLabel(26, CommonData.g_FONT1, GetMissionName(pTaskID), ccp(-98, 0), COLOR_Black, COLOR_White, false, ccp(0, 0), 2)
	Image_NameBg:addChild(nNameLabel)
	--任务描述
	local nTextLabel   = CreateLabel(string.format(GetMissionText(pTaskID), GetCondNum(pTaskID)), 18, ccc3(49,31,21), CommonData.g_FONT3, ccp(Image_NameBg:getPositionX() - 98,Image_NameBg:getPositionY() - 40), true)
	Image_ItemBg:addChild(nTextLabel)
	--任务图标
	local Image_Item = tolua.cast(Image_ItemBg:getChildByName("Image_Item"),"ImageView")
	local pResID = GetMissionIcon(pTaskID)
	Image_Item:loadTexture(GetMissionPath(pResID))
	--任务奖励图标
	local Image_RewardImg = tolua.cast(Image_ItemBg:getChildByName("Image_RewardImg"),"ImageView")
	local pResRewardID = GetMissionRewardRes(pTaskID)
	if pResRewardID <= 0 then
		Image_RewardImg:setVisible(false)
	else
		Image_RewardImg:setVisible(true)
		Image_RewardImg:loadTexture(GetMissionPath(pResRewardID))
	end
	--可领取字样
	local Image_Receive = tolua.cast(Image_ItemBg:getChildByName("Image_Receive"),"ImageView")
	Image_Receive:setVisible(false)
	Image_Receive:setTouchEnabled(false)

	--任务奖励
	local nShowTab = {}
	local nEndIndex = 0
	for i=1,2 do
		if pRewardID > 0 then
			local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Reward_"..i),"ImageView")
			local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_Reward_"..i),"Label")
			--if pRewardID > 233 then pRewardID = 1 end
			if pRewardID < 0 then return false end

			local nCoinID  = GetMissionRewardData(pRewardID, i)
			if nCoinID > 0 then
				local nCoinResId = GetCoinResID(nCoinID)
				local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
				local nPath    = GetRewardPath(nCoinResId)
				Image_Reward:loadTexture(nPath)
				Label_Reward:setText("X "..nCoinNum)
				if tostring(Label_Reward:getStringValue()) ~= "" then
					nShowTab[i] = 1
				else
					nShowTab[i] = 0
				end
				--("coin res = "..nPath)
				--Pause()
			else
				nEndIndex = i
				break
			end

		end
	end	

	--道具
	local nItemIndex = 1
	if nEndIndex > 0 then
		for i=nEndIndex,2 do
			if pRewardID > 0 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Reward_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_Reward_"..i),"Label")
				--if pRewardID > 233 then pRewardID = 1 end
				if pRewardID < 0 then return false end

				local nItemID = GetMissionRewardItemData(pRewardID, nItemIndex)
				if nItemID > 0 then 
					local nItemResID = GetItemResID(nItemID)
					local nNum 	   = GetMissionRewardItemDataNum(pRewardID, nItemIndex)
					local nPath    = GetRewardPath(nItemResID)
					Image_Reward:loadTexture(nPath)
					Label_Reward:setText("X "..nNum)

					if tostring(Label_Reward:getStringValue()) ~= "" then
						nShowTab[i] = 1
					else
						nShowTab[i] = 0
					end
				end

			end		
			nItemIndex = nItemIndex + 1
		end
	end

	for i=1,table.getn(nShowTab) do
		local nShow  = nShowTab[i]
		local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Reward_"..i),"ImageView")
		local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_Reward_"..i),"Label")
		if nShow == 1 then
			Image_Reward:setVisible(true)
			Label_Reward:setVisible(true)
		else
			Image_Reward:setVisible(false)
			Label_Reward:setVisible(false)		
		end
	end

	--领取刷新回调
	local function _Button_MissionReward_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			local function ReceiveSuccess( )
				NetWorkLoadingLayer.loadingHideNow()

				local function RefreshQuest()
					--刷新列表
					local function Refresh( )
						NetWorkLoadingLayer.loadingHideNow()
						--刷新分数
						local Label_InterNum		= tolua.cast(m_Panel_Daily:getChildByName("Label_InterNum"),"Label")
						Label_InterNum:setText(GetCurSocre())
						--刷新奖励盒子
						InitDailyUI_MissionProgress(m_Panel_Daily)
						--刷新任务列表
						local pDB = GetMissionTab()
						local pMissionDB = pDB["Mission"]

						SortMissionByState_2(pMissionDB, false)

						local function LoadMissionItemCallBack( nLoadMissionNumStart, nLoadMissionNumEnd , isFinish )
							local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
							for i=nLoadMissionNumStart, nLoadMissionNumEnd do
								local pItem = CloneItemWidget(pTemp)
								local isAdd = InitDailyItem(pItem, pMissionDB[i], i)
								if isAdd == true then
									m_ListView_MissionList:pushBackCustomItem(pItem)
								end
							end	
							if isFinish == true then
								UnlockTypeBtnTouch(true, 1) 		--日常任务加载完checkbox解锁
								UnlockMissionItemTouch(true, 1)
							end	
						end

						UpdateListItem(pMissionDB, LoadMissionItemCallBack, m_ListView_MissionList, 1)
					end
					NetWorkLoadingLayer.loadingShow(true)
					Packet_GetNormalMissionData.SetSuccessCallBack(Refresh)
					network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(1)) --0=主线任务。1=日常任务
				end
				--货币
				local tabCoin = {}
				for i=1,5 do
					if pRewardID > 0 then
						local nCoinID  = GetMissionRewardData(pRewardID, i)
						if nCoinID > 0 then
							local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
							local nCoinName = GetCoinName(nCoinID)
							local tabChild = {}
							tabChild[1] = nCoinID
							tabChild[2] = nCoinNum
							table.insert(tabCoin,tabChild)
						end
					end
				end
				--道具
				local tabItem = {}
				for i=1,10 do
					if pRewardID > 0 then
						local nItemID = GetMissionRewardItemData(pRewardID, i)
						if nItemID > 0 then 
							local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
							local tabItemChild = {}
							tabItemChild[1] = nItemID
							tabItemChild[2] = nNum
							table.insert(tabItem, tabItemChild)
						end
					end
				end
				--添加提示
				if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
					print("只有道具奖励")	
					ShowGoodsLayer(tabItem, nil, nil)
				elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
					print("只有货币奖励")	
					ShowGoodsLayer(nil, tabCoin, nil)
				elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
					print("道具货币奖励都有")	
					ShowGoodsLayer(tabItem, tabCoin, nil)						
				else
				end
			end
			NetWorkLoadingLayer.loadingShow(true)
			Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
			network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(1, sender:getTag())) --0=主线任务。1=日常任务
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end
	pItem:addTouchEventListener(_Button_MissionReward_CallBack)

	--任务状态
	local Button_GotoMission = tolua.cast(Image_ItemBg:getChildByName("Button_GotoMission"),"Button")
	if pTaskState == Mission_State.NotFinished then 
		--未完成
		local Label_MissionNum = tolua.cast(Image_ItemBg:getChildByName("Label_MissionNum"),"Label")
		local labelBtn = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT3, "前往", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
		Button_GotoMission:addChild(labelBtn)
		Button_GotoMission:addTouchEventListener(_Button_Goto_CallBack)
		Button_GotoMission:setVisible(true)
		Button_GotoMission:setTouchEnabled(false)
		Button_GotoMission:setTag(pMisDB["TaskID"])
		local pFinishNum = GetCondNum(pTaskID)
		if pFinishNum == 0 then
			pFinishNum = 1 
		end
		Label_MissionNum:setText(pCount.."/"..pFinishNum)
		Label_MissionNum:setVisible(true)
		--任务积分
		local nIntergalLabel = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "+"..pIntergal.."积分", ccp(150, 0), ccc3(81,113,39), ccc3(99,216,53), false, ccp(0, 0), 2)
		Image_NameBg:addChild(nIntergalLabel,99,100)
	elseif pTaskState == Mission_State.FinishedNotReceived then
		--完成未领取
		Button_GotoMission:setTouchEnabled(false)
		Button_GotoMission:setPositionX(10000)
		pItem:setTouchEnabled(true)
		--动画效果
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/shijierenwu/shijierenwu.ExportJson")
	    local pArmature = CCArmature:create("shijierenwu")
	    pArmature:getAnimation():play("Animation1")
	    pArmature:setPosition(ccp(556, 71))
	    pItem:addNode(pArmature,99,99)
	    --可领取字样
	    Image_Receive:setVisible(false)
		--任务积分
		local nIntergalLabel = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "+"..pIntergal.."积分", ccp(150, 0), ccc3(81,113,39), ccc3(99,216,53), false, ccp(0, 0), 2)
		Image_NameBg:addChild(nIntergalLabel,99,100)
	elseif pTaskState == Mission_State.HaveReceived then
		--完成已领取
		Button_GotoMission:setTouchEnabled(false)
		local Image_receiveReward = tolua.cast(Image_ItemBg:getChildByName("Image_receiveReward"),"ImageView")
		Image_receiveReward:setVisible(true)
		UpdateItemStatus(Image_ItemBg, true)

		local Image_receiveReward_sprite = tolua.cast(Image_receiveReward:getVirtualRenderer(), "CCSprite")
		SpriteSetGray(Image_receiveReward_sprite, 1)
		--任务积分
		--local nIntergalLabel = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, "+"..pIntergal.."积分", ccp(150, 0), ccc3(81,113,39), ccc3(99,216,53), false, ccp(0, 0), 2)
		--Image_NameBg:addChild(nIntergalLabel,99,100)
	else
		Button_GotoMission:setTouchEnabled(false)
		local Image_receiveReward = tolua.cast(Image_ItemBg:getChildByName("Image_receiveReward"),"ImageView")
		Image_receiveReward:setVisible(true)
		Image_receiveReward:loadTexture("Image/imgres/mission/lose.png")		
	end

	return true

end

--[[local function ReceiveRewardByDailyTaskRefresh( nCallBack, nTaskType )
	--删除Tip
	DelGoodLayer()
	--刷新列表
	local function Refresh( )
		NetWorkLoadingLayer.loadingHideNow()
		--刷新分数
		local Label_InterNum		= tolua.cast(m_Panel_Daily:getChildByName("Label_InterNum"),"Label")
		Label_InterNum:setText(GetCurSocre())
		--刷新奖励盒子
		InitDailyUI_MissionProgress(m_Panel_Daily)
		--刷新任务列表
		
		local pDB = GetMissionTab()
		local pMissionDB = pDB["Mission"]

		SortMissionByState_2(pMissionDB, false)
	

		local function LoadMissionItemCallBack( nLoadMissionNumStart, nLoadMissionNumEnd , isFinish )
			local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
			for i=nLoadMissionNumStart, nLoadMissionNumEnd do
				local pItem = CloneItemWidget(pTemp)
				local isAdd = InitDailyItem(pItem, pMissionDB[i], i)
				if isAdd == true then
					m_ListView_MissionList:pushBackCustomItem(pItem)
				end
			end	
			if isFinish == true then
				UnlockTypeBtnTouch(true, nTaskType) 		--日常任务加载完checkbox解锁
				UnlockMissionItemTouch(true, nTaskType)
				if nCallBack ~= nil then
					nCallBack()
				end
			end	
		end

		UpdateListItem(pMissionDB, LoadMissionItemCallBack, m_ListView_MissionList, 1)
	end
	NetWorkLoadingLayer.loadingShow(true)
	Packet_GetNormalMissionData.SetSuccessCallBack(Refresh)
	network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(nTaskType)) --0=主线任务。1=日常任务

end]]

local function ReceiveRewardByDailyTask( nTag, nCallBack )

	local pRewardID = GetRewardIDByTaskID(nTag)
	--发送领取任务奖励
	local function ReceiveSuccess( )
		NetWorkLoadingLayer.loadingHideNow()

		local function RefreshQuest()

		end
		--货币
		local tabCoin = {}
		for i=1,5 do
			if pRewardID > 0 then
				local nCoinID  = GetMissionRewardData(pRewardID, i)
				if nCoinID > 0 then
					local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
					local nCoinName = GetCoinName(nCoinID)
					local tabChild = {}
					tabChild[1] = nCoinID
					tabChild[2] = nCoinNum
					table.insert(tabCoin,tabChild)
				end
			end
		end
		--道具
		local tabItem = {}
		for i=1,10 do
			if pRewardID > 0 then
				local nItemID = GetMissionRewardItemData(pRewardID, i)
				if nItemID > 0 then 
					local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
					local tabItemChild = {}
					tabItemChild[1] = nItemID
					tabItemChild[2] = nNum
					table.insert(tabItem, tabItemChild)
				end
			end
		end
		--添加提示
		if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
			print("只有道具奖励")	
			ShowGoodsLayer(tabItem, nil, RefreshQuest)
		elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
			print("只有货币奖励")	
			ShowGoodsLayer(nil, tabCoin, RefreshQuest)
		elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
			print("道具货币奖励都有")	
			ShowGoodsLayer(tabItem, tabCoin, RefreshQuest)						
		else
		end
		if nCallBack ~= nil then
			nCallBack()
			nCallBack = nil
		end
	end
	--NetWorkLoadingLayer.loadingShow(true)
	Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
	--network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(1, nTag)) --0=主线任务。1=日常任务
	local pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_8
	if tonumber(nTag) == 3 then
		pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_8
	elseif tonumber(nTag) == 4 then 
		pNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_9
	end
	NewGuideManager.PostPacket(pNetType)
end

function ReceiveRewardByMainTask( nTag, nCallBack )
	local pRewardID = GetRewardIDByTaskIDByMainLine(nTag)
	--发送领取任务奖励
	local function ReceiveSuccess( nResult )
		NetWorkLoadingLayer.loadingHideNow()

		if nResult == 0 then
			TipLayer.createTimeLayer("领取失败")
			return
		end

		--货币
		local tabCoin = {}
		for i=1,5 do
			if pRewardID > 0 then
				local nCoinID  = GetMissionRewardData(pRewardID, i)
				if nCoinID > 0 then
					local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
					local nCoinName = GetCoinName(nCoinID)
					local tabChild = {}
					tabChild[1] = nCoinID
					tabChild[2] = nCoinNum
					table.insert(tabCoin,tabChild)
				end
			end
		end
		--道具
		local tabItem = {}
		for i=1,10 do
			if pRewardID > 0 then
				local nItemID = GetMissionRewardItemData(pRewardID, i)
				if nItemID > 0 then 
					local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
					local tabItemChild = {}
					tabItemChild[1] = nItemID
					tabItemChild[2] = nNum
					table.insert(tabItem, tabItemChild)
				end
			end
		end

		local function UnlockTouch(  )
			--SetMainItemTouch(true)
			--sender:setTouchEnabled(true)
		end

		--添加提示
		if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
			print("只有道具奖励")	
			ShowGoodsLayer(tabItem, nil, UnlockTouch)
		elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
			print("只有货币奖励")	
			ShowGoodsLayer(nil, tabCoin, UnlockTouch)
		elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
			print("道具货币奖励都有")	
			ShowGoodsLayer(tabItem, tabCoin, UnlockTouch)						
		else
		end
		if nCallBack ~= nil then
			nCallBack()
			nCallBack = nil
		end	
	end

	--NetWorkLoadingLayer.loadingShow(true)
	--sender:setTouchEnabled(false)
	--SetMainItemTouch(false)
	Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
	--network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(0, nTag)) --0=主线任务。1=日常任务
	NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_13)
end

local function InitDailyUI_MissionList( nList )
	local pDB = GetMissionTab()
	local pMissionDB = pDB["Mission"]

	SortMissionByState_2(pMissionDB, false)

	local function LoadMissionItemCallBack( nLoadMissionNumStart, nLoadMissionNumEnd , isFinish )
		local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
		for i=nLoadMissionNumStart, nLoadMissionNumEnd do
			local pItem = CloneItemWidget(pTemp)
			local isAdd = InitDailyItem(pItem, pMissionDB[i], i)
			if isAdd == true then
				nList:pushBackCustomItem(pItem)
			end
		end	
		if isFinish == true then
			UnlockTypeBtnTouch(true, 1) 		--日常任务加载完checkbox解锁
			UnlockMissionItemTouch(true, 1)
		end	
	end

	UpdateListItem(pMissionDB, LoadMissionItemCallBack, nList, 1)
end

local function InitDailyUI( )
	local Label_InterNum		= tolua.cast(m_Panel_Daily:getChildByName("Label_InterNum"),"Label")
	local pListArr = m_ListView_MissionList:getItems()
	if pListArr:count() == 0 then
		m_ListView_MissionList:setBounceEnabled(true)
		m_ListView_MissionList:setClippingType(1)
		Label_InterNum:setText(GetCurSocre())
		--任务进度条的UI初始化
		InitDailyUI_MissionProgress(m_Panel_Daily)
		--任务列表的UI初始化
		InitDailyUI_MissionList(m_ListView_MissionList)
	else
		print("日常任务列表已存在, 可直接更新")
	end
end

local function InitMainLineItem( nList, pItem, pMisDB, nIndex, isRefresh )
	--获取任务数据
	if tonumber(pMisDB["TaskID"]) == 0 then
		return false
	end

	local pTaskID 	   = GetTaskExampleID_MainLine(pMisDB["TaskID"]) 		--任务实例ID
	local pTaskState   = tonumber(pMisDB["TaskState"])
	local pCount 	   = tonumber(pMisDB["Count"])
	local pRewardID    = tonumber(pMisDB["RewardID"])

	pItem:setTag(pMisDB["TaskID"])
	pItem:setTouchEnabled(false)

	local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
	local Image_NameBg = tolua.cast(Image_ItemBg:getChildByName("Image_NameBg"),"ImageView")
	--任务名称
	if Image_NameBg:getChildByTag(150) ~= nil then
		Image_NameBg:getChildByTag(150):removeFromParentAndCleanup(true)
	end
	local nNameLabel   = StrokeLabel_createStrokeLabel(26, CommonData.g_FONT1, GetMissionName(pTaskID), ccp(-98, 0), COLOR_Black, COLOR_White, false, ccp(0, 0), 2)
	Image_NameBg:addChild(nNameLabel,1,150)
	--任务描述
	if Image_ItemBg:getChildByTag(151) ~= nil then
		Image_ItemBg:getChildByTag(151):removeFromParentAndCleanup(true)
	end
	local nTextLabel   = CreateLabel(string.format(GetMissionText(pTaskID), GetCondNum(pTaskID)), 18, ccc3(49,31,21), CommonData.g_FONT3, ccp(Image_NameBg:getPositionX() - 98,Image_NameBg:getPositionY() - 40), true)
	Image_ItemBg:addChild(nTextLabel,1,151)
	--任务图标
	local Image_Item = tolua.cast(Image_ItemBg:getChildByName("Image_Item"),"ImageView")
	local pResID = GetMissionIcon(pTaskID)
	Image_Item:loadTexture(GetMissionPath(pResID))

	--任务奖励图标
	local Image_RewardImg = tolua.cast(Image_ItemBg:getChildByName("Image_RewardImg"),"ImageView")
	local pResRewardID = GetMissionRewardRes(pTaskID)
	if pResRewardID <= 0 then
		Image_RewardImg:setVisible(false)
	else
		Image_RewardImg:setVisible(true)
		Image_RewardImg:loadTexture(GetMissionPath(pResRewardID))
	end

	--可领取字样
	local Image_Receive = tolua.cast(Image_ItemBg:getChildByName("Image_Receive"),"ImageView")
	Image_Receive:setVisible(false)
	Image_Receive:setTouchEnabled(false)
	--任务奖励
	local nShowTab = {}
	local nEndIndex = 0
	for i=1,2 do
		if pRewardID > 0 then
			local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Reward_"..i),"ImageView")
			local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_Reward_"..i),"Label")
			--if pRewardID > 233 then pRewardID = 1 end
			if pRewardID < 0 then return false end
			
			local nCoinID  = GetMissionRewardData(pRewardID, i)
			
			if nCoinID > 0 then
				local nCoinResId = GetCoinResID(nCoinID)
				local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
				local nPath    = GetRewardPath(nCoinResId)
				Image_Reward:loadTexture(nPath)
				Label_Reward:setText("X "..nCoinNum)
				if tostring(Label_Reward:getStringValue()) ~= "" then
					nShowTab[i] = 1
				else
					nShowTab[i] = 0
				end
			else
				nEndIndex = i
				break
			end
		end
	end	

	--道具
	local nItemIndex = 1
	if nEndIndex > 0 then
		for i=nEndIndex,2 do
			if pRewardID > 0 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Reward_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_Reward_"..i),"Label")
				--if pRewardID > 233 then pRewardID = 1 end
				if pRewardID < 0 then return false end

				local nItemID = GetMissionRewardItemData(pRewardID, nItemIndex)
				
				if nItemID > 0 then 
					local nItemResID = GetItemResID(nItemID)
					local nNum 	   = GetMissionRewardItemDataNum(pRewardID, nItemIndex)
					local nPath    = GetRewardPath(nItemResID)
					Image_Reward:loadTexture(nPath)
					Label_Reward:setText("X "..nNum)
					if tostring(Label_Reward:getStringValue()) ~= "" then
						nShowTab[i] = 1
					else
						nShowTab[i] = 0
					end
				end
			end		
			nItemIndex = nItemIndex + 1
		end
	end

	for i=1,table.getn(nShowTab) do
		local nShow  = nShowTab[i]
		local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Reward_"..i),"ImageView")
		local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_Reward_"..i),"Label")
		if nShow == 1 then
			Image_Reward:setVisible(true)
			Label_Reward:setVisible(true)
		else
			Image_Reward:setVisible(false)
			Label_Reward:setVisible(false)		
		end
	end

	local function _Button_MissionReward_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			--发送领取任务奖励
			local function ReceiveSuccess( nResult )
				NetWorkLoadingLayer.loadingHideNow()

				if nResult == 0 then
					TipLayer.createTimeLayer("领取失败")
					return
				end

				--货币
				local tabCoin = {}
				for i=1,5 do
					if pRewardID > 0 then
						local nCoinID  = GetMissionRewardData(pRewardID, i)
						if nCoinID > 0 then
							local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
							local nCoinName = GetCoinName(nCoinID)
							local tabChild = {}
							tabChild[1] = nCoinID
							tabChild[2] = nCoinNum
							table.insert(tabCoin,tabChild)
						end
					end
				end
				--道具
				local tabItem = {}
				for i=1,10 do
					if pRewardID > 0 then
						local nItemID = GetMissionRewardItemData(pRewardID, i)
						if nItemID > 0 then 
							local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
							local tabItemChild = {}
							tabItemChild[1] = nItemID
							tabItemChild[2] = nNum
							table.insert(tabItem, tabItemChild)
						end
					end
				end

				local function UnlockTouch(  )
					--SetMainItemTouch(true)
					--sender:setTouchEnabled(true)
				end

				--添加提示
				if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
					print("只有道具奖励")	
					ShowGoodsLayer(tabItem, nil, UnlockTouch)
				elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
					print("只有货币奖励")	
					ShowGoodsLayer(nil, tabCoin, UnlockTouch)
				elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
					print("道具货币奖励都有")	
					ShowGoodsLayer(tabItem, tabCoin, UnlockTouch)						
				else
				end
			end

			NetWorkLoadingLayer.loadingShow(true)
			--sender:setTouchEnabled(false)
			--SetMainItemTouch(false)
			Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
			network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(0, sender:getTag())) --0=主线任务。1=日常任务
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end

	pItem:addTouchEventListener(_Button_MissionReward_CallBack)

	--任务状态
	local Button_GotoMission = tolua.cast(Image_ItemBg:getChildByName("Button_GotoMission"),"Button")
	if pTaskState == Mission_State.NotFinished then 
		--未完成
		if m_TabMissionIndex["NotFinishedBeginIndex"] == -1 then
			m_TabMissionIndex["NotFinishedBeginIndex"] = nIndex - 1
		end

		pItem:setTouchEnabled(false)
		if pItem:getNodeByTag(153) ~= nil then
			pItem:getNodeByTag(153):removeFromParentAndCleanup(true)
		end
		if Button_GotoMission:getChildByTag(152) ~= nil then
			Button_GotoMission:getChildByTag(152):removeFromParentAndCleanup(true)
		end
		local Label_MissionNum = tolua.cast(Image_ItemBg:getChildByName("Label_MissionNum"),"Label")
		local labelBtn = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT3, "前往", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
		Button_GotoMission:addChild(labelBtn,1, 152)
		Button_GotoMission:addTouchEventListener(_Button_Goto_CallBack)
		Button_GotoMission:setVisible(true)
		Button_GotoMission:setTouchEnabled(true)
		Button_GotoMission:setTag(pMisDB["TaskID"])
		Button_GotoMission:setPositionX(253)
		local pFinishNum = GetCondNum(pTaskID)
		if pFinishNum == 0 then
			pFinishNum = 1 
		end
		Label_MissionNum:setText(pCount.."/"..pFinishNum)
		Label_MissionNum:setVisible(true)
	elseif pTaskState == Mission_State.FinishedNotReceived then
		
		--完成未领取
		Button_GotoMission:setTouchEnabled(false)
		Button_GotoMission:setPositionX(10000)
		pItem:setTouchEnabled(true)
		
		--动画效果
		if pItem:getNodeByTag(153) == nil then
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/shijierenwu/shijierenwu.ExportJson")
		    local pArmature = CCArmature:create("shijierenwu")
		    pArmature:getAnimation():play("Animation1")
		    pArmature:setPosition(ccp(556, 71))
		    pItem:addNode(pArmature,99,153)
		end
	    --可领取字样
	    --Image_Receive:setVisible(true)
	    Image_Receive:setVisible(false)
	elseif pTaskState == Mission_State.HaveReceived then
		--完成已领取
		Button_GotoMission:setTouchEnabled(false)
		local Image_receiveReward = tolua.cast(Image_ItemBg:getChildByName("Image_receiveReward"),"ImageView")
		Image_receiveReward:setVisible(true)
		UpdateItemStatus(Image_ItemBg, true)
	elseif pTaskState == Mission_State.MissionLock then
		local Image_DarkBg = tolua.cast(Image_ItemBg:getChildByName("Image_DarkBg"),"ImageView")
		if Image_DarkBg:getChildByTag(154) ~= nil then
			Image_DarkBg:getChildByTag(154):removeFromParentAndCleanup(true)
		end
		if Image_DarkBg:getChildByTag(153) ~= nil then
			Image_DarkBg:getChildByTag(153):removeFromParentAndCleanup(true)
		end
		local nStr = GetMainLineUnlockText(pMisDB["TaskID"])
		require "Script/Common/RichLabel"
	 	local UnlockText = RichLabel.Create(nStr,pItem:getSize().width, nil, ccp(0,0.5))
	 	UnlockText:setPosition(ccp(-70,0))
		Button_GotoMission:setTouchEnabled(false)
		Image_DarkBg:addChild(UnlockText,1,154)
		Image_DarkBg:setVisible(true)	
		Image_DarkBg:setZOrder(999)
	end

	return true
end

local function InitMainLineUI_MissionList( nList )
	local pDB_MainLine = GetMainLineTab()

	SortMissionByState_2(pDB_MainLine, false)

	local function LoadMissionItemCallBack( nLoadMissionNumStart, nLoadMissionNumEnd , isFinish )
		local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
		for i=nLoadMissionNumStart, nLoadMissionNumEnd do
			local pItem = CloneItemWidget(pTemp)
			local isAdd = InitMainLineItem(nList, pItem, pDB_MainLine[i], i)
			if isAdd == true then
				nList:pushBackCustomItem(pItem)
			end
		end	
		if isFinish == true then
			UnlockTypeBtnTouch(true, 0) 		--主线任务加载完checkbox解锁
			UnlockMissionItemTouch(true, 0)
		end		
	end

	UpdateListItem(pDB_MainLine, LoadMissionItemCallBack, nList, 0)
end

local function InitMainLineUI( )
	m_Panel_MainLine:setVisible(true)
	m_ListView_MissionList_MainLine:setBounceEnabled(true)
	m_ListView_MissionList_MainLine:setClippingType(1)
	local pListArr_MainLine = m_ListView_MissionList_MainLine:getItems()
	if pListArr_MainLine:count() == 0 then
		--任务列表的UI初始化
		InitMainLineUI_MissionList(m_ListView_MissionList_MainLine)
	else
		print("主线任务列表已存在, 可直接更新")
	end
end

--[[local function SetCWarMissionDelayTime( nSecend )
	if nSecend < 0 then return end
	m_nDelayTime = nSecend
	local strM = math.floor(nSecend/60)
	local strS = math.floor(nSecend%60)
	local strTemp = ""
	if tonumber(strM) < 10 then strM = "0" .. strM end
	if tonumber(strS) < 10 then strS = "0" .. strS end

	local Image_TimeBg = tolua.cast(m_Panel_CountryWar:getChildByName("Image_TimeBg"),"ImageView")
	local Label_Time   = tolua.cast(Image_TimeBg:getChildByName("Label_Time"),"Label")
	Label_Time:setText(strM.." : "..strS)

	local function tick(dt)
		if m_nDelayTime == 0 then
		-- 时间到了。战斗结束
			--print("时间到了。战斗结束")
			Image_TimeBg:setVisible(false)
			m_Panel_CountryWar:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
		end
		m_nDelayTime = m_nDelayTime - 1
		SetCWarMissionDelayTime(m_nDelayTime)
	end
	if m_nHanderTime ~= nil then
		m_Panel_CountryWar:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end

	m_nHanderTime = m_Panel_CountryWar:getScheduler():scheduleScriptFunc(tick, 1, false)
end]]

local function InitCWarItem( pIndex, pMessDB, pItem, nType, nMissionType )
	--nType  0 = 国家任务 ， 1 = 个人任务
	--获取任务数据
	local pTaskID 			= tonumber(pMessDB["TaskID"])
	local pState  			= tonumber(pMessDB["TaskState"])
	local pCount  			= tonumber(pMessDB["Count"])
	local pRewardID			= tonumber(pMessDB["RewardID"])
	local pIndex 			= tonumber(pMessDB["Index"])

	local pDefenseCountry,pDefenseCity,pAttackCountry,pAttackCity   = nil

	if nType == 0 and nMissionType == Mission_Type.Mission_CountryWar then
	 	pDefenseCountry		= tonumber(pMessDB["DefenseType"])
	 	pDefenseCity 		= tonumber(pMessDB["DefenseID"])
	 	pAttackCountry		= tonumber(pMessDB["AttackType"])
	 	pAttackCity 		= tonumber(pMessDB["AttackID"])
	 end
	if tonumber(pTaskID) == 0 then
		return false
	end

	pItem:setTag(pIndex)

	local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
	Image_ItemBg:setTouchEnabled(false)

	local function GetCountryStr( nType )
		local nStrC = ""
		if nType == 1 then
			nStrC = "魏国"
		elseif nType == 2 then
			nStrC = "蜀国"
		elseif nType == 3 then
			nStrC = "吴国"
		end	

		return nStrC		
	end

	local nCurCity = 145

	local nStr = ""
	--任务目标
	if pDefenseCountry ~= nil and pAttackCountry ~= nil then
		if pDefenseCountry ~= 0 then
			local nCountryStr = GetCountryStr(pDefenseCountry)
			--现在是防守任务
			local nCityName = GetCityName(pDefenseCity)
			nStr = "防守"..nCountryStr.."城池"..nCityName
			nCurCity = pDefenseCity
		end

		if pAttackCountry ~= 0 then
			local nCountryStr = GetCountryStr(pAttackCountry)
			--现在是进攻任务
			local nCityName = GetCityName(pAttackCity)
			nStr = "进攻"..nCountryStr.."城池"..nCityName
			nCurCity = pAttackCity
		end
	end

	--任务名称
	local Label_Name   = tolua.cast(Image_ItemBg:getChildByName("Label_Name"),"Label")
	local strName      = GetMissionName(pTaskID)
	if pDefenseCountry == nil or pAttackCountry == nil then
		Label_Name:setText(strName)
	else
		Label_Name:setText(strName.." : "..nStr)
	end

	--任务图标
	local Image_State = tolua.cast(Image_ItemBg:getChildByName("Image_State"),"ImageView")
	local pResID = GetMissionIcon(pTaskID)
	Image_State:loadTexture(GetMissionPath(pResID))

	--任务奖励图标
	local Image_RewardImg = tolua.cast(Image_ItemBg:getChildByName("Image_RewardImg"),"ImageView")
	local pResRewardID = GetMissionRewardRes(pTaskID)
	if pResRewardID <= 0 then
		Image_RewardImg:setVisible(false)
	else
		Image_RewardImg:setVisible(true)
		Image_RewardImg:loadTexture(GetMissionPath(pResRewardID))
	end

	--任务状态
	local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
	local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
	local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
	local ProgressBar_Mission  = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
	local Button_Goto 		   = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
	Image_MissionState_2:setTouchEnabled(false)
	Image_ProgressBar:setTouchEnabled(false)
	ProgressBar_Mission:setTouchEnabled(false)

	--任务奖励
	--货币
	local nShowTab = {}
	local nEndIndex = 0
	for i=1,4 do
		if pRewardID > 0 then
			local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
			local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
			--if pRewardID > 233 then pRewardID = 1 end
			if pRewardID < 0 then return false end

			local nCoinID  = GetMissionRewardData(pRewardID, i)
			
			if nCoinID > 0 then
				local nCoinResId = GetCoinResID(nCoinID)
				local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
				local nPath    = GetRewardPath(nCoinResId)
				Image_Reward:loadTexture(nPath)
				Label_Reward:setText("X "..nCoinNum)
				nShowTab[i] = 1
			else
				nEndIndex = i
				break
			end
		end
	end

	--道具
	local nIndex = 1
	if nEndIndex > 0 then
		for i=nEndIndex,4 do
			if pRewardID > 0 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				--if pRewardID > 233 then pRewardID = 1 end
				if pRewardID < 0 then return false end

				local nItemID = GetMissionRewardItemData(pRewardID, nIndex)
				
				if nItemID > 0 then 
					local nItemResID = GetItemResID(nItemID)
					local nNum 	   = GetMissionRewardItemDataNum(pRewardID, nIndex)
					local nPath    = GetRewardPath(nItemResID)
					Image_Reward:loadTexture(nPath)
					Label_Reward:setText("X "..nNum)
					nShowTab[i] = 1
				end
			end		
			nIndex = nIndex + 1
		end
	end

	if m_CurType == Mission_Type.Mission_CountryWar then
		Button_Goto:setTag(nCurCity)
	elseif m_CurType == Mission_Type.Mission_Special then
		Button_Goto:setTag(nCurCity)
	else
		Button_Goto:setTag(pTaskID)
	end

	Button_Goto:addTouchEventListener(_Button_Goto_CallBack)

	local function _Button_MissionReward_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			--发送领取任务奖励
			local function ReceiveSuccess( )
				NetWorkLoadingLayer.loadingHideNow()
				local Image_ItemBg = tolua.cast(sender:getChildByName("Image_ItemBg"),"ImageView")
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_1"),"ImageView")
				--货币
				local tabCoin = {}
				for i=1,5 do
					if pRewardID > 0 then
						local nCoinID  = GetMissionRewardData(pRewardID, i)
						if nCoinID > 0 then
							local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
							local nCoinName = GetCoinName(nCoinID)
							local tabChild = {}
							tabChild[1] = nCoinID
							tabChild[2] = nCoinNum
							table.insert(tabCoin,tabChild)
						end
					end
				end
				--道具
				local tabItem = {}
				for i=1,10 do
					if pRewardID > 0 then
						local nItemID = GetMissionRewardItemData(pRewardID, i)
						if nItemID > 0 then 
							local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
							local tabItemChild = {}
							tabItemChild[1] = nItemID
							tabItemChild[2] = nNum
							table.insert(tabItem, tabItemChild)
						end
					end
				end

				--添加提示
				if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
					print("只有道具奖励")	
					ShowGoodsLayer(tabItem, nil, nil)
				elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
					print("只有货币奖励")	
					ShowGoodsLayer(nil, tabCoin, nil)
				elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
					print("道具货币奖励都有")	
					ShowGoodsLayer(tabItem, tabCoin, nil)						
				else
				end
			end
			NetWorkLoadingLayer.loadingShow(true)
			Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
			network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(Mission_Type.Mission_CountryWar, sender:getTag())) --0=主线任务。1=日常任务 2=军团任务 3=国家任务
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end	

	local function _Button_MissionReward_LevelUp_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			print("领取国家升级任务的奖励")
			--发送领取任务奖励
			local function ReceiveSuccess( )
				NetWorkLoadingLayer.loadingHideNow()
				local Image_ItemBg = tolua.cast(sender:getChildByName("Image_ItemBg"),"ImageView")
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_1"),"ImageView")
				--货币
				local tabCoin = {}
				for i=1,5 do
					if pRewardID > 0 then
						local nCoinID  = GetMissionRewardData(pRewardID, i)
						if nCoinID > 0 then
							local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
							local nCoinName = GetCoinName(nCoinID)
							local tabChild = {}
							tabChild[1] = nCoinID
							tabChild[2] = nCoinNum
							table.insert(tabCoin,tabChild)
						end
					end
				end
				--道具
				local tabItem = {}
				for i=1,10 do
					if pRewardID > 0 then
						local nItemID = GetMissionRewardItemData(pRewardID, i)
						if nItemID > 0 then 
							local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
							local tabItemChild = {}
							tabItemChild[1] = nItemID
							tabItemChild[2] = nNum
							table.insert(tabItem, tabItemChild)
						end
					end
				end

				--添加提示
				if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
					print("只有道具奖励")	
					ShowGoodsLayer(tabItem, nil, nil)
				elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
					print("只有货币奖励")	
					ShowGoodsLayer(nil, tabCoin, nil)
				elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
					print("道具货币奖励都有")	
					ShowGoodsLayer(tabItem, tabCoin, nil)						
				else
				end
			end
			NetWorkLoadingLayer.loadingShow(true)
			Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
			network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(Mission_Type.Mission_Special, sender:getTag())) --0=主线任务。1=日常任务 2=军团任务 3=国家任务
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end			

	local function _Button_MissionReward_ShiLian_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			print("领取国家试炼任务的奖励")
			--发送领取任务奖励
			local function ReceiveSuccess( )
				NetWorkLoadingLayer.loadingHideNow()
				local Image_ItemBg = tolua.cast(sender:getChildByName("Image_ItemBg"),"ImageView")
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_1"),"ImageView")
				--货币
				local tabCoin = {}
				for i=1,5 do
					if pRewardID > 0 then
						local nCoinID  = GetMissionRewardData(pRewardID, i)
						if nCoinID > 0 then
							local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
							local nCoinName = GetCoinName(nCoinID)
							local tabChild = {}
							tabChild[1] = nCoinID
							tabChild[2] = nCoinNum
							table.insert(tabCoin,tabChild)
						end
					end
				end
				--道具
				local tabItem = {}
				for i=1,10 do
					if pRewardID > 0 then
						local nItemID = GetMissionRewardItemData(pRewardID, i)
						if nItemID > 0 then 
							local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
							local tabItemChild = {}
							tabItemChild[1] = nItemID
							tabItemChild[2] = nNum
							table.insert(tabItem, tabItemChild)
						end
					end
				end

				--添加提示
				if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
					print("只有道具奖励")	
					ShowGoodsLayer(tabItem, nil, nil)
				elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
					print("只有货币奖励")	
					ShowGoodsLayer(nil, tabCoin, nil)
				elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
					print("道具货币奖励都有")	
					ShowGoodsLayer(tabItem, tabCoin, nil)						
				else
				end
			end
			NetWorkLoadingLayer.loadingShow(true)
			Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
			network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(Mission_Type.Mission_ShiLian, sender:getTag())) --0=主线任务。1=日常任务 2=军团任务 3=国家任务
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end			

	if nMissionType ~= nil then

		if nMissionType == Mission_Type.Mission_CountryWar then

			pItem:addTouchEventListener(_Button_MissionReward_CallBack)

		elseif nMissionType == Mission_Type.Mission_LevelUp then

			pItem:addTouchEventListener(_Button_MissionReward_LevelUp_CallBack)

		elseif nMissionType == Mission_Type.Mission_ShiLian then

			pItem:addTouchEventListener(_Button_MissionReward_ShiLian_CallBack)

	
		end
		

	end


	

	if pState == Mission_State.NotFinished then
		--未完成
		Image_ProgressBar:setVisible(true)
		Button_Goto:setVisible(true)
		Button_Goto:setTouchEnabled(true)
		local labelBtn = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT3, "前往", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
		Button_Goto:addChild(labelBtn)

		local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
		local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
		local pFinishNum = GetCondNum(pTaskID)
		if pFinishNum == 0 then
			pFinishNum = 1 
		end
		Label_Percent:setText(pCount.."/"..pFinishNum)

		local nPer = pCount / pFinishNum

		ProgressBar_Mission:setPercent(nPer * 100)

		pItem:setTouchEnabled(false)

	elseif pState == Mission_State.FinishedNotReceived then
		--完成未领取
		Image_MissionState_2:setVisible(true)
		Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")
		Image_MissionState:setVisible(true)
		Image_MissionState:loadTexture("Image/imgres/mission/win.png")

		pItem:setTouchEnabled(true)

		for i=1,table.getn(nShowTab) do
			local nShow  = nShowTab[i]
			if nShow == 1 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				Image_Reward:setVisible(true)
				Label_Reward:setVisible(true)
			end
		end

		Button_Goto:setEnabled(false)

	elseif pState == Mission_State.HaveReceived then
		--已领取
		Image_MissionState_2:setVisible(true)
		Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")
		Image_MissionState:setVisible(true)
		Image_MissionState:loadTexture("Image/imgres/mission/win.png")

		for i=1,table.getn(nShowTab) do
			local nShow  = nShowTab[i]
			if nShow == 1 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				Image_Reward:setVisible(true)
				Label_Reward:setVisible(true)
			end
		end
		pItem:setTouchEnabled(false)
		Button_Goto:setEnabled(false)

	elseif pState == Mission_State.MissionFaied then
		--任务失败
		Image_MissionState:setVisible(true)

		for i=1,table.getn(nShowTab) do
			local nShow  = nShowTab[i]
			if nShow == 1 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				Image_Reward:setVisible(true)
				Label_Reward:setVisible(true)
			end
		end

		Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
		Image_MissionState_2:setVisible(true)

		pItem:setTouchEnabled(false)
		Button_Goto:setEnabled(false)
	else
		pItem:setTouchEnabled(false)
		Button_Goto:setEnabled(false)
	end
	return true

end

local function InitCorpsItem( pMessDB, pItem )
	local pTaskID 			= tonumber(pMessDB["TaskID"])
	local pState  			= tonumber(pMessDB["TaskState"])
	local pCount  			= tonumber(pMessDB["Count"])
	local pRewardID			= tonumber(pMessDB["RewardID"])
	local pIndex 			= tonumber(pMessDB["Index"])

	if tonumber(pTaskID) == 0 then
		return false
	end

	pItem:setTag(pIndex)

	local Image_ItemBg = tolua.cast(pItem:getChildByName("Image_ItemBg"),"ImageView")
	Image_ItemBg:setTouchEnabled(false)

	--任务名称条件
	local _Name_Cond   = GetMissionCond_2Info(pTaskID)
	local Label_Cond   = "(任意)"
	if _Name_Cond == 1 then
		Label_Cond = "(魏国)"
	elseif _Name_Cond == 2 then
		Label_Cond = "(蜀国)"
	elseif _Name_Cond == 3 then
		Label_Cond = "(吴国)"
	elseif _Name_Cond == 0 then
		Label_Cond   = "(任意)"
	elseif _Name_Cond == -1 then
		Label_Cond   = ""
	end

	--任务名称
	local Label_Name   = tolua.cast(Image_ItemBg:getChildByName("Label_Name"),"Label")
	local strName      = GetMissionName(pTaskID)
	Label_Name:setText(strName..Label_Cond)

	--任务图标
	local Image_State = tolua.cast(Image_ItemBg:getChildByName("Image_State"),"ImageView")
	local pResID = GetMissionIcon(pTaskID)
	--print(pTaskID,pResID)
	--Pause()
	Image_State:loadTexture(GetMissionPath(pResID))

	--任务奖励图标
	local Image_RewardImg = tolua.cast(Image_ItemBg:getChildByName("Image_RewardImg"),"ImageView")
	local pResRewardID = GetMissionRewardRes(pTaskID)
	if pResRewardID <= 0 then
		Image_RewardImg:setVisible(false)
	else
		Image_RewardImg:setVisible(true)
		Image_RewardImg:loadTexture(GetMissionPath(pResRewardID))
	end

	--任务状态
	local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
	local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
	local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
	local ProgressBar_Mission  = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
	local Button_Goto 		   = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
	Image_MissionState_2:setTouchEnabled(false)
	Image_ProgressBar:setTouchEnabled(false)
	ProgressBar_Mission:setTouchEnabled(false)

	--任务奖励
	--货币
	local nShowTab = {}
	local nEndIndex = 0
	for i=1,4 do
		if pRewardID > 0 then
			local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
			local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
			--if pRewardID > 233 then pRewardID = 1 end
			if pRewardID < 0 then return false end

			local nCoinID  = GetMissionRewardData(pRewardID, i)
			
			if nCoinID > 0 then
				local nCoinResId = GetCoinResID(nCoinID)
				local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
				local nPath    = GetRewardPath(nCoinResId)
				Image_Reward:loadTexture(nPath)
				Label_Reward:setText("X "..nCoinNum)
				nShowTab[i] = 1
			else
				nEndIndex = i
				break
			end
		end
	end

	--道具
	local nIndex = 1
	if nEndIndex > 0 then
		for i=nEndIndex,4 do
			if pRewardID > 0 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				--if pRewardID > 233 then pRewardID = 1 end
				if pRewardID < 0 then return false end

				local nItemID = GetMissionRewardItemData(pRewardID, nIndex)
				
				if nItemID > 0 then 
					local nItemResID = GetItemResID(nItemID)
					local nNum 	   = GetMissionRewardItemDataNum(pRewardID, nIndex)
					local nPath    = GetRewardPath(nItemResID)
					Image_Reward:loadTexture(nPath)
					Label_Reward:setText("X "..nNum)
					nShowTab[i] = 1
				end
			end		
			nIndex = nIndex + 1
		end
	end

	if m_CurType == Mission_Type.Mission_Corps then
		Button_Goto:setTag(145)
	else
		Button_Goto:setTag(pTaskID)
	end

	Button_Goto:addTouchEventListener(_Button_Goto_CallBack)

	local function _Button_MissionReward_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			--发送领取任务奖励
			local function ReceiveSuccess( nResult )
				NetWorkLoadingLayer.loadingHideNow()

				if nResult == 0 then
					if tonumber(GetCorpsMission_SurPlusFinishTimes()) == 0 then
						--可完成次数为0
						TipLayer.createTimeLayer("可完成次数不足,无法领取任务奖励", 2)
						return
					end
				end

				local Image_ItemBg = tolua.cast(sender:getChildByName("Image_ItemBg"),"ImageView")
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_1"),"ImageView")
				--货币
				local tabCoin = {}
				for i=1,5 do
					if pRewardID > 0 then
						local nCoinID  = GetMissionRewardData(pRewardID, i)
						if nCoinID > 0 then
							local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
							local nCoinName = GetCoinName(nCoinID)
							local tabChild = {}
							tabChild[1] = nCoinID
							tabChild[2] = nCoinNum
							table.insert(tabCoin,tabChild)
						end
					end
				end
				--道具
				local tabItem = {}
				for i=1,10 do
					if pRewardID > 0 then
						local nItemID = GetMissionRewardItemData(pRewardID, i)
						if nItemID > 0 then 
							local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
							local tabItemChild = {}
							tabItemChild[1] = nItemID
							tabItemChild[2] = nNum
							table.insert(tabItem, tabItemChild)
						end
					end
				end

				local function RefreshCorpsList(  )
					
					local function Request(  )

						NetWorkLoadingLayer.loadingHideNow()
	
						m_ListView_MissionList_Corps:removeAllItems()

						local pDB = GetCorpsMission_MissionDB()

						local pMessDB = pDB["CorpsMission"]

						SortMissionByState_2(pMessDB, false)

						local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionCountryWarItem.json")

						for i=1, table.getn(pMessDB) do
							local pItem = CloneItemWidget(pTemp)

							if InitCorpsItem(pMessDB[i], pItem) == true then
								m_ListView_MissionList_Corps:pushBackCustomItem(pItem)
							end
						end	

						local Image_TimeBg = tolua.cast(m_Panel_Corps:getChildByName("Image_TimeBg"),"ImageView")
						local Image_RefreshNumBg = tolua.cast(m_Panel_Corps:getChildByName("Image_RefreshNumBg"),"ImageView")
						--剩余完成次数
						local Label_AddInfo	= tolua.cast(m_Panel_Corps:getChildByName("Label_AddInfo"),"Label")
						Label_AddInfo:setText("可完成"..GetCorpsMission_SurPlusFinishTimes().."/"..GetCorpsMission_TopFinishTimes().."次，每日增加四次")
						--免费刷新次数
						local Label_RefreshNum = tolua.cast(Image_RefreshNumBg:getChildByName("Label_RefreshNum"),"Label")
						Label_RefreshNum:setText("刷新次数"..GetCorpsMission_FreeRefreshTimes())

						local Button_Add = tolua.cast(m_Panel_Corps:getChildByName("Button_Add"),"Button")
						local pButton_AddSp = tolua.cast(Button_Add:getVirtualRenderer(), "CCSprite")

						if GetCorpsMission_SurPlusFinishTimes() > 0 then
							Button_Add:setTouchEnabled(false)
							SpriteSetGray(pButton_AddSp,1)
						else
							Button_Add:setTouchEnabled(true)
							SpriteSetGray(pButton_AddSp,0)
						end

						UnlockTypeBtnTouch(true, 3) 		--国战任务加载完checkbox解锁
						UnlockMissionItemTouch(true, 3)

					end


					NetWorkLoadingLayer.loadingShow(true)	
					Packet_GetReceiveMissionCorpsData.SetSuccessCallBack(Request)
					network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(2)) --0=主线任务。1=日常任务。2=军团任务

				end

				--添加提示
				if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
					print("只有道具奖励")	
					ShowGoodsLayer(tabItem, nil, RefreshCorpsList)
				elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
					print("只有货币奖励")	
					ShowGoodsLayer(nil, tabCoin, RefreshCorpsList)
				elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
					print("道具货币奖励都有")	
					ShowGoodsLayer(tabItem, tabCoin, RefreshCorpsList)						
				else
				end
			end
			NetWorkLoadingLayer.loadingShow(true)
			Packet_GetReceiveMissionNormalData.SetSuccessCallBack(ReceiveSuccess)
			network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(Mission_Type.Mission_Corps, sender:getTag())) --0=主线任务。1=日常任务 2=军团任务 3=国家任务
		elseif eventType == TouchEventType.began then
		elseif eventType == TouchEventType.canceled then
		end
	end		

	pItem:addTouchEventListener(_Button_MissionReward_CallBack)

	if pState == Mission_State.NotFinished then
		--未完成
		Image_ProgressBar:setVisible(true)
		Button_Goto:setVisible(true)
		Button_Goto:setTouchEnabled(true)
		local labelBtn = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT3, "前往", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
		Button_Goto:addChild(labelBtn)

		local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
		local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
		local pFinishNum = GetCondNum(pTaskID)
		if pFinishNum == 0 then
			pFinishNum = 1 
		end
		Label_Percent:setText(pCount.."/"..pFinishNum)

		local nPer = pCount / pFinishNum

		ProgressBar_Mission:setPercent(nPer * 100)

		pItem:setTouchEnabled(false)

	elseif pState == Mission_State.FinishedNotReceived then
		--完成未领取
		Image_MissionState_2:setVisible(true)
		Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")
		Image_MissionState:setVisible(true)
		Image_MissionState:loadTexture("Image/imgres/mission/win.png")

		pItem:setTouchEnabled(true)

		for i=1,table.getn(nShowTab) do
			local nShow  = nShowTab[i]
			if nShow == 1 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				Image_Reward:setVisible(true)
				Label_Reward:setVisible(true)
			end
		end

		Button_Goto:setEnabled(false)

	elseif pState == Mission_State.HaveReceived then
		--已领取
		Image_MissionState_2:setVisible(true)
		Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")
		Image_MissionState:setVisible(true)
		Image_MissionState:loadTexture("Image/imgres/mission/win.png")

		for i=1,table.getn(nShowTab) do
			local nShow  = nShowTab[i]
			if nShow == 1 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				Image_Reward:setVisible(true)
				Label_Reward:setVisible(true)
			end
		end
		pItem:setTouchEnabled(false)
		Button_Goto:setEnabled(false)

	elseif pState == Mission_State.MissionFaied then
		--任务失败
		Image_MissionState:setVisible(true)

		for i=1,table.getn(nShowTab) do
			local nShow  = nShowTab[i]
			if nShow == 1 then
				local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
				local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
				Image_Reward:setVisible(true)
				Label_Reward:setVisible(true)
			end
		end

		Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
		Image_MissionState_2:setVisible(true)

		pItem:setTouchEnabled(false)
		Button_Goto:setEnabled(false)
	else
		pItem:setTouchEnabled(false)
		Button_Goto:setEnabled(false)
	end

	return true

end

local function InitCorpsUI_MissionList( )
	--任务列表
	if m_ListView_MissionList_Corps:getItems():count() == 0 then
		
		local pDB = GetCorpsMission_MissionDB()

		local pMessDB = pDB["CorpsMission"]

		SortMissionByState_2(pMessDB, false)

		local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionCountryWarItem.json")

		for i=1, table.getn(pMessDB) do
			local pItem = CloneItemWidget(pTemp)

			if InitCorpsItem(pMessDB[i], pItem) == true then
				m_ListView_MissionList_Corps:pushBackCustomItem(pItem)
			end
		end	

		UnlockTypeBtnTouch(true, 3) 		--国战任务加载完checkbox解锁
		UnlockMissionItemTouch(true, 3)

	else
		print("军团任务列表已存在")

		return false

	end

	return true
end

local function InitCWarLoadingBar( pMessDB )
	local ProgressBar_CWarMission = tolua.cast(m_Panel_CountryWar:getChildByName("ProgressBar_CWarMission"),"LoadingBar")

	local pCountryDB  = pMessDB["CWarMission"]
	local pPersonalDB = pMessDB["PersonalMission"]

	local nFinishNum = 0
	
	--国战完成数
	for key,value in pairs(pCountryDB) do
		if value["TaskState"] == Mission_State.FinishedNotReceived or value["TaskState"] == Mission_State.HaveReceived then
			nFinishNum = nFinishNum + 1
		end
		m_CWarFinishNumTotal = m_CWarFinishNumTotal + 1
	end

	--个人完成数
	for key,value in pairs(pPersonalDB) do
		if value["TaskState"] == Mission_State.FinishedNotReceived or value["TaskState"] == Mission_State.HaveReceived then
			nFinishNum = nFinishNum + 1
		end
		m_CWarFinishNumTotal = m_CWarFinishNumTotal + 1		
	end

	local nPer = nFinishNum / m_CWarFinishNumTotal

	ProgressBar_CWarMission:setPercent(nPer * 100)	

end

local function RefreshCWarLoadingBar( )

	local ProgressBar_CWarMission = tolua.cast(m_Panel_CountryWar:getChildByName("ProgressBar_CWarMission"),"LoadingBar")

	local nPer = m_CWarFinishNum / m_CWarFinishNumTotal

	ProgressBar_CWarMission:setPercent(nPer * 100)	

end

local function InitCountryWarUI_MissionList( )
	--任务列表
	if m_ListView_MissionList_CountryWar:getItems():count() == 0 then
		
		local pMessCWarDB = GetMissionCWarDB()

		local pCountryDB  = pMessCWarDB["CWarMission"]
		local pPersonalDB = pMessCWarDB["PersonalMission"]
		local pRewardID   = pMessCWarDB["RewardID"]

		local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionCountryWarItem.json")
		for i=1, table.getn(pCountryDB) do
			local pItem = CloneItemWidget(pTemp)
			if InitCWarItem(i, pCountryDB[i], pItem, 0, Mission_Type.Mission_CountryWar) == true then
				m_ListView_MissionList_CountryWar:pushBackCustomItem(pItem)
			end
		end	

		for i=1, table.getn(pPersonalDB) do
			local pItem = CloneItemWidget(pTemp)
			if InitCWarItem(i, pPersonalDB[i], pItem, 1, Mission_Type.Mission_CountryWar) == true then
				m_ListView_MissionList_CountryWar:pushBackCustomItem(pItem)
			end
		end	

		UnlockTypeBtnTouch(true, 2) 		--国战任务加载完checkbox解锁
		UnlockMissionItemTouch(true, 2)

	else
		print("国战任务列表已存在")

		return false

	end

	return true
end

local function SetCWarSurplusTime( nTime, nLabel )
	if nTime < 0 then return end
	local strM = math.floor(nTime/60)
	local strS = math.floor(nTime%60)
	local strTemp = ""
	if tonumber(strM) < 10 then strM = "0" .. strM end
	if tonumber(strS) < 10 then strS = "0" .. strS end

	nLabel:setText(strM.." : "..strS)
end

local function InitCountryWarUI( )
	if m_MissionNormalLayer == nil then
		return
	end

	if m_ListView_MissionList_CountryWar == nil then
		return
	end

	m_ListView_MissionList_CountryWar:setBounceEnabled(true)
	m_ListView_MissionList_CountryWar:setClippingType(1)

	--[[if m_nHanderTime ~= nil then
		m_Panel_CountryWar:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end]]

	local Image_TimeBg = tolua.cast(m_Panel_CountryWar:getChildByName("Image_TimeBg"),"ImageView")
	local Image_TimeBg_2 = tolua.cast(m_Panel_CountryWar:getChildByName("Image_TimeBg_2"),"ImageView")
	if Image_TimeBg_2 ~= nil then
		Image_TimeBg_2:setVisible(false)
	end
	local Label_TimeTitle = tolua.cast(Image_TimeBg:getChildByName("Label_TimeTitle"),"Label")
	local Label_Time   = tolua.cast(Image_TimeBg:getChildByName("Label_Time"),"Label")
	local Label_TimeTitle_2 = tolua.cast(Image_TimeBg:getChildByName("Label_TimeTitle_2"),"Label")


	local pMessCWarDB = GetMissionCWarDB()
	local nBoxState   = pMessCWarDB["RewardState"]
	local pRewardID   = pMessCWarDB["RewardID"]

	InitCWarLoadingBar(pMessCWarDB)

	local pBoxArmature = nil

	if m_Panel_CountryWar:getNodeByTag(199) ~= nil then
		pBoxArmature = m_Panel_CountryWar:getNodeByTag(199)
		if nBoxState == Mission_State.NotFinished then
			pBoxArmature:getAnimation():play("Animation1")
		elseif nBoxState == Mission_State.FinishedNotReceived then
			pBoxArmature:getAnimation():play("Animation2")
		elseif nBoxState == Mission_State.HaveReceived then
			pBoxArmature:getAnimation():play("Animation3")
		end
	else
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/pata_baoxiang01.ExportJson")

		local ProgressBar_CWarMission = tolua.cast(m_Panel_CountryWar:getChildByName("ProgressBar_CWarMission"),"LoadingBar")

		pBoxArmature = CCArmature:create("pata_baoxiang01")

		pBoxArmature:setPosition(ccp(ProgressBar_CWarMission:getPositionX() + 165, ProgressBar_CWarMission:getPositionY() + 50))

		m_Panel_CountryWar:addNode(pBoxArmature,999, 199)
	end

	local function GetLevelUpMissionBegin(  )
		--判断当前国家三国任务是否发布
		if GetMissionCountryWarType_LevelUp() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI or 
			GetMissionCountryWarType_LevelUp() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU or 
			GetMissionCountryWarType_LevelUp() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU then

			return true
		end

		return false
	end

	if GetMissionCountryWarState() == 1 and GetMissionCountryWarType() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS  then
		--国家任务已发布
		if InitCountryWarUI_MissionList() == true then

			if m_Panel_CountryWar:getNodeByTag(199) ~= nil then
				if nBoxState == Mission_State.NotFinished then
					m_Panel_CountryWar:getNodeByTag(199):getAnimation():play("Animation1")
				elseif nBoxState == Mission_State.FinishedNotReceived then
					m_Panel_CountryWar:getNodeByTag(199):getAnimation():play("Animation2")
				elseif nBoxState == Mission_State.HaveReceived then
					m_Panel_CountryWar:getNodeByTag(199):getAnimation():play("Animation3")
				end
			end
			--任务总进度
			local nMaxCWarNum = m_ListView_MissionList_CountryWar:getItems():count()

			local ProgressBar_CWarMission = tolua.cast(m_Panel_CountryWar:getChildByName("ProgressBar_CWarMission"),"LoadingBar")
		
			for i=1,6 do
				local pLine = ProgressBar_CWarMission:getNodeByTag(100 + i)
				if pLine ~= nil then 
					pLine:removeFromParentAndCleanup(true)
				else
					break
				end
			end

			local pLoadingSize = ProgressBar_CWarMission:getSize().width

			for i=1,nMaxCWarNum do
				local nCutSize = pLoadingSize / nMaxCWarNum
				local nCutLine = CCSprite:create("Image/imgres/mission/cutline_cwar.png")
				nCutLine:setPosition(ccp(i * nCutSize - pLoadingSize * 0.5,0))
				ProgressBar_CWarMission:addNode(nCutLine, 1, 100 + i)
			end

			--奖励盒子
			local function _Button_RewardBoxCWar_CallBack( sender, eventType )
				if eventType == TouchEventType.ended then
					if pBoxArmature ~= nil then	
						if nBoxState == Mission_State.NotFinished then
							TipLayer.createTimeLayer("任务未完成,无法领取奖励",2)
						elseif nBoxState == Mission_State.FinishedNotReceived then
							local function RefreshRewardBox( )
								--删除按钮
								if m_Panel_CountryWar:getChildByTag(1990) ~= nil then
									m_Panel_CountryWar:getChildByTag(1990):removeFromParentAndCleanup(true)
								end 
								--货币
								local tabCoin = {}
								for i=1,5 do
									if pRewardID > 0 then
										local nCoinID  = GetMissionRewardData(pRewardID, i)
										if nCoinID > 0 then
											local nCoinNum = GetMissionRewardDataNum(pRewardID, i)
											local nCoinName = GetCoinName(nCoinID)
											local tabChild = {}
											tabChild[1] = nCoinID
											tabChild[2] = nCoinNum
											table.insert(tabCoin,tabChild)
										end
									end
								end
								--道具
								local tabItem = {}
								for i=1,10 do
									if pRewardID > 0 then
										local nItemID = GetMissionRewardItemData(pRewardID, i)
										if nItemID > 0 then 
											local nNum 		   = GetMissionRewardItemDataNum(pRewardID, i)
											local tabItemChild = {}
											tabItemChild[1] = nItemID
											tabItemChild[2] = nNum
											table.insert(tabItem, tabItemChild)
										end
									end
								end

								local function PlayEndAni( )
									pBoxArmature:getAnimation():play("Animation3")
								end

								NetWorkLoadingLayer.loadingHideNow()
								--添加提示
								if table.getn(tabItem) > 0 and table.getn(tabCoin) == 0 then
									print("只有道具奖励 by cwar")	
									ShowGoodsLayer(tabItem, nil, PlayEndAni)
								elseif table.getn(tabItem) == 0 and table.getn(tabCoin) > 0 then
									print("只有货币奖励 by cwar")	
									ShowGoodsLayer(nil, tabCoin, PlayEndAni)
								elseif table.getn(tabItem) > 0 and table.getn(tabCoin) > 0 then
									print("道具货币奖励都有 by cwar")	
									ShowGoodsLayer(tabItem, tabCoin, PlayEndAni)						
								else
								end
							end
							--领取箱子奖励
							NetWorkLoadingLayer.loadingShow(true)
							Packet_GetReceiveMissionNormalData.SetSuccessCallBack(RefreshRewardBox)
							network.NetWorkEvent(Packet_GetReceiveMissionNormalData.CreatePacket(3, 0)) --0=主线任务。1=日常任务
						elseif nBoxState == Mission_State.HaveReceived then
							return 
						end		
						pBoxArmature:setScale(1.0)	
					end
				elseif eventType == TouchEventType.began then
					if pBoxArmature ~= nil then
						pBoxArmature:setScale(0.9)
					end
				elseif eventType == TouchEventType.canceled then
					if pBoxArmature ~= nil then
						pBoxArmature:setScale(1.0)
					end
				end
			end			

			local Btn_Node = Widget:create()
			Btn_Node:setEnabled(true)
			Btn_Node:setTouchEnabled(true)
			Btn_Node:ignoreContentAdaptWithSize(false)
		    Btn_Node:setSize(CCSize(100, 100))
			Btn_Node:addTouchEventListener(_Button_RewardBoxCWar_CallBack)
			Btn_Node:setPosition(ccp(pBoxArmature:getPositionX(), pBoxArmature:getPositionY() - 25))
			Btn_Node:setVisible(false)
			m_Panel_CountryWar:addChild(Btn_Node,99,1990)

			--任务剩余时间
			if GetMissionCountryWarTime() == 0 then
				local nStr1,nStr2 = GetCWarMissionReleaseTime()
				Label_TimeTitle_2:setText("每日"..nStr1.."和"..nStr2.."发布国家任务")
				Label_TimeTitle_2:setVisible(true)
				Label_TimeTitle:setVisible(false)
				Label_Time:setVisible(false)
			else

				m_CWarMissionDelayTime = GetMissionCountryWarSurPlusTime()

				if m_CWarMissionDelayTime > 0 then   --还未结束
					--开启计时器
					m_isBeginCWarCount = true
					SetCWarSurplusTime(m_CWarMissionDelayTime, Label_Time)
					Label_TimeTitle:setVisible(true)
					Label_Time:setVisible(true)
					Label_TimeTitle_2:setVisible(false)
				else
					--Label_Time:setText("00 : 00")
					local nStr1,nStr2 = GetCWarMissionReleaseTime()
					Label_TimeTitle_2:setText("每日"..nStr1.."和"..nStr2.."发布国家任务")
					Label_TimeTitle_2:setVisible(true)
					Label_TimeTitle:setVisible(false)
					Label_Time:setVisible(false)
				end
			end
		end
	else
		--国家任务未发布
		UnlockTypeBtnTouch(true, 2) 
		UnlockMissionItemTouch(true, 2)

		local nStr1,nStr2 = GetCWarMissionReleaseTime()
		Label_TimeTitle_2:setText("每日"..nStr1.."和"..nStr2.."发布国家任务")
		Label_TimeTitle_2:setVisible(true)
		Label_TimeTitle:setVisible(false)
		Label_Time:setVisible(false)

	end

end

local function GotoVip(  )
	MainScene.GoToVIPLayer( 0 )
end

local function _Button_AddCorpsTimes_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(0.68)

        local bVipTab = MainScene.CheckVIPFunction( enumVIPFunction.eVipFunction_20 )

        local function UpdateTimes(  )
			local Image_TimeBg = tolua.cast(m_Panel_Corps:getChildByName("Image_TimeBg"),"ImageView")
			local Image_RefreshNumBg = tolua.cast(m_Panel_Corps:getChildByName("Image_RefreshNumBg"),"ImageView")
			--剩余完成次数
			local Label_AddInfo	= tolua.cast(m_Panel_Corps:getChildByName("Label_AddInfo"),"Label")
			Label_AddInfo:setText("可完成"..GetCorpsMission_SurPlusFinishTimes().."/"..GetCorpsMission_TopFinishTimes().."次，每日增加四次")
			--免费刷新次数
			local Label_RefreshNum = tolua.cast(Image_RefreshNumBg:getChildByName("Label_RefreshNum"),"Label")
			Label_RefreshNum:setText("刷新次数 "..GetCorpsMission_FreeRefreshTimes())

			local Button_Add = tolua.cast(m_Panel_Corps:getChildByName("Button_Add"),"Button")
			local pButton_AddSp = tolua.cast(Button_Add:getVirtualRenderer(), "CCSprite")

			if GetCorpsMission_SurPlusFinishTimes() > 0 then
				Button_Add:setTouchEnabled(false)
				SpriteSetGray(pButton_AddSp,1)
			else
				Button_Add:setTouchEnabled(true)
				SpriteSetGray(pButton_AddSp,0)
			end

        end

		if tonumber(server_mainDB.getMainData("VipJTRW")) > 0 then
			--弹出是否购买的Vip页面
			local function GoBuy( bState )
				if bState == true then
					if tonumber(server_mainDB.getMainData("gold")) < bVipTab.NeedNum then
						TipLayer.createTimeLayer("元宝不足", 2)
						return
					end

					MainScene.BuyCountFunction( enumVIPFunction.eVipFunction_20, 0, 0, UpdateTimes )
				end
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1629,GoBuy,bVipTab.NeedNum, bVipTab.name, tonumber(server_mainDB.getMainData("VipJTRW")))
			pTips = nil
		else
			--弹出去充值的vip页面
			--print("VipJTRW = "..tonumber(server_mainDB.getMainData("VipJTRW")))
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
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.58)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(0.68)
	end
end

local function InitCorpsUI(  )
	m_ListView_MissionList_Corps:setBounceEnabled(true)
	m_ListView_MissionList_Corps:setClippingType(1)

	local Image_TimeBg = tolua.cast(m_Panel_Corps:getChildByName("Image_TimeBg"),"ImageView")
	local Image_RefreshNumBg = tolua.cast(m_Panel_Corps:getChildByName("Image_RefreshNumBg"),"ImageView")
	--剩余完成次数
	local Label_AddInfo	= tolua.cast(m_Panel_Corps:getChildByName("Label_AddInfo"),"Label")
	Label_AddInfo:setText("可完成"..GetCorpsMission_SurPlusFinishTimes().."/"..GetCorpsMission_TopFinishTimes().."次，每日增加四次")
	--免费刷新次数
	local Label_RefreshNum = tolua.cast(Image_RefreshNumBg:getChildByName("Label_RefreshNum"),"Label")
	Label_RefreshNum:setText("刷新次数 "..GetCorpsMission_FreeRefreshTimes())
	--增加免费刷新次数
	local Button_Add = tolua.cast(m_Panel_Corps:getChildByName("Button_Add"),"Button")
	Button_Add:addTouchEventListener(_Button_AddCorpsTimes_CallBack)
	local pButton_AddSp = tolua.cast(Button_Add:getVirtualRenderer(), "CCSprite")

	if GetCorpsMission_SurPlusFinishTimes() > 0 then
		Button_Add:setTouchEnabled(false)
		SpriteSetGray(pButton_AddSp,1)
	else
		Button_Add:setTouchEnabled(true)
		SpriteSetGray(pButton_AddSp,0)
	end

	local function _Button_Corps_Refresh_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
	        sender:setScale(1.0)

			local function RefreshCorpsMission( nResult )
				NetWorkLoadingLayer.loadingHideNow()
				if nResult == 1 then
					m_ListView_MissionList_Corps:removeAllItems()
					InitCorpsUI()
				else
					--[[if tonumber(GetCorpsMission_FreeRefreshTimes()) == 0 then
						TipLayer.createTimeLayer("刷新次数不足", 2)
					end]]
					local pData = GetCorpsMission_RefreshConfuse()
					local pConsData = pData.TabData[1]
					local IsEnough  = pConsData["Enough"]
					if IsEnough == false then
						if pConsData.ItemId ~= nil then
							local Itemstr = GetItemNameByItemID(pConsData.ItemId)
							TipLayer.createTimeLayer(Itemstr.."不足", 2)
						else
							local CoinStr = GetCoinNameByConsumeType(pConsData.ConsumeType)
							TipLayer.createTimeLayer(CoinStr.."不足", 2)
						end
					end
				end
			end

			local function RefreshByNetWork( nState )
				if nState == true then
					NetWorkLoadingLayer.loadingShow(true)	
					Packet_GetReceiveMissionCorpsRefresh.SetSuccessCallBack(RefreshCorpsMission)
					network.NetWorkEvent(Packet_GetReceiveMissionCorpsRefresh.CreatePacket()) --0=主线任务。1=日常任务。2=军团任务
				end
			end


			if GetCorpsMission_FreeRefreshTimes() == 0 then
				local pData = GetCorpsMission_RefreshConfuse()
				local pConsData = pData.TabData[1]
				if pConsData.ItemId ~= nil then
					local Itemstr = GetItemNameByItemID(pConsData.ItemId)
					local ItemNeedNum = tonumber(pConsData.ItemNeedNum)
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1490,RefreshByNetWork, ItemNeedNum, Itemstr )
					pTips = nil
				else
					--是消耗的货币
					local CoinStr = GetCoinNameByConsumeType(pConsData.ConsumeType)
					local CoinNeedNum = tonumber(pConsData.ItemNeedNum)
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1490,RefreshByNetWork, CoinNeedNum, CoinStr )
					pTips = nil
				end
			else
				NetWorkLoadingLayer.loadingShow(true)	
				Packet_GetReceiveMissionCorpsRefresh.SetSuccessCallBack(RefreshCorpsMission)
				network.NetWorkEvent(Packet_GetReceiveMissionCorpsRefresh.CreatePacket()) --0=主线任务。1=日常任务。2=军团任务
			end

		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end

	--刷新按钮
	local Button_Refresh   = tolua.cast(m_Panel_Corps:getChildByName("Button_Refresh"),"Button")
	Button_Refresh:setTouchEnabled(true)
	Button_Refresh:addTouchEventListener(_Button_Corps_Refresh_CallBack)
	--排序数据
	InitCorpsUI_MissionList()
end

local function InitSpecialUI_MissionList( )
	--任务列表(判断是升级还是试炼)
	if m_IsBeginLevelUpTask == true then

		local pMessCWarDB = GetMissionDB_LevelUp()

		local pCountryDB  = pMessCWarDB["CWarMissionLevelUp"]
		local pPersonalDB = pMessCWarDB["PersonalMissionLevelUp"]

		local pInsertIndex = m_BeiginLevelUpIndex		

		local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionCountryWarItem.json")
		for i=1, table.getn(pCountryDB) do
			local pItem = CloneItemWidget(pTemp)
			if InitCWarItem(i, pCountryDB[i], pItem, 0, Mission_Type.Mission_Special) == true then
				m_ListView_MissionList_Special:insertCustomItem(pItem, pInsertIndex + 1)
				pInsertIndex = pInsertIndex + 1
			end
		end	

		for i=1, table.getn(pPersonalDB) do
			local pItem = CloneItemWidget(pTemp)
			local pListIndex = m_ListView_MissionList_Special:getItems():count()
			if InitCWarItem(i, pPersonalDB[i], pItem, 1, Mission_Type.Mission_Special) == true then
				m_ListView_MissionList_Special:insertCustomItem(pItem, pInsertIndex + 1)
				pInsertIndex = pInsertIndex + 1
			end
		end	

		--local pListCount = m_ListView_MissionList_Special:getItems():count()
		m_BeiginShiLianIndex = pInsertIndex + 1

	else

		return false

	end

	return true
end

local function InitSpecialUI_MissionList_ShiLian( )
	--任务列表(判断是升级还是试炼)
	if m_IsBeginShiLianTask == true then

		local pMessCWarDB = GetMissionDB_ShiLian()

		local pCountryDB  = pMessCWarDB["CWarMissionShiLian"]
		local pPersonalDB = pMessCWarDB["PersonalMissionShiLian"]

		local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionCountryWarItem.json")
		for i=1, table.getn(pCountryDB) do
			local pItem = CloneItemWidget(pTemp)
			local pListIndex = m_ListView_MissionList_Special:getItems():count()
			if InitCWarItem(i, pCountryDB[i], pItem, 0, Mission_Type.Mission_ShiLian) == true then
				m_ListView_MissionList_Special:insertCustomItem(pItem, pListIndex)
			end
		end	

		for i=1, table.getn(pPersonalDB) do
			local pItem = CloneItemWidget(pTemp)
			local pListIndex = m_ListView_MissionList_Special:getItems():count()
			if InitCWarItem(i, pPersonalDB[i], pItem, 1, Mission_Type.Mission_ShiLian) == true then
				m_ListView_MissionList_Special:insertCustomItem(pItem, pListIndex)
			end
		end	

		--local pListCount = m_ListView_MissionList_Special:getItems():count()
		--m_BeiginShiLianIndex = pListCount - 1

		UnlockTypeBtnTouch(true, 4) 		--试炼任务加载完checkbox解锁
		UnlockMissionItemTouch(true, 4)			

	else

		return false

	end

	return true
end

local function InitSpecialUI_LevelUp(  )

	local pMessCWarDB = GetMissionDB_LevelUp()

	local function GetLevelUpMissionBegin(  )
		--判断当前国家升级任务是否发布
		if GetMissionCountryWarType_LevelUp() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI or 
			GetMissionCountryWarType_LevelUp() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU or 
			GetMissionCountryWarType_LevelUp() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU then

			return true
		end

		return false
	end

	--国家升级任务

	if GetMissionCountryWarState_LevelUp() == 1 and GetLevelUpMissionBegin() == true then
		m_IsBeginLevelUpTask = true
		--国家升级任务已发布
		m_BeiginLevelUpIndex = 0 

		if InitSpecialUI_MissionList() == true then


		end	
	else
		print("国家升级任务未发布,删除ITEM")
		local nItemArray_CWar 			= m_ListView_MissionList_Special:getItems()
		local nMaxCount_CWar  			= nItemArray_CWar:count()
		print("m_BeiginShiLianIndex = "..m_BeiginShiLianIndex)
		for i=0,m_BeiginShiLianIndex do
			if i ~= m_BeiginLevelUpIndex and i ~= m_BeiginShiLianIndex then
				--local nItem = nItemArray_CWar:objectAtIndex(i-1)
				m_ListView_MissionList_Special:removeItem(i)
			end
		end
	end

end

local function InitSpecialUI_ShiLian(  )
	--国家试炼任务

    local function GetShiLianMissionBegin(  )
        --判断当前国家升级任务是否发布
        if GetMissionCountryWarType_ShiLian() == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_TRIAL then

            return true
        end

        return false
    end

    if GetShiLianMissionBegin() == true then
    	local Image_Bg = tolua.cast(m_ShiLianTitleLayer:getChildByName("Image_Bg"),"ImageView")
    	local pLabel = tolua.cast(Image_Bg:getChildByName("Label_Info"),"Label")
    	local pLabel_2 = tolua.cast(Image_Bg:getChildByName("Label_Info_2"),"Label")

		m_IsBeginShiLianTask = true
		--国家试炼任务已发布
		--之前有试炼任务存在需要先删除
		for i=m_ListView_MissionList_Special:getItems():count(), m_BeiginShiLianIndex, -1 do
			--print(i, m_BeiginShiLianIndex, m_ListView_MissionList_Special:getItems():count())
			--Pause()
			if m_ListView_MissionList_Special:getItems():count() - 1 ~= m_BeiginShiLianIndex then
				m_ListView_MissionList_Special:removeLastItem()
			end
		end

		--开始倒计时
		if InitSpecialUI_MissionList_ShiLian() == true then
			if GetMissionShiLianTime() == 0 then

				m_isBeginShiLianCount = false
				pLabel:setText("每周六14:30分开启，持续一小时")
				pLabel_2:setVisible(false)

			else

				m_ShiLianMissionDelayTime = GetMissionShiLianSurPlusTime()

				if m_ShiLianMissionDelayTime > 0 then   --还未结束	
					m_isBeginShiLianCount = true
					pLabel_2:setVisible(true)
					SetCWarSurplusTime(m_ShiLianMissionDelayTime, pLabel)
				else
					m_isBeginShiLianCount = false
					pLabel_2:setVisible(false)
					pLabel:setText("每周六14:30分开启，持续一小时")
				end

			end
		end	
    else
    	--清除倒计时
    	m_isBeginShiLianCount = false
    	pLabel_2:setVisible(false)
    	pLabel:setText("每周六14:30分开启，持续一小时")
    end
end


local function InitSpecialUI(  )
	m_ListView_MissionList_Special:setBounceEnabled(true)
	m_ListView_MissionList_Special:setClippingType(1)

	--先插入国家升级任务标题
	if m_ListView_MissionList_Special:getItems():count() == 0 then

    	local pLevelUpTitle = GUIReader:shareReader():widgetFromJsonFile("Image/MissionLevelUpTitle.json")
		m_ListView_MissionList_Special:pushBackCustomItem(pLevelUpTitle)

    	m_ShiLianTitleLayer = GUIReader:shareReader():widgetFromJsonFile("Image/MissionShilLianTitle.json")
		m_ListView_MissionList_Special:pushBackCustomItem(m_ShiLianTitleLayer)

	end

end

local function HeartBeat(  )
	if m_CurType == Mission_Type.Mission_CountryWar and m_isBeginCWarCount == true then
		--当前是国战任务界面并且可以开始国战任务计时时
		local Image_TimeBg = tolua.cast(m_Panel_CountryWar:getChildByName("Image_TimeBg"),"ImageView")
		local Label_Time   = tolua.cast(Image_TimeBg:getChildByName("Label_Time"),"Label")
		local Label_TimeTitle = tolua.cast(Image_TimeBg:getChildByName("Label_TimeTitle"),"Label")
		local Label_TimeTitle_2 = tolua.cast(Image_TimeBg:getChildByName("Label_TimeTitle_2"),"Label")

		if m_CWarMissionDelayTime >= 0 then
			
			m_CWarMissionDelayTime = m_CWarMissionDelayTime -1 
			SetCWarSurplusTime(m_CWarMissionDelayTime, Label_Time)
		else

			m_isBeginCWarCount = false

			local nStr1,nStr2 = GetCWarMissionReleaseTime()
			Label_TimeTitle_2:setText("每日"..nStr1.."和"..nStr2.."发布国家任务")
			Label_TimeTitle_2:setVisible(true)
			Label_TimeTitle:setVisible(false)
			Label_Time:setVisible(false)		

		end
	end

	if m_CurType == Mission_Type.Mission_Special and m_isBeginShiLianCount then
		--当前试炼任务界面并且可以开启倒计时
		local Image_Bg = tolua.cast(m_ShiLianTitleLayer:getChildByName("Image_Bg"),"ImageView")
		local pLabel = tolua.cast(Image_Bg:getChildByName("Label_Info"),"Label")
		local pLabel_2 = tolua.cast(Image_Bg:getChildByName("Label_Info_2"),"Label")
		if m_ShiLianMissionDelayTime > 0 then

			pLabel_2:setVisible(true)
			m_ShiLianMissionDelayTime = m_ShiLianMissionDelayTime - 1
			SetCWarSurplusTime(m_ShiLianMissionDelayTime, pLabel)		
		else

			local pLabel_2 = tolua.cast(Image_Bg:getChildByName("Label_Info_2"),"Label")
			pLabel_2:setVisible(false)
			m_isBeginShiLianCount = false
			pLabel:setText("每周六14:30分开启，持续一小时")

		end

	end

end

--开始国家升级任务（与国家试炼共用一个list）
function BeginCWarLevelUpMission(  )
	local nCountry = tonumber(server_mainDB.getMainData("nCountry"))
	local nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI
	print("nCountry = "..nCountry)
	if nCountry == 1 then
		print("请求魏国国家升级任务")
		nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI
	elseif nCountry == 2 then
		print("请求蜀国国家升级任务")
		nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU
	elseif nCountry == 3 then
		print("请求吴国国家升级任务")
		nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU
	end
	local function refreshCWarLevelupMission( )
		NetWorkLoadingLayer.loadingHideNow()
		InitSpecialUI()
		InitSpecialUI_LevelUp()
	end

	NetWorkLoadingLayer.loadingShow(true)	
	Packet_GetReceiveMissionCWarData.SetSuccessCallBack(refreshCWarLevelupMission, MissionSpecialType.Mission_LevelUp)
	network.NetWorkEvent(Packet_GetReceiveMissionCWarData.CreatePacket(nSendCountry)) 				--特殊任务
end
--开始国家试炼任务（与国家升级共用一个list）
function BeginCWarShiLianMission(  )
	local function refreshCWarShiLianMission( )
		NetWorkLoadingLayer.loadingHideNow()
		InitSpecialUI( )
		InitSpecialUI_ShiLian( )
	end

	NetWorkLoadingLayer.loadingShow(true)	
	Packet_GetReceiveMissionCWarData.SetSuccessCallBack(refreshCWarShiLianMission, MissionSpecialType.Mission_ShiLian)
	network.NetWorkEvent(Packet_GetReceiveMissionCWarData.CreatePacket(E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_TRIAL)) 				--特殊任务	
end

function BeginCWarMisiion(  )
	--接受到国战任务发布的消息
	m_ListView_MissionList_CountryWar:removeAllItems()

	local function refreshCWarMission( )
		NetWorkLoadingLayer.loadingHideNow()
		m_CWarFinishNum = 0
		m_CWarFinishNumTotal = 0
		InitCountryWarUI()
	end

	NetWorkLoadingLayer.loadingShow(true)	
	Packet_GetReceiveMissionCWarData.SetSuccessCallBack(refreshCWarMission)
	network.NetWorkEvent(Packet_GetReceiveMissionCWarData.CreatePacket(E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS))
end

function BeginCorpsMisiion(  )
	m_ListView_MissionList_Corps:removeAllItems()

	local function refreshCorpsMission( )
		NetWorkLoadingLayer.loadingHideNow()
		InitCorpsUI()
	end

	NetWorkLoadingLayer.loadingShow(true)	
	Packet_GetReceiveMissionCorpsData.SetSuccessCallBack(refreshCorpsMission)
	network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(2)) --0=主线任务。1=日常任务。2=军团任务
end

local function _Button_DailyBtn_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)

        SetCorpsLabelShow(false)
        
		local function openDailyMissionLayer( )
			m_CurType = Mission_Type.Mission_Daily

        	SetCheckBoxImageFalse() 		--还原checkbox
        	--1.更改已选checkbox
        	m_Image_DailyBtn:loadTexture("Image/imgres/button/btn_page_l.png")
        	--2.更换字体
        	if m_Image_DailyBtn:getChildByTag(99) ~= nil then
        		m_Image_DailyBtn:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nDailyLabel 		= StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "日常", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
        		m_Image_DailyBtn:addChild(nDailyLabel,1,99)
        	end
        	--3.显示界面，坐标重新设定
			m_Panel_Daily:setVisible(true)
			m_Panel_Daily:setPositionX(-398)
			--4.初始化列表
			InitDailyUI()
		end

        if m_Panel_Daily:isVisible() == false then
			if m_LoadDailyFinish == false then
				Packet_GetNormalMissionData.SetSuccessCallBack(openDailyMissionLayer)
				network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(1)) --0=主线任务。1=日常任务
			else
				openDailyMissionLayer()
				UnlockTypeBtnTouch(true, 1) 		--日常任务加载完checkbox解锁
				UnlockMissionItemTouch(true, 1)
				print("u already have the daily data in the table")
			end   
		else
			print("u have opened then daily layer ,now u just need to refresh u single mission or missionlist")    	
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_MainLineBtn_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)

        SetCorpsLabelShow(false)

        local function openMissionMainLineLayer( )
        	m_CurType = Mission_Type.Mission_MainLine

        	SetCheckBoxImageFalse() 		--还原checkbox
        	--1.更改已选checkbox
        	m_Image_MainLineBtn:loadTexture("Image/imgres/button/btn_page_l.png")
        	--2.更换字体
        	if m_Image_MainLineBtn:getChildByTag(99) ~= nil then
        		m_Image_MainLineBtn:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nMainLineLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "主线", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
        		m_Image_MainLineBtn:addChild(nMainLineLabel,1,99)
        	end
        	--3.显示界面，坐标重新设定
			m_Panel_MainLine:setVisible(true)
			m_Panel_MainLine:setPositionX(-398)
			--4.初始化列表
			InitMainLineUI()
		end
		if m_Panel_MainLine:isVisible() == false then
			if m_LoadMainLineFinish == false then				
				Packet_GetNormalMissionData.SetSuccessCallBack(openMissionMainLineLayer)
				network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(0)) --0=主线任务。1=日常任务
			else
				openMissionMainLineLayer()
				UnlockTypeBtnTouch(true, 0) 		--主线任务加载完checkbox解锁
				UnlockMissionItemTouch(true, 0)
				print("u already have the mainline data in the table")
			end
		else
			print("u have opened then mainline layer ,now u just need to refresh u single mission or missionlist")
		end

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_CountryWarBtn_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		if CheckCountryWarMissionOpen() == false then
			return
		end
        sender:setScale(1.0)

        SetCorpsLabelShow(false)

        local function openMissionCountryWarLayer( nState )
        	NetWorkLoadingLayer.loadingHideNow()

        	m_CurType = Mission_Type.Mission_CountryWar

        	SetCheckBoxImageFalse() 		--还原checkbox
        	--1.更改已选checkbox
        	m_Image_CountryWarBtn:loadTexture("Image/imgres/button/btn_page_l.png")
        	--2.更换字体
        	if m_Image_CountryWarBtn:getChildByTag(99) ~= nil then
        		m_Image_CountryWarBtn:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nCountryWarLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "国战", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
        		m_Image_CountryWarBtn:addChild(nCountryWarLabel,1,99)
        	end
        	--3.显示界面，坐标重新设定
			m_Panel_CountryWar:setVisible(true)
			m_Panel_CountryWar:setPositionX(-398)
			--4.初始化列表
			if nState == nil then
				InitCountryWarUI()
			end
		end
		if m_Panel_CountryWar:isVisible() == false then
			if m_LoadCountryWarFinish == false then			
				NetWorkLoadingLayer.loadingShow(true)	
				Packet_GetReceiveMissionCWarData.SetSuccessCallBack(openMissionCountryWarLayer)
				network.NetWorkEvent(Packet_GetReceiveMissionCWarData.CreatePacket(E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS)) --2 = 国战任务
			else
				openMissionCountryWarLayer(false)
				UnlockTypeBtnTouch(true, 2) 		--国战任务加载完checkbox解锁
				UnlockMissionItemTouch(true, 2)
				print("u already have the countrywar data in the table")
			end
		else
			print("u have opened then countrywar layer ,now u just need to refresh u single mission or missionlist")
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_CorpsBtn_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
		if CheckCorpsMissionOpen() == false then
			return
		end
        local function openMissionCorpsLayer( nState )
        	NetWorkLoadingLayer.loadingHideNow()

        	m_CurType = Mission_Type.Mission_Corps

        	SetCheckBoxImageFalse() 		--还原checkbox
        	--1.更改已选checkbox
        	m_Image_CorpsBtn:loadTexture("Image/imgres/button/btn_page_l.png")
        	--2.更换字体
        	if m_Image_CorpsBtn:getChildByTag(99) ~= nil then
        		m_Image_CorpsBtn:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nCorpsLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "军团", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
        		m_Image_CorpsBtn:addChild(nCorpsLabel,1,99)
        	end

	        if tonumber(server_mainDB.getMainData("nCorps")) == 0 then

	        	SetCorpsLabelShow(true)

	        	UnlockTypeBtnTouch(true, 3) 		--国战任务加载完checkbox解锁
				UnlockMissionItemTouch(true, 3)

	        	return

	        else
	        	--3.显示界面，坐标重新设定
				m_Panel_Corps:setVisible(true)
				m_Panel_Corps:setPositionX(-398)
				--4.初始化列表
				if nState == nil then
					InitCorpsUI()	
				end
	        end

		end
		if m_Panel_Corps:isVisible() == false then
			if m_LoadCorpsFinish == false then			
				NetWorkLoadingLayer.loadingShow(true)	
				Packet_GetReceiveMissionCorpsData.SetSuccessCallBack(openMissionCorpsLayer)
				network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(2)) --0=主线任务。1=日常任务。2=军团任务
			else
				openMissionCorpsLayer(false)
				UnlockTypeBtnTouch(true, 4) 		--军团任务加载完checkbox解锁
				UnlockMissionItemTouch(true, 4)
				print("u already have the corps data in the table")
			end
		else
			print("u have opened then corps layer ,now u just need to refresh u single mission or missionlist")
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_SpecialBtn_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		if CheckCountryWarMissionOpen() == false then
			return
		end
        sender:setScale(1.0)

        SetCorpsLabelShow(false)

        local function openMissionSpecialLayer( nState )
        	NetWorkLoadingLayer.loadingHideNow()

        	m_CurType = Mission_Type.Mission_Special

        	SetCheckBoxImageFalse() 		--还原checkbox
        	--1.更改已选checkbox
        	m_Image_SpecialBtn:setScale(1.3)

        	--3.显示界面，坐标重新设定
			m_Panel_Special:setVisible(true)
			m_Panel_Special:setPositionX(-398)
			--4.初始化列表
			if nState == nil then
				InitSpecialUI()
				InitSpecialUI_LevelUp()
			end

			--开始国家试炼任务请求
			if m_loadSpecialFinish == false then
				BeginCWarShiLianMission()
			else
				print("u already have the special shilian data in the table")
			end
		end
		if m_Panel_Special:isVisible() == false then
			if m_loadSpecialFinish == false then	

				local nCountry = tonumber(server_mainDB.getMainData("nCountry"))
				local nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI
				print("nCountry = "..nCountry)
				if nCountry == 1 then
					print("请求魏国国家升级任务—Click")
					nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI
				elseif nCountry == 2 then
					print("请求蜀国国家升级任务—Click")
					nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU
				elseif nCountry == 3 then
					print("请求吴国国家升级任务—Click")
					nSendCountry = E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU
				end

				NetWorkLoadingLayer.loadingShow(true)	
				Packet_GetReceiveMissionCWarData.SetSuccessCallBack(openMissionSpecialLayer, MissionSpecialType.Mission_LevelUp)
				network.NetWorkEvent(Packet_GetReceiveMissionCWarData.CreatePacket(nSendCountry)) 				--特殊任务
			else
				openMissionSpecialLayer(false)
				UnlockTypeBtnTouch(true, 4) 		--特殊任务加载完checkbox解锁
				UnlockMissionItemTouch(true, 4)
				print("u already have the special data in the table")
			end
		else
			print("u have opened then special layer ,now u just need to refresh u single mission or missionlist")
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function DeleteMission( nTaskID )
	local pGroupID 						 = GetTaskGroupID_MainLine(nTaskID)
	local Panel_MainLine 	   			 = tolua.cast(m_MissionNormalLayer:getWidgetByName("Panel_MainLine"),"Layout")
    local ListView_MissionList_MainLine  = tolua.cast(Panel_MainLine:getChildByName("ListView_MissionList_MainLine"),"ListView")
	local nItemArray 					 = ListView_MissionList_MainLine:getItems()
	local nMaxCount  					 = nItemArray:count()
	print("开始删除任务！！！！")
	for i=1,nMaxCount do
		local nItem = nItemArray:objectAtIndex(i-1)
		local nItemGroupID = GetTaskGroupID_MainLine(nItem:getTag())
		--print(tonumber(pGroupID), tonumber(nItemGroupID))
		if tonumber(pGroupID) == tonumber(nItemGroupID) then
			print("删除任务"..i)
			ListView_MissionList_MainLine:removeItem(i-1)
			m_TabMissionIndex["NotFinishedBeginIndex"] = m_TabMissionIndex["NotFinishedBeginIndex"] - 1
			break
		end
	end
end

function UpdateDailyBox( nBoxIndex, nBoxState, nBoxScore )
	if m_MissionNormalLayer == nil then
		return 
	end

	if nBoxScore == -1 then
		return
	end

	local Progress_Mission = tolua.cast(m_Panel_Daily:getChildByName("ProgressBar_Mission"),"LoadingBar")

	local nStage 	   	   = GetScoreStage(CommonData.g_MainDataTable.level)			--当前积分阶段

	local nMaxScore        = GetBoxMaxScore(nStage)

	local nSizeWidth       = Progress_Mission:getSize().width

	local nLastLinePosX    = -nSizeWidth * 0.5 

	local Label_InterNum		= tolua.cast(m_Panel_Daily:getChildByName("Label_InterNum"),"Label")
	Label_InterNum:setText(nBoxScore)

	Progress_Mission:setPercent( (nBoxScore / nMaxScore) * 100 )

	for i=1,4 do

		local nScore 	   = GetBoxScore(nStage, i)

		local nScorePer    = nScore / nMaxScore

		local nPosX        = nSizeWidth * nScorePer - nSizeWidth * 0.5

		if i < 4 then 
			if Progress_Mission:getNodeByTag(110 + i) ~= nil then 
				Progress_Mission:getNodeByTag(110 + i):setPositionX(nPosX)
				Progress_Mission:getNodeByTag(110 + i):setPositionY(0)
			else
				local nlineSp      = CCSprite:create("Image/imgres/corps/flap.png")
				nlineSp:setPositionX(nPosX)
				nlineSp:setPositionY(0)
				Progress_Mission:addNode(nlineSp,11,110 + i)
			end
		end

		local diffWidth = nil
		if nPosX > nLastLinePosX then
			diffWidth = ( nPosX - nLastLinePosX ) * 0.5
		else
			diffWidth = ( nLastLinePosX - nPosX ) * 0.5
		end

		if Progress_Mission:getChildByTag(210 + i) ~= nil then
			LabelLayer.setText(Progress_Mission:getChildByTag(210 + i), nScore)
		end

	end

	if nBoxIndex == -1 then
		return
	end

	local pAniStrNum = nil
	if nBoxIndex == 1 then
		--木箱子
		pAniStrNum = 5
	elseif nBoxIndex == 2 then
		--宝箱
		pAniStrNum = 9
	elseif nBoxIndex == 3 then
		--金箱子
		pAniStrNum = 1
	elseif nBoxIndex == 4 then
		--钻石箱子
		pAniStrNum = 13
	else
		pAniStrNum = 1
	end

	local function _Button_ReceiveRewardBox_CallBack( sender, eventType )
		local Progress_Mission 		= tolua.cast(m_Panel_Daily:getChildByName("ProgressBar_Mission"),"LoadingBar")
		if eventType == TouchEventType.ended then
			if Progress_Mission:getNodeByTag(310 + sender:getTag()) ~= nil then
				Progress_Mission:getNodeByTag(310 + sender:getTag()):setScale(0.6)
				local nStage 	   = GetScoreStage(CommonData.g_MainDataTable.level)			--当前积分阶段
				local nScore 	   = GetBoxScore(nStage, sender:getTag())
				local nBoxRewardID = GetBoxRewardID(sender:getTag())

				local function ReceiveCallback()
					local function ReceiveSuccessByBox()

					end
					Packet_GetReceiveMissionBoxData.SetSuccessCallBack(ReceiveSuccessByBox)
					network.NetWorkEvent(Packet_GetReceiveMissionBoxData.CreatePacket(sender:getTag() - 1)) -- 宝箱索引
				end

				if nBoxState == Mission_State.FinishedNotReceived then
					--显示领取按钮
					local pRewardLayer = MissionNormalRewardLayer.CreateMissionNormalRewardLayer(Mission_State.FinishedNotReceived, nScore, nBoxRewardID, ReceiveCallback)
					if pRewardLayer ~= nil then 
						m_MissionNormalLayer:addChild(pRewardLayer,9999)
					end
				else
					--不显示领取按钮
					local pRewardLayer = MissionNormalRewardLayer.CreateMissionNormalRewardLayer(Mission_State.NotFinished, nScore, nBoxRewardID)
					if pRewardLayer ~= nil then 
						m_MissionNormalLayer:addChild(pRewardLayer,9999)
					end
				end
			end
		elseif eventType == TouchEventType.began then
			if Progress_Mission:getNodeByTag(310 + sender:getTag()) ~= nil then
				Progress_Mission:getNodeByTag(310 + sender:getTag()):setScale(0.5)
			end
		elseif eventType == TouchEventType.canceled then
			if Progress_Mission:getNodeByTag(310 + sender:getTag()) ~= nil then
				Progress_Mission:getNodeByTag(310 + sender:getTag()):setScale(0.6)
			end
		end
	end

	if Progress_Mission:getNodeByTag(310 + nBoxIndex) ~= nil then 

		if nBoxState == Mission_State.NotFinished then
			Progress_Mission:getNodeByTag(310 + nBoxIndex):getAnimation():play("Animation"..pAniStrNum)
		elseif nBoxState == Mission_State.FinishedNotReceived then
			Progress_Mission:getNodeByTag(310 + nBoxIndex):getAnimation():play("Animation"..pAniStrNum + 1)
		elseif nBoxState == Mission_State.HaveReceived then
			Progress_Mission:getNodeByTag(310 + nBoxIndex):getAnimation():play("Animation"..pAniStrNum + 2)
			Progress_Mission:getNodeByTag(310 + nBoxIndex):getAnimation():gotoAndPlay(28)
		end

		Progress_Mission:getChildByTag(nBoxIndex):addTouchEventListener(_Button_ReceiveRewardBox_CallBack)
	end

end

--刷新一组数据
function MissionUpdateByArray( nType )
	if tonumber(nType) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS then

		print("更新国家任务的组任务")

		if m_MissionNormalLayer ~= nil and m_ListView_MissionList_CountryWar ~= nil then
			local nCWarTab = GetCWarArrayDB()
			local nTab = nCWarTab["CWarArray"]
			local nSurPTime = nCWarTab["SurPlusTime"]
			if nSurPTime <= 0 then
				print("国家任务结束")

				--[[if m_nHanderTime ~= nil then
					m_Panel_CountryWar:getScheduler():unscheduleScriptEntry(m_nHanderTime)
					m_nHanderTime = nil
				end]]

				local Image_TimeBg = tolua.cast(m_Panel_CountryWar:getChildByName("Image_TimeBg"),"ImageView")
				local Label_TimeTitle = tolua.cast(Image_TimeBg:getChildByName("Label_TimeTitle"),"Label")
				local Label_Time   = tolua.cast(Image_TimeBg:getChildByName("Label_Time"),"Label")
				local Label_TimeTitle_2 = tolua.cast(Image_TimeBg:getChildByName("Label_TimeTitle_2"),"Label")

				local nStr1,nStr2 = GetCWarMissionReleaseTime()
				Label_TimeTitle_2:setText("每日"..nStr1.."和"..nStr2.."发布国家任务")
				Label_TimeTitle_2:setVisible(true)
				Label_TimeTitle:setVisible(false)
				Label_Time:setVisible(false)	
			end
			local nItemArray_CWar 			= m_ListView_MissionList_CountryWar:getItems()
			local nMaxCount_CWar  			= nItemArray_CWar:count()
			for key,value in pairs(nTab) do
				local nIndex 		= value["Index"]
				local nTaskState  	= value["TaskState"]
				local pCount        = value["Count"]
				local pTaskID       = value["TaskID"]
				print("刷新国家任务"..nIndex)
				for i=1,nMaxCount_CWar do
					local nItem = nItemArray_CWar:objectAtIndex(i-1)
					if tonumber(nItem:getTag()) == nIndex then
						local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
						local Button_Goto  = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
						local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
						local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
						local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
					
						if nTaskState ~= Mission_State.NotFinished then

							Image_MissionState:setVisible(true)
							Image_MissionState:loadTexture("Image/imgres/mission/win.png")
							Button_Goto:setVisible(false)
							Button_Goto:setTouchEnabled(false)
							Image_MissionState_2:setVisible(true)
							Image_ProgressBar:setVisible(false)

							if nTaskState == Mission_State.FinishedNotReceived then --如果当前任务变成可领取
								print("任务"..nIndex.."可领取")
								Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")

								for i=1,4 do
									local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
									local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
									Image_Reward:setVisible(true)
									if tostring(Label_Reward:getStringValue()) ~= "" then
										Image_Reward:setVisible(true)
									end
								end
								nItem:setTouchEnabled(true)

								m_CWarFinishNum = m_CWarFinishNum + 1

								RefreshCWarLoadingBar()

							elseif nTaskState == Mission_State.HaveReceived then    --如果当前任务可变已领取
								print("国家任务索引"..nIndex.."已领取")

								nItem:setTouchEnabled(false)
								Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")
							elseif nTaskState == Mission_State.MissionFaied then
								print("国家任务索引"..nIndex.."已失败")
								nItem:setTouchEnabled(false)

								Image_MissionState:loadTexture("Image/imgres/mission/lose.png")
								Image_MissionState:setVisible(true)

								Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
								Image_MissionState_2:setVisible(true)
							end
						else
							print("国家任务索引"..nIndex.."未完成")
							local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
							local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
							local pFinishNum = GetCondNum(pTaskID)
							if pFinishNum == 0 then
								pFinishNum = 1 
							end
							Label_Percent:setText(pCount.."/"..pFinishNum)

							local nPer = pCount / pFinishNum

							ProgressBar_Mission:setPercent(nPer * 100)

							nItem:setTouchEnabled(false)
						end

						break
					end

				end
			end		
		end		

	elseif tonumber(nType) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI or
	   tonumber(nType) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU or
	   tonumber(nType) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU then

		print("更新国家升级任务的组任务")

		if m_MissionNormalLayer ~= nil and m_ListView_MissionList_Special ~= nil then

			local nCWarTab = GetCWarArrayDB_LevelUp()
			local nTab = nCWarTab["CWarArray"]

			local nItemArray_CWar 			= m_ListView_MissionList_Special:getItems()
			local nMaxCount_CWar  			= nItemArray_CWar:count()
			for key,value in pairs(nTab) do
				local nIndex 		= value["Index"]
				local nTaskState  	= value["TaskState"]
				local pCount        = value["Count"]
				local pTaskID       = value["TaskID"]
				print("刷新国家升级任务"..nIndex)
				for i=1,nMaxCount_CWar do
					if i-1 ~= m_BeiginLevelUpIndex and i-1 ~= m_BeiginShiLianIndex then
						local nItem = nItemArray_CWar:objectAtIndex(i-1)
						--print(nItem:getTag(), nIndex)
						--Pause()
						if tonumber(nItem:getTag()) == nIndex and tonumber(pTaskID) ~= 0 then
							local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
							local Button_Goto  = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
							local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
							local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
							local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
						
							if nTaskState ~= Mission_State.NotFinished then

								Image_MissionState:setVisible(true)
								Image_MissionState:loadTexture("Image/imgres/mission/win.png")
								Button_Goto:setVisible(false)
								Button_Goto:setTouchEnabled(false)
								Image_MissionState_2:setVisible(true)
								Image_ProgressBar:setVisible(false)

								if nTaskState == Mission_State.FinishedNotReceived then --如果当前任务变成可领取
									print("国家升级任务"..nIndex.."可领取")
									Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")

									for i=1,4 do
										local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
										local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
										if tostring(Label_Reward:getStringValue()) ~= "" then
											Image_Reward:setVisible(true)
										end
									end
									nItem:setTouchEnabled(true)

								elseif nTaskState == Mission_State.HaveReceived then    --如果当前任务可变已领取
									print("国家升级任务索引"..nIndex.."已领取")

									nItem:setTouchEnabled(false)
									Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")
									for i=1,4 do
										local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
										local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
										if tostring(Label_Reward:getStringValue()) ~= "" then
											Image_Reward:setVisible(true)
										end
									end

								elseif nTaskState == Mission_State.MissionFaied then
									print("国家升级任务索引"..nIndex.."已失败")
									nItem:setTouchEnabled(false)

									Image_MissionState:loadTexture("Image/imgres/mission/lose.png")
									Image_MissionState:setVisible(true)

									Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
									Image_MissionState_2:setVisible(true)
								end
							else
								print("国家升级任务索引"..nIndex.."未完成"..pTaskID)
								local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
								local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
								local pFinishNum = GetCondNum(pTaskID)
								if pFinishNum == 0 then
									pFinishNum = 1 
								end
								Label_Percent:setText(pCount.."/"..pFinishNum)

								local nPer = pCount / pFinishNum

								ProgressBar_Mission:setPercent(nPer * 100)

								nItem:setTouchEnabled(false)
							end

							break
						end
					end
				end
			end		
		end		
	elseif tonumber(nType) == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_TRIAL then
		print("更新国家试炼任务的组任务")

		if m_MissionNormalLayer ~= nil and m_ListView_MissionList_Special ~= nil then

			local nCWarTab = GetCWarArrayDB_ShiLian()
			local nTab = nCWarTab["CWarArray"]

			local nItemArray_CWar 			= m_ListView_MissionList_Special:getItems()
			local nMaxCount_CWar  			= nItemArray_CWar:count()
			for key,value in pairs(nTab) do
				local nIndex 		= value["Index"]
				local nTaskState  	= value["TaskState"]
				local pCount        = value["Count"]
				local pTaskID       = value["TaskID"]
				print("刷新国家试炼任务"..nIndex)
				for i=m_BeiginShiLianIndex+1, nMaxCount_CWar do
					if i-1 ~= m_BeiginShiLianIndex or i-1 ~= m_BeiginLevelUpIndex then
						local nItem = nItemArray_CWar:objectAtIndex(i-1)
						if tonumber(nItem:getTag()) == nIndex then
							local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
							local Button_Goto  = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
							local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
							local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
							local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
						
							if nTaskState ~= Mission_State.NotFinished then

								Image_MissionState:setVisible(true)
								Image_MissionState:loadTexture("Image/imgres/mission/win.png")
								Button_Goto:setVisible(false)
								Button_Goto:setTouchEnabled(false)
								Image_MissionState_2:setVisible(true)
								Image_ProgressBar:setVisible(false)

								if nTaskState == Mission_State.FinishedNotReceived then --如果当前任务变成可领取
									print("国家试炼任务"..nIndex.."可领取")
									Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")

									for i=1,4 do
										local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
										local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
										if tostring(Label_Reward:getStringValue()) ~= "" then
											Image_Reward:setVisible(true)
										end
									end
									nItem:setTouchEnabled(true)

								elseif nTaskState == Mission_State.HaveReceived then    --如果当前任务可变已领取
									print("国家试炼任务索引"..nIndex.."已领取")

									nItem:setTouchEnabled(false)
									Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")
									for i=1,4 do
										local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
										local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
										if tostring(Label_Reward:getStringValue()) ~= "" then
											Image_Reward:setVisible(true)
										end
									end

								elseif nTaskState == Mission_State.MissionFaied then
									print("国家试炼任务索引"..nIndex.."已失败")
									nItem:setTouchEnabled(false)

									Image_MissionState:loadTexture("Image/imgres/mission/lose.png")
									Image_MissionState:setVisible(true)

									Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
									Image_MissionState_2:setVisible(true)
								end
							else
								print("国家试炼任务索引"..nIndex.."未完成")
								local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
								local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
								local pFinishNum = GetCondNum(pTaskID)
								if pFinishNum == 0 then
									pFinishNum = 1 
								end
								Label_Percent:setText(pCount.."/"..pFinishNum)

								local nPer = pCount / pFinishNum

								ProgressBar_Mission:setPercent(nPer * 100)

								nItem:setTouchEnabled(false)
							end

							break
						end
					end
				end
			end		
		end			
	end
end

--单个任务更新
function MissionUpdateBySingle( nTaskType, nTaskID, nTaskState, nRewardID, nCount, nTakeTime, nIndex )
	if m_MissionNormalLayer ~= nil then
		local pTaskExampleID = nil
		local pGroupID 		 = nil
		--print( nTaskType, nTaskID, nTaskState, nRewardID, nCount, nTakeTime, nIndex )
		--Pause()
		if nTaskID > 0 then
			if nTaskType == Mission_Type.Mission_MainLine then
				pTaskExampleID = GetTaskExampleID_MainLine(nTaskID)
				pGroupID       = GetTaskGroupID_MainLine(nTaskID)			
			elseif nTaskType == Mission_Type.Mission_Daily then
				pTaskExampleID = GetTaskExampleID(nTaskID)
			elseif nTaskType == Mission_Type.Mission_CountryWar then
				pTaskExampleID = nIndex
			elseif nTaskType == Mission_Type.Mission_Corps then
				pTaskExampleID = nIndex
			elseif nTaskType == Mission_Type.Mission_Special then
				pTaskExampleID = nIndex
			elseif nTaskType == Mission_Type.Mission_ShiLian then
				pTaskExampleID = nIndex
			end

			if nTaskType == Mission_Type.Mission_MainLine then
				print("刷新主线任务"..pTaskExampleID..",组ID为 = "..pGroupID)
				local nItemArray 					 = m_ListView_MissionList_MainLine:getItems()
				local nMaxCount  					 = nItemArray:count()
				for i=1,nMaxCount do
					local nItem = nItemArray:objectAtIndex(i-1)
					local nItemGroupID = nil
					if nItem:getTag() < 20000 then
						nItemGroupID = GetTaskGroupID_MainLine(nItem:getTag())
						--print("nItemGroupID = "..nItemGroupID)
					end
					--print(tonumber(pGroupID), tonumber(nItemGroupID))
					if nItemGroupID ~= nil then
						if tonumber(pGroupID) == tonumber(nItemGroupID) then
							local pMisDB = {}
							pMisDB["TaskID"] = nTaskID
							pMisDB["TaskState"] = nTaskState
							pMisDB["RewardID"] = nRewardID
							pMisDB["Count"] = nCount
							pMisDB["TakeTime"] = nTakeTime

							if tonumber(nItem:getTag()) == tonumber(nTaskID) then
								print("更新旧任务")  
								if nTaskState == Mission_State.FinishedNotReceived then
									nItem:setTouchEnabled(true)
									--已存在的未完成任务变成了已完成
									local pNewItem_1 = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
									if InitMainLineItem(m_ListView_MissionList_MainLine, pNewItem_1, pMisDB, i) == true then
										m_ListView_MissionList_MainLine:removeItem(i-1)
										m_ListView_MissionList_MainLine:insertCustomItem(pNewItem_1, 0)
										m_TabMissionIndex["NotFinishedBeginIndex"] = m_TabMissionIndex["NotFinishedBeginIndex"] + 1
										print("已存在的未完成任务变成了已完成 NotFinishedBeginIndex = "..m_TabMissionIndex["NotFinishedBeginIndex"])
									end
								elseif nTaskState == Mission_State.NotFinished then
									nItem:setTouchEnabled(false)
									local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
									local Label_MissionNum = tolua.cast(Image_ItemBg:getChildByName("Label_MissionNum"),"Label")
									local pFinishNum = GetCondNum(pTaskExampleID)
									if pFinishNum == 0 then
										pFinishNum = 1 
									end
									Label_MissionNum:setText(nCount.."/"..pFinishNum)
									print("刷新任务完成数为"..nCount)
								end
								break
							else
								print("新任务")		
								if nTaskState == Mission_State.FinishedNotReceived then
									--如果现在新的Item状态为完成未领取，则上移到第一位
									local pNewItem = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
									pNewItem:setTouchEnabled(false)
									if InitMainLineItem(m_ListView_MissionList_MainLine, pNewItem, pMisDB, i) == true then
										m_ListView_MissionList_MainLine:removeItem(i-1)
										m_ListView_MissionList_MainLine:insertCustomItem(pNewItem, 0)
									end
									print("new mission insert list head")
								elseif nTaskState == Mission_State.NotFinished then
									--如果现在新的Item状态为未完成，则肯定是从已完成向未完成变化，则下移到未完成列表第一位
									print("NotFinishedBeginIndex = "..m_TabMissionIndex["NotFinishedBeginIndex"])
									local pNewItem = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
									pNewItem:setTouchEnabled(false)
									if InitMainLineItem(m_ListView_MissionList_MainLine, pNewItem, pMisDB, i) == true then
										m_ListView_MissionList_MainLine:insertCustomItem(pNewItem, m_TabMissionIndex["NotFinishedBeginIndex"])
										m_ListView_MissionList_MainLine:removeItem(i-1)
									end
									m_TabMissionIndex["NotFinishedBeginIndex"] = m_TabMissionIndex["NotFinishedBeginIndex"] - 1
									print("排序之后NotFinishedBeginIndex = "..m_TabMissionIndex["NotFinishedBeginIndex"])
								elseif nTaskState == Mission_State.MissionLock then
									--如果新的item状态为未解锁，则放入整个list的最后
									print("new mission insert list end")
									local pNewItem = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
									pNewItem:setTouchEnabled(false)
									if InitMainLineItem(m_ListView_MissionList_MainLine, pNewItem, pMisDB, i) == true then
										m_ListView_MissionList_MainLine:removeItem(i-1)
										m_ListView_MissionList_MainLine:pushBackCustomItem(pNewItem)		
									end								
								end
								break
							end
						end
					end
					
				end
			elseif nTaskType == Mission_Type.Mission_Daily then 
				print("刷新日常任务"..pTaskExampleID)
				print("nTaskState = "..nTaskState)

			    local function SortItem( _ItemArr, _MaxCount, _OriginIndex )
				    local tabAll = {}

				    for j=1,_MaxCount do
				    	local tabItemTag = {}
				    	local nItem_Px = _ItemArr:objectAtIndex(j-1)
				    	local Image_ItemBg_Px = tolua.cast(nItem_Px:getChildByName("Image_ItemBg"),"ImageView")
				    	tabItemTag["TaskState"] = Image_ItemBg_Px:getTag()  --任务状态
				    	tabItemTag["TaskID"] 	= nItem_Px:getTag()  --任务ID
				    	tabItemTag["Index"] 	= j-1 
				    	tabAll[j] = tabItemTag
				    end

				    SortMissionByState_2( tabAll, false )

				    for k, v in pairs( tabAll ) do
				    	if tonumber(v["Index"]) == tonumber(_OriginIndex) then
				    		return k-1
				    	end
				    end

			    end

				if nTaskState == Mission_State.NotFinished then  
					--任务状态还是未完成，但进度发送变化
					local nItemArray 			= m_ListView_MissionList:getItems()
					local nMaxCount  			= nItemArray:count()

					for i=1,nMaxCount do
						local nItem = nItemArray:objectAtIndex(i-1)
						if tonumber(nItem:getTag()) == tonumber(nTaskID) then
							local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
							local Label_MissionNum = tolua.cast(Image_ItemBg:getChildByName("Label_MissionNum"),"Label")
							local pFinishNum = GetCondNum(pTaskExampleID)
							if pFinishNum == 0 then
								pFinishNum = 1 
							end
							Label_MissionNum:setText(nCount.."/"..pFinishNum)
							break
						end
					end
				elseif nTaskState == Mission_State.FinishedNotReceived then
					--任务状态由未完成变成已完成
					print("日常任务状态由未完成变成已完成")
					local nItemArray 			= m_ListView_MissionList:getItems()
					local nMaxCount  			= nItemArray:count()

					for i=1,nMaxCount do
						local nItem = nItemArray:objectAtIndex(i-1)
						if tonumber(nItem:getTag()) == tonumber(nTaskID) then
							local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
							local Image_NameBg = tolua.cast(Image_ItemBg:getChildByName("Image_NameBg"),"ImageView")
							Image_ItemBg:setTag(nTaskState)
							local Image_Receive = tolua.cast(Image_ItemBg:getChildByName("Image_Receive"),"ImageView")
							local Button_GotoMission = tolua.cast(Image_ItemBg:getChildByName("Button_GotoMission"),"Button")
							local Label_MissionNum = tolua.cast(Image_ItemBg:getChildByName("Label_MissionNum"),"Label")
							Label_MissionNum:setVisible(false)
							--完成未领取
							Button_GotoMission:setTouchEnabled(false)
							Button_GotoMission:setPositionX(10000)
							nItem:setTouchEnabled(true)
							--动画效果
							CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/shijierenwu/shijierenwu.ExportJson")
						    local pArmature = CCArmature:create("shijierenwu")
						    pArmature:getAnimation():play("Animation1")
						    pArmature:setPosition(ccp(556, 71))
						    nItem:addNode(pArmature,99,99)
						    --可领取字样
						    Image_Receive:setVisible(false)
				    		nItem:retain()

						    --对item进行排序
						    local pNewIndex = SortItem( nItemArray, nMaxCount, i-1 )

						    m_ListView_MissionList:removeItem(i-1)

						    m_ListView_MissionList:insertCustomItem(nItem, pNewIndex)
							nItem:release()

							break
						end
					end
				elseif nTaskState == Mission_State.HaveReceived then
					--任务状态由已完成变成已领取
					local nItemArray 			= m_ListView_MissionList:getItems()
					local nMaxCount  			= nItemArray:count()

					for i=1,nMaxCount do
						local nItem = nItemArray:objectAtIndex(i-1)
						if tonumber(nItem:getTag()) == tonumber(nTaskID) then
							local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
							local Image_NameBg = tolua.cast(Image_ItemBg:getChildByName("Image_NameBg"),"ImageView")
							local Image_Receive = tolua.cast(Image_ItemBg:getChildByName("Image_Receive"),"ImageView")
							local Image_receiveReward = tolua.cast(Image_ItemBg:getChildByName("Image_receiveReward"),"ImageView")
							local Button_GotoMission = tolua.cast(Image_ItemBg:getChildByName("Button_GotoMission"),"Button")
							Image_ItemBg:setTag(nTaskState)
							if nItem:getNodeByTag(99) ~= nil then
								nItem:getNodeByTag(99):removeFromParentAndCleanup(true)
							end
							if Image_NameBg:getChildByTag(100) ~= nil then
								Image_NameBg:getChildByTag(100):removeFromParentAndCleanup(true)
							end

							nItem:setTouchEnabled(false)
							nItem:retain()

							Button_GotoMission:setTouchEnabled(false)
							Image_receiveReward:setVisible(true)
							UpdateItemStatus(Image_ItemBg, true)

							local Image_receiveReward_sprite = tolua.cast(Image_receiveReward:getVirtualRenderer(), "CCSprite")
							SpriteSetGray(Image_receiveReward_sprite, 1)

						    local pNewIndex = SortItem( nItemArray, nMaxCount, i-1 )

						    m_ListView_MissionList:removeItem(i-1)

						    m_ListView_MissionList:insertCustomItem(nItem, pNewIndex)
							nItem:release()

 							break
						end
					end										
				end
			elseif nTaskType == Mission_Type.Mission_CountryWar then
				print("单个刷新刷新国家任务"..nIndex)
				local nItemArray_CWar 			= m_ListView_MissionList_CountryWar:getItems()
				local nMaxCount_CWar  			= nItemArray_CWar:count()

				for i=1,nMaxCount_CWar do
					local nItem = nItemArray_CWar:objectAtIndex(i-1)
					if tonumber(nItem:getTag()) == pTaskExampleID then
						local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
						local Button_Goto  = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
						local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
						local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
						local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
						local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
						local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")

						if nTaskState == Mission_State.FinishedNotReceived then --如果当前任务变成可领取
							print("单个刷新任务"..pTaskExampleID.."可领取")
							nItem:setTouchEnabled(true)
							Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")

							for i=1,4 do
								local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
								local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
								if tostring(Label_Reward:getStringValue()) ~= "" then
									Image_Reward:setVisible(true)
								end
							end

							Button_Goto:setEnabled(false)

							m_CWarFinishNum = m_CWarFinishNum + 1

							RefreshCWarLoadingBar()

						elseif nTaskState == Mission_State.HaveReceived then    --如果当前任务可变已领取
							print("单个刷新国家任务索引"..pTaskExampleID.."已领取")

							Image_MissionState:setVisible(true)
							Image_MissionState:loadTexture("Image/imgres/mission/win.png")
							Button_Goto:setEnabled(false)
							Image_MissionState_2:setVisible(true)
							Image_ProgressBar:setVisible(false)

							nItem:setTouchEnabled(false)
							Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")
						elseif nTaskState == Mission_State.MissionFaied then
							print("单个刷新国家任务索引"..pTaskExampleID.."已失败")
							nItem:setTouchEnabled(false)

							Image_MissionState:loadTexture("Image/imgres/mission/lose.png")
							Image_MissionState:setVisible(true)

							Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
							Image_MissionState_2:setVisible(true)

							Button_Goto:setEnabled(false)
						elseif nTaskState == Mission_State.NotFinished then
							print("单个刷新国家任务索引"..pTaskExampleID.."未完成")
							local pFinishNum = GetCondNum(nTaskID)
							if pFinishNum == 0 then
								pFinishNum = 1 
							end
							Label_Percent:setText(nCount.."/"..pFinishNum)

							local nPer = nCount / pFinishNum

							ProgressBar_Mission:setPercent(nPer * 100)
						end

						break
					end
				end
			elseif nTaskType == Mission_Type.Mission_Corps then
				print("单个刷新军团任务"..nIndex)
				local nItemArray_Corps 			= m_ListView_MissionList_Corps:getItems()
				local nMaxCount_Corps  			= nItemArray_Corps:count()	
				--print( nTaskType, nTaskID, nTaskState, nRewardID, nCount, nTakeTime, nIndex )
				--Pause()
				for i=1,nMaxCount_Corps do
					local nItem = nItemArray_Corps:objectAtIndex(i-1)
					--print(nItem:getTag(), pTaskExampleID)
					--Pause()
					if tonumber(nItem:getTag()) == pTaskExampleID then
						local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
						local Button_Goto  = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
						local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
						local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
						local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
						local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
						local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")

						if nTaskState == Mission_State.FinishedNotReceived then --如果当前任务变成可领取
							print("单个刷新任务"..pTaskExampleID.."可领取")
							nItem:setTouchEnabled(true)
							Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")

							for i=1,4 do
								local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
								local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
								if tostring(Label_Reward:getStringValue()) ~= "" then
									Image_Reward:setVisible(true)
								end
							end

							Button_Goto:setVisible(false)
							Button_Goto:setEnabled(false)

						elseif nTaskState == Mission_State.HaveReceived then    --如果当前任务可变已领取
							print("单个刷新军团任务索引"..pTaskExampleID.."已领取")

							Image_MissionState:setVisible(true)
							Image_MissionState:loadTexture("Image/imgres/mission/win.png")

							Button_Goto:setVisible(false)
							Button_Goto:setEnabled(false)

							Image_MissionState_2:setVisible(true)
							Image_ProgressBar:setVisible(false)

							nItem:setTouchEnabled(false)
							Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")
						elseif nTaskState == Mission_State.MissionFaied then
							print("单个刷新军团任务索引"..pTaskExampleID.."已失败")
							nItem:setTouchEnabled(false)

							Image_MissionState:loadTexture("Image/imgres/mission/lose.png")
							Image_MissionState:setVisible(true)

							Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
							Image_MissionState_2:setVisible(true)

							Button_Goto:setVisible(false)
							Button_Goto:setEnabled(false)
						elseif nTaskState == Mission_State.NotFinished then
							print("单个刷新军团任务索引"..pTaskExampleID.."未完成")

							local pFinishNum = GetCondNum(nTaskID)
							if pFinishNum == 0 then
								pFinishNum = 1 
							end
							Label_Percent:setText(nCount.."/"..pFinishNum)

							local nPer = nCount / pFinishNum

							ProgressBar_Mission:setPercent(nPer * 100)
						end

						break
					end
				end

			elseif nTaskType == Mission_Type.Mission_Special or nTaskType == Mission_Type.Mission_ShiLian then
				print("单个刷新国家"..nTaskType.."任务"..nIndex)
				local nItemArray_CWar 			= m_ListView_MissionList_Special:getItems()
				local nMaxCount_CWar  			= nItemArray_CWar:count()
				--[[print("nMaxCount_CWar = "..nMaxCount_CWar)
				print(m_BeiginLevelUpIndex, m_BeiginShiLianIndex)
				Pause()]]
				for i=m_BeiginShiLianIndex+1,nMaxCount_CWar do
					if i-1 ~= m_BeiginLevelUpIndex or i-1 ~= m_BeiginShiLianIndex then
						local nItem = nItemArray_CWar:objectAtIndex(i-1)
						--print(nItem:getTag(), pTaskExampleID)
						--Pause()
						if tonumber(nItem:getTag()) == pTaskExampleID then
							local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"),"ImageView")
							local Button_Goto  = tolua.cast(Image_ItemBg:getChildByName("Button_Goto"),"Button")
							local Image_MissionState   = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState"),"ImageView")
							local Image_MissionState_2 = tolua.cast(Image_ItemBg:getChildByName("Image_MissionState_2"),"ImageView")
							local Image_ProgressBar    = tolua.cast(Image_ItemBg:getChildByName("Image_ProgressBar"),"ImageView")
							local Label_Percent 	  = tolua.cast(Image_ProgressBar:getChildByName("Label_Percent"),"Label")
							local ProgressBar_Mission = tolua.cast(Image_ProgressBar:getChildByName("ProgressBar_Mission"),"LoadingBar")
							if nTaskState == Mission_State.FinishedNotReceived then --如果当前任务变成可领取
								print("单个刷新国家"..nTaskType.."任务"..pTaskExampleID.."可领取")
								nItem:setTouchEnabled(true)
								Image_MissionState_2:loadTexture("Image/imgres/mission/receive.png")

								for i=1,4 do
									local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
									local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
									if tostring(Label_Reward:getStringValue()) ~= "" then
										Image_Reward:setVisible(true)
									end
								end

								Button_Goto:setEnabled(false)

							elseif nTaskState == Mission_State.HaveReceived then    --如果当前任务可变已领取
								print("单个刷新国家"..nTaskType.."任务索引"..pTaskExampleID.."已领取")

								Image_MissionState:setVisible(true)
								Image_MissionState:loadTexture("Image/imgres/mission/win.png")
								Button_Goto:setEnabled(false)
								Image_MissionState_2:setVisible(true)
								Image_ProgressBar:setVisible(false)

								nItem:setTouchEnabled(false)
								Image_MissionState_2:loadTexture("Image/imgres/countrywar/receiveLogo.png")

								for i=1,4 do
									local Image_Reward = tolua.cast(Image_ItemBg:getChildByName("Image_Coin_"..i),"ImageView")
									local Label_Reward = tolua.cast(Image_ItemBg:getChildByName("Label_CoinNum_"..i),"Label")
									if tostring(Label_Reward:getStringValue()) ~= "" then
										Image_Reward:setVisible(true)
									end
								end


							elseif nTaskState == Mission_State.MissionFaied then
								print("单个刷新国家"..nTaskType.."任务索引"..pTaskExampleID.."已失败")
								nItem:setTouchEnabled(false)

								Image_MissionState:loadTexture("Image/imgres/mission/lose.png")
								Image_MissionState:setVisible(true)

								Image_MissionState_2:loadTexture("Image/imgres/mission/lose_2.png")
								Image_MissionState_2:setVisible(true)

								Button_Goto:setEnabled(false)
							elseif nTaskState == Mission_State.NotFinished then
								print("单个刷新国家"..nTaskType.."任务索引"..pTaskExampleID.."未完成")
								local pFinishNum = GetCondNum(nTaskID)
								if pFinishNum == 0 then
									pFinishNum = 1 
								end
								Label_Percent:setText(nCount.."/"..pFinishNum)

								local nPer = nCount / pFinishNum

								ProgressBar_Mission:setPercent(nPer * 100)
							end

							break
						end
					end
				end	
			end
		else		
		end
	end
end

--刷新整个list
function MissionUpdateByList( nTaskType )
	local function Refresh( )
		--print("刷新整个页面"..nTaskType)
		if nTaskType == 1 then
			local function RefreshAct( ... )
				if m_Panel_Daily:isVisible() == true then
					m_Image_DailyBtn:setTouchEnabled(false)	
				end
				
				--停止当前的所有动作
				CCDirector:sharedDirector():getActionManager():removeAllActionsFromTarget(m_ListView_MissionList)
				--刷新分数
				local Label_InterNum		= tolua.cast(m_Panel_Daily:getChildByName("Label_InterNum"),"Label")
				Label_InterNum:setText(GetCurSocre())
				--刷新奖励盒子
				InitDailyUI_MissionProgress(m_Panel_Daily)
				--刷新任务列表
				local pDB = GetMissionTab()
				local pMissionDB = pDB["Mission"]

				SortMissionByState_2(pMissionDB, false)

				local function LoadMissionItemCallBack( nLoadMissionNumStart, nLoadMissionNumEnd , isFinish )
					local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
					for i=nLoadMissionNumStart, nLoadMissionNumEnd do
						local pItem = CloneItemWidget(pTemp)
						local isAdd = InitDailyItem(pItem, pMissionDB[i], i)
						if isAdd == true then
							m_ListView_MissionList:pushBackCustomItem(pItem)
						end
					end	
					if isFinish == true then
						UnlockTypeBtnTouch(true, 1) 		--日常任务加载完checkbox解锁
						UnlockMissionItemTouch(true, 1)
					end	
				end

				UpdateListItem(pMissionDB, LoadMissionItemCallBack, m_ListView_MissionList, 1)
			end
			--if Panel_Daily:isVisible() == true then
				--print("刷新日常任务列表")
				--RefreshAct()
			--else
				print("延迟0.5s刷新日常任务")
				local actionArray_Daily = CCArray:create()
				actionArray_Daily:addObject(CCDelayTime:create(0.5))
				actionArray_Daily:addObject(CCCallFunc:create(RefreshAct))
				m_Panel_Daily:runAction(CCSequence:create(actionArray_Daily))
			--end
			
		elseif nTaskType == 0 then
			local function RefreshMainLine( )
	        	if m_Panel_MainLine:isVisible() == true then
	        		m_Image_MainLineBtn:setTouchEnabled(false)
	        	end
				--停止当前的所有动作
				CCDirector:sharedDirector():getActionManager():removeAllActionsFromTarget(m_ListView_MissionList_MainLine)		
				--刷新任务列表
				local pDB_MainLine = GetMainLineTab()

				SortMissionByState_2(pDB_MainLine, false)

				local function LoadMissionItemCallBack( nLoadMissionNumStart, nLoadMissionNumEnd , isFinish )
					local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionDailyItem.json")
					for i=nLoadMissionNumStart, nLoadMissionNumEnd do
						local pItem = CloneItemWidget(pTemp)
						local isAdd = InitMainLineItem(m_ListView_MissionList_MainLine, pItem, pDB_MainLine[i], i)
						if isAdd == true then
							m_ListView_MissionList_MainLine:pushBackCustomItem(pItem)
						end
					end		
					if isFinish == true then
						UnlockTypeBtnTouch(true, 0) 		--主线任务加载完checkbox解锁
						UnlockMissionItemTouch(true, 0)
					end	
				end

				UpdateListItem(pDB_MainLine, LoadMissionItemCallBack, m_ListView_MissionList_MainLine, 0)
			end

			--if Panel_MainLine:isVisible() == true then
				--print("刷新主线任务列表")
			--	RefreshMainLine()
			--else
				print("延迟0.5s刷新主线任务")
				local actionArray_MainLine = CCArray:create()
				actionArray_MainLine:addObject(CCDelayTime:create(0.5))
				actionArray_MainLine:addObject(CCCallFunc:create(RefreshMainLine))
				m_Panel_MainLine:runAction(CCSequence:create(actionArray_MainLine))
			--end

		elseif nTaskType == 2 then
			--刷新军团任务
			NetWorkLoadingLayer.loadingHideNow()

			m_ListView_MissionList_Corps:removeAllItems()

			local pDB = GetCorpsMission_MissionDB()

			local pMessDB = pDB["CorpsMission"]

			SortMissionByState_2(pMessDB, false)

			local pTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionCountryWarItem.json")

			for i=1, table.getn(pMessDB) do
				local pItem = CloneItemWidget(pTemp)

				if InitCorpsItem(pMessDB[i], pItem) == true then
					m_ListView_MissionList_Corps:pushBackCustomItem(pItem)
				end
			end	

			UnlockTypeBtnTouch(true, 3) 		--国战任务加载完checkbox解锁
			UnlockMissionItemTouch(true, 3)
		end
		NetWorkLoadingLayer.loadingHideNow()
	end
	if m_MissionNormalLayer ~= nil then
		--刷新列表
		if nTaskType == 0 then
			--Packet_GetNormalMissionData.SetSuccessCallBack(Refresh)
			--network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(0)) --0=主线任务。1=日常任务
		elseif nTaskType == 1 then
			Packet_GetNormalMissionData.SetSuccessCallBack(Refresh)
			network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(1)) --0=主线任务。1=日常任务
		elseif nTaskType == 2 then
			Packet_GetReceiveMissionCorpsData.SetSuccessCallBack(Refresh)
			network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(2)) --0=主线任务。1=日常任务。2=军团任务
		end
	end
end

function RefreshRedPoint( )
	if m_MissionNormalLayer ~= nil then
		local redPoint_DailyBtn    	= tolua.cast(m_Image_DailyBtn:getChildByName("Image_Point"),"ImageView")
		local redPoint_MainLineBtn 	= tolua.cast(m_Image_MainLineBtn:getChildByName("Image_Point"),"ImageView")
		local redPoint_CWarBtn 		= tolua.cast(m_Image_CountryWarBtn:getChildByName("Image_Point"),"ImageView")
		local redPoint_CorpsBtn 	= tolua.cast(m_Image_CorpsBtn:getChildByName("Image_Point"),"ImageView")
		local redPoint_SpecialBtn 	= tolua.cast(m_Image_SpecialBtn:getChildByName("Image_Point"),"ImageView")

		for i=1,6 do
			local nState = GetPromptState(i)
			if i-1 == Mission_Type.Mission_MainLine then
				redPoint_MainLineBtn:setVisible(nState)
			elseif i-1 == Mission_Type.Mission_Daily then
				redPoint_DailyBtn:setVisible(nState)
			elseif i-1 == Mission_Type.Mission_Corps then
				redPoint_CorpsBtn:setVisible(nState)
			elseif i-1 == Mission_Type.Mission_CountryWar then
				redPoint_CWarBtn:setVisible(nState)
			elseif i-1 == Mission_Type.Mission_Special then
				redPoint_SpecialBtn:setVisible(nState)
			elseif i-1 == Mission_Type.Mission_ShiLian then
				redPoint_SpecialBtn:setVisible(nState)
			end
		end
	end
end

function GetControlUI(  )
	return m_MissionNormalLayer
end

function GetCurMissionType( )
	return m_CurType
end

function GetMissionByNewGuilde( nType, nTaskID, nCallBack, nTaskType )
	if nType == 0 then
		--领取任务
		if nTaskType == Mission_Type.Mission_Daily then
			ReceiveRewardByDailyTask( nTaskID, nCallBack )
		elseif nTaskType == Mission_Type.Mission_MainLine then
			ReceiveRewardByMainTask( nTaskID, nCallBack )
		end
		
	elseif nType == 1 then
		--关闭领取奖励tips
		if nTaskType == Mission_Type.Mission_Daily then 
			--ReceiveRewardByDailyTaskRefresh( nCallBack, nTaskType )
			--删除Tip
			DelGoodLayer()
			if nCallBack ~= nil then
				nCallBack()
				nCallBack = nil
			end
		elseif nTaskType == Mission_Type.Mission_MainLine then
			--删除Tip
			DelGoodLayer()
			if nCallBack ~= nil then
				nCallBack()
				nCallBack = nil
			end
		end
	elseif nType == 2 then
		--关闭任务界面
		UIRelease()
		if nCallBack ~= nil then
			nCallBack()
			nCallBack = nil
		end
	end
end

--create entrance
function CreateMissionNormalLayer( nType, isGoto )
	InitVars()
	m_MissionNormalLayer = TouchGroup:create()
	m_MissionNormalLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MissionNormalLayer.json"))

	m_TabMissionIndex = {} 		--存放主线任务各类型开始索引表
	m_TabMissionIndex["NotFinishedBeginIndex"] = -1			--未完成任务的开始索引
	m_TabMissionIndex["UnlockBeginIndex"] 	   = -1			--未解锁任务的开始索引
	m_TabMissionIndex["NotReceive"] 	  	   = 0			--未解锁任务的开始索引

	m_CurType = nType

	m_LoadMainLineFinish 		= false

	m_LoadDailyFinish 			= false

	m_LoadCountryWarFinish 		= false

	m_LoadCorpsFinish 			= false

	m_loadSpecialFinish 		= false

	m_IsCorpsComeIn 			= false

	m_IsCWarComeIn 				= false

	m_IsBeginLevelUpTask 		= false

	m_IsBeginShiLianTask 		= false

	m_CWarMissionDelayTime 		= 0

	m_ShiLianMissionDelayTime   = 0

	m_BeiginLevelUpIndex 		= 0 

	m_BeiginShiLianIndex 		= 1

	m_Image_DailyBtn 		= tolua.cast(m_MissionNormalLayer:getWidgetByName("Image_DailyBtn"),"ImageView")
	m_Image_MainLineBtn 	= tolua.cast(m_MissionNormalLayer:getWidgetByName("Image_MainLineBtn"),"ImageView")
	m_Image_CountryWarBtn 	= tolua.cast(m_MissionNormalLayer:getWidgetByName("Image_CountryWarBtn"),"ImageView")
	m_Image_CorpsBtn 		= tolua.cast(m_MissionNormalLayer:getWidgetByName("Image_CorpsBtn"),"ImageView")
	m_Image_SpecialBtn 		= tolua.cast(m_MissionNormalLayer:getWidgetByName("Image_SpecialBtn"),"ImageView")

	m_Image_DailyBtn:setTouchEnabled(false)
	m_Image_MainLineBtn:setTouchEnabled(false)
	m_Image_CountryWarBtn:setTouchEnabled(false)
	m_Image_CorpsBtn:setTouchEnabled(false)
	m_Image_SpecialBtn:setTouchEnabled(false)

	m_Image_DailyBtn:addTouchEventListener(_Button_DailyBtn_CallBack)
	m_Image_MainLineBtn:addTouchEventListener(_Button_MainLineBtn_CallBack)
	m_Image_CountryWarBtn:addTouchEventListener(_Button_CountryWarBtn_CallBack)
	m_Image_CorpsBtn:addTouchEventListener(_Button_CorpsBtn_CallBack)
	m_Image_SpecialBtn:addTouchEventListener(_Button_SpecialBtn_CallBack)

	RefreshRedPoint()

	m_Panel_Daily 	   			= tolua.cast(m_MissionNormalLayer:getWidgetByName("Panel_Daily"),"Layout")
	m_Panel_MainLine 			= tolua.cast(m_MissionNormalLayer:getWidgetByName("Panel_MainLine"),"Layout")
	m_Panel_CountryWar 	   		= tolua.cast(m_MissionNormalLayer:getWidgetByName("Panel_CountryWar"),"Layout")
	m_Panel_Corps 				= tolua.cast(m_MissionNormalLayer:getWidgetByName("Panel_Corps"),"Layout")
	m_Panel_Special 			= tolua.cast(m_MissionNormalLayer:getWidgetByName("Panel_Special"),"Layout")

    m_ListView_MissionList  		   = tolua.cast(m_Panel_Daily:getChildByName("ListView_MissionList"),"ListView")
    m_ListView_MissionList_MainLine    = tolua.cast(m_Panel_MainLine:getChildByName("ListView_MissionList_MainLine"),"ListView")
    m_ListView_MissionList_CountryWar  = tolua.cast(m_Panel_CountryWar:getChildByName("ListView_MissionList_CountryWar"),"ListView")
    m_ListView_MissionList_Corps       = tolua.cast(m_Panel_Corps:getChildByName("ListView_MissionList_Corps"),"ListView")
    m_ListView_MissionList_Special     = tolua.cast(m_Panel_Special:getChildByName("ListView_MissionList_Special"),"ListView")

	local nDailyLabel,nMainLineLabel,nCountryWarLabel,nCorpsLabel,nSpecialLabel = nil

	if nType == Mission_Type.Mission_Daily then
		InitDailyUI()
		m_Panel_Daily:setVisible(true)
		m_Panel_Daily:setPositionX(m_Panel_Daily:getPositionX() - 10000)
		nDailyLabel      	= StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "日常", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
		nMainLineLabel   	= CreateLabel( "主线", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nCountryWarLabel 	= CreateLabel( "国战", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nCorpsLabel 		= CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nSpecialLabel       = CreateLabel( "特殊", 30, ccc3(255,243,143), CommonData.g_FONT1, ccp(0,-32))
		m_Image_DailyBtn:loadTexture("Image/imgres/button/btn_page_l.png")
	elseif nType == Mission_Type.Mission_MainLine then
		InitMainLineUI()
		m_Panel_MainLine:setVisible(true)
		m_Panel_MainLine:setPositionX(m_Panel_MainLine:getPositionX() - 10000)
		nMainLineLabel    	= StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "主线", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
		nDailyLabel 	  	= CreateLabel( "日常", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nCountryWarLabel  	= CreateLabel( "国战", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nCorpsLabel 		= CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nSpecialLabel       = CreateLabel( "特殊", 30, ccc3(255,243,143), CommonData.g_FONT1, ccp(0,-32))
		m_Image_MainLineBtn:loadTexture("Image/imgres/button/btn_page_l.png")
	elseif tonumber(nType) == Mission_Type.Mission_CountryWar then
		--国家任务
		if CheckCountryWarMissionOpen() == false then
			return
		end
		--BeginCWarMisiion()	
		if isGoto == nil then
			m_IsCWarComeIn = true
			BeginCWarMisiion()
		else
			InitCountryWarUI()
		end
		m_Panel_CountryWar:setVisible(true)
		m_Panel_CountryWar:setPositionX(m_Panel_CountryWar:getPositionX() - 10000)	
		nCountryWarLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "国战", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
		nMainLineLabel 	  	= CreateLabel( "主线", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nDailyLabel 	  	= CreateLabel( "日常", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nCorpsLabel 		= CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nSpecialLabel       = CreateLabel( "特殊", 30, ccc3(255,243,143), CommonData.g_FONT1, ccp(0,-32))
		m_Image_CountryWarBtn:loadTexture("Image/imgres/button/btn_page_l.png")
		if isGoto == nil then
			m_Image_DailyBtn:setEnabled(false)
			m_Image_MainLineBtn:setEnabled(false)
			m_Image_SpecialBtn:setPosition(ccp(433, m_Image_CountryWarBtn:getPositionY() + 33))
			m_Image_CountryWarBtn:setPosition(ccp(m_Image_MainLineBtn:getPositionX(), m_Image_MainLineBtn:getPositionY()))
			m_Image_CorpsBtn:setPosition(ccp(m_Image_DailyBtn:getPositionX(), m_Image_DailyBtn:getPositionY()))
		end
	elseif tonumber(nType) == Mission_Type.Mission_Corps then
		if CheckCorpsMissionOpen() == false then
			return
		end
		--军团任务
		InitCorpsUI()
		m_IsCorpsComeIn = true
		m_Panel_Corps:setVisible(true)
		m_Panel_Corps:setPositionX(m_Panel_Corps:getPositionX() - 10000)	
		nCorpsLabel    		= StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "军团", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
		nMainLineLabel 	  	= CreateLabel( "主线", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nCountryWarLabel 	= CreateLabel( "国战", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nDailyLabel 		= CreateLabel( "日常", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nSpecialLabel       = CreateLabel( "特殊", 30, ccc3(255,243,143), CommonData.g_FONT1, ccp(0,-32))
		m_Image_CorpsBtn:loadTexture("Image/imgres/button/btn_page_l.png")
		if MainScene.GetCurParent() == false then
			m_Image_DailyBtn:setEnabled(false)
			m_Image_MainLineBtn:setEnabled(false)
			m_Image_SpecialBtn:setPosition(ccp(433, m_Image_CountryWarBtn:getPositionY() + 33))
			m_Image_CountryWarBtn:setPosition(ccp(m_Image_MainLineBtn:getPositionX(), m_Image_MainLineBtn:getPositionY()))
			m_Image_CorpsBtn:setPosition(ccp(m_Image_DailyBtn:getPositionX(), m_Image_DailyBtn:getPositionY()))
		end
	elseif nType == Mission_Type.Mission_Special then
		if CheckCountryWarMissionOpen() == false then
			return
		end
		--特殊任务
		InitSpecialUI()
		m_Panel_Special:setVisible(true)
		m_Panel_Special:setPositionX(m_Panel_Special:getPositionX() - 10000)	
		nCorpsLabel    		= CreateLabel( "军团", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nMainLineLabel 	  	= CreateLabel( "主线", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nCountryWarLabel 	= CreateLabel( "国战", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nDailyLabel 		= CreateLabel( "日常", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		nSpecialLabel       = CreateLabel( "特殊", 30, ccc3(255,243,143), CommonData.g_FONT1, ccp(0,-32))
		m_Image_SpecialBtn:setScale(1.3)
	end

	m_Image_DailyBtn:addChild(nDailyLabel,1,99)
	m_Image_MainLineBtn:addChild(nMainLineLabel,1,99)
	m_Image_CountryWarBtn:addChild(nCountryWarLabel,1,99)
	m_Image_CorpsBtn:addChild(nCorpsLabel,1,99)
	m_Image_SpecialBtn:addChild(nSpecialLabel,1,99)

    --按钮事件设置
    local Button_Return = tolua.cast(m_MissionNormalLayer:getWidgetByName("Button_Return"),"Button")
	if Button_Return == nil then
		print("Button_Return is nil")
		return false
	else
		Button_Return:addTouchEventListener(_Button_Return_CallBack)
	end

	--开启页面计时器
	if m_nHanderTime ~= nil then
		m_Panel_CountryWar:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end

	m_nHanderTime = m_Panel_CountryWar:getScheduler():scheduleScriptFunc(HeartBeat, 1, false)

	return  m_MissionNormalLayer
end

function GetUIControl(  )
	return m_MissionNormalLayer
end