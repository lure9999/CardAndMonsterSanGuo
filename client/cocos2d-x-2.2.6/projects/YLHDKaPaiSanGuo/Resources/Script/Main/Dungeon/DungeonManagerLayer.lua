require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Dungeon/DungeonLayer"
require "Script/Main/Dungeon/DungeonLogic"
require "Script/Main/Dungeon/EliteDungeonLayer"
require "Script/Main/Dungeon/ActivityLayer"
require "Script/serverDB/server_mainDB"

module("DungeonManagerLayer", package.seeall)

local m_pLayerDungeonManager = nil
local m_pLayerDungeon = nil
local m_pLayerNormal = nil
local m_pLayerElite = nil
local m_pLayerActivity = nil

local m_chbNormal = nil
local m_chbElite = nil
local m_chbActivity = nil
local m_chbCur = nil
local m_pImgSelect = nil
local m_GotoSceneIndex = nil

local CreateStrokeLabel			= LabelLayer.createStrokeLabel
local SetStrokeLabelText		= LabelLayer.setText

local GetMainDataByKey			= server_mainDB.getMainData

local GetOpenActivityRule		= DungeonLogic.GetOpenActivityRule
local CheckEliteOpen			= DungeonLogic.CheckEliteOpen

local function InitVars()
	m_pLayerDungeonManager = nil
	m_pLayerDungeon = nil
	m_pLayerNormal = nil
	m_pLayerElite = nil
	m_pLayerActivity = nil
	m_chbNormal = nil
	m_chbElite = nil
	m_chbActivity = nil
	m_chbCur = nil
	m_pImgSelect = nil
	m_GotoSceneIndex = nil
	MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_DUNGEON)
end

local function HandleLyaerVisible( pLayerShow, pLayerHide1, pLayerHide2 )
	if pLayerShow~=nil then
		pLayerShow:setVisible(true)
		pLayerShow:setEnabled(true)
	end

	if pLayerHide1~=nil then
		pLayerHide1:setVisible(false)
		pLayerHide1:setEnabled(false)
	end

	if pLayerHide2~=nil then
		pLayerHide2:setVisible(false)
		pLayerHide2:setEnabled(false)
	end
end

local function ChangeDungeonByType( pCurCheckBox )
	m_pImgSelect:setPosition(ccp(pCurCheckBox:getPositionX(), pCurCheckBox:getPositionY()))
	if pCurCheckBox:getTag()==m_chbNormal:getTag() then
		if m_pLayerNormal==nil  then
			m_pLayerNormal = DungeonLayer.CreateDungeonLayer()
			m_pLayerDungeon:addChild(m_pLayerNormal)
		else
			HandleLyaerVisible( m_pLayerNormal, m_pLayerElite, m_pLayerActivity)
		end

	elseif pCurCheckBox:getTag()==m_chbElite:getTag() then
		if m_pLayerElite==nil  then
			m_pLayerElite = EliteDungeonLayer.CreateEliteDungeonLayer()
			m_pLayerDungeon:addChild(m_pLayerElite)
		else
			HandleLyaerVisible( m_pLayerElite, m_pLayerActivity, m_pLayerNormal)
		end
	elseif pCurCheckBox:getTag()==m_chbActivity:getTag() then
		if m_pLayerActivity==nil  then	
			m_pLayerActivity = ActivityLayer.CreateActivityLayer()
			m_pLayerDungeon:addChild(m_pLayerActivity)
		else
			HandleLyaerVisible( m_pLayerActivity, m_pLayerElite, m_pLayerNormal)
		end
	end
end


local function _CheckBox_DungeonManager_CallBack(sender, eventType)
	-- 获取当前点击的CheckBox
	AudioUtil.PlayBtnClick()
	local pCurCheckBox = tolua.cast(sender,"CheckBox")
	if eventType == CheckBoxEventType.selected then
		if m_chbCur~=pCurCheckBox then
			m_chbCur:setSelectedState(false)
			m_chbCur = pCurCheckBox
			ChangeDungeonByType(m_chbCur)
		end
	else
		if pCurCheckBox:getSelectedState() == false then
			pCurCheckBox:setSelectedState(true)
			if m_chbCur==nil then
				m_chbCur = pCurCheckBox
				ChangeDungeonByType(m_chbCur)
			end
		end
	end
