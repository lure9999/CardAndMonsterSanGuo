-- 武将丹药的UI层

require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralDanYaoData"
require "Script/Main/Wujiang/GeneralDanYaoLogic"

module("GeneralDanYaoLayer", package.seeall)

local MAX_JINDAN_LV = 10
-- 控件变量
local m_plyGeneralDanYao = nil
local m_btnLeft = nil
local m_btnRight = nil
local m_imgDanYao = {}
local m_lbJinDanAttr = {}
local m_lbDanYaoAttr = {}
local m_lbDanYao = nil
local m_lbDanYaoMax = nil
local m_btnJinJie = nil
local m_btnOneKey = nil
local m_imgDanYaoIcon = nil

-- 数据变量
local m_nDanYaoLv = nil
local m_nDanYaoIdx = nil
local m_tabDanYaoData = {}

-- 丹药数据接口
local GetGeneralId 			= server_generalDB.GetTempIdByGrid
local GetGeneralName		= GeneralBaseData.GetGeneralName
local GetGeneralLv			= GeneralBaseData.GetGeneralLv
local GetDanYaoLvText		= GeneralBaseData.GetDanYaoLvText
local GetDanYaoLv 			= GeneralBaseData.GetDanYaoLv
local GetGeneralHeadIcon 	= GeneralBaseData.GetGeneralHeadIcon
local GetGeneralColorIcon 	= GeneralBaseData.GetGeneralColorIcon
local GetDanYaoIcon 		= GeneralDanYaoData.GetDanYaoIcon
local GetDanYaoNeedLv		= GeneralDanYaoData.GetDanYaoNeedLv
local GetDanYaoConsumeId 	= GeneralDanYaoData.GetDanYaoConsumeId
local GetJinDanAttrId		= GeneralDanYaoData.GetJinDanAttrId
local GetJinDanIcon			= GeneralDanYaoData.GetJinDanIcon
local GetDanYaoAttrAllValue	= GeneralDanYaoData.GetDanYaoAttrAllValue
local GetJinDanAddValue		= GeneralDanYaoData.GetJinDanAddValue

local GetDanYaoAttrName		= GeneralDanYaoData.GetDanYaoAttrName
local GetDanYaoAttrValue	= GeneralDanYaoData.GetDanYaoAttrValue

-- 丹药逻辑接口
local CheckGeneralLv		= GeneralDanYaoLogic.CheckGeneralLv
local CheckDanYaoState		= GeneralDanYaoLogic.CheckDanYaoState
local SetEnoughLv			= GeneralDanYaoLogic.SetEnoughLv
local SetEnoughItem			= GeneralDanYaoLogic.SetEnoughItem
local SetPrevState			= GeneralDanYaoLogic.SetPrevState
local GetDanYaoItemData		= GeneralDanYaoLogic.GetDanYaoItemData
local _HeChengDanYao_CallBack_ 	= GeneralDanYaoLogic._HeChengDanYao_CallBack_
local _HeChengDanYao_CallBack_No_Tips	= GeneralDanYaoLogic._HeChengDanYao_CallBack_No_Tips

local SetCurGeneralIdx 		= GeneralBaseUILogic.SetCurGeneralIdx
local GetCurGeneralGrid		= GeneralBaseUILogic.GetCurGeneralGrid
local UpdateBtnsState		= GeneralBaseUILogic.UpdateBtnsState
local PlayGeneralAnimation	= GeneralBaseUILogic.PlayGeneralAnimation
local UpdateHeadIcon		= GeneralBaseUILogic.UpdateHeadIcon


local CreateStrokeLabel 	= LabelLayer.createStrokeLabel
local SetStrokeLabelText	= LabelLayer.setText

local GetConsumeItemColorIcon 	= ConsumeLogic.GetConsumeItemColorIcon
-- 初始化变量
local function InitVars(  )
-- 控件变量
	m_plyGeneralDanYao = nil
	m_btnLeft = nil
	m_btnRight = nil
	m_imgDanYao = {}
	m_lbJinDanAttr = {}
	m_lbDanYaoAttr = {}
	m_lbDanYao = nil
	m_lbDanYaoMax = nil
	m_btnJinJie = nil
	m_imgDanYaoIcon = nil

