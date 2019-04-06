require "Script/Main/MainBtnLayer"
require "Script/Common/Common"
require "Script/Main/Equip/EquipLogic"
require "Script/Main/Equip/EquipPropertyLayer"

module("EquipListLayer", package.seeall)


--常量
TAG_PINJI_ADD = 335


--逻辑

local RunGetListAction = EquipLogic.RunGetListAction
local UpdateEquipList  = EquipLogic.UpdateEquipList
local UpdateListData   = EquipLogic.UpdateListData
local GetRow           = EquipLogic.GetRow
local GetCol          = EquipLogic.GetCol
local ChangeLayer    = EquipLogic.ChangeLayer
local CheckBEquip    = EquipLogic.CheckBEquip --是否可以装备
local UpDateMatrixBack = EquipLogic.UpDateMatrixBack
local AddTreasureStrengthen = EquipLogic.AddTreasureStrengthen
local ChecxBGrid     = EquipLogic.ChecxBGrid
local CheckBFull     = EquipLogic.CheckBFull
local ClearTableTreasure = EquipLogic.ClearTableTreasure
local RemoveGridTable = EquipLogic.RemoveGridTable
local GetTableTreasure = EquipLogic.GetTableTreasure
local CheckBCanEat    = EquipLogic.CheckBCanEat
--数据
local UpdateDataList = EquipListData.UpdateDataList
 

--界面
local CreateEquipProperty =  EquipPropertyLayer.CreateEquipProperty


--[[local function DeleteListView(mListView)
	if mListView~=nil then
		if mListView:getItems():count() ~= 0 then
			mListView:removeAllItems()
		end
	end
end]]--
local function DeleteLayer(mLayer)
	mLayer:removeFromParentAndCleanup(true)
end
--只有宝物才会调用
local function GetGridEquip(self)
	return self.m_grid_pos
end


local function InitVars()
	--EquipListManager.InitVars()
	UpdateListData()
end

local function addMainBtn(self)
	--主界面的按钮
    local temp_equipList = MainBtnLayer.createMainBtnLayer()
    self.m_layer:addChild(temp_equipList, layerMainBtn_Tag, layerMainBtn_Tag)
end


local function getCloneItemEquip(mCloneItem)
	mCloneItem = GUIReader:shareReader():widgetFromJsonFile("Image/EquipItem.json")
	local new_item = mCloneItem:clone()
	local peer = tolua.getpeer(mCloneItem)
	tolua.setpeer(new_item,peer)
	return new_item 

end

local function _Btn_Head_Equip_CallBack(nGrid,sender,self)
	--到属性界面
	ChangeLayer(self.m_layer,CreateEquipProperty(nGrid,E_LAYER_TYPE.E_LAYER_TYPE_EQUIP,self),layerEquipProperty_Tag)
end	
local function _Btn_MatriEquip_CallBack(nGrid,sender,self)
	--刷新回到阵容界面
	if CheckBEquip(nGrid,self.m_grid_pos) == true then
		local function BackCallBack()
			DeleteLayer(self.m_layer)
			UpdateDataList()
			MainScene.PopUILayer()
		end
		UpDateMatrixBack(BackCallBack)
	end
end

local function Exit_MatriEquip_CallBack(self,nTempID,n_grid_pos,fCallBack)
	local nGrid = server_equipDB.GetGridByTempId(nTempID)
	if nGrid~=nil then
		if CheckBEquip(nGrid,n_grid_pos) == true then
			local function BackCallBack()
				DeleteLayer(self.m_layer)
				UpdateDataList()
				MainScene.PopUILayer()
				if fCallBack~=nil then
					fCallBack()
				end
			end
			UpDateMatrixBack(BackCallBack,true)
		end
	end
end
local function AddImgSelect(sender)
	local imgSelect = ImageView:create()
	imgSelect:loadTexture("Image/imgres/equip/equip_selected.png")
	imgSelect:setPosition(ccp(imgSelect:getContentSize().width+40,20))
	EquipCommon.AddStrokeLabel(imgSelect,500,sender)
