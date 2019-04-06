--FileName:CorpsMessHallLayer
--Author:xuechao
--Purpose:军团食堂界面
module("CorpsMessHallLayer",package.seeall)
require "Script/serverDB/techeffect"
require "Script/serverDB/technolog"
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceData"
require "Script/Main/Corps/CorpsMessHallData"

local MessHallLayer  	 = nil
local btn_bule       	 = nil
local btn_single     	 = nil
local btn_pink       	 = nil
local m_Pinkrevice   	 = nil
local m_DinRevice    	 = nil
local m_SingleRevice 	 = nil
local image_bulebg       = nil
local image_yellowbg     = nil
local image_pinkbg       = nil
local imageBlackB        = nil
local imageBlackY        = nil
local imageBlackP        = nil
local nlevel             = nil
local m_timeHand         = nil
local label_time         = nil
local label_count        = nil
local countFree          = 1
local tableMessDB        = {}
local MessFlag 			 = {}
local tableParaData      = {}

local nOff_X = CommonData.g_Origin.x
local nOff_Y = CommonData.g_Origin.y


local GetIconDataID = CorpsData.GetIconDataID
local CheckMessHallLV = CorpsLogic.CheckMessHallLV
local GetScienceUpDate  	= CorpsScienceData.GetScienceUpdate
local GetScienceHall        = CorpsScienceData.GetScienceHall
local GetScienceDataByID = CorpsData.GetScienceDataByID
local GetBuyNumHall = CorpsMessHallData.GetBuyNumHall


local function initData(  )
	MessHallLayer    = nil
	btn_bule       	 = nil
	btn_single     	 = nil
	btn_pink       	 = nil
	m_Pinkrevice   	 = nil
	m_DinRevice    	 = nil
	m_SingleRevice 	 = nil
	image_bulebg     = nil
	image_yellowbg   = nil
	image_pinkbg     = nil
	imageBlackP      = nil
	imageBlackY      = nil
	imageBlackB      = nil
	nlevel           = nil
	m_timeHand       = nil
	label_time       = nil
	label_count      = nil
	countFree        = 1
	tableMessDB      = {}
	MessFlag 		 = {}
	tableParaData    = {}
end

local function _Click_MessHall_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		if m_timeHand ~= nil then
			MessHallLayer:getScheduler():unscheduleScriptEntry(m_timeHand)
			m_timeHand = nil
		end
		MessHallLayer:setVisible(false)
		MessHallLayer:removeFromParentAndCleanup(true)
		MessHallLayer = nil
		
		CorpsScene.CleanCorpsTopLayer()
		local p_Scene = CorpsScene.GetPScene()
		CorpsScene.loadCorpsTopLayer(p_Scene)
		if tonumber(countFree) <= 0 then
			CorpsScene.DeleteRedPoint(11)
		else
			CorpsScene.upDateHallPoint()
		end
	end
end

local function SetGlod( num )
	local label_gold = tolua.cast(MessHallLayer:getWidgetByName("Label_gold"),"Label")
	label_gold:setColor(ccc3(116,85,20))
	label_gold:setFontSize(18)
	label_gold:setFontName(CommonData.g_FONT1)
	label_gold:setText(num)
end

local function SetSliver( num )
	local label_sliver = tolua.cast(MessHallLayer:getWidgetByName("Label_sliver"),"Label")
	label_sliver:setColor(ccc3(116,85,20))
	label_sliver:setFontSize(18)
	label_sliver:setFontName(CommonData.g_FONT1)
	label_sliver:setText(num)
end

local function SetContribute( num )
	local label_contribute = tolua.cast(MessHallLayer:getWidgetByName("Label_contribute"),"Label")
	label_contribute:setColor(ccc3(116,85,20))
	label_contribute:setFontSize(18)
	label_contribute:setFontName(CommonData.g_FONT1)
	label_contribute:setText(num)
end

local function SetCorpsIcon( nCorpsId )
	--根据食堂等级来确定图标
	local MessID = tonumber(nCorpsId)
	local image_kuang = tolua.cast(MessHallLayer:getWidgetByName("Image_60"),"ImageView")
	image_kuang:loadTexture("Image/imgres/common/color/wj_pz7.png")
	local Image_CorpsIcon = tolua.cast(MessHallLayer:getWidgetByName("Image_Corpsicon"),"ImageView")
	Image_CorpsIcon:setZOrder(-1)
	if MessID > 0 then
		local iconPath = resimg.getFieldByIdAndIndex(MessID,"icon_path")
		Image_CorpsIcon:loadTexture(iconPath)
	end
