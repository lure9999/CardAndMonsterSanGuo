

module("EquipXilianPlanLayer", package.seeall)



--变量
local m_panel_change = nil 
local m_orgTag       = nil 
local m_layer        = nil
local m_callBack     = nil 
local m_Grid         = nil
local m_Type         = nil 

local CheckBFirstChoose = EquipXilianLogic.CheckBFirstChoose
local GetXLTimes        = EquipXilianLogic.GetXLTimes
local GetXLPlan         = EquipXilianLogic.GetXLPlan
local GetPlanType       = EquipXilianLogic.GetPlanType
local GetXLExpendTableByXLID = EquipStrengthenLogic.GetXLExpendTableByXLID

local GetXLConsumeID = EquipXilianLogic.GetXLConsumeID
local CheckVIP       = EquipXilianLogic.CheckVIP

local function InitVars()
	m_panel_change = nil 
	m_orgTag = nil 
	m_layer = nil
	m_callBack = nil 
end
local function _Box_XL_Times_CallBack(sender,eventType)
	local nowTag = sender:getTag()
	if eventType == CheckBoxEventType.selected then
		if nowTag ~= m_orgTag then
			m_panel_change:getChildByTag(m_orgTag):setSelectedState(false)
			local lable_org_word = tolua.cast(m_layer:getWidgetByName("label"..(m_orgTag-1000)),"Label")
			local lable_now_word = tolua.cast(m_layer:getWidgetByName("label"..(nowTag-1000)),"Label")
			lable_org_word:setColor(ccc3(49,31,21))
			lable_now_word:setColor(ccc3(211,175,95))
			local img_arrow_org = tolua.cast(m_layer:getWidgetByName("img_"..(m_orgTag-1000)),"ImageView")
			local img_arrow_now = tolua.cast(m_layer:getWidgetByName("img_"..(nowTag-1000)),"ImageView")
			img_arrow_org:setVisible(false)
			img_arrow_now:setVisible(true)
			if nowTag == 1001 then
				CCUserDefault:sharedUserDefault():setIntegerForKey("n_xl_time",1)	
			else
				CCUserDefault:sharedUserDefault():setIntegerForKey("n_xl_time",(nowTag-1000)*5-5)	
			end
			m_orgTag = nowTag
			
			if m_callBack~=nil then
				m_callBack(m_Grid,GetXLTimes(),GetXLPlan(GetPlanType()),EquipXilianCommonLayer.XL_TYPE_PLAN,false)
			end
		end
	elseif eventType == CheckBoxEventType.unselected then
		if nowTag == m_orgTag then
			sender:setSelectedState(true)
		end
	end
end
local function _Btn_XL_PLAN_CallBack( sender,eventType )
	local tag_now = sender:getTag()
	if eventType == TouchEventType.ended then
		CCUserDefault:sharedUserDefault():setIntegerForKey("n_xl_type",tag_now-1003)
		if m_callBack~=nil then
			if tag_now-1003~= 1 then
				local tabVIP = nil
				if (tag_now-1003) == 2 then
					tabVIP = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_8)
				elseif (tag_now-1003) == 3 then
					tabVIP = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_9)
				end
				if tonumber(tabVIP.vipLimit) == 0 then
					local function ToVIP()
						MainScene.GoToVIPLayer(1)
					end
					
					local pTips = TipCommonLayer.CreateTipLayerManager()
					if tonumber(tabVIP.level) ~= -1 then
						pTips:ShowCommonTips(1505,ToVIP,tabVIP.level,tabVIP.vipLevel)
					else
						pTips:ShowCommonTips(1634,ToVIP,tabVIP.vipLevel)
					end
					pTips = nil
					return 
				end
			end
			m_callBack(m_Grid,GetXLTimes(),GetXLPlan(tag_now-1003),EquipXilianCommonLayer.XL_TYPE_PLAN,false)
		end
	end

