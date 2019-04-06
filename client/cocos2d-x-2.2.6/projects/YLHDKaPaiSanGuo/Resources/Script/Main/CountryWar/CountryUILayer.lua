-- for CCLuaEngine traceback
require "Script/Common/Common"
require "Script/Fight/simulationStl"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/CountryWarRaderLayer"
require "Script/Main/CountryWar/ClickCityLayer"
require "Script/Main/CountryWar/CountryWarDef"
require "Script/Main/CountryWar/PathFinding"
require "Script/Main/CountryWar/CityNode"
require "Script/Main/Chat/ChatShowLayer"
require "Script/Main/Mission/MissionLayer"
require "Script/Main/CountryWar/CountryChildLayer"
require "Script/Main/CountryWar/CountryWarRecoveryBloodLayer"


module("CountryUILayer", package.seeall)

local m_UILayer		= nil
local m_isBlood 	= nil
local m_TarCity     = nil
local m_ActType 	= nil
local m_BDWJTab 	= {}
local m_TabCallBack = {}
local m_MissionTab  = {}
local m_nHanderTime = nil
local m_isCountTime = nil   --是否打开计时器
local m_TeamCellTime = {}


local StrokeLabel_createStrokeLabel 		= 	LabelLayer.createStrokeLabel 

local CopyItemWidget						= 	CountryWarLogic.CopyItemWidget
local GetIndexByCTag						=	CountryWarLogic.GetIndexByCTag
local GetCurActType							=	CountryWarLogic.GetCurActType
local JudgeIsUnlockCellAll					=	CountryWarLogic.JudgeIsUnlockCellAll

local GetGeneralResId 						=	CountryWarData.GetGeneralResId
local GetGeneralHeadPath					=	CountryWarData.GetGeneralHeadPath
local GetTeamTab 							=	CountryWarData.GetTeamTab
local GetTeamCount 							=	CountryWarData.GetTeamCount
local GetTeamLevel 							=	CountryWarData.GetTeamLevel
local GetTeamFace 							=	CountryWarData.GetTeamFace
local GetTeamName 							=	CountryWarData.GetTeamName
local GetTeamBlood 							=	CountryWarData.GetTeamBlood
local GetTeamCurBlood						=	CountryWarData.GetTeamCurBlood
local GetCityNameByIndex					=	CountryWarData.GetCityNameByIndex
local GetTeamState							=	CountryWarData.GetTeamState
local GetPlayerCountry						=	CountryWarData.GetPlayerCountry
local GetTeamLife							=	CountryWarData.GetTeamLife
local GetTeamCell							=	CountryWarData.GetTeamCell
local GetTeamMaxBlood 						=	CountryWarData.GetTeamMaxBlood
local GetUnlockPrisonConsume				=	CountryWarData.GetUnlockPrisonConsume
local SetTeamCurBlood						=	CountryWarData.SetTeamCurBlood
local GetPathByImageID						=	CountryWarData.GetPathByImageID

local function InitVars()
	m_UILayer		= nil
	m_TabCallBack	= nil
	m_MissionTab	= nil
	m_TeamTab 		= nil
	m_isBlood 		= nil
	m_TarCity     	= nil
	m_BDWJTab 		= nil
	m_ActType 		= nil
	m_nHanderTime 	= nil
	m_isCountTime 	= nil
	m_TeamCellTime  = nil
end

local BaseType = {
	MainScene 		=	0,
	CorpsScene 		=	1,
}

local UI_Tag = {
	UI_MISSION 		=	1200,
}

local ShowReBloodType = {
	Show  = 1,
	Hide  = 2,
}

function HideUILayer( nState )
	m_UILayer:setVisible(nState)
end

function GetControlUI( )
	return m_UILayer
end

local function _Click_MainCity_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		m_TabCallBack.MainCity()
		ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
		m_TabCallBack.BacktToNormal()
		local pParent = CountryWarScene.GetCurParent()
		local pLeaveCallBack = CountryWarScene.GetLeaveCorpsCallBack()
		--判断当前父节点是否是军团，如果是需要离开场景
		if pParent == BaseType.CorpsScene then
			if pLeaveCallBack ~= nil then
				pLeaveCallBack()
				print("父节点是军团场景,返回主场景")
			else
				print("离开军团场景的回调为空")
			end
		else

			--print("父节点不是军团场景")

		end

		
		
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Army_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		--[[local tab = CountryWarScene.GetNodeObjArr()
		local node = tab[134]
		node:AddOtherCityState(COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_ATTACK ,false)]]
		--判断当前是不是军团场景，如果不是的话创建军团并进入，如果是则直接返回
		local pParent = CountryWarScene.GetCurParent()
		if pParent == BaseType.CorpsScene then
			print("父节点是军团场景,直接返回到军团场景")
			local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
			if tonumber(isCorps) > 0 then
				m_TabCallBack.MainCity()
				require "Script/Main/Corps/CorpsScene"
				local p_scene  = CorpsScene.GetPScene()
				CorpsScene.ShowHideCoinBar(true)
				ChatShowLayer.ShowChatlayer(p_scene)
				m_TabCallBack.BacktToNormal()
			else
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1507,nil)
				pTips = nil
			end
		elseif pParent == BaseType.MainScene then
			print("父节点是主场景，创建军团场景并进入")
			if MainScene.ShowCorpsScene() ~= false then
				m_TabCallBack.MainCity()
				ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
				m_TabCallBack.BacktToNormal()
			end
		else
			m_TabCallBack.MainCity()
			ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
			m_TabCallBack.BacktToNormal()			
		end
		sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Team_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		--[[local tab = CountryWarScene.GetNodeObjArr()
		for key, value in pairs(tab) do
			value:HideAllAni()
			value:Destory()
		end
		sender:setScale(1.0)
		m_TabCallBack.BacktToNormal()]]

		require "Script/Main/CountryReward/CountryRewardLayer"
		CountryRewardLayer.createRewardLayer(m_UILayer)

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)

	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Event_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		--[[local tab = CountryWarScene.GetNodeObjArr()
		for key, value in pairs(tab) do
			value:Resume()
		end   
		sender:setScale(1.0)
		m_TabCallBack.BacktToNormal()]]
		--打开任务界面
		local pMissionLayer = MissionNormalLayer.CreateMissionNormalLayer(3)
		m_UILayer:addChild(pMissionLayer, UI_Tag.UI_MISSION, UI_Tag.UI_MISSION)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Animal_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		require "Script/Main/Corps/CorpsScene"
		local nCorpsID = server_mainDB.getMainData("nCorps")
		if tonumber(nCorpsID) > 0 then
			local function GetSuccessCallback(  )
				CorpsScene.CreateSpiriteLayer(m_UILayer)
			end	
			Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
		else
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1507,nil)
			pTips = nil
		end

		--[[require "Script/Main/CountryWar/CountryWarGuideManager"
		local pManager = CountryWarGuideManager.Create()

		local function End(  )
			print("camera move end")
			pManager:Fun_ShowUI()
			pManager:Fun_ExitCountryWarScene()
		end

		pManager:Fun_HideUI()
		pManager:Fun_CameraMoveByMainCity(End)]]

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function SetRadarBtnState( nState )
	local pRadarClick = tolua.cast(m_UILayer:getWidgetByName("Button_Radar"), "Button")
	pRadarClick:setVisible(nState)
	pRadarClick:setTouchEnabled(nState)
