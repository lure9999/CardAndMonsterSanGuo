-- for CCLuaEngine traceback
require "Script/Common/Common"
require "Script/Fight/simulationStl"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarDef"


module("CountryLevelUpLayer", package.seeall)

local m_LevelUpLayer 	= nil 
local m_PanelCountry    = nil
local m_Exp 			= nil
local m_MaxExp 			= nil
local m_FightPowerTab 	= nil


local StrokeLabel_createStrokeLabel 		= 	LabelLayer.createStrokeLabel 

local GetGeneralResId						= 	CountryWarData.GetGeneralResId
local GetCountry							=	CountryWarData.GetCountry
local GetPower								=	CountryWarData.GetPower
local GetLevel								=	CountryWarData.GetLevel
local GetExp								=	CountryWarData.GetExp
local GetEnemyCountry						=	CountryWarData.GetEnemyCountry
local GetEnemyLevel							=	CountryWarData.GetEnemyLevel
local GetEnemyExp							=	CountryWarData.GetEnemyExp
local GetNormalDefenseArmyID				=	CountryWarData.GetNormalDefenseArmyID
local GetEliteDefenseArmyID					=	CountryWarData.GetEliteDefenseArmyID
local GetLevelUpMax							=	CountryWarData.GetLevelUpMax
local GetCountryRes							=	CountryWarData.GetCountryRes
local GetNormalArmyName						=	CountryWarData.GetNormalArmyName
local GetNormalArmyLv						=	CountryWarData.GetNormalArmyLv
local GetEliteArmyName						=	CountryWarData.GetEliteArmyName
local GetEliteArmyLv						=	CountryWarData.GetEliteArmyLv

local UIInterface_CreatAnimateByResID 		= 	UIInterface.CreatAnimateByResID

local CountryType = {
	Country 		=	1,
	GPost 			=	2,
}

local function InitVars()
	m_LevelUpLayer 	  = nil 
	m_PanelCountry    = nil
	m_Exp 			  = nil
	m_MaxExp 		  = nil
	m_FightPowerTab   = nil
end

local function _Button_Return_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		m_LevelUpLayer:removeFromParentAndCleanup(true)
		InitVars()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Show_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
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

