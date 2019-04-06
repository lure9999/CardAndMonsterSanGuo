module("CorpsGodTreeLayer",package.seeall)
require "Script/serverDB/resimg"
require "Script/Main/Mall/ShopLogic"
require "Script/Main/Corps/CorpsTreeTips"
local GetScienceUpDate  		= CorpsScienceData.GetScienceUpdate
local GetAnimationAction        = ShopLogic.GetAnimationAction
local GetTimeString				= UnitTime.GetTimeString

local m_GodTreeLayer   = nil
local m_timeHander     = nil
local progressBar      = nil
local m_CorpsRipeLayer = nil
local m_CorpsUnRipeLayer = nil
local label_time       = nil
local tableLevel       = {}

local function init(  )
	m_GodTreeLayer     = nil
	m_timeHander       = nil
	progressBar        = nil
	m_CorpsRipeLayer   = nil
	m_CorpsUnRipeLayer = nil
	label_time         = nil
	tableLevel         = {}
end

local function _Click_Cancel_CallBack( sender,eventType )
	if eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.ended then
		sender:setScale(1.0)
		AudioUtil.PlayBtnClick()
		if m_timeHander ~= nil then
			m_GodTreeLayer:getScheduler():unscheduleScriptEntry(m_timeHander)
			m_timeHander = nil
		end
		progressBar:stopAllActions()
		m_GodTreeLayer:removeFromParentAndCleanup(true)
		m_GodTreeLayer = nil
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

--刷新神树建筑的状态
function RefreshTreeState(  )
	local ScienceID = 1
	local function JudgeTree()
		NetWorkLoadingLayer.loadingHideNow()
		local tableTreeDBState = GetScienceUpDate()
		CorpsScene.UpdateGodTreeState(tableTreeDBState)					
	end
	Packet_CorpsScienceUpDate.SetSuccessCallBack(JudgeTree)
	network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(ScienceID))
	NetWorkLoadingLayer.loadingShow(true)
end

--神树未成熟时的回调
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

--神树成熟时的回调
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

function SetDelaysTime(nSecend)
	if nSecend < 0 then return end
	if m_GodTreeLayer == nil then
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
			if m_timeHander ~= nil then
				m_GodTreeLayer:getScheduler():unscheduleScriptEntry(m_timeHander)
				m_timeHander = nil
			end
				
			local function GetSuccessTreeCallBack(  )
				NetWorkLoadingLayer.loadingShow(false)
				progressBar:stopAllActions()
				progressBar:setPercent(100)
				loadUI()
				-- RefreshTreeState()
			end
								
			NetWorkLoadingLayer.loadingShow(true)
			Packet_CorpsScienceUpDate.SetSuccessCallBack(GetSuccessTreeCallBack)
			network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(1))
		end
		nDelayTime = nDelayTime -1
		SetDelaysTime(nDelayTime)
	end
	if m_timeHander == nil then
		m_timeHander = m_GodTreeLayer:getScheduler():scheduleScriptFunc(tick, 1, false)
	end
	if m_timeHander ~= nil then
		label_time:setText(strH..":"..strM .. ":" .. strS)		
	end
end

