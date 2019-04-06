module("CorpsTreeLayer",package.seeall)
require "Script/serverDB/resimg"
require "Script/Main/Mall/ShopLogic"
local GetScienceUpDate  = CorpsScienceData.GetScienceUpdate
local GetAnimationAction            = ShopLogic.GetAnimationAction

local m_CorpsTreeLayer 		= nil
local m_CorpsTreeGreenLayer = nil
local m_CorpsRipeLayer 		= nil
local m_CorpsUnRipeLayer 	= nil
local label_time            = nil
local GreenTreeBar          = nil
local m_curCount            = nil
local m_MaxLimite           = nil
local AddPercentNum         = 30
local tableUnTreeDate 		= {}

local function RefreshTreeState(  )
	local ScienceID = 1
	local function JudgeTree()
		NetWorkLoadingLayer.loadingHideNow()
		tableTreeDBState = GetScienceUpDate()
		CorpsScene.UpdateGodTreeState(tableTreeDBState)					
	end
	Packet_CorpsScienceUpDate.SetSuccessCallBack(JudgeTree)
	network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(ScienceID))
	NetWorkLoadingLayer.loadingShow(true)
end

local function showRipeExpericnce( tabREX )
	if m_CorpsRipeLayer == nil then
		m_CorpsRipeLayer = TouchGroup:create()
	    m_CorpsRipeLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsRipeLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_CorpsRipeLayer, layerCopTree_tag, layerCopTree_tag)
	end

	local label_num = tolua.cast(m_CorpsRipeLayer:getWidgetByName("Label_num"),"Label")
	local label_rich = tolua.cast(m_CorpsRipeLayer:getWidgetByName("Label_rich"),"Label")
	local totalExp = tonumber(tabREX.nMoneyNum) + tonumber(tabREX.nVIPNum)
	-- label_num:setText(totalExp)
	local R_path,R_name = CorpsData.GetRewardIconPath(tabREX.nMoneyType)

	local nMessText1 = "|color|51,25,13||size|24|".."恭喜您获得了".."|color|1,116,36||size|24|"..totalExp.."|color|51,25,13||size|24|"..R_name
	local messContentItem1 = RichLabel.Create(nMessText1,550,nil,nil,1)
	messContentItem1:setPosition(ccp(-145,10))		
	label_num:addChild(messContentItem1)

	local tabVIPTree = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_18)
	
	if tabVIPTree["vipLimit"] ~= 0 then
		local nMessText2 = "|color|51,25,13||size|18|".."其中VIP".."额外获得".."|color|1,116,36||size|18|"..tabREX.nVIPNum.."|color|51,25,13||size|18|"..R_name  --tabVIPTree["cur_VIP"]..
		local messContentItem2 = RichLabel.Create(nMessText2,550,nil,nil,1)
		messContentItem2:setPosition(ccp(-120,10))		
		label_rich:addChild(messContentItem2)
	else
		label_rich:setVisible(false)
	end

	local image_icon = tolua.cast(m_CorpsRipeLayer:getWidgetByName("Image_icon"),"ImageView")

	-- local img_path = CorpsData.GetPathImg(tabREX["nRewardID"])
	-- image_icon:loadTexture(img_path)
	local img_path = nil
	local tab_reward = RewardLogic.GetRewardTable(tabREX.nRewardID)  
	local tabTCoin = tab_reward[1]
	local tabTItem = tab_reward[2]

	local pLbItemNum = Label:create()
	pLbItemNum:setPosition(ccp(-25,-15))
	pLbItemNum:setFontSize(18)
	pLbItemNum:setName("LabelNum")
	
	pLbItemNum:setAnchorPoint(ccp(0, 0.5))
	image_icon:addChild(pLbItemNum)

	if #tabTCoin == 0 then
		img_path = tabTItem[1]["ItemPath"]
		pLbItemNum:setText(tabTItem[1]["ItemNum"])
	else
		img_path = tabTCoin[1]["CoinPath"]
		pLbItemNum:setText(tabTCoin[1]["CoinNum"])
	end
	image_icon:loadTexture(img_path)

	-- local label_word = tolua.cast(m_CorpsRipeLayer:getWidgetByName("Label_20"),"Label")
	-- label_word:setText(R_name)

	local function _Click_ripe_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_CorpsRipeLayer:setVisible(false)
			m_CorpsRipeLayer:removeFromParentAndCleanup(true)
			m_CorpsRipeLayer = nil
			RefreshTreeState()
		end
	end

	local btn_ripetext = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"确定",ccp(0,0),COLOR_Black,ccc3(255,255,255),true,ccp(0,0),3)
	
	local btn_ripe = tolua.cast(m_CorpsRipeLayer:getWidgetByName("Button_29"),"Button")
	btn_ripe:addChild(btn_ripetext)
	btn_ripe:addTouchEventListener(_Click_ripe_CallBack)

