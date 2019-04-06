--FileName:CorpsPersentData
--Author:xuechao
--Purpose:军团捐献数据

require "Script/serverDB/legioicon"
require "Script/serverDB/resimg"
require "Script/serverDB/globedefine"
require "Script/serverDB/consume"
require "Script/serverDB/technolog"
require "Script/serverDB/techeffect"
require "Script/serverDB/server_CorpsScienceUpDate"
require "Script/serverDB/effect"
require "Script/serverDB/pointreward"
require "Script/serverDB/coin"
module("CorpsPersentData",package.seeall)
require "Script/Common/RewardLogic"
--消耗物品初级
function GetSciencePriData( nTempID ,num)
	local tableData = effect.getDataById(nTempID)--通过ID获取食堂效果信息
	local priTab = tableData[num]--获取初级食堂的id
	local tableData1 = technolog.getDataById(priTab)--获取初级食堂效果ID对应的信息
	local tableData2 = effect.getDataById(tableData1[10])
	local tableData3 = pointreward.getDataById(tableData2[2])
	return tableData3[1], tableData3[2],tableData3[3],tableData3[4]
end


--获取图标信息
function GetRewardIconPath( nTempID )
	local tableDataImg = coin.getDataById(nTempID)
	local imgPath = resimg.getFieldByIdAndIndex(tableDataImg[2],"icon_path")
	local name = tableDataImg[1]
	return imgPath,name
end

--获取消耗类型信息
function GetMessConsumePrimaryInfo( nTempID ,num)
	local tableData = effect.getDataById(nTempID)--通过ID获取食堂效果信息
	local priTab = tableData[num]--获取中级食堂的id
	local tableData1 = technolog.getDataById(priTab)
	local tableData2 = effect.getDataById(tableData1[10])
	local tab_reward = RewardLogic.GetRewardTable(tableData2[2])
	
	if tonumber( tableData2[3]) ==0 then
		return tab_reward[1][1],tab_reward[1][2], 0
	end
	
	local n_consumDB = ConsumeLogic.GetExpendData(tonumber(tableData2[3]))
	return tab_reward[1][1],tab_reward[1][2],n_consumDB.TabData[1]
end

function GetRewardName( nType )
	return coin.getFieldByIdAndIndex(nType,"Name")
end

function GetDonateNum(  )
	local tab = globedefine.getDataById("Legio_JuanXian")
	return tonumber(tab[4])
end

function GetBuyNumDonate(  )
	return server_CorpsDonate.GetCopyTable()
end


