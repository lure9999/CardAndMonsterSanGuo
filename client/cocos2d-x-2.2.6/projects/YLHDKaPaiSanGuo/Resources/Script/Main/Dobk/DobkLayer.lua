--夺宝界面 celina

module("DobkLayer", package.seeall)

require "Script/Main/Dobk/DobkData"
require "Script/Main/Dobk/DobkLogic"

--变量
local m_dobkLayer = nil 
local m_type = nil
local m_org_select_id = nil 
local m_img_select = nil
local m_left_count = 0
local m_right_count = 0
local m_listView = nil
local m_box_sw = nil 
local m_box_bw = nil
--数据
local GetTabSPData = DobkData.GetTabSPData
local GetItemName  = DobkData.GetItemName
local GetItemCount = DobkData.GetItemCount
local GetItemNeedCount = DobkData.GetItemNeedCount
local GetExpendNL   = DobkData.GetExpendNL
local GetLuckNum = DobkData.GetLuckNum
local GetBoxNum = DobkData.GetBoxNum
local GetBoxExp = DobkData.GetBoxExp

--逻辑
local CheckBDobk = DobkLogic.CheckBDobk
local ToDobkSelect = DobkLogic.ToDobkSelect
local ToGetGoods  = DobkLogic.ToGetGoods
local GetDobkLayerData = DobkLogic.GetDobkLayerData
local ToSPHC = DobkLogic.ToSPHC
local GetItemNum = DobkLogic.GetItemNum
local CheckBOpenBox = DobkLogic.CheckBOpenBox


local function InitVars()
	m_dobkLayer = nil 
	m_org_select_id = nil
	m_img_select = nil
	m_right_count = 0
	m_left_count = 0
	m_type = nil
	m_box_sw = nil 
	m_box_bw = nil 
end	

function GetSelectSpID()
	return m_org_select_id
end
function GetSelectSpType()
	return m_type
end
local function _Box_SW_CallBack(sender, eventType)
	if eventType == CheckBoxEventType.selected then 
		m_box_bw:setSelectedState(false)
		if m_type~= DOBK_TYPE.DOBK_TYPE_SW then
			--不是神武界面
			--重新得到数据
			m_org_select_id = nil 
			m_img_select = nil
			--GetDobkLayerData(m_type,UpdateDobkLayer)
			m_type =DOBK_TYPE.DOBK_TYPE_SW
			UpdateDobkLayer()
		end
	else
		if eventType == CheckBoxEventType.unselected then
			if sender:getSelectedState() == false then
				sender:setSelectedState(true)
			end
		end
	end
end
local function _Box_BW_CallBack(sender, eventType)
	if eventType == CheckBoxEventType.selected then 
		m_box_sw:setSelectedState(false)
		if m_type~= DOBK_TYPE.DOBK_TYPE_BW then
			--不是宝物界面
			m_org_select_id = nil 
			m_img_select = nil
			--GetDobkLayerData(m_type,UpdateDobkLayer)
			
			m_type = DOBK_TYPE.DOBK_TYPE_BW
			UpdateDobkLayer()
			
		end
	else
		if eventType == CheckBoxEventType.unselected then
			if sender:getSelectedState() == false then
				sender:setSelectedState(true)
			end
		end
	end
end
--上面的俩按钮 
local function ShowTopBtn()
	m_box_sw = tolua.cast(m_dobkLayer:getWidgetByName("box_sw"),"CheckBox")
	
	local lable_sw = tolua.cast(m_dobkLayer:getWidgetByName("Label_sw"),"Label")
	--lable_sw:setFontName(CommonData.g_FONT1)
	--CreateItemCallBack(img_sw,false,_Img_SW_CallBack,nil)
	
	m_box_sw:addEventListenerCheckBox(_Box_SW_CallBack)
	m_box_bw = tolua.cast(m_dobkLayer:getWidgetByName("box_bw"),"CheckBox")
	
	local lable_bw = tolua.cast(m_dobkLayer:getWidgetByName("Label_bm"),"Label")
	--lable_bw:setFontName(CommonData.g_FONT1)
	
	m_box_bw:addEventListenerCheckBox(_Box_BW_CallBack)
	
	if m_type== DOBK_TYPE.DOBK_TYPE_BW then
		m_box_sw:setSelectedState(false)
		m_box_bw:setSelectedState(true)
	end
	if m_type== DOBK_TYPE.DOBK_TYPE_SW then
		m_box_sw:setSelectedState(true)
		m_box_bw:setSelectedState(false)
	end
