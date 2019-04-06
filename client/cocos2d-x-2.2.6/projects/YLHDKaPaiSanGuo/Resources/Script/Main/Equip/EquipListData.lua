
require "Script/serverDB/server_equipDB"
require "Script/serverDB/equipt"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/general"
require "Script/serverDB/resimg"
require "Script/serverDB/attribute"
require "Script/serverDB/xilianattribute"
require "Script/serverDB/xilian"
--装备列表数据

module("EquipListData", package.seeall)

TAG_STATE_EQUIPED = 1 
TAG_STATE_OTHER   = 2

GetEquipListCount = server_equipDB.GetCount()
 

local table_data_equiped  = nil 
local table_data_equip    = nil 
local table_data_treasure = nil 
local table_data_lingbao  = nil 


local bUpdateCount = false
local bUpdateInfo  = false
 
function GetTempID(nGird)
	return server_equipDB.GetTempIdByGrid(nGird)
end

local function GetInfoByStr(nGird,str)
	
	return equipt.getFieldByIdAndIndex(GetTempID(nGird),str)
end
function GetColorLvByGrid(nGrid)
	return GetInfoByStr(nGrid,"Level")
end

function GetTipsByGrid(nGrid)
	return GetInfoByStr(nGrid,"Tips")
end
function GetSellPriceByGrid(nGrid)
	return GetInfoByStr(nGrid,"Sell")
end
function GetSellTypeByGrid(nGrid)
	return GetInfoByStr(nGrid,"Type")
end
function GetCountEquipBag()
	return #server_equipDB.GetCopyTable()
end
function GetEquipCopyTable()
	
	return server_equipDB.GetCopyTable()
end
function CheckBHaveEquipByGrid(nGrid)
	local table_cur = server_equipDB.GetCopyTable()
	--[[printTab(table_cur)
	print("***************************")
	print(nGrid)
	Pause()]]--
	for key,value in pairs (table_cur) do 
		if tonumber(value["Grid"]) == tonumber(nGrid) then
			return true
		end
	end
	return false
end
function GetCountByType(nType)
	local count_type = 0
	
	for key,value in pairs (server_equipDB.GetCopyTable()) do 
		
		local eType = GetInfoByStr(value["Grid"],"Type")
		if tonumber(eType) == tonumber(nType) then
			count_type= count_type+1
		end
		
	end
	return count_type
end
--获得位置
function GetExampleByGrid(nGrid)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"Example")

end
function GetEquipNameByGrid(nGrid)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"Name")
end
--获得是否可以洗炼
function GetXLState(nGrid)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"XiLLimit")
end
--获得品质
function GetColorByGrid(nGrid)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"Color")
end
--获得可达到的最高等级
function GetHighestLvByGrid(nGrid)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"QiangHLv")
end
--获得强化的最高等级
function GetHighStrengthLvByGrid(nGrid)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"QiangHLimit")
end
function GetEquipedName(nGird)
	local str_name = nil 
	if	server_matrixDB.IsShangZhenEquip(nGird) == true then
		--print("GetEquipedName")
		local g_grid = server_matrixDB.GetGeneralGridByEquipGrid(nGird)
		if g_grid~= nil then
			local general_tempid = server_generalDB.GetTempIdByGrid(g_grid)
			-- print("general_tempid=="..general_tempid)
			if general_tempid~=nil then
				local general_name = nil 
				if  tonumber(general.getFieldByIdAndIndex(general_tempid, "Type")) == GeneralType.Main then
					general_name = CommonData.g_MainDataTable["name"]
				else
					general_name = general.getFieldByIdAndIndex(general_tempid, "Name")
				end
				--print(general_name)
				str_name = tostring(general_name)
			end
		end
		-- print("general_grid=="..general_grid)
	end
	return str_name

end

function GetEquipedCount()
	local count_type = 0
	for key,value in pairs (server_equipDB.GetCopyTable()) do 
		
		if GetEquipedName(value["Grid"])~=nil then
			count_type = count_type+1
		end
	end
	return count_type

end
local function checkSuit(nGrid)
	if tonumber( GetInfoByStr(nGrid,"Type") )== E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT then
		return true
	end
	return false
