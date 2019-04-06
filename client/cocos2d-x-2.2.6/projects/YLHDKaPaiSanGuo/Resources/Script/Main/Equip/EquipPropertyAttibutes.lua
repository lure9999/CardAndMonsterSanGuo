require "Script/Common/LabelLayer"
require "Script/Main/Equip/EquipPropertyData"

module("EquipPropertyAttibutes", package.seeall)

--左中的基础信息
--常量

local m_layer_attibutes = nil 
local m_panel_base = nil 
local img_word_bg = nil 
--数据
local GetBaseInfo = EquipPropertyData.GetBaseInfo
local GetStrValueBase = EquipPropertyData.GetStrValueBase
local GetTypeByGrid = EquipListData.GetTypeByGrid

local function baseUI(nGrid)
	local tabel_xl_add = server_equipDB.GetStrengthenByGrid(nGrid)
	--得到基础的值
	local table_base_now = GetBaseInfo(nGrid)
	local count_base = #table_base_now 
	for i=1,2 do 
		EquipCommon.DeleteImg(m_panel_base,"imgBase"..i)
	end
	for i=1,#table_base_now do 
		local img_bg = ImageView:create()
		img_bg:loadTexture("Image/imgres/equip/bg_name_equiped.png")
		if count_base == 1 then
			img_bg:setPosition(ccp(img_word_bg:getPositionX()+120,45))
		else
			img_bg:setPosition(ccp(img_word_bg:getPositionX()+120,26+(i-1)*43))
		end
		--img_bg:setScaleX(1.2)
		if m_panel_base:getChildByTag(100+i)~=nil then
			m_panel_base:getChildByTag(100+i):setVisible(false)
			m_panel_base:getChildByTag(100+i):removeFromParentAndCleanup(true)
		end
		img_bg:setName("imgBase"..i)
		m_panel_base:addChild(img_bg,0,100+i)
		--[[local img_type_base = ImageView:create()
		img_type_base:loadTexture(GetIconPath(table_base_now[i].base_type))
		img_type_base:setPosition(ccp(-45,0))
		if img_bg:getChildByTag(i)~=nil then
			img_bg:getChildByTag(i):setVisible(false)
			img_bg:getChildByTag(i):removeFromParentAndCleanup(true)
		end
		img_bg:addChild(img_type_base,0,i) ]]--
		
		local baseName = Label:create()
		baseName:setColor(ccc3(49,31,21))
		baseName:setFontSize(18)
		baseName:setPosition(ccp(-35,0))
		if tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
			
			baseName:setText("全队"..table_base_now[i].base_name..":")
		else
			baseName:setText(table_base_now[i].base_name..":")
		end
		EquipCommon.AddStrokeLabel(baseName,i,img_bg)
		local str_value = GetStrValueBase(table_base_now[i].base_value,table_base_now[i].base_method)
		local lable_value = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,str_value,ccp(-10,0),COLOR_Black,ccc3(219,198,167),false,ccp(0,-1),1)
		EquipCommon.AddStrokeLabel(lable_value,10+i,img_bg)
		
		
		local value_xl_add = tabel_xl_add[i]["Add_Value"]
		if tonumber(value_xl_add)~=0 then
			--如果有洗炼附加值
			local lable_value_xl_add = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"(+"..value_xl_add..")",ccp(60,0),ccc3(81,113,39),ccc3(0,255,79),false,ccp(0,-2),2)
			
			EquipCommon.AddStrokeLabel(lable_value_xl_add,50+i,img_bg)
		end
	end
	
end

function createPropertyAttibutes(nGrid)
	--基础属性
	m_layer_attibutes = EquipPropertyLayer.getEquipLayerControl()
	m_panel_base = tolua.cast(m_layer_attibutes:getWidgetByName("Panel_base_property"),"Layout")
	img_word_bg = tolua.cast(m_layer_attibutes:getWidgetByName("img_bg_base"),"ImageView")
	local lable_word_attibutes_1 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"基础",ccp(0,13),ccc3(44,36,36),ccc3(219,198,167),true,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(lable_word_attibutes_1,1,img_word_bg)
	
	local lable_word_attibutes_2 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"属性",ccp(0,-13),ccc3(44,36,36),ccc3(219,198,167),true,ccp(0,-2),2)
	
	EquipCommon.AddStrokeLabel(lable_word_attibutes_2,2,img_word_bg)
	baseUI(nGrid)
	
end