end

function showTreeLayer(RipeTable)
	if m_CorpsTreeLayer == nil then
		m_CorpsTreeLayer = TouchGroup:create()
	    m_CorpsTreeLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsTreeLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_CorpsTreeLayer, layerCopTree_tag, layerCopTree_tag)
	end
	
	local imgBar = tolua.cast(m_CorpsTreeLayer:getWidgetByName("Image_bar"),"ImageView")
	CommonInterface.GetAnimationByName("Image/imgres/corps/qianghua04/qianghua04.ExportJson", 
			"qianghua04", 
			"Animation2", 
			imgBar, 
			ccp(0, 0),
			nil,
			12)

	--动画
	local img_ani = tolua.cast(m_CorpsTreeLayer:getWidgetByName("Image_Animation"),"ImageView")
	local Animation11,Animation12 = GetAnimationAction(3)
	CommonInterface.GetAnimationByName(Animation11, 
		Animation12, 
		"Animation1", 
		img_ani, 
		ccp(10, -15),
		nil,
		10)
	--bar
	local bar = tolua.cast(m_CorpsTreeLayer:getWidgetByName("ProgressBar_bar"),"LoadingBar")
	bar:setPercent(100)

	--没增加一点所用到的时间
	local label_times = tolua.cast(m_CorpsTreeLayer:getWidgetByName("Label_time"),"Label")

	--暴击奖励
	local image_reward = tolua.cast(m_CorpsTreeLayer:getWidgetByName("Image_imgs"),"ImageView")
	local img_path = nil
	local tab_reward = RewardLogic.GetRewardTable(RipeTable.nRewardID)  
	
	local tabTCoin = tab_reward[1]
	local tabTItem = tab_reward[2]

	local pLbItemNum = Label:create()
	pLbItemNum:setPosition(ccp(-23,-15))
	pLbItemNum:setFontSize(18)
	pLbItemNum:setName("LabelNum")
	
	pLbItemNum:setAnchorPoint(ccp(0, 0.5))
	image_reward:addChild(pLbItemNum)

	if #tabTCoin == 0 then
		img_path = tabTItem[1]["ItemPath"]
		pLbItemNum:setText(tabTItem[1]["ItemNum"])
	else
		img_path = tabTCoin[1]["CoinPath"]
		pLbItemNum:setText(tabTCoin[1]["CoinNum"])
	end
	----奖励图标
	image_reward:loadTexture(img_path)

	--
	local l_gVipWord = tolua.cast(m_CorpsTreeLayer:getWidgetByName("Label_VIPWord"),"Label")
	local tabVIPTree = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_18)
	
	if tabVIPTree["vipLimit"] ~= 0 then
		local doubleNum = tonumber(tabVIPTree["cur_Num"])/100
		l_gVipWord:setText("VIP".."增加"..doubleNum.."倍经验") --tabVIPTree["cur_VIP"]..
	else
		l_gVipWord:setText("购买VIP可增加经验")
	end

	--button
	local function _Click_tree_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			
			local function GetSuccessCallBack(  )
				NetWorkLoadingLayer.loadingHideNow()
				m_CorpsTreeLayer:setVisible(false)
				m_CorpsTreeLayer:removeFromParentAndCleanup(true)
				m_CorpsTreeLayer = nil
				local RipeTab = {}
				RipeTab = CorpsData.GetCorpsTreeData()
				showRipeExpericnce(RipeTab)
			end
			Packet_CorpsTreeGet.SetSuccessCallBack(GetSuccessCallBack)
			network.NetWorkEvent(Packet_CorpsTreeGet.CreatePacket())
			NetWorkLoadingLayer.loadingShow(true)
		end
	end
	local btn_text = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"立即领取",ccp(0,0),COLOR_Black,ccc3(255,255,255),true,ccp(0,0),3)
	
	local btn_get = tolua.cast(m_CorpsTreeLayer:getWidgetByName("Button_get"),"Button")
	btn_get:addChild(btn_text)
	btn_get:addTouchEventListener(_Click_tree_CallBack)

	local function _Click_Return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_CorpsTreeLayer:setVisible(false)
			m_CorpsTreeLayer:removeFromParentAndCleanup(true)
			m_CorpsTreeLayer = nil
		end
	end

	local btn_Cancel = tolua.cast(m_CorpsTreeLayer:getWidgetByName("Button_return"),"Button")
	btn_Cancel:addTouchEventListener(_Click_Return_CallBack)
