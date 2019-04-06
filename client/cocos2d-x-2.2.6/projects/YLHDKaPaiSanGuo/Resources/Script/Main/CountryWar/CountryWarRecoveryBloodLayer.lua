-- for CCLuaEngine traceback
require "Script/Common/Common"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"

module("CountryWarRecoveryBloodLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 
local UIInterface_CreatAnimateByResID 	= 	UIInterface.CreatAnimateByResID

local numIsIntab						=	CountryWarLogic.numIsIntab
local CreateLabel 						=	CountryWarLogic.CreateLabel

local GetPlayerCountry					=	CountryWarData.GetPlayerCountry
local GetGeneralHeadPath				=	CountryWarData.GetGeneralHeadPath
local GetCountryRes						=	CountryWarData.GetCountryRes
local GetPathByImageID					=	CountryWarData.GetPathByImageID

local GetTeamCurBlood					=	CountryWarData.GetTeamCurBlood
local GetTeamMaxBlood					=	CountryWarData.GetTeamMaxBlood
local GetTeamRes 						=	CountryWarData.GetTeamRes
local GetTeamFace						=	CountryWarData.GetTeamFace
local GetTeamName 						=	CountryWarData.GetTeamName
local GetRecoveryBloodCons				=	CountryWarData.GetRecoveryBloodCons
local GetReconveryBloodNum				=	CountryWarData.GetReconveryBloodNum
local GetCurHaveItemNum					=	CountryWarData.GetCurHaveItemNum
local GetReconveryBloodName				=	CountryWarData.GetReconveryBloodName
local GetTeamLevel						=	CountryWarData.GetTeamLevel

local m_RecoveryBloodLayer = nil
local m_TeamIndex = nil
local m_BuyNum = nil
local m_Label_CurNum = nil
local m_ConsID = nil
local m_HaveItemNum = nil


local function InitVars(  )
	m_RecoveryBloodLayer = nil
	m_TeamIndex 		 = nil
	m_BuyNum			 = nil
	m_Label_CurNum       = nil
	m_ConsID 			 = nil
	m_HaveItemNum 		 = nil  
end

local function _Button_Close_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		m_RecoveryBloodLayer:removeFromParentAndCleanup(true)
		InitVars()

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)

	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function UpdateBloodNum(  )
	-- 刷新恢复生命值说明	
	local Image_WhiteBg 	=   tolua.cast(m_RecoveryBloodLayer:getWidgetByName("Image_WhiteBg"), "ImageView") 
	if Image_WhiteBg:getChildByTag(3) ~= nil then

		local pConsBlood = m_BuyNum * GetReconveryBloodNum( m_ConsID )

		local pInfoStr = " "..m_BuyNum.."个, 将恢复队伍"..pConsBlood.."生命值"

		Image_WhiteBg:getChildByTag(3):setText(pInfoStr)

	end
end

local function CountEatFullBlood(  )
	--计算当前血量恢复满需要吃多少个云南白药
	local pCurBlood = GetTeamCurBlood( m_TeamIndex )
	local pMaxBlood = GetTeamMaxBlood( m_TeamIndex )
	local pDiffBlood = pMaxBlood - pCurBlood

	return math.ceil(tonumber(pDiffBlood) / GetReconveryBloodNum(m_ConsID))

end

local function JudgeBuyNum(  )

	if m_BuyNum <= 1 then

		m_BuyNum = 1

	else

		if m_BuyNum >= m_HaveItemNum then

			m_BuyNum = m_HaveItemNum  			--已选数量只能等于当前拥有的数量

			if m_BuyNum <= 1 then

				m_BuyNum = 1

			end

		else

			--如果现在拥有很多则判断吃多少个可以把血条吃满
			local pNeedNum = CountEatFullBlood()
			print("当前吃"..pNeedNum.."个血药可以吃满")

			if m_BuyNum >= pNeedNum then

				m_BuyNum = pNeedNum

			end

		end

	end
end

