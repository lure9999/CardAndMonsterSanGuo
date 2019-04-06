
require "Script/Main/Equip/EquipPropertyLogic"
require "Script/Main/Equip/EquipLogic"
require "Script/Main/Equip/EquipListData"
require "Script/Main/Equip/EquipPropertyBaseInfo"
require "Script/Main/Equip/EquipPropertyAttibutes"
require "Script/Main/Equip/EquipPropertyXilianInfo"
require "Script/Main/Equip/EquipPropertySuit"
require "Script/Main/Equip/EquipOperateLayer"

module("EquipPropertyLayer", package.seeall)


---celina 装备属性界面

--变量
local m_layerEquipProperty = nil 
local m_grid = nil 
local m_layerType = nil 
local interFaceParent = nil 
local itemListCallBack = nil 
local n_pos = nil 

--逻辑

local GetShowBtn  = EquipPropertyLogic.GetShowBtn
local ChangeLayer = EquipLogic.ChangeLayer
local UpDateMatrixBack = EquipLogic.UpDateMatrixBack
local GetBRefine = EquipPropertyLogic.GetBRefine
local CheckXLJL = EquipPropertyLogic.CheckXLJL
local CheckBStrengthen = EquipLogic.CheckBStrengthen
--数据
local GetExampleByGrid = EquipListData.GetExampleByGrid
local GetTypeByGrid    = EquipListData.GetTypeByGrid

--常量


--获得当前layer的对象
function getEquipLayerControl()
	
	return m_layerEquipProperty
end


function ClearMySelf()
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Equip)
	m_layerEquipProperty:removeFromParentAndCleanup(true)
	m_layerEquipProperty = nil
end
--初始化变量
local function InitVars()
	m_layerEquipProperty = nil 
	m_grid = nil 
	m_layerType = nil 
	m_box_type = nil 
	itemListCallBack = nil
	n_pos = nil
end
function GetLayerType()
	return m_layerType
end
local function _Btn_ExEquip_Property_CallBack()
	
	UpDateMatrixBack()
	--点击更换装备
	ClearMySelf()
	MainScene.PopUILayer()
	local posEquip = GetExampleByGrid(m_grid)
	if GetTypeByGrid(m_grid)== E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		posEquip = n_pos
	end
	local interfaceMatrix = EquipListLayer.CreateLayerEquipList(ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP,nil,posEquip)
	--这里不需要加删除因为是多份的
	ChangeLayer( m_layerEquipProperty, interfaceMatrix.m_layer,layerEquipMatrix)
	
end

local function ShowChangeBtn(nType)
	local btn_change = tolua.cast(m_layerEquipProperty:getWidgetByName("btn_change"),"Button")
	if GetShowBtn(nType) == false then
		btn_change:setVisible(false)
		btn_change:setTouchEnabled(false)
	else
		btn_change:setVisible(true)
		btn_change:setTouchEnabled(true)
		CreateBtnCallBack(btn_change,"更换装备",30,_Btn_ExEquip_Property_CallBack)
	end
	
end
local function showLeftInfo()
	--左上的基本信息
	--[[print(m_grid)
	Pause()]]--
	EquipPropertyBaseInfo.createBaseInfoProperty(m_grid)
	--左中的基础信息
	EquipPropertyAttibutes.createPropertyAttibutes(m_grid)
	--左下的洗炼信息
	EquipPropertyXilianInfo.createPropertyXilianInfo(m_grid)
end
local function showRightInfo()
	EquipPropertySuit.createPropertySuit(m_grid)
end
local function ClosePropertyLayer()
	if m_layerType == E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG then
		ClearMySelf()
		MainScene.PopUILayer()
	end
