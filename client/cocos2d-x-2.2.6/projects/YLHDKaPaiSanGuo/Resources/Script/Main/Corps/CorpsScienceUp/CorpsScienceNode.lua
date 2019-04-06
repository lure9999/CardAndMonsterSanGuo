module("CorpsScienceNode",package.seeall)
local GetScienceImg 			 = CorpsScienceData.GetScienceImg
local GetScienceIconImg          = CorpsScienceData.GetScienceIconImg
local GetScienceTimeByID = CorpsScienceData.GetScienceTimeByID -- 得到当前科技研发的时间
local m_ScienceType = {
	E_SCIENCE_TYPE_CORPS_TREE = 1,
	E_SCIENCE_TYPE_CORPS_MEMBER = 2,
	E_SCIENCE_TYPE_CORPS_OFFICER = 3,
	E_SCIENCE_TYPE_CORPS_MESS = 4,
	E_SCIENCE_TYPE_CORPS_DONATE = 5,
	E_SCIENCE_TYPE_CORPS_SHOP = 6,
	E_SCIENCE_TYPE_CORPS_MERCENARY = 7,
	E_SCIENCE_TYPE_CORPS_ANIMAL = 8,
	E_SCIENCE_TYPE_CORPS_TASK = 9,
	E_SCIENCE_TYPE_CORPS_EVENT = 10,
	E_SCIENCE_TYPE_CORPS_STORAGE = 11,
	E_SCIENCE_TYPE_CORPS_BATTLE = 12,
}

local m_SULayer = nil
local label_time = nil
local s_UptimeHand = nil


