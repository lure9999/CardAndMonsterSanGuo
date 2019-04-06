require "Script/Common/LabelLayer"
module("CorpsTipLayer",package.seeall)
require "Script/Main/Chat/ChatData"
require "Script/Main/Chat/ChatLayer"
require "Script/Main/Chat/ChatShowLayer"
local GetGamerInfo	=   ChatData.GetGamerInfo

local HeroInfoLayer = nil
local HeroSetInfoLayer = nil
local m_MercenaryInfo = nil
local labelheroPosition = nil
local PositionNum  = nil
local num = 1
local labelpowerdataText = nil
local LeaveHeroName = nil
local image_Ugeneral = nil
local image_shengnv = nil
local image_ComPerson = nil
local image_hufa = nil
local image_general = nil
local tablePersonInfo = {}
local tablePositionType = {"将军","副将","护法","圣女","帮众"}
local GetHeadImgPath = CorpsData.GetHeadImgPath
local GetSearchId = CorpsLogic.SearchId
local n_golbPosition = nil
local numHuafa = 0
local numShennv = 0
local tableOffical = {}
local TotalnumGeneral = 0
local TotalnumUnGeneral = 0
local TotalnumHua = 0
local TotalnumShengnv = 0
local c_positionType = nil
local c_alterPosType = nil
--显示个人信息
local function initData(  )
	HeroInfoLayer = nil
	HeroSetInfoLayer = nil
	m_MercenaryInfo = nil
	labelheroPosition = nil
	PositionNum  = nil
	num = 1
	labelpowerdataText = nil
	LeaveHeroName = nil
	image_Ugeneral = nil
	image_shengnv = nil
	image_ComPerson = nil
	image_hufa = nil
	image_general = nil
	n_golbPosition = nil
	numHuafa        = 0
	numShennv       = 0
	tablePersonInfo = {}
	tableOffical = {}
end

local function SetPower( num )
	local labelheroPower = tolua.cast(HeroInfoLayer:getWidgetByName("Label_power"),"Label")
	if labelheroPower:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(labelheroPower:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(num)
	else
		local pText = LabelBMFont:create()	
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-10,-20))
		pText:setAnchorPoint(ccp(0,0.5))
		pText:setText(num)
		labelheroPower:addChild(pText,0,1000)
	end
end

local function SetPositionPower( num )
	local label_level = tolua.cast(HeroSetInfoLayer:getWidgetByName("Label_power"),"Label")
	if label_level:getChildByTag(1005) ~= nil then
		local ntemp = tolua.cast(label_level:getChildByTag(1005),"LabelBMFont")
		ntemp:setText(num)
	else
		local pText = LabelBMFont:create()		
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(0,-20))
		--pText:setAnchorPoint(ccp(0,0))
		pText:setText(num)
		label_level:addChild(pText,1005,1005)
	end
end

local function _Click_left_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		num = num - 1
		if num < 1 then
			num = #tablePositionType
		end
		
		--labelTestTypr:setText(TestTypeTable[num])
		if lable_offical:getChildByTag(1000) ~= nil then
			LabelLayer.setText(lable_offical:getChildByTag(1000),tablePositionType[num])
		else
			local text = LabelLayer.createStrokeLabel(30,"微软雅黑",tablePositionType[num],ccp(0,0),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,0),0)
			lable_offical:addChild(text,0,1000)
		end
	end
end

local function _Click_right_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		num = num + 1
		if num > #tablePositionType then
			num = 1
		end
		
		--labelTestTypr:setText(TestTypeTable[num])
		if lable_offical:getChildByTag(1000) ~= nil then
			LabelLayer.setText(lable_offical:getChildByTag(1000),tablePositionType[num])
		else
			local text = LabelLayer.createStrokeLabel(30,"微软雅黑",tablePositionType[num],ccp(0,0),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,0),0)
			lable_offical:addChild(text,0,1000)
		end
	end
end

