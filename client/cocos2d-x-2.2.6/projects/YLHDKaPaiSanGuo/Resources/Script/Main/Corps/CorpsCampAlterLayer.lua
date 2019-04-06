--FileName:CorpsCampAlterLayer
--Author:sixuechao
--Purpose:军团设置中修改旗帜标志
--

module("CorpsCampAlterLayer",package.seeall)
require "Script/Main/Corps/CorpsLogic"

local CampAlterLayer 		= nil
local CampWeiqi 			= nil
local CampShuqi 			= nil
local CampWuqi 				= nil
local CampWeiLimit 			= nil
local CampShuLimit 			= nil
local CampWuLimit		 	= nil
local Image_bg      		= nil
local image_limit         	= nil
local PanelWei              = nil
local PanelShu              = nil
local PanelWu               = nil
local image_weiPortery      = nil
local image_shuPortery      = nil
local image_wuPortery       = nil
local nCountryID            = nil
local m_recomCountryID      = 1
local m_WeiPower            = nil
local m_ShuPower            = nil
local m_WuPower             = nil
local tableCountryID        = {}
local tableCampValue        = {}

local CheckCountryPower = CorpsLogic.CheckCountryPower

local function initData(  )
	CampAlterLayer 	= nil
	CampWeiqi 		= nil
	CampShuqi 		= nil
	CampWuqi 		= nil
	CampWeiLimit 	= nil
	CampShuLimit 	= nil
	CampWuLimit 	= nil
	Image_bg        = nil
	Image_limit 	= nil
	PanelWu         = nil
	PanelShu        = nil
	PanelWei        = nil
	image_weiPortery = nil
	image_shuPortery = nil
	image_wuPortery  = nil
	nCountryID       = nil
	m_recomCountryID = 1
	m_WeiPower       = nil
	m_ShuPower       = nil
	m_WuPower        = nil
end

local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		CampAlterLayer:setVisible(false)
		CampAlterLayer:removeFromParentAndCleanup(true)
		CampAlterLayer = nil
		tableCampValue = {}
	end
end

local function _Click_certain_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if nCountryID == nil then
			nCountryID = tableCampValue.country			
		end	
		if CheckCountryPower(nCountryID,m_WeiPower,m_ShuPower,m_WuPower) == true then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1058,nil)
			pTips = nil
		else	
			local function GetSuccessCallback(  )
				--NetWorkLoadingLayer.loadingHideShow()	
				
				local str = CorpsLogic.checkCampCountry(nCountryID)
				CorpsInfoSetLayer.ChangeCorpsCamp(nCountryID)
				CorpsScene.UpdateCoutryState(nCountryID)
				CampAlterLayer:setVisible(false)
				CampAlterLayer:removeFromParentAndCleanup(true)
				CampAlterLayer = nil
				tableCampValue = {}
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1435,nil,str)
				pTips = nil
				
			end	
			Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(5,nCountryID))
		end
	end
end

local function removeArray( pNode )
	
	pNode:removeFromParentAndCleanup(true)		
end