local function _Button_Plus_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)

		local pPlusNum = sender:getTag()

		if m_BuyNum ~= nil then

			m_BuyNum = m_BuyNum + pPlusNum

			JudgeBuyNum()

			m_Label_CurNum:setText(m_BuyNum)

			UpdateBloodNum()

		end

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)

	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_Sub_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)

		local pPlusNum = sender:getTag()

		if m_BuyNum ~= nil then

			m_BuyNum = m_BuyNum - pPlusNum

			if m_BuyNum < 1 then

				m_BuyNum = 1

			end

			m_Label_CurNum:setText(m_BuyNum)

			UpdateBloodNum()

		end

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)

	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_Use_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)

		local function UseCallBack( nResult )
			NetWorkLoadingLayer.loadingShow(false)
			if tonumber(nResult) == 1 then
				--成功
				if m_ConsID == nil or m_ConsID <= 0 then
					m_ConsID = 232
				end
				local pTips = TipCommonLayer.CreateTipLayerManager()
				local pStr = tostring(GetReconveryBloodName(m_ConsID))
				pTips:ShowCommonTips(1640, nil, m_BuyNum, tostring(pStr))
				pTips = nil
				m_RecoveryBloodLayer:removeFromParentAndCleanup(true)
				InitVars()		
			elseif tonumber(nResult) == 2 then 
				TipLayer.createTimeLayer("队伍不存在",2)
			elseif tonumber(nResult) == 3 then 
				if m_ConsID == nil or m_ConsID <= 0 then
					m_ConsID = 232
				end
				TipLayer.createTimeLayer(GetReconveryBloodName(m_ConsID).."不足",2)
			elseif tonumber(nResult) == 4 then 
				TipLayer.createTimeLayer("队伍不在空闲或移动状态，无法调养",2)
			end
		end

		JudgeBuyNum()

		if m_BuyNum > m_HaveItemNum then
			local pStr = tostring(GetReconveryBloodName(m_ConsID))
			TipLayer.createTimeLayer(pStr.."不足",2)
			return 
		end

		NetWorkLoadingLayer.loadingShow(true)
		Packet_CountryWarEatBlood.SetSuccessCallBack(UseCallBack)
		network.NetWorkEvent(Packet_CountryWarEatBlood.CreatePacket(m_TeamIndex, m_ConsID, m_BuyNum))

	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)

	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitUI(  )
	local Image_Bg 			= 	tolua.cast(m_RecoveryBloodLayer:getWidgetByName("Image_Bg"), "ImageView")
	local Image_WhiteBg 	=   tolua.cast(m_RecoveryBloodLayer:getWidgetByName("Image_WhiteBg"), "ImageView") 
	local Image_Head    	= 	tolua.cast(Image_Bg:getChildByName("Image_Head"), "ImageView")
	local Button_Sub_1 	 	= 	tolua.cast(Image_Bg:getChildByName("Button_Sub_1"), "Button")
	local Button_Sub_10 	= 	tolua.cast(Image_Bg:getChildByName("Button_Sub_10"), "Button")
	local Button_Plus_1 	= 	tolua.cast(Image_Bg:getChildByName("Button_Plus_1"), "Button")
	local Button_Plus_10 	= 	tolua.cast(Image_Bg:getChildByName("Button_Plus_10"), "Button")
	local Button_Sure 		= 	tolua.cast(Image_Bg:getChildByName("Button_Sure"), "Button")

	m_Label_CurNum      =   tolua.cast(Image_Bg:getChildByName("Label_CurNum"), "Label")
	
	local Image_HeadItem	=   tolua.cast(Image_Head:getChildByName("Image_HeadItem"), "ImageView")
	local ProgressBar_Blood =   tolua.cast(Image_Head:getChildByName("ProgressBar_Blood"), "LoadingBar") 
	local Label_Blood       =   tolua.cast(Image_Head:getChildByName("Label_Blood"), "Label")

	--设置头像
	if m_TeamIndex == 0 then
		local pFaceId = GetTeamFace(m_TeamIndex)
		local pPath = GetPathByImageID( pFaceId )
		Image_HeadItem:loadTexture( pPath )
	else
		local pTeamRes  = GetTeamRes( m_TeamIndex )
		local pHeadPath = GetGeneralHeadPath( pTeamRes )
		Image_HeadItem:loadTexture( pHeadPath )
	end

	--设置血量
	local pCurBlood = GetTeamCurBlood( m_TeamIndex )
	local pMaxBlood = GetTeamMaxBlood( m_TeamIndex )
	local pPercent  = pCurBlood / pMaxBlood * 100
	ProgressBar_Blood:setPercent( pPercent )
	Label_Blood:setText(tostring(pCurBlood).."/"..tostring(pMaxBlood))

	--设置姓名
	local pName = GetTeamName( m_TeamIndex )
	local pNameLabel = CreateLabel(pName, 24, ccc3(233,172,110), CommonData.g_FONT3, ccp(ProgressBar_Blood:getPositionX() - 110, ProgressBar_Blood:getPositionY() + 40))
	pNameLabel:setAnchorPoint(ccp(0,0.5))
	Image_Head:addChild(pNameLabel)

	--设置等级
	local Label_Level = tolua.cast(Image_Head:getChildByName("Label_Level"), "Label")
	Label_Level:setText(GetTeamLevel(m_TeamIndex))

	--设置购买数量
	m_Label_CurNum:setText(m_BuyNum)

	--设置购买按钮相关
	Button_Sub_1:setTag(1)
	Button_Sub_10:setTag(10)
	Button_Plus_1:setTag(1)
	Button_Plus_10:setTag(10)

	Button_Sub_1:addTouchEventListener( _Button_Sub_CallBack )
	Button_Sub_10:addTouchEventListener( _Button_Sub_CallBack )
	Button_Plus_1:addTouchEventListener( _Button_Plus_CallBack )
	Button_Plus_10:addTouchEventListener( _Button_Plus_CallBack )

	--添加消耗说明
	local ImageView_Cons = ImageView:create()
	ImageView_Cons:loadTexture(GetPathByImageID(m_ConsID))
	ImageView_Cons:setPosition(ccp(-70, -90))
	ImageView_Cons:setScale(0.5)

	local pWidth = ImageView_Cons:getContentSize().width * 0.25

	local pInfoLabel = CreateLabel("当前使用 ", 18, ccc3(233,172,110), CommonData.g_FONT1, ccp(ImageView_Cons:getPositionX() - pWidth, -90))
	pInfoLabel:setAnchorPoint(ccp(1,0.5))

	local pConsBlood = m_BuyNum * GetReconveryBloodNum( m_ConsID )

	local pInfoStr_2 = " "..m_BuyNum.."个, 将恢复队伍"..pConsBlood.."生命值"
	local pInfoStr_2Label = CreateLabel(pInfoStr_2, 18, ccc3(233,172,110), CommonData.g_FONT1, ccp(ImageView_Cons:getPositionX() + pWidth, -90))
	pInfoStr_2Label:setAnchorPoint(ccp(0,0.5))

	Image_WhiteBg:addChild(pInfoLabel,1,1)
	Image_WhiteBg:addChild(ImageView_Cons,2,2)
	Image_WhiteBg:addChild(pInfoStr_2Label,3,3)

	--确定按钮
	local pSureInfo = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT3, "确定使用", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
	Button_Sure:addChild(pSureInfo)
	Button_Sure:addTouchEventListener( _Button_Use_CallBack )

	--当前拥有的云南白药数量
	local ImageView_Cons_Haved = ImageView:create()
	ImageView_Cons_Haved:loadTexture(GetPathByImageID(m_ConsID))
	ImageView_Cons_Haved:setPosition(ccp(Button_Sure:getPositionX() + 135, Button_Sure:getPositionY()))
	ImageView_Cons_Haved:setScale(0.5)	

	Image_Bg:addChild(ImageView_Cons_Haved)

	local pHaveLabel   = CreateLabel("拥有", 18, ccc3(233,172,110), CommonData.g_FONT1, ccp(ImageView_Cons_Haved:getPositionX() - pWidth, ImageView_Cons_Haved:getPositionY()))
	local pHaveLabel_2 = CreateLabel(" "..m_HaveItemNum.."个", 18, ccc3(233,172,110), CommonData.g_FONT1, ccp(ImageView_Cons_Haved:getPositionX() + pWidth, ImageView_Cons_Haved:getPositionY()))

	pHaveLabel:setAnchorPoint(ccp(1,0.5))
	pHaveLabel_2:setAnchorPoint(ccp(0,0.5))
	Image_Bg:addChild(pHaveLabel)
	Image_Bg:addChild(pHaveLabel_2,1,99)


