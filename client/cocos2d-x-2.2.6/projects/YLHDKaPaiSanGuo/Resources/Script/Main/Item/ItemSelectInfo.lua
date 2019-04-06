
--选中的物品的信息

module("ItemSelectInfo", package.seeall)


require "Script/Main/Equip/EquipListData"
--require "Script/Main/Equip/EquipPropertyLayer"
require "Script/Main/Equip/EquipListLayer"
require "Script/Main/Equip/EquipLogic"

--变量
local m_layer = nil 
local fListCallBack = nil
--数据物品
local GetTempIDByGrid = ItemData.GetTempIDByGrid
local GetNameByTempId = ItemData.GetNameByTempId
local GetNumByGird    = ItemData.GetNumByGird
local GetNumJHunByGird = ItemData.GetNumJHunByGird
local GetBHaveWJ       = ItemData.GetBHaveWJ
local GetDesByGird     = ItemData.GetDesByGird
local GetPriceByGird   = ItemData.GetPriceByGird
--装备的数据
local GetTempID_Equip    = EquipListData.GetTempID
local GetEquipNameByGrid_Equip = EquipListData.GetEquipNameByGrid
local GetColorLvByGrid_Equip  = EquipListData.GetColorLvByGrid
local GetTipsByGrid_Equip     = EquipListData.GetTipsByGrid
local GetSellPriceByGrid_Equip = EquipListData.GetSellPriceByGrid

local  CreateEquipProperty = EquipPropertyLayer.CreateEquipProperty
local ChangeLayer = EquipLogic.ChangeLayer

--逻辑
local ToGuideTotal_UI = ItemLogic.ToGuideTotal

--20150222 增加指引
--[[local function _Btn_Icon_CallBack(nGrid,sender)
	ToGuideTotal_UI(sender,nGrid) 

end]]--
local function ShowItemInfo(mLayer,nGrid,nType)
	local m_img_item = tolua.cast(mLayer:getWidgetByName("img_item"),"ImageView")
	m_img_item:removeAllChildrenWithCleanup(true)
	local pControl = UIInterface.MakeHeadIcon(m_img_item, ICONTYPE.ITEM_ICON,GetTempIDByGrid(nGrid) )
	pControl:setTag(TAG_GRID_ADD+tonumber(nGrid))
	ToGuideTotal_UI(pControl,nGrid)
	--CreateItemCallBack(pControl,false,_Btn_Icon_CallBack,nil)
	local img_name_bg = tolua.cast(mLayer:getWidgetByName("img_name_bg"),"ImageView")
	local lable_name = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,GetNameByTempId(GetTempIDByGrid(nGrid)),ccp(13,3),COLOR_Black,ccc3(255,192,55),true,ccp(0,-2),2)
	AddLabelImg(lable_name,2,img_name_bg)
	--数量
	local lableColorLv =  tolua.cast(mLayer:getWidgetByName("label_num_own"),"Label")
	lableColorLv:setText("持有")
	local img_num_bg = tolua.cast(mLayer:getWidgetByName("img_num_bg"),"ImageView")
	local own_num = nil
	local need_num = nil 
	local str_num = nil 
	local lable_num = nil 
	if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		own_num = GetNumByGird(nGrid)
		str_num = tostring(own_num)
		lable_num = LabelLayer.createStrokeLabel(24,CommonData.g_FONT3,str_num,ccp(13,3),COLOR_Black,ccc3(219,198,167),true,ccp(0,-2),2)
	end
	if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP then
		need_num = GetNumJHunByGird(nGrid)
		own_num = GetNumByGird(nGrid)
		
		str_num = string.format("%d/%d",own_num,need_num)
		if tonumber(own_num)<tonumber(need_num) then
			lable_num = LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,str_num,ccp(13,3),ccc3(23,5,5),ccc3(255,87,35),true,ccp(0,-2),2)
		else
			lable_num = LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,str_num,ccp(13,3),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
		
		end
	end
	if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH then
		need_num = GetNumJHunByGird(nGrid)
		own_num = GetNumByGird(nGrid)
		if GetBHaveWJ(nGrid) == true then
			--只能炼化
			str_num = tostring(own_num)
			lable_num = LabelLayer.createStrokeLabel(24,CommonData.g_FONT3,str_num,ccp(13,3),COLOR_Black,ccc3(219,198,167),true,ccp(0,-2),2)
		else
			str_num = string.format("%d/%d",own_num,need_num)
			if tonumber(own_num)<tonumber(need_num) then
				lable_num = LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,str_num,ccp(13,3),ccc3(23,5,5),ccc3(255,87,35),true,ccp(0,-2),2)
			else
				lable_num = LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,str_num,ccp(13,3),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
			
			end
		end
	end
	
	AddLabelImg(lable_num,2,img_num_bg)
	--描述
	local lable_des = tolua.cast(mLayer:getWidgetByName("Label_item_info"),"Label")
	lable_des:setText(GetDesByGird(nGrid))
	--价格
	local img_sliver_bg = tolua.cast(mLayer:getWidgetByName("img_price_bg"),"ImageView")
	local label_num_sliver = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,GetPriceByGird(nGrid),ccp(0,0),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
	AddLabelImg(label_num_sliver,2,img_sliver_bg)
