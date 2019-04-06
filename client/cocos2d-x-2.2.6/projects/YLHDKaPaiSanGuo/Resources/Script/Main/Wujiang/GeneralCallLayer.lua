require "Script/Common/Common"
require "Script/Main/Wujiang/HeroArmatureLayer"

module("GeneralCallLayer", package.seeall)

local m_pLayerGnenralCall = nil
local m_funcCallBack = nil
local m_nType = nil
local m_nPos = nil

local GetItemGridByTempID							= server_itemDB.GetGird
local GetNumByTempID								= ItemData.GetNumByTempID
local GetItemEventParaA								= ItemData.GetItemEventParaA
local GetItemEventParaB								= ItemData.GetItemEventParaB --武将ID
local GetItemEventParaC								= ItemData.GetItemEventParaC --消耗银币
local GetGeneralColorIcon							= GeneralBaseData.GetGeneralColorIcon
local GetGeneralHeadIcon 							= GeneralBaseData.GetGeneralHeadIcon
local GetArrowPath									= GeneralBaseData.GetArrowPath
local GetGeneralNameByTempId						= GeneralBaseData.GetGeneralNameByTempId
local getMainDataByKey 								= server_mainDB.getMainData
local createStrokeLabel 							= LabelLayer.createStrokeLabel
local CreateTipLayerManager								= TipCommonLayer.CreateTipLayerManager
local function InitVars(  )
	m_pLayerGnenralCall = nil
	m_funcCallBack = nil
	m_nType = nil
	m_nPos = nil
end

local function _BtnClose_CallBack(  )
	m_pLayerGnenralCall:removeFromParentAndCleanup(true)
	InitVars()
end

local function _BtnConfrim_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		local nItemId = sender:getTag()
		if getMainDataByKey("silver") < GetItemEventParaC(nItemId) then
			--CreateTipsLayer(1003, TIPS_TYPE.TIPS_TYPE_NONE, nil, nil)
			local pTip = CreateTipLayerManager()
			pTip:ShowCommonTips(1003,nil)
			pTip = nil
			return
		end
		local function CallOver()
			NetWorkLoadingLayer.loadingHideNow()
			local pHeroArmature = HeroArmatureLayer.CreateHeroArmaLayer(GetItemEventParaB(nItemId), 2, m_nType, m_nPos, m_funcCallBack)
			local pRunningScene = CCDirector:sharedDirector():getRunningScene()
			pRunningScene:addChild(pHeroArmature, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
			m_pLayerGnenralCall:removeFromParentAndCleanup(true)
			InitVars()
		end
		Packet_UseItem.SetSuccessCallBack(CallOver)
		network.NetWorkEvent(Packet_UseItem.CreatPacket(GetItemGridByTempID(nItemId), 1, nItemId))
		NetWorkLoadingLayer.loadingShow(true)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif  eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function UpdateCallData( nItemId )
	local pImageItem = tolua.cast(m_pLayerGnenralCall:getWidgetByName("Image_10"), "ImageView")
	local pControl = UIInterface.MakeHeadIcon(pImageItem, ICONTYPE.ITEM_ICON, nItemId, nil)

	local nGeneralId = GetItemEventParaB(nItemId)
	local pImageColor = tolua.cast(m_pLayerGnenralCall:getWidgetByName("Image_Head"), "ImageView")
	pImageColor:loadTexture(GetGeneralColorIcon(nGeneralId))

	local pImageIcon = tolua.cast(m_pLayerGnenralCall:getWidgetByName("Image_13"), "ImageView")
	pImageIcon:loadTexture(GetGeneralHeadIcon(nGeneralId))

	local pImageArrow = tolua.cast(m_pLayerGnenralCall:getWidgetByName("Image_Arrow"), "ImageView")
	pImageArrow:loadTexture(GetArrowPath(nGeneralId))

	local  pLabelCost = createStrokeLabel(22, "default", tostring(GetItemEventParaC(nItemId)), ccp(600, 260), ccc3(81, 113, 39),  ccc3(0, 255, 79), false, ccp(0, -2), 2)
	m_pLayerGnenralCall:addChild(pLabelCost)

	local pLabelNum = createStrokeLabel(18, "default", tostring(GetNumByTempID(nItemId)).."/"..tostring(GetItemEventParaA(nItemId)), ccp(438, 320), ccc3(81, 113, 39),  ccc3(0, 255, 79), true, ccp(0, -2), 2)
	m_pLayerGnenralCall:addChild(pLabelNum)

	local pLabelName = tolua.cast(m_pLayerGnenralCall:getWidgetByName("Label_Name"), "Label")
	pLabelName:setText(GetGeneralNameByTempId(nGeneralId))

	if getMainDataByKey("silver") < GetItemEventParaC(nItemId) then
		LabelLayer.setColor(pLabelCost, COLOR_Red)
	else
		LabelLayer.setColor(pLabelCost, COLOR_Green)
	end
end

local function InitWidgets( nItemId )
	m_pLayerGnenralCall = TouchGroup:create()
	m_pLayerGnenralCall:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangCallLayer.json" ) )

	local pBtnClose = tolua.cast(m_pLayerGnenralCall:getWidgetByName("Button_Close"), "Button")
	if pBtnClose==nil then
		print("pBtnClose is nil")
		return false
	else
		CreateBtnCallBack(pBtnClose, nil, nil, _BtnClose_CallBack)
	end

	local pBtnConfrim = tolua.cast(m_pLayerGnenralCall:getWidgetByName("Button_Confrim"), "Button")
	if pBtnConfrim==nil then
		print("pBtnConfrim is nil")
		return false
	else
		pBtnConfrim:setTag(nItemId)
		local pLabel = createStrokeLabel(36, CommonData.g_FONT1, "确认", ccp(0, 0), COLOR_Black,  COLOR_White, true, ccp(0, -2), 2)
		pBtnConfrim:addChild(pLabel)
		pBtnConfrim:addTouchEventListener(_BtnConfrim_CallBack)
	end

	local pLabelTitle = createStrokeLabel(26, CommonData.g_FONT1, "召唤武将", ccp(570, 490), COLOR_Black,  ccc3(239, 193, 55), true, ccp(0, -2), 2)
	m_pLayerGnenralCall:addChild(pLabelTitle)

	return true
end

function CreateGeneralCallLayer( nItemId, nType, nPos, funcCallBack )
	if InitWidgets(nItemId)==false then
		print("InitWidgets Failed...")
		return
	end
	if funcCallBack~= nil then
		m_funcCallBack = funcCallBack
	end
	m_nType = nType
	m_nPos = nPos
	UpdateCallData(nItemId)
	return m_pLayerGnenralCall
end