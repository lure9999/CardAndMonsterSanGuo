require "Script/serverDB/charge"
require "Script/serverDB/vip"
require "Script/serverDB/resimg"
require "Script/serverDB/pointreward"
require "Script/serverDB/item"
require "Script/serverDB/coin"
require "Script/serverDB/server_VIPRewardStatusDB"
module("ChargeVIPData",package.seeall)

--得到充值表中所有的数据
function GetChargeInfo(  )
	local tab = charge.getTable()
	local tabCharge = {}
	for key,value in pairs(tab) do
		tabCharge[key] = {}
		tabCharge[key]["Type"] = value[1]
		tabCharge[key]["Name"] = value[2]
		tabCharge[key]["ResImg"] = value[3]
		tabCharge[key]["Text"] = value[4]
		tabCharge[key]["AfterText"] = value[5]
		tabCharge[key]["Gold"] = value[6]
		tabCharge[key]["Price"] = value[7]
		tabCharge[key]["AddGold"] = value[8]
		tabCharge[key]["Tag"] = value[9]
		tabCharge[key]["FristCharge"] = value[10]
	end
	return tabCharge
end
--通过索引值得到充值表中的相对应的数据
function GetChargeInfoByIndex( nIndex )
	local tab = charge.getDataById(nIndex)
	local tabCharge = {}
	tabCharge["Type"] = tab[1]
	tabCharge["Name"] = tab[2]
	tabCharge["ResImg"] = tab[3]
	tabCharge["Text"] = tab[4]
	tabCharge["AfterText"] = tab[5]
	tabCharge["Gold"] = tab[6]
	tabCharge["Price"] = tab[7]
	tabCharge["AddGold"] = tab[8]
	tabCharge["Tag"] = tab[9]
	tabCharge["FristCharge"] = tab[10]
	return tabCharge
end

--得到VIP所有的数据
function GetVIPAllData(  )
	local tab = vip.getTable()
	local tabVIP = {}
	for key,value in pairs(tab) do
		tabVIP[key] = {}
		tabVIP[key]["VipExp"] = value[1]
		tabVIP[key]["VipRew"] = value[2]
		tabVIP[key]["VipText"] = value[3]
	end
	return tabVIP
end

--通过索引ID获取相对应的数据
function GetVIPDataByIndex( nIndex )
	if tonumber(nIndex) >13 then
		nIndex = 13
	end
	local tab = vip.getDataById(nIndex)
	local tabVIP = {}
	tabVIP["VipExp"] = tab[1]
	tabVIP["VipRew"] = tab[2]
	tabVIP["VipText"] = tab[3]
	return tabVIP
end

function GetVIPRewardInfoByVIP( nVIP )
	local VIPTab = GetVIPDataByIndex(nVIP)
	local tabR = {}
	local tabReward = {}
	-- local tab = RewardLogic.GetRewardTable(tonumber(VIPTab["VipRew"]))\
	--奖励信息
	tabReward = RewardLogic.GetRewardTable(tonumber(VIPTab["VipRew"]))
	return tabReward
end

function GetVIPItemIndex( nVIP )
	local VIPTab = GetVIPDataByIndex(nVIP)
	local tabItem = {}
	for i=1,10 do
		local itemID = pointreward.getFieldByIdAndIndex(VIPTab["VipRew"],"ItemID_"..i)
		if tonumber(itemID) > 0 then
			table.insert(tabItem,itemID)
		end
	end
	return tabItem
end

function GetVIPCoinIndex( nVIP )
	local VIPTab = GetVIPDataByIndex(nVIP)
	local tabCoin = {}
	for i=1,5 do
		local coinID = pointreward.getFieldByIdAndIndex(VIPTab["VipRew"],"CionID_"..i)
		if tonumber(coinID) > 0 then
			table.insert(tabCoin,coinID)
		end
	end
	return tabCoin
end

function GetCoinByID( nIndex )
	local tab = GetChargeInfoByIndex(nIndex)
	local coinID = tab["ResImg"]
	return resimg.getFieldByIdAndIndex(coinID,"icon_path")
end

function GetPathByID( nIndex )
	return resimg.getFieldByIdAndIndex(nIndex,"icon_path")
end

function GetReChargeData(  )
	local tab = GetChargeInfo()
	local tabchargeinfo = {}
	for i=1,6 do
		local arrayData = GetChargeInfoByIndex(i)
		table.insert(tabchargeinfo,arrayData)
	end
	return tabchargeinfo
end

function GetRewardByServer(  )
	return server_VIPRewardStatusDB.GetCopyTable()
end

--得到奖励的状态值
function GetRewardStatus( nVIP )
	local tabReward = {}
	local VIPStatus = nil
	tabReward = GetRewardByServer()
	for key,value in pairs(tabReward) do
		if nVIP == key then
			return value
		end
	end
end

function GetLabelText( pControl,num )
	local label_ReNum = Label:create()
	label_ReNum:setTextAreaSize(CCSize(50,30))
	label_ReNum:setFontSize(22)
	label_ReNum:setAnchorPoint(ccp(0,0))
	label_ReNum:setTextHorizontalAlignment(1)
	label_ReNum:setText("X"..num)
	label_ReNum:setPosition(ccp(-50,-55))
	pControl:addChild(label_ReNum)
end

function GetFirstChargeStatus(  )
	local tabVIP = {}
	local v_data = server_mainDB.getMainData("firstCharge")
	local nArray = CCArray:create()
	IntTrans(tonumber(v_data), 1, 1, nArray)
	local nCount = nArray:count()
	for i=0,nCount-1 do
		local n_object = tolua.cast(nArray:objectAtIndex(i),"CCInteger")
		local n_objectNum = n_object:getValue()
		table.insert(tabVIP,n_objectNum)
	end
	return tabVIP
end