
require "Script/Common/LabelLayer"
require "Script/Main/Equip/EquipCommon"
require "Script/Main/Equip/EquipPropertyData"

module("EquipPropertyBaseInfo", package.seeall)


--变量

local m_layer_now = nil 
local m_panel_left_up = nil 

--逻辑部分
local IsLockLv = EquipPropertyLogic.IsLockLv
local GetUnLockInfo = EquipPropertyData.GetUnLockInfo

--数据
local GetTempID = EquipListData.GetTempID
local GetColorLvByGrid = EquipListData.GetColorLvByGrid
local GetEquipNameByGrid = EquipListData.GetEquipNameByGrid
local GetEquipedName =  EquipListData.GetEquipedName

--强化加成的部分
local function showQhAdd(nGrid)
	local bg_left_up = tolua.cast(m_layer_now:getWidgetByName("img_bg_up_left"),"ImageView")
	local m_table_qh = GetUnLockInfo(nGrid)
	local count = #m_table_qh
	for i=1,#m_table_qh do 
		local img_bg_i = ImageView:create()
		img_bg_i:loadTexture("Image/imgres/equip/bg_name_equiped.png")
		if count ==1 then
			img_bg_i:setPosition(ccp(63,5-60*i))
		else
			img_bg_i:setPosition(ccp(63,5-40*i))
		end
		if bg_left_up:getChildByTag(100+i)~=nil then
			bg_left_up:getChildByTag(100+i):setVisible(false)
			bg_left_up:getChildByTag(100+i):removeFromParentAndCleanup(true)
		end
		bg_left_up:addChild(img_bg_i,0,100+i)
		local img_type = ImageView:create()
		img_type:loadTexture(GetIconPath(m_table_qh[i].type_ep))
		img_type:setPosition(ccp(-40,0))
		if img_bg_i:getChildByTag(i)~=nil then
			img_bg_i:getChildByTag(i):setVisible(false)
			img_bg_i:getChildByTag(i):removeFromParentAndCleanup(true)
		end
		img_bg_i:addChild(img_type,0,i)
		
		local str_value  = nil 
		if (tonumber(m_table_qh[i].method_ep) == 0) or (tonumber(m_table_qh[i].method_ep) == 2) then
			str_value = "+"..m_table_qh[i].value_ep
		else
			local value = tonumber(m_table_qh[i].value_ep)*100
			str_value = "+"..value.."%"
		end
		local label_value = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,str_value,ccp(20,2),COLOR_Black,ccc3(219,198,167),true,ccp(0,-1),1)
		EquipCommon.AddStrokeLabel(label_value,10+i,img_bg_i)
	end
end

function createBaseInfoProperty(nGird)
	m_layer_now = EquipPropertyLayer.getEquipLayerControl()
	m_panel_left_up = tolua.cast(m_layer_now:getWidgetByName("Panel_left_up"),"Layout")
	
	--装备的图
	local img_equip = tolua.cast(m_layer_now:getWidgetByName("img_ep_property"),"ImageView")
	--[[print("createBaseInfoProperty")
	print(GetTempID(nGird))
	print(nGird)
	Pause()]]--
	local pIcon = UIInterface.MakeHeadIcon(img_equip, ICONTYPE.EQUIP_ICON,GetTempID(nGird) , nGird)
	
	local img_ep_name_bg = tolua.cast(m_layer_now:getWidgetByName("img_name_bg"),"ImageView")
	--装备的名称
	local label_equip_name = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,GetEquipNameByGrid(nGird),ccp(-80,2),COLOR_Black,ccc3(255,192,55),false,ccp(0,-3),3)
	EquipCommon.AddStrokeLabel(label_equip_name,2,img_ep_name_bg)
	
	local l_img_color_bg = tolua.cast(m_layer_now:getWidgetByName("img_property_bg1"),"ImageView")
	--品级
	local l_label_color = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,GetColorLvByGrid(nGird),ccp(20,2),COLOR_Black,ccc3(219,198,167),false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(l_label_color,2,l_img_color_bg)
	--强化加成
	local l_img_qh_bg = tolua.cast(m_layer_now:getWidgetByName("img_property_bg2"),"ImageView")
	
	
	if IsLockLv(nGird) == false then
		l_img_qh_bg:setVisible(false)
		l_img_color_bg:setPosition(ccp(63,-8))
	else
		l_img_qh_bg:setVisible(true)
		l_img_color_bg:setPosition(ccp(63,45))
	end
	
	--装备于
	local l_label_equiped = tolua.cast(m_layer_now:getWidgetByName("label_equiped"),"Label")
	--名字
	local l_label_equiped_name = tolua.cast(m_layer_now:getWidgetByName("label_equiped_name"),"Label")
	if GetEquipedName(nGird) == nil then
		l_label_equiped:setVisible(false)
		l_label_equiped_name:setVisible(false)
	else
		l_label_equiped:setVisible(true)
		l_label_equiped_name:setVisible(true)
		--l_label_equiped:setFontName(CommonData.g_FONT1)
		--l_label_equiped_name:setFontName(CommonData.g_FONT1)
		l_label_equiped_name:setText(GetEquipedName(nGird))
	end
	--强化加成的部分
	showQhAdd(nGird)
end