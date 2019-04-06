--FileName:CorpsApplyListLayer
--Author:sixuechao
--Purpose:军团申请人员列表
--
module("CorpsApplyListLayer",package.seeall)
require "Script/Main/Corps/CorpsData"

local m_CorpsApplyList = nil
local ListView_Hero = nil
local ApplyCorpsInfoWidget = nil
local heroID = nil
local heroFaceID = nil
local heroName = nil
local heroLevel = nil
local heroPower = nil
local corpsPeople = nil
local corpsNeedlevel = nil
local isCorps        = nil
local chooseNum = nil
local peopleNum = 0
local tableAllID = {}
local GetAllCorpsData = CorpsData.GetAllCorpsData
local createIDLayer  = TipLayer.createTimeLayer
local GetHeadImgPath = CorpsData.GetHeadImgPath
local cleanListView = CorpsLogic.cleanListView


local function initData(  )
	tableAllID = {}
	m_CorpsApplyList = nil
	ListView_Hero = nil
	ApplyCorpsInfoWidget = nil
	heroID = nil
	heroFaceID = nil
	heroName = nil
	heroLevel = nil
	heroPower = nil
	corpsPeople = nil
	corpsNeedlevel = nil
	isCorps        = nil
	chooseNum      = nil
	peopleNum = 0
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		m_CorpsApplyList:removeFromParentAndCleanup(true)	
		NetWorkLoadingLayer.loadingShow(false)
		if chooseNum == 2 then
			CorpsContentLayer.loadDataFromServer()

		end
	end
end

local function CreateHeroItemWidget( pListViewTemp )
	local pListViewMemberInfo = pListViewTemp:clone()
	local peer = tolua.getpeer(pListViewTemp)
	tolua.setpeer(pListViewMemberInfo,peer)
	return pListViewMemberInfo
end 

