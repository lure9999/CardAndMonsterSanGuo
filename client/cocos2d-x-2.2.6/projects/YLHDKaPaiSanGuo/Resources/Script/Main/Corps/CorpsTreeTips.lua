module("CorpsTreeTips",package.seeall)
local GetScienceUpDate  		= CorpsScienceData.GetScienceUpdate
local GetTimeInterval           = CorpsData.GetTimeInterval
local m_treeTipsLayer = nil
local m_timeHandertip = nil


function ShowTreeTips( nTecLevel )
	if m_treeTipsLayer == nil then
		m_treeTipsLayer = TouchGroup:create()
	    m_treeTipsLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsTreeTips.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(70)
		if temp == nil then
			scenetemp:addChild(m_treeTipsLayer, 70, 70)
		end
	end
	local tableData = GetScienceUpDate() -- 数据
	
	local use_item,g_time,item_path = CorpsData.GetGodTreeData()
	
	local m_name = tolua.cast(m_treeTipsLayer:getWidgetByName("Label_name"),"Label")
	local label_time = tolua.cast(m_treeTipsLayer:getWidgetByName("Label_time"),"Label")
	local l_useNum1 = tolua.cast(m_treeTipsLayer:getWidgetByName("Label_curNum"),"Label")
	local l_useNum2 = tolua.cast(m_treeTipsLayer:getWidgetByName("Label_num"),"Label")
	local l_11 = tolua.cast(m_treeTipsLayer:getWidgetByName("Label_11"),"Label")
	local l_subTime = tolua.cast(m_treeTipsLayer:getWidgetByName("Label_sec"),"Label")
	local l_curNum = tolua.cast(m_treeTipsLayer:getWidgetByName("Label_yetNum"),"Label")
	local img_item1 = tolua.cast(m_treeTipsLayer:getWidgetByName("Image_32"),"ImageView")
	local img_item2 = tolua.cast(m_treeTipsLayer:getWidgetByName("Image_curItem"),"ImageView")
	-- UIInterface.MakeHeadIcon(img_item1,ICONTYPE.ITEM_ICON,use_item,nil,nil,nil,3,nil)
	-- UIInterface.MakeHeadIcon(img_item2,ICONTYPE.ITEM_ICON,use_item,nil,nil,nil,3,nil)
	img_item1:loadTexture(item_path)	
	img_item2:loadTexture(item_path)

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(img_item1,use_item,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(img_item2,use_item,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil	

	local btn_certain = tolua.cast(m_treeTipsLayer:getWidgetByName("Button_certain"),"Button")
	local btn_return = tolua.cast(m_treeTipsLayer:getWidgetByName("Button_return"),"Button")
	local btn_subTen = tolua.cast(m_treeTipsLayer:getWidgetByName("Button_subTen"),"Button")
	local btn_sub = tolua.cast(m_treeTipsLayer:getWidgetByName("Button_sub"),"Button")
	local btn_add = tolua.cast(m_treeTipsLayer:getWidgetByName("Button_add"),"Button")
	local btn_addTen = tolua.cast(m_treeTipsLayer:getWidgetByName("Button_addTen"),"Button")
	local label_least = tolua.cast(btn_subTen:getChildByName("Label_24"),"Label")
	local label_most = tolua.cast(btn_addTen:getChildByName("Label_28"),"Label")
	local img_sub = tolua.cast(btn_sub:getChildByName("Image_25"),"ImageView")
	local img_add = tolua.cast(btn_add:getChildByName("Image_26"),"ImageView")
	local label_name = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,"军团神树",ccp(0,0),COLOR_Black, ccc3(255,194,30),true,ccp(0,-2),2)
	m_name:addChild(label_name)

	--使用道具
	local num = 1
	l_useNum1:setText(num)
	l_useNum2:setText(num)
	l_subTime:setText(g_time)
	local cur_num = server_itemDB.GetItemNumberByTempId(use_item)
	l_curNum:setText(cur_num)
	

	local addTime = tableData["nNextTime"]
	local timesMinute = GetTimeInterval(nTecLevel)
	local timesSeconds = tonumber(timesMinute)*60
	local totalTime = (math.floor((tableData["nMaxLimite"] - (tableData["nCurCount"] - tableData["nMoneyCount"]))/tableData["nMoneyCount"]))*timesSeconds+tableData["nNextTime"]
	
	local strHh = math.floor(totalTime/3600)
	local strMm = math.floor(totalTime/60) - strHh*60
	local strSs = math.floor(totalTime%60)

	local s_minute = math.floor(totalTime/60)

	local function SetDelaysTime(nSecend)
		if nSecend < 0 then return end
		if m_GodTreeLayer == nil then
			return
		end
		local nDelayTime = nSecend
		local strH = math.floor(nSecend/3600)
		local strM = math.floor(nSecend/60) - strH*60
		local strS = math.floor(nSecend%60)
		local strTemp = ""
		
		local function tick(dt)
			if nDelayTime == 0 then
				if m_timeHandertip ~= nil then
					m_treeTipsLayer:getScheduler():unscheduleScriptEntry(m_timeHandertip)
					m_timeHandertip = nil
				end
			end
			nDelayTime = nDelayTime -1
			SetDelaysTime(nDelayTime)
		end
		if m_timeHandertip == nil then
			m_timeHandertip = m_treeTipsLayer:getScheduler():scheduleScriptFunc(tick, 1, false)
		end
		if m_timeHandertip ~= nil then
			label_time:setText(strH.."小时"..strM .. "分钟")		
		end
	end
	if tableData["nCurCount"] ~= tableData["nMaxLimite"] and tableData["nMaxLimite"]~= 0 then
		label_time:setText(strHh.."小时"..strMm.."分钟")
		SetDelaysTime(totalTime)
	else
		label_time:setVisible(false)
		l_11:setVisible(false)
	end

	local function _Click_SubTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			if num <= 10 then
				num = 1
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1638,nil)
				pTips = nil
			else
				num = num - 10
			end
			l_useNum1:setText(num)
			l_useNum2:setText(num)
			if tonumber(g_time) <= 200 then
				g_time = 20
				num= num
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1638,nil)
				pTips = nil
			else
				g_time = 20*num
			end
			
			l_subTime:setText(g_time)
		end
	end
	local function _Click_Sub_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			if num <= 1 then
				num = 1
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1638,nil)
				pTips = nil
			else
				num = num - 1
				if num <= 1 then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1638,nil)
					pTips = nil
					num = num
				end
			end
			l_useNum1:setText(num)
			l_useNum2:setText(num)
			if tonumber(g_time) <= 20 then
				g_time = 20
			else
				g_time = 20*num
			end
			
			l_subTime:setText(g_time)
		end
	end
	local function _Click_AddTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			btn_subTen:setTouchEnabled(true)
			btn_sub:setTouchEnabled(true)
			if tonumber(cur_num) == 0 then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1639,nil)
				pTips = nil
				return
			end
			num = num + 10
			if num >= tonumber(cur_num) then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1637,nil)
				pTips = nil
				num = cur_num
			end
			l_useNum1:setText(num)
			l_useNum2:setText(num)
			g_time = num*g_time
			if tonumber(g_time) >= tonumber(s_minute) then
				num = math.ceil(s_minute/20)
				g_time = num*20
				-- cur_num = num
				l_useNum2:setText(num)
				l_useNum1:setText(num)
				
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1637,nil)
				pTips = nil
			else
				local cur_item = server_itemDB.GetItemNumberByTempId(use_item)
				if tonumber(tonumber(cur_item) - num) == 0 then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1639,nil)
					pTips = nil
				end
			end
			l_subTime:setText(g_time)
		end
	end
	local function _Click_Add_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			if tonumber(cur_num) == 0 then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1639,nil)
				pTips = nil
				return
			end
			if num >= tonumber(cur_num) then
				num = cur_num
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1637,nil)
				pTips = nil
				g_time = num*g_time
			else
				num = num + 1
				g_time = num*g_time
			end
			l_useNum1:setText(num)
			l_useNum2:setText(num)
			
			if tonumber(g_time) >= tonumber(s_minute) then
				num = math.ceil(s_minute/20)
				g_time = num*20
				l_useNum2:setText(num)
				l_useNum1:setText(num)
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1637,nil)
				pTips = nil
				return
				-- cur_num = num	
			else
				local cur_item = server_itemDB.GetItemNumberByTempId(use_item)
				if tonumber(tonumber(cur_item) - num) == 0 then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1639,nil)
					pTips = nil
				end
			end
			l_subTime:setText(g_time)
		end
	end

	btn_subTen:addTouchEventListener(_Click_SubTen_CallBack)
	btn_addTen:addTouchEventListener(_Click_AddTen_CallBack)
	btn_sub:addTouchEventListener(_Click_Sub_CallBack)
	btn_add:addTouchEventListener(_Click_Add_CallBack)

	local function _Click_Cancel_CallBack( sender,eventType )
		if eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif eventType == TouchEventType.ended then
			sender:setScale(1.0)
			AudioUtil.PlayBtnClick()
			if m_timeHandertip ~= nil then
				m_treeTipsLayer:getScheduler():unscheduleScriptEntry(m_timeHandertip)
				m_timeHandertip = nil
			end
			m_treeTipsLayer:removeFromParentAndCleanup(true)
			m_treeTipsLayer = nil
			local function GetSuccessTreeCallBack(  )
				NetWorkLoadingLayer.loadingShow(false)
				local tableData = GetScienceUpDate()
				local addTime = tableData["nNextTime"]
				local timesMinute = GetTimeInterval(nTecLevel)
				local timesSeconds = tonumber(timesMinute)*60
				local totalTime = (math.floor((tableData["nMaxLimite"] - (tableData["nCurCount"] - tableData["nMoneyCount"]))/tableData["nMoneyCount"]))*timesSeconds+tableData["nNextTime"]
	
				CorpsGodTreeLayer.SetDelaysTime(totalTime)
			end
							
			NetWorkLoadingLayer.loadingShow(true)
			Packet_CorpsScienceUpDate.SetSuccessCallBack(GetSuccessTreeCallBack)
			network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(1))
		elseif eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end
	btn_return:addTouchEventListener(_Click_Cancel_CallBack)

	local function _Click_certain_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			
			if tonumber(cur_num) == 0 then
				num = 0
			end
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				if m_timeHandertip ~= nil then
					m_treeTipsLayer:getScheduler():unscheduleScriptEntry(m_timeHandertip)
					m_timeHandertip = nil
				end
				m_treeTipsLayer:removeFromParentAndCleanup(true)
				m_treeTipsLayer = nil
				CorpsGodTreeLayer.loadUI()
				CorpsGodTreeLayer.RefreshTreeState()
			end
			Packet_TreeSpeedUp.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_TreeSpeedUp.CreatePacket(num))
			NetWorkLoadingLayer.loadingShow(true)
		end
	end
	local btn_text = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"确定使用",ccp(0,0),COLOR_Black,ccc3(255,255,255),true,ccp(0,0),3)
	btn_certain:addChild(btn_text)
	btn_certain:addTouchEventListener(_Click_certain_CallBack)
end