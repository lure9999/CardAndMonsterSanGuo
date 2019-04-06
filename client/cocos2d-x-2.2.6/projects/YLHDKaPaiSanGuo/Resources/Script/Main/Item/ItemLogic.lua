


module("ItemLogic", package.seeall)

require "Script/Main/Equip/EquipListData"
require "Script/Common/ConsumeLogic"
require "Script/Main/Wujiang/GeneralLvUpData"
require "Script/Main/Equip/StrengthenReturnLayer"

--数据
local GetBHaveWJ = ItemData.GetBHaveWJ
local GetTempIDByGrid = ItemData.GetTempIDByGrid
local GetPriceByGird        = ItemData.GetPriceByGird
local GetNumByGird          = ItemData.GetNumByGird
local GetItemCanUse      = ItemData.GetItemCanUse
local GetNameByTempId    = ItemData.GetNameByTempId
local GetNumByTempID     = ItemData.GetNumByTempID
local GetItemEventParaB  = ItemData.GetItemEventParaB
local GetItemEventType   = ItemData.GetItemEventType
local GetItemEventParaA  = ItemData.GetItemEventParaA
local GetPlayerLv        = ItemData.GetPlayerLv
local getMainGeneralLv 		= GeneralBaseData.GetMainGeneralLv
local getGeneralMaxExpPool	= GeneralLvUpData.GetGeneralMaxExpPool
local getGeneralExpPool 	= GeneralLvUpData.GetGeneralExpPool
local GetNumJHunByGird = ItemData.GetNumJHunByGird
local GetLHCoumeIDByItemID = ItemData.GetLHCoumeIDByItemID

local GetConsumeTab = ConsumeLogic.GetConsumeTab
local GetConsumeItemData = ConsumeLogic.GetConsumeItemData


local GetItemGridByID = ItemData.GetItemGridByID
local GetTableDataByType = ItemData.GetTableDataByType
local GetTabItemIDByDYLv = ItemData.GetTabItemIDByDYLv
local GetDYNameByLv = ItemData.GetDYNameByLv

local GetItemCounts = ItemData.GetItemCounts
local GetTypeByGrid =  EquipListData.GetTypeByGrid

local GetSellPriceByGrid_Equip = EquipListData.GetSellPriceByGrid
local GetTempID_Equip    = EquipListData.GetTempID
local GetCountEquipBag = EquipListData.GetCountEquipBag
local CheckBHaveEquipByGrid = EquipListData.CheckBHaveEquipByGrid
local GetSellTypeByGrid = EquipListData.GetSellTypeByGrid

-- add by sxin 
local BagItemIsFull	= ItemData.BagItemIsFull
local BagEquipIsFull = ItemData.BagEquipIsFull
local BagWJIsFull    = ItemData.BagWJIsFull

ITEM_BTN_TYPE = {
	ITEM_BTN_TYPE_SPHC = 1 ,
	ITEM_BTN_TYPE_LH  = 2,
	ITEM_BTN_TYPE_JHHC   = 3

}

--根据类型判断当前页有没有物品
function CheckBHaveGoods(nType)
	if #GetTableDataByType(nType)==0 then
		return true
	end
	
	return false
end
function GetScrollviewRow(nTableCount)
	local row = nTableCount/4
	if row<1 then
		row = 1
	end
	row = row-row%1
	return row
end
function GetScrollviewCol(nTableCount)
	local col_now = 0 
	if nTableCount<4 then
		col_now = nTableCount-1
	else
		col_now =3
	end
	return col_now
end
function GetBtnType(nType,nGrid)
	--设置现在的类型
	if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH then
		--现在是将魂界面 --0417日修改为，将魂在道具界面只能炼化，合成放入武将界面
		--if GetBHaveWJ(nGrid)==true then
			--只能炼化
			return  ITEM_BTN_TYPE.ITEM_BTN_TYPE_LH
		--else
			--可以将魂合成
			--return  ITEM_BTN_TYPE.ITEM_BTN_TYPE_JHHC
		--end
	end
	if tonumber(nType) == ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP then
		return  ITEM_BTN_TYPE.ITEM_BTN_TYPE_SPHC
	end
