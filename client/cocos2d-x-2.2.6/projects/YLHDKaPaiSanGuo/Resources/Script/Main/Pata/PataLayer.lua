require "Script/Common/Common"
require "Script/serverDB/server_fubenDB"
require "Script/Main/Pata/PataLogic"
require "Script/Main/Pata/PataData"
require "Script/Common/TipLayer"
require "Script/Common/RichLabel"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/DungeonLogic"
require "Script/Main/Pata/PataRefreshFightLayer"

module("PataLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= LabelLayer.createStrokeLabel 
local UIInterface_CreatAnimateByResID 	= UIInterface.CreatAnimateByResID
local GetPataData						= server_fubenDB.GetCopyTableByType
local GetPointStars						= server_fubenDB.GetPointStars
local OpenPataBox						= TipLayer.createPataBoxLayer
local OpenPataLevelInfo					= TipLayer.createPataLevelInfoLayer
local CreateTipLayerManager				= TipCommonLayer.CreateTipLayerManager

local GetNeedLv							= DungeonBaseData.GetNeedLv
local GetSceneIdxById 					= DungeonLogic.GetSceneIdxById
local GetSceneRuleId					= DungeonBaseData.GetSceneRuleId

local PlayRoleAnimation					= PataLogic.PlayRoleAnimation
local PlayRoleCallFunc					= PataLogic.PlayRoleCallFunc
local GetPointIdxBySceneId				= PataLogic.GetPointIdxBySceneId
local GetMonsterId						= PataLogic.GetMonsterId
local GetMonsterList					= PataLogic.GetMonsterList
local GetRewardItemData					= PataLogic.GetRewardItemData
local CountCurMonsterRes				= PataLogic.CountCurMonsterRes
local CountLayerNum						= PataLogic.CountLayerNum
local JudgePlayNextLevel				= PataLogic.JudgePlayNextLevel
--local ErrorTipShow						= PataLogic.errorTip
local GetRewardCoinData					= PataLogic.GetRewardCoinData
local MopEndJudge						= PataLogic.MopEndJudge
local GetConsumeMoneyMax				= PataLogic.GetConsumeMoneyMax
local JudgeSaoDangBtnShow				= PataLogic.JudgeSaoDangBtnShow
local GetMonsterID 						= PataLogic.GetMonsterID
local GetTimeThisLayer					= PataLogic.GetTimeThisLayer
local PauseCondJudgment_1 				= PataLogic.PauseCondJudgment_1
local PauseCondJudgment_2 				= PataLogic.PauseCondJudgment_2
local PauseCondJudgment_3 				= PataLogic.PauseCondJudgment_3
local PauseCondJudgment_4 				= PataLogic.PauseCondJudgment_4

local GetSceneID						= PataData.GetSceneID
local GetPointIdx						= PataData.GetPointIdx
local GetGeneralResId					= PataData.GetGeneralResId
local GetRuleTextByPointID				= PataData.GetRuleTextByPointID
local GetMonsterResId					= PataData.GetMonsterResId
local GetRewardList						= PataData.GetRewardList
local GetPataResetNum					= PataData.GetPataResetNum
local GetConsumeData					= PataData.GetConsumeData
local GetGeneralId 						= PataData.GetGeneralId
local GetPataMopUpTime					= PataData.GetPataMopUpTime
local GetPataFreeSetTimes				= PataData.GetPataFreeSetTimes


local m_PataPanel 	     	 = nil
local m_PataLayout			 = nil
local m_PataAni			 	 = nil
local m_HeroObject			 = nil
local m_EnemyObject		 	 = nil
local m_ActAni			  	 = nil
local m_IsPata			 	 = nil
local m_MonsterRes		 	 = nil
local m_HeroResID		 	 = nil
local m_nHanderTime		 	 = nil
local m_PlayScale			 = nil
local m_TablePataInfo   	 = nil
local m_nDelayTime 			 = nil
local m_SDTime				 = nil
local m_BeforeLayer		 	 = nil
local m_SaoDangBtn			 = nil
local m_CurPataState 		 = nil
local m_SurPlusTime 		 = nil
local m_IsPlayNext 			 = nil
local m_PauseTime 			 = 0

local function InitVars()
	m_PataPanel 			 = nil
	m_PataLayout			 = nil
	m_PataAni				 = nil
	m_IsPata				 = nil
	m_HeroObject			 = nil
	m_EnemyObject			 = nil
	m_ActAni				 = nil
	m_MonsterRes			 = nil
	m_HeroResID		 		 = nil
	m_nHanderTime			 = nil
	m_PlayScale				 = nil
	m_TablePataInfo     	 = nil
	m_nDelayTime 			 = nil
	m_SDTime				 = nil
	m_BeforeLayer       	 = nil
	m_SaoDangBtn			 = nil
	m_CurPataState 		 	 = nil
	m_PauseTime 			 = nil
	m_SurPlusTime 			 = nil
	m_IsPlayNext 			 = nil
	CommonData.g_IsPaTaIng 	 = false
end

local EClimbingTowerCMD = {
    ClimbingTower_CMD_Reset                 = 0,
    ClimbingTower_CMD_StarMopUp             = 1,
    ClimbingTower_CMD_EndMopUp            	= 2,  
    ClimbingTower_CMD_ConsumptionEndMop		= 3,  
}

local Role_Type = {
	Role_Hero								= 0,
	Role_Enemy 								= 1,
}

local PataSate = {
	State_Normal 							= 0, 			--正常爬塔过程
	State_SaoDang 							= 1, 			--扫荡动画
}

local PataAniState = {
	State_Normal_AnimationPlay 				= 0, 			--正常播放过场动画	
	State_SaoDang_AnimationPlay 			= 1, 			--扫荡中播放过场动画
}

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

local function DelTopEffect(  )
	if m_PataPanel:getChildByTag(1990) ~= nil then
		m_PataPanel:getChildByTag(1990):removeFromParentAndCleanup(true)
	end
end

--100层效果
local function TopEffect( )

	DelTopEffect()

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/pata_100_texiao.ExportJson")

	local pArmature = CCArmature:create("pata_100_texiao")
	pArmature:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5, CommonData.g_sizeVisibleSize.height * 0.5)) 
	pArmature:getAnimation():play("Animation1")
	pArmature:setScale(0.5)
	m_PataPanel:addChild(pArmature,0, 1990)

    local function onMovementEvent(armatureBack,movementType,movementID)
        if movementType == 1 then
        	pArmature:getAnimation():play("Animation2")
        end
    end
	
    pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)

end

local function PataUIResponseState( nState )
	--print(m_CurPataState,nState)
	--Pause()
	local Image_Consume = tolua.cast(m_PataPanel:getWidgetByName("Image_Consume"), "ImageView") --消耗
	local Image_HourBg = tolua.cast(m_PataPanel:getWidgetByName("Image_HourBg"), "ImageView")	--时间
	local Button_Reset = tolua.cast(m_PataPanel:getWidgetByName("Button_Reset"), "Button")
	local StrokeLabel_Saodang= m_SaoDangBtn:getChildByTag(100)
	local StrokeLabel_SaodangEnd= m_SaoDangBtn:getChildByTag(101)
	--爬塔各个阶段的UI响应
	if m_CurPataState == PataSate.State_Normal then 		--normal
		if nil ~= m_PataLayout:getChildByTag(301) then
			m_PataLayout:getChildByTag(301):setTouchEnabled(true)	--正常爬塔阶段时候敌人点击区域响应正常
		end
		if m_EnemyObject~=nil and m_EnemyObject:GetAnimate():getChildByTag(300) ~= nil then
			m_EnemyObject:GetAnimate():getChildByTag(300):setVisible(true)
		end
		Image_Consume:setVisible(false)
		Image_HourBg:setVisible(false)								--时间和消耗UI隐藏
		Button_Reset:setTouchEnabled(true)
		m_SaoDangBtn:setTouchEnabled(true)							--重置和扫荡按钮放开响应
		StrokeLabel_SaodangEnd:setVisible(false)
		StrokeLabel_Saodang:setVisible(true)
		m_SaoDangBtn:setTag(100)
		if nState ~= nil then 				--animation play
			if nState == PataAniState.State_Normal_AnimationPlay then
				if nil ~= m_PataLayout:getChildByTag(301) then
					m_PataLayout:getChildByTag(301):setTouchEnabled(false)	--正常爬塔阶段播放动画时段敌人点击区域响应false
				end								--时间和消耗UI隐藏
				Button_Reset:setTouchEnabled(false)
				m_SaoDangBtn:setTouchEnabled(false)							--重置和扫荡按钮放开响应
				if m_TablePataInfo.MaxLayer <= 1 then 
					if m_EnemyObject~=nil and m_EnemyObject:GetAnimate():getChildByTag(300) ~= nil then
						m_EnemyObject:GetAnimate():getChildByTag(300):setVisible(false)
					end
				end
			end
		else
		end
	elseif m_CurPataState == PataSate.State_SaoDang then 		--saodang
		if nil ~= m_PataLayout:getChildByTag(301) then
			m_PataLayout:getChildByTag(301):setTouchEnabled(false)	--正常爬塔阶段时候敌人点击区域响应正常
		end
		if m_EnemyObject ~= nil and m_EnemyObject:GetAnimate():getChildByTag(300) ~= nil then
			m_EnemyObject:GetAnimate():getChildByTag(300):setVisible(false)
		end
		Image_Consume:setVisible(true)
		Image_HourBg:setVisible(true)
		m_SaoDangBtn:setTouchEnabled(true)	
		StrokeLabel_SaodangEnd:setVisible(true)
		StrokeLabel_Saodang:setVisible(false)
		m_SaoDangBtn:setTag(101)
		if nState ~= nil then 				--animation play
			if nState == PataAniState.State_SaoDang_AnimationPlay then
				if nil ~= m_PataLayout:getChildByTag(301) then
					m_PataLayout:getChildByTag(301):setTouchEnabled(false)	--正常爬塔阶段播放动画时段敌人点击区域响应false
				end								
			end
		end
	end
end

