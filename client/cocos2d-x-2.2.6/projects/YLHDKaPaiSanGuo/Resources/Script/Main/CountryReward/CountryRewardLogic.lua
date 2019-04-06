require "Script/Main/Item/ItemData"
module("CountryRewardLogic",package.seeall)

local BagItemIsFull = ItemData.BagItemIsFull
local BagEquipIsFull = ItemData.BagEquipIsFull

--检测背包是否已满
function CheckBagIsFull(  )
	if (BagEquipIsFull() == true ) or (BagItemIsFull() == true) then
		return false
	end
	return true
end

function SortListViewByTime( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.Sign_Times) > tonumber(b.Sign_Times)
		else
			return tonumber(a.Sign_Times) < tonumber(b.Sign_Times)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end

--刷新列表
function RequestRefreshView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:requestRefreshView()
	end 
end


function cleanListView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:removeAllItems()
	end 
end

function JudgeCountryRewardStatus(  )
	
end