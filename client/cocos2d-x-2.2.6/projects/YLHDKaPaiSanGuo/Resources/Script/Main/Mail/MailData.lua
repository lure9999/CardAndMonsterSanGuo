
require "Script/serverDB/server_mailDB"
require "Script/serverDB/server_mailInfoDB"
require "Script/serverDB/server_mailDeleteDB"
require "Script/serverDB/resimg"
require "Script/serverDB/coin"
require "Script/serverDB/item"
module("MailData", package.seeall)

function GetMailInfo()
	--return server_mailDB.SetTableBuffer()
end

function GetSingerMailInfo( nMailId , nData )
	return nData[nMailId]
end

function GetSingerMailInfo_ChildMess( nMailId , nMailChild, nData)
	local SingerData = GetSingerMailInfo(nMailId, nData)
	return SingerData[nMailChild]
end

function GetSingerMainRewardInfo(nMailData)
	local RewardItemData = nMailData["RewardItem"]
	local RewardCoinData = nMailData["RewardCoin"]
	local rewardData = {}
	rewardData["coin"] = RewardCoinData
	rewardData["item"] = RewardItemData
	return rewardData
end

function GetItemHeadIcon( nType )
	return resimg.getFieldByIdAndIndex(nType,"icon_path")
end

local function GetCoinTypeIconID( nType )
	if nType > 0 then return tonumber(coin.getFieldByIdAndIndex(nType,"ResID")) end
end

function GetCoinTypeIconPath( nType )
	if GetCoinTypeIconID(nType) > 0 then 
		return resimg.getFieldByIdAndIndex(GetCoinTypeIconID(nType),"icon_path")		
	end
end

function GetItemPinZhi( nIndex )
	return item.getFieldByIdAndIndex(nIndex,"pinzhi")
end

function GetMailData()
	return server_mailDB.GetCopyTable()
end

function GetMainDataChild()
	return server_mailInfoDB.GetCopyTable()
end

function GetDelID()
	return server_mailDeleteDB.GetDelID()
end

function judgeMailBoxStatus()
	return server_mailDB.JudgeUnReadMail()
end