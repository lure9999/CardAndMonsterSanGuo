require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralListLogic"
module("GeneralBaseUILogic", package.seeall)

local m_tabGeneral = {}
local m_nGeneralGrid = 0
local m_nCurIdx = 0

local GetGeneralHeadIcon		= GeneralBaseData.GetGeneralHeadIcon
local GetGeneralColorIcon		= GeneralBaseData.GetGeneralColorIcon
local GetGeneralCountryIcon 	= GeneralBaseData.GetGeneralCountryIcon
local GetGeneralTypeIcon 		= GeneralBaseData.GetGeneralTypeIcon
local GetGeneralLv 				= GeneralBaseData.GetGeneralLv
local GetGeneralName 			= GeneralBaseData.GetGeneralName
local GetDanYaoLvText 			= GeneralBaseData.GetDanYaoLvText
local GetGeneralStar 			= GeneralBaseData.GetGeneralStar
local GegAnimationId			= GeneralBaseData.GegAnimationId
local GetAnimationData			= GeneralBaseData.GetAnimationData
local GetSameTypeGeneralTab		= GeneralBaseData.GetSameTypeGeneralTab
local GetItemType				= GeneralBaseData.GetItemType
local GetGeneralAttrData		= GeneralBaseData.GetGeneralAttrData
local GetGeneralGridListByTypeAndPos	= GeneralListLogic.GetGeneralGridListByTypeAndPos

local GetTempIdByGrid			= server_generalDB.GetTempIdByGrid
local GetGeneralPosByGrid		= GeneralBaseData.GetGeneralPosByGrid
local GetGeneralTypeByGrid		= GeneralBaseData.GetGeneralTypeByGrid
local GetGeneralType 			= GeneralBaseData.GetGeneralType
local GetItemIDByGeneralID		= GeneralBaseData.GetItemIDByGeneralID

local CreateStrokeLabel			= LabelLayer.createStrokeLabel

function InitGeneralOptData( nGrid, nPos,nClickType )
	m_tabGeneral= {}
	m_nCurIdx = 0
	local nType = GetGeneralTypeByGrid(nGrid)
	local tabGeneral = nil
	if tonumber(nClickType) == 0 then
		--从武将列表进入
	 	tabGeneral = GetGeneralGridListByTypeAndPos(nType, nPos)
	elseif tonumber(nClickType) == 1 then
		--从阵容进入
		local nWjGridTab = server_matrixDB.GetWJGridInMatrix()
		tabGeneral = GetGeneralGridListByTypeAndPos(nType, nPos , nWjGridTab)
	end
	for k, v in pairs(tabGeneral) do
		if nType==GetGeneralType(tonumber(v["GeneralId"]))then
			table.insert(m_tabGeneral, v)
		end
	end
	for k, v in pairs(m_tabGeneral) do
		if nGrid==v["Grid"] then
			m_nCurIdx = k
			m_nGeneralGrid = nGrid
		end
	end
end

function SetCurGeneralIdx( nInc )
	if m_nCurIdx>=1 and m_nCurIdx<=#m_tabGeneral then
		m_nCurIdx = m_nCurIdx + nInc
	end
end

function GetCurGeneralGrid(  )
	return m_tabGeneral[m_nCurIdx]["Grid"]
end

function PlayGeneralAnimationByGeneralId( nGeneralId, plArmature, strAniName, nRatioX, nRatioY, fScale )
	local nAniId = GegAnimationId(nGeneralId)
	if plArmature:getNodeByTag(plArmature:getTag()) ~= nil then
		plArmature:removeNodeByTag(plArmature:getTag())
	end
	local pAnimationfileName, pAnimationName =GetAnimationData(nAniId)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)
	local pArmature = CCArmature:create(pAnimationName)
	if pArmature~=nil then
		plArmature:addNode(pArmature, nGeneralId, plArmature:getTag())
	end
	pArmature:setPosition(ccp(plArmature:getSize().width*nRatioX, plArmature:getSize().height*nRatioY ))
	pArmature:getAnimation():play(GetAniName_Res_ID(nAniId, strAniName))

	if tonumber(nGeneralId) ~= 7004 and tonumber(nGeneralId) ~= 7005 and tonumber(nGeneralId) ~= 7006 and tonumber(nGeneralId) ~= 7002 and tonumber(nGeneralId) ~= 7001 then
		pArmature:setScaleX(fScale*pArmature:getScaleX())
		pArmature:setScaleY(fScale)	
	end

	local function onMovementEvent(armatureBack,movementType,movementID)
    	if movementType == 1 or movementType == 2 then
			pArmature:getAnimation():play(GetAniName_Res_ID(nAniId, Ani_Def_Key.Ani_stand))
    	end
    end
    pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