end

local function showUnRipeExpericnce( tabURE)
	if m_CorpsUnRipeLayer == nil then
		m_CorpsUnRipeLayer = TouchGroup:create()
	    m_CorpsUnRipeLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsUnRipeLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_CorpsUnRipeLayer, layerCopTree_tag, layerCopTree_tag)
	end
	local label_num = tolua.cast(m_CorpsUnRipeLayer:getWidgetByName("Label_num"),"Label")
	local label_vipNum = tolua.cast(m_CorpsUnRipeLayer:getWidgetByName("Label_VIP"),"Label")
	label_vipNum:setVisible(true)
	local nTotalNum = tonumber(tabURE.nMoneyNum) + tonumber(tabURE.nVIPNum)
	-- label_num:setText(nTotalNum)
	local u_path,u_name = CorpsData.GetRewardIconPath(tabURE.nMoneyType)

	local nMessText1 = "|color|51,25,13||size|24|".."恭喜您获得了".."|color|1,116,36||size|24|"..nTotalNum.."|color|51,25,13||size|24|"..u_name
	local messContentItem1 = RichLabel.Create(nMessText1,550,nil,nil,1)
	messContentItem1:setPosition(ccp(-150,10))		
	label_num:addChild(messContentItem1)

	local tabVIPTree = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_18)
	
	if tabVIPTree["vipLimit"] ~= 0 then
		-- label_vipNum:setText("VIP"..tabVIPTree["cur_VIP"].."增加"..tabURE.nVIPNum.."经验")
		local nMessText2 = "|color|51,25,13||size|18|".."其中VIP".."额外获得".."|color|1,116,36||size|18|"..tabURE.nVIPNum.."|color|51,25,13||size|18|".."武将经验" --tabVIPTree["cur_VIP"]..
		local messContentItem2 = RichLabel.Create(nMessText2,550,nil,nil,1)
		messContentItem2:setPosition(ccp(-110,10))		
		label_vipNum:addChild(messContentItem2)
	else
		label_vipNum:setVisible(false)
	end

	local function _Click_unripe_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_CorpsUnRipeLayer:setVisible(false)
			m_CorpsUnRipeLayer:removeFromParentAndCleanup(true)
			m_CorpsUnRipeLayer = nil
			RefreshTreeState()
		end
	end

	local btn_Unripetext = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"确定",ccp(0,0),COLOR_Black,ccc3(255,255,255),true,ccp(0,0),3)
	
	local btn_UnRipe = tolua.cast(m_CorpsUnRipeLayer:getWidgetByName("Button_gets"),"Button")
	btn_UnRipe:addChild(btn_Unripetext)
	btn_UnRipe:addTouchEventListener(_Click_unripe_CallBack)

end