end
local function _Img_Box_CallBack(tag,sender)
	if CheckBOpenBox() == false then
		TipLayer.createTimeLayer("背包已满",2)
		return 
	end
	sender:setTouchEnabled(false)
	local img_bg = tolua.cast(sender,"ImageView")
	img_bg:removeAllChildrenWithCleanup(true)
	local function EffectEnd()
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation4", 
			sender, 
			ccp(0, 0),
			nil,
			12)
		if sender:getChildByTag(12)~=nil then
			sender:getChildByTag(12):removeAllChildrenWithCleanup(true)
		end
		
		ToGetGoods(m_type,UpdateDobkLayer)
		sender:setTouchEnabled(true)
	end
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
		"pata_baoxiang01", 
		"Animation3", 
		sender, 
		ccp(0, 0),
		EffectEnd,
		12)
	
end
--宝箱的部分
local function ShowBox()
	local bar_box_count = tolua.cast(m_dobkLayer:getWidgetByName("bar_jd"),"LoadingBar")
	--宝箱的经验条
	bar_box_count:setPercent((GetBoxExp()/10)*100)
	
	
	--箱子的数量
	local label_box_num = tolua.cast(m_dobkLayer:getWidgetByName("Label_num_box"),"Label")
	label_box_num:setText(GetBoxNum())
	local img_box = tolua.cast(m_dobkLayer:getWidgetByName("Image_9"),"ImageView")
	img_box:setTouchEnabled(false)
	img_box:removeAllChildrenWithCleanup(true)
	if tonumber(GetBoxNum()) >0 then
		
		img_box:setTouchEnabled(true)
		CreateItemCallBack(img_box,false,_Img_Box_CallBack,nil)
		if img_box:getChildByTag(1)~= nil then
			img_box:getChildByTag(1):removeAllChildrenWithCleanup(true)
		end
		local function EffectOver()
			CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation2", 
			img_box, 
			ccp(0, 0),
			nil,
			10)
		
		end
		CommonInterface.GetAnimationByName("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation1", 
			img_box, 
			ccp(0, 0),
			EffectOver,
			10)
		
	else
		img_box:setTouchEnabled(false)
		
		if img_box:getChildByTag(1)~= nil then
			img_box:getChildByTag(1):removeAllChildrenWithCleanup(true)
		end
		local function PlayOne(animation)
			animation:playWithIndex(0)
		end
		CommonInterface.GetAnimationToPlay("Image/imgres/effectfile/pata_baoxiang01.ExportJson", 
			"pata_baoxiang01", 
			"Animation1", 
			img_box, 
			ccp(0, 0),
			PlayOne)
		
	end
	
end
local function LoadSelectIcon()
	local img_select_sp = tolua.cast(m_dobkLayer:getWidgetByName("img_sp"),"ImageView")
	UIInterface.MakeHeadIcon(img_select_sp, ICONTYPE.ITEM_COLOR_ICON, m_org_select_id, nil)
	--名字
	local lable_item_name = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,GetItemName(m_org_select_id),ccp(0,4),COLOR_Black,ccc3(255,193,55),true,ccp(0,-3),3)
	--名字背景
	local img_bg_name = tolua.cast(m_dobkLayer:getWidgetByName("img_name_bg"),"ImageView")
	lable_item_name:setPosition(ccp(-15,6))
	AddLabelImg(lable_item_name,2,img_bg_name)
	
	--得到当前的数量
	local nCurCount = GetItemCount(m_org_select_id,m_type)
	local nNeedCount = GetItemNeedCount(m_org_select_id)
	local label_num = tolua.cast(m_dobkLayer:getWidgetByName("Label_num"),"Label")
	label_num:setText(nCurCount.."/"..nNeedCount)
	local percent = nCurCount/nNeedCount
	
	local bar_count_sp = tolua.cast(m_dobkLayer:getWidgetByName("bar_sp"),"LoadingBar")
	if percent*100>100 then
		bar_count_sp:setPercent(100)
	else
		bar_count_sp:setPercent(percent*100)
	end
	
	
	--消耗耐力
	local label_nl = tolua.cast(m_dobkLayer:getWidgetByName("Label_info"),"Label")
	label_nl:setText("X"..GetExpendNL())