-- 设置倒记时时间，单位秒
function SetFightDelayTime(nSecend)
	if nSecend < 0 then return end
	m_nDelayTime = nSecend
	--print("m_TablePataInfo.CurTime = "..m_TablePataInfo.CurTime)
	--print(m_nDelayTime)
	local strM = math.floor(nSecend/60)
	local strS = math.floor(nSecend%60)
	local strTemp = ""
	if tonumber(strM) < 10 then strM = "0" .. strM end
	if tonumber(strS) < 10 then strS = "0" .. strS end

	local Image_HourBg = tolua.cast(m_PataPanel:getWidgetByName("Image_HourBg"), "ImageView")
	LabelLayer.setText(Image_HourBg:getChildByTag(110),strM)
	LabelLayer.setText(Image_HourBg:getChildByTag(111),strS)

	local function tick(dt)
		if m_nDelayTime == 0 then
		-- 时间到了。战斗结束
			--print("时间到了。战斗结束")
			m_PataPanel:getScheduler():unscheduleScriptEntry(m_SDTime)
			m_SDTime = nil
			Image_HourBg:setVisible(false)
		end
		m_nDelayTime = m_TablePataInfo.EndTime - m_TablePataInfo.CurTime - 1
		SetFightDelayTime(m_nDelayTime)
	end
	if m_SDTime == nil then
		m_SDTime = m_PataPanel:getScheduler():scheduleScriptFunc(tick, 1, false)
	end
end
-- 停止计时
local function StopFightDelayTime()
	if m_SDTime ~= nil then
		m_PataPanel:getScheduler():unscheduleScriptEntry(m_SDTime)
		m_SDTime = nil
		local Image_HourBg = tolua.cast(m_PataPanel:getWidgetByName("Image_HourBg"), "ImageView")
		LabelLayer.setText(Image_HourBg:getChildByTag(110),00)
		LabelLayer.setText(Image_HourBg:getChildByTag(111),00)
		Image_HourBg:setVisible(false)
	end
end
-- 开始计时
local function ContinueFightDelayTime()
	SetFightDelayTime(m_TablePataInfo.EndTime - m_TablePataInfo.CurTime)
end

--Return Main
local function _Click_Return_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		DelTopEffect()
		if m_HeroObject ~= nil then
			m_HeroObject:Destroy()
		end
		if m_EnemyObject ~= nil then
			m_EnemyObject:Destroy()
		end
		if m_nHanderTime ~= nil then
			m_PataPanel:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		end
		StopFightDelayTime()
		m_PataPanel:removeFromParentAndCleanup(false)
		InitVars()	
		MainScene.PopUILayer()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_StartFight_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		----------------------------------
		DelTopEffect()
		local pTipLayer = CreateTipLayerManager()
		if m_CurPataState == PataSate.State_Normal then
			function BattleBeginOver(pServerDataStream)
				if pServerDataStream == nil then 
					NetWorkLoadingLayer.loadingHideNow()
					if PataLayer.GetCurStars() < 0 then 
						--PataLogic.errorTip(1310)
						--pTipLayer:ShowCommonTips(1310,nil)
						--pTipLayer = nil
					    local pRFlayer = PataRefreshFightLayer.CreateRefreshFightLayer(m_TablePataInfo.SceceID, m_TablePataInfo.PointIdx)
					    m_PataPanel:addChild(pRFlayer,999)
					else
						--PataLogic.errorTip(1311)
						--TipLayer.createTimeLayer("很可惜未满足通关条件，爬塔失败了哦。",2)
						--pTipLayer:ShowCommonTips(1311,nil)
						--pTipLayer = nil
					    local pRFlayer = PataRefreshFightLayer.CreateRefreshFightLayer(m_TablePataInfo.SceceID, m_TablePataInfo.PointIdx)
					    m_PataPanel:addChild(pRFlayer,999)
					end
				else
					require "Script/Fight/BaseScene"
					BaseScene.createBaseScene()
					if NETWORKENABLE > 0 then
						BaseScene.InitServerFightData(pServerDataStream)
					end
					NetWorkLoadingLayer.loadingHideNow()
					BaseScene.EnterBaseScene()
					m_IsPata = true
				end
			end
			----------------------------------
			Packet_BattleBegin.SetSuccessCallBack(BattleBeginOver)
			network.NetWorkEvent(Packet_BattleBegin.CreatPacket(m_TablePataInfo.SceceID, m_TablePataInfo.PointIdx))
			NetWorkLoadingLayer.loadingShow(true)
		end
	elseif eventType == TouchEventType.began then
		
	elseif eventType == TouchEventType.canceled then
		
	end
end

local function _Click_FenXi_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		--战事分析(分析前更新数据)
		local tabMonster = nil
		if m_TablePataInfo.CurLayer > 100 then
			tabMonster = GetMonsterList(GetPointIdxBySceneId(GetSceneID(100) ,GetPointIdx(100)))
			OpenPataLevelInfo(100 , tabMonster)
		else
			tabMonster = GetMonsterList(GetPointIdxBySceneId(GetSceneID(m_TablePataInfo.CurLayer) ,GetPointIdx(m_TablePataInfo.CurLayer)))
			OpenPataLevelInfo(m_TablePataInfo.CurLayer , tabMonster)
		end
		sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_FightData_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		--查看战报
		sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_ShowBox_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		--宝箱预览
		OpenPataBox()
		sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Ranking_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		--排行榜
		sender:setScale(1.0)
		--TopEffect()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function RunRoleAttackAni( m_RoelAni, m_TargetRoleAni, m_ResID ,nSkillNum)
	local num = nSkillNum
	local function attackRepeat( )
		if m_CurPataState == PataSate.State_SaoDang == true then
			if num == 1 then
				m_RoelAni:playAttack(m_TargetRoleAni:GetAnimate())
			elseif num == 2 then
				m_RoelAni:playAttack(m_TargetRoleAni:GetAnimate())
			elseif num == 3 then
				m_RoelAni:playSkill(m_TargetRoleAni:GetAnimate())
			elseif num == 4 then
				m_RoelAni:playManualSkill(m_TargetRoleAni:GetAnimate())
			else

			end
		end
		num = num + 1
		if num == 5 then
			num = 1
		end
	end
	local actionArray1 = CCArray:create()
	actionArray1:addObject(CCCallFunc:create(attackRepeat))
	actionArray1:addObject(CCDelayTime:create(2))
	m_RoelAni:GetAnimate():runAction(CCRepeatForever:create(CCSequence:create(actionArray1)))
end

function UpdatePataData( )
	--数据同步
	local upDataData = GetPataData(DungeonsType.ClimbingTower)
	local panel_fightdata = tolua.cast(m_PataPanel:getWidgetByName("Panel_Data"), "Layout")

	--[[printTab(upDataData)
	Pause()]]

	m_BeforeLayer   = upDataData.CurrentLayer
	print("m_BeforeLayer = "..m_BeforeLayer)
	m_TablePataInfo.MaxLayer   = upDataData.MaxLayer
	m_TablePataInfo.CurLayer   = math.min(upDataData.CurrentLayer,m_TablePataInfo.MaxLayer)
	m_TablePataInfo.BeginTime  = upDataData.SaoDangBeginTime
	m_TablePataInfo.EndTime    = upDataData.SaoDangEndTime
	m_TablePataInfo.CurTime	   = upDataData.SaoDangCurTime
	m_TablePataInfo.FreeReSet  = upDataData.FreeReset
	m_TablePataInfo.SDLayer    = (m_TablePataInfo.EndTime - m_TablePataInfo.BeginTime) / 20
	if m_TablePataInfo.CurLayer > 100 then
		m_TablePataInfo.SceceID = GetSceneID(100)
		m_TablePataInfo.PointIdx = GetPointIdx(100)
	else
		m_TablePataInfo.SceceID = GetSceneID(m_TablePataInfo.CurLayer)
		m_TablePataInfo.PointIdx = GetPointIdx(m_TablePataInfo.CurLayer)
	end
	local nPointId = GetPointIdxBySceneId(m_TablePataInfo.SceceID  ,m_TablePataInfo.PointIdx)

	local tabMonster = GetMonsterList(nPointId)
	for key,value in pairs(tabMonster) do
		if value.MonsterType == MonsterType.Genereal then
			m_MonsterRes = GetMonsterResId(value.MonsterId)
			break
		else 
			if key == table.getn(tabMonster) then
				m_MonsterRes = GetMonsterResId(value.MonsterId)
			end
		end 
	end
	--初始化货币奖励
	local tabCoin = GetRewardCoinData(nPointId)
	local coinTabNum = table.getn(tabCoin)
	--先置false
	for i=1,3 do
		local imgCoin = tolua.cast(panel_fightdata:getChildByName("Image_Coin"..i), "ImageView")
		imgCoin:setVisible(false)
		if panel_fightdata:getChildByTag(200 + i) ~=nil then
			panel_fightdata:getChildByTag(200 + i):setVisible(false)
		end
	end
	--显示奖励
	for i=1,coinTabNum do
		local imgCoin = tolua.cast(panel_fightdata:getChildByName("Image_Coin"..i), "ImageView")
		imgCoin:loadTexture(tabCoin[i].CoinPath)
		imgCoin:setVisible(true)
		if panel_fightdata:getChildByTag(200 + i) ~=nil then
			panel_fightdata:getChildByTag(200 + i):setText(tabCoin[i].CoinNum)
			panel_fightdata:getChildByTag(200 + i):setVisible(true)
		end
	end
	--通关条件
	if panel_fightdata:getChildByTag(101) ~= nil then
		panel_fightdata:getChildByTag(101):removeFromParentAndCleanup(true)
	end
	local RuleText = RichLabel.Create(GetRuleTextByPointID(nPointId),panel_fightdata:getContentSize().width - 20)
	RuleText:setPosition(ccp(30,188))
	panel_fightdata:addChild(RuleText,1,101)
	--[[
	print("Update.after.CurLayer = "..m_TablePataInfo.CurLayer)
	print("Update.MaxLayer = "..m_TablePataInfo.MaxLayer)
	print("Update.FreeReSet = "..m_TablePataInfo.FreeReSet)
	print("Update.BeginTime = "..m_TablePataInfo.BeginTime)
	print("Update.EndTime = "..m_TablePataInfo.EndTime)
	print("Update.CurTime = "..m_TablePataInfo.CurTime)
	print("Update.starNum = "..GetPointStars(DungeonsType.ClimbingTower,m_TablePataInfo.SceceID,m_TablePataInfo.PointIdx))
	--]]
end