--根据职位来确定所拥有的权限
local function JudgePosition( nposition )
	if nposition == 0 then
		image_general:setTouchEnabled(true)
		image_Ugeneral:setTouchEnabled(true)
		image_shengnv:setTouchEnabled(true)
		image_hufa:setTouchEnabled(true)
		image_ComPerson:setTouchEnabled(true)
	elseif nposition == 1 then
		image_general:setTouchEnabled(false)
		image_Ugeneral:setTouchEnabled(false)
		image_shengnv:setTouchEnabled(true)
		image_hufa:setTouchEnabled(true)
		image_ComPerson:setTouchEnabled(true)
	elseif nposition == 2 then
		image_general:setTouchEnabled(false)
		image_Ugeneral:setTouchEnabled(false)
		image_shengnv:setTouchEnabled(false)
		image_hufa:setTouchEnabled(false)
		image_ComPerson:setTouchEnabled(false)
	elseif nposition == 3 then
		image_general:setTouchEnabled(false)
		image_Ugeneral:setTouchEnabled(false)
		image_shengnv:setTouchEnabled(false)
		image_hufa:setTouchEnabled(true)
		image_ComPerson:setTouchEnabled(true)
	elseif nposition == 4 then
		image_general:setTouchEnabled(false)
		image_Ugeneral:setTouchEnabled(false)
		image_shengnv:setTouchEnabled(false)
		image_hufa:setTouchEnabled(false)
		image_ComPerson:setTouchEnabled(false)
	end
end

local function AlterPositionFunction( nPosition )
	-- print("护法,圣女",numHuafa,numShennv)
	if nPosition == 0 then
		image_general:setScale(1)
		image_Ugeneral:setScale(0.9)
		image_shengnv:setScale(0.9)
		image_ComPerson:setScale(0.9)
		image_hufa:setScale(0.9)
		image_general:setColor(ccc3(255,255,255))
		image_Ugeneral:setColor(ccc3(150,150,150))
		image_shengnv:setColor(ccc3(150,150,150))
		image_ComPerson:setColor(ccc3(150,150,150))
		image_hufa:setColor(ccc3(150,150,150))
	elseif nPosition == 1 then
		local n_unGeneral = CorpsContentLayer.numUnGeneral
		-- print(n_unGeneral,nPosition)
		-- Pause()
		-- if tonumber(n_unGeneral) < 1 then
			image_general:setScale(0.9)
			image_Ugeneral:setScale(1)
			image_shengnv:setScale(0.9)
			image_ComPerson:setScale(0.9)
			image_hufa:setScale(0.9)
			image_general:setColor(ccc3(150,150,150))
			image_Ugeneral:setColor(ccc3(255,255,255))
			image_shengnv:setColor(ccc3(150,150,150))
			image_ComPerson:setColor(ccc3(150,150,150))
			image_hufa:setColor(ccc3(150,150,150))
			-- num = nPosition
		-- end
	elseif nPosition == 2 then
		local n_huafa = CorpsContentLayer.numHua
		-- print(n_huafa,nPosition)
		-- Pause()
		-- if tonumber(n_huafa) < tonumber(numHuafa) then
			image_general:setScale(0.9)
			image_Ugeneral:setScale(0.9)
			image_shengnv:setScale(0.9)
			image_ComPerson:setScale(0.9)
			image_hufa:setScale(1)
			image_general:setColor(ccc3(150,150,150))
			image_Ugeneral:setColor(ccc3(150,150,150))
			image_shengnv:setColor(ccc3(150,150,150))
			image_ComPerson:setColor(ccc3(150,150,150))
			image_hufa:setColor(ccc3(255,255,255))
			-- num = nPosition
		-- else

		-- end
	elseif nPosition == 3 then
		local n_shengnv = CorpsContentLayer.numShengnv
		-- print(n_shengnv,nPosition)
		-- Pause()
		-- if tonumber(n_shengnv) < tonumber(numShennv) then
			image_general:setScale(0.9)
			image_Ugeneral:setScale(0.9)
			image_shengnv:setScale(1)
			image_ComPerson:setScale(0.9)
			image_hufa:setScale(0.9)
			image_general:setColor(ccc3(150,150,150))
			image_Ugeneral:setColor(ccc3(150,150,150))
			image_shengnv:setColor(ccc3(255,255,255))
			image_ComPerson:setColor(ccc3(150,150,150))
			image_hufa:setColor(ccc3(150,150,150))
			-- num = nPosition
		-- else
		-- end
	elseif nPosition == 4 then
		image_general:setScale(0.9)
		image_Ugeneral:setScale(0.9)
		image_shengnv:setScale(0.9)
		image_ComPerson:setScale(1)
		image_hufa:setScale(0.9)
		image_general:setColor(ccc3(150,150,150))
		image_Ugeneral:setColor(ccc3(150,150,150))
		image_shengnv:setColor(ccc3(150,150,150))
		image_ComPerson:setColor(ccc3(255,255,255))
		image_hufa:setColor(ccc3(150,150,150))

	end