end
--获得需要的装备数据返回table
local function getTableListNeed(table_get,nGrid,state)
	--local table_data_i = {e_state = "",e_grid ="",e_name="",e_pinji="",e_euiped_name ="",e_color= ""}
	local table_data_i ={}
	table_data_i.e_state = state
	table_data_i.e_grid = nGrid
	table_data_i.e_tempID = GetTempID(nGrid)
	table_data_i.e_name = GetInfoByStr(nGrid,"Name")
	table_data_i.e_pinji = GetInfoByStr(nGrid,"Level")
	table_data_i.e_euiped_name = GetEquipedName(nGrid)
	table_data_i.e_color = GetInfoByStr(nGrid,"Color")
	table_data_i.e_suit = checkSuit(nGrid)
	table.insert(table_get,table_data_i)
	table_data_i = nil 
	
	return table_get
end
local function CheckBTreasureSelect(nGrid,nGridTreasure)
	local curPos = GetExampleByGrid(nGridTreasure)
	local nPos = GetExampleByGrid(nGrid)
	if nGridTreasure~=nil then
		if tonumber(nGrid) ~= tonumber(nGridTreasure) and 
			tonumber(GetInfoByStr(nGrid,"Type")) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE and
			tonumber(curPos) == tonumber(nPos) then
			return true
		end
	end
	return false
end
--根据进入列表的类型再过滤一次
local function GetFilterData(tableObject,nGrid,nTag,nTypeLayer,nPosGrid,nGridTreasure)
	if nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
		if nGridTreasure~=nil then
			if CheckBTreasureSelect(nGrid,nGridTreasure) == true then
				return getTableListNeed(tableObject,nGrid,nTag)
			end
		end
		
	elseif nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_LIST then
		return  getTableListNeed(tableObject,nGrid,nTag)
	elseif nTypeLayer == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP then
		--装备列表过来的需要显示匹配的Pos的装备
		local needPos = nPosGrid
		local nowPos  = GetExampleByGrid(nGrid)
		if MatrixLayer.getCurPos() == 6 then
			--只显示灵宝
			if tonumber(nowPos) == 0 then
				return  getTableListNeed(tableObject,nGrid,nTag)
			end
		else
			if tonumber(nowPos) == tonumber(needPos) then
				return  getTableListNeed(tableObject,nGrid,nTag)
			end
		end
		
	end
	
	return {}
end
local function GetEuipedData(nTypeLayer,nPosGrid,nGridTreasure)
	
	local table_new = server_equipDB.GetCopyTable()
	if table_data_equiped == nil then
		table_data_equiped = {}
		for key,value in pairs (table_new) do 
			if GetEquipedName(value["Grid"])~=nil then
				GetFilterData(table_data_equiped,value["Grid"],TAG_STATE_EQUIPED,nTypeLayer,nPosGrid,nGridTreasure)
			end
		end
	end
	
	return table_data_equiped
end

local function GetEquipData(nType,nTypeLayer,nPosGrid,nGridTreasure)
	local table_need = {} 
	local type_e = 0
	if nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP then
		--print(table_data_equip)
		--Pause()
		if table_data_equip == nil then
			table_data_equip = {}
			table_need = table_data_equip
		else
			return table_data_equip
		end
		
		type_e = E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP
	elseif  nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE then
		if table_data_treasure == nil then
			table_data_treasure = {}
			table_need = table_data_treasure
		else
			return table_data_treasure
		end
		type_e = E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE
	elseif  nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO then
		if table_data_lingbao == nil then
			table_data_lingbao = {}
			table_need = table_data_lingbao
		else
			return table_data_lingbao
		end
		type_e = E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO
	end	
	
	if #table_need == 0  then
		for key,value in pairs(server_equipDB.GetCopyTable()) do 
			local n_typeNow = tonumber(GetInfoByStr(value["Grid"],"Type"))
			if type_e == E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP  then
				--属于装备
				
				if n_typeNow ==E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP  or n_typeNow == E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT then
					--getTableListNeed(table_need,value["Grid"],TAG_STATE_OTHER)
					if GetEquipedName(value["Grid"])==nil then
						--print("装备")
						GetFilterData(table_need,value["Grid"],TAG_STATE_OTHER,nTypeLayer,nPosGrid,nGridTreasure)
					end
				end
			elseif type_e >E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT  then
				if type_e == n_typeNow then
					--getTableListNeed(table_need,value["Grid"],TAG_STATE_OTHER)
					if GetEquipedName(value["Grid"])==nil then
						GetFilterData(table_need,value["Grid"],TAG_STATE_OTHER,nTypeLayer,nPosGrid,nGridTreasure)
					end
				end
			end
		end
	end
	--[[print("****************table_need**********************")
	printTab(table_need)
	Pause()]]--
	return table_need
