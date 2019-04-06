--主将升级

module("HeroUpGradeLayer",package.seeall)
require "Script/Main/HeroUpgrade/HeroUpGradeData"

local UNCHANGE = "Image/imgres/VIPCharge/unchange.png"
local CurLevelData = HeroUpGradeData.CurLevelData
local GetImgpath   = HeroUpGradeData.GetImgpath

local m_UpgradeLayer   = nil
local cur_level        = 0

local function init(  )
	m_UpgradeLayer     = nil
	cur_level          = 0
end

function CloseUpGradeLayer(  )
	if m_UpgradeLayer ~= nil then
		m_UpgradeLayer:setVisible(false)
		m_UpgradeLayer:removeFromParentAndCleanup(true)
		m_UpgradeLayer = nil
	end
end

local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		CloseUpGradeLayer()
	end
end

local function upDateTop(  )
	--label
	local l_level = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_level"),"Label")
	local l_tili = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_tili"),"Label")
	local l_naili = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_naili"),"Label")
	local l_wj = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_wj"),"Label")
	local l_levelNum = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_levelNum"),"Label")
	local l_tiliNum = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_tiliNum"),"Label")
	local l_nailiNum = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_nailiNum"),"Label")
	local l_wjNum = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_wjNum"),"Label")

	--imageView 
	local img_arrows1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_arrow1"),"ImageView")
	local img_arrows2 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_arrow2"),"ImageView")
	local img_arrows3 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_arrow3"),"ImageView")
	local img_arrows4 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_arrow4"),"ImageView")

	--label
	local pro_level = tonumber(cur_level) - 1
	if pro_level <= 0 then
		pro_level = 1
	end
	local proData = CurLevelData(pro_level)
	l_level:setText("等级：LV"..pro_level)
	l_tili:setText("体力上限："..proData["TiLi_Max"])
	l_naili:setText("耐力上限："..proData["NaiLi_Max"])

	local cur_Data = CurLevelData(cur_level)
	

	local levelText = LabelBMFont:create()
	levelText:setFntFile("Image/imgres/common/num/limitNum.fnt")
	levelText:setPosition(ccp(30,1))
	levelText:setAnchorPoint(ccp(1,0.5))
	levelText:setText(cur_level)
	l_levelNum:addChild(levelText,0,1000)


	
	
	local wjText = LabelBMFont:create()
	wjText:setFntFile("Image/imgres/common/num/limitNum.fnt")
	wjText:setPosition(ccp(35,1))
	wjText:setAnchorPoint(ccp(1,0.5))
	wjText:setText(cur_Data["Exp_Reserves"])
	l_wjNum:addChild(wjText,0,1000)

	if tonumber(proData["TiLi_Max"]) == tonumber(cur_Data["TiLi_Max"]) then
		img_arrows2:loadTexture(UNCHANGE)
		--[[local pWorldText = Label:create()
		tiliText:setPosition(ccp(30,1))
		tiliText:setAnchorPoint(ccp(1,0.5))
		tiliText:setText(cur_Data["TiLi_Max"])
		l_tiliNum:addChild(tiliText,0,1000)]]--
		l_tiliNum:setText(cur_Data["TiLi_Max"])
		l_tiliNum:setPosition(ccp(70,19))
	else
		local tiliText = LabelBMFont:create()
		tiliText:setFntFile("Image/imgres/common/num/limitNum.fnt")
		tiliText:setPosition(ccp(30,1))
		tiliText:setAnchorPoint(ccp(1,0.5))
		tiliText:setText(cur_Data["TiLi_Max"])
		l_tiliNum:addChild(tiliText,0,1000)

	end
	if tonumber(proData["NaiLi_Max"]) == tonumber(cur_Data["NaiLi_Max"]) then
		img_arrows3:loadTexture(UNCHANGE)
		l_nailiNum:setText(cur_Data["NaiLi_Max"])
		l_nailiNum:setPosition(ccp(70,-16))
	else
		local nailiText = LabelBMFont:create()
		nailiText:setFntFile("Image/imgres/common/num/limitNum.fnt")
		nailiText:setPosition(ccp(30,1))
		nailiText:setAnchorPoint(ccp(1,0.5))
		nailiText:setText(cur_Data["NaiLi_Max"])
		l_nailiNum:addChild(nailiText,0,1000)
	end
	if tonumber(proData["Exp_Reserves"]) == tonumber(cur_Data["Exp_Reserves"]) then
		img_arrows4:loadTexture(UNCHANGE)
	end
	--[[if tonumber(proData["TiLi_Max"]) == tonumber(cur_Data["TiLi_Max"]) then
		img_arrows2:setVisible(false)
	end]]--