end

local function SetTasle( num )
	local label_tasle = tolua.cast(MessHallLayer:getWidgetByName("Label_taels"),"Label")
	label_tasle:setColor(ccc3(116,85,20))
	label_tasle:setFontSize(18)
	label_tasle:setFontName(CommonData.g_FONT1)
	label_tasle:setText(num)
end

local function SetTitleText( strNum)
	local label_title = tolua.cast(MessHallLayer:getWidgetByName("Label_corpsLevel"),"Label")
	label_title:setColor(ccc3(233,180,114))
	label_title:setFontSize(24)
	label_title:setFontName(CommonData.g_FONT1)
	label_title:setText(strNum)
end
 
local function SetContentText( str )
	local label_Content = tolua.cast(MessHallLayer:getWidgetByName("Label_info"),"Label")
	label_Content:setColor(ccc3(233,180,114))
	label_Content:setFontSize(20)
	label_Content:setFontName(CommonData.g_FONT1)
	label_Content:setText(str)
end

local function JieXiTime(  )
	local ntime = os.date("*t")
	local nMinute = ntime.min
	local nHour = ntime.hour
	local nSec = ntime.sec
	print(ntime,nHour,nMinute,nSec)
	printTab(ntime)
	local CurTime = os.time()
	local nT = os.date("*t",CurTime)
end

--前往充值界面
local function ToVIP()
	AudioUtil.PlayBtnClick()
	if m_timeHand ~= nil then
		MessHallLayer:getScheduler():unscheduleScriptEntry(m_timeHand)
		m_timeHand = nil
	end
	MessHallLayer:setVisible(false)
	MessHallLayer:removeFromParentAndCleanup(true)
	MessHallLayer = nil
	
	CorpsScene.CleanCorpsTopLayer()
	local p_Scene = CorpsScene.GetPScene()
	CorpsScene.loadCorpsTopLayer(p_Scene)
	MainScene.GoToVIPLayer(3)
end

local function _Click_Revice_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		local btn_Click = tolua.cast(sender,"Button")
		local pTag = btn_Click:getTag()
		--当领取次数为零是无法领取，显示为还没到开饭时间哦！
		local VIPLevel = server_mainDB.getMainData("vip")
		
		AudioUtil.PlayBtnClick()
		if pTag == 3 then
			local vipLimit = CorpsData.GetVIPLimit(enumVIPFunction.eVipFunction_4)
			if tonumber(VIPLevel) < tonumber(vipLimit) then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1634,ToVIP,vipLimit)
				pTips = nil
				return
			end
		end
		local function GetSuccessCallback()
			NetWorkLoadingLayer.loadingHideNow()
			btn_pink:setVisible(false)
			btn_bule:setVisible(false)
			btn_single:setVisible(false)
			btn_single:setTouchEnabled(false)
			btn_bule:setTouchEnabled(false)
			btn_pink:setTouchEnabled(false)
			CorpsScene.GetConteobile(0)
			countFree = countFree - 1
			if countFree <= 0 then
				countFree = 0
			end
			label_count:setText(countFree)
			if pTag == 1 then
				m_DinRevice:setVisible(true)
				--imageBlackB:setVisible(true)
			elseif pTag == 2 then
				m_SingleRevice:setVisible(true)
				--imageBlackY:setVisible(true)
			elseif pTag == 3 then
				m_Pinkrevice:setVisible(true)
				--imageBlackP:setVisible(true)
			end
			local btn_add = tolua.cast(MessHallLayer:getWidgetByName("Image_add"),"ImageView")
			btn_add:setTouchEnabled(true)
			pSpriteScience_least = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
			
			SpriteSetGray(pSpriteScience_least,0)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1445,nil)
			pTips = nil																
		end		
		Packet_CorpsMessHall.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsMessHall.CreatePacket(pTag))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function loadBtnControle(pControle )
	pControle:addTouchEventListener(_Click_Revice_CallBack)
end

