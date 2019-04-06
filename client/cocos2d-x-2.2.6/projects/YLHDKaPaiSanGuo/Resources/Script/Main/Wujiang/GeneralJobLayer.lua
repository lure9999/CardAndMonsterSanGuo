require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Audio/AudioUtil"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralBaseUILogic"
require "Script/Main/Wujiang/GeneralJobData"
require "Script/Main/Wujiang/GeneralJobLogic"

require "Script/Main/Wujiang/HeroArmatureLayer"

module("GeneralJobLayer", package.seeall)

local m_plyGeneralJob = nil
local m_lvJob = nil
local m_nGrid = nil
local m_lbName = nil
local m_lbDesc = nil
local m_btnJobExplain = nil
local m_btnStartUp = nil
local m_btnActivite = nil
local m_btnUpgrade = nil
local m_imgBg = nil
local m_imgSpecials = {}
local m_imgCons = {}
local m_lbState = nil
local m_lbCurName = nil
local m_lbNextName = nil

local m_tabConItemsData ={}

local GetConsumeParaAType 				= ConsumeLogic.GetConsumeParaAType
local GetConsumeTab						= ConsumeLogic.GetConsumeTab
local GetConsumeItemData				= ConsumeLogic.GetConsumeItemData
local SetConsumeItemsData				= ConsumeLogic.SetConsumeItemsData

local GetJobName						= GeneralJobData.GetJobName
local GetJobIcon						= GeneralJobData.GetJobIcon
local GetJobDesc						= GeneralJobData.GetJobDesc
local GetSpecialName					= GeneralJobData.GetSpecialName
local GetSpecialIcon					= GeneralJobData.GetSpecialIcon
local GetSpecialAttrValue				= GeneralJobData.GetSpecialAttrValue
local GetJinJieConsumeId				= GeneralJobData.GetJinJieConsumeId
local GetNextGeneralID					= GeneralJobData.GetNextGeneralID
local GetJobNeedLv						= GeneralJobData.GetJobNeedLv

local GetSpecialLv 						= GeneralJobLogic.GetSpecialLv
local GetTabGeneralId 					= GeneralJobLogic.GetTabGeneralId
local GetSelGeneralId					= GeneralJobLogic.GetSelGeneralId
local SetSelGeneralId					= GeneralJobLogic.SetSelGeneralId
local UpdateSpecialInfoByGeneralID		= GeneralJobLogic.UpdateSpecialInfoByGeneralID
local GetSpecialId						= GeneralJobLogic.GetSpecialId
local GetSpecialState 					= GeneralJobLogic.GetSpecialState
local GetJobStateByGeneralID			= GeneralJobLogic.GetJobStateByGeneralID
local CheckSpecLvUp						= GeneralJobLogic.CheckSpecLvUp
local CheckUpgradeLv					= GeneralJobLogic.CheckUpgradeLv
local CheckUpgradeConsumeItems			= GeneralJobLogic.CheckUpgradeConsumeItems
local CheckUpgradeState					= GeneralJobLogic.CheckUpgradeState
local GetNeedXingHunNum					= GeneralJobLogic.GetNeedXingHunNum
local GetSpecialValue 					= GeneralJobLogic.GetSpecialValue
local UpdateItemIcon 					= GeneralBaseUILogic.UpdateItemIcon
local GetCurSelIndex 					= GeneralJobLogic.GetCurSelIndex
local SetCurSelIndex					= GeneralJobLogic.SetCurSelIndex

local function InitVars( )
	m_plyGeneralJob = nil
	m_lvJob = nil
	m_nGrid = nil
	m_lbName = nil
	m_lbDesc = nil
	m_btnJobExplain = nil
	m_btnStartUp = nil
	m_btnActivite = nil
	m_btnUpgrade = nil
	m_imgBg = nil
	m_imgSpecials = {}
	m_imgCons = {}
	m_lbState = nil
	m_lbCurName = nil
	m_lbNextName = nil

	m_tabConItemsData ={}

end

local function GetSelectGeneralId(  )
	local nIdx = m_lvJob:getCurSelectedIndex()
	return m_lvJob:getItem(nIdx):getTag()
end