local function CurLayerComeInAni( ... )
	local panel_fightdata = tolua.cast(m_PataPanel:getWidgetByName("Panel_Data"), "Layout")
	local btn_reset = tolua.cast(m_PataPanel:getWidgetByName("Button_Reset"), "Button")
	local pCurLayer = m_TablePataInfo.CurLayer
	if pCurLayer > 100 then pCurLayer = 100 end
	--播放层数进入动画
	local function ChangeCurLayerNum( ... )
		--修改关卡层数
		if panel_fightdata:getChildByTag(100)~=nil then
			LabelLayer.setText(panel_fightdata:getChildByTag(100), pCurLayer)
			btn_reset:setTouchEnabled(true)
		end
		--LabelLayer.setText(m_PataPanel:getChildByTag(105),pCurLayer)
		local pLabelFont = tolua.cast(m_PataPanel:getChildByTag(105), "LabelBMFont")
		pLabelFont:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 + 193))
		pLabelFont:setText( pCurLayer )
	end
	local function CheckPos(  )
		local pLabelFont = tolua.cast(m_PataPanel:getChildByTag(105), "LabelBMFont")
		--print("before y = "..pLabelFont:getPositionY())
		--print("校驗坐標")
		pLabelFont:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 + 193))
		--print("after y = "..pLabelFont:getPositionY())
	end
	if m_PataPanel:getChildByTag(105)~=nil then
		local actionArrayLayerFadeIn = CCArray:create()
		actionArrayLayerFadeIn:addObject(CCDelayTime:create(1))
		actionArrayLayerFadeIn:addObject(CCCallFunc:create(ChangeCurLayerNum))
		actionArrayLayerFadeIn:addObject(CCFadeTo:create(0.1,255))	
		actionArrayLayerFadeIn:addObject(CCScaleTo:create(0.1,1.2))
		actionArrayLayerFadeIn:addObject(CCScaleTo:create(0.1,1))
		actionArrayLayerFadeIn:addObject(CCCallFunc:create(CheckPos))
		m_PataPanel:getChildByTag(105):runAction(CCSequence:create(actionArrayLayerFadeIn))
	end
	--修改消耗
	local img = tolua.cast(m_PataPanel:getWidgetByName("Image_Consume"), "ImageView")
	if img:getChildByTag(108)~=nil then
		LabelLayer.setText(img:getChildByTag(108),GetConsumeMoneyMax(pCurLayer,m_TablePataInfo.MaxLayer))
	end
end

local function CheerEnd( isMove )
	--播放主角胜利动画
	if m_HeroObject~=nil then
		local function Cheer_FunC( )
			m_HeroObject:playAnimation(GetAniName_Res_ID(m_HeroResID,Ani_Def_Key.Ani_cheers))
			local Button_Reset = tolua.cast(m_PataPanel:getWidgetByName("Button_Reset"), "Button") --放开按钮响应
			Button_Reset:setTouchEnabled(true)
			local img = tolua.cast(m_PataPanel:getWidgetByName("Image_Consume"), "ImageView")
			img:setVisible(false)
		end
		local function Run_FunC(  )
			m_SaoDangBtn:setEnabled(false)
			m_HeroObject:playAnimation(GetAniName_Res_ID(m_HeroResID,Ani_Def_Key.Ani_run))
		end
		m_HeroObject:GetAnimate():stopAllActions()

		local actionArray_Win = CCArray:create()
		actionArray_Win:addObject(CCCallFunc:create(Run_FunC))
		if isMove == false then
			print("biu biu ")
			actionArray_Win:addObject(CCMoveBy:create(1, ccp(100, 0)))
		else
			actionArray_Win:addObject(CCMoveBy:create(1, ccp(200, 0)))
		end
		actionArray_Win:addObject(CCCallFunc:create(Cheer_FunC))
		m_HeroObject:GetAnimate():runAction(CCSequence:create(actionArray_Win))
	end	
end

local function StartSaoDangAni( ... )
	-- 扫荡开始动画
	local function RunSaoDangAni( m_RoelAni, m_TargetRoleAni ,m_ResID, actionType ,normailize)
		local function RunCallFuncRun( )
			m_RoelAni:playAnimation(GetAniName_Res_ID(m_ResID,actionType))
		end
		local function RunCallFuncAttack( )	
			m_RoelAni:GetAnimate():stopAllActions()
			RunRoleAttackAni(m_RoelAni, m_TargetRoleAni, m_ResID ,1)	
		end
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCCallFunc:create(RunCallFuncRun))
		actionArray1:addObject(CCMoveBy:create(0.5,ccp(100 * normailize,0)))
		actionArray1:addObject(CCCallFunc:create(RunCallFuncAttack))
		m_RoelAni:GetAnimate():runAction(CCSequence:create(actionArray1))
	end
	if m_HeroObject~=nil and m_EnemyObject~=nil then
		RunSaoDangAni(m_HeroObject, m_EnemyObject, m_HeroResID, Ani_Def_Key.Ani_run , 1)
	end
	if m_EnemyObject~=nil and m_HeroObject~=nil then
		if m_EnemyObject:GetAnimate():getChildByTag(300)~=nil then
			m_EnemyObject:GetAnimate():getChildByTag(300):setVisible(false)
		end
		RunSaoDangAni(m_EnemyObject, m_HeroObject, m_MonsterRes, Ani_Def_Key.Ani_run, -1)
	end
	--显示提示信息
	--ErrorTipShow(1302,m_TablePataInfo.CurLayer)
	local pCurLayer = m_TablePataInfo.CurLayer
	if pCurLayer > 100 then pCurLayer = 100 end
	local pTips = CreateTipLayerManager()
	pTips:ShowCommonTips(1302,nil,pCurLayer)
	pTips = nil
end

local function CreateRoleByType( nType )
	local pCurLayer = m_TablePataInfo.CurLayer
	if pCurLayer > 100 then pCurLayer = 100 end
	--创建英雄和敌人
	if nType == Role_Type.Role_Hero then
		m_HeroResID = GetGeneralResId(server_mainDB.getMainData("nModeID"))
		m_HeroObject = UIEffectManager.CreateUIEffectObj()
		m_HeroObject:Create(tonumber(server_mainDB.getMainData("nModeID")),false,m_PataLayout)
		m_HeroObject:GetAnimate():setZOrder(2)
		m_HeroObject:GetAnimate():setVisible(false)
		m_HeroObject:GetAnimate():setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 - 200 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 - 120))
	elseif nType == Role_Type.Role_Enemy then
		m_MonsterRes = CountCurMonsterRes(pCurLayer)
		local nMonsterId = GetMonsterID(pCurLayer)
		m_EnemyObject = UIEffectManager.CreateUIEffectObj()
		m_EnemyObject:Create_Monst(nMonsterId,true,m_PataLayout)
		m_EnemyObject:GetAnimate():setZOrder(1)
		m_EnemyObject:GetAnimate():setVisible(false)
		m_EnemyObject:GetAnimate():setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + 220 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 - 120))
		--给动画添加点击和指示箭头
		local Btn_Click = Button:create()
		Btn_Click:setTouchEnabled(false)
		Btn_Click:setScale9Enabled(true)
		Btn_Click:loadTextures("Image/imgres/common/common_black.png","Image/imgres/common/common_black.png","Image/imgres/common/common_black.png")	
	    Btn_Click:setSize(CCSize(m_EnemyObject:GetAnimate():getContentSize().width,m_EnemyObject:GetAnimate():getContentSize().height))
		Btn_Click:addTouchEventListener(_Click_StartFight_PataLayer_CallBack)
		Btn_Click:setAnchorPoint(ccp(0.5,0))
		Btn_Click:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + 220 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 - 120))
		Btn_Click:setVisible(false)
		m_PataLayout:addChild(Btn_Click,2,301)
		--创建完敌人后创建进入战斗的箭头
		if m_EnemyObject:GetAnimate():getChildByTag(300) ~= nil then
			m_EnemyObject:GetAnimate():getChildByTag(300):removeFromParentAndCleanup(true)
		end
		local imgStartFight = ImageView:create()
		imgStartFight:loadTexture("Image/imgres/pata/UI/arrow.png")
		imgStartFight:setPosition(ccp(0,m_EnemyObject:GetAnimate():getContentSize().height + 20))
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(0.5,ccp(0,15)))
		actionArray1:addObject(CCMoveBy:create(0.5,ccp(0,-15)))
		imgStartFight:runAction(CCRepeatForever:create(CCSequence:create(actionArray1)))
		if m_CurPataState == PataSate.State_SaoDang then
			imgStartFight:setVisible(false)
		else
			imgStartFight:setVisible(true)
		end
		m_EnemyObject:GetAnimate():addChild(imgStartFight,10,300)
	end
end

local function EnemyComeInAni(  )
	--敌人动画
	CreateRoleByType(Role_Type.Role_Enemy)
	local function AniInCallfunc_Enemy( )
		m_EnemyObject:GetAnimate():setVisible(true)
		m_IsPlayNext = false
		if m_CurPataState == PataSate.State_Normal then
			PataUIResponseState(nil)
		else
			StartSaoDangAni()
			PataUIResponseState(nil)
		end
	end
	m_EnemyObject:PlayEffect("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001","Animation1",false,AniInCallfunc_Enemy)
end