local function GetBuyCount(  )
	CorpsScene.GetConteobile(0)
	local tab = GetBuyNumHall()
	countFree = 1 - tonumber(tab["nMoneyType"])
	if tonumber(countFree) > 0 then
		m_DinRevice:setVisible(false)
		m_SingleRevice:setVisible(false)
		m_Pinkrevice:setVisible(false)
		btn_pink:setVisible(true)
		btn_bule:setVisible(true)
		btn_single:setVisible(true)
		btn_single:setTouchEnabled(true)
		btn_bule:setTouchEnabled(true)
		btn_pink:setTouchEnabled(true)
		label_count:setText(countFree)
		local btn_add = tolua.cast(MessHallLayer:getWidgetByName("Image_add"),"ImageView")
		btn_add:setTouchEnabled(true)
		pSpriteScience_least = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
		
		SpriteSetGray(pSpriteScience_least,1)
	end
end

--dinnigtable
local function loadDinWriteCode( messHallLayer ,nlevel)
	image_bulebg = tolua.cast(messHallLayer:getWidgetByName("Image_bulebg"),"ImageView")
	-- local btnText = Label:create()
	local btnText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "领鸡腿", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, -2), 2)
	btn_bule = tolua.cast(messHallLayer:getWidgetByName("Button_bule"),"Button")
	btn_bule:setTag(1)
	btn_bule:addChild(btnText)
	loadBtnControle(btn_bule)
	if tableMessDB.nMoneyType ~= 0 then
		btn_bule:setVisible(false)
		btn_bule:setTouchEnabled(false)
	end
	

	---------------------------------------------------------------
	--消耗类型,数量及奖励类型数量
	--local level_1Data =  GetScienceDataByID(tableParaData[2])
	--printTab(level_1Data)
	--Pause
	-- local imgId,RewardCount = CorpsData.GetSciencePriData(MessFlag["TechEffID1"])
	print("饭桌")
	local tabReward,tabConsum = CorpsMessHallData.GetRewardConsumID(MessFlag["TechEffID1"],2)
	local GainName = tabReward[1][1]["CoinName"]
	local imgPath = tabReward[1][1]["CoinPath"]
	local RewardCount = tabReward[1][1]["CoinNum"]
	-- local imgPath ,GainName= CorpsData.GetRewardIconPath(imgId)

	m_DinRevice = tolua.cast(messHallLayer:getWidgetByName("Image_buleRevice"),"ImageView")
	m_DinRevice:setVisible(false)
	local mark_jun_3 = tolua.cast(messHallLayer:getWidgetByName("Image_ConRevice"),"ImageView")
	mark_jun_3:setVisible(false)
	if tonumber(tableMessDB["nMoneyType"]) == 1 then
		m_DinRevice:setVisible(true)
	end
	--添加文字及图片
	local nX = image_bulebg:getPositionX()
	local nY = image_bulebg:getPositionY()
	
	local FreeText = Label:create()
	FreeText:setFontSize(24)
	FreeText:setFontName(CommonData.g_FONT1)
	FreeText:setColor(ccc3(116,57,5))
	FreeText:setText("免费领取")
	FreeText:setPosition(ccp(0,-20))
	image_bulebg:addChild(FreeText)

	local GainText = Label:create()
	GainText:setFontSize(24)
	GainText:setFontName(CommonData.g_FONT1)
	GainText:setColor(ccc3(116,57,5))
	GainText:setPosition(ccp(-45,-80))
	GainText:setText(GainName..":")
	image_bulebg:addChild(GainText)

	local GainNumText = Label:create()
	GainNumText:setFontSize(24)
	GainNumText:setFontName(CommonData.g_FONT1)
	GainNumText:setColor(ccc3(116,57,5))
	GainNumText:setPosition(ccp(90,-80))
	GainNumText:setText(RewardCount)
	image_bulebg:addChild(GainNumText)

	local pImg = ImageView:create()
	pImg:loadTexture(imgPath)
	pImg:setAnchorPoint(ccp(0,0))
	pImg:setScale(0.45)
	-- pImg:setOpacity(60)
	pImg:setPosition(ccp(20,-100))
	image_bulebg:addChild(pImg)

end

