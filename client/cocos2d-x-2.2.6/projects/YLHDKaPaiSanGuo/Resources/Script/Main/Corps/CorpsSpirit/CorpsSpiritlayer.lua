require "Script/Common/UIGotoManager"
module("CorpsSpiritlayer",package.seeall)
require "Script/Main/Corps/CorpsSpirit/CorpsSpiritData"
require "Script/Main/Corps/CorpsSpirit/CorpsSpiritBase"
require "Script/Main/Corps/CorpsSpirit/CorpsSpiritLogic"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryLayer"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryData"
require "Script/Main/ChargeVIP/ChargeVIPFunction"
require "Script/Main/CountryWar/CountryUILayer"
-- require "Script/Main/NoticeBoard/NoticeScrollLayer"
require "Script/serverDB/vipfunction"
local CreateCommonInfoWidget = CorpsLogic.CreateCommonInfoWidget
local CheckSpiritStatus      = CorpsLogic.CheckSpiritStatus
local GetYetMercenaryInfo 	 = CorpsMercenaryData.GetYetMercenaryInfo
local GetMonsterInfo         = CorpsSpiritData.GetMonsterInfo
local SortMonsterFromLevel   = CorpsSpiritLogic.SortMonsterFromLevel
local GetSpiritInfoByLevel   = CorpsSpiritLogic.GetSpiritInfoByLevel
local GetAniPerstigDB        = CorpsSpiritData.GetAniPerstigDB
local GetAniInfoDB           = CorpsSpiritData.GetAniInfoDB
local GetCurPerByServer      = CorpsSpiritData.GetCurPerByServer
local GetQueryInfo           = CorpsSpiritData.GetQueryInfo
local SortQueryInfo          = CorpsSpiritLogic.SortQueryInfo
local GetCityName            = CorpsSpiritData.GetCityName
local GetCityType            = CorpsSpiritData.GetCityType
local ShowRewardLayer        = CorpsSpiritLogic.ShowRewardLayer
local GetNormalSpiritAnimation = CorpsSpiritLogic.GetNormalSpiritAnimation
local GetClickSpiritAnimation  = CorpsSpiritLogic.GetClickSpiritAnimation
local GetSpiritRobot         = CorpsSpiritData.GetSpiritRobot

local m_CorpsSpiritLayer = nil
local m_listView = nil
local m_SpiritClick = nil
local m_ChooseBless = nil
local m_nHanderTime = nil
local m_shengshouSpiritLayer = nil
local m_BHMLayer    = nil
local img_light     = nil
local m_selectBless = 1
local btnText       = nil
local m_GotoCountryWar = nil
local p_control1    = nil
local p_control2    = nil
local p_control3    = nil
local p_control4    = nil
local labelGoldText = nil
local m_nHandSpirit = nil
local m_RootLayer   = nil
local m_PointManger = nil
local m_spiritTypelayer = nil
local m_isClickCountryWar = false
local m_isCorpsEnter = false
local tabMangerHand = {}
local tabMerDB = {}
local tabPer   = {}
local spiritName = nil

local IMAGEFIGHT = "Image/imgres/main/fight.png"
local IMAGEEMPTY = "Image/imgres/common/common_empty.png"
local IMAGEBAIHU = "Image/imgres/corps/WhiteTiger.png"
local IMAGEQINGLONG = "Image/imgres/corps/qinglong.png"
local IMAGEXUANWU = "Image/imgres/corps/xuanwu.png"
local IMAGEZHUQUE = "Image/imgres/corps/zhuque.png"
local IMAGEBAHA =  "Image/imgres/chat/banshenxiang_long.png"
local MONSETQL = "Image/imgres/equip/icon/daojv/item038.png"
local MONSETBH = "Image/imgres/equip/icon/daojv/item039.png"
local MONSETZQ = "Image/imgres/equip/icon/daojv/item040.png"
local MONSETXW = "Image/imgres/equip/icon/daojv/item041.png"
local COLOR_TITLETOP = "|color|51,25,13||size|24|"
local COLOR_TITLE_SMALL = "|color|51,25,13||size|18|"
local SHENGSHOU_IMG = "Image/imgres/hero/head_icon/touxiang_yanlang.png"

local function initData()
	m_CorpsSpiritLayer = nil
	m_listView         = nil
	m_ChooseBless      = nil
	m_SpiritClick      = nil
	m_nHanderTime 	   = nil
	img_light          = nil
	btnText            = nil
	m_GotoCountryWar   = nil
	p_control1         = nil
	p_control2         = nil
	p_control3         = nil
	p_control4         = nil
	labelGoldText      = nil
	m_nHandSpirit      = nil
	m_RootLayer        = nil
	m_spiritTypelayer  = nil
	m_BHMLayer         = nil
	spiritName         = nil
	m_PointManger      = nil
	m_selectBless      = 1
	m_shengshouSpiritLayer = nil
	m_isCorpsEnter     = false
	tabMangerHand = {}
	tabPer        = {}
end

--关掉界面回调
local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		local btn_sender = tolua.cast(sender,"Button")
		btn_sender:setTouchEnabled(false)
		if m_CorpsSpiritLayer == nil then
			return
		end
		for key,value in pairs(tabMangerHand) do
			value:DeleteHandTime()
		end
		if m_nHandSpirit ~= nil then
			m_CorpsSpiritLayer:getScheduler():unscheduleScriptEntry(m_nHandSpirit)
			m_nHandSpirit = nil
		end

		m_CorpsSpiritLayer:removeFromParentAndCleanup(true)
		m_CorpsSpiritLayer = nil
		-- initData()
		if CheckSpiritStatus(tabPer) == false then
			CorpsScene.DeleteRedPoint(7)
		elseif CheckSpiritStatus(tabPer) == true then
			CorpsScene.upDatePointSpirit()
		end
	end
end

local function CreateItemWidget( pItemTemp )
    local pItem = pItemTemp:clone()
    local peer = tolua.getpeer(pItemTemp)
    tolua.setpeer(pItem, peer)
    return pItem
end

local function ComminuteText(str)
    local list = {}
    local len = string.len(str)
    local i = 1 
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i + shift - 1)
        i = i + shift
        table.insert(list, char)
    end
	return table.getn(list)
end

local function UIReleaseToCountryWar(  )
	if m_CorpsSpiritLayer ~= nil then
	for key,value in pairs(tabMangerHand) do
		value:DeleteHandTime()
	end
	if m_nHanderTime ~= nil then
		m_CorpsSpiritLayer:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end
	m_CorpsSpiritLayer:setVisible(false)
	m_CorpsSpiritLayer:removeFromParentAndCleanup(true)
	m_CorpsSpiritLayer = nil
	-- initData()
	-- MainScene.SetCurParent(true)
	end
end

--listView item点击进入国战回调
local function _Click_PanelItem_CallBack( sender,eventType )
	local n_CountryTag = sender:getTag()
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		sender:setScale(1.0)
		CorpsScene.ShowHideCoinBar(false)
		if CountryUILayer.GetControlUI() ~= nil then
			m_isCorpsEnter = true
		end
		local nUIID = 13
       	if m_isCorpsEnter == false then
       		m_GotoCountryWar:SetComeInType(2) 
       		m_GotoCountryWar:SetAttr(true, UIReleaseToCountryWar)
       		m_GotoCountryWar:SetParent(m_CorpsSpiritLayer)
       	else
       		m_GotoCountryWar:SetComeInType(1) 
       		m_GotoCountryWar:SetAttr(true, UIReleaseToCountryWar)
       		m_GotoCountryWar:SetParent(m_CorpsSpiritLayer)
       	end
       	m_GotoCountryWar:ReplaceUI(nUIID, n_CountryTag)
	elseif eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function GOTO_PanelItem_CallBack( nCity )
	local n_CountryTag = nCity
	CorpsScene.ShowHideCoinBar(false)
	if CountryUILayer.GetControlUI() ~= nil then
		m_isCorpsEnter = true
	end
	local function LeaveCorpsCallBack(  )
		CountryWarScene.SetLeaveCorpsCallBack(CorpsScene._Btn_Back_CallBack)
	end
	LeaveCorpsCallBack()
	local nUIID = 13
    if m_isCorpsEnter == false then
	    m_GotoCountryWar:SetComeInType(2) 
	    m_GotoCountryWar:SetAttr(true, UIReleaseToCountryWar)
       	m_GotoCountryWar:SetParent(m_CorpsSpiritLayer)
    else
       	m_GotoCountryWar:SetComeInType(1) 
       	m_GotoCountryWar:SetAttr(true, UIReleaseToCountryWar)
       	m_GotoCountryWar:SetParent(m_CorpsSpiritLayer)
   	end
    m_GotoCountryWar:ReplaceUI(nUIID, n_CountryTag)