local function ChooseCamp_CallBackss(sender,eventType )
	local posBegan = nil
	local posEnd = nil
	local posMoved = nil
	local pTag = sender:getTag()
	nCountryID = pTag
	if eventType == TouchEventType.began then
		posBegan = sender:getTouchStartPos()
	elseif eventType == TouchEventType.moved then
		posMoved = sender:getTouchMovePos()
	elseif eventType == TouchEventType.ended then
		posEnd = sender:getTouchEndPos()	
		local pcallFunc = CCCallFuncN:create(removeArray)
		local pScaleToSmall = CCScaleTo:create(0.1,0.74,0.74)
		local pScaleToBig = CCScaleTo:create(0.1,1.0)
		local pMoveToMiddle = CCMoveTo:create(0.1,ccp(565,412))
		local pMoveToLeft = CCMoveTo:create(0.1,ccp(270,412))
		local pMoveToRight = CCMoveTo:create(0.1,ccp(872,412))

		local pMoveBotomMiddle = CCMoveTo:create(0.1,ccp(565,169))
		local pMoveBotomleft = CCMoveTo:create(0.1,ccp(270,169))
		local pMoveBotomright = CCMoveTo:create(0.1,ccp(872,169))

		local arrayMoveToMiddle = CCArray:create()
		arrayMoveToMiddle:addObject(pScaleToBig)
		arrayMoveToMiddle:addObject(pMoveToMiddle)
		--arrayMoveToMiddle:addObject(pcallFunc)

		local arrayMoveToLeft = CCArray:create()
		arrayMoveToLeft:addObject(pScaleToSmall)
		arrayMoveToLeft:addObject(pMoveToLeft)
		--arrayMoveToLeft:addObject(pcallFunc)

		local arrayMoveToRight = CCArray:create()
		arrayMoveToRight:addObject(pScaleToSmall)
		arrayMoveToRight:addObject(pMoveToRight)
		--arrayMoveToRight:addObject(pcallFunc)

		local arrayMoveBottomMiddle = CCArray:create()		
		arrayMoveBottomMiddle:addObject(pMoveBotomMiddle)
		

		local arrayMoveBottomLeft = CCArray:create()
		arrayMoveBottomLeft:addObject(pMoveBotomleft)

		local arrayMoveBottomRight = CCArray:create()
		arrayMoveBottomRight:addObject(pMoveBotomright)

		if pTag == 1 then
			-- CampWeiLimit:setVisible(true)
			-- CampShuLimit:setVisible(false)
			-- CampWuLimit:setVisible(false)
			-- --Image_bg:setPosition(ccp(CampWeiqi:getPositionX(),Image_bg:getPositionY()))
			CampShuqi:setScale(0.74)
			CampWeiqi:setScale(1)
			CampWuqi:setScale(0.74)
			CampShuqi:setColor(ccc3(50,50,50))
			CampWuqi:setColor(ccc3(50,50,50))
			CampWeiqi:setColor(ccc3(255,255,255))
			--[[if CampWeiqi:getPositionX() == 270 then
				CampWeiqi:runAction(CCSequence:create(arrayMoveToMiddle))
				CampShuqi:runAction(CCSequence:create(arrayMoveToRight))
				CampWuqi:runAction(CCSequence:create(arrayMoveToLeft))

				image_weiPortery:runAction(CCSequence:create(arrayMoveBottomMiddle))
				image_shuPortery:runAction(CCSequence:create(arrayMoveBottomRight))
				image_wuPortery:runAction(CCSequence:create(arrayMoveBottomLeft))
				
			elseif CampWeiqi:getPositionX() == 872 then
				CampWeiqi:runAction(CCSequence:create(arrayMoveToMiddle))
				CampShuqi:runAction(CCSequence:create(arrayMoveToRight))
				CampWuqi:runAction(CCSequence:create(arrayMoveToLeft))
				
				image_weiPortery:runAction(CCSequence:create(arrayMoveBottomMiddle))
				image_shuPortery:runAction(CCSequence:create(arrayMoveBottomRight))
				image_wuPortery:runAction(CCSequence:create(arrayMoveBottomLeft))
			end]]--

		elseif pTag == 2 then
			-- CampWeiLimit:setVisible(false)
			-- CampShuLimit:setVisible(true)
			-- CampWuLimit:setVisible(false)
			-- --Image_bg:setPosition(ccp(CampShuqi:getPositionX(),Image_bg:getPositionY()))
			CampShuqi:setScale(1)
			CampWeiqi:setScale(0.74)
			CampWuqi:setScale(0.74)
			CampShuqi:setColor(ccc3(255,255,255))
			CampWeiqi:setColor(ccc3(50,50,50))
			CampWuqi:setColor(ccc3(50,50,50))

			--[[if CampShuqi:getPositionX() == 872 then
				CampWeiqi:runAction(CCSequence:create(arrayMoveToLeft))
				CampShuqi:runAction(CCSequence:create(arrayMoveToMiddle))
				CampWuqi:runAction(CCSequence:create(arrayMoveToRight))

				image_weiPortery:runAction(CCSequence:create(arrayMoveBottomLeft))
				image_shuPortery:runAction(CCSequence:create(arrayMoveBottomMiddle))
				image_wuPortery:runAction(CCSequence:create(arrayMoveBottomRight))
			elseif CampShuqi:getPositionX() == 270 then
				CampWeiqi:runAction(CCSequence:create(arrayMoveToLeft))
				CampShuqi:runAction(CCSequence:create(arrayMoveToMiddle))
				CampWuqi:runAction(CCSequence:create(arrayMoveToRight))

				image_weiPortery:runAction(CCSequence:create(arrayMoveBottomLeft))
				image_shuPortery:runAction(CCSequence:create(arrayMoveBottomMiddle))
				image_wuPortery:runAction(CCSequence:create(arrayMoveBottomRight))
			end]]--
		elseif pTag == 3 then
			-- CampWeiLimit:setVisible(false)
			-- CampShuLimit:setVisible(false)
			-- CampWuLimit:setVisible(true)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1453,nil)
			pTips = nil
			CampShuqi:setScale(0.74)
			CampWeiqi:setScale(0.74)
			CampWuqi:setScale(1)
			CampShuqi:setColor(ccc3(50,50,50))
			CampWeiqi:setColor(ccc3(50,50,50))
			CampWuqi:setColor(ccc3(255,255,255))

			--[[if CampWuqi:getPositionX() == 872 then
				CampWeiqi:runAction(CCSequence:create(arrayMoveToRight))
				CampShuqi:runAction(CCSequence:create(arrayMoveToLeft))
				CampWuqi:runAction(CCSequence:create(arrayMoveToMiddle))

				image_weiPortery:runAction(CCSequence:create(arrayMoveBottomRight))
				image_shuPortery:runAction(CCSequence:create(arrayMoveBottomLeft))
				image_wuPortery:runAction(CCSequence:create(arrayMoveBottomMiddle))
			elseif CampWuqi:getPositionX() == 270 then
				CampWeiqi:runAction(CCSequence:create(arrayMoveToRight))
				CampShuqi:runAction(CCSequence:create(arrayMoveToLeft))
				CampWuqi:runAction(CCSequence:create(arrayMoveToMiddle))
				
				image_weiPortery:runAction(CCSequence:create(arrayMoveBottomRight))
				image_shuPortery:runAction(CCSequence:create(arrayMoveBottomLeft))
				image_wuPortery:runAction(CCSequence:create(arrayMoveBottomMiddle))
			end]]--
			--Image_bg:setPosition(ccp(CampWuqi:getPositionX(),Image_bg:getPositionY()))
		end

	end
