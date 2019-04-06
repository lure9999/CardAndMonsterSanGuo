require "Script/Main/Corps/CorpsLogic"
require "Script/serverDB/server_itemDB"
module("CorpsMercenaryTipLayer",package.seeall)
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryData"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryLogic"
local GetRobotImg = CorpsMercenaryData.GetRobotImg
local GetColorImgPath = CorpsMercenaryData.GetColorImgPath
local CheckWhetherOwn = CorpsMercenaryLogic.CheckWhetherOwn

local m_MercenaryInfo = nil
local m_YetMercenaryInfo = nil
local m_MercenaryRenew = nil
local m_day = 1
local label_time = nil
local m_timeHand = nil
local label_time = nil
local m_handtime = nil
local t_day = 86400
local t_hour = 3600
local t_minte = 60
local GetRobotImg = CorpsMercenaryData.GetRobotImg
local cleanListView   = CorpsMercenaryLogic.cleanListView

function SearchId( id, tableData )
	for key,value in pairs(tableData) do
		if value == id then
			return true
		end
	end
	return false
end
--已拥有佣兵所剩余时间
local function RemainingTime( nTime )
				
	-- local S_UpT = CorpsScienceData.GetScienceUpT()
	local S_UpT = nTime
	local s_day = math.floor(nTime / t_day)
	local s_hour = math.floor(nTime / t_hour) - math.floor(nTime / t_day)*24
	local s_minute = math.floor(nTime / t_minte) - math.floor(nTime / t_hour)*60
	local s_second = S_UpT%60
	local s_hourStr = nil
	local s_minuteStr = nil
	local s_secondStr = nil
	----------------------处理分钟的操作------------------------------------------

	local function UpTime( dt )
		s_second = s_second - 1
		if s_second == -1 then
			if s_minute ~= -1 or s_hour ~= -1 then
				s_minute = s_minute - 1
				s_second = 59
				if s_minute == -1 then
					if s_hour ~= -1 then
						s_hour = s_hour - 1
						s_minute = 59
						if s_hour == -1 then
							s_day = s_day - 1
							s_hour = 23
							if s_day == -1 then
								if m_timeHand ~= nil then
									CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_timeHand)
									m_timeHand = nil
								end
								s_hour = 0
								s_minute = 0
								s_second = 0
							end
						end
					end
				end
			end
		end
		if s_day >= 1 then
			label_time:setText(s_day.."天"..s_hour.."小时")
		else
			if s_hour >= 1 then
				label_time:setText(s_hour.."小时"..s_minute.."分")
			else
				label_time:setText(s_minute.."分")
			end
		end
	end
	m_timeHand = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(UpTime, 1, false)
end

local function SetYongbingPower( num )
	local labelheroPower = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_Power"),"Label")
	if labelheroPower:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(labelheroPower:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(num)
	else
		local pText = LabelBMFont:create()	
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-50,-50))
		pText:setAnchorPoint(ccp(0,0))
		pText:setText(num)
		labelheroPower:addChild(pText,0,1000)
	end
end