--singleRoom
local function loadSingleWriteCode( messHallLayer,nlevel )
	image_yellowbg = tolua.cast(messHallLayer:getWidgetByName("Image_yellowbg"),"ImageView")
	local btnText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "领鸡腿", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, 0), 0)
	btn_single = tolua.cast(messHallLayer:getWidgetByName("Button_yellow"),"Button")
	btn_single:setTag(2)
	btn_single:addChild(btnText)
	loadBtnControle(btn_single)
	if tableMessDB.nMoneyType ~= 0 then
		btn_single:setVisible(false)
		btn_single:setTouchEnabled(false)
	end

	---获得的奖励信息
	-- local imgId,RewardCount = CorpsData.GetScienceMiddleData(MessFlag["TechEffID1"])
	-- local imgPath ,GainName= CorpsData.GetRewardIconPath(imgId)
	---消耗信息
	-- local imgConsumId,ConsumCount = CorpsData.GetMessConsumeMiddleInfo(MessFlag["TechEffID1"])
	-- local imgConsumPath ,ConsumName= CorpsData.GetRewardIconPath(imgConsumId)

	local tabReward,tabConsum = CorpsMessHallData.GetRewardConsumID(MessFlag["TechEffID1"],3)
	local GainName = tabReward[1][1]["CoinName"]
	local imgPath = tabReward[1][1]["CoinPath"]
	local RewardCount = tabReward[1][1]["CoinNum"]
	local imgConsumPath = tabConsum.TabData[1]["IconPath"]
	local ConsumCount = tabConsum.TabData[1]["ItemNeedNum"]
	local ConsumName = CorpsMessHallData.GetCreateCorpsConsumName(tabConsum.TabData[1]["ConsumeType"])

	m_SingleRevice = tolua.cast(messHallLayer:getWidgetByName("Image_yellowRevice"),"ImageView")
	m_SingleRevice:setVisible(false)
	local mark_jun_2 = tolua.cast(messHallLayer:getWidgetByName("Image_YContribute"),"ImageView")
	mark_jun_2:setVisible(false)

	if tonumber(tableMessDB["nMoneyType"]) == 2 then
		m_SingleRevice:setVisible(true)
	end
	--添加文字及图片
	local ConText = Label:create()
	ConText:setFontSize(24)
	ConText:setFontName(CommonData.g_FONT1)
	ConText:setColor(ccc3(116,57,5))
	ConText:setPosition(ccp(-50,-20))
	ConText:setText("消耗"..ConsumName..":")
	image_yellowbg:addChild(ConText)

	local ConNumText = Label:create()
	ConNumText:setFontSize(24)
	ConNumText:setFontName(CommonData.g_FONT1)
	ConNumText:setColor(ccc3(116,57,5))
	ConNumText:setPosition(ccp(100,-20))
	ConNumText:setText(ConsumCount)
	image_yellowbg:addChild(ConNumText)

	local GainText = Label:create()
	GainText:setFontSize(24)
	GainText:setFontName(CommonData.g_FONT1)
	GainText:setColor(ccc3(116,57,5))
	GainText:setPosition(ccp(-50,-80))
	GainText:setText(GainName..":")
	image_yellowbg:addChild(GainText)

	local GainNumText = Label:create()
	GainNumText:setFontSize(24)
	GainNumText:setFontName(CommonData.g_FONT1)
	GainNumText:setColor(ccc3(116,57,5))
	GainNumText:setPosition(ccp(90,-80))
	GainNumText:setText(RewardCount)
	image_yellowbg:addChild(GainNumText)

	local pImg = ImageView:create()
	pImg:loadTexture(imgPath)
	pImg:setAnchorPoint(ccp(0,0))
	pImg:setScale(0.45)
	-- pImg:setOpacity(60)
	pImg:setPosition(ccp(25,-100))
	image_yellowbg:addChild(pImg)

	local pImgCon = ImageView:create()
	pImgCon:loadTexture(imgConsumPath)
	pImgCon:setAnchorPoint(ccp(0,0))
	pImgCon:setScale(0.4)
	-- pImgCon:setOpacity(60)
	pImgCon:setPosition(ccp(30,-35))
	image_yellowbg:addChild(pImgCon)

end

