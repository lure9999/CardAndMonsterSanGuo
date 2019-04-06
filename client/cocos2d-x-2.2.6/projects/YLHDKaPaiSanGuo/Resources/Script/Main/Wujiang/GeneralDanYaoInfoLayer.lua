-- 武将丹药信息界面的UI层

require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralDanYaoData"
require "Script/Main/Wujiang/GeneralDanYaoLogic"
require "Script/Main/Wujiang/GeneralDanYaoLayer"

module("GeneralDanYaoInfoLayer", package.seeall)

-- 控件变量
local m_plyDanYaoInfo = nil
local m_lbDanYaoName = nil
local m_lbDanYaoState = nil
local m_imgConItem = {}
local m_btnLianDan = {}

-- 数据变量
local m_nGrid = nil
local m_nState = nil
local m_nItemIconOffX = 0
local m_tabDefaultPosX = {}
local m_tabDefaultPosY = {}
local m_tabDanYaoInfo = {}

-- 数据接口
local GetDanYaoName 			= GeneralDanYaoData.GetDanYaoName
local GetDanYaoIcon 			= GeneralDanYaoData.GetDanYaoIcon
local GetDanYaoAttrName			= GeneralDanYaoData.GetDanYaoAttrName
local GetDanYaoAttrValue		= GeneralDanYaoData.GetDanYaoAttrValue
local GetDanYaoDesc				= GeneralDanYaoData.GetDanYaoDesc

local GetConsumeTab 			= ConsumeLogic.GetConsumeTab

local GetConsumeItemData 		= ConsumeLogic.GetConsumeItemData--( nConsumeId,  nConsumeIdx, nConsumeType, nIncType, nIncIdx, nIncStep)
local GetConsumeParaAType 		= ConsumeLogic.GetConsumeParaAType
local GetConsumeItemColorIcon 	= ConsumeLogic.GetConsumeItemColorIcon

-- 逻辑接口
local _HeChengDanYao_CallBack_ 	= GeneralDanYaoLogic._HeChengDanYao_CallBack_
local GetDanYaoStateText		= GeneralDanYaoLogic.GetDanYaoStateText

local UpdateItemIcon 			= GeneralBaseUILogic.UpdateItemIcon
-- 初始化变量
local function InitVars()
-- 控件变量
	m_plyDanYaoInfo = nil
	m_lbDanYaoName = nil
	m_lbDanYaoState = nil
	m_imgConItem = {}
	m_btnLianDan = {}

-- 数据变量
	m_nGrid = nil
	m_nState = nil
	m_nItemIconOffX = 0
	m_tabDefaultPosX = {}
	m_tabDefaultPosY = {}
	m_tabDanYaoInfo = {}
end