function MercenaryInfoLayer( Mess,tabID,m_tableLevelInfo,tableMercenaryRobotDB,tableHaveMercenaryDB )
	if m_MercenaryInfo == nil then
		m_MercenaryInfo = TouchGroup:create()									-- 背景层
	    m_MercenaryInfo:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryHero.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_MercenaryInfo, 121, 121)
	end
	---------------------------------------------------------------------------------------------------------------
	--button
	local function _Click_Return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_MercenaryInfo:setVisible(false)
			m_MercenaryInfo:removeFromParentAndCleanup(true)
			m_MercenaryInfo = nil
		end
	end
	local btn_return = tolua.cast(m_MercenaryInfo:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_Return_CallBack)
	---------------------------------------------------------------------------------------------------------------
	local image_bg = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_bg"),"ImageView")
	local image_head = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_heroIcon"),"ImageView")
	local label_name = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_name"),"Label")
	local label_cost = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_cost"),"Label")
	local label_costNum = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_costNum"),"Label")
	local label_shengjia = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_shenjianum"),"Label")
	local label_time = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_89"),"Label")
	local btn_cost = tolua.cast(m_MercenaryInfo:getWidgetByName("Button_cost"),"Button")
	local image_empty = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_100"),"ImageView")
	local b_image = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_35"),"ImageView")
	local h_image = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_73"),"ImageView")
	local img_level = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_level"),"ImageView")
	local img_shengjia = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_shengjia"),"ImageView")
	local label_Curshengjia = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_shengjia"),"Label")
	-- local lable_level = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,Mess.level,ccp(0,0),COLOR_Black,ccc3(255,194,30),true,ccp(0,-2),2)
	-- AddLabelImg(lable_level,10,img_level)
	--折扣系数
	local d_count = CorpsMercenaryData.GetHireRebate(tabID)
	local image_rebate = tolua.cast(m_MercenaryInfo:getWidgetByName("Image_discount"),"ImageView")

	local dis_countNum = tonumber(d_count)*10
	local label_rebate = Label:create()
	label_rebate:setFontSize(18)
	label_rebate:setRotation(-45)
	label_rebate:setColor(ccc3(255,194,30))
	label_rebate:setText(dis_countNum.."折")
	label_rebate:setPosition(ccp(-5,6))
	image_rebate:addChild(label_rebate)
	if tonumber(d_count) == 1 then
		image_rebate:setVisible(false)
	end


	local lable_level = Label:create()
	lable_level:setFontSize(20)
	lable_level:setText(Mess.level)
	img_level:addChild(lable_level)

	local totalsTime,cur_hour,cur_min = CorpsMercenaryData.GetResTime()
	label_time:setText(cur_hour.."小时"..cur_min.."分")

	image_empty:loadTexture("Image/imgres/main/fight.png")

	local labelNameText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, Mess.name, ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, -2), 2)
	label_name:addChild(labelNameText)

	-- image_head:loadTexture(GetRobotImg(Mess.iconID))
	UIInterface.MakeHeadIcon(image_head,ICONTYPE.GENERAL_COLOR_ICON,Mess.iconID,nil,Mess.level,nil,Mess.nColorID,nil)
		
	
	SetYongbingPower(Mess.power)
	
	-- label_costNum:setText(Mess.power)
	local function GetCorpsMoney(  )
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingHideNow()
			local tablePersonInfo = {}
			tablePersonInfo = CorpsData.GetCorpsPersonInfo()
			-- CorpsScene.SetCorpsContribute(tablePersonInfo.m_nContribute)
		end
		Packet_CorpsPersonInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsPersonInfo.CreatePacket())
		NetWorkLoadingLayer.loadingShow(true)
	end
	local function _Click_Hire_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local checkMercenaryDB = {}
			for key,value in pairs(tableMercenaryRobotDB) do
				if tabID == key then
					checkMercenaryDB = value
				end
			end
			if CheckWhetherOwn(checkMercenaryDB.id,tableHaveMercenaryDB) == true then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1467,nil)
				pTips = nil
			else
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					AudioUtil.PlayBtnClick()
					m_MercenaryInfo:setVisible(false)
					m_MercenaryInfo:removeFromParentAndCleanup(true)
					m_MercenaryInfo = nil
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1461,nil)
					pTips = nil
					CorpsScene.GetConteobile(1)
					CorpsMercenaryLayers.showUI()
					GetCorpsMoney()
				end
				Packet_HireMercenary.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_HireMercenary.CreatePacket(tabID))
				NetWorkLoadingLayer.loadingShow(true)
			end
			
		end
	end

	local labelBtnText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "雇佣", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	btn_cost:addChild(labelBtnText)
    btn_cost:addTouchEventListener(_Click_Hire_CallBack)
	---------------------------------------------------------------------------------------------------------------
	--需要机器人队伍的信息
	local m_tabRobotCampInfo = {}
	local b_tabConsumInfo = {}
	local h_tabConsumInfo = {}

	

	m_tabRobotCampInfo = CorpsMercenaryData.GetMercenaryCampInfo()
	b_tabConsumInfo = CorpsMercenaryData.GetBloodConsumInfo()
	h_tabConsumInfo = CorpsMercenaryData.GetHireConsumInfo()
	local b_path = nil
	if b_tabConsumInfo[1].bConsumType == 0 then
		b_path = CorpsMercenaryData.GetConsumItem(b_tabConsumInfo[1].bConsumID)
	else
		b_path = CorpsMercenaryData.GetBHConsumPath(b_tabConsumInfo[1].bConsumType)
	end
	local h_path = nil
	if h_tabConsumInfo[1].hConsumType == 0 then
		h_path = CorpsMercenaryData.GetConsumItem(h_tabConsumInfo[1].hConsumID)
	else
		h_path = CorpsMercenaryData.GetBHConsumPath(h_tabConsumInfo[1].hConsumType)
	end
	b_image:loadTexture(b_path)
	label_costNum:setText(b_tabConsumInfo[1].bConsumNum)
	--h_image:loadTexture(h_path)
	--label_shengjia:setText(h_tabConsumInfo[1].hConsumNum)
	----原价
	-- local costNum,coinPath,dis_count,OriCost = CorpsMercenaryData.GetTeffectPara(m_tableLevelInfo.TechEffID1,tabID+1)
	img_shengjia:loadTexture(h_path)
	local hire_consum = 0
	hire_consum = h_tabConsumInfo[1].hConsumNum*d_count
	label_Curshengjia:setText(h_tabConsumInfo[1].hConsumNum)

	-- h_image:setScale(0.5)
	h_image:loadTexture(h_path)
	label_shengjia:setText(hire_consum)

	local function loadInfoControl( pControl ,pTabRobot)
		local hero_head = tolua.cast(pControl:getChildByName("Image_hero1"),"ImageView")
		-- hero_head:setScale(0.65)
		if next(pTabRobot) ~= nil then
			UIInterface.MakeHeadIcon(hero_head,ICONTYPE.GENERAL_COLOR_ICON,pTabRobot.faceID,nil,nil,nil,nil,nil)
			for i=1, pTabRobot["starLevel"] do
				local star = ImageView:create()
				star:loadTexture("Image/imgres/common/star.png")
				star:setPosition(ccp(-40 + (i-1) * 22, -48))
				star:setFlipX(false)
				hero_head:addChild(star)
			end
		end

	end

	local function InitWidgetControl( pControl ,pTabbcon)
		loadInfoControl(pControl,pTabbcon)
	end

	local image_hero1 = tolua.cast(image_bg:getChildByName("Image_37"),"ImageView")
	local image_hero2 = tolua.cast(image_bg:getChildByName("Image_37_0"),"ImageView")
	local image_hero3 = tolua.cast(image_bg:getChildByName("Image_37_1"),"ImageView")
	local image_hero4 = tolua.cast(image_bg:getChildByName("Image_37_2"),"ImageView")
	local image_hero5 = tolua.cast(image_bg:getChildByName("Image_37_3"),"ImageView")
	local image_hero6 = tolua.cast(image_bg:getChildByName("Image_37_4"),"ImageView")

	InitWidgetControl(image_hero1,m_tabRobotCampInfo[6])
	InitWidgetControl(image_hero2,m_tabRobotCampInfo[5])
	InitWidgetControl(image_hero3,m_tabRobotCampInfo[4])
	InitWidgetControl(image_hero4,m_tabRobotCampInfo[3])
	InitWidgetControl(image_hero5,m_tabRobotCampInfo[2])
	InitWidgetControl(image_hero6,m_tabRobotCampInfo[1])
	---------------------------------------------------------------------------------------------------------------

	return m_MercenaryInfo