end
--得到武将的次序ID
local function GetEquipedWJSortID(nEquipGrid)
	local wj_grid = server_matrixDB.GetGeneralGridByEquipGrid(nEquipGrid)
	local mGrid = server_matrixDB.GetMatrixDBByWJ(wj_grid)
	return tonumber(mGrid)
end
local function SortEquip(tableData,nLayerType)
	
	local function sortLvColorDes(a,b)
		if tonumber(GetCurLvByGird(a.e_grid))== tonumber(GetCurLvByGird(b.e_grid)) then
			if tonumber(a.e_pinji) == tonumber(b.e_pinji) then
				return tonumber(a.e_color)>tonumber(b.e_color)
			else
				return tonumber(a.e_pinji)>tonumber(b.e_pinji)
			end
			
		else
			return tonumber(GetCurLvByGird(a.e_grid))>tonumber(GetCurLvByGird(b.e_grid))
		end
	end
	local function sortTreasureDes(a,b)
		if tonumber(GetCurLvByGird(a.e_grid))== tonumber(GetCurLvByGird(b.e_grid)) then
			if tonumber(GetStarLvByGrid(a.e_grid)) == tonumber(GetStarLvByGrid(b.e_grid)) then
				--如果精练等级相等
				if tonumber(a.e_pinji) == tonumber(b.e_pinji) then
					return tonumber(a.e_color)>tonumber(b.e_color)
				else
					return tonumber(a.e_pinji)>tonumber(b.e_pinji)
				end
			else
				return tonumber(GetStarLvByGrid(a.e_grid))>tonumber(GetStarLvByGrid(b.e_grid))
			end
		else
			return tonumber(GetCurLvByGird(a.e_grid))>tonumber(GetCurLvByGird(b.e_grid))
		end
	end
	local function sortSelectTreasureDes(a,b)
		
		if tonumber(GetCurLvByGird(a.e_grid))== tonumber(GetCurLvByGird(b.e_grid)) then
			if tonumber(a.e_pinji) == tonumber(b.e_pinji) then
				if tonumber(a.e_color) == tonumber(b.e_color) then
					return tonumber(GetStarLvByGrid(a.e_grid))<tonumber(GetStarLvByGrid(b.e_grid))
				else
					return tonumber(a.e_color)<tonumber(b.e_color)
				end
				
			else
				return tonumber(a.e_pinji)<tonumber(b.e_pinji)
			end
		else
			return tonumber(GetCurLvByGird(a.e_grid))<tonumber(GetCurLvByGird(b.e_grid))
		end
	end
	if #tableData~= 0 and tonumber(GetInfoByStr(tableData[1].e_grid,"Type")) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
		--如果是宝物，按宝物的顺序排
		--如果是选择宝物那么按宝物的选择顺序排
		if nLayerType == ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_TREASURE_SLECTED then
			table.sort(tableData,sortSelectTreasureDes)
		else
			table.sort(tableData,sortTreasureDes)
		end
	else
		table.sort(tableData,sortLvColorDes)
	end
	
	return tableData
end
local function SortEquiped(tableEquiped)
	if #tableEquiped~=0 then
		local function SortByWJ(a,b)
			if GetEquipedWJSortID(a.e_grid) == GetEquipedWJSortID(b.e_grid)  then
				return tonumber(GetExampleByGrid(a.e_grid))< tonumber(GetExampleByGrid(b.e_grid))
			else
				return GetEquipedWJSortID(a.e_grid)<GetEquipedWJSortID(b.e_grid) 
			end
		end
		table.sort(tableEquiped,SortByWJ)
	end
	return tableEquiped
end

function GetListDataByType(nType,nTypeLayer,nGridTreasure,nPosGrid)
	--[[print(nType)
	Pause()]]--
	if nType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIPED then
		--返回所有已装备的数据
		return SortEquiped(GetEuipedData(nTypeLayer,nPosGrid,nGridTreasure),nTypeLayer)
	else
		return SortEquip(GetEquipData(nType,nTypeLayer,nPosGrid,nGridTreasure,nil),nTypeLayer)
	end
	
	return nil 
end


function DeleteData(tableData)

end
function UpdateDataList()
	table_data_equiped  = nil 
	table_data_equip    = nil 
	table_data_treasure = nil 
	table_data_lingbao  = nil 
end
--获得类型
function GetTypeByGrid(nGrid)
	return tonumber(equipt.getFieldByIdAndIndex(GetTempID(nGrid),"Type"))
