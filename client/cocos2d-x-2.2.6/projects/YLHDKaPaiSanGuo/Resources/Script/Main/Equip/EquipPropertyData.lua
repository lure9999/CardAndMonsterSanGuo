
require "Script/serverDB/equipt"
require "Script/serverDB/server_equipDB"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/resimg"
require "Script/serverDB/attribute"
require "Script/serverDB/suit"
require "Script/Common/CommonData"
require "Script/serverDB/attributincremental"



module("EquipPropertyData", package.seeall)

--基础数据
local GetLockLvByGrid = EquipListData.GetLockLvByGrid
local GetTempID       = EquipListData.GetTempID
local GetCurLvByGird  = EquipListData.GetCurLvByGird
local GetSuitEvName   = EquipListData.GetSuitEvName
local GetSuitEvColorPath = EquipListData.GetSuitEvColorPath
local GetSuitLive     = EquipListData.GetSuitLive
local GetSuitID       = EquipListData.GetSuitID
local GetStarLvByGrid  = EquipListData.GetStarLvByGrid
local GetBaseNameByGrid = EquipListData.GetBaseNameByGrid

local function dealWithUnlock(table_info)
	--[[print("table_info======================")
	printTab(table_info)]]--
	local table_new = {}
	local table_1 = table_info[1]
	table.insert(table_new,table_1)
	for i=2,#table_info do 
		if tonumber(table_info[i].type_ep) == tonumber(table_new[1].type_ep) then
			--类型相等，值相加
			
			table_1.value_ep = tonumber(table_1.value_ep)+tonumber(table_info[i].value_ep)
		else
			table.insert(table_new,table_info[i])
		end
	end
	--[[print("new========================")
	printTab(table_new)]]--
	return table_new
end
--获得强化解锁属性
local function GetQHAttByGridStr(nGrid,strAtt)
	return equipt.getFieldByIdAndIndex(GetTempID(nGrid),strAtt)
end
--得到解锁的值
local function GetUnlockValue(nGrid,strAtt)
	local lock_type = attribute.getFieldByIdAndIndex(GetQHAttByGridStr(nGrid,strAtt),"type")
	local lock_value = attribute.getFieldByIdAndIndex(GetQHAttByGridStr(nGrid,strAtt),"value")
	local lock_method = attribute.getFieldByIdAndIndex(GetQHAttByGridStr(nGrid,strAtt),"valuse_method")--用来判定是否是百分比
	local table_lock = {}
	table_lock.type_ep = lock_type
	table_lock.value_ep = lock_value
	table_lock.method_ep = lock_method
	return table_lock
end
--得到达到某个条件解锁的描述
function GetUnlockDesByGridLv(nGrid)
	local curLv = tonumber(GetCurLvByGird(nGrid))
	if curLv>= GetLockLvByGrid(nGrid,"QiangHLv_1") and curLv <GetLockLvByGrid(nGrid,"QiangHLv_2") then
		return attribute.getFieldByIdAndIndex(GetQHAttByGridStr(nGrid,"QiangHAtti_1"),"des")
	end
	if curLv>= GetLockLvByGrid(nGrid,"QiangHLv_2") and curLv <GetLockLvByGrid(nGrid,"QiangHLv_3") then
		return attribute.getFieldByIdAndIndex(GetQHAttByGridStr(nGrid,"QiangHAtti_2"),"des")
	end
	if curLv>= GetLockLvByGrid(nGrid,"QiangHLv_3") and curLv <GetLockLvByGrid(nGrid,"QiangHLv_4") then
		return attribute.getFieldByIdAndIndex(GetQHAttByGridStr(nGrid,"QiangHAtti_3"),"des")
	end
	if curLv>= GetLockLvByGrid(nGrid,"QiangHLv_4")  then
		return attribute.getFieldByIdAndIndex(GetQHAttByGridStr(nGrid,"QiangHAtti_4"),"des")
	end
	return ""
end
--得到 解锁的数量
function GetUnLockNum(nCurLv,nGrid)
	local countNum = 0
	
	for i=1,4 do 
		if nCurLv>= GetLockLvByGrid(nGrid,"QiangHLv_"..i) then
			countNum = countNum+1
		end
	end
	--print(countNum)
	--Pause()
	return countNum
end
--返回解锁属性相关要素的table表，传入等级
function GetUnLockInfo(nGrid)
	local table_unlock = {}
	local cur_lv = GetCurLvByGird(nGrid)
	for i=1,GetUnLockNum(cur_lv,nGrid) do 
		table.insert(table_unlock,GetUnlockValue(nGrid,"QiangHAtti_"..i))
	end
	--合并同类项处理
	return dealWithUnlock(table_unlock)
end

--得到基础属性的值
function GetBaseInfo(nGrid)
	local table_base = {}
	for i=1,2 do
		local base_id = equipt.getFieldByIdAndIndex(GetTempID(nGrid),"BaseAttitude_"..i)
		if tonumber(base_id)~=-1 then
			local table_temp = {}
			if GetCurLvByGird(nGrid) == 0 then
				table_temp.base_type = attribute.getFieldByIdAndIndex(base_id,"type")
				table_temp.base_value = attribute.getFieldByIdAndIndex(base_id,"value")
				table_temp.base_method = attribute.getFieldByIdAndIndex(base_id,"valuse_method")
				table_temp.base_name   = GetBaseNameByGrid(nGrid,"BaseAttitude_"..i)
			elseif GetCurLvByGird(nGrid)>0 then
				table_temp.base_type = attribute.getFieldByIdAndIndex(base_id,"type")
				table_temp.base_value = attributincremental.getFieldByIdAndIndex(base_id,"Inc_Att_"..GetCurLvByGird(nGrid))
				table_temp.base_method = attribute.getFieldByIdAndIndex(base_id,"valuse_method")
				table_temp.base_name   = GetBaseNameByGrid(nGrid,"BaseAttitude_"..i)
			end
			table.insert(table_base,table_temp)
		end
		
	end
	--[[print("基础信息表================")
	printTab(table_base)]]--
	return table_base
