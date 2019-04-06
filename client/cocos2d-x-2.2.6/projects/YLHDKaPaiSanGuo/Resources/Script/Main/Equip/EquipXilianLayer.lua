


module("EquipXilianLayer", package.seeall)

require "Script/Main/Equip/EquipXilianLogic"
require "Script/Main/Equip/EquipXilianBeforeLayer"
require "Script/Main/Equip/EquipXilianPlanLayer"
require "Script/Main/Equip/EquipXilianAfterLayer"
require "Script/Main/Equip/EquipXilianInfo"
--变量
local m_layer_xilian_equip = nil 
local nXLType  = nil
--数据
local GetCurLvByGird  = EquipListData.GetCurLvByGird
--逻辑
local CheckUIType    = EquipXilianLogic.CheckUIType
local CheckBXL       = EquipXilianLogic.CheckBXL
local ExpendXL       = EquipStrengthenLogic.ExpendXL --洗炼消耗
local GetXLConsumeID = EquipXilianLogic.GetXLConsumeID

local ToLayerXilianPlan = EquipXilianPlanLayer.ToLayerXilianPlan
local CheckBFirstChoose = EquipXilianLogic.CheckBFirstChoose
local GetXLTimes     = EquipXilianLogic.GetXLTimes
local GetXLPlan     = EquipXilianLogic.GetXLPlan
local CheckBTimes   = EquipXilianLogic.CheckBTimes
local GetPlanType   = EquipXilianLogic.GetPlanType
local ToXiLian      = EquipXilianLogic.ToXiLian
local ToReplace     = EquipXilianLogic.ToReplace
local ToCancelXL    = EquipXilianLogic.ToCancelXL
local CheckFirstXL  = EquipXilianLogic.CheckFirstXL
--分界面
local ToLayerXLBefore = EquipXilianBeforeLayer.ToLayerXLBefore
local ToLayerXLAfter  = EquipXilianAfterLayer.ToLayerXLAfter
local ToLayerXLInfo   = EquipXilianInfo.CreateEquipXilianInfo




local function HandelXL(nGrid)
	local function XLBsucessed(bSucess)
		if bSucess == true then
			if nXLType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_PLAN then
				local m_panel_change = tolua.cast(m_layer_xilian_equip:getWidgetByName("Panel_change"),"Layout")
				m_panel_change:setVisible(false)
			end
		end
	end
	local function ChangeLayer(list)
		--需要更新一下消耗
		EquipXilianPlanLayer.SetBtnFalse()
		ShowExpendXL(nGrid,GetXLTimes(),GetXLPlan(GetPlanType()),EquipXilianCommonLayer.XL_TYPE.XL_TYPE_AFTER,false)
		ToLayerXLAfter(nGrid,m_layer_xilian_equip,list,_Btn_ContinueXL_CallBack,_Btn_XL_Replace_CallBack,_Btn_Cancel_CallBack)
	end
	ToXiLian(nGrid,ChangeLayer,XLBsucessed)
end


function _Btn_ContinueXL_CallBack(nGrid)
	
	if CheckFirstXL() == true then
		local pTip = TipCommonLayer.CreateTipLayerManager()
		--每天的第一次需要一个继续洗炼的提示
		local messageID = 0 
		if GetXLTimes()==1 then
			messageID = 106
		end
		if GetXLTimes()==5 then
			messageID = 107
		end
		if GetXLTimes()==10 then
			messageID = 108
		end
		local function FirstHint(bConfirm)
			if bConfirm == false then
				CCUserDefault:sharedUserDefault():setIntegerForKey("day_now",UnitTime.GetCurDay())
				CCUserDefault:sharedUserDefault():setIntegerForKey("confirm",1)
				HandelXL(nGrid)
			end
			pTip = nil
		end
		pTip:ShowCommonTips(messageID,FirstHint)
		--TipCommonLayer.CreateTipsLayer(messageID,TIPS_TYPE.TIPS_TYPE_EQUIP,nGrid,FirstHint)
	else
		HandelXL(nGrid)
	end
	
end

function _Btn_XL_Replace_CallBack(nGrid)
	local function ReplaceCallBack()
		local m_panel_change = tolua.cast(m_layer_xilian_equip:getWidgetByName("Panel_change"),"Layout")
		m_panel_change:setVisible(false)
		ShowExpendXL(nGrid,GetXLTimes(),GetXLPlan(GetPlanType()),EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE,false)
		ToLayerXLBefore(nGrid,m_layer_xilian_equip,_Btn_XL_CallBack)
	end
	ToReplace(nGrid,ReplaceCallBack)

end
function _Btn_XL_CallBack(nGrid)
	HandelXL(nGrid)
end





function _Btn_Cancel_CallBack(nGrid)
	--回到洗炼前界面
	local function CancelOk()
		if nXLType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_PLAN then
			local m_panel_change = tolua.cast(m_layer_xilian_equip:getWidgetByName("Panel_change"),"Layout")
			m_panel_change:setVisible(false)
		end
		ShowExpendXL(nGrid,GetXLTimes(),GetXLPlan(GetPlanType()),EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE,false)
		ToLayerXLBefore(nGrid,m_layer_xilian_equip,_Btn_XL_CallBack)
	end
	
	ToCancelXL(nGrid,CancelOk)
end