local function loadPrivateWriteCode( messHallLayer ,nlevel)
	image_pinkbg = tolua.cast(messHallLayer:getWidgetByName("Image_pink"),"ImageView")
	local btnText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "领鸡腿", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, 0), 0)
	btn_pink = tolua.cast(messHallLayer:getWidgetByName("Button_pink"),"Button")
	btn_pink:setTag(3)
	btn_pink:addChild(btnText)
	loadBtnControle(btn_pink)
	if tableMessDB.nMoneyType ~= 0 then
		btn_pink:setVisible(false)
		btn_pink:setTouchEnabled(false)
	end
	m_Pinkrevice = tolua.cast(messHallLayer:getWidgetByName("Image_pinkRevice"),"ImageView")
	local VIPLevel = server_mainDB.getMainData("vip")
	m_Pinkrevice:setVisible(false)

	local mark_jun_1 = tolua.cast(messHallLayer:getWidgetByName("Image_Pcontribute"),"ImageView")
	mark_jun_1:setVisible(false)
	if tonumber(tableMessDB["nMoneyType"]) == 3 then
		m_Pinkrevice:setVisible(true)
	end
	--获取奖励信息
	-- local imgId,RewardCount = CorpsData.GetScienceGaojiData(MessFlag["TechEffID1"])
	-- local imgPath ,GainName= CorpsData.GetRewardIconPath(imgId)
	--消耗信息
	-- local imgConsumId,ConsumCount = CorpsData.GetMessConsumeBigInfo(MessFlag["TechEffID1"])
	-- local imgConsumPath ,ConsumName= CorpsData.GetRewardIconPath(imgConsumId)

	print("雅座")
	local tabReward,tabConsum = CorpsMessHallData.GetRewardConsumID(MessFlag["TechEffID1"],4)

	local GainName = tabReward[1][1]["CoinName"]
	local imgPath = tabReward[1][1]["CoinPath"]
	local RewardCount = tabReward[1][1]["CoinNum"]

	local imgConsumPath = tabConsum.TabData[1]["IconPath"]
	local ConsumCount = tabConsum.TabData[1]["ItemNeedNum"]
	local ConsumName = CorpsMessHallData.GetCreateCorpsConsumName(tabConsum.TabData[1]["ConsumeType"])
	--添加文字及图片
	local ConText = Label:create()
	ConText:setFontSize(24)
	ConText:setFontName(CommonData.g_FONT1)
	ConText:setColor(ccc3(116,57,5))
	ConText:setPosition(ccp(-50,-20))
	ConText:setText("消耗"..ConsumName..":")
	image_pinkbg:addChild(ConText)

	local ConNumText = Label:create()
	ConNumText:setFontSize(24)
	ConNumText:setFontName(CommonData.g_FONT1)
	ConNumText:setColor(ccc3(116,57,5))
	ConNumText:setPosition(ccp(80,-20))
	ConNumText:setText(ConsumCount)
	image_pinkbg:addChild(ConNumText)

	local GainText = Label:create()
	GainText:setFontSize(24)
	GainText:setFontName(CommonData.g_FONT1)
	GainText:setColor(ccc3(116,57,5))
	GainText:setPosition(ccp(-50,-80))
	GainText:setText(GainName..":")
	image_pinkbg:addChild(GainText)

	local GainNumText = Label:create()
	GainNumText:setFontSize(24)
	GainNumText:setFontName(CommonData.g_FONT1)
	GainNumText:setColor(ccc3(116,57,5))
	GainNumText:setPosition(ccp(90,-80))
	GainNumText:setText(RewardCount)
	image_pinkbg:addChild(GainNumText)

	local pImg = ImageView:create()
	pImg:loadTexture(imgPath)
	pImg:setAnchorPoint(ccp(0,0))
	pImg:setScale(0.45)
	-- pImg:setOpacity(60)
	pImg:setPosition(ccp(25,-100))
	image_pinkbg:addChild(pImg)

	local pImgCon = ImageView:create()
	pImgCon:loadTexture(imgConsumPath)
	pImgCon:setAnchorPoint(ccp(0,0))
	pImgCon:setScale(0.45)
	-- pImgCon:setOpacity(60)
	pImgCon:setPosition(ccp(10,-40))
	image_pinkbg:addChild(pImgCon)

	local VIPLevel = server_mainDB.getMainData("vip")
	local vipLimit = CorpsData.GetVIPLimit(enumVIPFunction.eVipFunction_4)
	if tonumber(VIPLevel) < tonumber(vipLimit) then
		local pShadeVIP = ImageView:create()
		pShadeVIP:loadTexture("Image/imgres/common/tip_bk_02.png")
		pShadeVIP:setPosition(ccp(0,0))
		image_pinkbg:addChild(pShadeVIP)

		local pShadeWord = Label:create()		
		pShadeWord:setFontSize(36)
		pShadeWord:setFontName(CommonData.g_FONT1)
		pShadeWord:setColor(ccc3(116,57,5))
		pShadeWord:setText("VIP等级"..vipLimit.."级开启")
		pShadeVIP:addChild(pShadeWord)
	end