end
function ToSellItem(nGrid,fCallBack)
	local price_now = GetPriceByGird(nGrid)
	local nHave = GetNumByGird(nGrid)
	local function SelectNumberCall(nNum)
		local function sellOver()
			NetWorkLoadingLayer.loadingHideNow()
			--TipLayer.createTimeLayer("售出成功，得到银币"..price_now*nNum.."钱", 2)
			local pTipLayer = TipCommonLayer.CreateTipLayerManager()
			--TipCommonLayer.CreateTipsLayer(502,TIPS_TYPE.TIPS_TYPE_ITEM,nGrid,nil,price_now*nNum)
			pTipLayer:ShowCommonTips(502,nil,price_now*nNum)
			pTipLayer = nil
			if fCallBack~=nil then
				fCallBack(nGrid)
			end
		end
		--print("SellNumber="..nNum)
		Packet_SellItem.SetSuccessCallBack(sellOver)
		network.NetWorkEvent(Packet_SellItem.CreatPacket(nGrid,nNum,0))
		NetWorkLoadingLayer.loadingShow(true)
	end
	TipLayer.createPiLiangLayer(2, GetTempIDByGrid(nGrid), nHave, nHave, 0, 0, 0, SelectNumberCall)

end
function ToSellEquip(nGrid,fCallBack)
	local price_now = GetSellPriceByGrid_Equip(nGrid)
	local nType_now = GetSellTypeByGrid(nGrid)
	local function SelectNumberCall(nNum)
		local function sellOver(list)
			NetWorkLoadingLayer.loadingHideNow()
			--TipLayer.createTimeLayer("售出成功，得到银币"..price_now*nNum.."钱", 2)
			--TipCommonLayer.CreateTipsLayer(502,TIPS_TYPE.TIPS_TYPE_EQUIP,nGrid,nil,price_now*nNum)
			local nCoin = #list[1]
			local nItem = #list[2]
			local nTotal = nCoin+nItem
			if nTotal ==0 then
				local pTipLayer = TipCommonLayer.CreateTipLayerManager()
				pTipLayer:ShowCommonTips(502,nil,price_now*nNum)
				pTipLayer = nil
				
			else
				--强化有返还
				StrengthenReturnLayer.CreateStrengthenReturn(list,price_now*nNum,nType_now)
			end
			if fCallBack~=nil then
				fCallBack(nGrid)
			end
		end
		--print("SellNumber="..nNum)
		Packet_SellItem.SetSuccessCallBack(sellOver)
		network.NetWorkEvent(Packet_SellItem.CreatPacket(nGrid,nNum,1))
		NetWorkLoadingLayer.loadingShow(true)
	end
	TipLayer.createPiLiangLayer(2, GetTempID_Equip(nGrid), 1, 1, 0, 0, 0, SelectNumberCall)
end
--检测是否还有物品或者装备
function CheckBHaveItem(nGrid,nType)
	if tonumber(nType)>= ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		local table_cur = server_itemDB.GetCopyTable()
		for key,value in pairs (table_cur) do 
			if tonumber(value["Grid"]) == tonumber(nGrid) then
				return true
			end
		end
	else
		return CheckBHaveEquipByGrid(nGrid)
	end
	return false
end
-- 使用增加经验池药品
local function UseExpDrug( nTempId, nHave )
	local nMaxExpPool = getGeneralMaxExpPool(getMainGeneralLv())
	local nCurExpPool = getGeneralExpPool()
	local nNeedExp = nMaxExpPool- nCurExpPool
	if nNeedExp>0 then
		local nNeedDrug = math.ceil(nNeedExp/GetItemEventParaB(nTempId))
		if nNeedDrug>nHave then
			return nHave
		else
			return nNeedDrug
		end
	else
		return 0
	end
end

