require "Script/Main/Corps/CorpsLogic"
module("CorpsMercenaryLayer",package.seeall)
require "Script/Main/Corps/CorpsTipLayer"
require "Script/Main/ChargeVIP/ChargeVIPFunction"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryTipLayer"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryLogic"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryData"
require "Script/serverDB/techeffect"
require "Script/serverDB/technolog"

local t_day = 86400
local t_hour = 3600
local t_minte = 60

--数据
local CreateCommonInfoWidget = CorpsLogic.CreateCommonInfoWidget
local GetCorpsDynamicInfo = CorpsData.GetCorpsDynamicInfo
local GetYetMercenaryInfo = CorpsMercenaryData.GetYetMercenaryInfo -- 得到已拥有机器人的数据
local GetMercenaryRobotInfo = CorpsMercenaryData.GetMercenaryRobotInfo -- 得到机器人的数据
local GetRefreshNum = CorpsMercenaryData.GetRefreshNum  -- 得到刷新次数
local GetMercenaryRefreshRobot = CorpsMercenaryData.GetMercenaryRefreshRobot
local GetRobotImg = CorpsMercenaryData.GetRobotImg
local GetColorImgPath = CorpsMercenaryData.GetColorImgPath
local GetTabIndeXTime = CorpsMercenaryData.GetTabIndeXTime
--逻辑
local GetSearchId = CorpsLogic.SearchId
local SetRefreshStatus = CorpsMercenaryLogic.SetRefreshStatus
local GetRefreshStatus = CorpsMercenaryLogic.GetRefreshStatus
local SaveTimeStatus = CorpsMercenaryLogic.SaveTimeStatus
local GetDayStatus = CorpsMercenaryLogic.GetDayStatus
local GetMonthStatus = CorpsMercenaryLogic.GetMonthStatus
local GetYearStatus = CorpsMercenaryLogic.GetYearStatus
local SaveCheckBoxStatus = CorpsMercenaryLogic.SaveCheckBoxStatus
local GetCheckBoxStatus  = CorpsMercenaryLogic.GetCheckBoxStatus
local CheckMercenaryTechLevel = CorpsLogic.CheckMessHallLV
local JudgeLevelLinit = CorpsMercenaryLogic.JudgeLevelLinit
local CheckMercenaryByID = CorpsMercenaryLogic.CheckMercenaryByID
local CheckWhetherOwn = CorpsMercenaryLogic.CheckWhetherOwn
local cleanListView   = CorpsMercenaryLogic.cleanListView

local m_CorpsMercearyLayer = nil
local Panel_yongbing       = nil
local Panel_tianjia        = nil
local Panel_bottom         = nil
local m_YetMercenaryInfo   = nil
local nDay                 = nil
local nMonth               = nil
local nYears               = nil
local m_refreshLayer       = nil
local CheckBox_Refresh     = nil
local PersonLevel          = nil
local label_freeNum        = nil
local m_MtimeHand           = nil
local label_time           = nil
local Image_black          = nil
local image_hire           = nil
local image_hero           = nil
local image_hero0         = nil
local image_hero1         = nil
local image_hero2         = nil
local m_MercenaryInfo      = nil
local FreeRefreshNum      = nil
local listView_Item       = nil
local pTag = 1
local HavePtag = 1
local vipLimitNum = 4
local TeffectNum = 2
local m_HaveMercenaryNum     = 0
local m_CurRefreshNum      = 0
local m_disRewen           = 0
local m_isRefresh = false
local m_tableMercenaryLevel = {}
local m_tableLevelInfo     = {}
local tableMercenaryRobotDB = {}
local tableHaveMercenaryDB = {}


local IMAGEEMPTY = "Image/imgres/common/common_empty.png"
local IMAGEFIGHT = "Image/imgres/main/fight.png"