end
local function _Btn_Icon_Equip_CallBack(nGrid,sender)
	--跳到装备属性界面
	ChangeLayer(m_layer,CreateEquipProperty(nGrid,E_LAYER_TYPE.E_LAYER_TYPE_ITEM,nil,fListCallBack),layerEquipProperty_Tag)
end
local function ShowEquipInfo(mLayer,nGrid)
	local m_img_equip = tolua.cast(mLayer:getWidgetByName("img_item"),"ImageView")
	m_img_equip:removeAllChildrenWithCleanup(true)
	local pClickControl = UIInterface.MakeHeadIcon(m_img_equip, ICONTYPE.EQUIP_ICON,GetTempID_Equip(nGrid) ,nGrid )
	pClickControl:setTag(TAG_GRID_ADD+tonumber(nGrid))
	CreateItemCallBack(pClickControl,false,_Btn_Icon_Equip_CallBack,nil)
	--名字
	local img_name_bg = tolua.cast(mLayer:getWidgetByName("img_name_bg"),"ImageView")
	local lable_name = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,GetEquipNameByGrid_Equip(nGrid),ccp(13,3),COLOR_Black,ccc3(255,192,55),true,ccp(0,-2),2)
	AddLabelImg(lable_name,2,img_name_bg)
	--品级
	local lableColorLv =  tolua.cast(mLayer:getWidgetByName("label_num_own"),"Label")
	lableColorLv:setText("品级")
	local img_lv_bg = tolua.cast(mLayer:getWidgetByName("img_num_bg"),"ImageView")
	local lable_colorLv = LabelLayer.createStrokeLabel(24,CommonData.g_FONT3,GetColorLvByGrid_Equip(nGrid),ccp(13,3),COLOR_Black,ccc3(219,198,167),true,ccp(0,-2),2)
	AddLabelImg(lable_colorLv,2,img_lv_bg)
	--描述
	local lable_des = tolua.cast(mLayer:getWidgetByName("Label_item_info"),"Label")
	lable_des:setText(GetTipsByGrid_Equip(nGrid))
	--价格
	local img_sliver_bg = tolua.cast(mLayer:getWidgetByName("img_price_bg"),"ImageView")
	local label_num_sliver = LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,GetSellPriceByGrid_Equip(nGrid),ccp(0,0),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)
	AddLabelImg(label_num_sliver,2,img_sliver_bg)
end

function CreateSelectInfo(mLayer,nGrid,nType,fCallBack)
	m_layer= mLayer
	local m_panel_info = tolua.cast(mLayer:getWidgetByName("Panel_xh"),"Layout")
	m_panel_info:setVisible(true)
	local m_panel_btn = tolua.cast(mLayer:getWidgetByName("Panel_btn"),"Layout")
	m_panel_btn:setVisible(true)
	local btn_sell = tolua.cast(mLayer:getWidgetByName("btn_sell"),"Button")
	local btn_use = tolua.cast(mLayer:getWidgetByName("btn_use"),"Button")
	btn_sell:setTouchEnabled(true)
	btn_use:setTouchEnabled(true)
	fListCallBack = fCallBack
	if tonumber(nType) >= ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		ShowItemInfo(mLayer,nGrid,nType)
	else
		ShowEquipInfo(mLayer,nGrid,nType)
	end
	
end
