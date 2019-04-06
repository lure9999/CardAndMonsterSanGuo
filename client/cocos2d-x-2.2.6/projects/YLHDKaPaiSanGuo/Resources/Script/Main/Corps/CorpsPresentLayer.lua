--FileName:CorpsPresentLayer
--Author:sixuechao
--Purpose:军团捐献界面
module("CorpsPresentLayer",package.seeall)
require "Script/serverDB/techeffect"
require "Script/serverDB/technolog"
require "Script/Main/Corps/CorpsPersentData"
require "Script/Main/Corps/CorpsTopLayer"
local mCorpsPresentLayer   = nil
local btn_bule       	   = nil
local btn_single     	   = nil
local btn_pink       	   = nil
local m_buleDonate         = nil
local m_YDonate            = nil
local m_PDonate            = nil
local image_Bulebg         = nil
local image_Pinkbg         = nil
local image_Ybg            = nil
local imageBlackB          = nil
local imageBlackY          = nil
local imageBlackP          = nil
local m_timeHand           = nil
local countFree            = 10
local scienceLevel         = 0
local scienceTime          = 0
local b_count              = 0
local y_count              = 0
local p_count              = 0
local label_count          = nil
local label_time           = nil
local m_timeHands          = nil
local label_bcount         = nil
local label_ycount         = nil
local label_pcount         = nil
local tableNum = {}
local MessFlag = {}
local tableMessData = {}

local nOff_X = CommonData.g_Origin.x
local nOff_Y = CommonData.g_Origin.y

local GetIconDataID = CorpsData.GetIconDataID
local CheckMessHallLV = CorpsLogic.CheckMessHallLV
local GetMainDataByKey = server_mainDB.getMainData
local GetDonateNum = CorpsPersentData.GetDonateNum
local GetBuyNumDonate = CorpsPersentData.GetBuyNumDonate

 local function initData(  )
 	mCorpsPresentLayer 	= nil
 	btn_bule       	  	= nil
	btn_single     	 	= nil
	btn_pink       	 	= nil
	m_buleDonate     	= nil
	m_YDonate        	= nil
	m_PDonate        	= nil
	image_Ybg        	= nil
	image_Pinkbg     	= nil
	image_Bulebg     	= nil
	imageBlackP      	= nil
	imageBlackY      	= nil
	imageBlackB      	= nil
	m_timeHand          = nil
	label_count         = nil
	label_time          = nil
	m_timeHands         = nil
	label_bcount        = nil
	label_ycount        = nil
	label_pcount        = nil
	countFree        	= 10
	scienceLevel     	= 0
	scienceTime         = 0
	b_count             = 0
	y_count             = 0
	p_count             = 0
	tableNum 		 	= {}
	MessFlag = {}
	tableMessData = {}
 end

local function SetCorpsIcon( nCorpsId )
	local image_kuang = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_60"),"ImageView")
	image_kuang:loadTexture("Image/imgres/common/color/wj_pz7.png")
	local Image_CorpsIcon = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_Corpsicon"),"ImageView")
	Image_CorpsIcon:setZOrder(-1)
	if tonumber(nCorpsId) > 0 then
		local iconPath = resimg.getFieldByIdAndIndex(nCorpsId,"icon_path")
		Image_CorpsIcon:loadTexture(iconPath)
	end
end

local function SetTitleText( strNum)
	local label_title = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_corpsLevel"),"Label")
	label_title:setColor(ccc3(233,180,114))
	label_title:setFontSize(24)
	label_title:setFontName(CommonData.g_FONT1)
	label_title:setText(strNum)
end

local function SetContentText( str )
	local label_Content = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_info"),"Label")
	label_Content:setColor(ccc3(233,180,114))
	label_Content:setFontSize(20)
	label_Content:setFontName(CommonData.g_FONT1)
	label_Content:setText(str)
end

local function GetCorpsMoney(  )
	local function GetSuccessCallback(  )
		NetWorkLoadingLayer.loadingHideNow()
		local tablePersonInfo = {}
		tablePersonInfo = CorpsData.GetCorpsPersonInfo()
	end
	Packet_CorpsPersonInfo.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsPersonInfo.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)
end

