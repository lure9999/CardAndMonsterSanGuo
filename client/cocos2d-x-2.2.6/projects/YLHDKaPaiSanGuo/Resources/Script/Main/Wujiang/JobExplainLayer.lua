require "Script/Main/Wujiang/GeneralBaseData"

module("JobExplainLayer", package.seeall)

local GetSkillData 				= GeneralBaseData.GetSkillData

local m_plyJobExplain = nil
local m_btnClose = nil
local m_btnOK = nil

local function InitVars(  )
	m_plyJobExplain = nil
	m_btnClose = nil
	m_btnOK = nil
end

local function UpdateSkillInfo( nGeneralId )
	local tabSkillData = GetSkillData(nGeneralId)
	local lbNorName = tolua.cast(m_plyJobExplain:getWidgetByName("Label_NorName"),"Label")
	if lbNorName~=nil then
		lbNorName:setText(tabSkillData.NormalSkill.Name)
	end

	local lbNorDesc = tolua.cast(m_plyJobExplain:getWidgetByName("Label_NorDesc"),"Label")
	if lbNorDesc~=nil then
		lbNorDesc:setText(tabSkillData.NormalSkill.Desc)
	end


	local lbEngName = tolua.cast(m_plyJobExplain:getWidgetByName("Label_EngName"),"Label")
	if lbEngName~=nil then
		lbEngName:setText(tabSkillData.AutoSkill.Name)
	end

	local lbEngDesc = tolua.cast(m_plyJobExplain:getWidgetByName("Label_EngDesc"),"Label")
	if lbEngDesc~=nil then
		lbEngDesc:setText(tabSkillData.AutoSkill.Desc)
	end

	local lbAutoName = tolua.cast(m_plyJobExplain:getWidgetByName("Label_AutoName"),"Label")
	if lbAutoName~=nil then
		lbAutoName:setText(tabSkillData.EngineSkill.Name)
	end

	local lbAutoDesc = tolua.cast(m_plyJobExplain:getWidgetByName("Label_AutoDesc"),"Label")
	if lbAutoDesc~=nil then
		lbAutoDesc:setText(tabSkillData.EngineSkill.Desc)
	end

end

local  function _BtnClose_CallBack( sender, eventType )
	if eventType==TouchEventType.ended then
		if m_plyJobExplain~=nil then
			m_plyJobExplain:removeFromParentAndCleanup(true)
			InitVars()
		end
	end
end

local function InitWidgets()
	m_btnClose = tolua.cast(m_plyJobExplain:getWidgetByName("Button_Close"), "Button")
	if m_btnClose==nil then
		print("m_btnClose is nil")
		return false
	else
		m_btnClose:addTouchEventListener(_BtnClose_CallBack)
	end

	m_btnOK = tolua.cast(m_plyJobExplain:getWidgetByName("Button_OK"), "Button")
	if m_btnOK==nil then
		print("m_btnOK is nil")
		return false
	else
		local pLabel = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "朕知道了", ccp(0, 0), COLOR_Black,  COLOR_White, true, ccp(0, -2), 2)
		m_btnOK:addChild(pLabel)
		m_btnOK:addTouchEventListener(_BtnClose_CallBack)
	end

	local imgBg = tolua.cast(m_plyJobExplain:getWidgetByName("Image_Bg"), "ImageView")
	if imgBg==nil then
		print("imgBg is nil")
		return false
	else
		local plbNormal = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "普通", ccp(-210, 111), COLOR_Black,  ccc3(196, 255, 152), true, ccp(0, -2), 2)
		imgBg:addChild(plbNormal)

		local plbEng = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "手动", ccp(-210, 54), COLOR_Black,  ccc3(176, 251, 208), true, ccp(0, -2), 2)
		imgBg:addChild(plbEng)

		local plbAuto = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "自动", ccp(-210, -3), COLOR_Black,  ccc3(176, 251, 208), true, ccp(0, -2), 2)
		imgBg:addChild(plbAuto)
	end
	return true
end

function CreateJobExplainLayer( nGeneralId )
	InitVars()
	m_plyJobExplain = TouchGroup:create()
	m_plyJobExplain:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/JobExplainLayer.json" ) )
	if InitWidgets()==false then
		return
	end

	UpdateSkillInfo(nGeneralId)
	return m_plyJobExplain
end