-- 数据变量
	m_nDanYaoLv = nil
	m_nDanYaoIdx = nil
	m_tabDanYaoData = {}
end

local function CreateTipText( pItemIcon, nAttrId )
	local pImgTip = ImageView:create()
	pImgTip:loadTexture("Image/imgres/wujiang/text_bg_small.png")
	pImgTip:setName("ImgTip")
	local strAttrName = GetDanYaoAttrName(nAttrId)
	local strAttrValue = GetDanYaoAttrValue(nAttrId)
	local plbText = Label:create()
	plbText:setFontSize(20)
	plbText:setText(strAttrName.."+"..strAttrValue)
	pImgTip:addChild(plbText)
	local panelDanYao = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Panel_DanYao"), "Layout")
	pImgTip:setPosition(ccp(pItemIcon:getPositionX() + pItemIcon:getSize().width, pItemIcon:getPositionY() + pItemIcon:getSize().height))
	panelDanYao:addChild(pImgTip)
end

local function RemoveTipText( )
	local panelDanYao = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Panel_DanYao"), "Layout")
	local pImgTip = panelDanYao:getChildByName("ImgTip")
	if pImgTip~=nil then
		panelDanYao:removeChild(pImgTip, true)
	end
end
local function _ImageActivited_DanYao_CallBack(sender, eventType)
	if eventType==TouchEventType.began then
		CreateTipText(sender, m_tabDanYaoData[sender:getTag()].AttrID)
	elseif eventType==TouchEventType.ended then
		RemoveTipText( )
	end
end
-- 丹药图标回调
local function _ImageNotActivite_DanYao_CallBack(sender, eventType)
	if eventType==TouchEventType.ended then
		require "Script/Main/Wujiang/GeneralDanYaoInfoLayer"
		--[[printTab(m_tabDanYaoData)
		print("sender:getTag() = "..sender:getTag())
		Pause()]]
		local lyInfo = GeneralDanYaoInfoLayer.CreateGeneralDanYaoInfoLayer(GetCurGeneralGrid(), m_tabDanYaoData[sender:getTag()])
		if lyInfo~=nil then
			m_plyGeneralDanYao:addChild(lyInfo, 1, 1)
		end
	end
end

local function UpdateTipText(  )
	local strLife 	= "生命+ "..GetJinDanAddValue(0, m_nDanYaoLv)
	local strAattck = "攻击+ "..GetJinDanAddValue(1, m_nDanYaoLv)
	local strWuFang = "物防+ "..GetJinDanAddValue(2, m_nDanYaoLv)
	local strFaFang = "法防+ "..GetJinDanAddValue(3, m_nDanYaoLv)
	local panelDanYao = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Panel_DanYao"), "Layout")

	--TipLayer.createPopTipLayer(strLife, 24, ccc3(0,255,79), ccp(panelDanYao:getPositionX() + panelDanYao:getSize().width/2, panelDanYao:getPositionY() + panelDanYao:getSize().height-130))
	--TipLayer.createPopTipLayer(strAattck, 24, ccc3(0,255,79), ccp(panelDanYao:getPositionX() + panelDanYao:getSize().width/2, panelDanYao:getPositionY() + panelDanYao:getSize().height-160))
	--TipLayer.createPopTipLayer(strWuFang, 24, ccc3(0,255,79), ccp(panelDanYao:getPositionX() + panelDanYao:getSize().width/2, panelDanYao:getPositionY() + panelDanYao:getSize().height-190))
	--TipLayer.createPopTipLayer(strFaFang, 24, ccc3(0,255,79), ccp(panelDanYao:getPositionX() + panelDanYao:getSize().width/2, panelDanYao:getPositionY() + panelDanYao:getSize().height-220))
end

-- 更新丹药增加的单个属性
local  function UpdateAddAttrByType( nAttrType, lbAttr, nAttrCount, bJinDan )
	local nAttrValue = GetDanYaoAttrAllValue( nAttrType, m_nDanYaoLv, bJinDan, m_nDanYaoIdx)
	if bJinDan then
		--金丹属性标签
		lbAttr:setText("+"..tostring(nAttrValue))
	else
		--丹药属性标签
		lbAttr:setText("("..tostring(nAttrValue)..")")
	end

end