local function GetConteobiled(  )
	local function GetSuccessCallback(  )
		local tableMoney = CorpsData.GetCorpsInfo()
		for key,value in pairs(tableMoney) do
			--NetWorkLoadingLayer.loadingHideNow()
			local n_Gold = server_mainDB.getMainData("gold")
			local n_Sliver = server_mainDB.getMainData("silver")
			local n_SPris = server_mainDB.getMainData("Family_Prestige")
			CorpsTopLayer.SetGodMoney(n_Sliver)
			CorpsTopLayer.SetSliverMoney(n_Gold)
			CorpsTopLayer.SetCorpsMoney(value[11])
			CorpsTopLayer.SetContribute(n_SPris)
		end
	end
	Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
	--NetWorkLoadingLayer.loadingShow(true)
end

local function SaveCountUser( countFree )
 	CCUserDefault:sharedUserDefault():setIntegerForKey("countFree", countFree)
 end
local function GetCountUser(  )
	CCUserDefault:sharedUserDefault():getIntegerForKey("countFree")
end
local function UpdateTime( dt )
	local Curtime = os.date("*t")
	if tonumber(Curtime.hour) == 4 and tonumber(Curtime.min) >= 5 and tonumber(Curtime.sec) >= 0 then 
		SaveCountUser(10)
	end
end

local function _Click_MessHall_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		if m_timeHands ~= nil then
			mCorpsPresentLayer:getScheduler():unscheduleScriptEntry(m_timeHands)
		end
		mCorpsPresentLayer:setVisible(false)
		mCorpsPresentLayer:removeFromParentAndCleanup(true)
		mCorpsPresentLayer = nil
		GetConteobiled()
		-- initData()
		if tonumber(countFree) <= 0 then
			CorpsScene.DeleteRedPoint(4)
		else
			CorpsScene.loadPacket()
		end
		
	end
end

--前往充值界面
local function ToVIP()
	AudioUtil.PlayBtnClick()
	if m_timeHands ~= nil then
		mCorpsPresentLayer:getScheduler():unscheduleScriptEntry(m_timeHands)
	end
	mCorpsPresentLayer:setVisible(false)
	mCorpsPresentLayer:removeFromParentAndCleanup(true)
	mCorpsPresentLayer = nil
	GetConteobiled()
	initData()
	MainScene.GoToVIPLayer(2)
end

local function _Click_Revice_CallBack( sender,eventType )
	local btn_total = tolua.cast(sender,"Button")
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		-- CorpsScene.GetCorpsMoney()
		local pTag = sender:getTag()
		local donateID = tonumber(pTag)
		-- btn_single:setVisible(false)
		-- btn_pink:setVisible(false)
		-- btn_bule:setVisible(false)
		local VIPLevel = server_mainDB.getMainData("vip")
		
		if donateID == 3 then
			local vipLimit = CorpsData.GetVIPLimit(enumVIPFunction.eVipFunction_3)
			if tonumber(VIPLevel) < tonumber(vipLimit) then
				-- TipLayer.createTimeLayer("领取VIP等级不足",2)
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1634,ToVIP,vipLimit)
				pTips = nil
				return
			end
		end
		if countFree ~= nil and tonumber(countFree) >0 then
			local function GetSuccessCallback()
				NetWorkLoadingLayer.loadingHideNow()
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1446,nil)
				pTips = nil
				countFree = countFree - 1
				-- LabelLayer:setText(label_count,countFree)
				label_count:setText(countFree)
				if pTag == 1 then
					b_count = b_count + 1
					label_bcount:setText(b_count)
				elseif pTag == 2 then
					y_count = y_count + 1
					label_ycount:setText(y_count)
				elseif pTag == 3 then
					p_count = p_count + 1
					label_pcount:setText(p_count)
				end
				SaveCountUser(countFree)
				if tonumber(countFree) <= 0 then
					btn_pink:setVisible(false)
					btn_single:setVisible(false)
					btn_bule:setVisible(false)
					btn_bule:setTouchEnabled(false)
					btn_single:setTouchEnabled(false)
					btn_pink:setTouchEnabled(false)
					local btn_add = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_add"),"ImageView")
					btn_add:setTouchEnabled(true)
					local pSpriteScience_least = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
					SpriteSetGray(pSpriteScience_least,0)
				end
				GetConteobiled()														
			end		
			Packet_CorpsScienceDonate.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_CorpsScienceDonate.CreatePacket(donateID))
			NetWorkLoadingLayer.loadingShow(true)
		else
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1053,nil)
			pTips = nil
		end
	end