end

local function _Click_Camp_CallBack( sender,eventType )
	local pTag = sender:getTag()
	local posBegan = nil
	local posMoved = nil
	local posEnd   = nil
	local posX = nil
	local posY = nil
	if eventType == TouchEventType.began then
		posBegan = sender:getTouchStartPos()
	elseif eventType == TouchEventType.moved then
		posMoved = sender:getTouchMovePos()
		posX = posMoved.x
		posY = posMoved.y
		print("moved",posX,posY)
		----------------判断是向左滑动还是向右滑动---------------------------
		
		if posX < 565 then
		--向左滑动	
			CampWuqi:setPosition(ccp(posX - 307,412))
			--CampWeiqi:setPosition(ccp())
		elseif posX >= 565 then
		--向右滑动
			CampWeiqi:setPosition(ccp(posX - 295,412))
			--CampWuqi:setPosition(ccp(posX - ))
		end
		CampShuqi:setPosition(ccp(posX,CampShuqi:getPositionY()))
	elseif eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		posEnd = sender:getTouchEndPos()
		posX = posEnd.x
		posY = posEnd.y
		print("ended",posX,posY)
		if posX <= 400 then
			CampShuqi:setPosition(ccp(270,412))
			CampWeiqi:setPosition(ccp(872,412))
			CampWuqi:setPosition(ccp(565,350))
		elseif posX > 400 and posX < 730 then
			CampShuqi:setPosition(ccp(565,350))
			CampWeiqi:setPosition(ccp(270,412))
			CampWuqi:setPosition(ccp(872,412))
		elseif posX >= 730 then
			CampShuqi:setPosition(ccp(872,412))
			CampWeiqi:setPosition(ccp(565,350))
			CampWuqi:setPosition(ccp(270,412))
		end
		
	end
end

local function CheckRecomdCountry( n_countryID )
	if n_countryID == 1 then
		CampShuqi:setScale(0.74)
		CampWeiqi:setScale(1)
		CampWuqi:setScale(0.74)
		CampShuqi:setColor(ccc3(50,50,50))
		CampWuqi:setColor(ccc3(50,50,50))
		CampWeiqi:setColor(ccc3(255,255,255))
	elseif n_countryID == 2 then
		CampShuqi:setScale(1)
		CampWeiqi:setScale(0.74)
		CampWuqi:setScale(0.74)
		CampShuqi:setColor(ccc3(255,255,255))
		CampWeiqi:setColor(ccc3(50,50,50))
		CampWuqi:setColor(ccc3(50,50,50))
	elseif n_countryID == 3 then
		CampShuqi:setScale(0.74)
		CampWeiqi:setScale(0.74)
		CampWuqi:setScale(1)
		CampShuqi:setColor(ccc3(50,50,50))
		CampWeiqi:setColor(ccc3(50,50,50))
		CampWuqi:setColor(ccc3(255,255,255))
	end
