require "Script/serverDB/legioicon"
require "Script/serverDB/resimg"
require "Script/serverDB/globedefine"
require "Script/serverDB/consume"
require "Script/serverDB/technolog"
require "Script/serverDB/server_CorpsScienceUpDate"
require "Script/serverDB/effect"
require "Script/serverDB/pointreward"
require "Script/serverDB/coin"
module("CorpsMessHallData",package.seeall)
require "Script/Common/RewardLogic"

function GetRewardConsumID( nEFFID ,num)
	local tab1 = effect.getDataById(nEFFID) -- 获取该科技的效果信息
	local tab2 = technolog.getDataById(tab1[num])
	local tab3 = effect.getDataById(tab2[10])
	local tab_reward = RewardLogic.GetRewardTable(tab3[2])
	if tonumber(tab3[3]) <= 0 then
		return tab_reward,0
	end
	local n_consumDB = ConsumeLogic.GetExpendData(tonumber(tab3[3]))
	
	return tab_reward,n_consumDB
end

function GetRewardData( ... )
	-- body
end

function GetCreateCorpsConsumName( nType )
	local n_name = nil
	if tonumber(nType) < 20 then
		n_name = coin.getFieldByIdAndIndex(nType,"Name")
	else
		n_name = item.getFieldByIdAndIndex(nType,"name")
	end
	return n_name
end

function GetBuyNumHall(  )
	return server_CorpsHall.GetCopyTable()
end