local function CheckBBoxUse(nGrid)
	local sName = GetNameByTempId(GetTempIDByGrid(nGrid))
	
	local nHave = GetNumByTempID(GetTempIDByGrid(nGrid))
	local pTips = TipCommonLayer.CreateTipLayerManager()
	local nCanUse = nil
	if sName == "银箱子" then
		local nKeyId = GetItemEventParaB(GetTempIDByGrid(nGrid))
		local nKeyGrid = server_itemDB.GetGridByTempIdAndType(nKeyId, E_BAGITEM_TYPE.E_BAGITEM_TYPE_DRUG)
		local nKeyNum = server_itemDB.GetItemNumberByTempId(nKeyId)
		if nHave > nKeyNum then nCanUse = nKeyNum end
		if nKeyGrid == nil then
			TipLayer.createTimeLayer("对不起，您的银钥匙不足，请购买银钥匙", 2)
			return false
		end
	end

	if sName == "金箱子" then
		local nKeyId = GetItemEventParaB(GetTempIDByGrid(nGrid))
		local nKeyGrid = server_itemDB.GetGridByTempIdAndType(nKeyId, E_BAGITEM_TYPE.E_BAGITEM_TYPE_DRUG)
		local nKeyNum = server_itemDB.GetItemNumberByTempId(nKeyId)
		if nHave > nKeyNum then nCanUse = nKeyNum end
		if nKeyGrid == nil then
			TipLayer.createTimeLayer("对不起，您的金钥匙不足，请购买金钥匙", 2)
			return false
		end
	end
	local event_type = GetItemEventType(GetTempIDByGrid(nGrid))
	local nEventParaA = GetItemEventParaA(GetTempIDByGrid(nGrid))
	if tonumber(event_type) == 2 then-- 箱子类型
		--local nWjMaxCount = 144--globedefine.getFieldByIdAndIndex("BoxMax", "Para_1")
		--if server_generalDB.GetCount() >= tonumber(nWjMaxCount) then
		--[[if BagWJIsFull() == true then
			--TipLayer.createTimeLayer("您的武将背包已满！", 2)
			TipCommonLayer.CreateTipsLayer(503,TIPS_TYPE.TIPS_TYPE_EQUIP,nil,nil,nil)
			return false
		end
		--local nEquipMaxCount = 240--globedefine.getFieldByIdAndIndex("BoxMax", "Para_2")
		
		--if tonumber(server_equipDB.GetCount()) >= tonumber(nEquipMaxCount) then
		if BagEquipIsFull() == true then
			--TipLayer.createTimeLayer("您的装备背包已满！", 2)
			TipCommonLayer.CreateTipsLayer(503,TIPS_TYPE.TIPS_TYPE_EQUIP,nil,nil,nil)
			return false
		end
		
		--local nItemMaxCount = 120--globedefine.getFieldByIdAndIndex("BoxMax", "Para_3")
		--if server_itemDB.GetCount() >= tonumber(nItemMaxCount) then
		if BagItemIsFull() == true then
			--TipLayer.createTimeLayer("您的物品背包已满！", 2)
			TipCommonLayer.CreateTipsLayer(503,TIPS_TYPE.TIPS_TYPE_EQUIP,nil,nil,nil)
			return false
		end]]--
		--修改为只有有一项没有满就放过去交给服务器判断，不然的话，装备满了，但是物品没满，就不能开了
		if BagWJIsFull()== true and BagEquipIsFull() == true and BagItemIsFull()== true then
			
			pTips:ShowCommonTips(503,nil)
			pTips = nil
			--TipCommonLayer.CreateTipsLayer(503,TIPS_TYPE.TIPS_TYPE_EQUIP,nil,nil,nil)
			return false
		end
	elseif event_type == 1 and nEventParaA==2 then
		nCanUse = UseExpDrug(GetTempIDByGrid(nGrid), nHave)
		--print("nCanUse="..nCanUse)
		if nCanUse<1 then
			--TipLayer.createTimeLayer("经验池已达上限！", 2)
			pTips:ShowCommonTips(203,nil)
			pTips = nil
			return false
		end
	elseif event_type == 1 and nEventParaA==1 then
		--增加主将经验
		if GetPlayerLv()>=100 then
			pTips:ShowCommonTips(1459,nil)
			pTips = nil
			return false
		end
		
	end
	return true
end
local function CheckItemBUse(nGrid)
	if tonumber(GetItemCanUse(nGrid)) == 0 then
		TipLayer.createTimeLayer("当前物品不可使用", 2)
		return 	false
	end
	return CheckBBoxUse(nGrid)
end
function ToUseItem(nGrid,fCallBack,bNewGuide)
	if CheckItemBUse(nGrid) == false then
		return 
	end
	local nHave = GetNumByTempID(GetTempIDByGrid(nGrid))
	local nCanUse = nil
	local function useOver()	
		NetWorkLoadingLayer.loadingHideNow()
		if bNewGuide~=nil then
			--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(5))
		end
		if fCallBack~=nil then
			fCallBack(nGrid)
		end
	end

	local function SelectNumberCall(nNum)
		
		Packet_UseItem.SetSuccessCallBack(useOver)
		network.NetWorkEvent(Packet_UseItem.CreatPacket(nGrid, nNum, GetTempIDByGrid(nGrid)))
		
		NetWorkLoadingLayer.loadingShow(true)
	end

	--取得物品类型，如果是宝箱则取得钥匙的数量
	local nItemType = GetItemEventType(GetTempIDByGrid(nGrid))
	local nkeyId = nil
	local nCurUseNum = nil
	if nItemType == 2 then
		--取得钥匙ID（金钥匙或者银钥匙）
		nkeyId = ItemData.GetItemEventParaB(GetTempIDByGrid(nGrid))
		if nkeyId ~= 0 then
			--不等于0说明有开启条件
			nCanUse = GetNumByTempID(nkeyId)
		end
	end

	if nHave == 1 then
		SelectNumberCall(1)
	else
		if nCanUse == nil then nCanUse = nHave end
		if nkeyId ~= 2 then
			if nCanUse > nHave then
				nCurUseNum = nHave
			else
				nCurUseNum = nCanUse 
			end
			TipLayer.createPiLiangLayer(1, GetTempIDByGrid(nGrid), nHave, nCurUseNum, 0, 0, 0, SelectNumberCall)
		else
			TipLayer.createPiLiangLayer(1, GetTempIDByGrid(nGrid), nHave, nCanUse, 0, 0, 0, SelectNumberCall)
		end
	end	