local function initData(  )
	m_CorpsMercearyLayer = nil
	Panel_yongbing        = nil
	Panel_tianjia         = nil
	Panel_bottom          = nil
	m_YetMercenaryInfo    = nil
	nYears                = nil
	nMonth                = nil
	nDay                  = nil
	m_refreshLayer        = nil
	CheckBox_Refresh      = nil
	PersonLevel           = nil
	label_freeNum         = nil
	m_MtimeHand           = nil
	label_time            = nil
	Image_black           = nil
	image_hire            = nil
	image_hero            = nil
	image_hero0           = nil
	image_hero1           = nil
	image_hero2           = nil
	m_MercenaryInfo       = nil
	FreeRefreshNum        = nil
	listView_Item         = nil
	pTag                  = 1
	HavePtag              = 1
	TeffectNum            = 2
	m_HaveMercenaryNum    = 0
	m_CurRefreshNum       = 0
	m_disRewen            = 0
	vipLimitNum           = 4
	m_tableMercenaryLevel = {}
	m_tableLevelInfo      = {}
	tableMercenaryRobotDB = {}
	tableHaveMercenaryDB  = {}
	m_isRefresh = false
end

local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		if m_MtimeHand ~= nil then
			m_CorpsMercearyLayer:getScheduler():unscheduleScriptEntry(m_MtimeHand)
			-- CCDirector:sharedDirector():getScheduler():unscheduleAll()
			m_MtimeHand = nil
		end
		m_CorpsMercearyLayer:setVisible(false)
		m_CorpsMercearyLayer:removeFromParentAndCleanup(true)
		m_CorpsMercearyLayer = nil
		-- CoinInfoBar.ShowHideBar(true)
	end
end


--左上
function showUpLeft()
	local Panel_upLeft = tolua.cast(m_CorpsMercearyLayer:getWidgetByName("Panel_upleft"),"Layout")

	--label 所拥有的佣兵数量
	local label_MencerNum = tolua.cast(Panel_upLeft:getChildByName("Label_num"),"Label")
	local tableHaveMercenaryNum = {}
	local num = 0
	tableHaveMercenaryNum = GetYetMercenaryInfo()
	for key,value in pairs(tableHaveMercenaryNum) do
		if next(value) ~= nil then
			num = num + 1
		end
	end
	label_MencerNum:setText(num.."/"..TotalHireNum)

	local btn_return = tolua.cast(Panel_upLeft:getChildByName("Button_return"),"Button")
	btn_return:setPosition(ccp(btn_return:getPositionX() + CommonData.g_Origin.x,btn_return:getPositionY()))
	btn_return:addTouchEventListener(_Click_return_CallBack)

end

local function SetPower(pControl,nNumber)
	if pControl:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(pControl:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(nNumber)
	else
		local pText = LabelBMFont:create()
		
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setScale(0.7)
		pText:setPosition(ccp(-15,-12))
		pText:setAnchorPoint(ccp(0.5,0.5))
		pText:setText(nNumber)
		pControl:addChild(pText,0,1000)
	end
end

--查看已有佣兵的信息
local function _Click_GetInfo_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local pID = sender:getTag()
		local m_MercenaryPersonInfo = {}
		for key,value in pairs(tableHaveMercenaryDB) do
			if pID == key then
				m_MercenaryPersonInfo = value
			end
		end		
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingHideNow()
			CorpsMercenaryTipLayer.YYbInfo(m_MercenaryPersonInfo,pID,m_tableLevelInfo)
		end
		Packet_MercenaryCamp.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_MercenaryCamp.CreatePacket(pID,1))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--添加佣兵
