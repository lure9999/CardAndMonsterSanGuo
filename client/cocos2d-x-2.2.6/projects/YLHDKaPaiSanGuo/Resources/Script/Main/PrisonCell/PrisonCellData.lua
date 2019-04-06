require "Script/serverDB/item"
require "Script/serverDB/coin"
require "Script/serverDB/globedefine"
require "Script/serverDB/pointreward"
require "Script/serverDB/techeffect"
require "Script/serverDB/technolog"
require "Script/serverDB/prison"
require "Script/serverDB/consume"
require "Script/serverDB/orderrew"
require "Script/serverDB/resimg"
require "Script/serverDB/server_GetPrisonGridInfo"
require "Script/serverDB/server_GetPrisonItemInfo"
require "Script/serverDB/server_GetPrisonBoxInfo"
require "Script/serverDB/server_UsePrisonItem"
require "Script/serverDB/server_GetPrisonBRDB"
require "Script/serverDB/server_CatchListDB"
module("PrisonCellData",package.seeall)

--获取牢房格子的信息服务器
function GetPrisonGridByServer(  )
	return server_GetPrisonGridInfo.GetCopyTable()
end

function GetTotalPrisonNum(  )
	return server_GetPrisonGridInfo.GetTotalNum()
end

function GetCatchListDB(  )
	return server_CatchListDB.GetCopyTable()
end

--得到宝箱的数量
function GetBoxNum(  )
	return server_GetPrisonBoxInfo.GetBoxNum()
	-- return 1
end
--得到奖励的进度条
function GetBarLength(  )
	return server_GetPrisonBoxInfo.GetBarLength()
end

--获得加成道具的信息
function GetItemInfoByServer(  )
	return server_GetPrisonItemInfo.GetCopyTable()
end
--使用加成道具后返回的信息
function GetUseItemInfo(  )
	return server_UsePrisonItem.GetCopyTable()
end

function GetBoxData(  )
	return server_GetPrisonBRDB.GetCopyTable()
end

--通过 全局定义表获取对应的数据
function GetCellDataByGlobe(  )
	local tab = globedefine.getDataById("Prison")
	return tab[1]
end

--得到科技相关的牢房信息
function GetTPrisonInfo(  )
	local tabTech = {}
	for i=1,5 do
		local tab = prison.getDataById(i)
		local arrayTab = {}
		arrayTab["OpenType"] 		= tab[1]
		arrayTab["ConditionPara"] 	= tab[2]
		arrayTab["RewardCondition"] = tab[3]
		arrayTab["RewardID"] 		= tab[4]
		arrayTab["OPenDesc"] 		= tab[5]
		arrayTab["PrisonBG"] 		= tab[6]
		table.insert(tabTech,arrayTab)
	end
	return tabTech
end
--得到金币相关的牢房信息
function GetGPrisonInfo(  )
	local tabGods = {}
	for i=6,10 do
		local tab = prison.getDataById(i)
		local arrayTab = {}
		arrayTab["OpenType"] 		= tab[1]
		arrayTab["ConditionPara"] 	= tab[2]
		arrayTab["RewardCondition"] = tab[3]
		arrayTab["RewardID"] 		= tab[4]
		arrayTab["OPenDesc"] 		= tab[5]
		arrayTab["PrisonBG"] 		= tab[6]
		table.insert(tabGods,arrayTab)
	end
	return tabGods
end

function GetRewardPrisonByID( nIndex )
	local tabP = {}
	local tabCoins = {}
	local tabItems = {}
	local tab = prison.getDataById(nIndex)
	tabP["OpenType"] 		= tab[1]
	tabP["ConditionPara"] 	= tab[2]
	tabP["RewardCondition"] = tab[3]
	tabP["RewardID"] 		= tab[4] -- 奖励ID
	tabP["PrisonName"] 		= tab[5]
	tabP["OPenDesc"] 		= tab[6]
	tabP["PrisonBG"] 		= tab[7]
	local tabReward = RewardLogic.GetRewardTable(tab[4])
	local tabIconBg = tabReward[1]
	local tabItemBg = tabReward[2]

	if #tabIconBg ~= 0 and #tabItemBg == 0 then
		local tabChild = {}
		for key,value in pairs(tabIconBg) do
			tabChild[1] = value["CoinID"]
			tabChild[2] = value["CoinNum"]
			table.insert(tabCoins,tabChild)
		end
	elseif #tabIconBg == 0 and #tabItemBg ~= 0 then
		local tabChild = {}
		for key,value in pairs(tabItemBg) do
			tabChild[1] = value["ItemID"]
			tabChild[2] = value["ItemNum"]
			table.insert(tabItems,tabChild)
		end
	elseif #tabIconBg ~= 0 and #tabItemBg ~= 0 then
		for key,value in pairs(tabIconBg) do
			local tabChild = {}
			tabChild[1] = value["CoinID"]
			tabChild[2] = value["CoinNum"]
			table.insert(tabCoins,tabChild)
		end
		for key,value in pairs(tabItemBg) do
			local tabChild = {}
			tabChild[1] = value["ItemID"]
			tabChild[2] = value["ItemNum"]
			table.insert(tabItems,tabChild)
		end
	end

	return tabCoins,tabItems
end

