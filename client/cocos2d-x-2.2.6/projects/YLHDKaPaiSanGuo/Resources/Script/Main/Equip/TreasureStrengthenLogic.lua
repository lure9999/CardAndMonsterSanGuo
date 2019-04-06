

module("TreasureStrengthenLogic", package.seeall)

--数据
local GetColorByGrid = EquipListData.GetColorByGrid
local GetTypeByGrid = EquipListData.GetTypeByGrid
local GetExampleByGrid = EquipListData.GetExampleByGrid
local GetCurLvByGird = EquipListData.GetCurLvByGird
local GetJinLExpByGrid = EquipListData.GetJinLExpByGrid
local GetQHLimitLvByGrid = EquipOperateData.GetQHLimitLvByGrid
local GetColorLvByGrid  = EquipListData.GetColorLvByGrid
local GetStarLvByGrid   = EquipListData.GetStarLvByGrid

--逻辑

local GetNeedExpByGirdLv = EquipStrengthenLogic.GetNeedExpByGirdLv
local GetHeapExpByGrid   = EquipStrengthenLogic.GetHeapExpByGrid
local RunActionArrTip    = EquipStrengthenLogic.RunActionArrTip
local ShowUpLvEffect     = EquipStrengthenLogic.ShowUpLvEffect
local RunActionTableData = EquipStrengthenLogic.RunActionTableData
local GetSelecExp        = EquipStrengthenLogic.GetSelecExp

function AddNewLayer(oldLayer,newLayer)
	if oldLayer:getChildByTag(10)~=nil then
		oldLayer:getChildByTag(10):setVisible(false)
		oldLayer:getChildByTag(10):removeFromParentAndCleanup(true)
	end
	oldLayer:addChild(newLayer,0,10)
end
local function SortTreasure(tableTreasure)
	local function sortByGrid(a,b)
		if tonumber(GetCurLvByGird(a.m_grid))== tonumber(GetCurLvByGird(b.m_grid)) then
			if tonumber(GetColorLvByGrid(a.m_grid)) == tonumber(GetColorLvByGrid(b.m_grid)) then
				if tonumber(GetColorByGrid(a.m_grid)) == tonumber(GetColorByGrid(b.m_grid)) then
					return tonumber(GetStarLvByGrid(a.m_grid))<tonumber(GetStarLvByGrid(b.m_grid))
				else
					return tonumber(GetColorByGrid(a.m_grid))<tonumber(GetColorByGrid(b.m_grid))
				end
				
			else
				return tonumber(GetColorLvByGrid(a.m_grid))<tonumber(GetColorLvByGrid(b.m_grid))
			end
		else
			return tonumber(GetCurLvByGird(a.m_grid))<tonumber(GetCurLvByGird(b.m_grid))
		end
	end
	table.sort(tableTreasure,sortByGrid)
	local tableNew = {}
	for key,value in pairs(tableTreasure) do 
		if key<6 then
			tableNew[key] = value
		end
	end
	return tableNew
end 
--计算所吃的宝物的经验 公式，1-n级经验之和加初始经验
local function GetEatTereasureExpByGrid(nGrid)
	local m_qh_lv = tonumber(GetCurLvByGird(nGrid))
	if m_qh_lv>0 then
		return GetHeapExpByGrid(nGrid,m_qh_lv)
	else
		return GetJinLExpByGrid(nGrid)
	end
	return 0
end
--监测所加的是否超出升级所需要的
local function CheckTable(nGrid,tableT)
	local m_bw_lv = tonumber(GetCurLvByGird(nGrid))
	local l_limit_lv = tonumber(GetQHLimitLvByGrid(nGrid))
	if ( m_bw_lv+1 )>= l_limit_lv then
		--如果下一级大于等于限制等级那么需要删除一些消耗品
		--首先得到升到限制加1级所需要的经验 所添加的不能超过限制等级上限加1
		local l_exp = GetNeedExpByGirdLv(nGrid,l_limit_lv+1-m_bw_lv)
		local add_exp  = 0 
		local i =1 
		while i<#tableT do 
			add_exp = add_exp + GetEatTereasureExpByGrid(tableT[i].m_grid)
			--print("add_exp:"..add_exp..":"..i)
			if add_exp>= l_exp then
				table.remove(tableT,i+1)
			else
				i=i+1
			end
		end
	end
	return tableT