local function MercenaryInfoControl( pControl, value)
	local imageLevel = tolua.cast(pControl:getChildByName("Image_29"),"ImageView")
	local labelName = tolua.cast(pControl:getChildByName("Label_Name"),"Label")
	local imageHead = tolua.cast(pControl:getChildByName("Image_icon"),"ImageView")
	local imageFight = tolua.cast(pControl:getChildByName("Image_fight"),"ImageView")
	local labelPower = tolua.cast(pControl:getChildByName("Label_power"),"Label")
	local img_end = tolua.cast(pControl:getChildByName("Image_end"),"ImageView")
	local img_Rebate = tolua.cast(pControl:getChildByName("Image_134"),"ImageView")
	label_time = tolua.cast(pControl:getChildByName("Label_shengyutime"),"Label") 
	imageHead:setTouchEnabled(true)
	img_end:setVisible(false)
	img_Rebate:setVisible(false)
	if value ~= nil then
		local labelLevel = Label:create()
		
		labelLevel:setFontSize(20)
		labelLevel:setText(value.level)
		AddLabelImg(labelLevel,101,imageLevel)
		 
		labelName:setFontSize(18)
		labelName:setText(value.name)

		-- local m_pControl = CorpsMercenaryTipLayer.ShowMercenaryInfo(imageHead,value)
		UIInterface.MakeHeadIcon(imageHead,ICONTYPE.GENERAL_COLOR_ICON,value.iconID,nil,nil,nil,value.nColorID,nil)


		imageFight:loadTexture(IMAGEFIGHT)
		imageFight:setScale(0.8)
		SetPower(labelPower,value.power)

		local dis_counts = CorpsMercenaryData.GetRewenRebate(m_disRewen)
		local dis_countNum = tonumber(dis_counts)*10
		local label_rebate = Label:create()
		label_rebate:setFontSize(18)
		label_rebate:setRotation(-45)
		label_rebate:setColor(ccc3(255,194,30))
		label_rebate:setText(dis_countNum.."折")
		label_rebate:setPosition(ccp(-5,6))
		img_Rebate:addChild(label_rebate)
		if dis_counts ~= 1 then
			img_Rebate:setVisible(true)
		end
		
		local TotalTime = value.times
		local d_day = math.floor(TotalTime / t_day)
		local h_hour = math.floor(TotalTime / t_hour) - d_day*24
		local m_minte = math.ceil(TotalTime / t_minte) - math.floor(TotalTime / t_hour)*60
		if TotalTime <= 0 then
			label_time:setText("佣兵已过期")
			img_end:setVisible(true)
		else
			if d_day >= 1 then
				label_time:setText("剩余:"..d_day.."天"..h_hour.."小时")
			else
				if h_hour >= 1 then
					label_time:setText("剩余:"..h_hour.."小时"..m_minte.."分")
				else
					label_time:setText("剩余:"..m_minte.."分")
				end
			end
		end
	else
		imageHead:loadTexture(IMAGEEMPTY)
		imageLevel:setVisible(false)
	end

end

local function _Click_AddYongbing_CallBack( sender,eventType )
	local ptags = sender:getTag()
	if eventType == TouchEventType.ended then
		print("添加佣兵",ptags)
	end
end 

local function AddYongbing( pControl,ptag )
	-- local label_text = tolua.cast(Panel_tianjia:getChildByName("Label_42"),"Label")
	local image_touch = tolua.cast(Panel_tianjia:getChildByName("Image_baikuang"),"ImageView")
	image_touch:setTouchEnabled(true)
	image_touch:setTag(ptag)
	image_touch:addTouchEventListener(_Click_AddYongbing_CallBack)

end

local function InitInfoControl( pControl ,value)
	m_disRewen = m_disRewen + 1
	local m_touch = tolua.cast(pControl:getChildByName("Image_empty"),"ImageView")
	Panel_yongbing = tolua.cast(pControl:getChildByName("Panel_yongbing"),"Layout")
	Panel_tianjia = tolua.cast(pControl:getChildByName("Panel_tianjia"),"Layout")
	Panel_tianjia:setVisible(false)
	Panel_tianjia:setTouchEnabled(false)
	Panel_yongbing:setVisible(false)
	Panel_yongbing:setTouchEnabled(false)
	m_touch:setVisible(false)
	m_touch:setTouchEnabled(false)
	local n_pLevel = server_mainDB.getMainData("level")
	local img_lock = tolua.cast(Panel_tianjia:getChildByName("Image_lock"),"ImageView")
	img_lock:setVisible(true)
	local l_levelLimitWord = tolua.cast(Panel_tianjia:getChildByName("Label_42"),"Label")
	local img_vip = tolua.cast(Panel_tianjia:getChildByName("Image_vip"),"ImageView")
	local label_vip = tolua.cast(img_vip:getChildByName("Label_vip"),"Label")
	local VIPLevel = server_mainDB.getMainData("vip")
	local GridLevel =CorpsMercenaryData.GetMercenaryGridLevel(HavePtag)
	
	-- ChargeVIPFunction.TipVIPLayer(enumVIPFunction.eVipFunction_1,pControl)
	
	local needVIP = CorpsMercenaryData.GainVIPGrid(vipLimitNum) ---对应格子所需要的VIP等级
	label_vip:setText("vip"..needVIP)

	if next(value) == nil then
		pControl:setTouchEnabled(false)
		Panel_tianjia:setVisible(true)
		Panel_tianjia:setTouchEnabled(true)
		if HavePtag == 1 then
			if tonumber(n_pLevel) >= tonumber(GridLevel)  then --or tonumber(VIPLevel) >= tonumber(needVIP)
				img_lock:setVisible(false)
				l_levelLimitWord:setText("虚席以待")
			end 
			img_vip:setVisible(false)
		elseif HavePtag == 2  then
			local vipF = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_5)
			if vipF["vipLimit"] == nil then
				vipF["vipLimit"] = 1
			end
			
			if GridLevel == nil then
				GridLevel = 20
			end 
			if tonumber(n_pLevel) >= tonumber(GridLevel) or tonumber(vipF["vipLimit"]) >= 1 then --
				img_lock:setVisible(false)
				l_levelLimitWord:setText("虚席以待")
			end
		elseif HavePtag == 3  then
			
			if GridLevel == nil then
				GridLevel = 30
			end 
			
			local vipF = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_6)
			if vipF["vipLimit"] == nil then
				vipF["vipLimit"] = 1
			end
			if tonumber(n_pLevel) >= tonumber(GridLevel) or tonumber(vipF["vipLimit"]) >= 1 then --
				img_lock:setVisible(false)
				l_levelLimitWord:setText("虚席以待")
			end
		end
		
		AddYongbing(pControl,HavePtag)
	else
		m_touch:setVisible(true)
		m_touch:setTouchEnabled(true)
		m_touch:setTag(HavePtag)
		Panel_yongbing:setVisible(true)
		Panel_yongbing:setTouchEnabled(true)
		MercenaryInfoControl(Panel_yongbing,value)
		m_touch:addTouchEventListener(_Click_GetInfo_CallBack)
	end
	HavePtag = HavePtag + 1
	vipLimitNum = vipLimitNum + 1
