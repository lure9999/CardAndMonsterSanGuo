require "Script/serverDB/general"
require "Script/Common/CommonData"
require "Script/DB/AnimationData"
require "Script/serverDB/equipt"
require "Script/serverDB/server_equipDB"
require "Script/serverDB/resimg"
require "Script/Main/Equip/EquipOperateData"
require "Script/Main/Equip/EquipListData"
require "Script/Main/Equip/EquipOperateLogic"



module("EquipOperateLayer", package.seeall)


---------------变量
local m_layer_equipOperate = nil
--装备的格子id
local m_Grid_equip = nil
--类型，1说明当前是装备，2 表示当前是宝物
local m_type_cur = nil
--界面类型，1说明当前是强化界面2是精炼或者洗练界面
local m_type_layer = nil
--存放当前的界面
local m_cur_layer = nil

local m_box_qh_equip_operate = nil
local m_box_xl_equip_operate = nil
local m_box_jl_euqip_operate = nil
--存放此件物品相同类型的所有的格子
local m_table_list = nil 
local img_mid = nil --中间部分
local panel_xh = nil --消耗部分
local m_label_name_eped = nil 
local m_img_bg_ep = nil
local m_org_box = nil 
local m_list_box_type = nil 
local m_box_type = nil 
local m_layer_type =nil --区别入口，从哪个界面进来的

local m_coin_type = nil  --区分是哪个界面的货币
---数据
local GetTableListByGird = EquipOperateData.GetTableListByGird
local GetQHLimitLvByGrid = EquipOperateData.GetQHLimitLvByGrid

local GetTempID          = EquipListData.GetTempID
local GetEquipedName     = EquipListData.GetEquipedName
local GetColorLvByGrid     = EquipListData.GetColorLvByGrid
local GetEquipNameByGrid = EquipListData.GetEquipNameByGrid
local GetTypeByGrid      = EquipListData.GetTypeByGrid
local GetCurLvByGird     = EquipListData.GetCurLvByGird

--逻辑
local ToLayerByType      = EquipOperateLogic.ToLayerByType
local ClearTableTreasure = EquipLogic.ClearTableTreasure
local CheckXLJL = EquipPropertyLogic.CheckXLJL

function getImgIcon()
	return m_img_bg_ep
end


--更新装备或者宝物等的基本信息 传入gird
function updateEquipInfo(gird,nCurLv)
	--[[print("gird==============================="..gird)
	Pause()]]--
	local m_str_lv_ep = 0 
	if nCurLv~=nil then
		m_str_lv_ep = nCurLv
	else
		m_str_lv_ep = GetCurLvByGird(gird)
	
	end
	if GetTypeByGrid(gird) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		if tonumber(m_str_lv_ep)==-1 then
			m_str_lv_ep = 0
		end
	end
	m_img_bg_ep = tolua.cast(m_layer_equipOperate:getWidgetByName("img_equip_icon"),"ImageView") 
	local pControl =  UIInterface.MakeHeadIcon(m_img_bg_ep, ICONTYPE.EQUIP_ICON, GetTempID(gird), gird,nCurLv)
	
	local panel_info = tolua.cast(m_layer_equipOperate:getWidgetByName("Panel_info"),"Layout")
	if GetEquipedName(gird)~=nil then
		panel_info:setVisible(true)
		m_label_name_eped:setText(GetEquipedName(gird))
	else
		panel_info:setVisible(false)
	end
	local l_img_bg_name = tolua.cast(m_layer_equipOperate:getWidgetByName("img_bg_equip_name"),"ImageView") 
	m_label_name_ep = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,GetEquipNameByGrid(gird),ccp(-8,7),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(m_label_name_ep,10,l_img_bg_name)
		
	local l_img_bg_color = tolua.cast(m_layer_equipOperate:getWidgetByName("img_color_bg"),"ImageView") 
	m_label_num_color =LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,GetColorLvByGrid(gird),ccp(6,0),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(m_label_num_color,10,l_img_bg_color)
	local str_lv = string.format("%s/%s",m_str_lv_ep,GetQHLimitLvByGrid(gird))
	local l_img_bg_lv = tolua.cast(m_layer_equipOperate:getWidgetByName("img_lv_bg"),"ImageView") 
	m_label_num_lv = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,str_lv,ccp(8,0),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(m_label_num_lv,100,l_img_bg_lv)
