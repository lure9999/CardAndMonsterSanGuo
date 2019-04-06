require "Script/Common/CommonData"
require "Script/Main/Equip/EquipStrengthenLogic"
require "Script/Main/Equip/EquipListData"
require "Script/Main/Equip/EquipOperateData"
--require "Script/Main/Equip/EquipOperateLogic"

module("EquipStrengthen", package.seeall)


--变量
local m_layer_strengthen_equip = nil
local m_grid_strengthen        = nil 
local bUpdate = true

--数据
local GetCurLvByGird     = EquipListData.GetCurLvByGird
local GetTempID          = EquipListData.GetTempID
local GetValueBase       = EquipOperateData.GetValueBase
local GetBaseNameByGrid  = EquipListData.GetBaseNameByGrid

--逻辑
local GetBLimitLayerByGrid = EquipStrengthenLogic.GetBLimitLayerByGrid
local GetBHaveBaseByGrid   = EquipStrengthenLogic.GetBHaveBaseByGrid
local ShowExpendMoney      = EquipStrengthenLogic.ShowExpendMoney
local GetUnlockState       = EquipStrengthenLogic.GetUnlockState
local Post_Packet_Strengthen = EquipStrengthenLogic.Post_Packet_Strengthen
local CheckBCanStrengthen   = EquipStrengthenLogic.CheckBCanStrengthen
local RunAutoStrengthenAction = EquipStrengthenLogic.RunAutoStrengthenAction
local GetBaseValueNoAdd       = EquipStrengthenLogic.GetBaseValueNoAdd
local RunActionEquipStrengthen = EquipStrengthenLogic.RunActionEquipStrengthen
local SetUnlockLvNow    = EquipStrengthenLogic.SetUnlockLvNow
local CheckBAutoQH      = EquipStrengthenLogic.CheckBAutoQH


function GetEquipStrengthenUI()
	return m_layer_strengthen_equip
end	
function GetBUpdate()
	return bUpdate
end
function SetBUpdate(bUp)
	bUpdate = bUp
end
local function SetValueBaseInfo(nGrid,objectName,objectValue,strBase,nCurLv)
	if GetBHaveBaseByGrid(nGrid,strBase) == true then
		objectName:setText(GetBaseNameByGrid(nGrid,strBase))
		if nCurLv~=nil then
			GetBaseValueNoAdd(nGrid,strBase,nCurLv,objectValue,2)
		else
			GetBaseValueNoAdd(nGrid,strBase,GetCurLvByGird(nGrid),objectValue,2)
		end
		
	else
		objectName:setVisible(false)
		objectValue:setVisible(false)
	end
end
local function showLLv(nGrid,nCurLv)
	local m_label_num_lv_cur = tolua.cast(m_layer_strengthen_equip:getWidgetByName("label_lv_cur"),"Label")
	if nCurLv~=nil then
		m_label_num_lv_cur:setText(nCurLv)
	else
		m_label_num_lv_cur:setText(GetCurLvByGird(nGrid))
	end
	
	--基础属性1
	local m_label_word_base1 = tolua.cast(m_layer_strengthen_equip:getWidgetByName("label_word_life_cur"),"Label")
    local m_label_num_base1 = tolua.cast(m_layer_strengthen_equip:getWidgetByName("label_num_life_cur"),"Label")
	--基础属性2
	local m_label_word_base2 = tolua.cast(m_layer_strengthen_equip:getWidgetByName("label_word_att_cur"),"Label")
    local m_label_num_base2 = tolua.cast(m_layer_strengthen_equip:getWidgetByName("label_num_att_cur"),"Label")
	
	SetValueBaseInfo(nGrid,m_label_word_base1,m_label_num_base1,"BaseAttitude_1",nCurLv)
	SetValueBaseInfo(nGrid,m_label_word_base2,m_label_num_base2,"BaseAttitude_2",nCurLv)
end
local function showRLv(nGrid,nCurLv)
	local m_img_r = tolua.cast(m_layer_strengthen_equip:getWidgetByName("img_r"),"ImageView")
	
	local m_label_lv = tolua.cast(m_layer_strengthen_equip:getWidgetByName("label_lv_next"),"Label")
	
	local nLv = 0 
	if nCurLv~=nil then
		nLv = tonumber(nCurLv)+1
	else
		nLv = tonumber(GetCurLvByGird(nGrid))+1
	end
	m_label_lv:setText(nLv)
	
	for i=1,2 do 
		local str_word = nil 
		if i==1 then
			str_word = "label_word_life_next"
		else
			str_word = "label_word_att_next"
		end
		local m_lable_next = tolua.cast(m_layer_strengthen_equip:getWidgetByName(str_word),"Label")
		local img_up = tolua.cast(m_layer_strengthen_equip:getWidgetByName("img_up"..i),"ImageView")
		
		if GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i) == true then
			m_lable_next:setText(GetBaseNameByGrid(nGrid,"BaseAttitude_"..i))
			local pos = ccp(0,0)
			if i== 1 then
				pos = ccp(-10,-5)
			else
				pos= ccp(-10,-32)
			end
			if tonumber(nLv)>100 then
				nLv = 100
			end
			local m_label_num_base_next = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,GetValueBase(nGrid,"BaseAttitude_"..i,nLv),pos,ccc3(81,113,39),ccc3(0,255,79),false,ccp(0,-2),2)
			EquipCommon.AddStrokeLabel(m_label_num_base_next,10+i,m_img_r)
		else
			m_lable_next:setVisible(false)
			img_up:setVisible(false)
		end
	end
	
