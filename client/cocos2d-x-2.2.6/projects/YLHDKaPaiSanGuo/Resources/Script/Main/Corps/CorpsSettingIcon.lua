
require "Script/Main/Corps/CorpsData"
require "Script/Main/Corps/CorpsLogic"
module("CorpsSettingIcon", package.seeall)
--require "Script/Main/Corps/CorpsInfoSetLayer"
local GetIconByLegio = CorpsData.GetIconByLegio
local GetIconDataID = CorpsData.GetIconDataID
local GetIconTableByFile = CorpsData.GetIconTableByFile
local getDataById = CorpsData.getDataById
local GetimsgDataTable = CorpsData.GetimsgDataTable
local GetIndexByField = CorpsData.GetIndexByField
local CreateCommonInfoWidget = CorpsLogic.CreateCommonInfoWidget

local ChangeSettingIcon = nil
tableNum = {}
tableIconPath = {}
local numTag = nil

local function initVars()
	ChangeSettingIcon = nil
	numTag              = nil

end

local function CreateIconItemWidget( pListViewIconTemp )
	local pListViewIcon = pListViewIconTemp:clone()
	local peer = tolua.getpeer(pListViewIconTemp)
	tolua.setpeer(pListViewIcon,peer)
	return pListViewIcon
end

local IconChanged = nil
function ImageIconCallBack(pTag)
	IconChanged = pTag
	return IconChanged
end

local function loadIconInfo()
	local ImaBG = tolua.cast(ChangeIconImageInfo:getWidgetByName("Image_BG"),"ImageView")
	local PanelIcon = tolua.cast(ChangeIconImageInfo:getWidgetByName("Panel_ListView"),"Layout")	
	local IconListView = tolua.cast(PanelIcon:getChildByName("ListView_Item"),"ListView")
	if IconListView ~= nil then IconListView:setClippingType(1) end

	local ListView_Icon = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsItemInfo.json")
	local listiconWidget = CreateCommonInfoWidget(ListView_Icon)
	
	
	--local image_70 = tolua.cast(listiconWidget:getChildByName("Image_70"),"ImageView")
	local image_Icon1 = tolua.cast(listiconWidget:getChildByName("Image_Item1"),"ImageView")
	local image_Icon2 = tolua.cast(listiconWidget:getChildByName("Image_Item2"),"ImageView")
	local image_Icon3 = tolua.cast(listiconWidget:getChildByName("Image_Item3"),"ImageView")
	local image_Icon4 = tolua.cast(listiconWidget:getChildByName("Image_Item4"),"ImageView")
	local image_Icon5 = tolua.cast(listiconWidget:getChildByName("Image_Item5"),"ImageView")

	IconListView:pushBackCustomItem(listiconWidget)
	IconListView:jumpToBottom()

end

local function _Click_LoadICONINFO_CallBack( sender,eventType )
	local ptag = sender:getTag()
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingHideNow()
			-- CorpsInfoSetLayer.ChangedCorpsIconItem(ptag)
			CorpsContentLayer.ChangedCorpsIconItem(ptag)
			CorpsScene.SetHeadIcon(ptag)
			ChangeSettingIcon:removeFromParentAndCleanup(true)
			initVars()
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1415,nil)
			pTips = nil
		end	
		Packet_CorpsSettingInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsSettingInfo.CreatePacket(1,ptag))
		NetWorkLoadingLayer.loadingShow(true)
		
	end
end

local function loadIconItemInfo(  )
	local imgBg = tolua.cast(ChangeSettingIcon:getWidgetByName("Image_BG"),"ImageView")
	local ScrollView_iconItem = tolua.cast(ChangeSettingIcon:getWidgetByName("ScrollView_iconItem"),"ScrollView")
	if ScrollView_iconItem ~= nil then ScrollView_iconItem:setClippingType(1) end
	local tableLegioData = GetIconTableByFile()
	local num = 0

	for key,value in pairs(tableLegioData) do
		num = num + 1
		
	end	

	for i=1,num do
		local iconNum =legioicon.getFieldByIdAndIndex(i,"iconid")
		local iconNumPath = resimg.getFieldByIdAndIndex(iconNum,"icon_path")
		table.insert(tableIconPath,iconNumPath)
		table.insert(tableNum,iconNum)
	end
	
	local NumData = num/5 
	if NumData == 0 then
		NumData = NumData
	else
		NumData = NumData+1
	end

	for i=1,NumData-1 do
		for j=1,5 do
			local IconIndex = ((i - 1)*5) + j

			local iconNumPath = resimg.getFieldByIdAndIndex(tableNum[IconIndex],"icon_path")
			
			local imageKuangBg = ImageView:create()
			imageKuangBg:loadTexture("Image/imgres/equip/icon/bottom.png")
			imageKuangBg:setPosition(ccp(-25 + j*90,750 - (i-1)*90))
			imageKuangBg:setScale(0.68)
			ScrollView_iconItem:addChild(imageKuangBg)

			local imageIconKuang = ImageView:create()
			imageIconKuang:loadTexture("Image/imgres/common/color/wj_pz7.png")
			imageIconKuang:setPosition(ccp(0,0))
			imageKuangBg:addChild(imageIconKuang)

			local imageIcon = ImageView:create()
			imageIcon:loadTexture(iconNumPath)
			imageIcon:setPosition(ccp(0,0))	
			imageIcon:setTag(tableNum[IconIndex])					
			imageIcon:setTouchEnabled(true)
			-- local pControl = UIInterface.MakeHeadIcon(imageIcon,ICONTYPE.CORPS_ICON,nil,nil,nil,tableNum[IconIndex],nil)
			-- pControl:setTag(tonumber(tableNum[IconIndex]))
			-- CreateItemCallBack(pControl,false,_Head_CallBack,nil)
			imageIcon:addTouchEventListener(_Click_LoadICONINFO_CallBack)
			imageIconKuang:addChild(imageIcon)
			
		end
		
	end
	
end

local function _Click_Return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then 
		AudioUtil.PlayBtnClick()
		ChangeSettingIcon:removeFromParentAndCleanup(false)
		
	end
end

function ChangedIconLayer()
	initVars()
	ChangeSettingIcon = TouchGroup:create()
	ChangeSettingIcon:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsItemInfoLayer.json"))
	
	local BtnReturn = tolua.cast(ChangeSettingIcon:getWidgetByName("Button_Return"),"Button")
	BtnReturn:addTouchEventListener(_Click_Return_CallBack)
	loadIconItemInfo()
	return ChangeSettingIcon
end