end

local function CheckBJHEnough(nGrid)
	local need_num = GetNumJHunByGird(nGrid)
	local own_num = GetNumByGird(nGrid)
	
	if tonumber(own_num)>= tonumber(need_num) then
		return true
	end
	return false
end

--检测是否添加红点
function CheckRedPoint(  )
	local tabRed = GetTableDataByType(9)
	for key,value in pairs(tabRed) do
		if CheckBJHEnough(value["Grid"]) == true then
			return true
		end
	end
	return false
end
--检测道具是否添加小红点
function CheckItemRedPoint( nGrid )
	return CheckBJHEnough(nGrid)
end

--将魂是否可以炼化(走消耗表)
local function GetBLH(consumeTab)
	for i=1,#consumeTab do
		local tableDataNow = GetConsumeItemData(consumeTab[i].ConsumeID, consumeTab[i].nIdx, consumeTab[i].ConsumeType, consumeTab[i].IncType)
		if tableDataNow.Enough==false then
		 	return false
		end
	end
	
	return true
end

local function CheckBJHLH(nGrid)
	local cTab = GetConsumeTab(5,GetLHCoumeIDByItemID(GetTempIDByGrid(nGrid)))
	return GetBLH(cTab)
end
local function CheckBLHHC(nTypeBtn,nGrid)
	if tonumber(nTypeBtn) == ITEM_BTN_TYPE.ITEM_BTN_TYPE_LH then
		--将魂炼化
		if CheckBJHLH(nGrid) == false then
			TipLayer.createTimeLayer("可炼化将魂数量不够", 2) 
			return false
		end
	end
	
	if tonumber(nTypeBtn) == ITEM_BTN_TYPE.ITEM_BTN_TYPE_JHHC then
		--print("将魂合成")
		if CheckBJHEnough(nGrid) == false then
			TipLayer.createTimeLayer("将魂数量不够", 2) 
			return false
		end
	end
	if tonumber(nTypeBtn) == ITEM_BTN_TYPE.ITEM_BTN_TYPE_SPHC then
		if CheckBJHEnough(nGrid) == false then
			TipLayer.createTimeLayer("碎片数量不够", 2) 
			return false
		end
	
	end
	return true
end
function ToLHHC(nGrid,fCallBack,nTypeBtn)
	if CheckBLHHC(nTypeBtn,nGrid) == false then
		return 
	end
	if tonumber(nTypeBtn) == ITEM_BTN_TYPE.ITEM_BTN_TYPE_JHHC then
		local function useOver()
			NetWorkLoadingLayer.loadingHideNow()
			if fCallBack~=nil then
				fCallBack(nGrid)
			end
		end
		Packet_UseItem.SetSuccessCallBack(useOver)
		network.NetWorkEvent(Packet_UseItem.CreatPacket(nGrid, 1, GetTempIDByGrid(nGrid)))
		NetWorkLoadingLayer.loadingShow(true)

	elseif tonumber(nTypeBtn) == ITEM_BTN_TYPE.ITEM_BTN_TYPE_SPHC then
		local function useOver()
			NetWorkLoadingLayer.loadingHideNow()
			if fCallBack~=nil then
				fCallBack(nGrid)
			end
		end
		Packet_UseItem.SetSuccessCallBack(useOver)
		network.NetWorkEvent(Packet_UseItem.CreatPacket(nGrid, 1,  GetTempIDByGrid(nGrid)))
		NetWorkLoadingLayer.loadingShow(true)
	elseif tonumber(nTypeBtn) == ITEM_BTN_TYPE.ITEM_BTN_TYPE_LH then
		--print("将魂炼化")
		--说明 一次只能炼化一个
		local function refiningOver()
			NetWorkLoadingLayer.loadingHideNow()
			if fCallBack~=nil then
				fCallBack(nGrid)
			end
		end
		Packet_Refining_Equip.SetSuccessCallBack(refiningOver)
		network.NetWorkEvent(Packet_Refining_Equip.CreatPacket(nGrid, 1,ENUM_REFINING_TYPE.ENUM_REFINING_TYPE_ITEM))
		NetWorkLoadingLayer.loadingShow(true)
		
	end