local function _Button_CountryBtn_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
   		local Image_BtnCountry = tolua.cast(m_LevelUpLayer:getWidgetByName("Image_BtnCountry"), "ImageView")
    	local Image_BtnOffical = tolua.cast(m_LevelUpLayer:getWidgetByName("Image_BtnOffical"), "ImageView")
        if m_PanelCountry:isVisible() == false then
        	Image_BtnOffical:loadTexture("Image/imgres/button/btn_page_n.png")
        	Image_BtnCountry:loadTexture("Image/imgres/button/btn_page_l.png")
        	if Image_BtnCountry:getChildByTag(99) ~= nil then
        		Image_BtnCountry:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nCountryLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "国家", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
        		Image_BtnCountry:addChild(nCountryLabel,1,99)
        	end
        	if Image_BtnOffical:getChildByTag(99) ~= nil then
        		Image_BtnOffical:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nOfficalLabel    = CreateLabel( "官员", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))	
        		Image_BtnOffical:addChild(nOfficalLabel,1,99)
        	end
			m_PanelCountry:setVisible(true)
			m_PanelCountry:setPositionX(m_PanelCountry:getPositionX() - 10000)
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_OfficalBtn_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
   		local Image_BtnCountry = tolua.cast(m_LevelUpLayer:getWidgetByName("Image_BtnCountry"), "ImageView")
    	local Image_BtnOffical = tolua.cast(m_LevelUpLayer:getWidgetByName("Image_BtnOffical"), "ImageView")
        if m_PanelCountry:isVisible() == true then
        	Image_BtnOffical:loadTexture("Image/imgres/button/btn_page_l.png")
        	Image_BtnCountry:loadTexture("Image/imgres/button/btn_page_n.png")
        	if Image_BtnCountry:getChildByTag(99) ~= nil then
        		Image_BtnCountry:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nCountryLabel    = CreateLabel( "国家", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
        		Image_BtnCountry:addChild(nCountryLabel,1,99)
        	end
        	if Image_BtnOffical:getChildByTag(99) ~= nil then
        		Image_BtnOffical:getChildByTag(99):removeFromParentAndCleanup(true)
        		local nOfficalLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "官员", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
        		Image_BtnOffical:addChild(nOfficalLabel,1,99)
        	end
			m_PanelCountry:setVisible(false)
			m_PanelCountry:setPositionX(m_PanelCountry:getPositionX() + 10000)
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitCountryUI(  )
	--添加城市动画
	local pCountry = GetCountry()
	local pLevel   = GetLevel()
	m_Exp     	   = GetExp()
	local Image_Bg 		= tolua.cast(m_LevelUpLayer:getWidgetByName("Image_Bg"), "ImageView")

	local Image_CountryInfo = tolua.cast(m_PanelCountry:getChildByName("Image_CountryInfo"), "ImageView")
	local ProgressBar_Exp   = tolua.cast(Image_CountryInfo:getChildByName("ProgressBar_Exp"), "LoadingBar")
	local Label_Exp 		= tolua.cast(ProgressBar_Exp:getChildByName("Label_Exp"), "Label")
	--经验
	m_MaxExp = GetLevelUpMax(pCountry, pLevel)
	if m_MaxExp <= m_Exp then m_Exp = m_MaxExp end
	if pLevel >= 10 then
		Label_Exp:setText("已达上限")
	else
		Label_Exp:setText(m_Exp.."/"..m_MaxExp)
	end
	ProgressBar_Exp:setPercent(tonumber(m_Exp / m_MaxExp) * 100)

	--战斗力
	local Label_CountryPower = tolua.cast(Image_CountryInfo:getChildByName("Label_CountryPower"), "Label")

	local pText = LabelBMFont:create()
	pText:setFntFile("Image/imgres/main/fight.fnt")
	pText:setPosition(ccp(Label_CountryPower:getPositionX() + 120, Label_CountryPower:getPositionY() - 8))
	pText:setAnchorPoint(ccp(0,0.5))
	printTab(m_FightPowerTab)
	pText:setText(m_FightPowerTab[tonumber(GetCountry())])
	Image_CountryInfo:addChild(pText,0,1000)

	local Image_CountryFlag = tolua.cast(Image_CountryInfo:getChildByName("Image_CountryFlag"), "ImageView")
	local Label_CountryName = tolua.cast(Image_CountryInfo:getChildByName("Label_CountryName"), "Label")

	if tonumber(GetCountry()) == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
		Image_CountryFlag:loadTexture("Image/imgres/corps/weiqi.png")
		Label_CountryName:setText("魏国LV."..pLevel)
	elseif tonumber(GetCountry()) == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
		Image_CountryFlag:loadTexture("Image/imgres/corps/shuqi.png")
		Label_CountryName:setText("蜀国LV."..pLevel)
	elseif tonumber(GetCountry()) == COUNTRY_TYPE.COUNTRY_TYPE_WU then
		Image_CountryFlag:loadTexture("Image/imgres/corps/wuqi.png")
		Label_CountryName:setText("吴国LV."..pLevel)
	end

	--敌人信息
	local Image_EnemyCoyInfo = tolua.cast(m_PanelCountry:getChildByName("Image_EnemyCoyInfo"), "ImageView")
	
	for i=1,2 do
		local Label_EnemyName = tolua.cast(Image_EnemyCoyInfo:getChildByName("Label_EnemyName_"..i), "Label")
		if tonumber(GetEnemyCountry(i)) == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
			Label_EnemyName:setText("魏国LV."..GetEnemyLevel(i))
		elseif tonumber(GetEnemyCountry(i)) == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
			Label_EnemyName:setText("蜀国LV."..GetEnemyLevel(i))
		elseif tonumber(GetEnemyCountry(i)) == COUNTRY_TYPE.COUNTRY_TYPE_WU then
			Label_EnemyName:setText("吴国LV."..GetEnemyLevel(i))
		end
		local pEnemyLevel = GetEnemyLevel(i)
		local pEnemyExp        = GetEnemyExp(i)
		local pEnemyMaxExp     = GetLevelUpMax(GetEnemyCountry(i), pEnemyLevel)
		if pEnemyMaxExp <= pEnemyExp then pEnemyExp = pEnemyMaxExp end

		local ProgressBar_Exp_Enemy  = tolua.cast(Image_EnemyCoyInfo:getChildByName("ProgressBar_Exp_"..i), "LoadingBar")
		local Label_Exp_Enemy        = tolua.cast(ProgressBar_Exp_Enemy:getChildByName("Label_Exp"), "Label")
		if pEnemyLevel >= 10 then 
			Label_Exp_Enemy:setText("已达上限")
		else
			Label_Exp_Enemy:setText(pEnemyExp.."/"..pEnemyMaxExp)
		end
		ProgressBar_Exp_Enemy:setPercent(tonumber(pEnemyExp / pEnemyMaxExp) * 100)
	end


	local Label_1  = tolua.cast(m_PanelCountry:getChildByName("Label_1"), "Label")
	local Label_2  = tolua.cast(m_PanelCountry:getChildByName("Label_2"), "Label")

	--普通守卫说明
	Label_1:setText(GetNormalArmyName().."LV."..GetNormalArmyLv())
	--精英守卫说明
	Label_2:setText(GetEliteArmyName().."LV."..GetEliteArmyLv())

	local nLevelUpLabel   = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT1, "国家升级", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)
	local nTrialLabel     = StrokeLabel_createStrokeLabel(20, CommonData.g_FONT1, "试炼任务", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, 0), 2)

	local Button_LevelUp  = tolua.cast(m_PanelCountry:getChildByName("Button_LevelUp"), "Button")
	local Button_Trial    = tolua.cast(m_PanelCountry:getChildByName("Button_Trial"), "Button")	
	Button_LevelUp:addChild(nLevelUpLabel)
	Button_Trial:addChild(nTrialLabel)

	local pImageAniBg = tolua.cast(m_PanelCountry:getChildByName("Image_AniBg"), "ImageView")
	if pImageAniBg==nil then
		print("pImageAniBg is nil")
		return false
	else
		pImageAniBg:runAction(CCRepeatForever:create(CCRotateBy:create(3, 360)))
		local pAniResTab = GetCountryRes(pCountry, pLevel)

		if pAniResTab ~= nil then

			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAniResTab["AniPath"])
		    local pArmature = CCArmature:create(pAniResTab["AniName"])
		    pArmature:getAnimation():play(pAniResTab["AniAct"])
		    pArmature:setPosition(ccp(pImageAniBg:getPositionX(), pImageAniBg:getPositionY()))
		    m_PanelCountry:addNode(pArmature,99)

		end
	end
	local normalID = GetNormalDefenseArmyID()
	local eliteID  = GetEliteDefenseArmyID()

	--添加守卫形象
	local pPlayer 	   = UIInterface_CreatAnimateByResID(GetGeneralResId(normalID)) 	--守卫
	pPlayer:setPosition(ccp(Label_1:getPositionX(), Label_1:getPositionY() + 30))
	local pPlayerElite = UIInterface_CreatAnimateByResID(GetGeneralResId(eliteID)) 	--精英守卫
	pPlayerElite:setPosition(ccp(Label_2:getPositionX(), Label_2:getPositionY() + 30))

	m_PanelCountry:addNode(pPlayer,99)
	m_PanelCountry:addNode(pPlayerElite,99)

	--国家等级label
	local pLevelStrTab = {}
	pLevelStrTab[1] = "一"
	pLevelStrTab[2] = "二"
	pLevelStrTab[3] = "三"
	pLevelStrTab[4] = "四"
	pLevelStrTab[5] = "五"
	pLevelStrTab[6] = "六"
	pLevelStrTab[7] = "七"
	pLevelStrTab[8] = "八"
	pLevelStrTab[9] = "九"
	pLevelStrTab[10] = "十"
	local Label_CountryLevel = tolua.cast(m_PanelCountry:getChildByName("Label_CountryLevel"), "Label")
	Label_CountryLevel:setText(pLevelStrTab[pLevel].."级国家")