end

local function _Click_Rader_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(0.8)
		SetRadarBtnState(false)
		m_TabCallBack.Radar()
		m_TabCallBack.BacktToNormal()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.7)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(0.8)
	end
end

local function _Click_Show_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		if sender:isVisible() == true then
			if m_UILayer:getChildByTag(1990) ~= nil then
				m_UILayer:getChildByTag(1990):setTouchEnabled(true)
				m_UILayer:getChildByTag(1990):setVisible(true)
				m_UILayer:getChildByTag(1990):setPositionX(m_UILayer:getChildByTag(1990):getPositionX() + 10000)
			end
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function AddUIName( nParent, nNameStr )
    local pText = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT1, nNameStr, ccp(0, -32), COLOR_Black, COLOR_White, true, ccp(0, 0), 0)
    nParent:addChild(pText,2)	
end

local function MissionState( nItem )
	local Image_bottom = tolua.cast(nItem:getChildByName("Image_bottom"), "ImageView")
	local Image_finish = tolua.cast(Image_bottom:getChildByName("Image_finish"), "ImageView")
	for i=1,3 do
		local Image_launch = tolua.cast(nItem:getChildByName("Image_launch_"..i), "ImageView")
	end
	Image_finish:setVisible(true)
end

--单挑
local function Click_Solo_CallFunc( nType )
	-- body
	AtkCitySceneLogic.ToSingleFight(nType)
	CountryWarScene.SetLevelSceneFromCountryWar(true)
end

local function UnlockCell_Packet( nTeamIndex )
	local function UnlockCell( nIndex, nRes )
		NetWorkLoadingLayer.loadingShow(false)
		if nRes == 1 then
			print("队伍"..nIndex.."+1已解锁")
			local Image_Teamer 		 = tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nIndex + 1), "ImageView")
			local Label_CellTime     = tolua.cast(Image_Teamer:getChildByName("Label_CellTime"), "Label")
			local Image_Head     = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 
			local pSpriteHeadImg 	 = tolua.cast(Image_Head:getVirtualRenderer(), "CCSprite")
			m_TeamCellTime[nIndex+1]   = 0
			Label_CellTime:setVisible(false)
			SpriteSetGray(pSpriteHeadImg,0)
		else
			TipLayer.createTimeLayer("解除牢房失败",2)
		end
	end
	Packet_CountryWarUnlockCell.SetSuccessCallBack(UnlockCell)
	network.NetWorkEvent(Packet_CountryWarUnlockCell.CreatPacket(nTeamIndex))
	NetWorkLoadingLayer.loadingShow(true)
end

local function FindTeamer( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(0.68)
		local curPt = nil 
		local player = nil
		if sender:getTag() == PlayerType.E_PlayerType_Main then
			curPt = m_TeamTab["MainGeneral"]:GetCurPt()
			player = m_TeamTab["MainGeneral"]
		elseif sender:getTag() == PlayerType.E_PlayerType_1 then
			curPt = m_TeamTab["Teamer1"]:GetCurPt()
			player = m_TeamTab["Teamer1"]
		elseif sender:getTag() == PlayerType.E_PlayerType_2 then
			curPt = m_TeamTab["Teamer2"]:GetCurPt()
			player = m_TeamTab["Teamer2"]
		elseif sender:getTag() == PlayerType.E_PlayerType_3 then
			curPt = m_TeamTab["Teamer3"]:GetCurPt()
			player = m_TeamTab["Teamer3"]
		else 
		end

		if player:GetState() == PlayerState.E_PlayerState_Free or player:GetState() == PlayerState.E_PlayerState_Move then
			m_TabCallBack.FindTeamer(curPt)
			print("当前是空闲/移动，找到队员")
		elseif player:GetState() == PlayerState.E_PlayerState_Solo then
			print("当前是单挑")
			Click_Solo_CallFunc(sender:getTag() - 1)
		elseif player:GetState() == PlayerState.E_PlayerState_Rest then
			m_TabCallBack.FindTeamer(curPt)
			print("当前是休息")
		elseif player:GetState() == PlayerState.E_PlayerState_CWar then	
			m_TabCallBack.FindTeamer(curPt)
			print("当前是国战")
		elseif player:GetState() == PlayerState.E_PlayerState_Battle then	
			m_TabCallBack.FindTeamer(curPt)
			print("当前是上阵")
		elseif player:GetState() == PlayerState.E_PlayerState_Fight then	
			m_TabCallBack.FindTeamer(curPt)
			print("当前是战斗")
		elseif player:GetState() == PlayerState.E_PlayerState_Misty then
			--m_TabCallBack.FindTeamer(curPt)
			print("当前是迷雾战")	
			CountryWarScene.WatchMistyWar(sender:getTag() - 1)
		elseif player:GetState() == PlayerState.E_PlayerState_Cell then
			--m_TabCallBack.FindTeamer(curPt)
			local function Cmd_Func( nState )
				if nState == true then
					UnlockCell_Packet(sender:getTag() - 1)
				end
			end
			
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1489,Cmd_Func, GetUnlockPrisonConsume())
			pTips = nil
			print("当前是牢狱中")					
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.58)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(0.68)
	end
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

