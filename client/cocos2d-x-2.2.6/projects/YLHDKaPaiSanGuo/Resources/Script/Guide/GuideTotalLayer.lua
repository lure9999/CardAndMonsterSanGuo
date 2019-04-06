
--指引管理总界面 celina

module("GuideTotalLayer", package.seeall)

require "Script/Guide/GuideTotalData"
require "Script/Guide/GuideTotalLogic"

--变量
local m_TotalLayer = nil 
local tableLayerData = nil 
local m_clone_guide = nil
local m_img_tips = nil
local m_tips_index = 0
--数据
local GetItemNameByType_UI = GuideTotalData.GetItemNameByType
local GetOwnNum_UI         = GuideTotalData.GetOwnNum
local GetRoadData_UI       = GuideTotalData.GetRoadData
local GetIndexByValue_UI   = GuideTotalData.GetIndexByValue
local GetIconPath_UI       = GuideTotalData.GetIconPath
local GetTitleByType_UI    = GuideTotalData.GetTitleByType
local GetDropGuideIndex_UI    = GuideTotalData.GetDropGuideIndex
local GetSubTitle_UI       = GuideTotalData.GetSubTitle

--逻辑
local ToGuideSubUI_UI = GuideTotalLogic.ToGuideSubUI
local GetCopyTimesInfo_UI = GuideTotalLogic.GetCopyTimesInfo
local UpdateAddInfo_UI    = GuideTotalLogic.UpdateAddInfo

local function getCloneGuideRoad(mCloneGuideItem)
	mCloneGuideItem = GUIReader:shareReader():widgetFromJsonFile("Image/GuideManagerItem.json")
	local new_item = mCloneGuideItem:clone()
	local peer = tolua.getpeer(mCloneGuideItem)
	tolua.setpeer(new_item,peer)
	return new_item 

end

local function CreateImgTips(pImgItem)
	if m_img_tips == nil then
		local m_listView = tolua.cast(m_TotalLayer:getWidgetByName("ListView_g"),"ListView")
		m_img_tips = ImageView:create()
		m_img_tips:loadTexture("Image/imgres/item/bg_talk.png")
		local label = Label:create()
		label:setFontSize(20)
		label:setColor(ccc3(51,25,12))
		label:setText("")
		AddLabelImg(label,1,m_img_tips)
		m_img_tips:setPosition(ccp(-25,-10))
		AddLabelImg(m_img_tips,500,pImgItem) 
	else
		m_img_tips:setVisible(true)
	end
	
end
local function InitVars()
	m_TotalLayer = nil 
	tableLayerData = nil 
	m_clone_guide = nil
	m_img_tips = nil
end
local  function CloseLayer()
	m_TotalLayer:removeFromParentAndCleanup(true)
	InitVars()
end
local function _Btn_Guide_CallBack(nGuideIndex)
	CloseLayer()
	ToGuideSubUI_UI(nGuideIndex)
end
local function _Item_Info_CallBack(nIndex,sender)
	if m_tips_index==0 then
		m_tips_index = nIndex
		CreateImgTips(sender)
		UpdateAddInfo_UI(nIndex,m_img_tips)
	else
		if m_tips_index == nIndex then
			--点击同一个 隐藏
			if m_img_tips~=nil then
				m_img_tips:setVisible(false)
			end
			m_tips_index = 0
		else
			if m_img_tips~=nil then
				m_img_tips:removeFromParentAndCleanup(true)
				m_img_tips = nil
			end
			CreateImgTips(sender)
			UpdateAddInfo_UI(nIndex,m_img_tips)
			m_tips_index = nIndex
		end
	end
	