end

function UpdateBlood(  )
	if m_RecoveryBloodLayer ~= nil then
		local Image_Bg 			= 	tolua.cast(m_RecoveryBloodLayer:getWidgetByName("Image_Bg"), "ImageView")
		local Image_Head    	= 	tolua.cast(Image_Bg:getChildByName("Image_Head"), "ImageView")
		local Label_Blood       =   tolua.cast(Image_Head:getChildByName("Label_Blood"), "Label")
		local ProgressBar_Blood =   tolua.cast(Image_Head:getChildByName("ProgressBar_Blood"), "LoadingBar") 

		local pCurBlood = GetTeamCurBlood( m_TeamIndex )
		local pMaxBlood = GetTeamMaxBlood( m_TeamIndex )
		local pPercent  = pCurBlood / pMaxBlood * 100
		ProgressBar_Blood:setPercent( pPercent )
		Label_Blood:setText(tostring(pCurBlood).."/"..tostring(pMaxBlood))
	end
end


function CreateCountryWarRecoveryBloodLayer( nParent, nTeamIndex )
	InitVars() 
	m_RecoveryBloodLayer = TouchGroup:create()
	m_RecoveryBloodLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryWarRecoveryBlood.json"))

	m_TeamIndex = nTeamIndex

	m_ConsID   = GetRecoveryBloodCons()

	m_BuyNum  = 1

	m_HaveItemNum = GetCurHaveItemNum( m_ConsID )

	InitUI()

	local Button_Close = 	tolua.cast(m_RecoveryBloodLayer:getWidgetByName("Button_Close"), "Button")
	Button_Close:addTouchEventListener( _Button_Close_CallBack )

	nParent:addChild(m_RecoveryBloodLayer)

    return m_RecoveryBloodLayer
end