end
--获得当前等级

function GetCurLvByGird(nGird)
	local cur_lv = 0 
	if tonumber(GetTypeByGrid(nGird)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
		cur_lv = server_equipDB.GetLevelByGrid(nGird)--server_equipDB.GetXLTimesByGrid(nGird)
		return cur_lv
	else
		cur_lv = server_equipDB.GetLevelByGrid(nGird)
		if tonumber(cur_lv) == -1 then
			cur_lv = 0
		end
		return tonumber(cur_lv)
	end
	return -1
end
function GetJinLExpByGrid(nGird)
	return equipt.getFieldByIdAndIndex(GetTempID(nGird),"JinLExp")
end

--得到达到解锁第一个等级的等级
function GetLockLvByGrid(nGird,strHLv)
	return tonumber(equipt.getFieldByIdAndIndex(GetTempID(nGird),strHLv))
end

function GetEquipIconPathByGrid(nGird)
	local resID = equipt.getFieldByIdAndIndex(GetTempID(nGird),"AnimationID")
	return resimg.getFieldByIdAndIndex(resID,"icon_path")

end
function GetEquipColorIconByGrid(nGrid)
	local nPinzhi = equipt.getFieldByIdAndIndex(GetTempID(nGrid),"Color")
	return string.format("Image/imgres/common/color/wj_pz%d.png",nPinzhi)
end
function GetStarLvByGrid(nGrid)
	return server_equipDB.GetXLTimesByGrid(nGrid)
end
function GetXLTimes(nGrid)
	return server_equipDB.GetXLTimesByGrid(nGrid)
end
-----------------套装---------------------------------
function GetSuitEvName(nGrid,str_suit)
	local s_id = GetSuitID(nGrid)
	local ep_id = suit.getFieldByIdAndIndex(s_id,str_suit)
	return equipt.getFieldByIdAndIndex(ep_id,"Name")
end
--套装部分
function GetSuitID(nGrid)
	return tonumber(equipt.getFieldByIdAndIndex(GetTempID(nGrid),"SuitID"))
end
function GetSuitEvColorPath(nGrid,str_suit)
	local ep_id = suit.getFieldByIdAndIndex(GetSuitID(nGrid),str_suit)
	local ep_color = equipt.getFieldByIdAndIndex(ep_id,"Color")
	local str_psth = "Image/imgres/common/color/wj_pz"..ep_color..".png"
	return str_psth
end
--该套装是否已经装备
function GetSuitLive(nGrid,str_suit)
	local ep_id = suit.getFieldByIdAndIndex(GetSuitID(nGrid),str_suit)
	local wj_grid = server_matrixDB.GetGeneralGridByEquipGrid(nGrid)
	if wj_grid~=nil then
		--说明这个已经被装备上
		local wj_equip_tab = server_matrixDB.GetEquipListByGeneralGrid(wj_grid)
		--printTab(wj_equip_tab)
		for key, value in pairs(wj_equip_tab) do
			--得到装备的id
			local id_equip = server_equipDB.GetTempIdByGrid(value)
			--print("id_equip"..id_equip)
			if tonumber(id_equip) == tonumber(ep_id) then
				return true
			end
		end
	end
	return false
end
function GetSuitEpPath(nGrid,str_suit)
	local ep_id = suit.getFieldByIdAndIndex(GetSuitID(nGrid),str_suit)
	local res_id = equipt.getFieldByIdAndIndex(ep_id,"AnimationID")
	return resimg.getFieldByIdAndIndex(res_id,"icon_path")
end
function GetSuitNameByGird(nGrid)
	return suit.getFieldByIdAndIndex(GetSuitID(nGrid),"SuitName")
end
----attribute 相关---
--得到基础ID
function GetBaseIDByGridStr(nGrid,strBase)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),strBase)
end
--通过Grid得到名字
function GetBaseNameByGrid(nGrid,strBase)
	return attribute.getFieldByIdAndIndex(GetBaseIDByGridStr(nGrid,strBase),"name")
end
--通过Grid得到Value
function GetBaseValueByGrid(nGrid,strBase)
	return attribute.getFieldByIdAndIndex(GetBaseIDByGridStr(nGrid,strBase),"value")
end
--获得基础属性的类型
function GetBaseTypeByGrid(nGrid,strBase)
	return attribute.getFieldByIdAndIndex(GetBaseIDByGridStr(nGrid,strBase),"type")