end

local function ShowEquipStrengthen(nGrid,nCurLv)
	if GetBLimitLayerByGrid(nGrid,nCurLv) == true then
		m_layer_strengthen_equip:removeAllChildrenWithCleanup(true)
		TreasureStrengthenLogic.AddNewLayer(m_layer_strengthen_equip,StrengthenLimitUI.createStrengthenLimitUI(nGrid))
	else
		showLLv(nGrid,nCurLv)
		showRLv(nGrid,nCurLv)
		if nCurLv~=nil then
			ShowExpendMoney(nGrid,nCurLv)
		else
			ShowExpendMoney(nGrid,GetCurLvByGird(nGrid))
		end
	end
	
end


local function ToStrengthen(nTag)
	local orgLV = GetCurLvByGird(m_grid_strengthen)
	local function StrengthenCallBack(tableLv)
		if tableLv ==nil then
			--说明是强化
			RunActionEquipStrengthen(orgLV,m_grid_strengthen,nil,m_layer_strengthen_equip)
		else
			--说明是自动强化
			RunAutoStrengthenAction(m_layer_strengthen_equip,m_grid_strengthen,tableLv,orgLV)
		end
	end
	Post_Packet_Strengthen(m_grid_strengthen,nTag,StrengthenCallBack)

end

function ToStrengthenByNewGuide(fCallBack)
	local orgLV = GetCurLvByGird(m_grid_strengthen)
	local function StrengthenCallBack(tableLv)
		if tableLv ==nil then
			--说明是强化
			RunActionEquipStrengthen(orgLV,m_grid_strengthen,nil,m_layer_strengthen_equip)
			if fCallBack~=nil then
				fCallBack()
			end
		else
			--说明是自动强化
			RunAutoStrengthenAction(m_layer_strengthen_equip,m_grid_strengthen,tableLv,orgLV)
		end
	end
	Post_Packet_Strengthen(m_grid_strengthen,EquipStrengthenLogic.E_STRENGTHEN_TYPE.E_STRENGTHEN_TYPE_NORMAL,StrengthenCallBack,true)
end

local function _Btn_Strengthen_CallBack( )
	--如果有解锁效果，那么解锁效果消失才能强化
	if CheckBCanStrengthen(m_grid_strengthen) == true then
		ToStrengthen(EquipStrengthenLogic.E_STRENGTHEN_TYPE.E_STRENGTHEN_TYPE_NORMAL)
	end
end

local function _Btn_StrengthenAuto_CallBack( )
	bUpdate = false
	local tabVIP_AutoQH = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_7)
	if tonumber(tabVIP_AutoQH.vipLimit) == 0 then
		local function ToVIP()
			MainScene.GoToVIPLayer(1)
		end
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1505,ToVIP,tabVIP_AutoQH.level,tabVIP_AutoQH.vipLevel)
		pTips = nil
		return 
	end
	if CheckBCanStrengthen(m_grid_strengthen) == true then
		ToStrengthen(EquipStrengthenLogic.E_STRENGTHEN_TYPE.E_STRENGTHEN_TYPE_AUTO)
	end

end
local function InitUI(nGrid,nCurLv)
	ShowEquipStrengthen(nGrid,nCurLv)
end
function UpdateEquipStrengthen(nGrid,nCurLv)
	--更新共用信息
	EquipOperateLayer.updateEquipInfo(nGrid,nCurLv)
	InitUI(nGrid,nCurLv)
end


local function InitVars()
	m_layer_strengthen_equip = nil 
	m_grid_strengthen        = nil 
end
function ClearEquipStrengthen()
	InitVars()
end
--传入要强化的装备的id
function createStrengthenEquip(nGrid)
	InitVars()
	m_layer_strengthen_equip = TouchGroup:create()
	m_layer_strengthen_equip:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/Equip_Strength.json" ) )
	--initData()
	m_grid_strengthen = nGrid
	InitUI(nGrid)
	
	local btn_qh_oper = tolua.cast(m_layer_strengthen_equip:getWidgetByName("btn_qh"),"Button")
	CreateBtnCallBack(btn_qh_oper,"强化",36,_Btn_Strengthen_CallBack)

	local btn_auto_qh_oper = tolua.cast(m_layer_strengthen_equip:getWidgetByName("btn_auto_qh"),"Button")
	CreateBtnCallBack(btn_auto_qh_oper,"自动强化",36,_Btn_StrengthenAuto_CallBack)
	
	CheckBAutoQH(btn_auto_qh_oper)
	
	return m_layer_strengthen_equip
end