end

--关闭赐福战队界面
local function _Click_ChooseBlessCancel_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		m_ChooseBless:setVisible(false)
		m_ChooseBless:removeFromParentAndCleanup(true)
		m_ChooseBless = nil
	end
end

--选择赐福战队回调
local function _Click_ChooseBlessCertain_CallBack( sender,eventType )
	local nTypeTag = sender:getTag()
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		
		local function GetBlessCallBack(  )
			NetWorkLoadingLayer.loadingHideNow()
			m_ChooseBless:setVisible(false)
			m_ChooseBless:removeFromParentAndCleanup(true)
			m_ChooseBless = nil
			local tab_reward = RewardLogic.GetRewardTable(tabMerDB["MosterRewardID"])  ---
			local tabTCoin = tab_reward[1]
			local tabTItem = tab_reward[2]
			local function _ClickTouch(  )
				AudioUtil.PlayBtnClick()
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1635,nil,spiritName)
				pTips = nil
			end
			
			local function GetReward(  )
				local tabToTCoin = {}
				local tabToTItem = {}
				if next(tabTCoin) ~= nil and next(tabTItem) == nil then
					local tabChild = {}
					tabChild[1] = tabTCoin[1]["CoinID"]
					tabChild[2] = tabTCoin[1]["CoinNum"]
					table.insert(tabToTCoin,tabChild)
					ShowRewardLayer(nil,tabToTCoin,_ClickTouch)
				elseif next(tabTCoin) == nil and next(tabTItem) ~= nil then
					local tabChild = {}
					tabChild[1] = tabTItem[1]["ItemID"]
					tabChild[2] = tabTItem[1]["ItemNum"]
					table.insert(tabToTItem,tabChild)
					ShowRewardLayer(tabToTItem,nil,_ClickTouch)
				elseif next(tabTCoin) ~= nil and next(tabTItem) ~= nil then
					local tabChild = {}
					local tabChildCoin = {}
					tabChild[1] = tabTItem[1]["ItemID"]
					tabChild[2] = tabTItem[1]["ItemNum"]
					tabChildCoin[1] = tabTCoin[1]["CoinID"]
					tabChildCoin[2] = tabTCoin[1]["CoinNum"]
					table.insert(tabToTItem,tabChild)
					table.insert(tabToTCoin,tabChildCoin)
					ShowRewardLayer(tabToTItem,tabToTCoin,_ClickTouch)
				end
			end
			GetReward()
		end
		Packet_AniBless.SetSuccessCallBack(GetBlessCallBack)
		network.NetWorkEvent(Packet_AniBless.CreatePacket(nTypeTag,m_selectBless))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--设置战斗力
local function SetPower(pControl, nNumber )
	if pControl:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(pControl:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(nNumber)
	else
		local pText = LabelBMFont:create()
		
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(0,-20))
		pText:setAnchorPoint(ccp(0.5,0.5))
		pControl:addChild(pText,0,1000)
		pText:setText(nNumber)
	end
end

--前往佣兵界面雇佣佣兵
local function _Click_guyong_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		-- CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
		                       
		local tabTotal = CorpsData.GetScienceLevel()
		local tabM = tabTotal[7]
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingHideNow()
			for key,value in pairs(tabMangerHand) do
				value:DeleteHandTime()
			end
			if m_nHandSpirit ~= nil then
				m_CorpsSpiritLayer:getScheduler():unscheduleScriptEntry(m_nHandSpirit)
				m_nHandSpirit = nil
			end
			m_ChooseBless:setVisible(false)
			m_ChooseBless:removeFromParentAndCleanup(true)  
			m_CorpsSpiritLayer:removeFromParentAndCleanup(true)
			m_CorpsSpiritLayer = nil
			-- initData()
			if CheckSpiritStatus(tabPer) == false then
				CorpsScene.DeleteRedPoint(7)
			elseif CheckSpiritStatus(tabPer) == true then
				CorpsScene.upDatePointSpirit()
			end
			local scenetemp = CCDirector:sharedDirector():getRunningScene()
			local temp = scenetemp:getChildByTag(120)
			if temp == nil then
				local pMercenaryLayer = CorpsMercenaryLayers.showMercenaryLayer(tabM)
				scenetemp:addChild(pMercenaryLayer,120,120)
			end
		end
		Packet_CorpsYetMercenary.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsYetMercenary.CreatePacket())
		NetWorkLoadingLayer.loadingShow(true)
	end
end

--战队的信息
local function ChooseBlessItem( pControl,tableItem )
	
	local imageBlessItem = tolua.cast(pControl:getChildByName("Image_item"),"ImageView")
	local image_fight = tolua.cast(pControl:getChildByName("Image_fight"),"ImageView")
	local label_power = tolua.cast(pControl:getChildByName("Label_power"),"Label")
	local label_name = tolua.cast(pControl:getChildByName("Label_name"),"Label")
	local btn_guyong = tolua.cast(pControl:getChildByName("Button_1"),"Button")
	btn_guyong:setVisible(false)
	btn_guyong:setTouchEnabled(false)
	local labelbtnText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT3, "前往雇佣", ccp(0, 2), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	
		
	if next(tableItem) ~= nil then
		image_fight:loadTexture(IMAGEFIGHT)
		SetPower(label_power,tableItem["power"])
		label_name:setText(tableItem["name"])
		UIInterface.MakeHeadIcon(imageBlessItem,ICONTYPE.GENERAL_COLOR_ICON,tableItem.iconID,nil,nil,nil,tableItem.nColorID,nil)
		-- imageBlessItem:loadTexture(tableItem[2])
	else
		btn_guyong:setVisible(true)
		btn_guyong:setTouchEnabled(true)
		btn_guyong:addChild(labelbtnText)
		btn_guyong:addTouchEventListener(_Click_guyong_CallBack)
	
	end
end

local function _Click_Troops_CallBack( sender,eventType )
	local p_tag = sender:getTag()
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		sender:setScale(1.0)
		if p_tag == 5 then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1491,nil)
			pTips = nil
		else
			m_selectBless = p_tag
			img_light:setPosition(ccp(sender:getPositionX() - 5,sender:getPositionY()))
		end
	elseif eventType == TouchEventType.began then
		sender:setScale(0.9)
	end
end

local function InitItemControl( pControl,tabItem ,n_tag)
	ChooseBlessItem(pControl,tabItem)
	pControl:setTouchEnabled(true)
	if tabItem["times"] ~= nil then
		if tabItem["times"] ~= 0 then
			pControl:setTag(n_tag)
		else
			pControl:setTag(5)
		end
		pControl:addTouchEventListener(_Click_Troops_CallBack)
	end
end                                                       