local function JudgeStateStr( nRoleStateID )
	local str = nil
	local color = nil
	if nRoleStateID == PlayerState.E_PlayerState_Free then
		str = "空闲"
		color = ccc3(5,166,8)
	elseif nRoleStateID == PlayerState.E_PlayerState_Rest then
		str = "休息"
		color = ccc3(5,166,8)
	elseif nRoleStateID == PlayerState.E_PlayerState_Move then
		str = "移动"
		color = ccc3(14,124,218)
	elseif nRoleStateID == PlayerState.E_PlayerState_CWar then
		str = "国战"
		color = ccc3(14,124,218)
	elseif nRoleStateID == PlayerState.E_PlayerState_Battle then
		str = "上阵"
		color = ccc3(226,55,9)
	elseif nRoleStateID == PlayerState.E_PlayerState_Solo then
		str = "单挑"
		color = ccc3(226,55,9)
	elseif nRoleStateID == PlayerState.E_PlayerState_Fight then
		str = "战斗"
		color = ccc3(226,55,9)
	elseif nRoleStateID == PlayerState.E_PlayerState_Misty then
		str = "迷雾战"
		color = ccc3(226,55,9)	
	elseif nRoleStateID == PlayerState.E_PlayerState_Cell then
		str = "牢狱"	
		color = ccc3(226,55,9)			
	else
		str = "出错啦"	
		color = ccc3(226,55,9)	
	end

	return str,color
end

local function SetFightDelayTime( Index )

	if m_TeamCellTime[Index] == 0 then
		--判断是不是所有队伍的已结束牢狱
		if JudgeIsUnlockCellAll() == true then
			if m_nHanderTime ~= nil then
				m_UILayer:getScheduler():unscheduleScriptEntry(m_nHanderTime)
				m_nHanderTime = nil
			end
			--print("所有队伍都没有在牢狱")

			return

		else
			--print("队伍"..Index.."结束牢狱")
			m_TeamCellTime[Index] = 0
		end
	else
		m_TeamCellTime[Index] = m_TeamCellTime[Index] - 1
	end

end

local function tick( dt )

	for nIndex,nTime in pairs( m_TeamCellTime ) do
		if m_TeamCellTime[nIndex] ~= nil then
			if m_TeamCellTime[nIndex] < 0 then return end

			SetFightDelayTime(nIndex, m_TeamCellTime[nIndex])

			if m_TeamCellTime[nIndex] ~= 0  then
				local Image_Teamer 		 = tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nIndex), "ImageView")
				local Label_CellTime     = tolua.cast(Image_Teamer:getChildByName("Label_CellTime"), "Label")
				local strM = math.floor(m_TeamCellTime[nIndex]/60)
				local strS = math.floor(m_TeamCellTime[nIndex]%60)
				local strTemp = ""
				if tonumber(strM) < 10 then strM = "0" .. strM end
				if tonumber(strS) < 10 then strS = "0" .. strS end

				--print("nIndex = "..nIndex.."   "..strM.."分", strS.."秒")

				Label_CellTime:setText(strM.."分"..strS.."秒")
				Label_CellTime:setVisible(true)
			end

		end
	end
	
end

local function ShowRecoveryBlood( nTeamIndex, pNormlize )
	-- 弹出吃血瓶按钮
	
	local Image_Teamer = tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nTeamIndex+1), "ImageView")
	local Button_RecoveryBtn = tolua.cast(Image_Teamer:getChildByName("Button_RecoveryBtn"), "Button")

    if tonumber(pNormlize) > 0 then
		Button_RecoveryBtn:setVisible(true)
		Image_Teamer:runAction(CCMoveTo:create(0.1, ccp(Image_Teamer:getPositionX(),120)))
	else
		Button_RecoveryBtn:setVisible(false)
		Image_Teamer:runAction(CCMoveTo:create(0.1, ccp(Image_Teamer:getPositionX(),70)))
	end
	print(Button_RecoveryBtn:isVisible())
	print("弹出调养Image_Teamer"..nTeamIndex+1)

end

