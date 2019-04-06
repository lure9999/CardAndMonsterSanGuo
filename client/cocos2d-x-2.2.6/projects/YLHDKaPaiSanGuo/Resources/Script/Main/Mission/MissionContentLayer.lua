require "Script/Common/Common"
require "Script/Common/RichLabel"
require "Script/Main/Mission/MissionData"
require "Script/Main/Mission/MissionLogic"


module("MissionContentLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 

local m_MissionContentLayer = nil
local m_BaseLayer			= nil
local m_PersonalHeight   = nil

local function InitVars()
	m_MissionContentLayer = nil
	m_BaseLayer			  = nil
	m_PersonalHeight   	  = nil
end

--copy item
local function CreateItemWidget( pItemTemp )
    local pItem = pItemTemp:clone()
    local peer = tolua.getpeer(pItemTemp)
    tolua.setpeer(pItem, peer)
    return pItem
end

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

local function _Button_Return_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
        m_BaseLayer:setVisible(true)
		m_MissionContentLayer:removeFromParentAndCleanup(true)
		InitVars()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Mission_CallFunc( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_FindCity_CallFunc( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
        local tag = 19
        require "Script/Main/CountryWar/CountryWarScene"
        CountryWarScene.MoveToHeroPt(tag)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
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


local function InitMissionContentUI( nType )
	local Image_MissionItem = tolua.cast(m_MissionContentLayer:getWidgetByName("Image_MissionTitle"),"ImageView")
	local pTitle_Storke = nil
	if nType == MISSION_TYPE.MISSION_COUNTRY then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "国 家 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
	elseif nType == MISSION_TYPE.MISSION_ARMY then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "军 团 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
	elseif nType == MISSION_TYPE.MISSION_SHILIAN then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "试 炼 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)		
	elseif nType == MISSION_TYPE.MISSION_LEVELUP then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "升 级 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
	elseif nType == MISSION_TYPE.MISSION_RANDOM then
		pTitle_Storke = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "随 机 任 务", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, 0), 2)
	end
	local pStateLabel    = CreateLabel("进行中", 24, ccc3(233,180,114), CommonData.g_FONT3, ccp(122,-3))
	if pTitle_Storke ~= nil then
		Image_MissionItem:addChild(pTitle_Storke,1)
	end
	if pStateLabel ~= nil then
		Image_MissionItem:addChild(pStateLabel,1)
	end
end

local function InitpItem( nItem, index, maxIndex )
	local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"), "ImageView")
	for i=1,4 do
		local corn = tolua.cast(Image_ItemBg:getChildByName("Image_Corn_"..i), "ImageView")
		if index == 1 then
			if i == 1 or i == 2 then
				corn:setVisible(true)
			end
		end
		if index == maxIndex then
			if i == 3 or i == 4 then
				corn:setVisible(true)
			end
		end
	end
	--任务名
	local missionName = CreateLabel("率部歼敌IV:造成1000万伤害", 20, ccc3(49,31,21), CommonData.g_FONT3, ccp(-105,10))
	missionName:setAnchorPoint(ccp(0,0))
	Image_ItemBg:addChild(missionName)
end

local function InitpItemByCountry( nItem )
	local title = tolua.cast(nItem:getChildByName("Image_Title"), "ImageView")
	local labelTitle = CreateLabel("国家任务", 22, COLOR_White, CommonData.g_FONT3, ccp(0,0))
	title:addChild(labelTitle)

	local Image_ItemBg = tolua.cast(nItem:getChildByName("Image_ItemBg"), "ImageView")
	local Button_FindCity = tolua.cast(Image_ItemBg:getChildByName("Button_FindCity"), "Button")
	local missionName = CreateLabel("守住【吴】", 20, ccc3(49,31,21), CommonData.g_FONT3, ccp(-105,10))
	missionName:setAnchorPoint(ccp(0,0))
	Image_ItemBg:addChild(missionName)

	local text = "函谷水域"
	local length = ComminuteText(text)
	local missionCity = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT1, text, ccp(0, 0), COLOR_Black, ccc3(99,216,53), true, ccp(0, 0), 2)
	Button_FindCity:addChild(missionCity)
	Button_FindCity:addTouchEventListener(_Click_FindCity_CallFunc)
	local lengthPos = length * 20
	local line = AddLine(ccp(0 - lengthPos / 2,-10),ccp(lengthPos / 2,-10), ccc3(99,216,53),1,255)
	Button_FindCity:addNode(line)
end

