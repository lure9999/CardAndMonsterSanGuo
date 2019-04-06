require "Script/Main/Equip/EquipListData"
require "Script/Main/Equip/EquipOperateData"
require "Script/Main/Equip/EquipStrengthenLogic"

module("StrengthenLimitUI", package.seeall)


--变量
local m_layer_limit = nil 

--数据
local GetCurLvByGird = EquipListData.GetCurLvByGird
local GetBaseIDByGridStr = EquipListData.GetBaseIDByGridStr
local GetValueBase       = EquipOperateData.GetValueBase
local GetTypeByGrid      = EquipListData.GetTypeByGrid

--逻辑
local GetStrengthenInfoByGrid = EquipStrengthenLogic.GetStrengthenInfoByGrid



local function ShowUI(nGrid)
	local m_label_lv = tolua.cast(m_layer_limit:getWidgetByName("label_lv_next"),"Label")
	m_label_lv:setText(GetCurLvByGird(nGrid))
	local m_img_bg = tolua.cast(m_layer_limit:getWidgetByName("img_r"),"ImageView")
	for i =1 ,2 do 
		local m_base_id = GetBaseIDByGridStr(nGrid,"BaseAttitude_"..i) 
		local m_label_word = tolua.cast(m_layer_limit:getWidgetByName("label_word_"..i),"Label")
		if tonumber(m_base_id) ~= -1 then
			m_label_word:setVisible(true)
			m_label_word:setText(attribute.getFieldByIdAndIndex(m_base_id,"name"))
			local valuenum = GetValueBase(nGrid,"BaseAttitude_"..i,GetCurLvByGird(nGrid))
			
			
			local pos = ccp(0,0)
			if i==1 then
				pos = ccp(-10,-5)
			else
				pos = ccp(-10,-32)
			end
			local m_label_num = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,valuenum,pos,ccc3(81,113,39),ccc3(0,255,79),false,ccp(0,-2),2)
			EquipCommon.AddStrokeLabel(m_label_num,10+i,m_img_bg)
		else
			m_label_word:setVisible(false)
		end
	end
	
	
	
	local m_label_info = tolua.cast(m_layer_limit:getWidgetByName("label_info"),"Label")
	m_label_info:setText(GetStrengthenInfoByGrid(nGrid))
	EquipOperateLogic.SetSliverNum("",3)
end
local function InitVars()
	m_layer_limit = nil 
end
function createStrengthenLimitUI(nGrid)
	InitVars()
	m_layer_limit = TouchGroup:create()
	m_layer_limit:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/Strengthen_limit.json" ) )
	
	ShowUI(nGrid)
	return m_layer_limit
end