end

--右上已有佣兵的信息
function showYetSolider()
	local Panel_YetSolider = tolua.cast(m_CorpsMercearyLayer:getWidgetByName("Panel_YetSoldier"),"Layout")

	local pImage_item1 = tolua.cast(Panel_YetSolider:getChildByName("Image_Item1"),"ImageView")
	local pImage_item2 = tolua.cast(Panel_YetSolider:getChildByName("Image_Item1_0"),"ImageView")
	local pImage_item3 = tolua.cast(Panel_YetSolider:getChildByName("Image_Item1_1"),"ImageView")
	HavePtag = 1
	vipLimitNum = 4
	m_disRewen = 0
	tableMercenaryRobotDB = {}

	tableHaveMercenaryDB = {}
	tableHaveMercenaryDB = GetYetMercenaryInfo()

	InitInfoControl(pImage_item1,tableHaveMercenaryDB[1])
	InitInfoControl(pImage_item2,tableHaveMercenaryDB[2])
	InitInfoControl(pImage_item3,tableHaveMercenaryDB[3])
	local id1 = CorpsMercenaryData.GetYetMercenaryID(1)
	local id2 = CorpsMercenaryData.GetYetMercenaryID(2)
	local id3 = CorpsMercenaryData.GetYetMercenaryID(3)
	local t1 = GetTabIndeXTime(1)
	local t2 = GetTabIndeXTime(2)
	local t3 = GetTabIndeXTime(3)

	local levelvel = CorpsMercenaryData.GetTabIndeXLevel(1)
	m_HaveMercenaryNum = #tableHaveMercenaryDB


end

--设置特殊字体的战力
local function SetBottomPower(pControl,nNumber)
	if pControl:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(pControl:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(nNumber)
	else
		local pText = LabelBMFont:create()
		
		pText:setFntFile("Image/imgres/main/fight.fnt")
		--pText:setScale(0.7)
		pText:setPosition(ccp(0,-20))
		pText:setAnchorPoint(ccp(0.5,0.5))
		pText:setText(nNumber) 
		pControl:addChild(pText,0,1000)
	end
end

local function SetYongbingPower( num )
	local labelheroPower = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_Power"),"Label")
	if labelheroPower:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(labelheroPower:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(num)
	else
		local pText = LabelBMFont:create()	
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-10,-17))
		pText:setAnchorPoint(ccp(0.5,0.5))
		pText:setText(num)
		labelheroPower:addChild(pText,0,1000)
	end
end

