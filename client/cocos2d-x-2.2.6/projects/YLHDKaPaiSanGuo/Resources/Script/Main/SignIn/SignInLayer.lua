module("SignInLayer",package.seeall)
require "Script/Main/SignIn/SignInData"
require "Script/Main/SignIn/SignInLogic"
require "Script/Main/ChargeVIP/ChargeVIPLayer"

local SINGLROWITEMCOUNT = 2
local m_SignInLayer    	= nil
local image_VIP       	= nil
local ScrollView_Daily  = nil
local listView_Daily    = nil
local label_wordDay     = nil
local m_array_icon      = nil
local m_signNum         = 0
local m_dayNum          = 0
local m_showInfo        = 0
local is_luxury         = false
local tab_curMonth = {}
local tab_monNum    = {}
local tab_lux = {}

local YETSIGNIN_IMAGE = "Image/imgres/signIn/AlreadySign.png"
local ISSIGNINLUXURY = "Image/imgres/button/btn_red.png"
local BLACKSIGN = "Image/imgres/common/common_black.png"

--逻辑
local SaveLuxuryIsFirst = SignInLogic.SaveLuxuryIsFirst
local GetLuxuryIsFirst = SignInLogic.GetLuxuryIsFirst
local GetLuxuryInfo = SignInData.GetLuxuryInfo-- 豪华签到
local GetDailyInfo  = SignInData.GetDailyInfo -- 日常签到
local GetSignInNum  = SignInData.GetSignInNum -- 签到次数
local GetDailyStatus = SignInData.GetDailyStatus -- 日常签到状态
local GetLuxurtStatus = SignInData.GetLuxurtStatus -- 豪华签到状态
local JudgeSignInStatus = SignInData.JudgeSignInStatus
local GetMonthDayNum = SignInData.GetMonthDayNum
local ShowRewardLayer = SignInLogic.ShowRewardLayer
local GetItemTypeByINdex = SignInData.GetItemTypeByINdex

local function InitData(  )
	m_SignInLayer   	= nil
	image_VIP           = nil
	ScrollView_Daily    = nil
	m_dayNum            = 0
	m_signNum           = 0
	m_showInfo          = nil
	label_wordDay       = nil
	listView_Daily      = nil
	is_luxury           = false
	tab_curMonth = {}
	tab_monNum           = {}
	tab_lux 			= {}
end

local function _Click_retrunMain_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		local signInStatus = JudgeSignInStatus()
		if signInStatus == true then
		else
			if MainScene.GetControlUI() ~= nil then
				MainScene.DeleteSignInStatus()
			end
		end
		m_SignInLayer:setVisible(false)
		m_SignInLayer:removeFromParentAndCleanup(true)
		m_SignInLayer = nil
		InitData()
		MainScene.PopUILayer()
	end
end
--VIP等级
local function GetVIPLevel( nNumber )
	local pText = LabelBMFont:create()
		
	pText:setFntFile("Image/imgres/common/num/number_vip.fnt")
	-- pText:setScale(0.7)
	pText:setPosition(ccp(17,0))
	pText:setAnchorPoint(ccp(0.5,0.5))
	pText:setText(nNumber)
	image_VIP:addChild(pText,0,1000)
end