local function ShowBloodAddTip( nParent, nValue, nPosX, nPosY )
	--TipLayer.createPopTipLayerAugment("生命值+"..nValue, 18, COLOR_Green, ccp(nPosX, nPosY + 46), 0.5, 50, false, true)
	pText = CCLabelTTF:create()
	pText:setPosition(ccp(0, 70))
	pText:setColor(COLOR_Green)
	pText:setFontSize(24)
	pText:setFontName(CommonData.g_FONT1)
	pText:setString("生命值+"..nValue)
	nParent:addNode(pText)

	local function DeleteSelf(  )
		if pText ~= nil then
			pText:removeFromParentAndCleanup(true)
			pText = nil
		end
	end

	local function hide_callback()
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCMoveBy:create(0.5, ccp(0, 50)))
		actionArray1:addObject(CCDelayTime:create(1))
		actionArray1:addObject(CCCallFuncN:create(DeleteSelf))
		pText:runAction(CCSequence:create(actionArray1))
	end

	if pText ~= nil then
		pText:setScale(0.7)
		local actionArray2 = CCArray:create()
		actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
		actionArray2:addObject(CCScaleTo:create(0.1, 1))
		actionArray2:addObject(CCDelayTime:create(0.2))
		actionArray2:addObject(CCCallFunc:create(hide_callback))
		actionArray2:addObject(CCFadeOut:create(1))
		pText:stopAllActions()
		pText:setOpacity(255)
		pText:runAction(CCSequence:create(actionArray2))
	end
end

function UpdateTeamAttr( nIndex, nAttrID, nValue )
	if m_UILayer == nil then
		return 
	end
	local Image_Teamer 		= tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nIndex+1), "ImageView")
	local Image_Bg          = tolua.cast(Image_Teamer:getChildByName("Image_Bg"), "ImageView")
	local Image_Head     	= tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 
	local Image_BloodBg     = tolua.cast(Image_Teamer:getChildByName("Image_BloodBg"), "ImageView")
	local Image_StateBg  	= tolua.cast(Image_Teamer:getChildByName("Image_StateBg"), "ImageView")
	local Labe_Level     	= tolua.cast(Image_Teamer:getChildByName("Label_Level"), "Label")
	local Image_TypeBg   	= tolua.cast(Image_Teamer:getChildByName("Image_TypeBg"), "ImageView")
	local Prog_Blood 	 	= tolua.cast(Image_BloodBg:getChildByName("ProgressBar_Blood"), "LoadingBar")
	local Button_RecoveryBtn = tolua.cast(Image_Teamer:getChildByName("Button_RecoveryBtn"), "Button")
	--print(nIndex, tonumber(nValue), GetTeamMaxBlood(nIndex))
	--Pause()
	if nAttrID == TEAM_ATTR.Blood then
		local pBlood = tonumber(nValue) / GetTeamMaxBlood(nIndex) * 100
		Prog_Blood:setPercent(pBlood)
		--空闲或者移动中的队伍血量发生变更弹出嗑药按钮
		local player = nil
		if nIndex == PlayerType.E_PlayerType_Main - 1 then
			player = m_TeamTab["MainGeneral"]
		elseif nIndex == PlayerType.E_PlayerType_1 - 1 then
			player = m_TeamTab["Teamer1"]
		elseif nIndex == PlayerType.E_PlayerType_2 - 1 then
			player = m_TeamTab["Teamer2"]
		elseif nIndex == PlayerType.E_PlayerType_3 - 1 then
			player = m_TeamTab["Teamer3"]
		else 
		end

		local pOldBlood = GetTeamCurBlood(nIndex)
		print("之前的血量为"..pOldBlood..",现在变为"..nValue)
		if tonumber(pOldBlood) > tonumber(nValue) then
			print("血量减少了")
		elseif tonumber(pOldBlood) < tonumber(nValue) then
			--print("血量增加了")
			ShowBloodAddTip( Image_Teamer, nValue - pOldBlood, Image_Teamer:getPositionX(), Image_Teamer:getPositionY() )
		end

		--print("队伍"..nIndex.."当前血量："..nValue..", 最大血量为: "..GetTeamMaxBlood(nIndex).."，当前的状态为："..player:GetState()..",UI状态为 = "..Image_Bg:getTag())

		SetTeamCurBlood(nIndex, nValue)						--更新血量数据源
		CountryWarRecoveryBloodLayer.UpdateBlood() 			--更新吃血瓶界面内的血量

		if player ~= nil and player:GetState() == PlayerState.E_PlayerState_Free or player:GetState() == PlayerState.E_PlayerState_Move then
			if tonumber(nValue) < GetTeamMaxBlood(nIndex) then
				if Image_Bg:getTag() == ShowReBloodType.Hide then
					--print("队伍"..nIndex.."可以调养了")
					Image_Bg:setTag(ShowReBloodType.Show)
					ShowRecoveryBlood( nIndex, 1 )			
				end
			elseif tonumber(nValue) >= GetTeamMaxBlood(nIndex) then
				if Image_Bg:getTag() == ShowReBloodType.Show then
					--print("队伍"..nIndex.."血量恢复完毕，完成调养了")
					Image_Bg:setTag(ShowReBloodType.Hide)
					ShowRecoveryBlood( nIndex, -1 )
				end
			end
		else
			--print("队伍"..nIndex.."进入禁止调养状态")
			if Image_Bg:getTag() == ShowReBloodType.Show then
				Image_Bg:setTag(ShowReBloodType.Hide)
				ShowRecoveryBlood( nIndex, -1 )
			end			
		end
	end

	--print("队伍"..nIndex.."UI状态为 = "..Image_Bg:getTag())

end

local function _Button_RecoveryBlood_CallBack( sender, eventType )
	local Image_Teamer 		= tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..sender:getTag() + 1), "ImageView")
	local Image_Bg          = tolua.cast(Image_Teamer:getChildByName("Image_Bg"), "ImageView")
	if Image_Bg:getTag() == ShowReBloodType.Hide then
		print("---hide---"..sender:getTag())
		return
	end
	if eventType == TouchEventType.ended then
		sender:setScale(1)
		print("Player "..sender:getTag().." 血量变化")
		CountryWarRecoveryBloodLayer.CreateCountryWarRecoveryBloodLayer( m_UILayer, sender:getTag() )
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1)
	end	
end