--查看佣兵机器人的信息的回调函数
local function _Click_huiDiaolist_CallBack( sender,eventType )

	local ptagID = sender:getTag()
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local m_RobotPersonInfo = {}
		for key,value in pairs(tableMercenaryRobotDB) do
			if ptagID == key then
				m_RobotPersonInfo = value
				
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					CorpsMercenaryTipLayer.MercenaryInfoLayer(m_RobotPersonInfo,ptagID,m_tableLevelInfo,tableMercenaryRobotDB,tableHaveMercenaryDB)
				end
				Packet_MercenaryCamp.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_MercenaryCamp.CreatePacket(ptagID,0))
				NetWorkLoadingLayer.loadingShow(true)
				return
			end
		end
		-- CorpsMercenaryData.GetHireRebate(ptagID)
	end
end

--佣兵机器人的基本信息
local function InitBottomInfoControl( pControl,value )
	local image_level = tolua.cast(pControl:getChildByName("Image_level"),"ImageView")
	local label_name = tolua.cast(pControl:getChildByName("Label_lName"),"Label")
	local image_rebate = tolua.cast(pControl:getChildByName("Image_rebate"),"ImageView")
	local image_headIcon = tolua.cast(pControl:getChildByName("Image_heroIcon"),"ImageView")
	local image_fight = tolua.cast(pControl:getChildByName("Image_fight"),"ImageView")
	local label_power = tolua.cast(pControl:getChildByName("Label_power"),"Label")
	local btn_cost = tolua.cast(pControl:getChildByName("Button_cost"),"Button")
	local image_kuang = tolua.cast(pControl:getChildByName("Image_kuang"),"ImageView")
	local btn_imgCost = tolua.cast(btn_cost:getChildByName("Image_157"),"ImageView")
	local img_hire = tolua.cast(pControl:getChildByName("Image_Hire"),"ImageView")
	local img_black = tolua.cast(pControl:getChildByName("Image_black"),"ImageView")
	img_hire:setVisible(false)
	img_black:setVisible(false)
	
	btn_cost:setTag(pTag)
	local label_cost = tolua.cast(btn_cost:getChildByName("Label_cost"),"Label")
	image_headIcon:setTouchEnabled(true)
	local labelCostText = nil
	labelCostText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT3, "", ccp(-10, 5), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	label_cost:addChild(labelCostText)
	if next(value) ~= nil then
		local labelLevel = Label:create()
		labelLevel:setText("")
		labelLevel:setFontSize(20)
		labelLevel:setText(value.level)
		AddLabelImg(labelLevel,101,image_level)

		label_name:setText("")
		label_name:setFontSize(22)	
		label_name:setText(value.name)

		local pControlll = UIInterface.MakeHeadIcon(image_headIcon,ICONTYPE.GENERAL_COLOR_ICON,value.iconID,nil,nil,nil,value.nColorID,nil)
		pControlll:setTag(pTag)
		pControlll:addTouchEventListener(_Click_huiDiaolist_CallBack)

		image_fight:loadTexture(IMAGEFIGHT)
		SetBottomPower(label_power,value.power)

		--显示是否已经被雇佣
		if CheckWhetherOwn(value.id,tableHaveMercenaryDB) == true then
			img_hire:setVisible(true)
			img_black:setVisible(true)
		end

		-- pTag = pTag + 1
		btn_cost:addTouchEventListener(_Click_huiDiaolist_CallBack)
		--效果ID

		local costNum,coinPath,dis_count = CorpsMercenaryData.GetMercenaryHireConsum(value["id"],TeffectNum)
		
		btn_imgCost:loadTexture(coinPath)

		-- label_cost:setText(costNum) 
		if tonumber(dis_count) < 1 then
			costNum = math.floor(costNum*dis_count)
		end
		LabelLayer.setText(labelCostText,"")
		LabelLayer.setText(labelCostText,costNum)
		--折扣显示
		local dis_countNum = tonumber(dis_count)*10
		local label_rebate = Label:create()
		label_rebate:setFontSize(18)
		label_rebate:setRotation(-45)
		label_rebate:setColor(ccc3(255,194,30))
		label_rebate:setText("")
		label_rebate:setText(dis_countNum.."折")
		label_rebate:setPosition(ccp(-5,6))
		image_rebate:addChild(label_rebate)
		if tonumber(dis_count) == 1 then
			image_rebate:setVisible(false)
		else
			--[[local label_rebate = Label:create()
			label_rebate:setFontSize(18)
			label_rebate:setRotation(-45)
			local dis_countNum = tonumber(dis_count)*10
			label_rebate:setText(dis_countNum.."折")
			image_rebate:addChild(label_rebate)]]--
		end
		
		-- TeffectNum = TeffectNum + 1
	else
		-- image_headIcon:loadTexture(IMAGEEMPTY)
		--label_str:setVisible(true)
	end