end
function GetTypeByTableData(tableData,nCurIndex,nType)
	if tonumber(nType)>= ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		
		return tableData[nCurIndex]["Type"]
	else
		return GetTypeByGrid(tableData[nCurIndex]["Grid"])
	end
	
end
function GetTempIDByTableData(tableData,nCurIndex,nType)
	if tonumber(nType)>= ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		return tableData[nCurIndex]["ItemID"]
	else
		return tableData[nCurIndex]["TempID"]
	end

end
function CheckBEquipNow(nType)
	if tonumber(nType)>= ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		return false
	end
	return true
end

function GetStrNumBag(nType)
	if tonumber(nType)== ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM then
		return GetItemCounts().."/"..MAX_BAG_ITME_COUNT
	else
		return GetCountEquipBag().."/"..MAX_BAG_EQUIP_COUNT
	end
	return ""
end

--装备炼化
local function CheckBEquipLH(nGrid)
	if tonumber(GetLHCoumeIDByItemID(GetTempID_Equip(nGrid))) <=0 then
		return true
	else
		local cTab = GetConsumeTab(5,GetLHCoumeIDByItemID(GetTempID_Equip(nGrid)))
		return GetBLH(cTab)
	end
	
end
function ToEquipRefining(nGrid,fCallBack)
	if CheckBEquipLH(nGrid) == false then
		TipLayer.createTimeLayer("可炼化数量不够", 2) 
		return 
	end
	local function refiningOver()
		NetWorkLoadingLayer.loadingHideNow()
		if fCallBack~=nil then
			fCallBack(nGrid)
		end
	end
	Packet_Refining_Equip.SetSuccessCallBack(refiningOver)
	network.NetWorkEvent(Packet_Refining_Equip.CreatPacket(nGrid, 1,ENUM_REFINING_TYPE.ENUM_REFINING_TYPE_EQUIP))
	NetWorkLoadingLayer.loadingShow(true)
end
local function CheckBDanYaoLH(nGrid)
	local cTab = GetConsumeTab(5,GetLHCoumeIDByItemID(GetTempIDByGrid(nGrid)))
	return GetBLH(cTab)
end
function ToLHDanYao(nGrid,fCallBack)
	if CheckBDanYaoLH(nGrid) == false then
		TipLayer.createTimeLayer("可炼化数量不够", 2) 
		return 
	end
	local function refiningOver()
		NetWorkLoadingLayer.loadingHideNow()
		if fCallBack~=nil then
			fCallBack(nGrid)
		end
	end
	Packet_Refining_Equip.SetSuccessCallBack(refiningOver)
	network.NetWorkEvent(Packet_Refining_Equip.CreatPacket(nGrid, 1,ENUM_REFINING_TYPE.ENUM_REFINING_TYPE_ITEM))
	NetWorkLoadingLayer.loadingShow(true)
end

function SearchByGrid(nGrid,tab)
	if nGrid == nil then
		return false 
	else
		for key,value in pairs(tab) do 
			if tonumber(nGrid) == value.Grid then
				return true
			end	
		end
	end
	return false
end
local function GetGuideGrid(tab)
	if tab== nil then
		return nil 
	end
	if #tab==0 then
		return nil 
	end
	if #tab>1 then
		for key,value in pairs(tab) do 
			local curGrid = GetItemGridByID(tonumber(value))
			if SearchByGrid(curGrid,GetTableDataByType(ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH)) == true then
				return value
			end
		end
		return nil
	else
		return tab[1]
	end
end
function GetGridByID(nDYLv)
	local tab = GetTabItemIDByDYLv(nDYLv)
	local curGrid = GetGuideGrid(tab)  
	if curGrid == nil then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1478,nil,GetDYNameByLv(nDYLv))
		pTips = nil
		return nil
	end
	return curGrid
end


function ToGuideTotal(pGuide,nGird)
	local pGuideManager = GuideRegisterManager.RegisterGuideManager()
	pGuideManager:RegisteGuide(pGuide,GetTempIDByGrid(nGird),GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM)
	pGuideManager = nil
	
end
--根据小的类型或者大背包的类型
function GetBoxByMenuType(iType)
	if tonumber(iType)>=ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH then
		return ENUM_TYPE_BOX_ITEM.ENUM_BOX_ITEM
	end
	return ENUM_TYPE_BOX_ITEM.ENUM_BOX_EQUIP
end