end

local function _ClickPosition_CallBack( sender,eventType )
	local ptag = sender:getTag()
	num = ptag
	if eventType == TouchEventType.ended then
		AlterPositionFunction(ptag)
	end
end

local function EnterScienceUpLayer( isUpScience )
	n_selectId = 3
	require "Script/Main/Corps/CorpsScienceUp/CorpsScienceUpLayer"
	HeroSetInfoLayer:setVisible(false)
	HeroSetInfoLayer:removeFromParentAndCleanup(true)
	HeroSetInfoLayer = nil
	if isUpScience == true then
		local scenetemp = CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerCorpsTeachTag)
		if temp == nil then
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				local pTeachnologyLayer = CorpsScienceUpLayer.createTeachLayer(n_selectId-1)
				scenetemp:addChild(pTeachnologyLayer,1000,1000)
			end	
			Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
			NetWorkLoadingLayer.loadingShow(true)
		end
	end
end
    --修改官职
function createSetPositionLayer( value,tabLevel)
	if HeroSetInfoLayer == nil then
		HeroSetInfoLayer = TouchGroup:create()									-- 背景层
		HeroSetInfoLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/Corps_SettingInfo.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(HeroSetInfoLayer, layerAlterPosition_Tag, layerAlterPosition_Tag)
	end
	---------------------------------------------------------------
	-------科技的等级信息及对应的效果值
	local tablePersonNumData = {}
	for i=15,18 do
		local ArrayMemData = CorpsScienceData.GetArrayData(i)
		table.insert(tablePersonNumData,ArrayMemData)
	end
	local tableOfficalInfo = tablePersonNumData[tabLevel.m_nLevel ]
	-- printTab(tableOfficalInfo)
	-- Pause()
	if tonumber(tableOfficalInfo[10]) ~= 0 then 
		numHuafa = CorpsData.GetCorpsMemberNum(tableOfficalInfo[10])
		numShennv = CorpsData.GetCorpsMemberNum(tableOfficalInfo[11])
	else
		numHuafa = 0
		numShennv = 0
	end
	----------------------------------------------------------------------
	--军团各种官职数量
	--[[TotalnumGeneral = CorpsMemberManageLayer.numGeneral
	TotalnumUnGeneral = CorpsMemberManageLayer.numUnGeneral
	TotalnumHua = CorpsMemberManageLayer.numHua
	TotalnumShengnv = CorpsMemberManageLayer.numShengnv]]--
	-----------------------------------------------------------------------
	--成员信息
	local heroPerposition = value.position
	local heroname = value.name
	local heroUserid = value.userID
	local Faceid = value.faceID
	local heroPower = value.power
	local LastTime = value.lastTime
	local Week = value.seven
	local hero_level = value.level
	---------------------------------------------------------------------------
	
	num = heroPerposition 

	local imagebg = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_BG"),"ImageView")
	local imageHeroIcon = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_icon"),"ImageView")
	-- imageHeroIcon:loadTexture(GetHeadImgPath(Faceid))
	local pControl = UIInterface.MakeHeadIcon(imageHeroIcon, ICONTYPE.HEAD_ICON, nil, nil,nil,value["faceID"],nil)

	local label_level = tolua.cast(HeroSetInfoLayer:getWidgetByName("Label_level"),"Label")
	local label_name = tolua.cast(HeroSetInfoLayer:getWidgetByName("Label_name"),"Label")
	--local label_power = tolua.cast(HeroSetInfoLayer:getWidgetByName("Label_power"),"Label")
	label_position = tolua.cast(HeroSetInfoLayer:getWidgetByName("Label_position"),"Label")
	label_position:setVisible(false)

	local images_fight = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_51"),"ImageView")
	images_fight:loadTexture("Image/imgres/main/fight.png")

	SetPositionPower(heroPower)
	local labelnameText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, heroname, ccp(0, 0), ccc3(83,28,2), ccc3(255,194,30), true, ccp(0, -2), 2)
	
	---官职label
	local labelGeneralText = LabelLayer.createStrokeLabel(28, CommonData.g_FONT1, "将军", ccp(0, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)
	local labelUGeneralText = LabelLayer.createStrokeLabel(28, CommonData.g_FONT1, "副将", ccp(0, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)
	local labelhuFaText = LabelLayer.createStrokeLabel(28, CommonData.g_FONT1, "护法", ccp(0, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)
	local labelShengNvText = LabelLayer.createStrokeLabel(28, CommonData.g_FONT1, "圣女", ccp(0, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)
	local labelComPersonText = LabelLayer.createStrokeLabel(28, CommonData.g_FONT1, "帮众", ccp(0, 5), ccc3(255,255,190), ccc3(75,39,11), true, ccp(0, -2), 2)


	label_level:setText(hero_level)
	label_name:addChild(labelnameText)
	label_position:setText("大将军")

	--button
	local btn_Cancel_ = tolua.cast(HeroSetInfoLayer:getWidgetByName("Button_cancel"),"Button")
	local btn_Certain = tolua.cast(HeroSetInfoLayer:getWidgetByName("Button_certain"),"Button")
	--local btn_left = tolua.cast(HeroSetInfoLayer:getWidgetByName("Button_56"),"Button")
	--local btn_right = tolua.cast(HeroSetInfoLayer:getWidgetByName("Button_60"),"Button")

	local labelCancelText  = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "取消", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, 0), 0)
	local labelCertainText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black,COLOR_White, true, ccp(0, 0), 0)
		
	btn_Cancel_:addChild(labelCancelText)
	btn_Certain:addChild(labelCertainText)

	image_general   = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_general"),"ImageView")
	image_Ugeneral  = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_Ugeneral"),"ImageView")
	image_shengnv   = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_shengnv"),"ImageView")
	image_ComPerson = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_ComPeople"),"ImageView")
	image_hufa	  = tolua.cast(HeroSetInfoLayer:getWidgetByName("Image_42"),"ImageView")

	image_general:setTouchEnabled(false)
	image_Ugeneral:setTouchEnabled(false)
	image_shengnv:setTouchEnabled(false)
	image_ComPerson:setTouchEnabled(false)
	image_hufa:setTouchEnabled(false)
	image_general:setTag(0)
	image_Ugeneral:setTag(1)
	image_hufa:setTag(2)
	image_shengnv:setTag(3)
	image_ComPerson:setTag(4)
	---------------
	JudgePosition(n_golbPosition)
	image_general:addChild(labelGeneralText)
	image_Ugeneral:addChild(labelUGeneralText)
	image_hufa:addChild(labelhuFaText)
	image_shengnv:addChild(labelShengNvText)
	image_ComPerson:addChild(labelComPersonText)

	AlterPositionFunction(value.position)
	image_general:addTouchEventListener(_ClickPosition_CallBack)
	image_Ugeneral:addTouchEventListener(_ClickPosition_CallBack)
	image_hufa:addTouchEventListener(_ClickPosition_CallBack)
	image_shengnv:addTouchEventListener(_ClickPosition_CallBack)
	image_ComPerson:addTouchEventListener(_ClickPosition_CallBack)

	local function _Click_CancelPosition_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			HeroSetInfoLayer:setVisible(false)
			HeroSetInfoLayer:removeFromParentAndCleanup(true)
			HeroSetInfoLayer = nil
		end
	end

	local function _Click_CertainPosition_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			PositionNum = num
			--[[if PositionNum == heroPerposition then
				HeroSetInfoLayer:setVisible(false)
				HeroSetInfoLayer:removeFromParentAndCleanup(true)
				HeroSetInfoLayer = nil
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1620,nil)
				pTips = nil
			else]]--
				if PositionNum == 0 then
					str = "将军"
				elseif PositionNum == 1 then
					str = "副将"
				elseif PositionNum == 2 then
					str = "护法"
				elseif PositionNum == 3 then
					str = "圣女"
				elseif PositionNum == 4 then
					str = "帮众"
				end
				if tabLevel.m_nLevel == 0 then
					-- TipLayer.createTimeLayer("当前科技等级为0级，请前往科技升级处升级再来")
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1458,EnterScienceUpLayer,nil)
					pTips = nil
				else
					if PositionNum == heroPerposition then
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1648,nil,str)
						pTips = nil
						return
					end
					local function GetSuccessCallback(  )
						NetWorkLoadingLayer.loadingShow(false)
						--LabelLayer.setText(labelpowerdataText,str)
						-- labelpowerdataText:setText(str)
						c_alterPosType = str
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1619,nil,value.name,str)
						pTips = nil
						HeroSetInfoLayer:setVisible(false)
						HeroSetInfoLayer:removeFromParentAndCleanup(true)
						HeroSetInfoLayer = nil
						CorpsContentLayer.loadDataFromServer()
					end	
					Packet_CorpsAppoint.SetSuccessCallBack(GetSuccessCallback)
					network.NetWorkEvent(Packet_CorpsAppoint.CreatePacket(PositionNum,heroUserid))
					NetWorkLoadingLayer.loadingShow(true)
				end
				
			--end
		end
	end


	btn_Cancel_:addTouchEventListener(_Click_CancelPosition_CallBack)
	btn_Certain:addTouchEventListener(_Click_CertainPosition_CallBack)