end

--传入1表示隐藏精炼的按钮，传入2表示隐藏洗练的按钮 传入3表示精炼和洗炼都隐藏（灵宝只有强化）
local function hideBtn(hide_type)
	if hide_type == E_LAYER_OPERATER.E_LAYER_OPERATER_EQUIP then
		--隐藏精炼的按钮
		if m_box_xl_equip_operate:isVisible() == false then
			m_box_xl_equip_operate:setVisible(true)
			m_box_xl_equip_operate:setTouchEnabled(true)
		end
		if m_box_jl_euqip_operate:isVisible() == true then
			m_box_jl_euqip_operate:setVisible(false)
			m_box_jl_euqip_operate:setTouchEnabled(false)
		end
		
	elseif hide_type == E_LAYER_OPERATER.E_LAYER_OPERATER_TREASURE then
		--隐藏洗练的按钮
		m_box_jl_euqip_operate:setPosition(ccp(942,377))
		if m_box_xl_equip_operate:isVisible() == true then
			m_box_xl_equip_operate:setVisible(false)
			m_box_xl_equip_operate:setTouchEnabled(false)
		end
		if m_box_jl_euqip_operate:isVisible() == false then
			m_box_jl_euqip_operate:setVisible(true)
			m_box_jl_euqip_operate:setTouchEnabled(true)
		end
	elseif hide_type == E_LAYER_OPERATER.E_LAYER_OPERATER_LINGBAO then
		m_box_jl_euqip_operate:setVisible(false)
		m_box_xl_equip_operate:setVisible(false)
		
		m_box_jl_euqip_operate:setTouchEnabled(false)
		m_box_xl_equip_operate:setTouchEnabled(false)
		m_box_xl_equip_operate:setTouchEnabled(false)
	end
end


--显示各个按钮的不同页面
function showBtnLayer(tag_box,mGrid)
	updateEquipInfo(mGrid)
	ToLayerByType(m_layer_equipOperate,tag_box,m_type_cur,mGrid)
end




local function initUI()
	
	hideBtn(m_type_cur)
	showBtnLayer(m_box_type,m_Grid_equip)
	

end
local function UpdateOperate(nGrid)
	m_Grid_equip = nGrid
	ClearTableTreasure()
	initUI()
end
local function _Btn_PageL_CallBack( )
	EquipCommon.PageLeftLogic(m_Grid_equip,m_list_box_type,UpdateOperate)
end
local function _Btn_PageR_CallBack( )
	EquipCommon.PageRightLogic(m_Grid_equip,m_list_box_type,UpdateOperate)
end
local function _Box_EquipOperate_CallBack(nType,sender)
	--需要清空选择的宝物
	if m_org_box:getTag() ~= sender:getTag() then
		m_org_box:setSelectedState(false)
		UpdateObject(m_org_box,sender,sender:getName())
		m_org_box = sender
	end
	if nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_XL then
		--如果是洗炼 那么要判断洗炼按钮是否开了
		if CheckXLJL(1) == false then
			--提示错误
			local tabXL = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_21)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1643,nil,"装备洗练",tonumber(tabXL.level))
			pTips = nil
			return 
		end
	end
	if nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JL then
		--如果是洗炼 那么要判断精炼按钮是否开了
		if CheckXLJL(2) == false then
			--提示错误
			local tabJL = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_22)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1643,nil,"宝物精炼",tonumber(tabJL.level))
			pTips = nil
			return 
		end
	end
	ClearTableTreasure()
	m_box_type = nType
	showBtnLayer(nType,m_Grid_equip)
end