end
local function AddGuideList(index,tabValue ,m_listView)
	local guide_clone_i = getCloneGuideRoad(m_clone_guide)
	local img_item_bg = tolua.cast(guide_clone_i:getChildByName("img_item"),"ImageView")
	
	
	local img_item_icon = tolua.cast(img_item_bg:getChildByName("img_icon"),"ImageView")
	local indexRes  = GetIndexByValue_UI("resID")
	--[[print(tabValue[indexRes])
	Pause()]]--
	img_item_icon:loadTexture(GetIconPath_UI(tabValue[indexRes]))
	--名字
	local Label_title = tolua.cast(img_item_bg:getChildByName("Label_title"),"Label")
	local typeIndex = GetIndexByValue_UI("Type")
	local para4Index = GetIndexByValue_UI("para4")
	local para1Index = GetIndexByValue_UI("para1")
	
	Label_title:setText(GetTitleByType_UI(tabValue[typeIndex],tabValue[para4Index],tabValue[para1Index],tableLayerData))
	m_listView:pushBackCustomItem(guide_clone_i)
	--副本独有
	
	local para2Index = GetIndexByValue_UI("para2")
	local Label_title_add = tolua.cast(img_item_bg:getChildByName("Label_title_add"),"Label")
	Label_title_add:setText(GetCopyTimesInfo_UI(tabValue[typeIndex],tabValue[para1Index],tabValue[para2Index]))
	
	
	local indexTips = GetIndexByValue_UI("Tips")
	local index = GetIndexByValue_UI("index")
	--介绍
	local Label_title_info = tolua.cast(img_item_bg:getChildByName("Label_title_info"),"Label")
	
	
	--Label_title_info:setText(GetSubTitle_UI(GetDropGuideIndex_UI(tabValue[indexTips])))
	Label_title_info:setText(GetSubTitle_UI(tabValue[index]))
	
	--前往的按钮
	local btn_guide = tolua.cast(img_item_bg:getChildByName("btn_guide"),"Button")
	
	
	img_item_bg:setTouchEnabled(true)
	
	--img_item_bg:setTag(TAG_GRID_ADD+GetDropGuideIndex_UI(tabValue[indexTips]))
	img_item_bg:setTag(TAG_GRID_ADD+tabValue[index])
	CreateItemCallBack(img_item_bg,false,_Item_Info_CallBack,nil)
	--CreateBtnCallBack( btn_guide,"前往",25,_Btn_Guide_CallBack, ccc3(84,29,2),ccc3(255,245,126),GetDropGuideIndex_UI(tabValue[indexTips]))
	CreateBtnCallBack( btn_guide,"前往",25,_Btn_Guide_CallBack, ccc3(84,29,2),ccc3(255,245,126),tabValue[index])
end

local function AddGuideRoad()
	local tabGuideRoadData = GetRoadData_UI(tableLayerData)
	local m_listView = tolua.cast(m_TotalLayer:getWidgetByName("ListView_g"),"ListView")
	m_listView:setClippingType(1)
	m_listView:setItemsMargin(5)
	local count = 0
	for key,value in pairs(tabGuideRoadData) do 
		count = count +1
		AddGuideList(key,value,m_listView)
	end
	if count == 0 then
		local labelInfo = Label:create()
		labelInfo:setFontSize(18)
		labelInfo:setFontName(CommonData.g_FONT3)
		labelInfo:setColor(ccc3(51,25,12))
		labelInfo:setPosition(ccp(-262,0))
		labelInfo:setText("该武将或者道具暂无掉落")
		AddLabelImg(labelInfo,1000,m_listView)
	end
end

local function InitUI()
	local img_item = tolua.cast(m_TotalLayer:getWidgetByName("img_item_icon"),"ImageView")
	if tonumber(tableLayerData.nType) == GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN then 
		UIInterface.MakeHeadIcon(img_item, ICONTYPE.COIN_ICON, tableLayerData.itemID, nil)
	else
		UIInterface.MakeHeadIcon(img_item, ICONTYPE.ITEM_ICON, tableLayerData.itemID, nil)
	end
	--名字
	local img_name_bg = tolua.cast(m_TotalLayer:getWidgetByName("img_item_name_bg"),"ImageView")
	local label_itemName = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,GetItemNameByType_UI(tableLayerData.nType,tableLayerData.itemID),ccp(8,3),COLOR_Black,ccc3(255,195,30),true,ccp(0,-2),2)
	AddLabelImg(label_itemName,2,img_name_bg) 
	--拥有数量
	local label_own_num = tolua.cast(m_TotalLayer:getWidgetByName("Label_own_num"),"Label")
	label_own_num:setText(GetOwnNum_UI(tableLayerData))
	
	--获得途径
	AddGuideRoad()
end

local function _Btn_Close_CallBack()
	m_TotalLayer:removeFromParentAndCleanup(true)
	InitVars()
	--MainScene.PopUILayer(false)
end
--tabData[itemID]
--tabData[nType] = {}

function CreateTotalLayer(tabData)
	InitVars()
	m_TotalLayer = TouchGroup:create()									-- 背景层
	m_TotalLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/GuideManagerLayer.json") )
	tableLayerData = tabData
	InitUI()
	local _btn_back = tolua.cast(m_TotalLayer:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack( _btn_back,nil,nil,_Btn_Close_CallBack )
	return m_TotalLayer
end