end
local function _Btn_Dobk_CallBack()
	local function ToSelect()
		AddLabelImg(DobkSelectLayer.CreateDobkSelectLayer(m_org_select_id),1000,m_dobkLayer)
	end
	ToDobkSelect(m_org_select_id,ToSelect)

	local panel_down = tolua.cast(m_dobkLayer:getWidgetByName("Panel_common_down"),"Layout")

	if panel_down:getNodeByTag(1990) ~= nil then
		panel_down:getNodeByTag(1990):removeFromParentAndCleanup(true)
	end
end

local function _Btn_HC_CallBack()
	--合成完了需要重新请求一下数据
	
	ToSPHC(m_type,m_org_select_id,UpdateDobkLayer)
end
local function ShowBtn()
	local btn_dobk = tolua.cast(m_dobkLayer:getWidgetByName("btn_ld"),"Button")
	local label_btn_name = nil
	if CheckBDobk(m_org_select_id,m_type) == true then
		CreateBtnCallBack(btn_dobk,"夺宝",36,_Btn_Dobk_CallBack,nil,nil,nil,nil)	
	else
		CreateBtnCallBack(btn_dobk,"合成",36,_Btn_HC_CallBack,nil,nil,nil,nil)	
	end
	
end

local function _Item_CallBack(tempID,sender)
	if tonumber(tempID) ~= m_org_select_id then
		m_org_select_id = tonumber(tempID)
		m_img_select:removeFromParentAndCleanup(true)
		m_img_select = nil 
		m_img_select = ImageView:create()
		m_img_select:loadTexture("Image/imgres/item/selected_xie_icon.png")
		AddLabelImg(m_img_select,1,sender)
		LoadSelectIcon()
		ShowBtn()
	end
end
local function _Btn_Right_CallBack()
	local arrayItems = m_listView:getItems()
	
	if m_right_count<arrayItems:count() then
		m_right_count = m_right_count+1 
		m_listView:scrollToPercentHorizontal(55*m_right_count,0.1,true)
	end	
end
local function _Btn_Left_CallBack()
	if m_right_count>0 then
		m_listView:scrollToPercentHorizontal(0,0.1,false)
		m_right_count = m_right_count-1
		m_left_count = m_left_count+1 
	end
	
end
--碎片的滑动部分
local function ShowList()
	--list
	m_listView = tolua.cast(m_dobkLayer:getWidgetByName("ListView_sp"),"ListView")
	m_listView:setClippingType(1)
	m_listView:setItemsMargin(-10)
	
	local listTabData = GetTabSPData(m_type)
	for key,value in pairs (listTabData) do 
		local img_sp = ImageView:create()
		img_sp:setScale(0.68)
		local pControl = UIInterface.MakeHeadIcon(img_sp, ICONTYPE.ITEM_COLOR_ICON, value.itemID, nil)
		pControl:setTag(TAG_GRID_ADD+tonumber(value.itemID))
		CreateItemCallBack(pControl,false,_Item_CallBack,nil)
		m_listView:pushBackCustomItem(img_sp)
	end
	--添加选中框
	if m_org_select_id==nil then
		m_org_select_id = listTabData[1].itemID
	end
	
	if GetItemNum(m_org_select_id,m_type,listTabData)==0 then
		m_org_select_id = listTabData[1].itemID
	end
	
	if m_img_select==nil then
		local num = 0 
		if GetItemNum(m_org_select_id,m_type,listTabData)>0 then
			num = GetItemNum(m_org_select_id,m_type,listTabData)-1
		end
		local item_1 = m_listView:getItem(num)
		m_img_select = ImageView:create()
		m_img_select:loadTexture("Image/imgres/item/selected_xie_icon.png")
		AddLabelImg(m_img_select,1,item_1)
	end
	--左右按钮
	local btn_list_right = tolua.cast(m_dobkLayer:getWidgetByName("btn_right"),"Button")
	CreateItemCallBack(btn_list_right,false,_Btn_Right_CallBack,nil)
	local btn_list_left = tolua.cast(m_dobkLayer:getWidgetByName("btn_left"),"Button")
	CreateItemCallBack(btn_list_left,false,_Btn_Left_CallBack,nil)
	--下面的选中框
	LoadSelectIcon()
