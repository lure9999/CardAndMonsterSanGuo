require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralBaseUILogic"

module("GeneralAttrLayer", package.seeall)

local m_plyGeneralAttr = nil
local m_btnLeft = nil
local m_btnRight = nil

local m_lbTalentName = nil
local m_lbBlog = nil
local m_imgTalentBg = nil
local m_poly = nil
local m_plBaseInfo = nil
local m_plAttr = nil
local m_lbSkillType = nil
local m_plArmature = nil
local m_ProgExpBg = nil

local m_nAinIdx = 1
local m_tabAniKey = {}
local CreateStrokeLabel 			= LabelLayer.createStrokeLabel
local SetStrokeLabelText			= LabelLayer.setText

local GetGeneralName				= GeneralBaseData.GetGeneralName
local GetGeneralAttrType			= GeneralBaseData.GetGeneralAttrType
local GetGeneralAttrData 			= GeneralBaseData.GetGeneralAttrData
local GetAttrPosition				= GeneralBaseData.GetAttrPosition
local GetSkillData 					= GeneralBaseData.GetSkillData
local GetTalentId					= GeneralBaseData.GetTalentId
local GetTalentName					= GeneralBaseData.GetTalentName
local GetTalentData					= GeneralBaseData.GetTalentData
local GetBlogData					= GeneralBaseData.GetBlogData
local GetAniKeyDef					= GeneralBaseData.GetAniKeyDef
local GetGeneralTypeByGrid			= GeneralBaseData.GetGeneralTypeByGrid

local SetCurGeneralIdx 				= GeneralBaseUILogic.SetCurGeneralIdx
local GetCurGeneralGrid				= GeneralBaseUILogic.GetCurGeneralGrid
local UpdateBtnsState				= GeneralBaseUILogic.UpdateBtnsState

local UpdateBaseInfo 				= GeneralBaseUILogic.UpdateBaseInfo
local PlayGeneralAnimation			= GeneralBaseUILogic.PlayGeneralAnimation

local GetTempIdByGrid				= server_generalDB.GetTempIdByGrid
local function InitVars()
	m_plyGeneralAttr = nil
	m_btnLeft = nil
	m_btnRight = nil

	m_plAttr = nil
	m_lbSkillType = nil
	m_lbTalentName = nil
	m_lbBlog = nil
	m_imgTalentBg = nil
	m_poly = nil
	m_plBaseInfo = nil
	m_plArmature = nil
	m_ProgExpBg = nil
	m_nAinIdx = 1
	m_tabAniKey = {}
end

local function UpdateBaseAttr( nGrid )
	local tabAttrData =	GetGeneralAttrData(nGrid)
	-- 资质
	local plbZiZhi = m_plAttr:getChildByName("lbZiZhi")
	SetStrokeLabelText(plbZiZhi, "资质："..tostring(tabAttrData.ZiZhi))

	-- 统帅
	local plbTongShuai = m_plAttr:getChildByName("lbTongShuai")
	SetStrokeLabelText(plbTongShuai, "统御："..tostring(tabAttrData.TiLi))

	-- 武力
	local plbWuLi = m_plAttr:getChildByName("lbWuLi")
	SetStrokeLabelText(plbWuLi, "武力："..tostring(tabAttrData.WuLi))

	-- 智力
	local plbZhiLi = m_plAttr:getChildByName("lbZhiLi")
	SetStrokeLabelText(plbZhiLi, "智力："..tostring(tabAttrData.ZhiLi))

	-- 穿透
	local plbChuanTou = m_plAttr:getChildByName("lbChuanTou")
	SetStrokeLabelText(plbChuanTou, "穿透："..tostring(tabAttrData.ChuanTou))

	-- 法防
	local plbFaFang = m_plAttr:getChildByName("lbFaFang")
	SetStrokeLabelText(plbFaFang, "法防："..tostring(tabAttrData.FaFang))

	-- 生命
	local plbShengMing = m_plAttr:getChildByName("lbShengMing")
	SetStrokeLabelText(plbShengMing, "生命："..tostring(tabAttrData.ShengMing))

	-- 闪避
	local plbShanBi = m_plAttr:getChildByName("lbShanBi")
	SetStrokeLabelText(plbShanBi, "闪避："..tostring(tabAttrData.ShanBi))


	-- 攻击
	local plbGongJi = m_plAttr:getChildByName("lbGongJi")
	SetStrokeLabelText(plbGongJi, "攻击："..tostring(tabAttrData.GongJi))

	-- 识破
	local plbShiPo = m_plAttr:getChildByName("lbShiPo")
	SetStrokeLabelText(plbShiPo,  "识破："..(tabAttrData.ShiPo))

	-- 暴击
	local plbBaoJi = m_plAttr:getChildByName("lbBaoJi")
	SetStrokeLabelText(plbBaoJi, "暴击："..tostring(tabAttrData.BaoJi))

	-- 免伤
	local plbMianShang = m_plAttr:getChildByName("lbMianShang")
	SetStrokeLabelText(plbMianShang, "免伤："..tostring(tabAttrData.MianShang))

	-- 物防
	local plbWuFang = m_plAttr:getChildByName("lbWuFang")
	SetStrokeLabelText(plbWuFang, "物防："..tostring(tabAttrData.WuFang))
