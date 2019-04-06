require "Script/Common/LabelLayer"



module("EquipPropertySuit", package.seeall)


--变量
local m_layer_suit = nil 
local m_panel_suit = nil 
local m_panel_unlock = nil 
local m_img_suit = nil 
--数据
local GetTypeByGrid     = EquipListData.GetTypeByGrid
local GetSuitEpPath     = EquipListData.GetSuitEpPath
local GetSuitNameByGird = EquipListData.GetSuitNameByGird

local GetUnLockValueInfo = EquipPropertyData.GetUnLockValueInfo
local GetSuitInfoByGrid = EquipPropertyData.GetSuitInfoByGrid
local GetSuitLiveInfo   = EquipPropertyData.GetSuitLiveInfo


--常量
E_INFO_TYPE = {
	E_INFO_TYPE_COMMON = 1 ,
	E_INFO_TYPE_SUIT   = 2

}

local function InitVars()
	m_layer_suit = nil 
	m_panel_suit = nil 
	m_panel_unlock = nil 
	m_img_suit = nil 
end

local function showInfo(l_tag,nGrid)
	local table_js = GetUnLockValueInfo(nGrid)
	
	local img_bg_i = nil 
	
	for i=1,#table_js do 
		if l_tag == E_INFO_TYPE.E_INFO_TYPE_COMMON then
			img_bg_i = tolua.cast(m_layer_suit:getWidgetByName("img_js_bg"..i),"ImageView")
		else
			img_bg_i = tolua.cast(m_layer_suit:getWidgetByName("img_js"..i),"ImageView")
		end
		local l_lable_word = nil 
		local str_value = "强化lv."..table_js[i].f_lv..":"..table_js[i].f_info
		if table_js[i].f_bLock == false then
			l_lable_word = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,str_value,ccp(0,0),COLOR_Black,ccc3(219,198,167),true,ccp(0,-1),1)
		else
			l_lable_word = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,str_value,ccp(0,0),COLOR_Black,COLOR_White,true,ccp(0,-1),1)
			img_bg_i:loadTexture("Image/imgres/equip/title_bg.png")
		end
		EquipCommon.AddStrokeLabel(l_lable_word,i,img_bg_i)
		
	end
end
local function showRightSuitInfo(nGrid)
	--名字
	local img_name_bg = tolua.cast(m_layer_suit:getWidgetByName("img_bg_suit_name"),"ImageView")
	local label_name = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,GetSuitNameByGird(nGrid),ccp(-3,0),COLOR_Black,COLOR_White,true,ccp(0,-1),1)
	EquipCommon.AddStrokeLabel(label_name,1,img_name_bg)
	
	local table_suit = GetSuitInfoByGrid(nGrid)
	local count_live = 0 --记录激活的个数
	for i=1,4 do
		local img_ep_suit = tolua.cast(m_layer_suit:getWidgetByName("img_"..i),"ImageView")
		img_ep_suit:loadTexture(GetSuitEpPath(nGrid,"EquipID_"..i))
		local label_name = tolua.cast(m_layer_suit:getWidgetByName("label_suit_name"..i),"Label")
		--品质
		local img_color = ImageView:create()
		--print(table_suit[i].colorPath)
		img_color:loadTexture(table_suit[i].colorPath)
		EquipCommon.AddStrokeLabel(img_color,10+i,img_ep_suit)
		
		--label_name:setFontName(CommonData.g_FONT1)
		label_name:setText(table_suit[i].name)
		if table_suit[i].bLive == false then
			--没有被激活
			
			label_name:setColor(COLOR_Black)
			--背景
			local img_bg = tolua.cast(m_layer_suit:getWidgetByName("img_ep_suit"..i),"ImageView")
			local _Img_bg_sprite = tolua.cast(img_bg:getVirtualRenderer(), "CCSprite")
			MakeRoundIcon(_Img_bg_sprite,"Image/imgres/equip/icon/bottom.png", 1, 1.0)
			--装备图
			local _Img_head_sprite = tolua.cast(img_ep_suit:getVirtualRenderer(), "CCSprite")
			MakeRoundIcon(_Img_head_sprite, GetSuitEpPath(nGrid,"EquipID_"..i), 1, 1.0)
			--品质图
			local _Img_color_sprite = tolua.cast(img_color:getVirtualRenderer(), "CCSprite")
			SpriteSetGray(_Img_color_sprite,1)	
		else
			count_live = count_live +1
			label_name:setColor(ccc3(0,255,79))
			if img_ep_suit:getChildByTag(30) == nil then
				CommonInterface.GetAnimationByName("Image/imgres/effectfile/WJ-wuqikuang.ExportJson", 
					"WJ-wuqikuang", 
					"Animation1", 
					img_ep_suit, 
					ccp(0, 0),
					nil,
					30)
            end
		end
		
	end
	--print("count_live:"..count_live)
	local img_info_bg1 = tolua.cast(m_layer_suit:getWidgetByName("img_num_bg1"),"ImageView")
	local img_info_bg2 = tolua.cast(m_layer_suit:getWidgetByName("img_num_bg2"),"ImageView")
	local img_info_bg3 = tolua.cast(m_layer_suit:getWidgetByName("img_num_bg3"),"ImageView")
	
	local table_now = GetSuitLiveInfo(count_live,nGrid)
	for i=1,#table_now do 
		local img_bg = nil 
		local str_num = nil 
		local pos_now = nil 
		local lable_name_1 = nil
		
		if tonumber(table_now[i].sid) == 2  then
			img_bg = img_info_bg1
			str_num = "装备2件"
			pos_now = ccp(-34,40-i*30)
		end
		if tonumber(table_now[i].sid) == 3  then
			img_bg = img_info_bg2
			str_num = "装备3件"
			pos_now = ccp(-34,40-(i-2)*30)
		end
		if tonumber(table_now[i].sid) == 4  then
			img_bg = img_info_bg3
			str_num = "装备4件"
			pos_now = ccp(-34,52-(i-4)*25)
		end
		
		local lable_info_1 = Label:create() 
		lable_info_1:setFontName(CommonData.g_FONT1)
		lable_info_1:setFontSize(18)
		lable_info_1:setAnchorPoint(ccp(0,0))
		lable_info_1:setTextHorizontalAlignment(0)
		if table_now[i].bLive == false then
			lable_name_1 = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,str_num,ccp(0,55),ccc3(44,36,36),ccc3(161,139,95),true,ccp(0,-1),1)
			lable_info_1:setColor(ccc3(175,150,121))
			
		else
			
			lable_info_1:setColor(COLOR_White)
			lable_name_1 = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,str_num,ccp(0,55),ccc3(44,36,36),ccc3(250,227,62),true,ccp(0,-1),1)
		end
		lable_info_1:setText(table_now[i].info)
		EquipCommon.AddStrokeLabel(lable_name_1,1,img_bg)
		
		lable_info_1:setPosition(pos_now)
		EquipCommon.AddStrokeLabel(lable_info_1,10+i,img_bg)
	end
	
