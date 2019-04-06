require "Script/Main/Item/GetGoodsLayer"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralLvUpData"
--按钮界面
module("ItemBtn", package.seeall)

--变量
local m_type_btn = nil --1，碎片合成，2将魂合成，3将魂炼化、
local btn_callBack = nil
local m_type_box = nil 
--数据
local GetItemEventType 		= ItemData.GetItemEventType
local GetItemEventParaA 	= ItemData.GetItemEventParaA
local GetItemEventParaB 	= ItemData.GetItemEventParaB
local GetPriceByGird        = ItemData.GetPriceByGird
local GetNumByGird          = ItemData.GetNumByGird
local GetTempIDByGrid       = ItemData.GetTempIDByGrid
local GetGoodsRuleByGrid    = ItemData.GetGoodsRuleByGrid
local GetBCanUseByRuleID    = ItemData.GetBCanUseByRuleID
local GetBCanLHByRuleID     = ItemData.GetBCanLHByRuleID



--逻辑
local GetBtnType   = ItemLogic.GetBtnType
local ToSellItem   = ItemLogic.ToSellItem
local ToUseItem    = ItemLogic.ToUseItem
local ToLHHC       = ItemLogic.ToLHHC
local ToSellEquip  = ItemLogic.ToSellEquip
local ToEquipRefining = ItemLogic.ToEquipRefining
local ToLHDanYao    = ItemLogic.ToLHDanYao




local function _Btn_Sell_ItemList_CallBack(nGrid)
	
	if m_type_box < ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		ToSellEquip(nGrid,btn_callBack)
	else
		ToSellItem(nGrid,btn_callBack)
	end
	
end

local function DeleteGuide()
	local btn_right = tolua.cast(ItemListLayer.GetUIControl():getWidgetByName("btn_use"),"Button")
	if btn_right:getParent():getNodeByTag(1990)~=nil then
		btn_right:getParent():getNodeByTag(1990):removeFromParentAndCleanup(true)
	end
end

local function _Btn_Use_ItemList_CallBack( nGrid )
    DeleteGuide()
	ToUseItem(nGrid,btn_callBack)
end
--炼化合成
local function _Btn_LHHC_ItemList_CallBack(nGrid)
	DeleteGuide()
	ToLHHC(nGrid,btn_callBack,m_type_btn)
end
local function _Btn_LH_Equip_CallBack(nGrid)
	--print("功能未开启")
	DeleteGuide()
	--TipCommonLayer.CreateTipsLayer(1006,TIPS_TYPE.TIPS_TYPE_EQUIP,nGrid,nil)
	ToEquipRefining(nGrid,btn_callBack)
end
local function _Btn_LHDanYao_CallBack(nGrid)
	DeleteGuide()
	ToLHDanYao(nGrid,btn_callBack)
end
local function ShowBtnByType(mLayer,nType,nGrid)
	--local m_panel_btn = tolua.cast(mLayer:getWidgetByName("Panel_btn"),"Layout")
	local m_btn_sell = tolua.cast(mLayer:getWidgetByName("btn_sell"),"Button")
	local m_btn_use = tolua.cast(mLayer:getWidgetByName("btn_use"),"Button")
	m_btn_sell:setScale9Enabled(true)
	if tonumber(nType) < ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH or 
		tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP or
		tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH then
		m_btn_sell:setVisible(true)
		m_btn_sell:setTouchEnabled(true)
		m_btn_sell:setSize(CCSize(127,45))
		m_btn_sell:setPosition(ccp(80,38))
		
		m_btn_use:setVisible(true)
		m_btn_use:setTouchEnabled(true)
		m_btn_use:setSize(CCSize(127,45))
		m_btn_use:setPosition(ccp(243,38))
	end
	if tonumber(nType) < ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		--装备只能出售和炼化
		CreateBtnCallBack(m_btn_sell,"出售",20,_Btn_Sell_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
		CreateBtnCallBack(m_btn_use,"炼化",20,_Btn_LH_Equip_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
	else
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP then
			--说明现在是碎片界面
			
			CreateBtnCallBack(m_btn_sell,"出售",20,_Btn_Sell_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
			
			CreateBtnCallBack(m_btn_use,"合成",20,_Btn_LHHC_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
		end 
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH then
			CreateBtnCallBack(m_btn_sell,"出售",20,_Btn_Sell_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
			local str_btn_name = nil 
			if GetBtnType(nType,nGrid) == ItemLogic.ITEM_BTN_TYPE.ITEM_BTN_TYPE_LH then
				str_btn_name = "炼化"
			else
				str_btn_name = "合成"
			end
			CreateBtnCallBack(m_btn_use,str_btn_name,20,_Btn_LHHC_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
		end 
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
			--说明现在是消耗品界面	走rule表
			--按钮为出售和使用或者出售和炼化
			if tonumber(GetGoodsRuleByGrid(nGrid)) == 4 then
				CreateBtnCallBack(m_btn_sell,"出售",20,_Btn_Sell_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
				m_btn_use:setVisible(false)
				m_btn_use:setTouchEnabled(false)
				m_btn_sell:setPosition(ccp(160,38))
				m_btn_sell:setSize(CCSize(187,45))
			else
				m_btn_use:setVisible(true)
				m_btn_use:setTouchEnabled(true)
				m_btn_sell:setSize(CCSize(127,45))
				m_btn_sell:setPosition(ccp(80,38))
				if GetBCanUseByRuleID(GetGoodsRuleByGrid(nGrid))== true then
					CreateBtnCallBack(m_btn_use,"使用",20,_Btn_Use_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
				elseif GetBCanLHByRuleID(GetGoodsRuleByGrid(nGrid)) == true then
					CreateBtnCallBack(m_btn_use,"炼化",20,_Btn_LHDanYao_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
				end	 
				CreateBtnCallBack(m_btn_sell,"出售",20,_Btn_Sell_ItemList_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid,nil,CommonData.g_FONT3)
			
			end
			
		end
	end
	
end
local function SetBtnType(nType,nGrid)
	m_type_box = nType
	m_type_btn = GetBtnType(nType,nGrid)
end

function NewGuideUseItem(nItemID,fCallBack)
	local nGridUse = ItemData.GetItemGridByID(nItemID)
	--ToUseItem(nGridUse,btn_callBack,true)
	local function useOver()	
		if btn_callBack~=nil then
			btn_callBack(nGridUse)
		end
	end
	Packet_UseItem.SetTempIDAndNum(208,1)
	NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_6)
	Packet_UseItem.SetSuccessCallBack(useOver)
	if fCallBack~=nil then
		fCallBack()
	end
end
function CreateItemBtn(mLayer,nGrid,nType,fCallBack)
	btn_callBack = fCallBack
	SetBtnType(nType,nGrid)
	ShowBtnByType(mLayer,nType,nGrid)
	
end