-- 更新丹药增加属性
local function UpdateAddAttrs(  )
	-- printTab(tabAttrType)
	for k,v in pairs(GeneralDanYaoData.tabAttrType) do
		UpdateAddAttrByType(v, m_lbJinDanAttr[k], GeneralDanYaoData.MAX_JINDAN_ATTR_COUNT, true)
		UpdateAddAttrByType(v, m_lbDanYaoAttr[k], GeneralDanYaoData.MAX_JINDAN_ATTR_COUNT, false)
	end
end

-- 激活丹药特效回调
local function _ImgDanYao_CallBack(  )
	--[[print("--------------------------------")
	print(m_nDanYaoIdx)
	print("--------------------------------")]]
	if m_nDanYaoIdx > 0 then
		local pLayoutEffect = m_imgDanYao[m_nDanYaoIdx]:getChildByTag(m_imgDanYao[m_nDanYaoIdx]:getTag())
		if pLayoutEffect~=nil then
			m_imgDanYao[m_nDanYaoIdx]:removeChild(pLayoutEffect,  true)
		end
	end
end

-- 激活丹药特效
function PlayDanYaoEffect( nIndex )
	local pIndex = m_nDanYaoIdx
	if nIndex ~= nil then
		pIndex = nIndex
	end
	CommonInterface.GetAnimationByName( "Image/imgres/effectfile/danyaojj-texiao.ExportJson",
										"danyaojj-texiao","Animation3",	m_imgDanYao[pIndex], ccp(0, 0),
										_ImgDanYao_CallBack, m_imgDanYao[pIndex]:getTag())
end

-- 更新丹药图标信息
local function UpdateDanYaoWidgetItem( nIdx, nConsumeID)
	local nGeneralLv = GetGeneralLv(GetCurGeneralGrid())
	local tabDanYaoItem = GetDanYaoItemData( m_nDanYaoLv, m_nDanYaoIdx, nIdx,  nConsumeID ,nGeneralLv )
	if m_tabDanYaoData[nIdx] ~= nil then
		m_tabDanYaoData[nIdx] = tabDanYaoItem
	else
		table.insert(m_tabDanYaoData, tabDanYaoItem)
	end
	-- printTab(tabDanYaoItem)
	local strIconPath = GetDanYaoIcon(m_nDanYaoLv, nIdx)
	m_imgDanYao[nIdx]:setTag(nIdx)
	local pImgItemIcon = tolua.cast(m_imgDanYao[nIdx]:getChildByName("Image_ItemIcon"), "ImageView")
	local nNeedLv =  GetDanYaoNeedLv(m_nDanYaoLv, nIdx)
	local pLbNeedLv = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Label_Lv_"..tostring(nIdx)), "Label")
	pLbNeedLv:setText("Lv."..tostring(nNeedLv))

	local strColorIcon = GetConsumeItemColorIcon(tabDanYaoItem.DanYaoID)
	local pImgColor = tolua.cast(m_imgDanYao[nIdx]:getChildByName("Image_Color"), "ImageView")
	pImgColor:loadTexture(strColorIcon)

	if tabDanYaoItem.bEnoughLv == false then
		pLbNeedLv:setColor(COLOR_Red)
	else
		pLbNeedLv:setColor(COLOR_Green)
	end

	if tabDanYaoItem.State == GeneralDanYaoData.ActiviteState.Activited then
		strIconPath = GetDanYaoIcon(m_nDanYaoLv, nIdx)
		pImgItemIcon:setSize(CCSize(78,78))
		m_imgDanYao[nIdx]:addTouchEventListener(_ImageActivited_DanYao_CallBack)
	else
		if tabDanYaoItem.State == GeneralDanYaoData.ActiviteState.CanActivite then
			strIconPath = "Image/imgres/common/add.png"
			pImgItemIcon:setSize(CCSize(50,54))
		elseif tabDanYaoItem.State == GeneralDanYaoData.ActiviteState.NotActivite then
			strIconPath = "Image/imgres/button/btn_add_gray.png"
			pImgItemIcon:setSize(CCSize(50,50))
		end
		m_imgDanYao[nIdx]:addTouchEventListener(_ImageNotActivite_DanYao_CallBack)
	end
	pImgItemIcon:loadTexture(strIconPath)
end