end
function GetStrValueBase(value,method)
	if (tonumber(method) == 0) or (tonumber(method) == 2) then
		return ("+"..value)
	else
		return ("+"..(tonumber(value)*100).."%")
	end
end
--得到洗炼的信息
function GetXLInfo(nGrid)
	local table_xl = {}
	for i=1,3 do
		local xl_id = equipt.getFieldByIdAndIndex(GetTempID(nGrid),"XiLAttitude_"..i)
		if tonumber(xl_id)~=-1 then
			local table_temp_xl = {}
			local lv = GetStarLvByGrid(nGrid)
			if lv>0 then
				table_temp_xl.xl_type = attribute.getFieldByIdAndIndex(xl_id,"type")
				table_temp_xl.xl_value = attributincremental.getFieldByIdAndIndex(xl_id,"Inc_Att_"..lv)
				table_temp_xl.xl_method = attribute.getFieldByIdAndIndex(xl_id,"valuse_method")
				table_temp_xl.xl_name = attribute.getFieldByIdAndIndex(xl_id,"name")
			end
			table.insert(table_xl,table_temp_xl)
		end
		
	end
	--[[print("精炼信息============")
	printTab(table_xl)]]--
	return table_xl
end
--得到每条信息 
local function GetUnlockFourInfo(nGrid,strLockID,strLockLv)

	local l_lock_id = GetQHAttByGridStr(nGrid,strLockID)
	local l_lock_lv = GetLockLvByGrid(nGrid,strLockLv)
	local l_lv      = GetCurLvByGird(nGrid)
	local table_four = {}
	if tonumber(l_lv)>=tonumber(l_lock_lv) then
		table_four.f_lv = l_lock_lv
		table_four.f_info = attribute.getFieldByIdAndIndex(l_lock_id,"des")
		table_four.f_bLock = true
	else
		table_four.f_lv = l_lock_lv
		table_four.f_info = attribute.getFieldByIdAndIndex(l_lock_id,"des")
		table_four.f_bLock = false
	end
	return table_four
end
--得到解锁的信息
function GetUnLockValueInfo(nGrid)
	local table_unlock_v = {}
	for i=1,4 do 
		table.insert(table_unlock_v,GetUnlockFourInfo(nGrid,"QiangHAtti_"..i,"QiangHLv_"..i))
	end
	--[[print("******************************")
	printTab(table_unlock_v)]]--
	return table_unlock_v
end
-------------------套装--------------------------------

function GetSuitInfoByGrid(nGrid)
	local table_suit_info = {}
	for i=1,4 do 
		local table_l = {}
		table_l.name = GetSuitEvName(nGrid,"EquipID_"..i)
		table_l.colorPath = GetSuitEvColorPath(nGrid,"EquipID_"..i)
		table_l.bLive = GetSuitLive(nGrid,"EquipID_"..i)
		table.insert(table_suit_info,table_l)
	end
	--[[print("**********table_suit_info*************")
	printTab(table_suit_info)]]--
	return table_suit_info
end
--得到激活的信息
function GetSuitLiveInfo(live_num,nGrid)
	local table_live = {}
	
	
	--得到激活的ID
	for i=1,2 do 
		local table_l = {}
		local b_id = suit.getFieldByIdAndIndex(GetSuitID(nGrid),"SuitAttitude2_"..i)
		table_l.info = attribute.getFieldByIdAndIndex(b_id,"des")
		if live_num>=2 then
			table_l.bLive = true 
		else
			table_l.bLive = false 
		end
		table_l.sid = 2 
		table.insert(table_live,table_l)
		table_l = nil 
	end
	--得到激活的ID
	for i=1,2 do 
		local table_l = {}
		local b_id = suit.getFieldByIdAndIndex(GetSuitID(nGrid),"SuitAttitude3_"..i)
		table_l.info = attribute.getFieldByIdAndIndex(b_id,"des")
		if live_num>=3  then
			table_l.bLive = true 
		else
			table_l.bLive = false 
		end
		table_l.sid = 3 
		table.insert(table_live,table_l)
		table_l = nil 
	end
	--得到激活的ID
	for i=1,4 do 
		local table_l = {}
		local b_id = suit.getFieldByIdAndIndex(GetSuitID(nGrid),"SuitAttitude4_"..i)
		table_l.info = attribute.getFieldByIdAndIndex(b_id,"des")
		if live_num>=4 then
			table_l.bLive = true 
		else
			table_l.bLive = false 
		end
		table_l.sid = 4
		table.insert(table_live,table_l)
		table_l = nil 
	end
	--[[print("============套装解锁信息===============")
	printTab(table_live)]]--
	return table_live
end
function GetXLNameByType(nType)
	
end