--赐福战队界面
local function ChooseBless(value,m_tag)
	if m_ChooseBless == nil then
		m_ChooseBless = TouchGroup:create()
	    m_ChooseBless:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSpiritBles.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		m_RootLayer:addChild(m_ChooseBless, layerSpiritGoldTag, layerSpiritGoldTag)
	end
	m_selectBless = 1
	-- m_ChooseBless:setTouchPriority(-1)
	tabMerDB = {}
	tabMerDB = GetSpiritInfoByLevel(m_tag)
	
	local m_tabMonst = GetSpiritInfoByLevel(m_tag)
	local m_tabeffect = CorpsSpiritData.GetBlessNumTotal(m_tabMonst["MosterEff1"])

	local Imagebg = tolua.cast(m_ChooseBless:getWidgetByName("Image_bg"),"ImageView")
	local label_title = tolua.cast(Imagebg:getChildByName("Label_title"),"Label")
	local label_content = tolua.cast(Imagebg:getChildByName("Label_content"),"Label")
	img_light = tolua.cast(Imagebg:getChildByName("Image_sahde"),"ImageView")


	if tonumber(m_tag) == 1 then
		spiritName = "青龙之魂"
	elseif tonumber(m_tag) == 2 then
		spiritName = "白虎之魂"
	elseif tonumber(m_tag) == 3 then
		spiritName = "朱雀之魂"
	elseif tonumber(m_tag) == 4 then
		spiritName = "玄武之魂"
	else
		spiritName = "灵兽军团"
	end

	label_title:setText("请选择赐福战队")
	local str = "攻击力"
	if tonumber(m_tabeffect["BlessType"]) == 1 then
		str  = "生命值"
	elseif tonumber(m_tabeffect["BlessType"]) == 2 then
		str = "攻击力"
	elseif tonumber(m_tabeffect["BlessType"]) == 3 then
		str = "防御力"
	end
	local nMessText1 = COLOR_TITLE_SMALL.."赐福说明:".."|color|100,49,24||size|18|"..m_tabMonst["MonsterDesc"]
	local messContentItem1 = RichLabel.Create(nMessText1,550,nil,nil,1)
	messContentItem1:setPosition(ccp(-50,15))		
	-- label_content:addChild(messContentItem1)

	--按钮
	local btn_Chosreturn = tolua.cast(Imagebg:getChildByName("Button_return"),"Button")
	local btn_Choscertain = tolua.cast(Imagebg:getChildByName("Button_certain"),"Button")
	btn_Choscertain:setTag(m_tag)

	local labelcancelText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "返回", ccp(0, 0), ccc3(0,0,0), ccc3(255,255,255), true, ccp(0, -3), 3)
	local labelcertainText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "确定赐福", ccp(0, 0), ccc3(0,0,0), ccc3(255,255,255), true, ccp(0, -3), 3)
	
	btn_Chosreturn:addChild(labelcancelText)
	btn_Choscertain:addChild(labelcertainText)

	btn_Chosreturn:addTouchEventListener(_Click_ChooseBlessCancel_CallBack)
	btn_Choscertain:addTouchEventListener(_Click_ChooseBlessCertain_CallBack)

	local tabPerson = {}
	tabPerson["level"] = server_mainDB.getMainData("level")
	tabPerson["name"] = server_mainDB.getMainData("name")
	tabPerson["power"] = server_mainDB.getMainData("power")
	tabPerson["iconID"] = server_mainDB.getMainData("nModeID")
	tabPerson["times"] = 100

	--四个item
	local pControl_1 = tolua.cast(Imagebg:getChildByName("Imageitem1"), "ImageView")
	local pControl_2 = tolua.cast(Imagebg:getChildByName("Imageitem1_0"), "ImageView")
	local pControl_3 = tolua.cast(Imagebg:getChildByName("Imageitem1_1"), "ImageView")
	local pControl_4 = tolua.cast(Imagebg:getChildByName("Imageitem1_2"), "ImageView")
	InitItemControl(pControl_1,tabPerson,1)
	InitItemControl(pControl_2,value[1],2)
	InitItemControl(pControl_3,value[2],3)
	InitItemControl(pControl_4,value[3],4)

end

--灵兽详细信息返回回调
local function _Click_SpiritReturn_CallBack( sender,eventType )  
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		m_SpiritClick:setVisible(false)
		m_SpiritClick:removeFromParentAndCleanup(true)
		m_SpiritClick = nil
	end
end