local function InitHead( nTab )
	print("初始化UI头像")
	for key,value in pairs(nTab) do
		local Image_Teamer = tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..key), "ImageView")
		Image_Teamer:setVisible(true)
		local Image_Bg       = tolua.cast(Image_Teamer:getChildByName("Image_Bg"), "ImageView") 
		Image_Bg:setTag(ShowReBloodType.Hide)
		local Image_Head     = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 
		local Image_BloodBg     = tolua.cast(Image_Teamer:getChildByName("Image_BloodBg"), "ImageView")
		local Image_StateBg  = tolua.cast(Image_Teamer:getChildByName("Image_StateBg"), "ImageView")
		local Labe_Level     = tolua.cast(Image_Teamer:getChildByName("Label_Level"), "Label")
		local Image_TypeBg   = tolua.cast(Image_Teamer:getChildByName("Image_TypeBg"), "ImageView")
		local Button_RecoveryBtn = tolua.cast(Image_Teamer:getChildByName("Button_RecoveryBtn"), "Button")
		Button_RecoveryBtn:setTag(key-1)
		local Prog_Blood 	 = tolua.cast(Image_BloodBg:getChildByName("ProgressBar_Blood"), "LoadingBar")
		local pSpriteHeadImg = tolua.cast(Image_Head:getVirtualRenderer(), "CCSprite")
		local nTeamerTab = nTab[key]
		if Image_Bg:getTag() == ShowReBloodType.Hide then
			Button_RecoveryBtn:setVisible(false)
		end
		Labe_Level:setText(string.format("%d", nTeamerTab.Level))

		if tonumber(key) == 1 then
			local nHeadPath = GetPathByImageID(tonumber(nTeamerTab.FaceID))
			Image_Head:loadTexture(nHeadPath)
		else
			local nTempId = nTeamerTab.nTempID
			local nHeadPath = GetGeneralHeadPath(nTempId)
			Image_Head:loadTexture(nHeadPath)
		end
		Image_Teamer:setTouchEnabled(true)
		Image_Teamer:setTag(nTeamerTab.Type)
		Image_Teamer:addTouchEventListener(FindTeamer)
		local pBloodPer = nTeamerTab.BloodCur / nTeamerTab.BloodMax * 100
		Prog_Blood:setPercent( pBloodPer )

		--是否显示调养
		UpdateTeamAttr(key-1, TEAM_ATTR.Blood, nTeamerTab.BloodCur)

		Button_RecoveryBtn:addTouchEventListener( _Button_RecoveryBlood_CallBack )

		--判断是否在坐牢
		if GetTeamCell(key-1) ~= -1 then
			SpriteSetGray(pSpriteHeadImg,1)
			m_TeamCellTime[key] = GetTeamCell(key-1)
			m_isCountTime = true
		else
			SpriteSetGray(pSpriteHeadImg,0)
		end
		--判断是否已过期
		if GetTeamLife(key-1) == true then
			if Image_Head:getChildByTag(99) == nil then
				local lifeImg = ImageView:create()
				lifeImg:setPosition(ccp(-8,-20))
				lifeImg:loadTexture("Image/imgres/corps/LifeEnd.png")
				Image_Head:addChild(lifeImg,1,99)
			end
		end
		--state text
		local str,color = JudgeStateStr(nTeamerTab.TeamState)
		local nStateLabel = CreateLabel(str, 24, color, CommonData.g_FONT1, ccp(0,0))
		Image_StateBg:addChild(nStateLabel,10,11)
		--判断是否有血战/坚守
		if tonumber(nTeamerTab.BloodTarCity) ~= -1 then
			m_isBlood = true
			m_TarCity = nTeamerTab.BloodTarCity
			table.insert(m_BDWJTab, key)
		end
		--type text
		local nTypeLabel = nil
		if nTeamerTab.Type == PlayerType.E_PlayerType_Main then
			nTypeLabel = CreateLabel("主", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
		elseif nTeamerTab.Type == PlayerType.E_PlayerType_1 then
			nTypeLabel = CreateLabel("1", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
		elseif nTeamerTab.Type == PlayerType.E_PlayerType_2 then
			nTypeLabel = CreateLabel("2", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
		elseif nTeamerTab.Type == PlayerType.E_PlayerType_3 then
			nTypeLabel = CreateLabel("3", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
		end
		Image_TypeBg:addChild(nTypeLabel,10,11)
	end

	--显示坚守或者血战的按钮
	local pBtnShow = tolua.cast(m_UILayer:getWidgetByName("Image_Show"), "ImageView")
	pBtnShow:addTouchEventListener(_Click_Show_CallBack)

	local showTitle = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT3, "", ccp(0, 0), COLOR_Black, ccc3(255,87,35), true, ccp(0, 0), 2)
	pBtnShow:addChild(showTitle,1,99)

	if m_isBlood == true then
		--当前有血战/坚守武将
		pBtnShow:setTouchEnabled(true)
		pBtnShow:setVisible(true)
		m_ActType = GetCurActType(m_TarCity)
		if m_ActType == PlayerState.E_PlayerState_BloodWar then
			LabelLayer.setText(showTitle, "血战中")	
		elseif m_ActType == PlayerState.E_PlayerState_Defense then
			LabelLayer.setText(showTitle, "坚守中")
		end
	else
		--当前无血战的武将
		pBtnShow:setTouchEnabled(false)
		pBtnShow:setVisible(false)
	end

end

function SetRoleState( nRoleID, nRoleStateID )
	local Image_Teamer = tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nRoleID), "ImageView")
	local Image_StateBg = tolua.cast(Image_Teamer:getChildByName("Image_StateBg"), "ImageView")

	if Image_StateBg:getChildByTag(11) ~= nil then
		if nRoleStateID == PlayerState.E_PlayerState_Free then
			Image_StateBg:getChildByTag(11):setText("空闲")
			Image_StateBg:getChildByTag(11):setColor(ccc3(5,166,8))
		elseif nRoleStateID == PlayerState.E_PlayerState_Rest then
			Image_StateBg:getChildByTag(11):setText("休息")
			Image_StateBg:getChildByTag(11):setColor(ccc3(5,166,8))
		elseif nRoleStateID == PlayerState.E_PlayerState_Move then
			Image_StateBg:getChildByTag(11):setText("移动")
			Image_StateBg:getChildByTag(11):setColor(ccc3(14,124,218))
		elseif nRoleStateID == PlayerState.E_PlayerState_CWar then
			Image_StateBg:getChildByTag(11):setText("国战")
			Image_StateBg:getChildByTag(11):setColor(ccc3(14,124,218))
		elseif nRoleStateID == PlayerState.E_PlayerState_Battle then
			Image_StateBg:getChildByTag(11):setText("上阵")
			Image_StateBg:getChildByTag(11):setColor(ccc3(226,55,9))
		elseif nRoleStateID == PlayerState.E_PlayerState_Solo then
			Image_StateBg:getChildByTag(11):setText("单挑")
			Image_StateBg:getChildByTag(11):setColor(ccc3(226,55,9))
		elseif nRoleStateID == PlayerState.E_PlayerState_Fight then
			Image_StateBg:getChildByTag(11):setText("战斗")
			Image_StateBg:getChildByTag(11):setColor(ccc3(226,55,9))	
		elseif nRoleStateID == PlayerState.E_PlayerState_Misty then
			Image_StateBg:getChildByTag(11):setText("迷雾战")
			Image_StateBg:getChildByTag(11):setColor(ccc3(226,55,9))
		elseif nRoleStateID == PlayerState.E_PlayerState_Cell then
			Image_StateBg:getChildByTag(11):setText("牢狱")
			Image_StateBg:getChildByTag(11):setColor(ccc3(226,55,9))
		end
	end
end

function AddChat(  )
	--添加聊天层
	ChatShowLayer.ShowChatlayer(m_UILayer)
end

function SetBtnBloodOrDefense( nState, nStr )
	local pBtnShow = tolua.cast(m_UILayer:getWidgetByName("Image_Show"), "ImageView")
	pBtnShow:setVisible(nState)
	pBtnShow:setTouchEnabled(nState)
	if nStr ~= nil then
		if pBtnShow:getChildByTag(99) ~= nil then
			LabelLayer.setText(pBtnShow:getChildByTag(99), nStr)
		end
	end
end

function DelTeamUIByOne( nIndex )
	local Image_Teamer 		= tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nIndex + 1), "ImageView")
	local Button_RecoveryBtn = tolua.cast(Image_Teamer:getChildByName("Button_RecoveryBtn"), "Button")
	local Image_Bg       = tolua.cast(Image_Teamer:getChildByName("Image_Bg"), "ImageView") 
	Image_Teamer:setVisible(false)
	Image_Teamer:setTouchEnabled(false)
	--Button_RecoveryBtn:setVisible(false)
	--Button_RecoveryBtn:setTouchEnabled(false)
	--坐标还原
	if Image_Bg:getTag() == ShowReBloodType.Show then
		Image_Teamer:setPositionY( Image_Teamer:getPositionY() - 50 )
	end