local function EndSaoDangPlayNext( ... )
	if m_TablePataInfo.CurLayer >= 100 then
		--已经爬到顶层
		CheerEnd( false )
		TopEffect()
		local Image_HourBg = tolua.cast(m_PataPanel:getWidgetByName("Image_HourBg"), "ImageView")
		Image_HourBg:setVisible(false)
		m_SaoDangBtn:setEnabled(false)
	else 
		m_TablePataInfo.CurLayer = m_TablePataInfo.MaxLayer
		m_TablePataInfo.SceceID = GetSceneID(m_TablePataInfo.CurLayer)
		m_TablePataInfo.PointIdx = GetPointIdx(m_TablePataInfo.CurLayer)
		local panel_fightdata = tolua.cast(m_PataPanel:getWidgetByName("Panel_Data"), "Layout")
		-- 播放死亡动画之后播放跳转下一层动画
		local function _Scene_Move( ... )
			m_PataAni:getAnimation():play("Animation2")
		end
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCDelayTime:create(1.5))
		actionArray1:addObject(CCCallFunc:create(_Scene_Move))
		m_PataAni:runAction(CCSequence:create(actionArray1))

		--下层动画延迟到敌人消失播放
		local function _Play_NextLayer( ... )
			local function AniNext_Hero( )
				if m_PataPanel:getChildByTag(203) ~= nil then
					m_PataPanel:removeChildByTag(203, true)
				end
				local function _Hero_Show( ... )
					m_HeroObject:playAnimation(GetAniName_Res_ID(m_HeroResID,Ani_Def_Key.Ani_stand))
					m_HeroObject:GetAnimate():setVisible(true)
					m_HeroObject:GetAnimate():setOpacity(120)
					local img = tolua.cast(m_PataPanel:getWidgetByName("Image_Consume"), "ImageView")
					if img:getChildByTag(108)~=nil then
						LabelLayer.setText(img:getChildByTag(108),GetConsumeMoneyMax(m_TablePataInfo.CurLayer,m_TablePataInfo.MaxLayer))
					end
				end
				--
				local actionArray1 = CCArray:create()
				actionArray1:addObject(CCDelayTime:create(0.5))
				actionArray1:addObject(CCMoveBy:create(0.1,ccp(-100,0)))
				actionArray1:addObject(CCCallFunc:create(_Hero_Show))
				actionArray1:addObject(CCFadeTo:create(0.25,255))
				actionArray1:addObject(CCCallFunc:create(EnemyComeInAni))
				if m_HeroObject ~= nil then
					m_HeroObject:GetAnimate():runAction(CCSequence:create(actionArray1))
				end
				CurLayerComeInAni()
			end
			m_HeroObject:GetAnimate():setVisible(false)	
			m_HeroObject:PlayEffect("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001","Animation4",true,AniNext_Hero)	
		end
		local actionArrayDelay = CCArray:create()
		actionArrayDelay:addObject(CCDelayTime:create(1))
		actionArrayDelay:addObject(CCCallFunc:create(_Play_NextLayer))
		m_HeroObject:GetAnimate():runAction(CCSequence:create(actionArrayDelay))

		local function _Remove_Enemy( ... )
			if m_EnemyObject ~= nil then
				m_EnemyObject:Destroy()
				m_EnemyObject = nil
			end		
		end 

		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCFadeTo:create(0.25,0))
		actionArray1:addObject(CCCallFunc:create(_Remove_Enemy))
		m_EnemyObject:GetAnimate():runAction(CCSequence:create(actionArray1))
		--播放层数消失动画
		local actionArrayLayerFadeOut = CCArray:create()
		actionArrayLayerFadeOut:addObject(CCFadeTo:create(0.25,0))	
		actionArrayLayerFadeOut:addObject(CCScaleTo:create(0.1,0))
		m_PataPanel:getChildByTag(105):runAction(CCSequence:create(actionArrayLayerFadeOut))
	end
end

local function EndSaoDangAni( ... )
	--大于等于扫荡结束时停止计时
	local pCurLayer = m_TablePataInfo.CurLayer
	if pCurLayer > 100 then pCurLayer = 100 end

	m_CurPataState = PataSate.State_Normal
	CommonData.g_IsPaTaIng = false
	if m_nHanderTime ~= nil then 
		m_PataPanel:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end
	if m_SDTime ~= nil then 
		m_PataPanel:getScheduler():unscheduleScriptEntry(m_SDTime)
		m_SDTime = nil
	end
	-- 扫荡结束动画
	if m_HeroObject~=nil then
		m_HeroObject:GetAnimate():stopAllActions()
		m_HeroObject:playAnimation(GetAniName_Res_ID(m_HeroResID,Ani_Def_Key.Ani_cheers))
	end
	if m_EnemyObject~=nil then
		m_EnemyObject:GetAnimate():stopAllActions()
		m_EnemyObject:playAnimation(GetAniName_Res_ID(m_MonsterRes,Ani_Def_Key.Ani_die),EndSaoDangPlayNext)
	end
	--重置按钮放开
	local btn_reset = tolua.cast(m_PataPanel:getWidgetByName("Button_Reset"), "Button")
	btn_reset:setTouchEnabled(true)
	--扫荡按钮回复
	m_SaoDangBtn:getChildByTag(100):setVisible(true)
	m_SaoDangBtn:getChildByTag(101):setVisible(false)
	m_SaoDangBtn:setTag(100)
	--扫荡过后判断扫荡按钮是否显示
	local img = tolua.cast(m_PataPanel:getWidgetByName("Image_Consume"), "ImageView")
	JudgeSaoDangBtnShow(m_SaoDangBtn,pCurLayer,m_TablePataInfo.MaxLayer,m_TablePataInfo.FreeReSet,true,img)
	--发放奖励提示
	--ErrorTipShow(1301)
	local pTip = CreateTipLayerManager()
	pTip:ShowCommonTips(1301,nil)
	pTip = nil
end

local function HeroComeInAni(  )
	local function AniInCallfunc_Hero( )
		m_HeroObject:GetAnimate():setVisible(true)
		EnemyComeInAni()
	end
	m_HeroObject:PlayEffect("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001","Animation1",true,AniInCallfunc_Hero)
end

function PlayNextLayerAni( )
	m_IsPlayNext = true
	print("PlayNextLayerAni PlayNextLayerAni PlayNextLayerAni")
	if m_CurPataState == PataSate.State_Normal then
		PataUIResponseState(PataSate.State_Normal)
	else
		PataUIResponseState(PataSate.State_SaoDang)
	end
	m_EnemyObject:GetAnimate():stopAllActions()
	m_HeroObject:GetAnimate():stopAllActions()
	local panel_fightdata = tolua.cast(m_PataPanel:getWidgetByName("Panel_Data"), "Layout")

	--print("m_TablePataInfo.CurLayer = "..m_TablePataInfo.CurLayer)
	--Pause()
	-- 播放死亡动画之后播放跳转下一层动画
	if m_TablePataInfo.CurLayer <= 100 then
		local function _Scene_Move( ... )
		    local function onMovementEvent(armatureBack,movementType,movementID)
		        if movementType == 1 then
		        	m_PataAni:getAnimation():play("Animation1")
		        end
		    end
			m_PataAni:getAnimation():play("Animation2")
			m_PataAni:getAnimation():setMovementEventCallFunc(onMovementEvent)
		end
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCDelayTime:create(1.5))
		actionArray1:addObject(CCCallFunc:create(_Scene_Move))
		m_PataAni:runAction(CCSequence:create(actionArray1))
	else
		CheerEnd()
	end

	local function AniInCallfunc_Hero( )
		local function _Hero_Show( ... )
			m_HeroObject:GetAnimate():setVisible(true)
			local img = tolua.cast(m_PataPanel:getWidgetByName("Image_Consume"), "ImageView")
			if img:getChildByTag(108)~=nil then
				LabelLayer.setText(img:getChildByTag(108),GetConsumeMoneyMax(m_TablePataInfo.CurLayer,m_TablePataInfo.MaxLayer))
			end
		end
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCDelayTime:create(0.5))
		if m_CurPataState == PataSate.State_SaoDang then
			actionArray1:addObject(CCMoveBy:create(0.1,ccp(-100,0)))
		end
		actionArray1:addObject(CCCallFunc:create(_Hero_Show))
		actionArray1:addObject(CCCallFunc:create(EnemyComeInAni))
		m_HeroObject:GetAnimate():runAction(CCSequence:create(actionArray1))
		CurLayerComeInAni()
	end

	--下层动画延迟到敌人消失播放
	local function _Play_NextLayer( ... )
		m_HeroObject:GetAnimate():setVisible(false)	
		m_HeroObject:PlayEffect("Image/Fight/skill/brith_all_001/brith_all_001.ExportJson","brith_all_001","Animation4",true,AniInCallfunc_Hero)	
	end
	local actionArrayDelay = CCArray:create()
	actionArrayDelay:addObject(CCDelayTime:create(1))
	if m_TablePataInfo.CurLayer <= 100 then
		actionArrayDelay:addObject(CCCallFunc:create(_Play_NextLayer))
	else
		TopEffect()
	end
	m_HeroObject:GetAnimate():runAction(CCSequence:create(actionArrayDelay))

	--播放敌人死亡动画
	local function LayerActAni( )
		local function _Remove_Enemy( ... )
			if m_EnemyObject ~= nil then
				m_EnemyObject:Destroy()
				m_EnemyObject = nil
			end		
		end 
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCFadeTo:create(0.25,0))
		actionArray1:addObject(CCCallFunc:create(_Remove_Enemy))
		m_EnemyObject:GetAnimate():runAction(CCSequence:create(actionArray1))
		--播放层数消失动画
		local actionArrayLayerFadeOut = CCArray:create()
		actionArrayLayerFadeOut:addObject(CCFadeTo:create(0.25,0))	
		actionArrayLayerFadeOut:addObject(CCScaleTo:create(0.1,0))
		m_PataPanel:getChildByTag(105):runAction(CCSequence:create(actionArrayLayerFadeOut))
	end
	m_EnemyObject:playAnimation(GetAniName_Res_ID(m_MonsterRes,Ani_Def_Key.Ani_die),LayerActAni)	
end

function PataFailed( nStar )
	local pPointIdx = nil
	if m_TablePataInfo.PointIdx <= 1 then
		pPointIdx = 1
	else
		pPointIdx = m_TablePataInfo.PointIdx
	end

 	local pMaxStarNum = GetPointStars(DungeonsType.ClimbingTower,m_TablePataInfo.SceceID,pPointIdx)

 	if pMaxStarNum == 3 then
 		PlayNextLayerAni()
 	else
		m_CurPataState = PataSate.State_Normal
		CommonData.g_IsPaTaIng = false
		PataUIResponseState(nil)
		if m_HeroObject~=nil then
			m_HeroObject:GetAnimate():stopAllActions()
			 if nStar > 0 then
				m_HeroObject:playAnimation(GetAniName_Res_ID(m_HeroResID,Ani_Def_Key.Ani_stand))
			else
				m_HeroObject:playAnimation(GetAniName_Res_ID(m_HeroResID,Ani_Def_Key.Ani_die))
			end
		end
		if m_EnemyObject~=nil then
			m_EnemyObject:GetAnimate():stopAllActions()
			if nStar > 0 then
				--m_EnemyObject:playAnimation(GetAniName_Res_ID(m_MonsterRes,Ani_Def_Key.Ani_die))
				m_EnemyObject:playAnimation(GetAniName_Res_ID(m_MonsterRes,Ani_Def_Key.Ani_stand))
			else
				m_EnemyObject:playAnimation(GetAniName_Res_ID(m_MonsterRes,Ani_Def_Key.Ani_cheers))
			end
		end
		--闯关箭头隐藏
		if m_EnemyObject:GetAnimate():getChildByTag(300) ~= nil then
			m_EnemyObject:GetAnimate():getChildByTag(300):setVisible(false)
		end
	end
end

local function BeginComingAniByCheerEnd(  )
	CreateRoleByType(Role_Type.Role_Hero)
	m_HeroObject:GetAnimate():setVisible(true)
	m_SaoDangBtn:setEnabled(false)
	CheerEnd()
	TopEffect()
end