--灵兽详细信息界面
local function ShowSpiritInfo( num )
	if m_SpiritClick == nil then
		m_SpiritClick = TouchGroup:create()
	    m_SpiritClick:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSpiritGoods.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		m_RootLayer:addChild(m_SpiritClick, layerSpiritGoldTag, layerSpiritGoldTag)
	end
	local tabSp = GetAniInfoDB()
	--根据灵兽的tag获取对应的信息
	local tabMonsterInfo = GetSpiritInfoByLevel(num)
	local ImageBG = tolua.cast(m_SpiritClick:getWidgetByName("Image_bg"),"ImageView")
	local tabSEffect = CorpsSpiritData.GetBlessNumTotal(tabMonsterInfo["MosterEff1"])

	------------------------------------------------------------------------------------------------------------------
	--Image 灵兽的图像
	local image_spirit1 = tolua.cast(ImageBG:getChildByName("Image_spirit1"),"ImageView")

	------------------------------------------------------------------------------------------------------------------
	--label 文本
	local label_name = tolua.cast(ImageBG:getChildByName("Label_name"),"Label")
	local label_num = tolua.cast(ImageBG:getChildByName("Label_num"),"Label")
	local label_bless = tolua.cast(ImageBG:getChildByName("Label_blessNum"),"Label")
	local label_blessExplain = tolua.cast(ImageBG:getChildByName("Label_bless"),"Label")
	local label_content = tolua.cast(ImageBG:getChildByName("Label_content"),"Label")
	local label_gold = tolua.cast(ImageBG:getChildByName("Label_gold"),"Label")
	local img_bars = tolua.cast(ImageBG:getChildByName("Image_parss"),"ImageView")
	local bar_spirit = tolua.cast(img_bars:getChildByName("ProgressBar_bar"),"LoadingBar")
	local label_bar = tolua.cast(img_bars:getChildByName("Label_percent"),"Label")
	local img_65 = tolua.cast(ImageBG:getChildByName("Image_reward"),"ImageView")
	local img_reward = tolua.cast(img_65:getChildByName("Image_61"),"ImageView")
	local l_rewardNum = tolua.cast(img_65:getChildByName("Label_63"),"Label")
	local l_RepuDesc = tolua.cast(ImageBG:getChildByName("Label_RePuDesc"),"Label")

	local nMessText = COLOR_TITLETOP.."灵兽:".."|color|2,95,235||size|24|"..tabMonsterInfo["MonsterName"]
	local messContentItem = RichLabel.Create(nMessText,400,nil,nil,1)
	messContentItem:setPosition(ccp(-15,0))		
	label_name:addChild(messContentItem)


	local nMessText1 = COLOR_TITLE_SMALL.."赐福次数:".."|color|100,49,24||size|18|".."上限".."|color|1,250,253||size|18|"..tabSp["BlessNum"].."|color|100,49,24||size|18|".."次(已赐福".."|color|1,250,253||size|18|"..tabSp["Cur_BlessNum"].."|color|100,49,24||size|18|".."次)"
	local messContentItem1 = RichLabel.Create(nMessText1,400,nil,nil,1)
	messContentItem1:setPosition(ccp(-15,0))		
	label_bless:addChild(messContentItem1)

	local nMessText2 = COLOR_TITLE_SMALL.."赐福说明:".."|color|100,49,24||size|18|"..tabMonsterInfo["MonsterDesc"]
	local messContentItem2 = RichLabel.Create(nMessText2,370,nil,nil,1)
	messContentItem2:setPosition(ccp(-15,0))		
	label_blessExplain:addChild(messContentItem2)

	local nMessText3 = "|color|121,91,59||size|18|"..tabMonsterInfo["RepuDesc"]
	local messContentItem3 = RichLabel.Create(nMessText3,350,nil,nil,1)
	messContentItem3:setPosition(ccp(30,0))		
	l_RepuDesc:addChild(messContentItem3)

	-- label_name:setText(tabMonsterInfo["MonsterName"])
	
	local cur_Per = tabSp["Cue_Per"]
	if tonumber(cur_Per) <= 0 then
		cur_Per = 0
	end
	label_bar:setText(cur_Per.."/"..tabMonsterInfo["ReputCost"])
	local p_percent = tonumber(cur_Per)/tonumber(tabMonsterInfo["ReputCost"])
	bar_spirit:setPercent(p_percent*100)
	if num == 1 then
		image_spirit1:loadTexture(IMAGEQINGLONG)
	elseif num == 2 then
		image_spirit1:loadTexture(IMAGEBAIHU)
	elseif num == 3 then
		image_spirit1:loadTexture(IMAGEZHUQUE)
	elseif num == 4 then
		image_spirit1:loadTexture(IMAGEXUANWU)
	else
		image_spirit1:loadTexture(IMAGEBAHA)
	end

	local tab_reward = RewardLogic.GetRewardTable(tabMonsterInfo["MosterRewardID"])  ---
	local tabTCoin = tab_reward[1]
	local tabTItem = tab_reward[2]
	----奖励图标
	if next(tabTCoin) ~= nil then
		img_reward:loadTexture(tabTCoin[1]["CoinPath"])	
		l_rewardNum:setText(tabTCoin[1]["CoinNum"])
	else
		img_reward:loadTexture(tabTItem[1]["ItemPath"])	
		l_rewardNum:setText(tabTItem[1]["ItemNum"])	
	end
	------------------------------------------------------------------------------------------------------------------
	---按钮
	local function _Click_spiritJinGong_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local n_typeTag = sender:getTag()
			local function GetTributeCallBack(  )
				local cur_MPer = GetCurPerByServer()
				if tonumber(cur_MPer) <= 0 then
					cur_MPer = 0
				end
				label_bar:setText(cur_MPer.."/"..tabMonsterInfo["ReputCost"])
				local p_ppercent = tonumber(cur_MPer)/tonumber(tabMonsterInfo["ReputCost"])
				if p_ppercent >= 1 then
					p_ppercent = 1
				end
				bar_spirit:setPercent(p_ppercent*100)
			end
			Packet_AniTribute.SetSuccessCallBack(GetTributeCallBack)
			network.NetWorkEvent(Packet_AniTribute.CreatePacket(n_typeTag,1))
		end
	end
	local function _Click_spiritJinGongGold_CallBack( sender,eventType )
		local btn_call = tolua.cast(sender,"Button")
		local m_BtnText = btn_call:getChildByTag(10001)
		local l_text = LabelLayer.getText(m_BtnText)
		local n_typeTag = sender:getTag()
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local str_name = nil
			if n_typeTag == 1 then
				str_name = "青龙之魂"
			elseif n_typeTag == 2 then
				str_name = "白虎之魂"
			elseif n_typeTag == 3 then
				str_name = "朱雀之魂"
			elseif n_typeTag == 4 then
				str_name = "玄武之魂"
			else
				str_name = "灵兽军团"
			end

			local function _ClickTouch(  )
				AudioUtil.PlayBtnClick()
				m_SpiritClick:setVisible(false)
				m_SpiritClick:removeFromParentAndCleanup(true)
				m_SpiritClick = nil	
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1635,nil,str_name)
				pTips = nil
			end
			
			local function GetReward(  )
				local tabToTCoin = {}
				local tabToTItem = {}
				if next(tabTCoin) ~= nil and next(tabTItem) == nil then
					local tabChild = {}
					tabChild[1] = tabTCoin[1]["CoinID"]
					tabChild[2] = tabTCoin[1]["CoinNum"]
					table.insert(tabToTCoin,tabChild)
					ShowRewardLayer(nil,tabToTCoin,_ClickTouch)
				elseif next(tabTCoin) == nil and next(tabTItem) ~= nil then
					local tabChild = {}
					tabChild[1] = tabTItem[1]["ItemID"]
					tabChild[2] = tabTItem[1]["ItemNum"]
					table.insert(tabToTItem,tabChild)
					ShowRewardLayer(tabToTItem,nil,_ClickTouch)
				elseif next(tabTCoin) ~= nil and next(tabTItem) ~= nil then
					local tabChild = {}
					local tabChildCoin = {}
					tabChild[1] = tabTItem[1]["ItemID"]
					tabChild[2] = tabTItem[1]["ItemNum"]
					tabChildCoin[1] = tabTCoin[1]["CoinID"]
					tabChildCoin[2] = tabTCoin[1]["CoinNum"]
					table.insert(tabToTItem,tabChild)
					table.insert(tabToTCoin,tabChildCoin)
					ShowRewardLayer(tabToTItem,tabToTCoin,_ClickTouch)
				end
			end
			

			--得到消耗的金币数量
			local consumGold = math.ceil((tonumber(tabMonsterInfo["ReputCost"]) - tonumber(tabSp["Cue_Per"]))/tonumber(tabMonsterInfo["GoldExchange"]))
				
			local function MonsterCallFull( isLock )
				if isLock == true then
					local function GetTributeCallBack(  )
						CorpsScene.GetConteobile(1)
						local cur_MPer = GetCurPerByServer()
						if tonumber(cur_MPer) <= 0 then
							cur_MPer = 0
						end
						label_bar:setText(cur_MPer.."/"..tabMonsterInfo["ReputCost"])
						local p_ppercent = tonumber(cur_MPer)/tonumber(tabMonsterInfo["ReputCost"])
						if p_ppercent >= 1 then
							p_ppercent = 1
							-- LabelLayer.setText(labelGoldText,"获取赐福")
							btn_call:setTag(10)
						end
						bar_spirit:setPercent(p_ppercent*100)
						GetReward()
					end
					Packet_AniTribute.SetSuccessCallBack(GetTributeCallBack)
					network.NetWorkEvent(Packet_AniTribute.CreatePacket(n_typeTag,2))
				end
			end
			local ppTips = TipCommonLayer.CreateTipLayerManager()
			ppTips:ShowCommonTips(1493,MonsterCallFull,consumGold, str_name)
				
		end
	end
	local btn_return = tolua.cast(ImageBG:getChildByName("Button_return"),"Button")
	-- local btn_pay = tolua.cast(ImageBG:getChildByName("Button_Pay"),"Button")
	local btn_gold = tolua.cast(ImageBG:getChildByName("Button_101"),"Button")
	-- local labelPayText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "声望进贡", ccp(0, 0), ccc3(0,0,0), ccc3(255,255,255), true, ccp(0, -3), 3)
	--local labelGoldText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "金币进贡", ccp(0, 0), ccc3(0,0,0), ccc3(255,255,255), true, ccp(0, -3), 3)
	--btn_gold:addChild(labelGoldText)

	local strname = ""
	if tonumber(p_percent) == 1 then
		strname = "获取贡品"
	else
		strname = "金币进贡"
	end
	if btn_gold:getChildByTag(10001) ~= nil then
		LabelLayer.setText(btn_gold:getChildByTag(10001),strname)
	else
		labelGoldText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "", ccp(0,0), COLOR_Black, COLOR_White, true, ccp(0, -3), 3)
		btn_gold:addChild(labelGoldText,10001,10001)
	end

	if tonumber(p_percent) >= 1 then
		
		btn_gold:setTag(10)
	else
		-- LabelLayer.setText(labelGoldText,"金币进贡")
		btn_gold:setTag(num)
	end
	LabelLayer.setText(labelGoldText,"获取贡品")
	-- btn_pay:addChild(labelPayText)
	-- btn_pay:setTag(num)
	
	btn_return:addTouchEventListener(_Click_SpiritReturn_CallBack)
	-- btn_pay:addTouchEventListener(_Click_spiritJinGong_CallBack)
	btn_gold:addTouchEventListener(_Click_spiritJinGongGold_CallBack)
end