end

local function upDateBottom(  )
	--imageView
	local img_open1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_open"),"ImageView")
	local img_open2 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_open1"),"ImageView")
	local img_close3 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_close1"),"ImageView")
	local img_close4 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_close2"),"ImageView")
	local img_opItem1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_icon1"),"ImageView")
	local img_opItem2 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_icon2"),"ImageView")
	local img_cItem1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_icon3"),"ImageView")
	local img_cItem2 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_icon4"),"ImageView")

	local img_top = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_14"),"ImageView")
	local img_bg = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_bg"),"ImageView")
	local img_1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_4"),"ImageView")
	local img_2 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_5"),"ImageView")
	local img_3 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_6"),"ImageView")
	local img_4 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_7"),"ImageView")
	local img_5 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_8"),"ImageView")
	local img_6 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_9"),"ImageView")
	local img_7 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_10"),"ImageView")
	local img_8 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_11"),"ImageView")
	local img_9 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_12"),"ImageView")
	local img_10 = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_13"),"ImageView")
	local img_lv = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_lv"),"ImageView")
	local btn_return = tolua.cast(m_UpgradeLayer:getWidgetByName("Button_return"),"Button")

	
	--label
	local l_open = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_open"),"Label")
	local l_close = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_close"),"Label")
	local l_open1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_open1"),"Label")
	local l_open2 = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_open2"),"Label")
	local l_close1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_close1"),"Label")
	local l_close2 = tolua.cast(m_UpgradeLayer:getWidgetByName("Label_close2"),"Label")

	local cur_Data = CurLevelData(cur_level)

	local closeID1 = 0
	local closeID2 = 0
	local openID1 = 0
	local openID2 = 0
	if tonumber(cur_Data["Open1"]) == nil then
		openID1 = 238
	else
		openID1 = tonumber(cur_Data["Open1"])
	end
	if tonumber(cur_Data["Open2"]) == nil then
		openID2 = 238
	else
		openID2 = tonumber(cur_Data["Open2"])
	end
	if tonumber(cur_Data["NextOpen1"]) == nil then
		closeID1 = 238
	else
		closeID1 = tonumber(cur_Data["NextOpen1"])
	end
	if tonumber(cur_Data["NextOpen2"]) == nil then
		closeID2 = 238
	else
		closeID2 = tonumber(cur_Data["NextOpen2"])
	end
	if openID1 <= 0 then
		
		img_open1:setVisible(false)
		img_open2:setVisible(false)
		l_open:setVisible(false)
		l_open1:setVisible(false)
		l_open2:setVisible(false)
		if tonumber(cur_Data["NextOpen1"]) <= 0 then
			img_close3:setVisible(false)
			img_close4:setVisible(false)
			l_close:setVisible(false)
			l_close1:setVisible(false)
			l_close2:setVisible(false)
			img_bg:setSize(CCSize(580,300))
			img_bg:setPosition(ccp(549,400))
			img_top:setPosition(ccp(0,-30))
			img_3:setPosition(ccp(0,-130))
			img_10:setPosition(ccp(5,80))
			img_1:setPosition(ccp(-147,130))
			img_2:setPosition(ccp(151,130))
			img_4:setPosition(ccp(-102,80))
			img_5:setPosition(ccp(112,80))
			img_6:setPosition(ccp(-186,25))
			img_7:setPosition(ccp(189,25))
			img_6:setSize(CCSize(120,120))
			img_7:setSize(CCSize(120,120))
			img_8:setSize(CCSize(250,90))
			img_9:setSize(CCSize(250,90))
			img_8:setPosition(ccp(-121,-80))
			img_9:setPosition(ccp(124,-80))
			btn_return:setPosition(ccp(280,130))
			img_lv:setPosition(ccp(73,25))
		else
			l_close1:removeAllChildrenWithCleanup(true)
			l_close2:removeAllChildrenWithCleanup(true)
			local imgClose1 = GetImgpath(closeID1)
			local imgClose2 = GetImgpath(closeID2)
			l_close:setPosition(ccp(l_close:getPositionX(),l_close:getPositionY()+26))
			img_close3:setPosition(ccp(img_close3:getPositionX(),img_close3:getPositionY()+26))
			img_close4:setPosition(ccp(img_close4:getPositionX(),img_close4:getPositionY()+26))
			l_close1:setPosition(ccp(l_close1:getPositionX(),l_close1:getPositionY()+26))
			l_close2:setPosition(ccp(l_close2:getPositionX(),l_close2:getPositionY()+20))
			img_cItem1:loadTexture(imgClose1)
			img_cItem2:loadTexture(imgClose2)
			local VIPContentItem1 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["NextOpenText1"],100,1,nil,1)
			local VIPContentItem2 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["NextOpenText2"],100,1,nil,1)
			VIPContentItem2:setPosition(ccp(-30,20))
			VIPContentItem1:setPosition(ccp(-30,20))
			l_close1:addChild(VIPContentItem1)
			l_close2:addChild(VIPContentItem2)

			--[[img_bg:setSize(CCSize(580,380))
			img_bg:setPosition(ccp(549,380))
			img_top:setPosition(ccp(0,20))
			img_3:setPosition(ccp(0,-170))
			img_10:setPosition(ccp(5,120))
			img_1:setPosition(ccp(-147,160))
			img_2:setPosition(ccp(151,160))
			img_4:setPosition(ccp(-102,80))
			img_5:setPosition(ccp(112,80))
			img_6:setPosition(ccp(-186,70))
			img_7:setPosition(ccp(189,70))
			img_6:setSize(CCSize(120,150))
			img_7:setSize(CCSize(120,150))
			img_8:setSize(CCSize(250,120))
			img_9:setSize(CCSize(250,120))
			img_8:setPosition(ccp(-121,-80))
			img_9:setPosition(ccp(124,-80))
			btn_return:setPosition(ccp(830,550))]]--
		end
		
	elseif openID1 >= 0 and openID2 <= 0 then
		img_open2:setVisible(false)
		l_open2:setVisible(false)
		local imgopenpath1 = GetImgpath(openID1)
		img_opItem1:loadTexture(imgopenpath1)
		l_open1:removeAllChildrenWithCleanup(true)
		local openContentItem1 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["OpenText1"],100,1,nil,1)
		openContentItem1:setPosition(ccp(-30,20))
		l_open1:addChild(openContentItem1)
		if closeID1 <= 0 then
			img_close3:setVisible(false)
			img_close4:setVisible(false)
			l_close:setVisible(false)
			l_close1:setVisible(false)
			l_close2:setVisible(false)
			l_open:setPosition(ccp(l_open:getPositionX(),l_open:getPositionY()-46))
			img_open1:setPosition(ccp(img_open1:getPositionX(),img_open1:getPositionY()-46))
			l_open1:setPosition(ccp(l_open1:getPositionX(),l_open1:getPositionY()-46))
		else 
			local imgClose1 = GetImgpath(closeID1)
			local imgClose2 = GetImgpath(closeID2)
			img_cItem1:loadTexture(imgClose1)
			img_cItem2:loadTexture(imgClose2)
			l_close1:removeAllChildrenWithCleanup(true)
			l_close2:removeAllChildrenWithCleanup(true)
			local VIPContentItem1 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["NextOpenText1"],100,1,nil,1)
			local VIPContentItem2 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["NextOpenText2"],100,1,nil,1)
			VIPContentItem2:setPosition(ccp(-30,20))
			VIPContentItem1:setPosition(ccp(-30,20))
			l_close1:addChild(VIPContentItem1)
			l_close2:addChild(VIPContentItem2)
		end
	elseif openID1 >= 0 and openID2 >= 0 then
		local imgopenpath1 = GetImgpath(openID1)
		img_opItem1:loadTexture(imgopenpath1)
		local imgopenpath2 = GetImgpath(openID2)
		img_opItem2:loadTexture(imgopenpath2)

		l_open1:removeAllChildrenWithCleanup(true)
		local openContentItem1 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["OpenText1"],100,1,nil,1)
		openContentItem1:setPosition(ccp(-30,20))
		l_open1:addChild(openContentItem1)
		l_open2:removeAllChildrenWithCleanup(true)
		local openContentItem2 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["OpenText2"],100,1,nil,1)
		openContentItem2:setPosition(ccp(-30,20))
		l_open2:addChild(openContentItem2)
		if closeID1 <= 0 then
			img_close3:setVisible(false)
			img_close4:setVisible(false)
			l_close:setVisible(false)
			l_close1:setVisible(false)
			l_close2:setVisible(false)
			l_open:setPosition(ccp(l_open:getPositionX(),l_open:getPositionY()-46))
			img_open1:setPosition(ccp(img_open1:getPositionX(),img_open1:getPositionY()-46))
			l_open1:setPosition(ccp(l_open1:getPositionX(),l_open1:getPositionY()-46))
			img_open2:setPosition(ccp(img_open2:getPositionX(),img_open2:getPositionY()-46))
			l_open2:setPosition(ccp(l_open2:getPositionX(),l_open2:getPositionY()-46))
		else
			local imgClose1 = GetImgpath(closeID1)
			local imgClose2 = GetImgpath(closeID2)
			img_cItem1:loadTexture(imgClose1)
			img_cItem2:loadTexture(imgClose2)
			l_close1:removeAllChildrenWithCleanup(true)
			l_close2:removeAllChildrenWithCleanup(true)
			local VIPContentItem1 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["NextOpenText1"],100,1,nil,1)
			local VIPContentItem2 = RichLabel.Create("|color|49,31,21||size|20|"..cur_Data["NextOpenText2"],100,1,nil,1)
			VIPContentItem2:setPosition(ccp(-30,20))
			VIPContentItem1:setPosition(ccp(-30,20))
			l_close1:addChild(VIPContentItem1)
			l_close2:addChild(VIPContentItem2)
		end
	end