--显示军团列表信息
local function ApplyCorpsInfoIcon(value )
	--value.name value.level value.userID value.faceID value.power
	local mCorpsId = value.id
	local ListCorps_Info  = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsInfoLayer.json")
	ApplyCorpsInfoWidget   = CreateHeroItemWidget(ListCorps_Info)
	--cleanListView(ListView_Hero)
	local CorpsIconItem   = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Image_Item"),"ImageView")	
	UIInterface.MakeHeadIcon(CorpsIconItem,ICONTYPE.DISPLAY_ICON,nil,nil,nil,nil,nil)
	CorpsIconItem:setScale(0.68)
	local CorpsIconKuang   = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Image_Kuang"),"ImageView")
	local corpskuangBg = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Image_64"),"ImageView")
	corpskuangBg:setZOrder(-1)

	local CorpsBelongIcon = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Image_Belong"),"ImageView")
    
	local LabelCorpsName  = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Label_CorpsName"),"Label")
	local LableCorpsLevel = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Label_Level"),"Label")
	local LabelCorps_Info = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Label_Info"),"Label")
	local LabelNeedLevel = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Label_NeedLevel"),"Label")
	local label_corpsNum = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Label_CorpsMember"),"Label")
	local Label_68 = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Label_68"),"Label")
	local Label_69 = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Label_69"),"Label")
	local btn = tolua.cast(ApplyCorpsInfoWidget:getChildByName("Button_48"),"Button")
	btn:setVisible(false)

	local m_LabelCorpsName  = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, value.faceID, ccp(-15, 0), ccc3(83,28,2), ccc3(253,194,30), true, ccp(0, -2), 2)
	
	local m_LabelLevel     = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, value.level, ccp(1, 0), ccc3(83,28,2), ccc3(253,235,200), true, ccp(0, -2), 2)
	local m_CorpsNum = LabelLayer.createStrokeLabel(18, CommonData.g_FONT1, value.name, ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	--CorpsIconItem:addChild(m_CorpsLevel)	
	label_corpsNum:addChild(m_CorpsNum)
	LabelCorpsName:addChild(m_LabelCorpsName)	
	CorpsBelongIcon:addChild(m_LabelLevel)
	ListView_Hero:pushBackCustomItem(ApplyCorpsInfoWidget)
    ListView_Hero:jumpToBottom()

end

local function CircleCorpsList(  )
	--拒绝加入军团
	local function _Click_Refuse_CallBack(sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local ptag = tolua.cast(sender,"Button")
			local HeroId = tonumber(ptag:getTag())
			local function GetSuccessCallback(  )
				NetWorkLoadingLayer.loadingHideNow()
				CircleCorpsList()
			end
			Packet_CorpsApplyOperator.SetSuccessCallBack(GetSuccessCallback)
			network.NetWorkEvent(Packet_CorpsApplyOperator.CreatePacket(HeroId,0))
			NetWorkLoadingLayer.loadingShow(true)
		end
	end
	--同意加入军团
	local function _Click_Certain_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			AudioUtil.PlayBtnClick()
			local ptag = tolua.cast(sender,"Button")
			local HeroId = tonumber(ptag:getTag()) 

			--if isCorps > 0 then
				--TipLayer.createTimeLayer("该玩家已有军团!!!")
			--else
				--if heroLevel >= corpsNeedlevel then
					--network.NetWorkEvent(Packet_CorpsApplyOperator.CreatePacket(heroID,1))
				--end
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					peopleNum = peopleNum + 1
					CorpsMemberManageLayer.GetPeopleNum(peopleNum)
					CircleCorpsList()
				end
				Packet_CorpsApplyOperator.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsApplyOperator.CreatePacket(HeroId,1))
				
				NetWorkLoadingLayer.loadingShow(true)
			--end
			
		end
	end

	local function PowerWord(str)
		local image_power = tolua.cast(listwidgetinfo:getChildByName("Image_13"),"ImageView")
		image_power:loadTexture("Image/imgres/main/fight.png")
	end

	local function GetPowerNum( num )
		local label_powerNum = tolua.cast(listwidgetinfo:getChildByName("Label_guanzhi"),"Label")
		if label_powerNum:getChildByTag(1000) ~= nil then
			local ntemp = tolua.cast(label_powerNum:getChildByTag(1000),"LabelBMFont")
			ntemp:setText(num)
		else
			local pText = LabelBMFont:create()		
			pText:setFntFile("Image/imgres/main/fight.fnt")
			pText:setPosition(ccp(-10,-20))
			pText:setAnchorPoint(ccp(0.5,0.5))
			pText:setText(num)
			label_powerNum:addChild(pText,0,1000)
		end
		
	end

	local function loadHeroInfo( value )

		heroID = value.id
		heroFaceID = value.flag
		heroName = value.name--图标ID
		heroLevel = value.level
		heroPower = value.people--名字
		isCorps = tonumber(server_mainDB.getMainData("nCorps"))
		local listMember_Info  =  GUIReader:shareReader():widgetFromJsonFile("Image/Corps_MemberInfo.json")
		listwidgetinfo = CreateHeroItemWidget(listMember_Info)
		--cleanListView(ListView_Hero)
		local faceID = value.flag
		local MemberIconItem = tolua.cast(listwidgetinfo:getChildByName("Image_Icon"),"ImageView")
		local HeroIconItem = tolua.cast(MemberIconItem:getChildByName("Image_iconID"),"ImageView")
		local img_kuang = tolua.cast(MemberIconItem:getChildByName("Image_49"),"ImageView")
		-- HeroIconItem:setVisible(false)
		img_kuang:setVisible(false)
		local itemid = nil

		if tonumber(value["name"]) == 0 then
			UIInterface.MakeHeadIcon(HeroIconItem,ICONTYPE.DISPLAY_ICON,nil,nil,nil,nil,7)
		else
			UIInterface.MakeHeadIcon(HeroIconItem, ICONTYPE.HEAD_ICON, nil, nil,nil,value["name"],nil)
		end
		--UIInterface.MakeHeadIcon(HeroIconItem,ICONTYPE.DISPLAY_ICON,nil,nil,nil,nil,nil)
		--HeroIconItem:setScale(0.65)

		local imageLevel = tolua.cast(listwidgetinfo:getChildByName("Image_level"),"ImageView")
		local label_level = tolua.cast(imageLevel:getChildByName("Label_Level"),"Label")

		
		local label_name  = tolua.cast(listwidgetinfo:getChildByName("Label_Name"),"Label")
		

		local herolevel = server_mainDB.getMainData("level")
		local heroname = server_mainDB.getMainData("name")
		local str = "战斗力"
	    PowerWord(str)
	    GetPowerNum(value.needLevel)
	    local labelLevelText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, value.level, ccp(0, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)
	    local labelNameText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, value.people, ccp(-20, 0), ccc3(83,28,2), ccc3(255,235,200), true, ccp(0, -2), 2)--value.name
	    local labelCancelText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "拒绝", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	    local labelCertainText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "同意", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	    --label_power:addChild(labelPowerText)
	    label_level:addChild(labelLevelText)
	    label_name:addChild(labelNameText)

	    --[[local pText = LabelBMFont:create()
		pText:setText(value.power)
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-10,-20))
		pText:setAnchorPoint(ccp(0,0.5))
		label_power:addChild(pText,0,1000)]]--艺术字体

	    local btnn_Cancel = Button:create()
	    btnn_Cancel:loadTextures("Image/imgres/button/btn_xl.png","Image/imgres/button/btn_xl.png","")
	    btnn_Cancel:setPosition(ccp(458,40))
	    btnn_Cancel:setScaleX(0.65)
	    btnn_Cancel:setTag(value.id)
	    listwidgetinfo:addChild(btnn_Cancel)
	    btnn_Cancel:addTouchEventListener(_Click_Refuse_CallBack)
	    btnn_Cancel:addChild(labelCancelText)

	    local btnn_Certain = Button:create()
	    btnn_Certain:loadTextures("Image/imgres/button/btn_xl.png","Image/imgres/button/btn_xl.png","")
	    btnn_Certain:setPosition(ccp(588,40))
	    btnn_Certain:setScaleX(0.65)
	    btnn_Certain:setTag(value.id)
	    listwidgetinfo:addChild(btnn_Certain)
	    btnn_Certain:addTouchEventListener(_Click_Certain_CallBack)
	    btnn_Certain:addChild(labelCertainText)

	    ListView_Hero:pushBackCustomItem(listwidgetinfo)
	    ListView_Hero:jumpToBottom()
	end
	local function GetSuccessCall(  )
		NetWorkLoadingLayer.loadingHideNow()
		local tableData = GetAllCorpsData()
		cleanListView(ListView_Hero)
		if #tableData ~= 0 then
			for key,value in pairs(tableData) do
				if chooseNum == 2 then
					loadHeroInfo(value)
					printTab(value)
					table.insert(tableAllID,value.id)
				end
			end
		else
			TipLayer.createTimeLayer("目前没有申请的玩家")
		end
	end
	Packet_CorpsGetList.SetSuccessCallBack(GetSuccessCall)
	network.NetWorkEvent(Packet_CorpsGetList.CreatePacket(1,chooseNum))
	NetWorkLoadingLayer.loadingShow(true)
