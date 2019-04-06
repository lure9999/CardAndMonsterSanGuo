require "Script/Common/ConsumeLogic"

module("PataRefreshFightLayer", package.seeall)

local GetRefreshFightConsID 				=	PataData.GetRefreshFightConsID
local GetRefreshFightBuffPercent 			=	PataData.GetRefreshFightBuffPercent

local GetExpendData							=	ConsumeLogic.GetExpendData
local GetConsumeTypeName					=	ConsumeLogic.GetConsumeTypeName

local GetConsumeItemIconByType				=	PataLogic.GetConsumeItemIconByType
local IsEnoughConsumeID 					=	PataLogic.IsEnoughConsumeID

local StrokeLabel_createStrokeLabel 		= LabelLayer.createStrokeLabel 

local m_RefreshLayer = nil
local m_CurType 	 = nil
local m_ChooseUI 	 = nil
local m_CurSceneID   = nil
local m_CurPointIdx  = nil

local BuffType = {
	BuffType_Attack 		=	1,
	BuffType_Blood 			=	2,
	BuffType_None 			=	3,
}

local function InitVars(  )
	m_RefreshLayer = nil
 	m_CurType 	   = nil
 	m_ChooseUI 	   = nil
	m_CurSceneID   = nil
	m_CurPointIdx  = nil
end

local function _Click_Choose_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		m_ChooseUI:setScale(1.0)
		if m_CurType == sender:getTag() then
			return
		end
		m_CurType = sender:getTag()
		print("m_CurType = "..m_CurType)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
		m_ChooseUI:setScale(0.9)
		local pItem = tolua.cast(m_RefreshLayer:getWidgetByName("Image_Buff_"..sender:getTag()), "ImageView")
		m_ChooseUI:setPosition(ccp( pItem:getPositionX() - 2, pItem:getPositionY() + 2 ))	
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
		m_ChooseUI:setScale(1.0)
	end
end

local function _Click_Start_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		local pConsID  = GetRefreshFightConsID( m_CurType )

		local nConsumeTab = GetExpendData( pConsID )

		if nConsumeTab["TabData"][1]["Enough"] == false then

			local pName = GetConsumeTypeName(nConsumeTab["TabData"][1]["ConsumeType"])
			TipLayer.createTimeLayer(pName.."不足",2)

			return
		end

		--请求带属性战斗
		PataLayer.PataBattleBegin()

		local function HandleAttrBattleBegin( nErrorID )
			if nErrorID ~= nil then
				print("nErrorID = "..nErrorID)
			end
			if m_RefreshLayer ~= nil then
				m_RefreshLayer:removeFromParentAndCleanup(true)
			end
			InitVars()
		end

		Packet_BattleBeginByAttr.SetSuccessCallBack(HandleAttrBattleBegin)
		network.NetWorkEvent(Packet_BattleBeginByAttr.CreatPacket(m_CurSceneID, m_CurPointIdx, m_CurType-1))
		NetWorkLoadingLayer.loadingShow(true)

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Close_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		if m_RefreshLayer ~= nil then
			m_RefreshLayer:removeFromParentAndCleanup(true)
		end
		InitVars()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitBuffItem( nItem, nIndex )

	local pConsID  = GetRefreshFightConsID( nIndex )

	local nConsumeTab = GetExpendData( pConsID )

	local nConsumeType = tonumber(nConsumeTab["TabData"][1]["ConsumeType"])

	local nConsumePath = GetConsumeItemIconByType( nConsumeType )

	local pConsImg = tolua.cast(nItem:getChildByName("Image_Cons"), "ImageView")

	pConsImg:loadTexture( nConsumePath )

	local pConsNum = nConsumeTab["TabData"][1]["ItemNeedNum"]

	local pConsLabel = tolua.cast(nItem:getChildByName("Label_Cons"), "Label")
	pConsLabel:setText( "消耗 : "..pConsNum )

	--Buff显示

	if nIndex <= 2 then

		if nIndex == 2 then
			local pAttrLabel = tolua.cast(nItem:getChildByName("Label_Attr"), "Label")
			pAttrLabel:setText("生命 :")
		end
		
		local pBuffPer = tonumber(GetRefreshFightBuffPercent( nIndex )) / 10
		--加成数量
		local pBuffText = LabelBMFont:create()
		pBuffText:setFntFile("Image/imgres/common/num/limitNum.fnt")
		pBuffText:setPosition(ccp(-5,-67))
		pBuffText:setAnchorPoint(ccp(0,0.5))
		pBuffText:setText(pBuffPer)
		nItem:addChild(pBuffText,0,1000)

		local pPercSp = CCSprite:create("Image/imgres/pata/UI/percent.png")
		pPercSp:setAnchorPoint(ccp(0, 0.5))
		pPercSp:setPosition(ccp(pBuffText:getPositionX() + pBuffText:getSize().width , pBuffText:getPositionY()))
		nItem:addNode(pPercSp)

		local pUpSp = CCSprite:create("Image/imgres/common/arrow_up.png")
		pUpSp:setAnchorPoint(ccp(0, 0.5))
		pUpSp:setPosition(ccp(pBuffText:getPositionX() + pBuffText:getSize().width + 25 , pBuffText:getPositionY()))
		nItem:addNode(pUpSp)

	end
end

local function Init(  )
	if m_RefreshLayer == nil then
		return
	end
	for i=1,3 do
		local pItem = tolua.cast(m_RefreshLayer:getWidgetByName("Image_Buff_"..i), "ImageView")
		pItem:setTouchEnabled(true)
		pItem:setTag(i)
		pItem:addTouchEventListener(_Click_Choose_CallBack)
		InitBuffItem(pItem, i)
	end

	m_ChooseUI = tolua.cast(m_RefreshLayer:getWidgetByName("Image_Choose"), "ImageView")
	m_ChooseUI:setTouchEnabled(false)

	local Btn_Ok = tolua.cast(m_RefreshLayer:getWidgetByName("Button_Ok"), "Button")
	Btn_Ok:addTouchEventListener(_Click_Start_CallBack)

	local Btn_Close = tolua.cast(m_RefreshLayer:getWidgetByName("Button_Close"), "Button")
	Btn_Close:addTouchEventListener(_Click_Close_CallBack)

	local StrokeLabel_Reset= StrokeLabel_createStrokeLabel(36, CommonData.g_FONT1, "重新挑战", ccp(0, 4), COLOR_Black, COLOR_White, true, ccp(0, 0), 3)
	Btn_Ok:addChild(StrokeLabel_Reset)

	local Image_Mid = tolua.cast(m_RefreshLayer:getWidgetByName("Image_Mid"), "ImageView")
	
	local StrokeLabel_Ttile = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT3, "选择加成", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
	Image_Mid:addChild(StrokeLabel_Ttile)
end

function CreateRefreshFightLayer( nSceneID, nPointIdx )
	m_RefreshLayer = TouchGroup:create()
	m_RefreshLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/PataRefreshFightLayer.json" ) )

	m_CurSceneID = nSceneID

	m_CurPointIdx = nPointIdx

	m_CurType = BuffType.BuffType_Attack

	Init()

	return m_RefreshLayer
end
