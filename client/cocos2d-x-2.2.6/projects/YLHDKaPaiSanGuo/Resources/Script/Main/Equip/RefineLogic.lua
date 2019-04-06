


module("RefineLogic", package.seeall)

--数据
local GetStarLvByGrid = EquipListData.GetStarLvByGrid
local GetCurLvByGird     = EquipListData.GetCurLvByGird

--逻辑
local CheckBExpendRefine = EquipStrengthenLogic.CheckBExpendRefine
local ShowUpLvEffect = EquipStrengthenLogic.ShowUpLvEffect
local RunActionArrTipRefine = EquipStrengthenLogic.RunActionArrTipRefine

function CheckStarLv(tableImg,nGrid)
	for i=1,tonumber(GetStarLvByGrid(nGrid)) do 
		tableImg[i].imgStar:loadTexture("Image/imgres/common/star.png")
	end
end
local function CheckBRefine(nGrid)
	if tonumber(GetCurLvByGird(nGrid))==0 then
		TipLayer.createTimeLayer("还没有强化过", 2)
		return false
	end
	if tonumber(GetStarLvByGrid(nGrid)) >=10 then
		TipLayer.createTimeLayer("已达上限", 2)
		return false
	end
	if CheckBExpendRefine(nGrid) == false then
		TipLayer.createTimeLayer("消耗物品不足", 2)
		return false
	end
	return true
end

function ToRefineTreasure(nGrid,fCallBack)
	if CheckBRefine(nGrid) == false then
		return 
	end
	local orgLv = tonumber(GetStarLvByGrid(nGrid))
	local function JingLianOver()
		NetWorkLoadingLayer.loadingHideNow()
		
		local lv = tonumber(GetStarLvByGrid(nGrid))- orgLv
		
		ShowUpLvEffect(TreasureRefine.GetRefineUI(),"Image/imgres/effect/word_up.png","Image/imgres/effect/word_star.png",lv,nil)
		RunActionArrTipRefine(orgLv,GetStarLvByGrid(nGrid),nGrid)
		
		if fCallBack~=nil then
			fCallBack(nGrid)
		end
	end

	Packet_JingLianTreasure.SetSuccessCallBack(JingLianOver)
	network.NetWorkEvent(Packet_JingLianTreasure.CreatPacket(nGrid))
	NetWorkLoadingLayer.loadingShow(true)
end