end

local function UpdateSkillData( nGrid )
	local nGeneralId = GetTempIdByGrid(nGrid)
	local tabSkillData = GetSkillData(nGeneralId)

	local nType =  GetGeneralAttrType(nGeneralId)
	if nType==GeneralBaseData.AttrType.WuLi  then
		SetStrokeLabelText(m_lbSkillType, "技  能（物理）")
	else
		SetStrokeLabelText(m_lbSkillType, "技  能（法术）")
	end

	local plbNorName = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_NorName"), "Label")
	if plbNorName~=nil then
		plbNorName:setText(tabSkillData.NormalSkill.Name)
	end

	local plbNorDesc = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_NorDesc"), "Label")
	if plbNorDesc~=nil then
		plbNorDesc:setText(tabSkillData.NormalSkill.Desc)
	end

	local plbEngName = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_EngName"), "Label")
	if plbEngName~=nil then
		plbEngName:setText(tabSkillData.EngineSkill.Name)
	end

	local plbEngDesc = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_EngDesc"), "Label")
	if plbEngDesc~=nil then
		plbEngDesc:setText(tabSkillData.EngineSkill.Desc)
	end

	local plbAutoName = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_AutoName"), "Label")
	if plbAutoName~=nil then
		plbAutoName:setText(tabSkillData.AutoSkill.Name)
	end

	local plbAutoDesc = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_AutoDesc"), "Label")
	if plbAutoDesc~=nil then
		plbAutoDesc:setText(tabSkillData.AutoSkill.Desc)
	end
end