end

local function initBottomControl( pControl,value )
	InitBottomInfoControl(pControl,value)

end

local function CreateItemWidget( pItemTemp )
    local pItem = pItemTemp:clone()
    local peer = tolua.getpeer(pItemTemp)
    tolua.setpeer(pItem, peer)
    return pItem
end
--加载佣兵机器人
local function showBottom(tabItem)
	--[[image_hero = tolua.cast(Panel_bottom:getChildByName("Image_hero"),"ImageView")
	image_hero0 = tolua.cast(Panel_bottom:getChildByName("Image_hero_0"),"ImageView")
	image_hero1 = tolua.cast(Panel_bottom:getChildByName("Image_hero_1"),"ImageView")
	image_hero2 = tolua.cast(Panel_bottom:getChildByName("Image_hero_2"),"ImageView")

	pTag = 1
	TeffectNum = 2
	initBottomControl(image_hero,tabItem[1])
	initBottomControl(image_hero0,tabItem[2])
	initBottomControl(image_hero1,tabItem[3])
	initBottomControl(image_hero2,tabItem[4])]]--

	

	local pMerItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryItem.json")
	pMerItemWidget = CreateItemWidget(pMerItemTemp)
	local pControl_1 = tolua.cast(pMerItemWidget:getChildByName("Image_hero"), "ImageView")
	initBottomControl(pControl_1,tabItem)
	listView_Item:pushBackCustomItem(pMerItemWidget)


end

local function UpadateItem(  )

	local pShopItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryItem.json")
	pMerItemWidget = CreateItemWidget(pMerItemTemp)
	
	RunListAction(listView_Item, tabShopItem, 4, showBottom)
end

--获取当天的时间
local function GetCurDayTime(  )
	local nTime = os.date("*t")
	nDay = nTime.day
	nMonth = nTime.month
	nYears = nTime.year
	SaveTimeStatus(nMonth)
end

function GetListView(  )
	return listView_Item
end