end

local function loadBtnControle(pControle )
	pControle:addTouchEventListener(_Click_Revice_CallBack)
end

function UpdateData(  )
	SetCorpsIcon(MessFlag.ResimgID)
	local strtitle = "军团慈善"
	SetTitleText(MessFlag.TechName..":")
	SetContentText(MessFlag["TechDes"])
end

--添加消耗及奖励
local function PrimaryDonateData( m_baseLayer,tabReward1,tabReward2,tabConsum,nGrid )
	---------------------------------------------------------------------------------------------------
	--消耗信息
	local str_word = nil
	local str_num = nil
	coin_path = nil
	if tonumber(tabConsum) == 0 then
		str_word = "银币"
		str_num  = 0
		coin_path = "Image/imgres/common/silver.png"
	else
		str_word = CorpsPersentData.GetRewardName(tabConsum["ConsumeType"])
		str_num  = tabConsum["ItemNeedNum"]
		coin_path = tabConsum["IconPath"]
	end
	local ConsumeText = Label:create()
	ConsumeText:setFontSize(24)
	ConsumeText:setFontName(CommonData.g_FONT1)
	ConsumeText:setColor(ccc3(116,57,5))
	ConsumeText:setPosition(ccp(-50,0))
	ConsumeText:setText("慷慨馈赠"..str_word)
	m_baseLayer:addChild(ConsumeText)

	local ConsumeNumText = Label:create()
	ConsumeNumText:setFontSize(24)
	ConsumeNumText:setFontName(CommonData.g_FONT1)
	ConsumeNumText:setColor(ccc3(116,57,5))
	ConsumeNumText:setText(str_num)
	ConsumeNumText:setPosition(ccp(95,0))
	m_baseLayer:addChild(ConsumeNumText)

	local pConsumeImg = ImageView:create()
	pConsumeImg:loadTexture(coin_path)
	pConsumeImg:setAnchorPoint(ccp(0,0))
	pConsumeImg:setScale(0.40)
	-- pImg:setOpacity(60)
	pConsumeImg:setPosition(ccp(27,-15))
	m_baseLayer:addChild(pConsumeImg)
	------------------------------------------------------------------------------------------------------
	--捐献奖励
	local RewardshengwangText = Label:create()
	RewardshengwangText:setFontSize(24)
	RewardshengwangText:setFontName(CommonData.g_FONT1)
	RewardshengwangText:setColor(ccc3(116,57,5))
	RewardshengwangText:setText("增加"..tabReward1["CoinName"])
	RewardshengwangText:setPosition(ccp(-50,-40))
	m_baseLayer:addChild(RewardshengwangText)

	local ShengwangNumText = Label:create()
	ShengwangNumText:setFontSize(24)
	ShengwangNumText:setFontName(CommonData.g_FONT1)
	ShengwangNumText:setColor(ccc3(116,57,5))
	ShengwangNumText:setPosition(ccp(85,-40))
	ShengwangNumText:setText(tabReward1["CoinNum"])
	m_baseLayer:addChild(ShengwangNumText)

	local pshengwangImg = ImageView:create()
	pshengwangImg:loadTexture(tabReward1["CoinPath"])
	pshengwangImg:setAnchorPoint(ccp(0,0))
	pshengwangImg:setScale(0.4)
	-- pImg:setOpacity(60)
	pshengwangImg:setPosition(ccp(27,-55))
	m_baseLayer:addChild(pshengwangImg)

	if tabReward2 ~= nil then
	local RewardCorpsMoneyText = Label:create()
	RewardCorpsMoneyText:setFontSize(24)
	RewardCorpsMoneyText:setFontName(CommonData.g_FONT1)
	RewardCorpsMoneyText:setColor(ccc3(116,57,5))
	RewardCorpsMoneyText:setPosition(ccp(-50,-80))
	RewardCorpsMoneyText:setText("增加"..tabReward2["CoinName"])
	m_baseLayer:addChild(RewardCorpsMoneyText)

	local CorpsMoneyNumText = Label:create()
	CorpsMoneyNumText:setFontSize(24)
	CorpsMoneyNumText:setFontName(CommonData.g_FONT1)
	CorpsMoneyNumText:setColor(ccc3(116,57,5))
	CorpsMoneyNumText:setPosition(ccp(92,-80))
	CorpsMoneyNumText:setText(tabReward2["CoinNum"])
	m_baseLayer:addChild(CorpsMoneyNumText)

	local pCorpsMoneyImg = ImageView:create()
	pCorpsMoneyImg:loadTexture(tabReward2["CoinPath"])
	pCorpsMoneyImg:setAnchorPoint(ccp(0,0))
	pCorpsMoneyImg:setScale(0.4)
	pCorpsMoneyImg:setPosition(ccp(27,-95))
	m_baseLayer:addChild(pCorpsMoneyImg)

	if nGrid == 3 then
		local VIPLevel = server_mainDB.getMainData("vip")
		local vipLimit = CorpsData.GetVIPLimit(enumVIPFunction.eVipFunction_3)
		if tonumber(VIPLevel) < tonumber(vipLimit) then
			local pShadeVIP = ImageView:create()
			pShadeVIP:loadTexture("Image/imgres/common/tip_bk_02.png")
			pShadeVIP:setPosition(ccp(0,0))
			m_baseLayer:addChild(pShadeVIP)

			local pShadeWord = Label:create()		
			pShadeWord:setFontSize(36)
			pShadeWord:setFontName(CommonData.g_FONT1)
			pShadeWord:setColor(ccc3(116,57,5))
			pShadeWord:setText("VIP等级"..vipLimit.."级开启")
			pShadeVIP:addChild(pShadeWord)
		end
	end
	end