end


local function ShowLuckNum()
	--显示幸运草的数量
	local panel_down = tolua.cast(m_dobkLayer:getWidgetByName("Panel_common_down"),"Layout")
	local label_luck_num = LabelLayer.createStrokeLabel(30,CommonData.g_FONT1,"X"..GetLuckNum(),ccp(0,4),COLOR_Black,ccc3(99,216,53),true,ccp(0,-3),3)
	label_luck_num:setPosition(ccp(330,39))
	AddLabelImg(label_luck_num,2,panel_down)
	--[[local img_test = ImageView:create()
	img_test:loadTexture("Image/imgres/wujiang/wj_bg_wen.png")
	img_test:setTextureRect(CCRectMake(0,0,300,40))
	img_test:setPosition(ccp(200,100))
	AddLabelImg(img_test,3,panel_down)]]--
end
--添加指引的代码 
local function AddGuide()
	--夺宝的按钮
	local panel_down = tolua.cast(m_dobkLayer:getWidgetByName("Panel_common_down"),"Layout")
	local btn_dobk = tolua.cast(m_dobkLayer:getWidgetByName("btn_ld"),"Button")

	--指引点击效果
	if panel_down:getNodeByTag(1990) ~= nil then
		panel_down:getNodeByTag(1990):removeFromParentAndCleanup(true)
	end

    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/zhiyin01.ExportJson")
	local GuideAnimation = CCArmature:create("zhiyin01")
	GuideAnimation:getAnimation():play("Animation1")

	GuideAnimation:setPosition(ccp(btn_dobk:getPositionX(), btn_dobk:getPositionY()))

	panel_down:addNode(GuideAnimation, 1990, 1990)

end
local function InitUI()
	
	ShowTopBtn()
	ShowBox()
	ShowList()
	ShowBtn()
	ShowLuckNum()
	
end


function UpdateDobkLayer()
	if m_listView:getItems():count()~= 0 then
		m_listView:removeAllItems()
		m_img_select = nil
	end
	InitUI()
end
local function _Btn_Back_Dobk_CallBack()
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Dobk)
	m_dobkLayer:removeFromParentAndCleanup(true)
	m_dobkLayer = nil
	
	MainScene.PopUILayer()
end
--nType 类型 宝物还是神武 ,选中的物品
function CreateDobkLayer(nType,nSelectID)
	InitVars()
	
	m_dobkLayer = TouchGroup:create()
	m_dobkLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/DobkLayer.json" ) )
	
	if nType~=nil then
		m_type = nType
	else
		m_type = DOBK_TYPE.DOBK_TYPE_SW --默认进来的是神武抢夺
	end
	if nSelectID~=nil then
		m_org_select_id = nSelectID
	end
	if m_type~=nil and m_org_select_id~=nil then
		AddGuide()
	end
	
	InitUI()
	
	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		pBarManager:Create(m_dobkLayer,CoinInfoBarManager.EnumLayerType.EnumLayerType_Dobk)
	end
	
	local btn_back_Dobk = tolua.cast(m_dobkLayer:getWidgetByName("btn_back"),"Button")
	CreateBtnCallBack(btn_back_Dobk,nil,0,_Btn_Back_Dobk_CallBack)
	
	return m_dobkLayer

end