--初始化状态
local function initCheckBoxState(nType)
	if nType == E_OPERATER.E_OPERATER_STRENGTHEN then
		--当前是强化操作
		m_box_qh_equip_operate:setSelectedState(true)
		m_org_box = m_box_qh_equip_operate
		CreateCheckBoxCallBack(m_box_qh_equip_operate,"强化",_Box_EquipOperate_CallBack)
		
	end	
	if nType == E_OPERATER.E_OPERATER_XILIAN then
		if m_type_cur==E_LAYER_OPERATER.E_LAYER_OPERATER_EQUIP then
			m_box_xl_equip_operate:setSelectedState(true)
			m_org_box = m_box_xl_equip_operate
			CreateCheckBoxCallBack(m_box_xl_equip_operate,"洗炼",_Box_EquipOperate_CallBack)
		end
		if m_type_cur==E_LAYER_OPERATER.E_LAYER_OPERATER_TREASURE then
			m_box_jl_euqip_operate:setSelectedState(true)
			m_org_box = m_box_jl_euqip_operate
			CreateCheckBoxCallBack(m_box_jl_euqip_operate,"精炼",_Box_EquipOperate_CallBack)
		end
	end
	m_box_type = GetBoxTypeByName(m_org_box:getName())
end
function UpdateBtn(nGrid)
	--只有洗炼用
	m_box_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_QH
	m_box_qh_equip_operate:setSelectedState(true)
	m_box_xl_equip_operate:setSelectedState(false)
	m_org_box = m_box_qh_equip_operate
	CreateCheckBoxCallBack(m_box_qh_equip_operate,"强化",_Box_EquipOperate_CallBack)
	CreateCheckBoxCallBack(m_box_xl_equip_operate,"洗炼",_Box_EquipOperate_CallBack)
	showBtnLayer(m_box_type,nGrid)
end
local function initData()
	local m_btn_page_l = tolua.cast(m_layer_equipOperate:getWidgetByName("btn_page_l"),"Button")
	local m_btn_page_r = tolua.cast(m_layer_equipOperate:getWidgetByName("btn_page_r"),"Button")
	CreateBtnCallBack(m_btn_page_l,nil,0,_Btn_PageL_CallBack)
	CreateBtnCallBack(m_btn_page_r,nil,0,_Btn_PageR_CallBack)
	
	if m_list_box_type == nil then
		--说明是阵容界面
		m_btn_page_l:setVisible(false)
		m_btn_page_r:setVisible(false)
		
		m_btn_page_l:setTouchEnabled(false)
		m_btn_page_r:setTouchEnabled(false)
	end		
	
	m_box_qh_equip_operate = tolua.cast(m_layer_equipOperate:getWidgetByName("box_qh_epoperate"),"CheckBox") 
	m_box_xl_equip_operate = tolua.cast(m_layer_equipOperate:getWidgetByName("box_xl_epoperate"),"CheckBox") 
	m_box_jl_euqip_operate = tolua.cast(m_layer_equipOperate:getWidgetByName("box_jl_epoperate"),"CheckBox") 

	initCheckBoxState(m_type_layer)
	
	
	CreateCheckBoxCallBack(m_box_qh_equip_operate,"强化",_Box_EquipOperate_CallBack)
	CreateCheckBoxCallBack(m_box_xl_equip_operate,"洗炼",_Box_EquipOperate_CallBack)
	CreateCheckBoxCallBack(m_box_jl_euqip_operate,"精炼",_Box_EquipOperate_CallBack)
	
	m_label_name_eped = tolua.cast(m_layer_equipOperate:getWidgetByName("label_word_name"),"Label")
	--m_label_name_eped:setFontName(CommonData.g_FONT1)
	
	panel_xh = tolua.cast(m_layer_equipOperate:getWidgetByName("Panel_xh"),"Layout")
	img_mid = tolua.cast(m_layer_equipOperate:getWidgetByName("img_mid"),"ImageView")
	local m_label_num_xh = LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,"999999",ccp(199,25),COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(m_label_num_xh,100,panel_xh)
	updateEquipInfo(m_Grid_equip)
end

function GetUIControl()
	return m_layer_equipOperate
end 
local function _Btn_Back_EquipOperate_CallBack( )
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(m_coin_type)
	EquipStrengthen.ClearEquipStrengthen()
	EquipXilianLayer.ClearXLLyaer()
	EquipXilianPlanLayer.ClearXLPlanLayer()
	MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_EQUIP_OPERATER)
	if m_list_box_type == nil then
		--说明是阵容界面	
		--EquipPropertyLayer.ClearMySelf()
		--MainScene.PopUILayer()
		EquipLogic.ClearTableTreasure()
	else	
		EquipPropertyLayer.UpdateProperty(m_layer_type,m_Grid_equip)
	end
	
	
	m_layer_equipOperate:removeFromParentAndCleanup(true)
	m_layer_equipOperate = nil
	MainScene.PopUILayer()
	--MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_EQUIP_OPERATER)
	
