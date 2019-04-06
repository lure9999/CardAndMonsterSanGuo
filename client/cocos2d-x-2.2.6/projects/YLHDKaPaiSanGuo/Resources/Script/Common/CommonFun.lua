
module("CommonFun", package.seeall)

-- 根据掉落ID得到物品表
function getItemTableByDropId(nId)
	require "Script/serverDB/itemdrop"
	require "Script/serverDB/itemdropgroup"
	local nLowLimit = itemdrop.getFieldByIdAndIndex(nId,"low_limit")
	local nHighLimit = itemdrop.getFieldByIdAndIndex(nId,"high_limit")
	local numCount = math.random(nLowLimit,nHighLimit)

	local tableItemDrop = {}
	for i = 1, 4 do
		local nMustID = itemdrop.getFieldByIdAndIndex(nId,"must_drop_id_" .. i)
		if tonumber(nMustID) > 0 then
			tableItemDrop[numCount] = nMustID
			numCount = numCount - 1
			if numCount <= 0 then
				break
			end
		end
	end

	if numCount > 0 then
		local nR = math.random(1, 100)
		local tableTake = {}
		local nC = 1
		for i = 1, 15 do
			local nValue = itemdrop.getFieldByIdAndIndex(nId,"value_" .. i)
			if tonumber(nValue) >= nR then
				tableTake[nC] = itemdrop.getFieldByIdAndIndex(nId,"group_id_" .. i)
				nC = nC + 1
			end
		end

		local nAllCount = table.getn(tableTake)
		if nAllCount > 0 then
			for i = 1, nAllCount do
				local nIndex = math.random(0, nAllCount)
				tableItemDrop[numCount] = tableTake[nIndex]
				numCount = numCount - 1
				if numCount <= 0 then
					break
				end
			end
		end
	end

	-- 掉落组
	--print("掉落组掉落组掉落组掉落组掉落组掉落组")
	local tableReturn = {}
	for key, value in pairs(tableItemDrop) do
		local nG_Id = value
		local tableGroupValue = {}
		local nRG = math.random(1, 100)
		local nI = 1
		for i = 1, 20 do
			local nV = itemdropgroup.getFieldByIdAndIndex(nG_Id,"item_value_" .. i)
			if tonumber(nV) >= nRG then 
				tableGroupValue[nI] = {}
				tableGroupValue[nI]["Id"] = itemdropgroup.getFieldByIdAndIndex(nG_Id, "item_id_" .. i)
				tableGroupValue[nI]["Count"] = itemdropgroup.getFieldByIdAndIndex(nG_Id, "item_number_" .. i)
				nI = nI + 1
			end
		end
		--
		local nAllCount = table.getn(tableGroupValue)
		if nAllCount > 0 then
			local nIndex = math.random(1, nAllCount)
			tableReturn[key] = tableGroupValue[nIndex]
		end
	end

	return tableReturn
end