function createSpeedUpLayer( nScienceID,nTime,nLevel )
	if m_SULayer == nil then
		m_SULayer = TouchGroup:create()
	    m_SULayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/ScienceSpeedUpLayer.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_SULayer, layerSpeedUp_tag, layerSpeedUp_tag)
	end
	local s_Time = 0
	local t_UpT = tonumber(GetScienceTimeByID(nScienceID))
	-- local g_Time,IconPath,ItemNeedNum,ItemNum = CorpsScienceData.GetSpeedUpData()
	local g_Time,iconID,nPath = CorpsScienceData.GetSpeedUpDataByID()

	local cur_num = server_itemDB.GetItemNumberByTempId(iconID)

	local ScienceName = CorpsScienceLogic.ReturnScienceName(nScienceID,nLevel)
	local s_hour = math.floor(t_UpT/3600)
	local s_minute = math.floor(t_UpT/60) -- s_hour*60
	local s_second = t_UpT - s_minute*60 - s_hour*3600
	
	local num = 1
	local suTime = g_Time
	-- m_LabelCorpsNum   = LabelLayer.createStrokeLabel(24, "微软雅黑", value.people, ccp(1, 0), COLOR_Black, ccc3(99,216,53), true, ccp(0, -2), 2)
	
	--label
	local m_name = tolua.cast(m_SULayer:getWidgetByName("Label_name"),"Label")
	label_time = tolua.cast(m_SULayer:getWidgetByName("Label_time"),"Label")
	local cur_UseNum = tolua.cast(m_SULayer:getWidgetByName("Label_cumNum"),"Label")
	local label_useNum = tolua.cast(m_SULayer:getWidgetByName("Label_num"),"Label")
	local label_subTime = tolua.cast(m_SULayer:getWidgetByName("Label_sec"),"Label")
	local label_curNum = tolua.cast(m_SULayer:getWidgetByName("Label_yetnum"),"Label")
	--image
	local img_use = tolua.cast(m_SULayer:getWidgetByName("Image_shitou"),"ImageView")
	local img_own = tolua.cast(m_SULayer:getWidgetByName("Image_yetimg"),"ImageView")
	
	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(img_use,iconID,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(img_own,iconID,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil

	img_own:loadTexture(nPath)
	img_use:loadTexture(nPath)
	local label_name = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,ScienceName,ccp(0,0),COLOR_Black, ccc3(255,194,30),true,ccp(0,-2),2)
	m_name:addChild(label_name)

	cur_UseNum:setText(num)
	label_useNum:setText(num)
	label_time:setText(t_UpT)
	label_curNum:setText(cur_num)
	label_subTime:setText(suTime)
	local function ShowTime(  )
		s_second = s_second..""
		s_minute = s_minute..""
		s_hour = s_hour..""
		if string.len(s_second) == 1 then
			s_second = "0"..s_second
		end
		if string.len(s_minute) == 1 then
			 s_minute = "0"..s_minute
		end
		if string.len(s_hour) == 1 then
			s_hour = "0"..s_hour
		end
		label_time:setText(s_minute) --..":"..s_second  s_hour..":"..
	end
	ShowTime()
	local function SetDelayCutTime(nSecend)
		if nSecend < 0 then return end
		local n_handTime = nil
		nDelayTime = nSecend
		local strM = math.floor(nSecend/60)
		local strS = math.floor(nSecend%60)
		local strTemp = ""
		if tonumber(strM) < 10 then strM = "0" .. strM end
		if tonumber(strS) < 10 then strS = "0" .. strS end
			
		label_time:setText(strM)
		local function tick(dt)
			if nDelayTime == 0 then
				m_SULayer:getScheduler():unscheduleScriptEntry(s_UptimeHand)
				s_UptimeHand = nil
			end
			nDelayTime = nDelayTime -1
			SetDelayCutTime(nDelayTime)
		end
		if s_UptimeHand == nil then
			s_UptimeHand = m_SULayer:getScheduler():scheduleScriptFunc(tick, 1, false)
		end
			
	end
	SetDelayCutTime(t_UpT)
	--各种回调函数
	--返回函数
	local function _Click_Close_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			if s_UptimeHand ~= nil then
				m_SULayer:getScheduler():unscheduleScriptEntry(s_UptimeHand)
				s_UptimeHand = nil
			end
			m_SULayer:setVisible(false)
			m_SULayer:removeFromParentAndCleanup(true)
			m_SULayer = nil
			
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				local ss_UpT = tonumber(GetScienceTimeByID(nScienceID))
				CorpsScienceUpLayer.CountDownTime(ss_UpT)
			end
			Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
			NetWorkLoadingLayer.loadingShow(true)
		end
	end

	local btn_subTen = nil
	local btn_sub = nil
	local btn_add = nil
	local btn_addTen = nil
	local label_least = nil
	local label_most = nil
	local img_sub = nil
	local img_add = nil
	local pSpriteScience_least = nil
	local pSpriteScience_sub = nil
	local pSpriteScience_add = nil
	local pSpriteScience_most = nil
	local pSpriteScience_lleast = nil
	local pSpriteScience_ladd = nil
	local pSpriteScience_lsub = nil
	local pSpriteScience_lmost = nil

	local function _Click_SubTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			--[[SpriteSetGray(pSpriteScience_most,0)
			SpriteSetGray(pSpriteScience_add,0)
			SpriteSetGray(pSpriteScience_lmost,0)
			SpriteSetGray(pSpriteScience_ladd,0)
			SpriteSetGray(pSpriteScience_least,1)
			SpriteSetGray(pSpriteScience_sub,1)
			SpriteSetGray(pSpriteScience_lleast,1)
			SpriteSetGray(pSpriteScience_lsub,1)
			btn_addTen:setTouchEnabled(true)
			btn_add:setTouchEnabled(true)
			btn_subTen:setTouchEnabled(false)
			btn_sub:setTouchEnabled(false)]]--
			if num <= 10 then
				num = 1
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1638,nil)
				pTips = nil
			else
				num = num - 10
			end
			cur_UseNum:setText(num)
			label_useNum:setText(num)
			if suTime <= 100 then
				suTime = 10
				num= num
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1638,nil)
				pTips = nil
			else
				suTime = suTime - 10*g_Time
			end
			
			label_subTime:setText(suTime)
		end
	end
	local function _Click_Sub_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			if num <= 1 then
				--[[SpriteSetGray(pSpriteScience_least,1)
				SpriteSetGray(pSpriteScience_sub,1)
				SpriteSetGray(pSpriteScience_lleast,1)
				SpriteSetGray(pSpriteScience_lsub,1)
				
				btn_subTen:setTouchEnabled(false)
				btn_sub:setTouchEnabled(false)]]--
				num = 1
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1638,nil)
				pTips = nil
			else
				--[[SpriteSetGray(pSpriteScience_most,0)
				SpriteSetGray(pSpriteScience_add,0)
				SpriteSetGray(pSpriteScience_lmost,0)
				SpriteSetGray(pSpriteScience_ladd,0)
				btn_addTen:setTouchEnabled(true)
				btn_add:setTouchEnabled(true)]]--
				num = num - 1
				if num <= 1 then
					--[[SpriteSetGray(pSpriteScience_least,1)
					SpriteSetGray(pSpriteScience_sub,1)
					SpriteSetGray(pSpriteScience_lleast,1)
					SpriteSetGray(pSpriteScience_lsub,1)
					
					btn_subTen:setTouchEnabled(false)
					btn_sub:setTouchEnabled(false)]]--
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1638,nil)
					pTips = nil
					num = num
				end
			end
			cur_UseNum:setText(num)
			label_useNum:setText(num)
			if suTime <= 10 then
				suTime = 10
			else
				suTime = suTime - g_Time
			end
			
			label_subTime:setText(suTime)
		end
	end
	local function _Click_Add_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			if num >= tonumber(cur_num) then
				if tonumber(cur_num) == 0 then
					num = 1
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1639,nil)
					pTips = nil
				else
					num = cur_num
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1637,nil)
					pTips = nil
				end
				
				
			else
				--[[SpriteSetGray(pSpriteScience_least,0)
				SpriteSetGray(pSpriteScience_sub,0)
				SpriteSetGray(pSpriteScience_lleast,0)
				SpriteSetGray(pSpriteScience_lsub,0)
				btn_subTen:setTouchEnabled(true)
				btn_sub:setTouchEnabled(true)]]--
				num = num + 1
			end
			cur_UseNum:setText(num)
			label_useNum:setText(num)
			suTime = num*g_Time
			if tonumber(suTime) >= tonumber(s_minute) then
				suTime = num*g_Time
				cur_UseNum:setText(num)
				label_useNum:setText(num)
				--[[SpriteSetGray(pSpriteScience_most,1)
				SpriteSetGray(pSpriteScience_add,1)
				SpriteSetGray(pSpriteScience_lmost,1)
				SpriteSetGray(pSpriteScience_ladd,1)]]--
				cur_num = num	
				-- btn_addTen:setTouchEnabled(false)
				-- btn_add:setTouchEnabled(false)
			else
				local cur_item = server_itemDB.GetItemNumberByTempId(iconID)
				if tonumber(tonumber(cur_item) - num) == 0 then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1639,nil)
					pTips = nil
				end
			end
			label_subTime:setText(suTime)
		end
	end
	local function _Click_AddTen_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			
			--[[SpriteSetGray(pSpriteScience_least,0)
			SpriteSetGray(pSpriteScience_sub,0)
			SpriteSetGray(pSpriteScience_lleast,0)
			SpriteSetGray(pSpriteScience_lsub,0)]]--
			
			btn_subTen:setTouchEnabled(true)
			btn_sub:setTouchEnabled(true)
			num = num + 10
			if num >= tonumber(cur_num) then
				if tonumber(cur_num) == 0 then
					num = 1
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1639,nil)
					pTips = nil
				else
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1637,nil)
					pTips = nil
					num = cur_num
				end
			end
			cur_UseNum:setText(num)
			label_useNum:setText(num)
			suTime = num*g_Time
			if tonumber(suTime) >= tonumber(s_minute) then
				--[[SpriteSetGray(pSpriteScience_most,1)
				SpriteSetGray(pSpriteScience_add,1)
				SpriteSetGray(pSpriteScience_lmost,1)
				SpriteSetGray(pSpriteScience_ladd,1)]]--
				-- btn_addTen:setTouchEnabled(false)
				-- btn_add:setTouchEnabled(false)
				num = math.ceil(s_minute/10)
				suTime = num*10
				cur_num = num
				cur_UseNum:setText(num)
				label_useNum:setText(num)
			else
				local cur_item = server_itemDB.GetItemNumberByTempId(iconID)
				if tonumber(tonumber(cur_item) - num) == 0 then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1639,nil)
					pTips = nil
				end
			end
			label_subTime:setText(suTime)
		end
	end
	local function _Click_Certain_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				if s_UptimeHand ~= nil then
					m_SULayer:getScheduler():unscheduleScriptEntry(s_UptimeHand)
					s_UptimeHand = nil
				end
				m_SULayer:setVisible(false)
				m_SULayer:removeFromParentAndCleanup(true)
				m_SULayer = nil
				local tabTime = CorpsScienceData.GetScienceSpeedDB()
				-- CorpsScienceUpLayer.CountDownTime(tabTime)
			end
			Packet_CorpsScienceSpeedUp.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_CorpsScienceSpeedUp.CreatePacket(nScienceID,num))
			NetWorkLoadingLayer.loadingShow(true)
		elseif eventType == TouchEventType.began then
		end
	end
	--text
	local m_CertainText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "确定使用", ccp(0, 0), COLOR_Black, ccc3(255,255,255), true, ccp(0, -3), 3)

	--button
	btn_subTen = tolua.cast(m_SULayer:getWidgetByName("Button_sunTen"),"Button")
	btn_sub = tolua.cast(m_SULayer:getWidgetByName("Button_sub"),"Button")
	btn_add = tolua.cast(m_SULayer:getWidgetByName("Button_add"),"Button")
	btn_addTen = tolua.cast(m_SULayer:getWidgetByName("Button_addTen"),"Button")
	label_least = tolua.cast(btn_subTen:getChildByName("Label_13"),"Label")
	label_most = tolua.cast(btn_addTen:getChildByName("Label_14"),"Label")
	img_sub = tolua.cast(btn_sub:getChildByName("Image_15"),"ImageView")
	img_add = tolua.cast(btn_add:getChildByName("Image_16"),"ImageView")

	pSpriteScience_least = tolua.cast(btn_subTen:getVirtualRenderer(), "CCSprite")
	pSpriteScience_sub = tolua.cast(btn_sub:getVirtualRenderer(), "CCSprite")
	pSpriteScience_add = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
	pSpriteScience_most = tolua.cast(btn_addTen:getVirtualRenderer(), "CCSprite")
	pSpriteScience_lleast = tolua.cast(label_least:getVirtualRenderer(), "CCSprite")
	pSpriteScience_lsub = tolua.cast(img_sub:getVirtualRenderer(), "CCSprite")
	pSpriteScience_ladd = tolua.cast(img_add:getVirtualRenderer(), "CCSprite")
	pSpriteScience_lmost = tolua.cast(label_most:getVirtualRenderer(), "CCSprite")

	--[[if tonumber(cur_num) == 0 or tonumber(suTime) >= tonumber(s_minute) then
		SpriteSetGray(pSpriteScience_most,1)
		SpriteSetGray(pSpriteScience_add,1)
		SpriteSetGray(pSpriteScience_lmost,1)
		SpriteSetGray(pSpriteScience_ladd,1)
		SpriteSetGray(pSpriteScience_least,1)
		SpriteSetGray(pSpriteScience_sub,1)
		SpriteSetGray(pSpriteScience_lleast,1)
		SpriteSetGray(pSpriteScience_lsub,1)
		btn_addTen:setTouchEnabled(false)
		btn_add:setTouchEnabled(false)
		btn_subTen:setTouchEnabled(false)
		btn_sub:setTouchEnabled(false)
	else
		SpriteSetGray(pSpriteScience_most,0)
		SpriteSetGray(pSpriteScience_add,0)
		SpriteSetGray(pSpriteScience_lmost,0)
		SpriteSetGray(pSpriteScience_ladd,0)
		SpriteSetGray(pSpriteScience_least,1)
		SpriteSetGray(pSpriteScience_sub,1)
		SpriteSetGray(pSpriteScience_lleast,1)
		SpriteSetGray(pSpriteScience_lsub,1)
		btn_addTen:setTouchEnabled(true)
		btn_add:setTouchEnabled(true)
		btn_subTen:setTouchEnabled(false)
		btn_sub:setTouchEnabled(false)
	end]]--

	local btn_return = tolua.cast(m_SULayer:getWidgetByName("Button_return"),"Button")
	local btn_certain = tolua.cast(m_SULayer:getWidgetByName("Button_certain"),"Button")

	btn_certain:addChild(m_CertainText)
	btn_certain:addTouchEventListener(_Click_Certain_CallBack)
	btn_return:addTouchEventListener(_Click_Close_CallBack)
	btn_subTen:addTouchEventListener(_Click_SubTen_CallBack)
	btn_sub:addTouchEventListener(_Click_Sub_CallBack)
	btn_add:addTouchEventListener(_Click_Add_CallBack)
	btn_addTen:addTouchEventListener(_Click_AddTen_CallBack)