-- 更新金丹进阶按钮特效状态
local function UpdateBtnJinJieEffect( )
	if m_nDanYaoIdx==GeneralDanYaoData.MAX_DANYAO_COUNT then
		CommonInterface.GetAnimationByName( "Image/imgres/effectfile/danyaojj-texiao.ExportJson",
											"danyaojj-texiao","Animation1",	m_btnJinJie, ccp(0, 0),
											nil, m_btnJinJie:getTag())
	else
		local pLayoutEffect = m_btnJinJie:getChildByTag(m_btnJinJie:getTag())
		if pLayoutEffect~=nil then
			m_btnJinJie:removeChild(pLayoutEffect,  true)
		end
	end
end

-- 金丹进阶特效回调
local function _ImgJinDan_Animation_CallBack(  )
	local pLayoutEffect = m_imgDanYaoIcon:getChildByTag(m_imgDanYaoIcon:getTag())
	if pLayoutEffect~=nil then
		m_imgDanYaoIcon:removeChild(pLayoutEffect,  true)
	end
end

-- 播放金丹进阶特效
local function PlayJinJieEffect(  )
		CommonInterface.GetAnimationByName( "Image/imgres/effectfile/danyaojj-texiao.ExportJson",
											"danyaojj-texiao","Animation2",	m_imgDanYaoIcon, ccp(0, 0),
											_ImgJinDan_Animation_CallBack, m_imgDanYaoIcon:getTag())
end

-- 更新丹药界面信息
function UpdateDanYaoData( nGrid )
	-- print("DanYaoGrid="..nGrid)
	m_tabDanYaoData = {}
	m_nDanYaoLv, m_nDanYaoIdx = GeneralDanYaoData.GetDanYaoServerData( nGrid )
	-- print("Lv = "..m_nDanYaoLv.."\t".."Idx = "..m_nDanYaoIdx)
	for i=1, GeneralDanYaoData.MAX_DANYAO_COUNT do
		local nConsumeID = GetDanYaoConsumeId( m_nDanYaoLv, i )
		if nConsumeID>0 then
			UpdateDanYaoWidgetItem(i, nConsumeID)
		end
	end

	local strIconPath = GetJinDanIcon(m_nDanYaoLv)
	local pJinDanIcon = tolua.cast(m_imgDanYaoIcon:getChildByName("Image_ItemIcon"), "ImageView")
	pJinDanIcon:loadTexture(strIconPath)

	local strDanYaoLv = GetDanYaoLvText(nGrid)
	SetStrokeLabelText(m_lbDanYao, strDanYaoLv)

	UpdateAddAttrs()

	UpdateBtnJinJieEffect()
	if m_nDanYaoLv>=MAX_JINDAN_LV then
		m_btnJinJie:setTouchEnabled(false)
		m_btnJinJie:setVisible(false)
		if m_nDanYaoIdx >= GeneralDanYaoData.MAX_DANYAO_COUNT then
			m_btnOneKey:setTouchEnabled(false)
			m_btnOneKey:setVisible(false)
			m_lbDanYaoMax:setVisible(true)
		else
			m_lbDanYaoMax:setVisible(false)
		end
	else
		m_lbDanYaoMax:setVisible(false)
	end 

	UpdateHeadIcon(nGrid, m_plyGeneralDanYao)
	UpdateBtnsState(m_btnLeft, m_btnRight)
end

-- 左箭头回调
local function _Btn_Left_DanYao_CallBack( )
	SetCurGeneralIdx(-1)
	UpdateHeadIcon(GetCurGeneralGrid(), m_plyGeneralDanYao)
	UpdateDanYaoData(GetCurGeneralGrid())
	UpdateBtnsState(m_btnLeft, m_btnRight)
end

-- 右箭头回调
local function _Btn_Right_DanYao_CallBack( )
	SetCurGeneralIdx(1)
	UpdateHeadIcon(GetCurGeneralGrid(), m_plyGeneralDanYao)
	UpdateDanYaoData(GetCurGeneralGrid())
	UpdateBtnsState(m_btnLeft, m_btnRight)
end