local function UpdateTalentData( nGrid )
	local plTalent =  tolua.cast(m_plyGeneralAttr:getWidgetByName("Panel_Talent"),"Layout")
	if m_poly~=nil then
		plTalent:removeNode(m_poly)
	end

	local nGeneralId = GetTempIdByGrid(nGrid)
	local nTalentId = GetTalentId(nGeneralId)
	local strTalentName = GetTalentName(nTalentId)

	LabelLayer.setText(m_lbTalentName, "天  赋（"..strTalentName.."）")

	local tabTalent = GetTalentData(nTalentId)

	local nBasePosX = m_imgTalentBg:getPositionX()
	local nBasePosY = m_imgTalentBg:getPositionY()
	local nUnitLen = math.floor(m_imgTalentBg:getSize().height/2) - 10

	local nMaxAttr = math.max(unpack(tabTalent))

	local nRatio = tabTalent[GeneralBaseData.TalentIdx.duoshan]/nMaxAttr
	local nShanBiPosX, nShanBiPosY = GetAttrPosition(0, nRatio, nUnitLen, nBasePosX, nBasePosY)

	nRatio = tabTalent[GeneralBaseData.TalentIdx.fafang]/nMaxAttr
	local nFaFangPosX, nFaFangPosY = GetAttrPosition(45, nRatio, nUnitLen, nBasePosX, nBasePosY)

	nRatio = tabTalent[GeneralBaseData.TalentIdx.wufang]/nMaxAttr
	local nWuFangPosX, nWuFangPosY = GetAttrPosition(90, nRatio, nUnitLen, nBasePosX, nBasePosY)

	nRatio = tabTalent[GeneralBaseData.TalentIdx.attack]/nMaxAttr
	local nGongJiPosX, nGongJiPosY = GetAttrPosition(135, nRatio, nUnitLen, nBasePosX, nBasePosY)

	nRatio = tabTalent[GeneralBaseData.TalentIdx.hp]/nMaxAttr
	local nHpPosX, nHpPosY = GetAttrPosition(180, nRatio, nUnitLen, nBasePosX, nBasePosY)

	nRatio = tabTalent[GeneralBaseData.TalentIdx.mingzhong]/nMaxAttr
	local nMingZhongPosX, nMingZhongPosY = GetAttrPosition(225, nRatio, nUnitLen, nBasePosX, nBasePosY)

	nRatio = tabTalent[GeneralBaseData.TalentIdx.crit]/nMaxAttr
	local nBaoJiPosX, nBaoJiPosY = GetAttrPosition(270,  nRatio, nUnitLen, nBasePosX, nBasePosY)

	nRatio = tabTalent[GeneralBaseData.TalentIdx.shipo]/nMaxAttr
	local nShiPoPosX, nShiPoPosY = GetAttrPosition(315, nRatio, nUnitLen, nBasePosX, nBasePosY)

	m_poly = AddPoly(ccp(nShanBiPosX,nShanBiPosY), ccp(nFaFangPosX, nFaFangPosY),
			 			ccp(nWuFangPosX,nWuFangPosY), ccp(nGongJiPosX,nGongJiPosY),
			 			ccp(nHpPosX,nHpPosY), ccp(nMingZhongPosX,nMingZhongPosY),
			 			ccp(nBaoJiPosX,nBaoJiPosY), ccp(nShiPoPosX,nShiPoPosY),
			 			ccc3(63, 168, 187), ccc3(41, 95, 89), 0.62)

	if m_poly~=nil then
		if plTalent~=nil then
			plTalent:addNode(m_poly)
		end
	end
end

local function UpdateBolgData( nGrid )
	local nTmpId = GetTempIdByGrid(nGrid)
	local strName= GetGeneralName(nGrid)
	LabelLayer.setText(m_lbBlog, "列  传（"..strName.."）")

	local strDes = GetBlogData(nTmpId)
	local lbDes = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_Blog"), "Label")
	lbDes:setText(strDes)
end

function UpdataAttrData( nGrid )
	m_tabAniKey = GetAniKeyDef(nGrid)
	UpdateBaseInfo(nGrid, m_plyGeneralAttr)
	UpdateBtnsState(m_btnLeft, m_btnRight)
	UpdateBaseAttr(nGrid)
	UpdateSkillData(nGrid)
	UpdateTalentData(nGrid)
	UpdateBolgData(nGrid)
	PlayGeneralAnimation(nGrid, m_plArmature, Ani_Def_Key.Ani_stand, 1/2, 1/5, 1.8)
end

local function _Btn_Lfet_Attr_CallBack( )
	SetCurGeneralIdx(-1)
	UpdataAttrData(GetCurGeneralGrid())
	UpdateBaseInfo(GetCurGeneralGrid(), m_plyGeneralAttr)
	UpdateBtnsState(m_btnLeft, m_btnRight)
end

local function _Btn_Right_Attr_CallBack( )
	SetCurGeneralIdx(1)
	UpdataAttrData(GetCurGeneralGrid())
	UpdateBaseInfo(GetCurGeneralGrid(), m_plyGeneralAttr)
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

local function InitProg(  )
	if m_ProgExpBg == nil then
		return
	end
	local nType = GetGeneralTypeByGrid(GetCurGeneralGrid())
	--print("------------pType() = "..pType)
	if nType==GeneralType.HuFa then
		m_ProgExpBg:setVisible(true)
		local pExpGrog  = tolua.cast(m_ProgExpBg:getChildByName("ProgressBar_Exp"), "LoadingBar")
		local pExpLabel = tolua.cast(m_ProgExpBg:getChildByName("Label_Exp"), "Label")
	end
end