end

function PlayGeneralAnimation( nGrid, plArmature, strAniName, nRatioX, nRatioY, fScale )
	PlayGeneralAnimationByGeneralId(GetTempIdByGrid(nGrid), plArmature, strAniName, nRatioX, nRatioY, fScale)
end

function UpdateBaseInfo( nGrid, plBase )
	local pImgCountry = tolua.cast(plBase:getWidgetByName("Image_Country"),"ImageView")
	if pImgCountry~=nil then
		pImgCountry:loadTexture(GetGeneralCountryIcon(nGrid))
	end

	local plbLv = tolua.cast(plBase:getWidgetByName("Label_Lv"),"Label")
	if plbLv ~= nil then
		plbLv:setText("Lv."..tostring(GetGeneralLv(nGrid)))
	end

	local strAttr = GetGeneralTypeIcon(nGrid)
	local pImgType = tolua.cast(plBase:getWidgetByName("Image_Type"),"ImageView")
	if pImgType~=nil then
		pImgType:loadTexture(strAttr)
	end

	local plbName = tolua.cast(plBase:getWidgetByName("Label_Name"),"Label")
	if plbName~=nil then
		plbName:setText(GetGeneralName(nGrid))
	end

	local plbDanYaoLv = plBase:getWidgetByName("lbDanYaoLv")
	if plbDanYaoLv~= nil then
		LabelLayer.setText(plbDanYaoLv, GetDanYaoLvText(nGrid))
	end

	local nStars = GetGeneralStar(nGrid)
	for i=1, 6 do
		local imgStar = tolua.cast(plBase:getWidgetByName("Image_star_"..tostring(i)),"ImageView")
		if i<=nStars then
			imgStar:setVisible(true)
		else
			imgStar:setVisible(false)
		end
	end
end