end

local function _Button_CountryLevelUp_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
        if m_Exp >= m_MaxExp then
        	if GetLevel() <= 10 then
	        	local function UpdateData(  )
					Packet_GetCountryLevelUpData.SetSuccessCallBack(InitCountryUI)
					network.NetWorkEvent(Packet_GetCountryLevelUpData.CreatePacket(GetCountry()))
					TipLayer.createTimeLayer("升级成功", 2)	
	        	end
				Packet_CountryLevelUpOrder.SetSuccessCallBack(UpdateData)
				network.NetWorkEvent(Packet_CountryLevelUpOrder.CreatePacket(GetCountry()))
			else
				TipLayer.createTimeLayer("国家等级已达上限", 2)
			end
		else
			TipLayer.createTimeLayer("经验不足", 2)	
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_TrialMission_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end


function CreateCountryLevelUpLay(nType, nPowerTab)
	InitVars() 

	m_LevelUpLayer = TouchGroup:create()								
    m_LevelUpLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryLevelUpLayer.json"))

    m_FightPowerTab = nPowerTab

    --local Image_Bg = tolua.cast(m_LevelUpLayer:getWidgetByName("Image_Bg"), "ImageView")
    local Image_BtnCountry = tolua.cast(m_LevelUpLayer:getWidgetByName("Image_BtnCountry"), "ImageView")
    local Image_BtnOffical = tolua.cast(m_LevelUpLayer:getWidgetByName("Image_BtnOffical"), "ImageView")
	Image_BtnCountry:setEnabled(false)
	Image_BtnOffical:setEnabled(false)
	Image_BtnCountry:addTouchEventListener(_Button_CountryBtn_CallBack)
	--Image_BtnOffical:addTouchEventListener(_Button_OfficalBtn_CallBack)

	if nType == CountryType.Country then
		local Image_Bg 		= tolua.cast(m_LevelUpLayer:getWidgetByName("Image_Bg"), "ImageView")
		m_PanelCountry 		= tolua.cast(Image_Bg:getChildByName("Panel_Country"), "Layout")
		local Button_LevelUp  = tolua.cast(m_PanelCountry:getChildByName("Button_LevelUp"), "Button")
		local Button_Trial    = tolua.cast(m_PanelCountry:getChildByName("Button_Trial"), "Button")	
		Button_LevelUp:addTouchEventListener(_Button_CountryLevelUp_CallBack)
		Button_Trial:addTouchEventListener(_Button_TrialMission_CallBack)

		InitCountryUI()
		local nCountryLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "国家", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
		local nOfficalLabel    = CreateLabel( "官员", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		Image_BtnCountry:addChild(nCountryLabel,1,99)
		Image_BtnOffical:addChild(nOfficalLabel,1,99)
	elseif nType == CountryType.GPost then
		local nOfficalLabel    = StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, "官员", ccp(12, 0), ccc3(24,14,4), COLOR_White, true, ccp(0, 0), 2)
		local nCountryLabel    = CreateLabel( "国家", 30, ccc3(239,137,82), CommonData.g_FONT1, ccp(7,0))
		Image_BtnCountry:addChild(nCountryLabel,1,99)
		Image_BtnOffical:addChild(nOfficalLabel,1,99)
	else

	end

    local Button_Return = tolua.cast(m_LevelUpLayer:getWidgetByName("Button_Return"),"Button")
	if Button_Return == nil then
		print("Button_Return is nil")
		return false
	else
		Button_Return:addTouchEventListener(_Button_Return_CallBack)
	end
    
    return m_LevelUpLayer
end

