
require "Script/Main/Equip/EquipListData"
require "Script/Main/MainScene"
require "Script/Main/Wujiang/GeneralBaseData"
--装备的逻辑相关

module("EquipLogic", package.seeall)

TIME_FUSH_LIST = 0.5
COUNT_LIST_PER_ADD = 4
COUNT_LIST_ORG_ADD = 6




---变量
local table_data = nil 

local count_now_add = 0 --记录现在增加的个数

-------数据
local GetCount        = EquipListData.GetEquipListCount
local GetEquipedCount = EquipListData.GetEquipedCount
local GetListDataByType = EquipListData.GetListDataByType
local UpdateDataList    = EquipListData.UpdateDataList
local GetColorLvByGrid      = EquipListData.GetColorLvByGrid
local GetBaseTypeByGrid  = EquipListData.GetBaseTypeByGrid

local GetHighStrengthLvByGrid = EquipListData.GetHighStrengthLvByGrid

local function GetActionArray(callback)
	local array_action = CCArray:create()
	array_action:addObject(CCDelayTime:create(TIME_FUSH_LIST))
	array_action:addObject(CCCallFunc:create(callback))
	local action_list = CCSequence:create(array_action)
	array_action:removeAllObjects()
	array_action = nil 
	return action_list
end

local function CheckAddListOver(tableData)
	if #tableData> count_now_add then
		return false
	end
	return true
end
--如果装备总数量小于8那么不需要分时加载
local function CheckAction(count)
	--print("count:"..count)
	if count<= COUNT_LIST_ORG_ADD then
		return true
	end
	return false
end
--根据类型返回相应的数据
local function BackListDataByType(nType,nTypeLayer,nGridTreasure,nPosGrid)
	--print("BackListDataByType")
	return GetListDataByType(nType,nTypeLayer,nGridTreasure,nPosGrid)
end