end

function UpdateBaseData(  )
	--[[local pImgGold = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Image_Gold"), "ImageView")
	local nGold = GetMainDataByKey("gold")
    if pImgGold:getChildByTag(1000) ~= nil then
		SetStrokeLabelText(pImgGold:getChildByTag(1000), nGold)
    else
		local pLabelGold = CreateStrokeLabel(20, "微软雅黑", tostring(nGold), ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	pImgGold:addChild(pLabelGold,  0, 1000)
    end

    local pImgSilver = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Image_Sliver"), "ImageView")
    local nSilver = GetMainDataByKey("silver")
    if pImgSilver:getChildByTag(1000) ~= nil then
		SetStrokeLabelText(pImgSilver:getChildByTag(1000), nSilver)
    else
		local pLabelSliver = CreateStrokeLabel(20, "微软雅黑", tostring(nSilver), ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	pImgSilver:addChild(pLabelSliver, 0, 1000)
    end

    local pImgTili = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Image_Tili"), "ImageView")
    local nTili = GetMainDataByKey("tili")
    local nMaxTili = GetMainDataByKey("max_tili")
    if pImgTili:getChildByTag(1000) ~= nil then
		SetStrokeLabelText(pImgTili:getChildByTag(1000), tostring(nTili).."/"..tostring(nMaxTili))
    else
		local pLabelTili = CreateStrokeLabel(20, "微软雅黑", tostring(nTili).."/"..tostring(nMaxTili), ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	pImgTili:addChild(pLabelTili, 0, 1000)
    end

    local pImgNaili = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Image_Naili"), "ImageView")
    local nNaili = GetMainDataByKey("naili")
     local nMaxNaili = GetMainDataByKey("max_naili")
    if pImgNaili:getChildByTag(1000) ~= nil then
		SetStrokeLabelText(pImgNaili:getChildByTag(1000), tostring(nNaili).."/"..tostring(nMaxNaili))
    else
		local pLabelTili = CreateStrokeLabel(20, "微软雅黑", tostring(nNaili).."/"..tostring(nMaxNaili), ccp(-40, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
	  	pImgNaili:addChild(pLabelTili, 0, 1000)
    end

    local pImgBattleEffect = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Image_BattleEffect"), "ImageView")
    local nPower = GetMainDataByKey("power")
    if pImgBattleEffect:getChildByTag(1000) ~= nil then
    	local nTemp = tolua.cast(pImgBattleEffect:getChildByTag(1000), "LabelBMFont")
		nTemp:setText(nPower)
    else
		local pText = LabelBMFont:create()
		pText:setText(nPower)
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-10,-20))
		pText:setAnchorPoint(ccp(0,0.5))
		pImgBattleEffect:addChild(pText,0,1000)
    end]]
end

local function _Btn_Back_DungeonManager_CallBack( )
	-- if m_pLayerNormal~=nil then
	-- 	print("m_pLayerNormal.ClearLayer()")
	-- 	DungeonLayer.ClearLayer()
	-- end
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Copy)
	m_pLayerDungeonManager:removeFromParentAndCleanup(true)
	InitVars()
	MainScene.PopUILayer()
end

local function ChangeLayerByType( nType )
	if nType==DungeonsType.Normal then
		_CheckBox_DungeonManager_CallBack(m_chbNormal, CheckBoxEventType.unselected)
	elseif nType==DungeonsType.Elite then
		_CheckBox_DungeonManager_CallBack(m_chbElite, CheckBoxEventType.unselected)
	elseif nType==DungeonsType.Activity then
		_CheckBox_DungeonManager_CallBack(m_chbActivity, CheckBoxEventType.unselected)
	end
end

local function InsertTipBtn( pSender )
	local function _Click_Tip_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			if pSender == m_chbElite then
				if CheckEliteOpen(true) == false then
					m_chbElite:setSelectedState(false)
					local pchbEliteSp = tolua.cast(m_chbElite:getVirtualRenderer(), "CCSprite")
					SpriteSetGray(pchbEliteSp, 1)
					return
				end
			elseif pSender == m_chbActivity then
				if server_mainDB.getMainData("level") < GetOpenActivityRule() then
					m_chbActivity:setSelectedState(false)
					local pchbActivitySp = tolua.cast(m_chbActivity:getVirtualRenderer(), "CCSprite")
					SpriteSetGray(pchbActivitySp, 1)
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1658,nil,GetOpenActivityRule())
					pTips = nil	
					return
				end
			end
		end
	end

	local Btn_Node = Widget:create()
	Btn_Node:setEnabled(true)
	Btn_Node:setTouchEnabled(true)
	Btn_Node:ignoreContentAdaptWithSize(false)
    Btn_Node:setSize(CCSize(165, 144))
    if pSender == m_chbElite then
		Btn_Node:setTag(1777)
	elseif pSender == m_chbActivity then
		Btn_Node:setTag(1778)
	end
	Btn_Node:addTouchEventListener(_Click_Tip_CallBack)
	Btn_Node:setPosition(ccp(pSender:getPositionX(),pSender:getPositionY()))
	Btn_Node:setVisible(false)
	m_pLayerDungeon:addChild(Btn_Node,1300)

end

function UpdateCheckBox(  )
	--精灵副本
	if m_chbElite == nil then
		print("m_chbElite is nil")
		return false
	else
		local pchbEliteSp = tolua.cast(m_chbElite:getVirtualRenderer(), "CCSprite")
		--判断条件是否打开此栏
		if CheckEliteOpen() == false then
			SpriteSetGray(pchbEliteSp, 1)
			m_chbElite:setTouchEnabled(false)
			InsertTipBtn( m_chbElite )
		else
			SpriteSetGray(pchbEliteSp, 0)
			m_chbElite:addEventListenerCheckBox(_CheckBox_DungeonManager_CallBack)
			m_chbElite:setTouchEnabled(true)
			if m_pLayerDungeon:getChildByTag(1777) ~= nil then
				m_pLayerDungeon:getChildByTag(1777):removeFromParentAndCleanup(true)
			end	
		end
	end
	--活动副本
	if m_chbActivity == nil then
		print("m_chbActivity is nil")
		return false
	else
		local pchbActivitySp = tolua.cast(m_chbActivity:getVirtualRenderer(), "CCSprite")
		--判断等级是否打开此栏
		if server_mainDB.getMainData("level") < GetOpenActivityRule() then
			SpriteSetGray(pchbActivitySp, 1)
			m_chbActivity:setTouchEnabled(false)
			InsertTipBtn( m_chbActivity )
		else
			SpriteSetGray(pchbActivitySp, 0)
			m_chbActivity:addEventListenerCheckBox(_CheckBox_DungeonManager_CallBack)
			m_chbActivity:setTouchEnabled(true)
			if m_pLayerDungeon:getChildByTag(1778) ~= nil then
				m_pLayerDungeon:getChildByTag(1778):removeFromParentAndCleanup(true)
			end	
		end
	end
end

local function InitWidgets( )
	m_pLayerDungeonManager = TouchGroup:create()
	m_pLayerDungeonManager:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/DungeonManagerLayer.json"))

	m_pLayerDungeon = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Panel_Dungeon"), "Layout")
	if m_pLayerDungeon == nil then
		print("m_pLayerDungeon is nil")
		return false
	end

	local pBtnBack = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Button_Close"),"Button")
	if pBtnBack==nil then
		print("pBtnBack is nil")
		return false
	else
		pBtnBack:setPosition(ccp(pBtnBack:getPositionX() + CommonData.g_Origin.x,pBtnBack:getPositionY() - CommonData.g_Origin.y))
		CreateBtnCallBack(pBtnBack, nil, nil, _Btn_Back_DungeonManager_CallBack)
	end

	--[[local Panel_BaseData = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Panel_BaseData"), "Layout")
	if Panel_BaseData == nil then
		print("Panel_BaseData is nil")
		return false
	else
		Panel_BaseData:setPosition(ccp(Panel_BaseData:getPositionX() - CommonData.g_Origin.x,Panel_BaseData:getPositionY() - CommonData.g_Origin.y))
	end]]

	--普通单选框
	m_chbNormal = tolua.cast(m_pLayerDungeonManager:getWidgetByName("CheckBox_World"), "CheckBox")
	if m_chbNormal == nil then
		print("m_chbNormal is nil")
		return false
	else
		m_chbNormal:addEventListenerCheckBox(_CheckBox_DungeonManager_CallBack)
	end

	--精英单选框
	m_chbElite = tolua.cast(m_pLayerDungeonManager:getWidgetByName("CheckBox_Elite"), "CheckBox")
	if m_chbElite == nil then
		print("m_chbElite is nil")
		return false
	else
		local pchbEliteSp = tolua.cast(m_chbElite:getVirtualRenderer(), "CCSprite")
		--判断条件是否打开此栏
		if CheckEliteOpen() == false then
			SpriteSetGray(pchbEliteSp, 1)
			m_chbElite:setTouchEnabled(false)
			InsertTipBtn( m_chbElite )
		else
			SpriteSetGray(pchbEliteSp, 0)
			m_chbElite:addEventListenerCheckBox(_CheckBox_DungeonManager_CallBack)
			m_chbElite:setTouchEnabled(true)
			if m_pLayerDungeon:getChildByTag(1777) ~= nil then
				m_pLayerDungeon:getChildByTag(1777):removeFromParentAndCleanup(true)
			end	
		end
	end

	--活动单选框
	m_chbActivity = tolua.cast(m_pLayerDungeonManager:getWidgetByName("CheckBox_Activity"), "CheckBox")
	if m_chbActivity == nil then
		print("m_chbActivity is nil")
		return false
	else
		local pchbActivitySp = tolua.cast(m_chbActivity:getVirtualRenderer(), "CCSprite")
		--判断等级是否打开此栏
		if server_mainDB.getMainData("level") < GetOpenActivityRule() then
			SpriteSetGray(pchbActivitySp, 1)
			m_chbActivity:setTouchEnabled(false)
			InsertTipBtn( m_chbActivity )
		else
			SpriteSetGray(pchbActivitySp, 0)
			m_chbActivity:addEventListenerCheckBox(_CheckBox_DungeonManager_CallBack)
			m_chbActivity:setTouchEnabled(true)
			if m_pLayerDungeon:getChildByTag(1778) ~= nil then
				m_pLayerDungeon:getChildByTag(1778):removeFromParentAndCleanup(true)
			end	
		end
	end

	m_pImgSelect = tolua.cast(m_pLayerDungeonManager:getWidgetByName("Image_Select"), "ImageView")
	if m_pImgSelect == nil then
		print("m_pImgSelect is nil")
		return false
	end

	return true
end

function GotoManagerCallFuncByType( nType, nCmd_1, nCmd_2 )
	if nType == DungeonsType.Normal then
		if nCmd_1 ~= nil and nCmd_2 ~= nil then DungeonLayer.GoToManagerCallFuncByNormal(nCmd_1, nCmd_2) end	
	elseif nType == DungeonsType.Elite then
		if nCmd_1 ~= nil then EliteDungeonLayer.GoToManagerCallFuncByElite( nCmd_1 ) end
	elseif nType == DungeonsType.Activity then
		if nCmd_1 ~= nil and nCmd_2 ~= nil then ActivityLayer.GoToManagerCallFuncByActivity(nCmd_1, nCmd_2) end 
	end
end

function ReturnDungeon(  )
	if m_pLayerDungeonManager ~= nil then
		local pBarManager = MainScene.GetBarManager()
		pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Copy)
		m_pLayerDungeonManager:removeFromParentAndCleanup(true)
		InitVars()
		MainScene.PopUILayer()
	end
end

function CreateDungeonManagerLayer( nType )
	InitVars( )
	if InitWidgets()==false then
		return
	end

	UpdateBaseData()
	ChangeLayerByType( nType )
	-- _CheckBox_DungeonManager_CallBack(m_chbNormal, CheckBoxEventType.unselected)
	--注册监听
	--MainScene.GetObserver():RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_DUNGEON,UpdateBaseData)
	--将主界面按钮重新加载一次
    local temp = MainBtnLayer.createMainBtnLayer()
    m_pLayerDungeonManager:addChild(temp, layerMainBtn_Tag, layerMainBtn_Tag)

    --添加货币栏
	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		pBarManager:Create(m_pLayerDungeonManager,CoinInfoBarManager.EnumLayerType.EnumLayerType_Copy)
	end

	return m_pLayerDungeonManager
end

function GetUIControl(  )
	return m_pLayerDungeonManager
end