--得到奖励的信息
function GetRewardInfo( nIndex )
	local tabP = {}
	local tab = prison.getDataById(nIndex)
	tabP["OpenType"] 		= tab[1]
	tabP["ConditionPara"] 	= tab[2]
	tabP["RewardCondition"] = tab[3]
	tabP["RewardID"] 		= tab[4]
	tabP["PrisonName"] 		= tab[5]
	tabP["OPenDesc"] 		= tab[6]
	tabP["PrisonBG"] 		= tab[7]
	
	local tabPointReward = RewardLogic.GetRewardTable(tabP["RewardID"])

	if next(tabPointReward[1]) ~= nil then
		return tabPointReward[1][1]["CoinPath"],tabPointReward[1][1]["CoinNum"],1,tabPointReward[1][1]["CoinID"]
	else
		return tabPointReward[2][1]["ItemPath"],tabPointReward[2][1]["ItemNum"],0.5,tabPointReward[2][1]["ItemID"]
	end 
end

function GetScaleNum( nCoinID )
	if tonumber(nCoinID) == 1 then
		return 0.4
	elseif tonumber(nCoinID) == 2 then
		return 0.4
	elseif tonumber(nCoinID) == 3 then
		return 0.4
	elseif tonumber(nCoinID) == 4 then
		return 0.4
	elseif tonumber(nCoinID) == 5 then
		return 0.7
	elseif tonumber(nCoinID) == 6 then
		return 0.7
	elseif tonumber(nCoinID) == 7 then
		return 0.4
	elseif tonumber(nCoinID) == 8 then
		return 0.5
	elseif tonumber(nCoinID) == 9 then
		return 0.5
	elseif tonumber(nCoinID) == 10 then
		return 0.3
	elseif tonumber(nCoinID) == 11 then
		return 0.5
	elseif tonumber(nCoinID) == 12 then
		return 0.5
	elseif tonumber(nCoinID) == 13 then
		return 0.3
	elseif tonumber(nCoinID) == 14 then
		return 0.5
	elseif tonumber(nCoinID) == 15 then
		return 0.5
	elseif tonumber(nCoinID) == 16 then
		return 0.5
	elseif tonumber(nCoinID) == 17 then
		return 0.5
	end
end

--得到宝箱奖励ID
function GetBoxReward(  )
	local tab = globedefine.getDataById("PrisonBox")
	local tabReward = pointreward.getDataById(tab[1])
	if tonumber(tabReward[3]) == 0 and tonumber(tabReward[11]) == 0 then
		return tabReward[1],tabReward[2]
	elseif tonumber(tabReward[3]) ~= 0 and tonumber(tabReward[11]) == 0 then
		return tabReward[1],tabReward[2],tabReward[3],tabReward[4]
	elseif tonumber(tabReward[3]) == 0 and tonumber(tabReward[11]) ~= 0 then
		return tabReward[1],tabReward[2],nil,nil,tabReward[11],tabReward[12]
	elseif tonumber(tabReward[3]) ~= 0 and tonumber(tabReward[11]) ~= 0 then
		return tabReward[1],tabReward[2],tabReward[3],tabReward[4],tabReward[11],tabReward[12]
	end
end

--获得解锁牢房消耗的
function GetPrisonConsum( nIndex )
	if tonumber(nIndex) ~= 0 then
		local tabPrison = prison.getDataById(nIndex)
		local tab = consume.getDataById(tabPrison[2])
		if tab == nil then
			return
		end
		local tabConsume = {}
		tabConsume["IncrementalLimit"] 	= tab[1]
		tabConsume["Consume_Type_1"] 	= tab[2]
		tabConsume["Type_1_para_A"] 	= tab[3]
		tabConsume["Type_1_para_B"] 	= tab[4]
		tabConsume["Consume_Type_2"] 	= tab[5]
		tabConsume["Type_2_para_A"] 	= tab[6]
		tabConsume["Type_2_para_B"] 	= tab[7]
		tabConsume["Consume_Type_3"] 	= tab[8]
		tabConsume["Type_3_para_A"] 	= tab[9]
		tabConsume["Type_3_para_B"] 	= tab[10]
		tabConsume["Consume_Type_4"] 	= tab[11]
		tabConsume["Type_4_para_A"] 	= tab[12]
		tabConsume["Type_4_para_B"] 	= tab[13]
		tabConsume["Consume_Type_5"] 	= tab[14]
		tabConsume["Type_5_para_A"] 	= tab[15]
		tabConsume["Type_5_para_B"] 	= tab[16]
		local name = coin.getFieldByIdAndIndex(tabConsume["Consume_Type_1"],"Name")
		return name,tabConsume["Type_1_para_A"]
	end
end

--得到牢房使用道具的信息
function GetPropInfo(  )
	local tab = globedefine.getDataById("Prison")
	local img_tian,img_wu = tab[4],tab[5]
	local tabTian = item.getDataById(tab[4])
	local tabWu = item.getDataById(tab[5])
	return img_tian,img_wu,tabTian,tabWu
end

--使用道具后的信息
function GetUseItemInfos(  )
	local tab = globedefine.getDataById("PrisonDouble")
	return tab[1],tab[2] -- 第一个参数时使用一个道具增加的次数 第二个参数是每消耗一次增加抓捕的额外增加次数
end

function GetPrisonItemPath( nIndex )
	return resimg.getFieldByIdAndIndex(nIndex,"icon_path")
end

function GetCoinPath( nIndex )
	--这需要判断没有 修改 ？？？？？？？？？？？
	if nIndex == -1 then
		nIndex = 1
	end
	local m_resID = coin.getFieldByIdAndIndex(nIndex,"ResID")
	return GetPrisonItemPath(m_resID)
end