local function BeginComingAniByFailed()
	CreateRoleByType(Role_Type.Role_Hero)
	CreateRoleByType(Role_Type.Role_Enemy)
	m_HeroObject:GetAnimate():setVisible(true)
	m_EnemyObject:GetAnimate():setVisible(true)
	PataFailed(GetCurStars())		
end

local function BeginComingAni( nState )
	m_HeroResID = GetGeneralResId(server_mainDB.getMainData("nModeID"))
	--英雄动画(取得英雄当前形象)
	CreateRoleByType(Role_Type.Role_Hero)
	--英雄进场
	if nState ~= nil then
		--重置进场
		HeroComeInAni(nState)
	else
		HeroComeInAni()
	end
end

local function BeginComingAniBySaoDang( ... )
	CreateRoleByType(Role_Type.Role_Hero)
	CreateRoleByType(Role_Type.Role_Enemy)
	if m_HeroObject ~= nil and m_EnemyObject ~= nil then
		math.randomseed(os.time())
		local nHeroSkNum = math.random(1,3)
		local nEnemySkNum = math.random(2,4)
		RunRoleAttackAni(m_HeroObject, m_EnemyObject,nil,nHeroSkNum)
		RunRoleAttackAni(m_EnemyObject, m_HeroObject,nil,nEnemySkNum)
	end
	m_HeroObject:GetAnimate():setVisible(true)
	m_HeroObject:GetAnimate():setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 - 120 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 - 120))
	m_EnemyObject:GetAnimate():setVisible(true)
	m_EnemyObject:GetAnimate():setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + 140 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 - 120))
end

local function ResetFunc( nState )
	local pCurLayer = m_TablePataInfo.CurLayer
	if pCurLayer > 100 then pCurLayer = 100 end
	--重置开始前修改响应
	if nState == false then
		--删除动画
		DelTopEffect()
		--判断当前层数是否超过4层，如果超过4层，则按下落5次处理，如果没有，则按当前层数下落
		local downMaxNum = nil
		if pCurLayer > 4 then
			downMaxNum = 5
		else
			downMaxNum = pCurLayer
		end
		local downNum = 1
		local function ChongzhiAni( ... )	
			if m_TablePataInfo.MaxLayer <= 1 then
				m_PataAni:stopAllActions()
				m_PataAni:getAnimation():setSpeedScale(m_PlayScale / 4)
				if m_HeroObject ~= nil then
					m_HeroObject:GetAnimate():setVisible(false)
					m_HeroObject:Destroy()
					m_HeroObject = nil
				end
				if m_EnemyObject ~= nil then
					m_EnemyObject:GetAnimate():setVisible(false)
					m_EnemyObject:Destroy()
					m_EnemyObject = nil
				end
				BeginComingAni()
				UpdatePataData()			--更新怪物
				if m_PataPanel:getChildByTag(106)~=nil then
					m_PataPanel:getChildByTag(106):setText(m_TablePataInfo.FreeReSet.."/"..GetPataResetNum())
				end
			else
				if downNum >= downMaxNum then
					m_PataAni:stopAllActions()
					m_PataAni:getAnimation():play("Animation1")
					BeginComingAni()			--开始动画
					UpdatePataData()			--更新怪物
					m_PataAni:getAnimation():setSpeedScale(m_PlayScale / 4)
					--重置过后判断扫荡按钮是否显示
					JudgeSaoDangBtnShow(m_SaoDangBtn,pCurLayer,m_TablePataInfo.MaxLayer,m_TablePataInfo.FreeReSet)
					--次数重置
					if m_PataPanel:getChildByTag(106)~=nil then
						m_PataPanel:getChildByTag(106):setText(m_TablePataInfo.FreeReSet.."/"..GetPataResetNum())
					end
					CurLayerComeInAni()			--修改层数
					--重置结束后修改响应
					if m_CurPataState == PataSate.State_Normal then
						PataUIResponseState(PataSate.State_Normal)
					else
						PataUIResponseState(nil)
					end
				else
					--播放动画前删除英雄和敌人
					if m_HeroObject ~= nil then
						m_HeroObject:Destroy()
						m_HeroObject = nil
					end
					if m_EnemyObject ~= nil then
						m_EnemyObject:Destroy()
						m_EnemyObject = nil
					end
					--当前层数消失
					m_PataPanel:getChildByTag(105):setScale(0)
					m_PataAni:getAnimation():play("Animation3")
					downNum = downNum + 1
				end
			end
		end
		local function over( ... )
			if m_CurPataState == PataSate.State_Normal then
				PataUIResponseState(PataSate.State_Normal)
			end
			NetWorkLoadingLayer.loadingHideNow()
			local actionArray1 = CCArray:create()
			actionArray1:addObject(CCCallFunc:create(ChongzhiAni))
			actionArray1:addObject(CCDelayTime:create(0.25))
			m_PataAni:runAction(CCRepeatForever:create(CCSequence:create(actionArray1)))
		end
		if m_PataPanel:getChildByTag(109)~=nil then
			m_PataPanel:getChildByTag(109):removeFromParentAndCleanup(true)
		end
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/pata/Animation/pata01/pata01.ExportJson")
		m_PataAni = CCArmature:create("pata01")
		m_PataAni:getAnimation():setSpeedScale(m_PlayScale)
		m_PataAni:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5))
		m_PataPanel:addChild(m_PataAni,-1,109)

		--over()
		--请求重置(增设重置条件规则)重置后同步数据
		UpdatePataData()
		Packet_ClimbingTowerSet.SetSuccessCallBack(over)
		network.NetWorkEvent(Packet_ClimbingTowerSet.CreatPacket(EClimbingTowerCMD.ClimbingTower_CMD_Reset))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function GotoVip(  )
	MainScene.GoToVIPLayer( 0 )
end

local function _Click_ChongZhi_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then

		local pCurLayer = m_TablePataInfo.CurLayer
		if pCurLayer > 100 then pCurLayer = 100 end

		local pTips = CreateTipLayerManager()
		local function Reset(  )
			if m_TablePataInfo.FreeReSet  > 0 then 
				--CreateTipsLayer(1307, TIPS_TYPE.TIPS_TYPE_NONE, nil, ResetFunc, nil)
				pTips:ShowCommonTips(1307, ResetFunc, tonumber(server_mainDB.getMainData("VipPata")))
				pTips = nil
			else
				--根据当前VIP等级判断可购买次数
				local bVipTab = MainScene.CheckVIPFunction( enumVIPFunction.eVipFunction_14 )
				if tonumber(server_mainDB.getMainData("VipPata")) > 0 then
					--购买爬塔重置次数
					local function GoBuy( bState )
						if bState == true then
							if tonumber(server_mainDB.getMainData("gold")) < bVipTab.NeedNum then
								TipLayer.createTimeLayer("元宝不足", 2)
								return
							end
							--local nPointId = GetPointId(m_TablePataInfo.SceceID, m_TablePataInfo.PointIdx)

							local function UpdateTimes(  )
								m_TablePataInfo.FreeReSet = GetPataFreeSetTimes()
								if m_PataPanel:getChildByTag(106)~=nil then
									m_PataPanel:getChildByTag(106):setText(m_TablePataInfo.FreeReSet.."/"..GetPataResetNum())
								end
							end
							MainScene.BuyCountFunction( enumVIPFunction.eVipFunction_14, m_TablePataInfo.SceceID, m_TablePataInfo.PointIdx, UpdateTimes )
						end
					end
					pTips:ShowCommonTips(1629,GoBuy,bVipTab.NeedNum, bVipTab.name, tonumber(server_mainDB.getMainData("VipPata")))
					pTips = nil
				else
					--去往充值界面
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
		end
		--重置爬塔
		if m_CurPataState == PataSate.State_Normal then 
			if pCurLayer ~= 1 then
				Reset()
			else
				UpdatePataData()
				--print(m_BeforeLayer, m_TablePataInfo.MaxLayer)
				--Pause()
				if m_BeforeLayer > m_TablePataInfo.MaxLayer then
					Reset()
				else
					--ErrorTipShow(1303)
					--TipLayer.createTimeLayer("您当前位于塔的底层，无需重置！",2)
					pTips:ShowCommonTips(1303,nil)
					pTips = nil
				end
			end
		else
			--错误提示当前正在扫荡状态ing
			--ErrorTipShow(1309)
			--TipLayer.createTimeLayer("扫荡中无法重置！",2)
			pTips:ShowCommonTips(1309,nil)
			pTips = nil
		end
		sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function PataFighting( ... )
	return m_IsPata
end

function GetPataSceneId( ... )
	return m_TablePataInfo.SceceID
end

function GetPataIndexId( ... )
	return m_TablePataInfo.PointIdx
end

local function SaoDangAutoFight( nCurLayer )
--計算時間差獲取當前層數
	if m_CurPataState == PataSate.State_SaoDang then
		--计算当前是否可执行下层动画,获取本层结束时间
		m_TablePataInfo.CurLayer = CountLayerNum(m_TablePataInfo.BeginTime,m_TablePataInfo.CurTime, m_TablePataInfo.EndTime,nCurLayer,true)
		--如果是扫荡状态 开启计时器 增加当前时间
		print("m_TablePataInfo.CurTime = "..m_TablePataInfo.CurTime)
		print("m_TablePataInfo.EndTime = "..m_TablePataInfo.EndTime)
		local function tick( dt )
			m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + 1
			--print("m_TablePataInfo.CurTime = "..m_TablePataInfo.CurTime.. " endTIme = "..m_TablePataInfo.EndTime)
			if m_TablePataInfo.CurTime >= m_TablePataInfo.EndTime - 1 then
				--播放扫荡结束动画
				EndSaoDangAni()
				if m_nHanderTime ~= nil then 
					m_PataPanel:getScheduler():unscheduleScriptEntry(m_nHanderTime)
					m_nHanderTime = nil
				end
			else
				local isPlayNext, m_SurPlusTime = JudgePlayNextLevel(m_TablePataInfo.BeginTime, m_TablePataInfo.CurTime, m_TablePataInfo.EndTime)
				--print("m_SurPlusTime = "..m_SurPlusTime)
				if isPlayNext == true then
					--检测更新数据
					m_TablePataInfo.CurLayer = m_TablePataInfo.CurLayer + 1
					PlayNextLayerAni()
				end
			end
		end
		if m_nHanderTime == nil then
			m_nHanderTime = m_PataPanel:getScheduler():scheduleScriptFunc(tick, 1, false)
		end	
	end
end

