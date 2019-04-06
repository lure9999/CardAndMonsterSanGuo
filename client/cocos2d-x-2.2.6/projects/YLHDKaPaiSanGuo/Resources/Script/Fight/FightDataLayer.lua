-- for CCLuaEngine traceback

require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/serverDB/general"
require "Script/Common/CommonData"
require "Script/serverDB/monst"
require "Script/DB/AnimationData"
require "Script/Main/Dungeon/DungeonBaseData"
require "Script/Main/Wujiang/GeneralBaseData"

module("FightDataLayer", package.seeall)

local GetMonsterIcon 				= DungeonBaseData.GetMonsterIcon
local GetMonsterColorIcon			= DungeonBaseData.GetMonsterColorIcon

local GetGeneralHeadIcon			= GeneralBaseData.GetGeneralHeadIcon
local GetGeneralColorIcon			= GeneralBaseData.GetGeneralColorIcon
local CreateStrokeLabel 		 	= LabelLayer.createStrokeLabel--
local m_pLayerFightData = nil
local m_pListDamage = nil
local m_bPkScene = false
local m_nMaxDamage = nil

local function InitVars(  )
	m_pLayerFightData = nil
	m_pListDamage = nil
	m_bPkScene = false
	m_nMaxDamage = 0
end

local function CreateDamageItemWidget( pShopItemTemp )
    local pShopItem = pShopItemTemp:clone()
    local peer = tolua.getpeer(pShopItemTemp)
    tolua.setpeer(pShopItem, peer)
    return pShopItem
end

local function UpdateDamageListItem( tabData, pListItem, bEnemy )
	local pImgHead = tolua.cast(pListItem:getChildByName("Image_Icon"), "ImageView")

	local pImgColor = tolua.cast(pListItem:getChildByName("Image_Color"), "ImageView")

	local pImgBar = tolua.cast(pListItem:getChildByName("Image_ProgressBar"), "ImageView")

	local pTimerBar = nil
	local pToBar = CCProgressTo:create(1, (tabData["m_Damage"]/m_nMaxDamage)*100)

	local pLabelDamage = nil
	if bEnemy==true then
		if m_bPkScene==true then
			pImgHead:loadTexture(GetGeneralHeadIcon(tabData["m_TempID"]))
			pImgColor:loadTexture(GetGeneralColorIcon(tabData["m_TempID"]))
		else
			pImgHead:loadTexture(GetMonsterIcon(tabData["m_TempID"]))
			pImgColor:loadTexture(GetMonsterColorIcon(tabData["m_TempID"]))
		end
		pLabelDamage= CreateStrokeLabel(18, "default", tostring(tabData["m_Damage"]), ccp(-30, 15), ccc3(106, 46, 19), ccc3(248, 145, 116), true, ccp(0, -2), 2)
		pTimerBar = CCProgressTimer:create(CCSprite:create("Image/imgres/dungeon/bar_red.png"))
		pTimerBar:setMidpoint(CCPointMake(1, 0))
	else
		pImgHead:loadTexture(GetGeneralHeadIcon(tabData["m_TempID"]))
		pImgColor:loadTexture(GetGeneralColorIcon(tabData["m_TempID"]))
		pLabelDamage= CreateStrokeLabel(18, "default", tostring(tabData["m_Damage"]), ccp(30, 15), ccc3(82, 107, 50), ccc3(210, 240, 91), true, ccp(0, -2), 2)
		pTimerBar = CCProgressTimer:create(CCSprite:create("Image/imgres/dungeon/bar_green.png"))
		pTimerBar:setMidpoint(CCPointMake(0, 0))
	end

	pTimerBar:setType(kCCProgressTimerTypeBar)
	pTimerBar:setBarChangeRate(CCPointMake(1, 0))
	pTimerBar:setPosition(ccp(0, 0))
	pImgBar:addNode(pTimerBar)
	pTimerBar:runAction(pToBar)

	pListItem:addChild(pLabelDamage)
end

local function GetDamageData( tabDamage, tabOwn, tabEnemy )
	for i,v in ipairs(tabDamage) do
		if v["m_PosID"]> 5 then
			table.insert(tabEnemy, v)
		else
			table.insert(tabOwn, v)
		end
		if v["m_Damage"] > m_nMaxDamage then
			m_nMaxDamage = v["m_Damage"]
		end
	end
end

local function UpdateDamageList( tabDamage )
	-- printTab(tabDamage)
	local tabOwn = {}
	local tabEnemy = {}

	m_pListDamage:removeAllItems()
	GetDamageData(tabDamage, tabOwn, tabEnemy)

	local nListCount = math.max(#tabOwn, #tabEnemy)
	local pListItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemFightData.json")
	for i=1, nListCount do
		local pDamageItem  = CreateDamageItemWidget(pListItemTemp)
		local pOwnItem = tolua.cast(pDamageItem:getChildByName("Image_Own"), "ImageView")
		local pEnemyItem = tolua.cast(pDamageItem:getChildByName("Image_Enemy"), "ImageView")

		if tabOwn[i]~=nil then
			UpdateDamageListItem( tabOwn[i], pOwnItem, false )
		else
			pOwnItem:setVisible(false)
		end

		if tabEnemy[i]~=nil then
			UpdateDamageListItem( tabEnemy[i], pEnemyItem, true )
		else
			pEnemyItem:setVisible(false)
		end
		m_pListDamage:pushBackCustomItem(pDamageItem)
	end
end

local function _Btn_Back_FightData_CallBack( sender, eventype )
	m_pLayerFightData:removeFromParentAndCleanup(true)
	InitVars()
end

local function InitWidgets(  )
	m_pLayerFightData = TouchGroup:create()
	m_pLayerFightData:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/FightDataLayer.json"))

	local pBtnClose = tolua.cast(m_pLayerFightData:getWidgetByName("Button_Close"),"Button")
	if pBtnClose==nil then
		print("pBtnClose is nil...")
		return false
	else
		CreateBtnCallBack(pBtnClose, nil, nil, _Btn_Back_FightData_CallBack)
	end

	m_pListDamage = tolua.cast(m_pLayerFightData:getWidgetByName("ListView_Damage"),"ListView")
	if m_pListDamage==nil then
		print("m_pListDamage is nil...")
		return false
	else
		m_pListDamage:setClippingType(1)
	end

	local pLabelOwn = tolua.cast(m_pLayerFightData:getWidgetByName("Label_Own"),"Label")
	if pLabelOwn==nil then
		print("pLabelOwn is nil...")
		return false
	else
		pLabelOwn:setFontName(CommonData.g_FONT1)
	end

	local pLabelEnemy = tolua.cast(m_pLayerFightData:getWidgetByName("Label_Enemy"),"Label")
	if pLabelEnemy==nil then
		print("pLabelEnemy is nil...")
		return false
	else
		pLabelEnemy:setFontName(CommonData.g_FONT1)
	end
	return true
end

function showFightData(bPkScene, pData)
	InitVars()
	if InitWidgets()==false then
		return
	end
	m_bPkScene = bPkScene
	UpdateDamageList(pData)
	return m_pLayerFightData
end