end
--根据等级获得增量表的value
function GetBaseAddValue(baseID,strBaseAdd)
	return attributincremental.getFieldByIdAndIndex(baseID,strBaseAdd)
end
function GetBaseMethodByBaseID(baseID)
	return attribute.getFieldByIdAndIndex(baseID,"valuse_method")
end
--强化基础信息
function GetQHConsumeIDByGrid(nGrid)--强化消耗ID
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"QiangHConsumeID")
end
function GetQHUnlockLv(nGrid,strLv)
	--"QiangHLv_1"
	return  equipt.getFieldByIdAndIndex(GetTempID(nGrid),strLv)
end
---------------------------
--获得两个等级的差值
function GetValueByLvID(nGrid,n_OldLv,n_CurLv)
	local table_base = {}
	for i=1,2 do
		local baseid = GetBaseIDByGridStr(nGrid,"BaseAttitude_"..i)
		--[[print(baseid)
		Pause()]]--
		if tonumber(baseid)~=-1 then
			local table_l = {}
			table_l.baseName = GetBaseNameByGrid(nGrid,"BaseAttitude_"..i)
			local value_old = nil 
			if tonumber(n_OldLv) == 0 then
				value_old = GetBaseValueByGrid(nGrid,"BaseAttitude_"..i)
				
			else
				value_old = GetBaseAddValue(baseid,"Inc_Att_"..n_OldLv)
			end
			local value_now = nil 
			if tonumber(n_CurLv) == 0 then
				value_now = GetBaseValueByGrid(nGrid,"BaseAttitude_"..i)
				
			else
				value_now = GetBaseAddValue(baseid,"Inc_Att_"..n_CurLv)
			end
			
			table_l.addValue = tonumber(value_now) - tonumber(value_old)
			table.insert(table_base,table_l)
		end
	end
	--[[print("================****===============")
	printTab(table_base)]]--
	return table_base
end
--精炼的信息
function GetValueRefineByLvID(nGrid,n_OldLv,n_CurLv)
	local table_refine = {}
	for i=1,3 do
		local refineId = GetBaseIDByGridStr(nGrid,"XiLAttitude_"..i)
		--[[print(baseid)
		Pause()]]--
		if tonumber(refineId)~=-1 then
			local table_l = {}
			table_l.baseName = GetBaseNameByGrid(nGrid,"XiLAttitude_"..i)
			local value_old = nil 
			if tonumber(n_OldLv) == 0 then
				value_old = GetBaseValueByGrid(nGrid,"XiLAttitude_"..i)
				
			else
				value_old = GetBaseAddValue(refineId,"Inc_Att_"..n_OldLv)
			end
			local value_now = nil 
			if tonumber(n_CurLv) == 0 then
				value_now = GetBaseValueByGrid(nGrid,"XiLAttitude_"..i)
				
			else
				value_now = GetBaseAddValue(refineId,"Inc_Att_"..n_CurLv)
			end
			
			table_l.addValue = tonumber(value_now) - tonumber(value_old)
			table.insert(table_refine,table_l)
		end
	end
	--[[print("================****===============")
	printTab(table_base)]]--
	return table_refine

end
----------------------------

-------------------左右按键需要------------------------------
local function GetTableDataPage(tableBack,nGrid)
	local tableN = {}
	tableN.e_grid = nGrid
	table.insert(tableBack,tableN)
	tableN = nil 
	
end
local function GetTableDataPageByType(tableOwn,nType)
	local tableNow = {}
	
	for key,value in pairs(tableOwn) do 
		if nType ==  ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIPED then
			if GetEquipedName(value["Grid"])~=nil then
				GetTableDataPage(tableNow,value["Grid"])
			end
		end
		local typeValue = GetTypeByGrid(value["Grid"])
		if nType ==  ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP then
			
			if tonumber(typeValue) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP or 
			tonumber(typeValue) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT then
				if GetEquipedName(value["Grid"])==nil then
					GetTableDataPage(tableNow,value["Grid"])
				end
			end
		end
		if nType ==  ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE then
			if tonumber(typeValue) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE then
				if GetEquipedName(value["Grid"])==nil then
					
					GetTableDataPage(tableNow,value["Grid"])
				end
			end
		end
		if nType ==  ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO then
			if tonumber(typeValue) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO then
				if GetEquipedName(value["Grid"])==nil then
					GetTableDataPage(tableNow,value["Grid"])
				end
			end
		end
	end
	
	return tableNow
