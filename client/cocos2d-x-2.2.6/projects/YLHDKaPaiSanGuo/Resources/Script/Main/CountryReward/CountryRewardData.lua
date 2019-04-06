require "Script/serverDB/server_RewardDB"
require "Script/serverDB/server_RewardGetDB"
require "Script/serverDB/coin"
require "Script/serverDB/item"
require "Script/serverDB/wargrid"
module("CountryRewardData",package.seeall)

--获取奖励列表
function GetRewardDataByServer(  )
	return server_RewardDB.GetCopyTable()
end

function GetRewardInfoByID( nTempID )
	local tab = {}
	local RewardName = nil
	if tonumber(nTempID) < 200 then
		tab = coin.getDataById(nTempID)
		RewardName = tab[1]
	else
		tab = item.getDataById(nTempID)
		RewardName = tab[2]
	end
	return tab,RewardName
end

--如果是货币类型,则通过货币表获取该货币的名字
function GetMoneyName( id )
	local tab = coin.getDataById(id)
	return tab[1],tab[2]
end

--如果不是货币类型则需要通过ID走item表获取信息
function GetDataByID( id )
	-- local coinID = 
	local CoinName = nil
	local is_coin = wargrid.getFieldByIdAndIndex(id, "CionID")
	local coinID = nil
	if tonumber(is_coin) == 0 then
		coinID = wargrid.getFieldByIdAndIndex(id, "CionPara")
		CoinName = item.getFieldByIdAndIndex(coinID, "name")
	else
		coinID = is_coin
		CoinName = coin.getFieldByIdAndIndex(is_coin, "Name")
	end
	return coinID,CoinName,is_coin
end