local function _Btn_UpLimit_CallBack(nGrid)
	local layer_info = ToLayerXLInfo(nGrid)
	if m_layer_xilian_equip:getChildByTag(3000)~=nil then
		m_layer_xilian_equip:getChildByTag(3000):setVisible(false)
		m_layer_xilian_equip:getChildByTag(3000):removeFromParentAndCleanup(true)
	end
	layer_info:setPosition(ccp(-170,0))
	m_layer_xilian_equip:addChild(layer_info,0,3000)
end

local function InitData(nGrid)
	--按钮提升洗炼上限
	local btn_up_limit = tolua.cast(m_layer_xilian_equip:getWidgetByName("btn_up_xl"),"ImageView")
	CreateBtnCallBack(btn_up_limit,"提升洗炼上限",20,_Btn_UpLimit_CallBack,ccc3(74,34,9),ccc3(255,245,133),nGrid)
end

--洗炼前显示界面
local function ShowXLBeforeUI(nGrid)
	--洗炼前的显示界面，分为洗炼过的，和没有洗炼过
	ToLayerXLBefore(nGrid,m_layer_xilian_equip,_Btn_XL_CallBack)
end
--洗炼替换界面
local function ShowXLAfterUI(nGrid,tableValue)
	ToLayerXLAfter(nGrid,m_layer_xilian_equip,tableValue,_Btn_ContinueXL_CallBack,_Btn_XL_Replace_CallBack,_Btn_Cancel_CallBack)
end
local function ChangeUI(nXLType,nGrid)
	local panel_mid = tolua.cast(m_layer_xilian_equip:getWidgetByName("Panel_before_xl"),"Layout")
	panel_mid:setVisible(true)
	--[[if nXLType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE then
		ShowXLBtn(nXLType,m_layer_xilian_equip,nGrid,_Btn_XL_CallBack)
	elseif nXLType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_AFTER then
		ShowXLBtn(nXLType,m_layer_xilian_equip,nGrid,_Btn_ContinueXL_CallBack,_Btn_XL_Replace_CallBack,_Btn_Cancel_CallBack)
	end]]--
end
--消耗部分
function ShowExpendXL(nGrid,nTimes,strPlan,nType,bChange)
	if bChange== true then
		ChangeUI(nType,nGrid)
	end
	local panel_expend = tolua.cast(m_layer_xilian_equip:getWidgetByName("Panel_xl_before"),"Layout")
	print("消耗")
	print(nGrid,GetXLConsumeID(GetPlanType()),nTimes)
	
	ExpendXL(nGrid,GetXLConsumeID(GetPlanType()),nTimes,m_layer_xilian_equip)
	--按钮
	local function _Btn_ChangePlan_CallBack()
		--改变方案
		nXLType = EquipXilianCommonLayer.XL_TYPE.XL_TYPE_PLAN
		
		ToLayerXilianPlan(nGrid,m_layer_xilian_equip,nType,ShowExpendXL)
	end
	local btn_plan = tolua.cast(m_layer_xilian_equip:getWidgetByName("btn_gg"),"Button")
	if nType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE or 
		nType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_AFTER then
		CreateBtnCallBack(btn_plan,"更换默认方案",20,_Btn_ChangePlan_CallBack,ccc3(74,34,9),ccc3(255,245,133))
	end
	--默认洗炼一次 初级洗炼
	local lable_times = nil 
	if CheckBTimes(nGrid,GetXLConsumeID(GetPlanType())) == true then
		lable_times = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"X"..nTimes,ccp(640,26),COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
	else
		lable_times = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"X"..nTimes,ccp(640,26),ccc3(23,5,5),ccc3(255,87,35),false,ccp(0,-2),2)
	end
	
	EquipCommon.AddStrokeLabel(lable_times,500,panel_expend)
	local lable_plan  = tolua.cast(m_layer_xilian_equip:getWidgetByName("label_xl_type"),"Label")
	lable_plan:setText(strPlan)
end



local function InitUI(nGrid)
	--检测是洗炼前界面还是洗炼后界面（也就是点击洗炼出现的界面）
	local function GetUIType(bXL,tableValue)
		if bXL == true then
			--洗炼前界面
			ShowXLBeforeUI(nGrid)
			nXLType = EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE
		else
			ShowXLAfterUI(nGrid,tableValue)
			nXLType = EquipXilianCommonLayer.XL_TYPE.XL_TYPE_AFTER
		end
		
		--消耗（共同）
		if CheckBFirstChoose() == true then
			CCUserDefault:sharedUserDefault():setIntegerForKey("n_xl_type",1)
			CCUserDefault:sharedUserDefault():setIntegerForKey("n_xl_time",1)
			print("初级洗炼消耗")
			ShowExpendXL(nGrid,1,"初级洗炼",nXLType,false)
		else
			print("取其他的洗炼消耗")
			print(nGrid,GetXLTimes(),GetXLPlan(GetPlanType()),nXLType)
			ShowExpendXL(nGrid,GetXLTimes(),GetXLPlan(GetPlanType()),nXLType,false)
		end
	end
	CheckUIType(nGrid,GetUIType)
	
end

local function InitVars()
	m_layer_xilian_equip = nil 
	nXLType = nil
end
function GetXLLayer()
	return m_layer_xilian_equip
end
function ClearXLLyaer()
	InitVars()
end
--传入要洗练的装备的sid
function CreateXilianEquip(id_xilian)
	InitVars()
	m_layer_xilian_equip = TouchGroup:create()
	m_layer_xilian_equip:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/Equip_Xilian.json" ) )
	InitData(id_xilian)
	InitUI(id_xilian)
	return m_layer_xilian_equip
end