end
--传入 按钮的类型（哪一组）,nTypeLayer，当前的界面类型（那种界面进来的）,
--nGridTreasure 如果是宝物强化进来的那么需要传入当前的宝物的格子以便剔除
--tableSelect 如果已经选择宝物那么左右按键的时候需要剔除这几个
function GetTableDataByType(nType,nGridTreasure)
	local tableNeed = {}
	local tableEquip = server_equipDB.GetCopyTable()
	local tableNeed = GetTableDataPageByType(tableEquip,nType)
	
	return tableNeed
end
-------------------------------------------------

--------------------------精炼---------------------------
function GetJLConsumeIDByGrid(nGrid)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),"JingLConsumeID")
end
------------------------end------------------------------
-----------------------洗炼--------------------------------
function GetXLLimitValueByLv(limitID,strLv)
	return xilianattribute.getFieldByIdAndIndex(limitID,strLv)

end

------------------------end------------------------------

local function SortItemEquip(tableData,nEquipType)
	local function SortLvColorEquip(a,b)
		if tonumber(GetCurLvByGird(a.Grid))== tonumber(GetCurLvByGird(b.Grid)) then
			if tonumber(GetColorLvByGrid(a.Grid)) == tonumber(GetColorLvByGrid(b.Grid)) then
				if tonumber(GetColorByGrid(a.Grid)) == tonumber(GetColorByGrid(b.Grid)) then
					return a.Grid<b.Grid
				else
					return tonumber(GetColorByGrid(a.Grid))>tonumber(GetColorByGrid(b.Grid))
				end
				
			else
				return tonumber(GetColorLvByGrid(a.Grid))>tonumber(GetColorLvByGrid(b.Grid))
			end
			
		else
			return tonumber(GetCurLvByGird(a.Grid))>tonumber(GetCurLvByGird(b.Grid))
		end
	end
	local function SortTreasure(a,b)
		if tonumber(GetCurLvByGird(a.Grid))== tonumber(GetCurLvByGird(b.Grid)) then
			if tonumber(GetStarLvByGrid(a.Grid)) == tonumber(GetStarLvByGrid(b.Grid)) then
				if tonumber(GetColorByGrid(a.Grid))==tonumber(GetColorByGrid(b.Grid)) then
					if tonumber(GetColorByGrid(a.Grid)) == tonumber(GetColorByGrid(b.Grid)) then
						return a.Grid<b.Grid
					else
						return  tonumber(GetColorByGrid(a.Grid))>tonumber(GetColorByGrid(b.Grid))
					end
					
				else
					return tonumber(GetColorByGrid(a.Grid))>tonumber(GetColorByGrid(b.Grid))
				end
				
			else
				return tonumber(GetStarLvByGrid(a.Grid))>tonumber(GetStarLvByGrid(b.Grid))
			end
			
		else
			return tonumber(GetCurLvByGird(a.Grid))>tonumber(GetCurLvByGird(b.Grid))
		end
	end
	
	if nEquipType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP  or nEquipType==ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO  then
		table.sort(tableData,SortLvColorEquip)
	end
	if nEquipType == ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE  then
		table.sort(tableData,SortTreasure)
	end
	
end
--该装备是否已经装备
function CheckBEquipedByGird(nGird)
	return server_matrixDB.IsShangZhenEquip(nGird)
end
------------------------道具界面需要的数据----------------------------------
function GetEquipDataByType(nType,tableType)
	for key,value in pairs(server_equipDB.GetCopyTable()) do 
		local n_typeNow = tonumber(GetInfoByStr(value["Grid"],"Type"))
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP then
			--属于装备
			if n_typeNow ==E_BAGITEM_TYPE.E_BAGITEM_TYPE_EQUIP  or n_typeNow == E_BAGITEM_TYPE.E_BAGITEM_TYPE_SUIT then
				--getTableListNeed(table_need,value["Grid"],TAG_STATE_OTHER)
				if GetEquipedName(value["Grid"])==nil then
					table.insert(tableType,value)
				end
			end
		end
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE then
			if n_typeNow == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE  then
				if GetEquipedName(value["Grid"])==nil then
					table.insert(tableType,value)
				end
			end
		end
		if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO then
			if n_typeNow == E_BAGITEM_TYPE.E_BAGITEM_TYPE_LINGBAO  then
				if GetEquipedName(value["Grid"])==nil then
					table.insert(tableType,value)
				end
			end
		end
	end
	SortItemEquip(tableType,nType)
	
end
------------------------end--------------------------------------------------
