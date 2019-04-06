module("CorpsChangedName",package.seeall)

local m_layer_CorpsChangedName = nil
local m_edit_CorpsChangedName = nil
local m_corpsName             = nil
local tableSeverData = {}
local nPageNum = 1
local tableDataList = {}
local CheckName = CorpsLogic.CheckName

local function initData(  )
	m_layer_CorpsChangedName = nil
	m_edit_CorpsChangedName = nil
	m_corpsName              = nil
	tableSeverData = {}
	nPageNum = 1
	tableDataList = {}
end

local function DeleteEditBox()
	local img_changeName_Bg = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Image_bg"),"ImageView")
	if img_changeName_Bg:getNodeByTag(200)~=nil then
		img_changeName_Bg:removeNodeByTag(200)
	end
end
local function _Btn_Cancel_Name_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		m_layer_CorpsChangedName:removeFromParentAndCleanup(true)
		DeleteEditBox()
		initData()
	end
	
end

local function GetSeverData(  )
	local function GetSuccessCall(  )
		local tableDataAp = CorpsData.GetAllCorpsData()
		if #tableDataAp ~= 0 then
			table.insert(tableSeverData,tableDataAp)	
		else
			print("表中内容为空")
		end
	end
	Packet_CorpsGetList.SetSuccessCallBack(GetSuccessCall)
	network.NetWorkEvent(Packet_CorpsGetList.CreatePacket(1,1))
end

local function GetFindServerData(  )
	local function GetFindSuccessCallback(  )
		
		tableDataList = CorpsData.GetCorpsListData()
		local nTotalNum = CorpsData.GetnTotalNum()
		nPageNum = nTotalNum
		if #tableDataList ~= 0 then
			table.insert(tableSeverData,tableDataList)
		end

	end
	Packet_CorpsFind.SetSuccessCallBack(GetFindSuccessCallback)
	network.NetWorkEvent(Packet_CorpsFind.CreatePacket(nPageNum))
end

local function _Btn_OK_Name_CallBack(sender,eventType)
	--确定，保存名字和关闭
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local tableServerName = {}
		for key,value in pairs(tableDataList) do
			local name = CorpsData.GetCorpsName(key)
			table.insert(tableServerName,name)
		end
		local editName = m_edit_CorpsChangedName:getText()
		local lenStr = string.len(editName)
		if CheckName(editName,tableServerName) ==true then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1410,nil)
			pTips = nil
		elseif lenStr >= 3 and lenStr <= 24 then 
			if editName ~= m_corpsName then
				local function GetSuccessCallback(  )
					--NetWorkLoadingLayer.loadingHideShow()	
					CorpsInfoSetLayer.ChangedCorpsName(editName)	
					CorpsScene.SetCorpsName(editName)
					m_layer_CorpsChangedName:setVisible(false)
					m_layer_CorpsChangedName:removeFromParentAndCleanup(true)
					m_layer_CorpsChangedName = nil
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1415,nil)
					pTips = nil
					
				end	
				Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(2,editName))
				--NetWorkLoadingLayer.loadingShow(true)
			else
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1418,nil)
				pTips = nil
			end
		else
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1409,nil)
			pTips = nil
		end
	end
	
end

local function ShowUI()
	local m_panel = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Panel_xh"),"Layout")	
		
	local img_bg_num = ImageView:create()
	img_bg_num:loadTexture("Image/imgres/equip/bg_name_equiped.png")
	img_bg_num:setPosition(ccp(200,40))
	--AddLabelImg(img_bg_num,2,m_panel)
	--消耗图标
	local img_changeName_Bg = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Image_bg"),"ImageView")

	local label_title = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Label_text"),"Label")
	local label_word = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Label_word"),"Label")
	local label_num = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Label_num"),"Label")	
	--label_num:setText(strExplain)
	label_num:setFontSize(30)
	label_num:setColor(ccc3(253,235,200))
	label_num:setText("9999")
	--按钮，确定和取消
	local m_btn_cancel = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Button_cancel"),"Button")
	local m_btn_ok = tolua.cast(m_layer_CorpsChangedName:getWidgetByName("Button_certain"),"Button")
	m_btn_ok:addTouchEventListener(_Btn_OK_Name_CallBack)
	m_btn_cancel:addTouchEventListener(_Btn_Cancel_Name_CallBack)

	local labelWordText = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"消耗",ccp(0,4),ccc3(43,31,31),ccc3(255,194,30),true,ccp(0,-2),2) 
	--local labelNumText = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"9999",ccp(0,4),ccc3(43,31,31),ccc3(253,235,200),true,ccp(0,-2),2)
	local labelCancelText = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,"取消",ccp(0,4),ccc3(0,0,0),ccc3(255,255,255),true,ccp(0,-2),2)
	local labelCertainText = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,"确定",ccp(0,4),ccc3(0,0,0),ccc3(255,255,255),true,ccp(0,-2),2)

	label_word:addChild(labelWordText)
	--label_num:addChild(labelNumText)
	m_btn_cancel:addChild(labelCancelText)
	m_btn_ok:addChild(labelCertainText)

	--输入文本
	if m_edit_CorpsChangedName == nil then
		m_edit_CorpsChangedName = CCEditBox:create(CCSizeMake(298,44),CCScale9Sprite:create("Image/imgres/login/bg_input.png"))
		m_edit_CorpsChangedName:setPosition(ccp(0,0))
		m_edit_CorpsChangedName:setMaxLength(6)		
		m_edit_CorpsChangedName:setFontName(CommonData.g_FONT3)
		m_edit_CorpsChangedName:setPlaceholderFontColor(ccc3(75,46,31))
		m_edit_CorpsChangedName:setPlaceholderFontSize(30)
		m_edit_CorpsChangedName:setFontColor(ccc3(75,46,31))
		m_edit_CorpsChangedName:setFontSize(30)
		m_edit_CorpsChangedName:setPlaceHolder("")
		m_edit_CorpsChangedName:setReturnType(kKeyboardReturnTypeDone)
		m_edit_CorpsChangedName:setInputFlag(kEditBoxInputFlagInitialCapsWord)
		m_edit_CorpsChangedName:setTouchPriority(-129)
		img_changeName_Bg:addNode(m_edit_CorpsChangedName,200,200)
	end
	
end


function ShowCorpsChangeNameLayer(value)
	initData()
	m_layer_CorpsChangedName =  TouchGroup:create()
	m_layer_CorpsChangedName:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CorpsChangeName.json" ) )
	ShowUI()
	-- GetSeverData()
	GetFindServerData()
	m_corpsName = value.name
	return m_layer_CorpsChangedName
end