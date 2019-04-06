
module("ItemGoods", package.seeall)


--变量
local m_scrollview_goods = nil
local m_img_select       =nil
local m_callBack         = nil 
local m_table_LotSelect = nil 
local m_PointManger      = nil
--数据
local GetTableDataByType = ItemData.GetTableDataByType
local GetNumByGird       = ItemData.GetNumByGird


--逻辑
local GetScrollviewRow  = ItemLogic.GetScrollviewRow
local GetScrollviewCol  = ItemLogic.GetScrollviewCol
local SearchByGrid = ItemLogic.SearchByGrid

local GetTypeByTableData = ItemLogic.GetTypeByTableData
local GetTempIDByTableData = ItemLogic.GetTempIDByTableData
local CheckBEquipNow      = ItemLogic.CheckBEquipNow

local CheckItemRedPoint = ItemLogic.CheckItemRedPoint -- 检测小红点

--每行的数量
local per_row_num = 4 
function SetSelectIconState(bShow)
	if m_img_select~=nil then
		m_img_select:setVisible(bShow)
	end
end
local function _Btn_Icon_Item_CallBack(nGrid,sender)
	if m_scrollview_goods:getChildByTag(TAG_GRID_ADD+nGrid)~=nil then
		local m_state = ItemListLayer.GetGoodsState()
		if tonumber(m_state) == 0 then
			local posX =  m_scrollview_goods:getChildByTag(TAG_GRID_ADD+nGrid):getPositionX()
			local posY =  m_scrollview_goods:getChildByTag(TAG_GRID_ADD+nGrid):getPositionY()
			if m_img_select~=nil then
				--print("m_img_select==========")
				--Pause()
				m_img_select:setPosition(ccp(posX,posY))
			end
			if m_callBack~=nil then
				m_callBack(nGrid)
			end
		end
		if tonumber(m_state) == 1 then
			
			ItemLotSelectLogic.DealLotGoodsSelect(sender)
		end
		
		--ItemSelectInfo.updateSelectInfo()
	end
end


local function AddSelectIcon(nNowGrid,nCurGrid,nCurInex,nType,posImg)
	if tonumber(nNowGrid) == (tonumber(nCurGrid)) then
		--添加选中框
		if  m_scrollview_goods:getChildByTag(nCurInex)== nil then
			--print(m_img_select)
			if m_img_select == nil then
				m_img_select = ImageView:create()
				if  tonumber(nType)<=ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
					m_img_select:loadTexture("Image/imgres/item/selected_icon.png")
				elseif tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP then
					m_img_select:loadTexture("Image/imgres/item/selected_xie_icon.png")
				elseif tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH then
					m_img_select:loadTexture("Image/imgres/item/selected_xie_icon.png")
				end
				m_img_select:setPosition(posImg)
				m_img_select:setScale(0.75)
				m_scrollview_goods:addChild(m_img_select,0,nCurInex)
			end
		end
	end
end

local function LoadScrollItems(m_data,cur_index,l_row,l_col,nCurGrid,nType)
	local m_type = GetTypeByTableData(m_data,cur_index,nType)
	local m_gird = m_data[cur_index]["Grid"]
	local m_tempId = GetTempIDByTableData(m_data,cur_index,nType)
	
	local m_size_view = m_scrollview_goods:getInnerContainerSize()
	--
	
	--AddSelectIcon(m_gird,nCurGrid,cur_index,nType,ccp(73+l_col*125,m_size_view.height-70-l_row*130))
	AddSelectIcon(m_gird,nCurGrid,cur_index,nType,ccp(53+l_col*96,m_size_view.height-60-l_row*100))
	--物品的icon
	local img_item_bi = ImageView:create()
	img_item_bi:setTag(TAG_GRID_ADD+tonumber(m_gird))
	--img_item_bi:setPosition(ccp(73+l_col*125,m_size_view.height-70-l_row*130))
	img_item_bi:setPosition(ccp(53+l_col*96,m_size_view.height-60-l_row*100))
	if CheckBEquipNow(nType)  == true then
		--表示装备
		local pClickControl = UIInterface.MakeHeadIcon(img_item_bi, ICONTYPE.EQUIP_ICON, m_tempId,m_gird)
		img_item_bi:setScale(0.75)
		pClickControl:setTag(TAG_GRID_ADD+tonumber(m_gird))
		CreateItemCallBack(pClickControl,false,_Btn_Icon_Item_CallBack,nil)
		local tab = {}
		tab[1]= pClickControl
		tab[2]= img_item_bi
		m_table_LotSelect[cur_index] = tab
		
	else
		local pClickControl = UIInterface.MakeHeadIcon(img_item_bi, ICONTYPE.ITEM_ICON, m_tempId,nil)
		img_item_bi:setScale(0.75)
		pClickControl:setTag(TAG_GRID_ADD+tonumber(m_gird))

		--碎片添加小红点
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP then
			if CheckItemRedPoint(m_gird) == true then
				m_PointManger:ShowRedPoint(m_gird,pClickControl,-44,46)
			else
				if pClickControl:getChildByTag(m_gird) ~= nil then
					pClickControl:getChildByTag(m_gird):removeFromParentAndCleanup(true) 
				end
			end
		end


		CreateItemCallBack(pClickControl,false,_Btn_Icon_Item_CallBack,nil)
		--添加数量
		local label_num = LabelLayer.createStrokeLabel(22,CommonData.g_FONT3,GetNumByGird(m_gird),ccp(-50,-40),COLOR_Black,COLOR_White,false,ccp(0,-2),2)
		AddLabelImg(label_num,5000,img_item_bi)
		local tab = {}
		tab[1]= pClickControl
		tab[2]= img_item_bi
		m_table_LotSelect[cur_index] = tab
	end
	
	
	
	m_scrollview_goods:addChild(img_item_bi,0,TAG_GRID_ADD+tonumber(m_gird))