end
function GetAutoAddTreasureTable(nGrid)
	local equipTable =  server_equipDB.GetCopyTable()
	local curExzample = GetExampleByGrid(nGrid)
	local TreasureTable = {}
	for key,value in pairs(equipTable) do 
		local bZhuangbei = server_matrixDB.IsShangZhenEquip(value.Grid)
		if tonumber(GetTypeByGrid(nGrid)) == E_BAGITEM_TYPE.E_BAGITEM_TYPE_TREASURE and 
			tonumber(GetExampleByGrid(value.Grid)) == tonumber(curExzample)		 and
			bZhuangbei == false and
			tonumber(nGrid)~= value.Grid then
			local nTempTable = {}
			nTempTable.m_grid = value.Grid
			--nTempTable.TempId = value.TempID
			
			table.insert(TreasureTable, nTempTable)

			
			
		end
			
	end
	 TreasureTable = CheckTable(nGrid,SortTreasure(TreasureTable))
	 return TreasureTable
end

local function CheckBStrengthen(nGrid,tableSelect)
	local m_bw_lv = tonumber(GetCurLvByGird(nGrid))
	local l_limit_lv = tonumber(GetQHLimitLvByGrid(nGrid))
	if tonumber(m_bw_lv) >= tonumber(l_limit_lv) then
		TipLayer.createTimeLayer("已经达到等级上限", 2)
		return false
	end
	local nIndex = 0
	for key,value in pairs(tableSelect) do
		nIndex = nIndex + 1
	end
	if nIndex == 0 then
		TipLayer.createTimeLayer("请选择强化消耗", 2)
		return false
	end
	return true
end
local function UpStrengthenDataLogic(tableData,nGrid,oldLv)
	local lv = tonumber(GetCurLvByGird(nGrid)) - tonumber(oldLv)
	if lv >0 then
		RunActionArrTip(oldLv,GetCurLvByGird(nGrid),nGrid)
		ShowUpLvEffect(TreasureStrengthen.GetTreasureUI(),"Image/imgres/effect/word_up.png","Image/imgres/effect/word_ji.png",lv,nil)
	end
	RunActionTableData(tableData,oldLv,GetCurLvByGird(nGrid),nGrid)
	--加上星星的特效 celina
	print("4=============================")
	local img_bg = tolua.cast(TreasureStrengthen.GetTreasureUI():getWidgetByName("img_bg_select"),"ImageView")
	CommonInterface.GetAnimationByName("Image/imgres/effectfile/baowuqianghua/baowuqianghua.ExportJson", 
		"baowuqianghua", 
		"Animation"..(6-#tableData), 
		TreasureStrengthen.GetTreasureUI(), 
		ccp(390, 320),
		nil,
		10)
	
end
function ToStrengthenBW(nGrid)
	local selectTable = EquipLogic.GetTableTreasure()
	--[[printTab(selectTable)
	Pause()]]--
	local nTemp = {-1, -1, -1, -1, -1}
	for key,value in pairs(selectTable) do
		nTemp[key] = value.m_grid
	end
	local beforeLv = tonumber(GetCurLvByGird(nGrid))
	if CheckBStrengthen(nGrid,selectTable) == true then
		local function StrengthenOver(bSuccess)
			NetWorkLoadingLayer.loadingHideNow()
			if bSuccess == true then
				TipLayer.createTimeLayer("强化成功", 2)
			else
				TipLayer.createTimeLayer("你吃了已装备的装备", 2)
			end
			EquipLogic.ClearTableTreasure()
			UpStrengthenDataLogic(selectTable,nGrid,beforeLv)
			if bSuccess == true then
				
				--共用信息的更新
				EquipOperateLayer.updateEquipInfo(nGrid)
				--更新进度条
				StrengthenNarmalLayer.UpdateProgress(TreasureStrengthen.GetTreasureUI(),nGrid)
				
			end
			
			--更新下方的消耗信息
			local tableNow = {}
			StrengthenNarmalLayer.ShowExpAndSliver(GetSelecExp(tableNow),nil)
			EquipCommon.Update(ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE,nGrid)
		end
		
		Packet_StrengthenTreasure.SetSuccessCallBack(StrengthenOver)
		
		
		network.NetWorkEvent(Packet_StrengthenTreasure.CreatPacket(nGrid, nTemp[1], nTemp[2],nTemp[3], nTemp[4], nTemp[5]))
		NetWorkLoadingLayer.loadingShow(true)
	end
end
