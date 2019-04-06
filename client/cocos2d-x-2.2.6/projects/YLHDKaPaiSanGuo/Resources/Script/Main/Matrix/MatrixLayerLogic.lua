-- for CCLuaEngine traceback


module("MatrixLayerLogic", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/serverDB/general"
require "Script/serverDB/equipt"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/server_equipDB"

require "Script/serverDB/attribute"

--add by sxin 2015-3-16 重构代码 逻辑层只做逻辑判断 界面在layer层

local TipLayer_createTimeLayer = TipLayer.createTimeLayer
local GetColorLvByGrid = EquipListData.GetColorLvByGrid
local GetExampleByGrid = EquipListData.GetExampleByGrid
local GetTypeByGrid    = EquipListData.GetTypeByGrid
local GetCurLvByGird = EquipListData.GetCurLvByGird

function WujiangIsMainStay(nGrid)
	
	local nWuGrid = server_matrixDB.GetGeneralGrid(nGrid)
    local tmpGeneralTab = server_generalDB.GetTableByGrid(nWuGrid)
    if tmpGeneralTab ~= nil and tonumber(tmpGeneralTab["Info02"]["MainStay"])==1 then
        
        return true
    end

	return false	
	
end

function CheckOpenMatrixWujiangList(nGrid)

    local nWuGrid = server_matrixDB.GetGeneralGrid(nGrid)
    local tmpGeneralTab = server_generalDB.GetTableByGrid(nWuGrid)
    if tmpGeneralTab ~= nil and tonumber(tmpGeneralTab["Info02"]["MainStay"])==1 then
        TipLayer_createTimeLayer("主将不能下阵", 2) 
        return false
    end


   return true

end



function CheckOpenMatrixEquipList(nGrid)
   
    local nWuGrid = server_matrixDB.GetGeneralGrid(nGrid)
	if nWuGrid <= 0 then
		if NewGuideManager.GetBGuide() == false then
			TipLayer_createTimeLayer("当前位置没有武将", 2) 
		end
        return false
	end	
	
	return true
  
end

--没有开启的武将位置 提示多少级开启 
function Open_Tip_WuJiang( iIndex )
	
	--print("提示多少级开启")
	--这里写提示逻辑
	local unlockLevel = tonumber(globedefine.getFieldByIdAndIndex("GeneralLv","Para_"..iIndex))

	TipLayer_createTimeLayer(unlockLevel.."级开启", 2) 
end

--没有开启的装备位置 提示多少级开启 
function Open_Tip_Equipt( iIndex )
	local unlockLevel = tonumber(globedefine.getFieldByIdAndIndex("LingBaoLv","Para_"..iIndex))

	TipLayer_createTimeLayer("护法等级达到"..unlockLevel.."级开启", 2)
end

function GetHufaCurrentLingBaoNums( nLevel )
	-- 判断护法当前开启几个灵宝格子

	local function GetUnlockLevel( nIndex )
		local unlockLevel = tonumber(globedefine.getFieldByIdAndIndex("LingBaoLv","Para_"..nIndex))
		return unlockLevel
	end

	if nLevel >= GetUnlockLevel(1) and nLevel < GetUnlockLevel(2) then
		return 1
	elseif nLevel >= GetUnlockLevel(2) and nLevel < GetUnlockLevel(3) then
		return 2
	elseif nLevel >= GetUnlockLevel(3) and nLevel < GetUnlockLevel(4) then
		return 3
	elseif nLevel >= GetUnlockLevel(4) and nLevel < GetUnlockLevel(5) then
		return 4
	elseif nLevel >= GetUnlockLevel(5) and nLevel < GetUnlockLevel(6) then
		return 5
	elseif nLevel >= GetUnlockLevel(6) then
		return 6
	else
		return 0
	end
end

local function BSelfEquip(nG_Grid,now_G_gird)
	if tonumber(nG_Grid) == tonumber(now_G_gird) then
		return true
	end
	return false
end
local function CheckBHaveKey(keyPos,tableData)
	for key,value in pairs(tableData) do 
		if tonumber(GetExampleByGrid(value.Grid)) == tonumber(keyPos) then
			return true
		end
	end
	return false 
end
--检测装备是否已经装备了
local function CheckBWJEquiped(nGrid)
	return server_matrixDB.IsShangZhenEquip(nGrid)
end
--得到需要的数据（除却了已经装备的非自己的）
local TYPE_WJ_EQUIP = {
	TYPE_WJ_EQUIP_HF = 1,
	TYPE_WJ_EQUIP_ZWJ = 2,
}
local function GetDataExceptByType(nType,tableEquip,nWJ)
	local get_table = {}
	if nType == TYPE_WJ_EQUIP.TYPE_WJ_EQUIP_ZWJ then
		
		for key,value in pairs(tableEquip) do 
			if	CheckBWJEquiped(value["Grid"]) == true then
				--已装备了，去掉不是自己的
				if BSelfEquip(nWJ,server_matrixDB.GetGeneralGridByEquipGrid(value["Grid"])) == true then
					--如果是自己身上的装备，放进去
					table.insert(get_table,value)
				end
			else
				table.insert(get_table,value)
			end
		end
		
	else
		for key,value in pairs(tableEquip) do 
			if tonumber(GetTypeByGrid(value["Grid"])) == 9 then
				if	CheckBWJEquiped(value["Grid"]) == true then
					--已装备了，去掉不是自己的
					if BSelfEquip(nWJ,server_matrixDB.GetGeneralGridByEquipGrid(value["Grid"])) == true then
						--如果是自己身上的装备，放进去
						table.insert(get_table,value)
					end
				else
					table.insert(get_table,value)
				end
			end
		end
		
	end
	return get_table
	
end
--add celina  添加装备等级的限制
local function CheckBWJOk(nGrid,nWJGrid)
	--检测武将是否能穿
	local nColorLevel = GetColorLvByGrid(nGrid)
	local nWJGrid = server_matrixDB.GetGeneralGrid(MatrixLayer.getCurPos())
	local nWJLv = GeneralBaseData.GetGeneralLv(nWJGrid)
	
	if tonumber(nWJLv)< tonumber(nColorLevel) then
		return false
	end
	return true
end
local function GetLBType(nGrid)
	local eID = server_equipDB.GetTempIdByGrid(nGrid)
	local baseID = equipt.getFieldByIdAndIndex(eID,"BaseAttitude_1")
	local typeLB = attribute.getFieldByIdAndIndex(baseID,"type")
	return tonumber(typeLB)
end
--检测属性是不是一样
local function CheckBSamePro(nGrid,tabInert)
	
	if #tabInert<=0 then
		return true 
	end
	for key ,value in pairs(tabInert) do 
		if GetLBType(nGrid)~= GetLBType(value.Grid) then
			return true 
		end
	end
	return false
end
--nNum,解锁的数量，（护法需要根据等级走，其他的一下子全开启）
function GetOneKeyEquipData(nWjGrid,nNum)
	local e_table = EquipListData.GetEquipCopyTable()
	
	local nWjTempID = server_generalDB.GetTempIdByGrid(nWjGrid)
	local typeWJ = general.getFieldByIdAndIndex(nWjTempID,"Type")
	--得到去除了其他已经装备的列表，然后按照品级排序
	local function SortByColorLv(a,b)
		if tonumber(GetColorLvByGrid(a.Grid)) == tonumber(GetColorLvByGrid(b.Grid)) then
			return  tonumber(GetCurLvByGird(a.Grid))>tonumber(GetCurLvByGird(b.Grid))
		else
			return tonumber(GetColorLvByGrid(a.Grid))>tonumber(GetColorLvByGrid(b.Grid))
		end
		
	end
	local tableNeed = {}
	if tonumber(typeWJ) ~=5 then
		tableNeed = GetDataExceptByType(TYPE_WJ_EQUIP.TYPE_WJ_EQUIP_ZWJ,e_table,nWjGrid)
		
	else
		tableNeed = GetDataExceptByType(TYPE_WJ_EQUIP.TYPE_WJ_EQUIP_HF,e_table,nWjGrid)
	end
	table.sort(tableNeed,SortByColorLv)
	
	
	--得到的表按照位置取出6个
	local tablePos = {}
	local nLBNum = 0
	for key,value in pairs(tableNeed) do 
		if tonumber(typeWJ) ~=5 then
			
			if CheckBHaveKey(GetExampleByGrid(value.Grid),tablePos) == false and table.getn(tablePos) <nNum and
				CheckBWJOk(value.Grid,nWjGrid)== true then
				table.insert(tablePos,value)
			end
		else
			--灵宝直接取前六个
			if tonumber(nLBNum)<=nNum then
				--添加条件 如果属性一样那么不能装
				if CheckBSamePro(value.Grid,tablePos) == true then
					nLBNum = nLBNum+1
					table.insert(tablePos,value)
				end
				
			end
		end
		
	end
	
	return tablePos
end
--add celina
function ToKeyStrengthen(nWjGrid,fCallBack)
	local function StatusOK(tabGird,nErrID)
		NetWorkLoadingLayer.loadingHideNow()
		if nErrID~=nil then
			if nErrID == 1004 then
				local pPoint = TipCommonLayer.CreateTipLayerManager()
				pPoint:ShowCommonTips(1652,nil)
				pPoint = nil
				return 
			end
		end
		if tabGird~=nil then
			if fCallBack~=nil then
				fCallBack(tabGird)
				fCallBack=nil
			end
		end
	end
	Packet_OneKeyStrengthen.SetSuccessCallBack(StatusOK)
	network.NetWorkEvent(Packet_OneKeyStrengthen.CreatPacket(nWjGrid))
	NetWorkLoadingLayer.loadingShow(true)
end