local function InitCountryList(  )
	local ListView_Country = tolua.cast(m_MissionContentLayer:getWidgetByName("ListView_Country"), "ListView")
	ListView_Country:setClippingType(1)
	local num = 4
	--增加国家任务item
	local pItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionCountryItem.json")
	local pItemheight = pItemTemp:getContentSize().height
	for i = 1, num do
		local pItem = CreateItemWidget(pItemTemp)
		InitpItemByCountry(pItem)
		ListView_Country:pushBackCustomItem(pItem)
	end	

	local function InitRewardItem( nItem )
		--完成度 3
		local missionNum = 2 		--当前任务总数
		local finishNum = 1 		--当前完成的任务数目
		local title = tolua.cast(nItem:getChildByName("Image_Title"), "ImageView")
		local pItemWidth = 60
		local pMaxItemWidth = 366
		local labelTitle = CreateLabel("附加奖励", 22, COLOR_White, CommonData.g_FONT3, ccp(0,0))
		title:addChild(labelTitle)	
		--先判断当前有几个任务	
		for i=1,missionNum do
			local Image_LaunchBg =  tolua.cast(nItem:getChildByName("Image_LaunchBg_"..i), "ImageView")
			Image_LaunchBg:setVisible(true)
			Image_LaunchBg:setScale9Enabled(true)
			local width = 366 / missionNum
			local diffX = width - pItemWidth
			Image_LaunchBg:setSize(CCSize(width, Image_LaunchBg:getSize().height))

			if i <= finishNum then
				local Image_Launch = tolua.cast(Image_LaunchBg:getChildByName("Image_Launch"), "ImageView")
				Image_Launch:setScale9Enabled(true)
				Image_Launch:setVisible(true)
				Image_Launch:setSize(CCSize(Image_Launch:getSize().width + diffX, Image_Launch:getSize().height))
			end
			
			if i ~= 1 then
				Image_LaunchBg:setPosition(ccp(Image_LaunchBg:getPositionX() + (diffX * (i-1)), 186))
			end
		end
	end
	local pItemReward = GUIReader:shareReader():widgetFromJsonFile("Image/MissionOtherItem.json")
	InitRewardItem(pItemReward)
	ListView_Country:pushBackCustomItem(pItemReward)
end

local function InitPersonalList(  )
	m_PersonalHeight = 0
	local num = 4
	local ScrollView_Personal = tolua.cast(m_MissionContentLayer:getWidgetByName("ScrollView_Personal"), "ScrollView")
	ScrollView_Personal:setClippingType(1)
	local title = tolua.cast(ScrollView_Personal:getChildByName("Image_title"), "ImageView")
	local redline = tolua.cast(ScrollView_Personal:getChildByName("Image_redline"), "ImageView")
	local labelTitle = CreateLabel("个人任务", 22, COLOR_White, CommonData.g_FONT3, ccp(0,0))
	title:addChild(labelTitle)
	m_PersonalHeight = m_PersonalHeight + title:getContentSize().height

	--增加个人任务item
	local pItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/MissionPersonalItem.json")
	local pItemheight = pItemTemp:getContentSize().height
	for i = 1, num do
		local pItem = CreateItemWidget(pItemTemp)
		InitpItem(pItem, i, num)
		pItem:setPositionX(-3)
		pItem:setTag(100 + i)
		ScrollView_Personal:addChild(pItem)
	end
	m_PersonalHeight = m_PersonalHeight + (pItemheight - 20) * num
	m_PersonalHeight = m_PersonalHeight + redline:getContentSize().height
	local labelText = CreateLabel("任务描述", 22, ccc3(142,33,0), CommonData.g_FONT3, ccp(62,redline:getPositionY() - 15))	
	ScrollView_Personal:addChild(labelText)
	m_PersonalHeight = m_PersonalHeight + labelText:getContentSize().height
	--local text = "曲礼曰：毋不敬，俨若思，安定辞，安民哉！敖不可长．欲不可从．志不可满．乐不可极。贤者狎而敬之．畏而爱之．爱而知其恶．憎而知其善．积而能散，安而能迁．临财毋苟得．临难毋苟免．很毋求胜．分毋求多．疑事毋质．直而勿有．鹦鹉能言．不离飞鸟．猩猩能言．不离禽兽．今人而无礼．虽能言．不亦禽兽之心乎．夫唯禽兽无礼．故父子聚麀．是故圣人作．为礼以教人．使人以有礼．知自别于禽兽．"
	local text = "曲礼曰：毋不敬，俨若思，安定辞，安民哉！敖不可长．欲不可从．志不可满．乐不可极。贤者狎而敬之"
	local missionInfo = RichLabel.Create("  |color|49,31,21|"..text,ScrollView_Personal:getInnerContainerSize().width - 40,1)
	ScrollView_Personal:addChild(missionInfo)
	m_PersonalHeight = m_PersonalHeight + missionInfo:getContentSize().height + 50  -- 50的偏差值
	--设置坐标
	if m_PersonalHeight < ScrollView_Personal:getContentSize().height then 
		m_PersonalHeight = ScrollView_Personal:getContentSize().height
	end
	ScrollView_Personal:setInnerContainerSize(CCSize(ScrollView_Personal:getInnerContainerSize().width, m_PersonalHeight))
	title:setPositionY(m_PersonalHeight - title:getContentSize().height * 0.5)
	for i=1,num do
		if ScrollView_Personal:getChildByTag(100 + i) ~= nil then
			ScrollView_Personal:getChildByTag(100 + i):setPositionY((title:getPositionY() - 30) - i * (pItemheight - 25))
		end
	end
	if ScrollView_Personal:getChildByTag(100 + num) ~= nil then
		redline:setPositionY(ScrollView_Personal:getChildByTag(100 + num):getPositionY() - 20)
		labelText:setPositionY(redline:getPositionY() - 15)
		missionInfo:setPosition(ccp(20, labelText:getPositionY() - 20))
	end
end
--create entrance
function CreateMissionLayer(nType, nBase)
	InitVars()
	m_MissionContentLayer = TouchGroup:create()
	m_MissionContentLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MissionContentLayer.json"))

	m_BaseLayer = nBase

	InitMissionContentUI(nType)

	InitPersonalList()

	InitCountryList()

    --按钮事件设置
    local Button_Return = tolua.cast(m_MissionContentLayer:getWidgetByName("Button_Return"),"Button")
	if Button_Return == nil then
		print("Button_Return is nil")
		return false
	else
		Button_Return:addTouchEventListener(_Button_Return_CallBack)
	end
    
	return  m_MissionContentLayer
end