function loadUI(  )
	local tableData = GetScienceUpDate()
	
	local btn_get = tolua.cast(m_GodTreeLayer:getWidgetByName("Button_get"),"Button")
	local btn_use = tolua.cast(m_GodTreeLayer:getWidgetByName("Button_subTime"),"Button")
	local l_gVipWord = tolua.cast(m_GodTreeLayer:getWidgetByName("Label_VIPWord"),"Label")
	local img_talk = tolua.cast(m_GodTreeLayer:getWidgetByName("Image_talk"),"ImageView")
	local l_talk = tolua.cast(m_GodTreeLayer:getWidgetByName("Label_talk"),"Label")
	progressBar = tolua.cast(m_GodTreeLayer:getWidgetByName("ProgressBar_bar"),"LoadingBar")
	label_time = tolua.cast(m_GodTreeLayer:getWidgetByName("Label_time"),"Label")
	local label_16 = tolua.cast(m_GodTreeLayer:getWidgetByName("Label_16"),"Label")
	local label_14 = tolua.cast(m_GodTreeLayer:getWidgetByName("Label_14"),"Label")
	local img_bar = tolua.cast(m_GodTreeLayer:getWidgetByName("Image_9"),"ImageView")
	label_time:setVisible(false)

	local addTime = tableData["nNextTime"]
	local timesMinute = CorpsData.GetTimeInterval(tableLevel["m_nLevel"])
	local timesSeconds = tonumber(timesMinute)*60
	local totalTime = (math.floor((tableData["nMaxLimite"] - (tableData["nCurCount"] - tableData["nMoneyCount"]))/tableData["nMoneyCount"]))*timesSeconds+tableData["nNextTime"]
	

	if tableData["nCurCount"] == tableData["nMaxLimite"] and tableData["nMaxLimite"]~= 0 then
		print("表示成熟")
		btn_get:setTag(1)
		btn_use:setTouchEnabled(false)
		btn_use:setVisible(false)
		btn_get:setPosition(ccp(0,-123))
		l_talk:setText("经验果实已经发育成熟，立即领取经验吧！")
		label_time:setVisible(false)
		label_16:setVisible(false)
		label_14:setVisible(false)
		CommonInterface.GetAnimationByName("Image/imgres/corps/qianghua04/qianghua04.ExportJson", 
			"qianghua04", 
			"Animation2", 
			img_bar, 
			ccp(0, 0),
			nil,
			12)
	else
		btn_get:setTag(2)
		btn_use:setTouchEnabled(true)
		btn_use:setVisible(true)
		l_talk:setText("您的经验果实现在还未成熟，是否现在领取?")
		label_time:setVisible(true)
	end

	--添加动画
	local img_animate = tolua.cast(m_GodTreeLayer:getWidgetByName("Image_67"),"ImageView")
	local Animation11,Animation12 = GetAnimationAction(3)
	CommonInterface.GetAnimationByName(Animation11, 
		Animation12, 
		"Animation1", 
		img_animate, 
		ccp(10, -15),
		nil,
		10)

	--进度条
	
	
	local m_curCount = tableData["nCurCount"]
	local m_MaxLimit = tableData["nMaxLimite"]
	local AddPercentNum = tonumber(m_curCount)/tonumber(m_MaxLimit)

	if tonumber(tableData["nMaxLimite"]) == 0 then
		progressBar:setPercent(0)
	else
		progressBar:setPercent(AddPercentNum*100)
	end

	
	
	local strHh = math.floor(totalTime/3600)
	local strMm = math.floor(totalTime/60) - strHh*60
	local strSs = math.floor(totalTime%60)

	if tonumber(strHh) < 10 then strHh = "0"..strHh end
	if tonumber(strMm) < 10 then strMm = "0"..strMm end
	if tonumber(strSs) < 10 then strSs = "0"..strSs end
	label_time:setText(strHh..":"..strMm..":"..strSs)
	local barpercentNum = tableData["nMoneyCount"]
	local function fulCallBack(  )
		progressBar:setPercent(barpercentNum)
		if barpercentNum >= 100 then
			progressBar:stopAllActions()
		else
			barpercentNum = barpercentNum + tableData["nMoneyCount"]
		end
	end
	local actionArray = CCArray:create()
	actionArray:addObject(CCDelayTime:create(timesSeconds))
	actionArray:addObject(CCCallFunc:create(fulCallBack))
	local action_list = CCSequence:create(actionArray)
	progressBar:runAction(CCRepeatForever:create(action_list))

	
	if tableData["nCurCount"] ~= tableData["nMaxLimite"] and tableData["nMaxLimite"]~= 0 then
		SetDelaysTime(totalTime)
	end

	--暴击奖励
	local image_reWard = tolua.cast(m_GodTreeLayer:getWidgetByName("Image_img"),"ImageView")
	local img_path = nil
	local tab_reward = RewardLogic.GetRewardTable(tableData["nRewardID"])  
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
			local btn_tag = sender:getTag()
			if btn_tag == 2 then
				if m_curCount == 0 then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1473,nil)
					pTips = nil
				else
					local function GetSuccessCallBack(  )
						NetWorkLoadingLayer.loadingHideNow()
						if m_timeHander ~= nil then
							m_GodTreeLayer:getScheduler():unscheduleScriptEntry(m_timeHander)
							m_timeHander = nil
						end
						progressBar:stopAllActions()
						m_GodTreeLayer:removeFromParentAndCleanup(true)
						m_GodTreeLayer = nil
						
						local UnRipeTab = {}
						UnRipeTab = CorpsData.GetCorpsTreeData()
						showUnRipeExpericnce(UnRipeTab)
					end
					Packet_CorpsTreeGet.SetSuccessCallBack(GetSuccessCallBack)
					network.NetWorkEvent(Packet_CorpsTreeGet.CreatePacket())
					NetWorkLoadingLayer.loadingShow(true)
				end
			else
				local function GetSuccessCallBack(  )
					NetWorkLoadingLayer.loadingHideNow()
					if m_timeHander ~= nil then
						m_GodTreeLayer:getScheduler():unscheduleScriptEntry(m_timeHander)
						m_timeHander = nil
					end
					progressBar:stopAllActions()
					m_GodTreeLayer:removeFromParentAndCleanup(true)
					m_GodTreeLayer = nil
					local RipeTab = {}
					RipeTab = CorpsData.GetCorpsTreeData()
					showRipeExpericnce(RipeTab)
				end
				Packet_CorpsTreeGet.SetSuccessCallBack(GetSuccessCallBack)
				network.NetWorkEvent(Packet_CorpsTreeGet.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)
			end
		end
	end
	local btn_text = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"立即领取",ccp(0,0),COLOR_Black,ccc3(255,255,255),true,ccp(0,0),3)

	
	local tabVIPTree = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_18)
	if tabVIPTree["vipLimit"] ~= 0 then
		local doubleNum = tonumber(tabVIPTree["cur_Num"])/100
		l_gVipWord:setText("VIP".."增加"..doubleNum.."倍经验") --tabVIPTree["cur_VIP"]..
	else
		l_gVipWord:setText("购买VIP可增加经验")
	end

	btn_get:addChild(btn_text)
	btn_get:addTouchEventListener(_Click_OK_CallBack)

	local btn_usetext = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"加速成熟",ccp(0,0),COLOR_Black,ccc3(255,255,255),true,ccp(0,0),3)
	btn_use:addChild(btn_usetext)
	local function _Click_Tips_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			local function GetSuccessTreeCallBack(  )
				NetWorkLoadingLayer.loadingShow(false)
				if m_timeHander ~= nil then
					m_GodTreeLayer:getScheduler():unscheduleScriptEntry(m_timeHander)
					m_timeHander = nil
				end
				CorpsTreeTips.ShowTreeTips(tableLevel["m_nLevel"])
			end
							
			NetWorkLoadingLayer.loadingShow(true)
			Packet_CorpsScienceUpDate.SetSuccessCallBack(GetSuccessTreeCallBack)
			network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(1))
		end
	end
	btn_use:addTouchEventListener(_Click_Tips_CallBack)
end

function ShowTreeLayer( nLevelData )
	init()
	if m_GodTreeLayer == nil then
		m_GodTreeLayer = TouchGroup:create()
	    m_GodTreeLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsTreesLayer.json"))
	end
	tableLevel = nLevelData

	loadUI()
	local btn_cancel = tolua.cast(m_GodTreeLayer:getWidgetByName("Button_cancel"),"Button")
	btn_cancel:addTouchEventListener(_Click_Cancel_CallBack)
	return m_GodTreeLayer
end