end
local function _Btn_XiLian_Property_CallBack()
	--洗炼或者精炼
	
	local box_type = nil 
	if interFaceParent~=nil then
		box_type = interFaceParent.m_check_box_type
	end
	if GetTypeByGrid(m_grid)==E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		--showOperateLayer(2,2)
		if CheckXLJL(2) == true then
			ClosePropertyLayer()
			MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
			ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_TREASURE,E_OPERATER.E_OPERATER_XILIAN,box_type,m_layerType),layerEquipOperateTag)
		else
			--提示错误
			local tabXL = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_22)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1643,nil,"宝物精炼",tonumber(tabXL.level))
			pTips = nil
		end
	else
		if CheckXLJL(1) == true then
			ClosePropertyLayer()
			MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
			ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_EQUIP,E_OPERATER.E_OPERATER_XILIAN,box_type,m_layerType),layerEquipOperateTag)
		else
			--提示错误
			local tabXL = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_21)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1643,nil,"装备洗练",tonumber(tabXL.level))
			pTips = nil
		end
	end
end
--强化
local function _Btn_Strengthen_Property_CallBack()
	if m_layerType == E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG then
		--Pause()
		ClearMySelf()
		MainScene.PopUILayer()
	end
	local box_type = nil 
	if interFaceParent~=nil then
		box_type = interFaceParent.m_check_box_type
	end
	if GetTypeByGrid(m_grid)== E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
		ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_TREASURE,E_OPERATER.E_OPERATER_STRENGTHEN,box_type,m_layerType),layerEquipOperateTag)
	elseif GetTypeByGrid(m_grid)== E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		--表示要到灵宝界面，灵宝只有强化
		MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
		ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_LINGBAO,E_OPERATER.E_OPERATER_STRENGTHEN,box_type,m_layerType),layerEquipOperateTag)
	else
		MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
		ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_EQUIP,E_OPERATER.E_OPERATER_STRENGTHEN,box_type,m_layerType),layerEquipOperateTag)
	
	end
	
end

function OpenStrengthenGuide(fCallBack)
	if m_layerType == E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG then
		
		ClearMySelf()
		MainScene.PopUILayer()
	end
	local box_type = nil 
	if interFaceParent~=nil then
		box_type = interFaceParent.m_check_box_type
	end
	if GetTypeByGrid(m_grid)== E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
		ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_TREASURE,E_OPERATER.E_OPERATER_STRENGTHEN,box_type,m_layerType),layerEquipOperateTag)
	elseif GetTypeByGrid(m_grid)== E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		--表示要到灵宝界面，灵宝只有强化
		MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
		ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_LINGBAO,E_OPERATER.E_OPERATER_STRENGTHEN,box_type,m_layerType),layerEquipOperateTag)
	else
		MainScene.DeleteUILayer(EquipOperateLayer.GetUIControl())
		ChangeLayer(m_layerEquipProperty,EquipOperateLayer.createEquipOperate(m_grid,E_LAYER_OPERATER.E_LAYER_OPERATER_EQUIP,E_OPERATER.E_OPERATER_STRENGTHEN,box_type,m_layerType),layerEquipOperateTag)
	
	end
	if fCallBack~=nil then
		fCallBack()
	end
end
local function showBtn()
	local panel_btn = tolua.cast(m_layerEquipProperty:getWidgetByName("Panel_btn"),"Layout")
	local btn_qh = tolua.cast(m_layerEquipProperty:getWidgetByName("btn_qh"),"Button")
	local btn_xl = tolua.cast(m_layerEquipProperty:getWidgetByName("btn_xl"),"Button")
	
	if (GetTypeByGrid(m_grid)==E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP) or (GetTypeByGrid(m_grid)==E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT)then
		
		
		btn_qh:setVisible(true)
		btn_qh:setTouchEnabled(true)
		CreateBtnCallBack(btn_qh,"强化",30,_Btn_Strengthen_Property_CallBack)
		
		btn_xl:setVisible(true)
		btn_xl:setTouchEnabled(true)
		CreateBtnCallBack(btn_xl,"洗炼",30,_Btn_XiLian_Property_CallBack)
		
	elseif GetTypeByGrid(m_grid) ==E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		btn_qh:setVisible(true)
		btn_qh:setTouchEnabled(true)
		CreateBtnCallBack(btn_qh,"强化",30,_Btn_Strengthen_Property_CallBack)
		if GetBRefine(m_grid) == true then
			btn_xl:setVisible(true)
			btn_xl:setTouchEnabled(true)
			CreateBtnCallBack(btn_xl,"精炼",30,_Btn_XiLian_Property_CallBack)
			
		else
			btn_xl:setVisible(false)
			btn_xl:setTouchEnabled(false)
		end
	elseif GetTypeByGrid(m_grid) ==E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		btn_qh:setVisible(true)
		btn_qh:setTouchEnabled(true)
		CreateBtnCallBack(btn_qh,"强化",30,_Btn_Strengthen_Property_CallBack)
		
		
		btn_xl:setVisible(false)
		btn_xl:setTouchEnabled(false)
	end
	if CheckBStrengthen(m_grid) == false then
		btn_qh:setVisible(false)
		btn_qh:setTouchEnabled(false)
	end
	if GetBRefine(m_grid) == false then
		btn_xl:setVisible(false)
		btn_xl:setTouchEnabled(false)

	end
	