end
local function _Btn_Treasure_CallBack(nGrid,sender)
	--宝物选择界面
	if CheckBCanEat(nGrid) == true then
		
		if ChecxBGrid(nGrid) == true then
			--选中五个就不能再选了
			if CheckBFull() == false then
				AddTreasureStrengthen(nGrid)
				AddImgSelect(sender)
			end
		else
			RemoveGridTable(nGrid)
			--说明点选了上次的
			sender:getChildByTag(500):setVisible(false)
			sender:getChildByTag(500):removeFromParentAndCleanup(true)
		end
	else
		TipLayer.createTimeLayer("已经装备的物品不能添加", 2)
	end
	
end
local function CheckShowBSelect(pControl,nGrid)
	if ChecxBGrid(nGrid) == false then
		AddImgSelect(pControl)
	end
end
local function SwitchCallBackByType(pControl,selfTable)
	local lableStr = nil 
	local m_layerEquipList = selfTable.m_layer
	local nLayerType = selfTable.m_type_layer
	local width = m_layerEquipList:getContentSize().width
	local height = m_layerEquipList:getContentSize().height
	if nLayerType == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_LIST then
		CreateItemCallBack(pControl,false,_Btn_Head_Equip_CallBack,selfTable)
	elseif nLayerType == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
		CreateItemCallBack(pControl,false,_Btn_Treasure_CallBack,selfTable)
		lableStr = "请选择要强化的宝物"
	elseif nLayerType == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP then
		CreateItemCallBack(pControl,false,_Btn_MatriEquip_CallBack,selfTable)
		lableStr = "请选择需要的装备"
	end
	
	if lableStr ~=nil then
		local lable = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,lableStr,ccp(width/2-150,height-110),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
		EquipCommon.AddStrokeLabel(lable,2000,m_layerEquipList)
	end
	
end
--加载
local function loadItems(tableID,cloneObject,nCol,dataTable,bSingle,selfTable)
	--print("nCol:"..nCol)
	--print("tableID:"..tableID)
	local modelClone = tolua.cast(cloneObject:getChildByName("img_item"..nCol.."_equip"),"ImageView")
	if bSingle== true then
		local modelCloneDlete = tolua.cast(cloneObject:getChildByName("img_item"..(nCol+1).."_equip"),"ImageView")
		modelCloneDlete:removeFromParentAndCleanup(true)
	end
	local img_head_equip = tolua.cast(modelClone:getChildByName("img_head"..nCol.."_equip"),"ImageView")
	local pControl = UIInterface.MakeHeadIcon(img_head_equip, ICONTYPE.EQUIP_ICON, dataTable[tableID].e_tempID, dataTable[tableID].e_grid)
	--pControl:setTag(TAG_GRID_ADD+tonumber(dataTable[tableID].e_grid))
	--pControl:addTouchEventListener(_Btn_Head_Equip_CallBack)
	--modelClone:addTouchEventListener(_Btn_Head_Equip_CallBack)
	modelClone:setTouchEnabled(true)
	pControl:setTouchEnabled(false)
	modelClone:setTag(TAG_GRID_ADD+tonumber(dataTable[tableID].e_grid))
	SwitchCallBackByType(modelClone,selfTable)
	if selfTable.m_type_layer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
		CheckShowBSelect(modelClone,dataTable[tableID].e_grid)
	end
	
	--名字
	local img_nameBg = tolua.cast(modelClone:getChildByName("img_name_bg"..nCol),"ImageView")
	local labelNameEquip = tolua.cast(img_nameBg:getChildByName("Label_name"..nCol.."_equip"),"Label")
	labelNameEquip:setText(dataTable[tableID].e_name)
	
	--装备于谁
	local lableEquipedName = tolua.cast(modelClone:getChildByName("label_ename"..nCol.."_equip"),"Label")
	local img_ENameBg      = tolua.cast(modelClone:getChildByName("img_bg_equip"..nCol),"ImageView")
	local lableEName       = tolua.cast(img_ENameBg:getChildByName("label_name_ep"..nCol),"Label")
	if dataTable[tableID].e_euiped_name~=nil then
		lableEName:setText(dataTable[tableID].e_euiped_name)
	else
		lableEquipedName:setVisible(false)
		img_ENameBg:setVisible(false)
		lableEName:setVisible(false)
	end
	--品级
	local label_pinji_euqip = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,dataTable[tableID].e_pinji,ccp(48,4),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
	EquipCommon.AddStrokeLabel(label_pinji_euqip,TAG_PINJI_ADD,modelClone)
