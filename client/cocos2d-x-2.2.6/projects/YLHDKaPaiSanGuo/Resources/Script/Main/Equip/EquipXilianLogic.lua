

--洗炼的逻辑

module("EquipXilianLogic", package.seeall)



--数据
local GetBaseNameByGrid = EquipListData.GetBaseNameByGrid
local GetBaseAddValue   = EquipListData.GetBaseAddValue
local GetBaseIDByGridStr = EquipListData.GetBaseIDByGridStr
local GetCurLvByGird  = EquipListData.GetCurLvByGird
local GetXLLimitValueByLv = EquipListData.GetXLLimitValueByLv
local GetExpendXLNum    = EquipStrengthenLogic.GetExpendXLNum


local function CheckBHaveXL(nGrid)
	if server_equipDB.GetXLTimes(nGrid) ==nil or server_equipDB.GetXLTimes(nGrid)==0 then
		--说明没有洗炼过
		return false
	end
	return true
end
local function GetStrLimitByLv(curLv)
	if tonumber(curLv)<40 then
		return "MaxAtti_1"
	end
	if tonumber(curLv)>=40 and tonumber(curLv)<60 then
		return "MaxAtti_2"
	end
	if tonumber(curLv)>=60 and tonumber(curLv)<80 then
		return "MaxAtti_3"
	end
	if tonumber(curLv)>=80  then
		return "MaxAtti_4"
	end
end
local function GetLimitValue(nGrid,strID)
	--得到ID 基础ID或者洗炼ID
	local propertyID = GetBaseIDByGridStr(nGrid,strID)
	return GetXLLimitValueByLv(propertyID,GetStrLimitByLv(GetCurLvByGird(nGrid)))
	
end
local function GetTableXL(nGrid,nType,value,addValue,key,tableInsert)
	local tableCur = {}
	tableCur.Type = nType
	local strID = ""
	if key>2 then
		--说明是洗炼属性
		tableCur.Name= GetBaseNameByGrid(nGrid,"XiLAttitude_"..(key-2))
		tableCur.Value =0
		strID = "XiLAttitude_"..(key-2)
	else
		tableCur.Name= GetBaseNameByGrid(nGrid,"BaseAttitude_"..key)
		strID = "BaseAttitude_"..key
		tableCur.Value = GetBaseAddValue(GetBaseIDByGridStr(nGrid,"BaseAttitude_"..key),"Inc_Att_"..GetCurLvByGird(nGrid))
	end
	tableCur.XLValue = addValue
	local limitValue = GetLimitValue(nGrid,strID)
	tableCur.LimitValue = limitValue
	if tonumber(addValue)>= tonumber(limitValue) then
		tableCur.BLimitMax = true 
	else
		tableCur.BLimitMax = false 
	end
	table.insert(tableInsert,tableCur)
	tableCur=nil
	
end

function GetDataByXLInfo(nGrid)
	--信息，包括1Type，属性的名称对应的类型比如血，攻，防等
	--2属性的名称Name
	--3 属性的值，随着等级变化（value 只有基础属性有）
	--4 属性的洗炼值 (addvalue,服务器返回)
	--5 目前等级所对应的洗炼极限值limitValue
	--6 当前是否是极限值 bLimitMax 
	local tableXLPerInfo = {} 
	local l_xl_table = server_equipDB.GetStrengthenByGrid(nGrid)
	for key ,value in pairs(l_xl_table) do 
		if value.Type~= nil then
			if key>2 then
				if CheckBHaveXL(nGrid) == true then
					GetTableXL(nGrid,value.Type,value.Value,value.Add_Value,key,tableXLPerInfo)
				end
			else
				GetTableXL(nGrid,value.Type,value.Value,value.Add_Value,key,tableXLPerInfo)
			end
			
			
		end
	
	end
	return tableXLPerInfo
end

function CheckUIType(nGrid,fCallBack)
	local l_valued_list = server_equipDB.GetListVauledByGird(nGrid)
	for key,value in pairs (l_valued_list) do 
		if value[1]~=nil then
			if tonumber(value[1]) ~=0 then
				--只要有一个值不为0说明点击了洗炼但是值没有替换
				if fCallBack~=nil then
					fCallBack(false,l_valued_list)
					return 
				end				
			end
		end
	end
	--print("=============l_valued_list=============")
	--printTab(l_valued_list)
	if fCallBack~=nil then
		fCallBack(true,l_valued_list)
		return 
	end 
end
function GetXLConsumeID(nXLType)
	print("GetXLConsumeID")
	print(nXLType)
	if tonumber(nXLType) ==0 then
		nXLType = 1
	end
	return xilian.getFieldByIdAndIndex(tonumber(nXLType),"XiL_ConsumeID")
end
function CheckBFirstChoose()
	if CCUserDefault:sharedUserDefault():getIntegerForKey("n_xl_time") == 0 or
		CCUserDefault:sharedUserDefault():getIntegerForKey("n_xl_type")== 0  then
		return true
	end
	return false
end
function GetXLTimes()
	return CCUserDefault:sharedUserDefault():getIntegerForKey("n_xl_time")
end
function GetXLPlan(nType)
	if nType == 1 then
		return "初级洗炼"
	end
	if nType == 2 then
		return "中级洗炼"
	end
	if nType == 3 then
		return "高级洗炼"
	end
	return ""