function UpdateHeadIcon( nGrid, plOpt)

	local nGeneralId = GetTempIdByGrid(nGrid)

	local plbName = tolua.cast(plOpt:getWidgetByName("Label_Name"), "Label")
	if plbName~=nil then
		plbName:setText(GetGeneralName(nGrid))
	end

	local pImgHead = tolua.cast(plOpt:getWidgetByName("Image_Head"), "ImageView")
	pImgHead:loadTexture("Image/imgres/equip/icon/bottom.png")

    local ImgIcon = tolua.cast(pImgHead:getChildByName("Image_Icon"), "ImageView")
    ImgIcon:setPosition(ccp(3, 17))
    ImgIcon:loadTexture(GetGeneralHeadIcon(nGeneralId))
    ImgIcon:setZOrder(1)

    local ImgColor = tolua.cast(pImgHead:getChildByName("Image_PinZhi"), "ImageView")
    ImgColor:loadTexture(GetGeneralColorIcon(nGeneralId))
    ImgColor:setZOrder(0)

    local lbLv = tolua.cast(pImgHead:getChildByName("Label_Lv"), "Label")
    lbLv:setZOrder(2)
    lbLv:setText("Lv."..tostring(GetGeneralLv(nGrid)))

    local nItemID = GetItemIDByGeneralID(nGeneralId)

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(pImgHead,nItemID,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil

end

function UpdateItemIcon( pItemIcon, tabItemData, nMaxCount, nCount, nOffX)
	local pImgItemColor = tolua.cast(pItemIcon:getChildByName("Image_Color"), "ImageView")
	local pImgBg = tolua.cast(pItemIcon:getChildByName("Image_ItemIcon"), "ImageView")
	local plbNum = tolua.cast(pItemIcon:getChildByName("Label_ItemNum"), "Label")

	if tabItemData.Enough==true then
		plbNum:setColor(COLOR_Green)
	else
		plbNum:setColor(COLOR_Red)
	end

	if tabItemData.ParaAType == ConsumeLogic.ConsumeParaAType.ItemID then
		pImgBg:setVisible(false)
		pImgItemColor:loadTexture(tabItemData.ColorIcon)
		plbNum:setText(tostring(tabItemData.ItemNum).."/"..tostring(tabItemData.ItemNeedNum))
		if tabItemData.ItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIPFRAGMENT
			or tabItemData.ItemType==E_BAGITEM_TYPE.E_BAGITEM_TYPE_GENERALFRAGMENT then
			local SpriteItemIcon = tolua.cast(pItemIcon:getVirtualRenderer(), "CCSprite")
			SpriteItemIcon:setContentSize(CCSize(78,78))
			MakeMaskIcon(SpriteItemIcon,  tabItemData.IconPath, 0, 1, "Image/imgres/common/color/jianghun_mask_small.png")
		else
			pImgBg:setVisible(true)
			pImgBg:loadTexture("Image/imgres/common/bottom.png")
			local pImgItemIcon = ImageView:create()
			pImgItemIcon:loadTexture(tabItemData.IconPath)
			pImgItemIcon:setScale(0.8)
			pImgBg:addChild(pImgItemIcon)
		end
	else
		pImgBg:setVisible(true)
		pImgItemColor:loadTexture("Image/imgres/common/color/wj_pz1.png")
		plbNum:setText(tostring(tabItemData.ItemNeedNum))
		--celina add
		pImgBg:loadTexture("Image/imgres/common/bottom.png")
		--end add
		local pImgItemIcon = ImageView:create()
		pImgItemIcon:setScale(0.8)
		pImgItemIcon:loadTexture(tabItemData.IconPath)
		pImgBg:addChild(pImgItemIcon)
	end

	local nPosX = pItemIcon:getPositionX() + (nMaxCount-nCount)/2*(pItemIcon:getContentSize().width+nOffX)
	pItemIcon:setPosition(ccp(nPosX, pItemIcon:getPositionY()))
end

local function EnabledWidget( pWidget, bEnabled )
	if pWidget~=nil then
		pWidget:setVisible(bEnabled)
		pWidget:setTouchEnabled(bEnabled)
		-- pWidget:setEnabled(bEnabled)
	end
end

function UpdateBtnsState( btnLeft, btnRight )
	if #m_tabGeneral==1 or m_tabGeneral==nil then
		EnabledWidget(btnLeft, false)
		EnabledWidget(btnRight, false)
	else
		if m_nCurIdx==1 then
			EnabledWidget(btnLeft, false)
			EnabledWidget(btnRight, true)
		elseif m_nCurIdx==#m_tabGeneral then
			EnabledWidget(btnLeft, true)
			EnabledWidget(btnRight, false)
		else
			EnabledWidget(btnLeft, true)
			EnabledWidget(btnRight, true)
		end
	end
end

function HandleLayerEnabled( pShowLayer, pHideLayer1, pHideLayer2 )
	EnabledWidget(pShowLayer, true)
	EnabledWidget(pHideLayer1, false)
	EnabledWidget(pHideLayer2, false)
end

local function SetLabelVisible( pCheckBox, bVisible )
	pCheckBox:getChildByTag(1):setVisible(bVisible)
	pCheckBox:getChildByTag(2):setVisible(not bVisible)
end

function HandleCheckBoxFont( pSelCheckBox, pUnSelCheckBox1, pUnSelCheckBox2 )
	SetLabelVisible(pSelCheckBox, true)
	SetLabelVisible(pUnSelCheckBox1, false)
	SetLabelVisible(pUnSelCheckBox2, false)
end

function CreateCheckBoxLabel( pCheckBox, strText, nPosX, nPosY )
	local plbSel = CreateStrokeLabel(30, CommonData.g_FONT1, strText, ccp(nPosX, nPosY), COLOR_Black, COLOR_White, true, ccp(0, -3), 3)
	pCheckBox:addChild(plbSel, 0, 1)
	local plbUnsel = Label:create()
	plbUnsel:setColor(ccc3(199,139,86))
	plbUnsel:setPosition(ccp(nPosX, nPosY))
	plbUnsel:setFontSize(30)
	plbUnsel:setText(strText)
	pCheckBox:addChild(plbUnsel, 0, 2)
end