end

function ShowScienceItemIcons( pIconContrl,ntempId,tab,nType,nLv )
	pIconContrl:loadTexture("Image/imgres/equip/icon/bottom.png")
	-- pIconContrl:setPosition(ccp(20,-10))
	local _Img_icon_ = ImageView:create()
	local tableValue = tab[nLv]
	_Img_icon_:loadTexture(GetScienceIconImg(tableValue[3]))  --  GetScienceImg
	_Img_icon_:setPosition(ccp(0,0))

	--AddLabelImg(_Img_icon_,1000,pIconContrl)
	

	local _Img_head_sprite_1 = tolua.cast(pIconContrl:getVirtualRenderer(), "CCSprite")
	MakeMaskIcon(_Img_head_sprite_1, "Image/imgres/common/bottom.png", 0, 1, "Image/imgres/common/color/icon_mask.png")

	local _Img_head_sprite_1 = tolua.cast(_Img_icon_:getVirtualRenderer(), "CCSprite")
	MakeMaskIcon(_Img_head_sprite_1, GetScienceIconImg(tableValue[3]), 0, 1, "Image/imgres/common/color/icon_mask.png")

	local _Img_icon = ImageView:create()
	_Img_icon:loadTexture("Image/imgres/common/color/wj_pz7.png")

	AddLabelImg(_Img_icon_,1000,_Img_icon)

	_Img_icon:setTouchEnabled(true)
	-- _Img_icon:setPosition(ccp(100,-100))
	AddLabelImg(_Img_icon,1000,pIconContrl)

	if nLv ~= nil then
		local label_lv = LabelLayer.createStrokeLabel(24,CommonData.g_FONT3,string.format("Lv.%d",tableValue[2]),ccp(-46,-40),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
		if _Img_icon_:getChildByTag(51) ~= nil then
			_Img_icon_:getChildByTag(51):setVisible(false)
			_Img_icon_:getChildByTag(51):removeFromParentAndCleanup(true)
		end
		_Img_icon_:addChild(label_lv, 0, 51)

		--local label_name = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,string.format(tableValue[4]),ccp(-60,-90),COLOR_Black,ccc3(255,234,19),false,ccp(0,-2),2)
		local label_name = Label:create()
		label_name:setFontSize(22)
		label_name:setColor(ccc3(255,234,19))
		label_name:setFontName(CommonData.g_FONT1)
		label_name:setPosition(ccp(0,-90))
		label_name:setText(string.format(tableValue[4]))
		if pIconContrl:getChildByTag(52) ~= nil then
			pIconContrl:getChildByTag(52):setVisible(false)
			pIconContrl:getChildByTag(52):removeFromParentAndCleanup(true)
		end
		pIconContrl:addChild(label_name, 0, 52)
	end

	return _Img_icon
end

--[[function CreateSType(  )
	local tab = {
		createScienceType 	= createScienceType,
		SetScienceEffID 	= SetScienceEffID,
		SetScienceDes		= SetScienceDes,
		SetScienceName		= SetScienceName,
		SetScienceImg		= SetScienceImg,
		SetScienceLV		= SetScienceLV,
		SetScienceIndex		= SetScienceIndex,
		SetScienceID        = SetScienceID,
	}
	return tab
end]]--