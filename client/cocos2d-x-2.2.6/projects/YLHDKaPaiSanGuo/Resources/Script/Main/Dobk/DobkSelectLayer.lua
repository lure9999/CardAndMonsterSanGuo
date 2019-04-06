--夺宝选择对手界面celina

module("DobkSelectLayer", package.seeall)
require "Script/Main/Dobk/DobkStartLayer"


--变量
local m_layer_dobkSelect = nil 
local m_temp_id = nil 

--数据
local GetDobkListData = DobkData.GetDobkListData

--界面
--local ToStartDobkLayer = DobkStartLayer.CreateDobkFightLayer
 

local function InitVars()

	m_layer_dobkSelect = nil
	m_temp_id = nil
end

function GetSelectLayer()
	return m_layer_dobkSelect
end
local function _Img_Dobk_One_CallBack(key,sender)
	--到抢夺界面（及播放一个抢夺的动画）
	if DobkStartLayer.GetStartLayer() == nil then
		if DobkLogic.CheckNaiLi(1) == true then
			local tableData = GetDobkListData()
			AddLabelImg(DobkStartLayer.CreateDobkFightLayer(tableData[key].eID,tableData[key].modelID,1),100,m_layer_dobkSelect)
		else
			TipLayer.createTimeLayer("耐力不足", 2)	
			return 
		end
	end
end
local function _Img_Dobk_Ten_CallBack(key,sender)
	--抢夺十次
	local tabVIP =  MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_10)
	if tonumber(tabVIP.vipLimit) == 0 then
		local function ToVIP()
			MainScene.GoToVIPLayer(1)
		end
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1505,ToVIP,tabVIP.level,tabVIP.vipLevel)
		pTips = nil
		return 
	end
	if DobkStartLayer.GetStartLayer() == nil then
		if DobkLogic.CheckNaiLi(10) == true then
			local tableTenData = GetDobkListData()
			AddLabelImg(DobkStartLayer.CreateDobkFightLayer(tableTenData[key].eID,tableTenData[key].modelID,10),100,m_layer_dobkSelect)
		else
			TipLayer.createTimeLayer("耐力不足", 2)	
			return
		end
	end
end
local function GetCloneDobkItem()
	local mCloneItem = GUIReader:shareReader():widgetFromJsonFile("Image/DobkItem.json")
	local new_item = mCloneItem:clone()
	local peer = tolua.getpeer(mCloneItem)
	tolua.setpeer(new_item,peer)
	return new_item 