end

local function _Click_AddCount_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		sender:setScale(1.0)
		local buyCount = server_mainDB.getMainData("VipST")
		local cur_VIP = server_mainDB.getMainData("vip")
		local tabVIP = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_17)
		local function GoBuy( bState )
			if bState == true then
				if tonumber(server_mainDB.getMainData("gold")) < tabVIP["NeedNum"] then
					TipLayer.createTimeLayer("金币不足", 2)
					return
				end

				MainScene.BuyCountFunction(enumVIPFunction.eVipFunction_17,1,1,GetBuyCount)
			end
		end
		if tonumber(countFree) <= 0 then
			if tonumber(tabVIP["vipLimit"]) == 0 then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1634,ToVIP,tabVIP["nextVIP"])
				pTips = nil
			else
				local buyCount = server_mainDB.getMainData("VipST")
				
				if tonumber(buyCount) == 0 then
					if tonumber(most_Tap) == 1 then
						if tonumber(tabVIP.level) <= 0 then
							local pTips = TipCommonLayer.CreateTipLayerManager()
							pTips:ShowCommonTips(1644, ToVIP,tabVIP.nextVIP, tabVIP.nextNum)
							pTips = nil
						else
							local pTips = TipCommonLayer.CreateTipLayerManager()
							pTips:ShowCommonTips(1506, ToVIP,tabVIP.nextVIP, tabVIP.nextNum)
							pTips = nil
						end
					else
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1649, nil)
						pTips = nil
					end
				else
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1631,GoBuy,tabVIP["NeedNum"], tabVIP["name"], buyCount)
					pTips = nil
				end
			end
		else
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1075,nil)
			pTips = nil
		end
	elseif eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function initVars( value )
	--调整偏移

	imageBlackB = tolua.cast(MessHallLayer:getWidgetByName("Image_balckB"),"ImageView")
	imageBlackB:setVisible(false)
	imageBlackP = tolua.cast(MessHallLayer:getWidgetByName("Image_9"),"ImageView")
	imageBlackP:setVisible(false)
	imageBlackY = tolua.cast(MessHallLayer:getWidgetByName("Image_8"),"ImageView")
	imageBlackY:setVisible(false)

	--------------------------------------------------------------------------
	--食堂中不需要显示的文字
	local label_bcount = tolua.cast(MessHallLayer:getWidgetByName("Label_bword"),"Label")
	label_bcount:setVisible(false)
	--中级
	local label_ycount = tolua.cast(MessHallLayer:getWidgetByName("Label_yword"),"Label")
	label_ycount:setVisible(false)
	--高级
	local label_pcount = tolua.cast(MessHallLayer:getWidgetByName("Label_pword"),"Label")
	label_pcount:setVisible(false)
	----------------------------------------------------------------------------
	-- SetGlod(CommonData.g_MainDataTable.gold)
	-- SetSliver(CommonData.g_MainDataTable.silver)
	-- SetContribute(CommonData.g_MainDataTable.gold )
	-- SetTasle(CommonData.g_MainDataTable.gold )
	SetCorpsIcon(MessFlag.ResimgID)
	SetTitleText(MessFlag.TechName..":")
	local str = "小饭桌可以获得5个鸡腿，单间可以获得15个鸡腿，雅座可以获得25个鸡腿！！！"
	SetContentText(MessFlag["TechDes"])

	----------------------------------------------------------------------
	if tonumber(tableMessDB.nMoneyType) == 1 or tonumber(tableMessDB.nMoneyType) == 2 or tonumber(tableMessDB.nMoneyType) == 3 then
		countFree = 0
	end
	--剩余次数
	local label_countWord = tolua.cast(MessHallLayer:getWidgetByName("Label_countLabel"),"Label")
	label_count = tolua.cast(MessHallLayer:getWidgetByName("Label_count"),"Label")
	-- label_countWord:setVisible(false)
	label_countWord:setText("剩余领取次数:")
	label_count:setText(countFree)
	label_count:setColor(COLOR_Green)
	local btn_add = tolua.cast(MessHallLayer:getWidgetByName("Image_add"),"ImageView")
	btn_add:setTouchEnabled(true)
	pSpriteScience_least = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
	if tonumber(countFree) == 0 then
		SpriteSetGray(pSpriteScience_least,0)
	else
		SpriteSetGray(pSpriteScience_least,1)
	end
	btn_add:addTouchEventListener(_Click_AddCount_CallBack)
	----------------------------------------------------------------------
	--刷新时间
	label_time = tolua.cast(MessHallLayer:getWidgetByName("Label_time"),"Label")
	
	local scienceTime = tableMessDB.nMoneyCount
	local strHs = math.floor(scienceTime/3600)
	local strMs = math.floor(scienceTime/60) - strHs*60
	local strSs = math.floor(scienceTime%60)
	local strTemp = ""
	if tonumber(strHs) < 10 then strHs = "0" .. strHs end
	if tonumber(strMs) < 10 then strMs = "0" .. strMs end
	if tonumber(strSs) < 10 then strSs = "0" .. strSs end
	label_time:setText(strHs..":"..strMs .. ":" .. strSs)

	
	local function SetDelayTime(nSecend)
		if nSecend < 0 then return end
				
		local nDelayTime = nSecend
		local strH = math.floor(nSecend/3600)
		local strM = math.floor(nSecend/60) - strH*60
		local strS = math.floor(nSecend%60)
		if tonumber(strH) < 10 then strH = "0" .. strH end
		if tonumber(strM) < 10 then strM = "0" .. strM end
		if tonumber(strS) < 10 then strS = "0" .. strS end
		
		local function tick(dt)
			if nDelayTime == 0 then
				if m_timeHand ~= nil then
					MessHallLayer:getScheduler():unscheduleScriptEntry(m_timeHand)
					m_timeHand = nil
				end
			end
			nDelayTime = nDelayTime -1
			SetDelayTime(nDelayTime)
		end
		if m_timeHand == nil then
			m_timeHand = MessHallLayer:getScheduler():scheduleScriptFunc(tick, 1, false)
		end
		if m_timeHand ~= nil then
			label_time:setText(strH..":"..strM .. ":" .. strS)		
		end
	end
	SetDelayTime(scienceTime)