end

local function CreateUGLayer( m_nLevel )
	init()
	m_UpgradeLayer = TouchGroup:create()
	m_UpgradeLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/HeroUpGrade.json"))

	cur_level = m_nLevel
	upDateTop()
	upDateBottom()

	m_UpgradeLayer:setTouchPriority(-1)


	--[[local panel_return = tolua.cast(m_UpgradeLayer:getWidgetByName("Panel_1"),"Layout")
	panel_return:addTouchEventListener(_Click_return_CallBack)]]--

	local btn_return = tolua.cast(m_UpgradeLayer:getWidgetByName("Button_return"),"Button")
	btn_return:setPressedActionEnabled(true)
	btn_return:addTouchEventListener(_Click_return_CallBack)

	if tonumber(m_nLevel) > 2 then
		m_UpgradeLayer:setScale(0)
		m_UpgradeLayer:runAction(CCScaleTo:create(0.2, 1))
	end

	return m_UpgradeLayer
end

function showUpLayer( n_level )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local nPosX = scenetemp:getContentSize().width
	local nPosY = scenetemp:getContentSize().height
	local temp = scenetemp:getChildByTag(layerHeroUpgrade_tag)
	local u_gradeLayer = CreateUGLayer(n_level)
	scenetemp:addChild(u_gradeLayer,layerHeroUpgrade_tag,layerHeroUpgrade_tag)
	local panel_1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Panel_1"),"Layout")
	local img_bg = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_bg"),"ImageView")
	panel_1:setVisible(false)
	local function DelayLayer(  )
		panel_1:setVisible(true)
		img_bg:setScale(0)
		local actionArray1 = CCArray:create()
		actionArray1:addObject(CCScaleTo:create(0.2, 1))
		-- actionArray1:addObject(CCDelayTime:create())
		-- actionArray1:addObject(CCCallFuncN:create(callBack))
		img_bg:runAction(CCSequence:create(actionArray1))
		if tonumber(n_level) == 2 then
			u_gradeLayer:setVisible(false)
		end
	end
	if temp ~= nil then
		temp:removeFromParentAndCleanup(true)
		
		AudioUtil.playEffect("audio/shengji_UI.mp3")
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/shengji_texiao/shengji_texiao.ExportJson", 
			"shengji_texiao", 
			"Animation1", 
			u_gradeLayer, 
			ccp(nPosX/2, nPosY/2),
			DelayLayer,
			layerHeroUpgrade_tag)
	else
		AudioUtil.playEffect("audio/shengji_UI.mp3")
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/shengji_texiao/shengji_texiao.ExportJson", 
			"shengji_texiao", 
			"Animation1", 
			u_gradeLayer, 
			ccp(nPosX/2, nPosY/2),
			DelayLayer,
			layerHeroUpgrade_tag)

	end