-- 更新合成丹药消耗物品信息
local function UpdateConsumeItem( tabConsumeItem, pImgItem, nCount)

	local tabConsumeItemData = GetConsumeItemData(tabConsumeItem.ConsumeID, tabConsumeItem.nIdx, tabConsumeItem.ConsumeType, tabConsumeItem.IncType)

	UpdateItemIcon(pImgItem, tabConsumeItemData, GeneralDanYaoData.MAX_CONSUMETYPE_COUNT, nCount, m_nItemIconOffX)

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	if tonumber(tabConsumeItemData.ConsumeType) == ConsumeType.Item then
		pGuideManager:RegisteGuide(pImgItem,tabConsumeItemData.ItemId,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	else
		pGuideManager:RegisteGuide(pImgItem,tabConsumeItemData.ConsumeType,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN)
	end
	pGuideManager = nil
	
end

-- 关闭按钮回调
local function _Btn_Close_DanYaoInfo_CallBack( sender, eventType )
	m_plyDanYaoInfo:removeFromParentAndCleanup(true)
	InitVars()
end

-- 合成丹药回调
local function _Btn_HeCheng_DanYaoInfo_CallBack( sender, eventType )
	if (_HeChengDanYao_CallBack_(m_nGrid, m_tabDanYaoInfo))==false then
		return
	end

	local function DanYaoOver()
		NetWorkLoadingLayer.loadingHideNow()
		GeneralDanYaoLayer.UpdateDanYaoData(m_nGrid)
		m_plyDanYaoInfo:removeFromParentAndCleanup(true)
		GeneralDanYaoLayer.PlayDanYaoEffect()
		InitVars()
	end
	Packet_DanYao.SetSuccessCallBack(DanYaoOver)
	network.NetWorkEvent(Packet_DanYao.CreatPacket(m_nGrid, 0, 0))
	NetWorkLoadingLayer.loadingShow(true)
end

-- 更新丹药信息
local function UpdateDanYaoInfo( tabDanYaoInfo )
	m_tabDanYaoInfo = tabDanYaoInfo
	-- printTab(tabDanYaoInfo)
	local strIconPath = GetDanYaoIcon(m_tabDanYaoInfo.DanYaoLv, m_tabDanYaoInfo.Index)
	local pImgDanYao = tolua.cast(m_plyDanYaoInfo:getWidgetByName("Image_DanYaoItem"), "ImageView")
	local pImgDanYaoIcon = tolua.cast(pImgDanYao:getChildByName("Image_ItemIcon"), "ImageView")
	if pImgDanYaoIcon~=nil then
		pImgDanYaoIcon:loadTexture(strIconPath)
	end
	local strColorIcon = GetConsumeItemColorIcon(tabDanYaoInfo.DanYaoID)
	local pImgColor = tolua.cast(pImgDanYao:getChildByName("Image_Color"), "ImageView")
	pImgColor:loadTexture(strColorIcon)

	local tabConsume = GetConsumeTab(GeneralDanYaoData.MAX_CONSUMETYPE_COUNT, m_tabDanYaoInfo.ConsumeID)
	for i=1, GeneralDanYaoData.MAX_CONSUMETYPE_COUNT do
		if i<=#tabConsume then
			m_imgConItem[i]:setVisible(true)
			m_imgConItem[i]:setPosition(ccp(m_tabDefaultPosX[i], m_tabDefaultPosY[i]))
			UpdateConsumeItem(tabConsume[i],  m_imgConItem[i], #tabConsume)
		else
			m_imgConItem[i]:setVisible(false)
		end
	end

	local strDanYaoName = GetDanYaoName(m_tabDanYaoInfo.DanYaoID)
	LabelLayer.setText(m_lbDanYaoName, strDanYaoName)


	local strState = GetDanYaoStateText(m_tabDanYaoInfo.State)
	LabelLayer.setText(m_lbDanYaoState, strState)

	if m_tabDanYaoInfo.State~=GeneralDanYaoData.ActiviteState.NotActivite then
		LabelLayer.setColor(m_lbDanYaoName, COLOR_White)
		LabelLayer.setColor(m_lbDanYaoState, COLOR_Green)
	else
		LabelLayer.setColor(m_lbDanYaoName, COLOR_Gray)
		LabelLayer.setColor(m_lbDanYaoState, COLOR_Gray)
	end

	local strAttrName = GetDanYaoAttrName(m_tabDanYaoInfo.AttrID)
	local strAttrValue = GetDanYaoAttrValue(m_tabDanYaoInfo.AttrID)

	local plbAttr = tolua.cast(m_plyDanYaoInfo:getWidgetByName("Label_Attr"), "Label")
	if plbAttr~=nil then
		plbAttr:setText(strAttrName.."：+"..strAttrValue)
	end

	m_btnLianDan:setTag(tabDanYaoInfo.Index)
end

-- 初始化相关控件
local function InitWidgets(  )
	local pBtnClose = tolua.cast(m_plyDanYaoInfo:getWidgetByName("Button_Close"), "Button")
	if pBtnClose==nil then
		print("pBtnClose is nil")
		return false
	else
		pBtnClose:addTouchEventListener(_Btn_Close_DanYaoInfo_CallBack)
		CreateBtnCallBack(pBtnClose, nil, nil, _Btn_Close_DanYaoInfo_CallBack)
	end

	m_btnLianDan = tolua.cast(m_plyDanYaoInfo:getWidgetByName("Button_LianDan"), "Button")
	if m_btnLianDan==nil then
		print("m_btnLianDan is nil")
		return false
	else
		CreateBtnCallBack(m_btnLianDan, "合成丹药", 36, _Btn_HeCheng_DanYaoInfo_CallBack)
	end


	local pImgBg = tolua.cast(m_plyDanYaoInfo:getWidgetByName("Image_Bg"), "ImageView")
	if pImgBg==nil then
		print("pImgBg is nil")
		return false
	else
		m_lbDanYaoName = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "黄芽丹一品", ccp(-40, 137), COLOR_Black, ccc3(175,175,175), false, ccp(0, -3), 3)
		pImgBg:addChild(m_lbDanYaoName)

		m_lbDanYaoState = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "测试", ccp(92, 137), COLOR_Black, ccc3(175,175,175), false, ccp(0, -3), 3)
		pImgBg:addChild(m_lbDanYaoState)
	end

	for i=1, GeneralDanYaoData.MAX_CONSUMETYPE_COUNT do
		m_imgConItem[i] = tolua.cast(m_plyDanYaoInfo:getWidgetByName("Image_ConsumeItem_"..tostring(i)), "ImageView")
		if m_imgConItem[i]== nil then
			print("m_imgConItem_"..tostring(i).." is nil")
			return false
		else
			table.insert(m_tabDefaultPosX, m_imgConItem[i]:getPositionX())
			table.insert(m_tabDefaultPosY, m_imgConItem[i]:getPositionY())
		end
	end

	m_nItemIconOffX = m_imgConItem[2]:getPositionX()-m_imgConItem[1]:getPositionX() - m_imgConItem[1]:getContentSize().width
	return true
end

-- 创建丹药信息界面
function CreateGeneralDanYaoInfoLayer( nGrid, tabDanYaoInfo )
	InitVars()
	m_plyDanYaoInfo = TouchGroup:create()
	m_plyDanYaoInfo:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangDanYaoInfoLayer.json" ) )

	if InitWidgets()==false then
		return
	end
	m_nGrid = nGrid
	UpdateDanYaoInfo( tabDanYaoInfo )
	return m_plyDanYaoInfo
end