local function MopEndRightNowTip( nState )
	if nState == false then
		--立即结束动画
		local upNum = 1
		local nJumpNum = 5
		if m_TablePataInfo.MaxLayer - m_TablePataInfo.CurLayer + 1 >= 5 then
			nJumpNum = 5
		else
			nJumpNum = m_TablePataInfo.MaxLayer - m_TablePataInfo.CurLayer + 1
		end
		local function ConsumptionEndMop( ... )	
			if upNum >= nJumpNum then
				m_PataAni:stopAllActions()
				m_PataAni:getAnimation():play("Animation1")
				if m_TablePataInfo.MaxLayer >= 101 then
					BeginComingAniByCheerEnd()
				else
					BeginComingAni()	
				end
				UpdatePataData()			--更新怪物
				CurLayerComeInAni()			--修改层数
				m_PataAni:getAnimation():setSpeedScale(m_PlayScale / 4)
				--重置过后判断扫荡按钮是否显示
				JudgeSaoDangBtnShow(m_SaoDangBtn,m_TablePataInfo.CurLayer,m_TablePataInfo.MaxLayer,m_TablePataInfo.FreeReSet)
				if m_nHanderTime ~= nil then 
					m_PataPanel:getScheduler():unscheduleScriptEntry(m_nHanderTime)
					m_nHanderTime = nil
				end
				--停止倒计时
				StopFightDelayTime()
				--提示奖励
				--ErrorTipShow(1301)
				local pTips = CreateTipLayerManager()
				pTips:ShowCommonTips(1301,nil)
				pTips = nil
				m_CurPataState = PataSate.State_Normal
				CommonData.g_IsPaTaIng = false
			else
				--播放动画前删除英雄和敌人
				if m_HeroObject ~= nil then
					m_HeroObject:Destroy()
					m_HeroObject = nil
				end
				if m_EnemyObject ~= nil then
					m_EnemyObject:Destroy()
					m_EnemyObject = nil
				end
				--当前层数消失
				m_PataPanel:getChildByTag(105):setScale(0)
				m_PataAni:getAnimation():play("Animation4")
				upNum = upNum + 1
			end
		end

		local function over( )
			if m_CurPataState == PataSate.State_Normal then
				PataUIResponseState(PataSate.State_Normal)
			else
				PataUIResponseState(PataSate.State_SaoDang)
			end
			if m_nHanderTime ~= nil then
				m_PataPanel:getScheduler():unscheduleScriptEntry(m_nHanderTime)
				m_nHanderTime = nil
			end
			m_SaoDangBtn:getChildByTag(100):setVisible(true)
			m_SaoDangBtn:getChildByTag(101):setVisible(false)
			m_SaoDangBtn:setTag(100)
			m_SaoDangBtn:setTouchEnabled(false)
			local actionArray1 = CCArray:create()
			actionArray1:addObject(CCCallFunc:create(ConsumptionEndMop))
			actionArray1:addObject(CCDelayTime:create(0.25))
			NetWorkLoadingLayer.loadingHideNow()
			m_PataAni:runAction(CCRepeatForever:create(CCSequence:create(actionArray1)))
		end
		if m_PataPanel:getChildByTag(109)~=nil then
			m_PataPanel:getChildByTag(109):removeFromParentAndCleanup(true)
		end
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/pata/Animation/pata01/pata01.ExportJson")
		m_PataAni = CCArmature:create("pata01")
		m_PataAni:getAnimation():setSpeedScale(m_PlayScale)
		m_PataAni:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5))
		m_PataPanel:addChild(m_PataAni,-1,109)
		--请求立即结束
		Packet_ClimbingTowerSet.SetSuccessCallBack(over)
		network.NetWorkEvent(Packet_ClimbingTowerSet.CreatPacket(EClimbingTowerCMD.ClimbingTower_CMD_ConsumptionEndMop))
		NetWorkLoadingLayer.loadingShow(true)
		UpdatePataData()	
	end
end

local function _Click_SaoDang_PataLayer_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)

		local pCurLayer = m_TablePataInfo.CurLayer
		if pCurLayer > 100 then pCurLayer = 100 end

		local pTipPata = CreateTipLayerManager()
		if sender:getTag() == 100 then 				--当前点击后是扫荡状态
			--爬塔设置信息初始化
			local function over( ... )
				--开始扫荡后 同步一遍数据
				--扫荡请求成功后，显示立即完成字样
				m_CurPataState = PataSate.State_SaoDang
				CommonData.g_IsPaTaIng = true
				sender:getChildByTag(101):setVisible(true)
				sender:getChildByTag(100):setVisible(false)
				sender:setTag(101)
				PataUIResponseState(nil)
				UpdatePataData()	
				StartSaoDangAni()
				SaoDangAutoFight(pCurLayer)
				NetWorkLoadingLayer.loadingHideNow()
				--开启倒计时
				ContinueFightDelayTime()
			end
			--请求爬塔(增设爬塔条件规则)
			print("cur = "..pCurLayer)
			print("max = "..m_TablePataInfo.MaxLayer)
			if pCurLayer <= m_TablePataInfo.MaxLayer - 1 then
				Packet_ClimbingTowerSet.SetSuccessCallBack(over)
				network.NetWorkEvent(Packet_ClimbingTowerSet.CreatPacket(EClimbingTowerCMD.ClimbingTower_CMD_StarMopUp))
				NetWorkLoadingLayer.loadingShow(true)
			else
				--ErrorTipShow(1308)
				--修改
				pTipPata:ShowCommonTips(1308,nil)
				pTipPata = nil
				--TipLayer.createTimeLayer("当前在可扫荡的最高层，需重置后才能扫荡",2)
			end
		elseif sender:getTag() == 101 then 				--当前点击后是立即结束状态
			--判断是否可以扫荡
			if MopEndJudge(pCurLayer,m_TablePataInfo.MaxLayer) == true and m_CurPataState == PataSate.State_SaoDang then
				if pCurLayer < m_TablePataInfo.MaxLayer - 1 then
					pTipPata:ShowCommonTips(1306,MopEndRightNowTip,tonumber(GetConsumeMoneyMax(pCurLayer,m_TablePataInfo.MaxLayer)))
					pTipPata = nil
				else
					pTipPata:ShowCommonTips(1305,nil)
					pTipPata = nil
				end
			else
				pTipPata:ShowCommonTips(1002,nil)
				pTipPata = nil
			end
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function GetCurStars(  )
	return GetPointStars(DungeonsType.ClimbingTower,m_TablePataInfo.SceceID,m_TablePataInfo.PointIdx)
end

function GetDeltaTIme( nTime )
	m_PauseTime = nTime
	print("m_PauseTime = "..m_PauseTime)
	local nPauseLayer = m_PauseTime/20
	local nLayerSurplusTime = m_PauseTime%20
	local isGoon = false

	if isGoon == false then
		if PauseCondJudgment_1(m_PauseTime, m_TablePataInfo.BeginTime, m_TablePataInfo.EndTime) == true then
			m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + m_PauseTime
			EndSaoDangAni()	
			isGoon = true
		end
	end

	if isGoon == false then
		if PauseCondJudgment_2(m_PauseTime, m_TablePataInfo.CurTime, m_TablePataInfo.EndTime) == true then
			m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + m_PauseTime
			EndSaoDangAni()	
			isGoon = true
		end	
	end

	if isGoon == false then
		if PauseCondJudgment_3(m_PauseTime) == true then
			local nPlusTime = nil
			if m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime >= 20 then
				nPlusTime = 20 - ((m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime) % 20)--暂停之前当前层还剩多少秒
			else
				nPlusTime = 20 - (m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime)
			end
			print("nPlusTime = "..nPlusTime)
			if m_PauseTime >= nPlusTime then
				if m_IsPlayNext == false then
					print("暂停期间跳层了未播放跳层动画")
					m_TablePataInfo.CurLayer = m_TablePataInfo.CurLayer + 1
				else
					print("暂停期间跳层了已播放跳层动画")
				end
				m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + m_PauseTime
				local nPlusTimeNew = 20 - ((m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime) % 20)  --跳完层后还剩多少秒
				print("跳完层后还剩 = "..nPlusTimeNew)
				if nPlusTimeNew <= 1 then
					print("跳完层后剩余时间不够执行跳层动画")
					m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + nPlusTimeNew
					m_TablePataInfo.CurLayer = m_TablePataInfo.CurLayer + 1
					PlayNextLayerAni()					
				end
			else
				m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + m_PauseTime
				local nPlusTimeNew = 20 - ((m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime) % 20)
				print("暂停过后还没跳层 剩余时间 = "..nPlusTimeNew)
				if nPlusTimeNew <= 1 then
					print("剩余时间小于1秒直接跳层")
					m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + nPlusTimeNew
					m_TablePataInfo.CurLayer = m_TablePataInfo.CurLayer + 1
					PlayNextLayerAni()
				end
			end
			
			isGoon = true
		end	
	end

	if isGoon == false then
		if PauseCondJudgment_4(m_PauseTime) == true then
			local nLayer = m_PauseTime / 20
			local nLayerSurTime = m_PauseTime % 20
			local nPlusTime = nil
			if m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime >= 20 then
				nPlusTime = 20 - ((m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime) % 20)--暂停之前当前层还剩多少秒
			else
				nPlusTime = 20 - (m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime)
			end
			m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + m_PauseTime
			m_TablePataInfo.CurLayer = m_TablePataInfo.CurLayer + math.floor(nLayer)
			print("暂停过后跳了"..math.floor(nLayer).."层")
			--print("nLayerSurTime = "..nLayerSurTime)
			--print("nPlusTime = "..nPlusTime)
			if nLayerSurTime >= nPlusTime then
				print("剩余的暂停时间大于暂停前那层还剩下的时间，所以可以直接跳转")
				m_TablePataInfo.CurLayer = m_TablePataInfo.CurLayer + 1
				PlayNextLayerAni()
		 	end 
			local nPlusTimeNew = 20 - ((m_TablePataInfo.CurTime - m_TablePataInfo.BeginTime) % 20)
			print("跳完层后当前层剩余时间为"..nPlusTimeNew)
			if nPlusTimeNew <= 1 then
				print("剩余时间小于1秒直接跳层")
				m_TablePataInfo.CurTime = m_TablePataInfo.CurTime + nPlusTimeNew
				m_TablePataInfo.CurLayer = m_TablePataInfo.CurLayer + 1
				PlayNextLayerAni()
			end
		end

		isGoon = true
	end

end