--显示物品的信息
local function ShowGoodsInfo( nDayID)
	if m_showInfo == nil then
		m_showInfo = TouchGroup:create()
	    m_showInfo:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/SignInData.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_showInfo, layerSignInData_tag, layerSignInData_tag)
	end
	local img_icon = tolua.cast(m_showInfo:getWidgetByName("Image_icon"),"ImageView")
	-- local label_goods = tolua.cast(m_showInfo:getWidgetByName("Label_wupin"),"Label")
	local label_name = tolua.cast(m_showInfo:getWidgetByName("Label_name"),"Label")
	local label_num = tolua.cast(m_showInfo:getWidgetByName("Label_num"),"Label")
	local label_curNum = tolua.cast(m_showInfo:getWidgetByName("Label_curNum"),"Label")
	local label_content = tolua.cast(m_showInfo:getWidgetByName("Label_content"),"Label")
	local label_word = tolua.cast(m_showInfo:getWidgetByName("Label_Word2"),"Label")
	local img_VIP = tolua.cast(m_showInfo:getWidgetByName("Image_42"),"ImageView")
	local label_vipreward = tolua.cast(m_showInfo:getWidgetByName("Label_vipreward"),"Label")
	local label_1 = tolua.cast(m_showInfo:getWidgetByName("Label_71"),"Label")
	local label_2 = tolua.cast(m_showInfo:getWidgetByName("Label_57"),"Label")

	
	--根据点击tag获取相应的信息,奖励ID和奖励数量
	if tonumber(nDayID) > 31 then
		local RewardID = nDayID
		local  tab = SignInData.GetRewardInfoByID2(tonumber(RewardID))
		local item_type = GetItemTypeByINdex(RewardID)

		local num = 0
		if tonumber(item_type) == 6 then
			local is_cunzai = server_generalDB.GetIsHaveWJ(RewardID)
			if is_cunzai == true then
				num = 1
			else
				num = 0
			end
		else
			num = server_itemDB.GetItemNumberByTempId(tonumber(RewardID))
		end
		
		label_name:setText(tab[2])
		label_content:setText(tab[7])
		label_curNum:setText(num)
		if tonumber(RewardID) == tonumber(tab_lux[1]["is_item"]) then
			label_num:setText(tab_lux[1]["num"])
			if tonumber(tab_lux[1]["is_coin"]) ~= 0 then
				UIInterface.MakeHeadIcon(img_icon,ICONTYPE.COIN_ICON,RewardID,nil,nil,nil,7,nil)
			else
				UIInterface.MakeHeadIcon(img_icon,ICONTYPE.ITEM_ICON,RewardID,nil,nil,nil,6,nil)
			end
		else
			label_num:setText(tab_lux[2]["num"])

			if tonumber(tab_lux[2]["is_coin"]) ~= 0 then
				UIInterface.MakeHeadIcon(img_icon,ICONTYPE.COIN_ICON,RewardID,nil,nil,nil,7,nil)
			else
				UIInterface.MakeHeadIcon(img_icon,ICONTYPE.ITEM_ICON,RewardID,nil,nil,nil,6,nil)
			end
		end

		label_vipreward:setVisible(false)
		img_VIP:setVisible(false)
		label_1:setVisible(false)
		label_word:setVisible(false)
		
	else
		local RewardID,RewardNUm,VIP_Level,VIP_beishu = nil
		local tabGrid = {}
		tabGrid = tab_monNum[nDayID]
		local tabGrid_reward = RewardLogic.GetRewardTable(tabGrid["NPointRewID"])
		local RewardID = SignInData.GetRewardInfoDataByDay(tabGrid["NPointRewID"])
	
		if next(tabGrid_reward[1]) ~= nil then
			RewardID,RewardNUm,VIP_Level,VIP_beishu = SignInData.GetRewardInfoByDay(nDayID)
			-- local vipStr = SignInData.GetVIPStr(VIP_beishu)
			label_num:setText(tabGrid_reward[1][1]["CoinNum"])
			label_word:setText("本月第"..nDayID.."次签到可以领取此次奖励")
		else
			label_num:setText(tabGrid_reward[2][1]["ItemNum"])
			label_word:setText("本月第"..nDayID.."次签到可以领取此次奖励")
		end
		
		local tabRewards = {}
		local num = nil
		--图标
		if next(tabGrid_reward[1]) ~= nil then
			UIInterface.MakeHeadIcon(img_icon,ICONTYPE.COIN_ICON,RewardID,nil,nil,nil,7,nil)	
			tabRewards,cur_num = SignInData.GetRewardInfoByID1(tonumber(RewardID))
			label_name:setText(tabRewards[1])
			label_content:setText("获得一定量的货币")
			-- label_curNum:setText(cur_num)
			local nMessText2 = "|color|233,180,114||size|18|".."当前拥有:".."|color|25,254,235||size|18|"..cur_num.."|color|233,180,114||size|18|".."个"
			local messContentItem2 = RichLabel.Create(nMessText2,250,nil,nil,1)
			messContentItem2:setPosition(ccp(-115,10))		
			label_curNum:addChild(messContentItem2)
			label_2:setVisible(false)
		else
			if tonumber(RewardID)<1 then
				return 
			end
			UIInterface.MakeHeadIcon(img_icon,ICONTYPE.ITEM_ICON,RewardID,nil,nil,nil,6,nil)
			tabRewards = SignInData.GetRewardInfoByID2(tonumber(RewardID))
			label_name:setText(tabRewards[2])
			label_content:setText(tabRewards[7])
			num = server_itemDB.GetItemNumberByTempId(tonumber(RewardID))
			-- label_curNum:setText(num)
			local nMessText2 = "|color|233,180,114||size|18|".."当前拥有:".."|color|25,254,235||size|18|"..num.."|color|233,180,114||size|18|".."个"
			local messContentItem2 = RichLabel.Create(nMessText2,250,nil,nil,1)
			messContentItem2:setPosition(ccp(-115,10))		
			label_curNum:addChild(messContentItem2)
		end
		--VIP功能
		local vipLevel,daily_Double,luxury_Double = GetMonthDayNum(nDayID)
		local strVIP = SignInData.GetVIPStr(nDayID)
		label_vipreward:setText("可以领取"..strVIP.."倍奖励)")
		--VIP
		local VIPLevel = SignInData.GetVIPLimitLevel()
		local pText = LabelBMFont:create()
		pText:setFntFile("Image/imgres/common/num/number_vip.fnt")
		-- pText:setScale(0.7)
		pText:setPosition(ccp(17,0))
		pText:setAnchorPoint(ccp(0.5,0.5))
		pText:setText(vipLevel)
		img_VIP:addChild(pText,0,1000)
		if tonumber(vipLevel) <= 0 then
			label_vipreward:setVisible(false)
			img_VIP:setVisible(false)
			label_1:setVisible(false)
		end
	end

	local function _Click_DeleteInfoLayer_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if m_showInfo ~= nil then
		  		m_showInfo:setVisible(false)
		  		m_showInfo:removeFromParentAndCleanup(true)
		  		m_showInfo = nil
		  		ScrollView_Daily:setTouchEnabled(true)
	  		end
		end
	end
	local panel_info = tolua.cast(m_showInfo:getWidgetByName("Panel_79"),"Layout")
	panel_info:addTouchEventListener(_Click_DeleteInfoLayer_CallBack)
