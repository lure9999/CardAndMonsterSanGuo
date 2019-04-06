require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralFateData"
require "Script/Main/Wujiang/GeneralFateLogic"
module("GeneralFateLayer", package.seeall)


local FIRST_STAR_FRAME_COUNT = 9
local OTHER_STAR_FRAME_COUNT = 20
local m_plyGeneralFate = nil
local m_btnRight = nil
local m_btnLeft = nil
local m_imgFateStars = {}
local m_imgBlueStars = {}
local m_imgStars = {}
local m_imgConItems = {}
local m_BtnFate = nil

local m_nFateId = 0
local m_nStars = 0
local m_nNeedLv = 0
local m_nLv = 0
local m_strName = nil
local m_nItemIconOffX = 0
local m_tabDefaultPosX = {}
local m_tabDefaultPosY = {}
local m_tabConItemsData	= {}

local function InitVars(  )
	m_plyGeneralFate = nil
	m_btnRight = nil
	m_btnLeft = nil
	m_imgFateStars = {}
	m_imgStars = {}
	m_imgConItems = {}
	m_BtnFate = nil

	m_nStars= 0
	m_nNeedLv = 0
	m_nLv = 0
	ge = nil
	m_nItemIconOffX = 0
	m_tabDefaultPosX = {}
	m_tabDefaultPosY = {}
	m_tabConItemsData = {}
	m_nFateId = 0
end

local GetConsumeTab 				= ConsumeLogic.GetConsumeTab
local GetConsumeItemData 			= ConsumeLogic.GetConsumeItemData--( nConsumeId,  nConsumeIdx, nConsumeType, nIncType, nIncIdx, nIncStep)
local GetConsumeParaAType 			= ConsumeLogic.GetConsumeParaAType
local SetConsumeItemsData			= ConsumeLogic.SetConsumeItemsData

local GetGeneralName				= GeneralBaseData.GetGeneralName
local GetSameTypeGeneralTab			= GeneralBaseData.GetSameTypeGeneralTab
local GetGeneralHeadIcon			= GeneralBaseData.GetGeneralHeadIcon
local GetGeneralColorIcon			= GeneralBaseData.GetGeneralColorIcon
local GetGeneralLv					= GeneralBaseData.GetGeneralLv
local GetGeneralStar 				= GeneralBaseData.GetGeneralStar

local GetGeneralTianMingId			= GeneralFateData.GetGeneralTianMingId
local GetTianMingNeedLv				= GeneralFateData.GetTianMingNeedLv
local GetTianMingConsumeId			= GeneralFateData.GetTianMingConsumeId
local GetMaxStars					= GeneralFateData.GetMaxStars
local GetAttrDes					= GeneralFateData.GetAttrDes

local CheckGeneralLv				= GeneralFateLogic.CheckGeneralLv
local CheckFateUpgrade				= GeneralFateLogic.CheckFateUpgrade

local SetCurGeneralIdx 				= GeneralBaseUILogic.SetCurGeneralIdx
local GetCurGeneralGrid				= GeneralBaseUILogic.GetCurGeneralGrid
local UpdateBtnsState				= GeneralBaseUILogic.UpdateBtnsState
local PlayGeneralAnimation			= GeneralBaseUILogic.PlayGeneralAnimation
local UpdateHeadIcon				= GeneralBaseUILogic.UpdateHeadIcon
local UpdateItemIcon 				= GeneralBaseUILogic.UpdateItemIcon

local CreateStrokeLabel 			= LabelLayer.createStrokeLabel

-- 创建属性Tip
local function CreatreAttrTextTip( pImgStar, nIdx )
	local pImgTip = ImageView:create()
	pImgTip:loadTexture("Image/imgres/wujiang/text_bg_small.png")
	pImgTip:setName("ImgTip")
	local plbText = Label:create()
	plbText:setFontSize(20)
	local strDes = GetAttrDes(m_nFateId, pImgStar:getTag())
	plbText:setText(strDes)
	pImgTip:addChild(plbText)
	local panelFate = tolua.cast(m_plyGeneralFate:getWidgetByName("Panel_Fate"), "Layout")
	pImgTip:setPosition(ccp(pImgStar:getPositionX() + pImgStar:getSize().width, pImgStar:getPositionY() + pImgStar:getSize().height/2))
	panelFate:addChild(pImgTip)
end

-- 删除属性Tip
local function RemoveTipText( )
	local panelFate = tolua.cast(m_plyGeneralFate:getWidgetByName("Panel_Fate"), "Layout")
	local pImgTip = panelFate:getChildByName("ImgTip")
	if pImgTip~=nil then
		panelFate:removeChild(pImgTip, true)
	end
end