--中间部分相关信息
local function showMiddle()
	local Panel_middle = tolua.cast(m_CorpsMercearyLayer:getWidgetByName("Panel_middle"),"Layout")
	local image_93 = tolua.cast(Panel_middle:getChildByName("Image_93"),"ImageView")
	local image_corpsIcon = tolua.cast(image_93:getChildByName("Image_corpsIcon"),"ImageView")
	local label_wordlevel = tolua.cast(Panel_middle:getChildByName("Label_wordLevel"),"Label")
	local label_content = tolua.cast(Panel_middle:getChildByName("Label_content"),"Label")
	local label_free = tolua.cast(Panel_middle:getChildByName("Label_106"),"Label")
	label_freeNum = tolua.cast(Panel_middle:getChildByName("Label_108"),"Label")
	local btn_refresh = tolua.cast(Panel_middle:getChildByName("Button_refresh"),"Button")
	local img_refreshMoney = tolua.cast(btn_refresh:getChildByName("Image_refreshMoney"),"ImageView")
	local l_refreshMoneyNum = tolua.cast(btn_refresh:getChildByName("Label_refreshNum"),"Label")
	local l_refresh = tolua.cast(btn_refresh:getChildByName("Label_btom"),"Label")
	img_refreshMoney:setVisible(false)
	FreeRefreshNum = CorpsMercenaryData.GetFreeRefreshNum()
	-- label_freeNum = GetRefreshNum()
	-- m_CurRefreshNum = GetRefreshNum() -- 获取免费刷新次数
	local n_curfreeNum = FreeRefreshNum - m_CurRefreshNum
	local RefConMNum,	RefConMImg = CorpsMercenaryData.GetRefreshConsum()
	if n_curfreeNum <= 0 then
		n_curfreeNum = 0
		img_refreshMoney:setVisible(true)
		img_refreshMoney:loadTexture(RefConMImg)
		l_refreshMoneyNum:setText(RefConMNum)
		l_refresh:setPosition(ccp(-60,0))
	end
	image_corpsIcon:loadTexture(GetRobotImg(m_tableLevelInfo.ResimgID))
	label_wordlevel:setText(m_tableLevelInfo.TechName)
	label_content:setText(m_tableLevelInfo.TechDes)
	label_free:setText("免费次数：")
	label_freeNum:setText(n_curfreeNum.."/"..FreeRefreshNum)

	--刷新回调
	local function RefreshXieyi(  )
		local tableMercenaryRefreshDB = GetMercenaryRefreshRobot()
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.NetWorkLoadingLayer.loadingHideNow()
			tableMercenaryRobotDB = {}
			local tableMercenaryRefreshInfo = GetMercenaryRefreshRobot()
			tableMercenaryRobotDB = tableMercenaryRefreshInfo
			m_CurRefreshNum = CorpsMercenaryData.GetYetRefreshNum() -- 获取免费刷新次数
			pTag = 1
			TeffectNum = 2
			cleanListView(listView_Item)
			for key,value in pairs(tableMercenaryRefreshInfo) do

				showBottom(value)
				pTag = 1+ pTag
				TeffectNum = 1+TeffectNum
			end
			CorpsScene.GetConteobile(1)
			-- showBottom(tableMercenaryRefreshInfo)
			showMiddle()
		end
		Packet_MercenaryRefresh.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_MercenaryRefresh.CreatePacket())
		NetWorkLoadingLayer.loadingShow(true)
	end

	local function RefreshLayer(  )
		if m_refreshLayer == nil then
			m_refreshLayer = TouchGroup:create()
			m_refreshLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryRefresh.json"))
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			scenetemp:addChild(m_refreshLayer, layerMercenaryRefresh_tag, layerMercenaryRefresh_tag)
		end

		local RefConsumNum,	RefConsumImg = CorpsMercenaryData.GetRefreshConsum()

		local image_RefreshIcon = tolua.cast(m_refreshLayer:getWidgetByName("Image_costIcon"),"ImageView")
		local label_RefreshCost = tolua.cast(m_refreshLayer:getWidgetByName("Label_costNum"),"Label")
		local label_RefreshNum  = tolua.cast(m_refreshLayer:getWidgetByName("Label_refreshnum"),"Label")
		local btn_cancel = tolua.cast(m_refreshLayer:getWidgetByName("Button_cancel"),"Button")
		local btn_certain = tolua.cast(m_refreshLayer:getWidgetByName("Button_certain"),"Button")

		label_RefreshNum:setText("(已刷新"..m_CurRefreshNum.."次)")
		
		local labelCertainText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		local labelcancelText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "取消", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
		btn_cancel:addChild(labelcancelText)
		btn_certain:addChild(labelCertainText)	

		image_RefreshIcon:loadTexture(RefConsumImg)
		label_RefreshCost:setText(RefConsumNum)

		local function _Click_RefreshCancel_CallBack( sender,eventType )
			if eventType == TouchEventType.ended then
				AudioUtil.PlayBtnClick()
				SaveCheckBoxStatus(false)
				SetRefreshStatus(false)
				m_refreshLayer:setVisible(false)
				m_refreshLayer:removeFromParentAndCleanup(true)
				m_refreshLayer = nil
			end
		end	
		local function _Click_RefreshCertain_CallBack( sender,eventType )
			if eventType == TouchEventType.ended then
				AudioUtil.PlayBtnClick()
				m_refreshLayer:setVisible(false)
				m_refreshLayer:removeFromParentAndCleanup(true)
				m_refreshLayer = nil
				local checkbox = CheckBox_Refresh:getSelectedState()
				if checkbox == false then
					print("未选中")
					SaveCheckBoxStatus(false)
					SetRefreshStatus(false)
					RefreshXieyi()
				else
					--print("选中")
					RefreshXieyi()
					GetCurDayTime()
					SaveCheckBoxStatus(true)
				end
				
			end
		end
		btn_certain:addTouchEventListener(_Click_RefreshCertain_CallBack)
		btn_cancel:addTouchEventListener(_Click_RefreshCancel_CallBack)

		--复选框
		local function selectedEvent( sender,eventType )
			local CheckBox = tolua.cast(sender,"CheckBox")
			if eventType == CheckBoxEventType.selected then
				SaveCheckBoxStatus(true)
				SetRefreshStatus(true)
			elseif eventType == CheckBoxEventType.unselected then
				SaveCheckBoxStatus(false)
				SetRefreshStatus(false)
			end
		end
		CheckBox_Refresh = tolua.cast(m_refreshLayer:getWidgetByName("CheckBox_18"),"CheckBox")
		CheckBox_Refresh:setSelectedState(false)
		--SaveCheckBoxStatus(GetCheckBoxStatus())
		CheckBox_Refresh:addEventListenerCheckBox(selectedEvent)

	end

	local function _Click_refresh_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local nTime = os.date("*t")
			local nDays = nTime.day
			local curMonth = nTime.month
			local nYearss = nTime.year
			m_isRefresh = GetRefreshStatus()
			local n_month = GetMonthStatus()
			local surNum = FreeRefreshNum - m_CurRefreshNum
			if tonumber(surNum) <= 0 then
				if n_month == 0 then
					RefreshLayer()
				else
					if n_month == curMonth then
						if m_isRefresh == false then
							RefreshLayer()
						elseif m_isRefresh == true then
							RefreshXieyi()
						end
					else
						RefreshLayer()
					end
				end
			else
				RefreshXieyi()
			end
		end
	end

	local labelReshText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "刷新", ccp(30, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	l_refresh:addChild(labelReshText)
	btn_refresh:addTouchEventListener(_Click_refresh_CallBack)

end

function showUI()	

	TotalHireNum,LevelLimitTen,LevelLimitTwenty,LevelLimitThirty = CorpsMercenaryData.GetHireTotalNum()
	
	showYetSolider()
	showUpLeft()

	--获取佣兵机器人的信息
	pTag = 1
	TeffectNum = 2
	local function GetSuccessCallback(  )
		NetWorkLoadingLayer.loadingHideNow()
		tableMercenaryRobotDB = GetMercenaryRobotInfo()	
		m_CurRefreshNum = GetRefreshNum() -- 获取免费刷新次数
		showMiddle()
		local pMerItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryItem.json")
		for key,value in pairs(tableMercenaryRobotDB) do
			
			showBottom(value)
			pTag = 1 + pTag
			TeffectNum = 1 + TeffectNum
		end
		-- showBottom(tableMercenaryRobotDB)
	end
	Packet_MercenaryRobot.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_MercenaryRobot.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)