--查看灵兽信息界面
local function loadSpiritInfo( num )
	if m_spiritTypelayer == nil then
		m_spiritTypelayer = TouchGroup:create()
	    m_spiritTypelayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSpitritExplain.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		m_RootLayer:addChild(m_spiritTypelayer, layerSpiritGoldTag, layerSpiritGoldTag)
	end
	-- m_spiritTypelayer:setTouchPriority(-1)
	local l_name = tolua.cast(m_spiritTypelayer:getWidgetByName("Label_name"),"Label")
	local l_limit = tolua.cast(m_spiritTypelayer:getWidgetByName("Label_limit"),"Label")
	local l_reward = tolua.cast(m_spiritTypelayer:getWidgetByName("Label_reward"),"Label")
	local l_richlab1 = tolua.cast(m_spiritTypelayer:getWidgetByName("Label_r1"),"Label")
	local l_richlab2 = tolua.cast(m_spiritTypelayer:getWidgetByName("Label_r2"),"Label")
	local l_ReItemNum = tolua.cast(m_spiritTypelayer:getWidgetByName("Label_13"),"Label")
	local l_ReItemName = tolua.cast(m_spiritTypelayer:getWidgetByName("Label_rewardname"),"Label")
	local img_Reward = tolua.cast(m_spiritTypelayer:getWidgetByName("Image_reward"),"ImageView")
	local img_ReItem = tolua.cast(m_spiritTypelayer:getWidgetByName("Image_item"),"ImageView")
	local btn_ItemR = tolua.cast(m_spiritTypelayer:getWidgetByName("Button_return"),"Button")
	local btn_certainR = tolua.cast(m_spiritTypelayer:getWidgetByName("Button_certain"),"Button")

	local tabMonsterInfo = GetSpiritInfoByLevel(num)
	
	l_name:setText(tabMonsterInfo["MonsterName"]..":")

	local nMessText1 = "|color|100,49,24||size|18|"..tabMonsterInfo["MonsterDesc"]
	local messContentItem1 = RichLabel.Create(nMessText1,350,nil,nil,1)
	messContentItem1:setPosition(ccp(-150,30))		
	l_richlab1:addChild(messContentItem1)

	local nMessText2 = "|color|100,49,24||size|18|"..tabMonsterInfo["RepuDesc"]
	local messContentItem2 = RichLabel.Create(nMessText2,350,nil,nil,1)
	messContentItem2:setPosition(ccp(-130,7))		
	l_richlab2:addChild(messContentItem2)

	--奖励
	local tab_reward = RewardLogic.GetRewardTable(tabMonsterInfo["MosterRewardID"])  
	
	local tabTCoin = tab_reward[1]
	local tabTItem = tab_reward[2]
	----奖励图标
	if next(tabTCoin) ~= nil then
		img_ReItem:loadTexture(tabTCoin[1]["CoinPath"])	
		l_ReItemName:setText(tabTCoin[1]["CoinName"].."X"..tabTCoin[1]["CoinNum"])
	else
		img_ReItem:loadTexture(tabTItem[1]["ItemPath"])	
		l_ReItemName:setText(tabTItem[1]["ItemName"].."X"..tabTItem[1]["ItemNum"])
	end

	local function _Click_Returnload_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_spiritTypelayer:setVisible(false)
			m_spiritTypelayer:removeFromParentAndCleanup(true)
			m_spiritTypelayer = nil
		end
	end
	local certainText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -3), 3)
	btn_certainR:addChild(certainText)
	btn_ItemR:addTouchEventListener(_Click_Returnload_CallBack)
	btn_certainR:addTouchEventListener(_Click_Returnload_CallBack)
end

--圣兽的详细信息
local function ShengShouSpiritBless(  )
	if m_shengshouSpiritLayer == nil then
		m_shengshouSpiritLayer = TouchGroup:create()
	    m_shengshouSpiritLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsBlessItem.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_shengshouSpiritLayer, layerSpiritGoldTag, layerSpiritGoldTag)
	end
	local m_name = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Label_15"),"Label")
	local t_num = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Label_16"),"Label")
	local cur_num = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Label_25"),"Label")
	local desc = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Label_27"),"Label")
	local label_effect = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Label_49"),"Label")
	local img_bar = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Image_bar"),"ImageView")
	local label_bar = tolua.cast(img_bar:getChildByName("Label_60"),"Label")
	local label_efnum = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Label_54"),"Label")
	local prossbar = tolua.cast(img_bar:getChildByName("ProgressBar_bar"),"LoadingBar")

	local tabMonsterInfo = GetSpiritInfoByLevel(5)
	local tabSpS = GetAniInfoDB()

	local tabEffect = CorpsSpiritData.GetBlessNumTotal(tabMonsterInfo["MosterEff1"])
	
	m_name:setText(tabMonsterInfo["MonsterName"])
	-- desc:setText(tabMonsterInfo["MonsterDesc"])
	t_num:setText(tabSpS["BlessNum"])
	label_efnum:setText(tabMonsterInfo["MonsterDesc"])
	cur_num:setText(tabSpS["Cur_BlessNum"])
	local cur_Pers = tabSpS["Cue_Per"]
	if tonumber(cur_Pers) <= 0 then
		cur_Pers = 0
	end
	local bar_num = tonumber(cur_Pers)/tonumber(tabMonsterInfo["ReputCost"])
	if bar_num >= 1 then
		bar_num = 1
	end
	label_bar:setText(cur_Pers.."/"..tabMonsterInfo["ReputCost"])
	prossbar:setPercent(bar_num*100)
	local function _CLick_SpiritItemRtn_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			m_shengshouSpiritLayer:setVisible(false)
			m_shengshouSpiritLayer:removeFromParentAndCleanup(true)
			m_shengshouSpiritLayer = nil
			
		end
	end

	--声望进贡
	local function _Click_NAHAMULeft_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			local pTag = sender:getTag()
			AudioUtil.PlayBtnClick()
			local function GetTributeCallBack(  )
				local cur_MPer = GetCurPerByServer()
				if tonumber(cur_MPer) <= 0 then
					cur_MPer = 0
				end
				label_bar:setText(cur_MPer.."/"..tabMonsterInfo["ReputCost"])
				local p_ppercent = tonumber(cur_MPer)/tonumber(tabMonsterInfo["ReputCost"])
				if p_ppercent >= 1 then
					p_ppercent = 1
				end
				prossbar:setPercent(p_ppercent*100)
			end
			Packet_AniTribute.SetSuccessCallBack(GetTributeCallBack)
			network.NetWorkEvent(Packet_AniTribute.CreatePacket(pTag,1))
		end
	end
	--金币进贡
	local function _Click_NAHAMURight_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local pTag = sender:getTag()
			local function GetTributeCallBack(  )
				local cur_MPer = GetCurPerByServer()
				if tonumber(cur_MPer) <= 0 then
					cur_MPer = 0
				end
				label_bar:setText(cur_MPer.."/"..tabMonsterInfo["ReputCost"])
				local p_ppercent = tonumber(cur_MPer)/tonumber(tabMonsterInfo["ReputCost"])
				if p_ppercent >= 1 then
					p_ppercent = 1
				end
				prossbar:setPercent(p_ppercent*100)
			end
			Packet_AniTribute.SetSuccessCallBack(GetTributeCallBack)
			network.NetWorkEvent(Packet_AniTribute.CreatePacket(pTag,2))
		end
	end

	local btn_rtn = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Button_shengshou"),"Button")
	local btn_left = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Button_left"),"Button")
	local btn_right = tolua.cast(m_shengshouSpiritLayer:getWidgetByName("Button_right"),"Button")
	local labelLeftText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "声望进贡", ccp(0, 0), ccc3(0,0,0), ccc3(255,255,255), true, ccp(0, 0), 3)
	local labelRightText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "金币进贡", ccp(0, 0), ccc3(0,0,0), ccc3(255,255,255), true, ccp(0, 0), 3)
	btn_left:addChild(labelLeftText)
	btn_right:addChild(labelRightText)

	btn_left:setTag(5)
	btn_right:setTag(5)
	btn_rtn:addTouchEventListener(_CLick_SpiritItemRtn_CallBack)
	btn_left:addTouchEventListener(_Click_NAHAMULeft_CallBack)
	btn_right:addTouchEventListener(_Click_NAHAMURight_CallBack)
end