end

local function ChooseCamp_CallBack( sender,eventType  )
	if eventType == TouchEventType.ended then
		local pCountryID = sender:getTag()
		nCountryID = pCountryID
		CheckRecomdCountry(pCountryID)
	end
end

local function InitCampInfoControl( pControl )
	pControl:addTouchEventListener(ChooseCamp_CallBack)
	--pControl:addTouchEventListener(_Click_Camp_CallBack)
end

local function SetWeiPorperty(  )
	--魏国设置
	local label_weiword1 = tolua.cast(CampAlterLayer:getWidgetByName("Label_weiword1"),"Label")
	local label_weiword2 = tolua.cast(CampAlterLayer:getWidgetByName("Label_weiword2"),"Label")
	local label_weilevel = tolua.cast(CampAlterLayer:getWidgetByName("Label_weilevel"),"Label")
	local label_weipower = tolua.cast(CampAlterLayer:getWidgetByName("Label_weipower"),"Label")

	local labelweiword1Text = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "国家等级:", ccp(0, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelweiword2Text = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "总战力:", ccp(0, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelweilevelText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "10", ccp(0, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelweipowerText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, m_WeiPower, ccp(0, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)

	label_weiword1:addChild(labelweiword1Text)
	label_weiword2:addChild(labelweiword2Text)
	label_weilevel:addChild(labelweilevelText)
	label_weipower:addChild(labelweipowerText)
end

local function SetshuPorperty(  )
	--蜀国设置
	local label_shuword1 = tolua.cast(CampAlterLayer:getWidgetByName("Label_shuword1"),"Label")
	local label_shuword2 = tolua.cast(CampAlterLayer:getWidgetByName("Label_shuword2"),"Label")
	local label_shulevel = tolua.cast(CampAlterLayer:getWidgetByName("Label_shuLevel"),"Label")
	local label_shupower = tolua.cast(CampAlterLayer:getWidgetByName("Label_shupower"),"Label")

	local labelshuword1Text = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "国家等级:", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelshuword2Text = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "总战力:", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelshulevelText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "10", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelshupowerText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, m_ShuPower, ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)

	label_shuword1:addChild(labelshuword1Text)
	label_shuword2:addChild(labelshuword2Text)
	label_shulevel:addChild(labelshulevelText)
	label_shupower:addChild(labelshupowerText)
end

local function SetwuPorperty(  )
	--吴国设置
	local label_wuword1 = tolua.cast(CampAlterLayer:getWidgetByName("Label_wuword1"),"Label")
	local label_wuword2 = tolua.cast(CampAlterLayer:getWidgetByName("Label_wuword2"),"Label")
	local label_wulevel = tolua.cast(CampAlterLayer:getWidgetByName("Label_wulevel"),"Label")
	local label_wupower = tolua.cast(CampAlterLayer:getWidgetByName("Label_wupower"),"Label")

	local labelwuword1Text = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "国家等级:", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelwuword2Text = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "总战力:", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelwulevelText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "10", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelwupowerText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, m_WuPower, ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)

	label_wuword1:addChild(labelwuword1Text)
	label_wuword2:addChild(labelwuword2Text)
	label_wulevel:addChild(labelwulevelText)
	label_wupower:addChild(labelwupowerText)
end

local function initNature(  )
	-- PanelWei = tolua.cast(CampAlterLayer:getWidgetByName("Panel_wei"),"Layout")
	-- PanelShu = tolua.cast(CampAlterLayer:getWidgetByName("Panel_shu"),"Layout")
	-- PanelWu = tolua.cast(CampAlterLayer:getWidgetByName("Panel_wu"),"Layout")
	image_weiPortery = tolua.cast(CampAlterLayer:getWidgetByName("Image_weipor"),"ImageView")
	image_shuPortery = tolua.cast(CampAlterLayer:getWidgetByName("Image_shupor"),"ImageView")
	image_wuPortery = tolua.cast(CampAlterLayer:getWidgetByName("Image_wupor"),"ImageView")

	CampWeiqi = tolua.cast(CampAlterLayer:getWidgetByName("Image_weiqi"),"ImageView")
	CampShuqi = tolua.cast(CampAlterLayer:getWidgetByName("Image_shuqi"),"ImageView")
	CampWuqi = tolua.cast(CampAlterLayer:getWidgetByName("Image_wuqi"),"ImageView")

	--CampWeiqi:setScale(0.74)
	CampWeiqi:setTag(1)
	CampWeiqi:setTouchEnabled(true)
	--CampShuqi:setScale(0.74)
	CampShuqi:setTag(2)
	CampShuqi:setTouchEnabled(true)
	-- CampShuqi:setScale(0.8)
	--CampShuqi:setPosition(ccp(565,390))
	--CampWuqi:setScale(0.74)
	CampWuqi:setTag(3)
	CampWuqi:setTouchEnabled(true)
	
	CheckRecomdCountry(m_recomCountryID)
	--CampShuqi:setColor(ccc3(255,255,255))
	--CampWeiqi:setColor(ccc3(50,50,50))
	--CampWuqi:setColor(ccc3(50,50,50))

	InitCampInfoControl(CampWeiqi)
	InitCampInfoControl(CampShuqi)
	InitCampInfoControl(CampWuqi)

	local label_cost = tolua.cast(CampAlterLayer:getWidgetByName("Label_cost"),"Label")
	local label_cost1 = tolua.cast(CampAlterLayer:getWidgetByName("Label_cost1"),"Label")
	local label_cost2 = tolua.cast(CampAlterLayer:getWidgetByName("Label_cost2"),"Label")

	image_limit = tolua.cast(CampAlterLayer:getWidgetByName("Image_limit"),"ImageView")

	local labelcostText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "花费:", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	local labelcost1Text = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "500", ccp(1, 0), ccc3(83,28,2), ccc3(25,245,235), true, ccp(0, -2), 2)
	local labelcost2Text = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "500", ccp(1, 0), ccc3(83,28,2), ccc3(228,199,167), true, ccp(0, -2), 2)
	line = AddLine(ccp(-35,0),ccp(35,0), ccc3(255,0,0),1,255)
	labelcost2Text:addNode(line)
	label_cost:addChild(labelcostText)
	label_cost1:addChild(labelcost1Text)
	label_cost2:addChild(labelcost2Text)
	
	SetWeiPorperty()
	SetshuPorperty()
	SetwuPorperty()

	local labelbtnText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "宣誓效忠", ccp(1, 0), ccc3(0,0,0), ccc3(255,255,255), true, ccp(0, -2), 2)

	--按钮
	local btn_cost = tolua.cast(CampAlterLayer:getWidgetByName("Button_ChooseCamp"),"Button")
	btn_cost:addChild(labelbtnText)
	btn_cost:addTouchEventListener(_Click_certain_CallBack)

	------------------------------------------
	---确定限制高战力标签的位置
	if ((m_WeiPower >= m_ShuPower*2) or (m_WeiPower >= m_WuPower*2))  then
		image_limit:setPosition(ccp(CampWeiqi:getPositionX(),CampWeiqi:getPositionY()))
	elseif ((m_ShuPower >= m_WeiPower*2)  or (m_ShuPower >= m_WuPower*2)) then
		image_limit:setPosition(ccp(CampShuqi:getPositionX(),CampShuqi:getPositionY()))
	elseif ((m_WuPower >= m_ShuPower*2) or (m_WuPower >= m_WeiPower*2)) then
		image_limit:setPosition(ccp(CampWuqi:getPositionX(),CampWuqi:getPositionY()))
	end

end

function ShowCampLayer( value )
	initData()
	CampAlterLayer = TouchGroup:create()
	CampAlterLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsChooseLayer.json"))

	local btun_return = tolua.cast(CampAlterLayer:getWidgetByName("Button_return"),"Button")
	btun_return:addTouchEventListener(_Click_return_CallBack)

	tableCountryID = CorpsData.GetRecomCountryData()
	m_recomCountryID = CorpsData.GetRecomCountryID()
	m_WeiPower = CorpsData.GetWeiCountryPower()
	m_ShuPower = CorpsData.GetShuCountryPower()
	m_WuPower  = CorpsData.GetWuCountryPower()

	initNature()

	tableCampValue["flag"] = value.flag
	tableCampValue["name"] = value.name
	tableCampValue["id"] = value.id
	tableCampValue["level"] = value.level
	tableCampValue["people"] = value.people
	tableCampValue["needlevel"] = value.needlevel
	tableCampValue["brief"] = value.brief
	tableCampValue["country"] = value.country

	

	return CampAlterLayer
end