local function UpdateConsumeWidget( imgItemCon, tabConsume, nIndex )
	if imgItemCon==nil  then
		return
	end

	local tabConsumeItemData = GetConsumeItemData(tabConsume.ConsumeID, tabConsume.nIdx, tabConsume.ConsumeType, tabConsume.IncType)

	SetConsumeItemsData(m_tabConItemsData, tabConsumeItemData)

	UpdateItemIcon(imgItemCon, tabConsumeItemData, 0, 0, 0)

	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	if tonumber(tabConsumeItemData.ConsumeType) == ConsumeType.Item then
		pGuideManager:RegisteGuide(imgItemCon,tabConsumeItemData.ItemId,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	else
		pGuideManager:RegisteGuide(imgItemCon,tabConsumeItemData.ConsumeType,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN)
	end
	pGuideManager = nil
end

local function UpdateJobWidgets( nGeneralId )
	local pImgArrow = tolua.cast(m_plyGeneralJob:getWidgetByName("Image_Arrow"), "ImageView")
	local plbNeedLv = tolua.cast(m_plyGeneralJob:getWidgetByName("Label_NeedLv"),"Label")
	local plbMax = tolua.cast(m_plyGeneralJob:getWidgetByName("Label_Max"), "Label")
	local strCurName = GetJobName(nGeneralId)
	local nState = GetJobStateByGeneralID(nGeneralId)

	LabelLayer.setText(m_lbCurName, strCurName)
	m_btnJobExplain:setTag(nGeneralId)
	m_btnStartUp:setTag(nGeneralId)
	m_btnActivite:setTag(nGeneralId)
	--print("nGeneralId = "..nGeneralId)
	--Pause()
	m_btnUpgrade:setTag(nGeneralId)

	if nState==GeneralJobData.JobState.NotActivite then
		m_btnActivite:setVisible(true)
		m_btnActivite:setTouchEnabled(true)
		m_btnUpgrade:setVisible(false)
		m_btnUpgrade:setTouchEnabled(false)
		m_btnStartUp:setVisible(true)
		m_btnStartUp:setTouchEnabled(true)

		for i=1, GeneralJobData.MAX_CONSUME_COUNT do
				m_imgCons[i]:setVisible(true)
		end
		LabelLayer.setColor(m_lbCurName, ccc3(239, 193, 55))
		LabelLayer.setText(m_lbState, "激活")
		pImgArrow:setVisible(false)
		plbMax:setVisible(false)
		--LabelLayer.setVisible(m_lbNextName, false)
		m_lbNextName:setVisible(false)
		local strNeedLv = GetJobNeedLv(nGeneralId)
		plbNeedLv:setText("等级"..strNeedLv.."可激活")
	else
		local nNextGeneralId = GetNextGeneralID(nGeneralId)

		LabelLayer.setColor(m_lbCurName, ccc3(127, 244, 80))
		LabelLayer.setText(m_lbState, "进阶")

		if nState==GeneralJobData.JobState.StartUp then
			m_btnStartUp:setVisible(false)
			m_btnStartUp:setTouchEnabled(false)
		else
			m_btnStartUp:setVisible(true)
			m_btnStartUp:setTouchEnabled(true)
		end

		if nNextGeneralId==-1 then
			for i=1, GeneralJobData.MAX_CONSUME_COUNT do
				m_imgCons[i]:setVisible(false)
			end
			plbNeedLv:setText("已达顶级")
			m_btnActivite:setVisible(false)
			m_btnActivite:setTouchEnabled(false)
			m_btnUpgrade:setVisible(false)
			m_btnUpgrade:setTouchEnabled(false)
			pImgArrow:setVisible(false)
			plbMax:setVisible(true)
			--LabelLayer.setVisible(m_lbNextName, false)
			m_lbNextName:setVisible(false)
		else
			for i=1, GeneralJobData.MAX_CONSUME_COUNT do
				m_imgCons[i]:setVisible(true)
			end
			local strNeedLv = GetJobNeedLv(nNextGeneralId)
			plbNeedLv:setText("等级"..strNeedLv.."可激活")
			local strNextName = GetJobName(nNextGeneralId)
			LabelLayer.setText(m_lbNextName, strNextName)

			m_btnActivite:setVisible(false)
			m_btnActivite:setTouchEnabled(false)
			m_btnUpgrade:setVisible(true)
			m_btnUpgrade:setTouchEnabled(true)
			pImgArrow:setVisible(true)
			plbMax:setVisible(false)
			--LabelLayer.setVisible(m_lbNextName, true)
			m_lbNextName:setVisible(false)
		end
	end
end

local function UpdateUpgradeInfo( nGeneralId )
	m_tabConItemsData = {}
	UpdateJobWidgets( nGeneralId)
	local nState = GetJobStateByGeneralID(nGeneralId)
	local pGeneralID = GetNextGeneralID(nGeneralId)
	if pGeneralID == -1 then
		pGeneralID = nGeneralId
	end
	if nState==GeneralJobData.JobState.NotActivite then
		pGeneralID = nGeneralId
	end
	local nConsumeId = GetJinJieConsumeId(pGeneralID)
	local tabConsume = GetConsumeTab( GeneralBaseData.MAX_CONSUMETYPE_COUNT, nConsumeId)
	for i=1, GeneralJobData.MAX_CONSUME_COUNT do
		if i<=#tabConsume then
			UpdateConsumeWidget(m_imgCons[i], tabConsume[i], i)
		end
	end
end

local function UpadateSpecialDynamicInfo( nIdx, nGeneralId )
	-- 专精等级
	local plbLv = tolua.cast(m_imgSpecials[nIdx]:getChildByName("lbLevel"), "Layout")
	local nSpecialLv = GetSpecialLv(nIdx)
	if plbLv~=nil then
		LabelLayer.setText(plbLv, "Lv."..tostring(nSpecialLv))
	end
	local plbXHNum = tolua.cast(m_imgSpecials[nIdx]:getChildByName("lbXingHunNum"), "Label")
	if plbXHNum~=nil then
		if GetSpecialState(nIdx)~=GeneralJobData.SpecialState.Normal then
			plbXHNum:setVisible(false)
		else
			local tabConsumeItemData = GetNeedXingHunNum(nGeneralId, nIdx, nSpecialLv)
			plbXHNum:setVisible(true)
			if tabConsumeItemData.Enough==true then
				-- LabelLayer.setColor(plbXHNum, COLOR_Green)
				plbXHNum:setColor(COLOR_Green)
			else
				-- LabelLayer.setColor(plbXHNum, COLOR_Red)
				plbXHNum:setColor(COLOR_Red)
			end
			-- LabelLayer.setText(plbXHNum, tostring(tabConsumeItemData.ItemNeedNum))
			plbXHNum:setText(tostring(tabConsumeItemData.ItemNeedNum))
		end
	end

	local  plbAttrNum = tolua.cast(m_imgSpecials[nIdx]:getChildByName("lbAttrNum"), "Layout")
	if plbAttrNum~=nil  then
		local nAttrNum = GetSpecialValue(nIdx)
		LabelLayer.setText(plbAttrNum, "+"..tostring(nAttrNum))
	end

end

local function  UpadateSpecialStaticInfo( nIdx, nGeneralId )
	-- 专精图标
	local imgSpecialIcon = tolua.cast(m_imgSpecials[nIdx]:getChildByName("Image_Icon"), "ImageView")
	if imgSpecialIcon~=nil then
		local strImgPath = GetSpecialIcon(nGeneralId, nIdx)
		imgSpecialIcon:loadTexture(strImgPath)
	end

	local nAttrId = GetSpecialId(nIdx)
	local strSpecialName = GetSpecialName(nAttrId)
	-- 专精名称
	local lbSpecial = tolua.cast(m_imgSpecials[nIdx]:getChildByName("Label_SpecName"), "Label")
	if lbSpecial~=nil then
		lbSpecial:setText(strSpecialName)
	end

	local lbAttrName = tolua.cast(m_imgSpecials[nIdx]:getChildByName("Label_AttrName"), "Label")
	if lbAttrName~=nil then
		lbAttrName:setText(strSpecialName)
	end
	--升级按钮
	local btnLvUp = tolua.cast(m_imgSpecials[nIdx]:getChildByName("Button_LvUp"), "Button")
	if btnLvUp~=nil then
		btnLvUp:setTag(nIdx)
		if GetSpecialState(nIdx)~=GeneralJobData.SpecialState.Normal then
			btnLvUp:setTouchEnabled(false)
			btnLvUp:setVisible(false)
		else
			btnLvUp:setTouchEnabled(true)
			btnLvUp:setVisible(true)
		end
	end

	-- 星魂图标
	local imgXHIcon = tolua.cast(m_imgSpecials[nIdx]:getChildByName("Image_Xh"), "ImageView")
	if imgXHIcon~=nil then
		if GetSpecialState(nIdx)~=GeneralJobData.SpecialState.Normal then
			imgXHIcon:setVisible(false)
		else
			imgXHIcon:setVisible(true)
		end

		local pGuideManager = GuideRegisterManager.RegisterGuideManager()
		pGuideManager:RegisteGuide(imgXHIcon,17,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN)
		pGuideManager = nil
	end

	local lbState = tolua.cast(m_imgSpecials[nIdx]:getChildByName("lbState"), "Layout")
	if lbState~=nil then
		if GetSpecialState(nIdx)==0 then
			lbState:setVisible(true)
		else
			lbState:setVisible(false)
		end
	end

	local imgMax = tolua.cast(m_imgSpecials[nIdx]:getChildByName("Image_End"), "ImageView")
	if imgMax~=nil then
		if GetSpecialState(nIdx)==GeneralJobData.SpecialState.MaxLv then
			imgMax:setVisible(true)
		else
			imgMax:setVisible(false)
		end
	end
end

local function _Button_LvUp_CallBack(sender, eventType)
	if eventType==TouchEventType.ended then
		local nIdx = sender:getTag()
		local nState = CheckSpecLvUp(nIdx)
		if tonumber(nState) == GeneralJobData.SpecErrorState.MaxLv then
			TipLayer.createTimeLayer("专精已达当前上限~", 2)
			return
		elseif tonumber(nState)  == GeneralJobData.SpecErrorState.NotEnouthItem then
			TipLayer.createTimeLayer("星魂不足！", 2)
			return
		else
			local nSelGeneralId = GetSelGeneralId()
			local function LvUpOver()
				NetWorkLoadingLayer.loadingHideNow()
				UpdateSpecialInfoByGeneralID(nSelGeneralId)
				UpdateUpgradeInfo(nSelGeneralId)
				for i=1, GeneralJobData.SPECIAL_COUNT do
					
					UpadateSpecialDynamicInfo(i, nSelGeneralId)
					UpadateSpecialStaticInfo(i, nSelGeneralId)
				end
				
				TipLayer.createTimeLayer("升级成功!",1)

			end
			Packet_ZhuanJing_LvUp.SetSuccessCallBack(LvUpOver)
			network.NetWorkEvent(Packet_ZhuanJing_LvUp.CreatPacket(nSelGeneralId, nIdx))
			NetWorkLoadingLayer.loadingShow(true)

		end
	end
end

-- 更新专精信息
local function UpdateSpecialInfo( nGeneralId )
	UpdateSpecialInfoByGeneralID(nGeneralId)
	for i=1, GeneralJobData.SPECIAL_COUNT do
		UpadateSpecialStaticInfo( i, nGeneralId)
		UpadateSpecialDynamicInfo(i, nGeneralId)
	end
end

local function UpdateStatciData( nGeneralId )
	local strDesc = GetJobDesc(nGeneralId)
	m_lbDesc:setText(strDesc)
	local strName = GetJobName(nGeneralId)
	LabelLayer.setText(m_lbName, strName)
end



local function UpdateMainGeneralInfo(nGeneralId)
	UpdateStatciData(nGeneralId)
	UpdateSpecialInfo(nGeneralId)
	UpdateUpgradeInfo(nGeneralId)
end

local function UpdateJobItem( nIdx )
	SetCurSelIndex( nIdx )
	for i=0, m_lvJob:getItems():count()-1 do
		local jobItem = m_lvJob:getItem(i)
		local imgSel = jobItem:getChildByName("jobSel")
		if i==nIdx then
			SetSelGeneralId(jobItem:getTag())
			UpdateMainGeneralInfo(jobItem:getTag())
			jobItem:setScale(1)
			imgSel:setVisible(true)
		else
			jobItem:setScale(0.85)
			imgSel:setVisible(false)
		end

		local strImg = GetJobIcon(jobItem:getTag())
		local pImgJob = tolua.cast(jobItem:getChildByName("Job"), "ImageView")
		if GetJobStateByGeneralID(jobItem:getTag()) == GeneralJobData.JobState.StartUp then
			strImg = string.gsub(strImg, ".png", "_sel.png")
		end
		pImgJob:loadTexture(strImg)
	end
end

local function _JobItem_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		UpdateJobItem(m_lvJob:getIndex(sender))
	end
end

local function CreateJobItem(nGeneralId)
	local plyJob = Layout:create()
	plyJob:setTag(nGeneralId)
	plyJob:setSize(CCSize(102,110))
	local strImg = GetJobIcon(nGeneralId)
	local imgBg = ImageView:create()
	imgBg:loadTexture("Image/imgres/wujiang/job_bg.png")
	imgBg:setPosition(ccp(49,51))
	plyJob:addChild(imgBg)

	local imgJob = ImageView:create()
	imgJob:loadTexture(strImg)
	imgJob:setName("Job")
	imgJob:setPosition(ccp(37,60))
	plyJob:addChild(imgJob)

	local imgNameBg = ImageView:create()
	imgNameBg:loadTexture("Image/imgres/wujiang/job_name_bg.png")
	imgNameBg:setPosition(ccp(55,15))
	plyJob:addChild(imgNameBg)

	local strName = GetJobName(nGeneralId)
	local lbName = LabelLayer.createStrokeLabel(28, CommonData.g_FONT1, strName, ccp(0, -7), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	lbName:setName("lbName")
	lbName:setPosition(ccp(48,26))
	plyJob:addChild(lbName)

	local imgSel = ImageView:create()
	imgSel:loadTexture("Image/imgres/common/arrow_cue.png")
	imgSel:setPosition(ccp(87,52))
	imgSel:setRotation(270)
	imgSel:setName("jobSel")
	imgSel:setVisible(false)
	plyJob:addChild(imgSel)

	plyJob:setScale(0.85)
	plyJob:setTouchEnabled(true)
	plyJob:addTouchEventListener(_JobItem_CallBack)
	return plyJob
end

function UpdateJobListView()
	m_lvJob:removeAllItems()
	for i,v in ipairs(GetTabGeneralId()) do
		local lvJobItem = CreateJobItem(v)
		m_lvJob:pushBackCustomItem(lvJobItem)
		if GetSelGeneralId()==m_lvJob:getItem(i-1):getTag()  then
			_JobItem_CallBack(m_lvJob:getItem(i-1), TouchEventType.ended)
		end
	end
end

local function _BtnExplain_CallBack( sender, eventType )
	if eventType==TouchEventType.ended then
		require "Script/Main/wujiang/JobExplainLayer"
		local lyJobExp = JobExplainLayer.CreateJobExplainLayer(sender:getTag())
		m_plyGeneralJob:addChild(lyJobExp)
	end
end

local function UpdateListJobSelItem( nIdx, nGeneralId )
	-- m_lvJob:getCurSelectedIndex()
	local strName = GetJobName(nGeneralId)
	local pItem = m_lvJob:getItem(nIdx)
	pItem:setTag(nGeneralId)
	local plbName = tolua.cast(pItem:getChildByName("lbName") , "Layout")
	LabelLayer.setText(plbName, strName)
end

local function HandleResultArmature(nGeneralId, nState, nPosX, nPosY)
	--add by sin 这个引用为什么不放外边！！！！
	--require "Script/Main/wujiang/HeroArmatureLayer"
	local pHeroArmature = HeroArmatureLayer.CreateHeroArmaLayer(nGeneralId, nState, nPosX, nPosY)
	m_plyGeneralJob:addChild(pHeroArmature)
end

local function _BtnStartUp_CallBack( sender, eventType )
	if eventType==TouchEventType.ended then
		local nState = GetJobStateByGeneralID(sender:getTag())
		if nState==GeneralJobData.JobState.NotActivite then
			TipLayer.createTimeLayer("公主,您需要先激活这个职业才能启用哦",2)
			return
		end

		local function TurnProOver()
			NetWorkLoadingLayer.loadingHideNow()
			SetSelGeneralId(sender:getTag())
			UpdateJobListView()
			UpdateMainGeneralInfo(sender:getTag())
			HandleResultArmature(sender:getTag(),1, -1, -1)
		end
		Packet_MainStay_ChangeJob.SetSuccessCallBack(TurnProOver)
		network.NetWorkEvent(Packet_MainStay_ChangeJob.CreatPacket(m_nGrid, sender:getTag()))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function _BtnActivite_CallBack( sender, eventType )
	if eventType==TouchEventType.ended then
		if CheckUpgradeState(sender:getTag(), m_tabConItemsData)==false then
			return
		end
		local function ActiveOver()
			NetWorkLoadingLayer.loadingHideNow()
			--激活成功 
			UpdateMainGeneralInfo(sender:getTag())
			local nIdx = m_lvJob:getCurSelectedIndex()
			local pItem = m_lvJob:getItem(nIdx)
			HandleResultArmature(sender:getTag(),0,pItem:getWorldPosition().x+pItem:getContentSize().width/2,
																	pItem:getWorldPosition().y+pItem:getContentSize().height/2)
		end
		Packet_MainStay_JiHuo.SetSuccessCallBack(ActiveOver)
		network.NetWorkEvent(Packet_MainStay_JiHuo.CreatPacket(m_nGrid, sender:getTag()))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function _BtnUpgrade_CallBack( sender, eventType )
	if eventType==TouchEventType.ended then
		local nNextGeneralId = GetNextGeneralID(sender:getTag())
		if CheckUpgradeState(nNextGeneralId, m_tabConItemsData)==false then
			return
		end

		local function UpgradedOver()
			UpdateListJobSelItem(GetCurSelIndex(), nNextGeneralId)
			NetWorkLoadingLayer.loadingHideNow()
			SetSelGeneralId(nNextGeneralId)
			UpdateMainGeneralInfo(nNextGeneralId)
			local nIdx = GetCurSelIndex()
			local pItem = m_lvJob:getItem(nIdx)
			--进阶重新单独写
			HandleResultArmature(nNextGeneralId,3,pItem:getWorldPosition().x+pItem:getContentSize().width/2,
													pItem:getWorldPosition().y+pItem:getContentSize().height/2)
		end
		Packet_UpraidJob.SetSuccessCallBack(UpgradedOver)
		network.NetWorkEvent(Packet_UpraidJob.CreatPacket(sender:getTag(), nNextGeneralId))
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function InitWidgets(  )
	 m_lvJob = tolua.cast(m_plyGeneralJob:getWidgetByName("ListView_Job"), "ListView")
	 if m_lvJob==nil then
	 	print("m_lvJob is nil")
	 	return false
	 else
		m_lvJob:setClippingType(1)
	 end

	 m_lbDesc = tolua.cast(m_plyGeneralJob:getWidgetByName("Label_Desc"), "Label")
	 if m_lbDesc==nil then
	 	print("m_lbDesc is nil")
	 	return false
	 end

	 local lExplain = tolua.cast(m_plyGeneralJob:getWidgetByName("Label_32"),"Label")
	 if lExplain ~= nil then
		lExplain:setVisible(false)
	end

	m_lbName =  LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "战士", ccp(123, 414), COLOR_Black, ccc3(239, 193, 55), true, ccp(0, -2), 2)
	if m_lbName==nil then
		print("m_lbName is nil")
		return false
	else
		local pLyaerJob = m_plyGeneralJob:getWidgetByName("Panel_HeroJob")
	 	pLyaerJob:addChild(m_lbName)
	end

	m_btnJobExplain = tolua.cast(m_plyGeneralJob:getWidgetByName("Button_JobExplain"), "Button")
	if m_btnJobExplain==nil then
		print("m_btnJobExplain is nil")
		return false
	else
		m_btnJobExplain:addTouchEventListener(_BtnExplain_CallBack)
	end

	m_btnStartUp = tolua.cast(m_plyGeneralJob:getWidgetByName("Button_StartUp"), "Button")
	if m_btnStartUp==nil then
		print("m_btnStartUp is nil")
		return false
	else
		local pLabel = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "启用", ccp(0, 0), COLOR_Black,  COLOR_White, true, ccp(0, -2), 2)
		m_btnStartUp:addChild(pLabel)
		m_btnStartUp:addTouchEventListener(_BtnStartUp_CallBack)
	end

	m_btnActivite = tolua.cast(m_plyGeneralJob:getWidgetByName("Button_Activite"), "Button")
	if m_btnActivite==nil then
		print("m_btnActivite is nil")
		return false
	else
		local pLabel = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "激活", ccp(0, 0), COLOR_Black,  COLOR_White, true, ccp(0, -2), 2)
		m_btnActivite:addChild(pLabel)
		m_btnActivite:addTouchEventListener(_BtnActivite_CallBack)
	end

	m_btnUpgrade = tolua.cast(m_plyGeneralJob:getWidgetByName("Button_Upgrade"), "Button")
	if m_btnUpgrade==nil then
		print("m_btnUpgrade is nil")
		return false
	else
		local pLabel = LabelLayer.createStrokeLabel(36, CommonData.g_FONT1, "进阶", ccp(0, 0), COLOR_Black,  COLOR_White, true, ccp(0, -2), 2)
		m_btnUpgrade:addChild(pLabel)
		m_btnUpgrade:addTouchEventListener(_BtnUpgrade_CallBack)
	end

	local pImgBg = tolua.cast(m_plyGeneralJob:getWidgetByName("Image_Bg"),"ImageView")
	if pImgBg==nil then
		print("pImgBg is nil")
		return false
	else
		local pLabel1 = LabelLayer.createStrokeLabel(25, CommonData.g_FONT1, "专精", ccp(-261, 168), COLOR_Black,  ccc3(255, 250, 125), true, ccp(0, -2), 2)
		pImgBg:addChild(pLabel1)
		m_lbState = LabelLayer.createStrokeLabel(25, CommonData.g_FONT1, "激活", ccp(-261, -54), COLOR_Black,  ccc3(255, 250, 125), true, ccp(0, -2), 2)
		pImgBg:addChild(m_lbState)

		m_lbCurName = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "战士", ccp(-83, -50), COLOR_Black,  ccc3(127, 244, 80), true, ccp(0, -2), 2)
		pImgBg:addChild(m_lbCurName)

		m_lbNextName = LabelLayer.createStrokeLabel(26, CommonData.g_FONT1, "猛士", ccp(7, -50), COLOR_Black,  ccc3(239, 193, 55), true, ccp(0, -2), 2)
		pImgBg:addChild(m_lbNextName)
	end

	for i=1, 4 do
		m_imgSpecials[i] = tolua.cast(m_plyGeneralJob:getWidgetByName("Image_Item_"..tostring(i)), "ImageView")
		if m_imgSpecials[i]==nil then
			print("m_imgSpecials["..i.."] is nil")
		else
			local plbLv = LabelLayer.createStrokeLabel(20, "Thonburi", "Lv.1", ccp(-130, -22), COLOR_Black,  COLOR_White, true, ccp(0, -2), 2)
			plbLv:setName("lbLevel")
			m_imgSpecials[i]:addChild(plbLv)

			local plbState = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "未激活", ccp(93, 14), COLOR_Black,  ccc3(175, 175, 175), true, ccp(0, -2), 2)
			plbState:setName("lbState")
			m_imgSpecials[i]:addChild(plbState)

			local plbAttrNum = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "+10", ccp(-20, -18), COLOR_Black,  COLOR_White, false, ccp(0, -2), 2)
			plbAttrNum:setName("lbAttrNum")
			m_imgSpecials[i]:addChild(plbAttrNum)

			local plbXingHunNum = Label:create()
			plbXingHunNum:setPosition(ccp(75,-18))
			plbXingHunNum:setFontSize(20)
			plbXingHunNum:setColor(COLOR_Red)
			plbXingHunNum:setName("lbXingHunNum")
			plbXingHunNum:setAnchorPoint(ccp(0, 0.5))
			m_imgSpecials[i]:addChild(plbXingHunNum)

			--[[local plbXingHunNum = LabelLayer.createStrokeLabel(20, CommonData.g_FONT1, "123456", ccp(75, -18), COLOR_Black,  ccc3(255, 0, 0), false, ccp(0, -2), 2)
			plbXingHunNum:setName("lbXingHunNum")
			m_imgSpecials[i]:addChild(plbXingHunNum)]]--

			local plbSpecName = tolua.cast(m_imgSpecials[i]:getChildByName("Label_SpecName"), "Label")
			plbSpecName:setFontName(CommonData.g_FONT1)

			local plbAttrName = tolua.cast(m_imgSpecials[i]:getChildByName("Label_AttrName"), "Label")
			plbAttrName:setFontName(CommonData.g_FONT1)

			local btnLvUp = tolua.cast(m_imgSpecials[i]:getChildByName("Button_LvUp"), "Button")
			if btnLvUp~=nil then
				btnLvUp:addTouchEventListener(_Button_LvUp_CallBack)
			end
		end
	end

	for i=1, 3 do
		m_imgCons[i] = tolua.cast(m_plyGeneralJob:getWidgetByName("Image_ConsumeItem_"..tostring(i)), "Layout")
		if m_imgCons[i]==nil then
			print("m_imgCons["..i.."] is nil")
			return false
		end
	end
	return true
end


function CreateGeneralJobLayer( nGrid )
	InitVars()
	m_plyGeneralJob = TouchGroup:create()
	m_plyGeneralJob:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/HeroJobLayer.json" ) )
	if InitWidgets()==false then
		return
	end
	m_nGrid = nGrid
	UpdateJobListView()

	return m_plyGeneralJob
end