local function BHMSpiritInfo( num )
	if m_BHMLayer == nil then
		m_BHMLayer = TouchGroup:create()
	    m_BHMLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSpitritBH.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_BHMLayer, layerSpiritGoldTag, layerSpiritGoldTag)
	end
	-- m_BHMLayer:setTouchPriority(-1)
	local tabSp = GetAniInfoDB()
	--根据灵兽的tag获取对应的信息
	local tabBHMInfo = GetSpiritInfoByLevel(5)
	local BH_percent = tonumber(tabSp["Cue_Per"])/tonumber(tabBHMInfo["ReputCost"])


	local l_BHName = tolua.cast(m_BHMLayer:getWidgetByName("Label_BHname"),"Label")
	local l_BHDesc = tolua.cast(m_BHMLayer:getWidgetByName("Label_BHDesc"),"Label")
	local l_BHBless = tolua.cast(m_BHMLayer:getWidgetByName("Label_BHBless"),"Label")
	local l_BHRWName = tolua.cast(m_BHMLayer:getWidgetByName("Label_BHrewardNum"),"Label")

	local img_BHMItem = tolua.cast(m_BHMLayer:getWidgetByName("Image_BHRWItem"),"ImageView")

	local nMessText1 = "|color|100,49,24||size|18|"..tabBHMInfo["MonsterDesc"]
	local messContentItem1 = RichLabel.Create(nMessText1,390,nil,nil,1)
	messContentItem1:setPosition(ccp(-160,25))		
	l_BHDesc:addChild(messContentItem1)

	local nMessText2 = "|color|100,49,24||size|18|"..tabBHMInfo["RepuDesc"]
	local messContentItem2 = RichLabel.Create(nMessText2,320,nil,nil,1)
	messContentItem2:setPosition(ccp(-140,0))		
	l_BHBless:addChild(messContentItem2)

	--奖励
	local tab_reward = RewardLogic.GetRewardTable(tabBHMInfo["MosterRewardID"])  
	
	local tabTCoin = tab_reward[1]
	local tabTItem = tab_reward[2]
	----奖励图标
	if next(tabTCoin) ~= nil then
		img_BHMItem:loadTexture(tabTCoin[1]["CoinPath"])
		l_BHRWName:setText(tabTCoin[1]["CoinName"].."X"..tabTCoin[1]["CoinNum"])
	else
		img_BHMItem:loadTexture(tabTItem[1]["ItemPath"])
		l_BHRWName:setText(tabTItem[1]["ItemName"].."X"..tabTItem[1]["ItemNum"])
	end

	local btn_type  = tolua.cast(m_BHMLayer:getWidgetByName("Button_zhuzhan"),"Button")
	local btn_BHreturn = tolua.cast(m_BHMLayer:getWidgetByName("Button_BHreturn"),"Button")

	local strBHM = ""
	if BH_percent >= 1 then
		strBHM = "灵兽助战"
		
	else
		strBHM = "获取贡品"
	end
	btn_type:setTag(5)
	local l_BHMText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, strBHM, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -3), 3)
	btn_type:addChild(l_BHMText,5,5)

	local function _Click_CloseBHM_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			m_BHMLayer:setVisible(false)
			m_BHMLayer:removeFromParentAndCleanup(true)
			m_BHMLayer = nil
		end
	end
	btn_BHreturn:addTouchEventListener(_Click_CloseBHM_CallBack)

	local function _Click_BHMJG_CallBack( sender,eventType )

		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local btnBHM = tolua.cast(sender,"Button")

			local m_BtnText = btnBHM:getChildByTag(5)
			local l_text = LabelLayer.getText(m_BtnText)

			local b_tag = sender:getTag()
			if BH_percent >= 1 then
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					m_BHMLayer:setVisible(false)
					m_BHMLayer:removeFromParentAndCleanup(true)
					m_BHMLayer = nil	
					local tabHM = {}
					tabHM = GetYetMercenaryInfo()
					ChooseBless(tabHM,b_tag)
				end
				Packet_CorpsYetMercenary.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsYetMercenary.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)
			else

				local str = "灵兽军团"
				local consumGold = math.ceil((tonumber(tabBHMInfo["ReputCost"]) - tonumber(tabSp["Cue_Per"]))/tonumber(tabBHMInfo["GoldExchange"]))
						
				local function MonsterCallFull( isLock )
					if isLock == true then
						local function GetTributeCallBack(  )
							CorpsScene.GetConteobile(1)
							local cur_MPer = GetCurPerByServer()
							BH_percent = tonumber(cur_MPer)/tonumber(tabBHMInfo["ReputCost"])
							if BH_percent >= 1 then
								LabelLayer.setText(m_BtnText,"灵兽助战")
							end
							-- BH_percent
							--m_BHMLayer:setVisible(false)
							--m_BHMLayer:removeFromParentAndCleanup(true)
							--m_BHMLayer = nil	
						end
						Packet_AniTribute.SetSuccessCallBack(GetTributeCallBack)
						network.NetWorkEvent(Packet_AniTribute.CreatePacket(b_tag,2))
					end
				end
				local ppTips = TipCommonLayer.CreateTipLayerManager()
				ppTips:ShowCommonTips(1493,MonsterCallFull,consumGold, str)
			end
		end
	end
	btn_type:addTouchEventListener(_Click_BHMJG_CallBack)


	local img_1 = tolua.cast(m_BHMLayer:getWidgetByName("Image_btm"),"ImageView")
	local img_2 = tolua.cast(m_BHMLayer:getWidgetByName("Image_btm_0"),"ImageView")
	local img_3 = tolua.cast(m_BHMLayer:getWidgetByName("Image_btm_1"),"ImageView")
	local img_4 = tolua.cast(m_BHMLayer:getWidgetByName("Image_btm_2"),"ImageView")
	local img_5 = tolua.cast(m_BHMLayer:getWidgetByName("Image_btm_3"),"ImageView")
	local img_6 = tolua.cast(m_BHMLayer:getWidgetByName("Image_btm_4"),"ImageView")
	local function loadInfoControl( pControl,pTabTobot )
		local hero_head = tolua.cast(pControl:getChildByName("Image_27"),"ImageView")
		if next(pTabTobot) ~= nil then
			UIInterface.MakeHeadIcon(hero_head,ICONTYPE.GENERAL_COLOR_ICON,pTabTobot["faceID"],nil,nil,nil,nil,nil)
			for i=1, pTabTobot["starLevel"] do
				local star = ImageView:create()
				star:loadTexture("Image/imgres/common/star.png")
				star:setPosition(ccp(-40 + (i-1) * 22, -48))
				star:setFlipX(false)
				hero_head:addChild(star)
			end
		end
	end
	local function InitWidgetControl( pControl,pTab )
		loadInfoControl(pControl,pTab)
	end
	local function GetSuccessCallback(  )
		local tabRobot = GetSpiritRobot()
			
		InitWidgetControl(img_1,tabRobot[6])
		InitWidgetControl(img_2,tabRobot[5])
		InitWidgetControl(img_3,tabRobot[4])
		InitWidgetControl(img_4,tabRobot[3])
		InitWidgetControl(img_5,tabRobot[2])
		InitWidgetControl(img_6,tabRobot[1])

		
	end
	Packet_AniBHMRobot.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_AniBHMRobot.CreatePacket())

end

local function _ClickTouckAnimate_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local n_Type = sender:getTag()
		local Animation11,Animation12 = GetClickSpiritAnimation(n_Type)
		local function EffectOver(  )
			local Animation21 = nil
			local Animation22 = nil
			local Animation21,Animation22 = GetNormalSpiritAnimation(n_Type)
			CommonInterface.GetAnimationByName(Animation21, 
				"juntuan_lingshou_texiao", 
				Animation22, 
				sender, 
				ccp(0, 0),
				nil,
				10)
		end
		CommonInterface.GetAnimationByName(Animation11, 
			"juntuan_lingshou_texiao", 
			Animation12, 
			sender, 
			ccp(0, 0),
			EffectOver,
			12)
	end
end

local function _ClickNormalAnimate_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local n_Type = sender:getTag()
		local Animation11,Animation12 = GetClickSpiritAnimation(n_Type)
		CommonInterface.GetAnimationByName(Animation11, 
			"juntuan_lingshou_texiao", 
			Animation12, 
			sender, 
			ccp(0, 0),
			nil,
			12)
	end