--一次性获得n个列表数据的动作
--pAction 的执行者
--listCallBack 回调函数
function RunGetListAction(pAction,listCallBack,tableData)
	--[[print("RunGetListAction")
	printTab(tableData)
	print("==============================")]]--
	pAction:stopAllActions()
	count_now_add = 0
	if CheckAction(#tableData) == true then
		--如果数量较小直接加载
		if listCallBack~=nil then	
			--到界面里面去加载
			listCallBack(tableData,1,#tableData)
		end
	else
		--先显示6个
		listCallBack(tableData,1,COUNT_LIST_ORG_ADD)
		--print("=================")
		count_now_add = COUNT_LIST_ORG_ADD
		local function listCheckCallBack()
			pAction:stopAllActions()
			if CheckAddListOver(tableData) == false then
				if (count_now_add+COUNT_LIST_PER_ADD) > #tableData then
					--pAction:stopAllActions()
					listCallBack(tableData,count_now_add+1,#tableData-count_now_add)
				else
					listCallBack(tableData,count_now_add+1,COUNT_LIST_PER_ADD)
					count_now_add = count_now_add +COUNT_LIST_PER_ADD
					pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
				end
			end
			--listCallBack(tableData)
		end
		
		pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
	end
	
	

end
local function clearListView(list)
	if list:getItems():count()~=0 then
		list:removeAllItems()
	end
end



--更新列表的数据，根据类型
function UpdateEquipList(list,nType,typeCallBack,nTypeLayer,nGridTreasure,nPosGrid)
	--清空list
	clearListView(list)
	local table_upData = BackListDataByType(nType,nTypeLayer,nGridTreasure,nPosGrid)
	--[[print("UpdateEquipList")
	print(nType)
	printTab(table_upData)
	Pause()]]--
	RunGetListAction(list,typeCallBack,table_upData)
end

--根据数量获得行和列
function GetRow(count)
	if count<=2 then
		return 1
	end
	if count%2~=0 then
		return (count/2-0.5+1)
	end
	return count/2
end
function GetCol(count,iRow,tableNum)
	if count<=1 then 
		return count
	end
	if iRow*2>tableNum then
		return 1
	end
	if iRow==GetRow(count) then
		if (count-iRow*2 )%2 ~=0 then
			return 1
		end
	end
	return 2
end

function ChangeLayer(pLayerNow,pLayerNew,nTag)
	MainScene.ShowLeftInfo(false)
	MainScene.ClearRootBtn()
	
	local scene_equip_now = CCDirector:sharedDirector():getRunningScene()
	if pLayerNew ~=nil then
		scene_equip_now:addChild(pLayerNew,nTag,nTag)
	end
	MainScene.PushUILayer(pLayerNew)
end

function UpdateListData()
	UpdateDataList()
end
local function CheckBLBEquip(nGrid)
	local nCurArrType = GetBaseTypeByGrid(nGrid,"BaseAttitude_1")
	for i = 1, 6 do
		local nEquipGrid = server_matrixDB.GetEquipGrid(MatrixLayer.getCurPos(), i)
		if nEquipGrid > 0 then
			-- 有灵宝，判断属性
			local nCurArrType_A = GetBaseTypeByGrid(nEquipGrid,"BaseAttitude_1")
			
			if nCurArrType == nCurArrType_A then
				return false
			end
		end
	end
end

function CheckBEquip(nGrid,nPosGrid)
	--检测是否可以装备
	local nColorLevel = GetColorLvByGrid(nGrid)
	local nWJGrid = server_matrixDB.GetGeneralGrid(MatrixLayer.getCurPos())
	local nWJLv = GeneralBaseData.GetGeneralLv(nWJGrid)
	
	if tonumber(nWJLv)< tonumber(nColorLevel) then
		--武将等级大于等于装备品级才允许穿戴,
		if server_generalDB.IsMainGeneral(nWJGrid) == true  then
			TipLayer.createTimeLayer("主公，您的等级小于装备品级，无法穿戴！", 2)
			return false
		else
			TipLayer.createTimeLayer("武将等级小于装备品级，无法穿戴！", 2)
			return false
		end
	end
	--如果是灵宝还要进行灵宝的特殊判断(MatrixLayer.getCurPos()阵容的位置是6那么需要选择灵宝)
	if MatrixLayer.getCurPos() == 6 then
		if CheckBLBEquip(nGrid) == false then
			-- 同属性的不能装备
			TipLayer.createTimeLayer("相同属性的灵宝不能一起装备", 2)
			return false
		end
	end
	server_matrixDB.DeleteEquipByEquipGrid(nGrid,nPosGrid )
	server_matrixDB.SetEquipGrid(nGrid, MatrixLayer.getCurPos(),nPosGrid )
	return true
end
function GetEquipGuideTab()
	function deleteKeyTab(st)
        local tab = {}
        for k, v in pairs(st or {}) do
            if type(v) ~= "table" then
                local nF = string.find(k, "equipgrid")
                if nF ~= nil then
                    for i = 1, 6 do
                        table.insert(tab, i, st["equipgrid" .. i])
                    end
                    return tab
                else
                    table.insert(tab, v)
                end
            else
                table.insert(tab, deleteKeyTab(v))
            end
        end
        return tab
    end

    local sendTable = deleteKeyTab(server_matrixDB.GetCopyTable())
	return sendTable
end
function UpDateMatrixBack(fCallBack,bGuide)
	if NETWORKENABLE > 0 then
		local function sendOver()
			NetWorkLoadingLayer.loadingHideNow()
			-- 去刷新阵容界面
			MatrixLayer.updataCurView()
			MatrixLayer.SetIsUpdate(true)
			if fCallBack~=nil then
				fCallBack()
			end
		end
		NetWorkLoadingLayer.loadingShow(true)
		if bGuide~=nil then
			Packet_ChangeMatrix.SetSuccessCallBack(sendOver)
			NewGuideManager.PostPacket(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_14)
		else
			server_matrixDB.SendMatrixToServer(server_matrixDB.GetCopyTable(), sendOver)
		end
		
	else
		MatrixLayer.updataCurView()
	end
end
--加入要强化的宝物
local tableTreasure = {}
function ClearTableTreasure()
	tableTreasure = {}
end
function GetTableTreasure()
	return tableTreasure
end
--自动添加的时候需要更新
function UpdateTableTreasure(tableNow)
	if #tableTreasure == 0 then
		for key,value in pairs (tableNow) do 
			local tableN = {}
			tableN.m_grid = value.m_grid
			table.insert(tableTreasure,tableN)
		end	
	else
		
		for i=1 ,#tableTreasure do 
			tableTreasure[i].m_grid = tableNow[i].m_grid
		end
		
		for i=#tableTreasure+1,#tableNow do 
			local tableN = {}
			tableN.m_grid = tableNow[i].m_grid
			table.insert(tableTreasure,tableN)
		end
	end
	
end
--检测是否已经选择该装备
function ChecxBGrid(nGrid)
	for key,value in pairs (tableTreasure) do 
		if tonumber(value.m_grid) == tonumber(nGrid) then
			return false
		end
	end
	return true
end
function RemoveGridTable(nGrid)
	local index = 0 
	for key,value in pairs (tableTreasure) do 
		if tonumber(value.m_grid) == tonumber(nGrid) then
			index = key
		end
	end
	table.remove(tableTreasure,index)
	
end
function AddTreasureStrengthen(nGrid)
	local tableNow = {}
	tableNow.m_grid = nGrid
	table.insert(tableTreasure,tableNow)
	
end
function CheckBFull()
	--print(#tableTreasure)
	--Pause()
	if #tableTreasure>=5 then
		return true
	end
	return false
end

function CheckBCanEat(nGrid)
	return not server_matrixDB.IsShangZhenEquip(nGrid)
end

function CheckBStrengthen(nGrid)
	if tonumber(GetHighStrengthLvByGrid(nGrid))<1 then
		return false
	end
	return true
end