end

local function GetBuyCount(  )
	GetConteobiled()
	local globNum = GetDonateNum()
	local tab = GetBuyNumDonate()
	countFree = tonumber(globNum) - tonumber(tab["nMoneyType"])
	if tonumber(countFree) > 0 then
		local btn_add = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_add"),"ImageView")
		btn_add:setTouchEnabled(true)
		pSpriteScience_least = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
		SpriteSetGray(pSpriteScience_least,0)
		btn_pink:setVisible(true)
		btn_single:setVisible(true)
		btn_bule:setVisible(true)
		btn_bule:setTouchEnabled(true)
		btn_single:setTouchEnabled(true)
		btn_pink:setTouchEnabled(true)
		label_count:setText(countFree)
	end
end

local function _Click_AddCount_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		AudioUtil.PlayBtnClick()
		local buyCount = server_mainDB.getMainData("VipJT")
		local cur_VIP = server_mainDB.getMainData("vip")
		local tabVIP = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_16)
		
		local function GoBuy( bState )
			if bState == true then
				if tonumber(server_mainDB.getMainData("gold")) < tabVIP["NeedNum"] then
					TipLayer.createTimeLayer("金币不足", 2)
					return
				end

				MainScene.BuyCountFunction(enumVIPFunction.eVipFunction_16,1,1,GetBuyCount)
			end
		end
		if tonumber(countFree) <= 0 then
			if tonumber(tabVIP["vipLimit"]) == 0 then
				
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1634,ToVIP,tabVIP["nextVIP"])
				pTips = nil
			else
				local buyCount = server_mainDB.getMainData("VipJT")
				if tonumber(buyCount) == 0  then
					if tonumber(most_Tap) == 1  then --tonumber(cur_VIP) < tonumber(tabVIP.nextVIP)
						if tonumber(tabVIP.level) <= 0 then
							local pTips = TipCommonLayer.CreateTipLayerManager()
							pTips:ShowCommonTips(1644, ToVIP,tabVIP.nextVIP, tabVIP.nextNum)
							pTips = nil
						else
							local pTips = TipCommonLayer.CreateTipLayerManager()
							pTips:ShowCommonTips(1506, ToVIP, tabVIP.nextVIP, tabVIP.nextNum)
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

