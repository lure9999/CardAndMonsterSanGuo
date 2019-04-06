
require "Script/Main/Equip/EquipStrengthen"
require "Script/Main/Equip/TreasureStrengthen"
require "Script/Main/Equip/LingBaoStrengthen"
require "Script/Main/Equip/TreasureRefine"
require "Script/Main/Equip/EquipXilianLayer"

module("EquipOperateLogic", package.seeall)

local GetEquipedName = EquipListData.GetEquipedName



local function addLayerOn(mLayerNow,mLayerNew)
	if mLayerNow:getChildByTag(layerEquipStrengthen_Tag)~=nil then
		mLayerNow:getChildByTag(layerEquipStrengthen_Tag):setVisible(false)
		mLayerNow:getChildByTag(layerEquipStrengthen_Tag):removeFromParentAndCleanup(true)
	end
	if mLayerNew ~= nil then
		mLayerNew:setPosition(ccp(170,40))
		mLayerNow:addChild(mLayerNew,layerEquipStrengthen_Tag,layerEquipStrengthen_Tag)
	end
end
--checkBox的类型
--nTagType 是装备还是宝物，或者灵宝
--nGrid 格子
function ToLayerByType(m_layer_now,nTagBox,nTagType,nGrid)
	local newLayer = nil 
	local panel_xh = tolua.cast(m_layer_now:getWidgetByName("Panel_xh"),"Layout")
	local img_mid = tolua.cast(m_layer_now:getWidgetByName("img_mid"),"ImageView")
	panel_xh:setVisible(true)
	img_mid:setVisible(true)
	if nTagBox == ENUM_TYPE_BOX.ENUM_TYPE_BOX_QH then
		--强化到强化界面
		if nTagType == E_LAYER_OPERATER.E_LAYER_OPERATER_EQUIP then
			newLayer = EquipStrengthen.createStrengthenEquip(nGrid)
		end
		if nTagType == E_LAYER_OPERATER.E_LAYER_OPERATER_TREASURE then
			if StrengthenNarmalLayer.GetBwSelectLayer()~=nil then
				MainScene.DeleteUILayer(StrengthenNarmalLayer.GetBwSelectLayer().m_layer)
				StrengthenNarmalLayer.ClearInterFace()
			end
			if TreasureStrengthen.GetTreasureUI()~=nil then
				--删掉coinBar
				local pBarManager = MainScene.GetBarManager()
				pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_TreasureQH)
			end
			newLayer = TreasureStrengthen.createTreasureStrengthen(nGrid)
		end
		if nTagType == E_LAYER_OPERATER.E_LAYER_OPERATER_LINGBAO then
			newLayer = LingBaoStrengthen.CreateLingBaoStrengthen(nGrid)
		end
	elseif nTagBox == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JL then
		newLayer = TreasureRefine.CreateTreasureRefine(nGrid)
		
	elseif nTagBox == ENUM_TYPE_BOX.ENUM_TYPE_BOX_XL then
		if EquipStrengthen.GetEquipStrengthenUI() ~= nil then
			EquipStrengthen.GetEquipStrengthenUI():removeFromParentAndCleanup(true)
			EquipStrengthen.ClearEquipStrengthen()
		end
		
		newLayer = EquipXilianLayer.CreateXilianEquip(nGrid)
		panel_xh:setVisible(false)
		img_mid:setVisible(false)
	end
	addLayerOn(m_layer_now,newLayer)
	if  nTagBox == ENUM_TYPE_BOX.ENUM_TYPE_BOX_XL then
		newLayer:setPosition(ccp(168,28))
	end
	if nTagBox~= ENUM_TYPE_BOX.ENUM_TYPE_BOX_XL then
		local img_xl = tolua.cast(m_layer_now:getWidgetByName("img_xh_icon"),"ImageView")
		img_xl:setTouchEnabled(true)
		local pGuideXH = GuideRegisterManager.RegisterGuideManager()
		pGuideXH:RegisteGuide(img_xl,1,GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN)
		pGuideXH = nil
	end
end
--更新消耗的银币数量num,数量，tag1表示银币数量够，2表示银币数量不够
function SetSliverNum(num,tag,object,order)
	local panel_xh = EquipOperateLayer.GetPanelXH()
	if object==nil then
		if tag == 1 then
			local m_label_num_xh = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,num,ccp(199,25),COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
			EquipCommon.AddStrokeLabel(m_label_num_xh,100,panel_xh)
		elseif tag == 2 then
			local m_label_num_xh = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,num,ccp(199,25),ccc3(23,5,5),ccc3(255,87,35),false,ccp(0,-2),2)
			EquipCommon.AddStrokeLabel(m_label_num_xh,100,panel_xh)
		else
			panel_xh:setVisible(false)
		end
	else
		local pos = nil 
		if order ==1 then
			--print("=====1=======")
			pos = ccp(400,26)
			if object:getChildByTag(110)~= nil then
				object:getChildByTag(110):setVisible(false)
				object:removeChildByTag(110,true)
			end 
			if object:getChildByTag(112)~= nil then
				object:getChildByTag(112):setVisible(false)
				object:removeChildByTag(112,true)
			end
		else
			pos = ccp(520,26)
			if object:getChildByTag(111)~= nil then
				object:getChildByTag(111):setVisible(false)
				object:removeChildByTag(111,true)
			end
			
			if object:getChildByTag(113)~= nil then
				object:getChildByTag(113):setVisible(false)
				object:removeChildByTag(113,true)
			end
		end
		
		if order~=2 then
			if object:getChildByTag(111)~= nil then
				object:getChildByTag(111):setVisible(false)
				object:removeChildByTag(111,true)
			end
			
			if object:getChildByTag(113)~= nil then
				object:getChildByTag(113):setVisible(false)
				object:removeChildByTag(113,true)
			end
		end
		
		if tag == 1 then
			
			if order ==2 then
				local m_label_num_xh2 = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,num,pos,COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
				EquipCommon.AddStrokeLabel(m_label_num_xh2,111,object)
			else
				local m_label_num_xh1 = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,num,pos,COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
				EquipCommon.AddStrokeLabel(m_label_num_xh1,110,object)
			end
		else
			
			if order ==2 then
				local m_label_num_xh2 = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,num,pos,COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
				EquipCommon.AddStrokeLabel(m_label_num_xh2,113,object)
			else
				local m_label_num_xh = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,num,pos,ccc3(23,5,5),ccc3(255,87,35),false,ccp(0,-2),2)
				EquipCommon.AddStrokeLabel(m_label_num_xh,112,object)
			end
		end
	end
end

