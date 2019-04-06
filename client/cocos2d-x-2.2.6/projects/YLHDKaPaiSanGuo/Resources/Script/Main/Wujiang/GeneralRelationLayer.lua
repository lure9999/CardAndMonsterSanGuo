require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralRelationData"
require "Script/Main/Wujiang/GeneralRelationLogic"


--缘分界面
module("GeneralRelationLayer", package.seeall)

local m_plyGeneralRelation = nil
local m_btnLeft = nil
local m_btnRight = nil
local m_plBaseInfo = nil
local m_lvRelation = nil
local m_plArmature = nil

local m_tabState = {}
local m_tabAniKey = {}
local m_nAinIdx = 1

local CreateStrokeLabel 			= LabelLayer.createStrokeLabel
local SetStrokeLabelText			= LabelLayer.setText
local SetStrokeLabelColor			= LabelLayer.setColor

local SetCurGeneralGrid 			= GeneralBaseData.SetCurGeneralGrid
local GetCurGeneralGrid				= GeneralBaseData.GetCurGeneralGrid
local GetAniKeyDef					= GeneralBaseData.GetAniKeyDef
local GetGenerHeadByGrid			= GeneralBaseData.GetGenerHeadByGrid
local GetTempIdByGrid				= server_generalDB.GetTempIdByGrid
local GetGeneralRelationIdTab		= GeneralRelationData.GetGeneralRelationIdTab

local GetRelationSolidTab			= server_generalDB.GetRelationSolidTab
local GetRelationItemTab			= GeneralRelationData.GetRelationItemTab

local CheckSolidState				= GeneralRelationLogic.CheckSolidState
local GetRelationData				= GeneralRelationLogic.GetRelationData
local GetStateText					= GeneralRelationLogic.GetStateText
local SortRelationStateTab			= GeneralRelationLogic.SortRelationStateTab

local SetCurGeneralIdx 				= GeneralBaseUILogic.SetCurGeneralIdx
local GetCurGeneralGrid				= GeneralBaseUILogic.GetCurGeneralGrid
local UpdateBtnsState				= GeneralBaseUILogic.UpdateBtnsState
local UpdateBaseInfo 				= GeneralBaseUILogic.UpdateBaseInfo
local PlayGeneralAnimation			= GeneralBaseUILogic.PlayGeneralAnimation


local COLOR_ACTIVTED_NAME 	= ccc3(239, 193, 55)
local COLOR_ACTIVTED_STATE 	= ccc3(0, 255, 79)
local COLOR_ACTIVTED_DESC 	= ccc3(219, 255, 255)
local COLOR_SOLIDIFIED 		= ccc3(20, 198, 227)

local function InitVars(  )
	m_plyGeneralRelation = nil
	m_tabAniKey = {}
	m_btnLeft = nil
	m_btnRight = nil
	m_plBaseInfo = nil
	m_lvRelation = nil
	m_plArmature = nil
	m_nAinIdx = 1
end

local function UpdateRelationConnt( tabState )
	local tabSortState = SortRelationStateTab(tabState)
	for i=1, GeneralRelationData.MAX_RELATION_COUNT do
		local  pImgSolid = m_plyGeneralRelation:getWidgetByName("Image_Solid_"..tostring(i))
		local  pImgActivite = m_plyGeneralRelation:getWidgetByName("Image_Activite_"..tostring(i))
		if i<=#tabSortState then
			if tabSortState[i]==GeneralRelationData.RelationState.Solidified then
				pImgSolid:setVisible(true)
				pImgActivite:setVisible(false)
			elseif tabSortState[i]==GeneralRelationData.RelationState.Solidifying then
				pImgSolid:setVisible(false)
				pImgActivite:setVisible(true)
			end
		else
			pImgSolid:setVisible(false)
			pImgActivite:setVisible(false)
		end
	end
end