local function initVars(  )
	--调整偏移


	imageBlackP = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_9"),"ImageView")
	imageBlackP:setVisible(false)
	imageBlackY = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_8"),"ImageView")
	imageBlackY:setVisible(false)
	imageBlackB = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_balckB"),"ImageView")
	imageBlackB:setVisible(false)

	local m_countwordText = LabelLayer.createStrokeLabel(18, CommonData.g_FONT3, "剩余捐献次数:", ccp(0, 0), COLOR_Black, ccc3(233,180,114), true, ccp(0, -2), 2)   
	local label_countWord = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_countLabel"),"Label")
	-- label_countWord:addChild(m_countwordText)
	label_countWord:setText("剩余捐献次数:")
	local m_countText = LabelLayer.createStrokeLabel(18, CommonData.g_FONT3, countFree, ccp(0, 0), COLOR_Black, COLOR_Green, true, ccp(0, -2), 2)   
	label_count = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_count"),"Label")
	--label_count:addChild(m_countText)
	if tonumber(countFree) == nil or tonumber(countFree) == 0 then
		label_count:setText(0)
	else
		label_count:setText(countFree)
	end
	label_count:setColor(COLOR_Green)
	----
	local btn_add = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_add"),"ImageView")
	btn_add:setTouchEnabled(true)
	pSpriteScience_least = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
	if tonumber(countFree) == 0 then
		SpriteSetGray(pSpriteScience_least,0)
	else
		SpriteSetGray(pSpriteScience_least,1)
	end
	btn_add:addTouchEventListener(_Click_AddCount_CallBack)
	------------------------------------------------------
	--各个级别捐献次数
	--初级
	label_bcount = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_bcount"),"Label")
	label_bcount:setText(b_count)
	--中级
	label_ycount = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_ycount"),"Label")
	label_ycount:setText(y_count)
	--高级
	label_pcount = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_pcount"),"Label")
	label_pcount:setText(p_count)


	label_time = tolua.cast(mCorpsPresentLayer:getWidgetByName("Label_time"),"Label")

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
				if m_timeHands ~= nil then
					mCorpsPresentLayer:getScheduler():unscheduleScriptEntry(m_timeHands)
					m_timeHands = nil
				end
				return 
			end
			nDelayTime = nDelayTime -1
			SetDelayTime(nDelayTime)
		end
		if m_timeHands == nil then
			m_timeHands = mCorpsPresentLayer:getScheduler():scheduleScriptFunc(tick, 1, false)
		else
			label_time:setText(strH..":"..strM .. ":" .. strS)
		end
	end
	SetDelayTime(scienceTime)
	-------------------------------------------------------------------------------------------------------------------------
	--pink
	image_Pinkbg = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_pink"),"ImageView")
	local image_pinkTop = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_pinkTop"),"ImageView")
	image_pinkTop:loadTexture("Image/imgres/corps/gongdeiwuliang.png")
	--image_pinkTop:setSize(CCSize(122,31))
	image_pinkTop:setScaleX(1.2)
	image_pinkTop:setScaleY(0.65)
	local image_PContent = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_pinkcontent"),"ImageView")
	image_PContent:loadTexture("Image/imgres/corps/mostMoney.png")
	image_PContent:setScale(0.7)
	local btnText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "捐献", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, 0), 0)
	btn_pink = tolua.cast(mCorpsPresentLayer:getWidgetByName("Button_pink"),"Button")
	btn_pink:setTag(3)
	btn_pink:addChild(btnText)
	loadBtnControle(btn_pink)
	local m_Pinkrevice = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_pinkRevice"),"ImageView")
	m_Pinkrevice:setVisible(false)
	m_PDonate = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_Pcontribute"),"ImageView")
	m_PDonate:setVisible(false)

	---------------------------------------------------------------------------------------------------------------------------
	image_Ybg = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_yellowbg"),"ImageView")
	local image_yellowTop = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_yellowtop"),"ImageView")
	image_yellowTop:loadTexture("Image/imgres/corps/leshanghaoshi.png")
	--image_yellowTop:setSize(CCSize(123,32))
	image_yellowTop:setScaleX(1.4)
	image_yellowTop:setScaleY(0.65)
	local image_yContent = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_yellowContent"),"ImageView")
	image_yContent:loadTexture("Image/imgres/corps/moreManey.png")
	image_yContent:setScale(0.8)
	local btnText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "捐献", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, 0), 0)
	btn_single = tolua.cast(mCorpsPresentLayer:getWidgetByName("Button_yellow"),"Button")
	btn_single:setTag(2)
	btn_single:addChild(btnText)
	loadBtnControle(btn_single)

	local m_SingleRevice = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_yellowRevice"),"ImageView")
	m_SingleRevice:setVisible(false)
	m_YDonate = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_YContribute"),"ImageView")
	m_YDonate:setVisible(false)

	-------------------------------------------------------------------------------------------------------------------------------
	image_Bulebg = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_bulebg"),"ImageView")
	local image_switchTop = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_switchbuleTop"),"ImageView")
	image_switchTop:loadTexture("Image/imgres/corps/xiaoxiaoxinyi.png")
	image_switchTop:setScaleX(1.2)
	image_switchTop:setScaleY(0.65)
	--image_switchTop:setSize(CCSize(122,31))
	local image_buleContent = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_buleContent"),"ImageView")
	image_buleContent:loadTexture("Image/imgres/corps/money.png")
	--image_buleContent:setScale(0.8)
	image_buleContent:setSize(CCSize(107,95))
	image_buleContent:setScale(0.9)
	--image_buleContent:setRotation(15)
	image_buleContent:setPosition(ccp(-3,90))
	local btnText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "捐献", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, 0), 0)
	btn_bule = tolua.cast(mCorpsPresentLayer:getWidgetByName("Button_bule"),"Button")
	btn_bule:setTag(1)
	btn_bule:addChild(btnText)
	loadBtnControle(btn_bule)

	local m_DinRevice = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_buleRevice"),"ImageView")
	m_DinRevice:setVisible(false)
	m_buleDonate = tolua.cast(mCorpsPresentLayer:getWidgetByName("Image_ConRevice"),"ImageView")
	m_buleDonate:setVisible(false)

	------------------------------------
	--初级
	local tab_CMoney,tab_CCon,tab_consum = CorpsPersentData.GetMessConsumePrimaryInfo(MessFlag["TechEffID1"],2)
	
	PrimaryDonateData(image_Bulebg,tab_CMoney,tab_CCon,tab_consum,1)
	

	---------------------------------------------------------------------------------------------------------------
	--中级
	local tab_CMoney2,tab_CCon2,tab_consum2 = CorpsPersentData.GetMessConsumePrimaryInfo(MessFlag["TechEffID1"],3)
	
	PrimaryDonateData(image_Ybg,tab_CMoney2,tab_CCon2,tab_consum2,2)
	-------------------------------------------------------------------------------------------------------------------------------------
	--高级
	local tab_CMoney3,tab_CCon3,tab_consum3 = CorpsPersentData.GetMessConsumePrimaryInfo(MessFlag["TechEffID1"],4)
	
	PrimaryDonateData(image_Pinkbg,tab_CMoney3,tab_CCon3,tab_consum3,3)
	---------------------------------------------------------------------------------------------------------------------------------------
	if tonumber(countFree) == nil or tonumber(countFree) == 0 then
		btn_bule:setVisible(false)
		btn_bule:setTouchEnabled(false)
		btn_pink:setVisible(false)
		btn_pink:setTouchEnabled(false)
		btn_single:setVisible(false)
		btn_single:setTouchEnabled(false)
	end

end



function CreatePresentLayer( valueDB ,tableDonateValue)
	
 	initData()

 	mCorpsPresentLayer = TouchGroup:create()
	mCorpsPresentLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMessHall.json"))

 	scienceLevel = tableDonateValue.m_nLevel
 	scienceTime = valueDB.nMoneyCount
 	b_count = valueDB.nIntervalTime -- 小小心意捐献次数
 	y_count = valueDB.nMaxLimite -- 乐善好施捐献次数
 	p_count = valueDB.nCurCount --共得无量捐献次数
 	local CurCount = valueDB.nMoneyType
 	local DonateNum = GetDonateNum()
 	countFree = DonateNum - CurCount

 	tableMessData = technolog.getArrDataByField("TechnologyID","5")
	for key,value in pairs(tableMessData) do
		if CheckMessHallLV(scienceLevel,value) == true then
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

	local btun_return = tolua.cast(mCorpsPresentLayer:getWidgetByName("Button_return"),"Button")
	btun_return:setPosition(ccp(btun_return:getPositionX() + nOff_X,btun_return:getPositionY() - nOff_Y))
	btun_return:addTouchEventListener(_Click_MessHall_CallBack)

	UpdateData()

	return mCorpsPresentLayer
 end