end

--1表示是非套装界面2，表示是套装界面
local function showUnlock(tag,nGrid)
	--解锁属性的字
	local word_bg = nil
	local pos_word = nil
	if tag ==E_INFO_TYPE.E_INFO_TYPE_COMMON then
		word_bg = m_panel_unlock
		pos_word_1 = ccp(14,130)
		pos_word_2 = ccp(14,100)
		pos_word_3 = ccp(14,70)
		pos_word_4 = ccp(14,40)
	else
		pos_word_1 = ccp(-195,-170)
		pos_word_2 = ccp(-195,-200)
		pos_word_3 = ccp(-195,-230)
		pos_word_4 = ccp(-195,-260)
		word_bg = m_img_suit
	end
	
	local lable_unlock_1 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"强",pos_word_1,ccc3(44,36,36),ccc3(219,198,167),false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(lable_unlock_1,1,word_bg)
	
	local lable_unlock_2 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"化",pos_word_2,ccc3(44,36,36),ccc3(219,198,167),false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(lable_unlock_2,2,word_bg)
	
	local lable_unlock_3 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"解",pos_word_3,ccc3(44,36,36),ccc3(219,198,167),false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(lable_unlock_3,3,word_bg)
	
	local lable_unlock_4 = LabelLayer.createStrokeLabel(25,CommonData.g_FONT1,"锁",pos_word_4,ccc3(44,36,36),ccc3(219,198,167),false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(lable_unlock_4,4,word_bg)
	
	--共同的信息
	showInfo(tag,nGrid)
	--print(tag)
	if tag == E_INFO_TYPE.E_INFO_TYPE_SUIT then
		--套装部分的信息
		showRightSuitInfo(nGrid)
	end
end

function createPropertySuit(nGrid)
	InitVars()
	m_layer_suit=EquipPropertyLayer.getEquipLayerControl()
	m_panel_suit = tolua.cast(m_layer_suit:getWidgetByName("Panel_suit_right_up"),"Layout")
	m_panel_unlock = tolua.cast(m_layer_suit:getWidgetByName("Panel_unlock"),"Layout")
	m_img_suit = tolua.cast(m_layer_suit:getWidgetByName("img_bg_right"),"ImageView")
	--[[print("===="..GetTypeByGrid(nGrid))
	
	print(E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT)
	Pause()]]--
	if tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT then
		m_panel_unlock:setVisible(false)
		m_img_suit:setVisible(true)
		showUnlock(E_INFO_TYPE.E_INFO_TYPE_SUIT,nGrid)
	else
		m_panel_unlock:setVisible(true)
		m_img_suit:setVisible(false)
		showUnlock(E_INFO_TYPE.E_INFO_TYPE_COMMON,nGrid)
	end

end