function showTreeGreenLayer(tableTree)
	if m_CorpsTreeGreenLayer == nil then
		m_CorpsTreeGreenLayer = TouchGroup:create()
	    m_CorpsTreeGreenLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsTreeGreenLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerCopTree_tag)
		if temp == nil then
			scenetemp:addChild(m_CorpsTreeGreenLayer, layerCopTree_tag, layerCopTree_tag)
		else
			print("已经是神树界面")
		end
	end
	local m_timeHandTree = nil
	tableUnTreeDate = {}
	tableUnTreeDate = GetScienceUpDate()
	m_curCount = tableUnTreeDate.nCurCount
	m_MaxLimite = tableUnTreeDate.nMaxLimite
	AddPercentNum = m_curCount/m_MaxLimite
	--bar
	GreenTreeBar = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("ProgressBar_bar"),"LoadingBar")
	if tableUnTreeDate.nMaxLimite == 0 then
		GreenTreeBar:setPercent(0)
	else
		GreenTreeBar:setPercent(AddPercentNum*100)
	end

	--添加动画
	local img_animate = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Image_67"),"ImageView")
	
	local Animation11,Animation12 = GetAnimationAction(3)
	CommonInterface.GetAnimationByName(Animation11, 
		Animation12, 
		"Animation1", 
		img_animate, 
		ccp(10, -15),
		nil,
		10)

	--每增加一点所用的时间
	label_time = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Label_time"),"Label")
	local addTime = tableUnTreeDate.nNextTime
	local timesMintue = CorpsData.GetTimeInterval(tableTree.m_nLevel)
	
	local timeSeconds = tonumber(timesMintue)*60
	local totalTime = (math.floor((tableUnTreeDate.nMaxLimite - tableUnTreeDate.nCurCount)/tableUnTreeDate.nMoneyCount)-1)*timeSeconds+tableUnTreeDate.nNextTime
	
	local strHh = math.floor(totalTime/3600)
	local strMm = math.floor(totalTime/60) - strHh*60
	local strSs = math.floor(totalTime%60)
	
	if tonumber(strHh) < 10 then strHh = "0" .. strHh end
	if tonumber(strMm) < 10 then strMm = "0" .. strMm end
	if tonumber(strSs) < 10 then strSs = "0" .. strSs end
	label_time:setText(strHh..":"..strMm .. ":" .. strSs)

	local barpercentNum = tableUnTreeDate.nMoneyCount
	local function fulCallBack(  )
		GreenTreeBar:setPercent(barpercentNum)
		if barpercentNum >= 100 then
			GreenTreeBar:stopAllActions()
		else
			barpercentNum = barpercentNum + tableUnTreeDate.nMoneyCount
		end
	end
	local actionArray = CCArray:create()
	actionArray:addObject(CCDelayTime:create(timeSeconds))
	actionArray:addObject(CCCallFunc:create(fulCallBack))
	local action_list = CCSequence:create(actionArray)
	GreenTreeBar:runAction(CCRepeatForever:create(action_list))

	local function SetDelaysTime(nSecend)
		if nSecend < 0 then return end
		if m_CorpsTreeGreenLayer == nil then
			return
		end
		local nDelayTime = nSecend
		local strH = math.floor(nSecend/3600)
		local strM = math.floor(nSecend/60) - strH*60
		local strS = math.floor(nSecend%60)
		local strTemp = ""
		if tonumber(strH) < 10 then strH = "0" .. strH end
		if tonumber(strM) < 10 then strM = "0" .. strM end
		if tonumber(strS) < 10 then strS = "0" .. strS end
		
		local function tick(dt)
			if nDelayTime == 0 then
				if m_timeHandTree ~= nil then
					m_CorpsTreeGreenLayer:getScheduler():unscheduleScriptEntry(m_timeHandTree)
					m_timeHandTree = nil
				end
				
				local function GetSuccessTreeCallBack(  )
					NetWorkLoadingLayer.loadingShow(false)
					GreenTreeBar:stopAllActions()
					m_CorpsTreeGreenLayer:removeFromParentAndCleanup(true)
					m_CorpsTreeGreenLayer = nil
					local tabRipeData = {}
					tabRipeData = GetScienceUpDate()
					showTreeLayer(tabRipeData)
				end
								
				NetWorkLoadingLayer.loadingShow(true)
				Packet_CorpsScienceUpDate.SetSuccessCallBack(GetSuccessTreeCallBack)
				network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(1))
			end
			nDelayTime = nDelayTime -1
			SetDelaysTime(nDelayTime)
		end
		if m_timeHandTree == nil then
			m_timeHandTree = m_CorpsTreeGreenLayer:getScheduler():scheduleScriptFunc(tick, 1, false)
		end
		if m_timeHandTree ~= nil then
			label_time:setText(strH..":"..strM .. ":" .. strS)		
		end
	end
	if tableUnTreeDate.nMaxLimite ~= 0 then
		SetDelaysTime(totalTime)
	end

	--暴击奖励
	local image_reWard = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Image_img"),"ImageView")
	local img_path = nil
	local tab_reward = RewardLogic.GetRewardTable(tableUnTreeDate.nRewardID)  
	local tabTCoin = tab_reward[1]
	local tabTItem = tab_reward[2]

	local pLbItemNum = Label:create()
	pLbItemNum:setPosition(ccp(-23,-15))
	pLbItemNum:setFontSize(18)
	pLbItemNum:setName("LabelNum")
	
	pLbItemNum:setAnchorPoint(ccp(0, 0.5))
	image_reWard:addChild(pLbItemNum)

	if #tabTCoin == 0 then
		img_path = tabTItem[1]["ItemPath"]
		pLbItemNum:setText(tabTItem[1]["ItemNum"])
	else
		img_path = tabTCoin[1]["CoinPath"]
		pLbItemNum:setText(tabTCoin[1]["CoinNum"])
	end
	----奖励图标
	image_reWard:loadTexture(img_path)

	--button
	local function _Click_OK_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if m_curCount == 0 then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1473,nil)
				pTips = nil
			else
				local function GetSuccessCallBack(  )
					NetWorkLoadingLayer.loadingHideNow()
					if m_timeHandTree ~= nil then
						m_CorpsTreeGreenLayer:getScheduler():unscheduleScriptEntry(m_timeHandTree)
						m_timeHandTree = nil
					end
					GreenTreeBar:stopAllActions()
					m_CorpsTreeGreenLayer:removeFromParentAndCleanup(true)
					m_CorpsTreeGreenLayer = nil
					
					local UnRipeTab = {}
					UnRipeTab = CorpsData.GetCorpsTreeData()
					showUnRipeExpericnce(UnRipeTab)
				end
				Packet_CorpsTreeGet.SetSuccessCallBack(GetSuccessCallBack)
				network.NetWorkEvent(Packet_CorpsTreeGet.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)
			end
		end
	end

	local function _Click_Cancel_CallBack(sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if m_timeHandTree ~= nil then
				m_CorpsTreeGreenLayer:getScheduler():unscheduleScriptEntry(m_timeHandTree)
				m_timeHandTree = nil
			end
			GreenTreeBar:stopAllActions()
			m_CorpsTreeGreenLayer:removeFromParentAndCleanup(true)
			m_CorpsTreeGreenLayer = nil
			--AddPercentNum = 30
			
			-- tableUnTreeDate = {}
		end
	end

	local btn_text = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"立即领取",ccp(0,0),COLOR_Black,ccc3(255,255,255),true,ccp(0,0),3)


	local btn_get = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Button_get"),"Button")
	local btn_cancel = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Button_cancel"),"Button")
	local img_gVip = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Image_vip"),"ImageView")
	local l_gVip = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Label_vip"),"Label")
	local l_gVipWord = tolua.cast(m_CorpsTreeGreenLayer:getWidgetByName("Label_vipWord"),"Label")
	img_gVip:setVisible(false)
	local tabVIPTree = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_18)
	
	if tabVIPTree["vipLimit"] ~= 0 then
		local doubleNum = tonumber(tabVIPTree["cur_Num"])/100
		l_gVipWord:setText("VIP".."增加"..doubleNum.."倍经验") --tabVIPTree["cur_VIP"]..
	else
		l_gVipWord:setText("购买VIP可增加经验")
	end

	btn_get:addChild(btn_text)
	btn_get:addTouchEventListener(_Click_OK_CallBack)
	btn_cancel:addTouchEventListener(_Click_Cancel_CallBack)

end