end
function CheckBTimes(nGrid,xlID)
	for key,value in pairs(GetExpendXLNum(nGrid,xlID)) do 
		if (tonumber(value.needNum)*GetXLTimes())> tonumber(value.ownNum) then
			return false
		end
	end
	return true
end
function GetPlanType()
	return tonumber(CCUserDefault:sharedUserDefault():getIntegerForKey("n_xl_type"))
	
end
local function CheckBAllLimit(nGrid)
	local l_xl_table = server_equipDB.GetStrengthenByGrid(nGrid)
	local tableLimit = {}
	local count = 0
	for key ,value in pairs(l_xl_table) do
		if value.Type~=nil then
			local strID = ""
			if key>2 then
				strID = "XiLAttitude_"..(key-2)
			else
				strID = "BaseAttitude_"..key
			end
			local limitValue = GetLimitValue(nGrid,strID)
			count = count+1
			if tonumber(value.Add_Value)>=tonumber(limitValue) then
				tableLimit[count] = true
			else
				tableLimit[count] = false
			end
		end
	end
	for key,value in pairs(tableLimit) do 
		if value == false then
			return false
		end
	end
	return true
end
local function CheckBXL(nGrid)
	
	if CheckBTimes(nGrid,GetXLConsumeID(GetPlanType())) == false then
		TipLayer.createTimeLayer("消耗物品不足", 2)
		return false
	end
	if tonumber(GetCurLvByGird(nGrid))<1 then
		TipLayer.createTimeLayer("主公，没强化过的装备不可以洗练哦！", 2) 
        return false
	end
	--如果都达到了极限那么也不能洗炼
	if CheckBAllLimit(nGrid) == true then
		TipLayer.createTimeLayer("洗炼属性已达到最大", 2)
		return false
	end
	return true
end
function CheckFirstXL()
	
	local cur_day = CCUserDefault:sharedUserDefault():getIntegerForKey ("day_now")
	local click = CCUserDefault:sharedUserDefault():getIntegerForKey ("confirm")
	if tonumber(cur_day) ~= UnitTime.GetCurDay() then
		CCUserDefault:sharedUserDefault():setIntegerForKey("day_now",UnitTime.GetCurDay())
		return true
	elseif tonumber(cur_day) == UnitTime.GetCurDay() then
		if click == 0 then
			return true
		end
	end
	return false
end
function ToXiLian(nGrid,fCallBack,fSucessCallBack)
	
	if CheckBXL(nGrid)== false then
		if fSucessCallBack~=nil then
			fSucessCallBack(false)
		end
		return 
		
	end
	
	local function XiLianOver(list)
		-- 更新
		if fSucessCallBack~=nil then
			fSucessCallBack(true)
		end
		NetWorkLoadingLayer.loadingHideNow()
		fCallBack(list)
	end
	
	Packet_EquipXiLian.SetSuccessCallBack(XiLianOver)
	network.NetWorkEvent(Packet_EquipXiLian.CreatPacket(nGrid, GetPlanType(), GetXLTimes()))
	NetWorkLoadingLayer.loadingShow(true)
end
function GetAfterXLInfo(nGrid,listXL)
	local tableOld = GetDataByXLInfo(nGrid)
	local tableAddValue = {}
	for key,value in pairs(listXL) do 
		if value[1]~=nil then
			local tableN ={}
			tableN[1] = value[1]
			table.insert(tableAddValue,tableN)
		end
	end
	for key,value in pairs(tableAddValue) do 
		tableOld[key].AddXLValue = value[1]
	end
	
	return tableOld
end
function ToReplace(nGrid,fCallBack)
	local function XiLianResultOver()
		NetWorkLoadingLayer.loadingHideNow()
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_EquipXiLianResult.SetSuccessCallBack(XiLianResultOver)
	network.NetWorkEvent(Packet_EquipXiLianResult.CreatPacket(nGrid, 1))
	NetWorkLoadingLayer.loadingShow(true)
end
function ToCancelXL(nGrid,fCallBack)
	local function Cancel()
		NetWorkLoadingLayer.loadingHideNow()		
		if fCallBack~=nil then	
			fCallBack()
		end
	end
	Packet_EquipXiLianResult.SetSuccessCallBack(Cancel)
	network.NetWorkEvent(Packet_EquipXiLianResult.CreatPacket(nGrid, 0))
	NetWorkLoadingLayer.loadingShow(true)
end

function CheckVIP(pParent_mid,pParent_high)
	local tabVIP_mid = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_8)
	local tabVIP_high= MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_9)
	--printTab(tabVIP_mid)
	--Pause()
	if tonumber(tabVIP_mid.vipLimit) == 0 then
		--中级洗炼没开启
		--Pause()
		AddVIPImage(pParent_mid,tabVIP_mid.vipLevel,ccp(-pParent_mid:getContentSize().width-90,pParent_mid:getContentSize().height/2-19))
	end
	if tonumber(tabVIP_high.vipLimit) == 0 then
		--高级洗炼没开启
		AddVIPImage(pParent_high,tabVIP_high.vipLevel,ccp(-pParent_mid:getContentSize().width-90,pParent_mid:getContentSize().height/2-19))
	end
end