end
local function LoadItems(pItem,tabData,key)
	
	local img_item_bg = tolua.cast(pItem:getChildByName("img_item_bg"),"ImageView")
	
	local headImg = tolua.cast(img_item_bg:getChildByName("img_user"),"ImageView")
	
	UIInterface.MakeHeadIcon(headImg,ICONTYPE.HEAD_ICON,tabData[key].headID, nil,nil,nil,nil)
	
	local img_lv_bg = ImageView:create()
	img_lv_bg:loadTexture("Image/imgres/countrywar/bottom_Black.png")
	img_lv_bg:setPosition(ccp(headImg:getPositionX()-3,headImg:getPositionY()-headImg:getContentSize().height*0.6/2+10))
	AddLabelImg(img_lv_bg,0,img_item_bg)
	local lable_lv = Label:create()--LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,"Lv."..tabData[key].level,ccp(0,4),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	lable_lv:setFontName(CommonData.g_FONT3)
	lable_lv:setFontSize(18)
	lable_lv:setColor(ccc3(255,255,255))
	lable_lv:setPosition(ccp(-6,0))
	lable_lv:setText("Lv."..tabData[key].level)
	AddLabelImg(lable_lv,1,img_lv_bg)
	--名字
	local label_name = tolua.cast(img_item_bg:getChildByName("Label_name"),"Label")
	--label_name:setFontName(CommonData.g_FONT1)
	label_name:setText(tabData[key].name)
	--战斗力
	local label_zdl = tolua.cast(img_item_bg:getChildByName("Label_zdl_num"),"Label")
	label_zdl:setText(tabData[key].power)
	--胜率
	local label_slv = tolua.cast(img_item_bg:getChildByName("Label_sl_num"),"Label")
	label_slv:setText(tonumber(tabData[key].winRate).."%")
	--掠夺十次
	local img_dobk_ten = tolua.cast(img_item_bg:getChildByName("img_dobk_ten_bg"),"ImageView")
	local img_dobk_num_ten = tolua.cast(img_dobk_ten:getChildByName("img_info_bg1"),"ImageView")
	--掠夺一次
	local img_dobk_one = tolua.cast(img_item_bg:getChildByName("img_dobk_bg"),"ImageView")
	local img_dobk_num = tolua.cast(img_dobk_one:getChildByName("img_info_2"),"ImageView")
	--概率图片
	local img_gv = tolua.cast(img_item_bg:getChildByName("img_chance"),"ImageView")
	
	img_dobk_one:setTouchEnabled(true)
	img_dobk_one:setTag(TAG_GRID_ADD+key)
	CreateItemCallBack(img_dobk_one,false,_Img_Dobk_One_CallBack,nil)
	
	local lable_lvduo = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,"掠夺",ccp(0,0),COLOR_Black,ccc3(255,233,131),true,ccp(0,-2),2) 
	AddLabelImg(lable_lvduo,100,img_dobk_num)
	--[[if tonumber(key)<4 then
		img_dobk_ten:setVisible(false)
	end]]--
	if tonumber(key)>1 and tonumber(key)<4 then
		img_gv:loadTexture("Image/imgres/dobk/normal_chance.png")
	end
	if tonumber(key) == 4  then
		img_gv:loadTexture("Image/imgres/dobk/low_chance.png")
	end
	
	img_dobk_ten:setTouchEnabled(true)
	img_dobk_ten:setTag(TAG_GRID_ADD+key)
	CreateItemCallBack(img_dobk_ten,false,_Img_Dobk_Ten_CallBack,nil)
	
	local lable_lvduo_ten = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,"掠十次",ccp(0,0),COLOR_Black,ccc3(255,233,131),true,ccp(0,-2),2) 
	AddLabelImg(lable_lvduo_ten,100,img_dobk_num_ten)
	
	
end
local function InitEnemyData( m_listView )
	local m_listView =  tolua.cast(m_layer_dobkSelect:getWidgetByName("ListView_dobk"),"ListView")
	if m_listView:getItems():count()~=0 then
		m_listView:removeAllItems()
	end
	m_listView:setClippingType(1)
	m_listView:setItemsMargin(7)
	
	local tableList = GetDobkListData()
	for key,value  in pairs(tableList) do 
		local item_clone = GetCloneDobkItem()
		LoadItems(item_clone,tableList,key)
		m_listView:pushBackCustomItem(item_clone)
	end
end
local function _Btn_Flush_CallBack()
	--刷新
	local function flushData()
		InitEnemyData()
	end
	DobkLogic.ToDobkSelect(m_temp_id,flushData)
end
local function InitUI()
	
	
	InitEnemyData()
	--按钮
	local btn_flush = tolua.cast(m_layer_dobkSelect:getWidgetByName("btn_flush"),"ImageView")
	CreateBtnCallBack(btn_flush,"刷新",36,_Btn_Flush_CallBack)
end



local function _Btn_Back_Select_CallBack()
	m_layer_dobkSelect:removeFromParentAndCleanup(true)
	--DobkLogic.GetDobkLayerData(DobkLayer.GetSelectSpType(),DobkLayer.UpdateDobkLayer)
	DobkLayer.UpdateDobkLayer()
end

function CreateDobkSelectLayer(nTempID)
	InitVars()
	m_layer_dobkSelect = TouchGroup:create()
	m_layer_dobkSelect:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/DobkListLayer.json" ) )
	m_temp_id = nTempID
	InitUI()
	local btn_back_Select = tolua.cast(m_layer_dobkSelect:getWidgetByName("btn_back"),"Button")
	CreateBtnCallBack(btn_back_Select,nil,0,_Btn_Back_Select_CallBack)
	
	return m_layer_dobkSelect
end