end

function GetHallLayer(  )
	return MessHallLayer
end

function CreateMessLayer( value ,tableMessLevel)
	initData()

	MessHallLayer = TouchGroup:create()
	MessHallLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMessHall.json"))

	tableMessDB = GetScienceHall()
	nlevel = tableMessLevel.m_nLevel
	if nlevel == nil then
		nlevel= 0
	end

	--local goldNum = tonumber(server_mainDB.getMainData("nCorps"))
	local tableMessData = technolog.getArrDataByField("TechnologyID","4")
	for key,value in pairs(tableMessData) do
		if CheckMessHallLV(nlevel,value) == true then
			MessFlag["TechnologyID"] = value[1]
			MessFlag["TechLv"] = value[2]
			MessFlag["ResimgID"] = value[3]
			MessFlag["TechName"] = value[4]
			MessFlag["TechDes"] = value[5]
			MessFlag["UpConditionID"] = value[6]
			MessFlag["UpConsumeID"] = value[7]
			MessFlag["ConsumeNum"] = value[8]
			MessFlag["TechEffID1"] = value[10]
		end
	end
	initVars()
	loadDinWriteCode(MessHallLayer,nlevel)
	loadSingleWriteCode(MessHallLayer,nlevel)
	loadPrivateWriteCode(MessHallLayer,nlevel)
	local btun_return = tolua.cast(MessHallLayer:getWidgetByName("Button_return"),"Button")
	btun_return:setPosition(ccp(btun_return:getPositionX() + nOff_X,btun_return:getPositionY() - nOff_Y))
	btun_return:addTouchEventListener(_Click_MessHall_CallBack)

	return MessHallLayer
end