end

local function InitUI(nLType)
	--更换装备的按钮
	ShowChangeBtn(nLType)
	showLeftInfo()
	showRightInfo()
	--底部的button
	showBtn()
end
function UpdateProperty(nType,nGrid)
	if m_layerEquipProperty~=nil then
		m_grid = nGrid
		InitUI(nType)
	end
end
--返回的回调
local function _Btn_Back_CallBack()
	if m_layerType == E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG then
		UpDateMatrixBack()
	end
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Equip)
	
	m_layerEquipProperty:removeFromParentAndCleanup(true)
	m_layerEquipProperty = nil
	MainScene.PopUILayer()
	if interFaceParent~=nil then
		interFaceParent:UpdateList()
	end
	--道具界面打开的更新道具界面
	if itemListCallBack~=nil and ItemListLayer.GetUIControl()~=nil then
		itemListCallBack(m_grid)
	end
end

local function PageUpdate(nGrid)
	UpdateProperty(m_layerType,nGrid)
end
--左右翻页的回调
local function _Btn_Left_CallBack()
	EquipCommon.PageLeftLogic(m_grid,interFaceParent.m_check_box_type,PageUpdate)
end
local function _Btn_Right_CallBack()
	
	EquipCommon.PageRightLogic(m_grid,interFaceParent.m_check_box_type,PageUpdate)
end
--入口

function CreateEquipProperty(nGrid, nLayerType,parentInterFace,fItemCallBack,nPos)
	InitVars()
	m_layerEquipProperty = TouchGroup:create()
	m_layerEquipProperty:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/Equip_Property_Layer.json"))
	itemListCallBack = fItemCallBack
	m_grid = nGrid
	m_layerType = nLayerType
	interFaceParent = parentInterFace
	n_pos = nPos
	InitUI(nLayerType)
	local btn_back = tolua.cast(m_layerEquipProperty:getWidgetByName("btn_back"),"Button")
	CreateBtnCallBack(btn_back,nil,0,_Btn_Back_CallBack)
	
	
	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		pBarManager:Create(m_layerEquipProperty,CoinInfoBarManager.EnumLayerType.EnumLayerType_Equip)
	end
	--左右按钮
	local btn_left = tolua.cast(m_layerEquipProperty:getWidgetByName("btn_left"),"Button")
	local btn_right = tolua.cast(m_layerEquipProperty:getWidgetByName("btn_right"),"Button")
	
	
	CreateBtnCallBack(btn_left,nil,0,_Btn_Left_CallBack)
	CreateBtnCallBack(btn_right,nil,0,_Btn_Right_CallBack)
	
	if nLayerType == E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG or nLayerType == E_LAYER_TYPE.E_LAYER_TYPE_ITEM then
		btn_left:setVisible(false)
		btn_right:setVisible(false)
		btn_left:setTouchEnabled(false)
		btn_right:setTouchEnabled(false)
	end
	return m_layerEquipProperty

end