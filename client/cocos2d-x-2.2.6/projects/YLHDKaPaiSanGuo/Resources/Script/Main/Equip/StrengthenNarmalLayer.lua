
require "Script/Main/Equip/EquipStrengthenLogic"
require "Script/Main/Equip/StrengthenData"
require "Script/Main/Equip/RefineLogic"
--强化普通界面
module("StrengthenNarmalLayer", package.seeall)



--数据
local GetTypeByGrid      = EquipListData.GetTypeByGrid
local SetLvUpdateInfo    = EquipCommon.SetLvUpdateInfo
local GetCurLvByGird     = EquipListData.GetCurLvByGird
local GetBaseNameByGrid  = EquipListData.GetBaseNameByGrid
local GetValueBase       = EquipOperateData.GetValueBase
local GetTempID          = EquipListData.GetTempID
local GetEquipIconPathByGrid = EquipListData.GetEquipIconPathByGrid
local GetStarLvByGrid   = EquipListData.GetStarLvByGrid
local UpdateDataList    = EquipListData.UpdateDataList


--变量
local m_grid      = nil 
local m_narmalLayer = nil
local m_button_adds = {}
local m_lableExp = nil 
local m_bar_exp = nil 
local m_table_stars = {}
local interFaceEquipList = nil --选择宝物的界面对象

--逻辑
local GetBHaveBaseByGrid = EquipStrengthenLogic.GetBHaveBaseByGrid
local ChangeLayer        = EquipLogic.ChangeLayer
local GetExpPercent      = EquipStrengthenLogic.GetExpPercent
local GetExpPercentByExp = EquipStrengthenLogic.GetExpPercentByExp
local GetSelecExp        = EquipStrengthenLogic.GetSelecExp
local ExpendCommon       = EquipStrengthenLogic.ExpendCommon
local GetExpInfo         = EquipStrengthenLogic.GetExpInfo
local GetExpAdd          = EquipStrengthenLogic.GetExpAdd

local CheckStarLv    = RefineLogic.CheckStarLv