local function InitPata(  )
	--获取当前层数数据
	--获取当前层数的关卡ID和战役ID
	m_TablePataInfo = {}
	m_PauseTime = 0
	local panel_fightdata = tolua.cast(m_PataPanel:getWidgetByName("Panel_Data"), "Layout")
	panel_fightdata:setPosition(ccp(panel_fightdata:getPositionX() + CommonData.g_Origin.x, panel_fightdata:getPositionY() + CommonData.g_Origin.y))
	local pheight		  = panel_fightdata:getContentSize().height
	local data 			  = GetPataData(DungeonsType.ClimbingTower)
	--Table set
	m_BeforeLayer   = data.CurrentLayer
	print("m_BeforeLayer = "..m_BeforeLayer)
	m_TablePataInfo.MaxLayer   = data.MaxLayer
	m_TablePataInfo.CurLayer   = math.min(data.CurrentLayer,m_TablePataInfo.MaxLayer)
	m_TablePataInfo.BeginTime  = data.SaoDangBeginTime
	m_TablePataInfo.EndTime    = data.SaoDangEndTime
	m_TablePataInfo.CurTime    = data.SaoDangCurTime
	m_TablePataInfo.FreeReSet  = data.FreeReset
	if m_TablePataInfo.CurLayer > 100 then
		m_TablePataInfo.SceceID    = GetSceneID(100)
		m_TablePataInfo.PointIdx   = GetPointIdx(100)
	else
		m_TablePataInfo.SceceID    = GetSceneID(m_TablePataInfo.CurLayer)
		m_TablePataInfo.PointIdx   = GetPointIdx(m_TablePataInfo.CurLayer)
	end
	m_TablePataInfo.LayerTime  = GetPataMopUpTime()
	local nPointId		  = GetPointIdxBySceneId(m_TablePataInfo.SceceID ,m_TablePataInfo.PointIdx)

	print("m_TablePataInfo.SceceID = "..m_TablePataInfo.SceceID )
	print("m_TablePataInfo.PointIdx = "..m_TablePataInfo.PointIdx)	
	print("m_TablePataInfo.After.CurLayer = "..m_TablePataInfo.CurLayer)
	print("m_TablePataInfo.MaxLayer = "..m_TablePataInfo.MaxLayer)
	print("m_TablePataInfo.FreeReSet = "..m_TablePataInfo.FreeReSet)
	print("m_TablePataInfo.BeginTime = "..m_TablePataInfo.BeginTime)
	print("m_TablePataInfo.EndTime = "..m_TablePataInfo.EndTime)
	print("m_TablePataInfo.CurTime = "..m_TablePataInfo.CurTime)
	print("starNum = "..GetPointStars(DungeonsType.ClimbingTower,m_TablePataInfo.SceceID,m_TablePataInfo.PointIdx))
	--判断当前是否在扫荡
	if m_TablePataInfo.BeginTime ~= 0 and m_TablePataInfo.CurTime < m_TablePataInfo.EndTime then
		--当前在扫荡 走扫荡逻辑
		m_CurPataState = PataSate.State_SaoDang
		CommonData.g_IsPaTaIng = true
	else
		--当前没有扫荡，走正常页面逻辑
		m_CurPataState = PataSate.State_Normal
		CommonData.g_IsPaTaIng = false
	end 

	if m_CurPataState == PataSate.State_SaoDang then
		SaoDangAutoFight(data.CurrentLayer)
	end

	m_IsPlayNext = false

	--计算进场怪物ID
	local tabMonster = GetMonsterList(nPointId)
	for key,value in pairs(tabMonster) do
		if value.MonsterType == MonsterType.Genereal then
			m_MonsterRes = GetMonsterResId(value.MonsterId)
			break
		else
			if key == table.getn(tabMonster) then
				m_MonsterRes = GetMonsterResId(value.MonsterId)
			end
		end 
	end
	--add Bg Animation
	if m_PataPanel:getChildByTag(109) ~= nil then
		m_PataPanel:getChildByTag(109):removeFromParentAndCleanup(true)
	end
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/pata/Animation/pata01/pata01.ExportJson")
	m_PataAni = CCArmature:create("pata01")
	m_PataAni:getAnimation():play("Animation1")
	m_PlayScale = m_PataAni:getAnimation():getSpeedScale() * 4
	m_PataAni:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5))
	m_PataPanel:addChild(m_PataAni,-1,109)

	m_SaoDangBtn = tolua.cast(m_PataPanel:getWidgetByName("Button_SaoDang"), "Button")
	m_SaoDangBtn:setPosition(ccp(m_SaoDangBtn:getPositionX() - CommonData.g_Origin.x,m_SaoDangBtn:getPositionY() - CommonData.g_Origin.y))
	m_SaoDangBtn:addTouchEventListener(_Click_SaoDang_PataLayer_CallBack)
	m_SaoDangBtn:setTouchEnabled(true)

	--初始化页面数据
	local StrokeLabel_Box = StrokeLabel_createStrokeLabel(22, CommonData.g_FONT3, "宝箱预览", ccp(0, 5), ccc3(33,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
	local btn_RewardBox = tolua.cast(m_PataPanel:getWidgetByName("Button_Box"), "Button")
	btn_RewardBox:setPosition(ccp(btn_RewardBox:getPositionX() - CommonData.g_Origin.x,btn_RewardBox:getPositionY() - CommonData.g_Origin.y))
	btn_RewardBox:addChild(StrokeLabel_Box)


	local StrokeLabel_Ranking= StrokeLabel_createStrokeLabel(22, CommonData.g_FONT3, "排行榜", ccp(0, 5), ccc3(33,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
	local btn_ranking = tolua.cast(m_PataPanel:getWidgetByName("Button_Ranking"), "Button")
	btn_ranking:setPosition(ccp(btn_ranking:getPositionX() - CommonData.g_Origin.x,btn_ranking:getPositionY() - CommonData.g_Origin.y))
	btn_ranking:addChild(StrokeLabel_Ranking)
	btn_ranking:setVisible(false)
	btn_ranking:setTouchEnabled(false)
	btn_RewardBox:setPosition(ccp(btn_ranking:getPositionX(), btn_ranking:getPositionY()))

	local StrokeLabel_Reset= StrokeLabel_createStrokeLabel(36, CommonData.g_FONT1, "重置", ccp(0, 4), COLOR_Black, COLOR_White, true, ccp(0, 0), 3)
	local btn_reset = tolua.cast(m_PataPanel:getWidgetByName("Button_Reset"), "Button")
	btn_reset:setPosition(ccp(btn_reset:getPositionX() + CommonData.g_Origin.x,btn_reset:getPositionY() - CommonData.g_Origin.y))
	btn_reset:addChild(StrokeLabel_Reset)
	--btn_reset:setTouchPriority(-129)

	local StrokeLabel_Saodang= StrokeLabel_createStrokeLabel(36, CommonData.g_FONT1, "扫荡", ccp(0, 4), COLOR_Black, COLOR_White, true, ccp(0, 0), 3)
	local StrokeLabel_SaodangEnd= StrokeLabel_createStrokeLabel(36, CommonData.g_FONT1, "立即结束", ccp(0, 4), COLOR_Black, COLOR_White, true, ccp(0, 0), 3)
	m_SaoDangBtn:addChild(StrokeLabel_Saodang,1,100)
	m_SaoDangBtn:addChild(StrokeLabel_SaodangEnd,1,101)

	local StrokeLabel_Fenxi= StrokeLabel_createStrokeLabel(22, CommonData.g_FONT1, "战事分析", ccp(0, 0), COLOR_Black, ccc3(255,233,131), true, ccp(0, 0), 2)
	local img_fenxi = tolua.cast(m_PataPanel:getWidgetByName("Image_TextBg_1"), "ImageView")
	img_fenxi:addChild(StrokeLabel_Fenxi)	

	local StrokeLabel_FightData= StrokeLabel_createStrokeLabel(22, CommonData.g_FONT1, "查看战报", ccp(0, 0), COLOR_Black, ccc3(255,233,131), true, ccp(0, 0), 2)
	local img_fightdata = tolua.cast(m_PataPanel:getWidgetByName("Image_TextBg_2"), "ImageView")
	img_fightdata:addChild(StrokeLabel_FightData)

	local imgFX_Bg = tolua.cast(m_PataPanel:getWidgetByName("Image_Fenxi"), "ImageView")
	imgFX_Bg:setPosition(ccp(imgFX_Bg:getPositionX() - CommonData.g_Origin.x,imgFX_Bg:getPositionY() - CommonData.g_Origin.y))
	local imgFD_Bg = tolua.cast(m_PataPanel:getWidgetByName("Image_FightData"), "ImageView")
	imgFD_Bg:setPosition(ccp(imgFD_Bg:getPositionX() - CommonData.g_Origin.x,imgFD_Bg:getPositionY() - CommonData.g_Origin.y))	
	imgFD_Bg:setVisible(false)
	imgFD_Bg:setTouchEnabled(false)

	local StrokeLabel_Cur= StrokeLabel_createStrokeLabel(24, CommonData.g_FONT1, "当前：   层", ccp(70, pheight - 20), COLOR_Black, ccc3(228,199,167), true, ccp(0, 0), 2)
	panel_fightdata:addChild(StrokeLabel_Cur)	
	if m_TablePataInfo.CurLayer > 100 then
		local StrokeLabel_CurNum= StrokeLabel_createStrokeLabel(24, CommonData.g_FONT3, 100, ccp(80, pheight - 20), COLOR_Black, ccc3(25,254,235), true, ccp(0, 0), 0)
		panel_fightdata:addChild(StrokeLabel_CurNum,1,100)	
	else
		local StrokeLabel_CurNum= StrokeLabel_createStrokeLabel(24, CommonData.g_FONT3, m_TablePataInfo.CurLayer, ccp(80, pheight - 20), COLOR_Black, ccc3(25,254,235), true, ccp(0, 0), 0)
		panel_fightdata:addChild(StrokeLabel_CurNum,1,100)	
	end
	local StrokeLabel_Rule= StrokeLabel_createStrokeLabel(24, CommonData.g_FONT1, "通关条件:", ccp(60, pheight - 50), COLOR_Black, ccc3(228,199,167), true, ccp(0, 0), 2)
	panel_fightdata:addChild(StrokeLabel_Rule)	
	local StrokeLabel_Reward= StrokeLabel_createStrokeLabel(24, CommonData.g_FONT1, "本层奖励：", ccp(65, 140), COLOR_Black, ccc3(228,199,167), true, ccp(0, 0), 2)
	panel_fightdata:addChild(StrokeLabel_Reward)
	local StrokeLabel_Coin_1 = CreateLabel("99999", 24, ccc3(25,254,235), CommonData.g_FONT3, ccp(100, 103))
	panel_fightdata:addChild(StrokeLabel_Coin_1,1,201)	
	StrokeLabel_Coin_1:setVisible(false)
	local StrokeLabel_Coin_2 = CreateLabel("99999", 24, ccc3(25,254,235), CommonData.g_FONT3, ccp(100, 67))	
	panel_fightdata:addChild(StrokeLabel_Coin_2,1,202)	
	StrokeLabel_Coin_2:setVisible(false)
	local StrokeLabel_Coin_3 = CreateLabel("99999", 24, ccc3(25,254,235), CommonData.g_FONT3, ccp(100, 28))	
	panel_fightdata:addChild(StrokeLabel_Coin_3,1,203)	
	StrokeLabel_Coin_3:setVisible(false)
	if m_TablePataInfo.CurLayer > 100 then
		--local StrokeLabel_CurNum_Middle= StrokeLabel_createStrokeLabel(48, CommonData.g_FONT1, 100, ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 + 190), ccc3(209,136,84), ccc3(61,59,24), true, ccp(0, 0), 2)
		--m_PataPanel:addChild(StrokeLabel_CurNum_Middle,1,105)	
		local StrokeLabel_CurNum_Middle = LabelBMFont:create()
		StrokeLabel_CurNum_Middle:setFntFile("Image/imgres/common/num/pataNum.fnt")
		StrokeLabel_CurNum_Middle:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 + 193))
		StrokeLabel_CurNum_Middle:setText(100)
		m_PataPanel:addChild(StrokeLabel_CurNum_Middle,1,105)
	else
		--local StrokeLabel_CurNum_Middle= StrokeLabel_createStrokeLabel(48, CommonData.g_FONT1, m_TablePataInfo.CurLayer, ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 + 190), ccc3(209,136,84), ccc3(61,59,24), true, ccp(0, 0), 2)
		--m_PataPanel:addChild(StrokeLabel_CurNum_Middle,1,105)	
		local StrokeLabel_CurNum_Middle = LabelBMFont:create()
		StrokeLabel_CurNum_Middle:setFntFile("Image/imgres/common/num/pataNum.fnt")
		StrokeLabel_CurNum_Middle:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height * 0.5 + 193))
		StrokeLabel_CurNum_Middle:setText(m_TablePataInfo.CurLayer)
		m_PataPanel:addChild(StrokeLabel_CurNum_Middle,1,105)
	end
	local img = tolua.cast(m_PataPanel:getWidgetByName("Image_Consume"), "ImageView")
	img:setPositionX(m_SaoDangBtn:getPositionX() - 180)
	local nConsumeData = GetConsumeData()
	img:loadTexture(nConsumeData.IconPath)
	--print("GetConsumeMoneyMax === "..GetConsumeMoneyMax())
	if m_TablePataInfo.CurLayer > 100 then
		local StrokeLabel_ConsumeNum= StrokeLabel_createStrokeLabel(24, CommonData.g_FONT1, GetConsumeMoneyMax(100,100), ccp(50, 0), COLOR_Black, ccc3(25,254,235), true, ccp(0, 0), 2)
		img:addChild(StrokeLabel_ConsumeNum,1,108)
	else		
		--print(m_TablePataInfo.CurLayer,m_TablePataInfo.MaxLayer)
		--Pause()
		local StrokeLabel_ConsumeNum= StrokeLabel_createStrokeLabel(24, CommonData.g_FONT1, GetConsumeMoneyMax(m_TablePataInfo.CurLayer,m_TablePataInfo.MaxLayer), ccp(50, 0), COLOR_Black, ccc3(25,254,235), true, ccp(0, 0), 2)
		img:addChild(StrokeLabel_ConsumeNum,1,108)
	end	

	local StrokeLabel_Surplus= StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "剩余次数:", ccp(btn_reset:getPositionX() + 160, btn_reset:getPositionY()), COLOR_Black, ccc3(228,199,167), true, ccp(0, 0), 2)
	m_PataPanel:addChild(StrokeLabel_Surplus)
	local colorSurplus = ccc3(25,254,235)
	--[[if m_TablePataInfo.FreeReSet == 0 then
		colorSurplus = ccc3(253,68,12)
	end]]
	local StrokeLabel_SurplusNum = CreateLabel(m_TablePataInfo.FreeReSet.."/"..GetPataResetNum(), 24, colorSurplus, CommonData.g_FONT3, ccp(StrokeLabel_Surplus:getPositionX() + 110, StrokeLabel_Surplus:getPositionY()))
	m_PataPanel:addChild(StrokeLabel_SurplusNum,1,106)	

	--时间
	local Image_HourBg = tolua.cast(m_PataPanel:getWidgetByName("Image_HourBg"), "ImageView")
	--Image_HourBg:setPosition(ccp(Image_HourBg:getPositionX() + CommonData.g_Origin.x,Image_HourBg:getPositionY() - CommonData.g_Origin.y))
	Image_HourBg:setPosition(ccp(CommonData.g_sizeVisibleSize.width * 0.5 + CommonData.g_Origin.x + 20,Image_HourBg:getPositionY() - CommonData.g_Origin.y))
	local StrokeLabel_minute = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT3, "00", ccp(-20, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_HourBg:addChild(StrokeLabel_minute,1,110)
	local StrokeLabel_colon = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT3, ":", ccp(0, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_HourBg:addChild(StrokeLabel_colon,1)
	local StrokeLabel_second = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT3, "00", ccp(20, 0), COLOR_Black, ccc3(248,158,80), true, ccp(0, 0), 1)
	Image_HourBg:addChild(StrokeLabel_second,1,111)

	local click_fenxi = tolua.cast(m_PataPanel:getWidgetByName("Image_FenXiClick"), "ImageView")
	local click_fightdata = tolua.cast(m_PataPanel:getWidgetByName("Image_FightDataClick"), "ImageView")

	click_fenxi:addTouchEventListener(_Click_FenXi_PataLayer_CallBack)
	click_fightdata:addTouchEventListener(_Click_FightData_PataLayer_CallBack)
	btn_reset:addTouchEventListener(_Click_ChongZhi_PataLayer_CallBack)
	btn_RewardBox:addTouchEventListener(_Click_ShowBox_PataLayer_CallBack)
	btn_ranking:addTouchEventListener(_Click_Ranking_PataLayer_CallBack)

	--init uiData
	--初始化货币奖励
	local tabCoin = GetRewardCoinData(nPointId)
	local coinTabNum = table.getn(tabCoin)
	for i=1,coinTabNum do
		local imgCoin = tolua.cast(panel_fightdata:getChildByName("Image_Coin"..i), "ImageView")
		imgCoin:loadTexture(tabCoin[i].CoinPath)
		imgCoin:setVisible(true)
		if panel_fightdata:getChildByTag(200 + i) ~=nil then
			panel_fightdata:getChildByTag(200 + i):setText(tabCoin[i].CoinNum)
			panel_fightdata:getChildByTag(200 + i):setVisible(true)
		end
	end
	--通关条件
	if panel_fightdata:getChildByTag(101) ~= nil then
		panel_fightdata:getChildByTag(101):removeFromParentAndCleanup(true)
	end
	local RuleText = RichLabel.Create(GetRuleTextByPointID(nPointId),panel_fightdata:getContentSize().width - 20)
	RuleText:setPosition(ccp(30,188))
	panel_fightdata:addChild(RuleText,1,101)
	if m_TablePataInfo.CurLayer > 100 then
		JudgeSaoDangBtnShow(m_SaoDangBtn,100,m_TablePataInfo.MaxLayer,m_TablePataInfo.FreeReSet,true,img)
	else
		JudgeSaoDangBtnShow(m_SaoDangBtn,m_TablePataInfo.CurLayer,m_TablePataInfo.MaxLayer,m_TablePataInfo.FreeReSet,true,img)
	end
	--初始化几个动画
	--人物入场动画
	if m_CurPataState == PataSate.State_SaoDang then
		PataUIResponseState(PataSate.State_SaoDang)
		BeginComingAniBySaoDang()
		SetFightDelayTime(m_TablePataInfo.EndTime - m_TablePataInfo.CurTime)
	else
		PataUIResponseState(PataSate.State_Normal)
		local starNum = GetPointStars(DungeonsType.ClimbingTower,m_TablePataInfo.SceceID,m_TablePataInfo.PointIdx)
		if tonumber(starNum) < 3 and m_BeforeLayer > m_TablePataInfo.MaxLayer then
			BeginComingAniByFailed()
		else
			if m_TablePataInfo.CurLayer >= 100 then
				BeginComingAniByCheerEnd()
			else 
				BeginComingAni()
			end
		end
	end
end

function CheckPataOpen(  )
	--爬塔功能开放检测
	local nSceneId = GetSceneID(1)
	local nSceneIdx = GetSceneIdxById(nSceneId)
	local nRuleId  = GetSceneRuleId(nSceneIdx)

	local nNeedLv = GetNeedLv(nRuleId)

	if nNeedLv ~= nil then

		if server_mainDB.getMainData("level") >= nNeedLv then 

			return true

		end

	end

	return false, nNeedLv
end

function PataBattleBegin(  )
	local function BattleBeginOver(pServerDataStream)
		if pServerDataStream ~= nil then 
			NetWorkLoadingLayer.loadingHideNow()
			require "Script/Fight/BaseScene"
			BaseScene.createBaseScene()
			if NETWORKENABLE > 0 then
				BaseScene.InitServerFightData(pServerDataStream)
			end
			NetWorkLoadingLayer.loadingHideNow()
			BaseScene.EnterBaseScene()
			m_IsPata = true
		end
	end

	Packet_BattleBegin.SetSuccessCallBack(BattleBeginOver)
end

--create entrance
function CreatePataLayer()
	InitVars()
	m_IsPata = true
	m_PataPanel = TouchGroup:create()
	m_PataPanel:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/PataLayer.json"))
	m_PataLayout = tolua.cast(m_PataPanel:getWidgetByName("Panel_PaTa"), "Layout")
	InitPata()

    --返回按钮
    local pBtnReturn = tolua.cast(m_PataPanel:getWidgetByName("Button_Return"), "Button")
    pBtnReturn:setPosition(ccp(pBtnReturn:getPositionX() + CommonData.g_Origin.x,pBtnReturn:getPositionY() - CommonData.g_Origin.y))
    pBtnReturn:addTouchEventListener(_Click_Return_PataLayer_CallBack)
    if m_CurPataState == PataSate.State_SaoDang then
    	CommonData.g_IsPaTaIng = true
    end
    
	return m_PataPanel
end