end

local function _Click_AllCertain_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if #tableAllID ~= 0 then
			for key,value in pairs(tableAllID) do
			
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					peopleNum = peopleNum + 1
					CorpsMemberManageLayer.GetPeopleNum(peopleNum)
				end
				Packet_CorpsApplyOperator.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsApplyOperator.CreatePacket(value,1))					
				NetWorkLoadingLayer.loadingShow(true)
			end
			tableAllID = {}
			CircleCorpsList()

		else

		end
	end
end

local function _Click_AllCancel_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		if #tableAllID ~= 0 then
			for key,value in pairs(tableAllID) do
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					TipLayer.createTimeLayer("已经全部拒绝")
				end
				Packet_CorpsApplyOperator.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsApplyOperator.CreatePacket(value,0))
				NetWorkLoadingLayer.loadingShow(true)
			end
			tableAllID = {}
			CircleCorpsList()
			
		end
		
	end
end

local function initWidget(  )
	local titleName = tolua.cast(m_CorpsApplyList:getWidgetByName("Label_title"),"Label")
	local m_titleNameText = nil
	if chooseNum == 2 then
		m_titleNameText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "军团申请列表", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, -2), 2)
	else
		m_titleNameText = LabelLayer.createStrokeLabel(30, CommonData.g_FONT1, "军团动态", ccp(0, 0), COLOR_Black, ccc3(255,194,30), true, ccp(0, -2), 2)
	end
	
	titleName:addChild(m_titleNameText)

	ListView_Hero = tolua.cast(m_CorpsApplyList:getWidgetByName("ListView_HeroList"),"ListView")
	if ListView_Hero ~= nil then ListView_Hero:setClippingType(1) end

	local m_AllCertainText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "全部同意", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	local m_AllCancelText = LabelLayer.createStrokeLabel(24, CommonData.g_FONT1, "全部拒绝", ccp(0, 0), ccc3(83,28,2), ccc3(255,245,126), true, ccp(0, -2), 2)
	
	local btn_certain = tolua.cast(m_CorpsApplyList:getWidgetByName("Button_certain"),"Button")
	local btn_cancel = tolua.cast(m_CorpsApplyList:getWidgetByName("Button_cancel"),"Button")
	btn_certain:addChild(m_AllCertainText)
	btn_cancel:addChild(m_AllCancelText)
	btn_certain:addTouchEventListener(_Click_AllCertain_CallBack)
	btn_cancel:addTouchEventListener(_Click_AllCancel_CallBack)

	CircleCorpsList()
end

function CreateApplyList(num)
	initData()

	m_CorpsApplyList = TouchGroup:create()
	m_CorpsApplyList:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsApplyList.json"))

	local btn_return = tolua.cast(m_CorpsApplyList:getWidgetByName("Button_Retuen"),"Button")
	btn_return:addTouchEventListener(_Click_Return_CallBack)

	chooseNum = num
	initWidget()
	
	return m_CorpsApplyList
end