end
--加载灵兽的声望信息
local function WidgetSpriteUI( pControl,PerTab,nTag )
	local img_sprite = tolua.cast(pControl:getChildByName("Image_spirit"),"ImageView")
	local l_spiritName = tolua.cast(pControl:getChildByName("Label_name"),"Label")
	local btn_sprite = tolua.cast(pControl:getChildByName("Button_spirit"),"Button")
	local img_bar = tolua.cast(pControl:getChildByName("Image_bar"),"ImageView")
	local bar_percent = tolua.cast(img_bar:getChildByName("ProgressBar_bar"),"LoadingBar")
	local l_bar = tolua.cast(img_bar:getChildByName("Label_bar"),"Label")

	btn_sprite:setTag(nTag)
	local tabMonsterInfo = GetSpiritInfoByLevel(nTag)
	local str = nil
	if nTag == 1 then

		str = "青龙之魂"
	elseif nTag == 2 then
		str = "白虎之魂"
	elseif nTag == 3 then
		str = "朱雀之魂"
	elseif nTag == 4 then
		str = "玄武之魂"
	end
	img_sprite:setTag(nTag)
	img_sprite:setTouchEnabled(true)
	
	local p_tag = nTag + 5
	print(nTag,p_tag,"tag值")

	if tonumber(PerTab["prestige"]) <= 0 then
		PerNum = 0
	end
	
	l_bar:setText(PerTab["prestige"].."/"..tabMonsterInfo["ReputCost"])
	local n_percent = tonumber(PerTab["prestige"])/tonumber(tabMonsterInfo["ReputCost"])

	if img_sprite:getChildByTag(12) ~= nil then
		img_sprite:getChildByTag(12):removeFromParentAndCleanup(true)
	end

	if n_percent >= 1 then
		n_percent = 1
		local Animation11,Animation112 = GetNormalSpiritAnimation(nTag)
		CommonInterface.GetAnimationByName(Animation11, 
			"juntuan_lingshou_texiao", 
			Animation112, 
			img_sprite, 
			ccp(0, 0),
			nil,
			12)
		-- img_sprite:addTouchEventListener(_ClickTouckAnimate_CallBack)
	else
		-- img_sprite:addTouchEventListener(_ClickNormalAnimate_CallBack)
	end
	l_spiritName:setText("贡品:"..str)
	bar_percent:setPercent(n_percent*100)
	

	local strname = ""
	if tonumber(PerTab["is_open"]) == 1 then
		strname = "灵兽赐福"
		if btn_sprite:getChildByTag(nTag) == nil then
			m_PointManger:ShowRedPoint(nTag,btn_sprite,62,15)
		end
	else
		strname = "获取贡品"
		if btn_sprite:getChildByTag(nTag) ~= nil then
			btn_sprite:getChildByTag(nTag):removeFromParentAndCleanup(true)
		end
		-- m_PointManger:DeleteRedPoint(nTag)
	end

	if btn_sprite:getChildByTag(1000) ~= nil then
		LabelLayer.setText(btn_sprite:getChildByTag(1000),strname)
	else
		btnText = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, strname, ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -3), 3)
		btn_sprite:addChild(btnText,1000,1000)
	end

	local function _Click_SpiritBless_CallBack( sender,eventType )
		
		if eventType == TouchEventType.ended then
			local btn_bless = tolua.cast(sender,"Button")
			local BlessTag = btn_bless:getTag()
			AudioUtil.PlayBtnClick()
			if tonumber(PerTab["is_open"]) == 0 then
				--查看灵兽的详细信息
				local function GetTributeCallBack(  )
					NetWorkLoadingLayer.loadingHideNow()
					-- ShowSpiritInfo(BlessTag)
					--得到消耗的金币数量
					local consumGold = math.ceil((tonumber(tabMonsterInfo["ReputCost"]) - tonumber(PerTab["prestige"]))/tonumber(tabMonsterInfo["GoldExchange"]))
						
					local function MonsterCallFull( isLock )
						if isLock == true then
							local function GetTributeCallBack(  )
								CorpsScene.GetConteobile(1)
								local cur_MPer = GetCurPerByServer()
								--[[if tonumber(cur_MPer) <= 0 then
									cur_MPer = 0
								end
								label_bar:setText(cur_MPer.."/"..tabMonsterInfo["ReputCost"])
								local p_ppercent = tonumber(cur_MPer)/tonumber(tabMonsterInfo["ReputCost"])
								if p_ppercent >= 1 then
									p_ppercent = 1
									-- LabelLayer.setText(labelGoldText,"获取赐福")
									btn_call:setTag(10)
								end
								bar_spirit:setPercent(p_ppercent*100)
								GetReward()]]--
							end
							Packet_AniTribute.SetSuccessCallBack(GetTributeCallBack)
							network.NetWorkEvent(Packet_AniTribute.CreatePacket(BlessTag,2))
						end
					end
					local ppTips = TipCommonLayer.CreateTipLayerManager()
					ppTips:ShowCommonTips(1493,MonsterCallFull,consumGold, str)
				end
				Packet_AniGetInfo.SetSuccessCallBack(GetTributeCallBack)
				network.NetWorkEvent(Packet_AniGetInfo.CreatePacket(BlessTag))
				NetWorkLoadingLayer.loadingShow(true)
			else
				--进入赐福界面,对战队进行赐福
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					local tabHM = {}
					tabHM = GetYetMercenaryInfo()
					ChooseBless(tabHM,BlessTag)
				end
				Packet_CorpsYetMercenary.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsYetMercenary.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)
			end
		end
	end
	btn_sprite:addTouchEventListener(_Click_SpiritBless_CallBack)

	local function _Click_loadInfo_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local s_tag = sender:getTag()
			loadSpiritInfo(s_tag)
		end
	end
	img_sprite:setTouchEnabled(true)
	img_sprite:setTag(nTag)
	img_sprite:addTouchEventListener(_Click_loadInfo_CallBack)
end

function GetSpiritLayer(  )
	return m_CorpsSpiritLayer
end

--灵兽信息
function ShowRightUI()
	if m_CorpsSpiritLayer == nil then
		return
	end
	local Panel_right = tolua.cast(m_CorpsSpiritLayer:getWidgetByName("Panel_right"),"Layout")
	------------------------------------------
	tabPer = GetAniPerstigDB()
	p_control1 = tolua.cast(Panel_right:getChildByName("Panel_spirit"),"Layout")
	p_control2 = tolua.cast(Panel_right:getChildByName("Panel_spirit_0"),"Layout")
	p_control3 = tolua.cast(Panel_right:getChildByName("Panel_spirit_1"),"Layout")
	p_control4 = tolua.cast(Panel_right:getChildByName("Panel_spirit_2"),"Layout")

	WidgetSpriteUI(p_control1,tabPer[1],1)
	WidgetSpriteUI(p_control2,tabPer[2],2)
	WidgetSpriteUI(p_control3,tabPer[3],3)
	WidgetSpriteUI(p_control4,tabPer[4],4)
	--------------------------------------------------------------------------------------------------
	--圣兽
	local image_lowest = tolua.cast(Panel_right:getChildByName("Image_lowst"),"ImageView")
	local image_hero = tolua.cast(image_lowest:getChildByName("Image_hero"),"ImageView")
	local image_fengding = tolua.cast(Panel_right:getChildByName("Button_64"),"Button")
	-- local pImgBar = tolua.cast(image_lowest:getChildByName("Image_bar"),"ImageView")
	local img_shade = tolua.cast(image_lowest:getChildByName("Image_num"),"ImageView")
	local img_shadeArray = tolua.cast(image_lowest:getChildByName("Image_fengding"),"ImageView")
	local img_action = tolua.cast(image_lowest:getChildByName("Image_bian"),"ImageView")
	local img_action1 = tolua.cast(image_lowest:getChildByName("Image_topBotom"),"ImageView")
	local label_shengshou = tolua.cast(img_shade:getChildByName("Label_shengshou"),"Label")
	local pToBar = CCProgressTo:create(10, 100)
	local pNum = 255

	image_hero:loadTexture(SHENGSHOU_IMG)

	local tabMSInfo = GetSpiritInfoByLevel(5)
	local p_sCurPer = tabPer[5]

	--[[if tonumber(p_sCurPer["is_open"]) == 1 then
		if image_lowest:getChildByTag(23) == nil then
			m_PointManger:ShowRedPoint(23,image_lowest,55,55)
		end
	else
		m_PointManger:DeleteRedPoint(23)
	end]]--

	local function _Click_SpiritShenshou_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local t_tag = sender:getTag()
			-- if tonumber(p_sCurPer["is_open"]) == 0 then
				local function GetTributeCallBack(  )
					NetWorkLoadingLayer.loadingHideNow()
					-- ShowSpiritInfo(t_tag)
					BHMSpiritInfo()
				end
				Packet_AniGetInfo.SetSuccessCallBack(GetTributeCallBack)
				network.NetWorkEvent(Packet_AniGetInfo.CreatePacket(t_tag))
				NetWorkLoadingLayer.loadingShow(true)
			--[[else
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					local tabHM = {}
					tabHM = GetYetMercenaryInfo()
					ChooseBless(tabHM,t_tag)
				end
				Packet_CorpsYetMercenary.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsYetMercenary.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)
			end]]--
		end
	end

	local Animation11,Animation112 = GetNormalSpiritAnimation(5)
	CommonInterface.GetAnimationByName(Animation11, 
			"juntuan_lingshou_texiao", 
			Animation112, 
			img_action, 
			ccp(0, 0),
			nil,
			12)
	
	local bar_SSpirit = tonumber(p_sCurPer["prestige"])/tonumber(tabMSInfo["ReputCost"])
	label_shengshou:setText(tonumber(p_sCurPer["prestige"]).."/"..tabMSInfo["ReputCost"])

	if bar_SSpirit >= 1 then
		bar_SSpirit = 1
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/juntuan_lingshou_texiao/juntuan_lingshou_texiao.ExportJson", 
			"juntuan_lingshou_texiao", 
			"Animation6", 
			img_shadeArray, 
			ccp(0, 0),
			nil,
			12)
	end
	local shadeNum = 255*(1-bar_SSpirit)
	img_shadeArray:setOpacity(shadeNum)
	img_action:setPosition(ccp(img_action:getPositionX(),-8-130*bar_SSpirit))
	
	image_fengding:setTag(5)
	image_fengding:setTouchEnabled(true)
	if tonumber(p_sCurPer["is_open"]) == 1 then
		-- image_fengding:setOpacity(0)
	else
		-- image_fengding:setOpacity(100)
	end
	image_fengding:addTouchEventListener(_Click_SpiritShenshou_CallBack)