end

--佣兵续期界面
function MercenaryRenewLayer( tabValue,GridID )
	if m_MercenaryRenew == nil then
		m_MercenaryRenew = TouchGroup:create()									-- 背景层
	    m_MercenaryRenew:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryXufei.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_MercenaryRenew, 123, 123)
	end
	------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------
	-----------------------
	m_day = 1
	local label_day = tolua.cast(m_MercenaryRenew:getWidgetByName("Label_day"),"Label")
	local label_curDay = tolua.cast(m_MercenaryRenew:getWidgetByName("Label_curDay"),"Label")
	local image_consumcost = tolua.cast(m_MercenaryRenew:getWidgetByName("Image_moneyicon"),"ImageView")
	local label_cost = tolua.cast(m_MercenaryRenew:getWidgetByName("Label_cost"),"Label")
	local label_Ruleexplain = tolua.cast(m_MercenaryRenew:getWidgetByName("Label_52"),"Label")
	local image_CurMoney = tolua.cast(m_MercenaryRenew:getWidgetByName("Image_60"),"ImageView")
	local label_curMoney = tolua.cast(m_MercenaryRenew:getWidgetByName("Label_curMoney"),"Label")
	local btn_label = tolua.cast(m_MercenaryRenew:getWidgetByName("Button_label"),"Button")

	----------------------------------------
	---基本数据
	local tabConsum = {}
	local tabXuFeiConsum = CorpsMercenaryData.GetHireConsumInfo()
	local XFDis = CorpsMercenaryData.GetXuFeiDis(GridID)
	local moneyNum = math.floor(tabXuFeiConsum[1]["hConsumNum"]*XFDis)
	
	tabConsum = CorpsMercenaryData.GetXuFeiConsum(tabValue["id"])
	image_consumcost:loadTexture(tabConsum.TabData[1]["IconPath"])
	image_CurMoney:loadTexture(tabConsum.TabData[1]["IconPath"])
	label_cost:setText(moneyNum)
	label_curMoney:setText(tabConsum.TabData[1]["ItemNum"])
	---------------------------------------------
	--[[local text = "规则说明"
	local lenText = CorpsLogic.ComminuteText(text)
	local label_RuleText = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, text, ccp(0, 0), COLOR_Black, COLOR_Green, true, ccp(0, -2), 2)
	label_Ruleexplain:addChild(label_RuleText)
	local lengthPos = lenText*25
	local line = AddLine(ccp(0 - lengthPos / 2,-10),ccp(lengthPos / 2,-10),COLOR_Green,1,255)
	label_Ruleexplain:addNode(line)]]--
	--文字监听事件
	local function _Click_BtnLabel_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			print("文字监听事件")
		end
	end
	--btn_label:addTouchEventListener(_Click_BtnLabel_CallBack)
	local most_day = CorpsMercenaryData.GetDayRebate()
	label_day:setText(m_day)
	local cur_second = tabValue.times
	local cur_day = math.ceil(cur_second / t_day)  --向下取整
	local day_nmmm = math.ceil(cur_second / t_day)  --向上取整
	local Remain_Day = most_day - cur_day
	label_curDay:setText("该佣兵剩余"..cur_day.."天,".."续费"..m_day.."天")
	-------------------------------------------------------------------------------------------------------
	local function _Click_return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_MercenaryRenew:setVisible(false)
			m_MercenaryRenew:removeFromParentAndCleanup(true)
			m_MercenaryRenew = nil
		end
	end
	--返回按钮
	local btn_XuFeireturn = tolua.cast(m_MercenaryRenew:getWidgetByName("Button_68"),"Button")
	btn_XuFeireturn:addTouchEventListener(_Click_return_CallBack)

	local btn_least = nil
	local btn_sub = nil
	local btn_add = nil
	local btn_most = nil
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

	
	local function _Click_SubLeast_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			SpriteSetGray(pSpriteScience_most,0)
			SpriteSetGray(pSpriteScience_add,0)
			SpriteSetGray(pSpriteScience_lmost,0)
			SpriteSetGray(pSpriteScience_ladd,0)
			SpriteSetGray(pSpriteScience_least,1)
			SpriteSetGray(pSpriteScience_sub,1)
			SpriteSetGray(pSpriteScience_lleast,1)
			SpriteSetGray(pSpriteScience_lsub,1)
			btn_most:setTouchEnabled(true)
			btn_add:setTouchEnabled(true)
			btn_least:setTouchEnabled(false)
			btn_sub:setTouchEnabled(false)
			m_day = 1
			label_day:setText(m_day)
			label_curDay:setText("该佣兵剩余"..cur_day.."天,".."续费"..m_day.."天")
			label_cost:setText(moneyNum*m_day)
		end
	end
	local function _Click_sub_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if m_day <= 1 then
				
				SpriteSetGray(pSpriteScience_least,1)
				SpriteSetGray(pSpriteScience_sub,1)
				SpriteSetGray(pSpriteScience_lleast,1)
				SpriteSetGray(pSpriteScience_lsub,1)
				
				btn_least:setTouchEnabled(false)
				btn_sub:setTouchEnabled(false)
				m_day = 1
			else
				SpriteSetGray(pSpriteScience_most,0)
				SpriteSetGray(pSpriteScience_add,0)
				SpriteSetGray(pSpriteScience_lmost,0)
				SpriteSetGray(pSpriteScience_ladd,0)
				btn_most:setTouchEnabled(true)
				btn_add:setTouchEnabled(true)
				m_day = m_day - 1
				if m_day <= 1 then
					SpriteSetGray(pSpriteScience_least,1)
					SpriteSetGray(pSpriteScience_sub,1)
					SpriteSetGray(pSpriteScience_lleast,1)
					SpriteSetGray(pSpriteScience_lsub,1)
					
					btn_least:setTouchEnabled(false)
					btn_sub:setTouchEnabled(false)
				end
			end
			label_day:setText(m_day)
			label_curDay:setText("该佣兵剩余"..cur_day.."天,".."续费"..m_day.."天")
			label_cost:setText(moneyNum*m_day)
		end
	end
	local function _Click_Add_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			if m_day >= (most_day - cur_day) then
				SpriteSetGray(pSpriteScience_most,1)
				SpriteSetGray(pSpriteScience_add,1)
				SpriteSetGray(pSpriteScience_lmost,1)
				SpriteSetGray(pSpriteScience_ladd,1)
				
				btn_most:setTouchEnabled(false)
				btn_add:setTouchEnabled(false)
				
				m_day = most_day - cur_day
			else
				SpriteSetGray(pSpriteScience_least,0)
				SpriteSetGray(pSpriteScience_sub,0)
				SpriteSetGray(pSpriteScience_lleast,0)
				SpriteSetGray(pSpriteScience_lsub,0)
				btn_least:setTouchEnabled(true)
				btn_sub:setTouchEnabled(true)
				m_day = m_day + 1
				if m_day >= (most_day - cur_day) then
					SpriteSetGray(pSpriteScience_most,1)
					SpriteSetGray(pSpriteScience_add,1)
					SpriteSetGray(pSpriteScience_lmost,1)
					SpriteSetGray(pSpriteScience_ladd,1)
					
					btn_most:setTouchEnabled(false)
					btn_add:setTouchEnabled(false)
				end
				
			end
			label_day:setText(m_day)
			label_curDay:setText("该佣兵剩余"..cur_day.."天,".."续费"..m_day.."天")
			label_cost:setText(moneyNum*m_day)
		end
	end
	local function _Click_Most_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local btn_spritMost = tolua.cast(sender,"Button")
			local pSpriteScience_most1 = tolua.cast(btn_spritMost:getVirtualRenderer(), "CCSprite")
			SpriteSetGray(pSpriteScience_most1,1)
			SpriteSetGray(pSpriteScience_add,1)
			SpriteSetGray(pSpriteScience_lmost,1)
			SpriteSetGray(pSpriteScience_ladd,1)
			SpriteSetGray(pSpriteScience_least,0)
			SpriteSetGray(pSpriteScience_sub,0)
			SpriteSetGray(pSpriteScience_lleast,0)
			SpriteSetGray(pSpriteScience_lsub,0)
			btn_most:setTouchEnabled(false)
			btn_add:setTouchEnabled(false)
			btn_least:setTouchEnabled(true)
			btn_sub:setTouchEnabled(true)
			if cur_day >= most_day then
				m_day = 1
			else
				m_day = Remain_Day
			end
			label_day:setText(m_day)
			label_curDay:setText("该佣兵剩余"..cur_day.."天,".."续费"..m_day.."天")
			label_cost:setText(moneyNum*m_day)
		end
	end
	----添加，减少按钮
	btn_least = tolua.cast(m_MercenaryRenew:getWidgetByName("Button_least"),"Button")
	btn_sub = tolua.cast(m_MercenaryRenew:getWidgetByName("Button_sun"),"Button")
	btn_add = tolua.cast(m_MercenaryRenew:getWidgetByName("Button_add"),"Button")
	btn_most = tolua.cast(m_MercenaryRenew:getWidgetByName("Button_most"),"Button")
	label_least = tolua.cast(btn_least:getChildByName("Label_29"),"Label")
	label_most = tolua.cast(btn_most:getChildByName("Label_37"),"Label")
	img_sub = tolua.cast(btn_sub:getChildByName("Image_33"),"ImageView")
	img_add = tolua.cast(btn_add:getChildByName("Image_35"),"ImageView")

	pSpriteScience_least = tolua.cast(btn_least:getVirtualRenderer(), "CCSprite")
	pSpriteScience_sub = tolua.cast(btn_sub:getVirtualRenderer(), "CCSprite")
	pSpriteScience_add = tolua.cast(btn_add:getVirtualRenderer(), "CCSprite")
	pSpriteScience_most = tolua.cast(btn_most:getVirtualRenderer(), "CCSprite")
	pSpriteScience_lleast = tolua.cast(label_least:getVirtualRenderer(), "CCSprite")
	pSpriteScience_lsub = tolua.cast(img_sub:getVirtualRenderer(), "CCSprite")
	pSpriteScience_ladd = tolua.cast(img_add:getVirtualRenderer(), "CCSprite")
	pSpriteScience_lmost = tolua.cast(label_most:getVirtualRenderer(), "CCSprite")

	if tonumber(cur_day) >= most_day then
		SpriteSetGray(pSpriteScience_most,1)
		SpriteSetGray(pSpriteScience_add,1)
		SpriteSetGray(pSpriteScience_lmost,1)
		SpriteSetGray(pSpriteScience_ladd,1)
		SpriteSetGray(pSpriteScience_least,1)
		SpriteSetGray(pSpriteScience_sub,1)
		SpriteSetGray(pSpriteScience_lleast,1)
		SpriteSetGray(pSpriteScience_lsub,1)
		btn_most:setTouchEnabled(false)
		btn_add:setTouchEnabled(false)
		btn_least:setTouchEnabled(false)
		btn_sub:setTouchEnabled(false)
	end
	if tonumber(cur_day) <= 1 or tonumber(m_day) <= 1 then 
		SpriteSetGray(pSpriteScience_least,1)
		SpriteSetGray(pSpriteScience_sub,1)
		SpriteSetGray(pSpriteScience_lleast,1)
		SpriteSetGray(pSpriteScience_lsub,1)
		btn_least:setTouchEnabled(false)
		btn_sub:setTouchEnabled(false)
	end
	btn_add:addTouchEventListener(_Click_Add_CallBack)
	btn_most:addTouchEventListener(_Click_Most_CallBack)
	btn_least:addTouchEventListener(_Click_SubLeast_CallBack)
	btn_sub:addTouchEventListener(_Click_sub_CallBack)
	
	

	--续期
	local function _Click_XuQi_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				m_MercenaryRenew:setVisible(false)
				m_MercenaryRenew:removeFromParentAndCleanup(true)
				m_MercenaryRenew = nil
				CorpsMercenaryLayers.showUI()
				CorpsScene.GetConteobile(2)
			end
			Packet_MercenaryRenew.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_MercenaryRenew.CreatePacket(GridID,m_day))
			NetWorkLoadingLayer.loadingShow(true)
		end
	end
	local labelxuqiText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "续期", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	local btn_xuqi = tolua.cast(m_MercenaryRenew:getWidgetByName("Button_xuqi1"),"Button")
	btn_xuqi:addChild(labelxuqiText)
	btn_xuqi:addTouchEventListener(_Click_XuQi_CallBack)