end

--创建UI的方法
function showMercenaryLayer(tabMerLevel)
	initData()
	m_tableMercenaryLevel = tabMerLevel
	local m_TechLevel = m_tableMercenaryLevel.m_nLevel
	--获取当前时间参数
	-- GetCurDayTime()
	PersonLevel = server_mainDB.getMainData("level")
	local tableTechInfo = {}
	tableTechInfo = technolog.getArrDataByField("TechnologyID","7")

	for key,value in pairs(tableTechInfo) do
		if CheckMercenaryTechLevel(m_TechLevel,value) == true then
			--m_tableLevelInfo = value
			m_tableLevelInfo["TechnologyID"] = value[1]
			m_tableLevelInfo["TechLv"] = value[2]
			m_tableLevelInfo["ResimgID"] = value[3]
			m_tableLevelInfo["TechName"] = value[4]
			m_tableLevelInfo["TechDes"] = value[5]
			m_tableLevelInfo["UpConditionID"] = value[6]
			m_tableLevelInfo["UpConsumeID"] = value[7]
			m_tableLevelInfo["ConsumeNum"] = value[8]
			m_tableLevelInfo["ResearchTime"] = value[9]
			m_tableLevelInfo["TechEffID1"] = value[10]
			m_tableLevelInfo["TechEffID2"] = value[11]
			m_tableLevelInfo["TechEffID3"] = value[12]
			m_tableLevelInfo["TechEffID4"] = value[13]
		end
	end
	m_CorpsMercearyLayer = TouchGroup:create()									-- 背景层
	m_CorpsMercearyLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryLayer.json"))
	Panel_bottom = tolua.cast(m_CorpsMercearyLayer:getWidgetByName("Panel_bottom"),"Layout")
	listView_Item = tolua.cast(Panel_bottom:getChildByName("ListView_item"),"ListView")
	SetRefreshStatus(m_isRefresh)
	showUI()

	return m_CorpsMercearyLayer
end