end
local function InitScrollviewGoods(nType,nCurGrid,fCallBack)
	local m_table_curtype_data = GetTableDataByType(nType)
	local table_count = #m_table_curtype_data
	if table_count<per_row_num then
		table_count = per_row_num
	end
	
	if nCurGrid==nil or SearchByGrid(nCurGrid,m_table_curtype_data) == false  then
		--默认选择第一个
		nCurGrid = m_table_curtype_data[1]["Grid"]
		if fCallBack~=nil then
			fCallBack(nCurGrid)
		end
	else
		fCallBack(nCurGrid)
	end
	--print(table_count)
	local nCountRow = math.floor(table_count/per_row_num)
	local nStay = table_count%per_row_num
	if nStay>0 then
		nCountRow = nCountRow +1
	end
	--local nCountRow = math.ceil(table_count/3)
	m_scrollview_goods:setInnerContainerSize(CCSize(397,nCountRow*(116*0.75)+14+(nCountRow-1)*14))
	local m_row = GetScrollviewRow(table.getn(m_table_curtype_data))
	local m_col = GetScrollviewCol(table.getn(m_table_curtype_data))
	
	for i=0,m_row-1 do 
		--每行三列 修改为每行四列
		for j=0,m_col do 
			LoadScrollItems(m_table_curtype_data,i*per_row_num+j+1,i,j,nCurGrid,nType)
		end
	end
	if table_count%per_row_num ==1 then
		LoadScrollItems(m_table_curtype_data,m_row*per_row_num+0+1,m_row,0,nCurGrid,nType)
	elseif table_count%per_row_num ==2 then
		
		LoadScrollItems(m_table_curtype_data,m_row*per_row_num+0+1,m_row,0,nCurGrid,nType)
		LoadScrollItems(m_table_curtype_data,m_row*per_row_num+1+1,m_row,1,nCurGrid,nType)
	elseif table_count%per_row_num ==3 then
		
		LoadScrollItems(m_table_curtype_data,m_row*per_row_num+0+1,m_row,0,nCurGrid,nType)
		LoadScrollItems(m_table_curtype_data,m_row*per_row_num+1+1,m_row,1,nCurGrid,nType)
		LoadScrollItems(m_table_curtype_data,m_row*per_row_num+2+1,m_row,2,nCurGrid,nType)
	end
	
end
function GetTabLot()
	return m_table_LotSelect
end

function ClearTabLot()
	if m_table_LotSelect~=nil then
		m_table_LotSelect={}
	end
end

function ClearGoods()
	m_scrollview_goods = nil
	m_callBack         = nil 
	m_table_LotSelect = nil 
end
function CreateItemGoods(mLayerGoods,bBoxType,nCurGrid,fCallBack)
	local m_panel_right = tolua.cast(mLayerGoods:getWidgetByName("img_bg_items_bi"),"ImageView")
	m_scrollview_goods = tolua.cast(mLayerGoods:getWidgetByName("scrollview_bi"),"ScrollView")
	m_scrollview_goods:removeAllChildrenWithCleanup(true)
	m_img_select = nil
	m_PointManger = AddPoint.CreateAddPoint()
	if m_table_LotSelect==nil then
		m_table_LotSelect = {}
	end
	if nCurGrid ==nil then
		
		m_img_select = nil
	end
	m_scrollview_goods:setClippingType(1)
	m_callBack = fCallBack
	
	InitScrollviewGoods(bBoxType,nCurGrid,fCallBack)
	
end