--宝物升级部分的信息
local function ShowTreasureLVUpdateInfo(m_layer,nGrid)
	--等级
	SetLvUpdateInfo(m_layer,"label_num_lv_cur",GetCurLvByGird(nGrid),true)
	SetLvUpdateInfo(m_layer,"label_num_lv_next",tonumber(GetCurLvByGird(nGrid))+1,true)
	
	local img_arrow = tolua.cast(m_layer:getWidgetByName("img_arrow"),"ImageView")
	local _Img_arrow = tolua.cast(img_arrow:getVirtualRenderer(), "CCSprite")
	
	local percent = m_bar_exp:getPercent()
	
	if tonumber(percent)<100 then
		
		SpriteSetGray(_Img_arrow,1)	
	else
		SpriteSetGray(_Img_arrow,0)	
	end
	for i=1,2 do 
		local img_up_r = tolua.cast(m_layer:getWidgetByName("img_r"..i),"ImageView")
		
		local value = nil
		local valueNext = nil
		
		local strName = ""
		if GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i) == true then
			strName = GetBaseNameByGrid(nGrid,"BaseAttitude_"..i)
			img_up_r:setVisible(true)
			value  = GetValueBase(nGrid,"BaseAttitude_"..i,GetCurLvByGird(nGrid))
			valueNext = GetValueBase(nGrid,"BaseAttitude_"..i,tonumber(GetCurLvByGird(nGrid))+1)
		else
			img_up_r:setVisible(false)
		end
		if tonumber(percent)<100 then
			img_up_r:setVisible(false)
		end
		if value~=nil then
			if tonumber(value)<1 then
				value = (tonumber(value)*100).."%"
			end
		end
		if valueNext~=nil then
			if tonumber(valueNext)<1 then
				valueNext = (tonumber(valueNext)*100).."%"
			end
		end
		if i==1 then
			--名字
			SetLvUpdateInfo(m_layer,"label_word_life_cur",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_layer,"label_word_life_next",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			
			SetLvUpdateInfo(m_layer,"label_num_life_cur",value,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_layer,"label_num_life_next",valueNext,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
		else
			SetLvUpdateInfo(m_layer,"label_word_att_cur",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_layer,"label_word_att_next",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			
			
			SetLvUpdateInfo(m_layer,"label_num_att_cur",value,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_layer,"label_num_att_next",valueNext,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
		end
		
	end
end
function ShowExpAndSliver(nExp,m_layer)
	if m_layer~=nil then
		m_lableExp = tolua.cast(m_layer:getWidgetByName("label_num_exp"),"Label")
	end
	if nExp == 0 then
		m_lableExp:setVisible(false)
	else
		m_lableExp:setVisible(true)
		m_lableExp:setText(nExp)
	end
	
end
function GetIconByOrderID(oID)
	--[[if m_button_adds[oID]:getChildByTag(1) ~=nil then
		return m_button_adds[oID]:getChildByTag(1)
	end]]--
	--[[local img_bg = m_button_adds[oID]:getParent()
	if img_bg:getChildByTag(2) ~=nil then
		return img_bg:getChildByTag(2) 
	end]]--
	print("1=============")
	local img_kuang_bg = tolua.cast(m_narmalLayer:getWidgetByName("img_bg_select"),"ImageView")
	return img_kuang_bg:getChildByTag(oID)
end
local function UpdateProgressNow(expNow)
	local label_exp = m_bar_exp:getChildByTag(100) 
	if label_exp~=nil then
		label_exp:setText(GetExpAdd(m_grid,expNow))
	end
	m_bar_exp:setPercent(GetExpPercentByExp(m_grid,expNow))
	--ShowTreasureLVUpdateInfo(m_layer,nGrid)
	
	
end
--[[local function ChangeEquipList(pLayerNow,pLayerNew,nTag)
	MainScene.ShowLeftInfo(false)
	MainScene.ClearRootBtn()
	MainScene.DeleteUILayer(pLayerNew)	
	local scene_equip_now = CCDirector:sharedDirector():getRunningScene()
	if pLayerNew ~=nil then
		scene_equip_now:addChild(pLayerNew,nTag,nTag)
	end
	MainScene.PushUILayer(pLayerNew)
end]]--
--添加宝物
local function _Btn_Adds_BW_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--选择宝物强化界面
		--[[print(m_grid)
		Pause()]]--
		UpdateDataList()
		
		interFaceEquipList = EquipListLayer.CreateLayerEquipList(ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED,m_grid,nil)
		
		ChangeLayer(EquipOperateLayer.GetUIControl(),interFaceEquipList.m_layer,layerTreasureListTag)
		--ChangeEquipList(EquipOperateLayer.GetUIControl(),interFaceEquipList.m_layer,layerTreasureListTag)
	end
end
function UpdateSelectBW(tableTreasure,mLayer,nGrid)
	
	EquipLogic.UpdateTableTreasure(tableTreasure)
	print("2=============")
	local img_kuang_bg = tolua.cast(m_narmalLayer:getWidgetByName("img_bg_select"),"ImageView")
	for i = 1, 5 do
		img_kuang_bg:removeChildByTag(i,true)
	end
	
	for i=1,#tableTreasure do 
		if tableTreasure[i].m_grid~=nil then
			--[[m_button_adds[i]:loadTextureNormal(GetEquipIconPathByGrid(tableTreasure[i].m_grid)) 
			m_button_adds[i]:loadTexturePressed(GetEquipIconPathByGrid(tableTreasure[i].m_grid)) 
			m_button_adds[i]:setScale(0.73)]]--
			local img_bg = tolua.cast(m_narmalLayer:getWidgetByName("img_bg_select_"..i),"ImageView")
			
			local PanelEquip = EquipCommon.AddEquipIcon(GetEquipIconPathByGrid(tableTreasure[i].m_grid),tableTreasure[i].m_grid)
			PanelEquip:setPosition(ccp(img_bg:getPositionX(),img_bg:getPositionY()))
			AddLabelImg(PanelEquip,i,img_kuang_bg)
			m_button_adds[i]:addTouchEventListener(_Btn_Adds_BW_CallBack)
		end
	end
	
	ShowExpAndSliver(GetSelecExp(tableTreasure),nil)
	UpdateProgressNow(GetSelecExp(tableTreasure))
	if mLayer==nil then
		if TreasureStrengthen.GetTreasureUI()~=nil then
			ShowTreasureLVUpdateInfo(TreasureStrengthen.GetTreasureUI(),nGrid)
		end
	end
end

local function ShowTreasureAddXHItem(m_layer,nGrid)
	
	for i=1,5 do
		
		m_button_adds[i] = tolua.cast(m_layer:getWidgetByName("btn_add_"..i),"Button")
		--m_button_adds[i]:setTag(3)
		if m_button_adds[i]~= nil then
			m_button_adds[i]:addTouchEventListener(_Btn_Adds_BW_CallBack)
		else
			print("button_add is nil")
		end
	end
end
--进度条相关
local function ShowProgress(m_layer,nGrid)
	--当前的经验
	m_bar_exp = tolua.cast(m_layer:getWidgetByName("pro_bar"),"LoadingBar")
	m_bar_exp:setPercent((GetExpPercent(nGrid)))
	
	local label_exp = Label:create()
	label_exp:setFontSize(18)
	label_exp:setText(GetExpInfo(nGrid))
	m_bar_exp:addChild(label_exp,100,100)
end
function UpdateProgress(m_layer,nGrid)
	m_bar_exp:setPercent((GetExpPercent(nGrid)))
	local label_exp = m_bar_exp:getChildByTag(100) 
	if label_exp~=nil then
		label_exp:setText(GetExpInfo(nGrid))
	end
	ShowTreasureLVUpdateInfo(m_layer,nGrid)
	
end
local function ShowTreasureNarmalLayer(m_layer,nGrid)
	--进度条
	ShowProgress(m_layer,nGrid)
	--升级部分的信息
	
	ShowTreasureLVUpdateInfo(m_layer,nGrid)
	--添加消耗品的信息
	ShowTreasureAddXHItem(m_layer,nGrid)
	
	--显示经验和金币
	local tableNew = {}
	ShowExpAndSliver(GetSelecExp(tableNew),m_layer)
end
local function InitVars()
	m_grid      = nil 
	m_lableExp = nil 
	m_button_adds = {}
	m_bar_exp = nil 
	m_table_stars = {}
	m_narmalLayer = nil
	interFaceEquipList = nil 
end
local function ShowExpendLingBao(nGrid,m_lingbao)
	ExpendCommon(nGrid,GetCurLvByGird(nGrid),0)
end
local function ShowLingBaoNarmalLayer(m_lingbao,nGrid)
	--等级
	EquipCommon.SetLvUpdateInfo(m_lingbao,"label_num_lv_cur",GetCurLvByGird(nGrid),true)
	EquipCommon.SetLvUpdateInfo(m_lingbao,"label_num_lv_next",tonumber(GetCurLvByGird(nGrid))+1,true)
	--基础属性
	for i=1,2 do 
		local img_up_r = tolua.cast(m_lingbao:getWidgetByName("img_l_r"..i),"ImageView")
		
		local value = nil
		local valueNext =  nil
		
		local strName = ""
		if GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i) == true then
			strName = GetBaseNameByGrid(nGrid,"BaseAttitude_"..i)
			img_up_r:setVisible(true)
			value  = GetValueBase(nGrid,"BaseAttitude_"..i,GetCurLvByGird(nGrid))
			valueNext = GetValueBase(nGrid,"BaseAttitude_"..i,tonumber(GetCurLvByGird(nGrid))+1)
		else
			img_up_r:setVisible(false)
		end
		if i==1 then
			--名字
			SetLvUpdateInfo(m_lingbao,"label_word_life_cur",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_lingbao,"label_word_life_next",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			
			SetLvUpdateInfo(m_lingbao,"label_num_life_cur",value,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_lingbao,"label_num_life_next",valueNext,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
		else
			SetLvUpdateInfo(m_lingbao,"label_word_att_cur",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_lingbao,"label_word_att_next",strName,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			
			SetLvUpdateInfo(m_lingbao,"label_num_att_cur",value,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
			SetLvUpdateInfo(m_lingbao,"label_num_att_next",valueNext,GetBHaveBaseByGrid(nGrid,"BaseAttitude_"..i))
		end
	end
	--强化消耗
	ShowExpendLingBao(nGrid,m_lingbao)
end
local function SetCommonInfo(m_layer_jl,strInfo,strName,bValue,pos,tag)
	SetLvUpdateInfo(m_layer_jl,strInfo,strName,bValue,pos,tag)
end
local function ShowMidInfo(m_layer,nGrid)
	--精炼取的是消耗
	--等级 精炼的等级取的是洗炼的次数
	EquipCommon.SetLvUpdateInfo(m_layer,"label_num_lv_cur",GetStarLvByGrid(nGrid),true)
	EquipCommon.SetLvUpdateInfo(m_layer,"label_num_lv_next",tonumber(GetStarLvByGrid(nGrid))+1,true)
	--基础属性
	for i=1,3 do 
		local img_up_r = tolua.cast(m_layer:getWidgetByName("img_up_"..i),"ImageView")
		local value = nil
		local valueNext = nil
		local strName = ""
		if GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i) == true then
			strName = GetBaseNameByGrid(nGrid,"XiLAttitude_"..i)
			img_up_r:setVisible(true)
			value  = GetValueBase(nGrid,"XiLAttitude_"..i,GetStarLvByGrid(nGrid))
			valueNext = GetValueBase(nGrid,"XiLAttitude_"..i,tonumber(GetStarLvByGrid(nGrid))+1)
		else
			img_up_r:setVisible(false)
		end
		if i==1 then
			--名字
			SetCommonInfo(m_layer,"label_word_ar_cur",strName,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			SetCommonInfo(m_layer,"label_word_ar_next",strName,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			
			
			SetCommonInfo(m_layer,"label_word_ar_num_cur",value,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			SetCommonInfo(m_layer,nil,valueNext,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i),ccp(-10,19),i)
		elseif i==2 then
			SetLvUpdateInfo(m_layer,"label_word_life_cur",strName,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			SetLvUpdateInfo(m_layer,"label_word_life_next",strName,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			
			SetLvUpdateInfo(m_layer,"label_num_life_cur",value,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			SetLvUpdateInfo(m_layer,nil,valueNext,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i),ccp(-10,-5),i)
		else
			SetLvUpdateInfo(m_layer,"label_word_att_cur",strName,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			SetLvUpdateInfo(m_layer,"label_word_att_next",strName,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			
			SetLvUpdateInfo(m_layer,"label_num_att_cur",value,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i))
			SetLvUpdateInfo(m_layer,nil,valueNext,GetBHaveBaseByGrid(nGrid,"XiLAttitude_"..i),ccp(-10,-32),i)
		end
	end
end
local function ShowStarInfo(m_layer,nGrid)
	for i=1,10 do 
		local str_star = string.format("img_star_%d",i)
		local img_star = tolua.cast(m_layer:getWidgetByName(str_star),"ImageView")
		local tableS = {}
		tableS.imgStar = img_star
		table.insert(m_table_stars,tableS)
	end
	CheckStarLv(m_table_stars,nGrid)
end

local function ShowRefineExpend(m_layer,nGrid)
	--最后一个参数区别是否是精炼
	ExpendCommon(nGrid,GetStarLvByGrid(nGrid),1)
end
local function ShowTreasureRefine(m_layer,nGrid)
	--中间部分的信息
	ShowMidInfo(m_layer,nGrid)
	--星级的显示
	ShowStarInfo(m_layer,nGrid)
	--消耗部分的信息
	ShowRefineExpend(m_layer,nGrid)
end
function GetBwSelectLayer()
	return interFaceEquipList
end
function ClearInterFace()
	interFaceEquipList = nil
end
function AddStrengthenNarmalLayer(m_layer,nGrid,nType)
	
	InitVars()
	m_grid       = nGrid
	m_narmalLayer = m_layer
	if tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		
		if nType~=nil then
			--说明是宝物精炼界面
			ShowTreasureRefine(m_layer,nGrid)
		else
			--宝物强化的普通界面
			ShowTreasureNarmalLayer(m_layer,nGrid)
		end
	elseif tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		ShowLingBaoNarmalLayer(m_layer,nGrid)
	end
	
end