end

local function addItemOnList(data_table,startNum,count,self)
	--[[print(#data_table)
	Pause()]]
	local nLayerType = self.m_type_layer
	if #data_table~=0 then
		for i=GetRow(startNum),GetRow(startNum)+GetRow(count)-1 do 
			local item_clone_i = getCloneItemEquip(self.m_clone_item)
			for j=1,GetCol(count,i,#data_table) do
				--[[print(2*(i-1)+j)
				print(GetCol(count,i))
				Pause()]]--
				if GetCol(count,i,#data_table)== 2 then
					loadItems(2*(i-1)+j,item_clone_i,j,data_table,false,self)
				else
					loadItems(2*(i-1)+j,item_clone_i,j,data_table,true,self)
				end
			end
			self.m_listView:pushBackCustomItem(item_clone_i)
		end
	else
		local lableStr = nil 
		local m_layerEquipList = self.m_layer
		local width = m_layerEquipList:getContentSize().width
		local height = m_layerEquipList:getContentSize().height
		if nLayerType == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
			lableStr = "请选择要强化的宝物"
		elseif nLayerType == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP then
			lableStr = "请选择需要的装备"
		end
		if lableStr ~=nil then
			local lable = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,lableStr,ccp(width/2-150,height-110),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
			EquipCommon.AddStrokeLabel(lable,2000,m_layerEquipList)
		end
	end

end
local function addAndUpdateListItem(nType,self)
	--DeleteListView(self.m_listView)
	local function UpCallBack(data_table,startNum,countAdd)
		--[[printTab(data_table)
		Pause()]]--
		addItemOnList(data_table,startNum,countAdd,self)
	end
	UpdateEquipList(self.m_listView,nType,UpCallBack,self.m_type_layer,self.m_grid_equip,self.m_grid_pos)
end
--更新函数
local function UpdateList_Equip(self)
	addAndUpdateListItem(self.m_check_box_type,self)
end
local function setBoxStateBShow(boxObject,bShow)
	if bShow == false then
		boxObject:removeFromParentAndCleanup(true)
	end
	
end
--检测右边的box是显示还是不显示根据类型
local function BoxBShow(box_equiped,box_equip,box_bw,box_lb,nTypeLayer)
	if nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
		setBoxStateBShow(box_bw,false)
		setBoxStateBShow(box_lb,false)
	elseif nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_LIST then
	elseif nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP then
		--阵容界面
		setBoxStateBShow(box_bw,false)
		setBoxStateBShow(box_lb,false)
		
	end
end
local function SetBoxState(box1,box2,box3)
	if box1~=nil then
		box1:setSelectedState(false)
	end
	if box2~=nil then
		box2:setSelectedState(false)
	end
	if box3~=nil then
		box3:setSelectedState(false)
	end
end

local function _Box_Box_CallBack(nType,sender,self)
	--记录一下checkBox的状态
	self.m_check_box_type = nType
	if self.m_oldObject:getTag() ~= sender:getTag() then
		self.m_oldObject:setSelectedState(false)
		UpdateObject(self.m_oldObject,sender,GetNameByBoxType(self.m_check_box_type))
		self.m_oldObject = sender
	end
	addAndUpdateListItem(nType,self)
end



local function CheckBoxInit(self)
	local m_layerEquipList = self.m_layer
	local nCheckBoxType = self.m_check_box_type
	local nTypeLayer = self.m_type_layer
	local nGridPos = self.m_grid_pos
	if nCheckBoxType ==nil then
		local box_hufa = tolua.cast(m_layerEquipList:getWidgetByName("box_wujianglist_hufa"),"CheckBox")
		box_hufa:removeFromParentAndCleanup(true)
	end
	
	local box_equiped = tolua.cast(m_layerEquipList:getWidgetByName("box_wujianglist_all"),"CheckBox")
	local box_equip = tolua.cast(m_layerEquipList:getWidgetByName("box_wujianglist_before"),"CheckBox")
	local box_bw = tolua.cast(m_layerEquipList:getWidgetByName("box_wujianglist_mid"),"CheckBox")
	local box_lb = tolua.cast(m_layerEquipList:getWidgetByName("box_wujianglist_after"),"CheckBox")
	
	
	BoxBShow(box_equiped,box_equip,box_bw,box_lb,nTypeLayer)
	if nCheckBoxType ==nil then
		if  nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_LIST then 
			self.m_check_box_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIPED 
			box_equiped:setSelectedState(true)
			self.m_oldObject = box_equiped
		end
	end
	
	if nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_LIST then
		CreateCheckBoxCallBack(box_equiped,ENUM_STRING_WORD.ENUM_STRING_EQUIPED,_Box_Box_CallBack,self)
		CreateCheckBoxCallBack(box_equip,ENUM_STRING_WORD.ENUM_STRING_EQUIP,_Box_Box_CallBack,self)
		CreateCheckBoxCallBack(box_bw,ENUM_STRING_WORD.ENUM_STRING_TREASURE,_Box_Box_CallBack,self)
		CreateCheckBoxCallBack(box_lb,ENUM_STRING_WORD.ENUM_STRING_LINGBAO,_Box_Box_CallBack,self)
	elseif nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
		self.m_check_box_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE 
		--0717修改为宝物选择界面，不显示任何按钮
		--[[box_equip:setSelectedState(true)
		self.m_oldObject = box_equip
		CreateCheckBoxCallBack(box_equiped,ENUM_STRING_WORD.ENUM_STRING_EQUIPED,_Box_Box_CallBack,self)
		CreateCheckBoxCallBack(box_equip,ENUM_STRING_WORD.ENUM_STRING_TREASURE,_Box_Box_CallBack,self)]]--
		self.m_oldObject = box_equip
		box_equiped:setVisible(false)
		box_equiped:setTouchEnabled(false)
		box_equip:setVisible(false)
		box_equip:setTouchEnabled(false)
	elseif  nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP then
		box_equip:setSelectedState(true)
		if MatrixLayer.getCurPos() == 6 then
			--显示的是灵宝
			CreateCheckBoxCallBack(box_equiped,ENUM_STRING_WORD.ENUM_STRING_EQUIPED,_Box_Box_CallBack,self)
			CreateCheckBoxCallBack(box_equip,ENUM_STRING_WORD.ENUM_STRING_LINGBAO,_Box_Box_CallBack,self)
			self.m_check_box_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO 
		else
			if tonumber(nGridPos)<5 then 
				--说明要显示装备
				CreateCheckBoxCallBack(box_equiped,ENUM_STRING_WORD.ENUM_STRING_EQUIPED,_Box_Box_CallBack,self)
				CreateCheckBoxCallBack(box_equip,ENUM_STRING_WORD.ENUM_STRING_EQUIP,_Box_Box_CallBack,self)
				self.m_check_box_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP 
				
			elseif tonumber(nGridPos)>4 then
				--说明显示的是宝物 
				CreateCheckBoxCallBack(box_equiped,ENUM_STRING_WORD.ENUM_STRING_EQUIPED,_Box_Box_CallBack,self)
				CreateCheckBoxCallBack(box_equip,ENUM_STRING_WORD.ENUM_STRING_TREASURE,_Box_Box_CallBack,self)
				self.m_check_box_type = ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE 
			end
		end
		self.m_oldObject = box_equip
	end
	--[[print(self.m_check_box_type)
	Pause()]]--
end
--[[function UpdateCheckBox(self)
	if self.m_type_layer ~=nil then
		CheckBoxInit(self)
	end
end]]--

local function deleteWJImg(mLayer,nTypeLayer)
	--原来的图片换成文字了所以不需要了
	local m_layerEquipList = mLayer
	local img_all = tolua.cast(m_layerEquipList:getWidgetByName("img_all"),"ImageView")
	local img_before = tolua.cast(m_layerEquipList:getWidgetByName("img_front"),"ImageView")
	
	
	if nTypeLayer== ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_LIST then
		--img_all:removeFromParentAndCleanup(true)
		--img_before:removeFromParentAndCleanup(true)
		local img_mid = tolua.cast(m_layerEquipList:getWidgetByName("img_mid"),"ImageView")
		local img_after = tolua.cast(m_layerEquipList:getWidgetByName("img_after"),"ImageView")
		img_mid:removeFromParentAndCleanup(true)
		img_after:removeFromParentAndCleanup(true)
	elseif nTypeLayer== ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
		img_all:removeFromParentAndCleanup(true)
		img_before:removeFromParentAndCleanup(true)
	elseif nTypeLayer== ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP then
		img_all:removeFromParentAndCleanup(true)
		img_before:removeFromParentAndCleanup(true)
	end
end
local function InitData(self)
	--checkbox
	CheckBoxInit(self)
	--删除之前的文字图片
	--deleteWJImg(self.m_layer,self.m_type_layer)

end
local function InitUI(self)
	addAndUpdateListItem(self.m_check_box_type,self)
end


--返回按钮
local function DealBackBtn(mLayer,mTypeLayer,nGrid)
	--back
	local btn_back_equiplist = tolua.cast(mLayer:getWidgetByName("btn_wujianglist_back"),"Button")
	
	local function callBack()
		
		if mTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
			StrengthenNarmalLayer.UpdateSelectBW(GetTableTreasure(),nil,nGrid)
		end 
		--[[if mTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP then
			if EquipPropertyLayer.getEquipLayerControl()~=nil then
				EquipPropertyLayer.ClearMySelf()
			end
		end]]--
		DeleteLayer(mLayer)
		if mTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
			
			StrengthenNarmalLayer.ClearInterFace()
		end 
		UpdateDataList()
		MainScene.PopUILayer()
	end
	CreateBtnCallBack(btn_back_equiplist,nil ,0,callBack)
end


--装备入口
function CreateLayerEquipList(nLayerType,nGrid,nGridPos)
	local tableEquipInterface = {}
	tableEquipInterface.m_clone_item = nil 
	tableEquipInterface.m_check_box_type = nil 
	tableEquipInterface.m_type_layer = nLayerType
	tableEquipInterface.m_grid_equip = nGrid 
	tableEquipInterface.m_grid_pos = nGridPos
	tableEquipInterface.m_listView = nil 
	tableEquipInterface.UpdateList = UpdateList_Equip
	tableEquipInterface.Exit_MatriEquip_CallBack = Exit_MatriEquip_CallBack
	--tableEquipInterface.GetUIControl = GetUIControl
	
	
	tableEquipInterface.m_layer = TouchGroup:create()
	tableEquipInterface.m_layer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/WujiangListLayer.json"))
	--listView
	tableEquipInterface.m_listView = tolua.cast(tableEquipInterface.m_layer:getWidgetByName("listview_wujianglist"),"ListView")
	tableEquipInterface.m_listView:setClippingType(1)
	tableEquipInterface.m_listView:setItemsMargin(-30)
	
	InitData(tableEquipInterface)
	InitUI(tableEquipInterface)
	
	DealBackBtn(tableEquipInterface.m_layer,tableEquipInterface.m_type_layer,tableEquipInterface.m_grid_equip)
	
	
	--将主界面按钮重新加载一次
    require "Script/Main/MainBtnLayer"
    local temp_equipList = MainBtnLayer.createMainBtnLayer()
    tableEquipInterface.m_layer:addChild(temp_equipList, layerMainBtn_Tag, layerMainBtn_Tag)
	
	return tableEquipInterface
end