end

--已经雇佣的佣兵的信息
local function SettYongbingPower( num )
	local labelheroPower = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_Power"),"Label")
	if labelheroPower:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(labelheroPower:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(num)
	else
		local pText = LabelBMFont:create()	
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-15,-17))
		pText:setAnchorPoint(ccp(0.5,0.5))
		pText:setText(num)
		labelheroPower:addChild(pText,0,1000)
	end
end

function YYbInfo( mess,tabId ,m_tableLevelInfo)
	if m_YetMercenaryInfo == nil then
		m_YetMercenaryInfo = TouchGroup:create()
		m_YetMercenaryInfo:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryYetHero.json"))
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_YetMercenaryInfo, 122, 122)
	end
	---------------------------------------------------------------------------------------------------------------
	--button
	local function _Click_Return_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_YetMercenaryInfo:setVisible(false)
			m_YetMercenaryInfo:removeFromParentAndCleanup(true)
			m_YetMercenaryInfo = nil
			if m_timeHand ~= nil then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_timeHand)
				m_timeHand = nil
			end
		end
	end
	local btn_return = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_Return_CallBack)
	---------------------------------------------------------------------------------------------------------------
	local image_bg = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_bg"),"ImageView")
	local image_head = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_heroIcon"),"ImageView")
	local label_name = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_name"),"Label")
	local label_powerWord = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_PowerWord"),"Label")
	-- local label_power = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_Power"),"Label")
	local label_cost = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_cost"),"Label")
	local label_costNum = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_costNum"),"Label")
	local btn_jiegu = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Button_cost"),"Button")
	local btn_xufei = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Button_xuqi"),"Button")
	local image_fight1 = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_96"),"ImageView")
	local b_image = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_35"),"ImageView")
	local h_image = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_73"),"ImageView")
	local h_costNum = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_shenjianum"),"Label")
	local img_level = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_level"),"ImageView")
	local img_shengjia = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_37"),"ImageView")
	local label_cursshengjia = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_38"),"Label")
	local img_end = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_end"),"ImageView")
	local img_agio = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Image_agio"),"ImageView")
	img_agio:setVisible(false)
	img_end:setVisible(false)
	-- local lable_level = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,mess.level,ccp(0,0),COLOR_Black,ccc3(255,194,30),true,ccp(0,-2),2)
	local lable_level = Label:create()
	lable_level:setFontSize(20)
	lable_level:setText(mess.level)
	img_level:addChild(lable_level)

	label_time = tolua.cast(m_YetMercenaryInfo:getWidgetByName("Label_48"),"Label")
	image_fight1:loadTexture("Image/imgres/main/fight.png")
	local labelxuText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "续期", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	local labelBtnText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "解雇", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	

	local function _Click_JieGu_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local function JieGuMercenary( isJieGu )
				if isJieGu == true then
					print("确定解雇")
					local function GetSuccessCallback(  )
						NetWorkLoadingLayer.loadingHideNow()
						m_YetMercenaryInfo:setVisible(false)
						m_YetMercenaryInfo:removeFromParentAndCleanup(true)
						m_YetMercenaryInfo = nil
						if m_timeHand ~= nil then
							CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_timeHand)
							m_timeHand = nil
						end
						CorpsMercenaryLayers.showUI()
					end
					Packet_MercenaryFire.SetSuccessCallBack(GetSuccessCallback)
					network.NetWorkEvent(Packet_MercenaryFire.CreatePacket(tabId))
					NetWorkLoadingLayer.loadingShow(true)
				else
					print("取消解雇")
				end
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1463,JieGuMercenary)
			
		end
	end

	local function _Click_XUFei_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_YetMercenaryInfo:setVisible(false)
			m_YetMercenaryInfo:removeFromParentAndCleanup(true)
			m_YetMercenaryInfo = nil
			if m_timeHand ~= nil then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_timeHand)
				m_timeHand = nil
			end
			MercenaryRenewLayer(mess,tabId)
		end
	end
	--判断数据是否为空
	if next(mess) ~= nil then
		local tabMercenaryCamp = {}
		local tabBloodConsum = {}
		local tabHireConsum = {}
		tabMercenaryCamp = CorpsMercenaryData.GetMercenaryCampInfo()
		tabBloodConsum = CorpsMercenaryData.GetBloodConsumInfo()
		tabHireConsum = CorpsMercenaryData.GetHireConsumInfo()
		local labelNameText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, mess.name, ccp(10, 10), COLOR_Black, ccc3(255,194,30), true, ccp(0, -2), 2)
		label_name:addChild(labelNameText)

		image_head:loadTexture(GetRobotImg(mess.iconID))
		UIInterface.MakeHeadIcon(image_head,ICONTYPE.GENERAL_COLOR_ICON,mess.iconID,nil,nil,nil,mess.nColorID,nil)
		
		--血战,续费费用
		local b_path = nil
		if tabBloodConsum[1].bConsumType == 0 then
			b_path = CorpsMercenaryData.GetConsumItem(tabBloodConsum[1].bConsumID)
		else
			b_path = CorpsMercenaryData.GetBHConsumPath(tabBloodConsum[1].bConsumType)
		end
		local h_path = nil
		if tabHireConsum[1].hConsumType == 0 then
			h_path = CorpsMercenaryData.GetConsumItem(tabHireConsum[1].hConsumID)
		else
			h_path = CorpsMercenaryData.GetBHConsumPath(tabHireConsum[1].hConsumType)
		end

		local dis_countss = CorpsMercenaryData.GetRewenRebate(tabId)
		local dis_countNum = tonumber(dis_countss)*10
		local label_rebate = Label:create()
		label_rebate:setFontSize(18)
		label_rebate:setRotation(-45)
		label_rebate:setColor(ccc3(255,194,30))
		label_rebate:setText(dis_countNum.."折")
		label_rebate:setPosition(ccp(-5,6))
		img_agio:addChild(label_rebate)
		if tonumber(dis_countss) < 1 then
			img_agio:setVisible(true)
		end

		b_image:loadTexture(b_path)
		label_costNum:setText(math.floor(tabBloodConsum[1].bConsumNum*dis_countss))
		h_image:loadTexture(h_path)
		h_costNum:setText(math.floor(tabHireConsum[1].hConsumNum*dis_countss))
		-- label_power:setText(tablePersonInfo.power)
		-- local costNum,coinPath = CorpsMercenaryData.GetTeffectPara(m_tableLevelInfo.TechEffID1,tabId+1)
		img_shengjia:loadTexture(h_path)
		label_cursshengjia:setText(tabHireConsum[1].hConsumNum)

		SettYongbingPower(mess.power)

		-- label_costNum:setText(mess.power)
		btn_jiegu:addChild(labelBtnText)
	    btn_xufei:addChild(labelxuText)
	    btn_xufei:addTouchEventListener(_Click_XUFei_CallBack)
	    btn_jiegu:addTouchEventListener(_Click_JieGu_CallBack)

	    local TotalTime = mess.times
	    local d_day = math.floor(TotalTime / t_day)
		local h_hour = math.floor(TotalTime / t_hour) - math.floor(TotalTime / t_day)*24
		local m_minte = math.floor(TotalTime / t_minte) - math.floor(TotalTime / t_hour)*60
		if TotalTime == 0 then
			img_end:setVisible(true)
			label_time:setText(m_minte.."分")
		else
			if d_day >= 1 then
				label_time:setText(d_day.."天"..h_hour.."小时")
			else
				if h_hour >= 1 then
					label_time:setText(h_hour.."小时"..m_minte.."分")
				else
					label_time:setText(m_minte.."分")
				end
			end
		end
		if TotalTime > 0 then
	    	RemainingTime(TotalTime)
		end
	    local function loadInfoControl( pControl,pTabControl )
			local hero_head = tolua.cast(pControl:getChildByName("Image_head"),"ImageView")
			if next(pTabControl) ~= nil then
				-- pControl:setScale(0.65)
				UIInterface.MakeHeadIcon(hero_head,ICONTYPE.GENERAL_COLOR_ICON,pTabControl.faceID,nil,pTabControl.level,nil,nil,pTabControl.level)
				for i=1, pTabControl["starLevel"] do
					local star = ImageView:create()
					star:loadTexture("Image/imgres/common/star.png")
					star:setPosition(ccp(-40 + (i-1) * 22, -48))
					star:setFlipX(false)
					hero_head:addChild(star)
				end
			end
		end

		local function InitWidgetControl( pControl ,tabControl)
			if next(tabControl) ~= nil then
				loadInfoControl(pControl,tabControl)
			end
		end

		local image_hero1 	= tolua.cast(image_bg:getChildByName("Image_hero1"),"ImageView")
		local image_hero1_0 = tolua.cast(image_bg:getChildByName("Image_hero1_0"),"ImageView")
		local image_hero1_1 = tolua.cast(image_bg:getChildByName("Image_hero1_1"),"ImageView")
		local image_hero1_2 = tolua.cast(image_bg:getChildByName("Image_hero1_2"),"ImageView")
		local image_hero1_3 = tolua.cast(image_bg:getChildByName("Image_hero1_3"),"ImageView")
		local image_hero1_4 = tolua.cast(image_bg:getChildByName("Image_hero1_4"),"ImageView")

		InitWidgetControl(image_hero1,tabMercenaryCamp[6])
		InitWidgetControl(image_hero1_0,tabMercenaryCamp[5])
		InitWidgetControl(image_hero1_1,tabMercenaryCamp[4])
		InitWidgetControl(image_hero1_2,tabMercenaryCamp[3])
		InitWidgetControl(image_hero1_3,tabMercenaryCamp[2])
		InitWidgetControl(image_hero1_4,tabMercenaryCamp[1])
	end
end
