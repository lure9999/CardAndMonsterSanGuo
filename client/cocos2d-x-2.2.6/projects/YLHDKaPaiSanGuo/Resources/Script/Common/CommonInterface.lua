
module("CommonInterface", package.seeall)

-- 得到阵容数据，为战斗使用
function getMatrixForFight()
    local tableTemp = {}

	require "Script/serverDB/server_matrixDB"
	require "Script/serverDB/server_generalDB"
    for i=5, 1, -1 do
        local nTempId = -1
        local nWjGrid = server_matrixDB.GetGeneralGrid(6-i)
        
        nTempId = server_generalDB.GetTempIdByGrid(nWjGrid)
    
        tableTemp[i] = {["GID"] = nWjGrid, ["TempID"] = nTempId,}
    end

    -- 如果空的位置的话。要把空位置向前移
    local tableRe = {}
    for i = 1, 5 do
    	if tonumber(tableTemp[i]["GID"]) > 0 then
    		table.insert(tableRe, tableTemp[i])
    	end
    end
    for i = 1, 5-table.getn(tableRe) do
    	table.insert(tableRe, {["GID"] = 0, ["TempID"] = 0,})
    end
    local nTempId = -1
    local nWjGrid = server_matrixDB.GetGeneralGrid(6)
    nTempId = server_generalDB.GetTempIdByGrid(nWjGrid)
    table.insert(tableRe, {["GID"] = nWjGrid, ["TempID"] = nTempId,})

    return tableRe
end

function DisSort(tableOld)
    -- 按攻击距离排序
    local tableNew = {}
    local tableNone = {}
    require "Script/serverDB/general"

    local nG_Count = 0
    local nE_Count = 1

    for j = 1, 5 do
        local nWjGrid = tableOld[j]["Info01"]["generalgrid"]
        if tonumber(nWjGrid) > 0 then
            nG_Count = nG_Count + 1
        end
    end

    for j = 1, 5 do
        local tableMaxDix = nil
        local nMaxDis = 0
        local nIndex = 0
        for i = 1, 5 do
            if tableOld[i] ~= nil then
                if tableOld[i]["Grid"] ~= 6 then
                    local nWjGrid = tableOld[i]["Info01"]["generalgrid"]
                    --print("nWjGrid = " .. nWjGrid)
                    local tableGeneralTemp = server_generalDB.GetTableByGrid(nWjGrid)
                    if tableGeneralTemp ~= nil then
                        --local nTempId = tableGeneralTemp["Info02"]["TempID"]
                        local nTempId = tableGeneralTemp["ItemID"]
                        local dis = general.getFieldByIdAndIndex(nTempId, "dis")
                        --print("dis = " .. dis)
                        if tonumber(dis) >= nMaxDis then
                            tableMaxDix = tableOld[i]
                            nIndex = i
                            nMaxDis = tonumber(dis)
                            --print("MaxDis = " .. nMaxDis)
                        end
                    else
                        if tonumber(nWjGrid) == -1 and tableMaxDix == nil then
                            tableMaxDix = tableOld[i]
                            nIndex = i
                        else
                            tableNone = tableOld[i]
                            if tableMaxDix == nil then
                                nIndex = i
                            end
                        end
                    end
                end
            end
        end

        if tableMaxDix ~= nil then
            if nG_Count == 0 then
                --table.insert(tableNew, nE_Count, tableMaxDix)
                tableMaxDix["Grid"] = nE_Count
                tableNew[nE_Count] = copyTab(tableMaxDix)
            else
                --table.insert(tableNew, 6 - nG_Count, tableMaxDix)
                tableMaxDix["Grid"] = 6 - nG_Count
                tableNew[6 - nG_Count] = copyTab(tableMaxDix)
            end
            table.remove(tableOld, nIndex)
        else
            if nG_Count == 0 then
                --table.insert(tableNew, nE_Count, copyTab(tableNone))
                tableNone["Grid"] = nE_Count
                tableNew[nE_Count] = copyTab(tableNone)
            else
                --table.insert(tableNew, 6 - nG_Count, copyTab(tableNone))
                tableNone["Grid"] = 6 - nG_Count
                tableNew[6 - nG_Count] = copyTab(tableNone)
            end
            table.remove(tableOld, nIndex)
        end
        if nG_Count ~= 0 then
            nG_Count = nG_Count - 1
        else
            nE_Count = nE_Count + 1
        end
    end

    for k,v in pairs(tableOld) do
        if v["Grid"] == 6 then
		--add by sxin
           -- table.insert(tableNew, 6, v)
			table.insert(tableNew, v)
        end
    end

    return tableNew
end
function CreateRunAnimationByJsonPath(strJsonPath, strJsonName, playIndex, pParentUI, ptPos, callBackFun, nTag)

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local PayArmature = CCArmature:create(strJsonName)
	
	PayArmature:getAnimation():playWithIndex(playIndex)
    PayArmature:setPosition(ptPos)   
	--add by sxin 因为外层调用都是Widget 用的getchilebytag所以只能加个layout了不然找不到！！！！！
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)
	
    local function onMovementEvent(armatureBack,movementType,movementID)
        if movementType == 1 then
            layout:removeFromParentAndCleanup(true)
          
            if callBackFun ~= nil then
                callBackFun()
				callBackFun = nil
            end
        end
		
    end

    PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	
    if nTag ~= nil then
		
        pParentUI:addChild(layout, 1, nTag)
    else
		
        pParentUI:addChild(layout,1)
    end