-- 金丹进阶按钮回调
local function _Btn_JinJie_DanYao_CallBack( )
	if m_nDanYaoIdx < GeneralDanYaoData.MAX_DANYAO_COUNT then
		local strText="主公，稍安勿躁，现在尚不可凝练此丹！"
		TipLayer.createOkTipLayer(strText, nil)
	else
		local function DanYaoOver()
			NetWorkLoadingLayer.loadingHideNow()
			UpdateDanYaoData(GetCurGeneralGrid())
			UpdateTipText()
			UpdateBtnJinJieEffect()
			PlayJinJieEffect()
		end
		Packet_DanYao.SetSuccessCallBack(DanYaoOver)
		network.NetWorkEvent(Packet_DanYao.CreatPacket(GetCurGeneralGrid(), 1, 0))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

-- 一键炼丹回调
local function _Btn_OneKey_DanYao_CallBack( )

	local pCurIndex = m_nDanYaoIdx

	if pCurIndex >= GeneralDanYaoData.MAX_DANYAO_COUNT then 
		local strText="丹药已经修炼满，请点击金丹进阶"
		TipLayer.createTimeLayer(strText, 2)	
		return	
	end

	if _HeChengDanYao_CallBack_No_Tips(GetCurGeneralGrid(), m_tabDanYaoData[pCurIndex + 1]) == false then
		--表示第一格无法炼丹，所以无法一键炼丹
		_HeChengDanYao_CallBack_(GetCurGeneralGrid(), m_tabDanYaoData[pCurIndex + 1])
		return
	end

	local function DanYaoOver()
		NetWorkLoadingLayer.loadingHideNow()

		m_tabDanYaoData = {}
		m_nDanYaoLv, m_nDanYaoIdx = GeneralDanYaoData.GetDanYaoServerData( GetCurGeneralGrid() )  --一键炼丹后的最终index

		for i=1, GeneralDanYaoData.MAX_DANYAO_COUNT do
			local nConsumeID = GetDanYaoConsumeId( m_nDanYaoLv, i )
			if nConsumeID>0 then
				local nGeneralLv = GetGeneralLv(GetCurGeneralGrid())
				local tabDanYaoItem = GetDanYaoItemData( m_nDanYaoLv, m_nDanYaoIdx, i,  nConsumeID ,nGeneralLv )
				table.insert(m_tabDanYaoData, tabDanYaoItem)
			end
		end

		--printTab(m_tabDanYaoData)
		--Pause()

		local function TouchMask(  )
			GeneralOptLayer.InsertMask()
		end

		local function TouchOpen(  )
			GeneralOptLayer.MaskDrop()
		end 

		local function DoPlay( )
			local nConsumeID = GetDanYaoConsumeId( m_nDanYaoLv, pCurIndex + 1 )
			if nConsumeID>0 then
				UpdateDanYaoWidgetItem(pCurIndex + 1, nConsumeID)
				--printTab(m_tabDanYaoData)
			end

			local strIconPath = GetJinDanIcon(m_nDanYaoLv)
			local pJinDanIcon = tolua.cast(m_imgDanYaoIcon:getChildByName("Image_ItemIcon"), "ImageView")
			pJinDanIcon:loadTexture(strIconPath)

			local strDanYaoLv = GetDanYaoLvText(GetCurGeneralGrid())
			SetStrokeLabelText(m_lbDanYao, strDanYaoLv)

			UpdateAddAttrs()

			if pCurIndex == m_nDanYaoIdx - 1 then

				UpdateBtnJinJieEffect()

			end

			if m_nDanYaoLv>=MAX_JINDAN_LV then
				m_btnJinJie:setTouchEnabled(false)
				m_btnJinJie:setVisible(false)

				if m_nDanYaoIdx >= GeneralDanYaoData.MAX_DANYAO_COUNT then
					m_btnOneKey:setTouchEnabled(false)
					m_btnOneKey:setVisible(false)
					m_lbDanYaoMax:setVisible(true)
				else
					m_lbDanYaoMax:setVisible(false)
				end

			else
				m_lbDanYaoMax:setVisible(false)
			end 

			UpdateHeadIcon(GetCurGeneralGrid(), m_plyGeneralDanYao)
			UpdateBtnsState(m_btnLeft, m_btnRight)

			PlayDanYaoEffect( pCurIndex + 1 )

			pCurIndex = pCurIndex + 1

		end

		local pArrAction = CCArray:create()
		pArrAction:addObject(CCCallFunc:create(TouchMask))
		for i=pCurIndex,m_nDanYaoIdx-1 do
			pArrAction:addObject(CCCallFunc:create(DoPlay))
			pArrAction:addObject(CCDelayTime:create(0.3))
		end
		pArrAction:addObject(CCCallFunc:create(TouchOpen))
		m_plyGeneralDanYao:runAction(CCSequence:create(pArrAction))

	end
	Packet_DanYao.SetSuccessCallBack(DanYaoOver)
	network.NetWorkEvent(Packet_DanYao.CreatPacket(GetCurGeneralGrid(), 0, 1))
	NetWorkLoadingLayer.loadingShow(true)