end

function CreateLayer( callBack )
	local c_level = server_mainDB.getMainData("level")
	if tonumber(c_level) == 1 then
		-- c_level = 2
	end
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local nPosX = scenetemp:getContentSize().width
	local nPosY = scenetemp:getContentSize().height
	local temp = scenetemp:getChildByTag(layerHeroUpgrade_tag)
	local u_gradeLayer = CreateUGLayer(c_level)
	scenetemp:addChild(u_gradeLayer,layerHeroUpgrade_tag,layerHeroUpgrade_tag)
	local panel_1 = tolua.cast(m_UpgradeLayer:getWidgetByName("Panel_1"),"Layout")
	local img_bg = tolua.cast(m_UpgradeLayer:getWidgetByName("Image_bg"),"ImageView")
	panel_1:setVisible(false)
	local function DelayLayer(  )
		panel_1:setVisible(true)
		if callBack ~= nil then
			img_bg:setScale(0)
			local actionArray1 = CCArray:create()
			actionArray1:addObject(CCScaleTo:create(0.2, 1))
			-- actionArray1:addObject(CCDelayTime:create())
			actionArray1:addObject(CCCallFuncN:create(callBack))
			img_bg:runAction(CCSequence:create(actionArray1))
		end
		if tonumber(c_level) == 2 then
			-- u_gradeLayer:setVisible(false)
		end
	end
	if temp ~= nil then
		temp:removeFromParentAndCleanup(true)
		AudioUtil.playEffect("audio/shengji_UI.mp3")
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/shengji_texiao/shengji_texiao.ExportJson", 
			"shengji_texiao", 
			"Animation1", 
			u_gradeLayer, 
			ccp(nPosX/2, nPosY/2),
			DelayLayer,
			1200)
	else
		AudioUtil.playEffect("audio/shengji_UI.mp3")
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/shengji_texiao/shengji_texiao.ExportJson", 
			"shengji_texiao", 
			"Animation1", 
			u_gradeLayer, 
			ccp(nPosX/2, nPosY/2),
			DelayLayer,
			1200)

	end
	
end

function ShowUpLayer( is_show )
	if m_UpgradeLayer ~= nil then
		m_UpgradeLayer:setVisible(is_show)
	end
end