end

--左侧信息
local function initWidget(  )
	if m_CorpsSpiritLayer == nil then
		return
	end
	local Panel_upLeft = tolua.cast(m_CorpsSpiritLayer:getWidgetByName("Panel_leftBottom"),"Layout")
	local img_leftBg = tolua.cast(Panel_upLeft:getChildByName("Image_bg"),"ImageView")
	Panel_upLeft:setPosition(ccp(Panel_upLeft:getPositionX() + CommonData.g_Origin.x,Panel_upLeft:getPositionY()))--m_ChatShowLayer:getPositionX() - CommonData.g_Origin.x
	local label_corpsLevel = tolua.cast(m_CorpsSpiritLayer:getWidgetByName("Label_corpsLevel"),"Label")
	local label_content = tolua.cast(m_CorpsSpiritLayer:getWidgetByName("Label_content"),"Label")
	local img_top = tolua.cast(m_CorpsSpiritLayer:getWidgetByName("Image_top"),"ImageView")
	local img_botoom = tolua.cast(m_CorpsSpiritLayer:getWidgetByName("Image_btom"),"ImageView")
	m_listView = tolua.cast(img_leftBg:getChildByName("ListView_ItemView"),"ListView")
	--箭头动作
	local actionArray1 = CCArray:create()
	actionArray1:addObject(CCMoveBy:create(1, ccp(0, -10)))
	actionArray1:addObject(CCMoveBy:create(1, ccp(0, 10)))
	img_top:runAction(CCRepeatForever:create(CCSequence:create(actionArray1)))

	local actionArray2 = CCArray:create()
	actionArray2:addObject(CCMoveBy:create(1, ccp(0, 10)))
	actionArray2:addObject(CCMoveBy:create(1, ccp(0, -10)))
	img_botoom:runAction(CCRepeatForever:create(CCSequence:create(actionArray2)))
	--得到当前科技等级信息
	local tabLeft = CorpsSpiritLogic.CkeckTechLevel()
	
    label_corpsLevel:setText(tabLeft["TechName"])

    -- label_content:setText(tabLeft["TechDes"])
    NoticeScrollLayer.ShowScrollowLayer(tabLeft["TechDes"],img_leftBg,-130,220)
    ----------------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------------------
	local tabQuery = {}
	local function GetQUERYCallFull(  )
		NetWorkLoadingLayer.loadingHideNow()
		tabQuery = GetQueryInfo()
		local pItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSpiritItem.json")
		if #tabQuery <= 8 then
			if next(tabQuery) ~= nil then
				for key,value in pairs(tabQuery) do
					if m_listView == nil then
						return
					end
					local m_CityItemManger = CorpsSpiritBase.Create()
					m_CityItemManger:SetValue(value)
					m_CityItemManger:ShowListCityItem(pItemTemp,value)
					m_listView:pushBackCustomItem(m_CityItemManger:GetItem())
					local ptem = m_CityItemManger:GetItem()
					table.insert(tabMangerHand,m_CityItemManger)
				end
				if #tabQuery < 4 then
					if img_top == nil or img_botoom == nil or m_listView == nil then
						return
					end
					img_top:setVisible(false)
					img_botoom:setVisible(false)
					for i=(#tabQuery+1),4 do
						local m_CityItemManger = CorpsSpiritBase.Create()
						m_CityItemManger:SetValue(value)
						local temp = m_CityItemManger:ShowListCityItem(pItemTemp,value)
						m_listView:pushBackCustomItem(m_CityItemManger:GetItem())
						table.insert(tabMangerHand,m_CityItemManger)
					end
				end
			else
				for i=1,4 do
					if img_top == nil or img_botoom == nil or m_listView == nil then
						return
					end
					img_top:setVisible(false)
					img_botoom:setVisible(false)
					local m_CityItemManger = CorpsSpiritBase.Create()
					m_CityItemManger:SetValue(value)
					local temp = m_CityItemManger:ShowListCityItem(pItemTemp,value)
					m_listView:pushBackCustomItem(m_CityItemManger:GetItem())
					table.insert(tabMangerHand,m_CityItemManger)

				end
			end
		else
			for key,value in pairs(tabQuery) do
				if m_listView == nil then
					return
				end
				local m_CityItemManger = CorpsSpiritBase.Create()
				m_CityItemManger:SetValue(value)
				local temp = m_CityItemManger:ShowListCityItem(pItemTemp,value)
				m_listView:pushBackCustomItem(m_CityItemManger:GetItem())
				table.insert(tabMangerHand,m_CityItemManger)
			end
		end
		
	end
	Packet_AniCountryInfo.SetSuccessCallBack(GetQUERYCallFull)
	network.NetWorkEvent(Packet_AniCountryInfo.CreatePacket())
	NetWorkLoadingLayer.loadingShow(true)

	--listView滑动回调
	local function requestCallBAck( sender,eventType )
		AudioUtil.PlayBtnClick()
		if eventType == SCROLLVIEW_EVENT_SCROLL_TO_TOP then
			if #tabQuery <= 4 then
				img_top:setVisible(false)
				img_botoom:setVisible(false)
			else
				img_top:setVisible(false)
				img_botoom:setVisible(true)
			end
		elseif eventType == SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM then
			if #tabQuery <= 4 then
				img_top:setVisible(false)
				img_botoom:setVisible(false)
			else
				img_top:setVisible(true)
				img_botoom:setVisible(false)
			end
		elseif eventType == SCROLLVIEW_EVENT_SCROLLING then
			if #tabQuery <= 4 then
				img_top:setVisible(false)
				img_botoom:setVisible(false)
			else
				img_top:setVisible(true)
				img_botoom:setVisible(true)
			end
		end
	end
	
	--m_listView:setItemsMargin(-5)
	if m_listView ~= nil then m_listView:setClippingType(1) end
	m_listView:addEventListenerScrollView(requestCallBAck)

	ShowRightUI()
end

function showSpiritLayer(nRoot)
	initData()

	m_PointManger = AddPoint.CreateAddPoint()

	m_CorpsSpiritLayer = TouchGroup:create()									-- 背景层
	m_CorpsSpiritLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSpiritLayer.json"))

	initWidget()
	
	local btn_return = tolua.cast(m_CorpsSpiritLayer:getWidgetByName("Button_return"),"Button")
	btn_return:setTouchEnabled(true)
	btn_return:addTouchEventListener(_Click_return_CallBack)
	

	if CorpsScene.GetPCorpsLayer == nil then
		m_isCorpsEnter = true
	end
	m_RootLayer = nRoot
	m_GotoCountryWar = UIGotoManager.CreateUIGotoManager()
	m_GotoCountryWar:CreateObj()

	

	return m_CorpsSpiritLayer
end