end

local function _Click_showInfo_CallBack( sender,eventType )
	
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local p_taginfo = sender:getTag()
  		-- sender:setScale(1.0)
  		ShowGoodsInfo(p_taginfo)
  		ScrollView_Daily:setTouchEnabled(false)
    elseif  eventType == TouchEventType.began then
     	-- sender:setScale(0.9)
    elseif eventType == TouchEventType.canceled then
    	-- sender:setScale(1.0)
    elseif eventType == TouchEventType.moved then
    	
    end
end

--豪华签到
local function LuxurySignIn(  )
	local Panel_luxury = tolua.cast(m_SignInLayer:getWidgetByName("Panel_luxury"),"Layout")
	-- local btn_Lux = tolua.cast(m_SignInLayer:getWidgetByName("Button_luxury"),"Button")
	local img_btn_lux = tolua.cast(m_SignInLayer:getWidgetByName("Image_button"),"ImageView")
	image_VIP = tolua.cast(m_SignInLayer:getWidgetByName("Image_VIP"),"ImageView")
	local ScrollView_luxury = tolua.cast(m_SignInLayer:getWidgetByName("ScrollView_luxury"),"ScrollView")
	local label_luxStatus = tolua.cast(m_SignInLayer:getWidgetByName("Label_lux"),"Label")
	label_luxStatus:setVisible(false)
	if ScrollView_luxury ~= nil then
		ScrollView_luxury:setClippingType(1)
	end
	ScrollView_luxury:removeAllChildrenWithCleanup(true)
	------------------------------------------------------------------------------------------------------
	--VIP签到奖励信息
	local VIPnum ,rewardNum1,rewardNum2,rewardicon1,rewardName1,rewardicon2,rewardName2,rf,rf,tabreWard = SignInData.GetVIPLimitLevel()
	------------------------------------------------------------------------------------------------------
	GetVIPLevel(VIPnum)
	
	tab_lux = GetLuxuryInfo()
	-- printTab(tab_lux)
	-- Pause()
	for key,value in pairs(tab_lux) do
		local img_pp = ImageView:create()
		img_pp:setScale(0.7)
		img_pp:setPosition(ccp(45+95*(key-1),45))
		local pControl = nil
		if tonumber(value["is_coin"]) == 0 then
			pControl = UIInterface.MakeHeadIcon(img_pp,ICONTYPE.ITEM_ICON,tonumber(value["is_item"]),nil,nil,nil,3,nil)
			pControl:setTag(tonumber(value["is_item"]))
		else
			pControl = UIInterface.MakeHeadIcon(img_daily,ICONTYPE.COIN_ICON,tonumber(value["is_item"]),nil,nil,nil,nil,nil)
			pControl:setTag(tonumber(value["is_coin"]))		
		end
		
		pControl:addTouchEventListener(_Click_showInfo_CallBack)
		ScrollView_luxury:addChild(img_pp)
	end
	--个人信息VIP
	local personVIP = server_mainDB.getMainData("vip")
	--豪华签到响应事件
	local function _Click_LuxurySign_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if personVIP < tonumber(VIPnum) then
				print("前往充值")
				m_SignInLayer:setVisible(false)
				m_SignInLayer:removeFromParentAndCleanup(true)
				m_SignInLayer = nil
				-- InitData()
				MainScene.PopUILayer()
				MainScene.GoToVIPLayer(1)
			else
				print("豪华签到")
				local function GetSuccessfull(  )
					NetWorkLoadingLayer.loadingHideNow()
					local tabLuxItem = {}
					local tabLuxCoin = {}
					for key,value in pairs(tab_lux) do
						local tabChild = {}
						if tonumber(value["is_coin"]) == 0 then
							tabChild[1] = value["is_item"]
							tabChild[2] = value["num"]
							table.insert(tabLuxItem,tabChild)
						elseif tonumber(value["is_coin"]) ~= 0 then
							tabChild[1] = value["is_coin"]
							tabChild[2] = value["num"]
							table.insert(tabLuxCoin,tabChild)
						end
					end
					local function _ClickTouch( )
						
					end
					if table.getn(tabLuxCoin) ~= 0 and table.getn(tabLuxItem) == 0 then
						ShowRewardLayer(nil,tabLuxCoin,_ClickTouch)
					elseif table.getn(tabLuxCoin) ~= 0 and table.getn(tabLuxItem) ~= 0 then
						ShowRewardLayer(tabLuxItem,tabLuxCoin,_ClickTouch)
					elseif table.getn(tabLuxCoin) == 0 and table.getn(tabLuxItem) ~= 0 then
						ShowRewardLayer(tabLuxItem,nil,_ClickTouch)
					end
					local function GetLuxSuccessCallBack(  )
						-- NetWorkLoadingLayer.loadingHideNow()
						-- LuxurySignIn()
						local lux_status = GetLuxurtStatus()
						if lux_status == 1 then
							img_btn_lux:setVisible(false)
							img_btn_lux:setTouchEnabled(false)
							label_luxStatus:setVisible(true)
						else
							img_btn_lux:setTouchEnabled(true)
						end
					end
					Packet_SignInReward.SetSuccessCallBack(GetLuxSuccessCallBack)
					network.NetWorkEvent(Packet_SignInReward.CreatePacket())
					-- NetWorkLoadingLayer.loadingShow(true)
				end
				Packet_SignInLuxury.SetSuccessCallBack(GetSuccessfull)
				network.NetWorkEvent(Packet_SignInLuxury.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)

			end
		end
	end
	local labelBtnText = nil
	if personVIP < tonumber(VIPnum) then
		labelBtnText = LabelLayer.createStrokeLabel(22, CommonData.g_FONT1, "前往充值", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
		img_btn_lux:loadTexture(ISSIGNINLUXURY)
	else
		labelBtnText = LabelLayer.createStrokeLabel(22, CommonData.g_FONT1, "豪华签到", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
		
	end
	local lux_status = GetLuxurtStatus()
	if lux_status == 1 then
		img_btn_lux:setVisible(false)
		img_btn_lux:setTouchEnabled(false)
		label_luxStatus:setVisible(true)
	else
		img_btn_lux:setTouchEnabled(true)
	end
	
	img_btn_lux:addChild(labelBtnText)
	img_btn_lux:addTouchEventListener(_Click_LuxurySign_CallBack)
end

local function SortImgpath( tabDailyValue,mm_dayNum,nTypeNum )
	local lineMaxNum = math.ceil(mm_dayNum/5)
	local lineMinNum = math.floor(mm_dayNum/5)
	local residum = mm_dayNum - lineMinNum*5
	for i=1,lineMaxNum  do
		if (lineMaxNum - i) == 0 and residum ~= 0 then
			for j=1,residum do
				local IconIndex = ((i - 1)*5) + j
				local vipLevel,daily_Double,luxury_Double = GetMonthDayNum(IconIndex)
				local img_daily = ImageView:create()
				img_daily:setScale(0.68)
				img_daily:setTag(IconIndex)
				img_daily:setPosition(ccp(55+105*(j - 1),650-100*(i-1))) 
				local pSpriteImg = tolua.cast(img_daily:getVirtualRenderer(), "CCSprite")
				local pControl = nil
				local reward_id = tabDailyValue[IconIndex]["NPointRewID"]
				local tab_reward = RewardLogic.GetRewardTable(tabDailyValue[IconIndex]["NPointRewID"])
				local itemID = SignInData.GetRewardInfoDataByDay(reward_id)
				if next(tab_reward[1]) ~= nil then
					pControl = UIInterface.MakeHeadIcon(img_daily,ICONTYPE.COIN_ICON,tonumber(itemID),nil,nil,nil,nil,nil)
					
				else
					pControl = UIInterface.MakeHeadIcon(img_daily,ICONTYPE.ITEM_ICON,tonumber(itemID),nil,nil,nil,nil,nil)
					
				end
				pControl:setTouchEnabled(true)
				pControl:setTag(IconIndex)
				pControl:addTouchEventListener(_Click_showInfo_CallBack)
				ScrollView_Daily:addChild(img_daily)

				local img_vips = ImageView:create()
				img_vips:loadTexture("Image/imgres/signIn/signIn_btom.png")
				img_vips:setPosition(ccp(42+105*(j - 1),662-100*(i-1)))
				ScrollView_Daily:addChild(img_vips,100,100)
				local strVIP = SignInData.GetVIPStr(IconIndex)
				local label_VIP = Label:create()
				label_VIP:setFontSize(18)
				label_VIP:setRotation(-45)
				label_VIP:setText("V"..vipLevel..strVIP.."倍")
				label_VIP:setPosition(ccp(-12,14))
				img_vips:addChild(label_VIP)

				if tonumber(vipLevel) == -1 then
					img_vips:setVisible(false)
				end

				local rewardNum = SignInData.GetRewardNum(IconIndex,reward_id)
				local label_RewardNum = Label:create()
				label_RewardNum:setTextAreaSize(CCSize(50,30))
				label_RewardNum:setFontSize(25)
				label_RewardNum:setAnchorPoint(ccp(0,0))
				label_RewardNum:setTextHorizontalAlignment(1)
				if next(tab_reward[1]) == nil then
					label_RewardNum:setText("X"..tab_reward[2][1]["ItemNum"])
				else
					label_RewardNum:setText("X"..tab_reward[1][1]["CoinNum"])
				end
				
				label_RewardNum:setPosition(ccp(-50,-55))
				pControl:addChild(label_RewardNum)

				local pSpiritVIP = tolua.cast(img_vips:getVirtualRenderer(),"CCSprite")
				local pSpiritcontrol = tolua.cast(pControl:getVirtualRenderer(), "CCSprite")
				local pImgIcon = tolua.cast(img_daily:getChildByTag(1000), "ImageView")
				local pSpriteIcon = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")
				local pImgHun = tolua.cast(pControl:getChildByTag(1001), "ImageView")
				local pSpriteHun = nil
				if pImgHun ~= nil then
					pSpriteHun = tolua.cast(pImgHun:getVirtualRenderer(), "CCSprite")
				end
				if IconIndex <= nTypeNum then
					local m_YetSign = ImageView:create()
					m_YetSign:loadTexture(YETSIGNIN_IMAGE)
					m_YetSign:setRotation(-40)
					m_YetSign:setTag(IconIndex)
					img_daily:addChild(m_YetSign,100,100)
					SpriteSetGray(pSpriteImg,1)
					SpriteSetGray(pSpiritcontrol,1)
					SpriteSetGray(pSpiritVIP,1)
					if pImgHun ~= nil then
			  			SpriteSetGray(pSpriteHun,1)
			  		end
			  		if pImgIcon ~= nil then
			  			SpriteSetGray(pSpriteIcon,1)
			  		end
				else
					SpriteSetGray(pSpriteImg,0)
					SpriteSetGray(pSpiritcontrol,0)
					SpriteSetGray(pSpiritVIP,0)
					if pImgHun ~= nil then
			  			SpriteSetGray(pSpriteHun,0)
			  		end
			  		if pImgIcon ~= nil then
			  			SpriteSetGray(pSpriteIcon,0)
			  		end
				end
			end
		else
			for j=1,5 do
				local IconIndex = ((i - 1)*5) + j
				local vipLevel,daily_Double,luxury_Double = GetMonthDayNum(IconIndex)

				local img_daily = ImageView:create()
				img_daily:setScale(0.68)
				img_daily:setTag(IconIndex)
				img_daily:setPosition(ccp(55+105*(j - 1),650-100*(i-1))) 
				local pSpriteImg = tolua.cast(img_daily:getVirtualRenderer(), "CCSprite")
				local pControl = nil
				local reward_id = tabDailyValue[IconIndex]["NPointRewID"]
				local tab_reward = RewardLogic.GetRewardTable(tabDailyValue[IconIndex]["NPointRewID"])
				local itemID = SignInData.GetRewardInfoDataByDay(reward_id)
				
				if next(tab_reward[1]) ~= nil then
					pControl = UIInterface.MakeHeadIcon(img_daily,ICONTYPE.COIN_ICON,tonumber(itemID),nil,nil,nil,nil,nil)
				
				else
					pControl = UIInterface.MakeHeadIcon(img_daily,ICONTYPE.ITEM_ICON,tonumber(itemID),nil,nil,nil,nil,nil)
					
				end
				pControl:setTouchEnabled(true)
				pControl:setTag(IconIndex)--IconIndex
				pControl:addTouchEventListener(_Click_showInfo_CallBack)
				ScrollView_Daily:addChild(img_daily)

				local img_vips = ImageView:create()
				img_vips:loadTexture("Image/imgres/signIn/signIn_btom.png")
				img_vips:setPosition(ccp(42+105*(j - 1),662-100*(i-1)))
				ScrollView_Daily:addChild(img_vips,100,100)

				local strVIP = SignInData.GetVIPStr(IconIndex)
				local label_VIP = Label:create()
				label_VIP:setFontSize(18)
				label_VIP:setRotation(-45)
				label_VIP:setText("V"..vipLevel..strVIP.."倍")
				label_VIP:setPosition(ccp(-12,14))
				img_vips:addChild(label_VIP)
				if tonumber(vipLevel) == -1 then
					img_vips:setVisible(false)
				end
				local rewardNum = SignInData.GetRewardNum(IconIndex,reward_id)
				local label_RewardNum = Label:create()
				label_RewardNum:setTextAreaSize(CCSize(50,30))
				label_RewardNum:setFontSize(25)
				label_RewardNum:setAnchorPoint(ccp(0,0))
				label_RewardNum:setTextHorizontalAlignment(1)
				if next(tab_reward[1]) == nil then
					label_RewardNum:setText("X"..tab_reward[2][1]["ItemNum"])
				else
					label_RewardNum:setText("X"..tab_reward[1][1]["CoinNum"])
				end
				label_RewardNum:setPosition(ccp(-50,-55))
				pControl:addChild(label_RewardNum)

				local pSpiritVIP = tolua.cast(img_vips:getVirtualRenderer(),"CCSprite")
				local pSpiritcontrol = tolua.cast(pControl:getVirtualRenderer(), "CCSprite")
				local pImgIcon = tolua.cast(img_daily:getChildByTag(1000), "ImageView")
				local pSpriteIcon = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")
				local pImgHun = tolua.cast(pControl:getChildByTag(1001), "ImageView")
				local pSpriteHun = nil
				if pImgHun ~= nil then
					pSpriteHun = tolua.cast(pImgHun:getVirtualRenderer(), "CCSprite")
				end
				if IconIndex <= nTypeNum then
					local m_YetSign = ImageView:create()
					m_YetSign:loadTexture(YETSIGNIN_IMAGE)
					m_YetSign:setRotation(-40)
					m_YetSign:setScale(0.68)
					m_YetSign:setPosition(ccp(55+105*(j - 1),650-100*(i-1)))
					ScrollView_Daily:addChild(m_YetSign,1000,1000)
					SpriteSetGray(pSpriteImg,1)
					SpriteSetGray(pSpiritcontrol,1)
					SpriteSetGray(pSpiritVIP,1)
					if pImgHun ~= nil then
			  			SpriteSetGray(pSpriteHun,1)
			  		end
			  		if pImgIcon ~= nil then
			  			SpriteSetGray(pSpriteIcon,1)
			  		end
				else
					SpriteSetGray(pSpriteImg,0)
					SpriteSetGray(pSpiritcontrol,0)
					SpriteSetGray(pSpiritVIP,0)
					if pImgHun ~= nil then
			  			SpriteSetGray(pSpriteHun,0)
			  		end
			  		if pImgIcon ~= nil then
			  			SpriteSetGray(pSpriteIcon,0)
			  		end
				end

			end
		end
	end 
end

local function requestCallBack( sender,eventType )
	if eventType == SCROLLVIEW_EVENT_SCROLL_TO_TOP then
	elseif eventType == SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM then
	end
end

--日常签到
local function DaliySignIn(  )
	local Panel_Daliy = tolua.cast(m_SignInLayer:getWidgetByName("Panel_daily"),"Layout")
	label_SignInDay = tolua.cast(m_SignInLayer:getWidgetByName("Label_already"),"Label")
	local btn_daily = tolua.cast(m_SignInLayer:getWidgetByName("Button_daliy"),"Button")
	ScrollView_Daily = tolua.cast(m_SignInLayer:getWidgetByName("ScrollView_daily"),"ScrollView")
	local s_imgIcon = tolua.cast(m_SignInLayer:getWidgetByName("Image_icon"),"ImageView")
	local label_status = tolua.cast(m_SignInLayer:getWidgetByName("Label_10"),"Label")
	label_status:setVisible(false)
	
	if ScrollView_Daily ~= nil then
		ScrollView_Daily:setClippingType(1)
	end
	tab_monNum,m_dayNum = SignInLogic.GetMonthNum()
	m_signNum = GetSignInNum()
	label_SignInDay:setText("本月已经签到"..m_signNum.."天")
	SortImgpath(tab_monNum,m_dayNum,m_signNum)
	local nRequire,nTimes = GetMonthDayNum(m_signNum+1)
	local personVIP = server_mainDB.getMainData("vip")
	--日常签到响应事件
	local function _Click_DaliySign_CallBack( sender,eventType )
		local dailyID = sender:getTag()
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				--签到奖励弹出窗
				local function _ClickTouch(  )
					
				end
				local tab_reward = RewardLogic.GetRewardTable(tab_monNum[dailyID]["NPointRewID"])
				local tabDailyTCoin = {}
				local tabDailyTItem = {}
				if next(tab_reward[1]) ~= nil and next(tab_reward[2]) == nil then
					for key,value in pairs(tab_reward[1]) do
						local tabChild = {}
						if tonumber(nRequire) <= tonumber(personVIP) then
							tabChild[1] = value["CoinID"]
							tabChild[2] = value["CoinNum"]*nTimes
						else
							tabChild[1] = value["CoinID"]
							tabChild[2] = value["CoinNum"]
						end
						table.insert(tabDailyTCoin,tabChild)
					end
					ShowRewardLayer(nil,tabDailyTCoin,_ClickTouch)
				elseif next(tab_reward[1]) == nil and next(tab_reward[2]) ~= nil then
					
					for key,value in pairs(tab_reward[2]) do
						local tabChild = {}
						if tonumber(nRequire) <= tonumber(personVIP) then
							tabChild[1] = value["ItemID"]
							tabChild[2] = value["ItemNum"]*nTimes
						else
							tabChild[1] = value["ItemID"]
							tabChild[2] = value["ItemNum"]
						end
						table.insert(tabDailyTItem,tabChild)
					end
					ShowRewardLayer(tabDailyTItem,nil,_ClickTouch)
				elseif next(tab_reward[1]) ~= nil and next(tab_reward[2]) ~= nil then
					for key,value in pairs(tab_reward[1]) do
						local tabChild = {}
						if tonumber(nRequire) <= tonumber(personVIP) then
							tabChild[1] = value["CoinID"]
							tabChild[2] = value["CoinNum"]*nTimes
						else
							tabChild[1] = value["CoinID"]
							tabChild[2] = value["CoinNum"]
						end
						table.insert(tabDailyTCoin,tabChild)
					end
					for key,value in pairs(tab_reward[2]) do
						local tabChild = {}
						if tonumber(nRequire) <= tonumber(personVIP) then
							tabChild[1] = value["ItemID"]
							tabChild[2] = value["ItemNum"]*nTimes
						else
							tabChild[1] = value["ItemID"]
							tabChild[2] = value["ItemNum"]
						end
						table.insert(tabDailyTItem,tabChild)
					end
					ShowRewardLayer(tabDailyTItem,tabDailyTCoin,_ClickTouch)
				end
				local function GetLuxSuccessCallBack(  )
					DaliySignIn()
				end
				Packet_SignInReward.SetSuccessCallBack(GetLuxSuccessCallBack)
				network.NetWorkEvent(Packet_SignInReward.CreatePacket())
			end
			Packet_SignInDaily.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_SignInDaily.CreatePacket())
			NetWorkLoadingLayer.loadingShow(true)

		end
	end
	local cur_time = os.date("*t")
	local labelDailyText = LabelLayer.createStrokeLabel(22, CommonData.g_FONT1, "签到领取", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	btn_daily:addChild(labelDailyText)
	-- btn_daily:setTag(cur_time["day"])
	btn_daily:setTag(m_signNum+1)
	local daily_status = GetDailyStatus()
	if daily_status == 1 then
		label_status:setVisible(true)
		btn_daily:setVisible(false)
		btn_daily:setTouchEnabled(false)
	else
		btn_daily:setVisible(true)
		btn_daily:setTouchEnabled(true)
		btn_daily:addTouchEventListener(_Click_DaliySign_CallBack)
	end
end



function CreateSignLayer(  )
	InitData()

	m_SignInLayer = TouchGroup:create()
	m_SignInLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/SignInLayer.json"))

	m_array_icon = CCArray:create()
	m_array_icon:retain()
	
	LuxurySignIn()
	DaliySignIn()
	

	-- local pMainBtns = MainBtnLayer.createMainBtnLayer()
	-- m_SignInLayer:addChild(pMainBtns, layerMainBtn_Tag, layerMainBtn_Tag)

	local panel_return = tolua.cast(m_SignInLayer:getWidgetByName("Panel_1"),"Layout")
	panel_return:addTouchEventListener(_Click_retrunMain_CallBack)

	local btn_return = tolua.cast(m_SignInLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_retrunMain_CallBack)

	return m_SignInLayer
end