end
local function ShowPlan(mLayer)
	for i=1,3 do 
		local m_box_i = tolua.cast(mLayer:getWidgetByName("box_"..i),"CheckBox")
		local nTimes = 0 
		if i==1 then
			nTimes = 1 
		else
			nTimes = i*5-5
		end
		m_box_i:setTouchEnabled(true)
		m_box_i:addEventListenerCheckBox(_Box_XL_Times_CallBack)
		m_box_i:setTag(1000+i)
		
		local img_arrow = tolua.cast(mLayer:getWidgetByName("img_"..i),"ImageView")
		img_arrow:setVisible(false)
		if CheckBFirstChoose() == true then
			if i==1 then
				m_box_i:setSelectedState(true)
				m_orgTag = m_box_i:getTag()
				img_arrow:setVisible(true)
			end
			
		elseif nTimes == GetXLTimes() then
			m_box_i:setSelectedState(true)
			m_orgTag = m_box_i:getTag()
			img_arrow:setVisible(true)
		end
		local label_times = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,"X"..nTimes,ccp(-2,-59),COLOR_Black,ccc3(219,198,167),true,ccp(0,-2),2)
		EquipCommon.AddStrokeLabel(label_times,100,m_box_i)
	end
	local btn_normal = tolua.cast(mLayer:getWidgetByName("btn_normal"),"Button")
	local btn_mid = tolua.cast(mLayer:getWidgetByName("btn_mid"),"Button")
	local btn_high = tolua.cast(mLayer:getWidgetByName("btn_high"),"Button")
	
	--添加VIP显示
	CheckVIP(btn_mid,btn_high)
	
	btn_normal:setTouchEnabled(true)
	btn_mid:setTouchEnabled(true)
	btn_high:setTouchEnabled(true)
	
	btn_normal:addTouchEventListener(_Btn_XL_PLAN_CallBack)
	btn_mid:addTouchEventListener(_Btn_XL_PLAN_CallBack)
	btn_high:addTouchEventListener(_Btn_XL_PLAN_CallBack)
	
	btn_normal:setTag(1004)
	btn_mid:setTag(1005)
	btn_high:setTag(1006)
	
	
	for i= 1,3 do 
		local img_one = tolua.cast(m_layer:getWidgetByName("img_sliver"..i),"ImageView")
		local img_two = tolua.cast(m_layer:getWidgetByName("img_bs"..i),"ImageView")
		local tableXLExpendData = GetXLExpendTableByXLID(m_Grid,GetXLConsumeID(i))
		for key,value in pairs(tableXLExpendData) do 
			local posNum = nil
			if key == 2 then
				img_two:setVisible(true)
				img_two:setScale(0.7)
				img_two:loadTexture(value.IconPath)
				posNum = ccp(170,6)
			else
				posNum = ccp(50,6)
				img_one:loadTexture(value.IconPath)
				img_two:setVisible(false)
			end
			
			local label_num_plan = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,value.ItemNeedNum,posNum,COLOR_Black,ccc3(99,216,53),false,ccp(0,-2),2)
			if i==1 then
				EquipCommon.AddStrokeLabel(label_num_plan,100+i+key,btn_normal)
			end
			if i==2 then
				EquipCommon.AddStrokeLabel(label_num_plan,100+i+key,btn_mid)
			end
			if i==3 then
				EquipCommon.AddStrokeLabel(label_num_plan,100+i+key,btn_high)
			end
		end
	end
	--绘制标题
	local m_panel_before = tolua.cast(m_layer:getWidgetByName("Panel_before_xl"),"Layout")
	local title_1 = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,"选择洗炼类型",ccp(150,232),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(title_1,500,m_panel_change)
	local title_2 = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,"选择洗炼次数",ccp(490,232),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(title_2,501,m_panel_change)
end
function SetBtnFalse()
	if m_layer~=nil then
		local btn_normal = tolua.cast(m_layer:getWidgetByName("btn_normal"),"Button")
		
		local btn_mid = tolua.cast(m_layer:getWidgetByName("btn_mid"),"Button")
		local btn_high = tolua.cast(m_layer:getWidgetByName("btn_high"),"Button")
		if btn_normal~=nil then 
			btn_normal:setTouchEnabled(false)
		end
		if btn_mid~=nil then 
			btn_mid:setTouchEnabled(false)
		end
		if btn_high~=nil then 
			btn_high:setTouchEnabled(false)
		end
		for i=1,3 do 
			local m_box_i = tolua.cast(m_layer:getWidgetByName("box_"..i),"CheckBox")
			if m_box_i~=nil then
				m_box_i:setTouchEnabled(false)
			end
		end
	end
end

function ClearXLPlanLayer()
	InitVars()
end
function ToLayerXilianPlan(nGrid,mLayer,nType,fCallBack)
	InitVars()
	m_layer = mLayer
	m_callBack = fCallBack
	m_Grid = nGrid
	m_Type = nType
	local m_panel_before = tolua.cast(mLayer:getWidgetByName("Panel_before_xl"),"Layout")
	m_panel_change = tolua.cast(mLayer:getWidgetByName("Panel_change"),"Layout")
	m_panel_before:setVisible(false)
	m_panel_change:setVisible(true)
	
	--按钮
	local function _Btn_Plan_CallBack()
		--返回洗炼界面
		m_panel_change:setVisible(false)
		--btn值也设置为false
		local btn_normal = tolua.cast(mLayer:getWidgetByName("btn_normal"),"Button")
		local btn_mid = tolua.cast(mLayer:getWidgetByName("btn_mid"),"Button")
		local btn_high = tolua.cast(mLayer:getWidgetByName("btn_high"),"Button")
		btn_normal:setTouchEnabled(false)
		btn_mid:setTouchEnabled(false)
		btn_high:setTouchEnabled(false)
		for i=1,3 do 
			local m_box_i = tolua.cast(mLayer:getWidgetByName("box_"..i),"CheckBox")
			m_box_i:setTouchEnabled(false)
		end
		fCallBack(nGrid,GetXLTimes(),GetXLPlan(GetPlanType()),nType,true)
	end
	local btn_plan = tolua.cast(mLayer:getWidgetByName("btn_gg"),"Button")
	if nType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_BEFORE or 
		nType == EquipXilianCommonLayer.XL_TYPE.XL_TYPE_AFTER then
		CreateBtnCallBack(btn_plan,"返回洗炼界面",20,_Btn_Plan_CallBack,ccc3(74,34,9),ccc3(255,245,133))
		
	end
	ShowPlan(mLayer)
end