end

function createHeroInfoLayer( value ,CommondPosition)
	-- printTab(value)
	-- Pause()
	local nGlobalID = CommonData.g_nGlobalID
	n_golbPosition = CorpsScene.n_GolbPosition
	local tableeeeee = CorpsData.GetScienceLevel()
	tableOffical = tableeeeee[3]
	c_alterPosType = nil
	local Heroposition = value.position
	local heroname = value.name
	local Userid = value.userID
	local Faceid = value.faceID
	local heroPower = value.power
	local LastTime = value.lastTime
	local Week = value.seven
	local hero_level = value.level
	local HeroImageBG = tolua.cast(HeroInfoLayer:getWidgetByName("Image_BG"),"ImageView")

	local heroIcon = tolua.cast(HeroInfoLayer:getWidgetByName("Image_icon"),"ImageView")
	if Faceid == 0 then
		UIInterface.MakeHeadIcon(heroIcon,ICONTYPE.DISPLAY_ICON,nil,nil,nil,nil,nil)
		--heroIcon:setScale(0.68)
	else
		local pControl = UIInterface.MakeHeadIcon(heroIcon, ICONTYPE.HEAD_ICON, nil, nil,nil,value["faceID"],nil)
		--heroIcon:loadTexture(GetHeadImgPath(Faceid))
	end

	local imageLevel = tolua.cast(HeroInfoLayer:getWidgetByName("Image_level"),"ImageView")
	local labelheroLevel = tolua.cast(imageLevel:getChildByName("Label_level"),"Label")

	local imageName = tolua.cast(HeroInfoLayer:getWidgetByName("Image_name"),"ImageView")
	local labelheroName = tolua.cast(HeroInfoLayer:getWidgetByName("Label_name"),"Label")
	local image_fight = tolua.cast(HeroInfoLayer:getWidgetByName("Image_112"),"ImageView")
	image_fight:loadTexture("Image/imgres/main/fight.png")

	-- local imagePower = tolua.cast(HeroImageBG:getChildByName("Image_power"),"ImageView")
	-- local labelheroPower = tolua.cast(imagePower:getChildByName("Label_power"),"Label")

	labelheroPosition = tolua.cast(HeroImageBG:getChildByName("Label_position"),"Label")
	-- labelheroPosition:setVisible(false)

	local btn_alterPosition = tolua.cast(HeroImageBG:getChildByName("Button_alterPosition"),"Button")
	local btn_Private = tolua.cast(HeroImageBG:getChildByName("Button_PrivateChat"),"Button")
	local btn_leaveCorps = tolua.cast(HeroImageBG:getChildByName("Button_LeaveCorps"),"Button")

	SetPower(value.power)
	local labelLevelText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, value.level, ccp(0, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)
    local labelNameText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, value.name, ccp(-40, 0), ccc3(83,28,2), ccc3(255,194,30), true, ccp(0, -2), 2)
    local labelOfficialText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "大将军", ccp(0, 0), ccc3(83,28,2), ccc3(62,28,11), true, ccp(0, -2), 2)
    local labelalterPositionText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "修改官职", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
    local labelPrivateChatText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "发起私聊", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
    local labelLeaveText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "请离军团", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)

    labelpowerdataText = Label:create()
    labelpowerdataText:setFontSize(30)
    labelpowerdataText:setColor(ccc3(63,28,11))
    labelpowerdataText:setPosition(ccp(-20,0))
    if value.position == 0 then
    	labelpowerdataText:setText("将军")
    	c_positionType = "将军"
      elseif value.position == 1 then
    	labelpowerdataText:setText("副将")
    	c_positionType = "副将"
    elseif value.position == 2 then
    	labelpowerdataText:setText("护法")
    	c_positionType = "护法"
    elseif value.position == 3 then
    	labelpowerdataText:setText("圣女")
    	c_positionType = "圣女"
    elseif value.position == 4 then
    	labelpowerdataText:setText("帮众")
    	c_positionType = "帮众" 
    end

    labelheroLevel:addChild(labelLevelText)
    labelheroPosition:addChild(labelpowerdataText)
    labelheroName:addChild(labelNameText)
    btn_alterPosition:addChild(labelalterPositionText)
    btn_Private:addChild(labelPrivateChatText)
    btn_leaveCorps:addChild(labelLeaveText)
    btn_alterPosition:setVisible(false)
    btn_alterPosition:setTouchEnabled(false)
	btn_leaveCorps:setVisible(false)
	btn_leaveCorps:setTouchEnabled(false)
	btn_Private:setTouchEnabled(false)
	btn_Private:setVisible(false)
	btn_Private:setTag(value["userID"])

	--判断点击的是自己还是他人

    if nGlobalID == value.userID then
    	btn_alterPosition:setVisible(false)
	    btn_leaveCorps:setVisible(false)
	    btn_Private:setVisible(false)
	    btn_alterPosition:setTouchEnabled(false)
	    btn_leaveCorps:setTouchEnabled(false)
	    btn_Private:setTouchEnabled(false)
    else
    	-- Pause()
    	if CommondPosition == 0 then
	    	btn_alterPosition:setVisible(true)
	    	btn_leaveCorps:setVisible(true)
	    	btn_Private:setVisible(true)
	    	btn_alterPosition:setTouchEnabled(true)
	    	btn_leaveCorps:setTouchEnabled(true)
	    	btn_Private:setTouchEnabled(true)
	    elseif CommondPosition == 1 or CommondPosition == 2 or CommondPosition == 3 then
	    	btn_alterPosition:setVisible(true)
	    	btn_leaveCorps:setVisible(true)
	    	btn_Private:setVisible(true)
	    	btn_alterPosition:setTouchEnabled(true)
	    	btn_leaveCorps:setTouchEnabled(true)
	    	btn_Private:setTouchEnabled(true)
	    else
	    	btn_Private:setVisible(true)
	    	btn_Private:setTouchEnabled(true)
    	end
    end

    local function _Click_AlterPosition_CallBack( sender,eventType )
    	if eventType == TouchEventType.ended then
    		AudioUtil.PlayBtnClick()
			
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				HeroInfoLayer:removeFromParentAndCleanup(true)
				HeroInfoLayer = nil
				local tableposition = {}
				tableposition = CorpsData.GetScienceLevel()
				createSetPositionLayer(value,tableposition[3])
				
			end	
			Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
			NetWorkLoadingLayer.loadingShow(true)
		end
    end

    local function _Click_PrivateChat_CallBack( sender,eventType )
    	if eventType == TouchEventType.ended then
    		AudioUtil.PlayBtnClick()
    		local function ShowGamerInfo()
				local currDB = GetGamerInfo()
				HeroInfoLayer:setVisible(false)
				HeroInfoLayer:removeFromParentAndCleanup(true)
				HeroInfoLayer = nil
				CorpsContentLayer.removeLayer()
				ChatShowLayer.OpenChatLayer()
				ChatLayer.SetPrivateName(currDB.name)
				ChatLayer.CheckBoxState(E_CHAT_TYPE.E_CHAT_PRIVATE)
				
			end
			Packet_GetGamerInfo.SetSuccessCallBack(ShowGamerInfo)
			network.NetWorkEvent(Packet_GetGamerInfo.CreatPacket(sender:getTag()))
    	end
    end

    local function _Click_LeaveHero_CallBack( sender,eventType )
    	if eventType == TouchEventType.ended then
    		AudioUtil.PlayBtnClick()
    		local function leaveCorpsFu( isLeave )
    			if isLeave == false then
    				
    			else
    				local function GetSuccessCallback(  )
						NetWorkLoadingLayer.loadingShow(false)
						HeroInfoLayer:setVisible(false)
						HeroInfoLayer:removeFromParentAndCleanup(true)
						HeroInfoLayer = nil
						-- CorpsMemberManageLayer.loadDataFromServer()
						CorpsContentLayer.loadDataFromServer()
					end	
					Packet_CorpsExpel.SetSuccessCallBack(GetSuccessCallback)
					network.NetWorkEvent(Packet_CorpsExpel.CreatePacket(value.userID))
					NetWorkLoadingLayer.loadingShow(true)
    			end
    		end
    		local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1618,leaveCorpsFu,value.name)
			-- pTips = nil
    	end
    end

    btn_alterPosition:addTouchEventListener(_Click_AlterPosition_CallBack)
    btn_Private:addTouchEventListener(_Click_PrivateChat_CallBack)
    btn_leaveCorps:addTouchEventListener(_Click_LeaveHero_CallBack)

	local function _Click_PerosonReturn_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			HeroInfoLayer:setVisible(false)
			HeroInfoLayer:removeFromParentAndCleanup(true)
			HeroInfoLayer = nil
			if c_alterPosType == nil then
				-- TipLayer.createTimeLayer("没进入修改界面修改该成员的官职")
			else
				if c_positionType == c_alterPosType then
					-- TipLayer.createTimeLayer("进入修改界面没有修改该成员的官职")
				else
					-- CorpsMemberManageLayer.loadDataFromServer()
					CorpsContentLayer.loadDataFromServer()
				end
			end
			-- 
		end
	end
	local button_PersonReturn = tolua.cast(HeroInfoLayer:getWidgetByName("Button_return"),"Button")
	button_PersonReturn:addTouchEventListener(_Click_PerosonReturn_CallBack)
	--return HeroInfoLayer