local function UpdateRelationItemData( pImgItem, nState, tabItemData)
	--printTab(tabItemData)
	local pItemIcon = tolua.cast(pImgItem:getChildByName("Image_ItemIcon"), "ImageView")
	pItemIcon:loadTexture(tabItemData.ItemIcon)

	local pImgColor = tolua.cast(pImgItem:getChildByName("Image_Color"), "ImageView")
	pImgColor:loadTexture(tabItemData.ColorIcon)

	local pIconSprite = tolua.cast(pItemIcon:getVirtualRenderer(), "CCSprite")
	local pColorSprite = tolua.cast(pImgColor:getVirtualRenderer(), "CCSprite")
	if nState == GeneralRelationData.RelationState.NotActivted then
  		if tabItemData.ShangZhen==true then
			SpriteSetGray(pIconSprite,0)
  		 	SpriteSetGray(pColorSprite,0)
		else
			SpriteSetGray(pIconSprite,1)
  		 	SpriteSetGray(pColorSprite,1)
		end
	elseif nState == GeneralRelationData.RelationState.Solidifying then
		SpriteSetGray(pIconSprite,0)
  		SpriteSetGray(pColorSprite,0)
	elseif nState == GeneralRelationData.RelationState.Solidified then
		SpriteSetGray(pIconSprite,0)
  		SpriteSetGray(pColorSprite,0)
	end

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(pItemIcon,tabItemData.ItemId,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil

end

local function UpdateRelationWidget( pRelationItem, tabEachRelationData )
	local plbName =pRelationItem:getChildByName("lbName")
	if plbName~=nil then
		SetStrokeLabelText(plbName, tabEachRelationData.RelationName)
	end

	local plbDesc = tolua.cast(pRelationItem:getChildByName("Label_Desc"),"Label")
	if plbDesc~=nil then
		plbDesc:setText(tabEachRelationData.Desc)
	end

	local plbState = pRelationItem:getChildByName("lbState")
	if plbState~=nil then
		local strState = GetStateText(tabEachRelationData.State, tabEachRelationData.SolidValue, tabEachRelationData.MaxSolidValue)
		SetStrokeLabelText(plbState, strState)
	end

	if tabEachRelationData.State == GeneralRelationData.RelationState.NotActivted then
		SetStrokeLabelColor(plbName, COLOR_Gray)
		SetStrokeLabelColor(plbState, COLOR_Gray)
	elseif tabEachRelationData.State == GeneralRelationData.RelationState.Solidifying then
		SetStrokeLabelColor(plbName, COLOR_ACTIVTED_NAME)
		SetStrokeLabelColor(plbState, COLOR_ACTIVTED_STATE)
	elseif tabEachRelationData.State == GeneralRelationData.RelationState.Solidified then
		SetStrokeLabelColor(plbName, COLOR_ACTIVTED_NAME)
		SetStrokeLabelColor(plbState, COLOR_SOLIDIFIED)
	end

	for i=1, GeneralRelationData.MAX_RELATION_ITEM_COUNT do
		local pImgItem = tolua.cast(pRelationItem:getChildByName("Image_Item_"..tostring(i)), "ImageView")
		if i<=#tabEachRelationData.EachData then
			pImgItem:setVisible(true)
			UpdateRelationItemData(pImgItem, tabEachRelationData.State, tabEachRelationData.EachData[i])
		else
			pImgItem:setVisible(false)
		end
	end
end

local function CreateRelationWidget( pRelationItemTemp )
	local pRelationItem = pRelationItemTemp:clone()
    local peer = tolua.getpeer(pRelationItemTemp)
    tolua.setpeer(pRelationItem, peer)
    local plbName = CreateStrokeLabel(28, CommonData.g_FONT1, "护法猪猪", ccp(16, 148), COLOR_Black,  COLOR_White, false, ccp(0, -3), 3)
    plbName:setName("lbName")
    pRelationItem:addChild(plbName)

    local plbState = CreateStrokeLabel(22, CommonData.g_FONT1, "未激活", ccp(155, 148), COLOR_Black,  COLOR_White, false, ccp(0, -2), 2)
    plbState:setName("lbState")
    pRelationItem:addChild(plbState)
    return pRelationItem
end

function UpdateRelationData( nGrid )
	m_lvRelation:removeAllItems()
	m_tabAniKey = GetAniKeyDef(nGrid)
	local tabState = {}
	local tabRelationData = GetRelationData(nGrid)
	local pRelationItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/RelationItemLayer.json")
	for i=1, #tabRelationData do
		local pRelationItem = CreateRelationWidget(pRelationItemTemp)
		UpdateRelationWidget(pRelationItem, tabRelationData[i], nGrid)
		m_lvRelation:pushBackCustomItem(pRelationItem)
		if tabRelationData[i].State~=GeneralRelationData.RelationState.NotActivted then
			table.insert( tabState, tabRelationData[i].State )
		end
	end
	UpdateBaseInfo(nGrid, m_plyGeneralRelation)
	UpdateBtnsState(m_btnLeft, m_btnRight)
	UpdateRelationConnt(tabState)
	PlayGeneralAnimation(nGrid, m_plArmature, Ani_Def_Key.Ani_stand, 1/2, 1/5, 1.8)
end

local function _Btn_Lfet_Relation_CallBack( )
	SetCurGeneralIdx(-1)
	UpdateRelationData(GetCurGeneralGrid())
	UpdateBaseInfo(GetCurGeneralGrid(), m_plyGeneralRelation)
	SetCurGeneralGrid(GetCurGeneralGrid())
	UpdateBtnsState(m_btnLeft, m_btnRight)
end

local function _Btn_Right_Relation_CallBack( )
	SetCurGeneralIdx(1)
	UpdateRelationData(GetCurGeneralGrid())
	UpdateBaseInfo(GetCurGeneralGrid(), m_plyGeneralRelation)
	SetCurGeneralGrid(GetCurGeneralGrid())
	UpdateBtnsState(m_btnLeft, m_btnRight)
end

local function _Panel_Armatrue_CallBack_( sender, eventType )
	if eventType == TouchEventType.ended then
		m_nAinIdx = m_nAinIdx+1
		if m_nAinIdx>=#m_tabAniKey then
			m_nAinIdx=1
		end
		PlayGeneralAnimation(GetCurGeneralGrid(), m_plArmature, m_tabAniKey[m_nAinIdx], 1/2, 1/5, 1.8)
	end
end

local function InitWidgets(  )
	m_lvRelation = tolua.cast(m_plyGeneralRelation:getWidgetByName("ListView_Relation"),"ListView")
	if m_lvRelation==nil then
		print("m_lvRelation is nil")
		return false
	else
		m_lvRelation:setClippingType(1)
	end

	m_plBaseInfo = tolua.cast(m_plyGeneralRelation:getWidgetByName("Panel_BaseInfo"), "Layout")
	if m_plBaseInfo==nil then
		print("m_plBaseInfo is nil")
		return false
	else
		local lbName = tolua.cast(m_plyGeneralRelation:getWidgetByName("Label_Name"),"Label")
		if lbName~=nil then
			lbName:setFontName(CommonData.g_FONT1)
		end
		local plbDanYaoLv =  LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "凝神成丹", ccp(160, 380), ccc3(57, 25, 15), ccc3(250, 255, 118), true, ccp(0, -2), 2)
		plbDanYaoLv:setName("lbDanYaoLv")
		if plbDanYaoLv~=nil then
			m_plBaseInfo:addChild(plbDanYaoLv)
		end
	end

	m_plArmature = tolua.cast(m_plyGeneralRelation:getWidgetByName("Panel_Armature"), "Layout")
	if m_plArmature==nil then
		print("m_plArmature is nil")
		return false
	else
		m_plArmature:addTouchEventListener(_Panel_Armatrue_CallBack_)
	end

	m_btnLeft = tolua.cast(m_plyGeneralRelation:getWidgetByName("Button_Left"),"Button")
	if m_btnLeft==nil then
		print("m_btnLeft is nil")
		return false
	else
		CreateBtnCallBack(m_btnLeft, nil, nil, _Btn_Lfet_Relation_CallBack)
	end

	m_btnRight = tolua.cast(m_plyGeneralRelation:getWidgetByName("Button_Right"),"Button")
	if m_btnRight==nil then
		print("m_btnRight is nil")
		return false
	else
		CreateBtnCallBack(m_btnRight, nil, nil, _Btn_Right_Relation_CallBack)

	end
	return true
end

function CreateGeneralRelationLayer( nGrid )
	InitVars()
	m_plyGeneralRelation = TouchGroup:create()
	m_plyGeneralRelation:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangRelationLayer.json" ) )
	if InitWidgets()==false then
		return
	end

	UpdateRelationData(nGrid)

	return m_plyGeneralRelation
end