-- 天命图标点击事件
local function _Img_FateStar_CallBack_(sender, eventType)
	if eventType==TouchEventType.began then
		CreatreAttrTextTip(sender)
	elseif eventType==TouchEventType.ended then
		RemoveTipText( )
	end
end

-- 更新消耗物品UI信息
local function UpdateConsumeItemData( tabConsumeItem, pImgItem, nCount )
	local tabConsumeItemData = GetConsumeItemData(tabConsumeItem.ConsumeID, tabConsumeItem.nIdx, tabConsumeItem.ConsumeType, tabConsumeItem.IncType)

	SetConsumeItemsData(m_tabConItemsData, tabConsumeItemData)

	UpdateItemIcon(pImgItem, tabConsumeItemData, GeneralFateData.MAX_CONSUME_TYPE, nCount, m_nItemIconOffX)

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	if tonumber(tabConsumeItemData.ConsumeType) == ConsumeType.Item then
		pGuideManager:RegisteGuide(pImgItem,tabConsumeItemData.ItemId,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	else
		pGuideManager:RegisteGuide(pImgItem,tabConsumeItemData.ConsumeType,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN)
	end
	pGuideManager = nil
	
end

-- 更新消耗物品
local function UpdateConsumeItems( nConsumeId )
	local tabConsume = GetConsumeTab(GeneralFateData.MAX_CONSUME_TYPE, nConsumeId)
	for i=1, GeneralFateData.MAX_CONSUME_TYPE do
		if i<=#tabConsume then
			m_imgConItems[i]:setVisible(true)
			UpdateConsumeItemData(tabConsume[i], m_imgConItems[i], #tabConsume)
		else
			m_imgConItems[i]:setVisible(false)
		end
	end
end

-- 更新等级标签
local function UpdateLbLv( nFateId, nIdx )
	local nNeedLv = GetTianMingNeedLv( nFateId, nIdx)
	local plbLv = tolua.cast(m_plyGeneralFate:getWidgetByName("Label_Lv_"..tostring(nIdx)), "Label")
	plbLv:setText("Lv."..tostring(nNeedLv))
	if CheckGeneralLv(nNeedLv, GetGeneralLv(GetCurGeneralGrid()) )==true then
		plbLv:setColor(COLOR_Green)
	else
		plbLv:setColor(COLOR_Red)
	end
end

-- 处理特效
local function HandleFateEffect( nIdx )
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/tianming.ExportJson")
    local PayArmature = CCArmature:create("tianming")
    PayArmature:getAnimation():playWithIndex(nIdx-1)
    if nIdx==1 then
    	 PayArmature:getAnimation():gotoAndPause(FIRST_STAR_FRAME_COUNT)
    else
    	 PayArmature:getAnimation():gotoAndPause(OTHER_STAR_FRAME_COUNT)
    end
    PayArmature:setPosition(ccp(0, 0))

    m_imgBlueStars[nIdx]:addNode(PayArmature, 0, nIdx)
end

-- 特效回调
local function _Effect_Fate_CallBack_( )
	HandleFateEffect(m_nStars)
end

-- 更新天命图片
local function UpdateFateStar( nIdx, nStars )
	if nIdx<=nStars then
		m_imgBlueStars[nIdx]:setTouchEnabled(true)
		m_imgStars[nIdx]:setVisible(true)
		HandleFateEffect(nIdx)
	else
		m_imgBlueStars[nIdx]:setTouchEnabled(true)
		m_imgStars[nIdx]:setVisible(false)
		m_imgBlueStars[nIdx]:removeAllNodes()
	end
end

-- 更新天命界面信息
function UpdateFateData( nGrid )
	m_tabConItemsData = {}
	UpdateHeadIcon(nGrid, m_plyGeneralFate)
	UpdateBtnsState(m_btnLeft, m_btnRight)

	m_nStars = GetGeneralStar(nGrid)
	local nGeneralId = server_generalDB.GetTempIdByGrid(nGrid)
	local nFateId = GetGeneralTianMingId(nGeneralId)
	m_nFateId = nFateId
	if m_nStars<GeneralFateData.MAX_STAR_COUNT then
		m_nNeedLv = GetTianMingNeedLv(nFateId, m_nStars+1)
		local nConsumeId = GetTianMingConsumeId(nFateId, m_nStars+1)
		UpdateConsumeItems(nConsumeId)
	else
		m_BtnFate:setTouchEnabled(false)
		m_BtnFate:setVisible(false)
		local pImgTop = tolua.cast(m_plyGeneralFate:getWidgetByName("Image_Top"), "ImageView")
		pImgTop:setVisible(true)
		local pImgImtes = tolua.cast(m_plyGeneralFate:getWidgetByName("Image_Items"), "ImageView")
		pImgImtes:setVisible(false)
	end

	if m_nStars < 1 then
		for i=1, GeneralFateData.MAX_STAR_COUNT do
			m_imgBlueStars[i]:removeAllNodes()
		end
	end

	for i=1, GeneralFateData.MAX_STAR_COUNT do
		UpdateFateStar(i, m_nStars)
		UpdateLbLv(nFateId, i)
	end
end

local function _Btn_Left_Fate_CallBack()
	SetCurGeneralIdx(-1)
	UpdateFateData(GetCurGeneralGrid())
	UpdateBtnsState(m_btnLeft, m_btnRight)
end


local function PlayUpgradeEffect( nStar )
	CommonInterface.GetAnimationByName( "Image/imgres/effectfile/tianming.ExportJson",
										"tianming","Animation"..tostring(nStar),	m_imgBlueStars[nStar], ccp(0, 0),
										_Effect_Fate_CallBack_, m_imgBlueStars[nStar]:getTag())
end

local function _Btn_Right_Fate_CallBack()
	SetCurGeneralIdx(1)
	UpdateFateData(GetCurGeneralGrid())
	UpdateBtnsState(m_btnLeft, m_btnRight)
end


-- 升星按钮回调
local function _Btn_Fate_CallBack()
	if CheckFateUpgrade(m_nNeedLv,  GetGeneralLv(GetCurGeneralGrid()), GetGeneralName(GetCurGeneralGrid()), m_tabConItemsData )==false then
		return false
	end

	local function TianMingOver()
		NetWorkLoadingLayer.loadingHideNow()
		-- 播放特效
		PlayUpgradeEffect(m_nStars+1)
		-- 刷新界面
		UpdateFateData(GetCurGeneralGrid())
		end
	Packet_TianMing.SetSuccessCallBack(TianMingOver)
	network.NetWorkEvent(Packet_TianMing.CreatPacket(GetCurGeneralGrid()))
	NetWorkLoadingLayer.loadingShow(true)
end

-- 初始化控件
local function InitWidgets(  )
	m_btnRight = tolua.cast(m_plyGeneralFate:getWidgetByName("Button_Right"), "Button")
	if m_btnRight==nil then
		print("m_btnRight is nil")
		return false
	else
		CreateBtnCallBack(m_btnRight, nil, nil, _Btn_Right_Fate_CallBack)
	end

	m_btnLeft = tolua.cast(m_plyGeneralFate:getWidgetByName("Button_Left"), "Button")
	if m_btnLeft==nil then
		print("m_btnLeft is nil")
		return false
	else
		CreateBtnCallBack(m_btnLeft, nil, nil, _Btn_Left_Fate_CallBack)
	end

	m_BtnFate = tolua.cast(m_plyGeneralFate:getWidgetByName("Button_Fate"), "Button")
	if m_BtnFate==nil then
		print("m_BtnFate is nil")
		return false
	else
		CreateBtnCallBack(m_BtnFate, "天命升星", 36, _Btn_Fate_CallBack)
	end

	for i=1, GeneralFateData.MAX_STAR_COUNT do
		m_imgStars[i] = tolua.cast(m_plyGeneralFate:getWidgetByName("Image_Star_"..tostring(i)), "ImageView")
		if m_imgStars[i]==nil then
			print(" m_imgstars_"..tostring(i).." is nil")
			return false
		end

		m_imgBlueStars[i] = tolua.cast(m_plyGeneralFate:getWidgetByName("Image_Fate_Blue_"..tostring(i)), "ImageView")
		if m_imgBlueStars[i]==nil then
			print(" m_imgBlueStars_"..tostring(i).." is nil")
			return false
		else
			m_imgBlueStars[i]:addTouchEventListener(_Img_FateStar_CallBack_)
			m_imgBlueStars[i]:setTag(i)
		end
	end

	for i=1, GeneralFateData.MAX_CONSUME_TYPE do
		m_imgConItems[i] = tolua.cast(m_plyGeneralFate:getWidgetByName("Image_ConsumeItem_"..tostring(i)), "ImageView")
		if m_imgConItems[i]==nil then
			print("m_imgConItems_"..tostring(i).." is nil")
			return false
		else
			table.insert(m_tabDefaultPosX, m_imgConItems[i]:getPositionX())
			table.insert(m_tabDefaultPosY, m_imgConItems[i]:getPositionY())
		end
	end

	m_nItemIconOffX = m_imgConItems[2]:getPositionX()-m_imgConItems[1]:getPositionX() - m_imgConItems[1]:getContentSize().width
	return true
end

-- 创建天命界面
function CreateGeneralFateLayer( nGrid )
	InitVars( )
	m_plyGeneralFate = TouchGroup:create()
	m_plyGeneralFate:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangFateLayer.json" ) )
	if InitWidgets()==false then
		return
	end

	UpdateFateData(nGrid)
	return m_plyGeneralFate
end