end


-- 初始化控件
local function InitWidgets(  )
	m_imgDanYaoIcon = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Image_JinDan"),"ImageView")
	if m_imgDanYaoIcon==nil then
		print("m_imgDanYaoIcon is nil")
		return false
	end

	for i=1, GeneralDanYaoData.MAX_DANYAO_COUNT do
		m_imgDanYao[i] = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Image_DanYao_"..tostring(i)), "ImageView")
		if m_imgDanYao==nil then
			print("m_imgDanYao_"..tostring(i).." is nil...")
			return false
		end
	end

	for i=1, #GeneralDanYaoData.tabAttrType do
		m_lbJinDanAttr[i] = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Label_num_"..tostring(i)), "Label")
		if m_lbJinDanAttr[i]==nil then
			print("m_lbJinDanAttr_"..tostring(i).." is nil...")
			return false
		end
	end

	for i=1, #GeneralDanYaoData.tabAttrType do
		m_lbDanYaoAttr[i] = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Label_num_dy_"..tostring(i)), "Label")
		if m_lbDanYaoAttr[i]==nil then
			print("m_lbDanYaoAttr_"..tostring(i).." is nil...")
			return false
		end
	end

	local pImgDanYao = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Image_JinDanLv"), "ImageView")
	if pImgDanYao==nil then
		print("pImgDanYao is nil")
		return false
	else
		m_lbDanYao = CreateStrokeLabel(20, CommonData.g_FONT1, "凝神成丹", ccp(0, 0), ccc3(57,25,15), ccc3(250,255,118), true, ccp(0, -2), 2)
		m_lbDanYaoMax = CreateStrokeLabel(20, CommonData.g_FONT1, "所有丹药已满级", ccp(0, -160), ccc3(57,25,15), ccc3(250,255,118), true, ccp(0, -2), 2)
		m_lbDanYaoMax:setVisible(false)
		pImgDanYao:addChild(m_lbDanYao)
		pImgDanYao:addChild(m_lbDanYaoMax)
	end

	m_btnRight = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Button_Right"), "Button")
	if m_btnRight==nil then
		print("m_btnRight is nil")
		return false
	else
		CreateBtnCallBack(m_btnRight, nil, nil, _Btn_Right_DanYao_CallBack)
	end

	m_btnLeft = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Button_Left"), "Button")
	if m_btnLeft==nil then
		print("m_btnLeft is nil")
		return false
	else
		CreateBtnCallBack(m_btnLeft, nil, nil, _Btn_Left_DanYao_CallBack)
	end

	m_btnJinJie = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Button_JinJie"), "Button")
	if m_btnJinJie==nil then
		print("m_btnJinJie is nil")
		return false
	else
		CreateBtnCallBack(m_btnJinJie, "金丹进阶", 36, _Btn_JinJie_DanYao_CallBack)
	end

	m_btnOneKey = tolua.cast(m_plyGeneralDanYao:getWidgetByName("Button_OneKey"), "Button")
	if m_btnOneKey==nil then
		print("m_btnOneKey is nil")
		return false
	else
		CreateBtnCallBack(m_btnOneKey, "一键炼丹", 36, _Btn_OneKey_DanYao_CallBack)
	end

	return true
end

-- 创建丹药界面
function CreateGeneralDanYaoLayer( nGrid )
	InitVars( )
	m_plyGeneralDanYao = TouchGroup:create()
	m_plyGeneralDanYao:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangDanYaoLayer.json" ) )
	if InitWidgets()==false then
		return
	end

	UpdateDanYaoData(nGrid)

	return m_plyGeneralDanYao
end