end

function UpdateTeamLifeUI( nIndex, nState )
	local Image_Teamer = tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nIndex+1), "ImageView")
	local Image_Head     = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 
	if nState == true then
		--续期了
		if Image_Head:getChildByTag(99) ~= nil then
			Image_Head:getChildByTag(99):removeFromParentAndCleanup(true)
		end
	else
		--到期了
		if Image_Head:getChildByTag(99) == nil then
			local lifeImg = ImageView:create()
			lifeImg:setPosition(ccp(-8,-20))
			lifeImg:loadTexture("Image/imgres/corps/LifeEnd.png")
			Image_Head:addChild(lifeImg,1,99)
		end
	end
end

function UpdateTeamUIByOne( nTab, bUpdateState )
	local Image_Teamer 	 = tolua.cast(m_UILayer:getWidgetByName("Image_Teamer"..nTab["TeamIndex"] + 1), "ImageView")
	local Image_Head     = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 
	local Image_BloodBg  = tolua.cast(Image_Teamer:getChildByName("Image_BloodBg"), "ImageView")
	local Image_StateBg  = tolua.cast(Image_Teamer:getChildByName("Image_StateBg"), "ImageView")
	local Labe_Level     = tolua.cast(Image_Teamer:getChildByName("Label_Level"), "Label")
	local Image_TypeBg   = tolua.cast(Image_Teamer:getChildByName("Image_TypeBg"), "ImageView")
	local Prog_Blood 	 = tolua.cast(Image_BloodBg:getChildByName("ProgressBar_Blood"), "LoadingBar")
	local pSpriteHeadImg = tolua.cast(Image_Head:getVirtualRenderer(), "CCSprite")
	local Label_CellTime     = tolua.cast(Image_Teamer:getChildByName("Label_CellTime"), "Label")
	local Image_Bg       = tolua.cast(Image_Teamer:getChildByName("Image_Bg"), "ImageView") 
	local Button_RecoveryBtn = tolua.cast(Image_Teamer:getChildByName("Button_RecoveryBtn"), "Button")
	Button_RecoveryBtn:setTag( nTab["TeamIndex"] )
	print("nTab[TeamIndex] = "..nTab["TeamIndex"])
	if bUpdateState == true then
		--如果是新增一个队伍，则设他的初值为false
		Image_Bg:setTag(ShowReBloodType.Hide)

		Button_RecoveryBtn:setVisible(false)
	end

	Button_RecoveryBtn:addTouchEventListener( _Button_RecoveryBlood_CallBack )

	Image_Teamer:setVisible(true)
	Image_Teamer:setTouchEnabled(true)
	--等级血条
	Labe_Level:setText(string.format("%d", nTab["Level"]))
	Prog_Blood:setPercent(tonumber(nTab["BloodCur"]) / tonumber(nTab["BloodMax"]) * 100)
	--头像
	if tonumber(nTab["TeamIndex"]) == 0 then
		local nHeadPath = GetPathByImageID(nTab["FaceID"])
		Image_Head:loadTexture(nHeadPath)
	else
		local nTempId = nTab["nTempID"]
		local nHeadPath = GetGeneralHeadPath(nTempId)
		Image_Head:loadTexture(nHeadPath)
	end
	Image_Teamer:setTag(nTab["Type"])
	Image_Teamer:addTouchEventListener(FindTeamer)

	--状态
	if Image_StateBg:getChildByTag(11) ~= nil then
		Image_StateBg:getChildByTag(11):removeFromParentAndCleanup(true)
	end
	local str,color = JudgeStateStr(nTab["TeamState"])
	local nStateLabel = CreateLabel(str, 24, color, CommonData.g_FONT1, ccp(0,0))
	Image_StateBg:addChild(nStateLabel,10,11)
	--标识
	if Image_TypeBg:getChildByTag(11) ~= nil then
		Image_TypeBg:getChildByTag(11):removeFromParentAndCleanup(true)
	end
	local nTypeLabel = nil
	if nTab["Type"] == PlayerType.E_PlayerType_Main then
		nTypeLabel = CreateLabel("主", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
	elseif nTab["Type"] == PlayerType.E_PlayerType_1 then
		nTypeLabel = CreateLabel("1", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
	elseif nTab["Type"] == PlayerType.E_PlayerType_2 then
		nTypeLabel = CreateLabel("2", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
	elseif nTab["Type"] == PlayerType.E_PlayerType_3 then
		nTypeLabel = CreateLabel("3", 24, COLOR_White, CommonData.g_FONT1, ccp(0,0))
	end
	Image_TypeBg:addChild(nTypeLabel,10,11)

	--坐牢了
	if tonumber(nTab["CellTime"]) ~= -1 then
		SpriteSetGray(pSpriteHeadImg,1)
		m_TeamCellTime[nTab["TeamIndex"] + 1] = nTab["CellTime"]
		m_isCountTime = true

		if m_isCountTime == true and  m_nHanderTime ~=  nil  then

			print("有人在牢房")

		else

			if m_nHanderTime ~= nil then
				m_UILayer:getScheduler():unscheduleScriptEntry(m_nHanderTime)
				m_nHanderTime = nil
			end

			m_nHanderTime = m_UILayer:getScheduler():scheduleScriptFunc(tick, 1, false)
			print("创建倒计时")
		end

	else
		m_TeamCellTime[nTab["TeamIndex"] + 1] = 0
		Label_CellTime:setVisible(false)
		SpriteSetGray(pSpriteHeadImg,0)
		printTab(m_TeamCellTime)
		--print("隐藏倒计时")
	end

	--雷达队伍刷新
	CountryWarRaderLayer.UpdateRaderTeamUI(nTab, 2)

end

function GetTarCityID( )
	if m_TarCity ~= nil then return m_TarCity end
end

function SetRedPointState( )
	if CommonData.g_CountryWarLayer == nil then
		return 
	end
	if m_UILayer == nil then
		return
	end
	if m_UILayer ~= nil then
		local pBtnDaily = tolua.cast(m_UILayer:getWidgetByName("Button_Event"), "Button")
		local pRedPoint = tolua.cast(pBtnDaily:getChildByName("Image_Point"), "ImageView")
		require "Script/serverDB/server_MissionPromptDB"
		local bShow = server_MissionPromptDB.GetRedPointStateByCWar()
		pRedPoint:setVisible(bShow) 
	end
end

function SetRewardPoint(  )
	if CommonData.g_CountryWarLayer == nil then
		return 
	end
	if m_UILayer == nil then
		return
	end
	if m_UILayer ~= nil then
		local pBtnTeam = tolua.cast(m_UILayer:getWidgetByName("Button_Reward"), "Button")
		require "Script/serverDB/server_RewardDB"
		local tab = server_RewardDB.GetCopyTable()
		if next(tab) ~= nil then
			local n_PointImg = ImageView:create()
			n_PointImg:loadTexture("Image/imgres/mission/redPoint.png")
			n_PointImg:setPosition(ccp(33,25))
			if pBtnTeam:getChildByTag(770) == nil then pBtnTeam:addChild(n_PointImg,10,770) end
			
		else
			if pBtnTeam:getChildByTag(770) ~= nil then 
				pBtnTeam:getChildByTag(770):removeFromParentAndCleanup(true) 
			end
		end
	end
end

function CreateCountryUILayer(CallBackTab, IdTab, TeamerTab)
	InitVars() 
	m_TabCallBack = {}
	m_MissionTab  = {}
	m_BDWJTab	  = {}
	m_TeamCellTime = {}
	m_isBlood     = false
	m_isCountTime = false
	if CallBackTab~=nil then
		m_TabCallBack = CallBackTab
	end

	m_UILayer = TouchGroup:create()								
    m_UILayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryWarUILayer.json"))
    --主城按钮
    local pBtnMainCityBg = tolua.cast(m_UILayer:getWidgetByName("Image_Bottom_5"), "ImageView")
    pBtnMainCityBg:setPosition(ccp(pBtnMainCityBg:getPositionX() - CommonData.g_Origin.x,pBtnMainCityBg:getPositionY() - CommonData.g_Origin.y))
    local pBtnMainCity = tolua.cast(m_UILayer:getWidgetByName("Button_MainCity"), "Button")
    pBtnMainCity:addTouchEventListener(_Click_MainCity_CallBack)
    pBtnMainCity:setEnabled(false)
    pBtnMainCityBg:setVisible(false)
    AddUIName(pBtnMainCityBg,"主城")
    --军队按钮
    local pBtnArmyCityBg = tolua.cast(m_UILayer:getWidgetByName("Image_Bottom_4"), "ImageView")
    pBtnArmyCityBg:setPosition(ccp(pBtnArmyCityBg:getPositionX() - CommonData.g_Origin.x,pBtnArmyCityBg:getPositionY() - CommonData.g_Origin.y))
    local pBtnArmy = tolua.cast(m_UILayer:getWidgetByName("Button_Army"), "Button")
    pBtnArmy:addTouchEventListener(_Click_Army_CallBack)
    pBtnArmyCityBg:setEnabled(false)
    AddUIName(pBtnArmyCityBg,"军队")
    --队伍按钮
    local pBtnTeamCityBg = tolua.cast(m_UILayer:getWidgetByName("Image_Bottom_1"), "ImageView")
    pBtnTeamCityBg:setPosition(ccp(pBtnTeamCityBg:getPositionX() + CommonData.g_Origin.x,pBtnTeamCityBg:getPositionY() - CommonData.g_Origin.y))
    local pBtnTeam = tolua.cast(m_UILayer:getWidgetByName("Button_Reward"), "Button")
    pBtnTeam:addTouchEventListener(_Click_Team_CallBack)
    AddUIName(pBtnTeamCityBg,"奖励")
    --事件按钮
    local pBtnEventCityBg = tolua.cast(m_UILayer:getWidgetByName("Image_Bottom_2"), "ImageView")
    pBtnEventCityBg:setPosition(ccp(pBtnEventCityBg:getPositionX() + CommonData.g_Origin.x,pBtnEventCityBg:getPositionY() - CommonData.g_Origin.y))
    local pBtnEvent = tolua.cast(m_UILayer:getWidgetByName("Button_Event"), "Button")
    pBtnEvent:addTouchEventListener(_Click_Event_CallBack)
    AddUIName(pBtnEventCityBg,"任务")
    --灵兽按钮
    local pBtnAnimalCityBg = tolua.cast(m_UILayer:getWidgetByName("Image_Bottom_3"), "ImageView")
    pBtnAnimalCityBg:setPosition(ccp(pBtnAnimalCityBg:getPositionX() + CommonData.g_Origin.x,pBtnAnimalCityBg:getPositionY() - CommonData.g_Origin.y))
    local pBtnAnimal = tolua.cast(m_UILayer:getWidgetByName("Button_Animal"), "Button")
    pBtnAnimal:addTouchEventListener(_Click_Animal_CallBack)
    AddUIName(pBtnAnimalCityBg,"灵兽")
    --雷达按钮响应
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
	local m_RadarAni = CCArmature:create("Scene_guozhan_leida01")
	m_RadarAni:getAnimation():play("Animation1")
	m_RadarAni:setPosition(ccp(0,0))

	local pRadarClick = tolua.cast(m_UILayer:getWidgetByName("Button_Radar"), "Button")
	pRadarClick:setPosition(ccp(pRadarClick:getPositionX() - CommonData.g_Origin.x,pRadarClick:getPositionY() - CommonData.g_Origin.y))
	pRadarClick:setSize(CCSizeMake(m_RadarAni:getContentSize().width,m_RadarAni:getContentSize().height))
	pRadarClick:addNode(m_RadarAni,1,99)
	pRadarClick:addTouchEventListener(_Click_Rader_CallBack)

	--国家标志
	local nCountryBg = ImageView:create()
	nCountryBg:loadTexture("Image/imgres/countrywar/countryBg.png")
	nCountryBg:setPosition(ccp(50,-50))
	pRadarClick:addChild(nCountryBg)

	local nCamp = GetPlayerCountry()
	local nCountryLabel = nil
	if nCamp == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
		nCountryLabel = CreateLabel("魏", 26, ccc3(27,150,255), CommonData.g_FONT1, ccp(0,0))
	elseif nCamp == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
		nCountryLabel = CreateLabel("蜀", 26, ccc3(236,53,4), CommonData.g_FONT1, ccp(0,0))
	elseif nCamp == COUNTRY_TYPE.COUNTRY_TYPE_WU then
		nCountryLabel = CreateLabel("吴", 26, ccc3(3,209,5), CommonData.g_FONT1, ccp(0,0))
	else
		nCountryLabel = CreateLabel("魏", 26, ccc3(27,150,255), CommonData.g_FONT1, ccp(0,0))
	end

	nCountryBg:addChild(nCountryLabel)

	m_TeamTab = TeamerTab

	--初始化队列头像
	InitHead(IdTab)

	--如果正在血战/坚守中直接创建layer
	if m_isBlood == true and m_TarCity ~= nil then
		local nChildLayer = CountryChildLayer.CreateCountryChildLayer(m_ActType, GetCityNameByIndex(GetIndexByCTag(m_TarCity)), m_TarCity, true, m_BDWJTab)
		nChildLayer:setVisible(false)
		nChildLayer:setTouchEnabled(false)
		nChildLayer:setPositionX(nChildLayer:getPositionX() - 10000)
		if nChildLayer ~= nil then
			m_UILayer:addChild(nChildLayer,1001,1990)
		end
	end

	if m_isCountTime == true then

		if m_nHanderTime ~= nil then
			m_UILayer:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
		end

		m_nHanderTime = m_UILayer:getScheduler():scheduleScriptFunc(tick, 1, false)

	end

	SetRedPointState()
	SetRewardPoint()
    return m_UILayer
end

