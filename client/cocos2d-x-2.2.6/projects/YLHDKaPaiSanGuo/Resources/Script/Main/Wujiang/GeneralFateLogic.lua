require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Main/Wujiang/GeneralFateData"

module("GeneralFateLogic", package.seeall)


local GetTianMingNeedLv 			= GeneralFateData.GetTianMingNeedLv

-- 检测等级
function CheckGeneralLv( nNeedLv, nGeneralLv )
	if nGeneralLv>=nNeedLv then
		return true
	else
		return false
	end
end

-- 检测消耗物品
function CheckFateUpgradeConsumeItems( tabConItemsData )
	for i=1, #tabConItemsData do
		if tabConItemsData[i].Enough == false then
			return tabConItemsData[i].Name
		end
	end
	return nil
end

-- 检测是否能够升星
function CheckFateUpgrade( nNeedLv, nLv, strName, tabConItemsData)
	if CheckGeneralLv(nNeedLv, nLv)==false then
		TipLayer.createTimeLayer(strName.."的等级不够啊！", 2)
		return false
	end

	local strItemName = CheckFateUpgradeConsumeItems(tabConItemsData)
	if strItemName~=nil then
		TipLayer.createTimeLayer("{"..strItemName.."}".."不足!", 2)
		return false
	end
	return true
end