local function InitWidgets()

	m_plBaseInfo = tolua.cast(m_plyGeneralAttr:getWidgetByName("Panel_BaseInfo"), "Layout")
	if m_plBaseInfo==nil then
		print("m_plBaseInfo is nil")
		return false
	else
		local lbName = tolua.cast(m_plyGeneralAttr:getWidgetByName("Label_Name"),"Label")
		if lbName~=nil then
			lbName:setFontName(CommonData.g_FONT1)
		end
		local plbDanYaoLv =  CreateStrokeLabel(20, CommonData.g_FONT1, "凝神成丹", ccp(160, 380), ccc3(57, 25, 15), ccc3(250, 255, 118), true, ccp(0, -2), 2)
		plbDanYaoLv:setName("lbDanYaoLv")
		if plbDanYaoLv~=nil then
			m_plBaseInfo:addChild(plbDanYaoLv)
		end
	end

	m_plArmature = tolua.cast(m_plyGeneralAttr:getWidgetByName("Panel_Armature"), "Layout")
	if m_plArmature==nil then
		print("m_plArmature is nil")
		return false
	else
		m_plArmature:addTouchEventListener(_Panel_Armatrue_CallBack_)
	end

	m_btnLeft = tolua.cast(m_plyGeneralAttr:getWidgetByName("Button_Left"),"Button")
	if m_btnLeft==nil then
		print("m_btnLeft is nil")
		return false
	else
		CreateBtnCallBack(m_btnLeft, nil, nil, _Btn_Lfet_Attr_CallBack)
	end

	m_btnRight = tolua.cast(m_plyGeneralAttr:getWidgetByName("Button_Right"),"Button")
	if m_btnRight==nil then
		print("m_btnRight is nil")
		return false
	else
		CreateBtnCallBack(m_btnRight, nil, nil, _Btn_Right_Attr_CallBack)
	end

	m_ProgExpBg = tolua.cast(m_plyGeneralAttr:getWidgetByName("Image_Prog"),"ImageView")
	if m_ProgExpBg==nil then
		print("m_ProgExpBg is nil")
		return false
	else
		InitProg()
	end

	 m_plAttr =  tolua.cast(m_plyGeneralAttr:getWidgetByName("Panel_BaseAttr"),"Layout")
	if m_plAttr==nil then
		print("m_plAttr is nil")
		return false
	else
		local plbZiZhi = CreateStrokeLabel(26, CommonData.g_FONT1, "资质：13", ccp(60, 283), ccc3(31, 17, 11), ccc3(255, 250, 125), false, ccp(0, -2), 2)
		plbZiZhi:setName("lbZiZhi")
		m_plAttr:addChild(plbZiZhi)

		local plbTongShuai = CreateStrokeLabel(20, CommonData.g_FONT1, "统御：123456", ccp(60, 245), COLOR_Black, COLOR_White, false, ccp(0, -2), 1)
		plbTongShuai:setName("lbTongShuai")
		m_plAttr:addChild(plbTongShuai)

		local plbWuLi = CreateStrokeLabel(20, CommonData.g_FONT1, "武力：123456", ccp(220, 245), COLOR_Black, COLOR_White, false, ccp(0, -2), 1)
		plbWuLi:setName("lbWuLi")
		m_plAttr:addChild(plbWuLi)

		local plbZhiLi = CreateStrokeLabel(20, CommonData.g_FONT1, "智力：123456", ccp(60, 205), COLOR_Black, COLOR_White, false, ccp(0, -2), 1)
		plbZhiLi:setName("lbZhiLi")
		m_plAttr:addChild(plbZhiLi)

		local plbChuanTou = CreateStrokeLabel(20, CommonData.g_FONT1, "穿透：123456", ccp(60, 170), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbChuanTou:setName("lbChuanTou")
		m_plAttr:addChild(plbChuanTou)

		local plbFaFang = CreateStrokeLabel(20, CommonData.g_FONT1, "法防：123456", ccp(220, 170), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbFaFang:setName("lbFaFang")
		m_plAttr:addChild(plbFaFang)

		local plbShengMing = CreateStrokeLabel(20, CommonData.g_FONT1, "生命：123456", ccp(60, 132), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbShengMing:setName("lbShengMing")
		m_plAttr:addChild(plbShengMing)

		local plbShanBi = CreateStrokeLabel(20, CommonData.g_FONT1, "闪避：123456", ccp(220, 132), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbShanBi:setName("lbShanBi")
		m_plAttr:addChild(plbShanBi)

		local plbGongJi = CreateStrokeLabel(20, CommonData.g_FONT1, "攻击：123456", ccp(60, 92), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbGongJi:setName("lbGongJi")
		m_plAttr:addChild(plbGongJi)

		local plbShiPo = CreateStrokeLabel(20, CommonData.g_FONT1, "识破：123456", ccp(220, 92), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbShiPo:setName("lbShiPo")
		m_plAttr:addChild(plbShiPo)

		local plbBaoJi = CreateStrokeLabel(20, CommonData.g_FONT1, "暴击：123456", ccp(60, 55), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbBaoJi:setName("lbBaoJi")
		m_plAttr:addChild(plbBaoJi)

		local plbMianShang = CreateStrokeLabel(20, CommonData.g_FONT1, "免伤：123456", ccp(220, 55), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbMianShang:setName("lbMianShang")
		m_plAttr:addChild(plbMianShang)

		local plbWuFang = CreateStrokeLabel(20, CommonData.g_FONT1, "物防：123456", ccp(60, 17), COLOR_Black, ccc3(255, 229, 160), false, ccp(0, -2), 1)
		plbWuFang:setName("lbWuFang")
		m_plAttr:addChild(plbWuFang)

	end

	local panelSkill =  tolua.cast(m_plyGeneralAttr:getWidgetByName("Panel_Skill"),"Layout")
	if panelSkill==nil then
		print("panelSkill is nil")
		return false
	else
		m_lbSkillType = CreateStrokeLabel(26, CommonData.g_FONT1, "技  能（法术）", ccp(60, 205), ccc3(31, 17, 11), ccc3(255, 250, 125), false, ccp(0, -2), 2)
		panelSkill:addChild(m_lbSkillType)

		local plbNormal = CreateStrokeLabel(24, CommonData.g_FONT1, "普通", ccp(13, 165), COLOR_Black,  ccc3(196, 255, 152), false, ccp(0, -2), 2)
		panelSkill:addChild(plbNormal)

		local plbEng = CreateStrokeLabel(24, CommonData.g_FONT1, "手动", ccp(13, 102), COLOR_Black,  ccc3(176, 251, 208), false, ccp(0, -2), 2)
		panelSkill:addChild(plbEng)

		local plbAuto = CreateStrokeLabel(24, CommonData.g_FONT1, "自动", ccp(13, 45), COLOR_Black,  ccc3(176, 251, 208), false, ccp(0, -2), 2)
		panelSkill:addChild(plbAuto)
	end

	local plTalent =  tolua.cast(m_plyGeneralAttr:getWidgetByName("Panel_Talent"),"Layout")
	if plTalent==nil then
		print("plTalent is nil")
		return false
	else
		m_lbTalentName = CreateStrokeLabel(26, CommonData.g_FONT1, "天  赋（天赋名称）", ccp(60, 320), ccc3(31, 17, 11), ccc3(255, 250, 125), false, ccp(0, -2), 2)
		plTalent:addChild(m_lbTalentName)

		m_imgTalentBg = tolua.cast(m_plyGeneralAttr:getWidgetByName("Image_Talent_bg"), "ImageView")
	end

	local plBlog =  tolua.cast(m_plyGeneralAttr:getWidgetByName("Panel_Blog"),"Layout")
	if plBlog==nil then
		print("plBlog is nil")
		return false
	else
		m_lbBlog = CreateStrokeLabel(26, CommonData.g_FONT1, "列  传（武将名称）", ccp(60, 90), ccc3(31, 17, 11), ccc3(255, 250, 125), false, ccp(0, -2), 2)
		plBlog:addChild(m_lbBlog)
	end

	local pScrollView_Attr = tolua.cast(m_plyGeneralAttr:getWidgetByName("ScrollView_Attr"), "ScrollView")
	if pScrollView_Attr==nil then
		print("pScrollView_Attr is nil")
		return false
	else
		pScrollView_Attr:setClippingType(1)
	end

	return true
end

function CreateGeneralAttrLayer( nGrid )
	InitVars()
	m_plyGeneralAttr = TouchGroup:create()
	m_plyGeneralAttr:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/WujiangAttrLayer.json" ) )

	if InitWidgets()==false then
		return
	end

	UpdataAttrData(nGrid)
	return m_plyGeneralAttr
end