end

function MercenaryInfoLayer( Mess,tabID )
	for key,value in pairs(Mess) do
		if GetSearchId(tabID,value) == true then
			tablePersonInfo["name"] = value[1]
			tablePersonInfo["img"] = value[2]
			tablePersonInfo["power"] = value[3]
			tablePersonInfo["level"] = value[4]
			tablePersonInfo["ID"] = value[5]
		end
	end
	if m_MercenaryInfo == nil then
		m_MercenaryInfo = TouchGroup:create()									-- 背景层
	    m_MercenaryInfo:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMercenaryHero.json") )
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(m_MercenaryInfo, layerMerInfo_Tag, layerMerInfo_Tag)
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
	local label_powerWord = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_PowerWord"),"Label")
	local label_power = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_Power"),"Label")
	local label_cost = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_cost"),"Label")
	local label_costNum = tolua.cast(m_MercenaryInfo:getWidgetByName("Label_costNum"),"Label")
	local btn_cost = tolua.cast(image_bg:getChildByName("Button_cost"),"Button")

	local labelNameText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, tablePersonInfo.name, ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
	label_name:addChild(labelNameText)

	image_head:loadTexture(tablePersonInfo.img)

	label_powerWord:setColor(ccc3(51,25,13))
	label_powerWord:setFontSize(24)
	label_powerWord:setFontName(CommonData.g_FONT3)	
	label_powerWord:setText("战力：")

	label_power:setColor(ccc3(51,25,13))
	label_power:setFontSize(24)
	label_power:setFontName(CommonData.g_FONT3)	
	label_power:setText(tablePersonInfo.power)

	label_cost:setColor(ccc3(51,25,13))
	label_cost:setFontSize(24)
	label_cost:setFontName(CommonData.g_FONT3)	
	label_cost:setText("身价：")

	label_costNum:setColor(ccc3(51,25,13))
	label_costNum:setFontSize(24)
	label_costNum:setFontName(CommonData.g_FONT3)	
	label_costNum:setText(tablePersonInfo.power)

	local labelBtnText = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "解雇", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, 0), 2)
	btn_cost:addChild(labelBtnText)
    
	---------------------------------------------------------------------------------------------------------------
	local function loadInfoControl( pControl )
		local hero_head = tolua.cast(pControl:getChildByName("Image_hero1"),"ImageView")

	end

	local function InitWidgetControl( pControl )
		loadInfoControl(pControl)
	end

	local image_hero1 = tolua.cast(image_bg:getChildByName("Image_37"),"ImageView")
	local image_hero2 = tolua.cast(image_bg:getChildByName("Image_37_0"),"ImageView")
	local image_hero3 = tolua.cast(image_bg:getChildByName("Image_37_1"),"ImageView")
	local image_hero4 = tolua.cast(image_bg:getChildByName("Image_37_2"),"ImageView")
	local image_hero5 = tolua.cast(image_bg:getChildByName("Image_37_3"),"ImageView")
	local image_hero6 = tolua.cast(image_bg:getChildByName("Image_37_4"),"ImageView")

	InitWidgetControl(image_hero1)
	InitWidgetControl(image_hero2)
	InitWidgetControl(image_hero3)
	InitWidgetControl(image_hero4)
	InitWidgetControl(image_hero5)
	InitWidgetControl(image_hero6)
	---------------------------------------------------------------------------------------------------------------

	return m_MercenaryInfo
end

function CreatePositionLayer( value ,CommondPosition)
	initData()

	if HeroInfoLayer == nil then
		HeroInfoLayer = TouchGroup:create()
		HeroInfoLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsMemberLayer.json"))
	end

	createHeroInfoLayer(value,CommondPosition)

	return HeroInfoLayer
end