end

function GetAnimationByName(strJsonPath, strJsonName, strPlayName, pParentUI, ptPos, callBackFun, nTag,bReturn )
	
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local PayArmature = CCArmature:create(strJsonName)
	PayArmature:setPosition(ptPos)  
	--先临时写一下
	if bReturn ~=nil then
		PayArmature:setScale(1.35)
	end
	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)	

    local function onMovementEvent(armatureBack,movementType,movementID)
        if movementType == 1 then
            layout:removeFromParentAndCleanup(true)    
            if callBackFun ~= nil then
                callBackFun()
				callBackFun = nil
				
            end
		elseif movementType == 2 then
			
        end
		if strJsonName ==  "brith_all_001" then
			print(movementID)
			
		end
    end
	
    PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	PayArmature:getAnimation():play(strPlayName)
    if nTag ~= nil then
		if pParentUI:getChildByTag(nTag)~=nil then
			pParentUI:getChildByTag(nTag):removeFromParentAndCleanup(true)
		end
        pParentUI:addChild(layout, nTag, nTag)
    else
		
        pParentUI:addChild(layout, 1)
    end
	return PayArmature
end
function GetAnimationToPlay(strJsonPath, strJsonName, strPlayName, pParentUI, ptPos,callBackFun)
	 CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(strJsonPath)
    local PayArmature = CCArmature:create(strJsonName)
	PayArmature:setPosition(ptPos)  

	local layout = Layout:create()
	layout:setTouchEnabled(false)
	layout:addNode(PayArmature)	
	if pParentUI:getChildByTag(1)~=nil then
		pParentUI:getChildByTag(1):removeFromParentAndCleanup(true)
	end
	pParentUI:addChild(layout, 1,1)
	if callBackFun~=nil then
		callBackFun(PayArmature:getAnimation())
	end
end

--根据传入的道具的ID,type,i_curID(当前要强化的物品本身的ID)查询表中的数量
function getItemsNum(i_id,i_type,i_curID)
	local num_item = 0 
	--print("isSame--=========="..tonumber(isSame))
	--print("i_id:"..i_id)
	local isSame = false 
	if tonumber(i_type) == 0 then
		require "Script/serverDB/server_itemDB"
		for key, value in pairs(server_itemDB.GetCopyTable()) do
			--print("---------"..value["ItemID"])
			if tonumber(value["ItemID"]) == tonumber(i_id) then
				--print("---------"..value["ItemID"])
				num_item =server_itemDB.GetItemNumberByTempId(value["ItemID"])
			end
		end
	end
	if tonumber(i_type) == 15 then
		require "Script/serverDB/server_generalDB"
		for key, value in pairs(server_itemDB.GetCopyTable()) do
			--print("---------"..value["ItemID"])
			if tonumber(value["ItemID"]) == tonumber(i_id) then
				num_item =1--server_itemDB.GetItemNumberByTempId(value["ItemID"])
			end
		end
	end
	if tonumber(i_type) == 16 then
		require "Script/serverDB/server_equipDB"
		--print("i_curID"..i_curID)
		local id_equip = item.getFieldByIdAndIndex(i_id,"event_para_A")
		--print("id_equip.."..id_equip)
		if tonumber(id_equip) == tonumber(i_curID) then
			isSame = true
		end
		for key, value in pairs(server_equipDB.GetCopyTable()) do
			--print("---------"..value["TempID"])
			if tonumber(value["TempID"]) == tonumber(id_equip) then
				--print("---------"..value["ItemID"])
				--得到装备的ID
				num_item =server_equipDB.GetEquipNumByTempId(id_equip)
			end
		end
	end
	--print("num_item:"..num_item)
	if isSame == true then
		--如果一样需要减掉自己本身
		num_item = num_item - 1
	end
	if tonumber(num_item)<0 then
		num_item = 0 
	end
	return num_item

end

--[[
--给一个时间如:153000,得到今天15:30:00的时间戳 
function getIntervalByTime( time )
    local curTime = 
    local temp = os.date("*t",curTime)
    local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
    local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s
    -- CCLuaLog("the timestring is ...." .. timeString)
    local timeInt = TimeUtil.getIntervalByTimeString(timeString)
    return timeInt
end
--]]

function MakeUIToCenter(pControl)
    if pControl ~= nil then
        local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
        local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
        pControl:setPosition(ccp(nOff_W/2, nOff_H/2))
    end
end
function PControlPos(tablePos)
	local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
	for key,value in pairs(tablePos) do
		if value["control"] ~= nil then
			local nWidth = value["control"]:getPositionX() - nOff_W/2 + value["off_x"]
			local nHeight = value["control"]:getPositionY() - nOff_H/2 + value["off_y"]
    		value["control"]:setPosition(ccp(nWidth, nHeight))
		end
	end
end