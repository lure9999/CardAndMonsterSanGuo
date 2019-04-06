require "Script/Common/LabelLayer"
require "Script/Main/Equip/EquipPropertyData"

module("EquipPropertyXilianInfo", package.seeall)

--变量
local m_xilian_layer = nil
local panel_xilian = nil 
--数据
local GetStarLvByGrid = EquipListData.GetStarLvByGrid
local GetXLInfo       = EquipPropertyData.GetXLInfo
local GetStrValueBase = EquipPropertyData.GetStrValueBase
local GetTypeByGrid   = EquipListData.GetTypeByGrid

E_TYPE_LIAN = {
	E_TYPE_LIAN_JL = 1,--表示精炼
	E_TYPE_LIAN_XL = 2 --表示洗练
}


--l_tag1表示精炼，2表示洗练
local function setData(l_tag,nGrid)
	if l_tag == E_TYPE_LIAN.E_TYPE_LIAN_JL then
		--显示星级
		for i = 1 ,10 do 
			local img_star = ImageView:create()
			if i<=GetStarLvByGrid(nGrid) then
				--当前星级
				img_star:loadTexture("Image/imgres/common/star.png")
			else
				img_star:loadTexture("Image/imgres/common/star_black.png")
			end
			if GetStarLvByGrid(nGrid)>0 then 
				img_star:setPosition(ccp(59+i*28,105))
			else
				img_star:setPosition(ccp(59+i*28,58))
			end
			if panel_xilian:getChildByTag(10+i)~=nil then
				panel_xilian:getChildByTag(10+i):setVisible(false)
				panel_xilian:getChildByTag(10+i):removeFromParentAndCleanup(true)
			end
			panel_xilian:addChild(img_star,0,10+i)
		end
		--显示精炼属性
		for i=1,3 do 
			EquipCommon.DeleteImg(panel_xilian,"img"..i)
		end
		if GetStarLvByGrid(nGrid) >0 then
			local table_jl = GetXLInfo(nGrid)
			local count_jl = #table_jl
			for i=1,#table_jl do 
				local img_bg_jl = ImageView:create()
				img_bg_jl:loadTexture("Image/imgres/equip/bg_name_equiped.png")
				if count_jl == 1 then
					img_bg_jl:setPosition(ccp(166,55))
				elseif count_jl == 2 then
					img_bg_jl:setPosition(ccp(166,69-(i-1)*43))
				else
					img_bg_jl:setPosition(ccp(166,84-(i-1)*36))
				end
				img_bg_jl:setName("img"..i)
				EquipCommon.AddStrokeLabel(img_bg_jl,100+i,panel_xilian)
				--[[local img_type_jl = ImageView:create()
				img_type_jl:loadTexture(GetIconPath(table_jl[i].xl_type))
				img_type_jl:setPosition(ccp(-45,0)) 
				EquipCommon.AddStrokeLabel(img_type_jl,i,img_bg_jl)]]--
				local jlName = Label:create()
				jlName:setColor(ccc3(49,31,21))
				jlName:setFontSize(18)
				jlName:setPosition(ccp(-35,0))
				jlName:setText(table_jl[i].xl_name..":")
				EquipCommon.AddStrokeLabel(jlName,i,img_bg_jl)
				
				local str_value_jl = GetStrValueBase(table_jl[i].xl_value,table_jl[i].xl_method)
				local lable_value_jl = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,str_value_jl,ccp(-10,0),COLOR_Black,ccc3(219,198,167),false,ccp(0,-1),1)
				EquipCommon.AddStrokeLabel(lable_value_jl,10+i,img_bg_jl)
			end
			
		end
	elseif l_tag == E_TYPE_LIAN.E_TYPE_LIAN_XL then
		local table_xl = server_equipDB.GetStrengthenByGrid(nGrid)
		local count_xl = 0 
		for i=3 ,#table_xl do
			if table_xl[i]["Type"]~=nil then
				count_xl= count_xl+1
			end
		end
		for i=3 ,#table_xl do 
			if table_xl[i]["Type"]~=nil then
				local img_bg_xl = ImageView:create()
				img_bg_xl:loadTexture("Image/imgres/equip/bg_name_equiped.png")
				if count_xl == 1 then
					img_bg_xl:setPosition(ccp(166,55))
				elseif count_xl == 2 then
					img_bg_xl:setPosition(ccp(166,69-(i-3)*43))
				else
					img_bg_xl:setPosition(ccp(166,99-(i-3)*43))
				end
				EquipCommon.AddStrokeLabel(img_bg_xl,100+i,panel_xilian)
				--[[local img_type_xl = ImageView:create()
				img_type_xl:loadTexture(GetIconPath(table_xl[i]["Type"]))
				img_type_xl:setPosition(ccp(-45,0))
				EquipCommon.AddStrokeLabel(img_type_xl,i,img_bg_xl)]]--
				
				local xlName = Label:create()
				xlName:setColor(ccc3(49,31,21))
				xlName:setFontSize(18)
				xlName:setPosition(ccp(-35,0))
				xlName:setText(GetIconName(table_xl[i]["Type"])..":")
				EquipCommon.AddStrokeLabel(xlName,i,img_bg_xl)
				
				local value_xl = tonumber(table_xl[i]["Value"])+tonumber(table_xl[i]["Add_Value"])
				local str_value_xl = GetStrValueBase(value_xl,0)
				local lable_value_xl = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,str_value_xl,ccp(-10,0),COLOR_Black,ccc3(219,198,167),false,ccp(0,-1),1)
				EquipCommon.AddStrokeLabel(lable_value_xl,10+i,img_bg_xl)
			end
		
		end
	end

end

--tag为1表示精炼，2表示洗练
local function showInfo(tag,nGrid)
	local img_word_bg_xl = tolua.cast(m_xilian_layer:getWidgetByName("img_bg_xl"),"ImageView")
	local str_word = nil 
	if tag == E_TYPE_LIAN.E_TYPE_LIAN_JL then
		str_word = "精炼"
	else
		str_word = "洗炼"
	end
	local lable_word_xl_1 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,str_word,ccp(0,13),ccc3(44,36,36),ccc3(219,198,167),true,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(lable_word_xl_1,1,img_word_bg_xl)
	
	local lable_word_xl_2 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"属性",ccp(0,-13),ccc3(44,36,36),ccc3(219,198,167),true,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(lable_word_xl_2,2,img_word_bg_xl)
	
	setData(tag,nGrid)

end
function createPropertyXilianInfo(nGrid)
	m_xilian_layer = EquipPropertyLayer.getEquipLayerControl()
	panel_xilian = tolua.cast(m_xilian_layer:getWidgetByName("Panel_xl_property"),"Layout")
	--print(EquipData.getEquipType())
	if GetTypeByGrid(nGrid)== E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		panel_xilian:setVisible(true)
		showInfo(E_TYPE_LIAN.E_TYPE_LIAN_JL,nGrid)
	else
		if GetTypeByGrid(nGrid)== E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
			panel_xilian:setVisible(false)
		else
			if GetStarLvByGrid(nGrid) ~= 0 then
				panel_xilian:setVisible(true)
				showInfo(E_TYPE_LIAN.E_TYPE_LIAN_XL,nGrid)
			else
				panel_xilian:setVisible(false)
			end
		end
	end
	
end