end
local function InitVars()
	m_layer_equipOperate = nil
    m_Grid_equip = nil
	m_type_cur = nil
	m_type_layer = nil
    m_box_qh_equip_operate = nil
	m_box_xl_equip_operate = nil
	m_box_jl_euqip_operate = nil
	m_table_list = nil 
	img_mid = nil --中间部分
	panel_xh = nil --消耗部分
	m_label_name_eped = nil 
	m_img_bg_ep = nil
	m_org_box = nil 
	m_box_type = nil 
	m_layer_type = nil
	m_coin_type = nil 
end

function GetPanelXH()
	return panel_xh
end

local function UpdateOperateLayer()
	if EquipStrengthen.GetEquipStrengthenUI()~=nil then
		if EquipStrengthen.GetBUpdate()== false then
			return 
		end
	end
	
	updateEquipInfo(m_Grid_equip,GetCurLvByGird(m_Grid_equip))
end

--类型说明 nGrid,当前装备的格子id，i_type_id 传入类型，1装备，2宝物，3，灵宝 i_btn_type，显示的类型，1强化，2洗练或者精炼
function createEquipOperate(nGrid,i_type_id,i_btn_type,nCheckBoxType,nLayerType)
	InitVars()
	m_layer_equipOperate = TouchGroup:create()
	m_layer_equipOperate:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/EquipOperateLayer.json" ) )
	
	m_Grid_equip = nGrid
	m_type_cur = i_type_id
	m_type_layer = i_btn_type
	m_list_box_type = nCheckBoxType
	m_table_list = GetTableListByGird(nGrid)
	m_layer_type = nLayerType
	initData()
	initUI()
	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		if tonumber(m_type_cur) == 1 then
			if tonumber(m_type_layer) == 1 then
				m_coin_type = CoinInfoBarManager.EnumLayerType.EnumLayerType_EquipQH
				--pBarManager:Create(m_layer_strengthen_equip,CoinInfoBarManager.EnumLayerType.EnumLayerType_EquipQH)
			end
			if tonumber(m_type_layer) == 2 then
				m_coin_type = CoinInfoBarManager.EnumLayerType.EnumLayerType_EquipXiLian
				--pBarManager:Create(m_layer_strengthen_equip,CoinInfoBarManager.EnumLayerType.EnumLayerType_EquipXiLian)
			end
		end
		if tonumber(m_type_cur) == 2 then
			--宝物界面
			if tonumber(m_type_layer) == 1 then
				m_coin_type = CoinInfoBarManager.EnumLayerType.EnumLayerType_TreasureQH
				--pBarManager:Create(m_layer_strengthen_equip,CoinInfoBarManager.EnumLayerType.EnumLayerType_TreasureQH)
			end
			if tonumber(m_type_layer) == 2 then
				m_coin_type = CoinInfoBarManager.EnumLayerType.EnumLayerType_TreasureJL
				--pBarManager:Create(m_layer_strengthen_equip,CoinInfoBarManager.EnumLayerType.EnumLayerType_TreasureJL)
			end
		end
		if tonumber(m_type_cur) == 3 then
			m_coin_type = CoinInfoBarManager.EnumLayerType.EnumLayerType_LingBao
			--pBarManager:Create(m_layer_strengthen_equip,CoinInfoBarManager.EnumLayerType.EnumLayerType_LingBao)
		end
		pBarManager:Create(m_layer_equipOperate,m_coin_type)
	end
	--注册更新
	MainScene.GetObserver():RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_EQUIP_OPERATER,UpdateOperateLayer)
	--将主界面按钮重新加载一次
    require "Script/Main/MainBtnLayer"
    local temp = MainBtnLayer.createMainBtnLayer()
    m_layer_equipOperate:addChild(temp, layerMainBtn_Tag, layerMainBtn_Tag)
	--返回按钮
	
	local btn_back_equipOperate = tolua.cast(m_layer_equipOperate:getWidgetByName("btn_back_ep_oper"),"Button")
	CreateBtnCallBack(btn_back_equipOperate,nil,0,_Btn_Back_EquipOperate_CallBack)
	
	return m_layer_equipOperate
end