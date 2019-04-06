


module("EquipCommon", package.seeall)

--数据
local GetTableDataByType = EquipListData.GetTableDataByType
local GetTypeByGrid = EquipListData.GetTypeByGrid
local GetCurLvByGird = EquipListData.GetCurLvByGird

local GetTableTreasure = EquipLogic.GetTableTreasure

function AddStrokeLabel(strokeLable,tag,pObject)
	
	if pObject:getChildByTag(tag)~=nil then
		pObject:getChildByTag(tag):setVisible(false)
		pObject:getChildByTag(tag):removeFromParentAndCleanup(true)
	end
	pObject:addChild(strokeLable,tag,tag)
end
--从这一级升级到下一级的信息layer所在的层，name 名称 ,value,值,isShow显示否
function SetLvUpdateInfo(layer,name,value,isShow,pos,tag)
	local object_info = nil 
	if name == nil then
		local img_r = tolua.cast(layer:getWidgetByName("img_r"),"ImageView")
		if isShow == true then
			
			object_info = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,value,pos,ccc3(81,113,39),ccc3(0,255,79),false,ccp(0,-2),2)
			AddStrokeLabel(object_info,100+tag,img_r)
		end
	else 
		object_info = tolua.cast(layer:getWidgetByName(name),"Label")
		if isShow == true then
			object_info:setText(value)
			object_info:setVisible(true)
		else
			object_info:setVisible(false)
		end
	end
	
end
--添加宝物的时候需要有品质框和背景
function AddEquipIcon(sreEquip,nGrid)
	--装备的icon
	local pPanel = Layout:create()
	--pPanel:setSize(CCSize(80,80 ))
	local img_equip = ImageView:create()
	img_equip:loadTexture(sreEquip)
	--print(sreEquip)
	--Pause()
	--img_equip:setScale(0.68)
	--底框
	local img_bg_icon = ImageView:create()
	img_bg_icon:loadTexture("Image/imgres/common/bottom.png")
	
	img_bg_icon:setScale(0.68)
	
	--品质框
	local pImgIconSide = ImageView:create()
	pImgIconSide:loadTexture("Image/imgres/common/color/wj_pz"..EquipListData.GetColorByGrid(nGrid)..".png")
	--pImgIconSide:setScale(0.68)
	AddStrokeLabel(img_equip,9,img_bg_icon)
	AddStrokeLabel(pImgIconSide,11,img_bg_icon)
	--加入等级
	--等级的背景
	local img_lv_bg = ImageView:create()
	img_lv_bg:loadTexture("Image/imgres/wujiang/lv_bg.png")
	img_lv_bg:setPosition(ccp(img_equip:getPositionX()-10,img_equip:getPositionY()-img_equip:getContentSize().height/4))
	
	local label_lv = Label:create()
	label_lv:setFontSize(18)
	label_lv:setText("LV"..GetCurLvByGird(nGrid))
	img_lv_bg:addChild(label_lv)
	AddLabelImg(img_bg_icon,1,pPanel)
	AddLabelImg(img_lv_bg,2,pPanel)
	return pPanel
end
function Update(nType,nGrid)
	--升级了有变动
	--[[print("Update")
	print(nType)
	print(nGrid)
	Pause()]]--
	EquipLogic.UpdateListData()
	
	EquipPropertyLayer.UpdateProperty(E_LAYER_TYPE.E_LAYER_TYPE_EQUIP,nGrid)
	--EquipListLayer.UpdateList(nType,nCurLv)
end

---翻页的逻辑
--如果是已经装备的只检出和当前类型一样的
local function CheckTable(tableEData,nGrid)
	local nCurType = tonumber(GetTypeByGrid(nGrid))
	local tableL = {}
	for key,value in pairs(tableEData) do 
		if tonumber(GetTypeByGrid(value.e_grid)) == nCurType then
			local tableN = {}
			tableN.e_grid = value.e_grid
			table.insert(tableL,tableN)
		end
	end
	return tableL
end
--检测是否到最后一个
local function CheckLBLast(curKey,Count)
	if curKey-1<=0 then
		return false
	end
	return true
end
local function CheckRBLast(curKey,Count)
	if curKey+1>Count then
		return false
	end
	return true
end
local function GetPageData(nGrid,nType)
	--需要宝物的格子，和选择的宝物
	local tableData = GetTableDataByType(nType,nGrid)
	
	if tableData~=nil then
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIPED then
			tableData = CheckTable(tableData,nGrid)
		end
	end
	
	return tableData
end
--nGrid当前的格子，nType当前的按钮类型（已装备，装备，宝物灵宝）,回调函数
function PageLeftLogic(nGrid,nType,LeftCallBack)
	local lTableData = GetPageData(nGrid,nType)
	
	for key,value in pairs(lTableData) do 
		if tonumber(value.e_grid)== tonumber(nGrid) then
			if CheckLBLast(key,#lTableData) == true then
				LeftCallBack(lTableData[key-1]["e_grid"])
			end
		end
	end
end
function PageRightLogic(nGrid,nType,RightCallBack)
	local rTableData = GetPageData(nGrid,nType)
	for key,value in pairs(rTableData) do 
		if tonumber(value.e_grid)== tonumber(nGrid) then
			if CheckRBLast(key,#rTableData) == true then
				RightCallBack(rTableData[key+1]["e_grid"])
			end
		end
	end
end

function DeleteImg(m_panel,strImg)
	if m_panel:getChildByName(strImg)~=nil then
		m_panel:getChildByName(strImg):removeFromParentAndCleanup(true)
	end
end